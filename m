From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/13] IB/srpt: chain RDMA READ/WRITE requests
Date: Mon,  7 Dec 2015 12:51:47 -0800
Message-ID: <1449521512-22921-9-git-send-email-hch@lst.de>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove struct rdma_iu and instead allocate the struct ib_rdma_wr array
early and fill out directly.  This allows us to chain the WRs, and thus
archive both less lock contention on the HCA workqueue as well as much
simpler error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 100 +++++++++++++---------------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  14 +----
 2 files changed, 39 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b8b654c..b5544b2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1055,7 +1055,7 @@ static void srpt_unmap_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	BUG_ON(ioctx->n_rdma && !ioctx->rdma_ius);
 
 	while (ioctx->n_rdma)
-		kfree(ioctx->rdma_ius[--ioctx->n_rdma].sge);
+		kfree(ioctx->rdma_ius[--ioctx->n_rdma].wr.sg_list);
 
 	kfree(ioctx->rdma_ius);
 	ioctx->rdma_ius = NULL;
@@ -1082,7 +1082,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	struct scatterlist *sg, *sg_orig;
 	int sg_cnt;
 	enum dma_data_direction dir;
-	struct rdma_iu *riu;
+	struct ib_rdma_wr *riu;
 	struct srp_direct_buf *db;
 	dma_addr_t dma_addr;
 	struct ib_sge *sge;
@@ -1115,7 +1115,8 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 		nrdma = (count + SRPT_DEF_SG_PER_WQE - 1) / SRPT_DEF_SG_PER_WQE
 			+ ioctx->n_rbuf;
 
-		ioctx->rdma_ius = kzalloc(nrdma * sizeof *riu, GFP_KERNEL);
+		ioctx->rdma_ius = kcalloc(nrdma, sizeof(*ioctx->rdma_ius),
+				GFP_KERNEL);
 		if (!ioctx->rdma_ius)
 			goto free_mem;
 
@@ -1139,9 +1140,9 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	     j < count && i < ioctx->n_rbuf && tsize > 0; ++i, ++riu, ++db) {
 		rsize = be32_to_cpu(db->len);
 		raddr = be64_to_cpu(db->va);
-		riu->raddr = raddr;
+		riu->remote_addr = raddr;
 		riu->rkey = be32_to_cpu(db->key);
-		riu->sge_cnt = 0;
+		riu->wr.num_sge = 0;
 
 		/* calculate how many sge required for this remote_buf */
 		while (rsize > 0 && tsize > 0) {
@@ -1165,27 +1166,29 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 				rsize = 0;
 			}
 
-			++riu->sge_cnt;
+			++riu->wr.num_sge;
 
-			if (rsize > 0 && riu->sge_cnt == SRPT_DEF_SG_PER_WQE) {
+			if (rsize > 0 &&
+			    riu->wr.num_sge == SRPT_DEF_SG_PER_WQE) {
 				++ioctx->n_rdma;
-				riu->sge =
-				    kmalloc(riu->sge_cnt * sizeof *riu->sge,
-					    GFP_KERNEL);
-				if (!riu->sge)
+				riu->wr.sg_list = kmalloc_array(riu->wr.num_sge,
+						sizeof(*riu->wr.sg_list),
+						GFP_KERNEL);
+				if (!riu->wr.sg_list)
 					goto free_mem;
 
 				++riu;
-				riu->sge_cnt = 0;
-				riu->raddr = raddr;
+				riu->wr.num_sge = 0;
+				riu->remote_addr = raddr;
 				riu->rkey = be32_to_cpu(db->key);
 			}
 		}
 
 		++ioctx->n_rdma;
-		riu->sge = kmalloc(riu->sge_cnt * sizeof *riu->sge,
-				   GFP_KERNEL);
-		if (!riu->sge)
+		riu->wr.sg_list = kmalloc_array(riu->wr.num_sge,
+					sizeof(*riu->wr.sg_list),
+					GFP_KERNEL);
+		if (!riu->wr.sg_list)
 			goto free_mem;
 	}
 
