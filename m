From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 1/2] megaraid_sas: Use 63-bit DMA addressing
Date: Tue, 18 Dec 2018 05:59:54 -0800
Message-ID: <1545141595-1467-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1545141595-1467-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1545141595-1467-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Although MegaRAID controllers support 64-bit DMA addressing,
as per hardware design, DMA address with all 64-bits set
(0xFFFFFFFF-FFFFFFFF) results in a firmware fault.

Fix -
Driver will set 63-bit DMA mask to ensure the above address
will not be used.

Cc: stable@vger.kernel.org
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b2d11e8f56b5..634cc8aed1c7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6185,13 +6185,13 @@ static int megasas_io_attach(struct megasas_instance *instance)
  * @instance:		Adapter soft state
  * Description:
  *
- * For Ventura, driver/FW will operate in 64bit DMA addresses.
+ * For Ventura, driver/FW will operate in 63bit DMA addresses.
  *
  * For invader-
  *	By default, driver/FW will operate in 32bit DMA addresses
  *	for consistent DMA mapping but if 32 bit consistent
- *	DMA mask fails, driver will try with 64 bit consistent
- *	mask provided FW is true 64bit DMA capable
+ *	DMA mask fails, driver will try with 63 bit consistent
+ *	mask provided FW is true 63bit DMA capable
  *
  * For older controllers(Thunderbolt and MFI based adapters)-
  *	driver/FW will operate in 32 bit consistent DMA addresses.
@@ -6205,14 +6205,14 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 
 	pdev = instance->pdev;
 	consistent_mask = (instance->adapter_type >= VENTURA_SERIES) ?
-				DMA_BIT_MASK(64) : DMA_BIT_MASK(32);
+				DMA_BIT_MASK(63) : DMA_BIT_MASK(32);
 
 	if (IS_DMA64) {
-		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
+		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(63)) &&
 		    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
 			goto fail_set_dma_mask;
 
-		if ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) &&
+		if ((*pdev->dev.dma_mask == DMA_BIT_MASK(63)) &&
 		    (dma_set_coherent_mask(&pdev->dev, consistent_mask) &&
 		     dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))) {
 			/*
@@ -6225,7 +6225,7 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 			if (!(scratch_pad_1 & MR_CAN_HANDLE_64_BIT_DMA_OFFSET))
 				goto fail_set_dma_mask;
 			else if (dma_set_mask_and_coherent(&pdev->dev,
-							   DMA_BIT_MASK(64)))
+							   DMA_BIT_MASK(63)))
 				goto fail_set_dma_mask;
 		}
 	} else if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
@@ -6237,8 +6237,8 @@ megasas_set_dma_mask(struct megasas_instance *instance)
 		instance->consistent_mask_64bit = true;
 
 	dev_info(&pdev->dev, "%s bit DMA mask and %s bit consistent mask\n",
-		 ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) ? "64" : "32"),
-		 (instance->consistent_mask_64bit ? "64" : "32"));
+		 ((*pdev->dev.dma_mask == DMA_BIT_MASK(64)) ? "63" : "32"),
+		 (instance->consistent_mask_64bit ? "63" : "32"));
 
 	return 0;
 
-- 
2.16.1
