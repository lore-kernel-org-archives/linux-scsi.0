From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] block: improve handling of the magic discard payload
Date: Fri,  2 Dec 2016 13:19:02 +0100
Message-ID: <1480681142-19963-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, keith.busch@intel.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Instead of allocating a single unused biovec for discard requests, send
them down without any payload.  Instead we allow the driver to add a
"special" payload using a biovec embedded into struct request (unioned
over other fields never used while in the driver), and overloading
the number of segments for this case.

This has a couple of advantages:

 - we don't have to allocate the bio_vec
 - the amount of special casing for discard requests in the block
   layer is significantly reduced
 - using this same scheme for other request types is trivial,
   which will be important for implementing the new WRITE_ZEROES
   op on devices where it actually requires a payload (e.g. SCSI)
 - we can get rid of playing games with the request length, as
   we'll never touch it and completions will work just fine
 - it will allow us to support ranged discard operations in the
   future by merging non-contiguous discard bios into a single
   request
 - last but not least it removes a lot of code

This patch is the common base for my WIP series for ranges discards and to
remove discard_zeroes_data in favor of always using REQ_OP_WRITE_ZEROES,
so it would be good to get it in quickly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                | 10 +--------
 block/blk-core.c           | 34 ++---------------------------
 block/blk-lib.c            |  2 +-
 block/blk-merge.c          | 53 +++++++++++++++-------------------------------
 drivers/nvme/host/core.c   | 17 ++++-----------
 drivers/nvme/host/nvme.h   |  6 ++++--
 drivers/nvme/host/pci.c    | 27 +++++++++++------------
 drivers/nvme/host/rdma.c   | 13 +++++-------
 drivers/nvme/target/loop.c |  4 ++--
 drivers/scsi/scsi_lib.c    |  6 +++---
 drivers/scsi/sd.c          | 24 ++++++++-------------
 include/linux/bio.h        |  3 ++-
 include/linux/blkdev.h     | 15 ++++++++++---
 13 files changed, 76 insertions(+), 138 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 83db1f3..2b37502 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1840,15 +1840,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	BUG_ON(sectors <= 0);
 	BUG_ON(sectors >= bio_sectors(bio));
 
-	/*
-	 * Discards need a mutable bio_vec to accommodate the payload
-	 * required by the DSM TRIM and UNMAP commands.
-	 */
-	if (bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_SECURE_ERASE)
-		split = bio_clone_bioset(bio, gfp, bs);
-	else
-		split = bio_clone_fast(bio, gfp, bs);
-
+	split = bio_clone_fast(bio, gfp, bs);
 	if (!split)
 		return NULL;
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 3f2eb8d..bb9934a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1475,38 +1475,6 @@ void blk_put_request(struct request *req)
 }
 EXPORT_SYMBOL(blk_put_request);
 
-/**
- * blk_add_request_payload - add a payload to a request
- * @rq: request to update
- * @page: page backing the payload
- * @offset: offset in page
- * @len: length of the payload.
- *
- * This allows to later add a payload to an already submitted request by
- * a block driver.  The driver needs to take care of freeing the payload
- * itself.
- *
- * Note that this is a quite horrible hack and nothing but handling of
- * discard requests should ever use it.
- */
-void blk_add_request_payload(struct request *rq, struct page *page,
-		int offset, unsigned int len)
-{
-	struct bio *bio = rq->bio;
-
-	bio->bi_io_vec->bv_page = page;
-	bio->bi_io_vec->bv_offset = offset;
-	bio->bi_io_vec->bv_len = len;
-
-	bio->bi_iter.bi_size = len;
-	bio->bi_vcnt = 1;
-	bio->bi_phys_segments = 1;
-
-	rq->__data_len = rq->resid_len = len;
-	rq->nr_phys_segments = 1;
-}
-EXPORT_SYMBOL_GPL(blk_add_request_payload);
-
 bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 			    struct bio *bio)
 {
@@ -2641,6 +2609,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		return false;
 	}
 
+	WARN_ON_ONCE(req->rq_flags & RQF_SPECIAL_PAYLOAD);
+
 	req->__data_len -= total_bytes;
 
 	/* update sector only for requests with clear definition of sector */
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 510a6fb..ed89c8f 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -80,7 +80,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			req_sects = end_sect - sector;
 		}
 
-		bio = next_bio(bio, 1, gfp_mask);
+		bio = next_bio(bio, 0, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev = bdev;
 		bio_set_op_attrs(bio, op, 0);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index cf2848c..5f719d3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -241,18 +241,13 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	if (!bio)
 		return 0;
 
-	/*
-	 * This should probably be returning 0, but blk_add_request_payload()
-	 * (Christoph!!!!)
-	 */
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_SAME:
 	case REQ_OP_WRITE_ZEROES:
+		return 0;
+	case REQ_OP_WRITE_SAME:
 		return 1;
-	default:
-		break;
 	}
 
 	fbio = bio;
