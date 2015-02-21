From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 23/43] hpsa: clean up driver init
Date: Sat, 21 Feb 2015 16:19:35 -0600
Message-ID: <20150221221935.21954.4551.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:1682 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbbBUWUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:20:53 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Improve initialization error handling in hpsa_init_one
Clean up style and indent issues
Rename functions for consistency
Improve error messaging on allocations
Fix return status from hpsa_put_ctlr_into_performant_mode
Correct free order in hpsa_init_one using new function
   hpsa_free_performant_mode
Prevent inadvertent use of null pointers by nulling out the parent structures
   and zeroing out associated size variables.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |  244 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 158 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af0439b..e76fa03 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -233,9 +233,8 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 /* performant mode helper functions */
 static void calc_bucket_map(int *bucket, int num_buckets,
 	int nsgs, int min_blocks, u32 *bucket_map);
-static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
-static void hpsa_free_ioaccel1_cmd_and_bft(struct ctlr_info *h);
-static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h);
+static void hpsa_free_performant_mode(struct ctlr_info *h);
+static int hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
 static inline u32 next_command(struct ctlr_info *h, u8 q);
 static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 			       u32 *cfg_base_addr, u64 *cfg_base_addr_index,
@@ -1673,6 +1672,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		 * since it didn't get added to scsi mid layer
 		 */
 		fixup_botched_add(h, added[i]);
+		added[i] = NULL;
 	}
 
 free_and_out:
@@ -1804,7 +1804,7 @@ static void hpsa_free_sg_chain_blocks(struct ctlr_info *h)
 	h->cmd_sg_list = NULL;
 }
 
-static int hpsa_allocate_sg_chain_blocks(struct ctlr_info *h)
+static int hpsa_alloc_sg_chain_blocks(struct ctlr_info *h)
 {
 	int i;
 
@@ -6501,9 +6501,11 @@ static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
 	if (h->msix_vector) {
 		if (h->pdev->msix_enabled)
 			pci_disable_msix(h->pdev);
+		h->msix_vector = 0;
 	} else if (h->msi_vector) {
 		if (h->pdev->msi_enabled)
 			pci_disable_msi(h->pdev);
+		h->msi_vector = 0;
 	}
 #endif /* CONFIG_PCI_MSI */
 }
@@ -6643,10 +6645,14 @@ static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 
 static void hpsa_free_cfgtables(struct ctlr_info *h)
 {
-	if (h->transtable)
+	if (h->transtable) {
 		iounmap(h->transtable);
-	if (h->cfgtable)
+		h->transtable = NULL;
+	}
+	if (h->cfgtable) {
 		iounmap(h->cfgtable);
+		h->cfgtable = NULL;
+	}
 }
 
 /* Find and map CISS config table and transfer table
@@ -6863,6 +6869,7 @@ static void hpsa_free_pci_init(struct ctlr_info *h)
 {
 	hpsa_free_cfgtables(h);			/* pci_init 4 */
 	iounmap(h->vaddr);			/* pci_init 3 */
+	h->vaddr = NULL;
 	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
 	pci_release_regions(h->pdev);		/* pci_init 2 */
 	pci_disable_device(h->pdev);		/* pci_init 1 */
@@ -6933,6 +6940,7 @@ clean4:	/* cfgtables, vaddr, intmode+region, pci */
 	hpsa_free_cfgtables(h);
 clean3:	/* vaddr, intmode+region, pci */
 	iounmap(h->vaddr);
+	h->vaddr = NULL;
 clean2:	/* intmode+region, pci */
 	hpsa_disable_interrupt_mode(h);
 	pci_release_regions(h->pdev);
@@ -7022,16 +7030,23 @@ out_disable:
 static void hpsa_free_cmd_pool(struct ctlr_info *h)
 {
 	kfree(h->cmd_pool_bits);
-	if (h->cmd_pool)
+	h->cmd_pool_bits = NULL;
+	if (h->cmd_pool) {
 		pci_free_consistent(h->pdev,
 				h->nr_cmds * sizeof(struct CommandList),
 				h->cmd_pool,
 				h->cmd_pool_dhandle);
-	if (h->errinfo_pool)
+		h->cmd_pool = NULL;
+		h->cmd_pool_dhandle = 0;
+	}
+	if (h->errinfo_pool) {
 		pci_free_consistent(h->pdev,
 				h->nr_cmds * sizeof(struct ErrorInfo),
 				h->errinfo_pool,
 				h->errinfo_pool_dhandle);
+		h->errinfo_pool = NULL;
+		h->errinfo_pool_dhandle = 0;
+	}
 }
 
 static int hpsa_alloc_cmd_pool(struct ctlr_info *h)
