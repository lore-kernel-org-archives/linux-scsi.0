From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/13] block: unify sysfs size node handling
Date: Mon, 14 Jul 2008 16:48:05 +0900
Message-ID: <1216021693-483-6-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbYGNHuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:50:13 -0400
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

Now that capacity and __dev are moved to part0, part0 and others can
share the same method.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   10 +---------
 fs/partitions/check.c |    4 ++--
 include/linux/genhd.h |    3 +++
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 25f76d5..c5b45e9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -728,14 +728,6 @@ static ssize_t disk_removable_show(struct device *dev,
 		       (disk->flags & GENHD_FL_REMOVABLE ? 1 : 0));
 }
 
-static ssize_t disk_size_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-
-	return sprintf(buf, "%llu\n", (unsigned long long)get_capacity(disk));
-}
-
 static ssize_t disk_capability_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -801,7 +793,7 @@ static ssize_t disk_fail_store(struct device *dev,
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d504c1a..bc4453a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -208,8 +208,8 @@ static ssize_t part_start_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->start_sect);
 }
 
-static ssize_t part_size_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+ssize_t part_size_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c677bae..8933ba8 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -577,6 +577,9 @@ extern void blk_register_region(dev_t devt, unsigned long range,
 			void *data);
 extern void blk_unregister_region(dev_t devt, unsigned long range);
 
+extern ssize_t part_size_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
+
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
-- 
1.5.4.5

