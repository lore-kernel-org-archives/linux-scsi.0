From: "James Daniel" <jdaniel@dakotacom.net>
Subject: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel Errors
Date: Wed, 17 Dec 2003 02:05:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000501c3c47c$dfc05ae0$0200000a@nightsky>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from breaker.dakotacom.net ([66.192.152.146]:53928 "EHLO
	breaker.dakotacom.net") by vger.kernel.org with ESMTP
	id S264229AbTLQJFF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2003 04:05:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Mike Christie <mikenc@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>

First off..
Mike, thank you for your work on this driver. James, thank you for pointing
out the patch.

I finally had time to take the server down and recompile with vga mode
selection support.. so, with 80x60, the entire scsi setup stays on the
screen at the time of panic.. here we go:

i91u: PCI Base=0xEC00, IRQ=12, BIOS=0xC8000, SCSI ID=7
i91u: Reset SCSI Bus ...
ERROR: SCSI host `INI9100U' has no error handling
ERROR: This is not a safe way to run your SCSI host
ERROR: The error handling must be added to this driver
Call Trace:
 [<c029cfd1>] scsi_host_alloc+0x291/0x2a0
 [<c029cff1>] scsi_register+0x11/0x60
 [<c02a4ed1>] i91u_detect+0x1d1/0x3c0
 [<c0290e28>] ide_register_driver+0xe8/0x120
 [<c03628b3>] init_this_scsi_driver+0x53/0x100
 [<c035276c>] do_initcalls+0x2c/0xa0
 [<c01050ed>] init+0x2d/0x140
 [<c01050c0>] init+0x0/0x140
 [<c0107329>] kernel_thread_helper+0x5/0x1c

It then goes on to ID the drive correctly, and loads the sd driver, which
again IDs the drive correctly.. and we get:

SCSI device  sda: 17783240 512-byte hdwr sectors (9105 MB)
SCSI device sda: drive cache: write back
/dev/scsi/host0/bus0/target1/lun0: unknown partition table
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0

which results in the end:

VFS: Cannot open root device "801" or sda1
Please append a correct "root=" boot option
kernel panic: VFS: Unable to mount root fs on sda1

Hope this helps in the debugging.. as you may guess, the whole box works
absolutely fine under 2.4.23...

- James Daniel

