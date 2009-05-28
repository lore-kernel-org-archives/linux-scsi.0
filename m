From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH v6] cciss: add cciss driver sysfs entries
Date: Thu, 28 May 2009 15:21:24 -0500
Message-ID: <20090528202124.GB4846@beardog.cca.cpqcorp.net>
References: <20090413164524.17977.99322.stgit@bluto.andrew> <20090413164530.17977.32550.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:19622 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZE1UVA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 16:21:00 -0400
Content-Disposition: inline
In-Reply-To: <20090413164530.17977.32550.stgit@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, Andrew Patterson <andrew.patterson@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, scameron@beardog.cca.cpqcorp.net

Patch 1 of 1

cciss: add cciss driver sysfs entries

From: Andrew Patterson <andrew.patterson@hp.com>

This patch adds sysfs entries to the cciss driver needed for the
dm/multipath tools. A file for vendor, model, rev, and unique_id is
added for each logical drive under directory
/sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
host) number and Y is the logical drive number. A link from
/sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
/sys/block/cciss!cXdY/device is also created. A bus is created
in /sys/bus/cciss.  A link is created from the pci ccissX entry to
/sys/bus/cciss/devices/ccissX.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
new file mode 100644
index 0000000..0a92a7c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-cciss
@@ -0,0 +1,33 @@
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/model
+Date:		March 2009
+Kernel Version: 2.6.30
+Contact:	iss_storagedev@hp.com
+Description:	Displays the SCSI INQUIRY page 0 model for logical drive
+		Y of controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/rev
+Date:		March 2009
+Kernel Version: 2.6.30
+Contact:	iss_storagedev@hp.com
+Description:	Displays the SCSI INQUIRY page 0 revision for logical
+		drive Y of controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/unique_id
+Date:		March 2009
+Kernel Version: 2.6.30
+Contact:	iss_storagedev@hp.com
+Description:	Displays the SCSI INQUIRY page 83 serial number for logical
+		drive Y of controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/vendor
+Date:		March 2009
+Kernel Version: 2.6.30
+Contact:	iss_storagedev@hp.com
+Description:	Displays the SCSI INQUIRY page 0 vendor for logical drive
+		Y of controller X.
+
+Where:		/sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY
+Date:		March 2009
+Kernel Version: 2.6.30
+Contact:	iss_storagedev@hp.com
+Description:	A symbolic link to /sys/block/cciss!cXdY
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0ef6f08..50e0909 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -437,6 +437,194 @@ static void __devinit cciss_procinit(int i)
 }
 #endif				/* CONFIG_PROC_FS */
 
