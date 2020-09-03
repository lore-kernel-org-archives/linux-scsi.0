Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D083C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E2A20C56
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 15:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBPugr8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgICP25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgICP2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 11:28:52 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE62C061244;
        Thu,  3 Sep 2020 08:28:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so3665903wrn.10;
        Thu, 03 Sep 2020 08:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8hTvQ7j0GRdc7ETbwSvFIKu7YhggF/VG5A+igi5S+vQ=;
        b=cBPugr8pIZrpG+H64iETyBV3w8A/qcIOM0f+czi5JrJfjDzvpStHLJSbvQCJEjDJ55
         qWZH2n3QR/7yqkTtY7HTPIvyILvQrLvsQb8pIPFgMgvYH0thFuJ77/l84xQRYydoMC4g
         KYrNeCIcFJl7UHzm6zTCo8DJ/EoLcWMhf4cHrzwYfCZfoEDQkkNH1XnvTs0pFiepCimL
         tlNOXMSrH4jWhyXfu5z3AioU7cERThZS5XGQUKtYtuKfwVfhkn76zpzlR+f6iL7cmRE/
         dJr2tZJxSWsPxv5l6PXx332kQYmNIrFlXWaaunJCs7p7YTadseM2qh7B+QBE/7bbQZXl
         PFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8hTvQ7j0GRdc7ETbwSvFIKu7YhggF/VG5A+igi5S+vQ=;
        b=Rt/t653SdxVpAjdbTUGFBJiEDG4OSI6plCS9U5Cn08XA7aCs9H5TyyPV7GhG7q9mCg
         jsonWKGMEsp7PYnVBb6i62faN/xeXJynkGgzLnyuKn+Pb+tPGZnBaVfBwwZQC2ZNXXU0
         VSPVYJY3UmSjP2J6Gbwrq0xLEv1NNH2cbz3jjmb/EwF/XupY2Ms0NQdsAiUEm5xwxp2D
         votj9kzgxPSLrvkyY//vC9DmilYlDZ12keg2Vup9bAvkZSegt4i0SwkPlSN5SNEYB8yG
         6twsg+edkawktjrnPwlBp4++GNsN84XCVuIHUepS6U+JZJhlvWqtGFtDdbanYZ6asG71
         W52Q==
X-Gm-Message-State: AOAM532pealpDQ+AASSO2//ORbG00H7CcODKQetLIHCPstp8JrM5FIOn
        fvHGNpnET3LiAStv4Zti+sc=
X-Google-Smtp-Source: ABdhPJzgpRIICy6QGDoaqKSKGpSZPKPKuVN/Y4aU9H/7qwg7gb11A52/z+AyN4mPNGDbfPtSmCYZSQ==
X-Received: by 2002:adf:fcc7:: with SMTP id f7mr3012725wrs.274.1599146930067;
        Thu, 03 Sep 2020 08:28:50 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id 32sm5750210wrh.18.2020.09.03.08.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 08:28:49 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 3/3] scsi: mpt: Port from pci_* to dma_* interface
Date:   Thu,  3 Sep 2020 16:28:32 +0100
Message-Id: <20200903152832.484908-4-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903152832.484908-1-alex.dewar90@gmail.com>
References: <20200903152832.484908-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace use of the pci_* methods in include/linux/pci-dma-compat.h with
their dma_* counterparts.

The below Coccinelle script was used. Replacing use of
pci_alloc_consistent requires manual intervention as dma_alloc_coherent
can be called with different alloc flags depending on context. I checked
and in none of these functions are called from an interrupt or with a
spinlock held.

@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/message/fusion/mptbase.c | 159 +++++++++++++++++--------------
 drivers/message/fusion/mptctl.c  |  82 +++++++++-------
 drivers/message/fusion/mptfc.c   |  35 +++----
 drivers/message/fusion/mptlan.c  |  90 +++++++++--------
 drivers/message/fusion/mptsas.c  |  94 +++++++++---------
 5 files changed, 248 insertions(+), 212 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 85fd9c3721ec..865bcd6af39f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -299,8 +299,8 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
 	if (!hdr.ExtPageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer)
 		goto out;
 
@@ -315,8 +315,8 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
 		rc = 1;
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-	    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return rc;
 }
@@ -1664,16 +1664,14 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		const uint64_t required_mask = dma_get_required_mask
 		    (&pdev->dev);
 		if (required_mask > DMA_BIT_MASK(32)
-			&& !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
-			&& !pci_set_consistent_dma_mask(pdev,
-						 DMA_BIT_MASK(64))) {
+			&& !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))
+			&& !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 			ioc->dma_mask = DMA_BIT_MASK(64);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
 				ioc->name));
-		} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
-			&& !pci_set_consistent_dma_mask(pdev,
-						DMA_BIT_MASK(32))) {
+		} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))
+			   && !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 			ioc->dma_mask = DMA_BIT_MASK(32);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
@@ -1684,9 +1682,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 			goto out_pci_release_region;
 		}
 	} else {
-		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
-			&& !pci_set_consistent_dma_mask(pdev,
-						DMA_BIT_MASK(32))) {
+		if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))
+			&& !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 			ioc->dma_mask = DMA_BIT_MASK(32);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
@@ -2768,9 +2765,9 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
 	if (ioc->spi_data.pIocPg4 != NULL) {
 		sz = ioc->spi_data.IocPg4Sz;
-		pci_free_consistent(ioc->pcidev, sz,
-			ioc->spi_data.pIocPg4,
-			ioc->spi_data.IocPg4_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz,
+				  ioc->spi_data.pIocPg4,
+				  ioc->spi_data.IocPg4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
 		ioc->alloc_total -= sz;
 	}
@@ -3506,7 +3503,8 @@ mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size)
 		rc = 0;
 		goto out;
 	}
