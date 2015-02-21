From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 36/43] hpsa: add interrupt number to /proc/interrupts
 interrupt name
Date: Sat, 21 Feb 2015 16:20:44 -0600
Message-ID: <20150221222044.21954.17228.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49565 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbbBUWWC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:02 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Add the interrupt number to the interrupt names that
appear in /proc/interrupts, so they are unique

Also, delete the IRQ and DAC prints.  Other parts of the kernel
already print the IRQ assignments, and dual-address-cycle support
has not been interesting since the parallel PCI bus went from
32 to 64 bits wide.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   20 ++++++++++++++------
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 63fdc70..d69a732 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7353,8 +7353,9 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 	if (h->intr_mode == PERF_MODE_INT && h->msix_vector > 0) {
 		/* If performant mode and MSI-X, use multiple reply queues */
 		for (i = 0; i < h->msix_vector; i++) {
+			sprintf(h->intrname[i], "%s-msix%d", h->devname, i);
 			rc = request_irq(h->intr[i], msixhandler,
-					0, h->devname,
+					0, h->intrname[i],
 					&h->q[i]);
 			if (rc) {
 				int j;
@@ -7375,12 +7376,22 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 	} else {
 		/* Use single reply pool */
 		if (h->msix_vector > 0 || h->msi_vector) {
+			if (h->msix_vector)
+				sprintf(h->intrname[h->intr_mode],
+					"%s-msix", h->devname);
+			else
+				sprintf(h->intrname[h->intr_mode],
+					"%s-msi", h->devname);
 			rc = request_irq(h->intr[h->intr_mode],
-				msixhandler, 0, h->devname,
+				msixhandler, 0,
+				h->intrname[h->intr_mode],
 				&h->q[h->intr_mode]);
 		} else {
+			sprintf(h->intrname[h->intr_mode],
+				"%s-intx", h->devname);
 			rc = request_irq(h->intr[h->intr_mode],
-				intxhandler, IRQF_SHARED, h->devname,
+				intxhandler, IRQF_SHARED,
+				h->intrname[h->intr_mode],
 				&h->q[h->intr_mode]);
 		}
 		irq_set_affinity_hint(h->intr[h->intr_mode], NULL);
@@ -7767,9 +7778,6 @@ reinit_after_soft_reset:
 	rc = hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx);
 	if (rc)
 		goto clean3;	/* pci, lockup, aer/h */
-	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
-	       h->devname, pdev->device,
-	       h->intr[h->intr_mode], dac ? "" : " not");
 	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
 		goto clean4;	/* irq, pci, lockup, aer/h */
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7cb8586..3ec8934 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -220,6 +220,7 @@ struct ctlr_info {
 	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
+	char intrname[MAX_REPLY_QUEUES][16];	/* "hpsa0-msix00" names */
 	u32 TMFSupportFlags; /* cache what task mgmt funcs are supported. */
 #define HPSATMF_BITS_SUPPORTED  (1 << 0)
 #define HPSATMF_PHYS_LUN_RESET  (1 << 1)

