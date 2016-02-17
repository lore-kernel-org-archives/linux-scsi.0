From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] [SCSI] dpt_i2o: use proper pci driver
Date: Wed, 17 Feb 2016 17:50:14 +0530
Message-ID: <1455711614-5185-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This is a pci device but was not done in the usual way a pci driver is
done. Convert the driver into a proper pci driver.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v1: only build warning related to "dptids defined but not used" was
fixed using #ifdef

 drivers/scsi/dpt_i2o.c | 269 ++++++++++++++++++++++---------------------------
 drivers/scsi/dpti.h    |   5 +-
 2 files changed, 120 insertions(+), 154 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index d4cda5e..9f50d1ae 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -111,6 +111,7 @@ static int sys_tbl_len;
 
 static adpt_hba* hba_chain = NULL;
 static int hba_count = 0;
+static bool control_reg;
 
 static struct class *adpt_sysfs_class;
 
@@ -187,118 +188,6 @@ static struct pci_device_id dptids[] = {
 };
 MODULE_DEVICE_TABLE(pci,dptids);
 
-static int adpt_detect(struct scsi_host_template* sht)
-{
-	struct pci_dev *pDev = NULL;
-	adpt_hba *pHba;
-	adpt_hba *next;
-
-	PINFO("Detecting Adaptec I2O RAID controllers...\n");
-
-        /* search for all Adatpec I2O RAID cards */
-	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
-		if(pDev->device == PCI_DPT_DEVICE_ID ||
-		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
-			if(adpt_install_hba(sht, pDev) ){
-				PERROR("Could not Init an I2O RAID device\n");
-				PERROR("Will not try to detect others.\n");
-				return hba_count-1;
-			}
-			pci_dev_get(pDev);
-		}
-	}
-
-	/* In INIT state, Activate IOPs */
-	for (pHba = hba_chain; pHba; pHba = next) {
-		next = pHba->next;
-		// Activate does get status , init outbound, and get hrt
-		if (adpt_i2o_activate_hba(pHba) < 0) {
-			adpt_i2o_delete_hba(pHba);
-		}
-	}
-
-
-	/* Active IOPs in HOLD state */
-
-rebuild_sys_tab:
-	if (hba_chain == NULL) 
-		return 0;
-
-	/*
-	 * If build_sys_table fails, we kill everything and bail
-	 * as we can't init the IOPs w/o a system table
-	 */	
-	if (adpt_i2o_build_sys_table() < 0) {
-		adpt_i2o_sys_shutdown();
-		return 0;
-	}
-
-	PDEBUG("HBA's in HOLD state\n");
-
-	/* If IOP don't get online, we need to rebuild the System table */
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if (adpt_i2o_online_hba(pHba) < 0) {
-			adpt_i2o_delete_hba(pHba);	
-			goto rebuild_sys_tab;
-		}
-	}
-
-	/* Active IOPs now in OPERATIONAL state */
-	PDEBUG("HBA's in OPERATIONAL state\n");
-
-	printk("dpti: If you have a lot of devices this could take a few minutes.\n");
-	for (pHba = hba_chain; pHba; pHba = next) {
-		next = pHba->next;
-		printk(KERN_INFO"%s: Reading the hardware resource table.\n", pHba->name);
-		if (adpt_i2o_lct_get(pHba) < 0){
-			adpt_i2o_delete_hba(pHba);
-			continue;
-		}
-
-		if (adpt_i2o_parse_lct(pHba) < 0){
-			adpt_i2o_delete_hba(pHba);
-			continue;
-		}
-		adpt_inquiry(pHba);
-	}
-
-	adpt_sysfs_class = class_create(THIS_MODULE, "dpt_i2o");
-	if (IS_ERR(adpt_sysfs_class)) {
-		printk(KERN_WARNING"dpti: unable to create dpt_i2o class\n");
-		adpt_sysfs_class = NULL;
-	}
-
-	for (pHba = hba_chain; pHba; pHba = next) {
-		next = pHba->next;
-		if (adpt_scsi_host_alloc(pHba, sht) < 0){
-			adpt_i2o_delete_hba(pHba);
-			continue;
-		}
-		pHba->initialized = TRUE;
-		pHba->state &= ~DPTI_STATE_RESET;
-		if (adpt_sysfs_class) {
-			struct device *dev = device_create(adpt_sysfs_class,
-				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit), NULL,
-				"dpti%d", pHba->unit);
-			if (IS_ERR(dev)) {
-				printk(KERN_WARNING"dpti%d: unable to "
-					"create device in dpt_i2o class\n",
-					pHba->unit);
-			}
-		}
-	}
-
-	// Register our control device node
-	// nodes will need to be created in /dev to access this
-	// the nodes can not be created from within the driver
-	if (hba_count && register_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER, &adpt_fops)) {
-		adpt_i2o_sys_shutdown();
-		return 0;
-	}
-	return hba_count;
-}
-
-
 /*
  * scsi_unregister will be called AFTER we return.
  */
