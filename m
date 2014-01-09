From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 10/11] IB/isert: Support T10-PI protected transactions
Date: Thu,  9 Jan 2014 18:40:57 +0200
Message-ID: <1389285658-7037-11-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

In case the Target core passed transport T10 protection
operation:

1. Register data buffer (data memory region)
2. Register protection buffer if exsists (prot memory region)
3. Register signature region (signature memory region)
   - use work request IB_WR_REG_SIG_MR
4. Execute RDMA
5. Upon RDMA completion check the signature status
   - if succeeded send good SCSI response
   - if failed send SCSI bad response with appropriate sense buffer

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  376 ++++++++++++++++++++++++++-----
 1 files changed, 321 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9aa933e..8a888f0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1499,6 +1499,7 @@ isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 	if (wr->fr_desc) {
 		pr_debug("unreg_fastreg_cmd: %p free fr_desc %p\n",
 			 isert_cmd, wr->fr_desc);
+		wr->fr_desc->protected = false;
 		spin_lock_bh(&isert_conn->conn_lock);
 		list_add_tail(&wr->fr_desc->list, &isert_conn->conn_fr_pool);
 		spin_unlock_bh(&isert_conn->conn_lock);
@@ -1604,13 +1605,65 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 }
 
 static void
+isert_pi_err_sense_buffer(u8 *buf, u8 key, u8 asc, u8 ascq)
+{
+	buf[0] = 0x70;
+	buf[SPC_SENSE_KEY_OFFSET] = key;
+	buf[SPC_ASC_KEY_OFFSET] = asc;
+	buf[SPC_ASCQ_KEY_OFFSET] = ascq;
+}
+
+static void
 isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
 			    struct isert_cmd *isert_cmd)
 {
+	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
+	struct ib_mr_status mr_status;
+	int ret;
 
+	if (wr->fr_desc && wr->fr_desc->protected) {
+		ret = ib_check_mr_status(wr->fr_desc->pi_ctx->sig_mr,
+					 IB_MR_CHECK_SIG_STATUS, &mr_status);
+		if (ret) {
+			pr_err("ib_check_mr_status failed, ret %d\n", ret);
+			goto fail_mr_status;
+		}
+		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
+			u32 block_size = se_cmd->se_dev->dev_attrib.block_size;
+
+			pr_err("PI error found type %d at offset %llx "
+			       "expected %x vs actual %x\n",
+			       mr_status.sig_err.err_type,
+			       mr_status.sig_err.sig_err_offset,
+			       mr_status.sig_err.expected,
+			       mr_status.sig_err.actual);
+			switch (mr_status.sig_err.err_type) {
+			case IB_SIG_BAD_GUARD:
+				se_cmd->pi_err = TARGET_GUARD_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_REFTAG:
+				se_cmd->pi_err = TARGET_REFTAG_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_APPTAG:
+				se_cmd->pi_err = TARGET_APPTAG_CHECK_FAILED;
+				break;
+			}
+			se_cmd->block_num =
+				mr_status.sig_err.sig_err_offset / block_size;
+			isert_pi_err_sense_buffer(se_cmd->sense_buffer,
+						  ILLEGAL_REQUEST, 0x10,
+						  (u8)se_cmd->pi_err);
+			se_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
+			se_cmd->scsi_sense_length = TRANSPORT_SENSE_BUFFER;
+			se_cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
+		}
+	}
+
+fail_mr_status:
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	isert_put_response(isert_conn->conn, cmd);
 }
@@ -1624,7 +1677,43 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
+	struct ib_mr_status mr_status;
+	int ret;
 
