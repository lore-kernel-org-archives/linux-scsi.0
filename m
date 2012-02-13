From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42765] New: mptscsih driver issues task aborts during high
 write utilization
Date: Mon, 13 Feb 2012 13:36:51 GMT
Message-ID: <bug-42765-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54417 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2BMNgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2012 08:36:51 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DDapDg018909
	for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2012 13:36:51 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42765

           Summary: mptscsih driver issues task aborts during high write
                    utilization
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.38-8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: eric.hidle@gmail.com
        Regression: No


Created an attachment (id=72364)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72364)
Graph of total write rate in guest during rsync data restore + mdadm rebuild
(high write utilization)

During high write utilization, a sting of errors similar to the following
appears in syslog:

Feb 13 07:42:22 Beluga kernel: [54224.040144] mptscsih: ioc1: attempting task
abort! (sc=ffff8800018dea00)
Feb 13 07:42:22 Beluga kernel: [54224.040154] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 47 0e 55 3f 00 02 00 00
Feb 13 07:42:23 Beluga kernel: [54224.779457] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff8800018dea00) (sn=53380191)
Feb 13 07:42:24 Beluga kernel: [54226.018680] mptscsih: ioc1: attempting task
abort! (sc=ffff88001737a300)
Feb 13 07:42:24 Beluga kernel: [54226.018699] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 47 0e 50 3f 00 00 08 00
Feb 13 07:42:24 Beluga kernel: [54226.018711] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88001737a300) (sn=53380197)
Feb 13 07:42:24 Beluga kernel: [54226.025368] mptscsih: ioc1: attempting task
abort! (sc=ffff88002b2c7200)
Feb 13 07:42:24 Beluga kernel: [54226.025372] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 47 0e 50 47 00 00 08 00
Feb 13 07:42:24 Beluga kernel: [54226.025382] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88002b2c7200) (sn=53380199)
Feb 13 07:42:24 Beluga kernel: [54226.025556] mptscsih: ioc1: attempting task
abort! (sc=ffff88002b3b3300)
Feb 13 07:42:24 Beluga kernel: [54226.025559] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 47 0e 50 4f 00 00 60 00
Feb 13 07:42:24 Beluga kernel: [54226.025569] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88002b3b3300) (sn=53380205)
Feb 13 07:42:24 Beluga kernel: [54226.025737] mptscsih: ioc1: attempting task
abort! (sc=ffff88002b2c7900)
Feb 13 07:42:24 Beluga kernel: [54226.025740] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 47 0e 57 3f 00 01 f0 00
Feb 13 07:42:24 Beluga kernel: [54226.025749] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88002b2c7900) (sn=53380211)
Feb 13 07:42:24 Beluga kernel: [54226.025916] mptscsih: ioc1: attempting task
abort! (sc=ffff88002b385e00)
Feb 13 07:42:24 Beluga kernel: [54226.025919] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 47 0e 59 2f 00 03 10 00
Feb 13 07:42:24 Beluga kernel: [54226.025928] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88002b385e00) (sn=53380217)
Feb 13 07:42:24 Beluga kernel: [54226.026094] mptscsih: ioc1: attempting task
abort! (sc=ffff88002b385b00)
Feb 13 07:42:24 Beluga kernel: [54226.026098] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 2f 7f ad bf 00 00 08 00
Feb 13 07:42:24 Beluga kernel: [54226.026107] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88002b385b00) (sn=53380218)
Feb 13 07:42:24 Beluga kernel: [54226.026271] mptscsih: ioc1: attempting task
abort! (sc=ffff88001737ad00)
Feb 13 07:42:24 Beluga kernel: [54226.026274] sd 3:0:5:0: [sdg] CDB: Write(10):
2a 00 2f 7f ad c7 00 00 08 00
Feb 13 07:42:24 Beluga kernel: [54226.026283] mptscsih: ioc1: task abort:
SUCCESS (rv=2002) (sc=ffff88001737ad00) (sn=53380224)

Simultaneous with this output in the Linux Guest Syslog, the following appear
in the VMWare Kernel Log:

2012-02-13T12:42:21.677Z cpu6:65683)<6>mptscsih: ioc0: attempting task abort!
(sc=0x4124015017c0)
2012-02-13T12:42:21.677Z cpu6:65683)MPT SAS Host:8:0:4:0 ::
<6>        command: Write(10): 2a 00 47 0e 55 bf 00 00 80 00
2012-02-13T12:42:22.141Z cpu1:2049)NMP: nmp_ThrottleLogForDevice:2318: Cmd 0x2a
(0x412400728580) to dev "naa.50024e92063340f2" on path "vmhba3:C0:T4:L0"
Failed: H:0x8 D:0x0 P:0x0 Possible sense data: 0x0 0x0 0x0.Act:EVAL
2012-02-13T12:42:22.141Z cpu1:2049)WARNING: NMP:
nmp_DeviceRequestFastDeviceProbe:237:NMP device "naa.50024e92063340f2" state in
doubt; requested fast path state update...
2012-02-13T12:42:22.141Z cpu1:2049)ScsiDeviceIO: 2305: Cmd(0x412400728580)
0x2a, CmdSN 0x800e0069 to dev "naa.50024e92063340f2" failed H:0x8 D:0x0 P:0x0
Possible sense data: 0x0 0x0 0x0.
2012-02-13T12:42:22.141Z cpu1:2049)<6>mptbase: ioc0: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
2012-02-13T12:42:22.142Z cpu3:100554)WARNING: LinScsi:
SCSILinuxQueueCommand:1175:queuecommand failed with status = 0x1055 Host Busy
vmhba3:0:4:0 (driver name: MPT SAS Host) - Message repeated 1 time
2012-02-13T12:42:22.142Z cpu6:65683)<6>mptscsih: ioc0: task abort: SUCCESS
(sc=0x4124015017c0)
2012-02-13T12:42:22.142Z cpu6:65683)<6>mptscsih: ioc0: attempting task abort!
(sc=0x4124014d6380)
2012-02-13T12:42:22.142Z cpu6:65683)MPT SAS Host:8:0:4:0 ::
<6>        command: Write(10): 2a 00 47 0e 56 3f 00 00 80 00
2012-02-13T12:42:22.142Z cpu6:65683)<6>mptscsih: ioc0: task abort: SUCCESS
(sc=0x4124014d6380)
2012-02-13T12:42:22.142Z cpu6:65683)<6>mptscsih: ioc0: attempting task abort!
(sc=0x41240141ba80)
2012-02-13T12:42:22.142Z cpu6:65683)MPT SAS Host:8:0:4:0 ::
<6>        command: Write(10): 2a 00 47 0e 56 bf 00 00 80 00
2012-02-13T12:42:22.142Z cpu6:65683)<6>mptscsih: ioc0: task abort: SUCCESS
(sc=0x41240141ba80)
2012-02-13T12:42:23.397Z cpu3:2171)NMP: nmp_ThrottleLogForDevice:2318: Cmd 0x0
(0x412400720d40) to dev "naa.50024e92063340f2" on path "vmhba3:C0:T4:L0"
Failed: H:0x0 D:0x2 P:0x0 Valid sense data: 0x6 0x29 0x0.Act:NONE
2012-02-13T12:42:23.397Z cpu3:2171)ScsiDeviceIO: 2305: Cmd(0x412400720d40) 0x0,
CmdSN 0x800e0061 to dev "naa.50024e92063340f2" failed H:0x0 D:0x2 P:0x0 Valid
sense data: 0x6 0x29 0x0.
2012-02-13T12:42:23.397Z cpu3:2171)ScsiCore: 1455: Power-on Reset occurred on
naa.50024e92063340f2


This has occurred on several of the disks attached to the LSI 1068E controller
in the system. All disks are Samsung HD204UI. O/S is Ubuntu 11.04 Server
running in VMWare ESXi 5.0 with all 6 drives attached to the guest via Raw
Device Mapping, and assembled into a RAID5 array using mdadm. 

When a hard disk undergoes POR, it can fall out of an mdadm array, causing
permanent data loss. We have seen one occurrence of a "Rebuild20" event from
mdadm in the Guest syslog. The POR causes all writes to the array to stop, long
enough to show up in the ESXi disk performance graph (attached image).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