+#define MAX_PRODUCT_NAME_LEN 19
+
+#define to_hba(n) container_of(n, struct ctlr_info, dev)
+#define to_drv(n) container_of(n, drive_info_struct, dev)
+
+static struct device_type cciss_host_type = {
+	.name		= "cciss_host",
+};
+
+static ssize_t dev_show_unique_id(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
+	__u8 sn[16];
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring)
+		ret = -EBUSY;
+	else
+		memcpy(sn, drv->serial_no, sizeof(sn));
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+
+	if (ret)
+		return ret;
+	else
+		return snprintf(buf, 16 * 2 + 2,
+				"%02X%02X%02X%02X%02X%02X%02X%02X"
+				"%02X%02X%02X%02X%02X%02X%02X%02X\n",
+				sn[0], sn[1], sn[2], sn[3],
+				sn[4], sn[5], sn[6], sn[7],
+				sn[8], sn[9], sn[10], sn[11],
+				sn[12], sn[13], sn[14], sn[15]);
+}
+DEVICE_ATTR(unique_id, S_IRUGO, dev_show_unique_id, NULL);
+
+static ssize_t dev_show_vendor(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
+	char vendor[VENDOR_LEN + 1];
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring)
+		ret = -EBUSY;
+	else
+		memcpy(vendor, drv->vendor, VENDOR_LEN + 1);
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+
+	if (ret)
+		return ret;
+	else
+		return snprintf(buf, sizeof(vendor) + 1, "%s\n", drv->vendor);
+}
+DEVICE_ATTR(vendor, S_IRUGO, dev_show_vendor, NULL);
+
+static ssize_t dev_show_model(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
+	char model[MODEL_LEN + 1];
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring)
+		ret = -EBUSY;
+	else
+		memcpy(model, drv->model, MODEL_LEN + 1);
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+
+	if (ret)
+		return ret;
+	else
+		return snprintf(buf, sizeof(model) + 1, "%s\n", drv->model);
+}
+DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
+
+static ssize_t dev_show_rev(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	drive_info_struct *drv = to_drv(dev);
+	struct ctlr_info *h = to_hba(drv->dev.parent);
+	char rev[REV_LEN + 1];
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	if (h->busy_configuring)
+		ret = -EBUSY;
+	else
+		memcpy(rev, drv->rev, REV_LEN + 1);
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+
+	if (ret)
+		return ret;
+	else
+		return snprintf(buf, sizeof(rev) + 1, "%s\n", drv->rev);
+}
+DEVICE_ATTR(rev, S_IRUGO, dev_show_rev, NULL);
+
+static struct attribute *cciss_dev_attrs[] = {
+	&dev_attr_unique_id.attr,
+	&dev_attr_model.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_rev.attr,
+	NULL
+};
+
+static struct attribute_group cciss_dev_attr_group = {
+	.attrs = cciss_dev_attrs,
+};
+
+static struct attribute_group *cciss_dev_attr_groups[] = {
+	&cciss_dev_attr_group,
+	NULL
+};
+
+static struct device_type cciss_dev_type = {
+	.name		= "cciss_device",
+	.groups		= cciss_dev_attr_groups,
+};
+
+static struct bus_type cciss_bus_type = {
+	.name		= "cciss",
+};
+
+
+/*
+ * Initialize sysfs entry for each controller.  This sets up and registers
+ * the 'cciss#' directory for each individual controller under
+ * /sys/bus/pci/devices/<dev>/.
+ */
+static int cciss_create_hba_sysfs_entry(struct ctlr_info *h)
+{
+	device_initialize(&h->dev);
+	h->dev.type = &cciss_host_type;
+	h->dev.bus = &cciss_bus_type;
+	dev_set_name(&h->dev, "%s", h->devname);
+	h->dev.parent = &h->pdev->dev;
+
+	return device_add(&h->dev);
+}
+
+/*
+ * Remove sysfs entries for an hba.
+ */
+static void cciss_destroy_hba_sysfs_entry(struct ctlr_info *h)
+{
+	device_del(&h->dev);
+}
+
+/*
+ * Initialize sysfs for each logical drive.  This sets up and registers
+ * the 'c#d#' directory for each individual logical drive under
+ * /sys/bus/pci/devices/<dev/ccis#/. We also create a link from
+ * /sys/block/cciss!c#d# to this entry.
+ */
+static int cciss_create_ld_sysfs_entry(struct ctlr_info *h,
+				       drive_info_struct *drv,
+				       int drv_index)
+{
+	device_initialize(&drv->dev);
+	drv->dev.type = &cciss_dev_type;
+	drv->dev.bus = &cciss_bus_type;
+	dev_set_name(&drv->dev, "c%dd%d", h->ctlr, drv_index);
+	drv->dev.parent = &h->dev;
+	return device_add(&drv->dev);
+}
+
+/*
+ * Remove sysfs entries for a logical drive.
+ */
+static void cciss_destroy_ld_sysfs_entry(drive_info_struct *drv)
+{
+	device_del(&drv->dev);
+}
+
 /*
  * For operations that cannot sleep, a command block is allocated at init,
  * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
@@ -1337,6 +1525,45 @@ static void cciss_softirq_done(struct request *rq)
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
+/* This function gets the SCSI vendor, model, and revision of a logical drive
+ * via the inquiry page 0.  Model, vendor, and rev are set to empty strings if
+ * they cannot be read.
+ */
+static void cciss_get_device_descr(int ctlr, int logvol, int withirq,
+				   char *vendor, char *model, char *rev)
+{
+	int rc;
+	InquiryData_struct *inq_buf;
+
+	*vendor = '\0';
+	*model = '\0';
+	*rev = '\0';
+
+	inq_buf = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+	if (!inq_buf)
+		return;
+
+	if (withirq)
+		rc = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buf,
+				     sizeof(InquiryData_struct), 1, logvol,
+				     0, TYPE_CMD);
+	else
+		rc = sendcmd(CISS_INQUIRY, ctlr, inq_buf,
+			     sizeof(InquiryData_struct), 1, logvol, 0, NULL,
+			     TYPE_CMD);
+	if (rc == IO_OK) {
+		memcpy(vendor, &inq_buf->data_byte[8], VENDOR_LEN);
+		vendor[VENDOR_LEN] = '\0';
+		memcpy(model, &inq_buf->data_byte[16], MODEL_LEN);
+		model[MODEL_LEN] = '\0';
+		memcpy(rev, &inq_buf->data_byte[32], REV_LEN);
+		rev[REV_LEN] = '\0';
+	}
+
+	kfree(inq_buf);
+	return;
+}
+
 /* This function gets the serial number of a logical drive via
  * inquiry page 0x83.  Serial no. is 16 bytes.  If the serial
  * number cannot be had, for whatever reason, 16 bytes of 0xff
@@ -1377,7 +1604,7 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	disk->first_minor = drv_index << NWD_SHIFT;
 	disk->fops = &cciss_fops;
 	disk->private_data = &h->drv[drv_index];
-	disk->driverfs_dev = &h->pdev->dev;
+	disk->driverfs_dev = &h->drv[drv_index].dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
@@ -1468,6 +1695,8 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 	drvinfo->block_size = block_size;
 	drvinfo->nr_blocks = total_size + 1;
 
+	cciss_get_device_descr(ctlr, drv_index, 1, drvinfo->vendor,
+				drvinfo->model, drvinfo->rev);
 	cciss_get_serial_no(ctlr, drv_index, 1, drvinfo->serial_no,
 			sizeof(drvinfo->serial_no));
 
@@ -1517,6 +1746,9 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 	h->drv[drv_index].cylinders = drvinfo->cylinders;
 	h->drv[drv_index].raid_level = drvinfo->raid_level;
 	memcpy(h->drv[drv_index].serial_no, drvinfo->serial_no, 16);
+	memcpy(h->drv[drv_index].vendor, drvinfo->vendor, VENDOR_LEN + 1);
+	memcpy(h->drv[drv_index].model, drvinfo->model, MODEL_LEN + 1);
+	memcpy(h->drv[drv_index].rev, drvinfo->rev, REV_LEN + 1);
 
 	++h->num_luns;
 	disk = h->gendisk[drv_index];
@@ -1591,6 +1823,8 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 		}
 	}
 	h->drv[drv_index].LunID = lunid;
+	if (cciss_create_ld_sysfs_entry(h, &h->drv[drv_index], drv_index))
+		goto err_free_disk;
 
 	/* Don't need to mark this busy because nobody */
 	/* else knows about this disk yet to contend */
