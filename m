From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 17/48] hpsa: rename hpsa_request_irq to hpsa_request_irqs
Date: Fri, 23 Jan 2015 16:42:32 -0600
Message-ID: <20150123224232.14919.60547.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30499 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbAWWn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:26 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Make the function name more descriptive. We use more than
one interrupt.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 354e7f8..f29f569 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6526,7 +6526,8 @@ static void hpsa_free_irqs(struct ctlr_info *h)
 		h->q[i] = 0;
 }
 
-static int hpsa_request_irq(struct ctlr_info *h,
+/* returns 0 on success; cleans up and returns -Enn on error */
+static int hpsa_request_irqs(struct ctlr_info *h,
 	irqreturn_t (*msixhandler)(int, void *),
 	irqreturn_t (*intxhandler)(int, void *))
 {
@@ -6934,7 +6935,7 @@ reinit_after_soft_reset:
 	/* make sure the board interrupts are off */
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 
-	if (hpsa_request_irq(h, do_hpsa_intr_msi, do_hpsa_intr_intx))
+	if (hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx))
 		goto clean2;
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
@@ -6970,11 +6971,11 @@ reinit_after_soft_reset:
 		h->access.set_intr_mask(h, HPSA_INTR_OFF);
 		spin_unlock_irqrestore(&h->lock, flags);
 		hpsa_free_irqs(h);
-		rc = hpsa_request_irq(h, hpsa_msix_discard_completions,
+		rc = hpsa_request_irqs(h, hpsa_msix_discard_completions,
 					hpsa_intx_discard_completions);
 		if (rc) {
-			dev_warn(&h->pdev->dev, "Failed to request_irq after "
-				"soft reset.\n");
+			dev_warn(&h->pdev->dev,
+				"Failed to request_irq after soft reset.\n");
 			goto clean4;
 		}
 

