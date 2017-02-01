From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fnic: switch to pci_alloc_irq_vectors
Date: Wed,  1 Feb 2017 15:02:53 +0100
Message-ID: <1485957773-12133-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56057 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdBAOC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 09:02:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com
Cc: linux-scsi@vger.kernel.org

Not a full cleanup for the IRQ code, for that we'd need to know if the
max number of the various CQ types is going to stay 1 forever.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/fnic/fnic.h     |  1 -
 drivers/scsi/fnic/fnic_isr.c | 41 +++++++++++++----------------------------
 2 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 9ddc920..cb59d82 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -217,7 +217,6 @@ struct fnic {
 	struct fcoe_ctlr ctlr;		/* FIP FCoE controller structure */
 	struct vnic_dev_bar bar0;
 
-	struct msix_entry msix_entry[FNIC_MSIX_INTR_MAX];
 	struct fnic_msix_entry msix[FNIC_MSIX_INTR_MAX];
 
 	struct vnic_stats *stats;
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index a0dd1b6..4e3a502 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -154,13 +154,13 @@ void fnic_free_intr(struct fnic *fnic)
 	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
 	case VNIC_DEV_INTR_MODE_INTX:
 	case VNIC_DEV_INTR_MODE_MSI:
-		free_irq(fnic->pdev->irq, fnic);
+		free_irq(pci_irq_vector(fnic->pdev, 0), fnic);
 		break;
 
 	case VNIC_DEV_INTR_MODE_MSIX:
 		for (i = 0; i < ARRAY_SIZE(fnic->msix); i++)
 			if (fnic->msix[i].requested)
-				free_irq(fnic->msix_entry[i].vector,
+				free_irq(pci_irq_vector(fnic->pdev, i),
 					 fnic->msix[i].devid);
 		break;
 
@@ -177,12 +177,12 @@ int fnic_request_intr(struct fnic *fnic)
 	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
 
 	case VNIC_DEV_INTR_MODE_INTX:
-		err = request_irq(fnic->pdev->irq, &fnic_isr_legacy,
-				  IRQF_SHARED, DRV_NAME, fnic);
+		err = request_irq(pci_irq_vector(fnic->pdev, 0),
+				&fnic_isr_legacy, IRQF_SHARED, DRV_NAME, fnic);
 		break;
 
 	case VNIC_DEV_INTR_MODE_MSI:
-		err = request_irq(fnic->pdev->irq, &fnic_isr_msi,
+		err = request_irq(pci_irq_vector(fnic->pdev, 0), &fnic_isr_msi,
 				  0, fnic->name, fnic);
 		break;
 
@@ -210,7 +210,7 @@ int fnic_request_intr(struct fnic *fnic)
 		fnic->msix[FNIC_MSIX_ERR_NOTIFY].devid = fnic;
 
 		for (i = 0; i < ARRAY_SIZE(fnic->msix); i++) {
-			err = request_irq(fnic->msix_entry[i].vector,
+			err = request_irq(pci_irq_vector(fnic->pdev, i),
 					  fnic->msix[i].isr, 0,
 					  fnic->msix[i].devname,
 					  fnic->msix[i].devid);
@@ -237,7 +237,6 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	unsigned int n = ARRAY_SIZE(fnic->rq);
 	unsigned int m = ARRAY_SIZE(fnic->wq);
 	unsigned int o = ARRAY_SIZE(fnic->wq_copy);
-	unsigned int i;
 
 	/*
 	 * Set interrupt mode (INTx, MSI, MSI-X) depending
@@ -248,23 +247,20 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
 	 * (last INTR is used for WQ/RQ errors and notification area)
 	 */
-
-	BUG_ON(ARRAY_SIZE(fnic->msix_entry) < n + m + o + 1);
-	for (i = 0; i < n + m + o + 1; i++)
-		fnic->msix_entry[i].entry = i;
-
 	if (fnic->rq_count >= n &&
 	    fnic->raw_wq_count >= m &&
 	    fnic->wq_copy_count >= o &&
 	    fnic->cq_count >= n + m + o) {
-		if (!pci_enable_msix_exact(fnic->pdev, fnic->msix_entry,
-					   n + m + o + 1)) {
+		int vecs = n + m + o + 1;
+
+		if (pci_alloc_irq_vectors(fnic->pdev, vecs, vecs,
+				PCI_IRQ_MSIX) < 0) {
 			fnic->rq_count = n;
 			fnic->raw_wq_count = m;
 			fnic->wq_copy_count = o;
 			fnic->wq_count = m + o;
 			fnic->cq_count = n + m + o;
-			fnic->intr_count = n + m + o + 1;
+			fnic->intr_count = vecs;
 			fnic->err_intr_offset = FNIC_MSIX_ERR_NOTIFY;
 
 			FNIC_ISR_DBG(KERN_DEBUG, fnic->lport->host,
@@ -284,8 +280,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	    fnic->wq_copy_count >= 1 &&
 	    fnic->cq_count >= 3 &&
 	    fnic->intr_count >= 1 &&
-	    !pci_enable_msi(fnic->pdev)) {
-
+	    pci_alloc_irq_vectors(fnic->pdev, 1, 1, PCI_IRQ_MSI) < 0) {
 		fnic->rq_count = 1;
 		fnic->raw_wq_count = 1;
 		fnic->wq_copy_count = 1;
@@ -334,17 +329,7 @@ int fnic_set_intr_mode(struct fnic *fnic)
 
 void fnic_clear_intr_mode(struct fnic *fnic)
 {
-	switch (vnic_dev_get_intr_mode(fnic->vdev)) {
-	case VNIC_DEV_INTR_MODE_MSIX:
-		pci_disable_msix(fnic->pdev);
-		break;
-	case VNIC_DEV_INTR_MODE_MSI:
-		pci_disable_msi(fnic->pdev);
-		break;
-	default:
-		break;
-	}
-
+	pci_free_irq_vectors(fnic->pdev);
 	vnic_dev_set_intr_mode(fnic->vdev, VNIC_DEV_INTR_MODE_INTX);
 }
 
-- 
2.1.4
