From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 17/42] hpsa: clean up error handling
Date: Tue, 17 Mar 2015 15:03:57 -0500
Message-ID: <20150317200357.19856.32749.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54504 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbbCQUFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:05:36 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

refactor error cleanup and shutdown
disable interrupts and pci_disable_device on critical failures
add hpsa_free_cfgtables function

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   92 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c98c591..3559425a4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6546,6 +6546,17 @@ static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 	return 0;
 }
 
+static void hpsa_free_cfgtables(struct ctlr_info *h)
+{
+	if (h->transtable)
+		iounmap(h->transtable);
+	if (h->cfgtable)
+		iounmap(h->cfgtable);
+}
+
+/* Find and map CISS config table and transfer table
++ * several items must be unmapped (freed) later
++ * */
 static int hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;
@@ -6572,8 +6583,11 @@ static int hpsa_find_cfgtables(struct ctlr_info *h)
 	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
 				cfg_base_addr_index)+cfg_offset+trans_offset,
 				sizeof(*h->transtable));
-	if (!h->transtable)
+	if (!h->transtable) {
+		dev_err(&h->pdev->dev, "Failed mapping transfer table\n");
+		hpsa_free_cfgtables(h);
 		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -6749,6 +6763,17 @@ error:
 	return -ENODEV;
 }
 
+/* free items allocated or mapped by hpsa_pci_init */
+static void hpsa_free_pci_init(struct ctlr_info *h)
+{
+	hpsa_free_cfgtables(h);			/* pci_init 4 */
+	iounmap(h->vaddr);			/* pci_init 3 */
+	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
+	pci_release_regions(h->pdev);		/* pci_init 2 */
+	pci_disable_device(h->pdev);		/* pci_init 1 */
+}
+
+/* several items must be freed later */
 static int hpsa_pci_init(struct ctlr_info *h)
 {
 	int prod_index, err;
@@ -6767,15 +6792,15 @@ static int hpsa_pci_init(struct ctlr_info *h)
 
 	err = pci_enable_device(h->pdev);
 	if (err) {
-		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");
+		dev_err(&h->pdev->dev, "failed to enable PCI device\n");
 		return err;
 	}
 
 	err = pci_request_regions(h->pdev, HPSA);
 	if (err) {
 		dev_err(&h->pdev->dev,
-			"cannot obtain PCI resources, aborting\n");
-		return err;
+			"failed to obtain PCI resources\n");
+		goto clean1;	/* pci */
 	}
 
 	pci_set_master(h->pdev);
@@ -6783,40 +6808,41 @@ static int hpsa_pci_init(struct ctlr_info *h)
 	hpsa_interrupt_mode(h);
 	err = hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
-		goto err_out_free_res;
+		goto clean2;	/* intmode+region, pci */
 	h->vaddr = remap_pci_mem(h->paddr, 0x250);
 	if (!h->vaddr) {
+		dev_err(&h->pdev->dev, "failed to remap PCI mem\n");
 		err = -ENOMEM;
-		goto err_out_free_res;
+		goto clean2;	/* intmode+region, pci */
 	}
 	err = hpsa_wait_for_board_state(h->pdev, h->vaddr, BOARD_READY);
 	if (err)
-		goto err_out_free_res;
+		goto clean3;	/* vaddr, intmode+region, pci */
 	err = hpsa_find_cfgtables(h);
 	if (err)
-		goto err_out_free_res;
+		goto clean3;	/* vaddr, intmode+region, pci */
 	hpsa_find_board_params(h);
 
 	if (!hpsa_CISS_signature_present(h)) {
 		err = -ENODEV;
-		goto err_out_free_res;
+		goto clean4;	/* cfgtables, vaddr, intmode+region, pci */
 	}
 	hpsa_set_driver_support_bits(h);
 	hpsa_p600_dma_prefetch_quirk(h);
 	err = hpsa_enter_simple_mode(h);
 	if (err)
-		goto err_out_free_res;
+		goto clean4;	/* cfgtables, vaddr, intmode+region, pci */
 	return 0;
 
-err_out_free_res:
-	if (h->transtable)
-		iounmap(h->transtable);
-	if (h->cfgtable)
-		iounmap(h->cfgtable);
-	if (h->vaddr)
-		iounmap(h->vaddr);
-	pci_disable_device(h->pdev);
+clean4:	/* cfgtables, vaddr, intmode+region, pci */
+	hpsa_free_cfgtables(h);
+clean3:	/* vaddr, intmode+region, pci */
+	iounmap(h->vaddr);
+clean2:	/* intmode+region, pci */
+	hpsa_disable_interrupt_mode(h);
 	pci_release_regions(h->pdev);
+clean1:	/* pci */
+	pci_disable_device(h->pdev);
 	return err;
 }
 
@@ -7025,8 +7051,9 @@ static int hpsa_request_irqs(struct ctlr_info *h,
 		}
 	}
 	if (rc) {
-		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
+		dev_err(&h->pdev->dev, "failed to get irq %d for %s\n",
 		       h->intr[h->intr_mode], h->devname);
+		hpsa_free_irqs(h);
 		return -ENODEV;
 	}
 	return 0;
@@ -7078,15 +7105,11 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 	kfree(h->ioaccel1_blockFetchTable);
 	kfree(h->blockFetchTable);
 	hpsa_free_reply_queues(h);
-	if (h->vaddr)
-		iounmap(h->vaddr);
-	if (h->transtable)
-		iounmap(h->transtable);
-	if (h->cfgtable)
-		iounmap(h->cfgtable);
-	hpsa_disable_interrupt_mode(h);
+	hpsa_free_cfgtables(h);			/* pci_init 4 */
+	iounmap(h->vaddr);			/* pci_init 3 */
+	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
 	pci_disable_device(h->pdev);
-	pci_release_regions(h->pdev);
+	pci_release_regions(h->pdev);		/* pci_init 2 */
 	kfree(h);
 }
 
@@ -7404,7 +7427,7 @@ reinit_after_soft_reset:
 			dac = 0;
 		} else {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
-			goto clean1;
+			goto clean2;
 		}
 	}
 
@@ -7515,6 +7538,7 @@ clean4:
 clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
+	hpsa_free_pci_init(h);
 clean1:
 	if (h->resubmit_wq)
 		destroy_workqueue(h->resubmit_wq);
@@ -7606,12 +7630,10 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	destroy_workqueue(h->resubmit_wq);
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
 
-	/* includes hpsa_free_irqs and hpsa_disable_interrupt_mode */
+	/* includes hpsa_free_irqs */
+	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
 	hpsa_shutdown(pdev);
 
-	iounmap(h->vaddr);
-	iounmap(h->transtable);
-	iounmap(h->cfgtable);
 	hpsa_free_device_info(h);
 	hpsa_free_sg_chain_blocks(h);
 	pci_free_consistent(h->pdev,
@@ -7626,8 +7648,10 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	kfree(h->ioaccel1_blockFetchTable);
 	kfree(h->ioaccel2_blockFetchTable);
 	kfree(h->hba_inquiry_data);
-	pci_disable_device(pdev);
-	pci_release_regions(pdev);
+
+	/* includes hpsa_disable_interrupt_mode - pci_init 2 */
+	hpsa_free_pci_init(h);
+
 	free_percpu(h->lockup_detected);
 	kfree(h);
 }

