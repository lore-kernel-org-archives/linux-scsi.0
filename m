From: Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6/6] lib/scatterlist: Drop order argument from sgl_free_n_order
Date: Wed,  7 Mar 2018 12:47:12 +0000
Message-ID: <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
References: <20180307124712.14963-1-tvrtko.ursulin@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180307124712.14963-1-tvrtko.ursulin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

We can derive the order from sg->length and so do not need to pass it in
explicitly. Rename the function to sgl_free_n.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org

---
 drivers/target/target_core_transport.c |  2 +-
 include/linux/scatterlist.h            |  5 ++---
 lib/scatterlist.c                      | 16 ++++++----------
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4558f2e1fe1b..91e8f4047492 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2303,7 +2303,7 @@ static void target_complete_ok_work(struct work_struct *work)
 
 void target_free_sgl(struct scatterlist *sgl, int nents)
 {
-	sgl_free_n_order(sgl, nents, 0);
+	sgl_free_n(sgl, nents);
 }
 EXPORT_SYMBOL(target_free_sgl);
 
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 3ffc5f3bf181..3779d1fdd5c4 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -280,8 +280,7 @@ int sg_alloc_table_from_pages(struct sg_table *sgt, struct page **pages,
 struct scatterlist *sgl_alloc_order(unsigned long length, unsigned int order,
 				    bool chainable, gfp_t gfp,
 				    unsigned int *nent_p);
-void sgl_free_n_order(struct scatterlist *sgl, unsigned int nents,
-		      unsigned int order);
+void sgl_free_n(struct scatterlist *sgl, unsigned int nents);
 
 /**
  * sgl_alloc - allocate a scatterlist and its pages
@@ -303,7 +302,7 @@ sgl_alloc(unsigned long length, gfp_t gfp, unsigned int *nent_p)
  */
 static inline void sgl_free(struct scatterlist *sgl)
 {
-	sgl_free_n_order(sgl, UINT_MAX, 0);
+	sgl_free_n(sgl, UINT_MAX);
 }
 
 #endif /* CONFIG_SGL_ALLOC */
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c637849482d3..76111e91a038 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -493,7 +493,7 @@ struct scatterlist *sgl_alloc_order(unsigned long length, unsigned int order,
 {
 	unsigned int chunk_len = PAGE_SIZE << order;
 	struct scatterlist *sgl, *sg;
-	unsigned int nent, i;
+	unsigned int nent;
 
 	nent = round_up(length, chunk_len) >> (PAGE_SHIFT + order);
 
@@ -517,12 +517,11 @@ struct scatterlist *sgl_alloc_order(unsigned long length, unsigned int order,
 
 	sg_init_table(sgl, nent);
 	sg = sgl;
-	i = 0;
 	while (length) {
 		struct page *page = alloc_pages(gfp, order);
 
 		if (!page) {
-			sgl_free_n_order(sgl, i, order);
+			sgl_free(sgl);
 			return NULL;
 		}
 
@@ -530,7 +529,6 @@ struct scatterlist *sgl_alloc_order(unsigned long length, unsigned int order,
 		sg_set_page(sg, page, chunk_len, 0);
 		length -= chunk_len;
 		sg = sg_next(sg);
-		i++;
 	}
 	WARN_ONCE(length, "length = %ld\n", length);
 	return sgl;
@@ -538,10 +536,9 @@ struct scatterlist *sgl_alloc_order(unsigned long length, unsigned int order,
 EXPORT_SYMBOL(sgl_alloc_order);
 
 /**
- * sgl_free_n_order - free a scatterlist and its pages
+ * sgl_free_n - free a scatterlist and its pages
  * @sgl: Scatterlist with one or more elements
  * @nents: Maximum number of elements to free
- * @order: Second argument for __free_pages()
  *
  * Notes:
  * - If several scatterlists have been chained and each chain element is
@@ -550,8 +547,7 @@ EXPORT_SYMBOL(sgl_alloc_order);
  * - All pages in a chained scatterlist can be freed at once by setting @nents
  *   to a high number.
  */
-void sgl_free_n_order(struct scatterlist *sgl, unsigned int nents,
-		      unsigned int order)
+void sgl_free_n(struct scatterlist *sgl, unsigned int nents)
 {
 	struct scatterlist *sg;
 	struct page *page;
@@ -562,11 +558,11 @@ void sgl_free_n_order(struct scatterlist *sgl, unsigned int nents,
 			break;
 		page = sg_page(sg);
 		if (page)
-			__free_pages(page, order);
+			__free_pages(page, get_order(sg->length));
 	}
 	kfree(sgl);
 }
-EXPORT_SYMBOL(sgl_free_n_order);
+EXPORT_SYMBOL(sgl_free_n);
 
 #endif /* CONFIG_SGL_ALLOC */
 
-- 
2.14.1
