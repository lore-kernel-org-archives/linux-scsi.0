From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 16/42] hpsa: break hpsa_free_irqs_and_disable_msix into
 two functions
Date: Tue, 17 Mar 2015 15:03:52 -0500
Message-ID: <20150317200351.19856.45360.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59240 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbbCQUFb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:05:31 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

replace calls to hpsa_free_irqs_and_disable_msix with
hpsa_free_irqs and hpsa_disable_interrupt_mode

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3fa72a1..c98c591 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6402,10 +6402,20 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 	return -1;
 }
 
+static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
+{
+	if (h->msix_vector) {
+		if (h->pdev->msix_enabled)
+			pci_disable_msix(h->pdev);
+	} else if (h->msi_vector) {
+		if (h->pdev->msi_enabled)
+			pci_disable_msi(h->pdev);
+	}
+}
+
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
  * controllers that are capable. If not, we use legacy INTx mode.
  */
-
 static void hpsa_interrupt_mode(struct ctlr_info *h)
 {
 #ifdef CONFIG_PCI_MSI
@@ -7046,20 +7056,6 @@ static int hpsa_kdump_soft_reset(struct ctlr_info *h)
 	return 0;
 }
 
-static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)
-{
-	hpsa_free_irqs(h);
-#ifdef CONFIG_PCI_MSI
-	if (h->msix_vector) {
-		if (h->pdev->msix_enabled)
-			pci_disable_msix(h->pdev);
-	} else if (h->msi_vector) {
-		if (h->pdev->msi_enabled)
-			pci_disable_msi(h->pdev);
-	}
-#endif /* CONFIG_PCI_MSI */
-}
-
 static void hpsa_free_reply_queues(struct ctlr_info *h)
 {
 	int i;
@@ -7076,7 +7072,7 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
 
 static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 {
-	hpsa_free_irqs_and_disable_msix(h);
+	hpsa_free_irqs(h);
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
 	kfree(h->ioaccel1_blockFetchTable);
@@ -7088,6 +7084,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		iounmap(h->transtable);
 	if (h->cfgtable)
 		iounmap(h->cfgtable);
+	hpsa_disable_interrupt_mode(h);
 	pci_disable_device(h->pdev);
 	pci_release_regions(h->pdev);
 	kfree(h);
@@ -7576,7 +7573,8 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	hpsa_free_irqs_and_disable_msix(h);
+	hpsa_free_irqs(h);
+	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
 }
 
 static void hpsa_free_device_info(struct ctlr_info *h)
@@ -7607,7 +7605,10 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
 	hpsa_unregister_scsi(h);	/* unhook from SCSI subsystem */
+
+	/* includes hpsa_free_irqs and hpsa_disable_interrupt_mode */
 	hpsa_shutdown(pdev);
+
 	iounmap(h->vaddr);
 	iounmap(h->transtable);
 	iounmap(h->cfgtable);

