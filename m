From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44111] New: pata_via: crash with VT6415 controller
Date: Sun,  1 Jul 2012 19:22:34 +0000 (UTC)
Message-ID: <bug-44111-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2GATWo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jul 2012 15:22:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7BD6D20209
	for <linux-scsi@vger.kernel.org>; Sun,  1 Jul 2012 19:22:40 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 83FFA20200
	for <linux-scsi@vger.kernel.org>; Sun,  1 Jul 2012 19:22:35 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=44111

           Summary: pata_via: crash with VT6415 controller
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.0 and above
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: giuliano.procida@gmail.com
        Regression: No


Original Debian bug report http://bugs.debian.org/679039 has some further
information.

Hardware is an ASUS M4A88TD-M/USB3 EVO motherboard with an apparently rare
on-board VIA VT6415 PATA controller. I have one device linked to this
controller, a LITE-ON DVDRW SOHW-1693S. CPU is a quad-core Phenom II.

Shortly after the pata_via module loads, the system hangs completely (no
SysReq, no keyboard LEDs) with probability ~ 0.9. The crash is prevented with
libata dma=1. Disabling the VIA option ROM makes no difference. The BIOS is the
latest available version.

In Debian 3.6.33 and earlier kernels, I believe a different driver was used
that did not crash. I could boot to confirm this.

The PCI device is:

04:00.0 IDE interface [0101]: VIA Technologies, Inc. VT6415 PATA IDE
Host Controller [1106:0415] (prog-if 85 [Master SecO PriO])
    Subsystem: ASUSTeK Computer Inc. M5A88-V EVO [1043:838f]
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 17
    Region 0: I/O ports at dc00 [size=8]
    Region 1: I/O ports at d880 [size=4]
    Region 2: I/O ports at d800 [size=8]
    Region 3: I/O ports at d480 [size=4]
    Region 4: I/O ports at d400 [size=16]
    Expansion ROM at feaf0000 [disabled] [size=64K]
    Capabilities: <access denied>

These logs were obtained using netconsole:

Crash with 3.2.0:

[   65.934145] pata_via 0000:04:00.0: version 0.3.4
[   65.934184] pata_via 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[   65.934297] pata_via 0000:04:00.0: setting latency timer to 64
[   65.935274] scsi6 : pata_via
[   65.935560] scsi7 : pata_via
[   65.936047] ata7: PATA max UDMA/133 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq
17
[   65.936059] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq
17
[   66.224661] ata7.01: ATAPI: LITE-ON DVDRW SOHW-1693S, KS09, max UDMA/66
[   66.240680] ata7.01: configured for UDMA/66
[   66.243198] scsi 6:0:1:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS09
PQ: 0 ANSI: 5

Crash with 3.4.4:

[  963.751260] pata_via 0000:04:00.0: version 0.3.4
[  963.756541] scsi6 : pata_via
[  963.760485] scsi7 : pata_via
[  963.764560] ata7: PATA max UDMA/133 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq
17
[  963.768330] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq
17
[  964.060046] ata7.01: ATAPI: LITE-ON DVDRW SOHW-1693S, KS09, max UDMA/66
[  964.079984] ata7.01: configured for UDMA/66
[  964.086377] scsi 6:0:1:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS09
PQ: 0 ANSI: 5

A non-crash with 3.2.0:

[  105.576978] pata_via 0000:04:00.0: version 0.3.4
[  105.577016] pata_via 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[  105.577130] pata_via 0000:04:00.0: setting latency timer to 64
[  105.578414] scsi6 : pata_via
[  105.580212] scsi7 : pata_via
[  105.580687] ata7: PATA max UDMA/133 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq
17
[  105.580708] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq
17
[  105.868656] ata7.01: ATAPI: LITE-ON DVDRW SOHW-1693S, KS09, max UDMA/66
[  105.884670] ata7.01: configured for UDMA/66
[  105.887152] scsi 6:0:1:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS09
PQ: 0 ANSI: 5
[  106.048133] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[  106.048150] cdrom: Uniform CD-ROM driver Revision: 3.20
[  106.048497] sr 6:0:1:0: Attached scsi CD-ROM sr0
(no crash)

(unload module)
[  227.560172] ata7.01: disabled
[  227.563668] pata_via 0000:04:00.0: PCI INT A disabled

(reload module)
[  260.320995] pata_via 0000:04:00.0: version 0.3.4
[  260.321035] pata_via 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ
17
[  260.321142] pata_via 0000:04:00.0: setting latency timer to 64
(different device enumeration)
[  260.322064] scsi8 : pata_via
[  260.322663] scsi9 : pata_via
[  260.323093] ata9: PATA max UDMA/133 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq
17
[  260.323105] ata10: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq
17
[  260.608665] ata9.01: ATAPI: LITE-ON DVDRW SOHW-1693S, KS09, max UDMA/66
[  260.624671] ata9.01: configured for UDMA/66
[  260.626251] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS09
PQ: 0 ANSI: 5
(hard crash)

Let me know if there is anything further I can do to test.

Is there a simple way of changing the ATA driver msg_enable bits without
re-compiling?

Regards,
Giuliano Procida.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
