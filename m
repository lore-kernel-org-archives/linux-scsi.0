From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 07/11] IB/isert: pass scatterlist instead of cmd to fast_reg_mr routine
Date: Thu,  9 Jan 2014 18:40:54 +0200
Message-ID: <1389285658-7037-8-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

This routine may help for protection registration as well.
This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 98f23f4..3495e73 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2247,26 +2247,22 @@ isert_map_fr_pagelist(struct ib_device *ib_dev,
 
 static int
 isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
-		  struct isert_cmd *isert_cmd, struct isert_conn *isert_conn,
-		  struct ib_sge *ib_sge, u32 offset, unsigned int data_len)
+		  struct isert_conn *isert_conn, struct scatterlist *sg_start,
+		  struct ib_sge *ib_sge, u32 sg_nents, u32 offset,
+		  unsigned int data_len)
 {
-	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
-	struct scatterlist *sg_start;
-	u32 sg_off, page_off;
 	struct ib_send_wr fr_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
+	int ret, pagelist_len;
+	u32 page_off;
 	u8 key;
-	int ret, sg_nents, pagelist_len;
 
-	sg_off = offset / PAGE_SIZE;
-	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = min_t(unsigned int, cmd->se_cmd.t_data_nents - sg_off,
-			 ISCSI_ISER_SG_TABLESIZE);
+	sg_nents = min_t(unsigned int, sg_nents, ISCSI_ISER_SG_TABLESIZE);
 	page_off = offset % PAGE_SIZE;
 
-	pr_debug("Cmd: %p use fr_desc %p sg_nents %d sg_off %d offset %u\n",
-		 isert_cmd, fr_desc, sg_nents, sg_off, offset);
+	pr_debug("Use fr_desc %p sg_nents %d offset %u\n",
+		 fr_desc, sg_nents, offset);
 
 	pagelist_len = isert_map_fr_pagelist(ib_dev, sg_start, sg_nents,
 					     &fr_desc->data_frpl->page_list[0]);
@@ -2335,9 +2331,9 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		data_left = se_cmd->data_length;
 	} else {
-		sg_off = cmd->write_data_done / PAGE_SIZE;
-		data_left = se_cmd->data_length - cmd->write_data_done;
 		offset = cmd->write_data_done;
+		sg_off = offset / PAGE_SIZE;
+		data_left = se_cmd->data_length - cmd->write_data_done;
 		isert_cmd->tx_desc.isert_cmd = isert_cmd;
 	}
 
@@ -2401,8 +2397,8 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
 		wr->fr_desc = fr_desc;
 
-		ret = isert_fast_reg_mr(fr_desc, isert_cmd, isert_conn,
-				  ib_sge, offset, data_len);
+		ret = isert_fast_reg_mr(fr_desc, isert_conn, sg_start,
+					ib_sge, sg_nents, offset, data_len);
 		if (ret) {
 			list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
 			goto unmap_sg;
-- 
1.7.1
