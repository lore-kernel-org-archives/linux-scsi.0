From: michaelc@cs.wisc.edu
Subject: [PATCH 08/10] split bioset_add_pages for sg mmap use
Date: Sat, 20 Oct 2007 00:44:42 -0500
Message-ID: <11928590892682-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
	<11928590862112-git-send-email-michaelc@cs.wisc.edu>
	<11928590861021-git-send-email-michaelc@cs.wisc.edu>
	<11928590871413-git-send-email-michaelc@cs.wisc.edu>
	<11928590871678-git-send-email-michaelc@cs.wisc.edu>
	<11928590884170-git-send-email-michaelc@cs.wisc.edu>
	<11928590894155-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590894155-git-send-email-michaelc@cs.wisc.edu>
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

open(/dev/sg)
mmap()
write(/dev/sg)
read(/dev/sg)

Then can do
write(/dev/sg)
read(/dev/sg)

multiple times.

close(/dev/sg)

The pages for the mmap operation are reused for each sg request, so
they cannot be freed when the bio is like with the copy or map operations.
This patch breaks up the bio page allocation from the page addition, so that
a mmap helper can alloc pages then reuse them for another requests.

The next patch contains the mmap helper and then the last patch will
have sg use all the helpers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c   |    6 +-
 fs/bio.c            |  120 ++++++++++++++++++++++++++++++++++----------------
 include/linux/bio.h |    5 +-
 3 files changed, 86 insertions(+), 45 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 2e00bd2..7298289 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2366,7 +2366,7 @@ static void __blk_rq_destroy_buffer(struct bio *bio)
 	if (bio_flagged(bio, BIO_USER_MAPPED))
 		bio_unmap_user(bio);
 	else
-		bioset_free_pages(bio);
+		bio_put(bio);
 }
 
 void blk_rq_destroy_buffer(struct bio *bio)
@@ -2414,8 +2414,8 @@ static int __blk_rq_setup_buffer(struct bio_set *bs, struct request *rq,
 		bio = bio_map_user(q, bs, (unsigned long)ubuf, map_len,
 				   reading, gfp_mask);
 	} else
-		bio = bioset_add_pages(q, bs, len, reading,
-				       gfp_mask);
+		bio = bioset_setup_pages(q, bs, len, reading,
+					 gfp_mask);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
diff --git a/fs/bio.c b/fs/bio.c
index 05ffe68..2f115ab 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -220,21 +220,8 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, gfp_t gfp_mask)
 	return NULL;
 }
 
-static void bio_bmd_destructor(struct bio *bio)
+void bioset_free_pages(struct bio_map_data *bmd)
 {
-	struct bio_map_data *bmd = bio->bi_private;
-	struct bio_set *bs;
-
-	if (!bmd)
-		return;
-	bs = bmd->bs;
-	bio_free_map_data(bmd);
-	bio_free(bio, bs);
-}
-
-void bioset_free_pages(struct bio *bio)
-{
-	struct bio_map_data *bmd = bio->bi_private;
 	struct bio_set *bs = bmd->bs;
 	int i;
 
@@ -242,71 +229,126 @@ void bioset_free_pages(struct bio *bio)
 		if (bmd->iovecs[i].page)
 			mempool_free(bmd->iovecs[i].page, bs->page_pool);
 	}
-	bio_put(bio);
+	bio_free_map_data(bmd);
 }
 
