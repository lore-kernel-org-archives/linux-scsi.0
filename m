From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH v4 3/9] dmapool: cleanup dma_pool_destroy
Date: Mon, 12 Nov 2018 10:42:48 -0500
Message-ID: <2ff327bb-59f7-5105-0bba-72329cb73154@cybernetics.com>
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
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Remove a small amount of code duplication between dma_pool_destroy() and
pool_free_page() in preparation for adding more code without having to
duplicate it.  No functional changes.

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---
--- linux/mm/dmapool.c.orig	2018-08-02 09:59:15.000000000 -0400
+++ linux/mm/dmapool.c	2018-08-02 10:01:26.000000000 -0400
@@ -249,13 +249,22 @@ static inline bool is_page_busy(struct d
 
 static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
 {
+	void *vaddr = page->vaddr;
 	dma_addr_t dma = page->dma;
 
+	list_del(&page->page_list);
+
+	if (is_page_busy(page)) {
+		dev_err(pool->dev,
+			"dma_pool_destroy %s, %p busy\n",
+			pool->name, vaddr);
+		/* leak the still-in-use consistent memory */
+	} else {
 #ifdef	DMAPOOL_DEBUG
-	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
+		memset(vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
-	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
-	list_del(&page->page_list);
+		dma_free_coherent(pool->dev, pool->allocation, vaddr, dma);
+	}
 	kfree(page);
 }
 
@@ -269,6 +278,7 @@ static void pool_free_page(struct dma_po
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
+	struct dma_page *page;
 	bool empty = false;
 
 	if (unlikely(!pool))
@@ -284,19 +294,10 @@ void dma_pool_destroy(struct dma_pool *p
 		device_remove_file(pool->dev, &dev_attr_pools);
 	mutex_unlock(&pools_reg_lock);
 
-	while (!list_empty(&pool->page_list)) {
-		struct dma_page *page;
-		page = list_entry(pool->page_list.next,
-				  struct dma_page, page_list);
-		if (is_page_busy(page)) {
-			dev_err(pool->dev,
-				"dma_pool_destroy %s, %p busy\n",
-				pool->name, page->vaddr);
-			/* leak the still-in-use consistent memory */
-			list_del(&page->page_list);
-			kfree(page);
-		} else
-			pool_free_page(pool, page);
+	while ((page = list_first_entry_or_null(&pool->page_list,
+						struct dma_page,
+						page_list))) {
+		pool_free_page(pool, page);
 	}
 
 	kfree(pool);
