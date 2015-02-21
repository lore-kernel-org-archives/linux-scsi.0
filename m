From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 40/43] hpsa: cleanup initialization code.
Date: Sat, 21 Feb 2015 16:21:05 -0600
Message-ID: <20150221222105.21954.13148.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:56133 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbbBUWWY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:24 -0500
Received: from g5t1627.atlanta.hp.com (g5t1627.atlanta.hp.com [15.192.137.10])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 4D161209
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:22:24 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

- remove goto clean_X labels
- avoid duplication of cleanup code

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  188 +++++++++++++++++++--------------------------------
 drivers/scsi/hpsa.h |    1 
 2 files changed, 70 insertions(+), 119 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ffdfa55..8a4c3f2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7519,6 +7519,9 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 		hpsa_free_irqs(h);
 		return -ENODEV;
 	}
+
+	h->request_irq_called = 1;
+
 	return 0;
 }
 
@@ -7559,27 +7562,6 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
 	h->reply_queue_size = 0;
 }
 
-static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
-{
-	hpsa_free_performant_mode(h);		/* init_one 7 */
-	hpsa_free_sg_chain_blocks(h);		/* init_one 6 */
-	hpsa_free_cmd_pool(h);			/* init_one 5 */
-	hpsa_free_irqs(h);			/* init_one 4 */
-	scsi_host_put(h->scsi_host);		/* init_one 3 */
-	h->scsi_host = NULL;			/* init_one 3 */
-	hpsa_free_pci_init(h);			/* init_one 2_5 */
-	free_percpu(h->lockup_detected);	/* init_one 2 */
-	h->lockup_detected = NULL;		/* init_one 2 */
-	if (h->resubmit_wq) {
-		destroy_workqueue(h->resubmit_wq);	/* init_one 1 */
-		h->resubmit_wq = NULL;
-	}
-	if (h->rescan_ctlr_wq) {
-		destroy_workqueue(h->rescan_ctlr_wq);
-		h->rescan_ctlr_wq = NULL;
-	}
-	kfree(h);				/* init_one 1 */
-}
 
 /* Called when controller lockup detected. */
 static void fail_all_outstanding_cmds(struct ctlr_info *h)
@@ -7814,6 +7796,46 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
 	return wq;
 }
 
+static int hpsa_init_cleanup(struct ctlr_info *h, int rc)
+{
+
+	if (h->rescan_ctlr_wq) {
+		destroy_workqueue(h->rescan_ctlr_wq);
+		h->rescan_ctlr_wq = NULL;
+	}
+
+	if (h->resubmit_wq) {
+		destroy_workqueue(h->resubmit_wq);
+		h->resubmit_wq = NULL;
+	}
+
+	wait_event_interruptible(h->scan_wait_queue,
+				test_bit(0,
+				(unsigned long *)&h->scan_finished));
+
+	hpsa_free_performant_mode(h);
+	hpsa_free_ioaccel2_sg_chain_blocks(h);
+	hpsa_free_sg_chain_blocks(h);
+	hpsa_free_cmd_pool(h);
+	if (h->request_irq_called)
+		hpsa_free_irqs(h);
+	if (h->scsi_host) {
+		scsi_remove_host(h->scsi_host);
+		scsi_host_put(h->scsi_host);
+		h->scsi_host = NULL;
+	}
+	hpsa_free_pci_init(h);
+	if (h->lockup_detected) {
+		free_percpu(h->lockup_detected);
+		h->lockup_detected = NULL;
+	}
+	kfree(h->hba_inquiry_data);
+	h->hba_inquiry_data = NULL;
+	kfree(h);
+
+	return rc;
+}
+
 static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int dac, rc;
@@ -7864,20 +7886,19 @@ reinit_after_soft_reset:
 	h->lockup_detected = alloc_percpu(u32);
 	if (!h->lockup_detected) {
 		dev_err(&h->pdev->dev, "Failed to allocate lockup detector\n");
-		rc = -ENOMEM;
-		goto clean1;	/* aer/h */
+		return -ENOMEM;
 	}
 	set_lockup_detected_for_all_cpus(h, 0);
 
 	rc = hpsa_pci_init(h);
 	if (rc)
