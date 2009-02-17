From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12733] New: mpt fusion driver crashes with LSI22320SE
	installed and BIOS ACPI turned off
Date: Tue, 17 Feb 2009 23:16:16 +0000
Message-ID: <1234912576.23466.16.camel@localhost.localdomain>
References: <bug-12733-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43538 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbZBQXQU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 18:16:20 -0500
In-Reply-To: <bug-12733-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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


