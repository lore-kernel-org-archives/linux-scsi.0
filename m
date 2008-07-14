From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/13] block: kill GENHD_FL_FAIL and use part0->make_it_fail
Date: Mon, 14 Jul 2008 16:48:09 +0900
Message-ID: <1216021693-483-10-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

GENHD_FL_FAIL for disk is what make_it_fail is for parts.  Kill it and
use part0->make_it_fail.  Sysfs node handling is unified too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c      |    5 +++--
 block/genhd.c         |   30 +-----------------------------
 fs/partitions/check.c |   10 +++++-----
 include/linux/genhd.h |    9 +++++++--
 4 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 511b8c7..332d695 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1262,8 +1262,9 @@ __setup("fail_make_request=", setup_fail_make_request);
 
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
index ff33b8c..21b8535 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -762,34 +762,6 @@ static ssize_t disk_stat_show(struct device *dev,
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
@@ -798,7 +770,7 @@ static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, disk_fail_show, disk_fail_store);
+	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
 #endif
 
 static struct attribute *disk_attrs[] = {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 931d366..ddd0258 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -237,17 +237,17 @@ static ssize_t part_stat_show(struct device *dev,
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
index 8c94f17..61448a9 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -112,8 +112,6 @@ struct hd_struct {
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
-#define GENHD_FL_FAIL				64
-
 
 struct gendisk {
 	/* major, first_minor, minors and ext_minors are input
@@ -582,6 +580,13 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
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

