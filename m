From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] isci: switch to pci_alloc_irq_vectors
Date: Wed, 30 Nov 2016 17:21:01 +0100
Message-ID: <1480522861-18096-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbcK3QVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2016 11:21:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, artur.paszkiewicz@intel.com
Cc: intel-linux-scu@intel.com, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/isci/host.h |  1 -
 drivers/scsi/isci/init.c | 23 ++++++++++-------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 22a9bb1..b353992 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -295,7 +295,6 @@ enum sci_controller_states {
 #define SCI_MAX_MSIX_INT (SCI_NUM_MSI_X_INT*SCI_MAX_CONTROLLERS)
 
 struct isci_pci_info {
-	struct msix_entry msix_entries[SCI_MAX_MSIX_INT];
 	struct isci_host *hosts[SCI_MAX_CONTROLLERS];
 	struct isci_orom *orom;
 };
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 77128d68..0b5b5db 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -350,16 +350,12 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 	 */
 	num_msix = num_controllers(pdev) * SCI_NUM_MSI_X_INT;
 
-	for (i = 0; i < num_msix; i++)
-		pci_info->msix_entries[i].entry = i;
-
-	err = pci_enable_msix_exact(pdev, pci_info->msix_entries, num_msix);
-	if (err)
+	err = pci_alloc_irq_vectors(pdev, num_msix, num_msix, PCI_IRQ_MSIX);
+	if (err < 0)
 		goto intx;
 
 	for (i = 0; i < num_msix; i++) {
 		int id = i / SCI_NUM_MSI_X_INT;
-		struct msix_entry *msix = &pci_info->msix_entries[i];
 		irq_handler_t isr;
 
 		ihost = pci_info->hosts[id];
@@ -369,8 +365,8 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 		else
 			isr = isci_msix_isr;
 
-		err = devm_request_irq(&pdev->dev, msix->vector, isr, 0,
-				       DRV_NAME"-msix", ihost);
+		err = devm_request_irq(&pdev->dev, pci_irq_vector(pdev, i),
+				isr, 0, DRV_NAME"-msix", ihost);
 		if (!err)
 			continue;
 
@@ -378,18 +374,19 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 		while (i--) {
 			id = i / SCI_NUM_MSI_X_INT;
 			ihost = pci_info->hosts[id];
-			msix = &pci_info->msix_entries[i];
-			devm_free_irq(&pdev->dev, msix->vector, ihost);
+			devm_free_irq(&pdev->dev, pci_irq_vector(pdev, i),
+					ihost);
 		}
-		pci_disable_msix(pdev);
+		pci_free_irq_vectors(pdev);
 		goto intx;
 	}
 	return 0;
 
  intx:
 	for_each_isci_host(i, ihost, pdev) {
-		err = devm_request_irq(&pdev->dev, pdev->irq, isci_intx_isr,
-				       IRQF_SHARED, DRV_NAME"-intx", ihost);
+		err = devm_request_irq(&pdev->dev, pci_irq_vector(pdev, 0),
+				isci_intx_isr, IRQF_SHARED, DRV_NAME"-intx",
+				ihost);
 		if (err)
 			break;
 	}
-- 
2.1.4

