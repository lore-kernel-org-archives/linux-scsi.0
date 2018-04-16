From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 11/12] net: remove the PCI_DMA_BUS_IS_PHYS check in
	illegal_highdma
Date: Mon, 16 Apr 2018 10:50:31 +0200
Message-ID: <20180416085032.7367-12-hch@lst.de>
References: <20180416085032.7367-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180416085032.7367-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

These days the dma mapping routines must be able to handle any address
supported by the device, be that using an iommu, or swiotlb if none is
supported.  With that the PCI_DMA_BUS_IS_PHYS check in illegal_highdma
is not needed and can be removed.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 net/core/dev.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 969462ebb296..5802cf177b07 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2884,11 +2884,7 @@ void netdev_rx_csum_fault(struct net_device *dev)
 EXPORT_SYMBOL(netdev_rx_csum_fault);
 #endif
 
-/* Actually, we should eliminate this check as soon as we know, that:
- * 1. IOMMU is present and allows to map all the memory.
- * 2. No high memory really exists on this machine.
- */
-
+/* XXX: check that highmem exists at all on the given machine. */
 static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 {
 #ifdef CONFIG_HIGHMEM
@@ -2902,20 +2898,6 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 				return 1;
 		}
 	}
-
-	if (PCI_DMA_BUS_IS_PHYS) {
-		struct device *pdev = dev->dev.parent;
-
-		if (!pdev)
-			return 0;
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-			dma_addr_t addr = page_to_phys(skb_frag_page(frag));
-
-			if (!pdev->dma_mask || addr + PAGE_SIZE - 1 > *pdev->dma_mask)
-				return 1;
-		}
-	}
 #endif
 	return 0;
 }
-- 
2.17.0
