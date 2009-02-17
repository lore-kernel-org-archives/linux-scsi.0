From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12733] New: mpt fusion driver crashes with LSI22320SE installed and BIOS ACPI turned off
Date: Tue, 17 Feb 2009 15:04:17 -0800 (PST)
Message-ID: <bug-12733-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbZBQXEt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 18:04:49 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1HN4HQn025806
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2009 15:04:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12733

           Summary: mpt fusion driver crashes with LSI22320SE installed and
                    BIOS ACPI turned off
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.27.5-117
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: mvolaski@aecom.yu.edu


On a system with a Supermicro X7DWN+ with ACPI turned off, and an LSI22320SE
card installed, the mptdriver will crash. (The problem appears to affect other
boards as well).

Here is the relevant log:

Oct  5 21:19:54 localhost kernel: Fusion MPT SPI Host driver 3.04.07
Oct  5 21:19:54 localhost kernel: mptbase: ioc0: Initiating bringup
Oct  5 21:19:54 localhost kernel: [drm] Initialized radeon 1.29.0 20080528 on
minor 0
Oct  5 21:19:54 localhost kernel: ioc0: LSI53C1030 C0:
Capabilities={Initiator,Target}
Oct  5 21:19:54 localhost kernel: scsi2 : ioc0: LSI53C1030 C0, FwRev=01033400h,
Ports=1, MaxQ=255, IRQ=52
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating bringup
Oct  5 21:19:54 localhost kernel: ioc1: LSI53C1030 C0:
Capabilities={Initiator,Target}
Oct  5 21:19:54 localhost kernel: scsi3 : ioc1: LSI53C1030 C0, FwRev=01033400h,
Ports=1, MaxQ=255, IRQ=52
Oct  5 21:19:54 localhost kernel: device-mapper: multipath: version 1.0.5
loaded
Oct  5 21:19:54 localhost kernel: EXT3 FS on dm-0, internal journal
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting task abort!
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: mptscsih: ioc1: completing
cmds: fw_channel 0, fw_id 4, sc=f5aca500, mf = f48e3160, idx=19
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: task abort: FAILED
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting target reset!
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: target reset: FAILED
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting bus reset!
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 3.4 MB/s
ST QAS RDSTRM WRFLOW (572 ns, offset 133)
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery

and

Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: bus reset: FAILED
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting host reset!
(sc=f5aca500)
Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 3.4 MB/s
ST QAS RDSTRM WRFLOW (572 ns, offset 133)
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
failed
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 3.4 MB/s
ST QAS RDSTRM WRFLOW (572 ns, offset 133)
Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
failed


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