+	if (wr->fr_desc && wr->fr_desc->protected) {
+		ret = ib_check_mr_status(wr->fr_desc->pi_ctx->sig_mr,
+					 IB_MR_CHECK_SIG_STATUS, &mr_status);
+		if (ret) {
+			pr_err("ib_check_mr_status failed, ret %d\n", ret);
+			goto fail_mr_status;
+		}
+		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
+			u32 block_size = se_cmd->se_dev->dev_attrib.block_size;
+
+			pr_err("PI error found key %x type %d at offset %llx "
+			       "expected %x vs actual %x\n",
+			       mr_status.sig_err.key,
+			       mr_status.sig_err.err_type,
+			       mr_status.sig_err.sig_err_offset,
+			       mr_status.sig_err.expected,
+			       mr_status.sig_err.actual);
+			switch (mr_status.sig_err.err_type) {
+			case IB_SIG_BAD_GUARD:
+				se_cmd->pi_err = TARGET_GUARD_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_REFTAG:
+				se_cmd->pi_err = TARGET_REFTAG_CHECK_FAILED;
+				break;
+			case IB_SIG_BAD_APPTAG:
+				se_cmd->pi_err = TARGET_APPTAG_CHECK_FAILED;
+				break;
+			}
+			se_cmd->block_num =
+				mr_status.sig_err.sig_err_offset / block_size;
+		}
+	}
+
+fail_mr_status:
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	cmd->write_data_done = wr->cur_rdma_length;
@@ -1738,6 +1827,7 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
 		atomic_dec(&isert_conn->post_send_buf_count);
 		isert_completion_rdma_write(tx_desc, isert_cmd);
+		break;
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
 
@@ -2324,6 +2414,128 @@ isert_fast_reg_mr(struct isert_conn *isert_conn, struct ib_mr *mr,
 }
 
 static int