@@ -1598,6 +1832,11 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 	h->drv[drv_index].busy_configuring = 0;
 	wmb();
 	return drv_index;
+
+err_free_disk:
+	put_disk(h->gendisk[drv_index]);
+	h->gendisk[drv_index] = NULL;
+	return -1;
 }
 
 /* This is for the special case of a controller which
@@ -1718,6 +1957,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 			return_code = deregister_disk(h, i, 1);
+			cciss_destroy_ld_sysfs_entry(&h->drv[i]);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -3723,12 +3963,15 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	INIT_HLIST_HEAD(&hba[i]->reqQ);
 
 	if (cciss_pci_init(hba[i], pdev) != 0)
-		goto clean1;
+		goto clean0;
 
 	sprintf(hba[i]->devname, "cciss%d", i);
 	hba[i]->ctlr = i;
 	hba[i]->pdev = pdev;
 
+	if (cciss_create_hba_sysfs_entry(hba[i]))
+		goto clean0;
+
 	/* configure PCI DMA stuff */
 	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
 		dac = 1;
@@ -3872,6 +4115,8 @@ clean4:
 clean2:
 	unregister_blkdev(hba[i]->major, hba[i]->devname);
 clean1:
+	cciss_destroy_hba_sysfs_entry(hba[i]);
+clean0:
 	hba[i]->busy_initializing = 0;
 	/* cleanup any queues that may have been initialized */
 	for (j=0; j <= hba[i]->highest_lun; j++){
@@ -3982,6 +4227,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	 */
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
+	cciss_destroy_hba_sysfs_entry(hba[i]);
 	free_hba(i);
 }
 
