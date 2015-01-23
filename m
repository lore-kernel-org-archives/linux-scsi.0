From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 07/48] hpsa: rename free_irqs to hpsa_free_irqs
Date: Fri, 23 Jan 2015 16:41:40 -0600
Message-ID: <20150123224140.14919.12478.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30235 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbbAWWme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:34 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Change the function names to have hpsa prefix.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4252b63..dc81d88 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6491,6 +6491,25 @@ static void hpsa_irq_affinity_hints(struct ctlr_info *h)
 	}
 }
 
+/* clear affinity hints and free MSI-X, MSI, or legacy INTx vectors */
+static void hpsa_free_irqs(struct ctlr_info *h)
+{
+	int i;
+
+	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
+		/* Single reply queue, only one irq to free */
+		i = h->intr_mode;
+		irq_set_affinity_hint(h->intr[i], NULL);
+		free_irq(h->intr[i], &h->q[i]);
+		return;
+	}
+
+	for (i = 0; i < h->msix_vector; i++) {
+		irq_set_affinity_hint(h->intr[i], NULL);
+		free_irq(h->intr[i], &h->q[i]);
+	}
+}
+
 static int hpsa_request_irq(struct ctlr_info *h,
 	irqreturn_t (*msixhandler)(int, void *),
 	irqreturn_t (*intxhandler)(int, void *))
@@ -6555,27 +6574,9 @@ static int hpsa_kdump_soft_reset(struct ctlr_info *h)
 	return 0;
 }
 
-static void free_irqs(struct ctlr_info *h)
-{
-	int i;
-
-	if (!h->msix_vector || h->intr_mode != PERF_MODE_INT) {
-		/* Single reply queue, only one irq to free */
-		i = h->intr_mode;
-		irq_set_affinity_hint(h->intr[i], NULL);
-		free_irq(h->intr[i], &h->q[i]);
-		return;
-	}
-
-	for (i = 0; i < h->msix_vector; i++) {
-		irq_set_affinity_hint(h->intr[i], NULL);
-		free_irq(h->intr[i], &h->q[i]);
-	}
-}
-
 static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)
 {
-	free_irqs(h);
+	hpsa_free_irqs(h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector) {
 		if (h->pdev->msix_enabled)
@@ -6937,7 +6938,7 @@ reinit_after_soft_reset:
 		spin_lock_irqsave(&h->lock, flags);
 		h->access.set_intr_mask(h, HPSA_INTR_OFF);
 		spin_unlock_irqrestore(&h->lock, flags);
-		free_irqs(h);
+		hpsa_free_irqs(h);
 		rc = hpsa_request_irq(h, hpsa_msix_discard_completions,
 					hpsa_intx_discard_completions);
 		if (rc) {
@@ -6997,7 +6998,7 @@ reinit_after_soft_reset:
 clean4:
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
-	free_irqs(h);
+	hpsa_free_irqs(h);
 clean2:
 clean1:
 	if (h->lockup_detected)

