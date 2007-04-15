From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/4] bidi support: bidirectional request
Date: Sun, 15 Apr 2007 20:33:28 +0300
Message-ID: <462261E8.5090005@panasas.com>
References: <46225E18.7070404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:60622 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753208AbXDOReN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Apr 2007 13:34:13 -0400
In-Reply-To: <46225E18.7070404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org

- Instantiate another request_io_part in struct request for bidi_read.
- Define & Implement new API for accessing bidi parts.
- API to Build bidi requests and map to sglists.
- Define new end_that_request_block() function to end a complete request.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Benny Halevy <bhalevy@panasas.com>
---
 block/elevator.c        |    7 +--
 block/ll_rw_blk.c       |  120 ++++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/scsi_lib.c |    2 +-
 include/linux/blkdev.h  |   56 +++++++++++++++++++++-
 4 files changed, 160 insertions(+), 25 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 237f15c..e39ef57 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -757,14 +757,9 @@ struct request *elv_next_request(request_queue_t *q)
             rq = NULL;
             break;
         } else if (ret == BLKPREP_KILL) {
-            int nr_bytes = rq_uni(rq)->hard_nr_sectors << 9;
-
-            if (!nr_bytes)
-                nr_bytes = rq_uni(rq)->data_len;
-
             blkdev_dequeue_request(rq);
             rq->cmd_flags |= REQ_QUIET;
-            end_that_request_chunk(rq, 0, nr_bytes);
+            end_that_request_block(rq, 0);
             end_that_request_last(rq, 0);
         } else {
             printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index c8ed8a9..21fdbc2 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -261,6 +261,7 @@ static void rq_init(request_queue_t *q, struct request *rq)
     rq->end_io_data = NULL;
     rq->completion_data = NULL;
     rq_init_io_part(&rq->uni);
+    rq_init_io_part(&rq->bidi_read);
 }

 /**
@@ -1312,14 +1313,16 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
 }

 /*
- * map a request to scatterlist, return number of sg entries setup. Caller
- * must make sure sg can hold rq->nr_phys_segments entries
+ * map a request_io_part to scatterlist, return number of sg entries setup.
+ * Caller must make sure sg can hold rq_io(rq, dir)->nr_phys_segments entries
  */
