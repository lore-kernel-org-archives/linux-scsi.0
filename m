From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] drivers/scsi/dpt_i2o: Convert to generic boolean
Date: Tue, 30 Oct 2007 11:54:22 +0100 (MET)
Message-ID: <20071030104806.30936.13253.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46751 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbXJ3Ky1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 06:54:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert to use the generic boolean.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Diffed against linus-git
Checked with script/checkpatch.pl
  (warned about long lines, but it is not introduced by this patch)

 dpt_i2o.c |   22 +++++++++++-----------
 dpti.h    |    9 ++-------
 2 files changed, 13 insertions(+), 18 deletions(-)


diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 8258506..bd3a82d 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -252,7 +252,7 @@ rebuild_sys_tab:
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
-		pHba->initialized = TRUE;
+		pHba->initialized = true;
 		pHba->state &= ~DPTI_STATE_RESET;
 		scsi_scan_host(pHba->host);
 	}
@@ -519,7 +519,7 @@ static int adpt_proc_info(struct Scsi_Host *host, char *buffer, char **start, of
 	int unit;
 
 	*start = buffer;
-	if (inout == TRUE) {
+	if (inout) {
 		/*
 		 * The user has done a write and wants us to take the
 		 * data in the buffer and do something with it.
@@ -893,7 +893,7 @@ static int adpt_install_hba(struct pci_dev* pDev)
 	void __iomem *base_addr_virt = NULL;
 	void __iomem *msg_addr_virt = NULL;
 
-	int raptorFlag = FALSE;
+	bool raptorFlag = false;
 
 	if(pci_enable_device(pDev)) {
 		return -EINVAL;
@@ -926,7 +926,7 @@ static int adpt_install_hba(struct pci_dev* pDev)
 		// Use BAR1 in this configuration
 		base_addr1_phys = pci_resource_start(pDev,1);
 		hba_map1_area_size = pci_resource_len(pDev,1);
-		raptorFlag = TRUE;
+		raptorFlag = true;
 	}
 
 	base_addr_virt = ioremap(base_addr0_phys,hba_map0_area_size);
@@ -936,7 +936,7 @@ static int adpt_install_hba(struct pci_dev* pDev)
 		return -EINVAL;
 	}
 
-        if(raptorFlag == TRUE) {
+	if (raptorFlag) {
 		msg_addr_virt = ioremap(base_addr1_phys, hba_map1_area_size );
 		if (!msg_addr_virt) {
 			PERROR("dpti: adpt_config_hba: io remap failed on BAR1\n");
@@ -996,7 +996,7 @@ static int adpt_install_hba(struct pci_dev* pDev)
 	spin_lock_init(&pHba->state_lock);
 	spin_lock_init(&adpt_post_wait_lock);
 
-	if(raptorFlag == 0){
+	if (!raptorFlag) {
 		printk(KERN_INFO"Adaptec I2O RAID controller %d at %p size=%x irq=%d\n", 
 			hba_count-1, base_addr_virt, hba_map0_area_size, pDev->irq);
 	} else {
@@ -1273,7 +1273,7 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 	u32 m = EMPTY_QUEUE ;
 	ulong timeout = jiffies + (TMOUT_IOPRESET*HZ);
 
-	if(pHba->initialized  == FALSE) {	// First time reset should be quick
+	if (!pHba->initialized) {	/* First time reset should be quick */
 		timeout = jiffies + (25*HZ);
 	} else {
 		adpt_i2o_quiesce_hba(pHba);
@@ -1576,7 +1576,7 @@ static int adpt_open(struct inode *inode, struct file *file)
 //		return -EBUSY;
 //	}
 
-	pHba->in_use = 1;
+	pHba->in_use = true;
 	mutex_unlock(&adpt_configuration_lock);
 
 	return 0;
@@ -1602,7 +1602,7 @@ static int adpt_close(struct inode *inode, struct file *file)
 		return -ENXIO;
 	}
 
-	pHba->in_use = 0;
+	pHba->in_use = false;
 
 	return 0;
 }
@@ -2433,8 +2433,8 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 						pDev->tid = tid;
 						memcpy(&d->lct_data, &lct->lct_entry[i], sizeof(i2o_lct_entry));
 						if (pDev->pScsi_dev) {
-							pDev->pScsi_dev->changed = TRUE;
-							pDev->pScsi_dev->removable = TRUE;
+							pDev->pScsi_dev->changed = true;
+							pDev->pScsi_dev->removable = true;
 						}
 					}
 					// Found it - mark it scanned
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 0892f6c..5eb7274 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -155,11 +155,6 @@ static int adpt_device_reset(struct scsi_cmnd* cmd);
 #define I2O_SCSI_DSC_QUEUE_FROZEN           0x4000
 
 
-#ifndef TRUE
-#define TRUE                  1
-#define FALSE                 0
-#endif
-
 #define HBA_FLAGS_INSTALLED_B       0x00000001	// Adapter Was Installed
 #define HBA_FLAGS_BLINKLED_B        0x00000002	// Adapter In Blink LED State
 #define HBA_FLAGS_IN_RESET	0x00000040	/* in reset */
@@ -209,8 +204,8 @@ typedef struct _adpt_hba {
 	spinlock_t state_lock;
 	int unit;
 	int host_no;		/* SCSI host number */
-	u8 initialized;
-	u8 in_use;		/* is the management node open*/
+	bool initialized:8;
+	bool in_use:8;		/* is the management node open*/
 
 	char name[32];
 	char detail[55];
