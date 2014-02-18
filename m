From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 35/35] hpsa: fixup MSI-X registration
Date: Tue, 18 Feb 2014 13:58:08 -0600
Message-ID: <20140218195808.15787.96741.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57138 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaBRT7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:59:34 -0500
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 0C0101C86
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:59:27 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Hannes Reinecke <hare@suse.de>

Commit 254f796b9f22b1944c64caabc356a56caaa2facd updated
the driver to use 16 MSI-X vectors, despite the fact that
older controllers would provide only 4.
This was causing MSI-X registration to drop down to INTx
mode. But as the controller support performant mode, the
initialisation will become confused and cause the machine
to stall during boot.

This patch fixes up the MSI-X registration to re-issue
the pci_enable_msix() call with the correct number of
MSI-X vectors. With that the hpsa driver continues to
works on older controllers like the P200.

Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hpsa.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c8de330..9f593b9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -744,7 +744,7 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 {
 	if (likely(h->transMethod & CFGTBL_Trans_Performant)) {
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
-		if (likely(h->msix_vector))
+		if (likely(h->msix_vector > 0))
 			c->Header.ReplyQueue =
 				raw_smp_processor_id() % h->nreply_queues;
 	}
@@ -5816,21 +5816,24 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
+		h->msix_vector = MAX_REPLY_QUEUES;
 		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
-						MAX_REPLY_QUEUES);
-		if (!err) {
-			for (i = 0; i < MAX_REPLY_QUEUES; i++)
-				h->intr[i] = hpsa_msix_entries[i].vector;
-			h->msix_vector = 1;
-			return;
-		}
+				      h->msix_vector);
 		if (err > 0) {
 			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
 			       "available\n", err);
-			goto default_int_mode;
+			h->msix_vector = err;
+			err = pci_enable_msix(h->pdev, hpsa_msix_entries,
+					      h->msix_vector);
+		}
+		if (!err) {
+			for (i = 0; i < h->msix_vector; i++)
+				h->intr[i] = hpsa_msix_entries[i].vector;
+			return;
 		} else {
 			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
 			       err);
+			h->msix_vector = 0;
 			goto default_int_mode;
 		}
 	}
@@ -6276,15 +6279,15 @@ static int hpsa_request_irq(struct ctlr_info *h,
 	for (i = 0; i < MAX_REPLY_QUEUES; i++)
 		h->q[i] = (u8) i;
 
-	if (h->intr_mode == PERF_MODE_INT && h->msix_vector) {
+	if (h->intr_mode == PERF_MODE_INT && h->msix_vector > 0) {
 		/* If performant mode and MSI-X, use multiple reply queues */
-		for (i = 0; i < MAX_REPLY_QUEUES; i++)
+		for (i = 0; i < h->msix_vector; i++)
 			rc = request_irq(h->intr[i], msixhandler,
 					0, h->devname,
 					&h->q[i]);
 	} else {
 		/* Use single reply pool */
-		if (h->msix_vector || h->msi_vector) {
+		if (h->msix_vector > 0 || h->msi_vector) {
 			rc = request_irq(h->intr[h->intr_mode],
 				msixhandler, 0, h->devname,
 				&h->q[h->intr_mode]);
@@ -6337,7 +6340,7 @@ static void free_irqs(struct ctlr_info *h)
 		return;
 	}
 
-	for (i = 0; i < MAX_REPLY_QUEUES; i++)
+	for (i = 0; i < h->msix_vector; i++)
 		free_irq(h->intr[i], &h->q[i]);
 }
 
@@ -7134,7 +7137,7 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	}
 
 	/* TODO, check that this next line h->nreply_queues is correct */
-	h->nreply_queues = h->msix_vector ? MAX_REPLY_QUEUES : 1;
+	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
 	hpsa_get_max_perf_mode_cmds(h);
 	/* Performant mode ring buffer and supporting data structures */
 	h->reply_pool_size = h->max_commands * sizeof(u64) * h->nreply_queues;

