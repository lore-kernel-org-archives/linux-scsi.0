From: michaelc@cs.wisc.edu
Subject: [PATCH 09/10] Add REQ_TYPE_BLOCL_PC mmap helpers
Date: Sat, 20 Oct 2007 00:44:43 -0500
Message-ID: <11928590903157-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
	<11928590861021-git-send-email-michaelc@cs.wisc.edu>
	<11928590871413-git-send-email-michaelc@cs.wisc.edu>
	<11928590871678-git-send-email-michaelc@cs.wisc.edu>
	<11928590884170-git-send-email-michaelc@cs.wisc.edu>
	<11928590894155-git-send-email-michaelc@cs.wisc.edu>
	<11928590892682-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590892682-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

sg supports a sg io mmap operation. These patches add some mmap helpers
based on the existing bio and blk functions.

This patch also modifies bioset_pagepool_create so that
it takes the number of pagepool entries. This is needed by
sg mmap (and other sg ops), so that it can allocate multiple large
blocks of pages.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c      |   90 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/bio.c               |   81 +++++++++++++++++++++++++++++++++++++++----
 include/linux/bio.h    |   12 ++++++-
 include/linux/blkdev.h |    9 +++++
 4 files changed, 183 insertions(+), 9 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 7298289..52b42d7 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2710,6 +2710,96 @@ int blk_rq_map_user_iov(struct bio_set *bs, struct request *rq,
 
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
+void blk_rq_mmap_close(struct bio_map_data *bmd)
+{
+	bioset_free_pages(bmd);
+}
+EXPORT_SYMBOL(blk_rq_mmap_close);
+
+/**
+ * blk_rq_mmap_open - alloc and setup buffers for REQ_BLOCK_PC mmap
+ * @bs:		bio set
+ * @q:		request queue
+ * @vma:	vm struct
+ *
+ * Description:
+ *    A the caller must also call blk_rq_setup_mmap_buffer on the request to
+ *    map the buffer to a bio.
+ *
+ *    When the mmap operation is done, blk_rq_mmap_close must be called.
+ */
+struct bio_map_data *blk_rq_mmap_open(struct bio_set *bs,
+				      struct request_queue *q,
+				      struct vm_area_struct *vma)
+{
+	struct bio_map_data *bmd;
+
+	if (vma->vm_pgoff)
+		return NULL;
+
+	if (!bs)
+		return NULL;
+
+	bmd = bioset_alloc_pages(q, bs, vma->vm_end - vma->vm_start,
+				 GFP_KERNEL);
+	if (!bmd)
+		return NULL;
+
+	vma->vm_flags |= VM_RESERVED;
+	return bmd;
+}
+EXPORT_SYMBOL(blk_rq_mmap_open);
+
+struct page *blk_rq_vma_nopage(struct bio_map_data *bmd,
+			       struct vm_area_struct *vma,
+			       unsigned long addr, int *type)
+{
+	struct page *p;
+
+	if (!bmd)
+		return NOPAGE_SIGBUS;
+
+	p = bio_map_data_get_page(bmd, addr - vma->vm_start);
+	if (p)
+		get_page(p);
+	else
+		p = NOPAGE_SIGBUS;
+	if (type)
+		*type = VM_FAULT_MINOR;
+	return p;
+}
+EXPORT_SYMBOL(blk_rq_vma_nopage);
+
+/**
+ * blk_rq_setup_mmap_buffer - setup request and bio page mappings
+ * @rq:		request
+ * @bmd:	bio_map_data returned from blk_rq_mmap
+ * @len:	len of transfer
+ *
+ * Note: there is not need to call a complete or transfer function.
+ * The bio's destructor function will handle the bio release.
+ */
+int blk_rq_setup_mmap_buffer(struct request *rq, struct bio_map_data *bmd,
+			     unsigned int len, gfp_t gfp_mask)
+{
+	struct request_queue *q = rq->q;
+	struct bio *bio;
+
+	if (!len || len > (q->max_hw_sectors << 9))
+		return -EINVAL;
+
+	bio = bioset_add_mmap_pages(q, bmd, len, rq_data_dir(rq) == READ,
+				    gfp_mask);
+	if (IS_ERR(bio))
+		return PTR_ERR(bio);
+
+	blk_rq_bio_prep(q, rq, bio);
+	blk_queue_bounce(q, &rq->bio);
+	rq->buffer = rq->data = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_setup_mmap_buffer);
+
 /**
  * blk_rq_complete_transfer - unmap a request with user data
  * @bio:	start of bio list
diff --git a/fs/bio.c b/fs/bio.c
index 2f115ab..ccd4e3e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -70,6 +70,7 @@ struct bio_set {
 	mempool_t *bvec_pools[BIOVEC_NR_POOLS];
 	mempool_t *page_pool;
 	int page_pool_order;
+	int page_pool_size;
 };
 
 /*
@@ -250,8 +251,15 @@ struct bio_map_data *bioset_alloc_pages(struct request_queue *q,
 
 	ret = 0;
 	while (len) {
+		/*
+		 * __GFP_COMP is from sg. It is needed for higher order
+		 * allocs when the pages are sent to something like the network
+		 * layer which does get/put page.
+		 *
+		 * It is also needed for mmap.
+		 */
 		page = mempool_alloc(bmd->bs->page_pool,
-				     q->bounce_gfp | gfp_mask);
+				     __GFP_COMP | q->bounce_gfp | gfp_mask);
 		if (!page) {
 			ret = -ENOMEM;
 			goto fail;
@@ -281,8 +289,10 @@ static void bio_bmd_destructor(struct bio *bio)
 	bio_free(bio, bs);
 }
 
