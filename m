From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/18] lpfc 8.3.42: Avoided making pci bar ioremap call
 during dual-chute WQ/RQ pci bar selection
Date: Fri, 6 Sep 2013 12:21:09 -0400
Message-ID: <1378484469.14051.31.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22351 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3IFQVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:21:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Avoided making pci bar ioremap call during dual-chute WQ/RQ pci bar selection


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   34 ++++++++++++----------------------
 lpfc_sli.c  |   16 ----------------
 2 files changed, 12 insertions(+), 38 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:04:17.694058616 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:04:21.023058692 -0400
@@ -7135,19 +7135,6 @@ lpfc_sli4_queue_destroy(struct lpfc_hba
 		phba->sli4_hba.fcp_wq = NULL;
 	}
 
-	if (phba->pci_bar0_memmap_p) {
-		iounmap(phba->pci_bar0_memmap_p);
-		phba->pci_bar0_memmap_p = NULL;
-	}
-	if (phba->pci_bar2_memmap_p) {
-		iounmap(phba->pci_bar2_memmap_p);
-		phba->pci_bar2_memmap_p = NULL;
-	}
-	if (phba->pci_bar4_memmap_p) {
-		iounmap(phba->pci_bar4_memmap_p);
-		phba->pci_bar4_memmap_p = NULL;
-	}
-
 	/* Release FCP CQ mapping array */
 	if (phba->sli4_hba.fcp_cq_map != NULL) {
 		kfree(phba->sli4_hba.fcp_cq_map);
@@ -7936,9 +7923,9 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba
 	 * particular PCI BARs regions is dependent on the type of
 	 * SLI4 device.
 	 */
-	if (pci_resource_start(pdev, 0)) {
-		phba->pci_bar0_map = pci_resource_start(pdev, 0);
-		bar0map_len = pci_resource_len(pdev, 0);
+	if (pci_resource_start(pdev, PCI_64BIT_BAR0)) {
+		phba->pci_bar0_map = pci_resource_start(pdev, PCI_64BIT_BAR0);
+		bar0map_len = pci_resource_len(pdev, PCI_64BIT_BAR0);
 
 		/*
 		 * Map SLI4 PCI Config Space Register base to a kernel virtual
@@ -7952,6 +7939,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba
 				   "registers.\n");
 			goto out;
 		}
+		phba->pci_bar0_memmap_p = phba->sli4_hba.conf_regs_memmap_p;
 		/* Set up BAR0 PCI config space register memory map */
 		lpfc_sli4_bar0_register_memmap(phba, if_type);
 	} else {
@@ -7974,13 +7962,13 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba
 	}
 
 	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
-	    (pci_resource_start(pdev, 2))) {
+	    (pci_resource_start(pdev, PCI_64BIT_BAR2))) {
 		/*
 		 * Map SLI4 if type 0 HBA Control Register base to a kernel
 		 * virtual address and setup the registers.
 		 */
-		phba->pci_bar1_map = pci_resource_start(pdev, 2);
-		bar1map_len = pci_resource_len(pdev, 2);
+		phba->pci_bar1_map = pci_resource_start(pdev, PCI_64BIT_BAR2);
+		bar1map_len = pci_resource_len(pdev, PCI_64BIT_BAR2);
 		phba->sli4_hba.ctrl_regs_memmap_p =
 				ioremap(phba->pci_bar1_map, bar1map_len);
 		if (!phba->sli4_hba.ctrl_regs_memmap_p) {
@@ -7988,17 +7976,18 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba
 			   "ioremap failed for SLI4 HBA control registers.\n");
 			goto out_iounmap_conf;
 		}
+		phba->pci_bar2_memmap_p = phba->sli4_hba.ctrl_regs_memmap_p;
 		lpfc_sli4_bar1_register_memmap(phba);
 	}
 
 	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
-	    (pci_resource_start(pdev, 4))) {
+	    (pci_resource_start(pdev, PCI_64BIT_BAR4))) {
 		/*
 		 * Map SLI4 if type 0 HBA Doorbell Register base to a kernel
 		 * virtual address and setup the registers.
 		 */
-		phba->pci_bar2_map = pci_resource_start(pdev, 4);
-		bar2map_len = pci_resource_len(pdev, 4);
+		phba->pci_bar2_map = pci_resource_start(pdev, PCI_64BIT_BAR4);
+		bar2map_len = pci_resource_len(pdev, PCI_64BIT_BAR4);
 		phba->sli4_hba.drbl_regs_memmap_p =
 				ioremap(phba->pci_bar2_map, bar2map_len);
 		if (!phba->sli4_hba.drbl_regs_memmap_p) {
@@ -8006,6 +7995,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba
 			   "ioremap failed for SLI4 HBA doorbell registers.\n");
 			goto out_iounmap_ctrl;
 		}
+		phba->pci_bar4_memmap_p = phba->sli4_hba.drbl_regs_memmap_p;
 		error = lpfc_sli4_bar2_register_memmap(phba, LPFC_VF0);
 		if (error)
 			goto out_iounmap_all;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-09-06 10:03:53.500058066 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-09-06 10:04:21.042058693 -0400
@@ -12233,7 +12233,6 @@ static void __iomem *
 lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
 {
 	struct pci_dev *pdev;
-	unsigned long bar_map, bar_map_len;
 
 	if (!phba->pcidev)
 		return NULL;
@@ -12242,25 +12241,10 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_
 
 	switch (pci_barset) {
 	case WQ_PCI_BAR_0_AND_1:
-		if (!phba->pci_bar0_memmap_p) {
-			bar_map = pci_resource_start(pdev, PCI_64BIT_BAR0);
-			bar_map_len = pci_resource_len(pdev, PCI_64BIT_BAR0);
-			phba->pci_bar0_memmap_p = ioremap(bar_map, bar_map_len);
-		}
 		return phba->pci_bar0_memmap_p;
 	case WQ_PCI_BAR_2_AND_3:
-		if (!phba->pci_bar2_memmap_p) {
-			bar_map = pci_resource_start(pdev, PCI_64BIT_BAR2);
-			bar_map_len = pci_resource_len(pdev, PCI_64BIT_BAR2);
-			phba->pci_bar2_memmap_p = ioremap(bar_map, bar_map_len);
-		}
 		return phba->pci_bar2_memmap_p;
 	case WQ_PCI_BAR_4_AND_5:
-		if (!phba->pci_bar4_memmap_p) {
-			bar_map = pci_resource_start(pdev, PCI_64BIT_BAR4);
-			bar_map_len = pci_resource_len(pdev, PCI_64BIT_BAR4);
-			phba->pci_bar4_memmap_p = ioremap(bar_map, bar_map_len);
-		}
 		return phba->pci_bar4_memmap_p;
 	default:
 		break;



