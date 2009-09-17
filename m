From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/20] cciss: Dynamically allocate struct device for each
	logical drive as needed.
Date: Thu, 17 Sep 2009 13:47:14 -0500
Message-ID: <20090917184713.15105.84721.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30025 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607AbZIQSqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 14:46:45 -0400
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

Dynamically allocate struct device for each logical drive as needed
instead of allocating the maximum we would ever need at driver init time.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   98 ++++++++++++++++++++++++++++++++++++-------------
 drivers/block/cciss.h |    2 +
 2 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1d2d614..4f9ef49 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -197,6 +197,8 @@ static void fail_all_cmds(unsigned long ctlr);
 static int add_to_scan_list(struct ctlr_info *h);
 static int scan_thread(void *data);
 static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
+static void cciss_hba_release(struct device *dev);
+static void cciss_device_release(struct device *dev);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -458,7 +460,6 @@ static void __devinit cciss_procinit(int i)
 #define MAX_PRODUCT_NAME_LEN 19
 
 #define to_hba(n) container_of(n, struct ctlr_info, dev)
-#define to_drv(n) container_of(n, drive_info_struct, dev)
 
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
@@ -478,8 +479,8 @@ static ssize_t dev_show_unique_id(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
-	drive_info_struct *drv = to_drv(dev);
-	struct ctlr_info *h = to_hba(drv->dev.parent);
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
 	__u8 sn[16];
 	unsigned long flags;
 	int ret = 0;
@@ -508,8 +509,8 @@ static ssize_t dev_show_vendor(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	drive_info_struct *drv = to_drv(dev);
-	struct ctlr_info *h = to_hba(drv->dev.parent);
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
 	char vendor[VENDOR_LEN + 1];
 	unsigned long flags;
 	int ret = 0;
@@ -532,8 +533,8 @@ static ssize_t dev_show_model(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	drive_info_struct *drv = to_drv(dev);
-	struct ctlr_info *h = to_hba(drv->dev.parent);
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
 	char model[MODEL_LEN + 1];
 	unsigned long flags;
 	int ret = 0;
@@ -556,8 +557,8 @@ static ssize_t dev_show_rev(struct device *dev,
 			    struct device_attribute *attr,
 			    char *buf)
 {
-	drive_info_struct *drv = to_drv(dev);
-	struct ctlr_info *h = to_hba(drv->dev.parent);
+	drive_info_struct *drv = dev_get_drvdata(dev);
+	struct ctlr_info *h = to_hba(drv->dev->parent);
 	char rev[REV_LEN + 1];
 	unsigned long flags;
 	int ret = 0;
@@ -593,6 +594,7 @@ static struct attribute_group *cciss_host_attr_groups[] = {
 static struct device_type cciss_host_type = {
 	.name		= "cciss_host",
 	.groups		= cciss_host_attr_groups,
+	.release	= cciss_hba_release,
 };
 
 static struct attribute *cciss_dev_attrs[] = {
@@ -615,12 +617,24 @@ static struct attribute_group *cciss_dev_attr_groups[] = {
 static struct device_type cciss_dev_type = {
 	.name		= "cciss_device",
 	.groups		= cciss_dev_attr_groups,
+	.release	= cciss_device_release,
 };
 
 static struct bus_type cciss_bus_type = {
 	.name		= "cciss",
 };
 
+/*
+ * cciss_hba_release is called when the reference count
+ * of h->dev goes to zero.
+ */
+static void cciss_hba_release(struct device *dev)
+{
+	/*
+	 * nothing to do, but need this to avoid a warning
+	 * about not having a release handler from lib/kref.c.
+	 */
+}
 
 /*
  * Initialize sysfs entry for each controller.  This sets up and registers
@@ -644,6 +658,15 @@ static int cciss_create_hba_sysfs_entry(struct ctlr_info *h)
 static void cciss_destroy_hba_sysfs_entry(struct ctlr_info *h)
 {
 	device_del(&h->dev);
+	put_device(&h->dev); /* final put. */
+}
+
+/* cciss_device_release is called when the reference count
+ * of h->drv[x].dev goes to zero.
+ */
+static void cciss_device_release(struct device *dev)
+{
+	kfree(dev);
 }
 
 /*
@@ -652,24 +675,33 @@ static void cciss_destroy_hba_sysfs_entry(struct ctlr_info *h)
  * /sys/bus/pci/devices/<dev/ccis#/. We also create a link from
  * /sys/block/cciss!c#d# to this entry.
  */
-static int cciss_create_ld_sysfs_entry(struct ctlr_info *h,
-				       drive_info_struct *drv,
+static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 				       int drv_index)
 {
-	device_initialize(&drv->dev);
-	drv->dev.type = &cciss_dev_type;
-	drv->dev.bus = &cciss_bus_type;
-	dev_set_name(&drv->dev, "c%dd%d", h->ctlr, drv_index);
-	drv->dev.parent = &h->dev;
-	return device_add(&drv->dev);
+	struct device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	device_initialize(dev);
+	dev->type = &cciss_dev_type;
+	dev->bus = &cciss_bus_type;
+	dev_set_name(dev, "c%dd%d", h->ctlr, drv_index);
+	dev->parent = &h->dev;
+	h->drv[drv_index].dev = dev;
+	dev_set_drvdata(dev, &h->drv[drv_index]);
+	return device_add(dev);
 }
 
 /*
  * Remove sysfs entries for a logical drive.
  */
-static void cciss_destroy_ld_sysfs_entry(drive_info_struct *drv)
+static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index)
 {
-	device_del(&drv->dev);
+	struct device *dev = h->drv[drv_index].dev;
+	device_del(dev);
+	put_device(dev); /* the "final" put. */
+	h->drv[drv_index].dev = NULL;
 }
 
 /*
@@ -1650,7 +1682,10 @@ static void cciss_get_serial_no(int ctlr, int logvol, int withirq,
 	return;
 }
 
-static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
+/*
+ * cciss_add_disk sets up the block device queue for a logical drive
+ */
+static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
 	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
@@ -1658,8 +1693,12 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->major = h->major;
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
+	if (h->drv[drv_index].dev == NULL) {
+		if (cciss_create_ld_sysfs_entry(h, drv_index))
+			goto cleanup_queue;
+	}
 	disk->private_data = &h->drv[drv_index];
-	disk->driverfs_dev = &h->drv[drv_index].dev;
+	disk->driverfs_dev = h->drv[drv_index].dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
@@ -1685,6 +1724,12 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	wmb();
 	h->drv[drv_index].queue = disk->queue;
 	add_disk(disk);
+	return 0;
+
+cleanup_queue:
+	blk_cleanup_queue(disk->queue);
+	disk->queue = NULL;
+	return -1;
 }
 
 /* This function will check the usage_count of the drive to be updated/added.
@@ -1870,7 +1915,7 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 		}
 	}
 	h->drv[drv_index].LunID = lunid;
-	if (cciss_create_ld_sysfs_entry(h, &h->drv[drv_index], drv_index))
+	if (cciss_create_ld_sysfs_entry(h, drv_index))
 		goto err_free_disk;
 
 	/* Don't need to mark this busy because nobody */
@@ -2144,7 +2189,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
-	cciss_destroy_ld_sysfs_entry(drv);
+	cciss_destroy_ld_sysfs_entry(h, drv_index);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4267,8 +4312,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 			if (q)
 				blk_cleanup_queue(q);
 		}
-		if (hba[i]->drv[j].raid_level != -1)
-			cciss_destroy_ld_sysfs_entry(&hba[i]->drv[j]);
+		if (hba[i]->drv[j].dev != NULL &&
+			(j == 0 || hba[i]->drv[j].raid_level != -1))
+				cciss_destroy_ld_sysfs_entry(hba[i], j);
 
 	}
 
@@ -4344,7 +4390,7 @@ static int __init cciss_init(void)
 	if (err)
 		goto err_thread_stop;
 
-	return 0;
+	return err;
 
 err_thread_stop:
 	kthread_stop(cciss_scan_thread);
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 4fb3639..9679342 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -45,7 +45,7 @@ typedef struct _drive_info_struct
 				   * to prevent it from being opened or it's
 				   * queue from being started.
 				   */
-	struct	device dev;
+	struct	device *dev;
 	__u8 serial_no[16]; /* from inquiry page 0x83,
 			     * not necc. null terminated.
 			     */

