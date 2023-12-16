-- 貪吃蛇遊戲：基本設置
function love.load()
    cellSize = 20
    snake = { {x = 3, y = 1}, {x = 2, y = 1}, {x = 1, y = 1} }
    direction = 'right'
    timer = 0
    delay = 0.15
    food = { x = math.random(1, love.graphics.getWidth() / cellSize), y = math.random(1, love.graphics.getHeight() / cellSize) }
    score = 0
    -- 新增顏色設置
    snakeColor = {0, 255, 0}
    foodColor = {255, 0, 0}
    backgroundColor = {20, 20, 20}
    gameState = 'running'
end

-- 更新遊戲狀態
function love.update(dt)
    if gameState == 'running' then
        timer = timer + dt
        if timer >= delay then
            timer = 0
            moveSnake()
        end
    end
end

-- 繪製遊戲
function love.draw()
    if gameState == 'running' then
        for _, segment in ipairs(snake) do
            love.graphics.rectangle('fill', (segment.x - 1) * cellSize, (segment.y - 1) * cellSize, cellSize, cellSize)
        end

        love.graphics.rectangle('fill', (food.x - 1) * cellSize, (food.y - 1) * cellSize, cellSize, cellSize)

        love.graphics.print("Score: " .. score, 5, 5)
    elseif gameState == 'gameover' then
        love.graphics.print("Game Over. Score: " .. score, 5, 5)
    end
end

-- 鍵盤控制
function love.keypressed(key)
    if key == 'right' and direction ~= 'left' then
        direction = 'right'
    elseif key == 'left' and direction ~= 'right' then
        direction = 'left'
    elseif key == 'up' and direction ~= 'down' then
        direction = 'up'
    elseif key == 'down' and direction ~= 'up' then
        direction = 'down'
    end
end

-- 移動蛇
function moveSnake()
    local head = { x = snake[1].x, y = snake[1].y }
    if direction == 'right' then
        head.x = head.x + 1
    elseif direction == 'left' then
        head.x = head.x - 1
    elseif direction == 'up' then
        head.y = head.y - 1
    elseif direction == 'down' then
        head.y = head.y + 1
    end

    if checkCollision(head) then
        gameState = 'gameover'
    else
        table.insert(snake, 1, head)

        if head.x == food.x and head.y == food.y then
            score = score + 1
            generateFood()
        else
            table.remove(snake)
        end
    end
end

-- 檢查碰撞
function checkCollision(head)
    for i, segment in ipairs(snake) do
        if i ~= 1 and head.x == segment.x and head.y == segment.y then
            return true
        end
    end
    return head.x < 1 or head.x > love.graphics.getWidth() / cellSize or
           head.y < 1 or head.y > love.graphics.getHeight() / cellSize
end

-- 生成食物
function generateFood()
    local possibleFoodPositions = {}
    for x = 1, love.graphics.getWidth() / cellSize do
        for y = 1, love.graphics.getHeight() / cellSize do
            local canPlace = true
            for _, segment in ipairs(snake) do
                if segment.x == x and segment.y == y then
                    canPlace = false
                    break
                end
            end
            if canPlace then
                table.insert(possibleFoodPositions, {x = x, y = y})
            end
        end
    end
    food = possibleFoodPositions[math.random(#possibleFoodPositions)]
end
