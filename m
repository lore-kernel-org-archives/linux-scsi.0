From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/13] block: move holder_dir from disk to part0
Date: Mon, 25 Aug 2008 19:56:11 +0900
Message-ID: <1219661777-17648-8-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Move disk->holder_dir to part0->holder_dir.  Kill now mostly
superflous bdev_get_holder().

While at it, kill superflous kobject_get/put() around holder_dir,
slave_dir and cmd_filter creation and collapse
disk_sysfs_add_subdirs() into register_disk().  These serve no purpose
but obfuscating the code.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cmd-filter.c    |   12 +++---------
 fs/block_dev.c        |   10 +---------
 fs/partitions/check.c |   15 +++------------
 include/linux/genhd.h |    1 -
 4 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index eec4404..1ab98b2 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -309,14 +309,10 @@ int blk_register_filter(struct gendisk *disk)
 {
 	int ret;
 	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
-	struct kobject *parent = kobject_get(disk->holder_dir->parent);
-
-	if (!parent)
-		return -ENODEV;
-
-	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent,
-				 "%s", "cmd_filter");
 
+	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype,
+				   &disk_to_dev(disk)->kobj,
+				   "%s", "cmd_filter");
 	if (ret < 0)
 		return ret;
 
@@ -329,6 +325,4 @@ void blk_unregister_filter(struct gendisk *disk)
 	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
 
 	kobject_put(&filter->kobj);
-	kobject_put(disk->holder_dir->parent);
 }
-
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c982a91..57d5726 100644
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
index cb9ec77..7e4a7d4 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -305,16 +305,6 @@ struct device_type part_type = {
 	.release	= part_release,
 };
 
-static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
-{
-	struct kobject *k;
-
-	k = kobject_get(&disk_to_dev(disk)->kobj);
-	disk->holder_dir = kobject_create_and_add("holders", k);
-	disk->slave_dir = kobject_create_and_add("slaves", k);
-	kobject_put(k);
-}
-
 static void delete_partition_rcu_cb(struct rcu_head *head)
 {
 	struct hd_struct *part = container_of(head, struct hd_struct, rcu_head);
@@ -464,7 +454,8 @@ void register_disk(struct gendisk *disk)
 		return;
 	}
 #endif
-	disk_sysfs_add_subdirs(disk);
+	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
+	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
 	/* No minors to use for partitions */
 	if (!disk_partitionable(disk))
@@ -592,7 +583,7 @@ void del_gendisk(struct gendisk *disk)
 	disk_stat_set_all(disk, 0);
 	disk->stamp = 0;
 
-	kobject_put(disk->holder_dir);
+	kobject_put(disk->part0.holder_dir);
 	kobject_put(disk->slave_dir);
 	disk->driverfs_dev = NULL;
 #ifndef CONFIG_SYSFS_DEPRECATED
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 461ba6d..a8573ba 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -151,7 +151,6 @@ struct gendisk {
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
-	struct kobject *holder_dir;
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-- 
1.5.4.5

