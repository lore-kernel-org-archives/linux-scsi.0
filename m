From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH v2 7/9] dmapool: debug: prevent endless loop in case of
	corruption
Date: Thu, 2 Aug 2018 16:00:37 -0400
Message-ID: <36e483e9-d779-497a-551e-32f96e184b49@cybernetics.com>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Prevent a possible endless loop with DMAPOOL_DEBUG enabled if a buggy
driver corrupts DMA pool memory.

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---
--- linux/mm/dmapool.c.orig	2018-08-02 10:14:25.000000000 -0400
+++ linux/mm/dmapool.c	2018-08-02 10:16:17.000000000 -0400
@@ -449,16 +449,35 @@ void dma_pool_free(struct dma_pool *pool
 	{
 		void *page_vaddr = vaddr - offset;
 		unsigned int chain = page->dma_free_o;
+		size_t total_free = 0;
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
+			 * The calculation of the number of blocks per
+			 * allocation is actually more complicated than this
+			 * because of the boundary value.  But this comparison
+			 * does not need to be exact; it just needs to prevent
+			 * an endless loop in case a buggy driver causes a
+			 * circular loop in the freelist.
+			 */
+			total_free += pool->size;
+			if (unlikely(total_free >= pool->allocation)) {
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
 	}
 	memset(vaddr, POOL_POISON_FREED, pool->size);
