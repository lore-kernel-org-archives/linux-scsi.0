From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13594] SMART responses for SATA disks on SAS get interpreted as
 errors
Date: Wed, 12 May 2010 17:43:03 GMT
Message-ID: <201005121743.o4CHh3hZ013341@demeter.kernel.org>
References: <bug-13594-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34213 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0ELRnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 13:43:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4CHh3mn013342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 12 May 2010 17:43:03 GMT
In-Reply-To: <bug-13594-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D13594





--- Comment #15 from Steinar H. Gunderson <sgunderson@bigfoot.com>  201=
0-05-12 17:42:55 ---
On Wed, May 12, 2010 at 06:45:33PM +0200, Steinar H. Gunderson wrote:
> It actually seems like that in 2.6.34-rc6, I can use SMART pretty muc=
h with
> impunity. Don't know if I'm just luckier now or what happened...

Scratch that; I could use smartctl all I wanted, but installing smartd
promptly floored the entire card (and with it, the machine, since the R=
AID
went away). dmesg below.

At reboot, I kept seeing the =E2=80=9CIOC is in FAULT state=E2=80=9D un=
til I got logged in
and killed smartd again.

/* Steinar */

[588630.695020] mptscsih: ioc0: attempting task abort! (sc=3Dffff880182=
bab200)
[588630.702007] sd 0:0:4:0: [sde] CDB: ATA command pass through(16): 85=
 08 0e
00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
[588632.074809] mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, =
Code=3D{IO
Executed}, SubCode(0x0000)
[588632.084283] mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff880182bab=
200)
[588638.081578] mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x1000)
[588638.095332] mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x2000)
[588642.090380] mptscsih: ioc0: attempting task abort! (sc=3Dffff880182=
bab200)
[588642.097310] sd 0:0:4:0: [sde] CDB: Test Unit Ready: 00 00 00 00 00 =
00
[588642.104177] mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff880182bab=
200)
[588642.110862] mptscsih: ioc0: attempting task abort! (sc=3Dffff8801c9=
ffb600)
[588642.117813] sd 0:0:4:0: [sde] CDB: Synchronize Cache(10): 35 00 00 =
00 00 00
00 00 00 00
[588642.126382] mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8801c9ffb=
600)
[588652.133012] mptscsih: ioc0: attempting task abort! (sc=3Dffff8801c9=
ffb600)
[588652.140020] sd 0:0:4:0: [sde] CDB: Test Unit Ready: 00 00 00 00 00 =
00
[588652.146909] mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff8801c9ffb=
600)
[588652.153621] mptscsih: ioc0: attempting target reset! (sc=3Dffff8801=
82bab200)
[588652.160768] sd 0:0:4:0: [sde] CDB: ATA command pass through(16): 85=
 08 0e
00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
[588652.177222] mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x2000)
[588653.575199] mptscsih: ioc0: target reset: SUCCESS (sc=3Dffff880182b=
ab200)
[588656.583548] mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x1000)
[588656.594285] mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x2000)
[588663.582006] mptscsih: ioc0: attempting task abort! (sc=3Dffff880182=
bab200)
[588663.588952] sd 0:0:4:0: [sde] CDB: Test Unit Ready: 00 00 00 00 00 =
00
[588663.595810] mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff880182bab=
200)
[588663.602509] mptscsih: ioc0: attempting bus reset! (sc=3Dffff880182b=
ab200)
[588663.609381] sd 0:0:4:0: [sde] CDB: ATA command pass through(16): 85=
 08 0e
