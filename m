From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/13] block: move __dev from disk to part0
Date: Mon, 25 Aug 2008 19:56:08 +0900
Message-ID: <1219661777-17648-5-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:51794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbYHYK6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 06:58:05 -0400
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Move disk->__dev to part0->__dev.  This simplifies bdget_disk() and
lookup_devt() and allows common sysfs attributes to be unified.
part_to_disk() is updated to handle part0 -> disk.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   40 ++++++++++++----------------------------
 include/linux/genhd.h |   13 ++++++++-----
 2 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 092f18f..aca135a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -539,22 +539,15 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
  */
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno)
 {
-	dev_t devt = MKDEV(0, 0);
+	struct hd_struct *part;
+	struct block_device *bdev = NULL;
 
-	if (partno == 0)
-		devt = disk_devt(disk);
-	else {
-		struct hd_struct *part;
+	part = disk_get_part(disk, partno);
+	if (part && part->nr_sects)
+		bdev = bdget(part_devt(part));
+	disk_put_part(part);
 
-		part = disk_get_part(disk, partno);
-		if (part && part->nr_sects)
-			devt = part_devt(part);
-		disk_put_part(part);
-	}
-
-	if (likely(devt != MKDEV(0, 0)))
-		return bdget(devt);
-	return NULL;
+	return bdev;
 }
 EXPORT_SYMBOL(bdget_disk);
 
@@ -1001,27 +994,18 @@ dev_t blk_lookup_devt(const char *name, int partno)
 	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
 	while ((dev = class_dev_iter_next(&iter))) {
 		struct gendisk *disk = dev_to_disk(dev);
+		struct hd_struct *part;
 
 		if (strcmp(dev->bus_id, name))
 			continue;
-		if (partno < 0 || partno >= disk_max_parts(disk))
-			continue;
-
-		if (partno == 0)
-			devt = disk_devt(disk);
-		else {
-			struct hd_struct *part;
-
-			part = disk_get_part(disk, partno);
-			if (!part || !part->nr_sects) {
-				disk_put_part(part);
-				continue;
-			}
 
+		part = disk_get_part(disk, partno);
+		if (part && part->nr_sects) {
 			devt = part_devt(part);
 			disk_put_part(part);
+			break;
 		}
-		break;
+		disk_put_part(part);
 	}
 	class_dev_iter_exit(&iter);
 	return devt;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c4490f2..242effa 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -16,9 +16,9 @@
 #ifdef CONFIG_BLOCK
 
 #define kobj_to_dev(k)		container_of((k), struct device, kobj)
-#define dev_to_disk(device)	container_of((device), struct gendisk, __dev)
+#define dev_to_disk(device)	container_of((device), struct gendisk, part0.__dev)
 #define dev_to_part(device)	container_of((device), struct hd_struct, __dev)
-#define disk_to_dev(disk)	(&((disk)->__dev))
+#define disk_to_dev(disk)	(&(disk)->part0.__dev)
 #define part_to_dev(part)	(&((part)->__dev))
 
 extern struct device_type part_type;
@@ -151,7 +151,6 @@ struct gendisk {
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
-	struct device __dev;
 	struct kobject *holder_dir;
 	struct kobject *slave_dir;
 
@@ -174,8 +173,12 @@ struct gendisk {
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
 {
-	if (likely(part))
-		return dev_to_disk(part_to_dev(part)->parent);
+	if (likely(part)) {
+		if (part->partno)
+			return dev_to_disk(part_to_dev(part)->parent);
+		else
+			return dev_to_disk(part_to_dev(part));
+	}
 	return NULL;
 }
 
-- 
1.5.4.5

