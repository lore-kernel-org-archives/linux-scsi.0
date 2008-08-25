From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] block: move policy from disk to part0
Date: Mon, 25 Aug 2008 19:56:10 +0900
Message-ID: <1219661777-17648-7-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:51830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbYHYK6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 06:58:25 -0400
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Move disk->policy to part0->policy.  Implement and use get_disk_ro().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   16 +++++-----------
 drivers/ide/ide-cd.c  |    2 +-
 drivers/md/dm-ioctl.c |    2 +-
 fs/partitions/check.c |    2 +-
 include/linux/genhd.h |    6 +++++-
 5 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b560d71..8762f35 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -758,7 +758,7 @@ static ssize_t disk_ro_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk->policy ? 1 : 0);
+	return sprintf(buf, "%d\n", get_disk_ro(disk) ? 1 : 0);
 }
 
 static ssize_t disk_capability_show(struct device *dev,
@@ -1091,10 +1091,7 @@ EXPORT_SYMBOL(put_disk);
 
 void set_device_ro(struct block_device *bdev, int flag)
 {
-	if (bdev->bd_contains != bdev)
-		bdev->bd_part->policy = flag;
-	else
-		bdev->bd_disk->policy = flag;
+	bdev->bd_part->policy = flag;
 }
 
 EXPORT_SYMBOL(set_device_ro);
@@ -1104,8 +1101,8 @@ void set_disk_ro(struct gendisk *disk, int flag)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
-	disk->policy = flag;
-	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
+	disk_part_iter_init(&piter, disk,
+			    DISK_PITER_INCL_EMPTY | DISK_PITER_INCL_PART0);
 	while ((part = disk_part_iter_next(&piter)))
 		part->policy = flag;
 	disk_part_iter_exit(&piter);
@@ -1117,10 +1114,7 @@ int bdev_read_only(struct block_device *bdev)
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
index 49a8c58..62c3a79 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1113,7 +1113,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 
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
index 9ab3e64..cb9ec77 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -375,7 +375,7 @@ int add_partition(struct gendisk *disk, int partno,
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = partno;
-	p->policy = disk->policy;
+	p->policy = get_disk_ro(disk);
 
 	dname = dev_name(ddev);
 	if (isdigit(dname[strlen(dname) - 1]))
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e89559a..461ba6d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -155,7 +155,6 @@ struct gendisk {
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-	int policy;
 
 	atomic_t sync_io;		/* RAID */
 	unsigned long stamp;
@@ -413,6 +412,11 @@ extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
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