@@ -7079,12 +7094,14 @@ static void hpsa_free_irqs(struct ctlr_info *h)
 		i = h->intr_mode;
 		irq_set_affinity_hint(h->intr[i], NULL);
 		free_irq(h->intr[i], &h->q[i]);
+		h->q[i] = 0;
 		return;
 	}
 
 	for (i = 0; i < h->msix_vector; i++) {
 		irq_set_affinity_hint(h->intr[i], NULL);
 		free_irq(h->intr[i], &h->q[i]);
+		h->q[i] = 0;
 	}
 	for (; i < MAX_REPLY_QUEUES; i++)
 		h->q[i] = 0;
@@ -7137,6 +7154,7 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 				intxhandler, IRQF_SHARED, h->devname,
 				&h->q[h->intr_mode]);
 		}
+		irq_set_affinity_hint(h->intr[h->intr_mode], NULL);
 	}
 	if (rc) {
 		dev_err(&h->pdev->dev, "failed to get irq %d for %s\n",
@@ -7181,23 +7199,17 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
 		h->reply_queue[i].head = NULL;
 		h->reply_queue[i].busaddr = 0;
 	}
+	h->reply_queue_size = 0;
 }
 
 static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 {
-	hpsa_free_irqs(h);
-	hpsa_free_sg_chain_blocks(h);
-	hpsa_free_cmd_pool(h);
-	kfree(h->blockFetchTable);		/* perf 2 */
-	hpsa_free_reply_queues(h);		/* perf 1 */
-	hpsa_free_ioaccel1_cmd_and_bft(h);	/* perf 1 */
-	hpsa_free_ioaccel2_cmd_and_bft(h);	/* perf 1 */
-	hpsa_free_cfgtables(h);			/* pci_init 4 */
-	iounmap(h->vaddr);			/* pci_init 3 */
-	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
-	pci_disable_device(h->pdev);
-	pci_release_regions(h->pdev);		/* pci_init 2 */
-	kfree(h);
+	hpsa_free_performant_mode(h);		/* init_one 7 */
+	hpsa_free_sg_chain_blocks(h);		/* init_one 6 */
+	hpsa_free_cmd_pool(h);			/* init_one 5 */
+	hpsa_free_irqs(h);			/* init_one 4 */
+	hpsa_free_pci_init(h);			/* init_one 3 */
+	kfree(h);				/* init_one 1 */
 }
 
 /* Called when controller lockup detected. */
@@ -7464,10 +7476,13 @@ reinit_after_soft_reset:
 	 */
 	BUILD_BUG_ON(sizeof(struct CommandList) % COMMANDLIST_ALIGNMENT);
 	h = kzalloc(sizeof(*h), GFP_KERNEL);
-	if (!h)
+	if (!h) {
+		dev_err(&pdev->dev, "Failed to allocate controller head\n");
 		return -ENOMEM;
+	}
 
 	h->pdev = pdev;
+
 	h->intr_mode = hpsa_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
 	INIT_LIST_HEAD(&h->offline_device_list);
 	spin_lock_init(&h->lock);
@@ -7485,20 +7500,21 @@ reinit_after_soft_reset:
 	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
 	if (!h->resubmit_wq) {
 		rc = -ENOMEM;
-		goto clean1;
+		goto clean1;	/* aer/h */
 	}
 
 	/* Allocate and clear per-cpu variable lockup_detected */
 	h->lockup_detected = alloc_percpu(u32);
 	if (!h->lockup_detected) {
+		dev_err(&h->pdev->dev, "Failed to allocate lockup detector\n");
 		rc = -ENOMEM;
-		goto clean1;
+		goto clean1;	/* wq/aer/h */
 	}
 	set_lockup_detected_for_all_cpus(h, 0);
 
 	rc = hpsa_pci_init(h);