@@ -3999,6 +4245,8 @@ static struct pci_driver cciss_pci_driver = {
  */
 static int __init cciss_init(void)
 {
+	int err;
+
 	/*
 	 * The hardware requires that commands are aligned on a 64-bit
 	 * boundary. Given that we use pci_alloc_consistent() to allocate an
@@ -4008,8 +4256,20 @@ static int __init cciss_init(void)
 
 	printk(KERN_INFO DRIVER_NAME "\n");
 
+	err = bus_register(&cciss_bus_type);
+	if (err)
+		return err;
+
 	/* Register for our PCI devices */
-	return pci_register_driver(&cciss_pci_driver);
+	err = pci_register_driver(&cciss_pci_driver);
+	if (err)
+		goto err_bus_register;
+
+	return 0;
+
+err_bus_register:
+	bus_unregister(&cciss_bus_type);
+	return err;
 }
 
 static void __exit cciss_cleanup(void)
@@ -4026,6 +4286,7 @@ static void __exit cciss_cleanup(void)
 		}
 	}
 	remove_proc_entry("driver/cciss", NULL);
+	bus_unregister(&cciss_bus_type);
 }
 
 static void fail_all_cmds(unsigned long ctlr)
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 703e080..dd1926d 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -12,6 +12,10 @@
 #define IO_OK		0
 #define IO_ERROR	1
 
+#define VENDOR_LEN	8
+#define MODEL_LEN	16
+#define REV_LEN		4
+
 struct ctlr_info;
 typedef struct ctlr_info ctlr_info_t;
 
@@ -34,13 +38,18 @@ typedef struct _drive_info_struct
 	int 	cylinders;
 	int	raid_level; /* set to -1 to indicate that
 			     * the drive is not in use/configured
-			    */
-	int	busy_configuring; /*This is set when the drive is being removed
-				   *to prevent it from being opened or it's queue
-				   *from being started.
-				  */
-	__u8 serial_no[16]; /* from inquiry page 0x83, */
-			    /* not necc. null terminated. */
+			     */
+	int	busy_configuring; /* This is set when a drive is being removed
+				   * to prevent it from being opened or it's
+				   * queue from being started.
+				   */
+	struct	device dev;
+	__u8 serial_no[16]; /* from inquiry page 0x83,
+			     * not necc. null terminated.
+			     */
+	char vendor[VENDOR_LEN + 1]; /* SCSI vendor string */
+	char model[MODEL_LEN + 1];   /* SCSI model string */
+	char rev[REV_LEN + 1];       /* SCSI revision string */
 } drive_info_struct;
 
 #ifdef CONFIG_CISS_SCSI_TAPE
@@ -123,6 +132,7 @@ struct ctlr_info
 	unsigned char alive;
 	struct completion *rescan_wait;
 	struct task_struct *cciss_scan_thread;
+	struct device dev;
 };
 
 /*  Defining the diffent access_menthods */

