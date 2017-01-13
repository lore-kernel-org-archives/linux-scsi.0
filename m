From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] nvme: use blk_rq_payload_bytes
Date: Fri, 13 Jan 2017 12:29:12 +0100
Message-ID: <1484306953-3194-4-git-send-email-hch@lst.de>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484306953-3194-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

The new blk_rq_payload_bytes generalizes the payload length hacks
that nvme_map_len did before.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/fc.c   |  5 ++---
 drivers/nvme/host/nvme.h |  8 --------
 drivers/nvme/host/pci.c  | 19 ++++++++-----------
 drivers/nvme/host/rdma.c | 13 +++++--------
 4 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index aa0bc60..fcc9dcf 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1654,13 +1654,12 @@ nvme_fc_map_data(struct nvme_fc_ctrl *ctrl, struct request *rq,
 		struct nvme_fc_fcp_op *op)
 {
 	struct nvmefc_fcp_req *freq = &op->fcp_req;
-	u32 map_len = nvme_map_len(rq);
 	enum dma_data_direction dir;
 	int ret;
 
 	freq->sg_cnt = 0;
 
-	if (!map_len)
+	if (!blk_rq_payload_bytes(rq))
 		return 0;
 
 	freq->sg_table.sgl = freq->first_sgl;
@@ -1854,7 +1853,7 @@ nvme_fc_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		return ret;
 
-	data_len = nvme_map_len(rq);
+	data_len = blk_rq_payload_bytes(rq);
 	if (data_len)
 		io_dir = ((rq_data_dir(rq) == WRITE) ?
 					NVMEFC_FCP_WRITE : NVMEFC_FCP_READ);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 6377e14..aead6d0 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -225,14 +225,6 @@ static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
 	return (sector >> (ns->lba_shift - 9));
 }
 
-static inline unsigned nvme_map_len(struct request *rq)
-{
-	if (req_op(rq) == REQ_OP_DISCARD)
-		return sizeof(struct nvme_dsm_range);
-	else
-		return blk_rq_bytes(rq);
-}
-
 static inline void nvme_cleanup_cmd(struct request *req)
 {
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 19beeb7..3faefab 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -306,11 +306,11 @@ static __le64 **iod_list(struct request *req)
 	return (__le64 **)(iod->sg + blk_rq_nr_phys_segments(req));
 }
 
-static int nvme_init_iod(struct request *rq, unsigned size,
-		struct nvme_dev *dev)
+static int nvme_init_iod(struct request *rq, struct nvme_dev *dev)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(rq);
 	int nseg = blk_rq_nr_phys_segments(rq);
+	unsigned int size = blk_rq_payload_bytes(rq);
 
 	if (nseg > NVME_INT_PAGES || size > NVME_INT_BYTES(dev)) {
 		iod->sg = kmalloc(nvme_iod_alloc_size(dev, size, nseg), GFP_ATOMIC);
@@ -420,12 +420,11 @@ static void nvme_dif_complete(u32 p, u32 v, struct t10_pi_tuple *pi)
 }
 #endif
 
-static bool nvme_setup_prps(struct nvme_dev *dev, struct request *req,
-		int total_len)
+static bool nvme_setup_prps(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct dma_pool *pool;
-	int length = total_len;
+	int length = blk_rq_payload_bytes(req);
 	struct scatterlist *sg = iod->sg;
 	int dma_len = sg_dma_len(sg);
 	u64 dma_addr = sg_dma_address(sg);
@@ -501,7 +500,7 @@ static bool nvme_setup_prps(struct nvme_dev *dev, struct request *req,
 }
 
 static int nvme_map_data(struct nvme_dev *dev, struct request *req,
-		unsigned size, struct nvme_command *cmnd)
+		struct nvme_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct request_queue *q = req->q;
@@ -519,7 +518,7 @@ static int nvme_map_data(struct nvme_dev *dev, struct request *req,
 				DMA_ATTR_NO_WARN))
 		goto out;
 
-	if (!nvme_setup_prps(dev, req, size))
+	if (!nvme_setup_prps(dev, req))
 		goto out_unmap;
 
 	ret = BLK_MQ_RQ_QUEUE_ERROR;
@@ -580,7 +579,6 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_dev *dev = nvmeq->dev;
 	struct request *req = bd->rq;
 	struct nvme_command cmnd;
-	unsigned map_len;
 	int ret = BLK_MQ_RQ_QUEUE_OK;
 
 	/*
@@ -600,13 +598,12 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		return ret;
 
-	map_len = nvme_map_len(req);
-	ret = nvme_init_iod(req, map_len, dev);
+	ret = nvme_init_iod(req, dev);
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		goto out_free_cmd;
 
 	if (blk_rq_nr_phys_segments(req))
-		ret = nvme_map_data(dev, req, map_len, &cmnd);
+		ret = nvme_map_data(dev, req, &cmnd);
 
 	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		goto out_cleanup_iod;
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 34e5648..557f29b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -981,8 +981,7 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 }
 
 static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
-		struct request *rq, unsigned int map_len,
-		struct nvme_command *c)
+		struct request *rq, struct nvme_command *c)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
 	struct nvme_rdma_device *dev = queue->device;
@@ -1014,9 +1013,9 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 	}
 
 	if (count == 1) {
-		if (rq_data_dir(rq) == WRITE &&
-		    map_len <= nvme_rdma_inline_data_size(queue) &&
-		    nvme_rdma_queue_idx(queue))
+		if (rq_data_dir(rq) == WRITE && nvme_rdma_queue_idx(queue) &&
+		    blk_rq_payload_bytes(rq) <=
+				nvme_rdma_inline_data_size(queue))
 			return nvme_rdma_map_sg_inline(queue, req, c);
 
 		if (dev->pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)
@@ -1444,7 +1443,6 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct nvme_command *c = sqe->data;
 	bool flush = false;
 	struct ib_device *dev;
-	unsigned int map_len;
 	int ret;
 
 	WARN_ON_ONCE(rq->tag < 0);
@@ -1462,8 +1460,7 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	blk_mq_start_request(rq);
 
-	map_len = nvme_map_len(rq);
-	ret = nvme_rdma_map_data(queue, rq, map_len, c);
+	ret = nvme_rdma_map_data(queue, rq, c);
 	if (ret < 0) {
 		dev_err(queue->ctrl->ctrl.device,
 			     "Failed to map data (%d)\n", ret);
-- 
2.1.4

