From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2/5] Adjust block device size after an online resize of a disk.
Date: Thu, 08 May 2008 00:30:30 -0600
Message-ID: <20080508063030.3818.76328.stgit@bluto.andrew>
References: <20080508062930.3818.31401.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28391 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088AbYEHGac (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 02:30:32 -0400
In-Reply-To: <20080508062930.3818.31401.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com

Adjust block device size after an online resize of a disk.

The revalidate_disk routine now checks if a disk has been resized by
comparing the gendisk capacity to the bdev inode size.  If they are
different (usually because the disk has been resized underneath the kernel)
the bdev inode size is adjusted to match the capacity.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 72aaf59..87014e6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -879,11 +879,32 @@ EXPORT_SYMBOL(open_by_devnum);
  */
 int revalidate_disk(struct gendisk *disk)
 {
+	struct block_device *bdev;
+	loff_t disk_size, bdev_size;
 	int ret = 0;
 
 	if (disk->fops->revalidate_disk)
 		ret = disk->fops->revalidate_disk(disk);
 
+	bdev = bdget_disk(disk, 0);
+	if (!bdev)
+		return ret;
+
+	disk_size = (loff_t)get_capacity(disk) << 9;
+	mutex_lock(&bdev->bd_mutex);
+	bdev_size = i_size_read(bdev->bd_inode);
+	if (disk_size != bdev_size) {
+		char name[BDEVNAME_SIZE];
+
+		disk_name(disk, 0, name);
+		printk(KERN_INFO
+		       "%s: detected capacity change from %lld to %lld\n",
+		       name, bdev_size, disk_size);
+		i_size_write(bdev->bd_inode, disk_size);
+	}
+
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
 	return ret;
 }
 EXPORT_SYMBOL(revalidate_disk);

