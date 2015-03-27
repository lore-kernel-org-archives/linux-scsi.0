From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] am53c974: Fix crash during modprobe
Date: Fri, 27 Mar 2015 08:29:03 +0100
Message-ID: <1427441343-122454-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbbC0H3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 03:29:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On systems with shared interrupts the interrupt routine might
be called as soon as the interrupt is enabled.
As this might happen before pci_set_drvdata() is called the
system would crash.

Reported-by: Andreas Brogle <anbro@ok.de>
Tested-by: Andreas Brogle <anbro@ok.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/am53c974.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index a6f5ee8..3a35502 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -144,6 +144,9 @@ static int pci_esp_irq_pending(struct esp *esp)
 {
 	struct pci_esp_priv *pep = pci_esp_get_priv(esp);
 
+	if (!pep)
+		return 0;
+
 	pep->dma_status = pci_esp_read8(esp, ESP_DMA_STATUS);
 	esp_dma_log("dma intr dreg[%02x]\n", pep->dma_status);
 
@@ -476,6 +479,8 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 		goto fail_unmap_regs;
 	}
 
+	pci_set_drvdata(pdev, pep);
+
 	err = request_irq(pdev->irq, scsi_esp_intr, IRQF_SHARED,
 			  DRV_MODULE_NAME, esp);
 	if (err < 0) {
@@ -496,8 +501,6 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 	/* Assume 40MHz clock */
 	esp->cfreq = 40000000;
 
-	pci_set_drvdata(pdev, pep);
-
 	err = scsi_esp_register(esp, &pdev->dev);
 	if (err)
 		goto fail_free_irq;
@@ -507,6 +510,7 @@ static int pci_esp_probe_one(struct pci_dev *pdev,
 fail_free_irq:
 	free_irq(pdev->irq, esp);
 fail_unmap_command_block:
+	pci_set_drvdata(pdev, NULL);
 	pci_free_consistent(pdev, 16, esp->command_block,
 			    esp->command_block_dma);
 fail_unmap_regs:
@@ -530,6 +534,7 @@ static void pci_esp_remove_one(struct pci_dev *pdev)
 
 	scsi_esp_unregister(esp);
 	free_irq(pdev->irq, esp);
+	pci_set_drvdata(pdev, NULL);
 	pci_free_consistent(pdev, 16, esp->command_block,
 			    esp->command_block_dma);
 	pci_iounmap(pdev, esp->regs);
-- 
1.8.5.2

