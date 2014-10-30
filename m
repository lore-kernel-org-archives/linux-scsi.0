From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ipr: set coherent DMA mask
Date: Thu, 30 Oct 2014 17:27:09 -0500
Message-ID: <201410302227.s9UMR9mR001183@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49602 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161277AbaJ3W1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 18:27:13 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 30 Oct 2014 18:27:12 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 76DC66E8045
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 18:27:10 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9UMRBGZ61669626
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 22:27:11 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9UMRALd001211
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2014 18:27:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, anton@samba.org


From: Anton Blanchard <anton@samba.org>

Use dma_set_mask_and_coherent() to set both the DMA and coherent
DMA mask.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_set_coherent_DMA_mask drivers/scsi/ipr.c
--- scsi-queue/drivers/scsi/ipr.c~ipr_set_coherent_DMA_mask	2014-10-30 17:15:30.007820722 -0500
+++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-10-30 17:15:30.013820667 -0500
@@ -9621,16 +9621,17 @@ static int ipr_probe_ioa(struct pci_dev 
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
 
_

