From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] scsi, block: fix duplicate bdi name registration crashes
Date: Sat, 28 Jan 2017 20:58:28 -0800
Message-ID: <148566590827.1627.3631056985359212959.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>, Christoph Hellwig <hch@lst.de>
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
Reported-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-core.c       |    1 +
 block/genhd.c          |    7 +++++++
 drivers/scsi/sd.c      |   41 +++++++++++++++++++++++++++++++++--------
 include/linux/blkdev.h |    1 +
 include/linux/genhd.h  |   17 +++++++++++++++++
 5 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 61ba08c58b64..950cea1e202e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -597,6 +597,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	spin_unlock_irq(lock);
 
 	bdi_unregister(&q->backing_dev_info);
+	put_disk_devt(q->disk_devt);
 
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
diff --git a/block/genhd.c b/block/genhd.c
index fcd6d4fae657..eb8009e928f5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -612,6 +612,13 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 
 	disk_alloc_events(disk);
 
+	/*
+	 * Take a reference on the devt and assign it to queue since it
+	 * must not be reallocated while the bdi is registerted
+	 */
+	disk->queue->disk_devt = disk->disk_devt;
+	get_disk_devt(disk->disk_devt);
+
 	/* Register BDI before referencing it from bdev */
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_owner(bdi, disk_to_dev(disk));
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0b09638fa39b..09405351577c 100644
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
+void sd_devt_release(struct kref *kref)
+{
+	struct sd_devt *sd_devt = container_of(kref, struct sd_devt,
+			disk_devt.kref);
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
 
+	kref_init(&sd_devt->disk_devt.kref);
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
index 1ca8e8fd1078..0432d1b44188 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -432,6 +432,7 @@ struct request_queue {
 	 */
 	struct delayed_work	delay_work;
 
+	struct disk_devt	*disk_devt;
 	struct backing_dev_info	backing_dev_info;
 
 	/*
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 76f39754e7b0..5a5efe6a0de1 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -167,6 +167,22 @@ struct blk_integrity {
 };
 
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
+struct disk_devt {
+	struct kref kref;
+	void (*release)(struct kref *);
+};
+
+static inline void put_disk_devt(struct disk_devt *disk_devt)
+{
+	if (disk_devt)
+		kref_put(&disk_devt->kref, disk_devt->release);
+}
+
+static inline void get_disk_devt(struct disk_devt *disk_devt)
+{
+	if (disk_devt)
+		kref_get(&disk_devt->kref);
+}
 
 struct gendisk {
 	/* major, first_minor and minors are input parameters only,
@@ -176,6 +192,7 @@ struct gendisk {
 	int first_minor;
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
+	struct disk_devt *disk_devt;
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
 	char *(*devnode)(struct gendisk *gd, umode_t *mode);
