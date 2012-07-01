From: Christian Schmidt <schmidt@digadd.de>
Subject: mvsas Kernel module failure
Date: Sun, 01 Jul 2012 22:11:21 +0200
Message-ID: <4FF0AEE9.5020607@digadd.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010207080407090204090104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:59377 "EHLO mx1.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874Ab2GAUkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jul 2012 16:40:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: yuxiangl@marvell.com

This is a multi-part message in MIME format.
--------------010207080407090204090104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

I am currently trying to get an Areca ARC-1320ix-16 SAS controller to
work. This controller has an 88SE94xx controller chip paired with a SAS
Expander on a single PCB.

The mvsas driver claims to support this board, however, in my tests with
kernels 2.6.36.4, 3.0.0, 3.0.35, 3.0.36, 3.1.10, 3.2.21, 3.3.8, 3.4.2
and 3.4.4 I did not find one that works. Several kernels panicced a few
minutes into boot after some timeouts, others produced BUGs only.

Attached logs are one from kernel 3.0.35 (the most successful ever: one
of the enclosure devices was found. I know from a test boot with FreeBSD
and the closed source driver that there are two, on SAS IDs 130 and 131.
The other is from 3.3.8 and shows the typical command timeout, fail to
abort, BUG situation I have with 3.2 and 3.4 as well. Note that these
are from two different machines I tried the host in.

I'm open to try all kinds of suggestions for the next week before I
return the controller.

Regards,
Christian

--------------010207080407090204090104
Content-Type: text/plain;
 name="mvsas-3.0.35.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mvsas-3.0.35.txt"

[ 4356.598148] mvsas 0000:02:00.0: mvsas: driver version 0.8.2
[ 4356.598162] mvsas 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[ 4356.598166] mvsas 0000:02:00.0: enabling bus mastering
[ 4356.598171] mvsas 0000:02:00.0: setting latency timer to 64
[ 4356.598454] mvsas 0000:02:00.0: mvsas: PCI-E x4, Bandwidth Usage: 5.0 Gbps
[ 4358.982094] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4358.982098] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4359.062084] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 0 2000220.
[ 4359.072085] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 1 d5b40150.
[ 4359.082086] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 2 3f900009.
[ 4359.092087] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 3 d5b40150.
[ 4359.102087] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 4 3f900009.
[ 4359.112088] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 5 11b.
[ 4359.122088] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 0 atta frame 6 0.
[ 4359.122092] drivers/scsi/mvsas/mv_sas.c 1338:port 0 attach dev info is 1b040002
[ 4359.122094] drivers/scsi/mvsas/mv_sas.c 1340:port 0 attach sas addr is 3f900009d5b40150
[ 4359.223040] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4359.223044] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4359.303030] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 0 2000220.
[ 4359.313031] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 1 d5b40150.
[ 4359.323032] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 2 3f900009.
[ 4359.333032] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 3 d5b40150.
[ 4359.343033] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 4 3f900009.
[ 4359.353034] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 5 11a.
[ 4359.363034] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 1 atta frame 6 0.
[ 4359.363038] drivers/scsi/mvsas/mv_sas.c 1338:port 1 attach dev info is 1a040002
[ 4359.363040] drivers/scsi/mvsas/mv_sas.c 1340:port 1 attach sas addr is 3f900009d5b40150
[ 4359.463959] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4359.463963] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4359.543949] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 0 2000220.
[ 4359.553950] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 1 d5b40150.
[ 4359.563951] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 2 3f900009.
[ 4359.573951] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 3 d5b40150.
[ 4359.583952] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 4 3f900009.
[ 4359.593953] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 5 119.
[ 4359.603954] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 2 atta frame 6 0.
[ 4359.603957] drivers/scsi/mvsas/mv_sas.c 1338:port 2 attach dev info is 19040002
[ 4359.603960] drivers/scsi/mvsas/mv_sas.c 1340:port 2 attach sas addr is 3f900009d5b40150
[ 4359.704926] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4359.704930] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4359.784918] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 0 2000220.
[ 4359.794919] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 1 d5b40150.
[ 4359.804921] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 2 3f900009.
[ 4359.814923] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 3 d5b40150.
[ 4359.824924] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 4 3f900009.
[ 4359.834925] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 5 118.
[ 4359.844927] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 3 atta frame 6 0.
[ 4359.844930] drivers/scsi/mvsas/mv_sas.c 1338:port 3 attach dev info is 18040002
[ 4359.844933] drivers/scsi/mvsas/mv_sas.c 1340:port 3 attach sas addr is 3f900009d5b40150
[ 4362.229325] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4362.229329] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4362.309315] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 0 2000220.
[ 4362.319316] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 1 d5b40150.
[ 4362.329317] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 2 3f900009.
[ 4362.339318] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 3 d5b40150.
[ 4362.349318] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 4 3f900009.
[ 4362.359319] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 5 117.
[ 4362.369320] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 4 atta frame 6 0.
[ 4362.369323] drivers/scsi/mvsas/mv_sas.c 1338:port 4 attach dev info is 17040002
[ 4362.369326] drivers/scsi/mvsas/mv_sas.c 1340:port 4 attach sas addr is 3f900009d5b40150
[ 4362.470267] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4362.470271] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4362.550257] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 0 2000220.
[ 4362.560258] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 1 d5b40150.
[ 4362.570259] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 2 3f900009.
[ 4362.580259] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 3 d5b40150.
[ 4362.590260] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 4 3f900009.
[ 4362.600261] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 5 116.
[ 4362.610261] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 5 atta frame 6 0.
[ 4362.610264] drivers/scsi/mvsas/mv_sas.c 1338:port 5 attach dev info is 16040002
[ 4362.610267] drivers/scsi/mvsas/mv_sas.c 1340:port 5 attach sas addr is 3f900009d5b40150
[ 4362.711213] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4362.711218] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4362.791204] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 0 2000220.
[ 4362.801205] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 1 d5b40150.
[ 4362.811206] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 2 3f900009.
[ 4362.821207] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 3 d5b40150.
[ 4362.831208] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 4 3f900009.
[ 4362.841209] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 5 115.
[ 4362.851209] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 6 atta frame 6 0.
[ 4362.851212] drivers/scsi/mvsas/mv_sas.c 1338:port 6 attach dev info is 15040002
[ 4362.851215] drivers/scsi/mvsas/mv_sas.c 1340:port 6 attach sas addr is 3f900009d5b40150
[ 4362.952143] drivers/scsi/mvsas/mv_94xx.c 505:get all reg link rate is 0x122f00
[ 4362.952147] drivers/scsi/mvsas/mv_94xx.c 510:get link rate is 10
[ 4363.032130] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 0 2000220.
[ 4363.042129] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 1 d5b40150.
[ 4363.052128] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 2 3f900009.
[ 4363.062127] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 3 d5b40150.
[ 4363.072126] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 4 3f900009.
[ 4363.082125] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 5 114.
[ 4363.092123] drivers/scsi/mvsas/mv_94xx.c 467:94xx phy 7 atta frame 6 0.
[ 4363.092125] drivers/scsi/mvsas/mv_sas.c 1338:port 7 attach dev info is 14040002
[ 4363.092127] drivers/scsi/mvsas/mv_sas.c 1340:port 7 attach sas addr is 3f900009d5b40150
[ 4363.092130] scsi8 : mvsas
[ 4363.093290] drivers/scsi/mvsas/mv_sas.c 379:phy 0 byte dmaded.
[ 4363.093297] drivers/scsi/mvsas/mv_sas.c 379:phy 1 byte dmaded.
[ 4363.093303] drivers/scsi/mvsas/mv_sas.c 379:phy 2 byte dmaded.
[ 4363.093307] drivers/scsi/mvsas/mv_sas.c 379:phy 3 byte dmaded.
[ 4363.093311] drivers/scsi/mvsas/mv_sas.c 379:phy 4 byte dmaded.
[ 4363.093314] drivers/scsi/mvsas/mv_sas.c 379:phy 5 byte dmaded.
[ 4363.093318] drivers/scsi/mvsas/mv_sas.c 379:phy 6 byte dmaded.
[ 4363.093325] drivers/scsi/mvsas/mv_sas.c 379:phy 7 byte dmaded.
[ 4363.093346] sas: phy-8:0 added to port-8:0, phy_mask:0x1 (5001b4d50900903f)
[ 4363.093351] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map 1
[ 4363.103366] sas: phy1 matched wide port0
[ 4363.103373] sas: phy-8:1 added to port-8:0, phy_mask:0x3 (5001b4d50900903f)
[ 4363.103377] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map 3
[ 4363.123385] sas: phy2 matched wide port0
[ 4363.123390] sas: phy-8:2 added to port-8:0, phy_mask:0x7 (5001b4d50900903f)
[ 4363.123393] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map 7
[ 4363.153399] sas: phy3 matched wide port0
[ 4363.153403] sas: phy-8:3 added to port-8:0, phy_mask:0xf (5001b4d50900903f)
[ 4363.153406] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map f
[ 4363.193412] sas: phy0 matched wide port0
[ 4363.193419] sas: phy-8:4 added to port-8:0, phy_mask:0xf (5001b4d50900903f)
[ 4363.193422] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map f
[ 4363.233425] sas: phy1 matched wide port0
[ 4363.233431] sas: phy-8:5 added to port-8:0, phy_mask:0xf (5001b4d50900903f)
[ 4363.233434] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map f
[ 4363.273437] sas: phy2 matched wide port0
[ 4363.273443] sas: phy-8:6 added to port-8:0, phy_mask:0xf (5001b4d50900903f)
[ 4363.273446] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map f
[ 4363.313448] sas: phy3 matched wide port0
[ 4363.313453] sas: phy-8:7 added to port-8:0, phy_mask:0xf (5001b4d50900903f)
[ 4363.313456] drivers/scsi/mvsas/mv_sas.c 1375:set wide port phy map f
[ 4363.353468] sas: DOING DISCOVERY on port 0, pid:100
[ 4363.353793] sas: ex 5001b4d50900903f phy00:T attached: 0000000000000000
[ 4363.353953] sas: ex 5001b4d50900903f phy01:T attached: 0000000000000000
[ 4363.354052] sas: ex 5001b4d50900903f phy02:T attached: 0000000000000000
[ 4363.354182] sas: ex 5001b4d50900903f phy03:T attached: 0000000000000000
[ 4363.354242] sas: ex 5001b4d50900903f phy04:D attached: 0000000000000000
[ 4363.354329] sas: ex 5001b4d50900903f phy05:D attached: 0000000000000000
[ 4363.354435] sas: ex 5001b4d50900903f phy06:D attached: 0000000000000000
[ 4363.354525] sas: ex 5001b4d50900903f phy07:D attached: 0000000000000000
[ 4363.354589] sas: ex 5001b4d50900903f phy08:D attached: 0000000000000000
[ 4363.354649] sas: ex 5001b4d50900903f phy09:D attached: 0000000000000000
[ 4363.354712] sas: ex 5001b4d50900903f phy10:D attached: 0000000000000000
[ 4363.354780] sas: ex 5001b4d50900903f phy11:D attached: 0000000000000000
[ 4363.354854] sas: ex 5001b4d50900903f phy12:D attached: 0000000000000000
[ 4363.354924] sas: ex 5001b4d50900903f phy13:D attached: 0000000000000000
[ 4363.355001] sas: ex 5001b4d50900903f phy14:D attached: 0000000000000000
[ 4363.355067] sas: ex 5001b4d50900903f phy15:D attached: 0000000000000000
[ 4363.355302] sas: ex 5001b4d50900903f phy16:T attached: 0000000000000000
[ 4363.355438] sas: ex 5001b4d50900903f phy17:T attached: 0000000000000000
[ 4363.355569] sas: ex 5001b4d50900903f phy18:T attached: 0000000000000000
[ 4363.355681] sas: ex 5001b4d50900903f phy19:T attached: 0000000000000000
[ 4363.355762] sas: ex 5001b4d50900903f phy20:D attached: 0000000000000000
[ 4363.355858] sas: ex 5001b4d50900903f phy21:D attached: 0000000000000000
[ 4363.355947] sas: ex 5001b4d50900903f phy22:D attached: 0000000000000000
[ 4363.356021] sas: ex 5001b4d50900903f phy23:D attached: 0000000000000000
[ 4363.356128] sas: ex 5001b4d50900903f phy24:S attached: 5005043011ab0000
[ 4363.356234] sas: ex 5001b4d50900903f phy25:S attached: 5005043011ab0000
[ 4363.356374] sas: ex 5001b4d50900903f phy26:S attached: 5005043011ab0000
[ 4363.356494] sas: ex 5001b4d50900903f phy27:S attached: 5005043011ab0000
[ 4363.356594] sas: ex 5001b4d50900903f phy28:T attached: 0000000000000000
[ 4363.356696] sas: ex 5001b4d50900903f phy29:T attached: 0000000000000000
[ 4363.356851] sas: ex 5001b4d50900903f phy30:T attached: 0000000000000000
[ 4363.356959] sas: ex 5001b4d50900903f phy31:T attached: 0000000000000000
[ 4363.357050] sas: ex 5001b4d50900903f phy32:D attached: 0000000000000000
[ 4363.357149] sas: ex 5001b4d50900903f phy33:D attached: 0000000000000000
[ 4363.357244] sas: ex 5001b4d50900903f phy34:D attached: 0000000000000000
[ 4363.357323] sas: ex 5001b4d50900903f phy35:D attached: 0000000000000000
[ 4363.357425] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4363.357527] sas: ex 5001b4d50900903f phy37:D attached: 0000000000000000
[ 4384.088113] sas: command 0xffff88022ada1500, task 0xffff88023132ef00, timed out: BLK_EH_NOT_HANDLED
[ 4384.088173] sas: Enter sas_scsi_recover_host
[ 4384.088177] sas: trying to find task 0xffff88023132ef00
[ 4384.088180] sas: sas_scsi_find_task: aborting task 0xffff88023132ef00
[ 4404.115414] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4404.115420] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4404.115423] sas: sas_scsi_find_task: querying task 0xffff88023132ef00
[ 4424.142669] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4424.142674] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4424.142677] sas: sas_scsi_find_task: task 0xffff88023132ef00 not at LU
[ 4424.142680] sas: task 0xffff88023132ef00 is not at LU: I_T recover
[ 4424.142682] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4424.142802] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4424.142807] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4424.142809] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4425.142718] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4425.142721] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4425.142723] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4426.142629] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4426.142632] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4426.142634] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4427.142542] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4427.142545] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4427.142547] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4428.142455] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4428.142458] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x300
[ 4428.142460] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4429.142367] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4429.142370] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4429.142372] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4430.142280] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4430.142283] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4430.142285] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4431.142191] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4431.142193] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4431.142196] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4434.143284] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4434.143294] sas: I_T 5001b4d50900903d recovered
[ 4434.143301] sas: --- Exit sas_scsi_recover_host
[ 4434.144365] scsi 8:0:0:0: Enclosure         Areca    ARC-8017-.01.09. 0109 PQ: 0 ANSI: 5
[ 4465.060970] sas: command 0xffff8802270dc800, task 0xffff880228612480, timed out: BLK_EH_NOT_HANDLED
[ 4465.061007] sas: Enter sas_scsi_recover_host
[ 4465.061010] sas: trying to find task 0xffff880228612480
[ 4465.061013] sas: sas_scsi_find_task: aborting task 0xffff880228612480
[ 4485.120200] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4485.120207] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4485.120210] sas: sas_scsi_find_task: querying task 0xffff880228612480
[ 4505.147443] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4505.147448] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4505.147451] sas: sas_scsi_find_task: task 0xffff880228612480 not at LU
[ 4505.147453] sas: task 0xffff880228612480 is not at LU: I_T recover
[ 4505.147456] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4505.147552] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4505.147555] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4505.147557] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4506.147464] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4506.147467] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4506.147469] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4507.147377] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4507.147379] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4507.147382] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4508.147290] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4508.147293] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4508.147295] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4509.147202] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4509.147205] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x100
[ 4509.147207] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4510.147113] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4510.147116] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4510.147118] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4511.147024] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4511.147026] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4511.147029] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4512.146936] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4512.146938] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4512.146941] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4515.147103] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4515.147114] sas: I_T 5001b4d50900903d recovered
[ 4515.147121] sas: --- Exit sas_scsi_recover_host
[ 4546.097773] sas: command 0xffff8802270dc800, task 0xffff88023132ef00, timed out: BLK_EH_NOT_HANDLED
[ 4546.097806] sas: Enter sas_scsi_recover_host
[ 4546.097809] sas: trying to find task 0xffff88023132ef00
[ 4546.097811] sas: sas_scsi_find_task: aborting task 0xffff88023132ef00
[ 4546.097859] sas: sas_scsi_find_task: task 0xffff88023132ef00 is done
[ 4546.097862] sas: sas_eh_handle_sas_errors: task 0xffff88023132ef00 is done
[ 4546.097872] sas: --- Exit sas_scsi_recover_host
[ 4546.098022] sas: DONE DISCOVERY on port 0, pid:100, result:0
[ 4546.098027] sas: broadcast received: 0
[ 4546.098030] sas: broadcast received: 0
[ 4546.098032] sas: broadcast received: 0
[ 4546.098034] sas: broadcast received: 0
[ 4546.098035] sas: broadcast received: 0
[ 4546.098037] sas: broadcast received: 0
[ 4546.098039] sas: broadcast received: 0
[ 4546.098041] sas: broadcast received: 0
[ 4546.098043] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4546.098150] ses 8:0:0:0: Attached Enclosure device
[ 4546.098229] ses 8:0:0:0: Attached scsi generic sg11 type 13
[ 4546.099959] sas: Expander phy change count has changed
[ 4546.101421] sas: ex 5001b4d50900903f phy36 originated BROADCAST(CHANGE)
[ 4546.101473] sas: ex 5001b4d50900903f phy 0x24 broadcast flutter
[ 4546.101525] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4546.101577] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4577.066388] sas: command 0xffff88022740db00, task 0xffff88022fb08600, timed out: BLK_EH_NOT_HANDLED
[ 4577.066408] sas: Enter sas_scsi_recover_host
[ 4577.066411] sas: trying to find task 0xffff88022fb08600
[ 4577.066413] sas: sas_scsi_find_task: aborting task 0xffff88022fb08600
[ 4597.093674] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4597.093680] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4597.093683] sas: sas_scsi_find_task: querying task 0xffff88022fb08600
[ 4617.120971] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4617.120977] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4617.120980] sas: sas_scsi_find_task: task 0xffff88022fb08600 not at LU
[ 4617.120982] sas: task 0xffff88022fb08600 is not at LU: I_T recover
[ 4617.120985] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4617.121087] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4617.121090] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4617.121092] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4618.121001] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4618.121004] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4618.121006] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4618.121932] sas: broadcast received: 0
[ 4618.121938] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4619.120934] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4619.120938] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4619.120941] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4620.120868] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4620.120872] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4620.120876] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4621.120804] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4621.120808] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x300
[ 4621.120812] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4622.120721] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4622.120723] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4622.120726] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4623.120631] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4623.120634] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4623.120636] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4624.120542] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4624.120545] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4624.120547] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4625.122914] sas: Expander phy change count has changed
[ 4625.124524] sas: ex 5001b4d50900903f phy36 originated BROADCAST(CHANGE)
[ 4625.124578] sas: ex 5001b4d50900903f phy 0x24 broadcast flutter
[ 4625.124631] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4625.124684] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4625.124687] sas: broadcast received: 0
[ 4625.124691] sas: broadcast received: 0
[ 4625.124693] sas: broadcast received: 0
[ 4625.124694] sas: broadcast received: 0
[ 4625.124696] sas: broadcast received: 0
[ 4625.124698] sas: broadcast received: 0
[ 4625.124700] sas: broadcast received: 0
[ 4625.124702] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4625.124742] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4627.120676] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4627.120686] sas: I_T 5001b4d50900903d recovered
[ 4627.120694] sas: --- Exit sas_scsi_recover_host
[ 4658.071278] sas: command 0xffff8802270dc400, task 0xffff88023132fe00, timed out: BLK_EH_NOT_HANDLED
[ 4658.071319] sas: Enter sas_scsi_recover_host
[ 4658.071322] sas: trying to find task 0xffff88023132fe00
[ 4658.071324] sas: sas_scsi_find_task: aborting task 0xffff88023132fe00
[ 4678.098601] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4678.098606] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4678.098609] sas: sas_scsi_find_task: querying task 0xffff88023132fe00
[ 4698.125870] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4698.125875] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4698.125878] sas: sas_scsi_find_task: task 0xffff88023132fe00 not at LU
[ 4698.125881] sas: task 0xffff88023132fe00 is not at LU: I_T recover
[ 4698.125883] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4698.125963] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4698.125967] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4698.125969] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4699.125879] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4699.125882] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4699.125884] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4700.125791] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4700.125794] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4700.125796] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4701.125704] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4701.125707] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x300
[ 4701.125709] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4702.125617] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4702.125619] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4702.125621] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4703.125527] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4703.125530] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4703.125532] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4704.125439] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4704.125442] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4704.125444] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4705.125373] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4705.125377] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4705.125381] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4706.125926] sas: broadcast received: 0
[ 4706.125933] sas: broadcast received: 0
[ 4706.125937] sas: broadcast received: 0
[ 4706.125940] sas: broadcast received: 0
[ 4706.125944] sas: broadcast received: 0
[ 4706.125947] sas: broadcast received: 0
[ 4706.125950] sas: broadcast received: 0
[ 4706.125953] sas: broadcast received: 0
[ 4706.125956] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4706.127540] sas: Expander phy change count has changed
[ 4706.129165] sas: ex 5001b4d50900903f phy36 originated BROADCAST(CHANGE)
[ 4706.129218] sas: ex 5001b4d50900903f phy 0x24 broadcast flutter
[ 4706.129272] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4706.129324] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4707.125747] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4707.125756] sas: I_T 5001b4d50900903d recovered
[ 4707.125764] sas: --- Exit sas_scsi_recover_host
[ 4738.052377] sas: command 0xffff880231c5cc00, task 0xffff88023132f380, timed out: BLK_EH_NOT_HANDLED
[ 4738.052417] sas: Enter sas_scsi_recover_host
[ 4738.052419] sas: trying to find task 0xffff88023132f380
[ 4738.052422] sas: sas_scsi_find_task: aborting task 0xffff88023132f380
[ 4758.079673] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4758.079678] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4758.079681] sas: sas_scsi_find_task: querying task 0xffff88023132f380
[ 4778.106946] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4778.106951] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4778.106954] sas: sas_scsi_find_task: task 0xffff88023132f380 not at LU
[ 4778.106956] sas: task 0xffff88023132f380 is not at LU: I_T recover
[ 4778.106959] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4778.107038] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4778.107042] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4778.107044] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4779.106953] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4779.106956] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4779.106959] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4780.106865] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4780.106868] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4780.106870] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4781.106778] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4781.106780] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x300
[ 4781.106783] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4782.106690] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4782.106693] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4782.106695] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4783.106601] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4783.106603] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4783.106606] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4784.106513] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4784.106516] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4784.106518] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4785.106445] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4785.106449] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4785.106453] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4785.106604] sas: broadcast received: 0
[ 4785.106609] sas: broadcast received: 0
[ 4785.106612] sas: broadcast received: 0
[ 4785.106615] sas: broadcast received: 0
[ 4785.106618] sas: broadcast received: 0
[ 4785.106621] sas: broadcast received: 0
[ 4785.106624] sas: broadcast received: 0
[ 4785.106627] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4786.108686] sas: Expander phy change count has changed
[ 4786.110176] sas: ex 5001b4d50900903f phy36 originated BROADCAST(CHANGE)
[ 4786.110230] sas: ex 5001b4d50900903f phy 0x24 broadcast flutter
[ 4786.110283] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4786.110336] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4786.110339] sas: broadcast received: 0
[ 4786.110342] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4786.110384] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4787.106799] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4787.106808] sas: I_T 5001b4d50900903d recovered
[ 4787.106816] sas: --- Exit sas_scsi_recover_host
[ 4818.033446] sas: command 0xffff8802270dc900, task 0xffff88023132ec00, timed out: BLK_EH_NOT_HANDLED
[ 4818.033486] sas: Enter sas_scsi_recover_host
[ 4818.033489] sas: trying to find task 0xffff88023132ec00
[ 4818.033491] sas: sas_scsi_find_task: aborting task 0xffff88023132ec00
[ 4838.060758] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4838.060763] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4838.060766] sas: sas_scsi_find_task: querying task 0xffff88023132ec00
[ 4858.087957] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4858.087962] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4858.087965] sas: sas_scsi_find_task: task 0xffff88023132ec00 not at LU
[ 4858.087968] sas: task 0xffff88023132ec00 is not at LU: I_T recover
[ 4858.087970] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4858.088091] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4858.088096] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4858.088098] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4859.088008] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4859.088011] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4859.088014] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4859.088926] sas: broadcast received: 0
[ 4859.088932] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4860.087922] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4860.087927] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4860.087930] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4861.087839] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4861.087843] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4861.087846] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4862.087758] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4862.087762] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x300
[ 4862.087765] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4863.087674] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4863.087678] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4863.087682] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4864.087592] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4864.087597] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4864.087600] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4865.087509] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4865.087514] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4865.087517] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4866.089713] sas: Expander phy change count has changed
[ 4866.091376] sas: ex 5001b4d50900903f phy36 originated BROADCAST(CHANGE)
[ 4866.091430] sas: ex 5001b4d50900903f phy 0x24 broadcast flutter
[ 4866.091483] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4866.091535] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4866.091538] sas: broadcast received: 0
[ 4866.091542] sas: broadcast received: 0
[ 4866.091544] sas: broadcast received: 0
[ 4866.091546] sas: broadcast received: 0
[ 4866.091548] sas: broadcast received: 0
[ 4866.091550] sas: broadcast received: 0
[ 4866.091552] sas: broadcast received: 0
[ 4866.091554] sas: REVALIDATING DOMAIN on port 0, pid:100
[ 4866.091594] sas: done REVALIDATING DOMAIN on port 0, pid:100, res 0x0
[ 4868.088602] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4868.088612] sas: I_T 5001b4d50900903d recovered
[ 4868.088620] sas: --- Exit sas_scsi_recover_host
[ 4899.038272] sas: command 0xffff880227cb2f00, task 0xffff88023132ec00, timed out: BLK_EH_NOT_HANDLED
[ 4899.038307] sas: Enter sas_scsi_recover_host
[ 4899.038309] sas: trying to find task 0xffff88023132ec00
[ 4899.038312] sas: sas_scsi_find_task: aborting task 0xffff88023132ec00
[ 4919.065535] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[1] timeout.
[ 4919.065540] drivers/scsi/mvsas/mv_sas.c 1833:mvs_abort_task:rc= -5
[ 4919.065543] sas: sas_scsi_find_task: querying task 0xffff88023132ec00
[ 4939.092744] drivers/scsi/mvsas/mv_sas.c 1595:TMF task[80] timeout.
[ 4939.092749] drivers/scsi/mvsas/mv_sas.c 1747:mvs_query_task:rc= 0
[ 4939.092752] sas: sas_scsi_find_task: task 0xffff88023132ec00 not at LU
[ 4939.092754] sas: task 0xffff88023132ec00 is not at LU: I_T recover
[ 4939.092757] sas: I_T nexus reset for dev 5001b4d50900903d
[ 4939.092878] drivers/scsi/mvsas/mv_sas.c 2198:port 0 ctrl sts=0x122F00.
[ 4939.092882] drivers/scsi/mvsas/mv_sas.c 2200:Port 0 irq sts = 0x100
[ 4939.092885] drivers/scsi/mvsas/mv_sas.c 2282:port 0 broadcast change.
[ 4940.092794] drivers/scsi/mvsas/mv_sas.c 2198:port 1 ctrl sts=0x122F00.
[ 4940.092796] drivers/scsi/mvsas/mv_sas.c 2200:Port 1 irq sts = 0x100
[ 4940.092799] drivers/scsi/mvsas/mv_sas.c 2282:port 1 broadcast change.
[ 4940.092845] sas: broadcast received: 0
[ 4940.092852] sas: REVALIDATING DOMAIN on port 0, pid:5832
[ 4941.092706] drivers/scsi/mvsas/mv_sas.c 2198:port 2 ctrl sts=0x122F00.
[ 4941.092709] drivers/scsi/mvsas/mv_sas.c 2200:Port 2 irq sts = 0x100
[ 4941.092711] drivers/scsi/mvsas/mv_sas.c 2282:port 2 broadcast change.
[ 4942.092618] drivers/scsi/mvsas/mv_sas.c 2198:port 3 ctrl sts=0x122F00.
[ 4942.092621] drivers/scsi/mvsas/mv_sas.c 2200:Port 3 irq sts = 0x100
[ 4942.092623] drivers/scsi/mvsas/mv_sas.c 2282:port 3 broadcast change.
[ 4943.092530] drivers/scsi/mvsas/mv_sas.c 2198:port 4 ctrl sts=0x122F00.
[ 4943.092533] drivers/scsi/mvsas/mv_sas.c 2200:Port 4 irq sts = 0x300
[ 4943.092536] drivers/scsi/mvsas/mv_sas.c 2282:port 4 broadcast change.
[ 4944.092445] drivers/scsi/mvsas/mv_sas.c 2198:port 5 ctrl sts=0x122F00.
[ 4944.092448] drivers/scsi/mvsas/mv_sas.c 2200:Port 5 irq sts = 0x300
[ 4944.092450] drivers/scsi/mvsas/mv_sas.c 2282:port 5 broadcast change.
[ 4945.092356] drivers/scsi/mvsas/mv_sas.c 2198:port 6 ctrl sts=0x122F00.
[ 4945.092359] drivers/scsi/mvsas/mv_sas.c 2200:Port 6 irq sts = 0x300
[ 4945.092361] drivers/scsi/mvsas/mv_sas.c 2282:port 6 broadcast change.
[ 4946.092267] drivers/scsi/mvsas/mv_sas.c 2198:port 7 ctrl sts=0x122F00.
[ 4946.092269] drivers/scsi/mvsas/mv_sas.c 2200:Port 7 irq sts = 0x300
[ 4946.092271] drivers/scsi/mvsas/mv_sas.c 2282:port 7 broadcast change.
[ 4947.094085] sas: Expander phy change count has changed
[ 4947.095542] sas: ex 5001b4d50900903f phy36 originated BROADCAST(CHANGE)
[ 4947.095596] sas: ex 5001b4d50900903f phy 0x24 broadcast flutter
[ 4947.095649] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[ 4947.095702] sas: done REVALIDATING DOMAIN on port 0, pid:5832, res 0x0
[ 4947.095705] sas: broadcast received: 0
[ 4947.095709] sas: broadcast received: 0
[ 4947.095711] sas: broadcast received: 0
[ 4947.095713] sas: broadcast received: 0
[ 4947.095715] sas: broadcast received: 0
[ 4947.095716] sas: broadcast received: 0
[ 4947.095718] sas: broadcast received: 0
[ 4947.095720] sas: REVALIDATING DOMAIN on port 0, pid:5832
[ 4947.095760] sas: done REVALIDATING DOMAIN on port 0, pid:5832, res 0x0
[ 4949.092429] drivers/scsi/mvsas/mv_sas.c 1701:mvs_I_T_nexus_reset for device[1]:rc= 0
[ 4949.092438] sas: I_T 5001b4d50900903d recovered
[ 4949.092446] sas: --- Exit sas_scsi_recover_host
[ 6061.920064] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8000] tag[0], task [ffff88023132ef00]:
[ 6061.920070] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8001] tag[1], task [ffff880227119200]:
[ 6061.920074] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8002] tag[2], task [ffff880227119200]:
[ 6061.920078] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8003] tag[3], task [ffff880228612480]:
[ 6061.920082] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8004] tag[4], task [ffff88022723a600]:
[ 6061.920086] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8005] tag[5], task [ffff88022a2a2400]:
[ 6061.920090] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8006] tag[6], task [ffff88022fb08600]:
[ 6061.920094] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8007] tag[7], task [ffff88022a2a2400]:
[ 6061.920097] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8008] tag[8], task [ffff88022a2a2400]:
[ 6061.920101] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8009] tag[9], task [ffff88023132fe00]:
[ 6061.920105] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800a] tag[a], task [ffff88022a2e2c00]:
[ 6061.920109] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800b] tag[b], task [ffff88022a2e2c00]:
[ 6061.920113] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800c] tag[c], task [ffff88023132f380]:
[ 6061.920116] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800d] tag[d], task [ffff88022a2e3e00]:
[ 6061.920120] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800e] tag[e], task [ffff88022a2e3e00]:
[ 6061.920124] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800f] tag[f], task [ffff88023132ec00]:
[ 6061.920128] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8010] tag[10], task [ffff88022a2e3600]:
[ 6061.920132] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8011] tag[11], task [ffff88022a2e3600]:
[ 6061.920135] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8012] tag[12], task [ffff88023132ec00]:
[ 6061.920139] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8013] tag[13], task [ffff88022b1be800]:
[ 6061.920143] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8014] tag[14], task [ffff88022a2a2e00]:
[ 6061.920147] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8000] tag[0], task [ffff88023132ef00]:
[ 6061.920151] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8001] tag[1], task [ffff880227119200]:
[ 6061.920155] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8002] tag[2], task [ffff880227119200]:
[ 6061.920159] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8003] tag[3], task [ffff880228612480]:
[ 6061.920184] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8004] tag[4], task [ffff88022723a600]:
[ 6061.920188] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8005] tag[5], task [ffff88022a2a2400]:
[ 6061.920192] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8006] tag[6], task [ffff88022fb08600]:
[ 6061.920195] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8007] tag[7], task [ffff88022a2a2400]:
[ 6061.920199] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8008] tag[8], task [ffff88022a2a2400]:
[ 6061.920203] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8009] tag[9], task [ffff88023132fe00]:
[ 6061.920207] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800a] tag[a], task [ffff88022a2e2c00]:
[ 6061.920211] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800b] tag[b], task [ffff88022a2e2c00]:
[ 6061.920215] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800c] tag[c], task [ffff88023132f380]:
[ 6061.920220] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800d] tag[d], task [ffff88022a2e3e00]:
[ 6061.920224] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800e] tag[e], task [ffff88022a2e3e00]:
[ 6061.920229] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800f] tag[f], task [ffff88023132ec00]:
[ 6061.920233] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8010] tag[10], task [ffff88022a2e3600]:
[ 6061.920237] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8011] tag[11], task [ffff88022a2e3600]:
[ 6061.920242] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8012] tag[12], task [ffff88023132ec00]:
[ 6061.920246] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8013] tag[13], task [ffff88022b1be800]:
[ 6061.920251] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8014] tag[14], task [ffff88022a2a2e00]:
[ 6061.920257] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8000] tag[0], task [ffff88023132ef00]:
[ 6061.920261] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8001] tag[1], task [ffff880227119200]:
[ 6061.920266] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8002] tag[2], task [ffff880227119200]:
[ 6061.920270] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8003] tag[3], task [ffff880228612480]:
[ 6061.920275] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8004] tag[4], task [ffff88022723a600]:
[ 6061.920279] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8005] tag[5], task [ffff88022a2a2400]:
[ 6061.920283] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8006] tag[6], task [ffff88022fb08600]:
[ 6061.920288] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8007] tag[7], task [ffff88022a2a2400]:
[ 6061.920292] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8008] tag[8], task [ffff88022a2a2400]:
[ 6061.920297] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8009] tag[9], task [ffff88023132fe00]:
[ 6061.920301] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800a] tag[a], task [ffff88022a2e2c00]:
[ 6061.920306] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800b] tag[b], task [ffff88022a2e2c00]:
[ 6061.920310] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800c] tag[c], task [ffff88023132f380]:
[ 6061.920314] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800d] tag[d], task [ffff88022a2e3e00]:
[ 6061.920319] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800e] tag[e], task [ffff88022a2e3e00]:
[ 6061.920323] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800f] tag[f], task [ffff88023132ec00]:
[ 6061.920328] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8010] tag[10], task [ffff88022a2e3600]:
[ 6061.920332] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8011] tag[11], task [ffff88022a2e3600]:
[ 6061.920337] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8012] tag[12], task [ffff88023132ec00]:
[ 6061.920341] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8013] tag[13], task [ffff88022b1be800]:
[ 6061.920346] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8014] tag[14], task [ffff88022a2a2e00]:
[ 6061.920351] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8000] tag[0], task [ffff88023132ef00]:
[ 6061.920355] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8001] tag[1], task [ffff880227119200]:
[ 6061.920359] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8002] tag[2], task [ffff880227119200]:
[ 6061.920364] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8003] tag[3], task [ffff880228612480]:
[ 6061.920368] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8004] tag[4], task [ffff88022723a600]:
[ 6061.920372] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8005] tag[5], task [ffff88022a2a2400]:
[ 6061.920377] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8006] tag[6], task [ffff88022fb08600]:
[ 6061.920381] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8007] tag[7], task [ffff88022a2a2400]:
[ 6061.920386] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8008] tag[8], task [ffff88022a2a2400]:
[ 6061.920390] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8009] tag[9], task [ffff88023132fe00]:
[ 6061.920394] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800a] tag[a], task [ffff88022a2e2c00]:
[ 6061.920399] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800b] tag[b], task [ffff88022a2e2c00]:
[ 6061.920403] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800c] tag[c], task [ffff88023132f380]:
[ 6061.920408] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800d] tag[d], task [ffff88022a2e3e00]:
[ 6061.920412] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800e] tag[e], task [ffff88022a2e3e00]:
[ 6061.920417] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800f] tag[f], task [ffff88023132ec00]:
[ 6061.920421] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8010] tag[10], task [ffff88022a2e3600]:
[ 6061.920426] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8011] tag[11], task [ffff88022a2e3600]:
[ 6061.920430] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8012] tag[12], task [ffff88023132ec00]:
[ 6061.920435] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8013] tag[13], task [ffff88022b1be800]:
[ 6061.920439] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8014] tag[14], task [ffff88022a2a2e00]:
[ 6061.920445] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8000] tag[0], task [ffff88023132ef00]:
[ 6061.920449] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8001] tag[1], task [ffff880227119200]:
[ 6061.920454] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8002] tag[2], task [ffff880227119200]:
[ 6061.920458] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8003] tag[3], task [ffff880228612480]:
[ 6061.920463] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8004] tag[4], task [ffff88022723a600]:
[ 6061.920467] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8005] tag[5], task [ffff88022a2a2400]:
[ 6061.920472] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8006] tag[6], task [ffff88022fb08600]:
[ 6061.920476] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8007] tag[7], task [ffff88022a2a2400]:
[ 6061.920480] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8008] tag[8], task [ffff88022a2a2400]:
[ 6061.920485] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8009] tag[9], task [ffff88023132fe00]:
[ 6061.920489] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800a] tag[a], task [ffff88022a2e2c00]:
[ 6061.920494] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800b] tag[b], task [ffff88022a2e2c00]:
[ 6061.920498] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800c] tag[c], task [ffff88023132f380]:
[ 6061.920503] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800d] tag[d], task [ffff88022a2e3e00]:
[ 6061.920507] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800e] tag[e], task [ffff88022a2e3e00]:
[ 6061.920511] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800f] tag[f], task [ffff88023132ec00]:
[ 6061.920516] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8010] tag[10], task [ffff88022a2e3600]:
[ 6061.920520] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8011] tag[11], task [ffff88022a2e3600]:
[ 6061.920524] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8012] tag[12], task [ffff88023132ec00]:
[ 6061.920529] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8013] tag[13], task [ffff88022b1be800]:
[ 6061.920533] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8014] tag[14], task [ffff88022a2a2e00]:
[ 6061.920538] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8000] tag[0], task [ffff88023132ef00]:
[ 6061.920543] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8001] tag[1], task [ffff880227119200]:
[ 6061.920547] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8002] tag[2], task [ffff880227119200]:
[ 6061.920551] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8003] tag[3], task [ffff880228612480]:
[ 6061.920556] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8004] tag[4], task [ffff88022723a600]:
[ 6061.920560] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8005] tag[5], task [ffff88022a2a2400]:
[ 6061.920565] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8006] tag[6], task [ffff88022fb08600]:
[ 6061.920569] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8007] tag[7], task [ffff88022a2a2400]:
[ 6061.920574] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8008] tag[8], task [ffff88022a2a2400]:
[ 6061.920578] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8009] tag[9], task [ffff88023132fe00]:
[ 6061.920582] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800a] tag[a], task [ffff88022a2e2c00]:
[ 6061.920587] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800b] tag[b], task [ffff88022a2e2c00]:
[ 6061.920591] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800c] tag[c], task [ffff88023132f380]:
[ 6061.920596] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800d] tag[d], task [ffff88022a2e3e00]:
[ 6061.920601] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800e] tag[e], task [ffff88022a2e3e00]:
[ 6061.920605] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb800f] tag[f], task [ffff88023132ec00]:
[ 6061.920610] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8010] tag[10], task [ffff88022a2e3600]:
[ 6061.920614] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8011] tag[11], task [ffff88022a2e3600]:
[ 6061.920619] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8012] tag[12], task [ffff88023132ec00]:
[ 6061.920623] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8013] tag[13], task [ffff88022b1be800]:
[ 6061.920628] drivers/scsi/mvsas/mv_sas.c 2084:Release slot [e8bb8014] tag[14], task [ffff88022a2a2e00]:
[ 6061.931218] drivers/scsi/mvsas/mv_sas.c 1503:found dev[1:1] is gone.
[ 6061.938218] drivers/scsi/mvsas/mv_sas.c 1503:found dev[0:2] is gone.
[ 6061.944283] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff8802277ee000 busy
[ 6061.944287] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022a4c2000 busy
[ 6061.944291] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880232576000 busy
[ 6061.944294] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880228154000 busy
[ 6061.944297] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff8802299e2000 busy
[ 6061.944300] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022889e000 busy
[ 6061.944303] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022723c000 busy
[ 6061.944306] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880227236000 busy
[ 6061.944309] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022ae8a000 busy
[ 6061.944311] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022774a000 busy
[ 6061.944314] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022a5d2000 busy
[ 6061.944317] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022ad66000 busy
[ 6061.944320] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022a5c4000 busy
[ 6061.944323] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880228616000 busy
[ 6061.944326] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880233152000 busy
[ 6061.944329] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022723a000 busy
[ 6061.944332] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022715c000 busy
[ 6061.944335] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880228610000 busy
[ 6061.944338] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff88022860a000 busy
[ 6061.944341] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880227a08000 busy
[ 6061.944344] mvsas 0000:02:00.0: dma_pool_destroy mvs_dma_pool0, ffff880228614000 busy
[ 6061.944517] mvsas 0000:02:00.0: PCI INT A disabled

