From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 16/41] hpsa: break hpsa_free_irqs_and_disable_msix into
 two functions
Date: Fri, 06 Mar 2015 17:47:12 -0600
Message-ID: <20150306234712.29973.63719.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:50780 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbbCFXsm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:48:42 -0500
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 353874516
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2015 23:48:42 +0000 (UTC)
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 229366b..177a38f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6405,10 +6405,22 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 	return -1;
 }
 
+static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
+{
+#ifdef CONFIG_PCI_MSI
+	if (h->msix_vector) {
+		if (h->pdev->msix_enabled)
+			pci_disable_msix(h->pdev);
+	} else if (h->msi_vector) {
+		if (h->pdev->msi_enabled)
+			pci_disable_msi(h->pdev);
+	}
+#endif /* CONFIG_PCI_MSI */
+}
+
 /* If MSI/MSI-X is supported by the kernel we will try to enable it on
  * controllers that are capable. If not, we use legacy INTx mode.
  */
-
 static void hpsa_interrupt_mode(struct ctlr_info *h)
 {
 #ifdef CONFIG_PCI_MSI
@@ -7049,20 +7061,6 @@ static int hpsa_kdump_soft_reset(struct ctlr_info *h)
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
@@ -7079,7 +7077,7 @@ static void hpsa_free_reply_queues(struct ctlr_info *h)
 
 static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 {
-	hpsa_free_irqs_and_disable_msix(h);
+	hpsa_free_irqs(h);
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
 	kfree(h->ioaccel1_blockFetchTable);
@@ -7091,6 +7089,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		iounmap(h->transtable);
 	if (h->cfgtable)
 		iounmap(h->cfgtable);
+	hpsa_disable_interrupt_mode(h);
 	pci_disable_device(h->pdev);
 	pci_release_regions(h->pdev);
 	kfree(h);
@@ -7579,7 +7578,8 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	 */
 	hpsa_flush_cache(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-	hpsa_free_irqs_and_disable_msix(h);
+	hpsa_free_irqs(h);
+	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
 }
 
 static void hpsa_free_device_info(struct ctlr_info *h)
@@ -7610,7 +7610,10 @@ static void hpsa_remove_one(struct pci_dev *pdev)
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

