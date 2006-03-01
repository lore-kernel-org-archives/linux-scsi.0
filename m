From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 7/22] lpfc 8.1.2: Fixed system panic in lpfc_sli_brdreset during dynamic add of LP11K
Date: Tue, 28 Feb 2006 19:25:19 -0500
Message-ID: <20060301002519.GA15421@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:43942 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932739AbWCAAZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:21 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PJAY015427
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:19 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PJQZ015426
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system panic in lpfc_sli_brdreset during dynamic add of LP11K

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1462,9 +1462,23 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	phba->pci_bar2_map = pci_resource_start(phba->pcidev, 2);
 	bar2map_len        = pci_resource_len(phba->pcidev, 2);
 
-	/* Map HBA SLIM and Control Registers to a kernel virtual address. */
+	/* Map HBA SLIM to a kernel virtual address. */
 	phba->slim_memmap_p      = ioremap(phba->pci_bar0_map, bar0map_len);
+	if (!phba->slim_memmap_p) {
+		error = -ENODEV;
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for SLIM memory.\n");
+		goto out_idr_remove;
+	}
+
+	/* Map HBA Control Registers to a kernel virtual address. */
 	phba->ctrl_regs_memmap_p = ioremap(phba->pci_bar2_map, bar2map_len);
+	if (!phba->ctrl_regs_memmap_p) {
+		error = -ENODEV;
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "ioremap failed for HBA control registers.\n");
+		goto out_iounmap_slim;
+	}
 
 	/* Allocate memory for SLI-2 structures */
 	phba->slim2p = dma_alloc_coherent(&phba->pcidev->dev, SLI2_SLIM_SIZE,
@@ -1643,6 +1657,7 @@ out_free_slim:
 							phba->slim2p_mapping);
 out_iounmap:
 	iounmap(phba->ctrl_regs_memmap_p);
+out_iounmap_slim:
 	iounmap(phba->slim_memmap_p);
 out_idr_remove:
 	idr_remove(&lpfc_hba_index, phba->brd_no);
