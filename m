Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3305DC48BCF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC8B661029
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhFMKfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:35:14 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:28338 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhFMKfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 06:35:14 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d10 with ME
        id GaZB2500a21Fzsu03aZBVb; Sun, 13 Jun 2021 12:33:12 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 12:33:12 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: mptlan: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 12:33:10 +0200
Message-Id: <db56a78d7d04b809abd32a6fb4839d698587bf7c.1623580326.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.
It has been compile tested.

No memory allocation in involved in this patch, so no GFP_ tweak is needed.

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
 drivers/message/fusion/mptlan.c | 90 ++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 3261cac762de..e62c90127cc2 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -516,9 +516,9 @@ mpt_lan_close(struct net_device *dev)
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
@@ -528,9 +528,9 @@ mpt_lan_close(struct net_device *dev)
 
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
@@ -582,8 +582,8 @@ mpt_lan_send_turbo(struct net_device *dev, u32 tmsg)
 			__func__, sent));
 
 	priv->SendCtl[ctx].skb = NULL;
-	pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
-			 priv->SendCtl[ctx].len, PCI_DMA_TODEVICE);
+	dma_unmap_single(&mpt_dev->pcidev->dev, priv->SendCtl[ctx].dma,
+			 priv->SendCtl[ctx].len, DMA_TO_DEVICE);
 	dev_kfree_skb_irq(sent);
 
 	spin_lock_irqsave(&priv->txfidx_lock, flags);
@@ -648,8 +648,9 @@ mpt_lan_send_reply(struct net_device *dev, LANSendReply_t *pSendRep)
 				__func__, sent));
 
 		priv->SendCtl[ctx].skb = NULL;
-		pci_unmap_single(mpt_dev->pcidev, priv->SendCtl[ctx].dma,
-				 priv->SendCtl[ctx].len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&mpt_dev->pcidev->dev,
+				 priv->SendCtl[ctx].dma,
+				 priv->SendCtl[ctx].len, DMA_TO_DEVICE);
 		dev_kfree_skb_irq(sent);
 
 		priv->mpt_txfidx[++priv->mpt_txfidx_tail] = ctx;
@@ -720,8 +721,8 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, 12);
 
-        dma = pci_map_single(mpt_dev->pcidev, skb->data, skb->len,
-			     PCI_DMA_TODEVICE);
+	dma = dma_map_single(&mpt_dev->pcidev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
 
 	priv->SendCtl[ctx].skb = skb;
 	priv->SendCtl[ctx].dma = dma;
@@ -868,13 +869,17 @@ mpt_lan_receive_post_turbo(struct net_device *dev, u32 tmsg)
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
 
@@ -882,8 +887,8 @@ mpt_lan_receive_post_turbo(struct net_device *dev, u32 tmsg)
 
 	priv->RcvCtl[ctx].skb = NULL;
 
-	pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-			 priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&mpt_dev->pcidev->dev, priv->RcvCtl[ctx].dma,
+			 priv->RcvCtl[ctx].len, DMA_FROM_DEVICE);
 
 out:
 	spin_lock_irqsave(&priv->rxfidx_lock, flags);
@@ -927,8 +932,8 @@ mpt_lan_receive_post_free(struct net_device *dev,
 //		dlprintk((KERN_INFO MYNAM "@rpr[2] TC + 3\n"));
 
 		priv->RcvCtl[ctx].skb = NULL;
-		pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-				 priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&mpt_dev->pcidev->dev, priv->RcvCtl[ctx].dma,
+				 priv->RcvCtl[ctx].len, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 
 		priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
@@ -1028,16 +1033,16 @@ mpt_lan_receive_post_reply(struct net_device *dev,
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
@@ -1056,17 +1061,17 @@ mpt_lan_receive_post_reply(struct net_device *dev,
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
@@ -1077,8 +1082,8 @@ mpt_lan_receive_post_reply(struct net_device *dev,
 
 		priv->RcvCtl[ctx].skb = NULL;
 
-		pci_unmap_single(mpt_dev->pcidev, priv->RcvCtl[ctx].dma,
-				 priv->RcvCtl[ctx].len, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&mpt_dev->pcidev->dev, priv->RcvCtl[ctx].dma,
+				 priv->RcvCtl[ctx].len, DMA_FROM_DEVICE);
 		priv->RcvCtl[ctx].dma = 0;
 
 		priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
@@ -1199,10 +1204,10 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 
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
@@ -1218,8 +1223,9 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 					break;
 				}
 
-				dma = pci_map_single(mpt_dev->pcidev, skb->data,
-						     len, PCI_DMA_FROMDEVICE);
+				dma = dma_map_single(&mpt_dev->pcidev->dev,
+						     skb->data, len,
+						     DMA_FROM_DEVICE);
 
 				priv->RcvCtl[ctx].skb = skb;
 				priv->RcvCtl[ctx].dma = dma;
-- 
2.30.2

