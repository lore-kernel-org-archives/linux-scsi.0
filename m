From: michaelc@cs.wisc.edu
Subject: [PATCH 03/10] Extend bio_sets to pool pages for bios in
	sets.
Date: Sat, 20 Oct 2007 00:44:37 -0500
Message-ID: <11928590861021-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590862112-git-send-email-michaelc@cs.wisc.edu>
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

If we have REQ_BLOCK_PC commands that transfer data like,
an inquiry, read of sector 0, or mode page, then we need to
make sure that we can allocate memory for the data.

sg and st have implemented their own reserve buffers. This patch
adds a mempool of pages onto the bio_set which serves the same
purpose. In later patches the block layer sg code and sg/st will
be converted to use this.

This patch just adds the infrastructure. The next patches will
convert the code to the new functions.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 fs/bio.c            |  144 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |    2 +
 2 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index f85139a..1e8db03 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -68,6 +68,8 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
 struct bio_set {
 	mempool_t *bio_pool;
 	mempool_t *bvec_pools[BIOVEC_NR_POOLS];
+	mempool_t *page_pool;
+	int page_pool_order;
 };
 
 /*
@@ -184,6 +186,118 @@ out:
 	return bio;
 }
 
+#if 0
+This #if is just to break up the patchset, make it easier to read
+and git bisectable.
+
+This patch extends biosets to have page pools. The next patch will replace
+bio_copy_user and friends with the the bioset version added below.
+
+struct bio_map_vec {
+	struct page *page;
+	unsigned int len;
+	void __user *userptr;
+};
+
+struct bio_map_data {
+	struct bio_map_vec *iovecs;
+	int nr_vecs;
+};
+
+static void bio_free_map_data(struct bio_map_data *bmd)
+{
+	kfree(bmd->iovecs);
+	kfree(bmd);
+}
+
+static struct bio_map_data *bio_alloc_map_data(int nr_segs)
+{
+	struct bio_map_data *bmd = kzalloc(sizeof(*bmd), GFP_KERNEL);
+
+	if (!bmd)
+		return NULL;
+
+	bmd->iovecs = kmalloc(sizeof(struct bio_map_vec) * nr_segs, GFP_KERNEL);
+	if (bmd->iovecs)
+		return bmd;
+
+	kfree(bmd);
+	return NULL;
+}
+
+
+void bioset_free_pages(struct bio_set *bs, struct bio *bio)
+{
+	struct bio_map_data *bmd = bio->bi_private;
+	int i;
+
+	for (i = 0; i < bmd->nr_vecs; i++)
+		mempool_free(bmd->iovecs[i].page, bs->page_pool);
+	bio_free_map_data(bmd);
+	bio_put(bio);
+}
+
+struct bio *bioset_add_pages(struct request_queue *q, struct bio_set *bs,
+			     unsigned int len, int write_to_vm, gfp_t gfp_mask)
+{
+	int nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	struct bio_map_data *bmd;
+	struct page *page;
+	struct bio *bio;
+	int i = 0, ret;
+
+	bmd = bio_alloc_map_data(nr_pages);
+	if (!bmd)
+		return ERR_PTR(-ENOMEM);
+
+	ret = -ENOMEM;
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
+	if (!bio)
+		goto out_bmd;
+	bio->bi_rw |= (!write_to_vm << BIO_RW);
+
+	ret = 0;
+	while (len) {
+		unsigned add_len;
+
+		page = mempool_alloc(bs->page_pool, q->bounce_gfp | gfp_mask);
+		if (!page)
+			goto cleanup;
+
+		bmd->nr_vecs++;
+		bmd->iovecs[i].page = page;
+		bmd->iovecs[i].len = 0;
+
+		add_len = min_t(unsigned int,
+			       (1 << bs->page_pool_order) << PAGE_SHIFT, len);
+		while (add_len) {
+			unsigned int added, bytes = PAGE_SIZE;
+
+			if (bytes > add_len)
+				bytes = add_len;
+
+			added = bio_add_pc_page(q, bio, page++, bytes, 0);
+			bmd->iovecs[i].len += added;
+			if (added < bytes)
+				break;
+			add_len -= bytes;
+			len -= bytes;
+		}
+		i++;
+	}
+
+	bio->bi_private = bmd;
+	return bio;
+
+cleanup:
+	bioset_free_pages(bs, bio);
+	bio_free(bio, bs);
+out_bmd:
+	bio_free_map_data(bmd);
+	return ERR_PTR(ret);
+}
+#endif
+
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
@@ -1155,6 +1269,34 @@ bad:
 	return NULL;
 }
 
+void bioset_pagepool_free(struct bio_set *bs)
+{
+	bioset_free(bs);
+
+	if (bs->page_pool)
+		mempool_destroy(bs->page_pool);
+}
+
+struct bio_set *bioset_pagepool_create(int bio_pool_size, int bvec_pool_size,
+				       int order)
+{
+	struct bio_set *bs = bioset_create(bio_pool_size, bvec_pool_size);
+
+	if (!bs)
+		return NULL;
+
+	bs->page_pool = mempool_create_page_pool(bio_pool_size, order);
+	if (!bs->page_pool)
+		goto free_bioset;
+
+	bs->page_pool_order = order;
+	return bs;
+
+free_bioset:
+	bioset_free(bs);
+	return NULL;
+}
+
 static void __init biovec_init_slabs(void)
 {
 	int i;
@@ -1212,5 +1354,7 @@ EXPORT_SYMBOL(bio_split_pool);
 EXPORT_SYMBOL(bio_copy_user);
 EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
+EXPORT_SYMBOL(bioset_pagepool_create);
 EXPORT_SYMBOL(bioset_free);
+EXPORT_SYMBOL(bioset_pagepool_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b76eb77..2d28c3b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -294,7 +294,9 @@ extern mempool_t *bio_split_pool;
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(int, int);
+extern struct bio_set *bioset_pagepool_create(int, int, int);
 extern void bioset_free(struct bio_set *);
+extern void bioset_pagepool_free(struct bio_set *);
 
 extern struct bio *bio_alloc(gfp_t, int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
-- 
1.5.1.2
