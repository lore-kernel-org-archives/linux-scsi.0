From: Andrew Morton <akpm@osdl.org>
Subject: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Sun, 26 Jun 2005 15:39:41 -0700
Message-ID: <20050626153941.456543d6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:1515 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261638AbVFZWkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jun 2005 18:40:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aradford@amcc.com, Nick Orlov <bugfixer@list.ru>


James said:

: OK ... I looked ... and it's not pretty.  The problem is that the 3ware
: assumes certain commands (INQUIRY, READ_CAPACITY, MODE_SENSE + a few
: others) are only generated internally and thus only have use_sg == 0.
: The scsi-block-tree breaks this assumption because we're trying to
: eliminate the use_sg == 0 special case.
: 
: It's important to note that this behaviour is already broken, as anyone
: using SG_IO to send commands to the device would have discovered.
: 
: Could you send this bug report to the scsi list and cc adam radford
: <aradford@amcc.com>.  The solution is probably to convert this driver to
: using the libata style command emulation.

Begin forwarded message:

Date: Sun, 26 Jun 2005 14:14:09 -0400
From: Nick Orlov <bugfixer@list.ru>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
Subject: 2.6.12-mm2: 3ware SATA RAID inaccessible


3Ware SATA RAID inaccessible with 2.6.12-mm2:

==================================================

Jun 26 11:49:51 nikolas kernel: 3ware Storage Controller device driver for Linux v1.26.02.001.
Jun 26 11:49:51 nikolas kernel: PCI: Found IRQ 9 for device 0000:00:0f.0
Jun 26 11:49:51 nikolas kernel: IRQ routing conflict for 0000:00:0f.0, have irq 5, want irq 9
Jun 26 11:49:51 nikolas kernel: scsi0 : 3ware Storage Controller
Jun 26 11:49:51 nikolas kernel: 3w-xxxx: scsi0: Found a 3ware Storage Controller at 0xa400, IRQ: 5.
Jun 26 11:49:51 nikolas kernel:   Vendor:           Model:                   Rev:     
Jun 26 11:49:51 nikolas kernel:   Type:   Direct-Access                      ANSI SCSI revision: 00
Jun 26 11:49:51 nikolas kernel: sda : sector size 0 reported, assuming 512.
Jun 26 11:49:51 nikolas kernel: SCSI device sda: 1 512-byte hdwr sectors (0 MB)
Jun 26 11:49:51 nikolas kernel: sda: asking for cache data failed
Jun 26 11:49:51 nikolas kernel: sda: assuming drive cache: write through
Jun 26 11:49:51 nikolas kernel: sda : sector size 0 reported, assuming 512.
Jun 26 11:49:51 nikolas kernel: SCSI device sda: 1 512-byte hdwr sectors (0 MB)
Jun 26 11:49:51 nikolas kernel: sda: asking for cache data failed
Jun 26 11:49:51 nikolas kernel: sda: assuming drive cache: write through
Jun 26 11:49:51 nikolas kernel:  sda: sda1 sda2 sda3
Jun 26 11:49:51 nikolas kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0

..........

Jun 26 11:49:51 nikolas kernel: ReiserFS: sda2: warning: sh-2006: read_super_block: bread failed (dev sda2, block 2, size 4096)
Jun 26 11:49:51 nikolas kernel: ReiserFS: sda2: warning: sh-2006: read_super_block: bread failed (dev sda2, block 16, size 4096)
Jun 26 11:49:51 nikolas kernel: ReiserFS: sda2: warning: sh-2021: reiserfs_fill_super: can not find reiserfs on sda2
Jun 26 11:49:51 nikolas kernel: ReiserFS: sda3: warning: sh-2006: read_super_block: bread failed (dev sda3, block 2, size 4096)
Jun 26 11:49:51 nikolas kernel: ReiserFS: sda3: warning: sh-2006: read_super_block: bread failed (dev sda3, block 16, size 4096)
Jun 26 11:49:51 nikolas kernel: ReiserFS: sda3: warning: sh-2021: reiserfs_fill_super: can not find reiserfs on sda3

==================================================


2.6.12-mm1 works just fine:

==================================================


Jun 26 11:59:07 nikolas kernel: 3ware Storage Controller device driver for Linux v1.26.02.001.
Jun 26 11:59:07 nikolas kernel: PCI: Found IRQ 9 for device 0000:00:0f.0
Jun 26 11:59:07 nikolas kernel: IRQ routing conflict for 0000:00:0f.0, have irq 5, want irq 9
Jun 26 11:59:07 nikolas kernel: scsi0 : 3ware Storage Controller
Jun 26 11:59:07 nikolas kernel: 3w-xxxx: scsi0: Found a 3ware Storage Controller at 0xa400, IRQ: 5.
Jun 26 11:59:07 nikolas kernel:   Vendor: 3ware     Model: Logical Disk 0    Rev: 1.2 
Jun 26 11:59:07 nikolas kernel:   Type:   Direct-Access                      ANSI SCSI revision: 00
Jun 26 11:59:07 nikolas kernel: SCSI device sda: 488395120 512-byte hdwr sectors (250058 MB)
Jun 26 11:59:07 nikolas kernel: SCSI device sda: drive cache: write back
Jun 26 11:59:07 nikolas kernel: SCSI device sda: 488395120 512-byte hdwr sectors (250058 MB)
Jun 26 11:59:07 nikolas kernel: SCSI device sda: drive cache: write back
Jun 26 11:59:07 nikolas kernel:  sda: sda1 sda2 sda3
Jun 26 11:59:07 nikolas kernel: Attached scsi disk sda at scsi0, channel 0, id 0, lun 0

..........


Jun 26 11:59:07 nikolas kernel: ReiserFS: sda2: found reiserfs format "3.6" with standard journal
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda2: using ordered data mode
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda2: checking transaction log (sda2)
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda2: Using r5 hash to sort names
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda3: found reiserfs format "3.6" with standard journal
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda3: using ordered data mode
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda3: checking transaction log (sda3)
Jun 26 11:59:07 nikolas kernel: ReiserFS: sda3: Using r5 hash to sort names

==================================================

reverting git-scsi-block-fix.patch git-scsi-block.patch solves the
problem.


Also, please note that some of the info printed twice:

Jun 26 11:59:07 nikolas kernel: SCSI device sda: 488395120 512-byte hdwr
sectors (250058 MB)
Jun 26 11:59:07 nikolas kernel: SCSI device sda: drive cache: write back
Jun 26 11:59:07 nikolas kernel: SCSI device sda: 488395120 512-byte hdwr
sectors (250058 MB)
Jun 26 11:59:07 nikolas kernel: SCSI device sda: drive cache: write back

This glitch was introduced long time ago, somewhere after 2.6.9-mm1.
I have an archive of all the kernels I've built, so if it'll help I can do
a binary search among them to find when exactly it happend.

-- 
With best wishes,
	Nick Orlov.

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
