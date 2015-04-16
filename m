From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 16/43] hpsa: break hpsa_free_irqs_and_disable_msix into
 two functions
Date: Thu, 16 Apr 2015 08:48:09 -0500
Message-ID: <20150416134809.30238.43519.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:49346 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbbDPNtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:49:12 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
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
index ad2b44c..b743f1a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6375,10 +6375,20 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
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
@@ -7019,20 +7029,6 @@ static int hpsa_kdump_soft_reset(struct ctlr_info *h)
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
@@ -7049,7 +7045,7 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
 
 static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 {
-	hpsa_free_irqs_and_disable_msix(h);
+	hpsa_free_irqs(h);
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
 	kfree(h->ioaccel1_blockFetchTable);
@@ -7061,6 +7057,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		iounmap(h->transtable);
 	if (h->cfgtable)
 		iounmap(h->cfgtable);
+	hpsa_disable_interrupt_mode(h);
 	pci_disable_device(h->pdev);
 	pci_release_regions(h->pdev);
 	kfree(h);
@@ -7550,7 +7547,8 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	hpsa_free_irqs_and_disable_msix(h);
+	hpsa_free_irqs(h);
+	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
 }
 
 static void hpsa_free_device_info(struct ctlr_info *h)
@@ -7581,7 +7579,10 @@ static void hpsa_remove_one(struct pci_dev *pdev)
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

