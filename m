From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 02/14] target: Add target_iomem descriptor
Date: Wed,  1 Jun 2016 21:48:35 +0000
Message-ID: <1464817727-9125-3-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch introduces a new struct target_iomem descriptor
containing scatterlist memory + scatterlist counts within
existing struct se_cmd.

This includes:

    - t_data_* // Used to store READ/WRITE payloads
    - t_data_*_orig // Used to store COMPARE_AND_WRITE payload
    - t_data_vmap // Used to map payload for CONTROL CDB emulation
    - t_bidi_data_* // Used for bidirectional READ payload
    - t_prot_* // Used for T10-PI payload

It also includes the associated mechanical conversion tree-wide
within target backend and fabric driver code.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c     | 24 +++----
 drivers/scsi/qla2xxx/qla_target.c           |  4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          | 19 +++---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c    |  4 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 10 +--
 drivers/target/iscsi/iscsi_target.c         |  4 +-
 drivers/target/sbp/sbp_target.c             |  4 +-
 drivers/target/target_core_file.c           | 24 +++----
 drivers/target/target_core_iblock.c         | 15 +++--
 drivers/target/target_core_pscsi.c          |  4 +-
 drivers/target/target_core_rd.c             |  2 +-
 drivers/target/target_core_sbc.c            | 49 +++++++-------
 drivers/target/target_core_transport.c      | 99 +++++++++++++++--------------
 drivers/target/target_core_user.c           | 21 +++---
 drivers/target/target_core_xcopy.c          | 17 ++---
 drivers/target/tcm_fc/tfc_cmd.c             |  8 +--
 drivers/target/tcm_fc/tfc_io.c              | 11 ++--
 drivers/usb/gadget/function/f_tcm.c         | 28 ++++----
 include/target/target_core_base.h           | 28 +++++---
 19 files changed, 199 insertions(+), 176 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a990c04..2c41a8b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1128,14 +1128,14 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 
 	if (imm_data_len != data_len) {
 		sg_nents = max(1UL, DIV_ROUND_UP(imm_data_len, PAGE_SIZE));
-		sg_copy_from_buffer(cmd->se_cmd.t_data_sg, sg_nents,
+		sg_copy_from_buffer(cmd->se_cmd.t_iomem.t_data_sg, sg_nents,
 				    &rx_desc->data[0], imm_data_len);
 		isert_dbg("Copy Immediate sg_nents: %u imm_data_len: %d\n",
 			  sg_nents, imm_data_len);
 	} else {
 		sg_init_table(&isert_cmd->sg, 1);
-		cmd->se_cmd.t_data_sg = &isert_cmd->sg;
-		cmd->se_cmd.t_data_nents = 1;
+		cmd->se_cmd.t_iomem.t_data_sg = &isert_cmd->sg;
+		cmd->se_cmd.t_iomem.t_data_nents = 1;
 		sg_set_buf(&isert_cmd->sg, &rx_desc->data[0], imm_data_len);
 		isert_dbg("Transfer Immediate imm_data_len: %d\n",
 			  imm_data_len);
@@ -1192,7 +1192,7 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 		  cmd->se_cmd.data_length);
 
 	sg_off = cmd->write_data_done / PAGE_SIZE;
-	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
+	sg_start = &cmd->se_cmd.t_iomem.t_data_sg[sg_off];
 	sg_nents = max(1UL, DIV_ROUND_UP(unsol_data_len, PAGE_SIZE));
 	page_off = cmd->write_data_done % PAGE_SIZE;
 	/*
@@ -1463,6 +1463,7 @@ static void
 isert_rdma_rw_ctx_destroy(struct isert_cmd *cmd, struct isert_conn *conn)
 {
 	struct se_cmd *se_cmd = &cmd->iscsi_cmd->se_cmd;
+	struct target_iomem *iomem = &se_cmd->t_iomem;
 	enum dma_data_direction dir = target_reverse_dma_direction(se_cmd);
 
 	if (!cmd->rw.nr_ops)
@@ -1470,12 +1471,12 @@ isert_rdma_rw_ctx_destroy(struct isert_cmd *cmd, struct isert_conn *conn)
 
 	if (isert_prot_cmd(conn, se_cmd)) {
 		rdma_rw_ctx_destroy_signature(&cmd->rw, conn->qp,
-				conn->cm_id->port_num, se_cmd->t_data_sg,
-				se_cmd->t_data_nents, se_cmd->t_prot_sg,
-				se_cmd->t_prot_nents, dir);
+				conn->cm_id->port_num, iomem->t_data_sg,
+				iomem->t_data_nents, iomem->t_prot_sg,
+				iomem->t_prot_nents, dir);
 	} else {
 		rdma_rw_ctx_destroy(&cmd->rw, conn->qp, conn->cm_id->port_num,
-				se_cmd->t_data_sg, se_cmd->t_data_nents, dir);
+				iomem->t_data_sg, iomem->t_data_nents, dir);
 	}
 
 	cmd->rw.nr_ops = 0;
@@ -2076,6 +2077,7 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 		struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
 {
 	struct se_cmd *se_cmd = &cmd->iscsi_cmd->se_cmd;
+	struct target_iomem *iomem = &se_cmd->t_iomem;
 	enum dma_data_direction dir = target_reverse_dma_direction(se_cmd);
 	u8 port_num = conn->cm_id->port_num;
 	u64 addr;
@@ -2101,12 +2103,12 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 
 		WARN_ON_ONCE(offset);
 		ret = rdma_rw_ctx_signature_init(&cmd->rw, conn->qp, port_num,
-				se_cmd->t_data_sg, se_cmd->t_data_nents,
-				se_cmd->t_prot_sg, se_cmd->t_prot_nents,
+				iomem->t_data_sg, iomem->t_data_nents,
+				iomem->t_prot_sg, iomem->t_prot_nents,
 				&sig_attrs, addr, rkey, dir);
 	} else {
 		ret = rdma_rw_ctx_init(&cmd->rw, conn->qp, port_num,
-				se_cmd->t_data_sg, se_cmd->t_data_nents,
+				iomem->t_data_sg, iomem->t_data_nents,
 				offset, addr, rkey, dir);
 	}
 	if (ret < 0) {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ca39deb..f93bd5f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4903,8 +4903,8 @@ restart:
 		}
 		se_cmd = &cmd->se_cmd;
 
-		cmd->sg_cnt = se_cmd->t_data_nents;
-		cmd->sg = se_cmd->t_data_sg;
+		cmd->sg_cnt = se_cmd->t_iomem.t_data_nents;
+		cmd->sg = se_cmd->t_iomem.t_data_sg;
 
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
 		       "SRR cmd %p (se_cmd %p, tag %lld, op %x), sg_cnt=%d, offset=%d",
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..dace993 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -381,11 +381,11 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
-	cmd->sg_cnt = se_cmd->t_data_nents;
-	cmd->sg = se_cmd->t_data_sg;
+	cmd->sg_cnt = se_cmd->t_iomem.t_data_nents;
+	cmd->sg = se_cmd->t_iomem.t_data_sg;
 
-	cmd->prot_sg_cnt = se_cmd->t_prot_nents;
-	cmd->prot_sg = se_cmd->t_prot_sg;
+	cmd->prot_sg_cnt = se_cmd->t_iomem.t_prot_nents;
+	cmd->prot_sg = se_cmd->t_iomem.t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
 
@@ -595,12 +595,12 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
-	cmd->sg_cnt = se_cmd->t_data_nents;
-	cmd->sg = se_cmd->t_data_sg;
+	cmd->sg_cnt = se_cmd->t_iomem.t_data_nents;
+	cmd->sg = se_cmd->t_iomem.t_data_sg;
 	cmd->offset = 0;
 
-	cmd->prot_sg_cnt = se_cmd->t_prot_nents;
-	cmd->prot_sg = se_cmd->t_prot_sg;
+	cmd->prot_sg_cnt = se_cmd->t_iomem.t_prot_nents;
+	cmd->prot_sg = se_cmd->t_iomem.t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
 
@@ -1817,7 +1817,8 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.node_acl_size			= sizeof(struct tcm_qla2xxx_nacl),
 	/*
 	 * XXX: Limit assumes single page per scatter-gather-list entry.
-	 * Current maximum is ~4.9 MB per se_cmd->t_data_sg with PAGE_SIZE=4096
+	 * Current maximum is ~4.9 MB per se_cmd->t_iomem.t_data_sg with
+	 * PAGE_SIZE=4096
 	 */
 	.max_data_sg_nents		= 1200,
 	.get_fabric_name		= tcm_qla2xxx_get_fabric_name,
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 5d78bdb..a0c94b4 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -245,8 +245,8 @@ cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	ccmd->setup_ddp = false;
 
-	ttinfo->sgl = cmd->se_cmd.t_data_sg;
-	ttinfo->nents = cmd->se_cmd.t_data_nents;
+	ttinfo->sgl = cmd->se_cmd.t_iomem.t_data_sg;
+	ttinfo->nents = cmd->se_cmd.t_iomem.t_data_nents;
 
 	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.data_length);
 	if (ret < 0) {
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index d02bf58..ac86574 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -368,7 +368,7 @@ cxgbit_map_skb(struct iscsi_cmd *cmd, struct sk_buff *skb, u32 data_offset,
 	/*
 	 * We know each entry in t_data_sg contains a page.
 	 */
-	sg = &cmd->se_cmd.t_data_sg[data_offset / PAGE_SIZE];
+	sg = &cmd->se_cmd.t_iomem.t_data_sg[data_offset / PAGE_SIZE];
 	page_off = (data_offset % PAGE_SIZE);
 
 	while (data_length && (i < nr_frags)) {
@@ -864,12 +864,12 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 			    dfrag->page_offset);
 		get_page(dfrag->page.p);
 
-		cmd->se_cmd.t_data_sg = &ccmd->sg;
-		cmd->se_cmd.t_data_nents = 1;
+		cmd->se_cmd.t_iomem.t_data_sg = &ccmd->sg;
+		cmd->se_cmd.t_iomem.t_data_nents = 1;
 
 		ccmd->release = true;
 	} else {
-		struct scatterlist *sg = &cmd->se_cmd.t_data_sg[0];
+		struct scatterlist *sg = &cmd->se_cmd.t_iomem.t_data_sg[0];
 		u32 sg_nents = max(1UL, DIV_ROUND_UP(pdu_cb->dlen, PAGE_SIZE));
 
 		cxgbit_skb_copy_to_sg(csk->skb, sg, sg_nents);
@@ -1005,7 +1005,7 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 
 	if (!(pdu_cb->flags & PDUCBF_RX_DATA_DDPD)) {
 		sg_off = data_offset / PAGE_SIZE;
-		sg_start = &cmd->se_cmd.t_data_sg[sg_off];
+		sg_start = &cmd->se_cmd.t_iomem.t_data_sg[sg_off];
 		sg_nents = max(1UL, DIV_ROUND_UP(data_len, PAGE_SIZE));
 
 		cxgbit_skb_copy_to_sg(csk->skb, sg_start, sg_nents);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 50f3d3a..44388e3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -907,12 +907,12 @@ static int iscsit_map_iovec(
 	 */
 	u32 ent = data_offset / PAGE_SIZE;
 
-	if (ent >= cmd->se_cmd.t_data_nents) {
+	if (ent >= cmd->se_cmd.t_iomem.t_data_nents) {
 		pr_err("Initial page entry out-of-bounds\n");
 		return -1;
 	}
 
-	sg = &cmd->se_cmd.t_data_sg[ent];
+	sg = &cmd->se_cmd.t_iomem.t_data_sg[ent];
 	page_off = (data_offset % PAGE_SIZE);
 
 	cmd->first_data_sg = sg;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 58bb6ed..dcc6eba 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1299,8 +1299,8 @@ static int sbp_rw_data(struct sbp_target_request *req)
 		length = req->se_cmd.data_length;
 	}
 
-	sg_miter_start(&iter, req->se_cmd.t_data_sg, req->se_cmd.t_data_nents,
-		sg_miter_flags);
+	sg_miter_start(&iter, req->se_cmd.t_iomem.t_data_sg,
+		       req->se_cmd.t_iomem.t_data_nents, sg_miter_flags);
 
 	while (length || num_pte) {
 		if (!length) {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 75f0f08..033c6a8 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -375,12 +375,12 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	if (cmd->t_data_nents > 1 ||
-	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
+	if (cmd->t_iomem.t_data_nents > 1 ||
+	    cmd->t_iomem.t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
 			" block_size: %u\n",
-			cmd->t_data_nents,
-			cmd->t_data_sg[0].length,
+			cmd->t_iomem.t_data_nents,
+			cmd->t_iomem.t_data_sg[0].length,
 			cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -390,9 +390,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	for (i = 0; i < nolb; i++) {
-		bvec[i].bv_page = sg_page(&cmd->t_data_sg[0]);
-		bvec[i].bv_len = cmd->t_data_sg[0].length;
-		bvec[i].bv_offset = cmd->t_data_sg[0].offset;
+		bvec[i].bv_page = sg_page(&cmd->t_iomem.t_data_sg[0]);
+		bvec[i].bv_len = cmd->t_iomem.t_data_sg[0].length;
+		bvec[i].bv_offset = cmd->t_iomem.t_data_sg[0].offset;
 
 		len += se_dev->dev_attrib.block_size;
 	}
@@ -534,7 +534,8 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (data_direction == DMA_FROM_DEVICE) {
 		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_rw(cmd, pfile, dev->prot_length,
-				       cmd->t_prot_sg, cmd->t_prot_nents,
+				       cmd->t_iomem.t_prot_sg,
+				       cmd->t_iomem.t_prot_nents,
 				       cmd->prot_length, 0);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -548,7 +549,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					ilog2(dev->dev_attrib.block_size);
 
 			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
-					    0, cmd->t_prot_sg, 0);
+					    0, cmd->t_iomem.t_prot_sg, 0);
 			if (rc)
 				return rc;
 		}
@@ -558,7 +559,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					ilog2(dev->dev_attrib.block_size);
 
 			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
-					    0, cmd->t_prot_sg, 0);
+					    0, cmd->t_iomem.t_prot_sg, 0);
 			if (rc)
 				return rc;
 		}
@@ -585,7 +586,8 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_rw(cmd, pfile, dev->prot_length,
-				       cmd->t_prot_sg, cmd->t_prot_nents,
+				       cmd->t_iomem.t_prot_sg,
+				       cmd->t_iomem.t_prot_nents,
 				       cmd->prot_length, 1);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7c4efb4..80ad456 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -416,7 +416,7 @@ static sense_reason_t
 iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct scatterlist *sg = &cmd->t_data_sg[0];
+	struct scatterlist *sg = &cmd->t_iomem.t_data_sg[0];
 	struct page *page = NULL;
 	int ret;
 
@@ -424,7 +424,8 @@ iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
 			return TCM_OUT_OF_RESOURCES;
-		sg_copy_to_buffer(sg, cmd->t_data_nents, page_address(page),
+		sg_copy_to_buffer(sg, cmd->t_iomem.t_data_nents,
+				  page_address(page),
 				  dev->dev_attrib.block_size);
 	}
 
@@ -460,12 +461,12 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-	sg = &cmd->t_data_sg[0];
+	sg = &cmd->t_iomem.t_data_sg[0];
 
-	if (cmd->t_data_nents > 1 ||
+	if (cmd->t_iomem.t_data_nents > 1 ||
 	    sg->length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			" block_size: %u\n", cmd->t_data_nents, sg->length,
+			" block_size: %u\n", cmd->t_iomem.t_data_nents, sg->length,
 			cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -636,7 +637,7 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 		return -ENODEV;
 	}
 
-	bip = bio_integrity_alloc(bio, GFP_NOIO, cmd->t_prot_nents);
+	bip = bio_integrity_alloc(bio, GFP_NOIO, cmd->t_iomem.t_prot_nents);
 	if (IS_ERR(bip)) {
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
@@ -649,7 +650,7 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
 
-	for_each_sg(cmd->t_prot_sg, sg, cmd->t_prot_nents, i) {
+	for_each_sg(cmd->t_iomem.t_prot_sg, sg, cmd->t_iomem.t_prot_nents, i) {
 
 		rc = bio_integrity_add_page(bio, sg_page(sg), sg->length,
 					    sg->offset);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de18790..75041dd 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -990,8 +990,8 @@ pscsi_parse_cdb(struct se_cmd *cmd)
 static sense_reason_t
 pscsi_execute_cmd(struct se_cmd *cmd)
 {
-	struct scatterlist *sgl = cmd->t_data_sg;
-	u32 sgl_nents = cmd->t_data_nents;
+	struct scatterlist *sgl = cmd->t_iomem.t_data_sg;
+	u32 sgl_nents = cmd->t_iomem.t_data_nents;
 	enum dma_data_direction data_direction = cmd->data_direction;
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
 	struct pscsi_plugin_task *pt;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 24b36fd..d840281 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -426,7 +426,7 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 				    prot_sg, prot_offset);
 	else
 		rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors, 0,
-				    cmd->t_prot_sg, 0);
+				    cmd->t_iomem.t_prot_sg, 0);
 
 	if (!rc)
 		sbc_dif_copy_prot(cmd, sectors, is_read, prot_sg, prot_offset);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 04f616b..c80a225 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -404,11 +404,11 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 		return TCM_OUT_OF_RESOURCES;
 	}
 	/*
-	 * Copy the scatterlist WRITE buffer located at cmd->t_data_sg
+	 * Copy the scatterlist WRITE buffer located at cmd->t_iomem.t_data_sg
 	 * into the locally allocated *buf
 	 */
-	sg_copy_to_buffer(cmd->t_data_sg,
-			  cmd->t_data_nents,
+	sg_copy_to_buffer(cmd->t_iomem.t_data_sg,
+			  cmd->t_iomem.t_data_nents,
 			  buf,
 			  cmd->data_length);
 
@@ -418,7 +418,8 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 	 */
 
 	offset = 0;
-	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
+	for_each_sg(cmd->t_iomem.t_bidi_data_sg, sg,
+		    cmd->t_iomem.t_bidi_data_nents, count) {
 		addr = kmap_atomic(sg_page(sg));
 		if (!addr) {
 			ret = TCM_OUT_OF_RESOURCES;
@@ -442,7 +443,7 @@ sbc_execute_rw(struct se_cmd *cmd)
 {
 	struct sbc_ops *ops = cmd->protocol_data;
 
-	return ops->execute_rw(cmd, cmd->t_data_sg, cmd->t_data_nents,
+	return ops->execute_rw(cmd, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
 			       cmd->data_direction);
 }
 
@@ -490,7 +491,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * Handle early failure in transport_generic_request_failure(),
 	 * which will not have taken ->caw_sem yet..
 	 */
-	if (!success && (!cmd->t_data_sg || !cmd->t_bidi_data_sg))
+	if (!success && (!cmd->t_iomem.t_data_sg || !cmd->t_iomem.t_bidi_data_sg))
 		return TCM_NO_SENSE;
 	/*
 	 * Handle special case for zero-length COMPARE_AND_WRITE
@@ -514,19 +515,19 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		goto out;
 	}
 
-	write_sg = kmalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
+	write_sg = kmalloc(sizeof(struct scatterlist) * cmd->t_iomem.t_data_nents,
 			   GFP_KERNEL);
 	if (!write_sg) {
 		pr_err("Unable to allocate compare_and_write sg\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
-	sg_init_table(write_sg, cmd->t_data_nents);
+	sg_init_table(write_sg, cmd->t_iomem.t_data_nents);
 	/*
 	 * Setup verify and write data payloads from total NumberLBAs.
 	 */
-	rc = sg_copy_to_buffer(cmd->t_data_sg, cmd->t_data_nents, buf,
-			       cmd->data_length);
+	rc = sg_copy_to_buffer(cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
+			       buf, cmd->data_length);
 	if (!rc) {
 		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
 		ret = TCM_OUT_OF_RESOURCES;
@@ -535,7 +536,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	/*
 	 * Compare against SCSI READ payload against verify payload
 	 */
-	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, i) {
+	for_each_sg(cmd->t_iomem.t_bidi_data_sg, sg,
+		    cmd->t_iomem.t_bidi_data_nents, i) {
 		addr = (unsigned char *)kmap_atomic(sg_page(sg));
 		if (!addr) {
 			ret = TCM_OUT_OF_RESOURCES;
@@ -560,7 +562,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 
 	i = 0;
 	len = cmd->t_task_nolb * block_size;
-	sg_miter_start(&m, cmd->t_data_sg, cmd->t_data_nents, SG_MITER_TO_SG);
+	sg_miter_start(&m, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
+		       SG_MITER_TO_SG);
 	/*
 	 * Currently assumes NoLB=1 and SGLs are PAGE_SIZE..
 	 */
@@ -584,10 +587,10 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * assignments, to be released in transport_free_pages() ->
 	 * transport_reset_sgl_orig()
 	 */
-	cmd->t_data_sg_orig = cmd->t_data_sg;
-	cmd->t_data_sg = write_sg;
-	cmd->t_data_nents_orig = cmd->t_data_nents;
-	cmd->t_data_nents = 1;
+	cmd->t_iomem.t_data_sg_orig = cmd->t_iomem.t_data_sg;
+	cmd->t_iomem.t_data_sg = write_sg;
+	cmd->t_iomem.t_data_nents_orig = cmd->t_iomem.t_data_nents;
+	cmd->t_iomem.t_data_nents = 1;
 
 	cmd->sam_task_attr = TCM_HEAD_TAG;
 	cmd->transport_complete_callback = compare_and_write_post;
@@ -645,8 +648,8 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	 */
 	cmd->data_length = cmd->t_task_nolb * dev->dev_attrib.block_size;
 
-	ret = ops->execute_rw(cmd, cmd->t_bidi_data_sg, cmd->t_bidi_data_nents,
-			      DMA_FROM_DEVICE);
+	ret = ops->execute_rw(cmd, cmd->t_iomem.t_bidi_data_sg,
+			      cmd->t_iomem.t_bidi_data_nents, DMA_FROM_DEVICE);
 	if (ret) {
 		cmd->transport_complete_callback = NULL;
 		up(&dev->caw_sem);
@@ -730,7 +733,7 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 	int pi_prot_type = dev->dev_attrib.pi_prot_type;
 	bool fabric_prot = false;
 
-	if (!cmd->t_prot_sg || !cmd->t_prot_nents) {
+	if (!cmd->t_iomem.t_prot_sg || !cmd->t_iomem.t_prot_nents) {
 		if (unlikely(protect &&
 		    !dev->dev_attrib.pi_prot_type && !cmd->se_sess->sess_prot_type)) {
 			pr_err("CDB contains protect bit, but device + fabric does"
@@ -1244,13 +1247,13 @@ sbc_dif_generate(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct t10_pi_tuple *sdt;
-	struct scatterlist *dsg = cmd->t_data_sg, *psg;
+	struct scatterlist *dsg = cmd->t_iomem.t_data_sg, *psg;
 	sector_t sector = cmd->t_task_lba;
 	void *daddr, *paddr;
 	int i, j, offset = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
+	for_each_sg(cmd->t_iomem.t_prot_sg, psg, cmd->t_iomem.t_prot_nents, i) {
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
 		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
 
@@ -1362,7 +1365,7 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 
 	left = sectors * dev->prot_length;
 
-	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
+	for_each_sg(cmd->t_iomem.t_prot_sg, psg, cmd->t_iomem.t_prot_nents, i) {
 		unsigned int psg_len, copied = 0;
 
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
@@ -1399,7 +1402,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 {
 	struct se_device *dev = cmd->se_dev;
 	struct t10_pi_tuple *sdt;
-	struct scatterlist *dsg = cmd->t_data_sg;
+	struct scatterlist *dsg = cmd->t_iomem.t_data_sg;
 	sector_t sector = start;
 	void *daddr, *paddr;
 	int i;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 614ef3f..e1e7c49 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -720,7 +720,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	if (dev && dev->transport->transport_complete) {
 		dev->transport->transport_complete(cmd,
-				cmd->t_data_sg,
+				cmd->t_iomem.t_data_sg,
 				transport_get_sense_buffer(cmd));
 		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
 			success = 1;
@@ -1400,10 +1400,10 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-	cmd->t_data_sg = sgl;
-	cmd->t_data_nents = sgl_count;
-	cmd->t_bidi_data_sg = sgl_bidi;
-	cmd->t_bidi_data_nents = sgl_bidi_count;
+	cmd->t_iomem.t_data_sg = sgl;
+	cmd->t_iomem.t_data_nents = sgl_count;
+	cmd->t_iomem.t_bidi_data_sg = sgl_bidi;
+	cmd->t_iomem.t_bidi_data_nents = sgl_bidi_count;
 
 	cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 	return 0;
@@ -1503,8 +1503,8 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 * if present.
 	 */
 	if (sgl_prot_count) {
-		se_cmd->t_prot_sg = sgl_prot;
-		se_cmd->t_prot_nents = sgl_prot_count;
+		se_cmd->t_iomem.t_prot_sg = sgl_prot;
+		se_cmd->t_iomem.t_prot_nents = sgl_prot_count;
 		se_cmd->se_cmd_flags |= SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC;
 	}
 
@@ -1821,7 +1821,7 @@ static int target_write_prot_action(struct se_cmd *cmd)
 
 		sectors = cmd->data_length >> ilog2(cmd->se_dev->dev_attrib.block_size);
 		cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
-					     sectors, 0, cmd->t_prot_sg, 0);
+					     sectors, 0, cmd->t_iomem.t_prot_sg, 0);
 		if (unlikely(cmd->pi_err)) {
 			spin_lock_irq(&cmd->t_state_lock);
 			cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
@@ -2051,8 +2051,8 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 				  ilog2(cmd->se_dev->dev_attrib.block_size);
 
 			cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
-						     sectors, 0, cmd->t_prot_sg,
-						     0);
+						     sectors, 0,
+						     cmd->t_iomem.t_prot_sg, 0);
 			if (cmd->pi_err)
 				return true;
 		}
@@ -2216,22 +2216,22 @@ static inline void transport_reset_sgl_orig(struct se_cmd *cmd)
 	 * Check for saved t_data_sg that may be used for COMPARE_AND_WRITE
 	 * emulation, and free + reset pointers if necessary..
 	 */
-	if (!cmd->t_data_sg_orig)
+	if (!cmd->t_iomem.t_data_sg_orig)
 		return;
 
-	kfree(cmd->t_data_sg);
-	cmd->t_data_sg = cmd->t_data_sg_orig;
-	cmd->t_data_sg_orig = NULL;
-	cmd->t_data_nents = cmd->t_data_nents_orig;
-	cmd->t_data_nents_orig = 0;
+	kfree(cmd->t_iomem.t_data_sg);
+	cmd->t_iomem.t_data_sg = cmd->t_iomem.t_data_sg_orig;
+	cmd->t_iomem.t_data_sg_orig = NULL;
+	cmd->t_iomem.t_data_nents = cmd->t_iomem.t_data_nents_orig;
+	cmd->t_iomem.t_data_nents_orig = 0;
 }
 
 static inline void transport_free_pages(struct se_cmd *cmd)
 {
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
-		target_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
-		cmd->t_prot_sg = NULL;
-		cmd->t_prot_nents = 0;
+		target_free_sgl(cmd->t_iomem.t_prot_sg, cmd->t_iomem.t_prot_nents);
+		cmd->t_iomem.t_prot_sg = NULL;
+		cmd->t_iomem.t_prot_nents = 0;
 	}
 
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) {
@@ -2240,23 +2240,23 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		 * SG_TO_MEM_NOALLOC to function with COMPARE_AND_WRITE
 		 */
 		if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) {
-			target_free_sgl(cmd->t_bidi_data_sg,
-					   cmd->t_bidi_data_nents);
-			cmd->t_bidi_data_sg = NULL;
-			cmd->t_bidi_data_nents = 0;
+			target_free_sgl(cmd->t_iomem.t_bidi_data_sg,
+					cmd->t_iomem.t_bidi_data_nents);
+			cmd->t_iomem.t_bidi_data_sg = NULL;
+			cmd->t_iomem.t_bidi_data_nents = 0;
 		}
 		transport_reset_sgl_orig(cmd);
 		return;
 	}
 	transport_reset_sgl_orig(cmd);
 
-	target_free_sgl(cmd->t_data_sg, cmd->t_data_nents);
-	cmd->t_data_sg = NULL;
-	cmd->t_data_nents = 0;
+	target_free_sgl(cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents);
+	cmd->t_iomem.t_data_sg = NULL;
+	cmd->t_iomem.t_data_nents = 0;
 
-	target_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
-	cmd->t_bidi_data_sg = NULL;
-	cmd->t_bidi_data_nents = 0;
+	target_free_sgl(cmd->t_iomem.t_bidi_data_sg, cmd->t_iomem.t_bidi_data_nents);
+	cmd->t_iomem.t_bidi_data_sg = NULL;
+	cmd->t_iomem.t_bidi_data_nents = 0;
 }
 
 /**
@@ -2277,7 +2277,7 @@ static int transport_put_cmd(struct se_cmd *cmd)
 
 void *transport_kmap_data_sg(struct se_cmd *cmd)
 {
-	struct scatterlist *sg = cmd->t_data_sg;
+	struct scatterlist *sg = cmd->t_iomem.t_data_sg;
 	struct page **pages;
 	int i;
 
@@ -2286,43 +2286,44 @@ void *transport_kmap_data_sg(struct se_cmd *cmd)
 	 * tcm_loop who may be using a contig buffer from the SCSI midlayer for
 	 * control CDBs passed as SGLs via transport_generic_map_mem_to_cmd()
 	 */
-	if (!cmd->t_data_nents)
+	if (!cmd->t_iomem.t_data_nents)
 		return NULL;
 
 	BUG_ON(!sg);
-	if (cmd->t_data_nents == 1)
+	if (cmd->t_iomem.t_data_nents == 1)
 		return kmap(sg_page(sg)) + sg->offset;
 
 	/* >1 page. use vmap */
-	pages = kmalloc(sizeof(*pages) * cmd->t_data_nents, GFP_KERNEL);
+	pages = kmalloc(sizeof(*pages) * cmd->t_iomem.t_data_nents, GFP_KERNEL);
 	if (!pages)
 		return NULL;
 
 	/* convert sg[] to pages[] */
-	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i) {
+	for_each_sg(cmd->t_iomem.t_data_sg, sg, cmd->t_iomem.t_data_nents, i) {
 		pages[i] = sg_page(sg);
 	}
 
-	cmd->t_data_vmap = vmap(pages, cmd->t_data_nents,  VM_MAP, PAGE_KERNEL);
+	cmd->t_iomem.t_data_vmap = vmap(pages, cmd->t_iomem.t_data_nents,
+					VM_MAP, PAGE_KERNEL);
 	kfree(pages);
-	if (!cmd->t_data_vmap)
+	if (!cmd->t_iomem.t_data_vmap)
 		return NULL;
 
-	return cmd->t_data_vmap + cmd->t_data_sg[0].offset;
+	return cmd->t_iomem.t_data_vmap + cmd->t_iomem.t_data_sg[0].offset;
 }
 EXPORT_SYMBOL(transport_kmap_data_sg);
 
 void transport_kunmap_data_sg(struct se_cmd *cmd)
 {
-	if (!cmd->t_data_nents) {
+	if (!cmd->t_iomem.t_data_nents) {
 		return;
-	} else if (cmd->t_data_nents == 1) {
-		kunmap(sg_page(cmd->t_data_sg));
+	} else if (cmd->t_iomem.t_data_nents == 1) {
+		kunmap(sg_page(cmd->t_iomem.t_data_sg));
 		return;
 	}
 
-	vunmap(cmd->t_data_vmap);
-	cmd->t_data_vmap = NULL;
+	vunmap(cmd->t_iomem.t_data_vmap);
+	cmd->t_iomem.t_data_vmap = NULL;
 }
 EXPORT_SYMBOL(transport_kunmap_data_sg);
 
@@ -2382,7 +2383,8 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 
 	if (cmd->prot_op != TARGET_PROT_NORMAL &&
 	    !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
-		ret = target_alloc_sgl(&cmd->t_prot_sg, &cmd->t_prot_nents,
+		ret = target_alloc_sgl(&cmd->t_iomem.t_prot_sg,
+				       &cmd->t_iomem.t_prot_nents,
 				       cmd->prot_length, true, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2406,14 +2408,15 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 			else
 				bidi_length = cmd->data_length;
 
-			ret = target_alloc_sgl(&cmd->t_bidi_data_sg,
-					       &cmd->t_bidi_data_nents,
+			ret = target_alloc_sgl(&cmd->t_iomem.t_bidi_data_sg,
+					       &cmd->t_iomem.t_bidi_data_nents,
 					       bidi_length, zero_flag, false);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 
-		ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
+		ret = target_alloc_sgl(&cmd->t_iomem.t_data_sg,
+				       &cmd->t_iomem.t_data_nents,
 				       cmd->data_length, zero_flag, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2426,8 +2429,8 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 		u32 caw_length = cmd->t_task_nolb *
 				 cmd->se_dev->dev_attrib.block_size;
 
-		ret = target_alloc_sgl(&cmd->t_bidi_data_sg,
-				       &cmd->t_bidi_data_nents,
+		ret = target_alloc_sgl(&cmd->t_iomem.t_bidi_data_sg,
+				       &cmd->t_iomem.t_bidi_data_nents,
 				       caw_length, zero_flag, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 62bf4fe..5013611 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -415,8 +415,8 @@ static int tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	 * expensive to tell how many regions are freed in the bitmap
 	*/
 	base_command_size = max(offsetof(struct tcmu_cmd_entry,
-				req.iov[se_cmd->t_bidi_data_nents +
-					se_cmd->t_data_nents]),
+				req.iov[se_cmd->t_iomem.t_bidi_data_nents +
+					se_cmd->t_iomem.t_data_nents]),
 				sizeof(struct tcmu_cmd_entry));
 	command_size = base_command_size
 		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
@@ -429,8 +429,9 @@ static int tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
 	data_length = se_cmd->data_length;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
-		data_length += se_cmd->t_bidi_data_sg->length;
+		BUG_ON(!(se_cmd->t_iomem.t_bidi_data_sg &&
+			 se_cmd->t_iomem.t_bidi_data_nents));
+		data_length += se_cmd->t_iomem.t_bidi_data_sg->length;
 	}
 	if ((command_size > (udev->cmdr_size / 2))
 	    || data_length > udev->data_size)
@@ -494,15 +495,15 @@ static int tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	alloc_and_scatter_data_area(udev, se_cmd->t_data_sg,
-		se_cmd->t_data_nents, &iov, &iov_cnt, copy_to_data_area);
+	alloc_and_scatter_data_area(udev, se_cmd->t_iomem.t_data_sg,
+		se_cmd->t_iomem.t_data_nents, &iov, &iov_cnt, copy_to_data_area);
 	entry->req.iov_cnt = iov_cnt;
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
 	iov_cnt = 0;
-	alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
-		se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false);
+	alloc_and_scatter_data_area(udev, se_cmd->t_iomem.t_bidi_data_sg,
+		se_cmd->t_iomem.t_bidi_data_nents, &iov, &iov_cnt, false);
 	entry->req.iov_bidi_cnt = iov_cnt;
 
 	/* cmd's data_bitmap is what changed in process */
@@ -584,14 +585,14 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		/* Get Data-In buffer before clean up */
 		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
 		gather_data_area(udev, bitmap,
-			se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents);
+			se_cmd->t_iomem.t_bidi_data_sg, se_cmd->t_iomem.t_bidi_data_nents);
 		free_data_area(udev, cmd);
 	} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
 		DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);
 
 		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
 		gather_data_area(udev, bitmap,
-			se_cmd->t_data_sg, se_cmd->t_data_nents);
+			se_cmd->t_iomem.t_data_sg, se_cmd->t_iomem.t_data_nents);
 		free_data_area(udev, cmd);
 	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
 		free_data_area(udev, cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 75cd854..0a4bd8a 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -562,7 +562,8 @@ static int target_xcopy_setup_pt_cmd(
 	}
 
 	if (alloc_mem) {
-		rc = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
+		rc = target_alloc_sgl(&cmd->t_iomem.t_data_sg,
+				      &cmd->t_iomem.t_data_nents,
 				      cmd->data_length, false, false);
 		if (rc < 0) {
 			ret = rc;
@@ -588,7 +589,7 @@ static int target_xcopy_setup_pt_cmd(
 		}
 
 		pr_debug("Setup PASSTHROUGH_NOALLOC t_data_sg: %p t_data_nents:"
-			 " %u\n", cmd->t_data_sg, cmd->t_data_nents);
+			 " %u\n", cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents);
 	}
 
 	return 0;
@@ -657,8 +658,8 @@ static int target_xcopy_read_source(
 		return rc;
 	}
 
-	xop->xop_data_sg = se_cmd->t_data_sg;
-	xop->xop_data_nents = se_cmd->t_data_nents;
+	xop->xop_data_sg = se_cmd->t_iomem.t_data_sg;
+	xop->xop_data_nents = se_cmd->t_iomem.t_data_nents;
 	pr_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
 		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
 
@@ -671,8 +672,8 @@ static int target_xcopy_read_source(
 	 * Clear off the allocated t_data_sg, that has been saved for
 	 * zero-copy WRITE submission reuse in struct xcopy_op..
 	 */
-	se_cmd->t_data_sg = NULL;
-	se_cmd->t_data_nents = 0;
+	se_cmd->t_iomem.t_data_sg = NULL;
+	se_cmd->t_iomem.t_data_nents = 0;
 
 	return 0;
 }
@@ -720,8 +721,8 @@ static int target_xcopy_write_destination(
 		 * core releases this memory on error during X-COPY WRITE I/O.
 		 */
 		src_cmd->se_cmd_flags &= ~SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
-		src_cmd->t_data_sg = xop->xop_data_sg;
-		src_cmd->t_data_nents = xop->xop_data_nents;
+		src_cmd->t_iomem.t_data_sg = xop->xop_data_sg;
+		src_cmd->t_iomem.t_data_nents = xop->xop_data_nents;
 
 		transport_generic_free_cmd(se_cmd, 0);
 		return rc;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 216e18c..04c98d0 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -55,10 +55,10 @@ static void _ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		caller, cmd, cmd->sess, cmd->seq, se_cmd);
 
 	pr_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
-		caller, cmd, se_cmd->t_data_nents,
+		caller, cmd, se_cmd->t_iomem.t_data_nents,
 	       se_cmd->data_length, se_cmd->se_cmd_flags);
 
-	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, count)
+	for_each_sg(se_cmd->t_iomem.t_data_sg, sg, se_cmd->t_iomem.t_data_nents, count)
 		pr_debug("%s: cmd %p sg %p page %p "
 			"len 0x%x off 0x%x\n",
 			caller, cmd, sg,
@@ -237,8 +237,8 @@ int ft_write_pending(struct se_cmd *se_cmd)
 		    (fh->fh_r_ctl == FC_RCTL_DD_DATA_DESC)) {
 			if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 			    lport->tt.ddp_target(lport, ep->xid,
-						 se_cmd->t_data_sg,
-						 se_cmd->t_data_nents))
+						 se_cmd->t_iomem.t_data_sg,
+						 se_cmd->t_iomem.t_data_nents))
 				cmd->was_ddp_setup = 1;
 		}
 	}
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 6f7c65a..86ae4c5 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -89,9 +89,9 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 	/*
 	 * Setup to use first mem list entry, unless no data.
 	 */
-	BUG_ON(remaining && !se_cmd->t_data_sg);
+	BUG_ON(remaining && !se_cmd->t_iomem.t_data_sg);
 	if (remaining) {
-		sg = se_cmd->t_data_sg;
+		sg = se_cmd->t_iomem.t_data_sg;
 		mem_len = sg->length;
 		mem_off = sg->offset;
 		page = sg_page(sg);
@@ -248,7 +248,8 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 				"payload, Frame will be dropped if"
 				"'Sequence Initiative' bit in f_ctl is"
 				"not set\n", __func__, ep->xid, f_ctl,
-				se_cmd->t_data_sg, se_cmd->t_data_nents);
+				se_cmd->t_iomem.t_data_sg,
+				se_cmd->t_iomem.t_data_nents);
 		/*
 		 * Invalidate HW DDP context if it was setup for respective
 		 * command. Invalidation of HW DDP context is requited in both
@@ -286,9 +287,9 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	/*
 	 * Setup to use first mem list entry, unless no data.
 	 */
-	BUG_ON(frame_len && !se_cmd->t_data_sg);
+	BUG_ON(frame_len && !se_cmd->t_iomem.t_data_sg);
 	if (frame_len) {
-		sg = se_cmd->t_data_sg;
+		sg = se_cmd->t_iomem.t_data_sg;
 		mem_len = sg->length;
 		mem_off = sg->offset;
 		page = sg_page(sg);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 35fe3c8..8986132 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -217,16 +217,16 @@ static int bot_send_read_response(struct usbg_cmd *cmd)
 		if (!cmd->data_buf)
 			return -ENOMEM;
 
-		sg_copy_to_buffer(se_cmd->t_data_sg,
-				se_cmd->t_data_nents,
+		sg_copy_to_buffer(se_cmd->t_iomem.t_data_sg,
+				se_cmd->t_iomem.t_data_nents,
 				cmd->data_buf,
 				se_cmd->data_length);
 
 		fu->bot_req_in->buf = cmd->data_buf;
 	} else {
 		fu->bot_req_in->buf = NULL;
-		fu->bot_req_in->num_sgs = se_cmd->t_data_nents;
-		fu->bot_req_in->sg = se_cmd->t_data_sg;
+		fu->bot_req_in->num_sgs = se_cmd->t_iomem.t_data_nents;
+		fu->bot_req_in->sg = se_cmd->t_iomem.t_data_sg;
 	}
 
 	fu->bot_req_in->complete = bot_read_compl;
@@ -264,8 +264,8 @@ static int bot_send_write_request(struct usbg_cmd *cmd)
 		fu->bot_req_out->buf = cmd->data_buf;
 	} else {
 		fu->bot_req_out->buf = NULL;
-		fu->bot_req_out->num_sgs = se_cmd->t_data_nents;
-		fu->bot_req_out->sg = se_cmd->t_data_sg;
+		fu->bot_req_out->num_sgs = se_cmd->t_iomem.t_data_nents;
+		fu->bot_req_out->sg = se_cmd->t_iomem.t_data_sg;
 	}
 
 	fu->bot_req_out->complete = usbg_data_write_cmpl;
@@ -519,16 +519,16 @@ static int uasp_prepare_r_request(struct usbg_cmd *cmd)
 		if (!cmd->data_buf)
 			return -ENOMEM;
 
-		sg_copy_to_buffer(se_cmd->t_data_sg,
-				se_cmd->t_data_nents,
+		sg_copy_to_buffer(se_cmd->t_iomem.t_data_sg,
+				se_cmd->t_iomem.t_data_nents,
 				cmd->data_buf,
 				se_cmd->data_length);
 
 		stream->req_in->buf = cmd->data_buf;
 	} else {
 		stream->req_in->buf = NULL;
-		stream->req_in->num_sgs = se_cmd->t_data_nents;
-		stream->req_in->sg = se_cmd->t_data_sg;
+		stream->req_in->num_sgs = se_cmd->t_iomem.t_data_nents;
+		stream->req_in->sg = se_cmd->t_iomem.t_data_sg;
 	}
 
 	stream->req_in->complete = uasp_status_data_cmpl;
@@ -960,8 +960,8 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 	}
 
 	if (req->num_sgs == 0) {
-		sg_copy_from_buffer(se_cmd->t_data_sg,
-				se_cmd->t_data_nents,
+		sg_copy_from_buffer(se_cmd->t_iomem.t_data_sg,
+				se_cmd->t_iomem.t_data_nents,
 				cmd->data_buf,
 				se_cmd->data_length);
 	}
@@ -987,8 +987,8 @@ static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
 		req->buf = cmd->data_buf;
 	} else {
 		req->buf = NULL;
-		req->num_sgs = se_cmd->t_data_nents;
-		req->sg = se_cmd->t_data_sg;
+		req->num_sgs = se_cmd->t_iomem.t_data_nents;
+		req->sg = se_cmd->t_iomem.t_data_sg;
 	}
 
 	req->complete = usbg_data_write_cmpl;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index b316b44..29ee45b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -432,6 +432,23 @@ enum target_core_dif_check {
 #define TCM_ORDERED_TAG	0x22
 #define TCM_ACA_TAG	0x24
 
+struct target_iomem {
+	/* Used to store READ/WRITE payloads */
+	struct scatterlist	*t_data_sg;
+	unsigned int		t_data_nents;
+	/* Used to store COMPARE_AND_WRITE payload */
+	struct scatterlist	*t_data_sg_orig;
+	unsigned int		t_data_nents_orig;
+	/* Used to map payload for CONTROL CDB emulation */
+	void			*t_data_vmap;
+	/* Used to store bidirectional READ payload */
+	struct scatterlist	*t_bidi_data_sg;
+	unsigned int		t_bidi_data_nents;
+	/* Used to store T10-PI payload */
+	struct scatterlist	*t_prot_sg;
+	unsigned int		t_prot_nents;
+};
+
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
@@ -495,14 +512,7 @@ struct se_cmd {
 	struct completion	t_transport_stop_comp;
 
 	struct work_struct	work;
-
-	struct scatterlist	*t_data_sg;
-	struct scatterlist	*t_data_sg_orig;
-	unsigned int		t_data_nents;
-	unsigned int		t_data_nents_orig;
-	void			*t_data_vmap;
-	struct scatterlist	*t_bidi_data_sg;
-	unsigned int		t_bidi_data_nents;
+	struct target_iomem	t_iomem;
 
 	/* Used for lun->lun_ref counting */
 	int			lun_ref_active;
@@ -519,8 +529,6 @@ struct se_cmd {
 	bool			prot_pto;
 	u32			prot_length;
 	u32			reftag_seed;
-	struct scatterlist	*t_prot_sg;
-	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
 	int			cpuid;
-- 
1.9.1
