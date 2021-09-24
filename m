Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842FAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 20:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D83611C8
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 20:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhIXUty (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 16:49:54 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:59656 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbhIXUtx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 16:49:53 -0400
Received: from pop-os.home ([90.126.248.220])
        by mwinf5d44 with ME
        id xwoF250084m3Hzu03woFy5; Fri, 24 Sep 2021 22:48:16 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 24 Sep 2021 22:48:16 +0200
X-ME-IP: 90.126.248.220
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] scsi: mptlan: Remove usage of the deprecated "pci-dma-compat.h" API
Date:   Fri, 24 Sep 2021 22:48:13 +0200
Message-Id: <db5aa78d7d44b809ab83ba6fb4880d698517bfec.1623580326.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In [1], Christoph Hellwig has proposed to remove the wrappers in
include/linux/pci-dma-compat.h.

Some reasons why this API should be removed have been given by Julia
Lawall in [2].

Finally, Arnd Bergmann reminded that the documentation was updated 11 years
ago to only describe the modern linux/dma-mapping.h interfaces and mark the
old bus-specific ones as no longer recommended, see commit 216bf58f4092
("Documentation: convert PCI-DMA-mapping.txt to use the generic DMA API").

A coccinelle script has been used to perform the needed transformation
Only relevant parts are given below.

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

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
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

[1]: https://lore.kernel.org/kernel-janitors/20200421081257.GA131897@infradead.org/
[2]: https://lore.kernel.org/kernel-janitors/alpine.DEB.2.22.394.2007120902170.2424@hadrien/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: Change Subject to be more explicit
    Keep only relevant part of the coccinelle script
    Try to improve the commit message to give some reason of why this change is done
    Add the scsi maintainers in the To: field as suggested in [3]

[3]: https://lore.kernel.org/kernel-janitors/CAK8P3a2CBvw_GP372R+p8f4_pa82sMuQ5iHk4Nb2dJCzm_Fivw@mail.gmail.com/
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

