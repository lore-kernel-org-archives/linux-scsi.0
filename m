From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] block: move register_disk() and del_gendisk() to block/genhd.c
Date: Mon,  1 Nov 2010 19:44:36 +0100
Message-ID: <1288637081-5183-3-git-send-email-tj@kernel.org>
References: <1288637081-5183-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1288637081-5183-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

There's no reason register_disk() and del_gendisk() should be in
fs/partitions/check.c and it forces unnecessary global functions.
Move both to genhd.c.  While at it, collapse unlink_gendisk(), which
was artificially in a separate function due to genhd.c/check.c split,
into del_gendisk().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c          |   90 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/partitions/check.c  |   89 -----------------------------------------------
 include/linux/blkdev.h |    1 -
 include/linux/genhd.h  |    1 -
 4 files changed, 87 insertions(+), 94 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 0905ab2..2e5e4c0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -502,6 +502,64 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+void register_disk(struct gendisk *disk)
+{
+	struct device *ddev = disk_to_dev(disk);
+	struct block_device *bdev;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+	int err;
+
+	ddev->parent = disk->driverfs_dev;
+
+	dev_set_name(ddev, disk->disk_name);
+
+	/* delay uevents, until we scanned partition table */
+	dev_set_uevent_suppress(ddev, 1);
+
+	if (device_add(ddev))
+		return;
+	if (!sysfs_deprecated) {
+		err = sysfs_create_link(block_depr, &ddev->kobj,
+					kobject_name(&ddev->kobj));
+		if (err) {
+			device_del(ddev);
+			return;
+		}
+	}
+	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
+	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
+
+	/* No minors to use for partitions */
+	if (!disk_partitionable(disk))
+		goto exit;
+
+	/* No such device (e.g., media were just removed) */
+	if (!get_capacity(disk))
+		goto exit;
+
+	bdev = bdget_disk(disk, 0);
+	if (!bdev)
+		goto exit;
+
+	bdev->bd_invalidated = 1;
+	err = blkdev_get(bdev, FMODE_READ, NULL);
+	if (err < 0)
+		goto exit;
+	blkdev_put(bdev, FMODE_READ);
+
+exit:
+	/* announce disk after possible partitions are created */
+	dev_set_uevent_suppress(ddev, 0);
+	kobject_uevent(&ddev->kobj, KOBJ_ADD);
+
+	/* announce possible partitions */
+	disk_part_iter_init(&piter, disk, 0);
+	while ((part = disk_part_iter_next(&piter)))
+		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
+	disk_part_iter_exit(&piter);
+}
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
@@ -552,17 +610,43 @@ void add_disk(struct gendisk *disk)
 				   "bdi");
 	WARN_ON(retval);
 }
-
 EXPORT_SYMBOL(add_disk);
-EXPORT_SYMBOL(del_gendisk);	/* in partitions/check.c */
 
-void unlink_gendisk(struct gendisk *disk)
+void del_gendisk(struct gendisk *disk)
 {
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	/* invalidate stuff */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	while ((part = disk_part_iter_next(&piter))) {
+		invalidate_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+
+	invalidate_partition(disk, 0);
+	blk_free_devt(disk_to_dev(disk)->devt);
+	set_capacity(disk, 0);
+	disk->flags &= ~GENHD_FL_UP;
+
 	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
 	blk_unregister_region(disk_devt(disk), disk->minors);
+
+	part_stat_set_all(&disk->part0, 0);
+	disk->part0.stamp = 0;
+
+	kobject_put(disk->part0.holder_dir);
+	kobject_put(disk->slave_dir);
+	disk->driverfs_dev = NULL;
+	if (!sysfs_deprecated)
+		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
+	device_del(disk_to_dev(disk));
 }
+EXPORT_SYMBOL(del_gendisk);
 
 /**
  * get_gendisk - get partitioning information for a given device
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 2e6501d..e4afbac 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -507,65 +507,6 @@ out_put:
 	return ERR_PTR(err);
 }
 
-/* Not exported, helper to add_disk(). */
-void register_disk(struct gendisk *disk)
-{
-	struct device *ddev = disk_to_dev(disk);
-	struct block_device *bdev;
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-	int err;
-
-	ddev->parent = disk->driverfs_dev;
-
-	dev_set_name(ddev, disk->disk_name);
-
-	/* delay uevents, until we scanned partition table */
-	dev_set_uevent_suppress(ddev, 1);
-
-	if (device_add(ddev))
-		return;
-	if (!sysfs_deprecated) {
-		err = sysfs_create_link(block_depr, &ddev->kobj,
-					kobject_name(&ddev->kobj));
-		if (err) {
-			device_del(ddev);
-			return;
-		}
-	}
-	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
-	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
-
-	/* No minors to use for partitions */
-	if (!disk_partitionable(disk))
-		goto exit;
-
-	/* No such device (e.g., media were just removed) */
-	if (!get_capacity(disk))
-		goto exit;
-
-	bdev = bdget_disk(disk, 0);
-	if (!bdev)
-		goto exit;
-
-	bdev->bd_invalidated = 1;
-	err = blkdev_get(bdev, FMODE_READ, NULL);
-	if (err < 0)
-		goto exit;
-	blkdev_put(bdev, FMODE_READ);
-
-exit:
-	/* announce disk after possible partitions are created */
-	dev_set_uevent_suppress(ddev, 0);
-	kobject_uevent(&ddev->kobj, KOBJ_ADD);
-
-	/* announce possible partitions */
-	disk_part_iter_init(&piter, disk, 0);
-	while ((part = disk_part_iter_next(&piter)))
-		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
-	disk_part_iter_exit(&piter);
-}
-
 static bool disk_unlock_native_capacity(struct gendisk *disk)
 {
 	const struct block_device_operations *bdops = disk->fops;
@@ -728,33 +669,3 @@ fail:
 }
 
 EXPORT_SYMBOL(read_dev_sector);
-
-void del_gendisk(struct gendisk *disk)
-{
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-
-	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
-	while ((part = disk_part_iter_next(&piter))) {
-		invalidate_partition(disk, part->partno);
-		delete_partition(disk, part->partno);
-	}
-	disk_part_iter_exit(&piter);
-
-	invalidate_partition(disk, 0);
-	blk_free_devt(disk_to_dev(disk)->devt);
-	set_capacity(disk, 0);
-	disk->flags &= ~GENHD_FL_UP;
-	unlink_gendisk(disk);
-	part_stat_set_all(&disk->part0, 0);
-	disk->part0.stamp = 0;
-
-	kobject_put(disk->part0.holder_dir);
-	kobject_put(disk->slave_dir);
-	disk->driverfs_dev = NULL;
-	if (!sysfs_deprecated)
-		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
-	device_del(disk_to_dev(disk));
-}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5027a59..c6f9e3c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -644,7 +644,6 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
-extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5e4e692..56e17ed 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -394,7 +394,6 @@ extern void part_round_stats(int cpu, struct hd_struct *part);
 /* block/genhd.c */
 extern void add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
-extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
-- 
1.7.1