-		goto clean2;	/* lu, aer/h */
+		return hpsa_init_cleanup(h, rc);
 
 	/* relies on h-> settings made by hpsa_pci_init, including
 	 * interrupt_mode h->intr */
 	rc = hpsa_scsi_host_alloc(h);
 	if (rc)
-		goto clean2_5;	/* pci, lu, aer/h */
+		return hpsa_init_cleanup(h, rc);
 
 	sprintf(h->devname, HPSA "%d", h->scsi_host->host_no);
 	h->ctlr = number_of_controllers;
@@ -7893,7 +7914,7 @@ reinit_after_soft_reset:
 			dac = 0;
 		} else {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
-			goto clean3;	/* shost, pci, lu, aer/h */
+			return hpsa_init_cleanup(h, rc);
 		}
 	}
 
@@ -7902,13 +7923,13 @@ reinit_after_soft_reset:
 
 	rc = hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx);
 	if (rc)
-		goto clean3;	/* shost, pci, lu, aer/h */
+		return hpsa_init_cleanup(h, rc);
 	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
-		goto clean4;	/* irq, shost, pci, lu, aer/h */
+		return hpsa_init_cleanup(h, rc);
 	rc = hpsa_alloc_sg_chain_blocks(h);
 	if (rc)
-		goto clean5;	/* cmd, irq, shost, pci, lu, aer/h */
+		return hpsa_init_cleanup(h, rc);
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->abort_cmd_wait_queue);
 	init_waitqueue_head(&h->abort_sync_wait_queue);
@@ -7921,28 +7942,22 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->devlock);
 	rc = hpsa_put_ctlr_into_performant_mode(h);
 	if (rc)
-		goto clean6; /* sg, cmd, irq, shost, pci, lu, aer/h */
+		return hpsa_init_cleanup(h, rc);
 
-	/* hook into SCSI subsystem */
-	rc = hpsa_scsi_add_host(h);
-	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
-
-	/* create the resubmit workqueue */
 	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
-	if (!h->rescan_ctlr_wq) {
-		rc = -ENOMEM;
-		goto clean7;
-	}
+	if (!h->rescan_ctlr_wq)
+		return hpsa_init_cleanup(h, -ENOMEM);
 
 	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
-	if (!h->resubmit_wq) {
-		rc = -ENOMEM;
-		goto clean7;	/* aer/h */
-	}
+	if (!h->resubmit_wq)
+		return hpsa_init_cleanup(h, -ENOMEM);
 
-	/*
-	 * At this point, the controller is ready to take commands.
+	/* hook into SCSI subsystem */
+	rc = hpsa_scsi_add_host(h);
+	if (rc)
+		return hpsa_init_cleanup(h, rc);
+
+	/* At this point, the controller is ready to take commands.
 	 * Now, if reset_devices and the hard reset didn't work, try
 	 * the soft reset and see if that works.
 	 */
@@ -7964,24 +7979,12 @@ reinit_after_soft_reset:
 		if (rc) {
 			dev_warn(&h->pdev->dev,
 				"Failed to request_irq after soft reset.\n");
-			/*
-			 * cannot goto clean7 or free_irqs will be called
-			 * again. Instead, do its work
-			 */
-			hpsa_free_performant_mode(h);	/* clean7 */
-			hpsa_free_sg_chain_blocks(h);	/* clean6 */
-			hpsa_free_cmd_pool(h);		/* clean5 */
-			/*
-			 * skip hpsa_free_irqs(h) clean4 since that
-			 * was just called before request_irqs failed
-			 */
-			goto clean3;
+			return hpsa_init_cleanup(h, rc);
 		}
 
 		rc = hpsa_kdump_soft_reset(h);
-		if (rc)
-			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean9;
+		if (rc) /* Neither hard nor soft reset worked, we're hosed. */
+			return hpsa_init_cleanup(h, rc);
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -7999,11 +8002,12 @@ reinit_after_soft_reset:
 		 * everything.  Easiest to just forget what we've done and do it
 		 * all over again.
 		 */
-		hpsa_undo_allocations_after_kdump_soft_reset(h);
+		hpsa_init_cleanup(h, 0);
 		try_soft_reset = 0;
