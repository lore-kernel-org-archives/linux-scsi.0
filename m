From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/13] block: unify sysfs size node handling
Date: Mon, 25 Aug 2008 19:56:09 +0900
Message-ID: <1219661777-17648-6-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Now that capacity and __dev are moved to part0, part0 and others can
share the same method.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   10 +---------
 fs/partitions/check.c |    4 ++--
 include/linux/genhd.h |    3 +++
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index aca135a..b560d71 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -761,14 +761,6 @@ static ssize_t disk_ro_show(struct device *dev,
 	return sprintf(buf, "%d\n", disk->policy ? 1 : 0);
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
@@ -836,7 +828,7 @@ static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 540ef84..9ab3e64 100644
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
index 242effa..e89559a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -601,6 +601,9 @@ extern void blk_register_region(dev_t devt, unsigned long range,
 			void *data);
 extern void blk_unregister_region(dev_t devt, unsigned long range);
 
+extern ssize_t part_size_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
+
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
-- 
1.5.4.5

