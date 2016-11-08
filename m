From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Tue,  8 Nov 2016 08:12:25 +0100
Message-ID: <1478589145-74280-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43447 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbcKHHMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 02:12:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

Use pci_alloc_irq_vectors and drop the hand-crafted
interrupt affinity routines.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c | 72 +++++++++++++++++++----------------------------------
 drivers/scsi/hpsa.h |  1 -
 2 files changed, 26 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4e82b69..104e699 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5618,7 +5618,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 	sh->sg_tablesize = h->maxsgentries;
 	sh->transportt = hpsa_sas_transport_template;
 	sh->hostdata[0] = (unsigned long) h;
-	sh->irq = h->intr[h->intr_mode];
+	sh->irq = pci_irq_vector(h->pdev, h->intr_mode);
 	sh->unique_id = sh->irq;
 
 	h->scsi_host = sh;
@@ -7667,14 +7667,9 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
  */
 static void hpsa_interrupt_mode(struct ctlr_info *h)
 {
+	unsigned int irq_flags = PCI_IRQ_LEGACY;
 #ifdef CONFIG_PCI_MSI
-	int err, i;
-	struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
-
-	for (i = 0; i < MAX_REPLY_QUEUES; i++) {
-		hpsa_msix_entries[i].vector = 0;
-		hpsa_msix_entries[i].entry = i;
-	}
+	int err;
 
 	/* Some boards advertise MSI but don't really support it */
 	if ((h->board_id == 0x40700E11) || (h->board_id == 0x40800E11) ||
@@ -7685,8 +7680,8 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		h->msix_vector = MAX_REPLY_QUEUES;
 		if (h->msix_vector > num_online_cpus())
 			h->msix_vector = num_online_cpus();
-		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
-					    1, h->msix_vector);
+		err = pci_alloc_irq_vectors(h->pdev, 1, h->msix_vector,
+					    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 		if (err < 0) {
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
 			h->msix_vector = 0;
@@ -7696,22 +7691,21 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 			       "available\n", err);
 		}
 		h->msix_vector = err;
-		for (i = 0; i < h->msix_vector; i++)
-			h->intr[i] = hpsa_msix_entries[i].vector;
 		return;
 	}
 single_msi_mode:
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
 		dev_info(&h->pdev->dev, "MSI capable controller\n");
-		if (!pci_enable_msi(h->pdev))
+		if (!pci_enable_msi(h->pdev)) {
 			h->msi_vector = 1;
-		else
+			irq_flags = PCI_IRQ_MSI;
+		} else
 			dev_warn(&h->pdev->dev, "MSI init failed\n");
 	}
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	h->intr[h->intr_mode] = h->pdev->irq;
+	pci_alloc_irq_vectors(h->pdev, 1, 1, irq_flags);
 }
 
 static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
@@ -8236,17 +8230,6 @@ static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
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
@@ -8255,15 +8238,13 @@ static void hpsa_free_irqs(struct ctlr_info *h)
 	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
 		/* Single reply queue, only one irq to free */
 		i = h->intr_mode;
-		irq_set_affinity_hint(h->intr[i], NULL);
-		free_irq(h->intr[i], &h->q[i]);
+		free_irq(pci_irq_vector(h->pdev, i), &h->q[i]);
 		h->q[i] = 0;
 		return;
 	}
 
 	for (i = 0; i < h->msix_vector; i++) {
-		irq_set_affinity_hint(h->intr[i], NULL);
-		free_irq(h->intr[i], &h->q[i]);
+		free_irq(pci_irq_vector(h->pdev, i), &h->q[i]);
 		h->q[i] = 0;
 	}
 	for (; i < MAX_REPLY_QUEUES; i++)
@@ -8288,17 +8269,18 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 		/* If performant mode and MSI-X, use multiple reply queues */
 		for (i = 0; i < h->msix_vector; i++) {
 			sprintf(h->intrname[i], "%s-msix%d", h->devname, i);
-			rc = request_irq(h->intr[i], msixhandler,
-					0, h->intrname[i],
-					&h->q[i]);
+			rc = request_irq(pci_irq_vector(h->pdev, i),
+					 msixhandler, 0, h->intrname[i],
+					 &h->q[i]);
 			if (rc) {
 				int j;
 
 				dev_err(&h->pdev->dev,
 					"failed to get irq %d for %s\n",
-				       h->intr[i], h->devname);
+					pci_irq_vector(h->pdev, i), h->devname);
 				for (j = 0; j < i; j++) {
-					free_irq(h->intr[j], &h->q[j]);
+					free_irq(pci_irq_vector(h->pdev, i),
+						 &h->q[j]);
 					h->q[j] = 0;
 				}
 				for (; j < MAX_REPLY_QUEUES; j++)
@@ -8306,7 +8288,6 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 				return rc;
 			}
 		}
-		hpsa_irq_affinity_hints(h);
 	} else {
 		/* Use single reply pool */
 		if (h->msix_vector > 0 || h->msi_vector) {
@@ -8316,23 +8297,22 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 			else
 				sprintf(h->intrname[h->intr_mode],
 					"%s-msi", h->devname);
-			rc = request_irq(h->intr[h->intr_mode],
-				msixhandler, 0,
-				h->intrname[h->intr_mode],
-				&h->q[h->intr_mode]);
+			rc = request_irq(pci_irq_vector(h->pdev, h->intr_mode),
+					 msixhandler, 0,
+					 h->intrname[h->intr_mode],
+					 &h->q[h->intr_mode]);
 		} else {
 			sprintf(h->intrname[h->intr_mode],
 				"%s-intx", h->devname);
-			rc = request_irq(h->intr[h->intr_mode],
-				intxhandler, IRQF_SHARED,
-				h->intrname[h->intr_mode],
-				&h->q[h->intr_mode]);
+			rc = request_irq(pci_irq_vector(h->pdev, h->intr_mode),
+					 intxhandler, IRQF_SHARED,
+					 h->intrname[h->intr_mode],
+					 &h->q[h->intr_mode]);
 		}
-		irq_set_affinity_hint(h->intr[h->intr_mode], NULL);
 	}
 	if (rc) {
 		dev_err(&h->pdev->dev, "failed to get irq %d for %s\n",
-		       h->intr[h->intr_mode], h->devname);
+			pci_irq_vector(h->pdev, h->intr_mode), h->devname);
 		hpsa_free_irqs(h);
 		return -ENODEV;
 	}
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 82cdfad..a10a24c 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -175,7 +175,6 @@ struct ctlr_info {
 #	define DOORBELL_INT	1
 #	define SIMPLE_MODE_INT	2
 #	define MEMQ_MODE_INT	3
-	unsigned int intr[MAX_REPLY_QUEUES];
 	unsigned int msix_vector;
 	unsigned int msi_vector;
 	int intr_mode; /* either PERF_MODE_INT or SIMPLE_MODE_INT */
-- 
1.8.5.6

