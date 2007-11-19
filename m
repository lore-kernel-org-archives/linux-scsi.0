From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/3] cciss: export more sysfs attributes
Date: Mon, 19 Nov 2007 16:03:07 -0600
Message-ID: <20071119220307.GA4660@roadking.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:42283 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbXKSWDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 17:03:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 1 of 3
This patch creates more sysfs attributes to be exported by cciss. Hopefully
we can work better with udev. Please consider this patch for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7d70496..2ba5a89 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -229,20 +229,483 @@ static inline CommandList_struct *removeQ(CommandList_struct **Qptr,
 	return c;
 }
 
+static inline int find_drv_index(int ctlr, drive_info_struct *drv){
+        int i;
+        for (i=0; i < CISS_MAX_LUN; i++) {
+                if (hba[ctlr]->drv[i].LunID == drv->LunID)
+                        return i;
+        }
+        return i;
+}
+
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
+#define ENG_GIG 1000000000
+#define ENG_GIG_FACTOR (ENG_GIG/512)
 #define RAID_UNKNOWN 6
+static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
+	"UNKNOWN"};
+
+
+static spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
+
+static void cciss_sysfs_stat_inquiry(int ctlr, int logvol,
+			int withirq, drive_info_struct *drv)
+{
+	int return_code;
+	InquiryData_struct *inq_buff;
+
+	/* If there are no heads then this is the controller disk and
+	 * not a valid logical drive so don't query it.
+	 */
+	if (!drv->heads)
+		return;
+
+	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+	if (!inq_buff) {
+		printk(KERN_ERR "cciss: out of memory\n");
+		goto err;
+	}
+
+	if (withirq)
+		return_code = sendcmd_withirq(CISS_INQUIRY, ctlr,
+			inq_buff, sizeof(*inq_buff), 1, logvol ,0, TYPE_CMD);
+	else
+		return_code = sendcmd(CISS_INQUIRY, ctlr, inq_buff,
+			sizeof(*inq_buff), 1, logvol , 0, NULL, TYPE_CMD);
+	if (return_code == IO_OK) {
+		memcpy(drv->vendor, &inq_buff->data_byte[8], 8);
+		drv->vendor[8]='\0';
+		memcpy(drv->model, &inq_buff->data_byte[16], 16);
+		drv->model[16] = '\0';
+		memcpy(drv->rev, &inq_buff->data_byte[32], 4);
+		drv->rev[4] = '\0';
+	} else { /* Get geometry failed */
+		printk(KERN_WARNING "cciss: inquiry for VPD page 0 failed\n");
+	}
+
+	if (withirq)
+		return_code = sendcmd_withirq(CISS_INQUIRY, ctlr,
+			inq_buff, sizeof(*inq_buff), 1, logvol ,0x83, TYPE_CMD);
+	else
+		return_code = sendcmd(CISS_INQUIRY, ctlr, inq_buff,
+			sizeof(*inq_buff), 1, logvol , 0x83, NULL, TYPE_CMD);
+
+	if (return_code == IO_OK) {
+		memcpy(drv->uid, &inq_buff->data_byte[8], 16);
+	} else { /* Get geometry failed */
+		printk(KERN_WARNING "cciss: id logical drive failed\n");
+	}
+
+	kfree(inq_buff);
+err:
+	drv->vendor[8] = '\0';
+	drv->model[16] = '\0';
+	drv->rev[4] = '\0';
+
+}
+
+static ssize_t cciss_show_raid_level(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	int raid;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 30, "Device busy configuring\n");
+	}
+
+	drv = d->disk->private_data;
+	if ((drv->raid_level < 0) || (drv->raid_level) > 5)
+		raid = RAID_UNKNOWN;
+	else
+		raid = drv->raid_level;
+
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return snprintf(buf, 20, "RAID %s\n", raid_label[raid]);
+}
+
+static ssize_t cciss_show_disk_size(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	sector_t vol_sz, vol_sz_frac;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 30, "Device busy configuring\n");
+	}
+
+	drv = d->disk->private_data;
+	vol_sz = drv->nr_blocks;
+	vol_sz_frac = sector_div(vol_sz, ENG_GIG_FACTOR);
+	vol_sz_frac *= 100;
+	sector_div(vol_sz_frac, ENG_GIG_FACTOR);
+
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return snprintf(buf, 30, "%4u.%02uGB\n", (int)vol_sz, (int)vol_sz_frac);
+}
+
+static ssize_t cciss_show_usage_count(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	int count;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+	drv = d->disk->private_data;
+	count = drv->usage_count;
+	spin_unlock(&sysfs_lock);
+	return snprintf(buf, 20, "%d\n", count);
+}
+
+static ssize_t cciss_show_vendor(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	int drv_index;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -EBUSY;
+	}
+
+	drv = d->disk->private_data;
+
+	if (!drv->heads) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -ENOTTY;
+	}
+
+	drv_index = find_drv_index(h->ctlr, drv);
+	if (drv_index != CISS_MAX_LUN) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 20, "%s\n", (char *)drv->vendor);
+	}
+
+	printk(KERN_ERR "cciss: logical drive not found\n");
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return -ENOTTY;
+}
+
+static ssize_t cciss_show_model(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	int drv_index;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -EBUSY;
+	}
+
+	drv = d->disk->private_data;
+
+	if (!drv->heads) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -ENOTTY;
+	}
+
+	drv_index = find_drv_index(h->ctlr, drv);
+	if (drv_index != CISS_MAX_LUN) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 20, "%s\n", (char *)drv->model);
+	}
+	printk(KERN_ERR "cciss: logical drive not found\n");
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return -ENOTTY;
+}
+
+static ssize_t cciss_show_rev(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	int drv_index;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -EBUSY;
+	}
+
+	drv = d->disk->private_data;
+
+	if (!drv->heads) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -ENOTTY;
+	}
+
+	drv_index = find_drv_index(h->ctlr, drv);
+	if (drv_index != CISS_MAX_LUN) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 20, "%s\n", (char *)drv->rev);
+	}
+
+	printk(KERN_ERR "cciss: logical drive not found\n");
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return -ENOTTY;
+}
+
+static ssize_t cciss_show_unique_id(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	int drv_index;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 30, "Device busy configuring\n");
+	}
+	drv = d->disk->private_data;
+
+	if (!drv->heads) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -ENOTTY;
+	}
+
+	drv_index = find_drv_index(h->ctlr, drv);
+	if (drv_index != CISS_MAX_LUN) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+
+		return snprintf(buf, 40, "%02X%02X%02X%02X%02X%02X%02X%02X"
+					 "%02X%02X%02X%02X%02X%02X%02X%02X\n",
+				  drv->uid[0], drv->uid[1], drv->uid[2],
+				  drv->uid[3], drv->uid[4], drv->uid[5],
+				  drv->uid[6], drv->uid[7], drv->uid[8],
+				  drv->uid[9], drv->uid[10], drv->uid[11],
+				  drv->uid[12], drv->uid[13], drv->uid[14],
+				  drv->uid[15]);
+	}
+
+	printk(KERN_ERR "cciss: logical drive not found\n");
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return -ENOENT;
+}
+
+static ssize_t cciss_show_bus(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, 20, "cciss\n");
+}
+
+static ssize_t cciss_show_lunid(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct drv_dynamic *d;
+	drive_info_struct *drv;
+	ctlr_info_t *h;
+	unsigned long flags;
+	int drv_index;
+
+	d = container_of(dev, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	if (!d->disk) {
+		spin_unlock(&sysfs_lock);
+		return -ENOENT;
+	}
+
+	h = get_host(d->disk);
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -EBUSY;
+	}
+
+	drv = d->disk->private_data;
+
+	if (!drv->heads) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return -ENOTTY;
+	}
+
+	drv_index = find_drv_index(h->ctlr, drv);
+	if (drv_index != CISS_MAX_LUN) {
+		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock(&sysfs_lock);
+		return snprintf(buf, 20, "%d\n", drv->LunID);
+	}
+
+	printk(KERN_ERR "cciss: logical drive not found\n");
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock(&sysfs_lock);
+	return -ENOTTY;
+}
+
+DEVICE_ATTR(raid_level, S_IRUGO | S_IWUSR, cciss_show_raid_level, NULL);
+DEVICE_ATTR(disk_size, S_IRUGO | S_IWUSR, cciss_show_disk_size, NULL);
+DEVICE_ATTR(usage_count, S_IRUGO | S_IWUSR, cciss_show_usage_count, NULL);
+DEVICE_ATTR(vendor, S_IRUGO | S_IWUSR, cciss_show_vendor, NULL);
+DEVICE_ATTR(model, S_IRUGO | S_IWUSR, cciss_show_model, NULL);
+DEVICE_ATTR(rev, S_IRUGO | S_IWUSR, cciss_show_rev, NULL);
+DEVICE_ATTR(unique_id, S_IRUGO | S_IWUSR, cciss_show_unique_id, NULL);
+DEVICE_ATTR(bus, S_IRUGO | S_IWUSR, cciss_show_bus, NULL);
+DEVICE_ATTR(lunid, S_IRUGO | S_IWUSR, cciss_show_lunid, NULL);
+
+static struct attribute *cciss_sysfs_attrs[] = {
+	&dev_attr_raid_level.attr,
+	&dev_attr_disk_size.attr,
+	&dev_attr_usage_count.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_model.attr,
+	&dev_attr_rev.attr,
+	&dev_attr_unique_id.attr,
+	&dev_attr_bus.attr,
+	&dev_attr_lunid.attr,
+	NULL
+ };
+
+static struct attribute_group cciss_attrs = {.attrs = cciss_sysfs_attrs};
+
+static void cciss_add_blk_sysfs_dev(drive_info_struct *drv,
+				    struct gendisk* disk,
+				    struct pci_dev *pdev, int disk_num)
+{
+	struct drv_dynamic *d = kmalloc(sizeof(struct drv_dynamic), GFP_KERNEL);
+	if (!d)
+		return;
+	memset(d, 0, sizeof(struct drv_dynamic));
+	disk->driverfs_dev = &d->dev;
+	d->dev.parent = &pdev->dev;
+	d->dev.release = (void (*)(struct device *))kfree;
+	sprintf(d->dev.bus_id, "disk%d", disk_num);
+	d->dev.driver_data = "cciss";
+	if (device_register(&d->dev)) {
+		put_device(&d->dev);
+		return;
+	}
+	sysfs_create_group(&d->dev.kobj, &cciss_attrs);
+	d->disk = disk;
+	drv->dev_info = &d->dev;
+}
+
+static void cciss_remove_blk_sysfs_dev(struct gendisk *disk)
+{
+	drive_info_struct *drv = get_drv(disk);
+	struct drv_dynamic *d;
+
+	if (!drv->dev_info)
+		return;
+
+	d = container_of(drv->dev_info, struct drv_dynamic, dev);
+	spin_lock(&sysfs_lock);
+	sysfs_remove_group(&d->dev.kobj, &cciss_attrs);
+	d->disk = NULL;
+	spin_unlock(&sysfs_lock);
+	device_unregister(drv->dev_info);
+	drv->dev_info = NULL;
+}
 
 #ifdef CONFIG_PROC_FS
 
 /*
  * Report information about this controller.
  */
