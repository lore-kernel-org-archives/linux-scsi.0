From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH] Do not set DMA mask to 32 bit first if adapter only supports 31
Date: Sun, 26 Jul 2009 12:25:05 +0200
Message-ID: <200907261225.07806.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:52967 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZGZKb7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2009 06:31:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/scsi/aacraid/linit.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9b97c3e..7e0d05a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1082,6 +1082,7 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 	struct list_head *insert = &aac_devices;
 	int error = -ENODEV;
 	int unique_id = 0;
+	u64 dmamask;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id > unique_id)
@@ -1095,17 +1096,18 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 		goto out;
 	error = -ENODEV;
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))
-		goto out_disable_pdev;
 	/*
 	 * If the quirk31 bit is set, the adapter needs adapter
 	 * to driver communication memory to be allocated below 2gig
 	 */
 	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
-		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(31)) ||
-				pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(31)))
-			goto out_disable_pdev;
+		dmamask = DMA_BIT_MASK(31);
+	else
+		dmamask = DMA_BIT_MASK(32);
+
+	if (pci_set_dma_mask(pdev, dmamask) ||
+			pci_set_consistent_dma_mask(pdev, dmamask))
+		goto out_disable_pdev;
 
 	pci_set_master(pdev);
 
-- 
1.6.0.2