-	ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma);
+	ioc->cached_fw = dma_alloc_coherent(&ioc->pcidev->dev, size,
+					    &ioc->cached_fw_dma, GFP_KERNEL);
 	if (!ioc->cached_fw) {
 		printk(MYIOC_s_ERR_FMT "Unable to allocate memory for the cached firmware image!\n",
 		    ioc->name);
@@ -3539,7 +3537,8 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 	sz = ioc->facts.FWImageSize;
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 		 ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
-	pci_free_consistent(ioc->pcidev, sz, ioc->cached_fw, ioc->cached_fw_dma);
+	dma_free_coherent(&ioc->pcidev->dev, sz, ioc->cached_fw,
+			  ioc->cached_fw_dma);
 	ioc->alloc_total -= sz;
 	ioc->cached_fw = NULL;
 }
@@ -4375,9 +4374,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		 */
 		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
 		    ioc->dma_mask > DMA_BIT_MASK(35)) {
-			if (!pci_set_dma_mask(ioc->pcidev, DMA_BIT_MASK(32))
-			    && !pci_set_consistent_dma_mask(ioc->pcidev,
-			    DMA_BIT_MASK(32))) {
+			if (!dma_set_mask(&ioc->pcidev->dev, DMA_BIT_MASK(32))
+			    && !dma_set_coherent_mask(&ioc->pcidev->dev, DMA_BIT_MASK(32))) {
 				dma_mask = DMA_BIT_MASK(35);
 				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "setting 35 bit addressing for "
@@ -4385,10 +4383,10 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 				    ioc->name));
 			} else {
 				/*Reseting DMA mask to 64 bit*/
-				pci_set_dma_mask(ioc->pcidev,
-					DMA_BIT_MASK(64));
-				pci_set_consistent_dma_mask(ioc->pcidev,
-					DMA_BIT_MASK(64));
+				dma_set_mask(&ioc->pcidev->dev,
+					     DMA_BIT_MASK(64));
+				dma_set_coherent_mask(&ioc->pcidev->dev,
+						      DMA_BIT_MASK(64));
 
 				printk(MYIOC_s_ERR_FMT
 				    "failed setting 35 bit addressing for "
@@ -4419,7 +4417,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 
 		total_size += sz;
 		mem = dma_alloc_coherent(&ioc->pcidev->dev, total_size,
-				&alloc_dma, GFP_KERNEL);
+					 &alloc_dma, GFP_KERNEL);
 		if (mem == NULL) {
 			printk(MYIOC_s_ERR_FMT "Unable to allocate Reply, Request, Chain Buffers!\n",
 				ioc->name);
@@ -4429,7 +4427,6 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Total alloc @ %p[%p], sz=%d[%x] bytes\n",
 			 	ioc->name, mem, (void *)(ulong)alloc_dma, total_size, total_size));
 
-		memset(mem, 0, total_size);
 		ioc->alloc_total += total_size;
 		ioc->alloc = mem;
 		ioc->alloc_dma = alloc_dma;
@@ -4523,9 +4520,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		alloc_dma += ioc->reply_sz;
 	}
 
-	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
-	    ioc->dma_mask) && !pci_set_consistent_dma_mask(ioc->pcidev,
-	    ioc->dma_mask))
+	if (dma_mask == DMA_BIT_MASK(35) && !dma_set_mask(&ioc->pcidev->dev, ioc->dma_mask) && !dma_set_coherent_mask(&ioc->pcidev->dev, ioc->dma_mask))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
@@ -4548,9 +4543,9 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->sense_buf_pool = NULL;
 	}
 
-	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
-	    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(ioc->pcidev,
-	    DMA_BIT_MASK(64)))
+	if (dma_mask == DMA_BIT_MASK(35) &&
+			!dma_set_mask(&ioc->pcidev->dev, DMA_BIT_MASK(64)) &&
+			!dma_set_coherent_mask(&ioc->pcidev->dev, DMA_BIT_MASK(64)))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
@@ -4883,10 +4878,10 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	if (hdr.PageLength > 0) {
 		data_sz = hdr.PageLength * 4;
-		ppage0_alloc = (LANPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+		ppage0_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+						  &page0_dma, GFP_KERNEL);
 		rc = -ENOMEM;
 		if (ppage0_alloc) {
-			memset((u8 *)ppage0_alloc, 0, data_sz);
 			cfg.physAddr = page0_dma;
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
@@ -4897,13 +4892,13 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 			}
 
-			pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
+			dma_free_coherent(&ioc->pcidev->dev, data_sz,
+					  (u8 *)ppage0_alloc, page0_dma);
 
 			/* FIXME!
 			 *	Normalize endianness of structure data,
 			 *	by byte-swapping all > 1 byte fields!
 			 */
-
 		}
 
 		if (rc)
@@ -4929,9 +4924,9 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage1_alloc = (LANPage1_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
+	ppage1_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+					  &page1_dma, GFP_KERNEL);
 	if (ppage1_alloc) {
-		memset((u8 *)ppage1_alloc, 0, data_sz);
 		cfg.physAddr = page1_dma;
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
@@ -4941,13 +4936,13 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 			memcpy(&ioc->lan_cnfg_page1, ppage1_alloc, copy_sz);
 		}
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage1_alloc, page1_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz,
+				  (u8 *)ppage1_alloc, page1_dma);
 
 		/* FIXME!
 		 *	Normalize endianness of structure data,
 		 *	by byte-swapping all > 1 byte fields!
 		 */
