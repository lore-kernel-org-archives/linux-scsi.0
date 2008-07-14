From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/13] block: always set bdev->bd_part
Date: Mon, 14 Jul 2008 16:48:08 +0900
Message-ID: <1216021693-483-9-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Till now, bdev->bd_part is set only if the bdev was for parts other
than part0.  This patch makes bdev->bd_part always set so that code
paths don't have to differenciate common handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c      |    2 +-
 drivers/md/md.c       |    5 +---
 fs/block_dev.c        |   67 ++++++++++++++++++++++--------------------------
 fs/partitions/check.c |    7 +----
 include/linux/genhd.h |    2 +-
 5 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1da936f..511b8c7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1263,7 +1263,7 @@ __setup("fail_make_request=", setup_fail_make_request);
 static int should_fail_request(struct bio *bio)
 {
 	if ((bio->bi_bdev->bd_disk->flags & GENHD_FL_FAIL) ||
-	    (bio->bi_bdev->bd_part && bio->bi_bdev->bd_part->make_it_fail))
+	    bio->bi_bdev->bd_part->make_it_fail)
 		return should_fail(&fail_make_request, bio->bi_size);
 
 	return 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4d6ef34..cff446f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1415,10 +1415,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
 
-	if (rdev->bdev->bd_part)
-		ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
-	else
-		ko = &disk_to_dev(rdev->bdev->bd_disk)->kobj;
+	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
 	if ((err = sysfs_create_link(&rdev->kobj, ko, "block"))) {
 		kobject_del(&rdev->kobj);
 		goto fail;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a563e71..58ad44f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -540,14 +540,6 @@ EXPORT_SYMBOL(bd_release);
  *           /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
  */
 
-static struct kobject *bdev_get_kobj(struct block_device *bdev)
-{
-	if (bdev->bd_contains != bdev)
-		return kobject_get(&part_to_dev(bdev->bd_part)->kobj);
-	else
-		return kobject_get(&disk_to_dev(bdev->bd_disk)->kobj);
-}
-
 static int add_symlink(struct kobject *from, struct kobject *to)
 {
 	if (!from || !to)
@@ -596,7 +588,7 @@ static int bd_holder_grab_dirs(struct block_device *bdev,
 	if (!bo->hdev)
 		goto fail_put_sdir;
 
-	bo->sdev = bdev_get_kobj(bdev);
+	bo->sdev = kobject_get(&part_to_dev(bdev->bd_part)->kobj);
 	if (!bo->sdev)
 		goto fail_put_hdev;
 
@@ -919,7 +911,6 @@ static int __blkdev_put(struct block_device *bdev, int for_part);
 
 static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
-	struct module *owner = NULL;
 	struct gendisk *disk;
 	struct hd_struct *part = NULL;
 	int ret;
@@ -939,25 +930,27 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 
 	ret = -ENXIO;
 	file->f_mapping = bdev->bd_inode->i_mapping;
+
 	lock_kernel();
+
 	disk = get_gendisk(bdev->bd_dev, &partno);
-	if (!disk) {
-		unlock_kernel();
-		bdput(bdev);
-		return ret;
-	}
-	owner = disk->fops->owner;
+	if (!disk)
+		goto out_unlock_kernel;
+	part = disk_get_part(disk, partno);
+	if (!part)
+		goto out_unlock_kernel;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
+		bdev->bd_part = part;
 		bdev->bd_contains = bdev;
 		if (!partno) {
 			struct backing_dev_info *bdi;
 			if (disk->fops->open) {
 				ret = disk->fops->open(bdev->bd_inode, file);
 				if (ret)
-					goto out_first;
+					goto out_clear;
 			}
 			if (!bdev->bd_openers) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
@@ -973,31 +966,32 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 			whole = bdget_disk(disk, 0);
 			ret = -ENOMEM;
 			if (!whole)
-				goto out_first;
+				goto out_clear;
 			BUG_ON(for_part);
 			ret = __blkdev_get(whole, file->f_mode, file->f_flags, 1);
 			if (ret)
-				goto out_first;
+				goto out_clear;
 			bdev->bd_contains = whole;
-			part = disk_get_part(disk, partno);
 			bdev->bd_inode->i_data.backing_dev_info =
 			   whole->bd_inode->i_data.backing_dev_info;
 			if (!(disk->flags & GENHD_FL_UP) ||
 			    !part || !part->nr_sects) {
 				ret = -ENXIO;
-				goto out_first;
+				goto out_clear;
 			}
-			bdev->bd_part = part;
 			bd_set_size(bdev, (loff_t)part->nr_sects << 9);
 		}
 	} else {
+		disk_put_part(part);
 		put_disk(disk);
-		module_put(owner);
+		module_put(disk->fops->owner);
+		part = NULL;
+		disk = NULL;
 		if (bdev->bd_contains == bdev) {
 			if (bdev->bd_disk->fops->open) {
 				ret = bdev->bd_disk->fops->open(bdev->bd_inode, file);
 				if (ret)
-					goto out;
+					goto out_unlock_bdev;
 			}
 			if (bdev->bd_invalidated)
 				rescan_partitions(bdev->bd_disk, bdev);
@@ -1010,20 +1004,24 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 	unlock_kernel();
 	return 0;
 
-out_first:
+ out_clear:
 	bdev->bd_disk = NULL;
+	bdev->bd_part = NULL;
 	bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, 1);
 	bdev->bd_contains = NULL;
-	put_disk(disk);
-	disk_put_part(part);
-	module_put(owner);
-out:
+ out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
+ out_unlock_kernel:
 	unlock_kernel();
-	if (ret)
-		bdput(bdev);
+
+	disk_put_part(part);
+	if (disk)
+		module_put(disk->fops->owner);
+	put_disk(disk);
+	bdput(bdev);
+
 	return ret;
 }
 
@@ -1108,11 +1106,8 @@ static int __blkdev_put(struct block_device *bdev, int for_part)
 
 		put_disk(disk);
 		module_put(owner);
-
-		if (bdev->bd_contains != bdev) {
-			disk_put_part(bdev->bd_part);
-			bdev->bd_part = NULL;
-		}
+		disk_put_part(bdev->bd_part);
+		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
 		bdev->bd_inode->i_data.backing_dev_info = &default_backing_dev_info;
 		if (bdev != bdev->bd_contains)
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e247b81..931d366 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -134,12 +134,7 @@ char *disk_name(struct gendisk *hd, int partno, char *buf)
 
 const char *bdevname(struct block_device *bdev, char *buf)
 {
-	int partno = 0;
-
-	if (bdev->bd_part)
-		partno = bdev->bd_part->partno;
-
-	return disk_name(bdev->bd_disk, partno, buf);
+	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
 }
 
 EXPORT_SYMBOL(bdevname);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index bf3d7e3..8c94f17 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -398,7 +398,7 @@ extern void rand_initialize_disk(struct gendisk *disk);
 
 static inline sector_t get_start_sect(struct block_device *bdev)
 {
-	return bdev->bd_contains == bdev ? 0 : bdev->bd_part->start_sect;
+	return bdev->bd_part->start_sect;
 }
 static inline sector_t get_capacity(struct gendisk *disk)
 {
-- 
1.5.4.5

