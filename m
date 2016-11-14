From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] blk-mq drivers: untangle 0 and BLK_MQ_RQ_QUEUE_OK
Date: Mon, 14 Nov 2016 15:49:59 -0800
Message-ID: <6ac81fdd561e008fec1f31e9a4530358737389a6.1479167141.git.osandov@fb.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Let's not depend on any of the BLK_MQ_RQ_QUEUE_* constants having
specific values. No functional change.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Hi, Jens,

Some more trivial cleanup, feel free to apply or not if it's too intrusive.

 drivers/nvme/host/core.c   | 4 ++--
 drivers/nvme/host/pci.c    | 8 ++++----
 drivers/nvme/host/rdma.c   | 2 +-
 drivers/nvme/target/loop.c | 6 +++---
 drivers/scsi/scsi_lib.c    | 6 +++---
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 79e679d..e7f9ef5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -276,7 +276,7 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	 */
 	req->__data_len = nr_bytes;
 
-	return 0;
+	return BLK_MQ_RQ_QUEUE_OK;
 }
 
 static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
@@ -324,7 +324,7 @@ static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
 int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmd)
 {
-	int ret = 0;
+	int ret = BLK_MQ_RQ_QUEUE_OK;
 
 	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
 		memcpy(cmd, req->cmd, sizeof(*cmd));
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0248d0e..4afa2f7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -328,7 +328,7 @@ static int nvme_init_iod(struct request *rq, unsigned size,
 		rq->retries = 0;
 		rq->cmd_flags |= REQ_DONTPREP;
 	}
-	return 0;
+	return BLK_MQ_RQ_QUEUE_OK;
 }
 
 static void nvme_free_iod(struct nvme_dev *dev, struct request *req)
@@ -598,17 +598,17 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	map_len = nvme_map_len(req);
 	ret = nvme_init_iod(req, map_len, dev);
-	if (ret)
+	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		return ret;
 
 	ret = nvme_setup_cmd(ns, req, &cmnd);
-	if (ret)
+	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		goto out;
 
 	if (req->nr_phys_segments)
 		ret = nvme_map_data(dev, req, map_len, &cmnd);
 
-	if (ret)
+	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		goto out;
 
 	cmnd.common.command_id = req->tag;
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 5a83881..125c43b 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1399,7 +1399,7 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 			sizeof(struct nvme_command), DMA_TO_DEVICE);
 
 	ret = nvme_setup_cmd(ns, rq, c);
-	if (ret)
+	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		return ret;
 
 	c->common.command_id = rq->tag;
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index d5df77d..01035fb 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -168,7 +168,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int ret;
 
 	ret = nvme_setup_cmd(ns, req, &iod->cmd);
-	if (ret)
+	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		return ret;
 
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
@@ -178,7 +178,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		nvme_cleanup_cmd(req);
 		blk_mq_start_request(req);
 		nvme_loop_queue_response(&iod->req);
-		return 0;
+		return BLK_MQ_RQ_QUEUE_OK;
 	}
 
 	if (blk_rq_bytes(req)) {
@@ -197,7 +197,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(req);
 
 	schedule_work(&iod->work);
-	return 0;
+	return BLK_MQ_RQ_QUEUE_OK;
 }
 
 static void nvme_loop_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2cca9cf..13887c0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1801,7 +1801,7 @@ static inline int prep_to_mq(int ret)
 {
 	switch (ret) {
 	case BLKPREP_OK:
-		return 0;
+		return BLK_MQ_RQ_QUEUE_OK;
 	case BLKPREP_DEFER:
 		return BLK_MQ_RQ_QUEUE_BUSY;
 	default:
@@ -1888,7 +1888,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int reason;
 
 	ret = prep_to_mq(scsi_prep_state_check(sdev, req));
-	if (ret)
+	if (ret != BLK_MQ_RQ_QUEUE_OK)
 		goto out;
 
 	ret = BLK_MQ_RQ_QUEUE_BUSY;
@@ -1905,7 +1905,7 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (!(req->cmd_flags & REQ_DONTPREP)) {
 		ret = prep_to_mq(scsi_mq_prep_fn(req));
-		if (ret)
+		if (ret != BLK_MQ_RQ_QUEUE_OK)
 			goto out_dec_host_busy;
 		req->cmd_flags |= REQ_DONTPREP;
 	} else {
-- 
2.10.2

