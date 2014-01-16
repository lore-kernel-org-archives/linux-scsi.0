From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 4/7] IB/isert: pass mr and frpl to isert_fast_reg_mr routine
Date: Thu, 16 Jan 2014 15:55:53 +0200
Message-ID: <1389880556-21059-5-git-send-email-sagig@mellanox.com>
References: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@daterainc.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

This commit generalizes isert_fast_reg_mr to receive mr
and frpl instead of fr_desc to do registration. In T10-PI
we also register protection memory region so we want to
use this routine.

This commit does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   62 +++++++++++++++----------------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3495e73..e5159ee 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2246,10 +2246,10 @@ isert_map_fr_pagelist(struct ib_device *ib_dev,
 }
 
 static int
-isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
-		  struct isert_conn *isert_conn, struct scatterlist *sg_start,
-		  struct ib_sge *ib_sge, u32 sg_nents, u32 offset,
-		  unsigned int data_len)
+isert_fast_reg_mr(struct isert_conn *isert_conn, struct ib_mr *mr,
+		  struct ib_fast_reg_page_list *frpl, bool *key_valid,
+		  struct scatterlist *sg_start, u32 sg_nents, u32 offset,
+		  unsigned int data_len, struct ib_sge *ib_sge)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct ib_send_wr fr_wr, inv_wr;
@@ -2260,33 +2260,31 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 
 	sg_nents = min_t(unsigned int, sg_nents, ISCSI_ISER_SG_TABLESIZE);
 	page_off = offset % PAGE_SIZE;
-
-	pr_debug("Use fr_desc %p sg_nents %d offset %u\n",
-		 fr_desc, sg_nents, offset);
+	pr_debug("Use mr %p frpl %p sg_nents %d offset %u\n",
+		 mr, frpl, sg_nents, offset);
 
 	pagelist_len = isert_map_fr_pagelist(ib_dev, sg_start, sg_nents,
-					     &fr_desc->data_frpl->page_list[0]);
+					     &frpl->page_list[0]);
 
-	if (!fr_desc->data_key_valid) {
+	if (!*key_valid) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
 		inv_wr.opcode = IB_WR_LOCAL_INV;
-		inv_wr.ex.invalidate_rkey = fr_desc->data_mr->rkey;
+		inv_wr.ex.invalidate_rkey = mr->rkey;
 		wr = &inv_wr;
 		/* Bump the key */
-		key = (u8)(fr_desc->data_mr->rkey & 0x000000FF);
-		ib_update_fast_reg_key(fr_desc->data_mr, ++key);
+		key = (u8)(mr->rkey & 0x000000FF);
+		ib_update_fast_reg_key(mr, ++key);
 	}
 
 	/* Prepare FASTREG WR */
 	memset(&fr_wr, 0, sizeof(fr_wr));
 	fr_wr.opcode = IB_WR_FAST_REG_MR;
-	fr_wr.wr.fast_reg.iova_start =
-		fr_desc->data_frpl->page_list[0] + page_off;
-	fr_wr.wr.fast_reg.page_list = fr_desc->data_frpl;
+	fr_wr.wr.fast_reg.iova_start = frpl->page_list[0] + page_off;
+	fr_wr.wr.fast_reg.page_list = frpl;
 	fr_wr.wr.fast_reg.page_list_len = pagelist_len;
 	fr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
 	fr_wr.wr.fast_reg.length = data_len;
-	fr_wr.wr.fast_reg.rkey = fr_desc->data_mr->rkey;
+	fr_wr.wr.fast_reg.rkey = mr->rkey;
 	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
 
 	if (!wr)
@@ -2299,14 +2297,14 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 		pr_err("fast registration failed, ret:%d\n", ret);
 		return ret;
 	}
-	fr_desc->data_key_valid = false;
 
-	ib_sge->lkey = fr_desc->data_mr->lkey;
-	ib_sge->addr = fr_desc->data_frpl->page_list[0] + page_off;
+	*key_valid = false;
+	ib_sge->lkey = mr->lkey;
+	ib_sge->addr = frpl->page_list[0] + page_off;
 	ib_sge->length = data_len;
 
-	pr_debug("RDMA ib_sge: addr: 0x%16llx  length: %u lkey: %08x\n",
-		 ib_sge->addr, ib_sge->length, ib_sge->lkey);
+	pr_debug("fastreg ib_sge: addr: 0x%16llx  length: %u lkey: %08x\n",
+		 ib_sge->addr + page_off, ib_sge->length, ib_sge->lkey);
 
 	return ret;
 }
@@ -2320,7 +2318,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct ib_send_wr *send_wr;
-	struct ib_sge *ib_sge;
+	struct ib_sge data_sge;
 	struct scatterlist *sg_start;
 	struct fast_reg_descriptor *fr_desc;
 	u32 sg_off = 0, sg_nents;
@@ -2352,10 +2350,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	pr_debug("Mapped cmd: %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
 		 isert_cmd, count, sg_start, sg_nents, data_left);
 
-	memset(&wr->s_ib_sge, 0, sizeof(*ib_sge));
-	ib_sge = &wr->s_ib_sge;
-	wr->ib_sge = ib_sge;
-
+	wr->ib_sge = &wr->s_ib_sge;
 	wr->send_wr_num = 1;
 	memset(&wr->s_send_wr, 0, sizeof(*send_wr));
 	wr->send_wr = &wr->s_send_wr;
@@ -2364,7 +2359,7 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	rdma_write_max = ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE;
 
 	send_wr = &isert_cmd->rdma_wr.s_send_wr;
-	send_wr->sg_list = ib_sge;
+	send_wr->sg_list = &wr->s_ib_sge;
 	send_wr->num_sge = 1;
 	send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
@@ -2385,9 +2380,9 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	/* if there is a single dma entry, dma mr is sufficient */
 	if (count == 1) {
-		ib_sge->addr = ib_sg_dma_address(ib_dev, &sg_start[0]);
-		ib_sge->length = ib_sg_dma_len(ib_dev, &sg_start[0]);
-		ib_sge->lkey = isert_conn->conn_mr->lkey;
+		wr->s_ib_sge.addr = ib_sg_dma_address(ib_dev, &sg_start[0]);
+		wr->s_ib_sge.length = ib_sg_dma_len(ib_dev, &sg_start[0]);
+		wr->s_ib_sge.lkey = isert_conn->conn_mr->lkey;
 		wr->fr_desc = NULL;
 	} else {
 		spin_lock_irqsave(&isert_conn->conn_lock, flags);
@@ -2397,12 +2392,15 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
 		wr->fr_desc = fr_desc;
 
-		ret = isert_fast_reg_mr(fr_desc, isert_conn, sg_start,
-					ib_sge, sg_nents, offset, data_len);
+		ret = isert_fast_reg_mr(isert_conn, fr_desc->data_mr,
+					fr_desc->data_frpl,
+					&fr_desc->data_key_valid, sg_start,
+					sg_nents, offset, data_len, &data_sge);
 		if (ret) {
 			list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
 			goto unmap_sg;
 		}
+		memcpy(&wr->s_ib_sge, &data_sge, sizeof(data_sge));
 	}
 
 	return 0;
-- 
1.7.1