-int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
+int blk_rq_map_sg_bidi(request_queue_t *q, struct request *rq,
+    struct scatterlist *sg, enum dma_data_direction dir)
 {
     struct bio_vec *bvec, *bvprv;
     struct bio *bio;
     int nsegs, i, cluster;
+    struct request_io_part* req_io = rq_io(rq, dir);

     nsegs = 0;
     cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
@@ -1328,7 +1331,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
      * for each bio in rq
      */
     bvprv = NULL;
-    rq_for_each_bio(bio, rq) {
+    for (bio = req_io->bio; bio; bio = bio->bi_next) {
         /*
          * for each segment in bio
          */
@@ -1360,7 +1363,17 @@ new_segment:

     return nsegs;
 }
+EXPORT_SYMBOL(blk_rq_map_sg_bidi);

+/*
+ * map a request to scatterlist, return number of sg entries setup. Caller
+ * must make sure sg can hold rq->nr_phys_segments entries
+ */
+int blk_rq_map_sg(request_queue_t *q, struct request *rq,
+                  struct scatterlist *sg)
+{
+    return blk_rq_map_sg_bidi(q, rq, sg, rq->data_dir);
+}
 EXPORT_SYMBOL(blk_rq_map_sg);

 /*
@@ -1415,11 +1428,12 @@ static inline int ll_new_hw_segment(request_queue_t *q,
     return 1;
 }

-int ll_back_merge_fn(request_queue_t *q, struct request *req, struct bio *bio)
+int ll_back_merge_fn(request_queue_t *q, struct request *req, struct bio *bio,
+    enum dma_data_direction dir)
 {
     unsigned short max_sectors;
     int len;
-    struct request_io_part* req_io = rq_uni(req);
+    struct request_io_part* req_io = rq_io(req, dir);

     if (unlikely(blk_pc_request(req)))
         max_sectors = q->max_hw_sectors;
@@ -2404,7 +2418,7 @@ static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
     req_io = rq_uni(rq);
     if (!req_io->bio)
         blk_rq_bio_prep(q, rq, bio);
-    else if (!ll_back_merge_fn(q, rq, bio)) {
+    else if (!ll_back_merge_fn(q, rq, bio, rq->data_dir)) {
         ret = -EINVAL;
         goto unmap_bio;
     } else {
@@ -2574,15 +2588,18 @@ int blk_rq_unmap_user(struct bio *bio)
 EXPORT_SYMBOL(blk_rq_unmap_user);

 /**
- * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
+ * blk_rq_map_kern_bidi - maps kernel data to a request_io_part, for BIDI usage
  * @q:        request queue where request should be inserted
  * @rq:        request to fill
  * @kbuf:    the kernel buffer
  * @len:    length of user data
  * @gfp_mask:    memory allocation flags
+ * @dir:        if it is a BIDIRECTIONAL request than DMA_TO_DEVICE to prepare
+ *              the bidi_write side or DMA_FROM_DEVICE to prepare the bidi_read
+ *              side, else it should be same as req->data_dir
  */
-int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
-            unsigned int len, gfp_t gfp_mask)
+int blk_rq_map_kern_bidi(request_queue_t *q, struct request *rq, void *kbuf,
+    unsigned int len, gfp_t gfp_mask, enum dma_data_direction dir)
 {
     struct bio *bio;

@@ -2595,14 +2612,29 @@ int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
     if (IS_ERR(bio))
         return PTR_ERR(bio);

-    if (dma_write_dir(rq->data_dir))
+    if (dma_write_dir(dir))
         bio->bi_rw |= (1 << BIO_RW);

-    blk_rq_bio_prep(q, rq, bio);
+    blk_rq_bio_prep_bidi(q, rq, bio ,dir);
     rq->buffer = rq->data = NULL;
     return 0;
 }

+EXPORT_SYMBOL(blk_rq_map_kern_bidi);
+
+/**
+ * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
+ * @q:        request queue where request should be inserted
+ * @rq:        request to fill
+ * @kbuf:    the kernel buffer
+ * @len:    length of user data
+ * @gfp_mask:    memory allocation flags
+ */
+int blk_rq_map_kern(request_queue_t *q, struct request *rq, void *kbuf,
+            unsigned int len, gfp_t gfp_mask)
+{
+    return blk_rq_map_kern_bidi( q, rq, kbuf, len, gfp_mask, rq->data_dir);
+}
 EXPORT_SYMBOL(blk_rq_map_kern);

 /**
@@ -2988,7 +3020,7 @@ static int __make_request(request_queue_t *q, struct bio *bio)
         case ELEVATOR_BACK_MERGE:
             BUG_ON(!rq_mergeable(req));

-            if (!ll_back_merge_fn(q, req, bio))
+            if (!ll_back_merge_fn(q, req, bio, req->data_dir))
                 break;

             blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
@@ -3375,11 +3407,11 @@ static void blk_recalc_rq_sectors(struct request *rq, int nsect)
 }

 static int __end_that_request_first(struct request *req, int uptodate,
-                    int nr_bytes)
+                    int nr_bytes, enum dma_data_direction dir)
 {
     int total_bytes, bio_nbytes, error, next_idx = 0;
     struct bio *bio;
-    struct request_io_part* req_io = rq_uni(req);
+    struct request_io_part* req_io = rq_io(req, dir);

     blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);

@@ -3469,6 +3501,8 @@ static int __end_that_request_first(struct request *req, int uptodate,
     if (!req_io->bio)
         return 0;

+    WARN_ON(rq_bidi_dir(req));
+
     /*
      * if the request wasn't completed, update state
      */
@@ -3501,7 +3535,7 @@ static int __end_that_request_first(struct request *req, int uptodate,
  **/
 int end_that_request_first(struct request *req, int uptodate, int nr_sectors)
 {
-    return __end_that_request_first(req, uptodate, nr_sectors << 9);
+    return end_that_request_chunk(req, uptodate, nr_sectors << 9);
 }

 EXPORT_SYMBOL(end_that_request_first);
@@ -3523,11 +3557,55 @@ EXPORT_SYMBOL(end_that_request_first);
  **/
 int end_that_request_chunk(struct request *req, int uptodate, int nr_bytes)
 {
-    return __end_that_request_first(req, uptodate, nr_bytes);
+    WARN_ON_BIDI_FLAG(req);
+    WARN_ON(!rq_uni_dir(req));
+    return __end_that_request_first(req, uptodate, nr_bytes,
+        rq_uni_dir(req) ? rq_dma_dir(req) : DMA_TO_DEVICE);
 }

 EXPORT_SYMBOL(end_that_request_chunk);

+static void __end_req_io_block(struct request_io_part *req_io, int error)
+{
+    struct bio *next, *bio = req_io->bio;
+    req_io->bio = NULL;
+
+    for (; bio; bio = next) {
+        next = bio->bi_next;
+        bio_endio(bio, bio->bi_size, error);
+    }
+}
+
+/**
+ * end_that_request_block - end ALL I/O on a request in one "shloop",
+ * including the bidi part.
+ * @req:      the request being processed
+ * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ *
+ * Description:
+ *     Ends ALL I/O on @req, both read/write or bidi. frees all bio resources.
+ **/
+void end_that_request_block(struct request *req, int uptodate)
+{
+    if (blk_pc_request(req)) {
+        int error = 0;
+        if (end_io_error(uptodate))
+            error = !uptodate ? -EIO : uptodate;
+        blk_add_trace_rq(req->q, req, BLK_TA_COMPLETE);
+
+        __end_req_io_block(&req->uni, error);
+        if (rq_bidi_dir(req))
+            __end_req_io_block(&req->bidi_read, 0);
+    } else { /* needs elevator bookeeping */
+        int nr_bytes = req->uni.hard_nr_sectors << 9;
+        if (!nr_bytes)
+            nr_bytes = req->uni.data_len;
+        end_that_request_chunk(req, uptodate, nr_bytes);
+    }
+}
+
+EXPORT_SYMBOL(end_that_request_block);
+
 /*
  * splice the completion data to a local structure and hand off to
  * process_completion_queue() to complete the requests
@@ -3656,6 +3734,14 @@ void end_request(struct request *req, int uptodate)

 EXPORT_SYMBOL(end_request);

+void blk_rq_bio_prep_bidi(request_queue_t *q, struct request *rq,
+    struct bio *bio, enum dma_data_direction dir)
+{
+    init_req_io_part_from_bio(q, rq_io(rq, dir), bio);
+    rq->buffer = NULL;
+}
+EXPORT_SYMBOL(blk_rq_bio_prep_bidi);
+
 void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 {
     rq->data_dir = bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5863827..42aefd4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -268,7 +268,7 @@ static int scsi_merge_bio(struct request *rq, struct bio *bio)

     if (!req_io->bio)
         blk_rq_bio_prep(q, rq, bio);
-    else if (!ll_back_merge_fn(q, rq, bio))
+    else if (!ll_back_merge_fn(q, rq, bio, rq_dma_dir(rq)))
         return -EINVAL;
     else {
         req_io->biotail->bi_next = bio;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 645d24b..16a02ee 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -322,6 +322,7 @@ struct request {
     void *end_io_data;

     struct request_io_part uni;
+    struct request_io_part bidi_read;
 };

 /*
@@ -600,6 +601,34 @@ static inline struct request_io_part* rq_uni(struct request* req)
     return &req->uni;
 }

+static inline struct request_io_part* rq_out(struct request* req)
+{
+    WARN_ON_BIDI_FLAG(req);
+    return &req->uni;
+}
+
+static inline struct request_io_part* rq_in(struct request* req)
+{
+    WARN_ON_BIDI_FLAG(req);
+    if (likely(rq_dma_dir(req) != DMA_BIDIRECTIONAL))
+        return &req->uni;
+
+    if (likely(req->cmd_flags & REQ_BIDI))
+        return &req->bidi_read;
+
+    return &req->uni;
+}
+
+static inline struct request_io_part* rq_io(struct request* req,
+                                            enum dma_data_direction dir)
+{
+    if (dir == DMA_FROM_DEVICE)
+        return rq_in(req);
+
+    WARN_ON( (dir != DMA_TO_DEVICE) && (dir != DMA_NONE) );
+    return &req->uni;
+}
+
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
@@ -700,7 +729,8 @@ extern int sg_scsi_ioctl(struct file *, struct request_queue *,
 /*
  * Temporary export, until SCSI gets fixed up.
  */
-extern int ll_back_merge_fn(request_queue_t *, struct request *, struct bio *);
+extern int ll_back_merge_fn(request_queue_t *, struct request *, struct bio *,
+    enum dma_data_direction);

 /*
  * A queue has just exitted congestion.  Note this in the global counter of
@@ -771,6 +801,15 @@ extern void end_request(struct request *req, int uptodate);
 extern void blk_complete_request(struct request *);

 /*
+ * end_request_block will complete and free all bio resources held
+ * by the request in one call. User will still need to call
+ * end_that_request_last(..).
+ * It is the only one that can deal with BIDI.
+ * can be called for parial bidi allocation and cleanup.
+ */
+extern void end_that_request_block(struct request *req, int uptodate);
+
+/*
  * end_that_request_first/chunk() takes an uptodate argument. we account
  * any value <= as an io error. 0 means -EIO for compatability reasons,
  * any other < 0 value is the direct error type. An uptodate value of
@@ -849,6 +888,21 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern void blk_rq_bio_prep(request_queue_t *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);

+/* BIDI API
+ * build a request. for bidi requests must be called twice to map/prepare
+ * the data-in and data-out buffers, one at a time according to
+ * the given dma_data_direction.
+ */
+extern void blk_rq_bio_prep_bidi(request_queue_t *, struct request *,
+    struct bio *, enum dma_data_direction);
+extern int blk_rq_map_kern_bidi(request_queue_t *, struct request *,
+    void *, unsigned int, gfp_t, enum dma_data_direction);
+/* retrieve the mapped pages for bidi according to
+ * the given dma_data_direction
+ */
+extern int blk_rq_map_sg_bidi(request_queue_t *, struct request *,
+    struct scatterlist *, enum dma_data_direction);
+
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
 #define SAFE_MAX_SECTORS 255
-- 
1.5.0.4.402.g8035