@@ -410,39 +405,21 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
 	*bvprv = *bvec;
 }
 
+static inline int __blk_bvec_map_sg(struct request_queue *q, struct bio_vec bv,
+		struct scatterlist *sglist, struct scatterlist **sg)
+{
+	*sg = sglist;
+	sg_set_page(*sg, bv.bv_page, bv.bv_len, bv.bv_offset);
+	return 1;
+}
+
 static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 			     struct scatterlist *sglist,
 			     struct scatterlist **sg)
 {
 	struct bio_vec bvec, bvprv = { NULL };
 	struct bvec_iter iter;
-	int nsegs, cluster;
-
-	nsegs = 0;
-	cluster = blk_queue_cluster(q);
-
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		/*
-		 * This is a hack - drivers should be neither modifying the
-		 * biovec, nor relying on bi_vcnt - but because of
-		 * blk_add_request_payload(), a discard bio may or may not have
-		 * a payload we need to set up here (thank you Christoph) and
-		 * bi_vcnt is really the only way of telling if we need to.
-		 */
-		if (!bio->bi_vcnt)
-			return 0;
-		/* Fall through */
-	case REQ_OP_WRITE_SAME:
-		*sg = sglist;
-		bvec = bio_iovec(bio);
-		sg_set_page(*sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
-		return 1;
-	default:
-		break;
-	}
+	int cluster = blk_queue_cluster(q), nsegs = 0;
 
 	for_each_bio(bio)
 		bio_for_each_segment(bvec, bio, iter)
@@ -462,7 +439,11 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	struct scatterlist *sg = NULL;
 	int nsegs = 0;
 
-	if (rq->bio)
+	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
+		nsegs = __blk_bvec_map_sg(q, rq->special_vec, sglist, &sg);
+	else if (rq->bio && bio_op(rq->bio) == REQ_OP_WRITE_SAME)
+		nsegs = __blk_bvec_map_sg(q, bio_iovec(rq->bio), sglist, &sg);
+	else if (rq->bio)
 		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg);
 
 	if (unlikely(rq->rq_flags & RQF_COPY_USER) &&
@@ -495,7 +476,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	 * Something must have been wrong if the figured number of
 	 * segment is bigger than number of req's physical segments
 	 */
-	WARN_ON(nsegs > rq->nr_phys_segments);
+	WARN_ON(nsegs > blk_rq_nr_phys_segments(rq));
 
 	return nsegs;
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 525d653..aa75b71 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -239,8 +239,6 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmnd)
 {
 	struct nvme_dsm_range *range;
-	struct page *page;
-	int offset;
 	unsigned int nr_bytes = blk_rq_bytes(req);
 
 	range = kmalloc(sizeof(*range), GFP_ATOMIC);
@@ -257,17 +255,10 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	cmnd->dsm.nr = 0;
 	cmnd->dsm.attributes = cpu_to_le32(NVME_DSMGMT_AD);
 
-	req->completion_data = range;
-	page = virt_to_page(range);
-	offset = offset_in_page(range);
-	blk_add_request_payload(req, page, offset, sizeof(*range));
-
-	/*
-	 * we set __data_len back to the size of the area to be discarded
-	 * on disk. This allows us to report completion on the full amount
-	 * of blocks described by the request.
-	 */
-	req->__data_len = nr_bytes;
+	req->special_vec.bv_page = virt_to_page(range);
+	req->special_vec.bv_offset = offset_in_page(range);
+	req->special_vec.bv_len = sizeof(*range);
+	req->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	return BLK_MQ_RQ_QUEUE_OK;
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a3d6ffd..bd53214 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -236,8 +236,10 @@ static inline unsigned nvme_map_len(struct request *rq)
 
 static inline void nvme_cleanup_cmd(struct request *req)
 {
-	if (req_op(req) == REQ_OP_DISCARD)
-		kfree(req->completion_data);
+	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		kfree(page_address(req->special_vec.bv_page) +
+		      req->special_vec.bv_offset);
+	}
 }
 
 static inline int nvme_error_status(u16 status)
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8e179cf..90b0568 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -303,14 +303,14 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
 static __le64 **iod_list(struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	return (__le64 **)(iod->sg + req->nr_phys_segments);
+	return (__le64 **)(iod->sg + blk_rq_nr_phys_segments(req));
 }
 
 static int nvme_init_iod(struct request *rq, unsigned size,
 		struct nvme_dev *dev)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(rq);