@@ -901,7 +790,8 @@ static void adpt_i2o_sys_shutdown(void)
 	 printk(KERN_INFO "Adaptec I2O controllers down.\n");
 }
 
-static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
+static adpt_hba *adpt_install_hba(struct scsi_host_template *sht,
+				  struct pci_dev *pDev)
 {
 
 	adpt_hba* pHba = NULL;
@@ -917,12 +807,12 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 	int raptorFlag = FALSE;
 
 	if(pci_enable_device(pDev)) {
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (pci_request_regions(pDev, "dpt_i2o")) {
 		PERROR("dpti: adpt_config_hba: pci request region failed\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	pci_set_master(pDev);
@@ -936,7 +826,7 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 			dma64 = 1;
 	}
 	if (!dma64 && pci_set_dma_mask(pDev, DMA_BIT_MASK(32)) != 0)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	/* adapter only supports message blocks below 4GB */
 	pci_set_consistent_dma_mask(pDev, DMA_BIT_MASK(32));
@@ -984,7 +874,7 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 	if (!base_addr_virt) {
 		pci_release_regions(pDev);
 		PERROR("dpti: adpt_config_hba: io remap failed\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
         if(raptorFlag == TRUE) {
@@ -993,7 +883,7 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 			PERROR("dpti: adpt_config_hba: io remap failed on BAR1\n");
 			iounmap(base_addr_virt);
 			pci_release_regions(pDev);
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 		}
 	} else {
 		msg_addr_virt = base_addr_virt;
@@ -1006,7 +896,7 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 			iounmap(msg_addr_virt);
 		iounmap(base_addr_virt);
 		pci_release_regions(pDev);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	mutex_lock(&adpt_configuration_lock);
@@ -1065,10 +955,10 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 	if (request_irq (pDev->irq, adpt_isr, IRQF_SHARED, pHba->name, pHba)) {
 		printk(KERN_ERR"%s: Couldn't register IRQ %d\n", pHba->name, pDev->irq);
 		adpt_i2o_delete_hba(pHba);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
-	return 0;
+	return pHba;
 }
 
 
@@ -3568,47 +3458,124 @@ static struct scsi_host_template driver_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
-static int __init adpt_init(void)
+static int adpt_pci_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *ent)
 {
-	int		error;
-	adpt_hba	*pHba, *next;
+	struct scsi_host_template *sht = &driver_template;
+	adpt_hba *pHba, *pHba_temp;
+	int err;
 
-	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+	pHba = adpt_install_hba(sht, pdev);
+	if (IS_ERR(pHba)) {
+		PERROR("Could not Init an I2O RAID device\n");
+		return PTR_ERR(pHba);
+	}
 
-	error = adpt_detect(&driver_template);
-	if (error < 0)
-		return error;
-	if (hba_chain == NULL)
-		return -ENODEV;
+	/*
+	 * In INIT state, Activate IOPs
+	 * Activate does get status , init outbound, and get hrt
+	 */
+	if (adpt_i2o_activate_hba(pHba) < 0)
+		adpt_i2o_delete_hba(pHba);
 
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		error = scsi_add_host(pHba->host, &pHba->pDev->dev);
-		if (error)
-			goto fail;
-		scsi_scan_host(pHba->host);
+	/* Active IOPs in HOLD state */
+
+rebuild_sys_tab:
+	/*
+	 * If build_sys_table fails, we kill everything and bail
+	 * as we can't init the IOPs w/o a system table
+	 */
+	if (adpt_i2o_build_sys_table() < 0) {
+		adpt_i2o_sys_shutdown();
+		return -EIO;
 	}
-	return 0;
-fail:
-	for (pHba = hba_chain; pHba; pHba = next) {
-		next = pHba->next;
-		scsi_remove_host(pHba->host);
+
+	PDEBUG("HBA's in HOLD state\n");
+
+	/* If IOP don't get online, we need to rebuild the System table */
+	for (pHba_temp = hba_chain; pHba_temp; pHba_temp = pHba_temp->next) {
+		if (adpt_i2o_online_hba(pHba_temp) < 0) {
+			adpt_i2o_delete_hba(pHba_temp);
+			goto rebuild_sys_tab;
+		}
 	}
-	return error;
+
+	/* Active IOPs now in OPERATIONAL state */
+	PDEBUG("%s: HBA in OPERATIONAL state\n", pHba->name);
+
+	if (adpt_i2o_lct_get(pHba) < 0) {
+		adpt_i2o_delete_hba(pHba);
+		return -EIO;
+	}
+	if (adpt_i2o_parse_lct(pHba) < 0) {
+		adpt_i2o_delete_hba(pHba);
+		return -EIO;
+	}
+	adpt_inquiry(pHba);
+
+	if (!adpt_sysfs_class) {
+		adpt_sysfs_class = class_create(THIS_MODULE, "dpt_i2o");
+		if (IS_ERR(adpt_sysfs_class)) {
+			printk(KERN_WARNING
+			       "dpti: unable to create dpt_i2o class\n");
+			adpt_sysfs_class = NULL;
+		}
+	}
+	if (adpt_scsi_host_alloc(pHba, sht) < 0) {
+		adpt_i2o_delete_hba(pHba);
+		return -EIO;
+	}
+
+	pHba->initialized = TRUE;
+	pHba->state &= ~DPTI_STATE_RESET;
+	if (adpt_sysfs_class) {
+		struct device *dev = device_create(adpt_sysfs_class,
+			NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit), NULL,
+			"dpti%d", pHba->unit);
+		if (IS_ERR(dev)) {
+			printk(KERN_WARNING
+			       "dpti%d: unable to create device in dpt_i2o class\n",
+			       pHba->unit);
+		}
+	}
+
+	/*
+	 * Register our control device node
+	 * nodes will need to be created in /dev to access this
+	 * the nodes can not be created from within the driver
+	 */
+	if (!control_reg && hba_count) {
+		if (register_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER, &adpt_fops)) {
+		adpt_i2o_sys_shutdown();
+		return -EIO;
+		}
+		control_reg = true;
+	}
+
+	err = scsi_add_host(pHba->host, &pHba->pDev->dev);
+	if (err)
+		return err;
+
+	scsi_scan_host(pHba->host);
+	pci_set_drvdata(pdev, pHba);
+
+	return 0;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_pci_remove(struct pci_dev *pdev)
 {
-	adpt_hba	*pHba, *next;
+	adpt_hba *pHba = pci_get_drvdata(pdev);
 
-	for (pHba = hba_chain; pHba; pHba = pHba->next)
-		scsi_remove_host(pHba->host);
-	for (pHba = hba_chain; pHba; pHba = next) {
-		next = pHba->next;
-		adpt_release(pHba->host);
-	}
+	scsi_remove_host(pHba->host);
+	adpt_release(pHba->host);
 }
 
-module_init(adpt_init);
-module_exit(adpt_exit);
+static struct pci_driver adpt_driver = {
+	.name = "adpt",
+	.id_table = dptids,
+	.probe = adpt_pci_probe,
+	.remove = adpt_pci_remove,
+};
 
+module_pci_driver(adpt_driver);
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 1fa345a..e3481a4 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -28,7 +28,6 @@
  * SCSI interface function Prototypes
  */
 
-static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct Scsi_Host *h, struct scsi_cmnd * cmd);
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
@@ -265,7 +264,6 @@ struct sg_simple_element {
  */
 
 static void adpt_i2o_sys_shutdown(void);
-static int adpt_init(void);
 static int adpt_i2o_build_sys_table(void);
 static irqreturn_t adpt_isr(int irq, void *dev_id);
 
@@ -301,7 +299,8 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba);
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u64 lun);
-static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
+static adpt_hba *adpt_install_hba(struct scsi_host_template *sht,
+				  struct pci_dev *pDev);
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
-- 
1.9.1
