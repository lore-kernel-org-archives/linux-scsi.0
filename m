From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2/6] Adjust block device size after an online resize of a disk.
Date: Fri, 29 Aug 2008 17:13:05 -0600
Message-ID: <20080829231305.25065.3834.stgit@bluto.andrew>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:35865 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYH2XNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2008 19:13:06 -0400
In-Reply-To: <20080829231254.25065.66052.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

Adjust block device size after an online resize of a disk.

The revalidate_disk routine now checks if a disk has been resized by
comparing the gendisk capacity to the bdev inode size.  If they are
different (usually because the disk has been resized underneath the kernel)
the bdev inode size is adjusted to match the capacity.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c     |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 39 insertions(+), 0 deletions(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 30bafca..f8df73a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -869,6 +869,34 @@ struct block_device *open_by_devnum(dev_t dev, unsigned mode)
 EXPORT_SYMBOL(open_by_devnum);
 
 /**
+ * check_disk_size_change - checks for disk size change and adjusts
+ *                          bdev size.
+ *
+ * @disk: struct gendisk to check
+ * @bdev: struct bdev to adjust.
+ *
+ * This routine checks to see if the bdev size does not match the disk size
+ * and adjusts it if it differs.
+ */
+void check_disk_size_change(struct gendisk *disk, struct block_device *bdev)
+{
+	loff_t disk_size, bdev_size;
+
+	disk_size = (loff_t)get_capacity(disk) << 9;
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
+}
+EXPORT_SYMBOL(check_disk_size_change);
+
+/**
  * revalidate_disk - wrapper for lower-level driver's revalidate_disk
  *                   call-back
  *
@@ -880,11 +908,20 @@ EXPORT_SYMBOL(open_by_devnum);
  */
 int revalidate_disk(struct gendisk *disk)
 {
+	struct block_device *bdev;
 	int ret = 0;
 
 	if (disk->fops->revalidate_disk)
 		ret = disk->fops->revalidate_disk(disk);
 
+	bdev = bdget_disk(disk, 0);
+	if (!bdev)
+		return ret;
+
+	mutex_lock(&bdev->bd_mutex);
+	check_disk_size_change(disk, bdev);
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
 	return ret;
 }
 EXPORT_SYMBOL(revalidate_disk);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 28756a9..ef23c3f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1718,6 +1718,8 @@ extern int fs_may_remount_ro(struct super_block *);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
+extern void check_disk_size_change(struct gendisk *disk,
+				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *);

