From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] pmcraid: switch to pci_alloc_irq_vectors
Date: Fri, 18 Nov 2016 07:28:16 +0100
Message-ID: <1479450496-14331-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbcKRG22 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 01:28:28 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c7cew-0005GZ-Se
        for linux-scsi@vger.kernel.org; Fri, 18 Nov 2016 06:28:27 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/pmcraid.c | 92 ++++++++++++++++++++++----------------------------
 drivers/scsi/pmcraid.h |  1 -
 2 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 68a5c34..b517642 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4590,16 +4590,14 @@ static void pmcraid_tasklet_function(unsigned long instance)
 static
 void pmcraid_unregister_interrupt_handler(struct pmcraid_instance *pinstance)
 {
+	struct pci_dev *pdev = pinstance->pdev;
 	int i;
 
 	for (i = 0; i < pinstance->num_hrrq; i++)
-		free_irq(pinstance->hrrq_vector[i].vector,
-			 &(pinstance->hrrq_vector[i]));
+		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 
-	if (pinstance->interrupt_mode) {
-		pci_disable_msix(pinstance->pdev);
-		pinstance->interrupt_mode = 0;
-	}
+	pinstance->interrupt_mode = 0;
+	pci_free_irq_vectors(pdev);
 }
 
 /**
@@ -4612,60 +4610,52 @@ void pmcraid_unregister_interrupt_handler(struct pmcraid_instance *pinstance)
 static int
 pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 {
-	int rc;
 	struct pci_dev *pdev = pinstance->pdev;
+	unsigned int irq_flag = PCI_IRQ_LEGACY, flag;
+	int num_hrrq, rc, i;
+	irq_handler_t isr;
 
-	if ((pmcraid_enable_msix) &&
-		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {
-		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
-		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
-		int i;
-		for (i = 0; i < PMCRAID_NUM_MSIX_VECTORS; i++)
-			entries[i].entry = i;
-
-		num_hrrq = pci_enable_msix_range(pdev, entries, 1, num_hrrq);
-		if (num_hrrq < 0)
-			goto pmcraid_isr_legacy;
-
-		for (i = 0; i < num_hrrq; i++) {
-			pinstance->hrrq_vector[i].hrrq_id = i;
-			pinstance->hrrq_vector[i].drv_inst = pinstance;
-			pinstance->hrrq_vector[i].vector = entries[i].vector;
-			rc = request_irq(pinstance->hrrq_vector[i].vector,
-					pmcraid_isr_msix, 0,
-					PMCRAID_DRIVER_NAME,
-					&(pinstance->hrrq_vector[i]));
-
-			if (rc) {
-				int j;
-				for (j = 0; j < i; j++)
-					free_irq(entries[j].vector,
-						 &(pinstance->hrrq_vector[j]));
-				pci_disable_msix(pdev);
-				goto pmcraid_isr_legacy;
-			}
-		}
+	if (pmcraid_enable_msix)
+		irq_flag |= PCI_IRQ_MSIX;
 
-		pinstance->num_hrrq = num_hrrq;
+	num_hrrq = pci_alloc_irq_vectors(pdev, 1, PMCRAID_NUM_MSIX_VECTORS,
+			irq_flag);
+	if (num_hrrq < 0)
+		return num_hrrq;
+
+	if (pdev->msix_enabled) {
+		flag = 0;
+		isr = pmcraid_isr_msix;
+	} else {
+		flag = IRQF_SHARED;
+		isr = pmcraid_isr;
+	}
+
+	for (i = 0; i < num_hrrq; i++) {
+		struct pmcraid_isr_param *vec = &pinstance->hrrq_vector[i];
+
+		vec->hrrq_id = i;
+		vec->drv_inst = pinstance;
+		rc = request_irq(pci_irq_vector(pdev, i), isr, flag,
+				PMCRAID_DRIVER_NAME, vec);
+		if (rc)
+			goto out_unwind;
+	}
+
+	pinstance->num_hrrq = num_hrrq;
+	if (pdev->msix_enabled) {
 		pinstance->interrupt_mode = 1;
 		iowrite32(DOORBELL_INTR_MODE_MSIX,
 			  pinstance->int_regs.host_ioa_interrupt_reg);
 		ioread32(pinstance->int_regs.host_ioa_interrupt_reg);
-		goto pmcraid_isr_out;
 	}
 
-pmcraid_isr_legacy:
-	/* If MSI-X registration failed fallback to legacy mode, where
-	 * only one hrrq entry will be used
-	 */
-	pinstance->hrrq_vector[0].hrrq_id = 0;
-	pinstance->hrrq_vector[0].drv_inst = pinstance;
-	pinstance->hrrq_vector[0].vector = pdev->irq;
-	pinstance->num_hrrq = 1;
-
-	rc = request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
-			 PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);
-pmcraid_isr_out:
+	return 0;
+
+out_unwind:
+	while (--i > 0)
+		free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
+	pci_free_irq_vectors(pdev);
 	return rc;
 }
 
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index e1d150f..568b18a 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -628,7 +628,6 @@ struct pmcraid_interrupts {
 /* ISR parameters LLD allocates (one for each MSI-X if enabled) vectors */
 struct pmcraid_isr_param {
 	struct pmcraid_instance *drv_inst;
-	u16 vector;			/* allocated msi-x vector */
 	u8 hrrq_id;			/* hrrq entry index */
 };
 
-- 
2.1.4