-
 	}
 
 	return rc;
@@ -5230,9 +5225,9 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
 	/* Read the config page */
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage_alloc = (IOUnitPage2_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	ppage_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz, &page_dma,
+					 GFP_KERNEL);
 	if (ppage_alloc) {
-		memset((u8 *)ppage_alloc, 0, data_sz);
 		cfg.physAddr = page_dma;
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
@@ -5240,7 +5235,8 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
 		if ((rc = mpt_config(ioc, &cfg)) == 0)
 			ioc->biosVersion = le32_to_cpu(ppage_alloc->BiosVersion);
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage_alloc, page_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz,
+				  (u8 *)ppage_alloc, page_dma);
 	}
 
 	return rc;
@@ -5315,7 +5311,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 		 return -EFAULT;
 
 	if (header.PageLength > 0) {
-		pbuf = pci_alloc_consistent(ioc->pcidev, header.PageLength * 4, &buf_dma);
+		pbuf = dma_alloc_coherent(&ioc->pcidev->dev,
+					  header.PageLength * 4, &buf_dma,
+					  GFP_KERNEL);
 		if (pbuf) {
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 			cfg.physAddr = buf_dma;
@@ -5371,7 +5369,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 				}
 			}
 			if (pbuf) {
-				pci_free_consistent(ioc->pcidev, header.PageLength * 4, pbuf, buf_dma);
+				dma_free_coherent(&ioc->pcidev->dev,
+						  header.PageLength * 4, pbuf,
+						  buf_dma);
 			}
 		}
 	}
@@ -5393,7 +5393,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 	if (header.PageLength > 0) {
 		/* Allocate memory and read SCSI Port Page 2
 		 */
-		pbuf = pci_alloc_consistent(ioc->pcidev, header.PageLength * 4, &buf_dma);
+		pbuf = dma_alloc_coherent(&ioc->pcidev->dev,
+					  header.PageLength * 4, &buf_dma,
+					  GFP_KERNEL);
 		if (pbuf) {
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_NVRAM;
 			cfg.physAddr = buf_dma;
@@ -5458,7 +5460,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 				}
 			}
 
-			pci_free_consistent(ioc->pcidev, header.PageLength * 4, pbuf, buf_dma);
+			dma_free_coherent(&ioc->pcidev->dev,
+					  header.PageLength * 4, pbuf,
+					  buf_dma);
 		}
 	}
 
@@ -5574,8 +5578,8 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (!hdr.PageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer)
 		goto out;
@@ -5622,8 +5626,8 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
  out:
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 }
 
 /**
@@ -5667,8 +5671,8 @@ mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer) {
 		rc = -ENOMEM;
@@ -5691,8 +5695,8 @@ mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num,
  out:
 
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 
 	return rc;
 }
@@ -5734,8 +5738,8 @@ mpt_raid_phys_disk_get_num_paths(MPT_ADAPTER *ioc, u8 phys_disk_num)
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer) {
 		rc = 0;
@@ -5755,8 +5759,8 @@ mpt_raid_phys_disk_get_num_paths(MPT_ADAPTER *ioc, u8 phys_disk_num)
  out:
 
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 
 	return rc;
 }
@@ -5806,8 +5810,8 @@ mpt_raid_phys_disk_pg1(MPT_ADAPTER *ioc, u8 phys_disk_num,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer) {
 		rc = -ENOMEM;
@@ -5844,8 +5848,8 @@ mpt_raid_phys_disk_pg1(MPT_ADAPTER *ioc, u8 phys_disk_num,
  out:
 
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 
 	return rc;
 }
@@ -5901,7 +5905,8 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 		return -EFAULT;
 
 	iocpage2sz = header.PageLength * 4;
-	pIoc2 = pci_alloc_consistent(ioc->pcidev, iocpage2sz, &ioc2_dma);
+	pIoc2 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage2sz, &ioc2_dma,
+				   GFP_KERNEL);
 	if (!pIoc2)
 		return -ENOMEM;
 
@@ -5926,7 +5931,7 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 		    pIoc2->RaidVolume[i].VolumeID);
 
  out:
-	pci_free_consistent(ioc->pcidev, iocpage2sz, pIoc2, ioc2_dma);
+	dma_free_coherent(&ioc->pcidev->dev, iocpage2sz, pIoc2, ioc2_dma);
 
 	return rc;
 }
@@ -5968,7 +5973,8 @@ mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 	/* Read Header good, alloc memory
 	 */
 	iocpage3sz = header.PageLength * 4;
-	pIoc3 = pci_alloc_consistent(ioc->pcidev, iocpage3sz, &ioc3_dma);
+	pIoc3 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage3sz, &ioc3_dma,
+				   GFP_KERNEL);
 	if (!pIoc3)
 		return 0;
 
@@ -5985,7 +5991,7 @@ mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 		}
 	}
 
-	pci_free_consistent(ioc->pcidev, iocpage3sz, pIoc3, ioc3_dma);
+	dma_free_coherent(&ioc->pcidev->dev, iocpage3sz, pIoc3, ioc3_dma);
 
 	return 0;
 }
