From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] ipr: use pci_irq_allocate_vectors
Date: Sun, 11 Sep 2016 15:31:24 +0200
Message-ID: <1473600688-24043-3-git-send-email-hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: kvm-owner@vger.kernel.org
To: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Switch the ipr driver to use pci_alloc_irq_vectors.  We need to two calls to
pci_alloc_irq_vectors as ipr only supports multiple MSI-X vectors, but not
multiple MSI vectors.

Otherwise this cleans up a lot of cruft and allows to use a common
request_irq loop for irq types, which happens to only iterate over a
single line in the non MSI-X case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ipr.c | 173 ++++++++++++++++-------------------------------------
 drivers/scsi/ipr.h |   7 +--
 2 files changed, 52 insertions(+), 128 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 17d04c7..cadf56c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -186,16 +186,16 @@ static const struct ipr_chip_cfg_t ipr_chip_cfg[] = {
 };
 
 static const struct ipr_chip_t ipr_chip[] = {
-	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, IPR_USE_MSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
+	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE, false, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CITRINE, false, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN, false, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN, false, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E, true, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[0] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, false, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, false, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, true, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE, true, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_RATTLESNAKE, true, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
 };
 
 static int ipr_max_bus_speeds[] = {
@@ -9356,23 +9356,11 @@ static void ipr_free_mem(struct ipr_ioa_cfg *ioa_cfg)
 static void ipr_free_irqs(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct pci_dev *pdev = ioa_cfg->pdev;
+	int i;
 
-	if (ioa_cfg->intr_flag == IPR_USE_MSI ||
-	    ioa_cfg->intr_flag == IPR_USE_MSIX) {
-		int i;
-		for (i = 0; i < ioa_cfg->nvectors; i++)
-			free_irq(ioa_cfg->vectors_info[i].vec,
-				 &ioa_cfg->hrrq[i]);
-	} else
-		free_irq(pdev->irq, &ioa_cfg->hrrq[0]);
-
-	if (ioa_cfg->intr_flag == IPR_USE_MSI) {
-		pci_disable_msi(pdev);
-		ioa_cfg->intr_flag &= ~IPR_USE_MSI;
-	} else if (ioa_cfg->intr_flag == IPR_USE_MSIX) {
-		pci_disable_msix(pdev);
-		ioa_cfg->intr_flag &= ~IPR_USE_MSIX;
-	}
+	for (i = 0; i < ioa_cfg->nvectors; i++)
+		free_irq(pci_irq_vector(pdev, i), &ioa_cfg->hrrq[i]);
+	pci_free_irq_vectors(pdev);
 }
 
 /**
@@ -9799,45 +9787,6 @@ static void ipr_wait_for_pci_err_recovery(struct ipr_ioa_cfg *ioa_cfg)
 	}
 }
 
-static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
-{
-	struct msix_entry entries[IPR_MAX_MSIX_VECTORS];
-	int i, vectors;
-
-	for (i = 0; i < ARRAY_SIZE(entries); ++i)
-		entries[i].entry = i;
-
-	vectors = pci_enable_msix_range(ioa_cfg->pdev,
-					entries, 1, ipr_number_of_msix);
-	if (vectors < 0) {
-		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		return vectors;
-	}
-
-	for (i = 0; i < vectors; i++)
-		ioa_cfg->vectors_info[i].vec = entries[i].vector;
-	ioa_cfg->nvectors = vectors;
-
-	return 0;
-}
-
-static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
-{
-	int i, vectors;
-
-	vectors = pci_enable_msi_range(ioa_cfg->pdev, 1, ipr_number_of_msix);
-	if (vectors < 0) {
-		ipr_wait_for_pci_err_recovery(ioa_cfg);
-		return vectors;
-	}
-
-	for (i = 0; i < vectors; i++)
-		ioa_cfg->vectors_info[i].vec = ioa_cfg->pdev->irq + i;
-	ioa_cfg->nvectors = vectors;
-
-	return 0;
-}
-
 static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int vec_idx, n = sizeof(ioa_cfg->vectors_info[0].desc) - 1;
@@ -9850,19 +9799,20 @@ static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
 	}
 }
 
-static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg)
+static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
+		struct pci_dev *pdev)
 {
 	int i, rc;
 
 	for (i = 1; i < ioa_cfg->nvectors; i++) {
-		rc = request_irq(ioa_cfg->vectors_info[i].vec,
+		rc = request_irq(pci_irq_vector(pdev, i),
 			ipr_isr_mhrrq,
 			0,
 			ioa_cfg->vectors_info[i].desc,
 			&ioa_cfg->hrrq[i]);
 		if (rc) {
 			while (--i >= 0)
-				free_irq(ioa_cfg->vectors_info[i].vec,
+				free_irq(pci_irq_vector(pdev, i),
 					&ioa_cfg->hrrq[i]);
 			return rc;
 		}
@@ -9900,8 +9850,7 @@ static irqreturn_t ipr_test_intr(int irq, void *devp)
  * ipr_test_msi - Test for Message Signaled Interrupt (MSI) support.
  * @pdev:		PCI device struct
  *
- * Description: The return value from pci_enable_msi_range() can not always be
- * trusted.  This routine sets up and initiates a test interrupt to determine
+ * Description: This routine sets up and initiates a test interrupt to determine
  * if the interrupt is received via the ipr_test_intr() service routine.
  * If the tests fails, the driver will fall back to LSI.
  *
@@ -9913,6 +9862,7 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	int rc;
 	volatile u32 int_reg;
 	unsigned long lock_flags = 0;
+	int irq = pci_irq_vector(pdev, 0);
 
 	ENTER;
 
@@ -9924,15 +9874,12 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	if (ioa_cfg->intr_flag == IPR_USE_MSIX)
-		rc = request_irq(ioa_cfg->vectors_info[0].vec, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
-	else
-		rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
+	rc = request_irq(irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
 	if (rc) {
-		dev_err(&pdev->dev, "Can not assign irq %d\n", pdev->irq);
+		dev_err(&pdev->dev, "Can not assign irq %d\n", irq);
 		return rc;
 	} else if (ipr_debug)
-		dev_info(&pdev->dev, "IRQ assigned: %d\n", pdev->irq);
+		dev_info(&pdev->dev, "IRQ assigned: %d\n", irq);
 
 	writel(IPR_PCII_IO_DEBUG_ACKNOWLEDGE, ioa_cfg->regs.sense_interrupt_reg32);
 	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
@@ -9949,10 +9896,7 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	if (ioa_cfg->intr_flag == IPR_USE_MSIX)
-		free_irq(ioa_cfg->vectors_info[0].vec, ioa_cfg);
-	else
-		free_irq(pdev->irq, ioa_cfg);
+	free_irq(irq, ioa_cfg);
 
 	LEAVE;
 
@@ -9976,6 +9920,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 	int rc = PCIBIOS_SUCCESSFUL;
 	volatile u32 mask, uproc, interrupts;
 	unsigned long lock_flags, driver_lock_flags;
+	unsigned int irq_flag;
 
 	ENTER;
 
@@ -10091,18 +10036,18 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 		ipr_number_of_msix = IPR_MAX_MSIX_VECTORS;
 	}
 
-	if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI &&
-			ipr_enable_msix(ioa_cfg) == 0)
-		ioa_cfg->intr_flag = IPR_USE_MSIX;
-	else if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI &&
-			ipr_enable_msi(ioa_cfg) == 0)
-		ioa_cfg->intr_flag = IPR_USE_MSI;
-	else {
-		ioa_cfg->intr_flag = IPR_USE_LSI;
-		ioa_cfg->clear_isr = 1;
-		ioa_cfg->nvectors = 1;
-		dev_info(&pdev->dev, "Cannot enable MSI.\n");
+	irq_flag = PCI_IRQ_LEGACY;
+	if (ioa_cfg->ipr_chip->has_msi)
+		irq_flag |= PCI_IRQ_MSI | PCI_IRQ_MSIX;
+	rc = pci_alloc_irq_vectors(pdev, 1, ipr_number_of_msix, irq_flag);
+	if (rc < 0) {
+		ipr_wait_for_pci_err_recovery(ioa_cfg);
+		goto cleanup_nomem;
 	}
+	ioa_cfg->nvectors = rc;
+
+	if (!pdev->msi_enabled && !pdev->msix_enabled)
+		ioa_cfg->clear_isr = 1;
 
 	pci_set_master(pdev);
 
@@ -10115,33 +10060,22 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 		}
 	}
 
-	if (ioa_cfg->intr_flag == IPR_USE_MSI ||
-	    ioa_cfg->intr_flag == IPR_USE_MSIX) {
+	if (pdev->msi_enabled || pdev->msix_enabled) {
 		rc = ipr_test_msi(ioa_cfg, pdev);
-		if (rc == -EOPNOTSUPP) {
+		switch (rc) {
+		case 0:
+			dev_info(&pdev->dev,
+				"Request for %d MSI%ss succeeded.", ioa_cfg->nvectors,
+				pdev->msix_enabled ? "-X" : "");
+			break;
+		case -EOPNOTSUPP:
 			ipr_wait_for_pci_err_recovery(ioa_cfg);
-			if (ioa_cfg->intr_flag == IPR_USE_MSI) {
-				ioa_cfg->intr_flag &= ~IPR_USE_MSI;
-				pci_disable_msi(pdev);
-			 } else if (ioa_cfg->intr_flag == IPR_USE_MSIX) {
-				ioa_cfg->intr_flag &= ~IPR_USE_MSIX;
-				pci_disable_msix(pdev);
-			}
+			pci_free_irq_vectors(pdev);
 
-			ioa_cfg->intr_flag = IPR_USE_LSI;
 			ioa_cfg->nvectors = 1;
-		}
-		else if (rc)
+			break;
+		default:
 			goto out_msi_disable;
-		else {
-			if (ioa_cfg->intr_flag == IPR_USE_MSI)
-				dev_info(&pdev->dev,
-					"Request for %d MSIs succeeded with starting IRQ: %d\n",
-					ioa_cfg->nvectors, pdev->irq);
-			else if (ioa_cfg->intr_flag == IPR_USE_MSIX)
-				dev_info(&pdev->dev,
-					"Request for %d MSIXs succeeded.",
-					ioa_cfg->nvectors);
 		}
 	}
 
@@ -10189,15 +10123,13 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 	ipr_mask_and_clear_interrupts(ioa_cfg, ~IPR_PCII_IOA_TRANS_TO_OPER);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	if (ioa_cfg->intr_flag == IPR_USE_MSI
-			|| ioa_cfg->intr_flag == IPR_USE_MSIX) {
+	if (pdev->msi_enabled || pdev->msix_enabled) {
 		name_msi_vectors(ioa_cfg);
-		rc = request_irq(ioa_cfg->vectors_info[0].vec, ipr_isr,
-			0,
+		rc = request_irq(pci_irq_vector(pdev, 0), ipr_isr, 0,
 			ioa_cfg->vectors_info[0].desc,
 			&ioa_cfg->hrrq[0]);
 		if (!rc)
-			rc = ipr_request_other_msi_irqs(ioa_cfg);
+			rc = ipr_request_other_msi_irqs(ioa_cfg, pdev);
 	} else {
 		rc = request_irq(pdev->irq, ipr_isr,
 			 IRQF_SHARED,
@@ -10239,10 +10171,7 @@ cleanup_nolog:
 	ipr_free_mem(ioa_cfg);
 out_msi_disable:
 	ipr_wait_for_pci_err_recovery(ioa_cfg);
-	if (ioa_cfg->intr_flag == IPR_USE_MSI)
-		pci_disable_msi(pdev);
-	else if (ioa_cfg->intr_flag == IPR_USE_MSIX)
-		pci_disable_msix(pdev);
+	pci_free_irq_vectors(pdev);
 cleanup_nomem:
 	iounmap(ipr_regs);
 out_disable:
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index cdb5196..ec4110e 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1411,10 +1411,7 @@ struct ipr_chip_cfg_t {
 struct ipr_chip_t {
 	u16 vendor;
 	u16 device;
-	u16 intr_type;
-#define IPR_USE_LSI			0x00
-#define IPR_USE_MSI			0x01
-#define IPR_USE_MSIX			0x02
+	bool has_msi;
 	u16 sis_type;
 #define IPR_SIS32			0x00
 #define IPR_SIS64			0x01
@@ -1589,11 +1586,9 @@ struct ipr_ioa_cfg {
 	struct ipr_cmnd **ipr_cmnd_list;
 	dma_addr_t *ipr_cmnd_list_dma;
 
-	u16 intr_flag;
 	unsigned int nvectors;
 
 	struct {
-		unsigned short vec;
 		char desc[22];
 	} vectors_info[IPR_MAX_MSIX_VECTORS];
 
-- 
2.1.4

