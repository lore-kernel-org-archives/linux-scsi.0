From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] block: move policy from disk to part0
Date: Mon, 14 Jul 2008 16:48:06 +0900
Message-ID: <1216021693-483-7-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Move disk->policy to part0->policy.  Implement and use get_disk_ro().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   14 ++++----------
 drivers/ide/ide-cd.c  |    2 +-
 drivers/md/dm-ioctl.c |    2 +-
 fs/partitions/check.c |    2 +-
 include/linux/genhd.h |    6 +++++-
 5 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c5b45e9..ff33b8c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1090,10 +1090,7 @@ EXPORT_SYMBOL(put_disk);
 
 void set_device_ro(struct block_device *bdev, int flag)
 {
-	if (bdev->bd_contains != bdev)
-		bdev->bd_part->policy = flag;
-	else
-		bdev->bd_disk->policy = flag;
+	bdev->bd_part->policy = flag;
 }
 
 EXPORT_SYMBOL(set_device_ro);
@@ -1103,8 +1100,8 @@ void set_disk_ro(struct gendisk *disk, int flag)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
-	disk->policy = flag;
-	disk_part_iter_start(&piter, disk, DISK_PITER_INCL_EMPTY);
+	disk_part_iter_start(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_INCL_PART0);
 	while ((part = disk_part_iter_next(&piter)))
 		part->policy = flag;
 	disk_part_iter_stop(&piter);
@@ -1116,10 +1113,7 @@ int bdev_read_only(struct block_device *bdev)
 {
 	if (!bdev)
 		return 0;
-	else if (bdev->bd_contains != bdev)
-		return bdev->bd_part->policy;
-	else
-		return bdev->bd_disk->policy;
+	return bdev->bd_part->policy;
 }
 
 EXPORT_SYMBOL(bdev_read_only);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 68e7f19..86752cb 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1126,7 +1126,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 
 	if (write) {
 		/* disk has become write protected */
-		if (cd->disk->policy) {
+		if (get_disk_ro(cd->disk)) {
 			cdrom_end_request(drive, 0);
 			return ide_stopped;
 		}
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c3de311..5b91915 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -548,7 +548,7 @@ static int __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	 */
 	param->open_count = dm_open_count(md);
 
-	if (disk->policy)
+	if (get_disk_ro(disk))
 		param->flags |= DM_READONLY_FLAG;
 
 	param->event_nr = dm_get_event_nr(md);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index bc4453a..bb969a0 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -384,7 +384,7 @@ int add_partition(struct gendisk *disk, int partno,
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = partno;
-	p->policy = disk->policy;
+	p->policy = get_disk_ro(disk);
 
 	dname = dev_name(ddev);
 	if (isdigit(dname[strlen(dname) - 1]))
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 8933ba8..0edef09 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -146,7 +146,6 @@ struct gendisk {
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-	int policy;
 
 	atomic_t sync_io;		/* RAID */
 	unsigned long stamp;
@@ -389,6 +388,11 @@ extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
 
+static inline int get_disk_ro(struct gendisk *disk)
+{
+	return disk->part0.policy;
+}
+
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk);
 extern void rand_initialize_disk(struct gendisk *disk);
-- 
1.5.4.5

