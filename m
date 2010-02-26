From: Bron Gondwana <brong@fastmail.fm>
Subject: mptscsih errors talking to Areca based SCSI-attached unit
Date: Fri, 26 Feb 2010 23:55:14 +1100
Message-ID: <20100226125514.GA6649@brong.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from forward1.smtp.messagingengine.com ([66.111.4.223]:51402 "EHLO
	forward1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936036Ab0BZNFY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2010 08:05:24 -0500
Received: from launde (vpn58.internal [10.203.0.58])
	by gateway1.messagingengine.com (Postfix) with ESMTP id E019CE27D9
	for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2010 07:55:15 -0500 (EST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I've been spending a couple of days trying to track down some issues
we're having with our SCSI attached storage units.  We have IBM
servers with the following card:

14:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
14:08.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)

A dual channel LSI card.  Each channel has a cable going to a single
external 12 drive unit - FT-1202-U3SA.  These are Areca based SATA
units with a SCSI interface.

One machine has been having troubles, which we _think_ are down to
timeout issues on the drive.  We've replaced the LSI card, the
cable and the controller unit in the external RAID device - the 
problems still seem to be following one particular RAID1 pair of
300GB VelociRaptor drives: WDC WD3000HLFS-01G6U0.

Anyway - we suspect one of the drives may have issues causing it
to take long timeouts trying to read from bad blocks.  We have
seen similar behaviour on multiple servers - but particularly
badly on this one - to the point where it's currently too unstable
for production use.  We're running replica data on it, which means
there's still enough IO to trigger an event every couple of hours.

We're running a 2.6.32.9 kernel with one tiny patch (to printk some
tracing for every SIGKILL that occurs - trying to track down the
culprit in another rare bug!)  I can post the config if anyone
thinks it will help.

Here's the debug trace.  /proc/sys/dev/scsi/logging_level is 63.
I start a couple of seconds before the event and go to a couple
of seconds after:

[23332.504032] scsi_block_when_processing_errors: rtn: 1
[23332.504067] scsi_block_when_processing_errors: rtn: 1
[23334.504039] scsi_block_when_processing_errors: rtn: 1
[23334.504075] scsi_block_when_processing_errors: rtn: 1
[23335.820008] Waking error handler thread
[23335.820039] Error handler scsi_eh_1 waking up
[23335.820079] sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 64
[23335.820111] sd 1:0:0:2: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 16
[23335.820142] sd 1:0:0:3: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
[23335.820172] sd 1:0:0:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
[23335.820202] sd 1:0:0:5: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 36
[23335.820236] sd 1:0:1:3: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
[23335.820266] sd 1:0:1:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 5
[23335.820297] Total of 127 commands on 7 devices require eh work
[23335.820325] scsi_eh_1: aborting cmd:0xffff8807a367f100
[23335.820352] mptscsih: ioc0: attempting task abort! (sc=ffff8807a367f100)
[23335.820381] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 07 c6 3b 0e 00 00 08 00
[23336.194779] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a367f100)
[23336.195141] scsi_eh_done scmd: ffff8807a367f100 result: 0
[23336.195172] scsi_send_eh_cmnd: scmd: ffff8807a367f100, timeleft: 2500
[23336.195207] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23336.195233] scsi_eh_tur: scmd ffff8807a367f100 rtn 2002
[23336.195259] scsi_eh_1: aborting cmd:0xffff8807af46cb00
[23336.195285] mptscsih: ioc0: attempting task abort! (sc=ffff8807af46cb00)
[23336.195313] sd 1:0:1:3: [sdk] CDB: Write(10): 2a 00 5a c2 57 fc 00 00 08 00
[23336.504026] scsi_block_when_processing_errors: rtn: 1
[23336.504053] scsi_block_when_processing_errors: rtn: 1

[.. snip heaps ..]

[23361.763530] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23361.763557] scsi_eh_tur: scmd ffff8807bea97b00 rtn 2002
[23361.763583] scsi_eh_1: aborting cmd:0xffff8807a3610100
[23361.763608] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3610100)
[23361.763637] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 0c 6d 0e 07 00 00 08 00
[23361.902681] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427818] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427851] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found

[.. snip another 50 or so ..]

[23362.429522] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429552] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429582] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.430207] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3610100)
[23362.430569] scsi_eh_done scmd: ffff8807a3610100 result: 0
[23362.430601] scsi_send_eh_cmnd: scmd: ffff8807a3610100, timeleft: 2500
[23362.430634] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.430661] scsi_eh_tur: scmd ffff8807a3610100 rtn 2002
[23362.430686] scsi_eh_1: aborting cmd:0xffff8807a3610b00
[23362.430712] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3610b00)
[23362.430741] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 0d 0c 41 0f 00 00 08 00
[23362.430793] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3610b00)
[23362.434200] scsi_send_eh_cmnd: scmd: ffff88072fd1b900, timeleft: 2500

[.. snip more ..]

[23362.463252] sd 1:0:0:3: [sde] CDB: Write(10): 2a 00 e6 20 96 a4 00 00 30 00
[23362.463323] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880540767800)
[23362.463500] scsi_eh_done scmd: ffff880540767800 result: 0
[23362.463531] scsi_send_eh_cmnd: scmd: ffff880540767800, timeleft: 2500
[23362.463559] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.463591] scsi_eh_tur: scmd ffff880540767800 rtn 2002
[23362.463627] scsi_eh_1: flush retry cmd: ffff8807a367f100
[23362.463665] scsi_eh_1: flush retry cmd: ffff8807af46cb00

[.. snip ..]

[23362.468745] scsi_eh_1: flush retry cmd: ffff8807a362c900
[23362.468771] scsi_eh_1: flush retry cmd: ffff8807a3454c00
[23362.468798] scsi_eh_1: flush retry cmd: ffff880540767800
[23362.468828] scsi_restart_operations: waking up host to restart
[23362.469052] Error handler scsi_eh_1 sleeping
[23362.504058] scsi_block_when_processing_errors: rtn: 1
[23362.504098] scsi_block_when_processing_errors: rtn: 1


The "block_when_processing_errors" lines happen every 2 seconds and
seem to not be related to anything.

I'll attach the full log.  The interesting bit to me is that there
are 127 outstanding items in the queue across all devices, pretty
much all the time.  We're running reiserfs (v3) on all the devices.

The RAID layout looks like this:

Raid Set # 00	Ch01 	sata10a1m (0&1/0/0)	Normal	100.0GB
		Ch02 	sata10a2m (0&1/0/2)	Normal	100.0GB
 	 		sata10a3m (0&1/0/4)	Normal	100.0GB
Raid Set # 01	Ch07 	sata10b1m (0&1/1/0)	Normal	100.0GB
 		Ch08 	sata10b2m (0&1/1/2)	Normal	100.0GB
 	 		sata10b3m (0&1/1/4)	Normal	100.0GB
Raid Set # 02	Ch03 	sata10a1d (0&1/0/1)	Normal	2000.0GB
 		Ch04 	sata10a2d (0&1/0/3)	Normal	2000.0GB
 		Ch05 	sata10a3d (0&1/0/5)	Normal	2000.0GB
 		Ch06 	 	 	 
Raid Set # 03	Ch09 	sata10b1d (0&1/1/1)	Normal	2000.0GB
 		Ch10 	sata10b2d (0&1/1/3)	Normal	2000.0GB
 		Ch11 	sata10b3d (0&1/1/5)	Normal	2000.0GB
 		Ch12 	 	 	 

So each RAID1 (2 x 300GB drives) and each RAID5 (4 x 2TB drives)
is split into three virtual "drives" to present to the SCSI
connection, keeping us to the 2TB limit.  These are then further
partitioned into 4 x 25GB and 500GB partitions for separate 
filesystems so any one fsck doesn't take forever!

There's also a ServeRaid8k device onboard in the server with its
own RAID1 that hosts the operating system and logs.  It's sda,
so the first drive (sata10a1m) is sdb, sata10a1d is sdc, sata10a2m
is sdd, etc.  So sdb, sdd and sdf are all actually the same
physical disks.  These are our suspects.

