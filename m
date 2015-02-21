From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 39/43] hpsa: use scsi host_no as hpsa controller number
Date: Sat, 21 Feb 2015 16:21:00 -0600
Message-ID: <20150221222100.21954.17959.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1867 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbbBUWWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:18 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Rather than numbering the hpsa controllers with an
incrementing 0..n value (e.g., that shows up in
/proc/interrupts), use the scsi midlayer
host_no (e.g. matching /sys/class/scsi_host/hostNN).

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  137 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c491bed..ffdfa55 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -330,32 +330,35 @@ static int check_for_unit_attention(struct ctlr_info *h,
 	switch (asc) {
 	case STATE_CHANGED:
 		dev_warn(&h->pdev->dev,
-			HPSA "%d: a state change detected, command retried\n",
-			h->ctlr);
+			"%s: a state change detected, command retried\n",
+			h->devname);
 		break;
 	case LUN_FAILED:
 		dev_warn(&h->pdev->dev,
-			HPSA "%d: LUN failure detected\n", h->ctlr);
+			"%s: LUN failure detected\n", h->devname);
 		break;
 	case REPORT_LUNS_CHANGED:
 		dev_warn(&h->pdev->dev,
-			HPSA "%d: report LUN data changed\n", h->ctlr);
+			"%s: report LUN data changed\n", h->devname);
 	/*
 	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the external
 	 * target (array) devices.
 	 */
 		break;
 	case POWER_OR_RESET:
-		dev_warn(&h->pdev->dev, HPSA "%d: a power on "
-			"or device reset detected\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			"%s: a power on or device reset detected\n",
+			h->devname);
 		break;
 	case UNIT_ATTENTION_CLEARED:
-		dev_warn(&h->pdev->dev, HPSA "%d: unit attention "
-		    "cleared by another initiator\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			"%s: unit attention cleared by another initiator\n",
+			h->devname);
 		break;
 	default:
-		dev_warn(&h->pdev->dev, HPSA "%d: unknown "
-			"unit attention detected\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			"%s: unknown unit attention detected\n",
+			h->devname);
 		break;
 	}
 	return 1;
@@ -4821,22 +4824,15 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 	return finished;
 }
 
-static void hpsa_unregister_scsi(struct ctlr_info *h)
-{
-	/* we are being forcibly unloaded, and may not refuse. */
-	scsi_remove_host(h->scsi_host);
-	scsi_host_put(h->scsi_host);
-	h->scsi_host = NULL;
-}
-
-static int hpsa_register_scsi(struct ctlr_info *h)
+static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
-	int error;
 
 	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
-	if (sh == NULL)
-		goto fail;
+	if (sh == NULL) {
+		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
+		return -ENOMEM;
+	}
 
 	sh->io_port = 0;
 	sh->n_io_port = 0;
@@ -4848,35 +4844,35 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
 	sh->cmd_per_lun = sh->can_queue;
 	sh->sg_tablesize = h->maxsgentries;
-	h->scsi_host = sh;
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = h->intr[h->intr_mode];
 	sh->unique_id = sh->irq;
 	if (!shost_use_blk_mq(sh)) {
-		error = scsi_init_shared_tag_map(sh, sh->can_queue);
+		int error = scsi_init_shared_tag_map(sh, sh->can_queue);
+
 		if (error) {
 			dev_err(&h->pdev->dev,
 				"%s: scsi_init_shared_tag_map failed for controller %d\n",
 				__func__, h->ctlr);
-			goto fail_host_put;
+			scsi_host_put(sh);
+			return error;
 		}
 	}
-	error = scsi_add_host(sh, &h->pdev->dev);
-	if (error) {
-		dev_err(&h->pdev->dev, "%s: scsi_add_host failed for controller %d\n",
-			__func__, h->ctlr);
-		goto fail_host_put;
-	}
-	scsi_scan_host(sh);
+	h->scsi_host = sh;
 	return 0;
+}
 
- fail_host_put:
-	scsi_host_put(sh);
-	return error;
- fail:
-	dev_err(&h->pdev->dev, "%s: scsi_host_alloc"
-		" failed for controller %d\n", __func__, h->ctlr);
-	return -ENOMEM;
+static int hpsa_scsi_add_host(struct ctlr_info *h)
+{
+	int rv;
+
+	rv = scsi_add_host(h->scsi_host, &h->pdev->dev);
+	if (rv) {
+		dev_err(&h->pdev->dev, "scsi_add_host failed\n");
+		return rv;
+	}
+	scsi_scan_host(h->scsi_host);
+	return 0;
 }
 
 /*
@@ -7569,7 +7565,9 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 	hpsa_free_sg_chain_blocks(h);		/* init_one 6 */
 	hpsa_free_cmd_pool(h);			/* init_one 5 */
 	hpsa_free_irqs(h);			/* init_one 4 */