-#define ENG_GIG 1000000000
-#define ENG_GIG_FACTOR (ENG_GIG/512)
-static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
-	"UNKNOWN"
-};
 
 static struct proc_dir_entry *proc_cciss;
 
@@ -1378,6 +1841,10 @@ geo_inq:
 					hba[ctlr]->drv[drv_index].block_size);
 
 		h->drv[drv_index].queue = disk->queue;
+		cciss_sysfs_stat_inquiry(ctlr, drv_index, 1,
+						&h->drv[drv_index]);
+		cciss_add_blk_sysfs_dev(&h->drv[drv_index], disk,
+						h->pdev, drv_index);
 		add_disk(disk);
 	}
 
@@ -1583,8 +2050,10 @@ static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
 	 */
 	if (h->gendisk[0] != disk) {
 		struct request_queue *q = disk->queue;
-		if (disk->flags & GENHD_FL_UP)
+		if (disk->flags & GENHD_FL_UP) {
+			cciss_remove_blk_sysfs_dev(disk);
 			del_gendisk(disk);
+		}
 		if (q) {
 			blk_cleanup_queue(q);
 			/* Set drv->queue to NULL so that we do not try
@@ -3478,6 +3947,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		if (!drv->heads && j)
 			continue;
 		blk_queue_hardsect_size(q, drv->block_size);
+		cciss_sysfs_stat_inquiry(i, j, 1, drv);
+		cciss_add_blk_sysfs_dev(drv, disk, pdev, j);
 		set_capacity(disk, drv->nr_blocks);
 		add_disk(disk);
 		j++;
@@ -3574,8 +4045,10 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		if (disk) {
 			struct request_queue *q = disk->queue;
 
-			if (disk->flags & GENHD_FL_UP)
+			if (disk->flags & GENHD_FL_UP) {
+				cciss_remove_blk_sysfs_dev(disk);
 				del_gendisk(disk);
+			}
 			if (q)
 				blk_cleanup_queue(q);
 		}
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index b70988d..d80b3e8 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -39,6 +39,11 @@ typedef struct _drive_info_struct
 				   *to prevent it from being opened or it's queue
 				   *from being started.
 				  */
+        char    vendor[9];
+        char    model[17];
+        char    rev[5];
+        BYTE    uid[16];
+	struct device *dev_info;
 } drive_info_struct;
 
 #ifdef CONFIG_CISS_SCSI_TAPE
@@ -146,6 +151,17 @@ struct ctlr_info
 
 #define CCISS_INTR_ON 	1 
 #define CCISS_INTR_OFF	0
+
+static inline ctlr_info_t *get_host(struct gendisk *disk)
+{
+	return disk->queue->queuedata;
+}
+
+static inline drive_info_struct *get_drv(struct gendisk *disk)
+{
+	return disk->private_data;
+}
+
 /* 
 	Send the command to the hardware 
 */
@@ -286,6 +302,11 @@ struct board_type {
 	int nr_cmds; /* Max cmds this kind of ctlr can handle. */
 };
 
+struct drv_dynamic {
+	struct device dev;      /* should be the first member */
+	struct gendisk *disk;
+};
+
 #define CCISS_LOCK(i)	(&hba[i]->lock)
 
 #endif /* CCISS_H */
