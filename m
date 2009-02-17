From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12733] mpt fusion driver crashes with LSI22320SE installed and BIOS ACPI turned off
Date: Tue, 17 Feb 2009 15:16:58 -0800 (PST)
Message-ID: <20090217231658.91F4C108043@picon.linux-foundation.org>
References: <bug-12733-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501AbZBQXR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 18:17:29 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1HNGwnR026716
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2009 15:17:00 -0800
In-Reply-To: <bug-12733-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12733





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2009-02-17 15:16 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2009-02-17 at 15:04 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12733
> 
>            Summary: mpt fusion driver crashes with LSI22320SE installed and
>                     BIOS ACPI turned off
>            Product: SCSI Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27.5-117
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: mvolaski@aecom.yu.edu
> 
> 
> On a system with a Supermicro X7DWN+ with ACPI turned off, and an LSI22320SE
> card installed, the mptdriver will crash. (The problem appears to affect other
> boards as well).

The first question is can this board operate without ACPI?  It's used to
get the interrupt routings and your log below indicates that the driver
isn't receiving the card interrupt.

> Here is the relevant log:
> 
> Oct  5 21:19:54 localhost kernel: Fusion MPT SPI Host driver 3.04.07
> Oct  5 21:19:54 localhost kernel: mptbase: ioc0: Initiating bringup
> Oct  5 21:19:54 localhost kernel: [drm] Initialized radeon 1.29.0 20080528 on
> minor 0
> Oct  5 21:19:54 localhost kernel: ioc0: LSI53C1030 C0:
> Capabilities={Initiator,Target}
> Oct  5 21:19:54 localhost kernel: scsi2 : ioc0: LSI53C1030 C0, FwRev=01033400h,
> Ports=1, MaxQ=255, IRQ=52
> Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating bringup
> Oct  5 21:19:54 localhost kernel: ioc1: LSI53C1030 C0:
> Capabilities={Initiator,Target}
> Oct  5 21:19:54 localhost kernel: scsi3 : ioc1: LSI53C1030 C0, FwRev=01033400h,
> Ports=1, MaxQ=255, IRQ=52

Is 52 the right interrupt number?

> Oct  5 21:19:54 localhost kernel: device-mapper: multipath: version 1.0.5
> loaded
> Oct  5 21:19:54 localhost kernel: EXT3 FS on dm-0, internal journal
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting task abort!
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
> Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
> Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: mptscsih: ioc1: completing
> cmds: fw_channel 0, fw_id 4, sc=f5aca500, mf = f48e3160, idx=19
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: task abort: FAILED
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting target reset!
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
> Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: target reset: FAILED
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting bus reset!
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: scsi 3:0:4:0: CDB: Inquiry: 12 00 00 00 24 00
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
> failed
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 3.4 MB/s
> ST QAS RDSTRM WRFLOW (572 ns, offset 133)
> Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
> 
> and
> 
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: Issue of TaskMgmt failed!
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: bus reset: FAILED
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: mptscsih: ioc1: attempting host reset!
> (sc=f5aca500)
> Oct  5 21:19:54 localhost kernel: mptbase: ioc1: Initiating recovery
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
> failed
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
> failed
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 3.4 MB/s
> ST QAS RDSTRM WRFLOW (572 ns, offset 133)
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
> failed
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
> failed
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: FAST-5 WIDE SCSI 3.4 MB/s
> ST QAS RDSTRM WRFLOW (572 ns, offset 133)
> Oct  5 21:19:54 localhost kernel: scsi target3:0:4: mptspi: ioc1: mpt_config
> failed

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
