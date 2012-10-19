From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 06/19] be2iscsi: Issue an FLR when driver is loaded
Date: Sat, 20 Oct 2012 04:42:37 +0530
Message-ID: <ac8466e4-fd64-44fe-8be0-1d1383c09d60@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38747 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2JSXNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:13:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

  Issue Function Level Reset everytime driver is loaded.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   65 +++++++++++----------------------------
 1 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index bd0f49f..41c7c56 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -47,8 +47,6 @@
 static unsigned int be_iopoll_budget = 10;
 static unsigned int be_max_phys_size = 64;
 static unsigned int enable_msix = 1;
-static unsigned int gcrashmode = 0;
-static unsigned int num_hba = 0;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
@@ -4446,14 +4444,18 @@ void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
 	beiscsi_log_enable_init(phba, beiscsi_log_enable);
 }
 
+/*
+ * beiscsi_quiesce()- Cleanup Driver resources
+ * @phba: Instance Priv structure
+ *
+ * Free the OS and HW resources held by the driver
+ **/
 static void beiscsi_quiesce(struct beiscsi_hba *phba)
 {
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	unsigned int i, msix_vec;
-	u8 *real_offset = 0;
-	u32 value = 0;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
 	phwi_context = phwi_ctrlr->phwi_ctxt;
@@ -4477,14 +4479,7 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba)
 
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
-	real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
-
-	value = readl((void *)real_offset);
 
-	if (value & 0x00010000) {
-		value &= 0xfffeffff;
-		writel(value, (void *)real_offset);
-	}
 	beiscsi_unmap_pci_function(phba);
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
@@ -4550,8 +4545,6 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
 	int ret, i;
-	u8 *real_offset = 0;
-	u32 value = 0;
 
 	ret = beiscsi_enable_pci(pcidev);
 	if (ret < 0) {
@@ -4606,31 +4599,18 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto hba_free;
 	}
 
-	if (!num_hba) {
-		real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
-		value = readl((void *)real_offset);
-		if (value & 0x00010000) {
-			gcrashmode++;
-			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-				    "BM_%d : Loading Driver in crashdump mode\n");
-			ret = beiscsi_cmd_reset_function(phba);
-			if (ret) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Reset Failed. Aborting Crashdump\n");
-				goto hba_free;
-			}
-			ret = be_chk_reset_complete(phba);
-			if (ret) {
-				beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
-					    "BM_%d : Failed to get out of reset."
-					    "Aborting Crashdump\n");
-				goto hba_free;
-			}
-		} else {
-			value |= 0x00010000;
-			writel(value, (void *)real_offset);
-			num_hba++;
-		}
+	ret = beiscsi_cmd_reset_function(phba);
+	if (ret) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : Reset Failed. Aborting Crashdump\n");
+		goto hba_free;
+	}
+	ret = be_chk_reset_complete(phba);
+	if (ret) {
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
+			    "BM_%d : Failed to get out of reset."
+			    "Aborting Crashdump\n");
+		goto hba_free;
 	}
 
 	spin_lock_init(&phba->io_sgl_lock);
@@ -4718,15 +4698,6 @@ free_twq:
 	beiscsi_clean_port(phba);
 	beiscsi_free_mem(phba);
 free_port:
-	real_offset = (u8 *)phba->csr_va + MPU_EP_SEMAPHORE;
-
-	value = readl((void *)real_offset);
-
-	if (value & 0x00010000) {
-		value &= 0xfffeffff;
-		writel(value, (void *)real_offset);
-	}
-
 	pci_free_consistent(phba->pcidev,
 			    phba->ctrl.mbox_mem_alloced.size,
 			    phba->ctrl.mbox_mem_alloced.va,
-- 
1.7.2

