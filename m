From: Pat LaVarre <p.lavarre@ieee.org>
Subject: zero block writes
Date: 14 Oct 2003 13:48:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066160907.3501.9.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:24226 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261670AbTJNTso
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2003 15:48:44 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 6EEE617A8
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2003 13:48:43 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

$
$ sg_dd of=/dev/sg0 if=/dev/null bs=2k count=1
0+0 records in
0+0 records out
$

cdb trace tells me this sg utils idiom assaults the device with a zero
block write, specifically:

...
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 00 00 00 00 00 00 00
usb-storage: Bulk command S 0x43425355 T 0x1e Trg 0 LUN 0 L 0 F 0 CL 10
...

I wonder if any of you find this sg utils factoid ineffably interesting,
as I do?

I know I have a personal history of pain with the scsi folk who dispute
the t10 claim that the cdb x 0A 00:00:00 00 00 means write out x100
blocks rather than zero and/or while yet that the cdb x 2A 00
00:00:00:00 00 00:00 00 does mean write out zero blocks.

I know I explicitly wrote code into a revision, at a time beyond the
original release of pldd, to discard writes of zero bytes quietly,
rather than passing them thru to the device.

I know such pass thru's trip over such unit attentions as x 6 29 reset.

Pat LaVarre


