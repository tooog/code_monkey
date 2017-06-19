package.path = 'numberlua.lua;' .. package.path
local bit = require 'bit'
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
IS={}
R={}
M={}
PC=1
function RUN()
	if M["M0"] ~= 0 then
		io.write("UP  \t")
		print(M["M0"])
		move_action = "up"
		step = M["M0"]
		lastposition = monkey_y - (step * 50);
	end
	if M["M1"] ~= 0 then
		io.write("DOWN\t")
		print(M["M1"])
		move_action = "down"
		step = M["M1"]
		lastposition = (step * 50) + monkey_y;
	end
	if M["M2"] ~= 0 then
		io.write("LEFT\t")
		print(M["M2"])
		move_action = "left"
		step = M["M2"]
		lastposition = monkey_x - (step * 50);
	end
	if M["M3"] ~= 0 then
		io.write("RIGHT\t")
		print(M["M3"])
		move_action = "right"
		step = M["M3"]
		lastposition = (step * 50) + monkey_x;	
	end	
	
	return
end

function IS.SR(A,B,C)
    local bhex = bit.band(0x0000FFFF , R[A])
    local hex = bit.tohex(bhex , 4)
    return hex
end
function IS.SM(A,B,C)
    local bhex = bit.band(0x0000FFFF , M[A])
    local hex = bit.tohex(bhex , 4)
    return hex
end
--"HALT","LOAD","STORE","ADD","MOVE","NOT","AND","OR","XOR","INC","DEC","ROTATE","JUMP"

function IS.LOAD(A,B,C)
    io.write("LOAD\t")
    print(A,B,C)
    if C ~= nil then  
        print("arg error C") 
        return
    end
    if M[B] == nil then 
        print("arg error B")
        return
    end
    if R[A] == nil then 
        print("arg error A") 
        return
    end
    R[A]=M[B]
	PC=PC+1