-	if (rc != 0)
-		goto clean1;
+	if (rc)
+		goto clean2;	/* lockup, wq/aer/h */
 
 	sprintf(h->devname, HPSA "%d", number_of_controllers);
 	h->ctlr = number_of_controllers;
@@ -7514,23 +7530,25 @@ reinit_after_soft_reset:
 			dac = 0;
 		} else {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
-			goto clean2;
+			goto clean3;	/* pci, lockup, wq/aer/h */
 		}
 	}
 
 	/* make sure the board interrupts are off */
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 
-	if (hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx))
-		goto clean2;
+	rc = hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx);
+	if (rc)
+		goto clean3;	/* pci, lockup, wq/aer/h */
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
 	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
-		goto clean2_and_free_irqs;
-	if (hpsa_allocate_sg_chain_blocks(h))
-		goto clean4;
+		goto clean4;	/* irq, pci, lockup, wq/aer/h */
+	rc = hpsa_alloc_sg_chain_blocks(h);
+	if (rc)
+		goto clean5;	/* cmd, irq, pci, lockup, wq/aer/h */
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->abort_cmd_wait_queue);
 	h->scan_finished = 1; /* no scan currently in progress */
@@ -7540,9 +7558,12 @@ reinit_after_soft_reset:
 	h->hba_mode_enabled = 0;
 	h->scsi_host = NULL;
 	spin_lock_init(&h->devlock);
-	hpsa_put_ctlr_into_performant_mode(h);
+	rc = hpsa_put_ctlr_into_performant_mode(h);
+	if (rc)
+		goto clean6;	/* sg, cmd, irq, pci, lockup, wq/aer/h */
 
-	/* At this point, the controller is ready to take commands.
+	/*
+	 * At this point, the controller is ready to take commands.
 	 * Now, if reset_devices and the hard reset didn't work, try
 	 * the soft reset and see if that works.
 	 */
@@ -7597,16 +7618,17 @@ reinit_after_soft_reset:
 		goto reinit_after_soft_reset;
 	}
 
-		/* Enable Accelerated IO path at driver layer */
-		h->acciopath_status = 1;
+	/* Enable Accelerated IO path at driver layer */
+	h->acciopath_status = 1;
 
 
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
 	hpsa_hba_inquiry(h);
-	if (hpsa_register_scsi(h)) /* hook ourselves into SCSI subsystem */
-		goto clean4;
+	rc = hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
+	if (rc)
+		goto clean7;
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -7618,22 +7640,32 @@ reinit_after_soft_reset:
 				h->heartbeat_sample_interval);
 	return 0;
 
-clean4:
+clean7: /* perf, sg, cmd, irq, pci, lockup, wq/aer/h */
+	kfree(h->hba_inquiry_data);
+	hpsa_free_performant_mode(h);
+	h->access.set_intr_mask(h, HPSA_INTR_OFF);
+clean6: /* sg, cmd, irq, pci, lockup, wq/aer/h */
 	hpsa_free_sg_chain_blocks(h);
+clean5: /* cmd, irq, pci, lockup, wq/aer/h */
 	hpsa_free_cmd_pool(h);
-	hpsa_free_ioaccel1_cmd_and_bft(h);
-	hpsa_free_ioaccel2_cmd_and_bft(h);
-clean2_and_free_irqs:
+clean4: /* irq, pci, lockup, wq/aer/h */
 	hpsa_free_irqs(h);
-clean2:
+clean3: /* pci, lockup, wq/aer/h */
 	hpsa_free_pci_init(h);
-clean1:
-	if (h->resubmit_wq)
+clean2: /* lockup, wq/aer/h */
+	if (h->lockup_detected) {
+		free_percpu(h->lockup_detected);
+		h->lockup_detected = NULL;
+	}
+clean1:	/* wq/aer/h */
+	if (h->resubmit_wq) {
 		destroy_workqueue(h->resubmit_wq);
-	if (h->rescan_ctlr_wq)
+		h->resubmit_wq = NULL;
+	}
+	if (h->rescan_ctlr_wq) {
 		destroy_workqueue(h->rescan_ctlr_wq);
-	if (h->lockup_detected)
-		free_percpu(h->lockup_detected);
+		h->rescan_ctlr_wq = NULL;
+	}
 	kfree(h);
 	return rc;
 }
