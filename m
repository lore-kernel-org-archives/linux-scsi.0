Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C40EC48BCF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 08:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD2A61222
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 08:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhFMIZa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 04:25:30 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:59187 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhFMIZ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 04:25:28 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d41 with ME
        id GYPS2500221Fzsu03YPSex; Sun, 13 Jun 2021 10:23:26 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 10:23:26 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 3/3] scsi: mptbase: use 'dma_set_mask_and_coherent()' to simplify code
Date:   Sun, 13 Jun 2021 10:23:24 +0200
Message-Id: <a93e5e750d9d7bbbd873eaa4de2f968341ade7f3.1623571676.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1623571676.git.christophe.jaillet@wanadoo.fr>
References: <cover.1623571676.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use 'dma_set_mask_and_coherent()' instead of
'dma_set_mask()/dma_set_coherent_mask()', it is less verbose.

While at it, fix a typo in a comment (s/Reseting/Resetting/).

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The code about the "1078 errata workaround" (around line 4449) looks
spurious to me. Test, value of 'dma_mask' and message are all about 35 bit
addressing, BUT the code uses DMA_BIT_MASK(32).
Having 35 here would look more logical to me

Just my 2 cents.
---
 drivers/message/fusion/mptbase.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 2add74f92323..ad3f5d8a5f7c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1665,15 +1665,14 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	if (sizeof(dma_addr_t) > 4) {
 		const uint64_t required_mask = dma_get_required_mask
 		    (&pdev->dev);
-		if (required_mask > DMA_BIT_MASK(32)
-			&& !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))
-			&& !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+		if (required_mask > DMA_BIT_MASK(32) &&
+		    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 			ioc->dma_mask = DMA_BIT_MASK(64);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
 				ioc->name));
-		} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))
-			   && !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+		} else if (!dma_set_mask_and_coherent(&pdev->dev,
+						      DMA_BIT_MASK(32))) {
 			ioc->dma_mask = DMA_BIT_MASK(32);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
@@ -1684,8 +1683,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 			goto out_pci_release_region;
 		}
 	} else {
-		if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))
-			&& !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+		if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
 			ioc->dma_mask = DMA_BIT_MASK(32);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
@@ -4451,19 +4449,17 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		 */
 		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
 		    ioc->dma_mask > DMA_BIT_MASK(35)) {
-			if (!dma_set_mask(&ioc->pcidev->dev, DMA_BIT_MASK(32))
-			    && !dma_set_coherent_mask(&ioc->pcidev->dev, DMA_BIT_MASK(32))) {
+			if (!dma_set_mask_and_coherent(&ioc->pcidev->dev,
+						       DMA_BIT_MASK(32))) {
 				dma_mask = DMA_BIT_MASK(35);
 				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "setting 35 bit addressing for "
 				    "Request/Reply/Chain and Sense Buffers\n",
 				    ioc->name));
 			} else {
-				/*Reseting DMA mask to 64 bit*/
-				dma_set_mask(&ioc->pcidev->dev,
-					     DMA_BIT_MASK(64));
-				dma_set_coherent_mask(&ioc->pcidev->dev,
-						      DMA_BIT_MASK(64));
+				/* Resetting DMA mask to 64 bit */
+				dma_set_mask_and_coherent(&ioc->pcidev->dev,
+							  DMA_BIT_MASK(64));
 
 				printk(MYIOC_s_ERR_FMT
 				    "failed setting 35 bit addressing for "
@@ -4599,8 +4595,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 	}
 
 	if (dma_mask == DMA_BIT_MASK(35) &&
-	    !dma_set_mask(&ioc->pcidev->dev, ioc->dma_mask) &&
-	    !dma_set_coherent_mask(&ioc->pcidev->dev, ioc->dma_mask))
+	    !dma_set_mask_and_coherent(&ioc->pcidev->dev, ioc->dma_mask))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
@@ -4624,8 +4619,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 	}
 
 	if (dma_mask == DMA_BIT_MASK(35) &&
-	    !dma_set_mask(&ioc->pcidev->dev, DMA_BIT_MASK(64)) &&
-	    !dma_set_coherent_mask(&ioc->pcidev->dev, DMA_BIT_MASK(64)))
+	    !dma_set_mask_and_coherent(&ioc->pcidev->dev, DMA_BIT_MASK(64)))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
-- 
2.30.2

