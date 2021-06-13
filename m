Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702F0C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 08:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C1161245
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 08:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhFMIZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 04:25:03 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:25094 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhFMIZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 04:25:02 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d41 with ME
        id GYNz2500G21Fzsu03YNzcb; Sun, 13 Jun 2021 10:23:00 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 10:23:00 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/3] scsi: mptbase: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 10:22:57 +0200
Message-Id: <fdcecd22abd9eb6b2c9c9fd2b63a7639ae972aa6.1623571676.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1623571676.git.christophe.jaillet@wanadoo.fr>
References: <cover.1623571676.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

In all these places where some memory is allocated GFP_KERNEL can be used
because they already call 'mpt_config()' which has an explicit
'might_sleep()'.

While at it, also remove some useless casting.

@@ @@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@ @@
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

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/message/fusion/mptbase.c | 147 +++++++++++++++++--------------
 1 file changed, 82 insertions(+), 65 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7f7abc9069f7..a9f261b6f613 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -300,8 +300,8 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
 	if (!hdr.ExtPageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 	if (!buffer)
 		goto out;
 
@@ -316,8 +316,8 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
 		rc = 1;
 
  out_free_consistent:
-	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
-	    buffer, dma_handle);
+	dma_free_coherent(&ioc->pcidev->dev, hdr.ExtPageLength * 4, buffer,
+			  dma_handle);
  out:
 	return rc;
 }
@@ -1666,16 +1666,14 @@ mpt_mapresources(MPT_ADAPTER *ioc)
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
@@ -1686,9 +1684,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
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
@@ -2774,9 +2771,9 @@ mpt_adapter_disable(MPT_ADAPTER *ioc)
 
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
@@ -4452,9 +4449,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
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
@@ -4462,10 +4458,10 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
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
@@ -4600,9 +4596,9 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		alloc_dma += ioc->reply_sz;
 	}
 
-	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
-	    ioc->dma_mask) && !pci_set_consistent_dma_mask(ioc->pcidev,
-	    ioc->dma_mask))
+	if (dma_mask == DMA_BIT_MASK(35) &&
+	    !dma_set_mask(&ioc->pcidev->dev, ioc->dma_mask) &&
+	    !dma_set_coherent_mask(&ioc->pcidev->dev, ioc->dma_mask))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
@@ -4625,9 +4621,9 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->sense_buf_pool = NULL;
 	}
 
-	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
-	    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(ioc->pcidev,
-	    DMA_BIT_MASK(64)))
+	if (dma_mask == DMA_BIT_MASK(35) &&
+	    !dma_set_mask(&ioc->pcidev->dev, DMA_BIT_MASK(64)) &&
+	    !dma_set_coherent_mask(&ioc->pcidev->dev, DMA_BIT_MASK(64)))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
@@ -4973,7 +4969,8 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	if (hdr.PageLength > 0) {
 		data_sz = hdr.PageLength * 4;
-		ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+		ppage0_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+						  &page0_dma, GFP_KERNEL);
 		rc = -ENOMEM;
 		if (ppage0_alloc) {
 			memset((u8 *)ppage0_alloc, 0, data_sz);
@@ -4987,7 +4984,8 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 			}
 
-			pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
+			dma_free_coherent(&ioc->pcidev->dev, data_sz,
+					  ppage0_alloc, page0_dma);
 
 			/* FIXME!
 			 *	Normalize endianness of structure data,
@@ -5019,7 +5017,8 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage1_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
+	ppage1_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+					  &page1_dma, GFP_KERNEL);
 	if (ppage1_alloc) {
 		memset((u8 *)ppage1_alloc, 0, data_sz);
 		cfg.physAddr = page1_dma;
@@ -5031,7 +5030,8 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 			memcpy(&ioc->lan_cnfg_page1, ppage1_alloc, copy_sz);
 		}
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage1_alloc, page1_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz, ppage1_alloc,
+				  page1_dma);
 
 		/* FIXME!
 		 *	Normalize endianness of structure data,
@@ -5320,7 +5320,8 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
 	/* Read the config page */
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	ppage_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+					 &page_dma, GFP_KERNEL);
 	if (ppage_alloc) {
 		memset((u8 *)ppage_alloc, 0, data_sz);
 		cfg.physAddr = page_dma;
@@ -5330,7 +5331,8 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
 		if ((rc = mpt_config(ioc, &cfg)) == 0)
 			ioc->biosVersion = le32_to_cpu(ppage_alloc->BiosVersion);
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage_alloc, page_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz, ppage_alloc,
+				  page_dma);
 	}
 
 	return rc;
@@ -5405,7 +5407,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 		 return -EFAULT;
 
 	if (header.PageLength > 0) {
-		pbuf = pci_alloc_consistent(ioc->pcidev, header.PageLength * 4, &buf_dma);
+		pbuf = dma_alloc_coherent(&ioc->pcidev->dev,
+					  header.PageLength * 4, &buf_dma,
+					  GFP_KERNEL);
 		if (pbuf) {
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 			cfg.physAddr = buf_dma;
@@ -5461,7 +5465,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
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
@@ -5483,7 +5489,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
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
@@ -5548,7 +5556,9 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc, int portnum)
 				}
 			}
 
-			pci_free_consistent(ioc->pcidev, header.PageLength * 4, pbuf, buf_dma);
+			dma_free_coherent(&ioc->pcidev->dev,
+					  header.PageLength * 4, pbuf,
+					  buf_dma);
 		}
 	}
 
@@ -5664,8 +5674,8 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	if (!hdr.PageLength)
 		goto out;
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer)
 		goto out;