--------------010207080407090204090104
Content-Type: text/plain;
 name="mvsas-3.3.8.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mvsas-3.3.8.txt"

[   11.089124] mvsas 0000:04:00.0: mvsas: driver version 0.8.16
[   11.089295] mvsas 0000:04:00.0: mvsas: PCI-E x8, Bandwidth Usage: 5.0 Gbps
[   13.866345] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   13.866349] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   13.946142] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 0 2000420.
[   13.956117] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 1 d5b40150.
[   13.966092] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 2 3f900009.
[   13.976066] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 3 d5b40150.
[   13.986041] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 4 3f900009.
[   13.996015] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 5 11b.
[   14.005990] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 0 atta frame 6 0.
[   14.015964] drivers/scsi/mvsas/mv_sas.c 1181:phy 0 attach dev info is 1b040002
[   14.015965] drivers/scsi/mvsas/mv_sas.c 1183:phy 0 attach sas addr is 3f900009d5b40150
[   14.116627] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   14.116631] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   14.196422] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 0 2000420.
[   14.206397] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 1 d5b40150.
[   14.216372] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 2 3f900009.
[   14.226346] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 3 d5b40150.
[   14.236321] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 4 3f900009.
[   14.246296] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 5 11a.
[   14.256270] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 1 atta frame 6 0.
[   14.266244] drivers/scsi/mvsas/mv_sas.c 1181:phy 1 attach dev info is 1a040002
[   14.266249] drivers/scsi/mvsas/mv_sas.c 1183:phy 1 attach sas addr is 3f900009d5b40150
[   14.366916] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   14.366919] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   14.446707] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 0 2000420.
[   14.456682] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 1 d5b40150.
[   14.466656] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 2 3f900009.
[   14.476630] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 3 d5b40150.
[   14.486605] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 4 3f900009.
[   14.496579] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 5 119.
[   14.506554] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 2 atta frame 6 0.
[   14.516528] drivers/scsi/mvsas/mv_sas.c 1181:phy 2 attach dev info is 19040002
[   14.516529] drivers/scsi/mvsas/mv_sas.c 1183:phy 2 attach sas addr is 3f900009d5b40150
[   14.617275] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   14.617279] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   14.697066] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 0 2000420.
[   14.707041] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 1 d5b40150.
[   14.717015] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 2 3f900009.
[   14.726990] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 3 d5b40150.
[   14.736964] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 4 3f900009.
[   14.746939] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 5 118.
[   14.756913] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 3 atta frame 6 0.
[   14.766887] drivers/scsi/mvsas/mv_sas.c 1181:phy 3 attach dev info is 18040002
[   14.766888] drivers/scsi/mvsas/mv_sas.c 1183:phy 3 attach sas addr is 3f900009d5b40150
[   17.543786] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   17.543789] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   17.623581] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 0 2000420.
[   17.633556] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 1 d5b40150.
[   17.643530] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 2 3f900009.
[   17.653505] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 3 d5b40150.
[   17.663480] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 4 3f900009.
[   17.673454] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 5 117.
[   17.683429] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 4 atta frame 6 0.
[   17.693403] drivers/scsi/mvsas/mv_sas.c 1181:phy 4 attach dev info is 17040002
[   17.693404] drivers/scsi/mvsas/mv_sas.c 1183:phy 4 attach sas addr is 3f900009d5b40150
[   17.794069] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   17.794072] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   17.873865] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 0 2000420.
[   17.883839] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 1 d5b40150.
[   17.893814] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 2 3f900009.
[   17.903789] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 3 d5b40150.
[   17.913763] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 4 3f900009.
[   17.923738] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 5 116.
[   17.933712] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 5 atta frame 6 0.
[   17.943686] drivers/scsi/mvsas/mv_sas.c 1181:phy 5 attach dev info is 16040002
[   17.943688] drivers/scsi/mvsas/mv_sas.c 1183:phy 5 attach sas addr is 3f900009d5b40150
[   18.044350] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   18.044354] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   18.124148] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 0 2000420.
[   18.134122] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 1 d5b40150.
[   18.144097] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 2 3f900009.
[   18.154072] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 3 d5b40150.
[   18.164046] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 4 3f900009.
[   18.174021] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 5 115.
[   18.183995] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 6 atta frame 6 0.
[   18.193969] drivers/scsi/mvsas/mv_sas.c 1181:phy 6 attach dev info is 15040002
[   18.193971] drivers/scsi/mvsas/mv_sas.c 1183:phy 6 attach sas addr is 3f900009d5b40150
[   18.294638] drivers/scsi/mvsas/mv_94xx.c 838:get all reg link rate is 0x122f00
[   18.294641] drivers/scsi/mvsas/mv_94xx.c 843:get link rate is 10
[   18.374433] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 0 2000420.
[   18.384408] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 1 d5b40150.
[   18.394383] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 2 3f900009.
[   18.404357] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 3 d5b40150.
[   18.414331] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 4 3f900009.
[   18.424306] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 5 114.
[   18.434280] drivers/scsi/mvsas/mv_94xx.c 801:94xx phy 7 atta frame 6 0.
[   18.444254] drivers/scsi/mvsas/mv_sas.c 1181:phy 7 attach dev info is 14040002
[   18.444256] drivers/scsi/mvsas/mv_sas.c 1183:phy 7 attach sas addr is 3f900009d5b40150
[   18.444264] scsi21 : mvsas
[   18.444581] drivers/scsi/mvsas/mv_sas.c 277:phy 0 byte dmaded.
[   18.444583] drivers/scsi/mvsas/mv_sas.c 277:phy 1 byte dmaded.
[   18.444584] drivers/scsi/mvsas/mv_sas.c 277:phy 2 byte dmaded.
[   18.444586] drivers/scsi/mvsas/mv_sas.c 277:phy 3 byte dmaded.
[   18.444587] drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
[   18.444589] drivers/scsi/mvsas/mv_sas.c 277:phy 5 byte dmaded.
[   18.444590] drivers/scsi/mvsas/mv_sas.c 277:phy 6 byte dmaded.
[   18.444591] drivers/scsi/mvsas/mv_sas.c 277:phy 7 byte dmaded.
[   18.444641] sas: phy-21:0 added to port-21:0, phy_mask:0x1 (5001b4d50900903f)
[   18.444644] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map 1
[   18.454635] sas: phy1 matched wide port0
[   18.454638] sas: phy-21:1 added to port-21:0, phy_mask:0x3 (5001b4d50900903f)
[   18.454640] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map 3
[   18.474589] sas: phy2 matched wide port0
[   18.474592] sas: phy-21:2 added to port-21:0, phy_mask:0x7 (5001b4d50900903f)
[   18.474594] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map 7
[   18.504516] sas: phy3 matched wide port0
[   18.504519] sas: phy-21:3 added to port-21:0, phy_mask:0xf (5001b4d50900903f)
[   18.504521] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map f
[   18.544415] sas: phy0 matched wide port0
[   18.544419] sas: phy-21:4 added to port-21:0, phy_mask:0xf (5001b4d50900903f)
[   18.544421] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map f
[   18.584316] sas: phy1 matched wide port0
[   18.584319] sas: phy-21:5 added to port-21:0, phy_mask:0xf (5001b4d50900903f)
[   18.584321] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map f
[   18.624216] sas: phy2 matched wide port0
[   18.624219] sas: phy-21:6 added to port-21:0, phy_mask:0xf (5001b4d50900903f)
[   18.624221] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map f
[   18.664115] sas: phy3 matched wide port0
[   18.664119] sas: phy-21:7 added to port-21:0, phy_mask:0xf (5001b4d50900903f)
[   18.664121] drivers/scsi/mvsas/mv_sas.c 1218:set wide port phy map f
[   18.704020] sas: DOING DISCOVERY on port 0, pid:1286
[   18.704289] sas: ex 5001b4d50900903f phy00:T attached: 5001b4d509009000
[   18.704425] sas: ex 5001b4d50900903f phy01:T attached: 5001b4d509009001
[   18.704531] sas: ex 5001b4d50900903f phy02:T attached: 5001b4d509009002
[   18.704702] sas: ex 5001b4d50900903f phy03:T attached: 5001b4d509009003
[   18.704897] sas: ex 5001b4d50900903f phy04:D attached: 0000000000000000
[   18.705106] sas: ex 5001b4d50900903f phy05:D attached: 0000000000000000
[   18.705175] sas: ex 5001b4d50900903f phy06:D attached: 0000000000000000
[   18.705246] sas: ex 5001b4d50900903f phy07:D attached: 0000000000000000
[   18.705305] sas: ex 5001b4d50900903f phy08:D attached: 0000000000000000
[   18.705381] sas: ex 5001b4d50900903f phy09:D attached: 0000000000000000
[   18.705473] sas: ex 5001b4d50900903f phy10:D attached: 0000000000000000
[   18.705644] sas: ex 5001b4d50900903f phy11:D attached: 0000000000000000
[   18.705745] sas: ex 5001b4d50900903f phy12:D attached: 0000000000000000
[   18.705797] sas: ex 5001b4d50900903f phy13:D attached: 0000000000000000
[   18.705843] sas: ex 5001b4d50900903f phy14:D attached: 0000000000000000
[   18.705897] sas: ex 5001b4d50900903f phy15:D attached: 0000000000000000
[   18.706018] sas: ex 5001b4d50900903f phy16:T attached: 0000000000000000
[   18.706145] sas: ex 5001b4d50900903f phy17:T attached: 0000000000000000
[   18.706238] sas: ex 5001b4d50900903f phy18:T attached: 0000000000000000
[   18.706351] sas: ex 5001b4d50900903f phy19:T attached: 0000000000000000
[   18.706434] sas: ex 5001b4d50900903f phy20:D attached: 0000000000000000
[   18.706531] sas: ex 5001b4d50900903f phy21:D attached: 0000000000000000
[   18.706616] sas: ex 5001b4d50900903f phy22:D attached: 0000000000000000
[   18.706705] sas: ex 5001b4d50900903f phy23:D attached: 0000000000000000
[   18.706836] sas: ex 5001b4d50900903f phy24:S attached: 5005043011ab0000
[   18.706960] sas: ex 5001b4d50900903f phy25:S attached: 5005043011ab0000
[   18.707047] sas: ex 5001b4d50900903f phy26:S attached: 5005043011ab0000
[   18.707138] sas: ex 5001b4d50900903f phy27:S attached: 5005043011ab0000
[   18.707217] sas: ex 5001b4d50900903f phy28:T attached: 0000000000000000
[   18.707294] sas: ex 5001b4d50900903f phy29:T attached: 0000000000000000
[   18.707376] sas: ex 5001b4d50900903f phy30:T attached: 0000000000000000
[   18.707453] sas: ex 5001b4d50900903f phy31:T attached: 0000000000000000
[   18.707508] sas: ex 5001b4d50900903f phy32:D attached: 0000000000000000
[   18.707605] sas: ex 5001b4d50900903f phy33:D attached: 0000000000000000
[   18.707684] sas: ex 5001b4d50900903f phy34:D attached: 0000000000000000
[   18.707740] sas: ex 5001b4d50900903f phy35:D attached: 0000000000000000
[   18.707814] sas: ex 5001b4d50900903f phy36:D attached: 5001b4d50900903d
[   18.707886] sas: ex 5001b4d50900903f phy37:D attached: 0000000000000000
[   18.707905] sas: target proto 0x0 at 5001b4d50900903f:0x0 not handled
[   18.707930] sas: target proto 0x0 at 5001b4d50900903f:0x1 not handled
[   18.707950] sas: target proto 0x0 at 5001b4d50900903f:0x2 not handled
[   18.707980] sas: target proto 0x0 at 5001b4d50900903f:0x3 not handled
[   39.902713] sas: command 0xffff88031297fac0, task 0xffff8803117d9e00, timed out: BLK_EH_NOT_HANDLED
[   39.902743] sas: Enter sas_scsi_recover_host
[   39.902747] sas: trying to find task 0xffff8803117d9e00
[   39.902749] sas: sas_scsi_find_task: aborting task 0xffff8803117d9e00
[   59.877674] drivers/scsi/mvsas/mv_sas.c 1423:TMF task[1] timeout.
[   59.877678] drivers/scsi/mvsas/mv_sas.c 1647:mvs_abort_task:rc= 5
[   59.877681] sas: sas_scsi_find_task: querying task 0xffff8803117d9e00
[   79.852391] drivers/scsi/mvsas/mv_sas.c 1423:TMF task[80] timeout.
[   79.852395] drivers/scsi/mvsas/mv_sas.c 1569:mvs_query_task:rc= 5
[   79.852398] sas: sas_scsi_find_task: task 0xffff8803117d9e00 failed to abort
[   79.852400] sas: task 0xffff8803117d9e00 is not at LU: I_T recover
[   79.852402] sas: I_T nexus reset for dev 5001b4d50900903d
[   79.852502] drivers/scsi/mvsas/mv_sas.c 2067:phy 0 ctrl sts=0x00122F00.
[   79.852505] drivers/scsi/mvsas/mv_sas.c 2069:phy 0 irq sts = 0x00000100
[   79.852508] drivers/scsi/mvsas/mv_sas.c 2147:phy 0 broadcast change.
[   79.852513] drivers/scsi/mvsas/mv_sas.c 2067:phy 1 ctrl sts=0x00122F00.
[   79.852515] drivers/scsi/mvsas/mv_sas.c 2069:phy 1 irq sts = 0x00000100
[   79.852517] drivers/scsi/mvsas/mv_sas.c 2147:phy 1 broadcast change.
[   79.852521] drivers/scsi/mvsas/mv_sas.c 2067:phy 2 ctrl sts=0x00122F00.
[   79.852524] drivers/scsi/mvsas/mv_sas.c 2069:phy 2 irq sts = 0x00000100
[   79.852526] drivers/scsi/mvsas/mv_sas.c 2147:phy 2 broadcast change.
[   79.852530] drivers/scsi/mvsas/mv_sas.c 2067:phy 3 ctrl sts=0x00122F00.
[   79.852533] drivers/scsi/mvsas/mv_sas.c 2069:phy 3 irq sts = 0x00000100
[   79.852535] drivers/scsi/mvsas/mv_sas.c 2147:phy 3 broadcast change.
[   79.852541] drivers/scsi/mvsas/mv_sas.c 2067:phy 4 ctrl sts=0x00122F00.
[   79.852543] drivers/scsi/mvsas/mv_sas.c 2069:phy 4 irq sts = 0x00000300
[   79.852545] drivers/scsi/mvsas/mv_sas.c 2147:phy 4 broadcast change.
[   79.852549] drivers/scsi/mvsas/mv_sas.c 2067:phy 5 ctrl sts=0x00122F00.
[   79.852552] drivers/scsi/mvsas/mv_sas.c 2069:phy 5 irq sts = 0x00000300
[   79.852554] drivers/scsi/mvsas/mv_sas.c 2147:phy 5 broadcast change.
[   79.852558] drivers/scsi/mvsas/mv_sas.c 2067:phy 6 ctrl sts=0x00122F00.
[   79.852561] drivers/scsi/mvsas/mv_sas.c 2069:phy 6 irq sts = 0x00000300
[   79.852563] drivers/scsi/mvsas/mv_sas.c 2147:phy 6 broadcast change.
[   79.852567] drivers/scsi/mvsas/mv_sas.c 2067:phy 7 ctrl sts=0x00122F00.
[   79.852570] drivers/scsi/mvsas/mv_sas.c 2069:phy 7 irq sts = 0x00000300
[   79.852572] drivers/scsi/mvsas/mv_sas.c 2147:phy 7 broadcast change.
[   81.847604] drivers/scsi/mvsas/mv_sas.c 1527:mvs_I_T_nexus_reset for device[1]:rc= 0
[   81.847710] BUG: unable to handle kernel paging request at 0000000300000066
[   81.848000] IP: [<ffffffffa014a3fe>] mvs_lu_reset+0x6e/0xb0 [mvsas]
[   81.848177] PGD 0 
[   81.848334] Oops: 0000 [#1] SMP 
[   81.848532] CPU 0 
[   81.848575] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat iptable_filter it87 hwmon_vid coretemp fuse acpi_cpufreq mperf snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec mvsas snd_pcm sr_mod usb_storage i2c_i801 cdrom snd_page_alloc e1000e r8169 snd_timer libsas mii xhci_hcd pata_jmicron snd scsi_transport_sas
[   81.850348] 
[   81.850468] Pid: 1745, comm: scsi_eh_21 Not tainted 3.3.8 #1 Gigabyte Technology Co., Ltd. X58A-UD3R/X58A-UD3R
[   81.850802] RIP: 0010:[<ffffffffa014a3fe>]  [<ffffffffa014a3fe>] mvs_lu_reset+0x6e/0xb0 [mvsas]
[   81.851061] RSP: 0018:ffff88030ffb9d20  EFLAGS: 00010246
[   81.851192] RAX: 0000000000000246 RBX: 0000000100000000 RCX: ffff88030ffc1878
[   81.851329] RDX: 000000000000002a RSI: 0000000000000246 RDI: ffff88030ffc0008
[   81.851466] RBP: ffff88030ffb9d70 R08: 0000000000000004 R09: 0000000000000000
[   81.851604] R10: 2e8ba2e8ba2e8ba3 R11: ffff8803131c54c0 R12: 0000000300000002
[   81.851741] R13: ffff880311761200 R14: ffff88030ffc0000 R15: ffff88030ffc0008
[   81.851879] FS:  0000000000000000(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
[   81.852096] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.852229] CR2: 0000000300000066 CR3: 0000000001805000 CR4: 00000000000006f0
[   81.852365] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.852503] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.852640] Process scsi_eh_21 (pid: 1745, threadinfo ffff88030ffb8000, task ffff880311d52050)
[   81.852858] Stack:
[   81.852978]  ffff88030ffb9d60 0000000000000246 0000000100000000 0000000800000002
[   81.853339]  0000000100000000 0000000000002003 ffff880311761200 ffff8803118bd000
[   81.853700]  ffff88031297fac0 ffff8803118bd000 ffff88030ffb9da0 ffffffffa0060940
[   81.854062] Call Trace:
[   81.854189]  [<ffffffffa0060940>] sas_eh_device_reset_handler+0x60/0x90 [libsas]
[   81.854407]  [<ffffffffa006147a>] sas_scsi_recover_host+0x34a/0x8a0 [libsas]
[   81.854548]  [<ffffffff81311328>] scsi_error_handler+0xe8/0x440
[   81.854685]  [<ffffffff810562fd>] ? default_wake_function+0xd/0x10
[   81.854820]  [<ffffffff81311240>] ? scsi_eh_get_sense+0x110/0x110
[   81.854956]  [<ffffffff8104d01e>] kthread+0x8e/0xa0
[   81.855088]  [<ffffffff814a4514>] kernel_thread_helper+0x4/0x10
[   81.855223]  [<ffffffff8104cf90>] ? kthread_freezable_should_stop+0x60/0x60
[   81.855360]  [<ffffffff814a4510>] ? gs_change+0xb/0xb
[   81.855490] Code: 2a 4d 8d 7e 08 4c 89 ff e8 e0 84 35 e1 4c 89 ee 4c 89 f7 48 89 45 b8 e8 71 fe ff ff 48 8b 45 b8 4c 89 ff 48 89 c6 e8 22 85 35 e1 <45> 8b 44 24 64 41 89 d9 48 c7 c1 c8 fc 14 a0 ba e6 05 00 00 48 
[   81.858206] RIP  [<ffffffffa014a3fe>] mvs_lu_reset+0x6e/0xb0 [mvsas]
[   81.858380]  RSP <ffff88030ffb9d20>
[   81.858505] CR2: 0000000300000066
[   81.858685] ---[ end trace acc151d35eb26c67 ]---
[   81.858836] drivers/scsi/mvsas/mv_sas.c 2018:phy0 Got Broadcast Change
[   81.858975] drivers/scsi/mvsas/mv_sas.c 2018:phy1 Got Broadcast Change
[   81.859115] drivers/scsi/mvsas/mv_sas.c 2018:phy2 Got Broadcast Change
[   81.859254] drivers/scsi/mvsas/mv_sas.c 2018:phy3 Got Broadcast Change
[   81.859257] drivers/scsi/mvsas/mv_sas.c 2018:phy0 Got Broadcast Change
[   81.859259] drivers/scsi/mvsas/mv_sas.c 2018:phy1 Got Broadcast Change
[   81.859262] drivers/scsi/mvsas/mv_sas.c 2018:phy2 Got Broadcast Change
[   81.859264] drivers/scsi/mvsas/mv_sas.c 2018:phy3 Got Broadcast Change

--------------010207080407090204090104--
