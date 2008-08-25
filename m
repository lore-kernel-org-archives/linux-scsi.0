From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/13] block: kill GENHD_FL_FAIL and use part0->make_it_fail
Date: Mon, 25 Aug 2008 19:56:13 +0900
Message-ID: <1219661777-17648-10-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:51809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbYHYK6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 06:58:13 -0400
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

GENHD_FL_FAIL for disk is what make_it_fail is for parts.  Kill it and
use part0->make_it_fail.  Sysfs node handling is unified too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c      |    5 +++--
 block/genhd.c         |   30 +-----------------------------
 fs/partitions/check.c |   10 +++++-----
 include/linux/genhd.h |    8 +++++++-
 4 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 09bba70..3a059cf 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1271,8 +1271,9 @@ __setup("fail_make_request=", setup_fail_make_request);
 
 static int should_fail_request(struct bio *bio)
 {
-	if ((bio->bi_bdev->bd_disk->flags & GENHD_FL_FAIL) ||
-	    bio->bi_bdev->bd_part->make_it_fail)
+	struct hd_struct *part = bio->bi_bdev->bd_part;
+
+	if (part_to_disk(part)->part0.make_it_fail || part->make_it_fail)
 		return should_fail(&fail_make_request, bio->bi_size);
 
 	return 0;
diff --git a/block/genhd.c b/block/genhd.c
index 8762f35..b0a11c7 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -796,34 +796,6 @@ static ssize_t disk_stat_show(struct device *dev,
 		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
 }
 
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-static ssize_t disk_fail_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-
-	return sprintf(buf, "%d\n", disk->flags & GENHD_FL_FAIL ? 1 : 0);
-}
-
-static ssize_t disk_fail_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-	int i;
-
-	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
-		if (i == 0)
-			disk->flags &= ~GENHD_FL_FAIL;
-		else
-			disk->flags |= GENHD_FL_FAIL;
-	}
-
-	return count;
-}
-
-#endif
-
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -833,7 +805,7 @@ static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, disk_fail_show, disk_fail_store);
+	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
 #endif
 
 static struct attribute *disk_attrs[] = {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index f99dd96..88fcf5a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -238,17 +238,17 @@ static ssize_t part_stat_show(struct device *dev,
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-static ssize_t part_fail_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+ssize_t part_fail_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 
 	return sprintf(buf, "%d\n", p->make_it_fail);
 }
 
-static ssize_t part_fail_store(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
+ssize_t part_fail_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	int i;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0743324..46d2a6f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -112,7 +112,6 @@ struct hd_struct {
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
-#define GENHD_FL_FAIL				64
 
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
@@ -606,6 +605,13 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+extern ssize_t part_fail_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
+extern ssize_t part_fail_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count);
+#endif /* CONFIG_FAIL_MAKE_REQUEST */
 
 #else /* CONFIG_BLOCK */
 
-- 
1.5.4.5

