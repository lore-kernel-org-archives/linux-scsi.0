From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] hpsa: use pci_alloc_irq_vectors and automatic irq affinity
Date: Wed,  9 Nov 2016 10:42:22 -0800
Message-ID: <1478716942-6335-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37787 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbcKISmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 13:42:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org

This patch converts over hpsa to use the pci_alloc_irq_vectors including
the PCI_IRQ_AFFINITY flag that automatically assigns spread out
irq affinity to the I/O queues.

It also cleans up the per-ctrl interrupt state due to the use of the
pci_irq_vector and pci_free_irq_vectors helpers that don't need to know
the exact irq type.  Additionally it changes a little oddity in the
existing code that was using different array indixes into the per-vector
arrays depending on wether a controller is using a single INTx or single
MSI irq.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hpsa.c | 143 ++++++++++++++++++----------------------------------
 drivers/scsi/hpsa.h |   6 +--
 2 files changed, 52 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d007ec1..dce8f80 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1001,7 +1001,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c,
 {
 	if (likely(h->transMethod & CFGTBL_Trans_Performant)) {
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
-		if (unlikely(!h->msix_vector))
+		if (unlikely(!h->msix_vectors))
 			return;
 		if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
 			c->Header.ReplyQueue =
@@ -5618,7 +5618,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->sg_tablesize = h->maxsgentries;
 	sh->transportt = hpsa_sas_transport_template;
 	sh->hostdata[0] = (unsigned long) h;
-	sh->irq = h->intr[h->intr_mode];
+	sh->irq = pci_irq_vector(h->pdev, 0);
 	sh->unique_id = sh->irq;
 
 	h->scsi_host = sh;
@@ -7652,67 +7652,41 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 
 static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
 {
-	if (h->msix_vector) {
-		if (h->pdev->msix_enabled)
-			pci_disable_msix(h->pdev);
-		h->msix_vector = 0;
-	} else if (h->msi_vector) {
-		if (h->pdev->msi_enabled)
-			pci_disable_msi(h->pdev);
-		h->msi_vector = 0;
-	}
+	pci_free_irq_vectors(h->pdev);
+	h->msix_vectors = 0;
 }
 
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
  * controllers that are capable. If not, we use legacy INTx mode.
  */
-static void hpsa_interrupt_mode(struct ctlr_info *h)
+static int hpsa_interrupt_mode(struct ctlr_info *h)
 {
-#ifdef CONFIG_PCI_MSI
-	int err, i;
-	struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
-
-	for (i = 0; i < MAX_REPLY_QUEUES; i++) {
-		hpsa_msix_entries[i].vector = 0;
-		hpsa_msix_entries[i].entry = i;
-	}
+	unsigned int flags = PCI_IRQ_LEGACY;
+	int ret;
 
 	/* Some boards advertise MSI but don't really support it */
-	if ((h->board_id == 0x40700E11) || (h->board_id == 0x40800E11) ||
-	    (h->board_id == 0x40820E11) || (h->board_id == 0x40830E11))
-		goto default_int_mode;
-	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
-		dev_info(&h->pdev->dev, "MSI-X capable controller\n");
-		h->msix_vector = MAX_REPLY_QUEUES;
-		if (h->msix_vector > num_online_cpus())
-			h->msix_vector = num_online_cpus();
-		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
-					    1, h->msix_vector);
-		if (err < 0) {
-			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
-			h->msix_vector = 0;
-			goto single_msi_mode;
-		} else if (err < h->msix_vector) {
-			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
-			       "available\n", err);
+	switch (h->board_id) {
+	case 0x40700E11:
+	case 0x40800E11:
+	case 0x40820E11:
+	case 0x40830E11:
+		break;
+	default:
+		ret = pci_alloc_irq_vectors(h->pdev, 1, MAX_REPLY_QUEUES,
+				PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+		if (ret > 0) {
+			h->msix_vectors = ret;
+			return 0;
 		}
-		h->msix_vector = err;
-		for (i = 0; i < h->msix_vector; i++)
-			h->intr[i] = hpsa_msix_entries[i].vector;
-		return;
-	}
-single_msi_mode:
-	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
-		dev_info(&h->pdev->dev, "MSI capable controller\n");
-		if (!pci_enable_msi(h->pdev))
-			h->msi_vector = 1;
-		else
-			dev_warn(&h->pdev->dev, "MSI init failed\n");
+
+		flags |= PCI_IRQ_MSI;
+		break;
 	}
-default_int_mode:
-#endif				/* CONFIG_PCI_MSI */
-	/* if we get here we're going to use the default interrupt mode */
-	h->intr[h->intr_mode] = h->pdev->irq;
+
+	ret = pci_alloc_irq_vectors(h->pdev, 1, 1, flags);
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
@@ -8068,7 +8042,9 @@ static int hpsa_pci_init(struct ctlr_info *h)
 
 	pci_set_master(h->pdev);
 
-	hpsa_interrupt_mode(h);
+	err = hpsa_interrupt_mode(h);
+	if (err)
+		goto clean1;
 	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
 		goto clean2;	/* intmode+region, pci */
@@ -8104,6 +8080,7 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	h->vaddr = NULL;
 clean2:	/* intmode+region, pci */
 	hpsa_disable_interrupt_mode(h);
+clean1:
 	/*
 	 * call pci_disable_device before pci_release_regions per
 	 * Documentation/PCI/pci.txt
@@ -8237,34 +8214,20 @@ static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
 	return -ENOMEM;
 }
 
-static void hpsa_irq_affinity_hints(struct ctlr_info *h)
-{
-	int i, cpu;
-
-	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < h->msix_vector; i++) {
-		irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
-		cpu = cpumask_next(cpu, cpu_online_mask);
-	}
-}
-
 /* clear affinity hints and free MSI-X, MSI, or legacy INTx vectors */
 static void hpsa_free_irqs(struct ctlr_info *h)
 {
 	int i;
 
-	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
+	if (!h->msix_vectors || h->intr_mode != PERF_MODE_INT) {
 		/* Single reply queue, only one irq to free */
-		i = h->intr_mode;
-		irq_set_affinity_hint(h->intr[i], NULL);
-		free_irq(h->intr[i], &h->q[i]);
-		h->q[i] = 0;
+		free_irq(pci_irq_vector(h->pdev, 0), &h->q[i]);
+		h->q[h->intr_mode] = 0;
 		return;
 	}
 
-	for (i = 0; i < h->msix_vector; i++) {
-		irq_set_affinity_hint(h->intr[i], NULL);
-		free_irq(h->intr[i], &h->q[i]);
+	for (i = 0; i < h->msix_vectors; i++) {
+		free_irq(pci_irq_vector(h->pdev, i), &h->q[i]);
 		h->q[i] = 0;
 	}
 	for (; i < MAX_REPLY_QUEUES; i++)
@@ -8285,11 +8248,11 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 	for (i = 0; i < MAX_REPLY_QUEUES; i++)
 		h->q[i] = (u8) i;
 
-	if (h->intr_mode == PERF_MODE_INT && h->msix_vector > 0) {
+	if (h->intr_mode == PERF_MODE_INT && h->msix_vectors > 0) {
 		/* If performant mode and MSI-X, use multiple reply queues */
-		for (i = 0; i < h->msix_vector; i++) {
+		for (i = 0; i < h->msix_vectors; i++) {
 			sprintf(h->intrname[i], "%s-msix%d", h->devname, i);
-			rc = request_irq(h->intr[i], msixhandler,
+			rc = request_irq(pci_irq_vector(h->pdev, i), msixhandler,
 					0, h->intrname[i],
 					&h->q[i]);
 			if (rc) {
@@ -8297,9 +8260,9 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 
 				dev_err(&h->pdev->dev,
 					"failed to get irq %d for %s\n",
-				       h->intr[i], h->devname);
+				       pci_irq_vector(h->pdev, i), h->devname);
 				for (j = 0; j < i; j++) {
-					free_irq(h->intr[j], &h->q[j]);
+					free_irq(pci_irq_vector(h->pdev, j), &h->q[j]);
 					h->q[j] = 0;
 				}
 				for (; j < MAX_REPLY_QUEUES; j++)
@@ -8307,33 +8270,27 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 				return rc;
 			}
 		}
-		hpsa_irq_affinity_hints(h);
 	} else {
 		/* Use single reply pool */
-		if (h->msix_vector > 0 || h->msi_vector) {
-			if (h->msix_vector)
-				sprintf(h->intrname[h->intr_mode],
-					"%s-msix", h->devname);
-			else
-				sprintf(h->intrname[h->intr_mode],
-					"%s-msi", h->devname);
-			rc = request_irq(h->intr[h->intr_mode],
+		if (h->msix_vectors > 0 || h->pdev->msi_enabled) {
+			sprintf(h->intrname[0], "%s-msi%s", h->devname,
+				h->msix_vectors ? "x" : "");
+			rc = request_irq(pci_irq_vector(h->pdev, 0),
 				msixhandler, 0,
-				h->intrname[h->intr_mode],
+				h->intrname[0],
 				&h->q[h->intr_mode]);
 		} else {
 			sprintf(h->intrname[h->intr_mode],
 				"%s-intx", h->devname);
-			rc = request_irq(h->intr[h->intr_mode],
+			rc = request_irq(pci_irq_vector(h->pdev, 0),
 				intxhandler, IRQF_SHARED,
-				h->intrname[h->intr_mode],
+				h->intrname[0],
 				&h->q[h->intr_mode]);
 		}
-		irq_set_affinity_hint(h->intr[h->intr_mode], NULL);
 	}
 	if (rc) {
 		dev_err(&h->pdev->dev, "failed to get irq %d for %s\n",
-		       h->intr[h->intr_mode], h->devname);
+		       pci_irq_vector(h->pdev, 0), h->devname);
 		hpsa_free_irqs(h);
 		return -ENODEV;
 	}
@@ -9519,7 +9476,7 @@ static int hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 			return rc;
 	}
 
-	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
+	h->nreply_queues = h->msix_vectors > 0 ? h->msix_vectors : 1;
 	hpsa_get_max_perf_mode_cmds(h);
 	/* Performant mode ring buffer and supporting data structures */
 	h->reply_queue_size = h->max_commands * sizeof(u64);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 82cdfad..3faf6cf 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -175,9 +175,7 @@ struct ctlr_info {
 #	define DOORBELL_INT	1
 #	define SIMPLE_MODE_INT	2
 #	define MEMQ_MODE_INT	3
-	unsigned int intr[MAX_REPLY_QUEUES];
-	unsigned int msix_vector;
-	unsigned int msi_vector;
+	unsigned int msix_vectors;
 	int intr_mode; /* either PERF_MODE_INT or SIMPLE_MODE_INT */
 	struct access_method access;
 
@@ -464,7 +462,7 @@ static unsigned long SA5_performant_completed(struct ctlr_info *h, u8 q)
 	unsigned long register_value = FIFO_EMPTY;
 
 	/* msi auto clears the interrupt pending bit. */
-	if (unlikely(!(h->msi_vector || h->msix_vector))) {
+	if (unlikely(!(h->pdev->msi_enabled || h->msix_vectors))) {
 		/* flush the controller write of the reply queue by reading
 		 * outbound doorbell status register.
 		 */
-- 
2.1.4

