From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Sat, 6 Nov 2010 11:51:38 GMT
Message-ID: <201011061151.oA6BpcPP014386@demeter1.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38461 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0KFLvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2010 07:51:39 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA6Bpc6n014387
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 6 Nov 2010 11:51:38 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652


quintin@quintin.co.nz changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |quintin@quintin.co.nz




--- Comment #6 from quintin@quintin.co.nz  2010-11-06 11:51:34 ---
I too am seeing this behavior on 2.6.26 after applying the patch from:
http://lkml.org/lkml/2010/4/26/335 - The drives we're using are: WD5000BEKT

Sometimes we have 1 drive drop from the array, other times multiple. The
messages from the latest were:

[2149681.954263] EXT3 FS on dm-1, internal journal
[2149681.954396] EXT3-fs: mounted filesystem with ordered data mode.
[2150378.948488] mptscsih: ioc0: attempting task abort! (sc=ffff88000b13b580)
[2150378.948589] sd 1:0:6:0: [sdh] CDB: Synchronize Cache(10): 35 00 00 00 00
00 00 00 00 00
[2150383.337348] mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO
Executed}, SubCode(0x0000)
[2150383.337806] mptsas: ioc0: removing sata device, channel 0, id 6, phy 6
[2150383.337902]  port-1:6: mptsas: ioc0: delete port (6)
[2150383.338043] sd 1:0:6:0: [sdh] Synchronizing SCSI cache
[2150383.554191] mptscsih: ioc0: task abort: SUCCESS (sc=ffff88000b13b580)
[2150383.554292] mptscsih: ioc0: attempting target reset! (sc=ffff88000b13b580)
[2150383.554372] sd 1:0:6:0: [sdh] CDB: Synchronize Cache(10): 35 00 00 00 00
00 00 00 00 00
[2150383.810191] mptscsih: ioc0: target reset: SUCCESS (sc=ffff88000b13b580)
[2150383.810288] mptscsih: ioc0: attempting bus reset! (sc=ffff88000b13b580)
[2150383.810367] sd 1:0:6:0: [sdh] CDB: Synchronize Cache(10): 35 00 00 00 00
00 00 00 00 00
[2150384.578124] mptscsih: ioc0: bus reset: SUCCESS (sc=ffff88000b13b580)
[2150394.582457] mptscsih: ioc0: attempting host reset! (sc=ffff88000b13b580)
[2150394.582555] mptbase: ioc0: Initiating recovery
[2150415.384673] mptscsih: ioc0: host reset: SUCCESS (sc=ffff88000b13b580)
[2150415.384773] sd 1:0:6:0: Device offlined - not ready after error recovery
[2150415.384865] end_request: I/O error, dev sdh, sector 976767931
[2150415.384944] md: super_written gets error=-5, uptodate=0
[2150415.385021] raid10: Disk failure on sdh6, disabling device.
[2150415.385022] raid10: Operation continuing on 7 devices.
[2150415.385223] raid10: sdh6: rescheduling sector 439149440
[2150415.385302] raid10: sdh6: rescheduling sector 439149456
[2150415.385378] raid10: sdh6: rescheduling sector 439149464
[2150415.385454] raid10: sdh6: rescheduling sector 439149472
[2150415.385530] raid10: sdh6: rescheduling sector 439149480
[2150415.385606] raid10: sdh6: rescheduling sector 439149488
[2150415.385682] raid10: sdh6: rescheduling sector 439149496
[2150415.385758] raid10: sdh6: rescheduling sector 439149504
[2150415.385834] raid10: sdh6: rescheduling sector 439149512
[2150415.385910] raid10: sdh6: rescheduling sector 439149520
[2150415.385990] end_request: I/O error, dev sdh, sector 20000703
[2150415.386067] md: super_written gets error=-5, uptodate=0
[2150415.386143] raid1: Disk failure on sdh1, disabling device.
[2150415.386144] raid1: Operation continuing on 7 devices.
[2150415.386422] sd 1:0:6:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK,SUGGEST_OK
[2150415.760573] raid10: Disk failure on sdh5, disabling device.
[2150415.760576] raid10: Operation continuing on 7 devices.
[2150415.786990] RAID1 conf printout:
[2150415.787080]  --- wd:7 rd:8
[2150415.787151]  disk 0, wo:0, o:1, dev:sdb1
[2150415.787225]  disk 1, wo:0, o:1, dev:sdc1
[2150415.787298]  disk 2, wo:0, o:1, dev:sdd1
[2150415.787381]  disk 3, wo:0, o:1, dev:sde1
[2150415.787455]  disk 4, wo:0, o:1, dev:sdf1
[2150415.787528]  disk 5, wo:0, o:1, dev:sdg1
[2150415.787611]  disk 6, wo:1, o:0, dev:sdh1
[2150415.787664]  disk 7, wo:0, o:1, dev:sdi1
[2150415.796490] RAID1 conf printout:
[2150415.796581]  --- wd:7 rd:8
[2150415.796653]  disk 0, wo:0, o:1, dev:sdb1
[2150415.796727]  disk 1, wo:0, o:1, dev:sdc1
[2150415.796800]  disk 2, wo:0, o:1, dev:sdd1
[2150415.796873]  disk 3, wo:0, o:1, dev:sde1
[2150415.796958]  disk 4, wo:0, o:1, dev:sdf1
[2150415.797032]  disk 5, wo:0, o:1, dev:sdg1
[2150415.797105]  disk 7, wo:0, o:1, dev:sdi1
[2150415.813487] RAID10 conf printout:
[2150415.813573]  --- wd:7 rd:8
[2150415.813645]  disk 0, wo:0, o:1, dev:sdb6
[2150415.813730]  disk 1, wo:0, o:1, dev:sdc6
[2150415.813803]  disk 2, wo:0, o:1, dev:sdd6
[2150415.813885]  disk 3, wo:0, o:1, dev:sde6
[2150415.813970]  disk 4, wo:0, o:1, dev:sdf6
[2150415.814044]  disk 5, wo:0, o:1, dev:sdg6
[2150415.814117]  disk 6, wo:1, o:0, dev:sdh6
[2150415.814200]  disk 7, wo:0, o:1, dev:sdi6
[2150415.815864] RAID10 conf printout:
[2150415.815937]  --- wd:7 rd:8
[2150415.816009]  disk 0, wo:0, o:1, dev:sdb6
[2150415.816082]  disk 1, wo:0, o:1, dev:sdc6
[2150415.816156]  disk 2, wo:0, o:1, dev:sdd6
[2150415.816229]  disk 3, wo:0, o:1, dev:sde6
[2150415.816302]  disk 4, wo:0, o:1, dev:sdf6
[2150415.821507]  disk 5, wo:0, o:1, dev:sdg6
[2150415.821580]  disk 7, wo:0, o:1, dev:sdi6
[2150415.843762] RAID10 conf printout:
[2150415.843839]  --- wd:7 rd:8
[2150415.843911]  disk 0, wo:0, o:1, dev:sdb5
[2150415.843984]  disk 1, wo:0, o:1, dev:sdc5
[2150415.844058]  disk 2, wo:0, o:1, dev:sdd5
[2150415.844131]  disk 3, wo:0, o:1, dev:sde5
[2150415.844204]  disk 4, wo:0, o:1, dev:sdf5
[2150415.844278]  disk 5, wo:0, o:1, dev:sdg5
[2150415.844351]  disk 6, wo:1, o:0, dev:sdh5
[2150415.844424]  disk 7, wo:0, o:1, dev:sdi5
[2150415.853059] RAID10 conf printout:
[2150415.853135]  --- wd:7 rd:8
[2150415.853206]  disk 0, wo:0, o:1, dev:sdb5
[2150415.853279]  disk 1, wo:0, o:1, dev:sdc5
[2150415.853352]  disk 2, wo:0, o:1, dev:sdd5
[2150415.853426]  disk 3, wo:0, o:1, dev:sde5
[2150415.853499]  disk 4, wo:0, o:1, dev:sdf5
[2150415.853572]  disk 5, wo:0, o:1, dev:sdg5
[2150415.853645]  disk 7, wo:0, o:1, dev:sdi5
[2150450.460260] mptsas: ioc0: attaching sata device, channel 0, id 6, phy 6
[2150450.466970] scsi 1:0:8:0: Direct-Access     ATA      WDC WD5000BEKT-6 1A01
PQ: 0 ANSI: 5
[2150450.468312] sd 1:0:8:0: [sdj] 976773168 512-byte hardware sectors (500108
MB)
[2150450.475724] sd 1:0:8:0: [sdj] Write Protect is off
[2150450.475802] sd 1:0:8:0: [sdj] Mode Sense: 73 00 00 08
[2150450.481065] sd 1:0:8:0: [sdj] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[2150450.481385] sd 1:0:8:0: [sdj] 976773168 512-byte hardware sectors (500108
MB)
[2150450.489103] sd 1:0:8:0: [sdj] Write Protect is off
[2150450.489179] sd 1:0:8:0: [sdj] Mode Sense: 73 00 00 08
[2150450.494628] sd 1:0:8:0: [sdj] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[2150450.494731]  sdj: sdj1 sdj2 < sdj5 sdj6 >
[2150450.831656] sd 1:0:8:0: [sdj] Attached SCSI disk

Upon further testing the drive turns out to be fine. I have hardware available
& are happy to test patches / perform additional debugging if required.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