@@ -1200,7 +1203,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	for (i = 0, j = 0;
 	     j < count && i < ioctx->n_rbuf && tsize > 0; ++i, ++riu, ++db) {
 		rsize = be32_to_cpu(db->len);
-		sge = riu->sge;
+		sge = riu->wr.sg_list;
 		k = 0;
 
 		while (rsize > 0 && tsize > 0) {
@@ -1232,9 +1235,9 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 			}
 
 			++k;
-			if (k == riu->sge_cnt && rsize > 0 && tsize > 0) {
+			if (k == riu->wr.num_sge && rsize > 0 && tsize > 0) {
 				++riu;
-				sge = riu->sge;
+				sge = riu->wr.sg_list;
 				k = 0;
 			} else if (rsize > 0 && tsize > 0)
 				++sge;
@@ -1455,8 +1458,6 @@ static void srpt_handle_rdma_comp(struct srpt_rdma_ch *ch,
 		else
 			pr_err("%s[%d]: wrong state = %d\n", __func__,
 			       __LINE__, srpt_get_cmd_state(ioctx));
-	} else if (opcode == SRPT_RDMA_ABORT) {
-		ioctx->rdma_aborted = true;
 	} else {
 		WARN(true, "unexpected opcode %d\n", opcode);
 	}
@@ -1979,8 +1980,7 @@ static void srpt_process_send_completion(struct ib_cq *cq,
 		if (opcode == SRPT_SEND)
 			srpt_handle_send_comp(ch, send_ioctx);
 		else {
-			WARN_ON(opcode != SRPT_RDMA_ABORT &&
-				wc->opcode != IB_WC_RDMA_READ);
+			WARN_ON(wc->opcode != IB_WC_RDMA_READ);
 			srpt_handle_rdma_comp(ch, send_ioctx, opcode);
 		}
 	} else {
@@ -2821,9 +2821,7 @@ static int srpt_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 			      struct srpt_send_ioctx *ioctx)
 {
-	struct ib_rdma_wr wr;
 	struct ib_send_wr *bad_wr;
-	struct rdma_iu *riu;
 	int i;
 	int ret;
 	int sq_wr_avail;
@@ -2842,59 +2840,37 @@ static int srpt_perform_rdmas(struct srpt_rdma_ch *ch,
 		}
 	}
 
-	ioctx->rdma_aborted = false;
-	ret = 0;
-	riu = ioctx->rdma_ius;
-	memset(&wr, 0, sizeof wr);
+	for (i = 0; i < n_rdma; i++) {
+		struct ib_rdma_wr *wr = &ioctx->rdma_ius[i];
 
-	for (i = 0; i < n_rdma; ++i, ++riu) {
 		if (dir == DMA_FROM_DEVICE) {
-			wr.wr.opcode = IB_WR_RDMA_WRITE;
-			wr.wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
+			wr->wr.opcode = IB_WR_RDMA_WRITE;
+			wr->wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
 						SRPT_RDMA_WRITE_LAST :
 						SRPT_RDMA_MID,
 						ioctx->ioctx.index);
 		} else {
-			wr.wr.opcode = IB_WR_RDMA_READ;
-			wr.wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
+			wr->wr.opcode = IB_WR_RDMA_READ;
+			wr->wr.wr_id = encode_wr_id(i == n_rdma - 1 ?
 						SRPT_RDMA_READ_LAST :
 						SRPT_RDMA_MID,
 						ioctx->ioctx.index);
 		}
-		wr.wr.next = NULL;
-		wr.remote_addr = riu->raddr;
-		wr.rkey = riu->rkey;
-		wr.wr.num_sge = riu->sge_cnt;
-		wr.wr.sg_list = riu->sge;
-
-		/* only get completion event for the last rdma write */
-		if (i == (n_rdma - 1) && dir == DMA_TO_DEVICE)
-			wr.wr.send_flags = IB_SEND_SIGNALED;
 
-		ret = ib_post_send(ch->qp, &wr.wr, &bad_wr);
-		if (ret)
-			break;
+		if (i == n_rdma - 1) {
+			/* only get completion event for the last rdma read */
+			if (dir == DMA_TO_DEVICE)
+				wr->wr.send_flags = IB_SEND_SIGNALED;
+			wr->wr.next = NULL;
+		} else {
+			wr->wr.next = &ioctx->rdma_ius[i + 1].wr;
+		}
 	}
 
+	ret = ib_post_send(ch->qp, &ioctx->rdma_ius->wr, &bad_wr);
 	if (ret)
 		pr_err("%s[%d]: ib_post_send() returned %d for %d/%d\n",
 				 __func__, __LINE__, ret, i, n_rdma);
-	if (ret && i > 0) {
-		wr.wr.num_sge = 0;
-		wr.wr.wr_id = encode_wr_id(SRPT_RDMA_ABORT, ioctx->ioctx.index);
-		wr.wr.send_flags = IB_SEND_SIGNALED;
-		while (ch->state == CH_LIVE &&
-			ib_post_send(ch->qp, &wr.wr, &bad_wr) != 0) {
-			pr_info("Trying to abort failed RDMA transfer [%d]\n",
-				ioctx->ioctx.index);
-			msleep(1000);
-		}
-		while (ch->state != CH_RELEASING && !ioctx->rdma_aborted) {
-			pr_info("Waiting until RDMA abort finished [%d]\n",
-				ioctx->ioctx.index);
-			msleep(1000);
-		}
-	}
 out:
 	if (unlikely(dir == DMA_TO_DEVICE && ret < 0))
 		atomic_add(n_rdma, &ch->sq_wr_avail);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 0df7d61..fd6097e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -132,7 +132,6 @@ enum srpt_opcode {
 	SRPT_RECV,
 	SRPT_SEND,
 	SRPT_RDMA_MID,
-	SRPT_RDMA_ABORT,
 	SRPT_RDMA_READ_LAST,
 	SRPT_RDMA_WRITE_LAST,
 };
@@ -150,14 +149,6 @@ static inline u32 idx_from_wr_id(u64 wr_id)
 	return (u32)wr_id;
 }
 
-struct rdma_iu {
-	u64		raddr;
-	u32		rkey;
-	struct ib_sge	*sge;
-	u32		sge_cnt;
-	int		mem_id;
-};
-
 /**
  * enum srpt_command_state - SCSI command state managed by SRPT.
  * @SRPT_STATE_NEW:           New command arrived and is being processed.
@@ -220,22 +211,19 @@ struct srpt_recv_ioctx {
  * @tag:         Tag of the received SRP information unit.
  * @spinlock:    Protects 'state'.
  * @state:       I/O context state.
- * @rdma_aborted: If initiating a multipart RDMA transfer failed, whether
- * 		 the already initiated transfers have finished.
  * @cmd:         Target core command data structure.
  * @sense_data:  SCSI sense data.
  */
 struct srpt_send_ioctx {
 	struct srpt_ioctx	ioctx;
 	struct srpt_rdma_ch	*ch;
-	struct rdma_iu		*rdma_ius;
+	struct ib_rdma_wr	*rdma_ius;
 	struct srp_direct_buf	*rbufs;
 	struct srp_direct_buf	single_rbuf;
 	struct scatterlist	*sg;
 	struct list_head	free_list;
 	spinlock_t		spinlock;
 	enum srpt_command_state	state;
-	bool			rdma_aborted;
 	struct se_cmd		cmd;
 	struct completion	tx_done;
 	int			sg_cnt;
-- 
1.9.1