+isert_reg_sig_mr(struct isert_conn *isert_conn, struct se_cmd *se_cmd,
+		 struct pi_context *pi_ctx, struct ib_sge *data_sge,
+		 struct ib_sge *prot_sge, struct ib_sge *sig_sge)
+{
+	struct ib_send_wr sig_wr, inv_wr;
+	struct ib_send_wr *bad_wr, *wr = NULL;
+	struct ib_sig_attrs sig_attrs = {0};
+	int ret;
+	u32 key;
+
+	if (!pi_ctx->sig_key_valid) {
+		memset(&inv_wr, 0, sizeof(inv_wr));
+		inv_wr.opcode = IB_WR_LOCAL_INV;
+		inv_wr.ex.invalidate_rkey = pi_ctx->sig_mr->rkey;
+		wr = &inv_wr;
+		/* Bump the key */
+		key = (u8)(pi_ctx->sig_mr->rkey & 0x000000FF);
+		ib_update_fast_reg_key(pi_ctx->sig_mr, ++key);
+	}
+
+	memset(&sig_wr, 0, sizeof(sig_wr));
+	sig_wr.opcode = IB_WR_REG_SIG_MR;
+	sig_wr.sg_list = data_sge;
+	sig_wr.num_sge = 1;
+	sig_wr.wr.sig_handover.access_flags = IB_ACCESS_LOCAL_WRITE;
+	sig_wr.wr.sig_handover.sig_attrs = &sig_attrs;
+	sig_wr.wr.sig_handover.sig_mr = pi_ctx->sig_mr;
+	if (se_cmd->t_prot_sg)
+		sig_wr.wr.sig_handover.prot = prot_sge;
+	else if (se_cmd->prot_handover == PROT_INTERLEAVED)
+		sig_wr.wr.sig_handover.prot = sig_wr.sg_list;
+
+	/* Set signature attributes */
+	sig_attrs.mem.sig_type = IB_SIG_TYPE_T10_DIF;
+	sig_attrs.wire.sig_type = IB_SIG_TYPE_T10_DIF;
+	sig_attrs.mem.sig.dif.pi_interval =
+	     			se_cmd->se_dev->dev_attrib.block_size;
+    	sig_attrs.wire.sig.dif.pi_interval =
+				se_cmd->se_dev->dev_attrib.block_size;
+
+	switch (se_cmd->prot_op) {
+	case TARGET_PROT_DIN_INSERT:
+	case TARGET_PROT_DOUT_STRIP:
+		sig_attrs.mem.sig.dif.type = IB_T10DIF_NONE;
+		sig_attrs.wire.sig.dif.type = se_cmd->prot_type;
+		sig_attrs.wire.sig.dif.bg_type = IB_T10DIF_CRC;
+		sig_attrs.wire.sig.dif.bg = se_cmd->bg_seed;
+		sig_attrs.wire.sig.dif.app_tag = se_cmd->apptag_seed;
+		sig_attrs.wire.sig.dif.ref_tag = se_cmd->reftag_seed;
+		break;
+	case TARGET_PROT_DOUT_INSERT:
+	case TARGET_PROT_DIN_STRIP:
+		sig_attrs.mem.sig.dif.type = se_cmd->prot_type;
+		sig_attrs.mem.sig.dif.bg_type = se_cmd->bg_type;
+		sig_attrs.mem.sig.dif.bg = se_cmd->bg_seed;
+		sig_attrs.mem.sig.dif.app_tag = se_cmd->apptag_seed;
+		sig_attrs.mem.sig.dif.ref_tag = se_cmd->reftag_seed;
+		sig_attrs.wire.sig.dif.type = IB_T10DIF_NONE;
+		break;
+	case TARGET_PROT_DIN_PASS:
+	case TARGET_PROT_DOUT_PASS:
+		sig_attrs.mem.sig.dif.type = se_cmd->prot_type;
+		sig_attrs.mem.sig.dif.bg_type = se_cmd->bg_type;
+		sig_attrs.mem.sig.dif.bg = se_cmd->bg_seed;
+		sig_attrs.mem.sig.dif.app_tag = se_cmd->apptag_seed;
+		sig_attrs.mem.sig.dif.ref_tag = se_cmd->reftag_seed;
+		sig_attrs.wire.sig.dif.type = se_cmd->prot_type;
+		sig_attrs.wire.sig.dif.bg_type = IB_T10DIF_CRC;
+		sig_attrs.wire.sig.dif.bg = se_cmd->bg_seed;
+		sig_attrs.wire.sig.dif.app_tag = se_cmd->apptag_seed;
+		sig_attrs.wire.sig.dif.ref_tag = se_cmd->reftag_seed;
+		break;
+	default:
+		pr_err("Unsupported PI operation %d\n", se_cmd->prot_op);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	switch (se_cmd->prot_type) {
+	case TARGET_DIF_TYPE0_PROT:
+		sig_attrs.check_mask = 0x0;
+		break;
+	case TARGET_DIF_TYPE1_PROT:
+		sig_attrs.check_mask = 0xcf;
+		break;
+	case TARGET_DIF_TYPE2_PROT:
+		sig_attrs.check_mask = 0xcf;
+		break;
+	case TARGET_DIF_TYPE3_PROT:
+		sig_attrs.check_mask = 0xc0;
+		break;
+	default:
+		pr_err("Unsupported protection type %d\n", se_cmd->prot_type);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!wr)
+		wr = &sig_wr;
+	else
+		wr->next = &sig_wr;
+
+	ret = ib_post_send(isert_conn->conn_qp, wr, &bad_wr);
+	if (ret) {
+		pr_err("fast registration failed, ret:%d\n", ret);
+		goto err;
+	}
+	pi_ctx->sig_key_valid = false;
+
+	sig_sge->lkey = pi_ctx->sig_mr->lkey;
+	sig_sge->addr = 0;
+	sig_sge->length = se_cmd->data_length;
+
+	pr_debug("sig_sge: addr: 0x%16llx  length: %u lkey: %08x\n",
+		 sig_sge->addr, sig_sge->length,
+		 sig_sge->lkey);
+
+err:
+	return ret;
+}
+
+static int
 isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr)
 {
@@ -2332,37 +2544,109 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct ib_send_wr *send_wr;
-	struct ib_sge data_sge;
+	struct ib_sge data_sge, prot_sge = {0}, sig_sge;
 	struct scatterlist *sg_start;
 	struct fast_reg_descriptor *fr_desc;
+	enum dma_data_direction dir;
 	u32 sg_off = 0, sg_nents;
 	u32 offset = 0, data_len, data_left, rdma_write_max;
-	int ret = 0, count;
+	int ret = 0, count, pcount;
 	unsigned long flags;
 
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
+		dir = DMA_TO_DEVICE;
 		data_left = se_cmd->data_length;
 	} else {
+		dir = DMA_FROM_DEVICE;
 		offset = cmd->write_data_done;
 		sg_off = offset / PAGE_SIZE;
 		data_left = se_cmd->data_length - cmd->write_data_done;
-		isert_cmd->tx_desc.isert_cmd = isert_cmd;
 	}
 
+	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
 	sg_nents = se_cmd->t_data_nents - sg_off;
 