-struct bio *bioset_add_pages(struct request_queue *q, struct bio_map_data *bmd,
-			     unsigned int len, int write_to_vm, gfp_t gfp_mask)
+static struct bio *bioset_add_pages(struct request_queue *q,
+				    struct bio_map_data *bmd,
+				    unsigned int len, int write_to_vm,
+				    gfp_t gfp_mask)
 {
 	int nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct page *page;
@@ -293,8 +303,6 @@ struct bio *bioset_add_pages(struct request_queue *q, struct bio_map_data *bmd,
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
-	bio->bi_private = bmd;
-	bio->bi_destructor = bio_bmd_destructor;
 
 	ret = 0;
 	while (len) {
@@ -332,6 +340,52 @@ free_bio:
 	return ERR_PTR(ret);
 }
 
+static void bio_mmap_endio(struct bio *bio, int err)
+{
+	bio_put(bio);
+}
+
+struct bio *bioset_add_mmap_pages(struct request_queue *q,
+				  struct bio_map_data *bmd, unsigned int len,
+				  int write_to_vm, gfp_t gfp_mask)
+{
+	struct bio *bio;
+
+	bio = bioset_add_pages(q, bmd, len, write_to_vm, gfp_mask);
+	if (IS_ERR(bio))
+		return bio;
+	/*
+	 * The mmap operation may want to reuse the bmd so we just free
+	 * the bio
+	 */
+	bio->bi_private = bmd->bs;
+	bio->bi_destructor = bio_blk_destructor;
+	bio->bi_end_io = bio_mmap_endio;
+
+	if (bio->bi_size == len)
+		return bio;
+	/*
+	 * Don't support partial mappings.
+	 */
+	bio_put(bio);
+	return ERR_PTR(-EINVAL);
+}
+
+struct page *bio_map_data_get_page(struct bio_map_data *bmd,
+				   unsigned long offset)
+{
+	unsigned long seg_size = (1 << bmd->bs->page_pool_order) << PAGE_SHIFT;
+	unsigned long seg_offset;
+	int iovec;
+
+	if (offset >= seg_size * bmd->nr_vecs)
+		return NULL;
+
+	iovec = offset / seg_size;
+	seg_offset = offset - (iovec * seg_size);
+	return bmd->iovecs[iovec].page + (seg_offset >> PAGE_SHIFT);
+}
+
 struct bio *bioset_setup_pages(struct request_queue *q, struct bio_set *bs,
 			       unsigned int len, int write_to_vm,
 			       gfp_t gfp_mask)
@@ -346,6 +400,10 @@ struct bio *bioset_setup_pages(struct request_queue *q, struct bio_set *bs,
 	bio = bioset_add_pages(q, bmd, len, write_to_vm, gfp_mask);
 	if (IS_ERR(bio))
 		bioset_free_pages(bmd);
+	else {
+		bio->bi_private = bmd;
+		bio->bi_destructor = bio_bmd_destructor;
+	}
 	return bio;
 }
 
@@ -1172,17 +1230,18 @@ void bioset_pagepool_free(struct bio_set *bs)
 }
 
 struct bio_set *bioset_pagepool_create(int bio_pool_size, int bvec_pool_size,
-				       int order)
+				       int page_pool_size, int order)
 {
 	struct bio_set *bs = bioset_create(bio_pool_size, bvec_pool_size);
 
 	if (!bs)
 		return NULL;
 
-	bs->page_pool = mempool_create_page_pool(bio_pool_size, order);
+	bs->page_pool = mempool_create_page_pool(page_pool_size, order);
 	if (!bs->page_pool)
 		goto free_bioset;
 
+	bs->page_pool_size = page_pool_size;
 	bs->page_pool_order = order;
 	return bs;
 
@@ -1191,6 +1250,11 @@ free_bioset:
 	return NULL;
 }
 
