From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC] block integrity: Fix write after checksum calculation problem
Date: Mon, 21 Feb 2011 18:00:22 -0800
Message-ID: <20110222020022.GH32261@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
discussion about how to deal with the situation where one program tells the
kernel to write a block to disk, the kernel computes the checksum of that data,
and then a second program begins writing to that same block before the disk HBA
can DMA the memory block, thereby causing the disk to complain about being sent
invalid checksums.

By my recollection, several solutions were proposed, such as retrying the I/O
with a new checksum; using the VM to track and stop page writes during I/O;
creating shadow pages so that subsequent memory writes go to a different page;
punting the integrity failure to the app to let it deal with it; and only
allowing DIF mode when O_DIRECT is enabled.

Unfortunately, I didn't get a sense that any sort of consensus had been reached
(much less anything patched into the kernel) and since I was able to write a
trivial program to trigger the write problem, I'm pretty sure that this has not
been fixed upstream.  (FYI, using O_DIRECT still seems fine.)

Below is a simple if naive solution: (ab)use the bounce buffering code to copy
the memory page just prior to calculating the checksum, and send the copy and
the checksum to the disk controller.  With this patch applied, the invalid
guard tag messages go away.  An optimization would be to perform the copy only
when memory contents change, but I wanted to ask peoples' opinions before
continuing.  I don't imagine bounce buffering is particularly speedy, though I
haven't noticed any corruption errors or weirdness yet.

Anyway, I'm mostly wondering: what do people think of this as a starting point
to fixing the DIF checksum problem?

--
block integrity: Fix write after integrity checksum calculation problem

The kernel does not prohibit writes to a dirty page during a write IO.  This
leads to the race where a memory write occurs after the integrity data has been
calculated but before the hardware initiates the DMA operation; when this
happens, the data does not match the checksum and the disk fails the write due
to an invalid checksum.

An awkward fix for now is to (ab)use the bounce buffering mechanism to snapshot
a page's contents just prior to calculating the checksum, and sending the copy
and its checksum to the hardware.  This is probably terrible for performance.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 block/Kconfig          |    1 
 block/blk-core.c       |    2 -
 block/blk-integrity.c  |    2 +
 fs/bio-integrity.c     |   12 +++-
 include/linux/bio.h    |    4 +
 include/linux/blkdev.h |   12 ++++
 mm/bounce.c            |  129 ++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 154 insertions(+), 8 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 60be1e0..ed89f19 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -66,6 +66,7 @@ config BLK_DEV_BSG
 	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
+	depends on BOUNCE=y
 	bool "Block layer data integrity support"
 	---help---
 	Some storage devices allow extra information to be
diff --git a/block/blk-core.c b/block/blk-core.c
index 3cc3bed..81a4e50 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1503,7 +1503,7 @@ static inline void __generic_make_request(struct bio *bio)
 		 */
 		blk_partition_remap(bio);
 
-		if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
+		if (bio_integrity_enabled(bio) && bio_integrity_prep(&bio))
 			goto end_io;
 
 		if (old_sector != -1)
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 54bcba6..24843f8 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -376,6 +376,8 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 
 	BUG_ON(disk == NULL);
 