-	hpsa_free_pci_init(h);			/* init_one 3 */
+	scsi_host_put(h->scsi_host);		/* init_one 3 */
+	h->scsi_host = NULL;			/* init_one 3 */
+	hpsa_free_pci_init(h);			/* init_one 2_5 */
 	free_percpu(h->lockup_detected);	/* init_one 2 */
 	h->lockup_detected = NULL;		/* init_one 2 */
 	if (h->resubmit_wq) {
@@ -7873,9 +7871,15 @@ reinit_after_soft_reset:
 
 	rc = hpsa_pci_init(h);
 	if (rc)
-		goto clean2;	/* lockup, aer/h */
+		goto clean2;	/* lu, aer/h */
 
-	sprintf(h->devname, HPSA "%d", number_of_controllers);
+	/* relies on h-> settings made by hpsa_pci_init, including
+	 * interrupt_mode h->intr */
+	rc = hpsa_scsi_host_alloc(h);
+	if (rc)
+		goto clean2_5;	/* pci, lu, aer/h */
+
+	sprintf(h->devname, HPSA "%d", h->scsi_host->host_no);
 	h->ctlr = number_of_controllers;
 	number_of_controllers++;
 
@@ -7889,7 +7893,7 @@ reinit_after_soft_reset:
 			dac = 0;
 		} else {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
-			goto clean3;	/* pci, lockup, aer/h */
+			goto clean3;	/* shost, pci, lu, aer/h */
 		}
 	}
 
@@ -7898,13 +7902,13 @@ reinit_after_soft_reset:
 
 	rc = hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx);
 	if (rc)
-		goto clean3;	/* pci, lockup, aer/h */
+		goto clean3;	/* shost, pci, lu, aer/h */
 	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
-		goto clean4;	/* irq, pci, lockup, aer/h */
+		goto clean4;	/* irq, shost, pci, lu, aer/h */
 	rc = hpsa_alloc_sg_chain_blocks(h);
 	if (rc)
-		goto clean5;	/* cmd, irq, pci, lockup, aer/h */
+		goto clean5;	/* cmd, irq, shost, pci, lu, aer/h */
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->abort_cmd_wait_queue);
 	init_waitqueue_head(&h->abort_sync_wait_queue);
@@ -7913,11 +7917,16 @@ reinit_after_soft_reset:
 	pci_set_drvdata(pdev, h);
 	h->ndevices = 0;
 	h->hba_mode_enabled = 0;
-	h->scsi_host = NULL;
+
 	spin_lock_init(&h->devlock);
 	rc = hpsa_put_ctlr_into_performant_mode(h);
 	if (rc)
-		goto clean6;	/* sg, cmd, irq, pci, lockup, aer/h */
+		goto clean6; /* sg, cmd, irq, shost, pci, lu, aer/h */
+
+	/* hook into SCSI subsystem */
+	rc = hpsa_scsi_add_host(h);
+	if (rc)
+		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* create the resubmit workqueue */
 	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
@@ -7972,7 +7981,7 @@ reinit_after_soft_reset:
 		rc = hpsa_kdump_soft_reset(h);
 		if (rc)
 			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean8;
+			goto clean9;
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -8007,9 +8016,6 @@ reinit_after_soft_reset:
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
 	hpsa_hba_inquiry(h);
-	rc = hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
-	if (rc)
-		goto clean8; /* wq, perf, sg, cmd, irq, pci, lockup, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8021,20 +8027,23 @@ reinit_after_soft_reset:
 				h->heartbeat_sample_interval);
 	return 0;
 
-clean8: /* perf, sg, cmd, irq, pci, lockup, aer/h */
+clean9: /* wq, sh, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	kfree(h->hba_inquiry_data);
-clean7: /* perf, sg, cmd, irq, pci, lockup, aer/h */
+clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 clean6: /* sg, cmd, irq, pci, lockup, wq/aer/h */
 	hpsa_free_sg_chain_blocks(h);
-clean5: /* cmd, irq, pci, lockup, aer/h */
+clean5: /* cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_cmd_pool(h);
-clean4: /* irq, pci, lockup, aer/h */
+clean4: /* irq, shost, pci, lu, aer/h */
 	hpsa_free_irqs(h);
-clean3: /* pci, lockup, aer/h */
+clean3: /* shost, pci, lu, aer/h */
+	scsi_host_put(h->scsi_host);
+	h->scsi_host = NULL;
+clean2_5: /* pci, lu, aer/h */
 	hpsa_free_pci_init(h);
-clean2: /* lockup, aer/h */
+clean2: /* lu, aer/h */
 	if (h->lockup_detected) {
 		free_percpu(h->lockup_detected);
 		h->lockup_detected = NULL;
@@ -8133,17 +8142,21 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 
 	hpsa_free_device_info(h);		/* scan */
 
-	hpsa_unregister_scsi(h);			/* init_one 9 */
-	kfree(h->hba_inquiry_data);			/* init_one 9 */
-	h->hba_inquiry_data = NULL;			/* init_one 9 */
+	kfree(h->hba_inquiry_data);			/* init_one 10 */
+	h->hba_inquiry_data = NULL;			/* init_one 10 */
+	scsi_remove_host(h->scsi_host);			/* init_one 8 */
+	hpsa_free_ioaccel2_sg_chain_blocks(h);
 	hpsa_free_performant_mode(h);			/* init_one 7 */
 	hpsa_free_sg_chain_blocks(h);			/* init_one 6 */
 	hpsa_free_cmd_pool(h);				/* init_one 5 */
 
 	/* hpsa_free_irqs already called via hpsa_shutdown init_one 4 */
 
+	scsi_host_put(h->scsi_host);			/* init_one 3 */
+	h->scsi_host = NULL;				/* init_one 3 */
+
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
-	hpsa_free_pci_init(h);				/* init_one 3 */
+	hpsa_free_pci_init(h);				/* init_one 2.5 */
 
 	free_percpu(h->lockup_detected);		/* init_one 2 */
 	h->lockup_detected = NULL;			/* init_one 2 */

