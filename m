From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] Revert "scsi, block: fix duplicate bdi name registration crashes"
Date: Thu,  9 Mar 2017 11:16:24 +0100
Message-ID: <20170309101624.25901-5-jack@suse.cz>
References: <20170309101624.25901-1-jack@suse.cz>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170309101624.25901-1-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

This reverts commit 0dba1314d4f81115dce711292ec7981d17231064. It causes
leaking of device numbers for SCSI when SCSI registers multiple gendisks
for one request_queue in succession. It can be easily reproduced using
Omar's script [1] on kernel with CONFIG_DEBUG_TEST_DRIVER_REMOVE.
Furthermore the protection provided by this commit is not needed anymore
as the problem it was fixing got also fixed by commit 165a5e22fafb
"block: Move bdi_unregister() to del_gendisk()".

[1]: http://marc.info/?l=linux-block&m=148554717109098&w=2

Tested-by: Omar Sandoval <osandov@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-core.c       |  2 --
 block/genhd.c          | 21 ---------------------
 drivers/scsi/sd.c      | 41 ++++++++---------------------------------
 include/linux/blkdev.h |  1 -
 include/linux/genhd.h  |  8 --------
 5 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1086dac8724c..a76895c9776d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -578,8 +578,6 @@ void blk_cleanup_queue(struct request_queue *q)
 		q->queue_lock = &q->__queue_lock;
 	spin_unlock_irq(lock);
 
-	put_disk_devt(q->disk_devt);
-
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
diff --git a/block/genhd.c b/block/genhd.c
index 94f323842b52..a9c516a8b37d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -572,20 +572,6 @@ static void register_disk(struct device *parent, struct gendisk *disk)
 	disk_part_iter_exit(&piter);
 }
 
-void put_disk_devt(struct disk_devt *disk_devt)
-{
-	if (disk_devt && atomic_dec_and_test(&disk_devt->count))
-		disk_devt->release(disk_devt);
-}
-EXPORT_SYMBOL(put_disk_devt);
-
-void get_disk_devt(struct disk_devt *disk_devt)
-{
-	if (disk_devt)
-		atomic_inc(&disk_devt->count);
-}
-EXPORT_SYMBOL(get_disk_devt);
-
 /**
  * device_add_disk - add partitioning information to kernel list
  * @parent: parent device for the disk
@@ -626,13 +612,6 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 
 	disk_alloc_events(disk);
 
-	/*
-	 * Take a reference on the devt and assign it to queue since it
-	 * must not be reallocated while the bdi is registered
-	 */
-	disk->queue->disk_devt = disk->disk_devt;
-	get_disk_devt(disk->disk_devt);
-
 	/* Register BDI before referencing it from bdev */
 	bdi = disk->queue->backing_dev_info;
 	bdi_register_owner(bdi, disk_to_dev(disk));
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7839f6c35cc..d277e8620e3e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3075,23 +3075,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	put_device(&sdkp->dev);
 }
 
-struct sd_devt {
-	int idx;
-	struct disk_devt disk_devt;
-};
-
-static void sd_devt_release(struct disk_devt *disk_devt)
-{
-	struct sd_devt *sd_devt = container_of(disk_devt, struct sd_devt,
-			disk_devt);
-
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sd_devt->idx);
-	spin_unlock(&sd_index_lock);
-
-	kfree(sd_devt);
-}
-
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -3113,7 +3096,6 @@ static void sd_devt_release(struct disk_devt *disk_devt)
 static int sd_probe(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	struct sd_devt *sd_devt;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	int index;
@@ -3139,13 +3121,9 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	sd_devt = kzalloc(sizeof(*sd_devt), GFP_KERNEL);
-	if (!sd_devt)
-		goto out_free;
-
 	gd = alloc_disk(SD_MINORS);
 	if (!gd)
-		goto out_free_devt;
+		goto out_free;
 
 	do {
 		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
@@ -3161,11 +3139,6 @@ static int sd_probe(struct device *dev)
 		goto out_put;
 	}
 
-	atomic_set(&sd_devt->disk_devt.count, 1);
-	sd_devt->disk_devt.release = sd_devt_release;
-	sd_devt->idx = index;
-	gd->disk_devt = &sd_devt->disk_devt;
-
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error) {
 		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
@@ -3205,12 +3178,11 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	put_disk_devt(&sd_devt->disk_devt);
-	sd_devt = NULL;
+	spin_lock(&sd_index_lock);
+	ida_remove(&sd_index_ida, index);
+	spin_unlock(&sd_index_lock);
  out_put:
 	put_disk(gd);
- out_free_devt:
-	kfree(sd_devt);
  out_free:
 	kfree(sdkp);
  out:
@@ -3271,7 +3243,10 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	put_disk_devt(disk->disk_devt);
+	spin_lock(&sd_index_lock);
+	ida_remove(&sd_index_ida, sdkp->index);
+	spin_unlock(&sd_index_lock);
+
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 796016e63c1d..5a7da607ca04 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -435,7 +435,6 @@ struct request_queue {
 	struct delayed_work	delay_work;
 
 	struct backing_dev_info	*backing_dev_info;
-	struct disk_devt	*disk_devt;
 
 	/*
 	 * The queue owner gets to use this for whatever they like.
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a999d281a2f1..76f39754e7b0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -167,13 +167,6 @@ struct blk_integrity {
 };
 
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
-struct disk_devt {
-	atomic_t count;
-	void (*release)(struct disk_devt *disk_devt);
-};
-
-void put_disk_devt(struct disk_devt *disk_devt);
-void get_disk_devt(struct disk_devt *disk_devt);
 
 struct gendisk {
 	/* major, first_minor and minors are input parameters only,
@@ -183,7 +176,6 @@ struct gendisk {
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
-	struct disk_devt *disk_devt;
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
 	char *(*devnode)(struct gendisk *gd, umode_t *mode);
-- 
2.10.2
