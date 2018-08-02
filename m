From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH v2 4/9] dmapool: improve scalability of dma_pool_alloc
Date: Thu, 2 Aug 2018 15:58:40 -0400
Message-ID: <1dbe6204-17fc-efd9-2381-48186cae2b94@cybernetics.com>
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
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

dma_pool_alloc() scales poorly when allocating a large number of pages
because it does a linear scan of all previously-allocated pages before
allocating a new one.  Improve its scalability by maintaining a separate
list of pages that have free blocks ready to (re)allocate.  In big O
notation, this improves the algorithm from O(n^2) to O(n).

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---

Changes since v1:

*) In v1, there was one (original) list for all pages and one (new) list
for pages with free blocks.  In v2, there is one list for pages with
free blocks and one list for pages without free blocks, and pages are
moved back and forth between the two lists.  This is to avoid bloating
struct dma_page with extra list pointers, which is important so that a
later patch can move its fields into struct page.

*) Use list_first_entry_or_null instead of !list_empty/list_first_entry.

Note that pool_find_page() will be removed entirely by a later patch, so
the extra code there won't stay for long.

--- linux/mm/dmapool.c.orig	2018-08-02 10:01:26.000000000 -0400
+++ linux/mm/dmapool.c	2018-08-02 10:03:46.000000000 -0400
@@ -15,11 +15,16 @@
  * Many older drivers still have their own code to do this.
  *
  * The current design of this allocator is fairly simple.  The pool is
- * represented by the 'struct dma_pool' which keeps a doubly-linked list of
- * allocated pages.  Each page in the page_list is split into blocks of at
- * least 'size' bytes.  Free blocks are tracked in an unsorted singly-linked
- * list of free blocks within the page.  Used blocks aren't tracked, but we
- * keep a count of how many are currently allocated from each page.
+ * represented by the 'struct dma_pool'.  Each allocated page is split into
+ * blocks of at least 'size' bytes.  Free blocks are tracked in an unsorted
+ * singly-linked list of free blocks within the page.  Used blocks aren't
+ * tracked, but we keep a count of how many are currently allocated from each
+ * page.
+ *
+ * The pool keeps two doubly-linked list of allocated pages.  The 'available'
+ * list tracks pages that have one or more free blocks, and the 'full' list
+ * tracks pages that have no free blocks.  Pages are moved from one list to
+ * the other as their blocks are allocated and freed.
  */
 
 #include <linux/device.h>
