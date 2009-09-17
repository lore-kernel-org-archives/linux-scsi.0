From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 20/20] cciss: Dynamically allocate the drive_info_struct for
	each logical drive.
Date: Thu, 17 Sep 2009 13:48:31 -0500
Message-ID: <20090917184831.15105.21502.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760363AbZIQSsO@vger.kernel.org>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

cciss: Dynamically allocate the drive_info_struct for each logical drive.
This reduces the size of the per-hba ctlr_info structure from 106936
bytes to 8132 bytes.  That's on 32-bit systems.  On 64-bit systems, the
improvement is even bigger.  Without this, the ctlr_info struct is so big
that the driver won't even load on a 64 bit system if CISS_MAX_LUN was
at it's current setting of 1024 logical drives.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |  293 ++++++++++++++++++++++++++++---------------------
 drivers/block/cciss.h |    5 +
 2 files changed, 168 insertions(+), 130 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f3f30c5..3c74ddf 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -200,6 +200,7 @@ static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 static void cciss_hba_release(struct device *dev);
 static void cciss_device_release(struct device *dev);
 static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
+static void cciss_free_drive_info(ctlr_info_t *h, int drv_index);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -326,7 +327,7 @@ static int cciss_seq_show(struct seq_file *seq, void *v)
 	ctlr_info_t *h = seq->private;
 	unsigned ctlr = h->ctlr;
 	loff_t *pos = v;
-	drive_info_struct *drv = &h->drv[*pos];
+	drive_info_struct *drv = h->drv[*pos];
 
 	if (*pos > h->highest_lun)
 		return 0;
@@ -460,6 +461,7 @@ static void __devinit cciss_procinit(int i)
 #define MAX_PRODUCT_NAME_LEN 19
 
 #define to_hba(n) container_of(n, struct ctlr_info, dev)
+#define to_drv(n) container_of(n, drive_info_struct, dev)
 
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
@@ -479,8 +481,8 @@ static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	__u8 sn[16];
 	unsigned long flags;
 	int ret = 0;