-	int nseg = rq->nr_phys_segments;
+	int nseg = blk_rq_nr_phys_segments(rq);
 
 	if (nseg > NVME_INT_PAGES || size > NVME_INT_BYTES(dev)) {
 		iod->sg = kmalloc(nvme_iod_alloc_size(dev, size, nseg), GFP_ATOMIC);
@@ -340,8 +340,6 @@ static void nvme_free_iod(struct nvme_dev *dev, struct request *req)
 	__le64 **list = iod_list(req);
 	dma_addr_t prp_dma = iod->first_dma;
 
-	nvme_cleanup_cmd(req);
-
 	if (iod->npages == 0)
 		dma_pool_free(dev->prp_small_pool, list[0], prp_dma);
 	for (i = 0; i < iod->npages; i++) {
@@ -511,7 +509,7 @@ static int nvme_map_data(struct nvme_dev *dev, struct request *req,
 			DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	int ret = BLK_MQ_RQ_QUEUE_ERROR;
 
-	sg_init_table(iod->sg, req->nr_phys_segments);
+	sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
 	iod->nents = blk_rq_map_sg(q, req, iod->sg);
 	if (!iod->nents)
 		goto out;
@@ -567,6 +565,7 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 		}
 	}
 
+	nvme_cleanup_cmd(req);
 	nvme_free_iod(dev, req);
 }
 
@@ -597,20 +596,20 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 		}
 	}
 
-	map_len = nvme_map_len(req);
-	ret = nvme_init_iod(req, map_len, dev);
+	ret = nvme_setup_cmd(ns, req, &cmnd);
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		return ret;
 
-	ret = nvme_setup_cmd(ns, req, &cmnd);
+	map_len = nvme_map_len(req);
+	ret = nvme_init_iod(req, map_len, dev);
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
-		goto out;
+		goto out_free_cmd;
 
-	if (req->nr_phys_segments)
+	if (blk_rq_nr_phys_segments(req))
 		ret = nvme_map_data(dev, req, map_len, &cmnd);
 
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
-		goto out;
+		goto out_cleanup_iod;
 
 	cmnd.common.command_id = req->tag;
 	blk_mq_start_request(req);
@@ -622,14 +621,16 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 		else
 			ret = BLK_MQ_RQ_QUEUE_ERROR;
 		spin_unlock_irq(&nvmeq->q_lock);
-		goto out;
+		goto out_cleanup_iod;
 	}
 	__nvme_submit_cmd(nvmeq, &cmnd);
 	nvme_process_cq(nvmeq);
 	spin_unlock_irq(&nvmeq->q_lock);
 	return BLK_MQ_RQ_QUEUE_OK;
-out:
+out_cleanup_iod:
 	nvme_free_iod(dev, req);
+out_free_cmd:
+	nvme_cleanup_cmd(req);
 	return ret;
 }
 
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6d102f9..042e319 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -964,8 +964,7 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
 	struct nvme_rdma_device *dev = queue->device;
 	struct ib_device *ibdev = dev->dev;
-	int nents, count;
-	int ret;
+	int count, ret;
 
 	req->num_sge = 1;
 	req->inline_data = false;
@@ -977,16 +976,14 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 		return nvme_rdma_set_sg_null(c);
 
 	req->sg_table.sgl = req->first_sgl;
-	ret = sg_alloc_table_chained(&req->sg_table, rq->nr_phys_segments,
-				req->sg_table.sgl);
+	ret = sg_alloc_table_chained(&req->sg_table,
+			blk_rq_nr_phys_segments(rq), req->sg_table.sgl);
 	if (ret)
 		return -ENOMEM;
 
-	nents = blk_rq_map_sg(rq->q, rq, req->sg_table.sgl);
-	BUG_ON(nents > rq->nr_phys_segments);
-	req->nents = nents;
+	req->nents = blk_rq_map_sg(rq->q, rq, req->sg_table.sgl);
 
