From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH v4 9/9] dmapool: debug: prevent endless loop in case of
	corruption
Date: Mon, 12 Nov 2018 10:46:35 -0500
Message-ID: <9e65ec2e-5e22-4f65-7b92-ca2af0c555f3@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Prevent a possible endless loop with DMAPOOL_DEBUG enabled if a buggy
driver corrupts DMA pool memory.

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---
--- linux/mm/dmapool.c.orig	2018-08-06 17:52:53.000000000 -0400
+++ linux/mm/dmapool.c	2018-08-06 17:53:31.000000000 -0400
@@ -454,17 +454,39 @@ void dma_pool_free(struct dma_pool *pool
 	{
 		void *page_vaddr = vaddr - offset;
 		unsigned int chain = page->dma_free_off;
+		unsigned int free_blks = 0;
+
 		while (chain < pool->allocation) {
-			if (chain != offset) {
-				chain = *(int *)(page_vaddr + chain);
-				continue;
+			if (unlikely(chain == offset)) {
+				spin_unlock_irqrestore(&pool->lock, flags);
+				dev_err(pool->dev,
+					"dma_pool_free %s, dma %pad already free\n",
+					pool->name, &dma);
+				return;
+			}
+
+			/*
+			 * A buggy driver could corrupt the freelist by
+			 * use-after-free, buffer overflow, etc.  Besides
+			 * checking for corruption, this also prevents an
+			 * endless loop in case corruption causes a circular
+			 * loop in the freelist.
+			 */
+			if (unlikely(++free_blks + page->dma_in_use >
+				     pool->blks_per_alloc)) {
+ freelist_corrupt:
+				spin_unlock_irqrestore(&pool->lock, flags);
+				dev_err(pool->dev,
+					"dma_pool_free %s, freelist corrupted\n",
+					pool->name);
+				return;
 			}
-			spin_unlock_irqrestore(&pool->lock, flags);
-			dev_err(pool->dev,
-				"dma_pool_free %s, dma %pad already free\n",
-				pool->name, &dma);
-			return;
+
+			chain = *(int *)(page_vaddr + chain);
 		}
+		if (unlikely(free_blks + page->dma_in_use !=
+			     pool->blks_per_alloc))
+			goto freelist_corrupt;
 	}
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
