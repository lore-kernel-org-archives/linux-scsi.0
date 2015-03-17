From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 35/42] hpsa: create workqueue after the driver is ready
 for use
Date: Tue, 17 Mar 2015 15:05:32 -0500
Message-ID: <20150317200532.19856.43645.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42596 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbbCQUIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:08:20 -0400
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 4D14464366
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:08:20 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Don't create the resubmit workqueue in hpsa_init_one until everything else
is ready to use, so everything can be freed in reverse order of when they
were allocated without risking freeing things while workqueue items are
still active.

Destroy the workqueue in the right order in
hpsa_undo_allocations_after_kdump_soft_reset too.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   60 ++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fdf36a7..0057236 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7714,30 +7714,18 @@ reinit_after_soft_reset:
 	atomic_set(&h->passthru_cmds_avail, HPSA_MAX_CONCURRENT_PASSTHRUS);
 	atomic_set(&h->abort_cmds_available, HPSA_CMDS_RESERVED_FOR_ABORTS);
 
-	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
-	if (!h->rescan_ctlr_wq) {
-		rc = -ENOMEM;
-		goto clean1;
-	}
-
-	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
-	if (!h->resubmit_wq) {
-		rc = -ENOMEM;
-		goto clean1;	/* aer/h */
-	}
-
 	/* Allocate and clear per-cpu variable lockup_detected */
 	h->lockup_detected = alloc_percpu(u32);
 	if (!h->lockup_detected) {
 		dev_err(&h->pdev->dev, "Failed to allocate lockup detector\n");
 		rc = -ENOMEM;
-		goto clean1;	/* wq/aer/h */
+		goto clean1;	/* aer/h */
 	}
 	set_lockup_detected_for_all_cpus(h, 0);
 
 	rc = hpsa_pci_init(h);
 	if (rc)
-		goto clean2;	/* lockup, wq/aer/h */
+		goto clean2;	/* lockup, aer/h */
 
 	sprintf(h->devname, HPSA "%d", number_of_controllers);
 	h->ctlr = number_of_controllers;
@@ -7753,7 +7741,7 @@ reinit_after_soft_reset:
 			dac = 0;
 		} else {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
-			goto clean3;	/* pci, lockup, wq/aer/h */
+			goto clean3;	/* pci, lockup, aer/h */
 		}
 	}
 
@@ -7762,16 +7750,16 @@ reinit_after_soft_reset:
 
 	rc = hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx);
 	if (rc)
-		goto clean3;	/* pci, lockup, wq/aer/h */
+		goto clean3;	/* pci, lockup, aer/h */
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
 	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
-		goto clean4;	/* irq, pci, lockup, wq/aer/h */
+		goto clean4;	/* irq, pci, lockup, aer/h */
 	rc = hpsa_alloc_sg_chain_blocks(h);
 	if (rc)
-		goto clean5;	/* cmd, irq, pci, lockup, wq/aer/h */
+		goto clean5;	/* cmd, irq, pci, lockup, aer/h */
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->abort_cmd_wait_queue);
 	init_waitqueue_head(&h->abort_sync_wait_queue);
@@ -7784,7 +7772,20 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->devlock);
 	rc = hpsa_put_ctlr_into_performant_mode(h);
 	if (rc)
-		goto clean6;	/* sg, cmd, irq, pci, lockup, wq/aer/h */
+		goto clean6;	/* sg, cmd, irq, pci, lockup, aer/h */
+
+	/* create the resubmit workqueue */
+	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
+	if (!h->rescan_ctlr_wq) {
+		rc = -ENOMEM;
+		goto clean7;
+	}
+
+	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
+	if (!h->resubmit_wq) {
+		rc = -ENOMEM;
+		goto clean7;	/* aer/h */
+	}
 
 	/*
 	 * At this point, the controller is ready to take commands.
@@ -7826,7 +7827,7 @@ reinit_after_soft_reset:
 		rc = hpsa_kdump_soft_reset(h);
 		if (rc)
 			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean7;
+			goto clean8;
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -7863,7 +7864,7 @@ reinit_after_soft_reset:
 	hpsa_hba_inquiry(h);
 	rc = hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
 	if (rc)
-		goto clean7;
+		goto clean8; /* wq, perf, sg, cmd, irq, pci, lockup, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -7875,19 +7876,20 @@ reinit_after_soft_reset:
 				h->heartbeat_sample_interval);
 	return 0;
 
-clean7: /* perf, sg, cmd, irq, pci, lockup, wq/aer/h */
+clean8: /* perf, sg, cmd, irq, pci, lockup, aer/h */
 	kfree(h->hba_inquiry_data);
+clean7: /* perf, sg, cmd, irq, pci, lockup, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 clean6: /* sg, cmd, irq, pci, lockup, wq/aer/h */
 	hpsa_free_sg_chain_blocks(h);
-clean5: /* cmd, irq, pci, lockup, wq/aer/h */
+clean5: /* cmd, irq, pci, lockup, aer/h */
 	hpsa_free_cmd_pool(h);
-clean4: /* irq, pci, lockup, wq/aer/h */
+clean4: /* irq, pci, lockup, aer/h */
 	hpsa_free_irqs(h);
-clean3: /* pci, lockup, wq/aer/h */
+clean3: /* pci, lockup, aer/h */
 	hpsa_free_pci_init(h);
-clean2: /* lockup, wq/aer/h */
+clean2: /* lockup, aer/h */
 	if (h->lockup_detected) {
 		free_percpu(h->lockup_detected);
 		h->lockup_detected = NULL;
@@ -7986,9 +7988,9 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 
 	hpsa_free_device_info(h);		/* scan */
 
-	hpsa_unregister_scsi(h);			/* init_one "8" */
-	kfree(h->hba_inquiry_data);			/* init_one "8" */
-	h->hba_inquiry_data = NULL;			/* init_one "8" */
+	hpsa_unregister_scsi(h);			/* init_one 9 */
+	kfree(h->hba_inquiry_data);			/* init_one 9 */
+	h->hba_inquiry_data = NULL;			/* init_one 9 */
 	hpsa_free_performant_mode(h);			/* init_one 7 */
 	hpsa_free_sg_chain_blocks(h);			/* init_one 6 */
 	hpsa_free_cmd_pool(h);				/* init_one 5 */

