From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 3/6] Check for device resize when rescanning partitions
Date: Thu, 04 Sep 2008 14:27:30 -0600
Message-ID: <20080904202730.10456.14322.stgit@bob.kio>
References: <20080904202714.10456.88061.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13263 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbYIDU1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2008 16:27:31 -0400
In-Reply-To: <20080904202714.10456.88061.stgit@bob.kio>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

Check for device resize when rescanning partitions

Check for device resize in the rescan_partitions() routine. If the device
has been resized, the bdev size is set to match. The rescan_partitions()
routine is called when opening the device and when calling the
BLKRRPART ioctl.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/partitions/check.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e6f378f..77cfe63 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -504,7 +504,6 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	res = invalidate_partition(disk, 0);
 	if (res)
 		return res;
-	bdev->bd_invalidated = 0;
 
 	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter)))
@@ -513,6 +512,8 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
+	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */

