From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.9: PCI Changes to lpfc driver
Date: Fri, 12 Feb 2010 14:40:50 -0500
Message-ID: <1266003670.2939.14.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49959 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756869Ab0BLTld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:41:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Call pci_save_state() after pci_restore_state() call to cope
  with kernel change.
- Add support for PCI BAR region 0 if BAR0 is a 64 bit register.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |    4 ----
 lpfc_init.c |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 32 insertions(+), 12 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-12 10:52:11.000000000 -0500
@@ -77,10 +77,6 @@ struct lpfc_sli_intf {
 #define LPFC_SLI_INTF_VALID		6
 };
 
-#define LPFC_SLI4_BAR0		1
-#define LPFC_SLI4_BAR1		2
-#define LPFC_SLI4_BAR2		4
-
 #define LPFC_SLI4_MBX_EMBED	true
 #define LPFC_SLI4_MBX_NEMBED	false
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:52:11.000000000 -0500
@@ -6079,16 +6079,20 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba 
 
 	/* Get the bus address of SLI4 device Bar0, Bar1, and Bar2 and the
 	 * number of bytes required by each mapping. They are actually
-	 * mapping to the PCI BAR regions 1, 2, and 4 by the SLI4 device.
+	 * mapping to the PCI BAR regions 0 or 1, 2, and 4 by the SLI4 device.
 	 */
-	phba->pci_bar0_map = pci_resource_start(pdev, LPFC_SLI4_BAR0);
-	bar0map_len = pci_resource_len(pdev, LPFC_SLI4_BAR0);
-
-	phba->pci_bar1_map = pci_resource_start(pdev, LPFC_SLI4_BAR1);
-	bar1map_len = pci_resource_len(pdev, LPFC_SLI4_BAR1);
+	if (pci_resource_start(pdev, 0)) {
+		phba->pci_bar0_map = pci_resource_start(pdev, 0);
+		bar0map_len = pci_resource_len(pdev, 0);
+	} else {
+		phba->pci_bar0_map = pci_resource_start(pdev, 1);
+		bar0map_len = pci_resource_len(pdev, 1);
+	}
+	phba->pci_bar1_map = pci_resource_start(pdev, 2);
+	bar1map_len = pci_resource_len(pdev, 2);
 
-	phba->pci_bar2_map = pci_resource_start(pdev, LPFC_SLI4_BAR2);
-	bar2map_len = pci_resource_len(pdev, LPFC_SLI4_BAR2);
+	phba->pci_bar2_map = pci_resource_start(pdev, 4);
+	bar2map_len = pci_resource_len(pdev, 4);
 
 	/* Map SLI4 PCI Config Space Register base to a kernel virtual addr */
 	phba->sli4_hba.conf_regs_memmap_p =
@@ -7174,6 +7178,12 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
+	/*
+	 * As the new kernel behavior of pci_restore_state() API call clears
+	 * device saved_state flag, need to save the restored state again.
+	 */
+	pci_save_state(pdev);
+
 	if (pdev->is_busmaster)
 		pci_set_master(pdev);
 
@@ -7357,6 +7367,13 @@ lpfc_io_slot_reset_s3(struct pci_dev *pd
 	}
 
 	pci_restore_state(pdev);
+
+	/*
+	 * As the new kernel behavior of pci_restore_state() API call clears
+	 * device saved_state flag, need to save the restored state again.
+	 */
+	pci_save_state(pdev);
+
 	if (pdev->is_busmaster)
 		pci_set_master(pdev);
 
@@ -7766,6 +7783,13 @@ lpfc_pci_resume_one_s4(struct pci_dev *p
 	/* Restore device state from PCI config space */
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+
+	/*
+	 * As the new kernel behavior of pci_restore_state() API call clears
+	 * device saved_state flag, need to save the restored state again.
+	 */
+	pci_save_state(pdev);
+
 	if (pdev->is_busmaster)
 		pci_set_master(pdev);
 


