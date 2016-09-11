From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] arcmsr: use pci_alloc_irq_vectors
Date: Sun, 11 Sep 2016 15:31:23 +0200
Message-ID: <1473600688-24043-2-git-send-email-hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Switch the arcmsr driver to use pci_alloc_irq_vectors.  We need to two
calls to pci_alloc_irq_vectors as arcmsr only supports multiple MSI-X
vectors, but not multiple MSI vectors.

Otherwise this cleans up a lot of cruft and allows to use a common
request_irq loop for irq types, which happens to only iterate over a
single line in the non MSI-X case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/arcmsr/arcmsr.h     |  5 +--
 drivers/scsi/arcmsr/arcmsr_hba.c | 82 ++++++++++++++++------------------------
 2 files changed, 33 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index cf99f8c..a254b32 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -629,7 +629,6 @@ struct AdapterControlBlock
 	struct pci_dev *		pdev;
 	struct Scsi_Host *		host;
 	unsigned long			vir2phy_offset;
-	struct msix_entry	entries[ARCMST_NUM_MSIX_VECTORS];
 	/* Offset is used in making arc cdb physical to virtual calculations */
 	uint32_t			outbound_int_enable;
 	uint32_t			cdb_phyaddr_hi32;
@@ -671,8 +670,6 @@ struct AdapterControlBlock
 	/* iop init */
 	#define ACB_F_ABORT				0x0200
 	#define ACB_F_FIRMWARE_TRAP           		0x0400
-	#define ACB_F_MSI_ENABLED		0x1000
-	#define ACB_F_MSIX_ENABLED		0x2000
 	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head		ccb_free_list;
@@ -725,7 +722,7 @@ struct AdapterControlBlock
 	atomic_t 			rq_map_token;
 	atomic_t			ante_token_value;
 	uint32_t	maxOutstanding;
-	int		msix_vector_count;
+	int		vector_count;
 };/* HW_DEVICE_EXTENSION */
 /*
 *******************************************************************************
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 7640498..a267327 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -720,51 +720,39 @@ static void arcmsr_message_isr_bh_fn(struct work_struct *work)
 static int
 arcmsr_request_irq(struct pci_dev *pdev, struct AdapterControlBlock *acb)
 {
-	int	i, j, r;
-	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
-
-	for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
-		entries[i].entry = i;
-	r = pci_enable_msix_range(pdev, entries, 1, ARCMST_NUM_MSIX_VECTORS);
-	if (r < 0)
-		goto msi_int;
-	acb->msix_vector_count = r;
-	for (i = 0; i < r; i++) {
-		if (request_irq(entries[i].vector,
-			arcmsr_do_interrupt, 0, "arcmsr", acb)) {
+	unsigned long flags;
+	int nvec, i;
+
+	nvec = pci_alloc_irq_vectors(pdev, 1, ARCMST_NUM_MSIX_VECTORS,
+			PCI_IRQ_MSIX);
+	if (nvec > 0) {
+		pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
+		flags = 0;
+	} else {
+		nvec = pci_alloc_irq_vectors(pdev, 1, 1,
+				PCI_IRQ_MSI | PCI_IRQ_LEGACY);
+		if (nvec < 1)
+			return FAILED;
+
+		flags = IRQF_SHARED;
+	}
+
+	acb->vector_count = nvec;
+	for (i = 0; i < nvec; i++) {
+		if (request_irq(pci_irq_vector(pdev, i), arcmsr_do_interrupt,
+				flags, "arcmsr", acb)) {
 			pr_warn("arcmsr%d: request_irq =%d failed!\n",
-				acb->host->host_no, entries[i].vector);
-			for (j = 0 ; j < i ; j++)
-				free_irq(entries[j].vector, acb);
-			pci_disable_msix(pdev);
-			goto msi_int;
+				acb->host->host_no, pci_irq_vector(pdev, i));
+			goto out_free_irq;
 		}
-		acb->entries[i] = entries[i];
-	}
-	acb->acb_flags |= ACB_F_MSIX_ENABLED;
-	pr_info("arcmsr%d: msi-x enabled\n", acb->host->host_no);
-	return SUCCESS;
-msi_int:
-	if (pci_enable_msi_exact(pdev, 1) < 0)
-		goto legacy_int;
-	if (request_irq(pdev->irq, arcmsr_do_interrupt,
-		IRQF_SHARED, "arcmsr", acb)) {
-		pr_warn("arcmsr%d: request_irq =%d failed!\n",
-			acb->host->host_no, pdev->irq);
-		pci_disable_msi(pdev);
-		goto legacy_int;
-	}
-	acb->acb_flags |= ACB_F_MSI_ENABLED;
-	pr_info("arcmsr%d: msi enabled\n", acb->host->host_no);
-	return SUCCESS;
-legacy_int:
-	if (request_irq(pdev->irq, arcmsr_do_interrupt,
-		IRQF_SHARED, "arcmsr", acb)) {
-		pr_warn("arcmsr%d: request_irq = %d failed!\n",
-			acb->host->host_no, pdev->irq);
-		return FAILED;
 	}
+
 	return SUCCESS;
+out_free_irq:
+	while (--i >= 0)
+		free_irq(pci_irq_vector(pdev, i), acb);
+	pci_free_irq_vectors(pdev);
+	return FAILED;
 }
 
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -886,15 +874,9 @@ static void arcmsr_free_irq(struct pci_dev *pdev,
 {
 	int i;
 
-	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
-		free_irq(pdev->irq, acb);
-		pci_disable_msi(pdev);
-	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
-		for (i = 0; i < acb->msix_vector_count; i++)
-			free_irq(acb->entries[i].vector, acb);
-		pci_disable_msix(pdev);
-	} else
-		free_irq(pdev->irq, acb);
+	for (i = 0; i < acb->vector_count; i++)
+		free_irq(pci_irq_vector(pdev, i), acb);
+	pci_free_irq_vectors(pdev);
 }
 
 static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
-- 
2.1.4
