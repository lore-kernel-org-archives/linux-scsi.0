Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4399C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 16:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B652073E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 16:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VGvzqmoQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405289AbgFXQ5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 12:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404919AbgFXQ5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 12:57:42 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B93CC061573
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2020 09:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ob1E0uDsu6387ym17kCfjHalL5bM6lzajHazP8VOBiI=; b=VGvzqmoQ2dFm8WJVlyXPAxWq7n
        AsMI06piPuJ5TPgqgbOSw40lgolHN9lBzOpCPkna+UtIex1W6xQqgwBNj2JQP6h+9QOGel1mi6wGU
        ferJMSDLXwS3xWccDcrgp2taO3wOliwmXKez97fFHOToqRTXjXvDlJFyZNI3O7iUtoQ3oYu/QWt2P
        RdRWV5J+s+urTFQDATyYd93BxJcLzNIBSPTSYI7KLZT34AldedfNAnPvLc24kq+qaSeN6m1r/ABgo
        q5KcEomVCRrWmrkoESvGI5Ap+5ZFis/DxByW79sXB/0tlrkIsaPFHeCqWNFkVR8P2VngRYHvY7S6c
        kyE5bxTg==;
Received: from [2001:4bb8:180:a3:5c7c:8955:539d:955b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jo8iC-0008Mg-Ra; Wed, 24 Jun 2020 16:57:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-scsi@vger.kernel.org
Cc:     MPT-FusionLinux.pdl@broadcom.com,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH, 5.8 regression] mptfusion: don't use GFP_ATOMIC for larger DMA allocations
Date:   Wed, 24 Jun 2020 18:57:24 +0200
Message-Id: <20200624165724.1818496-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mpt fusion driver still uses the legacy PCI DMA API, which hardcodes
atomic allocations.  This caused the driver to fail to load on some
powerpc VMs with incoherent DMA and small memory sizes.  Switch to use
the modern DMA API and sleeping allocations for large allocations
instead.  This is not a full cleanup of the PCI DMA API usage yet, but
just enough to fix the regression caused by reducing the default atomic
pool size.

Fixes: 3ee06a6d532f ("dma-pool: fix too large DMA pools on medium memory size systems")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/message/fusion/mptbase.c | 41 ++++++++++++++++----------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 68aea22f2b8978..5216487db4fbea 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1324,13 +1324,13 @@ mpt_host_page_alloc(MPT_ADAPTER *ioc, pIOCInit_t ioc_init)
 			return 0; /* fw doesn't need any host buffers */
 
 		/* spin till we get enough memory */
-		while(host_page_buffer_sz > 0) {
-
-			if((ioc->HostPageBuffer = pci_alloc_consistent(
-			    ioc->pcidev,
-			    host_page_buffer_sz,
-			    &ioc->HostPageBuffer_dma)) != NULL) {
-
+		while (host_page_buffer_sz > 0) {
+			ioc->HostPageBuffer =
+				dma_alloc_coherent(&ioc->pcidev->dev,
+						host_page_buffer_sz,
+						&ioc->HostPageBuffer_dma,
+						GFP_KERNEL);
+			if (ioc->HostPageBuffer) {
 				dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "host_page_buffer @ %p, dma @ %x, sz=%d bytes\n",
 				    ioc->name, ioc->HostPageBuffer,
@@ -2741,8 +2741,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 		sz = ioc->alloc_sz;
 		dexitprintk(ioc, printk(MYIOC_s_INFO_FMT "free  @ %p, sz=%d bytes\n",
 		    ioc->name, ioc->alloc, ioc->alloc_sz));
-		pci_free_consistent(ioc->pcidev, sz,
-				ioc->alloc, ioc->alloc_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->alloc,
+				ioc->alloc_dma);
 		ioc->reply_frames = NULL;
 		ioc->req_frames = NULL;
 		ioc->alloc = NULL;
@@ -2751,8 +2751,8 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->sense_buf_pool != NULL) {
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
-		pci_free_consistent(ioc->pcidev, sz,
-				ioc->sense_buf_pool, ioc->sense_buf_pool_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->sense_buf_pool,
+				ioc->sense_buf_pool_dma);
 		ioc->sense_buf_pool = NULL;
 		ioc->alloc_total -= sz;
 	}
@@ -2802,7 +2802,7 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 			"HostPageBuffer free  @ %p, sz=%d bytes\n",
 			ioc->name, ioc->HostPageBuffer,
 			ioc->HostPageBuffer_sz));
-		pci_free_consistent(ioc->pcidev, ioc->HostPageBuffer_sz,
+		dma_free_coherent(&ioc->pcidev->dev, ioc->HostPageBuffer_sz,
 		    ioc->HostPageBuffer, ioc->HostPageBuffer_dma);
 		ioc->HostPageBuffer = NULL;
 		ioc->HostPageBuffer_sz = 0;
@@ -4497,7 +4497,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 			 	ioc->name, sz, sz, num_chain));
 
 		total_size += sz;
-		mem = pci_alloc_consistent(ioc->pcidev, total_size, &alloc_dma);
+		mem = dma_alloc_coherent(&ioc->pcidev->dev, total_size,
+				&alloc_dma, GFP_KERNEL);
 		if (mem == NULL) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Reply, Request, Chain Buffers!\n",
 				ioc->name);
@@ -4574,8 +4575,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
-		ioc->sense_buf_pool =
-			pci_alloc_consistent(ioc->pcidev, sz, &ioc->sense_buf_pool_dma);
+		ioc->sense_buf_pool = dma_alloc_coherent(&ioc->pcidev->dev, sz,
+				&ioc->sense_buf_pool_dma, GFP_KERNEL);
 		if (ioc->sense_buf_pool == NULL) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Sense Buffers!\n",
 				ioc->name);
@@ -4613,18 +4614,16 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 	if (ioc->alloc != NULL) {
 		sz = ioc->alloc_sz;
-		pci_free_consistent(ioc->pcidev,
-				sz,
-				ioc->alloc, ioc->alloc_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->alloc,
+				ioc->alloc_dma);
 		ioc->reply_frames = NULL;
 		ioc->req_frames = NULL;
 		ioc->alloc_total -= sz;
 	}
 	if (ioc->sense_buf_pool != NULL) {
 		sz = (ioc->req_depth * MPT_SENSE_BUFFER_ALLOC);
-		pci_free_consistent(ioc->pcidev,
-				sz,
-				ioc->sense_buf_pool, ioc->sense_buf_pool_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, ioc->sense_buf_pool,
+				ioc->sense_buf_pool_dma);
 		ioc->sense_buf_pool = NULL;
 	}
 
-- 
2.26.2

