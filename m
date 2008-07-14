From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/13] block: move holder_dir from disk to part0
Date: Mon, 14 Jul 2008 16:48:07 +0900
Message-ID: <1216021693-483-8-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbYGNHt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:49:29 -0400
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

Move disk->holder_dir to part0->holder_dir.  Kill now mostly
superflous bdev_get_holder().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/block_dev.c        |   10 +---------
 fs/partitions/check.c |   20 +++++++-------------
 include/linux/genhd.h |    1 -
 3 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4fd822d..a563e71 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -548,14 +548,6 @@ static struct kobject *bdev_get_kobj(struct block_device *bdev)
 		return kobject_get(&disk_to_dev(bdev->bd_disk)->kobj);
 }
 
-static struct kobject *bdev_get_holder(struct block_device *bdev)
-{
-	if (bdev->bd_contains != bdev)
-		return kobject_get(bdev->bd_part->holder_dir);
-	else
-		return kobject_get(bdev->bd_disk->holder_dir);
-}
-
 static int add_symlink(struct kobject *from, struct kobject *to)
 {
 	if (!from || !to)
@@ -608,7 +600,7 @@ static int bd_holder_grab_dirs(struct block_device *bdev,
 	if (!bo->sdev)
 		goto fail_put_hdev;
 
-	bo->hdir = bdev_get_holder(bdev);
+	bo->hdir = kobject_get(bdev->bd_part->holder_dir);
 	if (!bo->hdir)
 		goto fail_put_sdev;
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index bb969a0..e247b81 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -304,23 +304,17 @@ struct device_type part_type = {
 	.release	= part_release,
 };
 
-static inline void partition_sysfs_add_subdir(struct hd_struct *p)
+static inline void partition_sysfs_add_subdir(struct hd_struct *part)
 {
-	struct kobject *k;
-
-	k = kobject_get(&part_to_dev(p)->kobj);
-	p->holder_dir = kobject_create_and_add("holders", k);
-	kobject_put(k);
+	part->holder_dir = kobject_create_and_add("holders",
+						  &part_to_dev(part)->kobj);
 }
 
 static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
 {
-	struct kobject *k;
-
-	k = kobject_get(&disk_to_dev(disk)->kobj);
-	disk->holder_dir = kobject_create_and_add("holders", k);
-	disk->slave_dir = kobject_create_and_add("slaves", k);
-	kobject_put(k);
+	partition_sysfs_add_subdir(&disk->part0);
+	disk->slave_dir = kobject_create_and_add("slaves",
+						 &disk_to_dev(disk)->kobj);
 }
 
 static void delete_partition_rcu_cb(struct rcu_head *head)
@@ -588,7 +582,7 @@ void del_gendisk(struct gendisk *disk)
 	disk_stat_set_all(disk, 0);
 	disk->stamp = 0;
 
-	kobject_put(disk->holder_dir);
+	kobject_put(disk->part0.holder_dir);
 	kobject_put(disk->slave_dir);
 	disk->driverfs_dev = NULL;
 #ifndef CONFIG_SYSFS_DEPRECATED
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0edef09..bf3d7e3 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -142,7 +142,6 @@ struct gendisk {
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
-	struct kobject *holder_dir;
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-- 
1.5.4.5