end
function IS.STORE(A,B,C)
    io.write("STORE\t")
    print(A,B,C)
    if C ~= nil then  
        print("arg error C") 
        return
    end
    if M[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    M[A]=R[B]
	PC=PC+1
	RUN()
end
function IS.ADD(A,B,C)
    io.write("ADD\t")
    print(A,B,C)
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    if R[C] == nil then 
        print("arg error C") 
        return
    end
    R[A]=R[B]+R[C]
	PC=PC+1
end
function IS.MOVE(A,B,C)
    io.write("MOVE\t")
    print(A,B,C)
    if C ~= nil then  
        print("arg error C ") 
        return
    end
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    R[A]=R[B]
	PC=PC+1
end
function IS.NOT(A,B,C)
    io.write("NOT\t")
    print(A,B,C)
    if C ~= nil then  
        print("arg error C") 
        return
    end
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    R[A]=bit.bnot(R[B])
	PC=PC+1
end
function IS.AND(A,B,C)
    io.write("AND\t")
    print(A,B,C)
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    if R[C] == nil then 
        print("arg error C") 
        return
    end
    R[A]=bit.band(R[B],R[C])
	PC=PC+1
end
function IS.OR(A,B,C)
    io.write("OR\t")
    print(A,B,C)
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    if R[C] == nil then 
        print("arg error C") 
        return
    end
    R[A]=bit.bor(R[B],R[C])
	PC=PC+1
end
function IS.XOR(A,B,C)
    io.write("XOR\t")
    print(A,B,C)
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    if R[C] == nil then 
        print("arg error C") 
        return
    end
    R[A]=bit.bxor(R[B],R[C])
	PC=PC+1
end
function IS.INC(A,B,C)
    io.write("INC\t")
    print(A,B,C)
    if C ~= nil then  
        print("arg error C") 
        return
    end
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    R[A]=bit.band(R[B] +1 , 0x0000FFFF)
	PC=PC+1
    --R[A] = 10
end
function IS.DEC(A,B,C)
    io.write("DEC\t")
    print(A,B,C)
    if C ~= nil then  
        print("arg error C") 
        return
    end
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    R[A]=bit.band(R[B] -1 , 0x0000FFFF)
    PC=PC+1
end
function IS.LS(A,B,C)
    io.write("DEC\t")
    print(A,B,C)
    if C == nil then  
        print("arg error C") 
        return
    end
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    R[A]=bit.band(bit.lshift(R[B],C) , 0x0000FFFF)
    PC=PC+1
end
function IS.RS(A,B,C)
    io.write("DEC\t")
    print(A,B,C)
    if C == nil then  
        print("arg error C") 
        return
    end
    if R[A] == nil then 
        print("arg error A")
        return
    end
    if R[B] == nil then 
        print("arg error B") 
        return
    end
    R[A]=bit.band(bit.rshift(R[B],C) , 0x0000FFFF)
    PC=PC+1
end
function IS.HALT(A,B,C)
	io.write("HALT\t")
	print(A,B,C)
	if C ~= nil then  
        print("arg error C") 
        return
    end
	if A ~= nil then  
        print("arg error A") 
        return
    end
	if B ~= nil then  
        print("arg error B") 
        return
    end
	return
end
function IS.JUMP(A,B,C)
	io.write("JUMP\t")
	print(A,B,C)
	if C ~= nil then  
        print("arg error C") 
        return
    end
	if R[A] == nil then 
        print("arg error A")
        return
    end    
	if B == nil then  
        print("arg error B") 
        return
    end
	if R[A] ~= 0 then
		PC = tonumber(B)
	else
		PC = PC+1
	end
	
	return
end
function IS.init()
    local i=0
    for i=0 ,8 do
        local hex = string.format("R%X",i)
        R[hex]=0;
    end
    for i=0 ,8 do
        local hex = string.format("M%X",i)
        M[hex]=0;
    end
end
function IS.EXE(STR_IN)
    local STR = split(STR_IN," ")
    if  IS[ STR[1] ] ~= nil then
        IS[ STR[1] ](STR[2],STR[3],STR[4])
    end
end


function love.load()
    	
    IS.init()
--圖片載入
	--LOAD
	main_bg = love.graphics.newImage("assets/main_bg.png")
	level_bg = love.graphics.newImage("assets/level_bg.png")
	test_bg = love.graphics.newImage("assets/test_bg.png")
	back_icon = love.graphics.newImage("assets/back_icon.png")
	button_icon = love.graphics.newImage("assets/button.png")
	sound_icon_play = love.graphics.newImage("assets/sound_play.png")
	sound_icon_stop = love.graphics.newImage("assets/sound_stop.png")
	monkey_icon = love.graphics.newImage("assets/monkey.jpg")
--音樂載入

	begin_mu = love.audio.newSource("assets/begin_mu.mp3") 
	game_mu = love.audio.newSource("assets/game_mu.mp3")


	--音量
	begin_mu:setVolume(0.5)
	game_mu:setVolume(0.7)

--字型載入
	title_font = love.graphics.newFont("assets/font.ttf",128)
	set_font = love.graphics.newFont("assets/font.ttf",64)
	fps_font = love.graphics.newFont("assets/font.ttf",20)
	
--宣告
	state = "loading"
	mousecheck = "false"
	keyboardcheck = "false"
	load_count = 1
	load_flag = "false"
	button_name={"1","2","3","4","5","6","7","8"}
	button_postion = {}
	button_set = 0
	keyboard_set = nil
	inform = {"INC R0 R0","LS R0 R0 2","INC R1 R1","STORE M3 R0","STORE M1 R0","STORE M2 R0","STORE M0 R1","","","","","","","","","","","","","","","","","","","","","","","","",""}
	inform_num_x = 0
	inform_num_y = 0

	tutorial_map={1,2,3,4,5,23,41,59,77,76,75,74,73,55}
	level1_map={1,2,3,4,5,23,41,59,77,78,79,80,81,63,45,27,9,10,11,12,13,31,49,67,85,86,87,88,89,71,53,35,17,18}
	level2_map={165,147,148,130,112,113,114,96,78,60,42,43,44,45,46,47,48,49,50,68,86,104,122,123,124,142,160,161,179}
	level3_map={}
	for i=1,180 do
		table.insert(level3_map, i)
	end

	map={tutorial_map,level1_map,level2_map,level3_map}
	reg_table={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

	move_action = nil
	step = 0
	lastposition = 0
	monkey_x=0
	monkey_y=0
	speed = 120
	auto_run_count = 0
	real_time = 0
	set_time = true
	odt = 0
	start_monkey_position = true

end

function love.update(dt)
	x = love.mouse.getX()
	y = love.mouse.getY()
	real_time = real_time + dt 
--滑鼠按鈕
	if state == "title" and mousecheck == "false" then
	--音效控制
		--播放
		if(x > 1100 and x <1150) then
			if(y >= 650 and y <= 700) then
				if love.mouse.isDown(1) then
					love.audio.play(begin_mu)
				end
			end			
		end
		--停止
		if(x > 1150 and x <1200) then
			if(y > 650 and y < 700) then
				if love.mouse.isDown(1) then
					love.audio.stop(begin_mu)
				end
			end			
		end
	--進入選單
		if(x > 512 and x <768) then
			if(y >= 436 and y <= 500) then
				if love.mouse.isDown(1) then
					state = "level"
					mousecheck = "true"
				end
			end			
		end
	--離開遊戲
		if(x > 512 and x < 768) then
			if(y >= 500 and y <= 574) then
				if love.mouse.isDown(1) then
					love.window.close( )
					love.audio.stop(begin_mu)
				end
			end			
		end
	-- --測試主畫面返回
	-- 	if(x > 100 and x <200) then
	-- 		if(y >= 100 and y <= 200) then
	-- 			if love.mouse.isDown(1) then
	-- 				state = "loading"
	-- 				load_count = 1
	-- 				load_flag = "false"
	-- 			end
	-- 		end			
	-- 	end
		
		
		
	end

if state == "tutorial" or state == "level_1" or state == "level_2" or state == "level_3" then
	if love.keyboard.isDown("escape") then
	state = "level"
	start_monkey_position = true
	love.audio.stop(game_mu)
	love.audio.play(begin_mu)
end
end



--鍵盤按鈕
if keyboardcheck == "false" then
	if love.keyboard.isDown("a") then
		keyboard_set = "A"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("b") then
		keyboard_set = "B"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("c") then
		keyboard_set = "C"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("d") then
		keyboard_set = "D"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("e") then
		keyboard_set = "E"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("f") then
		keyboard_set = "F"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("g") then
		keyboard_set = "G"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("h") then
		keyboard_set = "H"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("i") then
		keyboard_set = "I"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("j") then
		keyboard_set = "J"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("k") then
		keyboard_set = "K"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("l") then
		keyboard_set = "L"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("m") then
		keyboard_set = "M"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("n") then
		keyboard_set = "N"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("o") then
		keyboard_set = "O"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("p") then
		keyboard_set = "P"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("q") then
		keyboard_set = "Q"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("r") then
		keyboard_set = "R"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("s") then
		keyboard_set = "S"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("t") then
		keyboard_set = "T"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("u") then
		keyboard_set = "U"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("v") then
		keyboard_set = "V"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("w") then
		keyboard_set = "W"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("x") then
		keyboard_set = "X"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("y") then
		keyboard_set = "Y"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("z") then
		keyboard_set = "Z"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("(") then
	    keyboard_set = "("
	    keyboardcheck = "true"
	elseif love.keyboard.isDown(")") then
		keyboard_set = ")"
		keyboardcheck = "true"
	elseif love.keyboard.isDown('\"') then
		keyboard_set = "\""
		keyboardcheck = "true"
	elseif love.keyboard.isDown("space") then
		keyboard_set = " "
		keyboardcheck = "true"
	elseif love.keyboard.isDown("1") then
		keyboard_set = "1"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("2") then
		keyboard_set = "2"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("3") then
		keyboard_set = "3"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("4") then
		keyboard_set = "4"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("5") then
		keyboard_set = "5"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("6") then
		keyboard_set = "6"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("7") then
		keyboard_set = "7"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("8") then
		keyboard_set = "8"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("9") then
		keyboard_set = "9"
		keyboardcheck = "true"
	elseif love.keyboard.isDown("0") then
		keyboard_set = "0"
		keyboardcheck = "true"
	elseif keyboard_set then
		if inform_num_y < #inform then
			temp = string.sub(inform[inform_num_y+1],1,inform_num_x)
			temp1 = string.sub(inform[inform_num_y+1],inform_num_x+1)
			inform[inform_num_y+1] = temp..keyboard_set..temp1
		elseif inform_num_y >= #inform then
			inform[inform_num_y+1] = keyboard_set
		end
		inform_num_x = inform_num_x + 1
		keyboard_set = nil
	end
end
--game_ui
			if x > 575 and x < 675 then
				if y >= 625 and y <= 705 then
					if love.mouse.isDown(1) then
						button_set = "clear"
						mousecheck = "true"
						PC = 1
					IS.init()
					reg_table={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
					move_action = nil
					start_monkey_position = true
					end
				end			
			end 
	if (state == "tutorial" or state == "level_1" or state == "level_2" or state == "level_3")and mousecheck == "false" then
		if  move_action == nil then 
			if x > 400 and x < 500  then
				if y >= 625 and y <= 705 then
					if love.mouse.isDown(1) then
						button_set = "run"
						mousecheck = "true"
					end
				end			
			end 
		end






		if mousecheck == "true"  or button_set == "run" and move_action == nil then
            if button_set == "run" then
            	if set_time == true then
            		set_time = false
            		odt = real_time + 0.2
            	end
            	print("odt ="..tostring(odt))
            	while real_time >= odt and set_time == false do
            		set_time = true
            		print("wait_time")
            		print("odt ="..tostring(odt))
            		print("dt ="..tostring(real_time))
					print(PC)
					print(inform[PC])
					IS.EXE(inform[PC])
				
					for i=0,7 do
						local idx = "R" .. tostring(i)
						reg_table[i+1] = IS.SR(idx)
					end
					for i=0,7 do
						local idx = "M" .. tostring(i)
						reg_table[9+i] = IS.SM(idx)
					end
				end
        	end
			if not inform[25] then
				table.insert(inform,inform_num_x,button_name[button_set])
			end
		end


		if keyboardcheck == "false" then
			if love.keyboard.isDown("up") and inform_num_y > 0 then
				inform_num_y = inform_num_y - 1
				keyboardcheck = "true"
		
			elseif (love.keyboard.isDown("down") and inform_num_y < 24) or love.keyboard.isDown("return") then
				inform_num_y = inform_num_y + 1
				keyboardcheck = "true"
			elseif love.keyboard.isDown("left") and inform_num_x > 0 then
				inform_num_x = inform_num_x -1
				keyboardcheck = "true"
			elseif love.keyboard.isDown("right") then
				if inform_num_y < #inform then
					if inform_num_x < #inform[inform_num_y+1] then
					inform_num_x = inform_num_x +1
					keyboardcheck = "true"
					end
				end
			end

			if love.keyboard.isDown("backspace") and keyboardcheck == "false" and inform_num_x > 0 then
				keyboardcheck = "true"
				print("delet")
				if #inform[inform_num_y+1] > 0 then
					temp = string.sub(inform[inform_num_y+1],1,inform_num_x-1)
					temp1 = string.sub(inform[inform_num_y+1],inform_num_x+1)
					print(temp)
					print(temp1)
					inform[inform_num_y+1] = temp..temp1
					inform_num_x = inform_num_x - 1
				end 
			end

			--編輯器邊緣
			if  inform_num_y < #inform then
				if inform_num_x > #inform[inform_num_y+1] then
					inform_num_x = #inform[inform_num_y+1]
				end
			elseif inform_num_y >= #inform then
				inform_num_x = 0
			end
		end
	end
--人物位置
	if move_action ~= nil then
		if move_action == "up" then
			print("up")
			monkey_y = monkey_y - (speed * dt )
			if  monkey_y <= lastposition then
				move_action = nil
			end
		end
		if move_action == "down" then
			print("down")
			monkey_y = monkey_y + (speed * dt )
			if  monkey_y >= lastposition then
				move_action = nil
			end
		end
		if move_action == "left" then
			print("left")
			monkey_x = monkey_x - (speed * dt )
			if  monkey_x <= lastposition then
				move_action = nil
			end
		end
		if move_action == "right" then
			print("right")
			monkey_x = monkey_x + (speed * dt )
			if  monkey_x >= lastposition then
				move_action = nil
			end
		end
			
		if move_action == nil then
			print("clean everything")
			M["M0"] = 0
			M["M1"] = 0
			M["M2"] = 0
			M["M3"] = 0
			step = 0
			lastposition = 0
			if state =="tutorial" then
				if monkey_x >= -5 and monkey_x <= 50 then
					if monkey_y >=148 and monkey_y <= 200 then
						PC = 1
						IS.init()
						reg_table={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
						monkey_x = 0
						monkey_y = 0
						button_set = nil
						start_monkey_position = true
						state = "end"
					end
				end
			end
			if state == "level_1" then
				if monkey_x >= 845 and monkey_x <= 900 then
					if monkey_y >= -5 and monkey_y <= 50 then
						PC = 1
						IS.init()
						reg_table={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
						monkey_x = 0
						monkey_y = 0
						button_set = nil
						start_monkey_position = true
						state = "end"
					end
				end
			end
			if state == "level_2" then
				if monkey_x >= 800 and monkey_x <= 850 then
					if monkey_y >= 445 and monkey_y <= 500 then
						PC = 1
						IS.init()
						reg_table={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
						monkey_x = 100
						monkey_y = 450
						button_set = nil
						start_monkey_position = true
						state = "end"
					end
				end
			end
			if state == "level_3" then
			end
		end
	end
--主選單按鈕
	if state == "level" and mousecheck == "false" then
	--教學關卡
		if x > 512 and x < 768 then
			if y >= 180 and y <= 244 then
				if love.mouse.isDown(1) then
					state = "tutorial"
				end
			end			
		end
	--第一關
		if x > 512 and x < 768 then
			if y >= 260 and y <= 324 then
				if love.mouse.isDown(1) then
					state = "level_1"
					mousecheck = "true"
				end
			end			
		end
	--第二關
		if x > 512 and x < 768 then
			if y >= 340 and y <= 404 then
				if love.mouse.isDown(1) then
					state = "level_2"
					mousecheck = "true"
				end
			end			
		end
	--第三關
		if x > 512 and x < 768 then
			if y >= 420 and y <= 484 then
				if love.mouse.isDown(1) then
					--state = "level_3"
					mousecheck = "true"
				end
			end			
		end
	--返回主畫面
		if x > 576 and x < 704 then
			if y >= 500 and y <= 564 then
				if love.mouse.isDown(1) then
					state = "title"
					mousecheck = "true"
				end
			end			
		end
	end
	
	if state == "end" then
		if x > 450 and x < 850 then
			if y >= 400 and y <= 600 then
				if love.mouse.isDown(1) then
					state = "level"
					mousecheck = "true"
				end
			end			
		end	
	end

	
--滑鼠鍵盤鎖定
	if not love.mouse.isDown(1) then
		mousecheck = "false"
	end
	if not love.keyboard.isDown("up") and not love.keyboard.isDown("down") 
		and not love.keyboard.isDown("left") and not love.keyboard.isDown("right") 
		and not love.keyboard.isDown("backspace") and not love.keyboard.isDown("a")
		and not love.keyboard.isDown("b") and not love.keyboard.isDown("c")
		and not love.keyboard.isDown("d") and not love.keyboard.isDown("e")
		and not love.keyboard.isDown("f") and not love.keyboard.isDown("g")
		and not love.keyboard.isDown("h") and not love.keyboard.isDown("i")
		and not love.keyboard.isDown("j") and not love.keyboard.isDown("k")
		and not love.keyboard.isDown("l") and not love.keyboard.isDown("m")
		and not love.keyboard.isDown("n") and not love.keyboard.isDown("o")
		and not love.keyboard.isDown("p") and not love.keyboard.isDown("q")
		and not love.keyboard.isDown("r") and not love.keyboard.isDown("s")
		and not love.keyboard.isDown("t") and not love.keyboard.isDown("u")
		and not love.keyboard.isDown("v") and not love.keyboard.isDown("w")
		and not love.keyboard.isDown("x") and not love.keyboard.isDown("y")
		and not love.keyboard.isDown("z") and not love.keyboard.isDown("1")
		and not love.keyboard.isDown("2") and not love.keyboard.isDown("3")
		and not love.keyboard.isDown("4") and not love.keyboard.isDown("5")
		and not love.keyboard.isDown("6") and not love.keyboard.isDown("7")
		and not love.keyboard.isDown("8") and not love.keyboard.isDown("9")
		and not love.keyboard.isDown("space") and not love.keyboard.isDown("0")
		and not love.keyboard.isDown("return") then
	keyboardcheck = "false"
	end	
end


function love.draw()
	if state == "loading" then
		--love.graphics.print("load_count: "..tostring(load_count), 10, 300)
		love.graphics.setColor(255,255,255,load_count)
		love.graphics.setFont(title_font)
		love.graphics.printf("載入中...",0,200,1280,"center")
		if load_count < 255 and load_flag=="false" then
			load_count = load_count + 3
		end
		if load_count >= 255 or load_flag=="true" then
			load_flag = "true"
			load_count = load_count - 3
			if load_count <= 0 then
				state = "title"
				love.graphics.clear()
				love.audio.play(begin_mu)
			end
		end
	elseif state == "title" then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(main_bg,0,0)
		love.graphics.draw(sound_icon_play,1100,650)
		love.graphics.draw(sound_icon_stop,1150,650)
	--	love.graphics.draw(back_icon,100,100)
		love.graphics.setFont(title_font)
		love.graphics.printf("猴子大冒險",0,120,1280,"center")
		love.graphics.setFont(set_font)
		love.graphics.printf("開始遊戲",0,436,1280,"center")
		love.graphics.printf("離開遊戲",0,436+80,1280,"center")
		love.graphics.setFont(fps_font)
		love.graphics.printf("MUSIC", 1100, 620, 100, "center")
	elseif state == "level" then
		love.graphics.draw(level_bg,0,0)
		love.graphics.setFont(set_font)
		love.graphics.printf("教學關卡",0,180,1280,"center")
		love.graphics.printf("第一關",0,180+80,1280,"center")
		love.graphics.printf("第二關",0,180+80+80,1280,"center")
		love.graphics.printf("第三關",0,180+80+80+80,1280,"center")
		love.graphics.printf("返回",0,180+80+80+80+80,1280,"center")
	elseif state =="tutorial" then
		love.audio.stop(begin_mu)
		love.audio.play(game_mu)
		game_ui(1);
	elseif state =="level_1" then
		love.audio.stop(begin_mu)
		love.audio.play(game_mu)
		game_ui(2);
	elseif state =="level_2" then
		love.audio.stop(begin_mu)
		love.audio.play(game_mu)
		game_ui(3);
	elseif state =="level_3" then
		love.audio.stop(begin_mu)
		love.audio.play(game_mu)
		game_ui(4);
	elseif state == "end" then
	love.audio.stop(game_mu)

	love.graphics.setFont(title_font)
	love.graphics.printf("恭喜過關", 0, 200, 1280,"center")
	love.graphics.setColor(199,21,133,255)
	end_x = 450
	end_y = 400
	end_w = 400
	end_h = 200
	love.graphics.polygon("fill",end_x,end_y,end_x + end_w,end_y,end_x + end_w,end_y + end_h,end_x,end_y+end_h)
	love.graphics.setColor(100,150,100,255)
	love.graphics.setFont(set_font)
	love.graphics.printf("返回主選單", 450, 475, 400,"center")
	love.audio.play(begin_mu)
	end
	love.graphics.setFont(fps_font)
	love.graphics.setColor(100,100,100,255)
	love.graphics.print("Current FPS: ", 1100, 10)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(tostring(love.timer.getFPS( )), 1220 , 10)
	-- love.graphics.print("Mouse-X: "..tostring(x), 10, 30)
	-- love.graphics.print("Mouse-Y: "..tostring(y), 10, 60)
	-- love.graphics.print("mousecheck: "..tostring(mousecheck), 10, 90)
	-- love.graphics.print("state: "..tostring(state), 10, 120)
	-- love.graphics.print("inform_num_y: "..tostring(inform_num_y), 10, 150)
	-- love.graphics.print("button_set: "..tostring(button_set), 10, 180)
	-- love.graphics.print("move_action: "..tostring(move_action), 10, 210)
	-- love.graphics.print("real_time: "..tostring(real_time), 10, 240)
	-- love.graphics.print("start_monkey_position: "..tostring(start_monkey_position), 10, 270)
	

	function game_ui(map_index)

		love.graphics.draw(test_bg,0,0)
		love.graphics.line(0,500,900,500)
		love.graphics.line(900,0,900,720)
		love.graphics.setColor(255, 250, 205,100)	
	--網格
		count_map = 1
		for i=1,10 do
			love.graphics.line(0,50*i, 900, 50*i)
			for j=1,18 do
				love.graphics.line(50*j, 0, 50*j, 500)
				love.graphics.setFont(fps_font)
				love.graphics.print(count_map, (50*(j-1))+15, (50*(i-1))+15)
				count_map = count_map + 1
			end
		end

	--地圖
		for i=1,180 do
			for j=1,#map[map_index] do 
				if i==map[map_index][j] then
					map_catch = "true"
				end
			end
			if map_catch == "false" then
				x_map = (((i%18)*50)-50)
				if  i%18 == 0 then
					x_map = 850
				end 
				y_map = (math.floor(i/18))*50
				if i%18 == 0 then
					y_map = ((i/18)-1)*50
				end
				love.graphics.rectangle("fill" , x_map , y_map , 50 , 50 )
				--print("x="..x_map)
				--print("y="..y_map)
			end
			map_catch = "false"
		end

	--資訊視窗
		reg_x = 10
		reg_y = 520
	--	love.graphics.rectangle("line", reg_x, reg_y, 720, 180)
		love.graphics.line(reg_x, reg_y, reg_x+720, reg_y)
		love.graphics.line(reg_x, reg_y+90, reg_x+720, reg_y+90)
		love.graphics.line(reg_x, reg_y+20, reg_x+720, reg_y+20)
		love.graphics.line(reg_x, reg_y+110, reg_x+360, reg_y+110)
		love.graphics.line(reg_x, reg_y+180, reg_x+360, reg_y+180)
		for i=0,4 do
			love.graphics.line(reg_x+(90*i), reg_y, reg_x+(90*i), reg_y+180)
		end
		for i=0,8 do
			love.graphics.line(reg_x+(90*i), reg_y, reg_x+(90*i), reg_y+90)
		end
		for i=0,7 do
			love.graphics.print("R"..i, reg_x+30+(90*i),reg_y+2)
		end
		for i=0,3 do
			love.graphics.print("M"..i, reg_x+30+(90*i),reg_y+92)
		end
	--更新REG_table
		for i=1,8 do
			love.graphics.print(tostring(reg_table[i]), 40+(90*(i-1)), 560)
		end
		for i=1,4 do
			love.graphics.print(tostring(reg_table[i+8]), 40+(90*(i-1)), 650)
		end
	--輔助圖
		cross_x = 810
		cross_y = 610
		cross_l = 40
		love.graphics.line( cross_x + 5, cross_y, cross_x + cross_l + 5,cross_y)
		love.graphics.line( cross_x + cross_l ,cross_y + 5, cross_x + cross_l + 5,cross_y)
		love.graphics.line( cross_x + cross_l ,cross_y - 5, cross_x + cross_l + 5,cross_y)
		love.graphics.print("M3", cross_x + cross_l + 7, cross_y - 10)
		love.graphics.line( cross_x - cross_l - 5, cross_y, cross_x - 5,cross_y)
		love.graphics.line( cross_x - cross_l - 5, cross_y, cross_x - cross_l, cross_y - 5)
		love.graphics.line( cross_x - cross_l - 5, cross_y, cross_x - cross_l, cross_y + 5)
		love.graphics.print("M2", cross_x - cross_l - 25, cross_y - 9)
		love.graphics.line( cross_x, cross_y + 5, cross_x, cross_y + cross_l + 5)
		love.graphics.line( cross_x - 5,cross_y + cross_l , cross_x,cross_y + cross_l + 5)
		love.graphics.line( cross_x + 5,cross_y + cross_l , cross_x,cross_y + cross_l + 5)
		love.graphics.print("M1", cross_x - 8, cross_y + cross_l + 6 )
		love.graphics.line( cross_x, cross_y - 5, cross_x,cross_y - cross_l - 5)
		love.graphics.line( cross_x - 5,cross_y - cross_l, cross_x,cross_y - cross_l - 5)
		love.graphics.line( cross_x + 5,cross_y - cross_l, cross_x,cross_y - cross_l - 5)
		love.graphics.print("M0", cross_x - 8,cross_y - cross_l - 25)

	--輸入按鈕
		creat_button(440,625,100,80)
		love.graphics.setColor(100,100,100,255)
		love.graphics.printf("執行",440,625+30,100,"center")
		creat_button(575,625,100,80)
		love.graphics.setColor(100,100,100,255)
		love.graphics.printf("清除",575,625+30,100,"center")
	--輸入編輯器	
		for i=1,32 do
			love.graphics.print(tostring(i),930,10+i*20)
			if inform[i] then
				love.graphics.setColor(100,100,100,255)
				love.graphics.print(tostring(inform[i]),970,10+i*20)
			end
		end
		love.graphics.setColor(255,0,0,255)
		love.graphics.polygon("line",926,37+20*(PC-1),916,31+20*(PC-1),916,43+20*(PC-1))
		--print(inform_num_y )
		love.graphics.setColor(30,144,255,255)
		love.graphics.line( 970+(inform_num_x)*10,30+(inform_num_y)*20 ,970+(inform_num_x)*10,50+(inform_num_y)*20)

	--載入人物
	if start_monkey_position then
		if state == "level_1" or state == "tutorial" then
			monkey_x = 0
			monkey_y = 0
		end
		if state == "level_2" then
			monkey_x = 100
			monkey_y = 450
		end
		start_monkey_position = false
	end
	love.graphics.draw(monkey_icon, monkey_x, monkey_y)
	end

	function creat_button(a,b,c,d)
		love.graphics.setColor(100,150,100,255)
		love.graphics.polygon("fill",a,b,a+c,b,a+c,b+d,a,b+d)
	end
end



