My question (if you've read this far!  Thanks) is what's triggering
this complete flush of ALL IO to the device, and also triggering
a complete SCSI renegotiation the first time it happens (lost in 
the mists of dmesg now) - not only on this device but on the other
unit which is attached to the other channel on the card.

Is this likely to be related to the 127 outstanding items (queue full)
there?  I notice sd 1:0:0:0: (sdb) has a full 64 items in the queue
as well, which is the maximum queue size according to the code.

Thanks,

Bron.

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[23335.820297] Total of 127 commands on 7 devices require eh work
[23335.820325] scsi_eh_1: aborting cmd:0xffff8807a367f100
[23335.820352] mptscsih: ioc0: attempting task abort! (sc=ffff8807a367f100)
[23335.820381] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 07 c6 3b 0e 00 00 08 00
[23336.194779] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a367f100)
[23336.195141] scsi_eh_done scmd: ffff8807a367f100 result: 0
[23336.195172] scsi_send_eh_cmnd: scmd: ffff8807a367f100, timeleft: 2500
[23336.195207] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23336.195233] scsi_eh_tur: scmd ffff8807a367f100 rtn 2002
[23336.195259] scsi_eh_1: aborting cmd:0xffff8807af46cb00
[23336.195285] mptscsih: ioc0: attempting task abort! (sc=ffff8807af46cb00)
[23336.195313] sd 1:0:1:3: [sdk] CDB: Write(10): 2a 00 5a c2 57 fc 00 00 08 00
[23336.504026] scsi_block_when_processing_errors: rtn: 1
[23336.504053] scsi_block_when_processing_errors: rtn: 1
[23336.571070] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af46cb00)
[23336.571428] scsi_eh_done scmd: ffff8807af46cb00 result: 0
[23336.571460] scsi_send_eh_cmnd: scmd: ffff8807af46cb00, timeleft: 2500
[23336.571493] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23336.571520] scsi_eh_tur: scmd ffff8807af46cb00 rtn 2002
[23336.571546] scsi_eh_1: aborting cmd:0xffff8806e5de1700
[23336.571572] mptscsih: ioc0: attempting task abort! (sc=ffff8806e5de1700)
[23336.571601] sd 1:0:0:3: [sde] CDB: Write(10): 2a 00 0e ed f3 0f 00 00 20 00
[23336.946737] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806e5de1700)
[23336.947096] scsi_eh_done scmd: ffff8806e5de1700 result: 0
[23336.947128] scsi_send_eh_cmnd: scmd: ffff8806e5de1700, timeleft: 2500
[23336.947162] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23336.947189] scsi_eh_tur: scmd ffff8806e5de1700 rtn 2002
[23336.947214] scsi_eh_1: aborting cmd:0xffff8807a35fd600
[23336.947240] mptscsih: ioc0: attempting task abort! (sc=ffff8807a35fd600)
[23336.947269] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 01 00 cf 00 00 08 00
[23337.322726] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a35fd600)
[23337.323085] scsi_eh_done scmd: ffff8807a35fd600 result: 0
[23337.323116] scsi_send_eh_cmnd: scmd: ffff8807a35fd600, timeleft: 2500
[23337.323150] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23337.323177] scsi_eh_tur: scmd ffff8807a35fd600 rtn 2002
[23337.323202] scsi_eh_1: aborting cmd:0xffff88058581df00
[23337.323228] mptscsih: ioc0: attempting task abort! (sc=ffff88058581df00)
[23337.323257] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 0a f7 25 e5 00 00 08 00
[23337.698735] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88058581df00)
[23337.699092] scsi_eh_done scmd: ffff88058581df00 result: 0
[23337.699123] scsi_send_eh_cmnd: scmd: ffff88058581df00, timeleft: 2500
[23337.699157] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23337.699184] scsi_eh_tur: scmd ffff88058581df00 rtn 2002
[23337.699210] scsi_eh_1: aborting cmd:0xffff8807b7f06100
[23337.699235] mptscsih: ioc0: attempting task abort! (sc=ffff8807b7f06100)
[23337.699264] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 00 44 d7 00 00 68 00
[23338.074738] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807b7f06100)
[23338.075096] scsi_eh_done scmd: ffff8807b7f06100 result: 0
[23338.075127] scsi_send_eh_cmnd: scmd: ffff8807b7f06100, timeleft: 2500
[23338.075161] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23338.075188] scsi_eh_tur: scmd ffff8807b7f06100 rtn 2002
[23338.075214] scsi_eh_1: aborting cmd:0xffff88080a866200
[23338.075239] mptscsih: ioc0: attempting task abort! (sc=ffff88080a866200)
[23338.075268] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 28 00 3f 00 00 08 00
[23338.450742] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88080a866200)
[23338.451099] scsi_eh_done scmd: ffff88080a866200 result: 0
[23338.451131] scsi_send_eh_cmnd: scmd: ffff88080a866200, timeleft: 2500
[23338.451164] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23338.451191] scsi_eh_tur: scmd ffff88080a866200 rtn 2002
[23338.451217] scsi_eh_1: aborting cmd:0xffff8807ab52f700
[23338.451243] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab52f700)
[23338.451271] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 40 00 4f 00 00 08 00
[23338.504016] scsi_block_when_processing_errors: rtn: 1
[23338.504043] scsi_block_when_processing_errors: rtn: 1
[23338.826745] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab52f700)
[23338.827102] scsi_eh_done scmd: ffff8807ab52f700 result: 0
[23338.827134] scsi_send_eh_cmnd: scmd: ffff8807ab52f700, timeleft: 2500
[23338.827167] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23338.827194] scsi_eh_tur: scmd ffff8807ab52f700 rtn 2002
[23338.827220] scsi_eh_1: aborting cmd:0xffff8807a3755700
[23338.827246] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3755700)
[23338.827274] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 7c 00 57 00 00 08 00
[23339.202769] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3755700)
[23339.203128] scsi_eh_done scmd: ffff8807a3755700 result: 0
[23339.203160] scsi_send_eh_cmnd: scmd: ffff8807a3755700, timeleft: 2500
[23339.203188] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23339.203220] scsi_eh_tur: scmd ffff8807a3755700 rtn 2002
[23339.203246] scsi_eh_1: aborting cmd:0xffff8807af519400
[23339.203271] mptscsih: ioc0: attempting task abort! (sc=ffff8807af519400)
[23339.203300] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 7c 01 7f 00 00 08 00
[23339.578767] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af519400)
[23339.579125] scsi_eh_done scmd: ffff8807af519400 result: 0
[23339.579157] scsi_send_eh_cmnd: scmd: ffff8807af519400, timeleft: 2500
[23339.579190] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23339.579217] scsi_eh_tur: scmd ffff8807af519400 rtn 2002
[23339.579243] scsi_eh_1: aborting cmd:0xffff8807a34cc400
[23339.579269] mptscsih: ioc0: attempting task abort! (sc=ffff8807a34cc400)
[23339.579297] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 80 01 c7 00 00 08 00
[23339.954766] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a34cc400)
[23339.955124] scsi_eh_done scmd: ffff8807a34cc400 result: 0
[23339.955156] scsi_send_eh_cmnd: scmd: ffff8807a34cc400, timeleft: 2500
[23339.955189] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23339.955216] scsi_eh_tur: scmd ffff8807a34cc400 rtn 2002
[23339.955242] scsi_eh_1: aborting cmd:0xffff8806b90e7400
[23339.955268] mptscsih: ioc0: attempting task abort! (sc=ffff8806b90e7400)
[23339.955296] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 80 01 d7 00 00 08 00
[23340.330764] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806b90e7400)
[23340.331121] scsi_eh_done scmd: ffff8806b90e7400 result: 0
[23340.331152] scsi_send_eh_cmnd: scmd: ffff8806b90e7400, timeleft: 2500
[23340.331186] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23340.331213] scsi_eh_tur: scmd ffff8806b90e7400 rtn 2002
[23340.331238] scsi_eh_1: aborting cmd:0xffff8805a49b3d00
[23340.331264] mptscsih: ioc0: attempting task abort! (sc=ffff8805a49b3d00)
[23340.331293] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 84 00 3f 00 00 08 00
[23340.504021] scsi_block_when_processing_errors: rtn: 1
[23340.504047] scsi_block_when_processing_errors: rtn: 1
[23340.706769] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8805a49b3d00)
[23340.707127] scsi_eh_done scmd: ffff8805a49b3d00 result: 0
[23340.707159] scsi_send_eh_cmnd: scmd: ffff8805a49b3d00, timeleft: 2500
[23340.707192] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23340.707220] scsi_eh_tur: scmd ffff8805a49b3d00 rtn 2002
[23340.707245] scsi_eh_1: aborting cmd:0xffff8807ab41c800
[23340.707271] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab41c800)
[23340.707299] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 87 43 4f 00 00 08 00
[23341.082802] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab41c800)
[23341.083161] scsi_eh_done scmd: ffff8807ab41c800 result: 0
[23341.083192] scsi_send_eh_cmnd: scmd: ffff8807ab41c800, timeleft: 2500
[23341.084804] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23341.084831] scsi_eh_tur: scmd ffff8807ab41c800 rtn 2002
[23341.084857] scsi_eh_1: aborting cmd:0xffff88080a800d00
[23341.084883] mptscsih: ioc0: attempting task abort! (sc=ffff88080a800d00)
[23341.084911] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 8c 00 ef 00 00 08 00
[23341.458786] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88080a800d00)
[23341.459144] scsi_eh_done scmd: ffff88080a800d00 result: 0
[23341.459176] scsi_send_eh_cmnd: scmd: ffff88080a800d00, timeleft: 2500
[23341.459209] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23341.459236] scsi_eh_tur: scmd ffff88080a800d00 rtn 2002
[23341.459262] scsi_eh_1: aborting cmd:0xffff880782498200
[23341.459288] mptscsih: ioc0: attempting task abort! (sc=ffff880782498200)
[23341.459316] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 9c 02 8f 00 00 08 00
[23341.834781] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782498200)
[23341.835139] scsi_eh_done scmd: ffff880782498200 result: 0
[23341.835170] scsi_send_eh_cmnd: scmd: ffff880782498200, timeleft: 2500
[23341.835204] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23341.835231] scsi_eh_tur: scmd ffff880782498200 rtn 2002
[23341.835257] scsi_eh_1: aborting cmd:0xffff880782675800
[23341.835282] mptscsih: ioc0: attempting task abort! (sc=ffff880782675800)
[23341.835311] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 a4 02 5f 00 00 08 00
[23342.210788] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782675800)
[23342.211146] scsi_eh_done scmd: ffff880782675800 result: 0
[23342.211178] scsi_send_eh_cmnd: scmd: ffff880782675800, timeleft: 2500
[23342.211211] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23342.211238] scsi_eh_tur: scmd ffff880782675800 rtn 2002
[23342.211264] scsi_eh_1: aborting cmd:0xffff8806e5d4e700
[23342.211290] mptscsih: ioc0: attempting task abort! (sc=ffff8806e5d4e700)
[23342.211318] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 a4 39 0f 00 00 08 00
[23342.504016] scsi_block_when_processing_errors: rtn: 1
[23342.504043] scsi_block_when_processing_errors: rtn: 1
[23342.586792] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806e5d4e700)
[23342.587149] scsi_eh_done scmd: ffff8806e5d4e700 result: 0
[23342.587181] scsi_send_eh_cmnd: scmd: ffff8806e5d4e700, timeleft: 2500
[23342.587214] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23342.587241] scsi_eh_tur: scmd ffff8806e5d4e700 rtn 2002
[23342.587267] scsi_eh_1: aborting cmd:0xffff880782408200
[23342.587293] mptscsih: ioc0: attempting task abort! (sc=ffff880782408200)
[23342.587321] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 a8 00 3f 00 00 08 00
[23342.962817] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782408200)
[23342.963176] scsi_eh_done scmd: ffff880782408200 result: 0
[23342.963207] scsi_send_eh_cmnd: scmd: ffff880782408200, timeleft: 2500
[23342.963241] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23342.963268] scsi_eh_tur: scmd ffff880782408200 rtn 2002
[23342.963293] scsi_eh_1: aborting cmd:0xffff88081a3c3d00
[23342.963319] mptscsih: ioc0: attempting task abort! (sc=ffff88081a3c3d00)
[23342.963348] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 00 3f 00 00 08 00
[23343.338803] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a3c3d00)
[23343.339159] scsi_eh_done scmd: ffff88081a3c3d00 result: 0
[23343.339191] scsi_send_eh_cmnd: scmd: ffff88081a3c3d00, timeleft: 2500
[23343.339225] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23343.339252] scsi_eh_tur: scmd ffff88081a3c3d00 rtn 2002
[23343.339277] scsi_eh_1: aborting cmd:0xffff88083de79700
[23343.339303] mptscsih: ioc0: attempting task abort! (sc=ffff88083de79700)
[23343.339332] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 01 07 00 00 08 00
[23343.714817] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88083de79700)
[23343.715176] scsi_eh_done scmd: ffff88083de79700 result: 0
[23343.715207] scsi_send_eh_cmnd: scmd: ffff88083de79700, timeleft: 2500
[23343.715241] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23343.715268] scsi_eh_tur: scmd ffff88083de79700 rtn 2002
[23343.715293] scsi_eh_1: aborting cmd:0xffff8806c23a4000
[23343.715319] mptscsih: ioc0: attempting task abort! (sc=ffff8806c23a4000)
[23343.715348] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 02 6f 00 00 08 00
[23344.090811] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806c23a4000)
[23344.091167] scsi_eh_done scmd: ffff8806c23a4000 result: 0
[23344.091199] scsi_send_eh_cmnd: scmd: ffff8806c23a4000, timeleft: 2500
[23344.091232] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23344.091259] scsi_eh_tur: scmd ffff8806c23a4000 rtn 2002
[23344.091285] scsi_eh_1: aborting cmd:0xffff88081a2ccb00
[23344.091311] mptscsih: ioc0: attempting task abort! (sc=ffff88081a2ccb00)
[23344.091339] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 03 07 00 00 08 00
[23344.466826] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a2ccb00)
[23344.467183] scsi_eh_done scmd: ffff88081a2ccb00 result: 0
[23344.467215] scsi_send_eh_cmnd: scmd: ffff88081a2ccb00, timeleft: 2500
[23344.467248] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23344.467275] scsi_eh_tur: scmd ffff88081a2ccb00 rtn 2002
[23344.467301] scsi_eh_1: aborting cmd:0xffff8807826c3c00
[23344.467327] mptscsih: ioc0: attempting task abort! (sc=ffff8807826c3c00)
[23344.467355] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 03 27 00 00 08 00
[23344.504020] scsi_block_when_processing_errors: rtn: 1
[23344.504046] scsi_block_when_processing_errors: rtn: 1
[23344.842826] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807826c3c00)
[23344.843183] scsi_eh_done scmd: ffff8807826c3c00 result: 0
[23344.843214] scsi_send_eh_cmnd: scmd: ffff8807826c3c00, timeleft: 2500
[23344.843248] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23344.843275] scsi_eh_tur: scmd ffff8807826c3c00 rtn 2002
[23344.843301] scsi_eh_1: aborting cmd:0xffff88072fe0a600
[23344.843326] mptscsih: ioc0: attempting task abort! (sc=ffff88072fe0a600)
[23344.843355] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 03 87 00 00 08 00
[23345.218826] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fe0a600)
[23345.219183] scsi_eh_done scmd: ffff88072fe0a600 result: 0
[23345.219214] scsi_send_eh_cmnd: scmd: ffff88072fe0a600, timeleft: 2500
[23345.219248] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23345.219275] scsi_eh_tur: scmd ffff88072fe0a600 rtn 2002
[23345.219300] scsi_eh_1: aborting cmd:0xffff88072fe17b00
[23345.219326] mptscsih: ioc0: attempting task abort! (sc=ffff88072fe17b00)
[23345.219355] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 ac 03 9f 00 00 08 00
[23345.594829] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fe17b00)
[23345.595187] scsi_eh_done scmd: ffff88072fe17b00 result: 0
[23345.595218] scsi_send_eh_cmnd: scmd: ffff88072fe17b00, timeleft: 2500
[23345.595252] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23345.595279] scsi_eh_tur: scmd ffff88072fe17b00 rtn 2002
[23345.595304] scsi_eh_1: aborting cmd:0xffff88071a933300
[23345.595330] mptscsih: ioc0: attempting task abort! (sc=ffff88071a933300)
[23345.595359] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 bc 00 bf 00 00 08 00
[23345.970834] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88071a933300)
[23345.971191] scsi_eh_done scmd: ffff88071a933300 result: 0
[23345.971222] scsi_send_eh_cmnd: scmd: ffff88071a933300, timeleft: 2500
[23345.971256] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23345.971282] scsi_eh_tur: scmd ffff88071a933300 rtn 2002
[23345.971308] scsi_eh_1: aborting cmd:0xffff8806b91a6300
[23345.971334] mptscsih: ioc0: attempting task abort! (sc=ffff8806b91a6300)
[23345.971362] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 bc 01 2f 00 00 08 00
[23346.346851] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806b91a6300)
[23346.347207] scsi_eh_done scmd: ffff8806b91a6300 result: 0
[23346.347239] scsi_send_eh_cmnd: scmd: ffff8806b91a6300, timeleft: 2500
[23346.347273] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23346.347300] scsi_eh_tur: scmd ffff8806b91a6300 rtn 2002
[23346.347325] scsi_eh_1: aborting cmd:0xffff88071aa35300
[23346.347351] mptscsih: ioc0: attempting task abort! (sc=ffff88071aa35300)
[23346.347379] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 bc 01 57 00 00 08 00
[23346.504016] scsi_block_when_processing_errors: rtn: 1
[23346.504042] scsi_block_when_processing_errors: rtn: 1
[23346.722899] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88071aa35300)
[23346.723271] scsi_eh_done scmd: ffff88071aa35300 result: 0
[23346.723303] scsi_send_eh_cmnd: scmd: ffff88071aa35300, timeleft: 2500
[23346.723337] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23346.723364] scsi_eh_tur: scmd ffff88071aa35300 rtn 2002
[23346.723390] scsi_eh_1: aborting cmd:0xffff8807be8d8400
[23346.723415] mptscsih: ioc0: attempting task abort! (sc=ffff8807be8d8400)
[23346.723445] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 c0 02 5f 00 00 08 00
[23347.098859] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807be8d8400)
[23347.099216] scsi_eh_done scmd: ffff8807be8d8400 result: 0
[23347.099247] scsi_send_eh_cmnd: scmd: ffff8807be8d8400, timeleft: 2500
[23347.099281] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23347.099308] scsi_eh_tur: scmd ffff8807be8d8400 rtn 2002
[23347.099334] scsi_eh_1: aborting cmd:0xffff8807a34af700
[23347.099359] mptscsih: ioc0: attempting task abort! (sc=ffff8807a34af700)
[23347.099388] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 cc 00 5f 00 00 08 00
[23347.474860] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a34af700)
[23347.475219] scsi_eh_done scmd: ffff8807a34af700 result: 0
[23347.475250] scsi_send_eh_cmnd: scmd: ffff8807a34af700, timeleft: 2500
[23347.475284] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23347.475311] scsi_eh_tur: scmd ffff8807a34af700 rtn 2002
[23347.475336] scsi_eh_1: aborting cmd:0xffff88072fc53f00
[23347.475362] mptscsih: ioc0: attempting task abort! (sc=ffff88072fc53f00)
[23347.475390] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 cc 01 2f 00 00 08 00
[23347.850859] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fc53f00)
[23347.851216] scsi_eh_done scmd: ffff88072fc53f00 result: 0
[23347.851248] scsi_send_eh_cmnd: scmd: ffff88072fc53f00, timeleft: 2500
[23347.851281] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23347.851308] scsi_eh_tur: scmd ffff88072fc53f00 rtn 2002
[23347.851334] scsi_eh_1: aborting cmd:0xffff8807a35a7000
[23347.851360] mptscsih: ioc0: attempting task abort! (sc=ffff8807a35a7000)
[23347.851388] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 e0 01 ff 00 00 08 00
[23348.226867] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a35a7000)
[23348.227225] scsi_eh_done scmd: ffff8807a35a7000 result: 0
[23348.227257] scsi_send_eh_cmnd: scmd: ffff8807a35a7000, timeleft: 2500
[23348.227290] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23348.227317] scsi_eh_tur: scmd ffff8807a35a7000 rtn 2002
[23348.227343] scsi_eh_1: aborting cmd:0xffff88071a9a4300
[23348.227369] mptscsih: ioc0: attempting task abort! (sc=ffff88071a9a4300)
[23348.227397] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 e0 02 0f 00 00 08 00
[23348.504034] scsi_block_when_processing_errors: rtn: 1
[23348.504066] scsi_block_when_processing_errors: rtn: 1
[23348.602869] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88071a9a4300)
[23348.603227] scsi_eh_done scmd: ffff88071a9a4300 result: 0
[23348.603259] scsi_send_eh_cmnd: scmd: ffff88071a9a4300, timeleft: 2500
[23348.603292] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23348.603319] scsi_eh_tur: scmd ffff88071a9a4300 rtn 2002
[23348.603345] scsi_eh_1: aborting cmd:0xffff88078240d600
[23348.603371] mptscsih: ioc0: attempting task abort! (sc=ffff88078240d600)
[23348.603399] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 00 fc 00 6f 00 00 08 00
[23348.978874] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88078240d600)
[23348.979231] scsi_eh_done scmd: ffff88078240d600 result: 0
[23348.979262] scsi_send_eh_cmnd: scmd: ffff88078240d600, timeleft: 2500
[23348.979295] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23348.979322] scsi_eh_tur: scmd ffff88078240d600 rtn 2002
[23348.979348] scsi_eh_1: aborting cmd:0xffff88082441de00
[23348.979374] mptscsih: ioc0: attempting task abort! (sc=ffff88082441de00)
[23348.980983] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 08 04 cf 00 00 08 00
[23349.354885] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88082441de00)
[23349.355243] scsi_eh_done scmd: ffff88082441de00 result: 0
[23349.355274] scsi_send_eh_cmnd: scmd: ffff88082441de00, timeleft: 2500
[23349.355308] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23349.355335] scsi_eh_tur: scmd ffff88082441de00 rtn 2002
[23349.355361] scsi_eh_1: aborting cmd:0xffff880782437a00
[23349.355386] mptscsih: ioc0: attempting task abort! (sc=ffff880782437a00)
[23349.355415] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 10 00 3f 00 00 08 00
[23349.730887] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782437a00)
[23349.731245] scsi_eh_done scmd: ffff880782437a00 result: 0
[23349.731276] scsi_send_eh_cmnd: scmd: ffff880782437a00, timeleft: 2500
[23349.731310] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23349.731337] scsi_eh_tur: scmd ffff880782437a00 rtn 2002
[23349.731363] scsi_eh_1: aborting cmd:0xffff8807ab65bf00
[23349.731388] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab65bf00)
[23349.731417] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 10 00 8f 00 00 08 00
[23350.106897] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab65bf00)
[23350.107254] scsi_eh_done scmd: ffff8807ab65bf00 result: 0
[23350.107285] scsi_send_eh_cmnd: scmd: ffff8807ab65bf00, timeleft: 2500
[23350.107319] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23350.107346] scsi_eh_tur: scmd ffff8807ab65bf00 rtn 2002
[23350.107372] scsi_eh_1: aborting cmd:0xffff8807e17ca800
[23350.107397] mptscsih: ioc0: attempting task abort! (sc=ffff8807e17ca800)
[23350.107426] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 28 02 af 00 00 08 00
[23350.482898] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807e17ca800)
[23350.483256] scsi_eh_done scmd: ffff8807e17ca800 result: 0
[23350.483287] scsi_send_eh_cmnd: scmd: ffff8807e17ca800, timeleft: 2500
[23350.483320] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23350.483347] scsi_eh_tur: scmd ffff8807e17ca800 rtn 2002
[23350.483373] scsi_eh_1: aborting cmd:0xffff8807ab752800
[23350.483398] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab752800)
[23350.483427] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 38 00 3f 00 00 08 00
[23350.504020] scsi_block_when_processing_errors: rtn: 1
[23350.504046] scsi_block_when_processing_errors: rtn: 1
[23350.858895] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab752800)
[23350.859253] scsi_eh_done scmd: ffff8807ab752800 result: 0
[23350.859284] scsi_send_eh_cmnd: scmd: ffff8807ab752800, timeleft: 2500
[23350.859318] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23350.859345] scsi_eh_tur: scmd ffff8807ab752800 rtn 2002
[23350.859371] scsi_eh_1: aborting cmd:0xffff8807e14e4d00
[23350.859396] mptscsih: ioc0: attempting task abort! (sc=ffff8807e14e4d00)
[23350.859425] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 38 00 df 00 00 08 00
[23351.234900] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807e14e4d00)
[23351.235258] scsi_eh_done scmd: ffff8807e14e4d00 result: 0
[23351.235289] scsi_send_eh_cmnd: scmd: ffff8807e14e4d00, timeleft: 2500
[23351.235323] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23351.235350] scsi_eh_tur: scmd ffff8807e14e4d00 rtn 2002
[23351.235376] scsi_eh_1: aborting cmd:0xffff8807a34efd00
[23351.235401] mptscsih: ioc0: attempting task abort! (sc=ffff8807a34efd00)
[23351.235430] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 38 00 e7 00 00 08 00
[23351.610926] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a34efd00)
[23351.611284] scsi_eh_done scmd: ffff8807a34efd00 result: 0
[23351.611316] scsi_send_eh_cmnd: scmd: ffff8807a34efd00, timeleft: 2500
[23351.611349] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23351.611376] scsi_eh_tur: scmd ffff8807a34efd00 rtn 2002
[23351.611402] scsi_eh_1: aborting cmd:0xffff8807af77d500
[23351.611427] mptscsih: ioc0: attempting task abort! (sc=ffff8807af77d500)
[23351.611456] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 3c 00 4f 00 00 08 00
[23351.986915] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af77d500)
[23351.987272] scsi_eh_done scmd: ffff8807af77d500 result: 0
[23351.987303] scsi_send_eh_cmnd: scmd: ffff8807af77d500, timeleft: 2500
[23351.987337] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23351.987364] scsi_eh_tur: scmd ffff8807af77d500 rtn 2002
[23351.987390] scsi_eh_1: aborting cmd:0xffff8805b1354900
[23351.987416] mptscsih: ioc0: attempting task abort! (sc=ffff8805b1354900)
[23351.987444] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 44 03 bf 00 00 08 00
[23352.362914] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8805b1354900)
[23352.363271] scsi_eh_done scmd: ffff8805b1354900 result: 0
[23352.363302] scsi_send_eh_cmnd: scmd: ffff8805b1354900, timeleft: 2500
[23352.363336] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23352.363363] scsi_eh_tur: scmd ffff8805b1354900 rtn 2002
[23352.363389] scsi_eh_1: aborting cmd:0xffff88072fe20d00
[23352.363414] mptscsih: ioc0: attempting task abort! (sc=ffff88072fe20d00)
[23352.363443] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 44 07 87 00 00 08 00
[23352.504017] scsi_block_when_processing_errors: rtn: 1
[23352.504044] scsi_block_when_processing_errors: rtn: 1
[23352.738920] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fe20d00)
[23352.739277] scsi_eh_done scmd: ffff88072fe20d00 result: 0
[23352.739308] scsi_send_eh_cmnd: scmd: ffff88072fe20d00, timeleft: 2500
[23352.739342] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23352.739369] scsi_eh_tur: scmd ffff88072fe20d00 rtn 2002
[23352.739395] scsi_eh_1: aborting cmd:0xffff88072fcc4b00
[23352.739420] mptscsih: ioc0: attempting task abort! (sc=ffff88072fcc4b00)
[23352.739449] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 44 0a df 00 00 08 00
[23353.114924] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fcc4b00)
[23353.115282] scsi_eh_done scmd: ffff88072fcc4b00 result: 0
[23353.115313] scsi_send_eh_cmnd: scmd: ffff88072fcc4b00, timeleft: 2500
[23353.115347] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23353.115374] scsi_eh_tur: scmd ffff88072fcc4b00 rtn 2002
[23353.115400] scsi_eh_1: aborting cmd:0xffff88078264a600
[23353.115426] mptscsih: ioc0: attempting task abort! (sc=ffff88078264a600)
[23353.115454] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 44 0b 97 00 00 08 00
[23353.490938] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88078264a600)
[23353.491296] scsi_eh_done scmd: ffff88078264a600 result: 0
[23353.491327] scsi_send_eh_cmnd: scmd: ffff88078264a600, timeleft: 2500
[23353.491360] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23353.491387] scsi_eh_tur: scmd ffff88078264a600 rtn 2002
[23353.491413] scsi_eh_1: aborting cmd:0xffff8807a355ae00
[23353.491439] mptscsih: ioc0: attempting task abort! (sc=ffff8807a355ae00)
[23353.491467] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 4c 01 f7 00 00 08 00
[23353.866933] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a355ae00)
[23353.867290] scsi_eh_done scmd: ffff8807a355ae00 result: 0
[23353.867321] scsi_send_eh_cmnd: scmd: ffff8807a355ae00, timeleft: 2500
[23353.867355] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23353.867381] scsi_eh_tur: scmd ffff8807a355ae00 rtn 2002
[23353.867407] scsi_eh_1: aborting cmd:0xffff880782576f00
[23353.867433] mptscsih: ioc0: attempting task abort! (sc=ffff880782576f00)
[23353.867461] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 54 00 f7 00 00 08 00
[23354.242942] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782576f00)
[23354.243301] scsi_eh_done scmd: ffff880782576f00 result: 0
[23354.243332] scsi_send_eh_cmnd: scmd: ffff880782576f00, timeleft: 2500
[23354.243366] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23354.243393] scsi_eh_tur: scmd ffff880782576f00 rtn 2002
[23354.243418] scsi_eh_1: aborting cmd:0xffff880701440f00
[23354.243444] mptscsih: ioc0: attempting task abort! (sc=ffff880701440f00)
[23354.243473] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 6c 00 87 00 00 08 00
[23354.504015] scsi_block_when_processing_errors: rtn: 1
[23354.504041] scsi_block_when_processing_errors: rtn: 1
[23354.618945] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880701440f00)
[23354.619303] scsi_eh_done scmd: ffff880701440f00 result: 0
[23354.619334] scsi_send_eh_cmnd: scmd: ffff880701440f00, timeleft: 2500
[23354.619368] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23354.619395] scsi_eh_tur: scmd ffff880701440f00 rtn 2002
[23354.619421] scsi_eh_1: aborting cmd:0xffff88051292e800
[23354.619446] mptscsih: ioc0: attempting task abort! (sc=ffff88051292e800)
[23354.619475] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 70 00 d7 00 00 08 00
[23354.994950] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88051292e800)
[23354.995307] scsi_eh_done scmd: ffff88051292e800 result: 0
[23354.995339] scsi_send_eh_cmnd: scmd: ffff88051292e800, timeleft: 2500
[23354.995373] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23354.995399] scsi_eh_tur: scmd ffff88051292e800 rtn 2002
[23354.995425] scsi_eh_1: aborting cmd:0xffff88081a3cb400
[23354.995451] mptscsih: ioc0: attempting task abort! (sc=ffff88081a3cb400)
[23354.995480] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 70 01 37 00 00 08 00
[23355.370982] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a3cb400)
[23355.371341] scsi_eh_done scmd: ffff88081a3cb400 result: 0
[23355.371372] scsi_send_eh_cmnd: scmd: ffff88081a3cb400, timeleft: 2500
[23355.371406] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23355.371433] scsi_eh_tur: scmd ffff88081a3cb400 rtn 2002
[23355.371459] scsi_eh_1: aborting cmd:0xffff880701783100
[23355.371484] mptscsih: ioc0: attempting task abort! (sc=ffff880701783100)
[23355.371513] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 78 00 67 00 00 08 00
[23355.746969] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880701783100)
[23355.747327] scsi_eh_done scmd: ffff880701783100 result: 0
[23355.747358] scsi_send_eh_cmnd: scmd: ffff880701783100, timeleft: 2500
[23355.747392] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23355.747419] scsi_eh_tur: scmd ffff880701783100 rtn 2002
[23355.747445] scsi_eh_1: aborting cmd:0xffff8807a3652800
[23355.747470] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3652800)
[23355.747499] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 90 00 7f 00 00 08 00
[23356.122966] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3652800)
[23356.123324] scsi_eh_done scmd: ffff8807a3652800 result: 0
[23356.123355] scsi_send_eh_cmnd: scmd: ffff8807a3652800, timeleft: 2500
[23356.123389] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23356.123416] scsi_eh_tur: scmd ffff8807a3652800 rtn 2002
[23356.123442] scsi_eh_1: aborting cmd:0xffff8807a3652c00
[23356.123467] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3652c00)
[23356.123496] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 90 01 cf 00 00 08 00
[23356.498968] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3652c00)
[23356.499325] scsi_eh_done scmd: ffff8807a3652c00 result: 0
[23356.499356] scsi_send_eh_cmnd: scmd: ffff8807a3652c00, timeleft: 2500
[23356.499390] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23356.499417] scsi_eh_tur: scmd ffff8807a3652c00 rtn 2002
[23356.499442] scsi_eh_1: aborting cmd:0xffff8807824be900
[23356.499468] mptscsih: ioc0: attempting task abort! (sc=ffff8807824be900)
[23356.499496] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 94 01 27 00 00 08 00
[23356.504022] scsi_block_when_processing_errors: rtn: 1
[23356.504049] scsi_block_when_processing_errors: rtn: 1
[23356.874994] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807824be900)
[23356.875353] scsi_eh_done scmd: ffff8807824be900 result: 0
[23356.875384] scsi_send_eh_cmnd: scmd: ffff8807824be900, timeleft: 2500
[23356.875418] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23356.875445] scsi_eh_tur: scmd ffff8807824be900 rtn 2002
[23356.875471] scsi_eh_1: aborting cmd:0xffff88054059eb00
[23356.875497] mptscsih: ioc0: attempting task abort! (sc=ffff88054059eb00)
[23356.875525] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 b8 00 af 00 00 08 00
[23357.250975] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88054059eb00)
[23357.251332] scsi_eh_done scmd: ffff88054059eb00 result: 0
[23357.251364] scsi_send_eh_cmnd: scmd: ffff88054059eb00, timeleft: 2500
[23357.252979] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23357.253010] scsi_eh_tur: scmd ffff88054059eb00 rtn 2002
[23357.253037] scsi_eh_1: aborting cmd:0xffff8806c2151700
[23357.253063] mptscsih: ioc0: attempting task abort! (sc=ffff8806c2151700)
[23357.253092] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 c4 00 3f 00 00 08 00
[23357.626983] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806c2151700)
[23357.627341] scsi_eh_done scmd: ffff8806c2151700 result: 0
[23357.627372] scsi_send_eh_cmnd: scmd: ffff8806c2151700, timeleft: 2500
[23357.627406] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23357.627433] scsi_eh_tur: scmd ffff8806c2151700 rtn 2002
[23357.627459] scsi_eh_1: aborting cmd:0xffff8806c2151400
[23357.627484] mptscsih: ioc0: attempting task abort! (sc=ffff8806c2151400)
[23357.627513] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 cc 00 3f 00 00 08 00
[23358.003159] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806c2151400)
[23358.003517] scsi_eh_done scmd: ffff8806c2151400 result: 0
[23358.003549] scsi_send_eh_cmnd: scmd: ffff8806c2151400, timeleft: 2500
[23358.003583] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23358.003609] scsi_eh_tur: scmd ffff8806c2151400 rtn 2002
[23358.003635] scsi_eh_1: aborting cmd:0xffff880512925600
[23358.003661] mptscsih: ioc0: attempting task abort! (sc=ffff880512925600)
[23358.003689] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 cc 01 c7 00 00 08 00
[23358.379001] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880512925600)
[23358.379360] scsi_eh_done scmd: ffff880512925600 result: 0
[23358.379391] scsi_send_eh_cmnd: scmd: ffff880512925600, timeleft: 2500
[23358.379425] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23358.379452] scsi_eh_tur: scmd ffff880512925600 rtn 2002
[23358.379478] scsi_eh_1: aborting cmd:0xffff880512925b00
[23358.379503] mptscsih: ioc0: attempting task abort! (sc=ffff880512925b00)
[23358.379532] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 d0 01 07 00 00 08 00
[23358.504016] scsi_block_when_processing_errors: rtn: 1
[23358.504043] scsi_block_when_processing_errors: rtn: 1
[23358.755019] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880512925b00)
[23358.755375] scsi_eh_done scmd: ffff880512925b00 result: 0
[23358.755406] scsi_send_eh_cmnd: scmd: ffff880512925b00, timeleft: 2500
[23358.755440] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23358.755467] scsi_eh_tur: scmd ffff880512925b00 rtn 2002
[23358.755493] scsi_eh_1: aborting cmd:0xffff880782519b00
[23358.755518] mptscsih: ioc0: attempting task abort! (sc=ffff880782519b00)
[23358.755547] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 d8 02 af 00 00 08 00
[23359.131005] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782519b00)
[23359.131363] scsi_eh_done scmd: ffff880782519b00 result: 0
[23359.131394] scsi_send_eh_cmnd: scmd: ffff880782519b00, timeleft: 2500
[23359.131428] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23359.131454] scsi_eh_tur: scmd ffff880782519b00 rtn 2002
[23359.131480] scsi_eh_1: aborting cmd:0xffff8807a34cf600
[23359.131506] mptscsih: ioc0: attempting task abort! (sc=ffff8807a34cf600)
[23359.131534] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 dc 00 f7 00 00 08 00
[23359.507007] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a34cf600)
[23359.507365] scsi_eh_done scmd: ffff8807a34cf600 result: 0
[23359.507396] scsi_send_eh_cmnd: scmd: ffff8807a34cf600, timeleft: 2500
[23359.507430] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23359.507457] scsi_eh_tur: scmd ffff8807a34cf600 rtn 2002
[23359.507483] scsi_eh_1: aborting cmd:0xffff8806c23d5500
[23359.507508] mptscsih: ioc0: attempting task abort! (sc=ffff8806c23d5500)
[23359.507537] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 e0 01 07 00 00 08 00
[23359.883015] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806c23d5500)
[23359.883372] scsi_eh_done scmd: ffff8806c23d5500 result: 0
[23359.883404] scsi_send_eh_cmnd: scmd: ffff8806c23d5500, timeleft: 2500
[23359.883437] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23359.883464] scsi_eh_tur: scmd ffff8806c23d5500 rtn 2002
[23359.883490] scsi_eh_1: aborting cmd:0xffff8807af6ed100
[23359.883516] mptscsih: ioc0: attempting task abort! (sc=ffff8807af6ed100)
[23359.883544] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 01 f4 00 9f 00 00 08 00
[23360.259021] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af6ed100)
[23360.259378] scsi_eh_done scmd: ffff8807af6ed100 result: 0
[23360.259409] scsi_send_eh_cmnd: scmd: ffff8807af6ed100, timeleft: 2500
[23360.259443] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23360.259470] scsi_eh_tur: scmd ffff8807af6ed100 rtn 2002
[23360.259496] scsi_eh_1: aborting cmd:0xffff8807c2ebfa00
[23360.259521] mptscsih: ioc0: attempting task abort! (sc=ffff8807c2ebfa00)
[23360.259550] sd 1:0:0:0: [sdb] CDB: Write(10): 2a 00 02 04 01 af 00 00 08 00
[23360.504020] scsi_block_when_processing_errors: rtn: 1
[23360.504046] scsi_block_when_processing_errors: rtn: 1
[23360.635036] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807c2ebfa00)
[23360.635393] scsi_eh_done scmd: ffff8807c2ebfa00 result: 0
[23360.635424] scsi_send_eh_cmnd: scmd: ffff8807c2ebfa00, timeleft: 2500
[23360.635458] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23360.635485] scsi_eh_tur: scmd ffff8807c2ebfa00 rtn 2002
[23360.635510] scsi_eh_1: aborting cmd:0xffff88069ede7e00
[23360.635536] mptscsih: ioc0: attempting task abort! (sc=ffff88069ede7e00)
[23360.635565] sd 1:0:1:4: [sdl] CDB: Write(10): 2a 00 0a 2b 38 b5 00 00 08 00
[23361.011236] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88069ede7e00)
[23361.011595] scsi_eh_done scmd: ffff88069ede7e00 result: 0
[23361.011626] scsi_send_eh_cmnd: scmd: ffff88069ede7e00, timeleft: 2500
[23361.011660] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23361.011686] scsi_eh_tur: scmd ffff88069ede7e00 rtn 2002
[23361.011712] scsi_eh_1: aborting cmd:0xffff8807a3665700
[23361.011738] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3665700)
[23361.011767] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 02 a9 24 17 00 00 08 00
[23361.387026] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3665700)
[23361.387385] scsi_eh_done scmd: ffff8807a3665700 result: 0
[23361.387416] scsi_send_eh_cmnd: scmd: ffff8807a3665700, timeleft: 2500
[23361.387450] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23361.387477] scsi_eh_tur: scmd ffff8807a3665700 rtn 2002
[23361.387503] scsi_eh_1: aborting cmd:0xffff8807bea97b00
[23361.387528] mptscsih: ioc0: attempting task abort! (sc=ffff8807bea97b00)
[23361.387557] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 03 c2 de 6f 00 00 08 00
[23361.763103] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807bea97b00)
[23361.763464] scsi_eh_done scmd: ffff8807bea97b00 result: 0
[23361.763496] scsi_send_eh_cmnd: scmd: ffff8807bea97b00, timeleft: 2500
[23361.763530] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23361.763557] scsi_eh_tur: scmd ffff8807bea97b00 rtn 2002
[23361.763583] scsi_eh_1: aborting cmd:0xffff8807a3610100
[23361.763608] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3610100)
[23361.763637] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 0c 6d 0e 07 00 00 08 00
[23361.902681] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427818] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427851] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427886] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427916] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427947] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.427977] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428019] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428049] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428080] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428110] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428140] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428171] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428201] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428231] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428262] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428292] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428323] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428353] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428383] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428414] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428444] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428474] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428505] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428535] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428565] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428596] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428626] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428656] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428687] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428717] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428747] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428777] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428808] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428838] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428868] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428899] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428929] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428959] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.428990] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429028] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429059] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429089] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429119] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429149] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429180] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429210] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429241] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429271] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429301] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429332] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429362] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429392] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429422] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429453] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429483] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429522] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429552] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.429582] mptbase: ioc0: LogInfo(0x11010001): F/W: bug! MID not found
[23362.430207] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3610100)
[23362.430569] scsi_eh_done scmd: ffff8807a3610100 result: 0
[23362.430601] scsi_send_eh_cmnd: scmd: ffff8807a3610100, timeleft: 2500
[23362.430634] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.430661] scsi_eh_tur: scmd ffff8807a3610100 rtn 2002
[23362.430686] scsi_eh_1: aborting cmd:0xffff8807a3610b00
[23362.430712] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3610b00)
[23362.430741] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 0d 0c 41 0f 00 00 08 00
[23362.430793] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3610b00)
[23362.430964] scsi_eh_done scmd: ffff8807a3610b00 result: 0
[23362.430995] scsi_send_eh_cmnd: scmd: ffff8807a3610b00, timeleft: 2500
[23362.431029] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.431056] scsi_eh_tur: scmd ffff8807a3610b00 rtn 2002
[23362.431081] scsi_eh_1: aborting cmd:0xffff88051298e600
[23362.431107] mptscsih: ioc0: attempting task abort! (sc=ffff88051298e600)
[23362.431135] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 13 e4 02 6f 00 00 08 00
[23362.432766] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88051298e600)
[23362.432939] scsi_eh_done scmd: ffff88051298e600 result: 0
[23362.433009] scsi_send_eh_cmnd: scmd: ffff88051298e600, timeleft: 2500
[23362.433041] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.433068] scsi_eh_tur: scmd ffff88051298e600 rtn 2002
[23362.433094] scsi_eh_1: aborting cmd:0xffff8807beb95f00
[23362.433119] mptscsih: ioc0: attempting task abort! (sc=ffff8807beb95f00)
[23362.433148] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 13 e4 03 cf 00 00 08 00
[23362.433200] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807beb95f00)
[23362.433372] scsi_eh_done scmd: ffff8807beb95f00 result: 0
[23362.433403] scsi_send_eh_cmnd: scmd: ffff8807beb95f00, timeleft: 2500
[23362.433437] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.433464] scsi_eh_tur: scmd ffff8807beb95f00 rtn 2002
[23362.433489] scsi_eh_1: aborting cmd:0xffff8807a3578900
[23362.433524] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3578900)
[23362.433552] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 14 4e df 77 00 00 08 00
[23362.433604] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3578900)
[23362.433775] scsi_eh_done scmd: ffff8807a3578900 result: 0
[23362.433806] scsi_send_eh_cmnd: scmd: ffff8807a3578900, timeleft: 2500
[23362.433840] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.433867] scsi_eh_tur: scmd ffff8807a3578900 rtn 2002
[23362.433892] scsi_eh_1: aborting cmd:0xffff88072fd1b900
[23362.433918] mptscsih: ioc0: attempting task abort! (sc=ffff88072fd1b900)
[23362.433946] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 16 f8 01 af 00 00 08 00
[23362.433998] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fd1b900)
[23362.434169] scsi_eh_done scmd: ffff88072fd1b900 result: 0
[23362.434200] scsi_send_eh_cmnd: scmd: ffff88072fd1b900, timeleft: 2500
[23362.434234] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.434261] scsi_eh_tur: scmd ffff88072fd1b900 rtn 2002
[23362.434286] scsi_eh_1: aborting cmd:0xffff8807ab641f00
[23362.434312] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab641f00)
[23362.434340] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 18 1c 02 df 00 00 08 00
[23362.434392] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab641f00)
[23362.434563] scsi_eh_done scmd: ffff8807ab641f00 result: 0
[23362.434594] scsi_send_eh_cmnd: scmd: ffff8807ab641f00, timeleft: 2500
[23362.434627] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.434654] scsi_eh_tur: scmd ffff8807ab641f00 rtn 2002
[23362.434680] scsi_eh_1: aborting cmd:0xffff88081a3cec00
[23362.434705] mptscsih: ioc0: attempting task abort! (sc=ffff88081a3cec00)
[23362.434734] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 18 1c 10 07 00 00 08 00
[23362.434786] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a3cec00)
[23362.434956] scsi_eh_done scmd: ffff88081a3cec00 result: 0
[23362.434987] scsi_send_eh_cmnd: scmd: ffff88081a3cec00, timeleft: 2500
[23362.435021] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.435048] scsi_eh_tur: scmd ffff88081a3cec00 rtn 2002
[23362.435073] scsi_eh_1: aborting cmd:0xffff8807a379f400
[23362.435099] mptscsih: ioc0: attempting task abort! (sc=ffff8807a379f400)
[23362.435127] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 18 27 9b 67 00 00 08 00
[23362.435179] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a379f400)
[23362.435350] scsi_eh_done scmd: ffff8807a379f400 result: 0
[23362.435381] scsi_send_eh_cmnd: scmd: ffff8807a379f400, timeleft: 2500
[23362.435414] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.435441] scsi_eh_tur: scmd ffff8807a379f400 rtn 2002
[23362.435467] scsi_eh_1: aborting cmd:0xffff8807a3730c00
[23362.435492] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3730c00)
[23362.435521] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1a 74 e2 6f 00 00 08 00
[23362.435573] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3730c00)
[23362.435750] scsi_eh_done scmd: ffff8807a3730c00 result: 0
[23362.435781] scsi_send_eh_cmnd: scmd: ffff8807a3730c00, timeleft: 2500
[23362.435814] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.435841] scsi_eh_tur: scmd ffff8807a3730c00 rtn 2002
[23362.435867] scsi_eh_1: aborting cmd:0xffff8806b9106f00
[23362.435892] mptscsih: ioc0: attempting task abort! (sc=ffff8806b9106f00)
[23362.435921] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1a 7a aa 6f 00 00 08 00
[23362.435973] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806b9106f00)
[23362.436305] scsi_eh_done scmd: ffff8806b9106f00 result: 0
[23362.436580] scsi_send_eh_cmnd: scmd: ffff8806b9106f00, timeleft: 2500
[23362.436608] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.436635] scsi_eh_tur: scmd ffff8806b9106f00 rtn 2002
[23362.436661] scsi_eh_1: aborting cmd:0xffff8806b939a400
[23362.436702] mptscsih: ioc0: attempting task abort! (sc=ffff8806b939a400)
[23362.436742] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1c c0 22 6f 00 00 08 00
[23362.436795] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806b939a400)
[23362.436967] scsi_eh_done scmd: ffff8806b939a400 result: 0
[23362.437131] scsi_send_eh_cmnd: scmd: ffff8806b939a400, timeleft: 2500
[23362.437160] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.437192] scsi_eh_tur: scmd ffff8806b939a400 rtn 2002
[23362.437218] scsi_eh_1: aborting cmd:0xffff880782719300
[23362.437259] mptscsih: ioc0: attempting task abort! (sc=ffff880782719300)
[23362.437302] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1c c0 2c 6f 00 00 08 00
[23362.437355] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782719300)
[23362.437528] scsi_eh_done scmd: ffff880782719300 result: 0
[23362.437655] scsi_send_eh_cmnd: scmd: ffff880782719300, timeleft: 2499
[23362.437683] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.437710] scsi_eh_tur: scmd ffff880782719300 rtn 2002
[23362.437736] scsi_eh_1: aborting cmd:0xffff88072fce6100
[23362.437777] mptscsih: ioc0: attempting task abort! (sc=ffff88072fce6100)
[23362.437806] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1c c0 53 6f 00 00 08 00
[23362.437870] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fce6100)
[23362.438054] scsi_eh_done scmd: ffff88072fce6100 result: 0
[23362.438085] scsi_send_eh_cmnd: scmd: ffff88072fce6100, timeleft: 2500
[23362.438127] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.438154] scsi_eh_tur: scmd ffff88072fce6100 rtn 2002
[23362.438192] scsi_eh_1: aborting cmd:0xffff8807a376a300
[23362.438218] mptscsih: ioc0: attempting task abort! (sc=ffff8807a376a300)
[23362.438247] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1e a8 00 77 00 00 08 00
[23362.438312] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a376a300)
[23362.438497] scsi_eh_done scmd: ffff8807a376a300 result: 0
[23362.438545] scsi_send_eh_cmnd: scmd: ffff8807a376a300, timeleft: 2500
[23362.438573] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.438600] scsi_eh_tur: scmd ffff8807a376a300 rtn 2002
[23362.438626] scsi_eh_1: aborting cmd:0xffff8807ab675a00
[23362.438664] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab675a00)
[23362.438704] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1f 54 02 1f 00 00 08 00
[23362.438757] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab675a00)
[23362.438929] scsi_eh_done scmd: ffff8807ab675a00 result: 0
[23362.438966] scsi_send_eh_cmnd: scmd: ffff8807ab675a00, timeleft: 2500
[23362.438994] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.439033] scsi_eh_tur: scmd ffff8807ab675a00 rtn 2002
[23362.439071] scsi_eh_1: aborting cmd:0xffff8807ab675800
[23362.439097] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab675800)
[23362.439125] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1f 56 91 b7 00 00 08 00
[23362.439191] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab675800)
[23362.439365] scsi_eh_done scmd: ffff8807ab675800 result: 0
[23362.439405] scsi_send_eh_cmnd: scmd: ffff8807ab675800, timeleft: 2500
[23362.439450] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.439477] scsi_eh_tur: scmd ffff8807ab675800 rtn 2002
[23362.439503] scsi_eh_1: aborting cmd:0xffff8807be802800
[23362.439528] mptscsih: ioc0: attempting task abort! (sc=ffff8807be802800)
[23362.439568] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 1f 56 92 df 00 00 08 00
[23362.439632] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807be802800)
[23362.439806] scsi_eh_done scmd: ffff8807be802800 result: 0
[23362.439838] scsi_send_eh_cmnd: scmd: ffff8807be802800, timeleft: 2500
[23362.439866] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.439893] scsi_eh_tur: scmd ffff8807be802800 rtn 2002
[23362.439936] scsi_eh_1: aborting cmd:0xffff8807ab7ceb00
[23362.439974] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab7ceb00)
[23362.440016] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 23 b0 21 1f 00 00 08 00
[23362.440068] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab7ceb00)
[23362.440256] scsi_eh_done scmd: ffff8807ab7ceb00 result: 0
[23362.440539] scsi_send_eh_cmnd: scmd: ffff8807ab7ceb00, timeleft: 2500
[23362.440567] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.440594] scsi_eh_tur: scmd ffff8807ab7ceb00 rtn 2002
[23362.440632] scsi_eh_1: aborting cmd:0xffff8807ab7ce800
[23362.440671] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab7ce800)
[23362.440699] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 23 b0 b2 87 00 00 08 00
[23362.440752] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab7ce800)
[23362.440939] scsi_eh_done scmd: ffff8807ab7ce800 result: 0
[23362.441020] scsi_send_eh_cmnd: scmd: ffff8807ab7ce800, timeleft: 2500
[23362.441057] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.441084] scsi_eh_tur: scmd ffff8807ab7ce800 rtn 2002
[23362.441112] scsi_eh_1: aborting cmd:0xffff8806b93f8700
[23362.441138] mptscsih: ioc0: attempting task abort! (sc=ffff8806b93f8700)
[23362.441168] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 23 e4 00 ff 00 00 08 00
[23362.441223] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806b93f8700)
[23362.441398] scsi_eh_done scmd: ffff8806b93f8700 result: 0
[23362.441431] scsi_send_eh_cmnd: scmd: ffff8806b93f8700, timeleft: 2500
[23362.441459] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.441506] scsi_eh_tur: scmd ffff8806b93f8700 rtn 2002
[23362.441548] scsi_eh_1: aborting cmd:0xffff8807c2c54300
[23362.441574] mptscsih: ioc0: attempting task abort! (sc=ffff8807c2c54300)
[23362.441603] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 24 43 9e f7 00 00 08 00
[23362.441655] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807c2c54300)
[23362.441838] scsi_eh_done scmd: ffff8807c2c54300 result: 0
[23362.441882] scsi_send_eh_cmnd: scmd: ffff8807c2c54300, timeleft: 2500
[23362.441927] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.441954] scsi_eh_tur: scmd ffff8807c2c54300 rtn 2002
[23362.441979] scsi_eh_1: aborting cmd:0xffff88080aa53800
[23362.442005] mptscsih: ioc0: attempting task abort! (sc=ffff88080aa53800)
[23362.442047] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 26 2e 5d cf 00 00 08 00
[23362.442111] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88080aa53800)
[23362.442283] scsi_eh_done scmd: ffff88080aa53800 result: 0
[23362.442319] scsi_send_eh_cmnd: scmd: ffff88080aa53800, timeleft: 2500
[23362.442347] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.442385] scsi_eh_tur: scmd ffff88080aa53800 rtn 2002
[23362.442411] scsi_eh_1: aborting cmd:0xffff8805129b4900
[23362.442448] mptscsih: ioc0: attempting task abort! (sc=ffff8805129b4900)
[23362.442477] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 26 eb 73 77 00 00 08 00
[23362.442529] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8805129b4900)
[23362.442712] scsi_eh_done scmd: ffff8805129b4900 result: 0
[23362.442763] scsi_send_eh_cmnd: scmd: ffff8805129b4900, timeleft: 2500
[23362.442806] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.442837] scsi_eh_tur: scmd ffff8805129b4900 rtn 2002
[23362.442863] scsi_eh_1: aborting cmd:0xffff88080a8dd500
[23362.442888] mptscsih: ioc0: attempting task abort! (sc=ffff88080a8dd500)
[23362.442926] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 27 0d f3 7f 00 00 08 00
[23362.442999] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88080a8dd500)
[23362.443177] scsi_eh_done scmd: ffff88080a8dd500 result: 0
[23362.443209] scsi_send_eh_cmnd: scmd: ffff88080a8dd500, timeleft: 2500
[23362.443238] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.444936] scsi_eh_tur: scmd ffff88080a8dd500 rtn 2002
[23362.444962] scsi_eh_1: aborting cmd:0xffff880701420c00
[23362.444999] mptscsih: ioc0: attempting task abort! (sc=ffff880701420c00)
[23362.445039] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 2b f3 ff 47 00 00 08 00
[23362.445112] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880701420c00)
[23362.445295] scsi_eh_done scmd: ffff880701420c00 result: 0
[23362.445326] scsi_send_eh_cmnd: scmd: ffff880701420c00, timeleft: 2500
[23362.445354] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.445387] scsi_eh_tur: scmd ffff880701420c00 rtn 2002
[23362.445413] scsi_eh_1: aborting cmd:0xffff88072ff7ee00
[23362.445444] mptscsih: ioc0: attempting task abort! (sc=ffff88072ff7ee00)
[23362.445481] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 2e 90 82 e7 00 00 08 00
[23362.445545] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072ff7ee00)
[23362.445746] scsi_eh_done scmd: ffff88072ff7ee00 result: 0
[23362.445888] scsi_send_eh_cmnd: scmd: ffff88072ff7ee00, timeleft: 2500
[23362.445927] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.445959] scsi_eh_tur: scmd ffff88072ff7ee00 rtn 2002
[23362.445999] scsi_eh_1: aborting cmd:0xffff8807a3630600
[23362.446025] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3630600)
[23362.446054] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 31 38 00 3f 00 00 08 00
[23362.446116] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3630600)
[23362.446302] scsi_eh_done scmd: ffff8807a3630600 result: 0
[23362.446350] scsi_send_eh_cmnd: scmd: ffff8807a3630600, timeleft: 2500
[23362.446383] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.446410] scsi_eh_tur: scmd ffff8807a3630600 rtn 2002
[23362.446435] scsi_eh_1: aborting cmd:0xffff88078245d500
[23362.446471] mptscsih: ioc0: attempting task abort! (sc=ffff88078245d500)
[23362.446513] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 31 38 97 bf 00 00 08 00
[23362.446570] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88078245d500)
[23362.446747] scsi_eh_done scmd: ffff88078245d500 result: 0
[23362.446778] scsi_send_eh_cmnd: scmd: ffff88078245d500, timeleft: 2500
[23362.446807] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.446839] scsi_eh_tur: scmd ffff88078245d500 rtn 2002
[23362.446884] scsi_eh_1: aborting cmd:0xffff8807af65e200
[23362.446919] mptscsih: ioc0: attempting task abort! (sc=ffff8807af65e200)
[23362.446947] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 35 7b 9f 97 00 00 08 00
[23362.446999] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af65e200)
[23362.447188] scsi_eh_done scmd: ffff8807af65e200 result: 0
[23362.447224] scsi_send_eh_cmnd: scmd: ffff8807af65e200, timeleft: 2500
[23362.447272] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.447307] scsi_eh_tur: scmd ffff8807af65e200 rtn 2002
[23362.447333] scsi_eh_1: aborting cmd:0xffff88078250a600
[23362.447358] mptscsih: ioc0: attempting task abort! (sc=ffff88078250a600)
[23362.447396] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 35 7b 9f a7 00 00 08 00
[23362.447468] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88078250a600)
[23362.447646] scsi_eh_done scmd: ffff88078250a600 result: 0
[23362.447677] scsi_send_eh_cmnd: scmd: ffff88078250a600, timeleft: 2500
[23362.447705] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.447741] scsi_eh_tur: scmd ffff88078250a600 rtn 2002
[23362.447791] scsi_eh_1: aborting cmd:0xffff8807af407800
[23362.447821] mptscsih: ioc0: attempting task abort! (sc=ffff8807af407800)
[23362.447849] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 38 31 5a 7f 00 00 08 00
[23362.447911] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af407800)
[23362.448109] scsi_eh_done scmd: ffff8807af407800 result: 0
[23362.448414] scsi_send_eh_cmnd: scmd: ffff8807af407800, timeleft: 2500
[23362.448442] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.448480] scsi_eh_tur: scmd ffff8807af407800 rtn 2002
[23362.448510] scsi_eh_1: aborting cmd:0xffff8807a34ead00
[23362.448545] mptscsih: ioc0: attempting task abort! (sc=ffff8807a34ead00)
[23362.448577] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 38 42 d9 87 00 00 08 00
[23362.448630] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a34ead00)
[23362.448813] scsi_eh_done scmd: ffff8807a34ead00 result: 0
[23362.448889] scsi_send_eh_cmnd: scmd: ffff8807a34ead00, timeleft: 2500
[23362.448920] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.448947] scsi_eh_tur: scmd ffff8807a34ead00 rtn 2002
[23362.448973] scsi_eh_1: aborting cmd:0xffff8807ab602100
[23362.449008] mptscsih: ioc0: attempting task abort! (sc=ffff8807ab602100)
[23362.449041] sd 1:0:0:5: [sdg] CDB: Write(10): 2a 00 38 e6 2e 3f 00 00 08 00
[23362.449107] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807ab602100)
[23362.449284] scsi_eh_done scmd: ffff8807ab602100 result: 0
[23362.449317] scsi_send_eh_cmnd: scmd: ffff8807ab602100, timeleft: 2500
[23362.449346] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.449380] scsi_eh_tur: scmd ffff8807ab602100 rtn 2002
[23362.449430] scsi_eh_1: aborting cmd:0xffff88071aa08e00
[23362.449460] mptscsih: ioc0: attempting task abort! (sc=ffff88071aa08e00)
[23362.449488] sd 1:0:1:4: [sdl] CDB: Write(10): 2a 00 07 e6 34 96 00 00 08 00
[23362.449562] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88071aa08e00)
[23362.449937] scsi_eh_done scmd: ffff88071aa08e00 result: 0
[23362.449982] scsi_send_eh_cmnd: scmd: ffff88071aa08e00, timeleft: 2500
[23362.450015] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.450042] scsi_eh_tur: scmd ffff88071aa08e00 rtn 2002
[23362.450067] scsi_eh_1: aborting cmd:0xffff8807be839600
[23362.450104] mptscsih: ioc0: attempting task abort! (sc=ffff8807be839600)
[23362.450146] sd 1:0:1:4: [sdl] CDB: Write(10): 2a 00 07 e6 38 fe 00 00 08 00
[23362.450203] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807be839600)
[23362.450379] scsi_eh_done scmd: ffff8807be839600 result: 0
[23362.450410] scsi_send_eh_cmnd: scmd: ffff8807be839600, timeleft: 2500
[23362.450438] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.450473] scsi_eh_tur: scmd ffff8807be839600 rtn 2002
[23362.450508] scsi_eh_1: aborting cmd:0xffff880782634d00
[23362.450548] mptscsih: ioc0: attempting task abort! (sc=ffff880782634d00)
[23362.450581] sd 1:0:1:4: [sdl] CDB: Write(10): 2a 00 07 e6 34 5e 00 00 08 00
[23362.450633] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880782634d00)
[23362.450825] scsi_eh_done scmd: ffff880782634d00 result: 0
[23362.450855] scsi_send_eh_cmnd: scmd: ffff880782634d00, timeleft: 2500
[23362.450907] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.450938] scsi_eh_tur: scmd ffff880782634d00 rtn 2002
[23362.450964] scsi_eh_1: aborting cmd:0xffff8807c2f50300
[23362.450989] mptscsih: ioc0: attempting task abort! (sc=ffff8807c2f50300)
[23362.451027] sd 1:0:1:4: [sdl] CDB: Write(10): 2a 00 07 ba 37 16 00 00 08 00
[23362.451099] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807c2f50300)
[23362.451275] scsi_eh_done scmd: ffff8807c2f50300 result: 0
[23362.451307] scsi_send_eh_cmnd: scmd: ffff8807c2f50300, timeleft: 2500
[23362.451336] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.451368] scsi_eh_tur: scmd ffff8807c2f50300 rtn 2002
[23362.451428] scsi_eh_1: aborting cmd:0xffff8806c2173b00
[23362.451454] mptscsih: ioc0: attempting task abort! (sc=ffff8806c2173b00)
[23362.451482] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 cc 08 37 00 00 08 00
[23362.451549] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806c2173b00)
[23362.451736] scsi_eh_done scmd: ffff8806c2173b00 result: 0
[23362.451781] scsi_send_eh_cmnd: scmd: ffff8806c2173b00, timeleft: 2500
[23362.451809] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.451836] scsi_eh_tur: scmd ffff8806c2173b00 rtn 2002
[23362.451880] scsi_eh_1: aborting cmd:0xffff88072fd25800
[23362.451906] mptscsih: ioc0: attempting task abort! (sc=ffff88072fd25800)
[23362.451934] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 d8 01 0f 00 00 08 00
[23362.452019] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fd25800)
[23362.452191] scsi_eh_done scmd: ffff88072fd25800 result: 0
[23362.452520] scsi_send_eh_cmnd: scmd: ffff88072fd25800, timeleft: 2500
[23362.452548] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.452586] scsi_eh_tur: scmd ffff88072fd25800 rtn 2002
[23362.452621] scsi_eh_1: aborting cmd:0xffff88078245c600
[23362.452651] mptscsih: ioc0: attempting task abort! (sc=ffff88078245c600)
[23362.452680] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e0 00 d7 00 00 08 00
[23362.452742] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88078245c600)
[23362.452925] scsi_eh_done scmd: ffff88078245c600 result: 0
[23362.453030] scsi_send_eh_cmnd: scmd: ffff88078245c600, timeleft: 2500
[23362.453059] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.453096] scsi_eh_tur: scmd ffff88078245c600 rtn 2002
[23362.453132] scsi_eh_1: aborting cmd:0xffff8807b7d78f00
[23362.453162] mptscsih: ioc0: attempting task abort! (sc=ffff8807b7d78f00)
[23362.453190] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e4 00 3f 00 00 08 00
[23362.453252] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807b7d78f00)
[23362.453424] scsi_eh_done scmd: ffff8807b7d78f00 result: 0
[23362.453464] scsi_send_eh_cmnd: scmd: ffff8807b7d78f00, timeleft: 2500
[23362.453492] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.453528] scsi_eh_tur: scmd ffff8807b7d78f00 rtn 2002
[23362.453554] scsi_eh_1: aborting cmd:0xffff8807af467600
[23362.453589] mptscsih: ioc0: attempting task abort! (sc=ffff8807af467600)
[23362.453618] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e4 00 b7 00 00 08 00
[23362.453679] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807af467600)
[23362.453855] scsi_eh_done scmd: ffff8807af467600 result: 0
[23362.453886] scsi_send_eh_cmnd: scmd: ffff8807af467600, timeleft: 2500
[23362.453924] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.453951] scsi_eh_tur: scmd ffff8807af467600 rtn 2002
[23362.453985] scsi_eh_1: aborting cmd:0xffff88072fe19000
[23362.454011] mptscsih: ioc0: attempting task abort! (sc=ffff88072fe19000)
[23362.454039] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e4 00 df 00 00 08 00
[23362.454102] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fe19000)
[23362.454283] scsi_eh_done scmd: ffff88072fe19000 result: 0
[23362.454714] scsi_send_eh_cmnd: scmd: ffff88072fe19000, timeleft: 2500
[23362.454744] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.454771] scsi_eh_tur: scmd ffff88072fe19000 rtn 2002
[23362.454802] scsi_eh_1: aborting cmd:0xffff88081a3c9a00
[23362.454839] mptscsih: ioc0: attempting task abort! (sc=ffff88081a3c9a00)
[23362.454868] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e4 01 57 00 00 08 00
[23362.454929] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a3c9a00)
[23362.455108] scsi_eh_done scmd: ffff88081a3c9a00 result: 0
[23362.455144] scsi_send_eh_cmnd: scmd: ffff88081a3c9a00, timeleft: 2500
[23362.455172] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.455210] scsi_eh_tur: scmd ffff88081a3c9a00 rtn 2002
[23362.455236] scsi_eh_1: aborting cmd:0xffff8806e5e92400
[23362.455270] mptscsih: ioc0: attempting task abort! (sc=ffff8806e5e92400)
[23362.455298] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e4 03 27 00 00 08 00
[23362.455351] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806e5e92400)
[23362.455533] scsi_eh_done scmd: ffff8806e5e92400 result: 0
[23362.455821] scsi_send_eh_cmnd: scmd: ffff8806e5e92400, timeleft: 2500
[23362.455849] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.455876] scsi_eh_tur: scmd ffff8806e5e92400 rtn 2002
[23362.455915] scsi_eh_1: aborting cmd:0xffff8806c22ea500
[23362.455940] mptscsih: ioc0: attempting task abort! (sc=ffff8806c22ea500)
[23362.455977] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 02 e4 03 87 00 00 08 00
[23362.456046] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806c22ea500)
[23362.456219] scsi_eh_done scmd: ffff8806c22ea500 result: 0
[23362.456680] scsi_send_eh_cmnd: scmd: ffff8806c22ea500, timeleft: 2500
[23362.456709] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.456736] scsi_eh_tur: scmd ffff8806c22ea500 rtn 2002
[23362.456762] scsi_eh_1: aborting cmd:0xffff8807b7ec7700
[23362.456788] mptscsih: ioc0: attempting task abort! (sc=ffff8807b7ec7700)
[23362.456828] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 00 00 bf 00 00 08 00
[23362.458587] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807b7ec7700)
[23362.458771] scsi_eh_done scmd: ffff8807b7ec7700 result: 0
[23362.458803] scsi_send_eh_cmnd: scmd: ffff8807b7ec7700, timeleft: 2500
[23362.458836] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.458863] scsi_eh_tur: scmd ffff8807b7ec7700 rtn 2002
[23362.458889] scsi_eh_1: aborting cmd:0xffff880824756800
[23362.458915] mptscsih: ioc0: attempting task abort! (sc=ffff880824756800)
[23362.458951] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 04 01 67 00 00 08 00
[23362.459011] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880824756800)
[23362.459187] scsi_eh_done scmd: ffff880824756800 result: 0
[23362.459218] scsi_send_eh_cmnd: scmd: ffff880824756800, timeleft: 2500
[23362.459247] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.459274] scsi_eh_tur: scmd ffff880824756800 rtn 2002
[23362.459316] scsi_eh_1: aborting cmd:0xffff8807a34a2900
[23362.459355] mptscsih: ioc0: attempting task abort! (sc=ffff8807a34a2900)
[23362.459388] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 04 05 17 00 00 08 00
[23362.459440] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a34a2900)
[23362.459614] scsi_eh_done scmd: ffff8807a34a2900 result: 0
[23362.459645] scsi_send_eh_cmnd: scmd: ffff8807a34a2900, timeleft: 2500
[23362.459688] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.459729] scsi_eh_tur: scmd ffff8807a34a2900 rtn 2002
[23362.459759] scsi_eh_1: aborting cmd:0xffff88072fe71100
[23362.459785] mptscsih: ioc0: attempting task abort! (sc=ffff88072fe71100)
[23362.459814] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 08 00 3f 00 00 08 00
[23362.459881] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88072fe71100)
[23362.460079] scsi_eh_done scmd: ffff88072fe71100 result: 0
[23362.460362] scsi_send_eh_cmnd: scmd: ffff88072fe71100, timeleft: 2500
[23362.460397] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.460425] scsi_eh_tur: scmd ffff88072fe71100 rtn 2002
[23362.460456] scsi_eh_1: aborting cmd:0xffff88080ab28100
[23362.460482] mptscsih: ioc0: attempting task abort! (sc=ffff88080ab28100)
[23362.460511] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 08 01 0f 00 00 08 00
[23362.460579] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88080ab28100)
[23362.460765] scsi_eh_done scmd: ffff88080ab28100 result: 0
[23362.460807] scsi_send_eh_cmnd: scmd: ffff88080ab28100, timeleft: 2500
[23362.460842] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.460869] scsi_eh_tur: scmd ffff88080ab28100 rtn 2002
[23362.460895] scsi_eh_1: aborting cmd:0xffff88081a234600
[23362.460930] mptscsih: ioc0: attempting task abort! (sc=ffff88081a234600)
[23362.460963] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 08 02 5f 00 00 08 00
[23362.461039] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a234600)
[23362.461216] scsi_eh_done scmd: ffff88081a234600 result: 0
[23362.461247] scsi_send_eh_cmnd: scmd: ffff88081a234600, timeleft: 2500
[23362.461284] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.461311] scsi_eh_tur: scmd ffff88081a234600 rtn 2002
[23362.461361] scsi_eh_1: aborting cmd:0xffff8806b90e8c00
[23362.461391] mptscsih: ioc0: attempting task abort! (sc=ffff8806b90e8c00)
[23362.461420] sd 1:0:0:2: [sdd] CDB: Write(10): 2a 00 00 08 02 b7 00 00 08 00
[23362.461486] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8806b90e8c00)
[23362.461681] scsi_eh_done scmd: ffff8806b90e8c00 result: 0
[23362.461735] scsi_send_eh_cmnd: scmd: ffff8806b90e8c00, timeleft: 2500
[23362.461767] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.461794] scsi_eh_tur: scmd ffff8806b90e8c00 rtn 2002
[23362.461831] scsi_eh_1: aborting cmd:0xffff88081a2a8700
[23362.461871] mptscsih: ioc0: attempting task abort! (sc=ffff88081a2a8700)
[23362.461903] sd 1:0:0:4: [sdf] CDB: Write(10): 2a 00 00 7c 44 1f 00 00 10 00
[23362.461956] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88081a2a8700)
[23362.462144] scsi_eh_done scmd: ffff88081a2a8700 result: 0
[23362.462181] scsi_send_eh_cmnd: scmd: ffff88081a2a8700, timeleft: 2500
[23362.462229] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.462264] scsi_eh_tur: scmd ffff88081a2a8700 rtn 2002
[23362.462289] scsi_eh_1: aborting cmd:0xffff8807a362c900
[23362.462315] mptscsih: ioc0: attempting task abort! (sc=ffff8807a362c900)
[23362.462353] sd 1:0:0:4: [sdf] CDB: Write(10): 2a 00 00 7c 45 4f 00 00 08 00
[23362.462424] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a362c900)
[23362.462603] scsi_eh_done scmd: ffff8807a362c900 result: 0
[23362.462634] scsi_send_eh_cmnd: scmd: ffff8807a362c900, timeleft: 2500
[23362.462663] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.462690] scsi_eh_tur: scmd ffff8807a362c900 rtn 2002
[23362.462727] scsi_eh_1: aborting cmd:0xffff8807a3454c00
[23362.462771] mptscsih: ioc0: attempting task abort! (sc=ffff8807a3454c00)
[23362.462804] sd 1:0:1:3: [sdk] CDB: Write(10): 2a 00 7a 68 93 60 00 00 08 00
[23362.462856] mptscsih: ioc0: task abort: SUCCESS (sc=ffff8807a3454c00)
[23362.463043] scsi_eh_done scmd: ffff8807a3454c00 result: 0
[23362.463079] scsi_send_eh_cmnd: scmd: ffff8807a3454c00, timeleft: 2500
[23362.463126] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.463162] scsi_eh_tur: scmd ffff8807a3454c00 rtn 2002
[23362.463188] scsi_eh_1: aborting cmd:0xffff880540767800
[23362.463214] mptscsih: ioc0: attempting task abort! (sc=ffff880540767800)
[23362.463252] sd 1:0:0:3: [sde] CDB: Write(10): 2a 00 e6 20 96 a4 00 00 30 00
[23362.463323] mptscsih: ioc0: task abort: SUCCESS (sc=ffff880540767800)
[23362.463500] scsi_eh_done scmd: ffff880540767800 result: 0
[23362.463531] scsi_send_eh_cmnd: scmd: ffff880540767800, timeleft: 2500
[23362.463559] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[23362.463591] scsi_eh_tur: scmd ffff880540767800 rtn 2002
[23362.463627] scsi_eh_1: flush retry cmd: ffff8807a367f100
[23362.463665] scsi_eh_1: flush retry cmd: ffff8807af46cb00
[23362.463692] scsi_eh_1: flush retry cmd: ffff8806e5de1700
[23362.463719] scsi_eh_1: flush retry cmd: ffff8807a35fd600
[23362.463746] scsi_eh_1: flush retry cmd: ffff88058581df00
[23362.463773] scsi_eh_1: flush retry cmd: ffff8807b7f06100
[23362.463799] scsi_eh_1: flush retry cmd: ffff88080a866200
[23362.463826] scsi_eh_1: flush retry cmd: ffff8807ab52f700
[23362.463853] scsi_eh_1: flush retry cmd: ffff8807a3755700
[23362.463879] scsi_eh_1: flush retry cmd: ffff8807af519400
[23362.463906] scsi_eh_1: flush retry cmd: ffff8807a34cc400
[23362.463933] scsi_eh_1: flush retry cmd: ffff8806b90e7400
[23362.463960] scsi_eh_1: flush retry cmd: ffff8805a49b3d00
[23362.463986] scsi_eh_1: flush retry cmd: ffff8807ab41c800
[23362.464035] scsi_eh_1: flush retry cmd: ffff88080a800d00
[23362.464065] scsi_eh_1: flush retry cmd: ffff880782498200
[23362.464095] scsi_eh_1: flush retry cmd: ffff880782675800
[23362.464125] scsi_eh_1: flush retry cmd: ffff8806e5d4e700
[23362.464166] scsi_eh_1: flush retry cmd: ffff880782408200
[23362.464203] scsi_eh_1: flush retry cmd: ffff88081a3c3d00
[23362.464233] scsi_eh_1: flush retry cmd: ffff88083de79700
[23362.464260] scsi_eh_1: flush retry cmd: ffff8806c23a4000
[23362.464287] scsi_eh_1: flush retry cmd: ffff88081a2ccb00
[23362.464314] scsi_eh_1: flush retry cmd: ffff8807826c3c00
[23362.464341] scsi_eh_1: flush retry cmd: ffff88072fe0a600
[23362.464368] scsi_eh_1: flush retry cmd: ffff88072fe17b00
[23362.464395] scsi_eh_1: flush retry cmd: ffff88071a933300
[23362.464423] scsi_eh_1: flush retry cmd: ffff8806b91a6300
[23362.464450] scsi_eh_1: flush retry cmd: ffff88071aa35300
[23362.464486] scsi_eh_1: flush retry cmd: ffff8807be8d8400
[23362.464513] scsi_eh_1: flush retry cmd: ffff8807a34af700
[23362.464540] scsi_eh_1: flush retry cmd: ffff88072fc53f00
[23362.464567] scsi_eh_1: flush retry cmd: ffff8807a35a7000
[23362.464594] scsi_eh_1: flush retry cmd: ffff88071a9a4300
[23362.464621] scsi_eh_1: flush retry cmd: ffff88078240d600
[23362.464648] scsi_eh_1: flush retry cmd: ffff88082441de00
[23362.464675] scsi_eh_1: flush retry cmd: ffff880782437a00
[23362.464702] scsi_eh_1: flush retry cmd: ffff8807ab65bf00
[23362.464729] scsi_eh_1: flush retry cmd: ffff8807e17ca800
[23362.464762] scsi_eh_1: flush retry cmd: ffff8807ab752800
[23362.464790] scsi_eh_1: flush retry cmd: ffff8807e14e4d00
[23362.464816] scsi_eh_1: flush retry cmd: ffff8807a34efd00
[23362.464843] scsi_eh_1: flush retry cmd: ffff8807af77d500
[23362.464879] scsi_eh_1: flush retry cmd: ffff8805b1354900
[23362.464907] scsi_eh_1: flush retry cmd: ffff88072fe20d00
[23362.464939] scsi_eh_1: flush retry cmd: ffff88072fcc4b00
[23362.464966] scsi_eh_1: flush retry cmd: ffff88078264a600
[23362.464994] scsi_eh_1: flush retry cmd: ffff8807a355ae00
[23362.465021] scsi_eh_1: flush retry cmd: ffff880782576f00
[23362.465056] scsi_eh_1: flush retry cmd: ffff880701440f00
[23362.465084] scsi_eh_1: flush retry cmd: ffff88051292e800
[23362.465114] scsi_eh_1: flush retry cmd: ffff88081a3cb400
[23362.465144] scsi_eh_1: flush retry cmd: ffff880701783100
[23362.465174] scsi_eh_1: flush retry cmd: ffff8807a3652800
[23362.465203] scsi_eh_1: flush retry cmd: ffff8807a3652c00
[23362.465230] scsi_eh_1: flush retry cmd: ffff8807824be900
[23362.465263] scsi_eh_1: flush retry cmd: ffff88054059eb00
[23362.465297] scsi_eh_1: flush retry cmd: ffff8806c2151700
[23362.465323] scsi_eh_1: flush retry cmd: ffff8806c2151400
[23362.465355] scsi_eh_1: flush retry cmd: ffff880512925600
[23362.465382] scsi_eh_1: flush retry cmd: ffff880512925b00
[23362.465409] scsi_eh_1: flush retry cmd: ffff880782519b00
[23362.465436] scsi_eh_1: flush retry cmd: ffff8807a34cf600
[23362.465462] scsi_eh_1: flush retry cmd: ffff8806c23d5500
[23362.465489] scsi_eh_1: flush retry cmd: ffff8807af6ed100
[23362.465516] scsi_eh_1: flush retry cmd: ffff8807c2ebfa00
[23362.465550] scsi_eh_1: flush retry cmd: ffff88069ede7e00
[23362.465577] scsi_eh_1: flush retry cmd: ffff8807a3665700
[23362.465605] scsi_eh_1: flush retry cmd: ffff8807bea97b00
[23362.465632] scsi_eh_1: flush retry cmd: ffff8807a3610100
[23362.465658] scsi_eh_1: flush retry cmd: ffff8807a3610b00
[23362.465685] scsi_eh_1: flush retry cmd: ffff88051298e600
[23362.465711] scsi_eh_1: flush retry cmd: ffff8807beb95f00
[23362.465738] scsi_eh_1: flush retry cmd: ffff8807a3578900
[23362.465764] scsi_eh_1: flush retry cmd: ffff88072fd1b900
[23362.465791] scsi_eh_1: flush retry cmd: ffff8807ab641f00
[23362.465818] scsi_eh_1: flush retry cmd: ffff88081a3cec00
[23362.465845] scsi_eh_1: flush retry cmd: ffff8807a379f400
[23362.465871] scsi_eh_1: flush retry cmd: ffff8807a3730c00
[23362.465898] scsi_eh_1: flush retry cmd: ffff8806b9106f00
[23362.465925] scsi_eh_1: flush retry cmd: ffff8806b939a400
[23362.465952] scsi_eh_1: flush retry cmd: ffff880782719300
[23362.465979] scsi_eh_1: flush retry cmd: ffff88072fce6100
[23362.466005] scsi_eh_1: flush retry cmd: ffff8807a376a300
[23362.466032] scsi_eh_1: flush retry cmd: ffff8807ab675a00
[23362.466059] scsi_eh_1: flush retry cmd: ffff8807ab675800
[23362.466086] scsi_eh_1: flush retry cmd: ffff8807be802800
[23362.466113] scsi_eh_1: flush retry cmd: ffff8807ab7ceb00
[23362.466140] scsi_eh_1: flush retry cmd: ffff8807ab7ce800
[23362.466167] scsi_eh_1: flush retry cmd: ffff8806b93f8700
[23362.466193] scsi_eh_1: flush retry cmd: ffff8807c2c54300
[23362.466227] scsi_eh_1: flush retry cmd: ffff88080aa53800
[23362.466253] scsi_eh_1: flush retry cmd: ffff8805129b4900
[23362.466286] scsi_eh_1: flush retry cmd: ffff88080a8dd500
[23362.466313] scsi_eh_1: flush retry cmd: ffff880701420c00
[23362.467962] scsi_eh_1: flush retry cmd: ffff88072ff7ee00
[23362.467989] scsi_eh_1: flush retry cmd: ffff8807a3630600
[23362.468028] scsi_eh_1: flush retry cmd: ffff88078245d500
[23362.468055] scsi_eh_1: flush retry cmd: ffff8807af65e200
[23362.468082] scsi_eh_1: flush retry cmd: ffff88078250a600
[23362.468108] scsi_eh_1: flush retry cmd: ffff8807af407800
[23362.468135] scsi_eh_1: flush retry cmd: ffff8807a34ead00
[23362.468161] scsi_eh_1: flush retry cmd: ffff8807ab602100
[23362.468188] scsi_eh_1: flush retry cmd: ffff88071aa08e00
[23362.468215] scsi_eh_1: flush retry cmd: ffff8807be839600
[23362.468246] scsi_eh_1: flush retry cmd: ffff880782634d00
[23362.468272] scsi_eh_1: flush retry cmd: ffff8807c2f50300
[23362.468299] scsi_eh_1: flush retry cmd: ffff8806c2173b00
[23362.468325] scsi_eh_1: flush retry cmd: ffff88072fd25800
[23362.468351] scsi_eh_1: flush retry cmd: ffff88078245c600
[23362.468377] scsi_eh_1: flush retry cmd: ffff8807b7d78f00
[23362.468404] scsi_eh_1: flush retry cmd: ffff8807af467600
[23362.468430] scsi_eh_1: flush retry cmd: ffff88072fe19000
[23362.468457] scsi_eh_1: flush retry cmd: ffff88081a3c9a00
[23362.468483] scsi_eh_1: flush retry cmd: ffff8806e5e92400
[23362.468509] scsi_eh_1: flush retry cmd: ffff8806c22ea500
[23362.468535] scsi_eh_1: flush retry cmd: ffff8807b7ec7700
[23362.468561] scsi_eh_1: flush retry cmd: ffff880824756800
[23362.468588] scsi_eh_1: flush retry cmd: ffff8807a34a2900
[23362.468614] scsi_eh_1: flush retry cmd: ffff88072fe71100
[23362.468640] scsi_eh_1: flush retry cmd: ffff88080ab28100
[23362.468666] scsi_eh_1: flush retry cmd: ffff88081a234600
[23362.468692] scsi_eh_1: flush retry cmd: ffff8806b90e8c00
[23362.468719] scsi_eh_1: flush retry cmd: ffff88081a2a8700
[23362.468745] scsi_eh_1: flush retry cmd: ffff8807a362c900
[23362.468771] scsi_eh_1: flush retry cmd: ffff8807a3454c00
[23362.468798] scsi_eh_1: flush retry cmd: ffff880540767800
[23362.468828] scsi_restart_operations: waking up host to restart
[23362.469052] Error handler scsi_eh_1 sleeping
[23362.504058] scsi_block_when_processing_errors: rtn: 1
[23362.504098] scsi_block_when_processing_errors: rtn: 1
[23364.504050] scsi_block_when_processing_errors: rtn: 1

--cNdxnHkX5QqsyA0e--
