From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH v3 02/10] dmapool: remove checks for dev == NULL
Date: Tue, 7 Aug 2018 12:45:42 -0400
Message-ID: <99c5f149-90a7-dcc5-73a5-179ca009f914@cybernetics.com>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

dmapool originally tried to support pools without a device because
dma_alloc_coherent() supports allocations without a device.  But nobody
ended up using dma pools without a device, so the current checks in
dmapool.c for pool->dev == NULL are both insufficient and causing bloat.
Remove them.

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---

Changes since v2:
*) This was "dmapool: cleanup error messages" in v2.
*) Remove one more check for dev == NULL in dma_pool_destroy() that is
   unrelated to error messages.

--- linux/mm/dmapool.c.orig	2018-08-03 16:12:23.000000000 -0400
+++ linux/mm/dmapool.c	2018-08-03 16:13:44.000000000 -0400
@@ -277,7 +277,7 @@ void dma_pool_destroy(struct dma_pool *p
 	mutex_lock(&pools_reg_lock);
 	mutex_lock(&pools_lock);
 	list_del(&pool->pools);
-	if (pool->dev && list_empty(&pool->dev->dma_pools))
+	if (list_empty(&pool->dev->dma_pools))
 		empty = true;
 	mutex_unlock(&pools_lock);
 	if (empty)
@@ -289,13 +289,9 @@ void dma_pool_destroy(struct dma_pool *p
 		page = list_entry(pool->page_list.next,
 				  struct dma_page, page_list);
 		if (is_page_busy(page)) {
-			if (pool->dev)
-				dev_err(pool->dev,
-					"dma_pool_destroy %s, %p busy\n",
-					pool->name, page->vaddr);
-			else
-				pr_err("dma_pool_destroy %s, %p busy\n",
-				       pool->name, page->vaddr);
+			dev_err(pool->dev,
+				"dma_pool_destroy %s, %p busy\n",
+				pool->name, page->vaddr);
 			/* leak the still-in-use consistent memory */
 			list_del(&page->page_list);
 			kfree(page);
@@ -357,13 +353,9 @@ void *dma_pool_alloc(struct dma_pool *po
 		for (i = sizeof(page->offset); i < pool->size; i++) {
 			if (data[i] == POOL_POISON_FREED)
 				continue;
-			if (pool->dev)
-				dev_err(pool->dev,
-					"dma_pool_alloc %s, %p (corrupted)\n",
-					pool->name, retval);
-			else
-				pr_err("dma_pool_alloc %s, %p (corrupted)\n",
-					pool->name, retval);
+			dev_err(pool->dev,
+				"dma_pool_alloc %s, %p (corrupted)\n",
+				pool->name, retval);
 
 			/*
 			 * Dump the first 4 bytes even if they are not
@@ -418,13 +410,9 @@ void dma_pool_free(struct dma_pool *pool
 	page = pool_find_page(pool, dma);
 	if (!page) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		if (pool->dev)
-			dev_err(pool->dev,
-				"dma_pool_free %s, %p/%lx (bad dma)\n",
-				pool->name, vaddr, (unsigned long)dma);
-		else
-			pr_err("dma_pool_free %s, %p/%lx (bad dma)\n",
-			       pool->name, vaddr, (unsigned long)dma);
+		dev_err(pool->dev,
+			"dma_pool_free %s, %p/%lx (bad dma)\n",
+			pool->name, vaddr, (unsigned long)dma);
 		return;
 	}
 
@@ -432,13 +420,9 @@ void dma_pool_free(struct dma_pool *pool
 #ifdef	DMAPOOL_DEBUG
 	if ((dma - page->dma) != offset) {
 		spin_unlock_irqrestore(&pool->lock, flags);
-		if (pool->dev)
-			dev_err(pool->dev,
-				"dma_pool_free %s, %p (bad vaddr)/%pad\n",
-				pool->name, vaddr, &dma);
-		else
-			pr_err("dma_pool_free %s, %p (bad vaddr)/%pad\n",
-			       pool->name, vaddr, &dma);
+		dev_err(pool->dev,
+			"dma_pool_free %s, %p (bad vaddr)/%pad\n",
+			pool->name, vaddr, &dma);
 		return;
 	}
 	{
@@ -449,12 +433,9 @@ void dma_pool_free(struct dma_pool *pool
 				continue;
 			}
 			spin_unlock_irqrestore(&pool->lock, flags);
-			if (pool->dev)
-				dev_err(pool->dev, "dma_pool_free %s, dma %pad already free\n",
-					pool->name, &dma);
-			else
-				pr_err("dma_pool_free %s, dma %pad already free\n",
-				       pool->name, &dma);
+			dev_err(pool->dev,
+				"dma_pool_free %s, dma %pad already free\n",
+				pool->name, &dma);
 			return;
 		}
 	}
