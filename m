From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 7/8] be2iscsi : Fix DMA Out of SW-IOMMU space error
Date: Wed, 29 Jan 2014 02:16:45 -0500
Message-ID: <1390979807-16718-7-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44733 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaA2HRH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 02:17:07 -0500
Received: by mail-pb0-f54.google.com with SMTP id uo5so1407317pbc.41
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 23:17:07 -0800 (PST)
In-Reply-To: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Setting DMA bit mask 64 and roll back to 32 if not supported.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d9bd4b9..dd7eb12 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -681,8 +681,19 @@ static int beiscsi_enable_pci(struct pci_dev *pcidev)
 	}
 
 	pci_set_master(pcidev);
-	if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
-		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
+	ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
+	if (ret) {
+		ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
+			pci_disable_device(pcidev);
+			return ret;
+		} else {
+			ret = pci_set_consistent_dma_mask(pcidev,
+							  DMA_BIT_MASK(32));
+		}
+	} else {
+		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64));
 		if (ret) {
 			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
 			pci_disable_device(pcidev);
-- 
1.8.5.3