@@ -6019,7 +6025,8 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 
 	if ( (pIoc4 = ioc->spi_data.pIocPg4) == NULL ) {
 		iocpage4sz = (header.PageLength + 4) * 4; /* Allow 4 additional SEP's */
-		pIoc4 = pci_alloc_consistent(ioc->pcidev, iocpage4sz, &ioc4_dma);
+		pIoc4 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage4sz,
+					   &ioc4_dma, GFP_KERNEL);
 		if (!pIoc4)
 			return;
 		ioc->alloc_total += iocpage4sz;
@@ -6037,7 +6044,8 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 		ioc->spi_data.IocPg4_dma = ioc4_dma;
 		ioc->spi_data.IocPg4Sz = iocpage4sz;
 	} else {
-		pci_free_consistent(ioc->pcidev, iocpage4sz, pIoc4, ioc4_dma);
+		dma_free_coherent(&ioc->pcidev->dev, iocpage4sz, pIoc4,
+				  ioc4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
 		ioc->alloc_total -= iocpage4sz;
 	}
@@ -6074,7 +6082,8 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 	/* Read Header good, alloc memory
 	 */
 	iocpage1sz = header.PageLength * 4;
-	pIoc1 = pci_alloc_consistent(ioc->pcidev, iocpage1sz, &ioc1_dma);
+	pIoc1 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage1sz, &ioc1_dma,
+				   GFP_KERNEL);
 	if (!pIoc1)
 		return;
 
@@ -6125,7 +6134,7 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 		}
 	}
 
-	pci_free_consistent(ioc->pcidev, iocpage1sz, pIoc1, ioc1_dma);
+	dma_free_coherent(&ioc->pcidev->dev, iocpage1sz, pIoc1, ioc1_dma);
 
 	return;
 }
@@ -6154,7 +6163,8 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 		goto out;
 
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
-	pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
+	pbuf = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  &buf_dma, GFP_KERNEL);
 	if (!pbuf)
 		goto out;
 
@@ -6170,7 +6180,8 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 out:
 
 	if (pbuf)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4, pbuf,
+				  buf_dma);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index a20a11eea5a4..7acb49aca98f 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1044,14 +1044,15 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 	 * copying the data in this array into the correct place in the
 	 * request and chain buffers.
 	 */
-	sglbuf = pci_alloc_consistent(ioc->pcidev, MAX_SGL_BYTES, sglbuf_dma);
+	sglbuf = dma_alloc_coherent(&ioc->pcidev->dev, MAX_SGL_BYTES,
+				    sglbuf_dma, GFP_KERNEL);
 	if (sglbuf == NULL)
 		goto free_and_fail;
 
 	if (sgdir & 0x04000000)
-		dir = PCI_DMA_TODEVICE;
+		dir = DMA_TO_DEVICE;
 	else
-		dir = PCI_DMA_FROMDEVICE;
+		dir = DMA_FROM_DEVICE;
 
 	/* At start:
 	 *	sgl = sglbuf = point to beginning of sg buffer
@@ -1065,9 +1066,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 	while (bytes_allocd < bytes) {
 		this_alloc = min(alloc_sz, bytes-bytes_allocd);
 		buflist[buflist_ent].len = this_alloc;
-		buflist[buflist_ent].kptr = pci_alloc_consistent(ioc->pcidev,
-								 this_alloc,
-								 &pa);
+		buflist[buflist_ent].kptr = dma_alloc_coherent(&ioc->pcidev->dev,
+							       this_alloc,
+							       &pa, GFP_KERNEL);
 		if (buflist[buflist_ent].kptr == NULL) {
 			alloc_sz = alloc_sz / 2;
 			if (alloc_sz == 0) {
@@ -1083,8 +1084,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 
 			bytes_allocd += this_alloc;
 			sgl->FlagsLength = (0x10000000|sgdir|this_alloc);
-			dma_addr = pci_map_single(ioc->pcidev,
-				buflist[buflist_ent].kptr, this_alloc, dir);
+			dma_addr = dma_map_single(&ioc->pcidev->dev,
+						  buflist[buflist_ent].kptr,
+						  this_alloc, dir);
 			sgl->Address = dma_addr;
 
 			fragcnt++;
@@ -1143,9 +1145,11 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 			kptr = buflist[i].kptr;
 			len = buflist[i].len;
 
-			pci_free_consistent(ioc->pcidev, len, kptr, dma_addr);
+			dma_free_coherent(&ioc->pcidev->dev, len, kptr,
+					  dma_addr);
 		}
-		pci_free_consistent(ioc->pcidev, MAX_SGL_BYTES, sglbuf, *sglbuf_dma);
+		dma_free_coherent(&ioc->pcidev->dev, MAX_SGL_BYTES, sglbuf,
+				  *sglbuf_dma);
 	}
 	kfree(buflist);
 	return NULL;
@@ -1165,9 +1169,9 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
 	int		 n = 0;
 
 	if (sg->FlagsLength & 0x04000000)
-		dir = PCI_DMA_TODEVICE;
+		dir = DMA_TO_DEVICE;
 	else
-		dir = PCI_DMA_FROMDEVICE;
+		dir = DMA_FROM_DEVICE;
 
 	nib = (sg->FlagsLength & 0xF0000000) >> 28;
 	while (! (nib & 0x4)) { /* eob */
@@ -1182,8 +1186,10 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
 			dma_addr = sg->Address;
 			kptr = bl->kptr;
 			len = bl->len;
