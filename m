From: Anton Blanchard <anton@samba.org>
Subject: [PATCH 2/2] ipr: set coherent DMA mask
Date: Mon, 13 Oct 2014 20:14:36 +1100
Message-ID: <1413191676-1663-2-git-send-email-anton@samba.org>
References: <1413191676-1663-1-git-send-email-anton@samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:60552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbaJMJOl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2014 05:14:41 -0400
In-Reply-To: <1413191676-1663-1-git-send-email-anton@samba.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, scottwood@freescale.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org

Use dma_set_mask_and_coherent() to set both the DMA and coherent
DMA mask.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
 drivers/scsi/ipr.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 3aa28bd..15f4575 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9611,16 +9611,17 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 	ipr_init_regs(ioa_cfg);
 
 	if (ioa_cfg->sis64) {
-		rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 		if (rc < 0) {
-			dev_dbg(&pdev->dev, "Failed to set 64 bit PCI DMA mask\n");
-			rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+			dev_dbg(&pdev->dev, "Failed to set 64 bit DMA mask\n");
+			rc = dma_set_mask_and_coherent(&pdev->dev,
+						       DMA_BIT_MASK(32));
 		}
 	} else
-		rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 
 	if (rc < 0) {
-		dev_err(&pdev->dev, "Failed to set PCI DMA mask\n");
+		dev_err(&pdev->dev, "Failed to set DMA mask\n");
 		goto cleanup_nomem;
 	}
 
-- 
1.9.1

