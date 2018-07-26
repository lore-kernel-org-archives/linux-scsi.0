From: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Subject: [PATCH 1/3] dmapool: improve scalability of dma_pool_alloc
Date: Thu, 26 Jul 2018 14:54:21 -0400
Message-ID: <15ff502d-d840-1003-6c45-bc17f0d81262@cybernetics.com>
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
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

dma_pool_alloc() scales poorly when allocating a large number of pages
because it does a linear scan of all previously-allocated pages before
allocating a new one.  Improve its scalability by maintaining a separate
list of pages that have free blocks ready to (re)allocate.  In big O
notation, this improves the algorithm from O(n^2) to O(n).

Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
---

Using list_del_init() in dma_pool_alloc() makes it safe to call
list_del() unconditionally when freeing the page.

In dma_pool_free(), the check for being already in avail_page_list could
be written several different ways.  The most obvious way is:

if (page->offset >= pool->allocation)
	list_add(&page->avail_page_link, &pool->avail_page_list);

Another way would be to check page->in_use.  But since it is already
using list_del_init(), checking the list pointers directly is safest to
prevent any possible list corruption in case the caller misuses the API
(e.g. double-dma_pool_free()) with DMAPOOL_DEBUG disabled.

--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -20,6 +20,10 @@
  * least 'size' bytes.  Free blocks are tracked in an unsorted singly-linked
  * list of free blocks within the page.  Used blocks aren't tracked, but we
  * keep a count of how many are currently allocated from each page.
+ *
+ * The avail_page_list keeps track of pages that have one or more free blocks
+ * available to (re)allocate.  Pages are moved in and out of avail_page_list
+ * as their blocks are allocated and freed.
  */
 
 #include <linux/device.h>
@@ -44,6 +48,7 @@
 
 struct dma_pool {		/* the pool */
 	struct list_head page_list;
+	struct list_head avail_page_list;
 	spinlock_t lock;
 	size_t size;
 	struct device *dev;
@@ -55,6 +60,7 @@ struct dma_pool {		/* the pool */
 
 struct dma_page {		/* cacheable header for 'allocation' bytes */
 	struct list_head page_list;
+	struct list_head avail_page_link;
 	void *vaddr;
 	dma_addr_t dma;
 	unsigned int in_use;
@@ -164,6 +170,7 @@ struct dma_pool *dma_pool_create(const c
 	retval->dev = dev;
 
 	INIT_LIST_HEAD(&retval->page_list);
+	INIT_LIST_HEAD(&retval->avail_page_list);
 	spin_lock_init(&retval->lock);
 	retval->size = size;
 	retval->boundary = boundary;
@@ -256,6 +263,7 @@ static void pool_free_page(struct dma_po
 #endif
 	dma_free_coherent(pool->dev, pool->allocation, page->vaddr, dma);
 	list_del(&page->page_list);
+	list_del(&page->avail_page_link);
 	kfree(page);
 }
 
@@ -298,6 +306,7 @@ void dma_pool_destroy(struct dma_pool *p
 				       pool->name, page->vaddr);
 			/* leak the still-in-use consistent memory */
 			list_del(&page->page_list);
+			list_del(&page->avail_page_link);
 			kfree(page);
 		} else
 			pool_free_page(pool, page);
@@ -328,9 +337,11 @@ void *dma_pool_alloc(struct dma_pool *po
 	might_sleep_if(gfpflags_allow_blocking(mem_flags));
 
 	spin_lock_irqsave(&pool->lock, flags);
-	list_for_each_entry(page, &pool->page_list, page_list) {
-		if (page->offset < pool->allocation)
-			goto ready;
+	if (!list_empty(&pool->avail_page_list)) {
+		page = list_first_entry(&pool->avail_page_list,
+					struct dma_page,
+					avail_page_link);
+		goto ready;
 	}
 
 	/* pool_alloc_page() might sleep, so temporarily drop &pool->lock */
@@ -343,10 +354,13 @@ void *dma_pool_alloc(struct dma_pool *po
 	spin_lock_irqsave(&pool->lock, flags);
 
 	list_add(&page->page_list, &pool->page_list);
+	list_add(&page->avail_page_link, &pool->avail_page_list);
  ready:
 	page->in_use++;
 	offset = page->offset;
 	page->offset = *(int *)(page->vaddr + offset);
+	if (page->offset >= pool->allocation)
+		list_del_init(&page->avail_page_link);
 	retval = offset + page->vaddr;
 	*handle = offset + page->dma;
 #ifdef	DMAPOOL_DEBUG
@@ -461,6 +475,10 @@ void dma_pool_free(struct dma_pool *pool
 	memset(vaddr, POOL_POISON_FREED, pool->size);
 #endif
 
+	/* This test checks if the page is already in avail_page_list. */
+	if (list_empty(&page->avail_page_link))
+		list_add(&page->avail_page_link, &pool->avail_page_list);
+
 	page->in_use--;
 	*(int *)vaddr = page->offset;
 	page->offset = offset;