-	count = ib_dma_map_sg(ib_dev, sg_start, sg_nents,
-			      (wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-			      DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	wr->sge = sg_start;
+	wr->num_sge = sg_nents;
+	rdma_write_max = ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE;
+	data_len = min(data_left, rdma_write_max);
+	wr->cur_rdma_length = data_len;
+
+	/* dma map data sg */
+	count = ib_dma_map_sg(ib_dev, sg_start, sg_nents, dir);
 	if (unlikely(!count)) {
 		pr_err("Cmd: %p unrable to map SGs\n", isert_cmd);
 		return -EINVAL;
 	}
 	wr->sge = sg_start;
 	wr->num_sge = sg_nents;
-	pr_debug("Mapped cmd: %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
-		 isert_cmd, count, sg_start, sg_nents, data_left);
+	pr_debug("Mapped cmd %p count: %u sg: %p sg_nents: %u rdma_len %d\n",
+		 isert_cmd, count, sg_start, sg_nents, data_len);
+
+	if (count == 1 && se_cmd->prot_type == TARGET_PROT_NORMAL) {
+		wr->s_ib_sge.addr = ib_sg_dma_address(ib_dev, &sg_start[0]);
+		wr->s_ib_sge.length = ib_sg_dma_len(ib_dev, &sg_start[0]);
+		wr->s_ib_sge.lkey = isert_conn->conn_mr->lkey;
+	} else {
+		/* pop fastreg descriptor */
+		spin_lock_irqsave(&isert_conn->conn_lock, flags);
+		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
+					   struct fast_reg_descriptor, list);
+		list_del(&fr_desc->list);
+		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
+		wr->fr_desc = fr_desc;
+        
+		/* fast register data memory */
+		if (se_cmd->prot_handover == PROT_INTERLEAVED)
+			data_len += data_len / 512 * 8;
+		ret = isert_fast_reg_mr(isert_conn, fr_desc->data_mr,
+					fr_desc->data_frpl,
+				        &fr_desc->data_key_valid, sg_start,
+					sg_nents, offset, data_len, &data_sge);
+		if (ret)
+			goto unmap_sg;
+
+		if (se_cmd->prot_type != TARGET_PROT_NORMAL) {
+			/* Protection information */
+			struct pi_context *pi_ctx = fr_desc->pi_ctx;
+        
+			if (se_cmd->t_prot_sg) {
+				/* dma map prot sg */
+				pcount = ib_dma_map_sg(ib_dev, se_cmd->t_prot_sg,
+						       se_cmd->t_prot_nents, dir);
+				if (unlikely(!pcount)) {
+					pr_err("unable to map scatterlist %p\n",
+					       se_cmd->t_prot_sg);
+					ret = -EINVAL;
+					goto unmap_prot_sg;
+				}
+				pr_debug("Mapped cmd %p prot count: %u prot_sg: %p "
+					 "prot_sg_nents: %u prot_len: %d\n",
+					 isert_cmd, pcount, se_cmd->t_prot_sg,
+					 se_cmd->t_prot_nents, se_cmd->prot_length);
+
+				/* fast register data memory */
+				ret = isert_fast_reg_mr(isert_conn, pi_ctx->prot_mr,
+						        pi_ctx->prot_frpl, &pi_ctx->prot_key_valid,
+						        se_cmd->t_prot_sg, se_cmd->t_prot_nents,
+						        0, se_cmd->prot_length, &prot_sge);
+				if (ret)
+					goto unmap_prot_sg;
+			}
+        
+			ret = isert_reg_sig_mr(isert_conn, se_cmd, pi_ctx,
+					       &data_sge, &prot_sge, &sig_sge);
+			if (ret)
+				goto unmap_prot_sg;
+        
+			fr_desc->protected = true;
+			/* record sig_mr ib_sge to RDMA */
+			memcpy(&wr->s_ib_sge, &sig_sge, sizeof(sig_sge));
+		} else
+			/* record data ib_sge to RDMA */
+			memcpy(&wr->s_ib_sge, &data_sge, sizeof(data_sge));
+	}
 
 	wr->ib_sge = &wr->s_ib_sge;
 	wr->send_wr_num = 1;
@@ -2370,18 +2654,19 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	wr->send_wr = &wr->s_send_wr;
 
 	wr->isert_cmd = isert_cmd;
-	rdma_write_max = ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE;
 
 	send_wr = &isert_cmd->rdma_wr.s_send_wr;
 	send_wr->sg_list = &wr->s_ib_sge;
 	send_wr->num_sge = 1;
+	pr_debug("RDMA addr %llx length %x lkey %04x\n",
+	       send_wr->sg_list->addr, send_wr->sg_list->length, send_wr->sg_list->lkey);
 	send_wr->wr_id = (unsigned long)&isert_cmd->tx_desc;
 	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
 		send_wr->opcode = IB_WR_RDMA_WRITE;
 		send_wr->wr.rdma.remote_addr = isert_cmd->read_va;
 		send_wr->wr.rdma.rkey = isert_cmd->read_stag;
-		send_wr->send_flags = 0;
-		send_wr->next = &isert_cmd->tx_desc.send_wr;
+		send_wr->send_flags = se_cmd->prot_type == TARGET_PROT_NORMAL ?
+				      0 : IB_SEND_SIGNALED;
 	} else {
 		send_wr->opcode = IB_WR_RDMA_READ;
 		send_wr->wr.rdma.remote_addr = isert_cmd->write_va;
@@ -2389,40 +2674,14 @@ isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		send_wr->send_flags = IB_SEND_SIGNALED;
 	}
 