-		if (rc)
-			/* don't goto clean, we already unallocated */
+		if (rc) {
+			/* There is nothing to clean up, just return */
 			return -ENODEV;
+		}
 
 		goto reinit_after_soft_reset;
 	}
@@ -8026,39 +8030,6 @@ reinit_after_soft_reset:
 	queue_delayed_work(h->rescan_ctlr_wq, &h->rescan_ctlr_work,
 				h->heartbeat_sample_interval);
 	return 0;
-
-clean9: /* wq, sh, perf, sg, cmd, irq, shost, pci, lu, aer/h */
-	kfree(h->hba_inquiry_data);
-clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
-	hpsa_free_performant_mode(h);
-	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-clean6: /* sg, cmd, irq, pci, lockup, wq/aer/h */
-	hpsa_free_sg_chain_blocks(h);
-clean5: /* cmd, irq, shost, pci, lu, aer/h */
-	hpsa_free_cmd_pool(h);
-clean4: /* irq, shost, pci, lu, aer/h */
-	hpsa_free_irqs(h);
-clean3: /* shost, pci, lu, aer/h */
-	scsi_host_put(h->scsi_host);
-	h->scsi_host = NULL;
-clean2_5: /* pci, lu, aer/h */
-	hpsa_free_pci_init(h);
-clean2: /* lu, aer/h */
-	if (h->lockup_detected) {
-		free_percpu(h->lockup_detected);
-		h->lockup_detected = NULL;
-	}
-clean1:	/* wq/aer/h */
-	if (h->resubmit_wq) {
-		destroy_workqueue(h->resubmit_wq);
-		h->resubmit_wq = NULL;
-	}
-	if (h->rescan_ctlr_wq) {
-		destroy_workqueue(h->rescan_ctlr_wq);
-		h->rescan_ctlr_wq = NULL;
-	}
-	kfree(h);
-	return rc;
 }
 
 static void hpsa_flush_cache(struct ctlr_info *h)
@@ -8133,8 +8104,6 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&h->lock, flags);
 	cancel_delayed_work_sync(&h->monitor_ctlr_work);
 	cancel_delayed_work_sync(&h->rescan_ctlr_work);
-	destroy_workqueue(h->rescan_ctlr_wq);
-	destroy_workqueue(h->resubmit_wq);
 
 	/* includes hpsa_free_irqs - init_one 4 */
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
@@ -8142,26 +8111,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 
 	hpsa_free_device_info(h);		/* scan */
 
-	kfree(h->hba_inquiry_data);			/* init_one 10 */
-	h->hba_inquiry_data = NULL;			/* init_one 10 */
-	scsi_remove_host(h->scsi_host);			/* init_one 8 */
-	hpsa_free_ioaccel2_sg_chain_blocks(h);
-	hpsa_free_performant_mode(h);			/* init_one 7 */
-	hpsa_free_sg_chain_blocks(h);			/* init_one 6 */
-	hpsa_free_cmd_pool(h);				/* init_one 5 */
-
-	/* hpsa_free_irqs already called via hpsa_shutdown init_one 4 */
-
-	scsi_host_put(h->scsi_host);			/* init_one 3 */
-	h->scsi_host = NULL;				/* init_one 3 */
-
-	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
-	hpsa_free_pci_init(h);				/* init_one 2.5 */
-
-	free_percpu(h->lockup_detected);		/* init_one 2 */
-	h->lockup_detected = NULL;			/* init_one 2 */
-	/* (void) pci_disable_pcie_error_reporting(pdev); */	/* init_one 1 */
-	kfree(h);					/* init_one 1 */
+	hpsa_init_cleanup(h, 0);
 }
 
 static int hpsa_suspend(__attribute__((unused)) struct pci_dev *pdev,
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 2536b67..b1ae888 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -140,6 +140,7 @@ struct ctlr_info {
 #define HPSA_CMDS_RESERVED_FOR_DRIVER 1
 	struct CfgTable __iomem *cfgtable;
 	int	interrupts_enabled;
+	int	request_irq_called;
 	int 	max_commands;
 	atomic_t commands_outstanding;
 #	define PERF_MODE_INT	0

