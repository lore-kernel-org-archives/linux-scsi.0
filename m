From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/13] block: move capacity from disk to part0
Date: Mon, 25 Aug 2008 19:56:07 +0900
Message-ID: <1219661777-17648-4-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Move disk->capacity to part0->nr_sects and convert all users who
directly accessed the field to use {get|set}_capacity().  This is done
early to allow the __dev field to be moved.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/aoe/aoeblk.c |    2 +-
 drivers/block/aoe/aoecmd.c |    4 ++--
 drivers/block/aoe/aoedev.c |    2 +-
 fs/partitions/check.c      |    2 +-
 include/linux/genhd.h      |    5 ++---
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 3edb6cb..aa69556 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -276,7 +276,7 @@ aoeblk_gdalloc(void *vp)
 	gd->first_minor = d->sysminor * AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
-	gd->capacity = d->ssize;
+	set_capacity(gd, d->ssize);
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 17eed8c..934800f 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -645,7 +645,7 @@ aoecmd_sleepwork(struct work_struct *work)
 		unsigned long flags;
 		u64 ssize;
 
-		ssize = d->gd->capacity;
+		ssize = get_capacity(d->gd);
 		bd = bdget_disk(d->gd, 0);
 
 		if (bd) {
@@ -707,7 +707,7 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 	if (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
 		return;
 	if (d->gd != NULL) {
-		d->gd->capacity = ssize;
+		set_capacity(d->gd, ssize);
 		d->flags |= DEVFL_NEWSIZE;
 	} else
 		d->flags |= DEVFL_GDALLOC;
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index a1d813a..6a8038d 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -91,7 +91,7 @@ aoedev_downdev(struct aoedev *d)
 	}
 
 	if (d->gd)
-		d->gd->capacity = 0;
+		set_capacity(d->gd, 0);
 
 	d->flags &= ~DEVFL_UP;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 121d445..540ef84 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -586,7 +586,7 @@ void del_gendisk(struct gendisk *disk)
 	disk_part_iter_exit(&piter);
 
 	invalidate_partition(disk, 0);
-	disk->capacity = 0;
+	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 	unlink_gendisk(disk);
 	disk_stat_set_all(disk, 0);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9970d96..c4490f2 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -148,7 +148,6 @@ struct gendisk {
 	struct request_queue *queue;
 	struct blk_scsi_cmd_filter cmd_filter;
 	void *private_data;
-	sector_t capacity;
 
 	int flags;
 	struct device *driverfs_dev;  // FIXME: remove
@@ -421,11 +420,11 @@ static inline sector_t get_start_sect(struct block_device *bdev)
 }
 static inline sector_t get_capacity(struct gendisk *disk)
 {
-	return disk->capacity;
+	return disk->part0.nr_sects;
 }
 static inline void set_capacity(struct gendisk *disk, sector_t size)
 {
-	disk->capacity = size;
+	disk->part0.nr_sects = size;
 }
 
 #ifdef CONFIG_SOLARIS_X86_PARTITION
-- 
1.5.4.5