-	data_len = min(data_left, rdma_write_max);
-	wr->cur_rdma_length = data_len;
-
-	/* if there is a single dma entry, dma mr is sufficient */
-	if (count == 1) {
-		wr->s_ib_sge.addr = ib_sg_dma_address(ib_dev, &sg_start[0]);
-		wr->s_ib_sge.length = ib_sg_dma_len(ib_dev, &sg_start[0]);
-		wr->s_ib_sge.lkey = isert_conn->conn_mr->lkey;
-		wr->fr_desc = NULL;
-	} else {
-		spin_lock_irqsave(&isert_conn->conn_lock, flags);
-		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
-					   struct fast_reg_descriptor, list);
-		list_del(&fr_desc->list);
-		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
-		wr->fr_desc = fr_desc;
-
-		ret = isert_fast_reg_mr(isert_conn, fr_desc->data_mr,
-					fr_desc->data_frpl,
-					&fr_desc->data_key_valid, sg_start,
-					sg_nents, offset, data_len, &data_sge);
-		if (ret) {
-			list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
-			goto unmap_sg;
-		}
-		memcpy(&wr->s_ib_sge, &data_sge, sizeof(data_sge));
-	}
-
 	return 0;
-
+unmap_prot_sg:
+	if (se_cmd->t_prot_sg)
+		ib_dma_unmap_sg(ib_dev, se_cmd->t_prot_sg,
+				se_cmd->t_prot_nents, dir);
 unmap_sg:
-	ib_dma_unmap_sg(ib_dev, sg_start, sg_nents,
-			(wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
-			DMA_TO_DEVICE : DMA_FROM_DEVICE);
+	list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
+	ib_dma_unmap_sg(ib_dev, sg_start, sg_nents, dir);
 	return ret;
 }
 
@@ -2446,26 +2705,33 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		return rc;
 	}
 
-	/*
-	 * Build isert_conn->tx_desc for iSCSI response PDU and attach
-	 */
-	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
-	iscsit_build_rsp_pdu(cmd, conn, true, (struct iscsi_scsi_rsp *)
-			     &isert_cmd->tx_desc.iscsi_header);
-	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
-	isert_init_send_wr(isert_conn, isert_cmd,
-			   &isert_cmd->tx_desc.send_wr, true);
+	if (se_cmd->prot_type == TARGET_PROT_NORMAL) {
+		/*
+		 * Build isert_conn->tx_desc for iSCSI response PDU and attach
+		 */
+		isert_create_send_desc(isert_conn, isert_cmd,
+				       &isert_cmd->tx_desc);
+		iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
+				     &isert_cmd->tx_desc.iscsi_header);
+		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
+		isert_init_send_wr(isert_conn, isert_cmd,
+				   &isert_cmd->tx_desc.send_wr, true);
+		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
+	}
 
 	atomic_inc(&isert_conn->post_send_buf_count);
-
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
 		atomic_dec(&isert_conn->post_send_buf_count);
 	}
-	pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data READ\n",
-		 isert_cmd);
 
+	if (se_cmd->prot_type == TARGET_PROT_NORMAL)
+		pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data "
+			 "READ\n", isert_cmd);
+	else
+		pr_debug("Cmd: %p posted RDMA_WRITE for iSER Data READ\n",
+			 isert_cmd);
 	return 1;
 }
 
-- 
1.7.1
