From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 7/22] lpfc 8.1.2 :  Fixed system panic in lpfc_sli_brdreset
 during dynamic add of LP11K
Date: Wed, 08 Feb 2006 10:41:49 -0500
Message-ID: <43EA113D.2080007@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36493 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030441AbWBHPlw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:41:52 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18Ffprf011860
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:41:52 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fixed system panic in lpfc_sli_brdreset during dynamic add of LP11K


Signed-off-by: James Smart <James.Smart@emulex.com>

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