00 d5 00 01 00 09 00 4f 00 c2 00 b0 00
[588663.670443] mptbase: ioc0: LogInfo(0x31112000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x2000)
[588665.077991] mptscsih: ioc0: bus reset: SUCCESS (sc=3Dffff880182bab2=
00)
[588668.083821] mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL},
Code=3D{Reset}, SubCode(0x1000)
[588675.085656] sd 0:0:4:0: [sde] Device not ready
[588675.090326] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.097771] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.103969] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.111743] sd 0:0:4:0: [sde] CDB: Write(10): 2a 00 57 54 52 08 00 =
00 08 00
[588675.119172] end_request: I/O error, dev sde, sector 1465143816
[588675.125343] end_request: I/O error, dev sde, sector 1465143816
[588675.126238] md: super_written gets error=3D-5, uptodate=3D0
[588675.126238] raid5: Disk failure on sde6, disabling device.
[588675.126238] raid5: Operation continuing on 5 devices.
[588675.148011] sd 0:0:4:0: [sde] Device not ready
[588675.152712] sd 0:0:4:0: [sde] Device not ready
[588675.152723] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152725] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152727] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152730] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 44 bc ae 88 00 0=
0 80 00
[588675.152733] end_request: I/O error, dev sde, sector 1153216136
[588675.152740] sd 0:0:4:0: [sde] Device not ready
[588675.152741] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152743] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152745] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152747] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 2b 6a 42 70 00 0=
0 18 00
[588675.152751] end_request: I/O error, dev sde, sector 728384112
[588675.152755] sd 0:0:4:0: [sde] Device not ready
[588675.152756] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152758] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152759] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152762] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 45 9c d0 08 00 0=
0 80 00
[588675.152765] end_request: I/O error, dev sde, sector 1167904776
[588675.152769] sd 0:0:4:0: [sde] Device not ready
[588675.152770] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152771] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152773] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152775] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 2c c6 b8 88 00 0=
0 80 00
[588675.152779] end_request: I/O error, dev sde, sector 751220872
[588675.152783] sd 0:0:4:0: [sde] Device not ready
[588675.152784] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152785] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152787] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152789] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 32 fb f1 08 00 0=
0 80 00
[588675.152793] end_request: I/O error, dev sde, sector 855372040
[588675.152796] sd 0:0:4:0: [sde] Device not ready
[588675.152797] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152799] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152801] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152803] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 34 1e a8 88 00 0=
0 80 00
[588675.152806] end_request: I/O error, dev sde, sector 874424456
[588675.152811] sd 0:0:4:0: [sde] Device not ready
[588675.152812] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152813] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152815] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152817] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 3e 4d bd 88 00 0=
0 80 00
[588675.152821] end_request: I/O error, dev sde, sector 1045282184
[588675.152824] sd 0:0:4:0: [sde] Device not ready
[588675.152825] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152827] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152828] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152831] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 18 a3 50 88 00 0=
0 10 00
[588675.152834] end_request: I/O error, dev sde, sector 413356168
[588675.152838] sd 0:0:4:0: [sde] Device not ready
[588675.152839] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152841] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152842] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152845] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 18 a3 50 a0 00 0=
0 68 00
[588675.152848] end_request: I/O error, dev sde, sector 413356192
[588675.152855] sd 0:0:4:0: [sde] Device not ready
[588675.152856] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152857] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152859] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152861] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 36 12 e4 08 00 0=
0 80 00
[588675.152865] end_request: I/O error, dev sde, sector 907207688
[588675.152868] sd 0:0:4:0: [sde] Device not ready
[588675.152869] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152871] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152873] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152875] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 31 8e c0 08 00 0=
0 80 00
[588675.152878] end_request: I/O error, dev sde, sector 831438856
[588675.152882] sd 0:0:4:0: [sde] Device not ready
[588675.152883] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.152885] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.152886] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.152889] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 3d e3 2f 08 00 0=
0 80 00
[588675.152892] end_request: I/O error, dev sde, sector 1038298888
[588675.152910] end_request: I/O error, dev sdj, sector 2930271882
[588675.152912] md: super_written gets error=3D-5, uptodate=3D0
[588675.152915] raid5: Disk failure on sdj6, disabling device.
[588675.152915] raid5: Operation continuing on 4 devices.
[588675.158145] end_request: I/O error, dev sdh, sector 2930271882
[588675.158147] md: super_written gets error=3D-5, uptodate=3D0
[588675.158149] raid5: Disk failure on sdh6, disabling device.
[588675.158150] raid5: Operation continuing on 3 devices.
[588675.160440] end_request: I/O error, dev sdk, sector 2930271882
[588675.160442] md: super_written gets error=3D-5, uptodate=3D0
[588675.160444] raid5: Disk failure on sdk6, disabling device.
[588675.160445] raid5: Operation continuing on 2 devices.
[588675.161965] end_request: I/O error, dev sdg, sector 2930271882
[588675.161967] md: super_written gets error=3D-5, uptodate=3D0
[588675.161969] raid5: Disk failure on sdg6, disabling device.
[588675.161970] raid5: Operation continuing on 1 devices.
[588675.168925] end_request: I/O error, dev sdi, sector 2930271882
[588675.168927] md: super_written gets error=3D-5, uptodate=3D0
[588675.168929] raid5: Disk failure on sdi6, disabling device.
[588675.168930] raid5: Operation continuing on 0 devices.
[588675.168948] RAID5 conf printout:
[588675.168950]  --- rd:5 wd:0
[588675.168951]  disk 0, o:0, dev:sdg6
[588675.168952]  disk 1, o:0, dev:sdh6
[588675.168953]  disk 2, o:0, dev:sdi6
[588675.168955]  disk 3, o:0, dev:sdj6
[588675.168956]  disk 4, o:0, dev:sdk6
[588675.758839] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.766304] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.772415] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.780146] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 00 5a cc 98 00 0=
0 08 00
[588675.787487] end_request: I/O error, dev sde, sector 5950616
[588675.793314] sd 0:0:4:0: [sde] Device not ready
[588675.797984] sd 0:0:4:0: [sde] Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_SENSE
[588675.805453] sd 0:0:4:0: [sde] Sense Key : Not Ready [current]
[588675.811572] sd 0:0:4:0: [sde] Add. Sense: Logical unit failed
self-configuration
[588675.819312] sd 0:0:4:0: [sde] CDB: Read(10): 28 00 00 5a cc b0 00 0=
0 08 00
[588675.826713] end_request: I/O error, dev sde, sector 5950640
[588675.838005] RAID5 conf printout:
[588675.841422]  --- rd:5 wd:0
[588675.844323]  disk 1, o:0, dev:sdh6
[588675.847913]  disk 2, o:0, dev:sdi6
[588675.851516]  disk 3, o:0, dev:sdj6
[588675.855106]  disk 4, o:0, dev:sdk6
[588675.858697] RAID5 conf printout:
[588675.862139]  --- rd:5 wd:0
[588675.862154] RAID5 conf printout:
[588675.862155]  --- rd:6 wd:5
[588675.862157]  disk 0, o:1, dev:sda6
[588675.862158]  disk 1, o:1, dev:sdf6
[588675.862160]  disk 2, o:0, dev:sde6
[588675.862162]  disk 3, o:1, dev:sdc6
[588675.862163]  disk 4, o:1, dev:sdb1
[588675.862164]  disk 5, o:1, dev:sdd1
[588675.892893]  disk 1, o:0, dev:sdh6
[588675.896490]  disk 2, o:0, dev:sdi6
[588675.900086]  disk 3, o:0, dev:sdj6
[588675.903674]  disk 4, o:0, dev:sdk6
[588675.912005] RAID5 conf printout:
[588675.915438]  --- rd:5 wd:0
[588675.918339]  disk 1, o:0, dev:sdh6
[588675.919256] RAID5 conf printout:
[588675.919258]  --- rd:6 wd:5
[588675.919259]  disk 0, o:1, dev:sda6
[588675.919261]  disk 1, o:1, dev:sdf6
[588675.919262]  disk 3, o:1, dev:sdc6
[588675.919263]  disk 4, o:1, dev:sdb1
[588675.919264]  disk 5, o:1, dev:sdd1
[588675.946353]  disk 2, o:0, dev:sdi6
[588675.949956]  disk 3, o:0, dev:sdj6
[588675.953553] RAID5 conf printout:
[588675.956990]  --- rd:5 wd:0
[588675.959890]  disk 1, o:0, dev:sdh6
[588675.963502]  disk 2, o:0, dev:sdi6
[588675.967103]  disk 3, o:0, dev:sdj6
[588675.974006] RAID5 conf printout:
[588675.977431]  --- rd:5 wd:0
[588675.980380]  disk 1, o:0, dev:sdh6
[588675.984017]  disk 2, o:0, dev:sdi6
[588675.987633] RAID5 conf printout:
[588675.991069]  --- rd:5 wd:0
[588675.993989]  disk 1, o:0, dev:sdh6
[588675.997600]  disk 2, o:0, dev:sdi6
[588676.006006] RAID5 conf printout:
[588676.009465]  --- rd:5 wd:0
[588676.012375]  disk 1, o:0, dev:sdh6
[588676.015985] RAID5 conf printout:
[588676.019473]  --- rd:5 wd:0
[588676.022367]  disk 1, o:0, dev:sdh6
[588676.030005] RAID5 conf printout:
[588676.033439]  --- rd:5 wd:0
[588676.036350] Buffer I/O error on device dm-15, logical block 3075932=
16
[588676.043081] lost page write due to I/O error on dm-15
[588676.751012] ttyS0: 1 input overrun(s)
[588679.821212] ttyS0: 1 input overrun(s)
[588702.915013] mptbase: ioc0: WARNING - IOC is in FAULT state (7827h)!=
!!
[588702.921701] mptbase: ioc0: WARNING - Issuing HardReset from
mpt_fault_reset_work!!
[588702.929579] mptbase: ioc0: Initiating recovery
[588702.934245] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[588702.940210] mptbase: ioc0: WARNING -            FAULT code =3D 7827=
h
[588706.051011] mptbase: ioc0: Recovered from IOC FAULT
[588717.036031] mptbase: ioc0: WARNING - mpt_fault_reset_work: HardRese=
t:
success

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