@@ -509,8 +511,8 @@ static ssize_t dev_show_vendor(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	char vendor[VENDOR_LEN + 1];
 	unsigned long flags;
 	int ret = 0;
@@ -533,8 +535,8 @@ static ssize_t dev_show_model(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	char model[MODEL_LEN + 1];
 	unsigned long flags;
 	int ret = 0;
@@ -557,8 +559,8 @@ static ssize_t dev_show_rev(struct device *dev,
 			    struct device_attribute *attr,
 			    char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	char rev[REV_LEN + 1];
 	unsigned long flags;
 	int ret = 0;
@@ -580,8 +582,8 @@ DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
 static ssize_t cciss_show_lunid(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	unsigned long flags;
 	unsigned char lunid[8];
 
@@ -605,8 +607,8 @@ DEVICE_ATTR(lunid, S_IRUGO, cciss_show_lunid, NULL);
 static ssize_t cciss_show_raid_level(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	int raid;
 	unsigned long flags;
 
@@ -628,8 +630,8 @@ DEVICE_ATTR(raid_level, S_IRUGO, cciss_show_raid_level, NULL);
 static ssize_t cciss_show_usage_count(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
-	drive_info_struct *drv = dev_get_drvdata(dev);
-	struct ctlr_info *h = to_hba(drv->dev->parent);
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
 	unsigned long flags;
 	int count;
 
@@ -732,11 +734,12 @@ static void cciss_destroy_hba_sysfs_entry(struct ctlr_info *h)
 }
 
 /* cciss_device_release is called when the reference count
- * of h->drv[x].dev goes to zero.
+ * of h->drv[x]dev goes to zero.
  */
 static void cciss_device_release(struct device *dev)
 {
-	kfree(dev);
+	drive_info_struct *drv = to_drv(dev);
+	kfree(drv);
 }
 
 /*
@@ -750,20 +753,16 @@ static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 {
 	struct device *dev;
 
-	/* Special case for c*d0, we only create it once. */
-	if (drv_index == 0 && h->drv[drv_index].dev != NULL)
+	if (h->drv[drv_index]->device_initialized)
 		return 0;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
-		return -ENOMEM;
+	dev = &h->drv[drv_index]->dev;
 	device_initialize(dev);
 	dev->type = &cciss_dev_type;
 	dev->bus = &cciss_bus_type;
 	dev_set_name(dev, "c%dd%d", h->ctlr, drv_index);
 	dev->parent = &h->dev;
-	h->drv[drv_index].dev = dev;
-	dev_set_drvdata(dev, &h->drv[drv_index]);
+	h->drv[drv_index]->device_initialized = 1;
 	return device_add(dev);
 }
 
@@ -773,7 +772,7 @@ static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index,
 	int ctlr_exiting)
 {
-	struct device *dev = h->drv[drv_index].dev;
+	struct device *dev = &h->drv[drv_index]->dev;
 
 	/* special case for c*d0, we only destroy it on controller exit */
 	if (drv_index == 0 && !ctlr_exiting)
@@ -781,7 +780,7 @@ static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index,
 
 	device_del(dev);
 	put_device(dev); /* the "final" put. */
-	h->drv[drv_index].dev = NULL;
+	h->drv[drv_index] = NULL;
 }
 
 /*
@@ -1624,7 +1623,10 @@ static void cciss_check_queues(ctlr_info_t *h)
 		/* make sure the disk has been added and the drive is real
 		 * because this can be called from the middle of init_one.
 		 */
-		if (!(h->drv[curr_queue].queue) || !(h->drv[curr_queue].heads))
+		if (!h->drv[curr_queue])
+			continue;
+		if (!(h->drv[curr_queue]->queue) ||
+			!(h->drv[curr_queue]->heads))
 			continue;
 		blk_start_queue(h->gendisk[curr_queue]->queue);
 
@@ -1684,8 +1686,8 @@ static void cciss_softirq_done(struct request *rq)
 static inline void log_unit_to_scsi3addr(ctlr_info_t *h,
 	unsigned char scsi3addr[], uint32_t log_unit)
 {
-	memcpy(scsi3addr, h->drv[log_unit].LunID,
-		sizeof(h->drv[log_unit].LunID));
+	memcpy(scsi3addr, h->drv[log_unit]->LunID,
+		sizeof(h->drv[log_unit]->LunID));
 }
 
 /* This function gets the SCSI vendor, model, and revision of a logical drive
@@ -1775,12 +1777,10 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->major = h->major;
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
-	if (h->drv[drv_index].dev == NULL) {
-		if (cciss_create_ld_sysfs_entry(h, drv_index))
-			goto cleanup_queue;
-	}
-	disk->private_data = &h->drv[drv_index];
-	disk->driverfs_dev = h->drv[drv_index].dev;
+	if (cciss_create_ld_sysfs_entry(h, drv_index))
+		goto cleanup_queue;
+	disk->private_data = h->drv[drv_index];
+	disk->driverfs_dev = &h->drv[drv_index]->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
@@ -1798,13 +1798,13 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->queue->queuedata = h;
 
 	blk_queue_logical_block_size(disk->queue,
-				     h->drv[drv_index].block_size);
+				     h->drv[drv_index]->block_size);
 
 	/* Make sure all queue data is written out before */
-	/* setting h->drv[drv_index].queue, as setting this */
+	/* setting h->drv[drv_index]->queue, as setting this */
 	/* allows the interrupt handler to start the queue */
 	wmb();
-	h->drv[drv_index].queue = disk->queue;
+	h->drv[drv_index]->queue = disk->queue;
 	add_disk(disk);
 	return 0;
 
@@ -1839,7 +1839,7 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 
 	/* Get information about the disk and modify the driver structure */
 	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
-	drvinfo = kmalloc(sizeof(*drvinfo), GFP_KERNEL);
+	drvinfo = kzalloc(sizeof(*drvinfo), GFP_KERNEL);
 	if (inq_buff == NULL || drvinfo == NULL)
 		goto mem_msg;
 
@@ -1875,16 +1875,19 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 				drvinfo->model, drvinfo->rev);
 	cciss_get_serial_no(ctlr, drv_index, 1, drvinfo->serial_no,
 			sizeof(drvinfo->serial_no));
+	/* Save the lunid in case we deregister the disk, below. */
+	memcpy(drvinfo->LunID, h->drv[drv_index]->LunID,
+		sizeof(drvinfo->LunID));
 
 	/* Is it the same disk we already know, and nothing's changed? */
-	if (h->drv[drv_index].raid_level != -1 &&
+	if (h->drv[drv_index]->raid_level != -1 &&
 		((memcmp(drvinfo->serial_no,
-				h->drv[drv_index].serial_no, 16) == 0) &&
-		drvinfo->block_size == h->drv[drv_index].block_size &&
-		drvinfo->nr_blocks == h->drv[drv_index].nr_blocks &&
-		drvinfo->heads == h->drv[drv_index].heads &&
-		drvinfo->sectors == h->drv[drv_index].sectors &&
-		drvinfo->cylinders == h->drv[drv_index].cylinders))
+				h->drv[drv_index]->serial_no, 16) == 0) &&
+		drvinfo->block_size == h->drv[drv_index]->block_size &&
+		drvinfo->nr_blocks == h->drv[drv_index]->nr_blocks &&
+		drvinfo->heads == h->drv[drv_index]->heads &&
+		drvinfo->sectors == h->drv[drv_index]->sectors &&
+		drvinfo->cylinders == h->drv[drv_index]->cylinders))
 			/* The disk is unchanged, nothing to update */
 			goto freeret;
 
