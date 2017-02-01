From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] snic: switch to pci_irq_alloc_vectors
Date: Wed,  1 Feb 2017 15:21:21 +0100
Message-ID: <1485958881-17367-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51866 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdBAOVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2017 09:21:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kartilak@cisco.com, sebaddel@cisco.com
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/snic/snic.h     |  1 -
 drivers/scsi/snic/snic_isr.c | 48 ++++++++++++++++++--------------------------
 2 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 8ed778d..de0ab5f 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -299,7 +299,6 @@ struct snic {
 
 	/* pci related */
 	struct pci_dev *pdev;
-	struct msix_entry msix_entry[SNIC_MSIX_INTR_MAX];
 	struct snic_msix_entry msix[SNIC_MSIX_INTR_MAX];
 
 	/* io related info */
diff --git a/drivers/scsi/snic/snic_isr.c b/drivers/scsi/snic/snic_isr.c
index f552003..d859501 100644
--- a/drivers/scsi/snic/snic_isr.c
+++ b/drivers/scsi/snic/snic_isr.c
@@ -93,7 +93,7 @@ snic_free_intr(struct snic *snic)
 	/* ONLY interrupt mode MSIX is supported */
 	for (i = 0; i < ARRAY_SIZE(snic->msix); i++) {
 		if (snic->msix[i].requested) {
-			free_irq(snic->msix_entry[i].vector,
+			free_irq(pci_irq_vector(snic->pdev, i),
 				 snic->msix[i].devid);
 		}
 	}
@@ -134,7 +134,7 @@ snic_request_intr(struct snic *snic)
 	snic->msix[SNIC_MSIX_ERR_NOTIFY].devid = snic;
 
 	for (i = 0; i < ARRAY_SIZE(snic->msix); i++) {
-		ret = request_irq(snic->msix_entry[i].vector,
+		ret = request_irq(pci_irq_vector(snic->pdev, i),
 				  snic->msix[i].isr,
 				  0,
 				  snic->msix[i].devname,
@@ -158,47 +158,37 @@ snic_set_intr_mode(struct snic *snic)
 {
 	unsigned int n = ARRAY_SIZE(snic->wq);
 	unsigned int m = SNIC_CQ_IO_CMPL_MAX;
-	unsigned int i;
+	unsigned int vecs = n + m + 1;
 
 	/*
 	 * We need n WQs, m CQs, and n+m+1 INTRs
 	 * (last INTR is used for WQ/CQ errors and notification area
 	 */
-
 	BUILD_BUG_ON((ARRAY_SIZE(snic->wq) + SNIC_CQ_IO_CMPL_MAX) >
 			ARRAY_SIZE(snic->intr));
-	SNIC_BUG_ON(ARRAY_SIZE(snic->msix_entry) < (n + m + 1));
-
-	for (i = 0; i < (n + m + 1); i++)
-		snic->msix_entry[i].entry = i;
-
-	if (snic->wq_count >= n && snic->cq_count >= (n + m)) {
-		if (!pci_enable_msix(snic->pdev,
-				     snic->msix_entry,
-				     (n + m + 1))) {
-			snic->wq_count = n;
-			snic->cq_count = n + m;
-			snic->intr_count = n + m + 1;
-			snic->err_intr_offset = SNIC_MSIX_ERR_NOTIFY;
-
-			SNIC_ISR_DBG(snic->shost,
-				     "Using MSI-X Interrupts\n");
-			svnic_dev_set_intr_mode(snic->vdev,
-						VNIC_DEV_INTR_MODE_MSIX);
-
-			return 0;
-		}
-	}
 
-	svnic_dev_set_intr_mode(snic->vdev, VNIC_DEV_INTR_MODE_UNKNOWN);
+	if (snic->wq_count < n || snic->cq_count < n + m)
+		goto fail;
 
+	if (pci_alloc_irq_vectors(snic->pdev, vecs, vecs, PCI_IRQ_MSIX) < 0)
+		goto fail;
+
+	snic->wq_count = n;
+	snic->cq_count = n + m;
+	snic->intr_count = vecs;
+	snic->err_intr_offset = SNIC_MSIX_ERR_NOTIFY;
+
+	SNIC_ISR_DBG(snic->shost, "Using MSI-X Interrupts\n");
+	svnic_dev_set_intr_mode(snic->vdev, VNIC_DEV_INTR_MODE_MSIX);
+	return 0;
+fail:
+	svnic_dev_set_intr_mode(snic->vdev, VNIC_DEV_INTR_MODE_UNKNOWN);
 	return -EINVAL;
 } /* end of snic_set_intr_mode */
 
 void
 snic_clear_intr_mode(struct snic *snic)
 {
-	pci_disable_msix(snic->pdev);
-
+	pci_free_irq_vectors(snic->pdev);
 	svnic_dev_set_intr_mode(snic->vdev, VNIC_DEV_INTR_MODE_INTX);
 }
-- 
2.1.4
