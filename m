From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH V2 2/4] be2iscsi : Fix the PCI request region reserving.
Date: Sat, 20 Dec 2014 06:22:14 +0530
Message-ID: <003632b9-7569-485e-84e6-96bd050f3e33@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:55123 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaLSIZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2014 03:25:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Reserve the device PCI I/O and Memory resources.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 98490da..2f5eb9c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -670,14 +670,20 @@ static int beiscsi_enable_pci(struct pci_dev *pcidev)
 		return ret;
 	}
 
+	ret = pci_request_regions(pcidev, DRV_NAME);
+	if (ret) {
+		dev_err(&pcidev->dev,
+				"beiscsi_enable_pci - request region failed\n");
+		goto pci_dev_disable;
+	}
+
 	pci_set_master(pcidev);
 	ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
 	if (ret) {
 		ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
 		if (ret) {
 			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
-			pci_disable_device(pcidev);
-			return ret;
+			goto pci_region_release;
 		} else {
 			ret = pci_set_consistent_dma_mask(pcidev,
 							  DMA_BIT_MASK(32));
@@ -686,11 +692,17 @@ static int beiscsi_enable_pci(struct pci_dev *pcidev)
 		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64));
 		if (ret) {
 			dev_err(&pcidev->dev, "Could not set PCI DMA Mask\n");
-			pci_disable_device(pcidev);
-			return ret;
+			goto pci_region_release;
 		}
 	}
 	return 0;
+
+pci_region_release:
+	pci_release_regions(pcidev);
+pci_dev_disable:
+	pci_disable_device(pcidev);
+
+	return ret;
 }
 
 static int be_ctrl_init(struct beiscsi_hba *phba, struct pci_dev *pdev)
@@ -5277,6 +5289,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	iscsi_host_free(phba->shost);
 	pci_disable_pcie_error_reporting(pcidev);
 	pci_set_drvdata(pcidev, NULL);
+	pci_release_regions(pcidev);
 	pci_disable_device(pcidev);
 }
 
@@ -5757,6 +5770,7 @@ hba_free:
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
 disable_pci:
+	pci_release_regions(pcidev);
 	pci_disable_device(pcidev);
 	return ret;
 }
-- 
1.7.1

