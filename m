From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3] scsi, block: fix duplicate bdi name registration crashes
Date: Wed, 01 Feb 2017 14:05:23 -0800
Message-ID: <148598661794.11527.10024529085859239448.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

Warnings of the following form occur because scsi reuses a devt number
while the block layer still has it referenced as the name of the bdi
[1]:

 WARNING: CPU: 1 PID: 93 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
 sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:192'
 [..]
 Call Trace:
  dump_stack+0x86/0xc3
  __warn+0xcb/0xf0
  warn_slowpath_fmt+0x5f/0x80
  ? kernfs_path_from_node+0x4f/0x60
  sysfs_warn_dup+0x62/0x80
  sysfs_create_dir_ns+0x77/0x90
  kobject_add_internal+0xb2/0x350
  kobject_add+0x75/0xd0
  device_add+0x15a/0x650
  device_create_groups_vargs+0xe0/0xf0
  device_create_vargs+0x1c/0x20
  bdi_register+0x90/0x240
  ? lockdep_init_map+0x57/0x200
  bdi_register_owner+0x36/0x60
  device_add_disk+0x1bb/0x4e0
  ? __pm_runtime_use_autosuspend+0x5c/0x70
  sd_probe_async+0x10d/0x1c0
  async_run_entry_fn+0x39/0x170

This is a brute-force fix to pass the devt release information from
sd_probe() to the locations where we register the bdi,
device_add_disk(), and unregister the bdi, blk_cleanup_queue().

Thanks to Omar for the quick reproducer script [2]. This patch survives
where an unmodified kernel fails in a few seconds.

[1]: https://marc.info/?l=linux-scsi&m=147116857810716&w=4
[2]: http://marc.info/?l=linux-block&m=148554717109098&w=2

Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Reported-by: Omar Sandoval <osandov@osandov.com>
Tested-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v3:
 * un-inline {get,put}_disk_devt() (Bart)
 * added Omar's tested-by from v2

Changes in v2:
 * rebased on top of Jan's bdi lifetime series
 * replace kref_{get,put}() with atomic_{inc,dec_and_test} (Christoph)

 block/blk-core.c       |    1 +
 block/genhd.c          |   21 +++++++++++++++++++++
 drivers/scsi/sd.c      |   41 +++++++++++++++++++++++++++++++++--------
 include/linux/blkdev.h |    1 +
 include/linux/genhd.h  |    8 ++++++++
 5 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 84fabb51714a..0cd6b3c4b41c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -595,6 +595,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	spin_unlock_irq(lock);
 
 	bdi_unregister(q->backing_dev_info);
+	put_disk_devt(q->disk_devt);
 
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
diff --git a/block/genhd.c b/block/genhd.c
index d9ccd42f3675..3631cd480295 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -572,6 +572,20 @@ static void register_disk(struct device *parent, struct gendisk *disk)
 	disk_part_iter_exit(&piter);
 }
 
+void put_disk_devt(struct disk_devt *disk_devt)
+{
+	if (disk_devt && atomic_dec_and_test(&disk_devt->count))
+		disk_devt->release(disk_devt);
+}
+EXPORT_SYMBOL(put_disk_devt);
+
+void get_disk_devt(struct disk_devt *disk_devt)
+{
+	if (disk_devt)
+		atomic_inc(&disk_devt->count);
+}
+EXPORT_SYMBOL(get_disk_devt);
+
 /**
  * device_add_disk - add partitioning information to kernel list
  * @parent: parent device for the disk
@@ -612,6 +626,13 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 
 	disk_alloc_events(disk);
 
+	/*
+	 * Take a reference on the devt and assign it to queue since it
+	 * must not be reallocated while the bdi is registered
+	 */
+	disk->queue->disk_devt = disk->disk_devt;
+	get_disk_devt(disk->disk_devt);
+
 	/* Register BDI before referencing it from bdev */
 	bdi = disk->queue->backing_dev_info;
 	bdi_register_owner(bdi, disk_to_dev(disk));
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0b09638fa39b..102111e730ce 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3067,6 +3067,23 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	put_device(&sdkp->dev);
 }
 
+struct sd_devt {
+	int idx;
+	struct disk_devt disk_devt;
+};
+
+void sd_devt_release(struct disk_devt *disk_devt)
+{
+	struct sd_devt *sd_devt = container_of(disk_devt, struct sd_devt,
+			disk_devt);
+
+	spin_lock(&sd_index_lock);
+	ida_remove(&sd_index_ida, sd_devt->idx);
+	spin_unlock(&sd_index_lock);
+
+	kfree(sd_devt);
+}
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -3088,6 +3105,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 static int sd_probe(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+	struct sd_devt *sd_devt;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
 	int index;
@@ -3113,9 +3131,13 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
+	sd_devt = kzalloc(sizeof(*sd_devt), GFP_KERNEL);
+	if (!sd_devt)
+		goto out_free;
+
 	gd = alloc_disk(SD_MINORS);
 	if (!gd)
-		goto out_free;
+		goto out_free_devt;
 
 	do {
 		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
@@ -3131,6 +3153,11 @@ static int sd_probe(struct device *dev)
 		goto out_put;
 	}
 
+	atomic_set(&sd_devt->disk_devt.count, 1);
+	sd_devt->disk_devt.release = sd_devt_release;
+	sd_devt->idx = index;
+	gd->disk_devt = &sd_devt->disk_devt;
+
 	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
 	if (error) {
 		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
@@ -3170,13 +3197,14 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, index);
-	spin_unlock(&sd_index_lock);
+	put_disk_devt(&sd_devt->disk_devt);
+	sd_devt = NULL;
  out_put:
 	put_disk(gd);
  out_free:
 	kfree(sdkp);
+ out_free_devt:
+	kfree(sd_devt);
  out:
 	scsi_autopm_put_device(sdp);
 	return error;
@@ -3235,10 +3263,7 @@ static void scsi_disk_release(struct device *dev)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
 	
-	spin_lock(&sd_index_lock);
-	ida_remove(&sd_index_ida, sdkp->index);
-	spin_unlock(&sd_index_lock);
-
+	put_disk_devt(disk->disk_devt);
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3c0ff78b1219..53195a4d597a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -433,6 +433,7 @@ struct request_queue {
 	struct delayed_work	delay_work;
 
 	struct backing_dev_info	*backing_dev_info;
+	struct disk_devt	*disk_devt;
 
 	/*
 	 * The queue owner gets to use this for whatever they like.
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 76f39754e7b0..a999d281a2f1 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -167,6 +167,13 @@ struct blk_integrity {
 };
 
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
+struct disk_devt {
+	atomic_t count;
+	void (*release)(struct disk_devt *disk_devt);
+};
+
+void put_disk_devt(struct disk_devt *disk_devt);
+void get_disk_devt(struct disk_devt *disk_devt);
 
 struct gendisk {
 	/* major, first_minor and minors are input parameters only,
@@ -176,6 +183,7 @@ struct gendisk {
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
+	struct disk_devt *disk_devt;
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
 	char *(*devnode)(struct gendisk *gd, umode_t *mode);

