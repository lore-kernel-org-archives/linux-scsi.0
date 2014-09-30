From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Tue, 30 Sep 2014 10:27:33 +0000
Message-ID: <bug-85151-11613-0u4nT06ZIT@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40321 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaI3K1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 06:27:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ECA5520200
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2014 10:27:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B44FE201C7
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2014 10:27:33 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #10 from linux-ide@crashplan.pro ---
After splitting module loading and connecting the expander, and enabling
verbose pm80xx logging in between:

1. disconnect cable
2. modprobe pm80xx
3. # echo 0xfff > $(find /sys -iname logging_level)
4. verify new verbose logging level: # cat $(find /sys -iname logging_level)
00000fffh
5. plug cable

The new verbose dmesg output when connecting the HP Expander SAS Card
[468406-B21, 487738-001]:

[ 1642.564117] pm80xx pm8001_mpi_msg_consume 1450:: CI=11 PI=15
msgHeader=81002700
[ 1642.564580] pm80xx process_one_iomb 3464:OPC_OUB_HW_EVENT
[ 1642.565045] pm80xx mpi_hw_event 3106:portid:0 phyid:0 event:0x4 status:0x0
[ 1642.565551] pm80xx mpi_hw_event 3112:HW_EVENT_PHY_START_STATUS
[ 1642.566074] pm80xx hw_event_sas_phy_up 2863:portid:0; phyid:0; linkrate:4;
portstate:1; devicetype:2
[ 1642.566669] pm80xx hw_event_sas_phy_up 2879:expander device.
[ 1642.567281] pm80xx pm8001_bytes_dmaed 3246:phy 0 byte dmaded.
[ 1642.567913] pm80xx pm8001_mpi_msg_free_set 1407: CI=12 PI=15
[ 1642.568563] pm80xx pm8001_mpi_msg_consume 1450:: CI=12 PI=15
msgHeader=81002700
[ 1642.569241] pm80xx process_one_iomb 3464:OPC_OUB_HW_EVENT
[ 1642.569943] pm80xx mpi_hw_event 3106:portid:0 phyid:1 event:0x4 status:0x0
[ 1642.570687] pm80xx mpi_hw_event 3112:HW_EVENT_PHY_START_STATUS
[ 1642.571451] pm80xx hw_event_sas_phy_up 2863:portid:0; phyid:1; linkrate:4;
portstate:1; devicetype:2
[ 1642.572286] pm80xx hw_event_sas_phy_up 2879:expander device.
[ 1642.573132] pm80xx pm8001_bytes_dmaed 3246:phy 1 byte dmaded.
[ 1642.574004] pm80xx pm8001_mpi_msg_free_set 1407: CI=13 PI=15
[ 1642.574895] pm80xx pm8001_mpi_msg_consume 1450:: CI=13 PI=15
msgHeader=81002700
[ 1642.575818] pm80xx process_one_iomb 3464:OPC_OUB_HW_EVENT
[ 1642.576761] pm80xx mpi_hw_event 3106:portid:0 phyid:2 event:0x4 status:0x0
[ 1642.577748] pm80xx mpi_hw_event 3112:HW_EVENT_PHY_START_STATUS
[ 1642.578755] pm80xx hw_event_sas_phy_up 2863:portid:0; phyid:2; linkrate:4;
portstate:1; devicetype:2
[ 1642.579835] pm80xx hw_event_sas_phy_up 2879:expander device.
[ 1642.580924] pm80xx pm8001_bytes_dmaed 3246:phy 2 byte dmaded.
[ 1642.582039] pm80xx pm8001_mpi_msg_free_set 1407: CI=14 PI=15
[ 1642.583175] pm80xx pm8001_mpi_msg_consume 1450:: CI=14 PI=15
msgHeader=81002700
[ 1642.584339] pm80xx process_one_iomb 3464:OPC_OUB_HW_EVENT
[ 1642.585525] pm80xx mpi_hw_event 3106:portid:0 phyid:3 event:0x4 status:0x0
[ 1642.586756] pm80xx mpi_hw_event 3112:HW_EVENT_PHY_START_STATUS
[ 1642.588006] pm80xx hw_event_sas_phy_up 2863:portid:0; phyid:3; linkrate:4;
portstate:1; devicetype:2
[ 1642.589325] pm80xx hw_event_sas_phy_up 2879:expander device.
[ 1642.590821] pm80xx pm8001_bytes_dmaed 3246:phy 3 byte dmaded.
[ 1642.592350] pm80xx pm8001_mpi_msg_free_set 1407: CI=15 PI=15
[ 1642.594488] sas: phy-4:0 added to port-4:0, phy_mask:0x1 (5001438023aad066)
[ 1642.596212] sas: phy-4:1 added to port-4:1, phy_mask:0x2 (5001438023aad066)
[ 1642.598079] sas: phy-4:2 added to port-4:2, phy_mask:0x4 (5001438023aad066)
[ 1642.599804] sas: phy-4:3 added to port-4:3, phy_mask:0x8 (5001438023aad066)
[ 1642.601494] sas: DOING DISCOVERY on port 0, pid:137
[ 1642.603161] pm80xx pm8001_dev_found_notify 643:Found device
[ 1642.604698] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:32 , UPDATED
PI=12 CI=11
[ 1642.606242] pm80xx pm8001_mpi_msg_consume 1450:: CI=15 PI=16
msgHeader=81002832
[ 1642.607848] pm80xx process_one_iomb 3489:OPC_OUB_DEV_REGIST
[ 1642.609443] pm80xx pm8001_mpi_reg_resp 3552: register device is status = 0
[ 1642.611074] pm80xx pm8001_mpi_reg_resp 3555:DEVREG_SUCCESS
[ 1642.612720] pm80xx pm8001_mpi_msg_free_set 1407: CI=16 PI=16
[ 1642.614386] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.614386]
[ 1642.614386] pm80xx pm80xx_chip_smp_req 3768:SMP Frame Length 8
[ 1642.619030] pm80xx pm80xx_chip_smp_req 3814:SMP REQUEST DIRECT MODE
[ 1642.620612] pm80xx pm80xx_chip_smp_req 3821:Byte[0]:40 (DMA data:40)
[ 1642.622209] pm80xx pm80xx_chip_smp_req 3821:Byte[1]:0 (DMA data:40)
[ 1642.623813] pm80xx pm80xx_chip_smp_req 3821:Byte[2]:0 (DMA data:40)
[ 1642.625417] pm80xx pm80xx_chip_smp_req 3821:Byte[3]:0 (DMA data:40)
[ 1642.626891] pm80xx pm80xx_chip_smp_req 3821:Byte[4]:0 (DMA data:40)
[ 1642.628352] pm80xx pm80xx_chip_smp_req 3821:Byte[5]:0 (DMA data:40)
[ 1642.629812] pm80xx pm80xx_chip_smp_req 3821:Byte[6]:0 (DMA data:40)
[ 1642.631273] pm80xx pm80xx_chip_smp_req 3821:Byte[7]:0 (DMA data:40)
[ 1642.632736] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:12 , UPDATED
PI=13 CI=12
[ 1642.634242] pm80xx pm8001_mpi_msg_consume 1450:: CI=16 PI=17
msgHeader=81002006
[ 1642.635782] pm80xx process_one_iomb 3479:OPC_OUB_SMP_COMP
[ 1642.637327] pm80xx mpi_smp_completion 2611:IO_SUCCESS
[ 1642.638886] pm80xx mpi_smp_completion 2619:DIRECT RESPONSE Length:28
[ 1642.640469] pm80xx mpi_smp_completion 2628:SMP Byte0 DMA data 0x41 psmp 0x41
[ 1642.642072] pm80xx mpi_smp_completion 2628:SMP Byte1 DMA data 0x0 psmp 0x0
[ 1642.643680] pm80xx mpi_smp_completion 2628:SMP Byte2 DMA data 0x0 psmp 0x0
[ 1642.645256] pm80xx mpi_smp_completion 2628:SMP Byte3 DMA data 0x0 psmp 0x0
[ 1642.646806] pm80xx mpi_smp_completion 2628:SMP Byte4 DMA data 0x0 psmp 0x0
[ 1642.648327] pm80xx mpi_smp_completion 2628:SMP Byte5 DMA data 0x49 psmp 0x49
[ 1642.649838] pm80xx mpi_smp_completion 2628:SMP Byte6 DMA data 0x4 psmp 0x4
[ 1642.651314] pm80xx mpi_smp_completion 2628:SMP Byte7 DMA data 0x0 psmp 0x0
[ 1642.652764] pm80xx mpi_smp_completion 2628:SMP Byte8 DMA data 0xffffff80
psmp 0x80
[ 1642.654208] pm80xx mpi_smp_completion 2628:SMP Byte9 DMA data 0x25 psmp 0x25
[ 1642.655642] pm80xx mpi_smp_completion 2628:SMP Byte10 DMA data 0xffffff8c
psmp 0x8c
[ 1642.657080] pm80xx mpi_smp_completion 2628:SMP Byte11 DMA data 0x0 psmp 0x0
[ 1642.658494] pm80xx mpi_smp_completion 2628:SMP Byte12 DMA data 0x50 psmp
0x50
[ 1642.659889] pm80xx mpi_smp_completion 2628:SMP Byte13 DMA data 0x1 psmp 0x1
[ 1642.661270] pm80xx mpi_smp_completion 2628:SMP Byte14 DMA data 0x43 psmp
0x43
[ 1642.662619] pm80xx mpi_smp_completion 2628:SMP Byte15 DMA data 0xffffff80
psmp 0x80
[ 1642.663950] pm80xx mpi_smp_completion 2628:SMP Byte16 DMA data 0x23 psmp
0x23
[ 1642.665269] pm80xx mpi_smp_completion 2628:SMP Byte17 DMA data 0xffffffaa
psmp 0xaa
[ 1642.666585] pm80xx mpi_smp_completion 2628:SMP Byte18 DMA data 0xffffffd0
psmp 0xd0
[ 1642.667887] pm80xx mpi_smp_completion 2628:SMP Byte19 DMA data 0x65 psmp
0x65
[ 1642.669166] pm80xx mpi_smp_completion 2628:SMP Byte20 DMA data 0x0 psmp 0x0
[ 1642.670426] pm80xx mpi_smp_completion 2628:SMP Byte21 DMA data 0x0 psmp 0x0
[ 1642.671665] pm80xx mpi_smp_completion 2628:SMP Byte22 DMA data 0x0 psmp 0x0
[ 1642.672865] pm80xx mpi_smp_completion 2628:SMP Byte23 DMA data 0x0 psmp 0x0
[ 1642.674036] pm80xx mpi_smp_completion 2628:SMP Byte24 DMA data 0x0 psmp 0x0
[ 1642.675188] pm80xx mpi_smp_completion 2628:SMP Byte25 DMA data 0x0 psmp 0x0
[ 1642.676321] pm80xx mpi_smp_completion 2628:SMP Byte26 DMA data 0x0 psmp 0x0
[ 1642.677440] pm80xx mpi_smp_completion 2628:SMP Byte27 DMA data 0x0 psmp 0x0
[ 1642.678536] pm80xx pm8001_mpi_msg_free_set 1407: CI=17 PI=17
[ 1642.679622] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.679622]
[ 1642.679622] pm80xx pm80xx_chip_smp_req 3768:SMP Frame Length 8
[ 1642.684002] pm80xx pm80xx_chip_smp_req 3814:SMP REQUEST DIRECT MODE
[ 1642.685446] pm80xx pm80xx_chip_smp_req 3821:Byte[0]:40 (DMA data:40)
[ 1642.686884] pm80xx pm80xx_chip_smp_req 3821:Byte[1]:1 (DMA data:40)
[ 1642.688291] pm80xx pm80xx_chip_smp_req 3821:Byte[2]:0 (DMA data:40)
[ 1642.689696] pm80xx pm80xx_chip_smp_req 3821:Byte[3]:0 (DMA data:40)
[ 1642.691098] pm80xx pm80xx_chip_smp_req 3821:Byte[4]:0 (DMA data:40)
[ 1642.692499] pm80xx pm80xx_chip_smp_req 3821:Byte[5]:0 (DMA data:40)
[ 1642.693862] pm80xx pm80xx_chip_smp_req 3821:Byte[6]:0 (DMA data:40)
[ 1642.695193] pm80xx pm80xx_chip_smp_req 3821:Byte[7]:0 (DMA data:40)
[ 1642.696490] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:12 , UPDATED
PI=14 CI=13
[ 1642.697810] pm80xx pm8001_mpi_msg_consume 1450:: CI=17 PI=18
msgHeader=81002006
[ 1642.699133] pm80xx process_one_iomb 3479:OPC_OUB_SMP_COMP
[ 1642.700428] pm80xx mpi_smp_completion 2611:IO_SUCCESS
[ 1642.701722] pm80xx mpi_smp_completion 2619:DIRECT RESPONSE Length:60
[ 1642.703026] pm80xx mpi_smp_completion 2628:SMP Byte0 DMA data 0x41 psmp 0x41
[ 1642.704335] pm80xx mpi_smp_completion 2628:SMP Byte1 DMA data 0x1 psmp 0x1
[ 1642.705620] pm80xx mpi_smp_completion 2628:SMP Byte2 DMA data 0x0 psmp 0x0
[ 1642.706880] pm80xx mpi_smp_completion 2628:SMP Byte3 DMA data 0x0 psmp 0x0
[ 1642.708124] pm80xx mpi_smp_completion 2628:SMP Byte4 DMA data 0x0 psmp 0x0
[ 1642.709349] pm80xx mpi_smp_completion 2628:SMP Byte5 DMA data 0x49 psmp 0x49
[ 1642.710472] pm80xx mpi_smp_completion 2628:SMP Byte6 DMA data 0x0 psmp 0x0
[ 1642.711569] pm80xx mpi_smp_completion 2628:SMP Byte7 DMA data 0x0 psmp 0x0
[ 1642.712665] pm80xx mpi_smp_completion 2628:SMP Byte8 DMA data 0x1 psmp 0x1
[ 1642.713764] pm80xx mpi_smp_completion 2628:SMP Byte9 DMA data 0x0 psmp 0x0
[ 1642.714865] pm80xx mpi_smp_completion 2628:SMP Byte10 DMA data 0x0 psmp 0x0
[ 1642.715983] pm80xx mpi_smp_completion 2628:SMP Byte11 DMA data 0x0 psmp 0x0
[ 1642.717100] pm80xx mpi_smp_completion 2628:SMP Byte12 DMA data 0x48 psmp
0x48
[ 1642.718189] pm80xx mpi_smp_completion 2628:SMP Byte13 DMA data 0x50 psmp
0x50
[ 1642.719252] pm80xx mpi_smp_completion 2628:SMP Byte14 DMA data 0x20 psmp
0x20
[ 1642.720281] pm80xx mpi_smp_completion 2628:SMP Byte15 DMA data 0x20 psmp
0x20
[ 1642.721290] pm80xx mpi_smp_completion 2628:SMP Byte16 DMA data 0x20 psmp
0x20
[ 1642.722283] pm80xx mpi_smp_completion 2628:SMP Byte17 DMA data 0x20 psmp
0x20
[ 1642.723254] pm80xx mpi_smp_completion 2628:SMP Byte18 DMA data 0x20 psmp
0x20
[ 1642.724219] pm80xx mpi_smp_completion 2628:SMP Byte19 DMA data 0x20 psmp
0x20
[ 1642.725185] pm80xx mpi_smp_completion 2628:SMP Byte20 DMA data 0x48 psmp
0x48
[ 1642.726153] pm80xx mpi_smp_completion 2628:SMP Byte21 DMA data 0x50 psmp
0x50
[ 1642.727126] pm80xx mpi_smp_completion 2628:SMP Byte22 DMA data 0x20 psmp
0x20
[ 1642.728095] pm80xx mpi_smp_completion 2628:SMP Byte23 DMA data 0x53 psmp
0x53
[ 1642.729059] pm80xx mpi_smp_completion 2628:SMP Byte24 DMA data 0x41 psmp
0x41
[ 1642.730023] pm80xx mpi_smp_completion 2628:SMP Byte25 DMA data 0x53 psmp
0x53
[ 1642.730980] pm80xx mpi_smp_completion 2628:SMP Byte26 DMA data 0x20 psmp
0x20
[ 1642.731928] pm80xx mpi_smp_completion 2628:SMP Byte27 DMA data 0x45 psmp
0x45
[ 1642.732862] pm80xx mpi_smp_completion 2628:SMP Byte28 DMA data 0x58 psmp
0x58
[ 1642.733775] pm80xx mpi_smp_completion 2628:SMP Byte29 DMA data 0x50 psmp
0x50
[ 1642.734602] pm80xx mpi_smp_completion 2628:SMP Byte30 DMA data 0x20 psmp
0x20
[ 1642.735426] pm80xx mpi_smp_completion 2628:SMP Byte31 DMA data 0x43 psmp
0x43
[ 1642.736245] pm80xx mpi_smp_completion 2628:SMP Byte32 DMA data 0x61 psmp
0x61
[ 1642.737056] pm80xx mpi_smp_completion 2628:SMP Byte33 DMA data 0x72 psmp
0x72
[ 1642.737858] pm80xx mpi_smp_completion 2628:SMP Byte34 DMA data 0x64 psmp
0x64
[ 1642.738655] pm80xx mpi_smp_completion 2628:SMP Byte35 DMA data 0x20 psmp
0x20
[ 1642.739451] pm80xx mpi_smp_completion 2628:SMP Byte36 DMA data 0x32 psmp
0x32
[ 1642.740239] pm80xx mpi_smp_completion 2628:SMP Byte37 DMA data 0x2e psmp
0x2e
[ 1642.741024] pm80xx mpi_smp_completion 2628:SMP Byte38 DMA data 0x31 psmp
0x31
[ 1642.741812] pm80xx mpi_smp_completion 2628:SMP Byte39 DMA data 0x30 psmp
0x30
[ 1642.742601] pm80xx mpi_smp_completion 2628:SMP Byte40 DMA data 0x50 psmp
0x50
[ 1642.743394] pm80xx mpi_smp_completion 2628:SMP Byte41 DMA data 0x4d psmp
0x4d
[ 1642.744189] pm80xx mpi_smp_completion 2628:SMP Byte42 DMA data 0x43 psmp
0x43
[ 1642.745067] pm80xx mpi_smp_completion 2628:SMP Byte43 DMA data 0x53 psmp
0x53
[ 1642.745867] pm80xx mpi_smp_completion 2628:SMP Byte44 DMA data 0x49 psmp
0x49
[ 1642.746667] pm80xx mpi_smp_completion 2628:SMP Byte45 DMA data 0x45 psmp
0x45
[ 1642.747440] pm80xx mpi_smp_completion 2628:SMP Byte46 DMA data 0x52 psmp
0x52
[ 1642.748196] pm80xx mpi_smp_completion 2628:SMP Byte47 DMA data 0x41 psmp
0x41
[ 1642.748931] pm80xx mpi_smp_completion 2628:SMP Byte48 DMA data 0xffffff80
psmp 0x80
[ 1642.749656] pm80xx mpi_smp_completion 2628:SMP Byte49 DMA data 0x5 psmp 0x5
[ 1642.750373] pm80xx mpi_smp_completion 2628:SMP Byte50 DMA data 0x2 psmp 0x2
[ 1642.751081] pm80xx mpi_smp_completion 2628:SMP Byte51 DMA data 0x0 psmp 0x0
[ 1642.751782] pm80xx mpi_smp_completion 2628:SMP Byte52 DMA data 0x0 psmp 0x0
[ 1642.752479] pm80xx mpi_smp_completion 2628:SMP Byte53 DMA data 0x0 psmp 0x0
[ 1642.753178] pm80xx mpi_smp_completion 2628:SMP Byte54 DMA data 0x0 psmp 0x0
[ 1642.753875] pm80xx mpi_smp_completion 2628:SMP Byte55 DMA data 0x0 psmp 0x0
[ 1642.754572] pm80xx mpi_smp_completion 2628:SMP Byte56 DMA data 0x0 psmp 0x0
[ 1642.755269] pm80xx mpi_smp_completion 2628:SMP Byte57 DMA data 0x0 psmp 0x0
[ 1642.755966] pm80xx mpi_smp_completion 2628:SMP Byte58 DMA data 0x0 psmp 0x0
[ 1642.756631] pm80xx mpi_smp_completion 2628:SMP Byte59 DMA data 0x0 psmp 0x0
[ 1642.757272] pm80xx pm8001_mpi_msg_free_set 1407: CI=18 PI=18
[ 1642.757900] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.757900]
[ 1642.757900] pm80xx pm80xx_chip_smp_req 3768:SMP Frame Length 16
[ 1642.759788] pm80xx pm80xx_chip_smp_req 3781:SMP REQUEST INDIRECT MODE
[ 1642.760441] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:12 , UPDATED
PI=15 CI=14
[ 1642.761496] pm80xx pm8001_mpi_msg_consume 1450:: CI=18 PI=19
msgHeader=81002006
[ 1642.762159] pm80xx process_one_iomb 3479:OPC_OUB_SMP_COMP
[ 1642.762826] pm80xx mpi_smp_completion 2604:smp IO status 0x2
[ 1642.763508] pm80xx mpi_smp_completion 2641:IO_UNDERFLOW
[ 1642.764195] pm80xx pm8001_mpi_msg_free_set 1407: CI=19 PI=19
[ 1642.764932] sas: expander 5001438023aad066 discovery failed(0xffffffa6)
[ 1642.765689] pm80xx pm8001_dev_gone_notify 866:found dev[16385:2] is gone.
[ 1642.766453] pm80xx pm8001_chip_dereg_dev_req 4573:unregister device
device_id = 16385
[ 1642.767240] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:10 , UPDATED
PI=16 CI=15
[ 1642.768065] pm80xx pm8001_mpi_msg_consume 1450:: CI=19 PI=20
msgHeader=8100200b
[ 1642.768896] pm80xx process_one_iomb 3494:unregister the device
[ 1642.769739] pm80xx pm8001_mpi_msg_free_set 1407: CI=20 PI=20
[ 1642.771479] sas: DONE DISCOVERY on port 0, pid:137, result:-90
[ 1642.772323] sas: DOING DISCOVERY on port 1, pid:137
[ 1642.773337] pm80xx pm8001_dev_found_notify 643:Found device
[ 1642.774202] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:32 , UPDATED
PI=17 CI=16
[ 1642.775132] pm80xx pm8001_mpi_msg_consume 1450:: CI=20 PI=21
msgHeader=81002832
[ 1642.776052] pm80xx process_one_iomb 3489:OPC_OUB_DEV_REGIST
[ 1642.776976] pm80xx pm8001_mpi_reg_resp 3552: register device is status =
4162
[ 1642.777929] pm80xx pm8001_mpi_reg_resp
3588:DEVREG_FAILURE_DEVICE_TYPE_NOT_UNSORPORTED
[ 1642.778906] pm80xx pm8001_mpi_msg_free_set 1407: CI=21 PI=21
[ 1642.779930] pm80xx pm8001_task_exec 375:pm8001_task_exec device