-			pci_unmap_single(ioc->pcidev, dma_addr, len, dir);
-			pci_free_consistent(ioc->pcidev, len, kptr, dma_addr);
+			dma_unmap_single(&ioc->pcidev->dev, dma_addr, len,
+					 dir);
+			dma_free_coherent(&ioc->pcidev->dev, len, kptr,
+					  dma_addr);
 			n++;
 		}
 		sg++;
@@ -1200,12 +1206,12 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
 		dma_addr = sg->Address;
 		kptr = bl->kptr;
 		len = bl->len;
-		pci_unmap_single(ioc->pcidev, dma_addr, len, dir);
-		pci_free_consistent(ioc->pcidev, len, kptr, dma_addr);
+		dma_unmap_single(&ioc->pcidev->dev, dma_addr, len, dir);
+		dma_free_coherent(&ioc->pcidev->dev, len, kptr, dma_addr);
 		n++;
 	}
 
-	pci_free_consistent(ioc->pcidev, MAX_SGL_BYTES, sgl, sgl_dma);
+	dma_free_coherent(&ioc->pcidev->dev, MAX_SGL_BYTES, sgl, sgl_dma);
 	kfree(buflist);
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "-SG: Free'd 1 SGL buf + %d kbufs!\n",
 	    ioc->name, n));
@@ -2109,8 +2115,9 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 			}
 			flagsLength |= karg.dataOutSize;
 			bufOut.len = karg.dataOutSize;
-			bufOut.kptr = pci_alloc_consistent(
-					ioc->pcidev, bufOut.len, &dma_addr_out);
+			bufOut.kptr = dma_alloc_coherent(&ioc->pcidev->dev,
+							 bufOut.len,
+							 &dma_addr_out, GFP_KERNEL);
 
 			if (bufOut.kptr == NULL) {
 				rc = -ENOMEM;
@@ -2143,8 +2150,9 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 			flagsLength |= karg.dataInSize;
 
 			bufIn.len = karg.dataInSize;
-			bufIn.kptr = pci_alloc_consistent(ioc->pcidev,
-					bufIn.len, &dma_addr_in);
+			bufIn.kptr = dma_alloc_coherent(&ioc->pcidev->dev,
+							bufIn.len,
+							&dma_addr_in, GFP_KERNEL);
 
 			if (bufIn.kptr == NULL) {
 				rc = -ENOMEM;
@@ -2293,13 +2301,13 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 	/* Free the allocated memory.
 	 */
 	if (bufOut.kptr != NULL) {
-		pci_free_consistent(ioc->pcidev,
-			bufOut.len, (void *) bufOut.kptr, dma_addr_out);
+		dma_free_coherent(&ioc->pcidev->dev, bufOut.len,
+				  (void *)bufOut.kptr, dma_addr_out);
 	}
 
 	if (bufIn.kptr != NULL) {
-		pci_free_consistent(ioc->pcidev,
-			bufIn.len, (void *) bufIn.kptr, dma_addr_in);
+		dma_free_coherent(&ioc->pcidev->dev, bufIn.len,
+				  (void *)bufIn.kptr, dma_addr_in);
 	}
 
 	/* mf is null if command issued successfully
@@ -2405,7 +2413,9 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 			/* Issue the second config page request */
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
-			pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
+			pbuf = dma_alloc_coherent(&ioc->pcidev->dev,
+						  hdr.PageLength * 4,
+						  &buf_dma, GFP_KERNEL);
 			if (pbuf) {
 				cfg.physAddr = buf_dma;
 				if (mpt_config(ioc, &cfg) == 0) {
@@ -2415,7 +2425,9 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 							pdata->BoardTracerNumber, 24);
 					}
 				}
-				pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
+				dma_free_coherent(&ioc->pcidev->dev,
+						  hdr.PageLength * 4, pbuf,
+						  buf_dma);
 				pbuf = NULL;
 			}
 		}
@@ -2480,7 +2492,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	else
 		IstwiRWRequest->DeviceAddr = 0xB0;
 
-	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
+	pbuf = dma_alloc_coherent(&ioc->pcidev->dev, 4, &buf_dma, GFP_KERNEL);
 	if (!pbuf)
 		goto out;
 	ioc->add_sge((char *)&IstwiRWRequest->SGL,
@@ -2529,7 +2541,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context, 0);
 
 	if (pbuf)
-		pci_free_consistent(ioc->pcidev, 4, pbuf, buf_dma);
+		dma_free_coherent(&ioc->pcidev->dev, 4, pbuf, buf_dma);
 
 	/* Copy the data from kernel memory to user memory
 	 */
@@ -2595,7 +2607,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
        /* Get the data transfer speeds
         */
 	data_sz = ioc->spi_data.sdp0length * 4;
-	pg0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	pg0_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz, &page_dma,
+				       GFP_KERNEL);
 	if (pg0_alloc) {
 		hdr.PageVersion = ioc->spi_data.sdp0version;
 		hdr.PageLength = data_sz;
@@ -2633,7 +2646,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 				karg.negotiated_speed = HP_DEV_SPEED_ASYNC;
 		}
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) pg0_alloc, page_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz, (u8 *)pg0_alloc,
+				  page_dma);
 	}
 
 	/* Set defaults
@@ -2659,7 +2673,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 		/* Issue the second config page request */
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 		data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
-		pg3_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+		pg3_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+					       &page_dma, GFP_KERNEL);
 		if (pg3_alloc) {
 			cfg.physAddr = page_dma;
 			cfg.pageAddr = (karg.hdr.channel << 8) | karg.hdr.id;
@@ -2668,7 +2683,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 				karg.phase_errors = (u32) le16_to_cpu(pg3_alloc->PhaseErrorCount);
 				karg.parity_errors = (u32) le16_to_cpu(pg3_alloc->ParityErrorCount);
 			}
