From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 0/4] detect online disk resize
Date: Mon, 05 May 2008 17:04:14 -0600
Message-ID: <20080505230414.12905.15331.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:21344 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYEEXEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 19:04:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com

This patch series handles online disk resizes that are currently not
completely recognized by the kernel using the existing revalidate_disk
routines.  An online resize can occur when growing or shrinking a
Fibre Channel LUN or perhaps by adding a disk to an existing RAID
volume.

The kernel currently recognizes a device size change when
revalidate_disk() is called; however, the block layer does not use the
new size while it has any current openers on the device. So, for
example, if LVM has an volume open on the device, you will generally
not see the size change until after a reboot. We fix this problem by
creating a wrapper to be used with lower-level revalidate_disk
routines.  This wrapper first calls the lower-level driver's
revalidate_disk routine. It then compares the gendisk capacity to the
block devices inode size. If there is a difference, we adjust the
block device's size. If the size has changed, we then flush the disk
for safety.

This patch series only modifies the sd driver to use these changes as
that is all that I currently have to test with. Device drivers like cciss
and DAC960 should probably use it as well.

Diff stats:

 drivers/scsi/sd.c  |    4 +--
 fs/block_dev.c     |   76 +++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |    1 +
 3 files changed, 74 insertions(+), 7 deletions(-)

Commits:

 - Added flush_disk to factor out common buffer cache flushing code.
 - Wrapper for lower-level revalidate_disk routines.
 - Adjust block device size after an online resize of a disk.
 - SCSI sd driver calls revalidate_disk wrapper.

-- 
Andrew Patterson

