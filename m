From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32362] New: ATA Passthrough generates incorrect LBA addresses
 with OS ASYNC activity, Image of Bus-trace attached
Date: Thu, 31 Mar 2011 16:11:08 GMT
Message-ID: <bug-32362-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:38143 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758593Ab1CaQLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 12:11:09 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2VGB8JC029134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 16:11:08 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=32362

           Summary: ATA Passthrough generates incorrect LBA addresses with
                    OS ASYNC activity, Image of Bus-trace attached
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: All
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: marcus.firthview@gmail.com
        Regression: No


Created an attachment (id=52792)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=52792)
Finisar Bus-Trace of SG tools w/System Activity

Bug: Low 28 bits of LBA address to drive after DMA completion (read/write),
following the interrupt to the kernel, status is read from the drive with the
updated LBA address. The 28 lower bits are then transposed into the NEXT drive
commands upper 28bits.

Confirmed: smartmon/sgtools using a Finisar protocol analyzer.

When: Only occurs when using systems whos BIOS is set into Legacy (or ATA/IDE)
modes. (Does NOT occur when using AHCI bios mode).

See attached image to see what occured when running SG tools to read the SMART
log (command 0x2F)... It becomes very obvious that the ATA Pass-Through
driver's actual data becomes over-written with the previous commands LBA
address. 

Example:

  DMA-Write LBA=00000123456
    ->>  BUS:  Cmd 0x2f, LBA=0x0000123456
  Read Status:  DRDY, drive LBA=0x123457 (LBA updated in HW)

  Device Identify  LBA=0000000000
    ->>  BUS: Cmd 0xec, LBA=12345700000   <-- BAD/OOPS!!!
(In this case, CMD 0xec ignores LBA)..

However, a cleverly constructed packet could use a read/writes combined with a
previously corrupted LBA address to access portions of the drive which should
be considered 'restricted/confidential', thus compromising system security and
potentially by-passing AV or other security products.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
