From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 0/6] detect online disk resize
Date: Thu, 04 Sep 2008 14:27:15 -0600
Message-ID: <20080904202714.10456.88061.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41241 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYIDU1Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 16:27:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

Resubmitting this patch against Jens's linux-2.6-block:for-2.6.28 repo.

This patch series handles online disk resizes that are currently not
completely recognized by the kernel using the existing revalidate_disk
routines.  An online resize can occur when growing or shrinking a
Fibre Channel LUN or perhaps by adding a disk to an existing RAID
volume.

The kernel currently recognizes a device size change when the
lower-level revalidate_disk routines are called; however, the block
layer does not use the new size while it has any current openers on
the device. So, for example, if LVM has an volume open on the device,
you will generally not see the size change until after a reboot. We
fix this problem by creating a wrapper to be used with lower-level
revalidate_disk routines.  This wrapper first calls the lower-level
driver's revalidate_disk routine. It then compares the gendisk
capacity to the block devices inode size. If there is a difference, we
adjust the block device's size. If the size has changed, we then flush
the disk for safety. The size is also checked in rescan_partitions
which is called when the device is opened or when the BLKRRPART ioctl
is called.

There are several ways to "kick off" a device size change:

1. For SCSI devices do:

  # echo 1 > /sys/class/scsi_device/<device>/device/rescan

  or

  # blockdev --rereadpt <device file>

2. Other devices (not device mapper)

  # blockdev --rereadpt <device file>

I have tested this patch on SCSI and SmartArray (cciss)
devices. Device mapper still does not recognize device size changes
until the device is restarted.


Diff stats:

 drivers/scsi/sd.c     |    4 +-
 fs/block_dev.c        |   91 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/partitions/check.c |    3 +-
 include/linux/fs.h    |    3 ++
 4 files changed, 93 insertions(+), 8 deletions(-)

Commits:

 - Wrapper for lower-level revalidate_disk routines.
 - Adjust block device size after an online resize of a disk.
 - Check for device resize in rescan_partitions.
 - SCSI sd driver calls revalidate_disk wrapper.
 - Added flush_disk to factor out common buffer cache flushing code.
 - Call flush_disk() after detecting an online resize.

-- 
Andrew Patterson

