From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] dpt_i2o: convert to SCSI hotplug model
Date: Mon, 30 Jul 2007 15:19:18 -0600
Message-ID: <20070730211917.GK21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34138 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967770AbXG3VTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 17:19:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com, linux-scsi@vger.kernel.org

dpt_i2o: Convert to new SCSI driver model

 - Delete refereces to HOSTS_C
 - Switch to module_init/module_exit instead of detect/release
 - Don't pass around the host template and rename it to adpt_template
 - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
   scsi_add_host, scsi_scan_host and scsi_host_put.

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 2e2362d..50b47ec 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -173,20 +173,20 @@ static struct pci_device_id dptids[] = {
 };
 MODULE_DEVICE_TABLE(pci,dptids);
 
-static int adpt_detect(struct scsi_host_template* sht)
+static void adpt_exit(void);
+
+static int adpt_detect(void)
 {
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
 
-	adpt_init();
-
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
 	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
 		if(pDev->device == PCI_DPT_DEVICE_ID ||
 		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
-			if(adpt_install_hba(sht, pDev) ){
+			if(adpt_install_hba(pDev) ){
 				PERROR("Could not Init an I2O RAID device\n");
 				PERROR("Will not try to detect others.\n");
 				return hba_count-1;
@@ -248,34 +248,33 @@ rebuild_sys_tab:
 	}
 
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if( adpt_scsi_register(pHba,sht) < 0){
+		if (adpt_scsi_register(pHba) < 0) {
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
+		scsi_scan_host(pHba->host);
 	}
 
 	// Register our control device node
 	// nodes will need to be created in /dev to access this
 	// the nodes can not be created from within the driver
 	if (hba_count && register_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER, &adpt_fops)) {
-		adpt_i2o_sys_shutdown();
+		adpt_exit();
 		return 0;
 	}
 	return hba_count;
 }
 
 
-/*
- * scsi_unregister will be called AFTER we return. 
- */
-static int adpt_release(struct Scsi_Host *host)
+static int adpt_release(adpt_hba *pHba)
 {
-	adpt_hba* pHba = (adpt_hba*) host->hostdata[0];
+	struct Scsi_Host *shost = pHba->host;
+	scsi_remove_host(shost);
 //	adpt_i2o_quiesce_hba(pHba);
 	adpt_i2o_delete_hba(pHba);
-	scsi_unregister(host);
+	scsi_host_put(shost);
 	return 0;
 }
 
@@ -882,7 +881,7 @@ static int adpt_reboot_event(struct notifier_block *n, ulong code, void *p)
 #endif
 
 
-static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) 
+static int adpt_install_hba(struct pci_dev* pDev) 
 {
 
 	adpt_hba* pHba = NULL;
@@ -1031,8 +1030,6 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 
 
 	mutex_lock(&adpt_configuration_lock);
-	// scsi_unregister calls our adpt_release which
-	// does a quiese
 	if(pHba->host){
 		free_irq(pHba->host->irq, pHba);
 	}
@@ -1084,17 +1081,6 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 }
 
 
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
@@ -2180,37 +2166,6 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_d
 }
 
 
-static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
-{
-	struct Scsi_Host *host = NULL;
-
-	host = scsi_register(sht, sizeof(adpt_hba*));
-	if (host == NULL) {
-		printk ("%s: scsi_register returned NULL\n",pHba->name);
-		return -1;
-	}
-	host->hostdata[0] = (unsigned long)pHba;
-	pHba->host = host;
-
-	host->irq = pHba->pDev->irq;
-	/* no IO ports, so don't have to set host->io_port and 
-	 * host->n_io_port
-	 */
-	host->io_port = 0;
-	host->n_io_port = 0;
-				/* see comments in scsi_host.h */
-	host->max_id = 16;
-	host->max_lun = 256;
-	host->max_channel = pHba->top_scsi_channel + 1;
-	host->cmd_per_lun = 1;
-	host->unique_id = (uint) pHba;
-	host->sg_tablesize = pHba->sg_tablesize;
-	host->can_queue = pHba->post_fifo_size;
-
-	return 0;
-}
-
-
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
@@ -3329,12 +3284,10 @@ static static void adpt_delay(int millisec)
 
 #endif
 
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template adpt_template = {
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
-	.detect			= adpt_detect,	
-	.release		= adpt_release,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
@@ -3348,5 +3301,62 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
-#include "scsi_module.c"
+
+static s32 adpt_scsi_register(adpt_hba* pHba)
+{
+	struct Scsi_Host *host;
+
+	host = scsi_host_alloc(&adpt_template, sizeof(adpt_hba*));
+	if (host == NULL) {
+		printk ("%s: scsi_host_alloc returned NULL\n",pHba->name);
+		return -1;
+	}
+	host->hostdata[0] = (unsigned long)pHba;
+	pHba->host = host;
+
+	host->irq = pHba->pDev->irq;
+	/* no IO ports, so don't have to set host->io_port and 
+	 * host->n_io_port
+	 */
+	host->io_port = 0;
+	host->n_io_port = 0;
+				/* see comments in scsi_host.h */
+	host->max_id = 16;
+	host->max_lun = 256;
+	host->max_channel = pHba->top_scsi_channel + 1;
+	host->cmd_per_lun = 1;
+	host->unique_id = (uint) pHba;
+	host->sg_tablesize = pHba->sg_tablesize;
+	host->can_queue = pHba->post_fifo_size;
+
+	if (scsi_add_host(host, &pHba->pDev->dev)) {
+		scsi_host_put(host);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __init adpt_init(void)
+{
+	int count;
+
+	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+#ifdef REBOOT_NOTIFIER
+	register_reboot_notifier(&adpt_reboot_notifier);
+#endif
+
+	count = adpt_detect();
+
+	return count > 0 ? 0 : -ENODEV;
+}
+
+static void __exit adpt_exit(void)
+{
+	while (hba_chain)
+		adpt_release(hba_chain);
+}
+
+module_init(adpt_init);
+module_exit(adpt_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index fd79068..0892f6c 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -28,11 +28,9 @@
  * SCSI interface function Prototypes
  */
 
-static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct scsi_cmnd * cmd, void (*cmdcomplete) (struct scsi_cmnd *));
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
-static int adpt_release(struct Scsi_Host *host);
 static int adpt_slave_configure(struct scsi_device *);
 
 static const char *adpt_info(struct Scsi_Host *pSHost);
@@ -49,8 +47,6 @@ static int adpt_device_reset(struct scsi_cmnd* cmd);
 
 #define DPT_DRIVER_NAME	"Adaptec I2O RAID"
 
-#ifndef HOSTS_C
-
 #include "dpt/sys_info.h"
 #include <linux/wait.h>
 #include "dpt/dpti_i2o.h"
@@ -289,7 +285,7 @@ static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba);
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
+static s32 adpt_scsi_register(adpt_hba* pHba);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);
@@ -299,7 +295,7 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba);
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun);
-static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
+static int adpt_install_hba(struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
@@ -343,5 +339,4 @@ static void adpt_i386_info(sysInfo_S* si);
 #define FW_DEBUG_BLED_OFFSET       8
 
 #define FW_DEBUG_FLAGS_NO_HEADERS_B    0x01
-#endif				/* !HOSTS_C */
 #endif				/* _DPT_H */

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