-			pci_free_consistent(ioc->pcidev, data_sz, (u8 *) pg3_alloc, page_dma);
+			dma_free_coherent(&ioc->pcidev->dev, data_sz,
+					  (u8 *)pg3_alloc, page_dma);
 		}
 	}
 	hd = shost_priv(ioc->sh);
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index f92b0433f599..207b4731e536 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -331,8 +331,8 @@ mptfc_GetFcDevPage0(MPT_ADAPTER *ioc, int ioc_port,
 			break;
 
 		data_sz = hdr.PageLength * 4;
-		ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz,
-		    					&page0_dma);
+		ppage0_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+						  &page0_dma, GFP_KERNEL);
 		rc = -ENOMEM;
 		if (!ppage0_alloc)
 			break;
@@ -367,8 +367,8 @@ mptfc_GetFcDevPage0(MPT_ADAPTER *ioc, int ioc_port,
 			*p_p0 = *ppage0_alloc;	/* save data */
 			*p_pp0++ = p_p0++;	/* save addr */
 		}
-		pci_free_consistent(ioc->pcidev, data_sz,
-		    			(u8 *) ppage0_alloc, page0_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz,
+				  (u8 *)ppage0_alloc, page0_dma);
 		if (rc != 0)
 			break;
 
@@ -763,7 +763,8 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+	ppage0_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+					  &page0_dma, GFP_KERNEL);
 	if (ppage0_alloc) {
 
  try_again:
@@ -817,7 +818,8 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 			mptfc_display_port_link_speed(ioc, portnum, pp0dest);
 		}
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz,
+				  (u8 *)ppage0_alloc, page0_dma);
 	}
 
 	return rc;
@@ -904,9 +906,8 @@ mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
 		if (data_sz < sizeof(FCPortPage1_t))
 			data_sz = sizeof(FCPortPage1_t);
 
-		page1_alloc = pci_alloc_consistent(ioc->pcidev,
-						data_sz,
-						&page1_dma);
+		page1_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+						 &page1_dma, GFP_KERNEL);
 		if (!page1_alloc)
 			return -ENOMEM;
 	}
@@ -916,8 +917,8 @@ mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
 		data_sz = ioc->fc_data.fc_port_page1[portnum].pg_sz;
 		if (hdr.PageLength * 4 > data_sz) {
 			ioc->fc_data.fc_port_page1[portnum].data = NULL;
-			pci_free_consistent(ioc->pcidev, data_sz, (u8 *)
-				page1_alloc, page1_dma);
+			dma_free_coherent(&ioc->pcidev->dev, data_sz,
+					  (u8 *)page1_alloc, page1_dma);
 			goto start_over;
 		}
 	}
@@ -932,8 +933,8 @@ mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
 	}
 	else {
 		ioc->fc_data.fc_port_page1[portnum].data = NULL;
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *)
-			page1_alloc, page1_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz,
+				  (u8 *)page1_alloc, page1_dma);
 	}
 
 	return rc;
@@ -1514,10 +1515,10 @@ static void mptfc_remove(struct pci_dev *pdev)
 
 	for (ii=0; ii<ioc->facts.NumberOfPorts; ii++) {
 		if (ioc->fc_data.fc_port_page1[ii].data) {
-			pci_free_consistent(ioc->pcidev,
-				ioc->fc_data.fc_port_page1[ii].pg_sz,
-				(u8 *) ioc->fc_data.fc_port_page1[ii].data,
-				ioc->fc_data.fc_port_page1[ii].dma);
+			dma_free_coherent(&ioc->pcidev->dev,
+					  ioc->fc_data.fc_port_page1[ii].pg_sz,
+					  (u8 *)ioc->fc_data.fc_port_page1[ii].data,
+					  ioc->fc_data.fc_port_page1[ii].dma);
 			ioc->fc_data.fc_port_page1[ii].data = NULL;
 		}
 	}
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 7d3784aa20e5..67994df08608 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -519,9 +519,9 @@ mpt_lan_close(struct net_device *dev)
 		if (priv->RcvCtl[i].skb != NULL) {
 /**/			dlprintk((KERN_INFO MYNAM "/lan_close: bucket %05x "
 /**/				  "is still out\n", i));
-			pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[i].dma,
-					 priv->RcvCtl[i].len,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&mpt_dev->pcidev->dev,
+					 priv->RcvCtl[i].dma,
+					 priv->RcvCtl[i].len, DMA_FROM_DEVICE);
 			dev_kfree_skb(priv->RcvCtl[i].skb);
 		}
 	}
@@ -531,9 +531,9 @@ mpt_lan_close(struct net_device *dev)
 
 	for (i = 0; i < priv->tx_max_out; i++) {
 		if (priv->SendCtl[i].skb != NULL) {
-			pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[i].dma,
-					 priv->SendCtl[i].len,
-					 PCI_DMA_TODEVICE);
+			dma_unmap_single(&mpt_dev->pcidev->dev,
+					 priv->SendCtl[i].dma,
+					 priv->SendCtl[i].len, DMA_TO_DEVICE);
 			dev_kfree_skb(priv->SendCtl[i].skb);
 		}
 	}