@@ -7681,7 +7713,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	hpsa_free_irqs(h);
+	hpsa_free_irqs(h);			/* init_one 4 */
 	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
 }
 
@@ -7689,8 +7721,10 @@ static void hpsa_free_device_info(struct ctlr_info *h)
 {
 	int i;
 
-	for (i = 0; i < h->ndevices; i++)
+	for (i = 0; i < h->ndevices; i++) {
 		kfree(h->dev[i]);
+		h->dev[i] = NULL;
+	}
 }
 
 static void hpsa_remove_one(struct pci_dev *pdev)
@@ -7712,26 +7746,29 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&h->rescan_ctlr_work);
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
-	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 
-	/* includes hpsa_free_irqs */
+	/* includes hpsa_free_irqs - init_one 4 */
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
 	hpsa_shutdown(pdev);
 
-	hpsa_free_device_info(h);
-	hpsa_free_sg_chain_blocks(h);
-	kfree(h->blockFetchTable);		/* perf 2 */
-	hpsa_free_reply_queues(h);		/* perf 1 */
-	hpsa_free_ioaccel1_cmd_and_bft(h);	/* perf 1 */
-	hpsa_free_ioaccel2_cmd_and_bft(h);	/* perf 1 */
-	hpsa_free_cmd_pool(h);			/* init_one 5 */
-	kfree(h->hba_inquiry_data);
+	hpsa_free_device_info(h);		/* scan */
+
+	hpsa_unregister_scsi(h);			/* init_one "8" */
+	kfree(h->hba_inquiry_data);			/* init_one "8" */
+	h->hba_inquiry_data = NULL;			/* init_one "8" */
+	hpsa_free_performant_mode(h);			/* init_one 7 */
+	hpsa_free_sg_chain_blocks(h);			/* init_one 6 */
+	hpsa_free_cmd_pool(h);				/* init_one 5 */
+
+	/* hpsa_free_irqs already called via hpsa_shutdown init_one 4 */
 
 	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
-	hpsa_free_pci_init(h);
+	hpsa_free_pci_init(h);				/* init_one 3 */
 