+	init_integrity_pool();
+
 	if (disk->integrity == NULL) {
 		bi = kmem_cache_alloc(integrity_cachep,
 				      GFP_KERNEL | __GFP_ZERO);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index df4fdfd..9eee904 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -393,8 +393,9 @@ static inline unsigned short blk_integrity_tuple_size(struct blk_integrity *bi)
  * block device's integrity function.  In the READ case, the buffer
  * will be prepared for DMA and a suitable end_io handler set up.
  */
-int bio_integrity_prep(struct bio *bio)
+int bio_integrity_prep(struct bio **pbio)
 {
+	struct bio *bio;
 	struct bio_integrity_payload *bip;
 	struct blk_integrity *bi;
 	struct request_queue *q;
@@ -404,10 +405,13 @@ int bio_integrity_prep(struct bio *bio)
 	unsigned int bytes, offset, i;
 	unsigned int sectors;
 
-	bi = bdev_get_integrity(bio->bi_bdev);
-	q = bdev_get_queue(bio->bi_bdev);
+	bi = bdev_get_integrity((*pbio)->bi_bdev);
+	q = bdev_get_queue((*pbio)->bi_bdev);
 	BUG_ON(bi == NULL);
-	BUG_ON(bio_integrity(bio));
+	BUG_ON(bio_integrity(*pbio));
+
+	blk_queue_integrity_bounce(q, pbio);
+	bio = *pbio;
 
 	sectors = bio_integrity_hw_sectors(bi, bio_sectors(bio));
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 36d10f0..1834934 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -505,7 +505,7 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
-#define bio_integrity(bio) (bio->bi_integrity != NULL)
+#define bio_integrity(bio) ((bio)->bi_integrity != NULL)
 
 extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
@@ -514,7 +514,7 @@ extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, uns
 extern int bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_prep(struct bio *);
+extern int bio_integrity_prep(struct bio **);
 extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8a082a5..1c9fc40 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -599,6 +599,18 @@ extern unsigned long blk_max_low_pfn, blk_max_pfn;
 #define BLK_DEFAULT_SG_TIMEOUT	(60 * HZ)
 #define BLK_MIN_SG_TIMEOUT	(7 * HZ)
 
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+extern int init_integrity_pool(void);
+extern void blk_queue_integrity_bounce(struct request_queue *q,
+				       struct bio **bio);
+#else
+#define init_integrity_pool()	do { } while (0);
+static inline void blk_queue_integrity_bounce(struct request_queue *q,
+					      struct bio **bio)
+{
+}
+#endif
+
 #ifdef CONFIG_BOUNCE
 extern int init_emergency_isa_pool(void);
 extern void blk_queue_bounce(struct request_queue *q, struct bio **bio);
diff --git a/mm/bounce.c b/mm/bounce.c
index 1481de6..c0ce533 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -21,7 +21,19 @@
 #define POOL_SIZE	64
 #define ISA_POOL_SIZE	16
 
-static mempool_t *page_pool, *isa_page_pool;
+static mempool_t *integrity_pool, *page_pool, *isa_page_pool;
+
+int init_integrity_pool(void)
+{
+	if (integrity_pool)
+		return 0;
+
+	integrity_pool = mempool_create_page_pool(POOL_SIZE, 0);
+	BUG_ON(!integrity_pool);
+	printk(KERN_INFO "integrity bounce pool size: %d pages\n", POOL_SIZE);
+
+	return 0;
+}
 
 #ifdef CONFIG_HIGHMEM
 static __init int init_emergency_pool(void)
@@ -151,6 +163,11 @@ static void bounce_end_io_write(struct bio *bio, int err)
 	bounce_end_io(bio, page_pool, err);
 }
 
+static void bounce_end_integrity_io_write(struct bio *bio, int err)
+{
+	bounce_end_io(bio, integrity_pool, err);
+}
+
 static void bounce_end_io_write_isa(struct bio *bio, int err)
 {
 
@@ -298,3 +315,113 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 }
 
 EXPORT_SYMBOL(blk_queue_bounce);
+
+/*
+ * Fix the problem of pages getting dirtied after the integrity checksum
+ * calculation by copying all writes to a shadow buffer prior to computing
+ * checksums.
+ */
+static void __blk_queue_integrity_bounce(struct request_queue *q,
+					 struct bio **bio_orig,
+					 mempool_t *pool)
+{
+	struct page *page;
+	struct bio *bio = NULL;
+	int i;
+	struct bio_vec *to, *from;
+
+	bio_for_each_segment(from, *bio_orig, i) {
+		char *vto, *vfrom;
+		page = from->bv_page;
+
+		/*
+		 * irk, bounce it
+		 */
+		if (!bio) {
+			unsigned int cnt = (*bio_orig)->bi_vcnt;
+
+			bio = bio_alloc(GFP_NOIO, cnt);
+			memset(bio->bi_io_vec, 0, cnt * sizeof(struct bio_vec));
+		}
+
+
+		to = bio->bi_io_vec + i;
+
+		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
+		to->bv_len = from->bv_len;
+		to->bv_offset = from->bv_offset;
+		inc_zone_page_state(to->bv_page, NR_BOUNCE);
+
+		flush_dcache_page(from->bv_page);
+		vto = page_address(to->bv_page) + to->bv_offset;
+		vfrom = kmap(from->bv_page) + from->bv_offset;
+		memcpy(vto, vfrom, to->bv_len);
+		kunmap(from->bv_page);
+	}
+
+	/*
+	 * no pages bounced
+	 */
+	if (!bio)
+		return;
+
+	trace_block_bio_bounce(q, *bio_orig);
+
+	/*
+	 * at least one page was bounced, fill in possible non-highmem
+	 * pages
+	 */
+	__bio_for_each_segment(from, *bio_orig, i, 0) {
+		to = bio_iovec_idx(bio, i);
+		if (!to->bv_page) {
+			to->bv_page = from->bv_page;
+			to->bv_len = from->bv_len;
+			to->bv_offset = from->bv_offset;
+		}
+	}
+
+	bio->bi_bdev = (*bio_orig)->bi_bdev;
+	bio->bi_flags |= (1 << BIO_BOUNCED);
+	bio->bi_sector = (*bio_orig)->bi_sector;
+	bio->bi_rw = (*bio_orig)->bi_rw;
+
+	bio->bi_vcnt = (*bio_orig)->bi_vcnt;
+	bio->bi_idx = (*bio_orig)->bi_idx;
+	bio->bi_size = (*bio_orig)->bi_size;
+
+	if (pool == integrity_pool)
+		bio->bi_end_io = bounce_end_integrity_io_write;
+	else
+		bio->bi_end_io = bounce_end_io_write_isa;
+
+	bio->bi_private = *bio_orig;
+	*bio_orig = bio;
+}
+
+void blk_queue_integrity_bounce(struct request_queue *q, struct bio **bio_orig)
+{
+	mempool_t *pool;
+
+	/* only do this for writes */
+	if (bio_data_dir(*bio_orig) != WRITE)
+		return;
+	/*
+	 * Data-less bio, nothing to bounce
+	 */
+	if (!bio_has_data(*bio_orig))
+		return;
+
+	if (!(q->bounce_gfp & GFP_DMA)) {
+		BUG_ON(!integrity_pool);
+		pool = integrity_pool;
+	} else {
+		BUG_ON(!isa_page_pool);
+		pool = isa_page_pool;
+	}
+
+	/*
+	 * slow path
+	 */
+	__blk_queue_integrity_bounce(q, bio_orig, pool);
+}
+EXPORT_SYMBOL(blk_queue_integrity_bounce);