@@ -1894,18 +1897,17 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 	 * If the disk already exists then deregister it before proceeding
 	 * (unless it's the first disk (for the controller node).
 	 */
-	if (h->drv[drv_index].raid_level != -1 && drv_index != 0) {
+	if (h->drv[drv_index]->raid_level != -1 && drv_index != 0) {
 		printk(KERN_WARNING "disk %d has changed.\n", drv_index);
 		spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
-		h->drv[drv_index].busy_configuring = 1;
+		h->drv[drv_index]->busy_configuring = 1;
 		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
-		/* deregister_disk sets h->drv[drv_index].queue = NULL
+		/* deregister_disk sets h->drv[drv_index]->queue = NULL
 		 * which keeps the interrupt handler from starting
 		 * the queue.
 		 */
 		ret = deregister_disk(h, drv_index, 0, via_ioctl);
-		h->drv[drv_index].busy_configuring = 0;
 	}
 
 	/* If the disk is in use return */
@@ -1913,22 +1915,31 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 		goto freeret;
 
 	/* Save the new information from cciss_geometry_inquiry
-	 * and serial number inquiry.
+	 * and serial number inquiry.  If the disk was deregistered
+	 * above, then h->drv[drv_index] will be NULL.
 	 */
-	h->drv[drv_index].block_size = drvinfo->block_size;
-	h->drv[drv_index].nr_blocks = drvinfo->nr_blocks;
-	h->drv[drv_index].heads = drvinfo->heads;
-	h->drv[drv_index].sectors = drvinfo->sectors;
-	h->drv[drv_index].cylinders = drvinfo->cylinders;
-	h->drv[drv_index].raid_level = drvinfo->raid_level;
-	memcpy(h->drv[drv_index].serial_no, drvinfo->serial_no, 16);
-	memcpy(h->drv[drv_index].vendor, drvinfo->vendor, VENDOR_LEN + 1);
-	memcpy(h->drv[drv_index].model, drvinfo->model, MODEL_LEN + 1);
-	memcpy(h->drv[drv_index].rev, drvinfo->rev, REV_LEN + 1);
+	if (h->drv[drv_index] == NULL) {
+		drvinfo->device_initialized = 0;
+		h->drv[drv_index] = drvinfo;
+		drvinfo = NULL; /* so it won't be freed below. */
+	} else {
+		/* special case for cxd0 */
+		h->drv[drv_index]->block_size = drvinfo->block_size;
+		h->drv[drv_index]->nr_blocks = drvinfo->nr_blocks;
+		h->drv[drv_index]->heads = drvinfo->heads;
+		h->drv[drv_index]->sectors = drvinfo->sectors;
+		h->drv[drv_index]->cylinders = drvinfo->cylinders;
+		h->drv[drv_index]->raid_level = drvinfo->raid_level;
+		memcpy(h->drv[drv_index]->serial_no, drvinfo->serial_no, 16);
+		memcpy(h->drv[drv_index]->vendor, drvinfo->vendor,
+			VENDOR_LEN + 1);
+		memcpy(h->drv[drv_index]->model, drvinfo->model, MODEL_LEN + 1);
+		memcpy(h->drv[drv_index]->rev, drvinfo->rev, REV_LEN + 1);
+	}
 
 	++h->num_luns;
 	disk = h->gendisk[drv_index];
-	set_capacity(disk, h->drv[drv_index].nr_blocks);
+	set_capacity(disk, h->drv[drv_index]->nr_blocks);
 
 	/* If it's not disk 0 (drv_index != 0)
 	 * or if it was disk 0, but there was previously
@@ -1939,6 +1950,7 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 	if (drv_index || first_time) {
 		if (cciss_add_disk(h, disk, drv_index) != 0) {
 			cciss_free_gendisk(h, drv_index);
+			cciss_free_drive_info(h, drv_index);
 			printk(KERN_WARNING "cciss:%d could not update "
 				"disk %d\n", h->ctlr, drv_index);
 			--h->num_luns;
@@ -1955,28 +1967,64 @@ mem_msg:
 }
 
 /* This function will find the first index of the controllers drive array
- * that has a -1 for the raid_level and will return that index.  This is
- * where new drives will be added.  If the index to be returned is greater
- * than the highest_lun index for the controller then highest_lun is set
- * to this new index.  If there are no available indexes then -1 is returned.
- * "controller_node" is used to know if this is a real logical drive, or just
- * the controller node, which determines if this counts towards highest_lun.
+ * that has a null drv pointer and allocate the drive info struct and
+ * will return that index   This is where new drives will be added.
+ * If the index to be returned is greater than the highest_lun index for
+ * the controller then highest_lun is set * to this new index.
+ * If there are no available indexes or if tha allocation fails, then -1
+ * is returned.  * "controller_node" is used to know if this is a real
+ * logical drive, or just the controller node, which determines if this
+ * counts towards highest_lun.
  */
-static int cciss_find_free_drive_index(int ctlr, int controller_node)
+static int cciss_alloc_drive_info(ctlr_info_t *h, int controller_node)
 {
 	int i;
+	drive_info_struct *drv;
 
+	/* Search for an empty slot for our drive info */
 	for (i = 0; i < CISS_MAX_LUN; i++) {
-		if (hba[ctlr]->drv[i].raid_level == -1) {
-			if (i > hba[ctlr]->highest_lun)
-				if (!controller_node)
-					hba[ctlr]->highest_lun = i;
+
+		/* if not cxd0 case, and it's occupied, skip it. */
+		if (h->drv[i] && i != 0)
+			continue;
+		/*
+		 * If it's cxd0 case, and drv is alloc'ed already, and a
+		 * disk is configured there, skip it.
+		 */
+		if (i == 0 && h->drv[i] && h->drv[i]->raid_level != -1)
+			continue;
+
+		/*
+		 * We've found an empty slot.  Update highest_lun
+		 * provided this isn't just the fake cxd0 controller node.
+		 */
+		if (i > h->highest_lun && !controller_node)
+			h->highest_lun = i;
+
+		/* If adding a real disk at cxd0, and it's already alloc'ed */
+		if (i == 0 && h->drv[i] != NULL)
 			return i;
-		}
+
+		/*
+		 * Found an empty slot, not already alloc'ed.  Allocate it.
+		 * Mark it with raid_level == -1, so we know it's new later on.
+		 */
+		drv = kzalloc(sizeof(*drv), GFP_KERNEL);
+		if (!drv)
+			return -1;
+		drv->raid_level = -1; /* so we know it's new */
+		h->drv[i] = drv;
+		return i;
 	}
 	return -1;
 }
 
+static void cciss_free_drive_info(ctlr_info_t *h, int drv_index)
+{
+	kfree(h->drv[drv_index]);
+	h->drv[drv_index] = NULL;
+}
+
 static void cciss_free_gendisk(ctlr_info_t *h, int drv_index)
 {
 	put_disk(h->gendisk[drv_index]);
@@ -1997,7 +2045,7 @@ static int cciss_add_gendisk(ctlr_info_t *h, unsigned char lunid[],
 {
 	int drv_index;
 
-	drv_index = cciss_find_free_drive_index(h->ctlr, controller_node);
+	drv_index = cciss_alloc_drive_info(h, controller_node);
 	if (drv_index == -1)
 		return -1;
 
@@ -2009,24 +2057,24 @@ static int cciss_add_gendisk(ctlr_info_t *h, unsigned char lunid[],
 			printk(KERN_ERR "cciss%d: could not "
 				"allocate a new disk %d\n",
 				h->ctlr, drv_index);
-			return -1;
+			goto err_free_drive_info;
 		}
 	}
-	memcpy(h->drv[drv_index].LunID, lunid,
-		sizeof(h->drv[drv_index].LunID));
-	if (h->drv[drv_index].dev == NULL) {
-		if (cciss_create_ld_sysfs_entry(h, drv_index))
-			goto err_free_disk;
-	}
+	memcpy(h->drv[drv_index]->LunID, lunid,
+		sizeof(h->drv[drv_index]->LunID));
+	if (cciss_create_ld_sysfs_entry(h, drv_index))
+		goto err_free_disk;
 	/* Don't need to mark this busy because nobody */
 	/* else knows about this disk yet to contend */
 	/* for access to it. */
-	h->drv[drv_index].busy_configuring = 0;
+	h->drv[drv_index]->busy_configuring = 0;
 	wmb();
 	return drv_index;
 
 err_free_disk:
 	cciss_free_gendisk(h, drv_index);
+err_free_drive_info:
+	cciss_free_drive_info(h, drv_index);
 	return -1;
 }
 
@@ -2046,17 +2094,18 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 	drv_index = cciss_add_gendisk(h, CTLR_LUNID, 1);
 	if (drv_index == -1)
 		goto error;
-	h->drv[drv_index].block_size = 512;
-	h->drv[drv_index].nr_blocks = 0;
-	h->drv[drv_index].heads = 0;
-	h->drv[drv_index].sectors = 0;
-	h->drv[drv_index].cylinders = 0;
-	h->drv[drv_index].raid_level = -1;
-	memset(h->drv[drv_index].serial_no, 0, 16);
+	h->drv[drv_index]->block_size = 512;
+	h->drv[drv_index]->nr_blocks = 0;
+	h->drv[drv_index]->heads = 0;
+	h->drv[drv_index]->sectors = 0;
+	h->drv[drv_index]->cylinders = 0;
+	h->drv[drv_index]->raid_level = -1;
+	memset(h->drv[drv_index]->serial_no, 0, 16);
 	disk = h->gendisk[drv_index];
 	if (cciss_add_disk(h, disk, drv_index) == 0)
 		return;
 	cciss_free_gendisk(h, drv_index);
+	cciss_free_drive_info(h, drv_index);
 error:
 	printk(KERN_WARNING "cciss%d: could not "
 		"add disk 0.\n", h->ctlr);
@@ -2135,12 +2184,12 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 		drv_found = 0;
 
 		/* skip holes in the array from already deleted drives */
-		if (h->drv[i].raid_level == -1)
+		if (h->drv[i] == NULL)
 			continue;
 
 		for (j = 0; j < num_luns; j++) {
 			memcpy(lunid, &ld_buff->LUN[j][0], sizeof(lunid));
-			if (memcmp(h->drv[i].LunID, lunid,
+			if (memcmp(h->drv[i]->LunID, lunid,
 				sizeof(lunid)) == 0) {
 				drv_found = 1;
 				break;
@@ -2149,10 +2198,11 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 		if (!drv_found) {
 			/* Deregister it from the OS, it's gone. */
 			spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
-			h->drv[i].busy_configuring = 1;
+			h->drv[i]->busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 			return_code = deregister_disk(h, i, 1, via_ioctl);
-			h->drv[i].busy_configuring = 0;
+			if (h->drv[i] != NULL)
+				h->drv[i]->busy_configuring = 0;
 		}
 	}
 
@@ -2173,9 +2223,9 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 		 * the first free index and add it.
 		 */
 		for (j = 0; j <= h->highest_lun; j++) {
-			if (h->drv[j].raid_level != -1 &&
-				memcmp(h->drv[j].LunID, lunid,
-					sizeof(h->drv[j].LunID)) == 0) {
+			if (h->drv[j] != NULL &&
+				memcmp(h->drv[j]->LunID, lunid,
+					sizeof(h->drv[j]->LunID)) == 0) {
 				drv_index = j;
 				drv_found = 1;
 				break;
@@ -2252,11 +2302,12 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	int i;
 	struct gendisk *disk;
 	drive_info_struct *drv;
+	int recalculate_highest_lun;
 
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-	drv = &h->drv[drv_index];
+	drv = h->drv[drv_index];
 	disk = h->gendisk[drv_index];
 
 	/* make sure logical volume is NOT is use */
@@ -2266,6 +2317,8 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	} else if (drv->usage_count > 0)
 		return -EBUSY;
 
+	recalculate_highest_lun = (drv == h->drv[h->highest_lun]);
+
 	/* invalidate the devices and deregister the disk.  If it is disk
 	 * zero do not deregister it but just zero out it's values.  This
 	 * allows us to delete disk zero but keep the controller registered.
@@ -2276,14 +2329,8 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 			cciss_destroy_ld_sysfs_entry(h, drv_index, 0);
 			del_gendisk(disk);
 		}
-		if (q) {
+		if (q)
 			blk_cleanup_queue(q);
-			/* Set drv->queue to NULL so that we do not try
-			 * to call blk_start_queue on this queue in the
-			 * interrupt handler
-			 */
-			drv->queue = NULL;
-		}
 		/* If clear_all is set then we are deleting the logical
 		 * drive, not just refreshing its info.  For drives
 		 * other than disk 0 we will call put_disk.  We do not
@@ -2306,24 +2353,20 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 		}
 	} else {
 		set_capacity(disk, 0);
+		cciss_clear_drive_info(drv);
 	}
 
 	--h->num_luns;
-	cciss_clear_drive_info(drv);
-
-	if (clear_all) {
-		/* check to see if it was the last disk */
-		if (drv == h->drv + h->highest_lun) {
-			/* if so, find the new hightest lun */
-			int i, newhighest = -1;
-			for (i = 0; i <= h->highest_lun; i++) {
-				/* if the disk has size > 0, it is available */
-				if (h->drv[i].heads)
-					newhighest = i;
-			}
-			h->highest_lun = newhighest;
+
+	/* if it was the last disk, find the new hightest lun */
+	if (clear_all && recalculate_highest_lun) {
+		int i, newhighest = -1;
+		for (i = 0; i <= h->highest_lun; i++) {
+			/* if the disk has size > 0, it is available */
+			if (h->drv[i] && h->drv[i]->heads)
+				newhighest = i;
 		}
-		memset(drv->LunID, 0, sizeof(drv->LunID));
+		h->highest_lun = newhighest;
 	}
 	return 0;
 }
@@ -2754,7 +2797,7 @@ static int cciss_revalidate(struct gendisk *disk)
 	InquiryData_struct *inq_buff = NULL;
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
-		if (memcmp(h->drv[logvol].LunID, drv->LunID,
+		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
 			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;
 			break;
@@ -4292,8 +4335,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	hba[i]->num_luns = 0;
 	hba[i]->highest_lun = -1;
 	for (j = 0; j < CISS_MAX_LUN; j++) {
-		hba[i]->drv[j].raid_level = -1;
-		hba[i]->drv[j].queue = NULL;
+		hba[i]->drv[j] = NULL;
 		hba[i]->gendisk[j] = NULL;
 	}
 
@@ -4348,12 +4390,7 @@ clean1:
 	cciss_destroy_hba_sysfs_entry(hba[i]);
 clean0:
 	hba[i]->busy_initializing = 0;
-	/* cleanup any queues that may have been initialized */
-	for (j=0; j <= hba[i]->highest_lun; j++){
-		drive_info_struct *drv = &(hba[i]->drv[j]);
-		if (drv->queue)
-			blk_cleanup_queue(drv->queue);
-	}
+
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 5188f71..31524cf 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -45,13 +45,14 @@ typedef struct _drive_info_struct
 				   * to prevent it from being opened or it's
 				   * queue from being started.
 				   */
-	struct	device *dev;
+	struct	device dev;
 	__u8 serial_no[16]; /* from inquiry page 0x83,
 			     * not necc. null terminated.
 			     */
 	char vendor[VENDOR_LEN + 1]; /* SCSI vendor string */
 	char model[MODEL_LEN + 1];   /* SCSI model string */
 	char rev[REV_LEN + 1];       /* SCSI revision string */
+	char device_initialized;     /* indicates whether dev is initialized */
 } drive_info_struct;
 
 struct ctlr_info 
@@ -87,7 +88,7 @@ struct ctlr_info
 	BYTE	cciss_read_capacity;
 
 	// information about each logical volume
-	drive_info_struct drv[CISS_MAX_LUN];
+	drive_info_struct *drv[CISS_MAX_LUN];
 
 	struct access_method access;
 