-	free_percpu(h->lockup_detected);
-	kfree(h);
+	free_percpu(h->lockup_detected);		/* init_one 2 */
+	h->lockup_detected = NULL;			/* init_one 2 */
+	/* (void) pci_disable_pcie_error_reporting(pdev); */	/* init_one 1 */
+	kfree(h);					/* init_one 1 */
 }
 
 static int hpsa_suspend(__attribute__((unused)) struct pci_dev *pdev,
@@ -7789,7 +7826,10 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
-/* return -ENODEV or other reason on error, 0 on success */
+/*
+ * return -ENODEV on err, 0 on success (or no action)
+ * allocates numerous items that must be freed later
+ */
 static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 {
 	int i;
@@ -7974,12 +8014,16 @@ static int hpsa_enter_performant_mode(struct ctlr_info *h, u32 trans_support)
 /* Free ioaccel1 mode command blocks and block fetch table */
 static void hpsa_free_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 {
-	if (h->ioaccel_cmd_pool)
+	if (h->ioaccel_cmd_pool) {
 		pci_free_consistent(h->pdev,
 			h->nr_cmds * sizeof(*h->ioaccel_cmd_pool),
 			h->ioaccel_cmd_pool,
 			h->ioaccel_cmd_pool_dhandle);
+		h->ioaccel_cmd_pool = NULL;
+		h->ioaccel_cmd_pool_dhandle = 0;
+	}
 	kfree(h->ioaccel1_blockFetchTable);
+	h->ioaccel1_blockFetchTable = NULL;
 }
 
 /* Allocate ioaccel1 mode command blocks and block fetch table */
@@ -8023,12 +8067,16 @@ static void hpsa_free_ioaccel2_cmd_and_bft(struct ctlr_info *h)
 {
 	hpsa_free_ioaccel2_sg_chain_blocks(h);
 
-	if (h->ioaccel2_cmd_pool)
+	if (h->ioaccel2_cmd_pool) {
 		pci_free_consistent(h->pdev,
 			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
 			h->ioaccel2_cmd_pool,
 			h->ioaccel2_cmd_pool_dhandle);
+		h->ioaccel2_cmd_pool = NULL;
+		h->ioaccel2_cmd_pool_dhandle = 0;
+	}
 	kfree(h->ioaccel2_blockFetchTable);
+	h->ioaccel2_blockFetchTable = NULL;
 }
 
 /* Allocate ioaccel2 mode command blocks and block fetch table */
@@ -8073,33 +8121,46 @@ clean_up:
 	return rc;
 }
 
-static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
+/* Free items allocated by hpsa_put_ctlr_into_performant_mode */
+static void hpsa_free_performant_mode(struct ctlr_info *h)
+{
+	kfree(h->blockFetchTable);
+	h->blockFetchTable = NULL;
+	hpsa_free_reply_queues(h);
+	hpsa_free_ioaccel1_cmd_and_bft(h);
+	hpsa_free_ioaccel2_cmd_and_bft(h);
+}
+
+/* return -ENODEV on error, 0 on success (or no action)
+ * allocates numerous items that must be freed later
+ */
+static int hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
 	unsigned long transMethod = CFGTBL_Trans_Performant |
 					CFGTBL_Trans_use_short_tags;
-	int i;
+	int i, rc;
 
 	if (hpsa_simple_mode)
-		return;
+		return 0;
 
 	trans_support = readl(&(h->cfgtable->TransportSupport));
 	if (!(trans_support & PERFORMANT_MODE))
-		return;
+		return 0;
 
 	/* Check for I/O accelerator mode support */
 	if (trans_support & CFGTBL_Trans_io_accel1) {
 		transMethod |= CFGTBL_Trans_io_accel1 |
 				CFGTBL_Trans_enable_directed_msix;
-		if (hpsa_alloc_ioaccel1_cmd_and_bft(h))
-			goto clean_up;
-	} else {
-		if (trans_support & CFGTBL_Trans_io_accel2) {
-				transMethod |= CFGTBL_Trans_io_accel2 |
+		rc = hpsa_alloc_ioaccel1_cmd_and_bft(h);
+		if (rc)
+			return rc;
+	} else if (trans_support & CFGTBL_Trans_io_accel2) {
+		transMethod |= CFGTBL_Trans_io_accel2 |
 				CFGTBL_Trans_enable_directed_msix;
-		if (hpsa_alloc_ioaccel2_cmd_and_bft(h))
-			goto clean_up;
-		}
+		rc = hpsa_alloc_ioaccel2_cmd_and_bft(h);
+		if (rc)
+			return rc;
 	}
 
 	h->nreply_queues = h->msix_vector > 0 ? h->msix_vector : 1;
@@ -8111,8 +8172,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 		h->reply_queue[i].head = pci_alloc_consistent(h->pdev,
 						h->reply_queue_size,
 						&(h->reply_queue[i].busaddr));
-		if (!h->reply_queue[i].head)
-			goto clean_up;
+		if (!h->reply_queue[i].head) {
+			rc = -ENOMEM;
+			goto clean1;	/* rq, ioaccel */
+		}
 		h->reply_queue[i].size = h->max_commands;
 		h->reply_queue[i].wraparound = 1;  /* spec: init to 1 */
 		h->reply_queue[i].current_entry = 0;
@@ -8121,15 +8184,24 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	/* Need a block fetch table for performant mode */
 	h->blockFetchTable = kmalloc(((SG_ENTRIES_IN_CMD + 1) *
 				sizeof(u32)), GFP_KERNEL);
-	if (!h->blockFetchTable)
-		goto clean_up;
+	if (!h->blockFetchTable) {
+		rc = -ENOMEM;
+		goto clean1;	/* rq, ioaccel */
+	}
 
-	hpsa_enter_performant_mode(h, trans_support);
-	return;
+	rc = hpsa_enter_performant_mode(h, trans_support);
+	if (rc)
+		goto clean2;	/* bft, rq, ioaccel */
+	return 0;
 
-clean_up:
-	hpsa_free_reply_queues(h);
+clean2:	/* bft, rq, ioaccel */
 	kfree(h->blockFetchTable);
+	h->blockFetchTable = NULL;
+clean1:	/* rq, ioaccel */
+	hpsa_free_reply_queues(h);
+	hpsa_free_ioaccel1_cmd_and_bft(h);
+	hpsa_free_ioaccel2_cmd_and_bft(h);
+	return rc;
 }
 
 static int is_accelerated_cmd(struct CommandList *c)