-	count = ib_dma_map_sg(ibdev, req->sg_table.sgl, nents,
+	count = ib_dma_map_sg(ibdev, req->sg_table.sgl, req->nents,
 		    rq_data_dir(rq) == WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	if (unlikely(count <= 0)) {
 		sg_free_table_chained(&req->sg_table, true);
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index be56d05..79c5d7c 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -185,13 +185,13 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (blk_rq_bytes(req)) {
 		iod->sg_table.sgl = iod->first_sgl;
 		ret = sg_alloc_table_chained(&iod->sg_table,
-			req->nr_phys_segments, iod->sg_table.sgl);
+				blk_rq_nr_phys_segments(req),
+				iod->sg_table.sgl);
 		if (ret)
 			return BLK_MQ_RQ_QUEUE_BUSY;
 
 		iod->req.sg = iod->sg_table.sgl;
 		iod->req.sg_cnt = blk_rq_map_sg(req->q, req, iod->sg_table.sgl);
-		BUG_ON(iod->req.sg_cnt > req->nr_phys_segments);
 	}
 
 	iod->cmd.common.command_id = req->tag;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47a5c87..9a8ccff 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1007,8 +1007,8 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	if (unlikely(sg_alloc_table_chained(&sdb->table, req->nr_phys_segments,
-					sdb->table.sgl)))
+	if (unlikely(sg_alloc_table_chained(&sdb->table,
+			blk_rq_nr_phys_segments(req), sdb->table.sgl)))
 		return BLKPREP_DEFER;
 
 	/* 
@@ -1040,7 +1040,7 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	bool is_mq = (rq->mq_ctx != NULL);
 	int error;
 
-	BUG_ON(!rq->nr_phys_segments);
+	BUG_ON(!blk_rq_nr_phys_segments(rq));
 
 	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 65738b0..079c2d9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -716,7 +716,6 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	unsigned int nr_sectors = blk_rq_sectors(rq);
-	unsigned int nr_bytes = blk_rq_bytes(rq);
 	unsigned int len;
 	int ret;
 	char *buf;
@@ -772,24 +771,19 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	rq->completion_data = page;
 	rq->timeout = SD_TIMEOUT;
 
 	cmd->transfersize = len;
 	cmd->allowed = SD_MAX_RETRIES;
 
-	/*
-	 * Initially __data_len is set to the amount of data that needs to be
-	 * transferred to the target. This amount depends on whether WRITE SAME
-	 * or UNMAP is being used. After the scatterlist has been mapped by
-	 * scsi_init_io() we set __data_len to the size of the area to be
-	 * discarded on disk. This allows us to report completion on the full
-	 * amount of blocks described by the request.
-	 */
-	blk_add_request_payload(rq, page, 0, len);
-	ret = scsi_init_io(cmd);
-	rq->__data_len = nr_bytes;
+	rq->special_vec.bv_page = page;
+	rq->special_vec.bv_offset = 0;
+	rq->special_vec.bv_len = len;
+
+	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
+	rq->resid_len = len;
 
+	ret = scsi_init_io(cmd);
 out:
 	if (ret != BLKPREP_OK)
 		__free_page(page);
@@ -1182,8 +1176,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (req_op(rq) == REQ_OP_DISCARD)
-		__free_page(rq->completion_data);
+	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
+		__free_page(rq->special_vec.bv_page);
 
 	if (SCpnt->cmnd != rq->cmd) {
 		mempool_free(SCpnt->cmnd, sd_cdb_pool);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b153239..7cf8a6c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -197,8 +197,9 @@ static inline unsigned bio_segments(struct bio *bio)
 	switch (bio_op(bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_SAME:
 	case REQ_OP_WRITE_ZEROES:
+		return 0;
+	case REQ_OP_WRITE_SAME:
 		return 1;
 	default:
 		break;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebeef2b..c539376 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -120,10 +120,13 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_HASHED		((__force req_flags_t)(1 << 16))
 /* IO stats tracking on */
 #define RQF_STATS		((__force req_flags_t)(1 << 17))
+/* Look at ->special_vec for the actual data payload instead of the
+   bio chain. */
+#define RQF_SPECIAL_PAYLOAD	((__force req_flags_t)(1 << 18))
 
 /* flags that prevent us from merging requests: */
 #define RQF_NOMERGE_FLAGS \
-	(RQF_STARTED | RQF_SOFTBARRIER | RQF_FLUSH_SEQ)
+	(RQF_STARTED | RQF_SOFTBARRIER | RQF_FLUSH_SEQ | RQF_SPECIAL_PAYLOAD)
 
 #define BLK_MAX_CDB	16
 
@@ -175,6 +178,7 @@ struct request {
 	 */
 	union {
 		struct rb_node rb_node;	/* sort/lookup */
+		struct bio_vec special_vec;
 		void *completion_data;
 	};
 
@@ -909,8 +913,6 @@ extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern void blk_rq_set_block_pc(struct request *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
-extern void blk_add_request_payload(struct request *rq, struct page *page,
-		int offset, unsigned int len);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 			     struct bio_set *bs, gfp_t gfp_mask,
@@ -1153,6 +1155,13 @@ extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
+static inline unsigned short blk_rq_nr_phys_segments(struct request *rq)
+{
+	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
+		return 1;
+	return rq->nr_phys_segments;
+}
+
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
-- 
2.1.4

