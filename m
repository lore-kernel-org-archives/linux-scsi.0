From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH 1/4] dpt_i2o: use standard __init / __exit code
Date: Fri, 2 May 2008 01:05:33 +0200
Message-ID: <20080501230528.GA19820@xs4all.net>
References: <20080501230211.GA19796@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3634 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbYEAXFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 19:05:36 -0400
Received: from n2o.xs4all.nl (n2o.xs4all.nl [194.109.0.112])
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id m41N5YtU090501
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 01:05:34 +0200 (CEST)
	(envelope-from miquels@cistron.nl)
Received: from mikevs by n2o.xs4all.nl with local (Exim 4.69)
	(envelope-from <miquels@cistron.nl>)
	id 1JrhqH-00059p-U6
	for linux-scsi@vger.kernel.org; Fri, 02 May 2008 01:05:33 +0200
Content-Disposition: inline
In-Reply-To: <20080501230211.GA19796@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[PATCH 1/4] dpt_i2o: use standard __init / __exit code

Update dpt_i2o.c to use the standard __init / __exit
code instead of the legacy '#include "scsi_module.c"' code.

This is needed in preparation of 64-bit support. scsi_module.c
calls scsi_add_host() with the device pointer set to NULL, and that
crashes code like arch/x64/kernel/pci-gart_64.c::need_iommu().

The reboot_notifier code is deleted because it wasn't compiled
in ever anyway, and it would be useless to duplicate it in
the new code.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

diff -ruN orig/linux-2.6.25/drivers/scsi/dpt_i2o.c linux-2.6.25-dpt64-01/drivers/scsi/dpt_i2o.c
--- orig/linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-dpt64-01/drivers/scsi/dpt_i2o.c	2008-05-01 22:58:14.000000000 +0200
@@ -118,17 +114,8 @@
 static const struct file_operations adpt_fops = {
 	.ioctl		= adpt_ioctl,
 	.open		= adpt_open,
-	.release	= adpt_close
-};
-
-#ifdef REBOOT_NOTIFIER
-static struct notifier_block adpt_reboot_notifier =
-{
-	 adpt_reboot_event,
-	 NULL,
-	 0
+	.release	= adpt_close
 };
-#endif
 
 /* Structures and definitions for synchronous message posting.
  * See adpt_i2o_post_wait() for description
@@ -178,8 +175,6 @@
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
 
-	adpt_init();
-
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
@@ -248,7 +243,7 @@
 	}
 
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if( adpt_scsi_register(pHba,sht) < 0){
+		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
@@ -861,27 +856,6 @@
 	 printk(KERN_INFO "Adaptec I2O controllers down.\n");
 }
 
-/*
- * reboot/shutdown notification.
- *
- * - Quiesce each IOP in the system
- *
- */
-
-#ifdef REBOOT_NOTIFIER
-static int adpt_reboot_event(struct notifier_block *n, ulong code, void *p)
-{
-
-	 if(code != SYS_RESTART && code != SYS_HALT && code != SYS_POWER_OFF)
-		  return NOTIFY_DONE;
-
-	 adpt_i2o_sys_shutdown();
-
-	 return NOTIFY_DONE;
-}
-#endif
-
-
 static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
 {
 
@@ -1080,18 +1092,6 @@
 	}
 }
 
-
-static int adpt_init(void)
-{
-	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
-#ifdef REBOOT_NOTIFIER
-	register_reboot_notifier(&adpt_reboot_notifier);
-#endif
-
-	return 0;
-}
-
-
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
 {
 	struct adpt_device* d;
@@ -2177,13 +2202,13 @@
 }
 
 
-static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
+static s32 adpt_scsi_host_alloc(adpt_hba* pHba, struct scsi_host_template *sht)
 {
-	struct Scsi_Host *host = NULL;
+	struct Scsi_Host *host;
 
-	host = scsi_register(sht, sizeof(adpt_hba*));
+	host = scsi_host_alloc(sht, sizeof(adpt_hba*));
 	if (host == NULL) {
-		printk ("%s: scsi_register returned NULL\n",pHba->name);
+		printk("%s: scsi_host_alloc returned NULL\n", pHba->name);
 		return -1;
 	}
 	host->hostdata[0] = (unsigned long)pHba;
@@ -3323,11 +3391,10 @@
 #endif
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
-	.detect			= adpt_detect,
-	.release		= adpt_release,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
@@ -3341,5 +3408,48 @@
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-#include "scsi_module.c"
+
+static int __init adpt_init(void)
+{
+	int		error;
+	adpt_hba	*pHba, *next;
+
+	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+
+	error = adpt_detect(&driver_template);
+	if (error < 0)
+		return error;
+	if (hba_chain == NULL)
+		return -ENODEV;
+
+	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+		error = scsi_add_host(pHba->host, &pHba->pDev->dev);
+		if (error)
+			goto fail;
+		scsi_scan_host(pHba->host);
+	}
+	return 0;
+fail:
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
+		scsi_remove_host(pHba->host);
+	}
+	return error;
+}
+
+static void __exit adpt_exit(void)
+{
+	adpt_hba	*pHba, *next;
+
+	for (pHba = hba_chain; pHba; pHba = pHba->next)
+		scsi_remove_host(pHba->host);
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
+		adpt_release(pHba->host);
+	}
+}
+
+module_init(adpt_init);
+module_exit(adpt_exit);
+
 MODULE_LICENSE("GPL");
diff -ruN orig/linux-2.6.25/drivers/scsi/dpti.h linux-2.6.25-dpt64-01/drivers/scsi/dpti.h
--- orig/linux-2.6.25/drivers/scsi/dpti.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-dpt64-01/drivers/scsi/dpti.h	2008-05-01 21:21:16.000000000 +0200
@@ -84,7 +84,6 @@
 #define PCI_DPT_DEVICE_ID         (0xA501)	// DPT PCI I2O Device ID
 #define PCI_DPT_RAPTOR_DEVICE_ID  (0xA511)	
 
-//#define REBOOT_NOTIFIER 1
 /* Debugging macro from Linux Device Drivers - Rubini */
 #undef PDEBUG
 #ifdef DEBUG
@@ -264,9 +269,6 @@
 static int adpt_init(void);
 static int adpt_i2o_build_sys_table(void);
 static irqreturn_t adpt_isr(int irq, void *dev_id);
-#ifdef REBOOT_NOTIFIER
-static int adpt_reboot_event(struct notifier_block *n, ulong code, void *p);
-#endif
 
 static void adpt_i2o_report_hba_unit(adpt_hba* pHba, struct i2o_device *d);
 static int adpt_i2o_query_scalar(adpt_hba* pHba, int tid, 
@@ -289,7 +292,7 @@
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
+static s32 adpt_scsi_host_alloc(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);
