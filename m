From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] Fix NULL pointer dereference in sd_revalidate_disk
Date: Wed, 22 Feb 2012 10:01:53 +0900
Message-ID: <4F443E81.2060402@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Naveen Goswamy <naveen.goswamy@polymtl.ca>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Dave Jones <davej@redhat.com>, sgruszka@redhat.com, Huajun Li <huajun.li.lee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Since 2.6.39 (1196f8b), when a driver returns -ENOMEDIUM for open(),
__blkdev_get() calls rescan_partitions() to remove
in-kernel partition structures and raise KOBJ_CHANGE uevent.

However it ends up calling driver's revalidate_disk without open
and could cause oops.

In the case of SCSI:

  process A                  process B
  ----------------------------------------------
  sys_open
    __blkdev_get
      sd_open
        returns -ENOMEDIUM
                             scsi_remove_device
                               <scsi_device torn down>
      rescan_partitions
        sd_revalidate_disk
          <oops>

Oopses are reported here:
http://marc.info/?l=linux-scsi&m=132388619710052

This patch separates the partition invalidation from rescan_partitions()
and use it for -ENOMEDIUM case. 

Reported-by: Huajun Li <huajun.li.lee@gmail.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
--
 block/partition-generic.c |   48 ++++++++++++++++++++++++++++++++++++++--------
 fs/block_dev.c            |   16 +++++++++++----
 include/linux/genhd.h     |    1 
 3 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index fe23ee7..e61d319 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -596,6 +596,7 @@ extern char *disk_name (struct gendisk *hd, int partno, char *buf);
 
 extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
+extern int invalidate_partitions(struct gendisk *disk, struct block_device *bdev);
 extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     int partno, sector_t start,
 						     sector_t len, int flags,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0e575d1..5e9f198 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1183,8 +1183,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			 * The latter is necessary to prevent ghost
 			 * partitions on a removed medium.
 			 */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(disk, bdev);
+			if (bdev->bd_invalidated) {
+				if (!ret)
+					rescan_partitions(disk, bdev);
+				else if (ret == -ENOMEDIUM)
+					invalidate_partitions(disk, bdev);
+			}
 			if (ret)
 				goto out_clear;
 		} else {
@@ -1214,8 +1218,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (bdev->bd_disk->fops->open)
 				ret = bdev->bd_disk->fops->open(bdev, mode);
 			/* the same as first opener case, read comment there */
-			if (bdev->bd_invalidated && (!ret || ret == -ENOMEDIUM))
-				rescan_partitions(bdev->bd_disk, bdev);
+			if (bdev->bd_invalidated) {
+				if (!ret)
+					rescan_partitions(bdev->bd_disk, bdev);
+				else if (ret == -ENOMEDIUM)
+					invalidate_partitions(bdev->bd_disk, bdev);
+			}
 			if (ret)
 				goto out_unlock_bdev;
 		}
diff --git a/block/partition-generic.c b/block/partition-generic.c
index d06ec1c..6df5d69 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -389,17 +389,11 @@ static bool disk_unlock_native_capacity(struct gendisk *disk)
 	}
 }
 
-int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
 {
-	struct parsed_partitions *state = NULL;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	int p, highest, res;
-rescan:
-	if (state && !IS_ERR(state)) {
-		kfree(state);
-		state = NULL;
-	}
+	int res;
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
@@ -412,6 +406,24 @@ rescan:
 		delete_partition(disk, part->partno);
 	disk_part_iter_exit(&piter);
 
+	return 0;
+}
+
+int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
+{
+	struct parsed_partitions *state = NULL;
+	struct hd_struct *part;
+	int p, highest, res;
+rescan:
+	if (state && !IS_ERR(state)) {
+		kfree(state);
+		state = NULL;
+	}
+
+	res = drop_partitions(disk, bdev);
+	if (res)
+		return res;
+
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
@@ -515,6 +527,26 @@ rescan:
 	return 0;
 }
 
+int invalidate_partitions(struct gendisk *disk, struct block_device *bdev)
+{
+	int res;
+
+	if (!bdev->bd_invalidated)
+		return 0;
+
+	res = drop_partitions(disk, bdev);
+	if (res)
+		return res;
+
+	set_capacity(disk, 0);
+	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
+	/* tell userspace that the media / partition table may have changed */
+	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+
+	return 0;
+}
+
 unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