@@ -585,8 +585,8 @@ mpt_lan_send_turbo(struct net_device *dev, u32 tmsg)
 			__func__, sent));
 
 	priv->SendCtl[ctx].skb = NULL;
-	pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
-			 priv->SendCtl[ctx].len, PCI_DMA_TODEVICE);
+	dma_unmap_single(&mpt_dev->pcidev->dev, priv->SendCtl[ctx].dma,
+			 priv->SendCtl[ctx].len, DMA_TO_DEVICE);
 	dev_kfree_skb_irq(sent);
 
 	spin_lock_irqsave(&priv->txfidx_lock, flags);
@@ -651,8 +651,9 @@ mpt_lan_send_reply(struct net_device *dev, LANSendReply_t *pSendRep)
 				__func__, sent));
 
 		priv->SendCtl[ctx].skb = NULL;
-		pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
-				 priv->SendCtl[ctx].len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&mpt_dev->pcidev->dev,
+				 priv->SendCtl[ctx].dma,
+				 priv->SendCtl[ctx].len, DMA_TO_DEVICE);
 		dev_kfree_skb_irq(sent);
 
 		priv->mpt_txfidx[++priv->mpt_txfidx_tail] = ctx;
@@ -723,8 +724,8 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, 12);
 
-        dma = pci_map_single(mpt_dev->pcidev, skb->data, skb->len,
-			     PCI_DMA_TODEVICE);
+        dma = dma_map_single(&mpt_dev->pcidev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
 
 	priv->SendCtl[ctx].skb = skb;
 	priv->SendCtl[ctx].dma = dma;
@@ -871,13 +872,17 @@ mpt_lan_receive_post_turbo(struct net_device *dev, u32 tmsg)
 			return -ENOMEM;
 		}
 
-		pci_dma_sync_single_for_cpu(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-					    priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&mpt_dev->pcidev->dev,
+					priv->RcvCtl[ctx].dma,
+					priv->RcvCtl[ctx].len,
+					DMA_FROM_DEVICE);
 
 		skb_copy_from_linear_data(old_skb, skb_put(skb, len), len);
 
-		pci_dma_sync_single_for_device(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-					       priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&mpt_dev->pcidev->dev,
+					   priv->RcvCtl[ctx].dma,
+					   priv->RcvCtl[ctx].len,
+					   DMA_FROM_DEVICE);
 		goto out;
 	}
 
@@ -885,8 +890,8 @@ mpt_lan_receive_post_turbo(struct net_device *dev, u32 tmsg)
 
 	priv->RcvCtl[ctx].skb = NULL;
 
-	pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-			 priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&mpt_dev->pcidev->dev, priv->RcvCtl[ctx].dma,
+			 priv->RcvCtl[ctx].len, DMA_FROM_DEVICE);
 
 out:
 	spin_lock_irqsave(&priv->rxfidx_lock, flags);