@@ -43,7 +48,10 @@
 #endif
 
 struct dma_pool {		/* the pool */
-	struct list_head page_list;
+#define POOL_FULL_IDX   0
+#define POOL_AVAIL_IDX  1
+#define POOL_N_LISTS    2
+	struct list_head page_list[POOL_N_LISTS];
 	spinlock_t lock;
 	size_t size;
 	struct device *dev;
@@ -54,7 +62,7 @@ struct dma_pool {		/* the pool */
 };
 
 struct dma_page {		/* cacheable header for 'allocation' bytes */
-	struct list_head page_list;
+	struct list_head dma_list;
 	void *vaddr;
 	dma_addr_t dma;
 	unsigned int in_use;
@@ -70,7 +78,6 @@ show_pools(struct device *dev, struct de
 	unsigned temp;
 	unsigned size;
 	char *next;
-	struct dma_page *page;
 	struct dma_pool *pool;
 
 	next = buf;
@@ -84,11 +91,18 @@ show_pools(struct device *dev, struct de
 	list_for_each_entry(pool, &dev->dma_pools, pools) {
 		unsigned pages = 0;
 		unsigned blocks = 0;
+		int list_idx;
 
 		spin_lock_irq(&pool->lock);
-		list_for_each_entry(page, &pool->page_list, page_list) {
-			pages++;
-			blocks += page->in_use;
+		for (list_idx = 0; list_idx < POOL_N_LISTS; list_idx++) {
+			struct dma_page *page;
+
+			list_for_each_entry(page,
+					    &pool->page_list[list_idx],
+					    dma_list) {
+				pages++;
+				blocks += page->in_use;
+			}
 		}
 		spin_unlock_irq(&pool->lock);
 
@@ -163,7 +177,8 @@ struct dma_pool *dma_pool_create(const c
 
 	retval->dev = dev;
 
-	INIT_LIST_HEAD(&retval->page_list);
+	INIT_LIST_HEAD(&retval->page_list[0]);
+	INIT_LIST_HEAD(&retval->page_list[1]);
 	spin_lock_init(&retval->lock);
 	retval->size = size;
 	retval->boundary = boundary;
@@ -252,7 +267,7 @@ static void pool_free_page(struct dma_po
 	void *vaddr = page->vaddr;
 	dma_addr_t dma = page->dma;
 
-	list_del(&page->page_list);
+	list_del(&page->dma_list);
 
 	if (is_page_busy(page)) {
 		dev_err(pool->dev,
@@ -278,8 +293,8 @@ static void pool_free_page(struct dma_po
  */
 void dma_pool_destroy(struct dma_pool *pool)
 {
-	struct dma_page *page;
 	bool empty = false;
+	int list_idx;
 
 	if (unlikely(!pool))
 		return;
@@ -294,10 +309,15 @@ void dma_pool_destroy(struct dma_pool *p
 		device_remove_file(pool->dev, &dev_attr_pools);
 	mutex_unlock(&pools_reg_lock);
 
-	while ((page = list_first_entry_or_null(&pool->page_list,
-						struct dma_page,
-						page_list))) {
-		pool_free_page(pool, page);
+	for (list_idx = 0; list_idx < POOL_N_LISTS; list_idx++) {
+		struct dma_page *page;
+
+		while ((page = list_first_entry_or_null(
+					&pool->page_list[list_idx],
+					struct dma_page,
+					dma_list))) {
+			pool_free_page(pool, page);
+		}
 	}
 
 	kfree(pool);
@@ -325,10 +345,11 @@ void *dma_pool_alloc(struct dma_pool *po
 	might_sleep_if(gfpflags_allow_blocking(mem_flags));
 
 	spin_lock_irqsave(&pool->lock, flags);
-	list_for_each_entry(page, &pool->page_list, page_list) {
-		if (page->offset < pool->allocation)
-			goto ready;
-	}
+	page = list_first_entry_or_null(&pool->page_list[POOL_AVAIL_IDX],
+					struct dma_page,
+					dma_list);
+	if (page)
+		goto ready;
 
 	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -339,11 +360,16 @@ void *dma_pool_alloc(struct dma_pool *po
 
 	spin_lock_irqsave(&pool->lock, flags);
 
-	list_add(&page->page_list, &pool->page_list);
+	list_add(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);
  ready:
 	page->in_use++;
 	offset = page->offset;
 	page->offset = *(int *)(page->vaddr + offset);
+	if (page->offset >= pool->allocation) {
+		/* Move page from the "available" list to the "full" list. */
+		list_del(&page->dma_list);
+		list_add(&page->dma_list, &pool->page_list[POOL_FULL_IDX]);
+	}
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	DMAPOOL_DEBUG
@@ -381,13 +407,19 @@ EXPORT_SYMBOL(dma_pool_alloc);
 
 static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
 {
-	struct dma_page *page;
+	int list_idx;
+
+	for (list_idx = 0; list_idx < POOL_N_LISTS; list_idx++) {
+		struct dma_page *page;
 
-	list_for_each_entry(page, &pool->page_list, page_list) {
-		if (dma < page->dma)
-			continue;
-		if ((dma - page->dma) < pool->allocation)
-			return page;
+		list_for_each_entry(page,
+				    &pool->page_list[list_idx],
+				    dma_list) {
+			if (dma < page->dma)
+				continue;
+			if ((dma - page->dma) < pool->allocation)
+				return page;
+		}
 	}
 	return NULL;
 }
@@ -444,6 +476,11 @@ void dma_pool_free(struct dma_pool *pool
 #endif
 
 	page->in_use--;
+	if (page->offset >= pool->allocation) {
+		/* Move page from the "full" list to the "available" list. */
+		list_del(&page->dma_list);
+		list_add(&page->dma_list, &pool->page_list[POOL_AVAIL_IDX]);
+	}
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
 	/*