+unsigned bioset_pagepool_get_size(struct bio_set *bs)
+{
+	return bs->page_pool_size * (1 << bs->page_pool_order) << PAGE_SHIFT;
+}
+
 static void __init biovec_init_slabs(void)
 {
 	int i;
@@ -1215,7 +1279,7 @@ static int __init init_bio(void)
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
-	blk_bio_set = bioset_pagepool_create(BIO_POOL_SIZE, 2, 0);
+	blk_bio_set = bioset_pagepool_create(BIO_POOL_SIZE, 2, 1, 0);
 	if (!blk_bio_set)
 		panic("Failed to create blk_bio_set");
 
@@ -1249,4 +1313,5 @@ EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_pagepool_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bioset_pagepool_free);
+EXPORT_SYMBOL(bioset_pagepool_get_size);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6d0c6b7..bc7d244 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -62,6 +62,7 @@ struct bio_vec {
 	unsigned int	bv_offset;
 };
 
+struct bio_map_data;
 struct bio_set;
 struct bio;
 typedef void (bio_end_io_t) (struct bio *, int);
@@ -294,9 +295,10 @@ extern mempool_t *bio_split_pool;
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(int, int);
-extern struct bio_set *bioset_pagepool_create(int, int, int);
+extern struct bio_set *bioset_pagepool_create(int, int, int, int);
 extern void bioset_free(struct bio_set *);
 extern void bioset_pagepool_free(struct bio_set *);
+extern unsigned bioset_pagepool_get_size(struct bio_set *);
 
 extern struct bio *bio_alloc(gfp_t, int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
@@ -331,6 +333,14 @@ extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
 extern struct bio *bioset_setup_pages(struct request_queue *, struct bio_set *,
 				      unsigned int, int, gfp_t);
+extern void bioset_free_pages(struct bio_map_data *);
+extern struct bio_map_data *bioset_alloc_pages(struct request_queue *,
+					       struct bio_set *, unsigned int,
+					       gfp_t);
+extern struct bio *bioset_add_mmap_pages(struct request_queue *,
+					 struct bio_map_data *, unsigned int,
+					 int, gfp_t gfp_mask);
+extern struct page *bio_map_data_get_page(struct bio_map_data *, unsigned long);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 75f92cb..64bc2bc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -700,6 +700,15 @@ extern int blk_rq_map_user_iov(struct bio_set *, struct request *,
 extern int blk_rq_copy_user_iov(struct bio_set *, struct request *,
 				struct sg_iovec *, int, unsigned long, gfp_t);
 extern int blk_rq_uncopy_user_iov(struct bio *, struct sg_iovec *, int);
+extern struct bio_map_data *blk_rq_mmap_open(struct bio_set *,
+					     struct request_queue *,
+					     struct vm_area_struct *);
+extern void blk_rq_mmap_close(struct bio_map_data *);
+extern struct page *blk_rq_vma_nopage(struct bio_map_data *,
+				      struct vm_area_struct *,
+				      unsigned long, int *);
+extern int blk_rq_setup_mmap_buffer(struct request *, struct bio_map_data *,
+				    unsigned int, gfp_t);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.5.1.2
