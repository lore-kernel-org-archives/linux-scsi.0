From: michaelc@cs.wisc.edu
Subject: [PATCH 01/10] use seperate bioset for REQ_TYPE_BLOCK_PC
Date: Sat, 20 Oct 2007 00:44:35 -0500
Message-ID: <1192859085521-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
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

If we are failing over a device or trying to do sg io to add a path to a
device where all paths are failed, we do not want to allocate bios from the
same bioset as the FS above it, because the device could have been internally
queueing IO while there were no paths and the fs bioset could be depleted.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 fs/bio.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index d59ddbf..0781e65 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -75,6 +75,10 @@ struct bio_set {
  * IO code that does not need private memory pools.
  */
 static struct bio_set *fs_bio_set;
+/*
+ * blk_bio_set is for block layer commands like REQ_TYPE_BLOCK_PC
+ */
+static struct bio_set *blk_bio_set;
 
 static inline struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx, struct bio_set *bs)
 {
@@ -128,6 +132,11 @@ static void bio_fs_destructor(struct bio *bio)
 	bio_free(bio, fs_bio_set);
 }
 
+static void bio_blk_destructor(struct bio *bio)
+{
+	bio_free(bio, blk_bio_set);
+}
+
 void bio_init(struct bio *bio)
 {
 	memset(bio, 0, sizeof(*bio));
@@ -532,11 +541,12 @@ struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
 	bmd->userptr = (void __user *) uaddr;
 
 	ret = -ENOMEM;
-	bio = bio_alloc(GFP_KERNEL, end - start);
+	bio = bio_alloc_bioset(GFP_KERNEL, end - start, blk_bio_set);
 	if (!bio)
 		goto out_bmd;
 
 	bio->bi_rw |= (!write_to_vm << BIO_RW);
+	bio->bi_destructor = bio_blk_destructor;
 
 	ret = 0;
 	while (len) {
@@ -620,9 +630,10 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_alloc(GFP_KERNEL, nr_pages);
+	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, blk_bio_set);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
+	bio->bi_destructor = bio_blk_destructor;
 
 	ret = -ENOMEM;
 	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
@@ -805,9 +816,10 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_alloc_bioset(gfp_mask, nr_pages, blk_bio_set);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
+	bio->bi_destructor = bio_blk_destructor;
 
 	offset = offset_in_page(kaddr);
 	for (i = 0; i < nr_pages; i++) {
@@ -1172,6 +1184,10 @@ static int __init init_bio(void)
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
+	blk_bio_set = bioset_create(BIO_POOL_SIZE, 2);
+	if (!blk_bio_set)
+		panic("Failed to create blk_bio_set");
+
 	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
 						     sizeof(struct bio_pair));
 	if (!bio_split_pool)
-- 
1.5.1.2