@@ -5712,8 +5722,8 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *ioc, u8 channel, u8 id)
 
  out:
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 }
 
 /**
@@ -5757,8 +5767,8 @@ mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer) {
 		rc = -ENOMEM;
@@ -5781,8 +5791,8 @@ mpt_raid_phys_disk_pg0(MPT_ADAPTER *ioc, u8 phys_disk_num,
  out:
 
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 
 	return rc;
 }
@@ -5824,8 +5834,8 @@ mpt_raid_phys_disk_get_num_paths(MPT_ADAPTER *ioc, u8 phys_disk_num)
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer) {
 		rc = 0;
@@ -5845,8 +5855,8 @@ mpt_raid_phys_disk_get_num_paths(MPT_ADAPTER *ioc, u8 phys_disk_num)
  out:
 
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 
 	return rc;
 }
@@ -5896,8 +5906,8 @@ mpt_raid_phys_disk_pg1(MPT_ADAPTER *ioc, u8 phys_disk_num,
 		goto out;
 	}
 
-	buffer = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4,
-	    &dma_handle);
+	buffer = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				    &dma_handle, GFP_KERNEL);
 
 	if (!buffer) {
 		rc = -ENOMEM;
@@ -5934,8 +5944,8 @@ mpt_raid_phys_disk_pg1(MPT_ADAPTER *ioc, u8 phys_disk_num,
  out:
 
 	if (buffer)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, buffer,
-		    dma_handle);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  buffer, dma_handle);
 
 	return rc;
 }
@@ -5991,7 +6001,8 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 		return -EFAULT;
 
 	iocpage2sz = header.PageLength * 4;
-	pIoc2 = pci_alloc_consistent(ioc->pcidev, iocpage2sz, &ioc2_dma);
+	pIoc2 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage2sz, &ioc2_dma,
+				   GFP_KERNEL);
 	if (!pIoc2)
 		return -ENOMEM;
 
@@ -6016,7 +6027,7 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 		    pIoc2->RaidVolume[i].VolumeID);
 
  out:
-	pci_free_consistent(ioc->pcidev, iocpage2sz, pIoc2, ioc2_dma);
+	dma_free_coherent(&ioc->pcidev->dev, iocpage2sz, pIoc2, ioc2_dma);
 
 	return rc;
 }
@@ -6058,7 +6069,8 @@ mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 	/* Read Header good, alloc memory
 	 */
 	iocpage3sz = header.PageLength * 4;
-	pIoc3 = pci_alloc_consistent(ioc->pcidev, iocpage3sz, &ioc3_dma);
+	pIoc3 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage3sz, &ioc3_dma,
+				   GFP_KERNEL);
 	if (!pIoc3)
 		return 0;
 
@@ -6075,7 +6087,7 @@ mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 		}
 	}
 
-	pci_free_consistent(ioc->pcidev, iocpage3sz, pIoc3, ioc3_dma);
+	dma_free_coherent(&ioc->pcidev->dev, iocpage3sz, pIoc3, ioc3_dma);
 
 	return 0;
 }
@@ -6109,7 +6121,8 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 
 	if ( (pIoc4 = ioc->spi_data.pIocPg4) == NULL ) {
 		iocpage4sz = (header.PageLength + 4) * 4; /* Allow 4 additional SEP's */
-		pIoc4 = pci_alloc_consistent(ioc->pcidev, iocpage4sz, &ioc4_dma);
+		pIoc4 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage4sz,
+					   &ioc4_dma, GFP_KERNEL);
 		if (!pIoc4)
 			return;
 		ioc->alloc_total += iocpage4sz;
@@ -6127,7 +6140,8 @@ mpt_read_ioc_pg_4(MPT_ADAPTER *ioc)
 		ioc->spi_data.IocPg4_dma = ioc4_dma;
 		ioc->spi_data.IocPg4Sz = iocpage4sz;
 	} else {
-		pci_free_consistent(ioc->pcidev, iocpage4sz, pIoc4, ioc4_dma);
+		dma_free_coherent(&ioc->pcidev->dev, iocpage4sz, pIoc4,
+				  ioc4_dma);
 		ioc->spi_data.pIocPg4 = NULL;
 		ioc->alloc_total -= iocpage4sz;
 	}
@@ -6164,7 +6178,8 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 	/* Read Header good, alloc memory
 	 */
 	iocpage1sz = header.PageLength * 4;
-	pIoc1 = pci_alloc_consistent(ioc->pcidev, iocpage1sz, &ioc1_dma);
+	pIoc1 = dma_alloc_coherent(&ioc->pcidev->dev, iocpage1sz, &ioc1_dma,
+				   GFP_KERNEL);
 	if (!pIoc1)
 		return;
 
@@ -6215,7 +6230,7 @@ mpt_read_ioc_pg_1(MPT_ADAPTER *ioc)
 		}
 	}
 
-	pci_free_consistent(ioc->pcidev, iocpage1sz, pIoc1, ioc1_dma);
+	dma_free_coherent(&ioc->pcidev->dev, iocpage1sz, pIoc1, ioc1_dma);
 
 	return;
 }
@@ -6244,7 +6259,8 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 		goto out;
 
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
-	pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
+	pbuf = dma_alloc_coherent(&ioc->pcidev->dev, hdr.PageLength * 4,
+				  &buf_dma, GFP_KERNEL);
 	if (!pbuf)
 		goto out;
 
@@ -6260,7 +6276,8 @@ mpt_get_manufacturing_pg_0(MPT_ADAPTER *ioc)
 out:
 
 	if (pbuf)
-		pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
+		dma_free_coherent(&ioc->pcidev->dev, hdr.PageLength * 4, pbuf,
+				  buf_dma);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-- 
2.30.2