@@ -930,8 +935,8 @@ mpt_lan_receive_post_free(struct net_device *dev,
 //		dlprintk((KERN_INFO MYNAM "@rpr[2] TC + 3\n"));
 
 		priv->RcvCtl[ctx].skb = NULL;
-		pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-				 priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&mpt_dev->pcidev->dev, priv->RcvCtl[ctx].dma,
+				 priv->RcvCtl[ctx].len, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 
 		priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
@@ -1031,16 +1036,16 @@ mpt_lan_receive_post_reply(struct net_device *dev,
 //					IOC_AND_NETDEV_NAMES_s_s(dev),
 //					i, l));
 
-			pci_dma_sync_single_for_cpu(mpt_dev->pcidev,
-						    priv->RcvCtl[ctx].dma,
-						    priv->RcvCtl[ctx].len,
-						    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&mpt_dev->pcidev->dev,
+						priv->RcvCtl[ctx].dma,
+						priv->RcvCtl[ctx].len,
+						DMA_FROM_DEVICE);
 			skb_copy_from_linear_data(old_skb, skb_put(skb, l), l);
 
-			pci_dma_sync_single_for_device(mpt_dev->pcidev,
-						       priv->RcvCtl[ctx].dma,
-						       priv->RcvCtl[ctx].len,
-						       PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&mpt_dev->pcidev->dev,
+						   priv->RcvCtl[ctx].dma,
+						   priv->RcvCtl[ctx].len,
+						   DMA_FROM_DEVICE);
 
 			priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
 			szrem -= l;
@@ -1059,17 +1064,17 @@ mpt_lan_receive_post_reply(struct net_device *dev,
 			return -ENOMEM;
 		}
 
-		pci_dma_sync_single_for_cpu(mpt_dev->pcidev,
-					    priv->RcvCtl[ctx].dma,
-					    priv->RcvCtl[ctx].len,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&mpt_dev->pcidev->dev,
+					priv->RcvCtl[ctx].dma,
+					priv->RcvCtl[ctx].len,
+					DMA_FROM_DEVICE);
 
 		skb_copy_from_linear_data(old_skb, skb_put(skb, len), len);
 
-		pci_dma_sync_single_for_device(mpt_dev->pcidev,
-					       priv->RcvCtl[ctx].dma,
-					       priv->RcvCtl[ctx].len,
-					       PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&mpt_dev->pcidev->dev,
+					   priv->RcvCtl[ctx].dma,
+					   priv->RcvCtl[ctx].len,
+					   DMA_FROM_DEVICE);
 
 		spin_lock_irqsave(&priv->rxfidx_lock, flags);
 		priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
@@ -1080,8 +1085,8 @@ mpt_lan_receive_post_reply(struct net_device *dev,
 
 		priv->RcvCtl[ctx].skb = NULL;
 
-		pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-				 priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&mpt_dev->pcidev->dev, priv->RcvCtl[ctx].dma,
+				 priv->RcvCtl[ctx].len, DMA_FROM_DEVICE);
 		priv->RcvCtl[ctx].dma = 0;
 
 		priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
@@ -1202,10 +1207,10 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 
 			skb = priv->RcvCtl[ctx].skb;
 			if (skb && (priv->RcvCtl[ctx].len != len)) {
-				pci_unmap_single(mpt_dev->pcidev,
+				dma_unmap_single(&mpt_dev->pcidev->dev,
 						 priv->RcvCtl[ctx].dma,
 						 priv->RcvCtl[ctx].len,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 				dev_kfree_skb(priv->RcvCtl[ctx].skb);
 				skb = priv->RcvCtl[ctx].skb = NULL;
 			}
@@ -1221,8 +1226,9 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 					break;
 				}
 
-				dma = pci_map_single(mpt_dev->pcidev, skb->data,
-						     len, PCI_DMA_FROMDEVICE);
+				dma = dma_map_single(&mpt_dev->pcidev->dev,
+						     skb->data, len,
+						     DMA_FROM_DEVICE);
 
 				priv->RcvCtl[ctx].skb = skb;
 				priv->RcvCtl[ctx].dma = dma;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index e0508ff16a09..45d3aa08a4a2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -674,8 +674,8 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 	if (!hdr.PageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer)
 		goto out;
@@ -741,8 +741,8 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 
  out:
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 }
 
 /**
@@ -1371,8 +1371,8 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			&dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -1398,8 +1398,8 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *ioc, struct mptsas_enclosure *enclosure,
 	enclosure->sep_channel = buffer->SEPBus;
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2030,8 +2030,8 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 	if (!hdr.ExtPageLength)
 		return -ENXIO;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -2053,8 +2053,8 @@ static int mptsas_get_linkerrors(struct sas_phy *phy)
 		le32_to_cpu(buffer->PhyResetProblemCount);
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
 	return error;
 }
 
@@ -2273,7 +2273,7 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		       << MPI_SGE_FLAGS_SHIFT;
 
 	if (!dma_map_sg(&ioc->pcidev->dev, job->request_payload.sg_list,
-			1, PCI_DMA_BIDIRECTIONAL))
+			1, DMA_BIDIRECTIONAL))
 		goto put_mf;
 
 	flagsLength |= (sg_dma_len(job->request_payload.sg_list) - 4);
@@ -2290,7 +2290,7 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
 
 	if (!dma_map_sg(&ioc->pcidev->dev, job->reply_payload.sg_list,
-			1, PCI_DMA_BIDIRECTIONAL))
+			1, DMA_BIDIRECTIONAL))
 		goto unmap_out;
 	flagsLength |= sg_dma_len(job->reply_payload.sg_list) + 4;
 	ioc->add_sge(psge, flagsLength,
@@ -2328,10 +2328,10 @@ static void mptsas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 
 unmap_in:
 	dma_unmap_sg(&ioc->pcidev->dev, job->reply_payload.sg_list, 1,
-			PCI_DMA_BIDIRECTIONAL);
+			DMA_BIDIRECTIONAL);
 unmap_out:
 	dma_unmap_sg(&ioc->pcidev->dev, job->request_payload.sg_list, 1,
-			PCI_DMA_BIDIRECTIONAL);
+			DMA_BIDIRECTIONAL);
 put_mf:
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
@@ -2384,8 +2384,8 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-					    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2424,8 +2424,8 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 	}
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2459,8 +2459,8 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-					    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2481,8 +2481,8 @@ mptsas_sas_io_unit_pg1(MPT_ADAPTER *ioc)
 	    device_missing_delay & MPI_SAS_IOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2523,8 +2523,8 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2545,8 +2545,8 @@ mptsas_sas_phy_pg0(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	phy_info->attached.handle = le16_to_cpu(buffer->AttachedDevHandle);
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2586,8 +2586,8 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2626,8 +2626,8 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	device_info->flags = le16_to_cpu(buffer->Flags);
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2669,8 +2669,8 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2709,8 +2709,8 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 	}
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2749,8 +2749,8 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-				      &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer) {
 		error = -ENOMEM;
 		goto out;
@@ -2782,8 +2782,8 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	phy_info->attached.handle = le16_to_cpu(buffer->AttachedDevHandle);
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-			    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return error;
 }
@@ -2867,7 +2867,8 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 
 	sz = sizeof(struct rep_manu_request) + sizeof(struct rep_manu_reply);
 
-	data_out = pci_alloc_consistent(ioc->pcidev, sz, &data_out_dma);
+	data_out = dma_alloc_coherent(&ioc->pcidev->dev, sz, &data_out_dma,
+				      GFP_KERNEL);
 	if (!data_out) {
 		printk(KERN_ERR "Memory allocation failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
@@ -2958,7 +2959,8 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 	}
 out_free:
 	if (data_out_dma)
-		pci_free_consistent(ioc->pcidev, sz, data_out, data_out_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, data_out,
+				  data_out_dma);
 put_mf:
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
@@ -4244,8 +4246,8 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (!hdr.PageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer)
 		goto out;
@@ -4291,8 +4293,8 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
  out:
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 }
 /*
  * Work queue thread to handle SAS hotplug events
-- 
2.28.0

