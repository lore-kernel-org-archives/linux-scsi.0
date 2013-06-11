From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] New: commit 97dec564fd4948e0e560869c80b76e166ca2a83e
 breaks communication with XYRATEX disk shelves
Date: Tue, 11 Jun 2013 13:53:48 +0000 (UTC)
Message-ID: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3FKNxw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jun 2013 09:53:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 58A0C2028D
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2013 13:53:51 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id AB93220258
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2013 13:53:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601

           Summary: commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
                    communication with XYRATEX disk shelves
           Product: SCSI Drivers
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: jackhill@jackhill.us
        Regression: Yes


My setup:

I have a

Fibre Channel: QLogic Corp. ISP2322-based 2Gb Fibre Channel to PCI-X HBA (rev
03)

Connected via 2Gb Fibre Channel to a NetApp branded disk shelf, model RA-1402.
The shelf has dual XYRATEX P/N: 106-00101+C0 Fribe Channel controllers. The
shelf has 14 SATA disks connected via Fibre Channel to SATA converters.

Prior to commit 97dec564fd4948e0e560869c80b76e166ca2a83e (as determined with
git bisect) Linux was able to see all the disks as well as the two XRATEX
controllers and read and write to them normally.

After the problem commit, niether the XYRATEX controllers nor the disks are
visible.

Here is an excerpt of the working dmesg output

"""
[    2.708225] QLogic Fibre Channel HBA Driver: 8.03.01-k6
[    2.708302]   alloc irq_desc for 19 on node -1
[    2.708304]   alloc kstat_irqs on node -1
[    2.708309] qla2xxx 0000:03:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.708388] qla2xxx 0000:03:07.0: Found an ISP2322, irq 19, iobase
0xffffc900021fe000
[    2.709059] qla2xxx 0000:03:07.0: Configuring PCI space...
[    2.709415] qla2xxx 0000:03:07.0: Configure NVRAM parameters...
[    2.801997] qla2xxx 0000:03:07.0: Verifying loaded RISC code...
[    2.813685] FDC 0 is a post-1991 82077
[    2.832538] qla2xxx 0000:03:07.0: firmware: requesting ql2322_fw.bin
[    2.972588] qla2xxx 0000:03:07.0: Allocated (1180 KB) for firmware dump...
[    3.032548] scsi4 : qla2xxx
[    3.032854] qla2xxx 0000:03:07.0: 
[    3.032855]  QLogic Fibre Channel HBA Driver: 8.03.01-k6
[    3.032856]   QLogic QLE2360 - PCI-Express to 2Gb FC, Single Channel
[    3.032856]   ISP2322: PCI-X (66 MHz) @ 0000:03:07.0 hdma+, host#=4,
fw=3.03.28 IPX
[    3.313904] qla2xxx 0000:03:07.0: LIP reset occurred (f8f7).
[    3.345574] qla2xxx 0000:03:07.0: LIP occurred (f8f7).
[    3.452223] qla2xxx 0000:03:07.0: LIP reset occurred (f7f7).
[    3.482427] qla2xxx 0000:03:07.0: LIP occurred (f7f7).
[    3.544781] qla2xxx 0000:03:07.0: LOOP UP detected (2 Gbps).
[    3.856407] scsi 4:0:0:0: Enclosure         XYRATEX  RS-1402-SA-XNS1  3033
PQ: 0 ANSI: 3
[    3.859343] scsi 4:0:1:0: Enclosure         XYRATEX  RS-1402-SA-XNS1  3033
PQ: 0 ANSI: 3
[    3.863781] scsi 4:0:2:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.866454] scsi 4:0:3:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.869147] scsi 4:0:4:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.871834] scsi 4:0:5:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.874515] scsi 4:0:6:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.877196] scsi 4:0:7:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.879867] scsi 4:0:8:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.882539] scsi 4:0:9:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.885218] scsi 4:0:10:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.888035] scsi 4:0:11:0: Direct-Access     ST332082 0AS           SX .AAE
PQ: 0 ANSI: 3
[    3.890712] scsi 4:0:12:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.893391] scsi 4:0:13:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.896142] scsi 4:0:14:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
[    3.898820] scsi 4:0:15:0: Direct-Access     HITACHI  HDS725050KLA36SX AB0A
PQ: 0 ANSI: 3
"""

It would be super if the fix for this could be backported to 3.2.

Let me know if you need more information or would like me to test anything.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