[ 1642.780602] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.781997] pm80xx pm8001_task_exec 375:pm8001_task_exec device

[ 1642.782732] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.784255] pm80xx pm8001_task_exec 375:pm8001_task_exec device

[ 1642.785061] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.786718] sas: RG to ex 5001438023aad066 failed:0xffffffba
[ 1642.787586] pm80xx pm8001_dev_gone_notify 866:found dev[2048:2] is gone.
[ 1642.788471] pm80xx pm8001_chip_dereg_dev_req 4573:unregister device
device_id = 2048
[ 1642.789375] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:10 , UPDATED
PI=18 CI=17
[ 1642.790322] pm80xx pm8001_mpi_msg_consume 1450:: CI=21 PI=22
msgHeader=8100200b
[ 1642.790322] pm80xx process_one_iomb 3494:unregister the device
[ 1642.790323] pm80xx pm8001_mpi_dereg_resp 3610: deregister device failed
,status = 1023, device_id = 0
[ 1642.790324] pm80xx pm8001_mpi_msg_free_set 1407: CI=22 PI=22
[ 1642.790413] sas: DONE DISCOVERY on port 1, pid:137, result:-70
[ 1642.790420] sas: DOING DISCOVERY on port 2, pid:137
[ 1642.790513] pm80xx pm8001_dev_found_notify 643:Found device
[ 1642.790514] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:32 , UPDATED
PI=19 CI=18
[ 1642.790525] pm80xx pm8001_mpi_msg_consume 1450:: CI=22 PI=23
msgHeader=81002832
[ 1642.790526] pm80xx process_one_iomb 3489:OPC_OUB_DEV_REGIST
[ 1642.790527] pm80xx pm8001_mpi_reg_resp 3552: register device is status =
4162
[ 1642.790527] pm80xx pm8001_mpi_reg_resp
3588:DEVREG_FAILURE_DEVICE_TYPE_NOT_UNSORPORTED
[ 1642.790529] pm80xx pm8001_mpi_msg_free_set 1407: CI=23 PI=23
[ 1642.792165] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.792165]
[ 1642.792165] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.792167] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.792167]
[ 1642.792167] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.792168] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.792168]
[ 1642.792168] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.792169] sas: RG to ex 5001438023aad066 failed:0xffffffba
[ 1642.792171] pm80xx pm8001_dev_gone_notify 866:found dev[2048:2] is gone.
[ 1642.792172] pm80xx pm8001_chip_dereg_dev_req 4573:unregister device
device_id = 2048
[ 1642.792174] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:10 , UPDATED
PI=20 CI=19
[ 1642.792184] pm80xx pm8001_mpi_msg_consume 1450:: CI=23 PI=24
msgHeader=8100200b
[ 1642.792185] pm80xx process_one_iomb 3494:unregister the device
[ 1642.792187] pm80xx pm8001_mpi_dereg_resp 3610: deregister device failed
,status = 1023, device_id = 0
[ 1642.792188] pm80xx pm8001_mpi_msg_free_set 1407: CI=24 PI=24
[ 1642.792673] sas: DONE DISCOVERY on port 2, pid:137, result:-70
[ 1642.792680] sas: DOING DISCOVERY on port 3, pid:137
[ 1642.793409] pm80xx pm8001_dev_found_notify 643:Found device
[ 1642.793411] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:32 , UPDATED
PI=21 CI=20
[ 1642.793425] pm80xx pm8001_mpi_msg_consume 1450:: CI=24 PI=25
msgHeader=81002832
[ 1642.793425] pm80xx process_one_iomb 3489:OPC_OUB_DEV_REGIST
[ 1642.793426] pm80xx pm8001_mpi_reg_resp 3552: register device is status =
4162
[ 1642.793427] pm80xx pm8001_mpi_reg_resp
3588:DEVREG_FAILURE_DEVICE_TYPE_NOT_UNSORPORTED
[ 1642.793429] pm80xx pm8001_mpi_msg_free_set 1407: CI=25 PI=25
[ 1642.795451] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.795451]
[ 1642.795451] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.795453] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.795453]
[ 1642.795453] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.795454] pm80xx pm8001_task_exec 375:pm8001_task_exec device
[ 1642.795454]
[ 1642.795454] sas: smp_execute_task: task to dev 5001438023aad066 response:
0xffffffff status 0x8a
[ 1642.795455] sas: RG to ex 5001438023aad066 failed:0xffffffba
[ 1642.795456] pm80xx pm8001_dev_gone_notify 866:found dev[2048:2] is gone.
[ 1642.795457] pm80xx pm8001_chip_dereg_dev_req 4573:unregister device
device_id = 2048
[ 1642.795458] pm80xx pm8001_mpi_build_cmd 1368:INB Q 0 OPCODE:10 , UPDATED
PI=22 CI=21
[ 1642.795468] pm80xx pm8001_mpi_msg_consume 1450:: CI=25 PI=26
msgHeader=8100200b
[ 1642.795469] pm80xx process_one_iomb 3494:unregister the device
[ 1642.795470] pm80xx pm8001_mpi_dereg_resp 3610: deregister device failed
,status = 1023, device_id = 0
[ 1642.795470] pm80xx pm8001_mpi_msg_free_set 1407: CI=26 PI=26
[ 1642.796793] sas: DONE DISCOVERY on port 3, pid:137, result:-70

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
