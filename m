From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 02/11] IB/iser: Push the desicion what memory key to use into fast_reg_mr routine
Date: Sun, 23 Feb 2014 14:19:25 +0200
Message-ID: <1393157974-24931-3-git-send-email-sagig@mellanox.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57202 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751251AbaBWMTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 07:19:42 -0500
In-Reply-To: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

This is a preparation step for T10-PI offload support. We prefer to push
the desicion of which mkey to use (global or fastreg) to iser_fast_reg_mr.
We choose to do this since it in T10-PI we may need to register for
protection buffers and in this case we wish to simplify iser_fast_reg_mr
instead of repeating the logic of which key to use.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_memory.c |  101 +++++++++++++++++------------
 1 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 4e34729..0e029fe 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -444,16 +444,40 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 	return 0;
 }
 
-static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
-			    struct iser_conn *ib_conn,
+static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 			    struct iser_regd_buf *regd_buf,
-			    u32 offset, unsigned int data_size,
-			    unsigned int page_list_len)
+			    struct iser_data_buf *mem,
+			    struct ib_sge *sge)
 {
+	struct fast_reg_descriptor *desc = regd_buf->reg.mem_h;
+	struct iser_conn *ib_conn = iser_task->iser_conn->ib_conn;
+	struct iser_device *device = ib_conn->device;
+	struct ib_device *ibdev = device->ib_device;
 	struct ib_send_wr fastreg_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
 	u8 key;
-	int ret;
+	int ret, offset, size, plen;
+
+	/* if there a single dma entry, dma mr suffices */
+	if (mem->dma_nents == 1) {
+		struct scatterlist *sg = (struct scatterlist *)mem->buf;
+
+		sge->lkey = device->mr->lkey;
+		sge->addr   = ib_sg_dma_address(ibdev, &sg[0]);
+		sge->length  = ib_sg_dma_len(ibdev, &sg[0]);
+
+		iser_dbg("Single DMA entry: lkey=0x%x, addr=0x%llx, length=0x%x\n",
+			 sge->lkey, sge->addr, sge->length);
+		return 0;
+	}
+
+	plen = iser_sg_to_page_vec(mem, device->ib_device,
+				   desc->data_frpl->page_list,
+				   &offset, &size);
+	if (plen * SIZE_4K < size) {
+		iser_err("fast reg page_list too short to hold this SG\n");
+		return -EINVAL;
+	}
 
 	if (!desc->valid) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
@@ -472,9 +496,9 @@ static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
 	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
 	fastreg_wr.wr.fast_reg.iova_start = desc->data_frpl->page_list[0] + offset;
 	fastreg_wr.wr.fast_reg.page_list = desc->data_frpl;
-	fastreg_wr.wr.fast_reg.page_list_len = page_list_len;
+	fastreg_wr.wr.fast_reg.page_list_len = plen;
 	fastreg_wr.wr.fast_reg.page_shift = SHIFT_4K;
-	fastreg_wr.wr.fast_reg.length = data_size;
+	fastreg_wr.wr.fast_reg.length = size;
 	fastreg_wr.wr.fast_reg.rkey = desc->data_mr->rkey;
 	fastreg_wr.wr.fast_reg.access_flags = (IB_ACCESS_LOCAL_WRITE  |
 					       IB_ACCESS_REMOTE_WRITE |
@@ -492,12 +516,9 @@ static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
 	}
 	desc->valid = false;
 
-	regd_buf->reg.mem_h = desc;
-	regd_buf->reg.lkey = desc->data_mr->lkey;
-	regd_buf->reg.rkey = desc->data_mr->rkey;
-	regd_buf->reg.va = desc->data_frpl->page_list[0] + offset;
-	regd_buf->reg.len = data_size;
-	regd_buf->reg.is_mr = 1;
+	sge->lkey = desc->data_mr->lkey;
+	sge->addr = desc->data_frpl->page_list[0] + offset;
+	sge->length = size;
 
 	return ret;
 }
@@ -516,11 +537,10 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 	struct ib_device *ibdev = device->ib_device;
 	struct iser_data_buf *mem = &iser_task->data[cmd_dir];
 	struct iser_regd_buf *regd_buf = &iser_task->rdma_regd[cmd_dir];
-	struct fast_reg_descriptor *desc;
-	unsigned int data_size, page_list_len;
+	struct fast_reg_descriptor *desc = NULL;
+	struct ib_sge data_sge;
 	int err, aligned_len;
 	unsigned long flags;
-	u32 offset;
 
 	aligned_len = iser_data_buf_aligned_len(mem, ibdev);
 	if (aligned_len != mem->dma_nents) {
@@ -533,41 +553,38 @@ int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
 		mem = &iser_task->data_copy[cmd_dir];
 	}
 
-	/* if there a single dma entry, dma mr suffices */
-	if (mem->dma_nents == 1) {
-		struct scatterlist *sg = (struct scatterlist *)mem->buf;
-
-		regd_buf->reg.lkey = device->mr->lkey;
-		regd_buf->reg.rkey = device->mr->rkey;
-		regd_buf->reg.len  = ib_sg_dma_len(ibdev, &sg[0]);
-		regd_buf->reg.va   = ib_sg_dma_address(ibdev, &sg[0]);
-		regd_buf->reg.is_mr = 0;
-	} else {
+	if (mem->dma_nents != 1) {
 		spin_lock_irqsave(&ib_conn->lock, flags);
 		desc = list_first_entry(&ib_conn->fastreg.pool,
 					struct fast_reg_descriptor, list);
 		list_del(&desc->list);
 		spin_unlock_irqrestore(&ib_conn->lock, flags);
-		page_list_len = iser_sg_to_page_vec(mem, device->ib_device,
-						    desc->data_frpl->page_list,
-						    &offset, &data_size);
-
-		if (page_list_len * SIZE_4K < data_size) {
-			iser_err("fast reg page_list too short to hold this SG\n");
-			err = -EINVAL;
-			goto err_reg;
-		}
+		regd_buf->reg.mem_h = desc;
+	}
 
-		err = iser_fast_reg_mr(desc, ib_conn, regd_buf,
-				       offset, data_size, page_list_len);
-		if (err)
-			goto err_reg;
+	err = iser_fast_reg_mr(iser_task, regd_buf, mem, &data_sge);
+	if (err)
+		goto err_reg;
+
+	if (desc) {
+		regd_buf->reg.rkey = desc->data_mr->rkey;
+		regd_buf->reg.is_mr = 1;
+	} else {
+		regd_buf->reg.rkey = device->mr->rkey;
+		regd_buf->reg.is_mr = 0;
 	}
 
+	regd_buf->reg.lkey = data_sge.lkey;
+	regd_buf->reg.va = data_sge.addr;
+	regd_buf->reg.len = data_sge.length;
+
 	return 0;
 err_reg:
-	spin_lock_irqsave(&ib_conn->lock, flags);
-	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
-	spin_unlock_irqrestore(&ib_conn->lock, flags);
+	if (desc) {
+		spin_lock_irqsave(&ib_conn->lock, flags);
+		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+		spin_unlock_irqrestore(&ib_conn->lock, flags);
+	}
+
 	return err;
 }
-- 
1.7.1

