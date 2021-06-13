Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B8AC48BCF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 07:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88BBF60C41
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 07:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFMHMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 03:12:24 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:42826 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFMHMY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 03:12:24 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d31 with ME
        id GXAK2500121Fzsu03XAKqL; Sun, 13 Jun 2021 09:10:20 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 09:10:20 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: mptfc: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 09:10:16 +0200
Message-Id: <95afc589713ade2110e7812159ce3e9ab453ec18.1623568121.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'mptfc_GetFcDevPage0()' GFP_KERNEL can be used
because it is already used in this function and no lock is acquired in the
between.

When memory is allocated in 'mptfc_GetFcPortPage0()' and
'mptfc_GetFcPortPage1()' GFP_KERNEL can be used because they already call
'mpt_config()' which has an explicit 'might_sleep()'.

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
 drivers/message/fusion/mptfc.c | 35 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 0484e9c15c09..572333fadd68 100644
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
+				  ppage0_alloc, page0_dma);
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
+		dma_free_coherent(&ioc->pcidev->dev, data_sz, ppage0_alloc,
+				  page0_dma);
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
+					  page1_alloc, page1_dma);
 			goto start_over;
 		}
 	}
@@ -932,8 +933,8 @@ mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
 	}
 	else {
 		ioc->fc_data.fc_port_page1[portnum].data = NULL;
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *)
-			page1_alloc, page1_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz, page1_alloc,
+				  page1_dma);
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
+					  ioc->fc_data.fc_port_page1[ii].data,
+					  ioc->fc_data.fc_port_page1[ii].dma);
 			ioc->fc_data.fc_port_page1[ii].data = NULL;
 		}
 	}
-- 
2.30.2

