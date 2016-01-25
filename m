From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH v3] mptlan: add checks for dma mapping errors
Date: Mon, 25 Jan 2016 19:02:24 +0100
Message-ID: <1453744944-4065-1-git-send-email-khoroshilov@ispras.ru>
References: <56A6568B.9020707@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56A6568B.9020707@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

mpt_lan_sdu_send() and mpt_lan_post_receive_buckets() do not check
if mapping dma memory succeed.
The patch adds the checks and failure handling.

v3: Fix resource deallocation (reported by Tomas Henzl).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/message/fusion/mptlan.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index cbe96072a6cc..e9b83fc7be35 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -734,6 +734,13 @@ mpt_lan_sdu_send (struct sk_buff *skb, struct net_device *dev)
 
         dma = pci_map_single(mpt_dev->pcidev, skb->data, skb->len,
 			     PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(mpt_dev->pcidev, dma)) {
+		mpt_put_msg_frame(LanCtx, mpt_dev, mf);
+		netif_stop_queue(dev);
+
+		printk (KERN_ERR "%s: dma mapping failed\n", __func__);
+		return NETDEV_TX_BUSY;
+	}
 
 	priv->SendCtl[ctx].skb = skb;
 	priv->SendCtl[ctx].dma = dma;
@@ -1232,6 +1239,15 @@ mpt_lan_post_receive_buckets(struct mpt_lan_priv *priv)
 
 				dma = pci_map_single(mpt_dev->pcidev, skb->data,
 						     len, PCI_DMA_FROMDEVICE);
+				if (pci_dma_mapping_error(mpt_dev->pcidev, dma)) {
+					printk (KERN_WARNING
+						MYNAM "/%s: dma mapping failed\n",
+						__func__);
+					dev_kfree_skb(skb);
+					priv->mpt_rxfidx[++priv->mpt_rxfidx_tail] = ctx;
+					spin_unlock_irqrestore(&priv->rxfidx_lock, flags);
+					break;
+				}
 
 				priv->RcvCtl[ctx].skb = skb;
 				priv->RcvCtl[ctx].dma = dma;
-- 
1.9.1