-struct bio *bioset_add_pages(struct request_queue *q, struct bio_set *bs,
-			     unsigned int len, int write_to_vm, gfp_t gfp_mask)
+struct bio_map_data *bioset_alloc_pages(struct request_queue *q,
+					struct bio_set *bs, unsigned int len,
+					gfp_t gfp_mask)
 {
 	int nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct bio_map_data *bmd;
 	struct page *page;
-	struct bio *bio;
 	int i = 0, ret;
 
 	bmd = bio_alloc_map_data(nr_pages, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
+	bmd->bs = bs;
+	if (!bmd->bs)
+		bmd->bs = blk_bio_set;
 
-	ret = -ENOMEM;
-	if (!bs)
-		bs = blk_bio_set;
-	bio = bio_alloc_bioset(gfp_mask, nr_pages, bs);
+	ret = 0;
+	while (len) {
+		page = mempool_alloc(bmd->bs->page_pool,
+				     q->bounce_gfp | gfp_mask);
+		if (!page) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+		bmd->nr_vecs++;
+		bmd->iovecs[i].page = page;
+
+		len -= min_t(unsigned int,
+			    (1 << bmd->bs->page_pool_order) << PAGE_SHIFT, len);
+		i++;
+	}
+	return bmd;
+fail:
+	bioset_free_pages(bmd);
+	return ERR_PTR(ret);
+}
+
+static void bio_bmd_destructor(struct bio *bio)
+{
+	struct bio_map_data *bmd = bio->bi_private;
+	struct bio_set *bs;
+
+	if (!bmd)
+		return;
+	bs = bmd->bs;
+	bioset_free_pages(bmd);
+	bio_free(bio, bs);
+}
+
+struct bio *bioset_add_pages(struct request_queue *q, struct bio_map_data *bmd,
+			     unsigned int len, int write_to_vm, gfp_t gfp_mask)
+{
+	int nr_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	struct page *page;
+	struct bio *bio;
+	int i = 0, ret;
+
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, bmd->bs);
 	if (!bio)
-		goto out_bmd;
+		return ERR_PTR(-ENOMEM);
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
-	bio->bi_destructor = bio_bmd_destructor;
 	bio->bi_private = bmd;
-	bmd->bs = bs;
+	bio->bi_destructor = bio_bmd_destructor;
 
 	ret = 0;
 	while (len) {
 		unsigned add_len;
 
-		page = mempool_alloc(bs->page_pool, q->bounce_gfp | gfp_mask);
+		page = bmd->iovecs[i].page;
 		if (!page) {
-			ret = -ENOMEM;
-			bioset_free_pages(bio);
-			goto fail;
+			ret = -EINVAL;
+			printk(KERN_ERR "Invalid bio map data. Not enough "
+			       "pages allocated to handle req of len %d\n",
+			       len);
+			goto free_bio;
 		}
-		bmd->nr_vecs++;
-		bmd->iovecs[i].page = page;
 
 		add_len = min_t(unsigned int,
-			       (1 << bs->page_pool_order) << PAGE_SHIFT, len);
+			       (1 << bmd->bs->page_pool_order) << PAGE_SHIFT,
+				len);
 		while (add_len) {
-			unsigned int added, bytes = PAGE_SIZE;
+			unsigned int bytes = PAGE_SIZE;
 
 			if (bytes > add_len)
 				bytes = add_len;
 
-			added = bio_add_pc_page(q, bio, page++, bytes, 0);
-			if (added < bytes)
+			if (bio_add_pc_page(q, bio, page++, bytes, 0) < bytes)
 				break;
 			add_len -= bytes;
 			len -= bytes;
 		}
 		i++;
 	}
-
 	return bio;
 
-out_bmd:
-	bio_free_map_data(bmd);
-fail:
+free_bio:
+	bio_free(bio, bmd->bs);
 	return ERR_PTR(ret);
 }
 
+struct bio *bioset_setup_pages(struct request_queue *q, struct bio_set *bs,
+			       unsigned int len, int write_to_vm,
+			       gfp_t gfp_mask)
+{
+	struct bio_map_data *bmd;
+	struct bio *bio;
+
+	bmd = bioset_alloc_pages(q, bs, len, gfp_mask);
+	if (IS_ERR(bmd))
+		return ERR_PTR(-ENOMEM);
+
+	bio = bioset_add_pages(q, bmd, len, write_to_vm, gfp_mask);
+	if (IS_ERR(bio))
+		bioset_free_pages(bmd);
+	return bio;
+}
+
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b860448..6d0c6b7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -329,9 +329,8 @@ extern struct bio *bio_map_kern(struct request_queue *, struct bio_set *,
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 extern void bio_release_pages(struct bio *bio);
-extern void bioset_free_pages(struct bio *);
-extern struct bio *bioset_add_pages(struct request_queue *,
-				    struct bio_set *, unsigned int, int, gfp_t);
+extern struct bio *bioset_setup_pages(struct request_queue *, struct bio_set *,
+				      unsigned int, int, gfp_t);
 void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
-- 
1.5.1.2
