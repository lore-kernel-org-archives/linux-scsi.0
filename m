From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH v2 5/9] dmapool: rename fields in dma_page
Date: Thu, 2 Aug 2018 15:59:15 -0400
Message-ID: <e2badcf3-c284-5c2d-6fa9-4efa4fd9f19a@cybernetics.com>
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

Rename fields in 'struct dma_page' in preparation for moving them into
'struct page'.  No functional changes.

in_use -> dma_in_use
offset -> dma_free_o

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---
--- linux/mm/dmapool.c.orig	2018-08-02 10:03:46.000000000 -0400
+++ linux/mm/dmapool.c	2018-08-02 10:06:32.000000000 -0400
@@ -65,8 +65,8 @@ struct dma_page {		/* cacheable header f
 	struct list_head dma_list;
 	void *vaddr;
 	dma_addr_t dma;
-	unsigned int in_use;
-	unsigned int offset;
+	unsigned int dma_in_use;
+	unsigned int dma_free_o;
 };
 
 static DEFINE_MUTEX(pools_lock);
@@ -101,7 +101,7 @@ show_pools(struct device *dev, struct de
 					    &pool->page_list[list_idx],
 					    dma_list) {
 				pages++;
-				blocks += page->in_use;
+				blocks += page->dma_in_use;
 			}
 		}
 		spin_unlock_irq(&pool->lock);
@@ -248,8 +248,8 @@ static struct dma_page *pool_alloc_page(
 		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 #endif
 		pool_initialise_page(pool, page);
-		page->in_use = 0;
-		page->offset = 0;
+		page->dma_in_use = 0;
+		page->dma_free_o = 0;
 	} else {
 		kfree(page);
 		page = NULL;
@@ -259,7 +259,7 @@ static struct dma_page *pool_alloc_page(
 
 static inline bool is_page_busy(struct dma_page *page)
 {
-	return page->in_use != 0;
+	return page->dma_in_use != 0;
 }
 
 static void pool_free_page(struct dma_pool *pool, struct dma_page *page)
@@ -362,10 +362,10 @@ void *dma_pool_alloc(struct dma_pool *po
 
 	list_add(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);
  ready:
-	page->in_use++;
-	offset = page->offset;
-	page->offset = *(int *)(page->vaddr + offset);
-	if (page->offset >= pool->allocation) {
+	page->dma_in_use++;
+	offset = page->dma_free_o;
+	page->dma_free_o = *(int *)(page->vaddr + offset);
+	if (page->dma_free_o >= pool->allocation) {
 		/* Move page from the "available" list to the "full" list. */
 		list_del(&page->dma_list);
 		list_add(&page->dma_list, &pool->page_list[POOL_FULL_IDX]);
@@ -376,8 +376,8 @@ void *dma_pool_alloc(struct dma_pool *po
 	{
 		int i;
 		u8 *data = retval;
-		/* page->offset is stored in first 4 bytes */
-		for (i = sizeof(page->offset); i < pool->size; i++) {
+		/* page->dma_free_o is stored in first 4 bytes */
+		for (i = sizeof(page->dma_free_o); i < pool->size; i++) {
 			if (data[i] == POOL_POISON_FREED)
 				continue;
 			dev_err(pool->dev,
@@ -459,7 +459,7 @@ void dma_pool_free(struct dma_pool *pool
 		return;
 	}
 	{
-		unsigned int chain = page->offset;
+		unsigned int chain = page->dma_free_o;
 		while (chain < pool->allocation) {
 			if (chain != offset) {
 				chain = *(int *)(page->vaddr + chain);
@@ -475,14 +475,14 @@ void dma_pool_free(struct dma_pool *pool
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
 
-	page->in_use--;
-	if (page->offset >= pool->allocation) {
+	page->dma_in_use--;
+	if (page->dma_free_o >= pool->allocation) {
 		/* Move page from the "full" list to the "available" list. */
 		list_del(&page->dma_list);
 		list_add(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);
 	}
-	*(int *)vaddr = page->offset;
-	page->offset = offset;
+	*(int *)vaddr = page->dma_free_o;
+	page->dma_free_o = offset;
 	/*
 	 * Resist a temptation to do
 	 *    if (!is_page_busy(page)) pool_free_page(pool, page);
