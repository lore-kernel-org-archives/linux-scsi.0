From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 03/16] target: Add target_iostate descriptor
Date: Tue,  7 Jun 2016 04:12:28 +0000
Message-ID: <1465272761-26045-4-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch introduces a new struct target_iostate descriptor
containing logical block address, length in bytes, data_direction,
T10-PI, and target_iostate completion callback.

This includes:

    - t_task_* // Used for LBA + Number of LBAs
    - data_* // Used for length and direction
    - prot_* // T10-PI related
    - reftag_seed // T10-PI related
    - bad_sector // T10-PI related
    - iomem // Pointer to struct target_iomem descriptor
    - se_dev // Pointer to struct se_device backend
    - t_comp_func // Pointer to submission callback
    - priv // Used by IBLOCK, dropped in seperate patch

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
 drivers/infiniband/ulp/isert/ib_isert.c           |  37 +++---
 drivers/infiniband/ulp/srpt/ib_srpt.c             |   6 +-
 drivers/scsi/qla2xxx/qla_target.c                 |  60 ++++-----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |  10 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c          |   4 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c       |  10 +-
 drivers/target/iscsi/iscsi_target.c               |  22 ++--
 drivers/target/iscsi/iscsi_target_datain_values.c |  18 +--
 drivers/target/iscsi/iscsi_target_erl0.c          |  24 ++--
 drivers/target/iscsi/iscsi_target_erl1.c          |   8 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  40 +++---
 drivers/target/iscsi/iscsi_target_tmr.c           |   4 +-
 drivers/target/iscsi/iscsi_target_util.c          |   4 +-
 drivers/target/loopback/tcm_loop.c                |   2 +-
 drivers/target/sbp/sbp_target.c                   |   4 +-
 drivers/target/target_core_alua.c                 |  34 ++---
 drivers/target/target_core_device.c               |  22 ++--
 drivers/target/target_core_file.c                 |  48 +++----
 drivers/target/target_core_iblock.c               |  13 +-
 drivers/target/target_core_pr.c                   |  56 ++++----
 drivers/target/target_core_pscsi.c                |  12 +-
 drivers/target/target_core_rd.c                   |  18 +--
 drivers/target/target_core_sbc.c                  | 152 +++++++++++-----------
 drivers/target/target_core_spc.c                  |  28 ++--
 drivers/target/target_core_transport.c            | 106 +++++++--------
 drivers/target/target_core_user.c                 |  12 +-
 drivers/target/target_core_xcopy.c                |  10 +-
 drivers/target/tcm_fc/tfc_cmd.c                   |   6 +-
 drivers/target/tcm_fc/tfc_io.c                    |  10 +-
 drivers/usb/gadget/function/f_tcm.c               |  22 ++--
 drivers/vhost/scsi.c                              |   2 +-
 include/target/target_core_base.h                 |  39 ++++--
 include/target/target_core_fabric.h               |   2 +-
 include/trace/events/target.h                     |   4 +-
 34 files changed, 433 insertions(+), 416 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 2c41a8b..861d0e0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -65,7 +65,7 @@ static inline bool
 isert_prot_cmd(struct isert_conn *conn, struct se_cmd *cmd)
 {
 	return (conn->pi_support &&
-		cmd->prot_op != TARGET_PROT_NORMAL);
+		cmd->t_iostate.prot_op != TARGET_PROT_NORMAL);
 }
 
 
@@ -1111,7 +1111,7 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 	imm_data = cmd->immediate_data;
 	imm_data_len = cmd->first_burst_len;
 	unsol_data = cmd->unsolicited_data;
-	data_len = cmd->se_cmd.data_length;
+	data_len = cmd->se_cmd.t_iostate.data_length;
 
 	if (imm_data && imm_data_len == data_len)
 		cmd->se_cmd.se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
@@ -1143,7 +1143,7 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 
 	cmd->write_data_done += imm_data_len;
 
-	if (cmd->write_data_done == cmd->se_cmd.data_length) {
+	if (cmd->write_data_done == cmd->se_cmd.t_iostate.data_length) {
 		spin_lock_bh(&cmd->istate_lock);
 		cmd->cmd_flags |= ICF_GOT_LAST_DATAOUT;
 		cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
@@ -1189,7 +1189,7 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	isert_dbg("Unsolicited DataOut unsol_data_len: %u, "
 		  "write_data_done: %u, data_length: %u\n",
 		  unsol_data_len,  cmd->write_data_done,
-		  cmd->se_cmd.data_length);
+		  cmd->se_cmd.t_iostate.data_length);
 
 	sg_off = cmd->write_data_done / PAGE_SIZE;
 	sg_start = &cmd->se_cmd.t_iomem.t_data_sg[sg_off];
@@ -1614,12 +1614,12 @@ isert_check_pi_status(struct se_cmd *se_cmd, struct ib_mr *sig_mr)
 		}
 		sec_offset_err = mr_status.sig_err.sig_err_offset;
 		do_div(sec_offset_err, block_size);
-		se_cmd->bad_sector = sec_offset_err + se_cmd->t_task_lba;
+		se_cmd->t_iostate.bad_sector = sec_offset_err + se_cmd->t_iostate.t_task_lba;
 
 		isert_err("PI error found type %d at sector 0x%llx "
 			  "expected 0x%x vs actual 0x%x\n",
 			  mr_status.sig_err.err_type,
-			  (unsigned long long)se_cmd->bad_sector,
+			  (unsigned long long)se_cmd->t_iostate.bad_sector,
 			  mr_status.sig_err.expected,
 			  mr_status.sig_err.actual);
 		ret = 1;
@@ -2025,7 +2025,7 @@ isert_set_dif_domain(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs,
 	domain->sig_type = IB_SIG_TYPE_T10_DIF;
 	domain->sig.dif.bg_type = IB_T10DIF_CRC;
 	domain->sig.dif.pi_interval = se_cmd->se_dev->dev_attrib.block_size;
-	domain->sig.dif.ref_tag = se_cmd->reftag_seed;
+	domain->sig.dif.ref_tag = se_cmd->t_iostate.reftag_seed;
 	/*
 	 * At the moment we hard code those, but if in the future
 	 * the target core would like to use it, we will take it
@@ -2034,17 +2034,19 @@ isert_set_dif_domain(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs,
 	domain->sig.dif.apptag_check_mask = 0xffff;
 	domain->sig.dif.app_escape = true;
 	domain->sig.dif.ref_escape = true;
-	if (se_cmd->prot_type == TARGET_DIF_TYPE1_PROT ||
-	    se_cmd->prot_type == TARGET_DIF_TYPE2_PROT)
+	if (se_cmd->t_iostate.prot_type == TARGET_DIF_TYPE1_PROT ||
+	    se_cmd->t_iostate.prot_type == TARGET_DIF_TYPE2_PROT)
 		domain->sig.dif.ref_remap = true;
 };
 
 static int
 isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
 {
+	struct target_iostate *ios = &se_cmd->t_iostate;
+
 	memset(sig_attrs, 0, sizeof(*sig_attrs));
 
-	switch (se_cmd->prot_op) {
+	switch (se_cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
 		sig_attrs->mem.sig_type = IB_SIG_TYPE_NONE;
@@ -2061,14 +2063,14 @@ isert_set_sig_attrs(struct se_cmd *se_cmd, struct ib_sig_attrs *sig_attrs)
 		isert_set_dif_domain(se_cmd, sig_attrs, &sig_attrs->mem);
 		break;
 	default:
-		isert_err("Unsupported PI operation %d\n", se_cmd->prot_op);
+		isert_err("Unsupported PI operation %d\n", se_cmd->t_iostate.prot_op);
 		return -EINVAL;
 	}
 
 	sig_attrs->check_mask =
-	       (se_cmd->prot_checks & TARGET_DIF_CHECK_GUARD  ? 0xc0 : 0) |
-	       (se_cmd->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x30 : 0) |
-	       (se_cmd->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x0f : 0);
+	       (ios->prot_checks & TARGET_DIF_CHECK_GUARD  ? 0xc0 : 0) |
+	       (ios->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x30 : 0) |
+	       (ios->prot_checks & TARGET_DIF_CHECK_REFTAG ? 0x0f : 0);
 	return 0;
 }
 
@@ -2133,7 +2135,7 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	int rc;
 
 	isert_dbg("Cmd: %p RDMA_WRITE data_length: %u\n",
-		 isert_cmd, se_cmd->data_length);
+		 isert_cmd, se_cmd->t_iostate.data_length);
 
 	if (isert_prot_cmd(isert_conn, se_cmd)) {
 		isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
@@ -2168,9 +2170,10 @@ static int
 isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 {
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	isert_dbg("Cmd: %p RDMA_READ data_length: %u write_data_done: %u\n",
-		 isert_cmd, cmd->se_cmd.data_length, cmd->write_data_done);
+		 isert_cmd, se_cmd->t_iostate.data_length, cmd->write_data_done);
 
 	isert_cmd->tx_desc.tx_cqe.done = isert_rdma_read_done;
 	isert_rdma_rw_ctx_post(isert_cmd, conn->context,
@@ -2556,7 +2559,7 @@ isert_put_unsol_pending_cmds(struct iscsi_conn *conn)
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
 		if ((cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA) &&
 		    (cmd->write_data_done < conn->sess->sess_ops->FirstBurstLength) &&
-		    (cmd->write_data_done < cmd->se_cmd.data_length))
+		    (cmd->write_data_done < cmd->se_cmd.t_iostate.data_length))
 			list_move_tail(&cmd->i_conn_node, &drop_cmd_list);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e68b20cb..8f675a7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -937,7 +937,7 @@ static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
 		*dir = DMA_NONE;
 
 	/* initialize data_direction early as srpt_alloc_rw_ctxs needs it */
-	ioctx->cmd.data_direction = *dir;
+	ioctx->cmd.t_iostate.data_direction = *dir;
 
 	if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_DIRECT) ||
 	    ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_DIRECT)) {
@@ -2296,8 +2296,8 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	}
 
 	/* For read commands, transfer the data to the initiator. */
-	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
-	    ioctx->cmd.data_length &&
+	if (ioctx->cmd.t_iostate.data_direction == DMA_FROM_DEVICE &&
+	    ioctx->cmd.t_iostate.data_length &&
 	    !ioctx->queue_status_only) {
 		for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
 			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f93bd5f..a1ab13f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1808,7 +1808,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 
 	prm->cmd->sg_mapped = 1;
 
-	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL) {
+	if (cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_NORMAL) {
 		/*
 		 * If greater than four sg entries then we need to allocate
 		 * the continuation entries
@@ -1819,8 +1819,8 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 			prm->tgt->datasegs_per_cont);
 	} else {
 		/* DIF */
-		if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
-		    (cmd->se_cmd.prot_op == TARGET_PROT_DOUT_STRIP)) {
+		if ((cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_DIN_INSERT) ||
+		    (cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_DOUT_STRIP)) {
 			prm->seg_cnt = DIV_ROUND_UP(cmd->bufflen, cmd->blk_sz);
 			prm->tot_dsds = prm->seg_cnt;
 		} else
@@ -1834,8 +1834,8 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 			if (unlikely(prm->prot_seg_cnt == 0))
 				goto out_err;
 
-			if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
-			    (cmd->se_cmd.prot_op == TARGET_PROT_DOUT_STRIP)) {
+			if ((cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_DIN_INSERT) ||
+			    (cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_DOUT_STRIP)) {
 				/* Dif Bundling not support here */
 				prm->prot_seg_cnt = DIV_ROUND_UP(cmd->bufflen,
 								cmd->blk_sz);
@@ -2355,7 +2355,7 @@ qlt_hba_err_chk_enabled(struct se_cmd *se_cmd)
 	 return 0;
 	 *
 	 */
-	switch (se_cmd->prot_op) {
+	switch (se_cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DOUT_INSERT:
 	case TARGET_PROT_DIN_STRIP:
 		if (ql2xenablehba_err_chk >= 1)
@@ -2382,7 +2382,7 @@ qlt_hba_err_chk_enabled(struct se_cmd *se_cmd)
 static inline void
 qlt_set_t10dif_tags(struct se_cmd *se_cmd, struct crc_context *ctx)
 {
-	uint32_t lba = 0xffffffff & se_cmd->t_task_lba;
+	uint32_t lba = 0xffffffff & se_cmd->t_iostate.t_task_lba;
 
 	/* wait til Mode Sense/Select cmd, modepage Ah, subpage 2
 	 * have been immplemented by TCM, before AppTag is avail.
@@ -2392,7 +2392,7 @@ qlt_set_t10dif_tags(struct se_cmd *se_cmd, struct crc_context *ctx)
 	ctx->app_tag_mask[0] = 0x0;
 	ctx->app_tag_mask[1] = 0x0;
 
-	switch (se_cmd->prot_type) {
+	switch (se_cmd->t_iostate.prot_type) {
 	case TARGET_DIF_TYPE0_PROT:
 		/*
 		 * No check for ql2xenablehba_err_chk, as it would be an
@@ -2479,18 +2479,18 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe071,
 		"qla_target(%d):%s: se_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
-		vha->vp_idx, __func__, se_cmd, se_cmd->prot_op,
-		prm->prot_sg, prm->prot_seg_cnt, se_cmd->t_task_lba);
+		vha->vp_idx, __func__, se_cmd, se_cmd->t_iostate.prot_op,
+		prm->prot_sg, prm->prot_seg_cnt, se_cmd->t_iostate.t_task_lba);
 
-	if ((se_cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
-	    (se_cmd->prot_op == TARGET_PROT_DOUT_STRIP))
+	if ((se_cmd->t_iostate.prot_op == TARGET_PROT_DIN_INSERT) ||
+	    (se_cmd->t_iostate.prot_op == TARGET_PROT_DOUT_STRIP))
 		bundling = 0;
 
 	/* Compute dif len and adjust data len to incude protection */
 	data_bytes = cmd->bufflen;
 	dif_bytes  = (data_bytes / cmd->blk_sz) * 8;
 
-	switch (se_cmd->prot_op) {
+	switch (se_cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
 		transfer_length = data_bytes;
@@ -2513,14 +2513,14 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 		fw_prot_opts |= 0x10; /* Disable Guard tag checking */
 	/* HBA error checking enabled */
 	else if (IS_PI_UNINIT_CAPABLE(ha)) {
-		if ((se_cmd->prot_type == TARGET_DIF_TYPE1_PROT) ||
-		    (se_cmd->prot_type == TARGET_DIF_TYPE2_PROT))
+		if ((se_cmd->t_iostate.prot_type == TARGET_DIF_TYPE1_PROT) ||
+		    (se_cmd->t_iostate.prot_type == TARGET_DIF_TYPE2_PROT))
 			fw_prot_opts |= PO_DIS_VALD_APP_ESC;
-		else if (se_cmd->prot_type == TARGET_DIF_TYPE3_PROT)
+		else if (se_cmd->t_iostate.prot_type == TARGET_DIF_TYPE3_PROT)
 			fw_prot_opts |= PO_DIS_VALD_APP_REF_ESC;
 	}
 
-	switch (se_cmd->prot_op) {
+	switch (se_cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_INSERT:
 		fw_prot_opts |= PO_MODE_DIF_INSERT;
@@ -2732,7 +2732,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (unlikely(res))
 		goto out_unmap_unlock;
 
-	if (cmd->se_cmd.prot_op && (xmit_type & QLA_TGT_XMIT_DATA))
+	if (cmd->se_cmd.t_iostate.prot_op && (xmit_type & QLA_TGT_XMIT_DATA))
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
@@ -2748,7 +2748,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 		    cpu_to_le16(CTIO7_FLAGS_DATA_IN |
 			CTIO7_FLAGS_STATUS_MODE_0);
 
-		if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
+		if (cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_NORMAL)
 			qlt_load_data_segments(&prm, vha);
 
 		if (prm.add_status_pkt == 0) {
@@ -2873,7 +2873,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	res = qlt_check_reserve_free_req(vha, prm.req_cnt);
 	if (res != 0)
 		goto out_unlock_free_unmap;
-	if (cmd->se_cmd.prot_op)
+	if (cmd->se_cmd.t_iostate.prot_op)
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
@@ -2887,7 +2887,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	pkt->u.status0.flags |= cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
 	    CTIO7_FLAGS_STATUS_MODE_0);
 
-	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
+	if (cmd->se_cmd.t_iostate.prot_op == TARGET_PROT_NORMAL)
 		qlt_load_data_segments(&prm, vha);
 
 	cmd->state = QLA_TGT_STATE_NEED_DATA;
@@ -2922,7 +2922,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	uint32_t	e_ref_tag, a_ref_tag;
 	uint16_t	e_app_tag, a_app_tag;
 	uint16_t	e_guard, a_guard;
-	uint64_t	lba = cmd->se_cmd.t_task_lba;
+	uint64_t	lba = cmd->se_cmd.t_iostate.t_task_lba;
 
 	a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
 	a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
@@ -2946,13 +2946,13 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	 * For type 0,1,2: app tag is all 'f's
 	 */
 	if ((a_app_tag == 0xffff) &&
-	    ((cmd->se_cmd.prot_type != TARGET_DIF_TYPE3_PROT) ||
+	    ((cmd->se_cmd.t_iostate.prot_type != TARGET_DIF_TYPE3_PROT) ||
 	     (a_ref_tag == 0xffffffff))) {
 		uint32_t blocks_done;
 
 		/* 2TB boundary case covered automatically with this */
 		blocks_done = e_ref_tag - (uint32_t)lba + 1;
-		cmd->se_cmd.bad_sector = e_ref_tag;
+		cmd->se_cmd.t_iostate.bad_sector = e_ref_tag;
 		cmd->se_cmd.pi_err = 0;
 		ql_dbg(ql_dbg_tgt, vha, 0xf074,
 			"need to return scsi good\n");
@@ -2993,7 +2993,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 			spt += j;
 
 			spt->app_tag = 0xffff;
-			if (cmd->se_cmd.prot_type == SCSI_PROT_DIF_TYPE3)
+			if (cmd->se_cmd.t_iostate.prot_type == SCSI_PROT_DIF_TYPE3)
 				spt->ref_tag = 0xffffffff;
 #endif
 		}
@@ -3004,7 +3004,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	/* check guard */
 	if (e_guard != a_guard) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
+		cmd->se_cmd.t_iostate.bad_sector = cmd->se_cmd.t_iostate.t_task_lba;
 
 		ql_log(ql_log_warn, vha, 0xe076,
 		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -3017,7 +3017,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	/* check ref tag */
 	if (e_ref_tag != a_ref_tag) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = e_ref_tag;
+		cmd->se_cmd.t_iostate.bad_sector = e_ref_tag;
 
 		ql_log(ql_log_warn, vha, 0xe077,
 			"Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -3030,7 +3030,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	/* check appl tag */
 	if (e_app_tag != a_app_tag) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
+		cmd->se_cmd.t_iostate.bad_sector = cmd->se_cmd.t_iostate.t_task_lba;
 
 		ql_log(ql_log_warn, vha, 0xe078,
 			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -4734,7 +4734,7 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			    "scsi_status\n");
 			goto out_reject;
 		}
-		cmd->bufflen = se_cmd->data_length;
+		cmd->bufflen = se_cmd->t_iostate.data_length;
 
 		if (qlt_has_data(cmd)) {
 			if (qlt_srr_adjust_data(cmd, offset, &xmit_type) != 0)
@@ -4766,7 +4766,7 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			    " with non GOOD scsi_status\n");
 			goto out_reject;
 		}
-		cmd->bufflen = se_cmd->data_length;
+		cmd->bufflen = se_cmd->t_iostate.data_length;
 
 		if (qlt_has_data(cmd)) {
 			if (qlt_srr_adjust_data(cmd, offset, &xmit_type) != 0)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index dace993..935519d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -378,7 +378,7 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 		return 0;
 	}
 	cmd->cmd_flags |= BIT_3;
-	cmd->bufflen = se_cmd->data_length;
+	cmd->bufflen = se_cmd->t_iostate.data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
 	cmd->sg_cnt = se_cmd->t_iomem.t_data_nents;
@@ -592,7 +592,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	}
 
 	cmd->cmd_flags |= BIT_4;
-	cmd->bufflen = se_cmd->data_length;
+	cmd->bufflen = se_cmd->t_iostate.data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
 	cmd->sg_cnt = se_cmd->t_iomem.t_data_nents;
@@ -617,7 +617,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 				struct qla_tgt_cmd, se_cmd);
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
-	cmd->bufflen = se_cmd->data_length;
+	cmd->bufflen = se_cmd->t_iostate.data_length;
 	cmd->sg = NULL;
 	cmd->sg_cnt = 0;
 	cmd->offset = 0;
@@ -628,7 +628,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	}
 	cmd->cmd_flags |= BIT_5;
 
-	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+	if (se_cmd->t_iostate.data_direction == DMA_FROM_DEVICE) {
 		/*
 		 * For FCP_READ with CHECK_CONDITION status, clear cmd->bufflen
 		 * for qla_tgt_xmit_response LLD code
@@ -638,7 +638,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 			se_cmd->residual_count = 0;
 		}
 		se_cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-		se_cmd->residual_count += se_cmd->data_length;
+		se_cmd->residual_count += se_cmd->t_iostate.data_length;
 
 		cmd->bufflen = 0;
 	}
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index a0c94b4..1313d68 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -248,10 +248,10 @@ cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	ttinfo->sgl = cmd->se_cmd.t_iomem.t_data_sg;
 	ttinfo->nents = cmd->se_cmd.t_iomem.t_data_nents;
 
-	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.data_length);
+	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.t_iostate.data_length);
 	if (ret < 0) {
 		pr_info("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
-			csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
+			csk, cmd, cmd->se_cmd.t_iostate.data_length, ttinfo->nents);
 
 		ttinfo->sgl = NULL;
 		ttinfo->nents = 0;
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index ac86574..02f6875 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -413,7 +413,7 @@ cxgbit_tx_datain_iso(struct cxgbit_sock *csk, struct iscsi_cmd *cmd,
 	struct sk_buff *skb;
 	struct iscsi_datain datain;
 	struct cxgbit_iso_info iso_info;
-	u32 data_length = cmd->se_cmd.data_length;
+	u32 data_length = cmd->se_cmd.t_iostate.data_length;
 	u32 mrdsl = conn->conn_ops->MaxRecvDataSegmentLength;
 	u32 num_pdu, plen, tx_data = 0;
 	bool task_sense = !!(cmd->se_cmd.se_cmd_flags &
@@ -531,7 +531,7 @@ cxgbit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		       const struct iscsi_datain *datain)
 {
 	struct cxgbit_sock *csk = conn->context;
-	u32 data_length = cmd->se_cmd.data_length;
+	u32 data_length = cmd->se_cmd.t_iostate.data_length;
 	u32 padding = ((-data_length) & 3);
 	u32 mrdsl = conn->conn_ops->MaxRecvDataSegmentLength;
 
@@ -877,7 +877,7 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 
 	cmd->write_data_done += pdu_cb->dlen;
 
-	if (cmd->write_data_done == cmd->se_cmd.data_length) {
+	if (cmd->write_data_done == cmd->se_cmd.t_iostate.data_length) {
 		spin_lock_bh(&cmd->istate_lock);
 		cmd->cmd_flags |= ICF_GOT_LAST_DATAOUT;
 		cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
@@ -954,7 +954,7 @@ cxgbit_handle_scsi_cmd(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 	if (rc < 0)
 		return rc;
 
-	if (pdu_cb->dlen && (pdu_cb->dlen == cmd->se_cmd.data_length) &&
+	if (pdu_cb->dlen && (pdu_cb->dlen == cmd->se_cmd.t_iostate.data_length) &&
 	    (pdu_cb->nr_dfrags == 1))
 		cmd->se_cmd.se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 
@@ -1001,7 +1001,7 @@ static int cxgbit_handle_iscsi_dataout(struct cxgbit_sock *csk)
 	pr_debug("DataOut data_len: %u, "
 		"write_data_done: %u, data_length: %u\n",
 		  data_len,  cmd->write_data_done,
-		  cmd->se_cmd.data_length);
+		  cmd->se_cmd.t_iostate.data_length);
 
 	if (!(pdu_cb->flags & PDUCBF_RX_DATA_DDPD)) {
 		sg_off = data_offset / PAGE_SIZE;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 44388e3..4140344 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -978,7 +978,7 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 
 static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 {
-	u32 iov_count = max(1UL, DIV_ROUND_UP(cmd->se_cmd.data_length, PAGE_SIZE));
+	u32 iov_count = max(1UL, DIV_ROUND_UP(cmd->se_cmd.t_iostate.data_length, PAGE_SIZE));
 
 	iov_count += ISCSI_IOV_DATA_BUFFER;
 
@@ -1478,10 +1478,10 @@ iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
 	se_cmd = &cmd->se_cmd;
 	iscsit_mod_dataout_timer(cmd);
 
-	if ((be32_to_cpu(hdr->offset) + payload_length) > cmd->se_cmd.data_length) {
+	if ((be32_to_cpu(hdr->offset) + payload_length) > cmd->se_cmd.t_iostate.data_length) {
 		pr_err("DataOut Offset: %u, Length %u greater than"
 			" iSCSI Command EDTL %u, protocol error.\n",
-			hdr->offset, payload_length, cmd->se_cmd.data_length);
+			hdr->offset, payload_length, cmd->se_cmd.t_iostate.data_length);
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_BOOKMARK_INVALID, buf);
 	}
 
@@ -2650,7 +2650,7 @@ static int iscsit_handle_immediate_data(
 
 	cmd->write_data_done += length;
 
-	if (cmd->write_data_done == cmd->se_cmd.data_length) {
+	if (cmd->write_data_done == cmd->se_cmd.t_iostate.data_length) {
 		spin_lock_bh(&cmd->istate_lock);
 		cmd->cmd_flags |= ICF_GOT_LAST_DATAOUT;
 		cmd->i_state = ISTATE_RECEIVED_LAST_DATAOUT;
@@ -2808,11 +2808,11 @@ static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	/*
 	 * Be paranoid and double check the logic for now.
 	 */
-	if ((datain.offset + datain.length) > cmd->se_cmd.data_length) {
+	if ((datain.offset + datain.length) > cmd->se_cmd.t_iostate.data_length) {
 		pr_err("Command ITT: 0x%08x, datain.offset: %u and"
 			" datain.length: %u exceeds cmd->data_length: %u\n",
 			cmd->init_task_tag, datain.offset, datain.length,
-			cmd->se_cmd.data_length);
+			cmd->se_cmd.t_iostate.data_length);
 		return -1;
 	}
 
@@ -3116,8 +3116,8 @@ int iscsit_build_r2ts_for_cmd(
 					conn->sess->sess_ops->MaxBurstLength -
 					cmd->next_burst_len;
 
-				if (new_data_end > cmd->se_cmd.data_length)
-					xfer_len = cmd->se_cmd.data_length - offset;
+				if (new_data_end > cmd->se_cmd.t_iostate.data_length)
+					xfer_len = cmd->se_cmd.t_iostate.data_length - offset;
 				else
 					xfer_len =
 						conn->sess->sess_ops->MaxBurstLength -
@@ -3126,14 +3126,14 @@ int iscsit_build_r2ts_for_cmd(
 				int new_data_end = offset +
 					conn->sess->sess_ops->MaxBurstLength;
 
-				if (new_data_end > cmd->se_cmd.data_length)
-					xfer_len = cmd->se_cmd.data_length - offset;
+				if (new_data_end > cmd->se_cmd.t_iostate.data_length)
+					xfer_len = cmd->se_cmd.t_iostate.data_length - offset;
 				else
 					xfer_len = conn->sess->sess_ops->MaxBurstLength;
 			}
 			cmd->r2t_offset += xfer_len;
 
-			if (cmd->r2t_offset == cmd->se_cmd.data_length)
+			if (cmd->r2t_offset == cmd->se_cmd.t_iostate.data_length)
 				cmd->cmd_flags |= ICF_SENT_LAST_R2T;
 		} else {
 			struct iscsi_seq *seq;
diff --git a/drivers/target/iscsi/iscsi_target_datain_values.c b/drivers/target/iscsi/iscsi_target_datain_values.c
index 647d4a5..9aff3b8 100644
--- a/drivers/target/iscsi/iscsi_target_datain_values.c
+++ b/drivers/target/iscsi/iscsi_target_datain_values.c
@@ -108,7 +108,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_yes(
 	read_data_done = (!dr->recovery) ?
 			cmd->read_data_done : dr->read_data_done;
 
-	read_data_left = (cmd->se_cmd.data_length - read_data_done);
+	read_data_left = (cmd->se_cmd.t_iostate.data_length - read_data_done);
 	if (!read_data_left) {
 		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
@@ -207,7 +207,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_yes(
 	seq_send_order = (!dr->recovery) ?
 			cmd->seq_send_order : dr->seq_send_order;
 
-	read_data_left = (cmd->se_cmd.data_length - read_data_done);
+	read_data_left = (cmd->se_cmd.t_iostate.data_length - read_data_done);
 	if (!read_data_left) {
 		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
@@ -226,8 +226,8 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_yes(
 	offset = (seq->offset + seq->next_burst_len);
 
 	if ((offset + conn->conn_ops->MaxRecvDataSegmentLength) >=
-	     cmd->se_cmd.data_length) {
-		datain->length = (cmd->se_cmd.data_length - offset);
+	     cmd->se_cmd.t_iostate.data_length) {
+		datain->length = (cmd->se_cmd.t_iostate.data_length - offset);
 		datain->offset = offset;
 
 		datain->flags |= ISCSI_FLAG_CMD_FINAL;
@@ -259,7 +259,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_yes(
 		}
 	}
 
-	if ((read_data_done + datain->length) == cmd->se_cmd.data_length)
+	if ((read_data_done + datain->length) == cmd->se_cmd.t_iostate.data_length)
 		datain->flags |= ISCSI_FLAG_DATA_STATUS;
 
 	datain->data_sn = (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
@@ -328,7 +328,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_no(
 	read_data_done = (!dr->recovery) ?
 			cmd->read_data_done : dr->read_data_done;
 
-	read_data_left = (cmd->se_cmd.data_length - read_data_done);
+	read_data_left = (cmd->se_cmd.t_iostate.data_length - read_data_done);
 	if (!read_data_left) {
 		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
@@ -339,7 +339,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_yes_and_no(
 	if (!pdu)
 		return dr;
 
-	if ((read_data_done + pdu->length) == cmd->se_cmd.data_length) {
+	if ((read_data_done + pdu->length) == cmd->se_cmd.t_iostate.data_length) {
 		pdu->flags |= (ISCSI_FLAG_CMD_FINAL | ISCSI_FLAG_DATA_STATUS);
 		if (conn->sess->sess_ops->ErrorRecoveryLevel > 0)
 			pdu->flags |= ISCSI_FLAG_DATA_ACK;
@@ -428,7 +428,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_no(
 	seq_send_order = (!dr->recovery) ?
 			cmd->seq_send_order : dr->seq_send_order;
 
-	read_data_left = (cmd->se_cmd.data_length - read_data_done);
+	read_data_left = (cmd->se_cmd.t_iostate.data_length - read_data_done);
 	if (!read_data_left) {
 		pr_err("ITT: 0x%08x read_data_left is zero!\n",
 				cmd->init_task_tag);
@@ -458,7 +458,7 @@ static struct iscsi_datain_req *iscsit_set_datain_values_no_and_no(
 	} else
 		seq->next_burst_len += pdu->length;
 
-	if ((read_data_done + pdu->length) == cmd->se_cmd.data_length)
+	if ((read_data_done + pdu->length) == cmd->se_cmd.t_iostate.data_length)
 		pdu->flags |= ISCSI_FLAG_DATA_STATUS;
 
 	pdu->data_sn = (!dr->recovery) ? cmd->data_sn++ : dr->data_sn++;
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index b54e72c..61fe12a 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -45,9 +45,9 @@ void iscsit_set_dataout_sequence_values(
 	if (cmd->unsolicited_data) {
 		cmd->seq_start_offset = cmd->write_data_done;
 		cmd->seq_end_offset = (cmd->write_data_done +
-			((cmd->se_cmd.data_length >
+			((cmd->se_cmd.t_iostate.data_length >
 			  conn->sess->sess_ops->FirstBurstLength) ?
-			 conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.data_length));
+			 conn->sess->sess_ops->FirstBurstLength : cmd->se_cmd.t_iostate.data_length));
 		return;
 	}
 
@@ -56,15 +56,15 @@ void iscsit_set_dataout_sequence_values(
 
 	if (!cmd->seq_start_offset && !cmd->seq_end_offset) {
 		cmd->seq_start_offset = cmd->write_data_done;
-		cmd->seq_end_offset = (cmd->se_cmd.data_length >
+		cmd->seq_end_offset = (cmd->se_cmd.t_iostate.data_length >
 			conn->sess->sess_ops->MaxBurstLength) ?
 			(cmd->write_data_done +
-			conn->sess->sess_ops->MaxBurstLength) : cmd->se_cmd.data_length;
+			conn->sess->sess_ops->MaxBurstLength) : cmd->se_cmd.t_iostate.data_length;
 	} else {
 		cmd->seq_start_offset = cmd->seq_end_offset;
 		cmd->seq_end_offset = ((cmd->seq_end_offset +
 			conn->sess->sess_ops->MaxBurstLength) >=
-			cmd->se_cmd.data_length) ? cmd->se_cmd.data_length :
+			cmd->se_cmd.t_iostate.data_length) ? cmd->se_cmd.t_iostate.data_length :
 			(cmd->seq_end_offset +
 			 conn->sess->sess_ops->MaxBurstLength);
 	}
@@ -180,13 +180,13 @@ static int iscsit_dataout_check_unsolicited_sequence(
 		if (!conn->sess->sess_ops->DataPDUInOrder)
 			goto out;
 
-		if ((first_burst_len != cmd->se_cmd.data_length) &&
+		if ((first_burst_len != cmd->se_cmd.t_iostate.data_length) &&
 		    (first_burst_len != conn->sess->sess_ops->FirstBurstLength)) {
 			pr_err("Unsolicited non-immediate data"
 			" received %u does not equal FirstBurstLength: %u, and"
 			" does not equal ExpXferLen %u.\n", first_burst_len,
 				conn->sess->sess_ops->FirstBurstLength,
-				cmd->se_cmd.data_length);
+				cmd->se_cmd.t_iostate.data_length);
 			transport_send_check_condition_and_sense(&cmd->se_cmd,
 					TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 			return DATAOUT_CANNOT_RECOVER;
@@ -199,10 +199,10 @@ static int iscsit_dataout_check_unsolicited_sequence(
 				conn->sess->sess_ops->FirstBurstLength);
 			return DATAOUT_CANNOT_RECOVER;
 		}
-		if (first_burst_len == cmd->se_cmd.data_length) {
+		if (first_burst_len == cmd->se_cmd.t_iostate.data_length) {
 			pr_err("Command ITT: 0x%08x reached"
 			" ExpXferLen: %u, but ISCSI_FLAG_CMD_FINAL is not set. protocol"
-			" error.\n", cmd->init_task_tag, cmd->se_cmd.data_length);
+			" error.\n", cmd->init_task_tag, cmd->se_cmd.t_iostate.data_length);
 			return DATAOUT_CANNOT_RECOVER;
 		}
 	}
@@ -293,7 +293,7 @@ static int iscsit_dataout_check_sequence(
 			if ((next_burst_len <
 			     conn->sess->sess_ops->MaxBurstLength) &&
 			   ((cmd->write_data_done + payload_length) <
-			     cmd->se_cmd.data_length)) {
+			     cmd->se_cmd.t_iostate.data_length)) {
 				pr_err("Command ITT: 0x%08x set ISCSI_FLAG_CMD_FINAL"
 				" before end of DataOUT sequence, protocol"
 				" error.\n", cmd->init_task_tag);
@@ -318,7 +318,7 @@ static int iscsit_dataout_check_sequence(
 				return DATAOUT_CANNOT_RECOVER;
 			}
 			if ((cmd->write_data_done + payload_length) ==
-					cmd->se_cmd.data_length) {
+					cmd->se_cmd.t_iostate.data_length) {
 				pr_err("Command ITT: 0x%08x reached"
 				" last DataOUT PDU in sequence but ISCSI_FLAG_"
 				"CMD_FINAL is not set, protocol error.\n",
@@ -640,7 +640,7 @@ static int iscsit_dataout_post_crc_passed(
 
 	cmd->write_data_done += payload_length;
 
-	if (cmd->write_data_done == cmd->se_cmd.data_length)
+	if (cmd->write_data_done == cmd->se_cmd.t_iostate.data_length)
 		return DATAOUT_SEND_TO_TRANSPORT;
 	else if (send_r2t)
 		return DATAOUT_SEND_R2T;
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 9214c9da..acb57b0 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1115,8 +1115,8 @@ static int iscsit_set_dataout_timeout_values(
 	if (cmd->unsolicited_data) {
 		*offset = 0;
 		*length = (conn->sess->sess_ops->FirstBurstLength >
-			   cmd->se_cmd.data_length) ?
-			   cmd->se_cmd.data_length :
+			   cmd->se_cmd.t_iostate.data_length) ?
+			   cmd->se_cmd.t_iostate.data_length :
 			   conn->sess->sess_ops->FirstBurstLength;
 		return 0;
 	}
@@ -1187,8 +1187,8 @@ static void iscsit_handle_dataout_timeout(unsigned long data)
 		if (conn->sess->sess_ops->DataPDUInOrder) {
 			pdu_offset = cmd->write_data_done;
 			if ((pdu_offset + (conn->sess->sess_ops->MaxBurstLength -
-			     cmd->next_burst_len)) > cmd->se_cmd.data_length)
-				pdu_length = (cmd->se_cmd.data_length -
+			     cmd->next_burst_len)) > cmd->se_cmd.t_iostate.data_length)
+				pdu_length = (cmd->se_cmd.t_iostate.data_length -
 					cmd->write_data_done);
 			else
 				pdu_length = (conn->sess->sess_ops->MaxBurstLength -
diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index e446a09..dcb0530 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -220,7 +220,7 @@ static void iscsit_determine_counts_for_list(
 	u32 mdsl;
 	struct iscsi_conn *conn = cmd->conn;
 
-	if (cmd->se_cmd.data_direction == DMA_TO_DEVICE)
+	if (cmd->se_cmd.t_iostate.data_direction == DMA_TO_DEVICE)
 		mdsl = cmd->conn->conn_ops->MaxXmitDataSegmentLength;
 	else
 		mdsl = cmd->conn->conn_ops->MaxRecvDataSegmentLength;
@@ -231,10 +231,10 @@ static void iscsit_determine_counts_for_list(
 
 	if ((bl->type == PDULIST_UNSOLICITED) ||
 	    (bl->type == PDULIST_IMMEDIATE_AND_UNSOLICITED))
-		unsolicited_data_length = min(cmd->se_cmd.data_length,
+		unsolicited_data_length = min(cmd->se_cmd.t_iostate.data_length,
 			conn->sess->sess_ops->FirstBurstLength);
 
-	while (offset < cmd->se_cmd.data_length) {
+	while (offset < cmd->se_cmd.t_iostate.data_length) {
 		*pdu_count += 1;
 
 		if (check_immediate) {
@@ -247,10 +247,10 @@ static void iscsit_determine_counts_for_list(
 			continue;
 		}
 		if (unsolicited_data_length > 0) {
-			if ((offset + mdsl) >= cmd->se_cmd.data_length) {
+			if ((offset + mdsl) >= cmd->se_cmd.t_iostate.data_length) {
 				unsolicited_data_length -=
-					(cmd->se_cmd.data_length - offset);
-				offset += (cmd->se_cmd.data_length - offset);
+					(cmd->se_cmd.t_iostate.data_length - offset);
+				offset += (cmd->se_cmd.t_iostate.data_length - offset);
 				continue;
 			}
 			if ((offset + mdsl)
@@ -269,8 +269,8 @@ static void iscsit_determine_counts_for_list(
 			unsolicited_data_length -= mdsl;
 			continue;
 		}
-		if ((offset + mdsl) >= cmd->se_cmd.data_length) {
-			offset += (cmd->se_cmd.data_length - offset);
+		if ((offset + mdsl) >= cmd->se_cmd.t_iostate.data_length) {
+			offset += (cmd->se_cmd.t_iostate.data_length - offset);
 			continue;
 		}
 		if ((burstlength + mdsl) >=
@@ -303,7 +303,7 @@ static int iscsit_do_build_pdu_and_seq_lists(
 	struct iscsi_pdu *pdu = cmd->pdu_list;
 	struct iscsi_seq *seq = cmd->seq_list;
 
-	if (cmd->se_cmd.data_direction == DMA_TO_DEVICE)
+	if (cmd->se_cmd.t_iostate.data_direction == DMA_TO_DEVICE)
 		mdsl = cmd->conn->conn_ops->MaxXmitDataSegmentLength;
 	else
 		mdsl = cmd->conn->conn_ops->MaxRecvDataSegmentLength;
@@ -317,10 +317,10 @@ static int iscsit_do_build_pdu_and_seq_lists(
 
 	if ((bl->type == PDULIST_UNSOLICITED) ||
 	    (bl->type == PDULIST_IMMEDIATE_AND_UNSOLICITED))
-		unsolicited_data_length = min(cmd->se_cmd.data_length,
+		unsolicited_data_length = min(cmd->se_cmd.t_iostate.data_length,
 			conn->sess->sess_ops->FirstBurstLength);
 
-	while (offset < cmd->se_cmd.data_length) {
+	while (offset < cmd->se_cmd.t_iostate.data_length) {
 		pdu_count++;
 		if (!datapduinorder) {
 			pdu[i].offset = offset;
@@ -354,21 +354,21 @@ static int iscsit_do_build_pdu_and_seq_lists(
 			continue;
 		}
 		if (unsolicited_data_length > 0) {
-			if ((offset + mdsl) >= cmd->se_cmd.data_length) {
+			if ((offset + mdsl) >= cmd->se_cmd.t_iostate.data_length) {
 				if (!datapduinorder) {
 					pdu[i].type = PDUTYPE_UNSOLICITED;
 					pdu[i].length =
-						(cmd->se_cmd.data_length - offset);
+						(cmd->se_cmd.t_iostate.data_length - offset);
 				}
 				if (!datasequenceinorder) {
 					seq[seq_no].type = SEQTYPE_UNSOLICITED;
 					seq[seq_no].pdu_count = pdu_count;
 					seq[seq_no].xfer_len = (burstlength +
-						(cmd->se_cmd.data_length - offset));
+						(cmd->se_cmd.t_iostate.data_length - offset));
 				}
 				unsolicited_data_length -=
-						(cmd->se_cmd.data_length - offset);
-				offset += (cmd->se_cmd.data_length - offset);
+						(cmd->se_cmd.t_iostate.data_length - offset);
+				offset += (cmd->se_cmd.t_iostate.data_length - offset);
 				continue;
 			}
 			if ((offset + mdsl) >=
@@ -406,18 +406,18 @@ static int iscsit_do_build_pdu_and_seq_lists(
 			unsolicited_data_length -= mdsl;
 			continue;
 		}
-		if ((offset + mdsl) >= cmd->se_cmd.data_length) {
+		if ((offset + mdsl) >= cmd->se_cmd.t_iostate.data_length) {
 			if (!datapduinorder) {
 				pdu[i].type = PDUTYPE_NORMAL;
-				pdu[i].length = (cmd->se_cmd.data_length - offset);
+				pdu[i].length = (cmd->se_cmd.t_iostate.data_length - offset);
 			}
 			if (!datasequenceinorder) {
 				seq[seq_no].type = SEQTYPE_NORMAL;
 				seq[seq_no].pdu_count = pdu_count;
 				seq[seq_no].xfer_len = (burstlength +
-					(cmd->se_cmd.data_length - offset));
+					(cmd->se_cmd.t_iostate.data_length - offset));
 			}
-			offset += (cmd->se_cmd.data_length - offset);
+			offset += (cmd->se_cmd.t_iostate.data_length - offset);
 			continue;
 		}
 		if ((burstlength + mdsl) >=
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index 3d63705..5379b99 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -280,9 +280,9 @@ static int iscsit_task_reassign_complete_write(
 		offset = cmd->next_burst_len = cmd->write_data_done;
 
 		if ((conn->sess->sess_ops->FirstBurstLength - offset) >=
-		     cmd->se_cmd.data_length) {
+		     cmd->se_cmd.t_iostate.data_length) {
 			no_build_r2ts = 1;
-			length = (cmd->se_cmd.data_length - offset);
+			length = (cmd->se_cmd.t_iostate.data_length - offset);
 		} else
 			length = (conn->sess->sess_ops->FirstBurstLength - offset);
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1f38177..7403242 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -355,14 +355,14 @@ int iscsit_check_unsolicited_dataout(struct iscsi_cmd *cmd, unsigned char *buf)
 	if (!(hdr->flags & ISCSI_FLAG_CMD_FINAL))
 		return 0;
 
-	if (((cmd->first_burst_len + payload_length) != cmd->se_cmd.data_length) &&
+	if (((cmd->first_burst_len + payload_length) != cmd->se_cmd.t_iostate.data_length) &&
 	    ((cmd->first_burst_len + payload_length) !=
 	      conn->sess->sess_ops->FirstBurstLength)) {
 		pr_err("Unsolicited non-immediate data received %u"
 			" does not equal FirstBurstLength: %u, and does"
 			" not equal ExpXferLen %u.\n",
 			(cmd->first_burst_len + payload_length),
-			conn->sess->sess_ops->FirstBurstLength, cmd->se_cmd.data_length);
+			conn->sess->sess_ops->FirstBurstLength, cmd->se_cmd.t_iostate.data_length);
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_INCORRECT_AMOUNT_OF_DATA, 0);
 		return -1;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 5091b31..a1e7ab3 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -152,7 +152,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	transfer_length = scsi_transfer_length(sc);
 	if (!scsi_prot_sg_count(sc) &&
 	    scsi_get_prot_op(sc) != SCSI_PROT_NORMAL) {
-		se_cmd->prot_pto = true;
+		se_cmd->t_iostate.prot_pto = true;
 		/*
 		 * loopback transport doesn't support
 		 * WRITE_GENERATE, READ_STRIP protection
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index dcc6eba..366e112 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1262,7 +1262,7 @@ static int sbp_rw_data(struct sbp_target_request *req)
 	struct fw_card *card;
 	struct sg_mapping_iter iter;
 
-	if (req->se_cmd.data_direction == DMA_FROM_DEVICE) {
+	if (req->se_cmd.t_iostate.data_direction == DMA_FROM_DEVICE) {
 		tcode = TCODE_WRITE_BLOCK_REQUEST;
 		sg_miter_flags = SG_MITER_FROM_SG;
 	} else {
@@ -1296,7 +1296,7 @@ static int sbp_rw_data(struct sbp_target_request *req)
 		num_pte = 0;
 
 		offset = sbp2_pointer_to_addr(&req->orb.data_descriptor);
-		length = req->se_cmd.data_length;
+		length = req->se_cmd.t_iostate.data_length;
 	}
 
 	sg_miter_start(&iter, req->se_cmd.t_iomem.t_data_sg,
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 4c82bbe..c806a96 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -71,9 +71,9 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	unsigned char *buf;
 	u32 rd_len = 0, off;
 
-	if (cmd->data_length < 4) {
+	if (cmd->t_iostate.data_length < 4) {
 		pr_warn("REPORT REFERRALS allocation length %u too"
-			" small\n", cmd->data_length);
+			" small\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -96,10 +96,10 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 		int pg_num;
 
 		off += 4;
-		if (cmd->data_length > off)
+		if (cmd->t_iostate.data_length > off)
 			put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
 		off += 8;
-		if (cmd->data_length > off)
+		if (cmd->t_iostate.data_length > off)
 			put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
 		off += 8;
 		rd_len += 20;
@@ -109,19 +109,19 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 			int alua_state = map_mem->lba_map_mem_alua_state;
 			int alua_pg_id = map_mem->lba_map_mem_alua_pg_id;
 
-			if (cmd->data_length > off)
+			if (cmd->t_iostate.data_length > off)
 				buf[off] = alua_state & 0x0f;
 			off += 2;
-			if (cmd->data_length > off)
+			if (cmd->t_iostate.data_length > off)
 				buf[off] = (alua_pg_id >> 8) & 0xff;
 			off++;
-			if (cmd->data_length > off)
+			if (cmd->t_iostate.data_length > off)
 				buf[off] = (alua_pg_id & 0xff);
 			off++;
 			rd_len += 4;
 			pg_num++;
 		}
-		if (cmd->data_length > desc_num)
+		if (cmd->t_iostate.data_length > desc_num)
 			buf[desc_num] = pg_num;
 	}
 	spin_unlock(&dev->t10_alua.lba_map_lock);
@@ -161,9 +161,9 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	else
 		off = 4;
 
-	if (cmd->data_length < off) {
+	if (cmd->t_iostate.data_length < off) {
 		pr_warn("REPORT TARGET PORT GROUPS allocation length %u too"
-			" small for %s header\n", cmd->data_length,
+			" small for %s header\n", cmd->t_iostate.data_length,
 			(ext_hdr) ? "extended" : "normal");
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -181,7 +181,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		 * the allocation length and the response is truncated.
 		 */
 		if ((off + 8 + (tg_pt_gp->tg_pt_gp_members * 4)) >
-		     cmd->data_length) {
+		     cmd->t_iostate.data_length) {
 			rd_len += 8 + (tg_pt_gp->tg_pt_gp_members * 4);
 			continue;
 		}
@@ -289,9 +289,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	int alua_access_state, primary = 0, valid_states;
 	u16 tg_pt_id, rtpi;
 
-	if (cmd->data_length < 4) {
+	if (cmd->t_iostate.data_length < 4) {
 		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
-			" small\n", cmd->data_length);
+			" small\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
@@ -324,7 +324,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 	ptr = &buf[4]; /* Skip over RESERVED area in header */
 
-	while (len < cmd->data_length) {
+	while (len < cmd->t_iostate.data_length) {
 		bool found = false;
 		alua_access_state = (ptr[0] & 0x0f);
 		/*
@@ -483,10 +483,10 @@ static inline int core_alua_state_lba_dependent(
 	spin_lock(&dev->t10_alua.lba_map_lock);
 	segment_size = dev->t10_alua.lba_map_segment_size;
 	segment_mult = dev->t10_alua.lba_map_segment_multiplier;
-	sectors = cmd->data_length / dev->dev_attrib.block_size;
+	sectors = cmd->t_iostate.data_length / dev->dev_attrib.block_size;
 
-	lba = cmd->t_task_lba;
-	while (lba < cmd->t_task_lba + sectors) {
+	lba = cmd->t_iostate.t_task_lba;
+	while (lba < cmd->t_iostate.t_task_lba + sectors) {
 		struct t10_alua_lba_map *cur_map = NULL, *map;
 		struct t10_alua_lba_map_member *map_mem;
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index a4046ca..910c990 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -69,11 +69,11 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	if (deve) {
 		atomic_long_inc(&deve->total_cmds);
 
-		if (se_cmd->data_direction == DMA_TO_DEVICE)
-			atomic_long_add(se_cmd->data_length,
+		if (se_cmd->t_iostate.data_direction == DMA_TO_DEVICE)
+			atomic_long_add(se_cmd->t_iostate.data_length,
 					&deve->write_bytes);
-		else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-			atomic_long_add(se_cmd->data_length,
+		else if (se_cmd->t_iostate.data_direction == DMA_FROM_DEVICE)
+			atomic_long_add(se_cmd->t_iostate.data_length,
 					&deve->read_bytes);
 
 		se_lun = rcu_dereference(deve->se_lun);
@@ -85,7 +85,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 		percpu_ref_get(&se_lun->lun_ref);
 		se_cmd->lun_ref_active = true;
 
-		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
+		if ((se_cmd->t_iostate.data_direction == DMA_TO_DEVICE) &&
 		    deve->lun_access_ro) {
 			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
 				" Access for 0x%08llx\n",
@@ -123,8 +123,8 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 		/*
 		 * Force WRITE PROTECT for virtual LUN 0
 		 */
-		if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
-		    (se_cmd->data_direction != DMA_NONE)) {
+		if ((se_cmd->t_iostate.data_direction != DMA_FROM_DEVICE) &&
+		    (se_cmd->t_iostate.data_direction != DMA_NONE)) {
 			ret = TCM_WRITE_PROTECTED;
 			goto ref_dev;
 		}
@@ -139,11 +139,11 @@ ref_dev:
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 	atomic_long_inc(&se_cmd->se_dev->num_cmds);
 
-	if (se_cmd->data_direction == DMA_TO_DEVICE)
-		atomic_long_add(se_cmd->data_length,
+	if (se_cmd->t_iostate.data_direction == DMA_TO_DEVICE)
+		atomic_long_add(se_cmd->t_iostate.data_length,
 				&se_cmd->se_dev->write_bytes);
-	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-		atomic_long_add(se_cmd->data_length,
+	else if (se_cmd->t_iostate.data_direction == DMA_FROM_DEVICE)
+		atomic_long_add(se_cmd->t_iostate.data_length,
 				&se_cmd->se_dev->read_bytes);
 
 	return ret;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 033c6a8..c865e45 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -254,7 +254,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 	struct iov_iter iter;
 	struct bio_vec *bvec;
 	ssize_t len = 0;
-	loff_t pos = (cmd->t_task_lba * block_size);
+	loff_t pos = (cmd->t_iostate.t_task_lba * block_size);
 	int ret = 0, i;
 
 	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
@@ -327,13 +327,13 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 	/*
 	 * Determine if we will be flushing the entire device.
 	 */
-	if (cmd->t_task_lba == 0 && cmd->data_length == 0) {
+	if (cmd->t_iostate.t_task_lba == 0 && cmd->t_iostate.data_length == 0) {
 		start = 0;
 		end = LLONG_MAX;
 	} else {
-		start = cmd->t_task_lba * dev->dev_attrib.block_size;
-		if (cmd->data_length)
-			end = start + cmd->data_length - 1;
+		start = cmd->t_iostate.t_task_lba * dev->dev_attrib.block_size;
+		if (cmd->t_iostate.data_length)
+			end = start + cmd->t_iostate.data_length - 1;
 		else
 			end = LLONG_MAX;
 	}
@@ -358,7 +358,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 {
 	struct se_device *se_dev = cmd->se_dev;
 	struct fd_dev *fd_dev = FD_DEV(se_dev);
-	loff_t pos = cmd->t_task_lba * se_dev->dev_attrib.block_size;
+	loff_t pos = cmd->t_iostate.t_task_lba * se_dev->dev_attrib.block_size;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
 	struct iov_iter iter;
 	struct bio_vec *bvec;
@@ -369,7 +369,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 		return 0;
 	}
-	if (cmd->prot_op) {
+	if (cmd->t_iostate.prot_op) {
 		pr_err("WRITE_SAME: Protection information with FILEIO"
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -521,10 +521,10 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * We are currently limited by the number of iovecs (2048) per
 	 * single vfs_[writev,readv] call.
 	 */
-	if (cmd->data_length > FD_MAX_BYTES) {
+	if (cmd->t_iostate.data_length > FD_MAX_BYTES) {
 		pr_err("FILEIO: Not able to process I/O of %u bytes due to"
 		       "FD_MAX_BYTES: %u iovec count limitiation\n",
-			cmd->data_length, FD_MAX_BYTES);
+			cmd->t_iostate.data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -532,63 +532,63 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * physical memory addresses to struct iovec virtual memory.
 	 */
 	if (data_direction == DMA_FROM_DEVICE) {
-		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
+		if (cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_rw(cmd, pfile, dev->prot_length,
 				       cmd->t_iomem.t_prot_sg,
 				       cmd->t_iomem.t_prot_nents,
-				       cmd->prot_length, 0);
+				       cmd->t_iostate.prot_length, 0);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 
 		ret = fd_do_rw(cmd, file, dev->dev_attrib.block_size,
-			       sgl, sgl_nents, cmd->data_length, 0);
+			       sgl, sgl_nents, cmd->t_iostate.data_length, 0);
 
-		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-			u32 sectors = cmd->data_length >>
+		if (ret > 0 && cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
+			u32 sectors = cmd->t_iostate.data_length >>
 					ilog2(dev->dev_attrib.block_size);
 
-			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
+			rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors,
 					    0, cmd->t_iomem.t_prot_sg, 0);
 			if (rc)
 				return rc;
 		}
 	} else {
-		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-			u32 sectors = cmd->data_length >>
+		if (cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
+			u32 sectors = cmd->t_iostate.data_length >>
 					ilog2(dev->dev_attrib.block_size);
 
-			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
+			rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors,
 					    0, cmd->t_iomem.t_prot_sg, 0);
 			if (rc)
 				return rc;
 		}
 
 		ret = fd_do_rw(cmd, file, dev->dev_attrib.block_size,
-			       sgl, sgl_nents, cmd->data_length, 1);
+			       sgl, sgl_nents, cmd->t_iostate.data_length, 1);
 		/*
 		 * Perform implicit vfs_fsync_range() for fd_do_writev() ops
 		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
 		 * Allow this to happen independent of WCE=0 setting.
 		 */
 		if (ret > 0 && (cmd->se_cmd_flags & SCF_FUA)) {
-			loff_t start = cmd->t_task_lba *
+			loff_t start = cmd->t_iostate.t_task_lba *
 				dev->dev_attrib.block_size;
 			loff_t end;
 
-			if (cmd->data_length)
-				end = start + cmd->data_length - 1;
+			if (cmd->t_iostate.data_length)
+				end = start + cmd->t_iostate.data_length - 1;
 			else
 				end = LLONG_MAX;
 
 			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 		}
 
-		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
+		if (ret > 0 && cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_rw(cmd, pfile, dev->prot_length,
 				       cmd->t_iomem.t_prot_sg,
 				       cmd->t_iomem.t_prot_nents,
-				       cmd->prot_length, 1);
+				       cmd->t_iostate.prot_length, 1);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 80ad456..0f45973 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -430,7 +430,8 @@ iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
 	}
 
 	ret = blkdev_issue_write_same(bdev,
-				target_to_linux_sector(dev, cmd->t_task_lba),
+				target_to_linux_sector(dev,
+					cmd->t_iostate.t_task_lba),
 				target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd)),
 				GFP_KERNEL, page ? page : sg_page(sg));
@@ -452,11 +453,11 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	struct bio *bio;
 	struct bio_list list;
 	struct se_device *dev = cmd->se_dev;
-	sector_t block_lba = target_to_linux_sector(dev, cmd->t_task_lba);
+	sector_t block_lba = target_to_linux_sector(dev, cmd->t_iostate.t_task_lba);
 	sector_t sectors = target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd));
 
-	if (cmd->prot_op) {
+	if (cmd->t_iostate.prot_op) {
 		pr_err("WRITE_SAME: Protection information with IBLOCK"
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -643,7 +644,7 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 		return PTR_ERR(bip);
 	}
 
-	bip->bip_iter.bi_size = (cmd->data_length / dev->dev_attrib.block_size) *
+	bip->bip_iter.bi_size = (cmd->t_iostate.data_length / dev->dev_attrib.block_size) *
 			 dev->prot_length;
 	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
 
@@ -671,7 +672,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		  enum dma_data_direction data_direction)
 {
 	struct se_device *dev = cmd->se_dev;
-	sector_t block_lba = target_to_linux_sector(dev, cmd->t_task_lba);
+	sector_t block_lba = target_to_linux_sector(dev, cmd->t_iostate.t_task_lba);
 	struct iblock_req *ibr;
 	struct bio *bio, *bio_start;
 	struct bio_list list;
@@ -751,7 +752,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		sg_num--;
 	}
 
-	if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
+	if (cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
 		int rc = iblock_alloc_bip(cmd, bio_start);
 		if (rc)
 			goto fail_put_bios;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 47463c9..f91058f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -497,7 +497,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 	 * WRITE_EXCLUSIVE_* reservation.
 	 */
 	if (we && !registered_nexus) {
-		if (cmd->data_direction == DMA_TO_DEVICE) {
+		if (cmd->t_iostate.data_direction == DMA_TO_DEVICE) {
 			/*
 			 * Conflict for write exclusive
 			 */
@@ -545,7 +545,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
                 * Reads are allowed for Write Exclusive locks
                 * from all registrants.
                 */
-               if (cmd->data_direction == DMA_FROM_DEVICE) {
+               if (cmd->t_iostate.data_direction == DMA_FROM_DEVICE) {
                        pr_debug("Allowing READ CDB: 0x%02x for %s"
                                " reservation\n", cdb[0],
                                core_scsi3_pr_dump_type(pr_reg_type));
@@ -1543,9 +1543,9 @@ core_scsi3_decode_spec_i_port(
 	tidh_new->dest_se_deve = NULL;
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
-	if (cmd->data_length < 28) {
+	if (cmd->t_iostate.data_length < 28) {
 		pr_warn("SPC-PR: Received PR OUT parameter list"
-			" length too small: %u\n", cmd->data_length);
+			" length too small: %u\n", cmd->t_iostate.data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
 	}
@@ -1566,10 +1566,10 @@ core_scsi3_decode_spec_i_port(
 	tpdl |= (buf[26] & 0xff) << 8;
 	tpdl |= buf[27] & 0xff;
 
-	if ((tpdl + 28) != cmd->data_length) {
+	if ((tpdl + 28) != cmd->t_iostate.data_length) {
 		pr_err("SPC-3 PR: Illegal tpdl: %u + 28 byte header"
-			" does not equal CDB data_length: %u\n", tpdl,
-			cmd->data_length);
+			" does not equal CDB t_iostate.data_length: %u\n", tpdl,
+			cmd->t_iostate.data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_unmap;
 	}
@@ -1658,9 +1658,9 @@ core_scsi3_decode_spec_i_port(
 			goto out_unmap;
 		}
 
-		pr_debug("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
+		pr_debug("SPC-3 PR SPEC_I_PT: Got %s t_iostate.data_length: %u tpdl: %u"
 			" tid_len: %d for %s + %s\n",
-			dest_tpg->se_tpg_tfo->get_fabric_name(), cmd->data_length,
+			dest_tpg->se_tpg_tfo->get_fabric_name(), cmd->t_iostate.data_length,
 			tpdl, tid_len, i_str, iport_ptr);
 
 		if (tid_len > tpdl) {
@@ -3229,10 +3229,10 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	transport_kunmap_data_sg(cmd);
 	buf = NULL;
 
-	if ((tid_len + 24) != cmd->data_length) {
+	if ((tid_len + 24) != cmd->t_iostate.data_length) {
 		pr_err("SPC-3 PR: Illegal tid_len: %u + 24 byte header"
-			" does not equal CDB data_length: %u\n", tid_len,
-			cmd->data_length);
+			" does not equal CDB t_iostate.data_length: %u\n", tid_len,
+			cmd->t_iostate.data_length);
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out_put_pr_reg;
 	}
@@ -3598,9 +3598,9 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	if (!cmd->se_sess)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	if (cmd->data_length < 24) {
+	if (cmd->t_iostate.data_length < 24) {
 		pr_warn("SPC-PR: Received PR OUT parameter list"
-			" length too small: %u\n", cmd->data_length);
+			" length too small: %u\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
@@ -3658,9 +3658,9 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	 * code set to PARAMETER LIST LENGTH ERROR.
 	 */
 	if (!spec_i_pt && ((cdb[1] & 0x1f) != PRO_REGISTER_AND_MOVE) &&
-	    (cmd->data_length != 24)) {
+	    (cmd->t_iostate.data_length != 24)) {
 		pr_warn("SPC-PR: Received PR OUT illegal parameter"
-			" list length: %u\n", cmd->data_length);
+			" list length: %u\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
@@ -3723,9 +3723,9 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	unsigned char *buf;
 	u32 add_len = 0, off = 8;
 
-	if (cmd->data_length < 8) {
+	if (cmd->t_iostate.data_length < 8) {
 		pr_err("PRIN SA READ_KEYS SCSI Data Length: %u"
-			" too small\n", cmd->data_length);
+			" too small\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3745,7 +3745,7 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 		 * Check for overflow of 8byte PRI READ_KEYS payload and
 		 * next reservation key list descriptor.
 		 */
-		if ((add_len + 8) > (cmd->data_length - 8))
+		if ((add_len + 8) > (cmd->t_iostate.data_length - 8))
 			break;
 
 		buf[off++] = ((pr_reg->pr_res_key >> 56) & 0xff);
@@ -3785,9 +3785,9 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	u64 pr_res_key;
 	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
 
-	if (cmd->data_length < 8) {
+	if (cmd->t_iostate.data_length < 8) {
 		pr_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
-			" too small\n", cmd->data_length);
+			" too small\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3811,7 +3811,7 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 		buf[6] = ((add_len >> 8) & 0xff);
 		buf[7] = (add_len & 0xff);
 
-		if (cmd->data_length < 22)
+		if (cmd->t_iostate.data_length < 22)
 			goto err;
 
 		/*
@@ -3871,9 +3871,9 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	unsigned char *buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
-	if (cmd->data_length < 6) {
+	if (cmd->t_iostate.data_length < 6) {
 		pr_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
-			" %u too small\n", cmd->data_length);
+			" %u too small\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3936,9 +3936,9 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	int exp_desc_len, desc_len;
 	bool all_reg = false;
 
-	if (cmd->data_length < 8) {
+	if (cmd->t_iostate.data_length < 8) {
 		pr_err("PRIN SA READ_FULL_STATUS SCSI Data Length: %u"
-			" too small\n", cmd->data_length);
+			" too small\n", cmd->t_iostate.data_length);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -3981,9 +3981,9 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		exp_desc_len = target_get_pr_transport_id_len(se_nacl, pr_reg,
 					&format_code);
 		if (exp_desc_len < 0 ||
-		    exp_desc_len + add_len > cmd->data_length) {
+		    exp_desc_len + add_len > cmd->t_iostate.data_length) {
 			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
-				" out of buffer: %d\n", cmd->data_length);
+				" out of buffer: %d\n", cmd->t_iostate.data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec_mb(&pr_reg->pr_res_holders);
 			break;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 75041dd..105894a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -640,7 +640,7 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
 	 * Hack to make sure that Write-Protect modepage is set if R/O mode is
 	 * forced.
 	 */
-	if (!cmd->data_length)
+	if (!cmd->t_iostate.data_length)
 		goto after_mode_sense;
 
 	if (((cdb[0] == MODE_SENSE) || (cdb[0] == MODE_SENSE_10)) &&
@@ -667,7 +667,7 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
 	}
 after_mode_sense:
 
-	if (sd->type != TYPE_TAPE || !cmd->data_length)
+	if (sd->type != TYPE_TAPE || !cmd->t_iostate.data_length)
 		goto after_mode_select;
 
 	/*
@@ -882,8 +882,8 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct bio *bio = NULL, *tbio = NULL;
 	struct page *page;
 	struct scatterlist *sg;
-	u32 data_len = cmd->data_length, i, len, bytes, off;
-	int nr_pages = (cmd->data_length + sgl[0].offset +
+	u32 data_len = cmd->t_iostate.data_length, i, len, bytes, off;
+	int nr_pages = (cmd->t_iostate.data_length + sgl[0].offset +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 	int nr_vecs = 0, rc;
 	int rw = (data_direction == DMA_TO_DEVICE);
@@ -992,7 +992,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 {
 	struct scatterlist *sgl = cmd->t_iomem.t_data_sg;
 	u32 sgl_nents = cmd->t_iomem.t_data_nents;
-	enum dma_data_direction data_direction = cmd->data_direction;
+	enum dma_data_direction data_direction = cmd->t_iostate.data_direction;
 	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
 	struct pscsi_plugin_task *pt;
 	struct request *req;
@@ -1024,7 +1024,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 
 		blk_rq_set_block_pc(req);
 	} else {
-		BUG_ON(!cmd->data_length);
+		BUG_ON(!cmd->t_iostate.data_length);
 
 		ret = pscsi_map_sg(cmd, sgl, sgl_nents, data_direction, &hbio);
 		if (ret)
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index d840281..4edd3e0 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -404,13 +404,13 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *prot_table;
 	struct scatterlist *prot_sg;
-	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
+	u32 sectors = cmd->t_iostate.data_length / se_dev->dev_attrib.block_size;
 	u32 prot_offset, prot_page;
 	u32 prot_npages __maybe_unused;
 	u64 tmp;
 	sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	tmp = cmd->t_task_lba * se_dev->prot_length;
+	tmp = cmd->t_iostate.t_task_lba * se_dev->prot_length;
 	prot_offset = do_div(tmp, PAGE_SIZE);
 	prot_page = tmp;
 
@@ -422,10 +422,10 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 					prot_table->page_start_offset];
 
 	if (is_read)
-		rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors, 0,
+		rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors, 0,
 				    prot_sg, prot_offset);
 	else
-		rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors, 0,
+		rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors, 0,
 				    cmd->t_iomem.t_prot_sg, 0);
 
 	if (!rc)
@@ -455,10 +455,10 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
-	tmp = cmd->t_task_lba * se_dev->dev_attrib.block_size;
+	tmp = cmd->t_iostate.t_task_lba * se_dev->dev_attrib.block_size;
 	rd_offset = do_div(tmp, PAGE_SIZE);
 	rd_page = tmp;
-	rd_size = cmd->data_length;
+	rd_size = cmd->t_iostate.data_length;
 
 	table = rd_get_sg_table(dev, rd_page);
 	if (!table)
@@ -469,9 +469,9 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	pr_debug("RD[%u]: %s LBA: %llu, Size: %u Page: %u, Offset: %u\n",
 			dev->rd_dev_id,
 			data_direction == DMA_FROM_DEVICE ? "Read" : "Write",
-			cmd->t_task_lba, rd_size, rd_page, rd_offset);
+			cmd->t_iostate.t_task_lba, rd_size, rd_page, rd_offset);
 
-	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
+	if (cmd->t_iostate.prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_TO_DEVICE) {
 		rc = rd_do_prot_rw(cmd, false);
 		if (rc)
@@ -539,7 +539,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 	sg_miter_stop(&m);
 
-	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
+	if (cmd->t_iostate.prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_FROM_DEVICE) {
 		rc = rd_do_prot_rw(cmd, true);
 		if (rc)
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index c80a225..744ef71 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -81,7 +81,7 @@ sbc_emulate_readcapacity(struct se_cmd *cmd)
 
 	rbuf = transport_kmap_data_sg(cmd);
 	if (rbuf) {
-		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->t_iostate.data_length));
 		transport_kunmap_data_sg(cmd);
 	}
 
@@ -154,7 +154,7 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 
 	rbuf = transport_kmap_data_sg(cmd);
 	if (rbuf) {
-		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->t_iostate.data_length));
 		transport_kunmap_data_sg(cmd);
 	}
 
@@ -213,7 +213,7 @@ sector_t sbc_get_write_same_sectors(struct se_cmd *cmd)
 		return num_blocks;
 
 	return cmd->se_dev->transport->get_blocks(cmd->se_dev) -
-		cmd->t_task_lba + 1;
+		cmd->t_iostate.t_task_lba + 1;
 }
 EXPORT_SYMBOL(sbc_get_write_same_sectors);
 
@@ -225,7 +225,7 @@ sbc_execute_write_same_unmap(struct se_cmd *cmd)
 	sense_reason_t ret;
 
 	if (nolb) {
-		ret = ops->execute_unmap(cmd, cmd->t_task_lba, nolb);
+		ret = ops->execute_unmap(cmd, cmd->t_iostate.t_task_lba, nolb);
 		if (ret)
 			return ret;
 	}
@@ -340,10 +340,10 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	/*
 	 * Sanity check for LBA wrap and request past end of device.
 	 */
-	if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
-	    ((cmd->t_task_lba + sectors) > end_lba)) {
+	if (((cmd->t_iostate.t_task_lba + sectors) < cmd->t_iostate.t_task_lba) ||
+	    ((cmd->t_iostate.t_task_lba + sectors) > end_lba)) {
 		pr_err("WRITE_SAME exceeds last lba %llu (lba %llu, sectors %u)\n",
-		       (unsigned long long)end_lba, cmd->t_task_lba, sectors);
+		       (unsigned long long)end_lba, cmd->t_iostate.t_task_lba, sectors);
 		return TCM_ADDRESS_OUT_OF_RANGE;
 	}
 
@@ -398,7 +398,7 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 	 *    blocks transferred from the data-out buffer; and
 	 * 5) transfer the resulting XOR data to the data-in buffer.
 	 */
-	buf = kmalloc(cmd->data_length, GFP_KERNEL);
+	buf = kmalloc(cmd->t_iostate.data_length, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate xor_callback buf\n");
 		return TCM_OUT_OF_RESOURCES;
@@ -410,7 +410,7 @@ static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
 	sg_copy_to_buffer(cmd->t_iomem.t_data_sg,
 			  cmd->t_iomem.t_data_nents,
 			  buf,
-			  cmd->data_length);
+			  cmd->t_iostate.data_length);
 
 	/*
 	 * Now perform the XOR against the BIDI read memory located at
@@ -444,7 +444,7 @@ sbc_execute_rw(struct se_cmd *cmd)
 	struct sbc_ops *ops = cmd->protocol_data;
 
 	return ops->execute_rw(cmd, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
-			       cmd->data_direction);
+			       cmd->t_iostate.data_direction);
 }
 
 static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
@@ -481,7 +481,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	unsigned char *buf = NULL, *addr;
 	struct sg_mapping_iter m;
 	unsigned int offset = 0, len;
-	unsigned int nlbas = cmd->t_task_nolb;
+	unsigned int nlbas = cmd->t_iostate.t_task_nolb;
 	unsigned int block_size = dev->dev_attrib.block_size;
 	unsigned int compare_len = (nlbas * block_size);
 	sense_reason_t ret = TCM_NO_SENSE;
@@ -496,7 +496,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	/*
 	 * Handle special case for zero-length COMPARE_AND_WRITE
 	 */
-	if (!cmd->data_length)
+	if (!cmd->t_iostate.data_length)
 		goto out;
 	/*
 	 * Immediately exit + release dev->caw_sem if command has already
@@ -508,7 +508,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		goto out;
 	}
 
-	buf = kzalloc(cmd->data_length, GFP_KERNEL);
+	buf = kzalloc(cmd->t_iostate.data_length, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate compare_and_write buf\n");
 		ret = TCM_OUT_OF_RESOURCES;
@@ -527,7 +527,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * Setup verify and write data payloads from total NumberLBAs.
 	 */
 	rc = sg_copy_to_buffer(cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
-			       buf, cmd->data_length);
+			       buf, cmd->t_iostate.data_length);
 	if (!rc) {
 		pr_err("sg_copy_to_buffer() failed for compare_and_write\n");
 		ret = TCM_OUT_OF_RESOURCES;
@@ -561,7 +561,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	}
 
 	i = 0;
-	len = cmd->t_task_nolb * block_size;
+	len = cmd->t_iostate.t_task_nolb * block_size;
 	sg_miter_start(&m, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
 		       SG_MITER_TO_SG);
 	/*
@@ -642,11 +642,12 @@ sbc_compare_and_write(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
-	 * Reset cmd->data_length to individual block_size in order to not
+	 * Reset cmd->t_iostate.data_length to individual block_size in order to not
 	 * confuse backend drivers that depend on this value matching the
 	 * size of the I/O being submitted.
 	 */
-	cmd->data_length = cmd->t_task_nolb * dev->dev_attrib.block_size;
+	cmd->t_iostate.data_length = cmd->t_iostate.t_task_nolb *
+				     dev->dev_attrib.block_size;
 
 	ret = ops->execute_rw(cmd, cmd->t_iomem.t_bidi_data_sg,
 			      cmd->t_iomem.t_bidi_data_nents, DMA_FROM_DEVICE);
@@ -668,52 +669,52 @@ sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_
 		       bool is_write, struct se_cmd *cmd)
 {
 	if (is_write) {
-		cmd->prot_op = fabric_prot ? TARGET_PROT_DOUT_STRIP :
+		cmd->t_iostate.prot_op = fabric_prot ? TARGET_PROT_DOUT_STRIP :
 			       protect ? TARGET_PROT_DOUT_PASS :
 			       TARGET_PROT_DOUT_INSERT;
 		switch (protect) {
 		case 0x0:
 		case 0x3:
-			cmd->prot_checks = 0;
+			cmd->t_iostate.prot_checks = 0;
 			break;
 		case 0x1:
 		case 0x5:
-			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			cmd->t_iostate.prot_checks = TARGET_DIF_CHECK_GUARD;
 			if (prot_type == TARGET_DIF_TYPE1_PROT)
-				cmd->prot_checks |= TARGET_DIF_CHECK_REFTAG;
+				cmd->t_iostate.prot_checks |= TARGET_DIF_CHECK_REFTAG;
 			break;
 		case 0x2:
 			if (prot_type == TARGET_DIF_TYPE1_PROT)
-				cmd->prot_checks = TARGET_DIF_CHECK_REFTAG;
+				cmd->t_iostate.prot_checks = TARGET_DIF_CHECK_REFTAG;
 			break;
 		case 0x4:
-			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			cmd->t_iostate.prot_checks = TARGET_DIF_CHECK_GUARD;
 			break;
 		default:
 			pr_err("Unsupported protect field %d\n", protect);
 			return -EINVAL;
 		}
 	} else {
-		cmd->prot_op = fabric_prot ? TARGET_PROT_DIN_INSERT :
+		cmd->t_iostate.prot_op = fabric_prot ? TARGET_PROT_DIN_INSERT :
 			       protect ? TARGET_PROT_DIN_PASS :
 			       TARGET_PROT_DIN_STRIP;
 		switch (protect) {
 		case 0x0:
 		case 0x1:
 		case 0x5:
-			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			cmd->t_iostate.prot_checks = TARGET_DIF_CHECK_GUARD;
 			if (prot_type == TARGET_DIF_TYPE1_PROT)
-				cmd->prot_checks |= TARGET_DIF_CHECK_REFTAG;
+				cmd->t_iostate.prot_checks |= TARGET_DIF_CHECK_REFTAG;
 			break;
 		case 0x2:
 			if (prot_type == TARGET_DIF_TYPE1_PROT)
-				cmd->prot_checks = TARGET_DIF_CHECK_REFTAG;
+				cmd->t_iostate.prot_checks = TARGET_DIF_CHECK_REFTAG;
 			break;
 		case 0x3:
-			cmd->prot_checks = 0;
+			cmd->t_iostate.prot_checks = 0;
 			break;
 		case 0x4:
-			cmd->prot_checks = TARGET_DIF_CHECK_GUARD;
+			cmd->t_iostate.prot_checks = TARGET_DIF_CHECK_GUARD;
 			break;
 		default:
 			pr_err("Unsupported protect field %d\n", protect);
@@ -740,22 +741,22 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 			       " not advertise PROTECT=1 feature bit\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
-		if (cmd->prot_pto)
+		if (cmd->t_iostate.prot_pto)
 			return TCM_NO_SENSE;
 	}
 
 	switch (dev->dev_attrib.pi_prot_type) {
 	case TARGET_DIF_TYPE3_PROT:
-		cmd->reftag_seed = 0xffffffff;
+		cmd->t_iostate.reftag_seed = 0xffffffff;
 		break;
 	case TARGET_DIF_TYPE2_PROT:
 		if (protect)
 			return TCM_INVALID_CDB_FIELD;
 
-		cmd->reftag_seed = cmd->t_task_lba;
+		cmd->t_iostate.reftag_seed = cmd->t_iostate.t_task_lba;
 		break;
 	case TARGET_DIF_TYPE1_PROT:
-		cmd->reftag_seed = cmd->t_task_lba;
+		cmd->t_iostate.reftag_seed = cmd->t_iostate.t_task_lba;
 		break;
 	case TARGET_DIF_TYPE0_PROT:
 		/*
@@ -783,8 +784,8 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 	if (sbc_set_prot_op_checks(protect, fabric_prot, pi_prot_type, is_write, cmd))
 		return TCM_INVALID_CDB_FIELD;
 
-	cmd->prot_type = pi_prot_type;
-	cmd->prot_length = dev->prot_length * sectors;
+	cmd->t_iostate.prot_type = pi_prot_type;
+	cmd->t_iostate.prot_length = dev->prot_length * sectors;
 
 	/**
 	 * In case protection information exists over the wire
@@ -793,12 +794,13 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 	 * length
 	 **/
 	if (protect)
-		cmd->data_length = sectors * dev->dev_attrib.block_size;
+		cmd->t_iostate.data_length = sectors * dev->dev_attrib.block_size;
 
-	pr_debug("%s: prot_type=%d, data_length=%d, prot_length=%d "
-		 "prot_op=%d prot_checks=%d\n",
-		 __func__, cmd->prot_type, cmd->data_length, cmd->prot_length,
-		 cmd->prot_op, cmd->prot_checks);
+	pr_debug("%s: prot_type=%d, t_iostate.data_length=%d, prot_length=%d "
+		 "prot_op=%d t_iostate.prot_checks=%d\n",
+		 __func__, cmd->t_iostate.prot_type, cmd->t_iostate.data_length,
+		 cmd->t_iostate.prot_length, cmd->t_iostate.prot_op,
+		 cmd->t_iostate.prot_checks);
 
 	return TCM_NO_SENSE;
 }
@@ -840,13 +842,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	switch (cdb[0]) {
 	case READ_6:
 		sectors = transport_get_sectors_6(cdb);
-		cmd->t_task_lba = transport_lba_21(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_10:
 		sectors = transport_get_sectors_10(cdb);
-		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
@@ -860,7 +862,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case READ_12:
 		sectors = transport_get_sectors_12(cdb);
-		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
@@ -874,7 +876,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case READ_16:
 		sectors = transport_get_sectors_16(cdb);
-		cmd->t_task_lba = transport_lba_64(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_64(cdb);
 
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
@@ -888,14 +890,14 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case WRITE_6:
 		sectors = transport_get_sectors_6(cdb);
-		cmd->t_task_lba = transport_lba_21(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_10:
 	case WRITE_VERIFY:
 		sectors = transport_get_sectors_10(cdb);
-		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
@@ -909,7 +911,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case WRITE_12:
 		sectors = transport_get_sectors_12(cdb);
-		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
@@ -923,7 +925,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case WRITE_16:
 		sectors = transport_get_sectors_16(cdb);
-		cmd->t_task_lba = transport_lba_64(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_64(cdb);
 
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
@@ -936,7 +938,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case XDWRITEREAD_10:
-		if (cmd->data_direction != DMA_TO_DEVICE ||
+		if (cmd->t_iostate.data_direction != DMA_TO_DEVICE ||
 		    !(cmd->se_cmd_flags & SCF_BIDI))
 			return TCM_INVALID_CDB_FIELD;
 		sectors = transport_get_sectors_10(cdb);
@@ -944,7 +946,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (sbc_check_dpofua(dev, cmd, cdb))
 			return TCM_INVALID_CDB_FIELD;
 
-		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 
 		/*
@@ -966,7 +968,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			 * Use WRITE_32 and READ_32 opcodes for the emulated
 			 * XDWRITE_READ_32 logic.
 			 */
-			cmd->t_task_lba = transport_lba_64_ext(cdb);
+			cmd->t_iostate.t_task_lba = transport_lba_64_ext(cdb);
 			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 
 			/*
@@ -985,7 +987,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			}
 
 			size = sbc_get_size(cmd, 1);
-			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
+			cmd->t_iostate.t_task_lba = get_unaligned_be64(&cdb[12]);
 
 			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
 			if (ret)
@@ -1016,8 +1018,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * zero is not an error..
 		 */
 		size = 2 * sbc_get_size(cmd, sectors);
-		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
-		cmd->t_task_nolb = sectors;
+		cmd->t_iostate.t_task_lba = get_unaligned_be64(&cdb[2]);
+		cmd->t_iostate.t_task_nolb = sectors;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB | SCF_COMPARE_AND_WRITE;
 		cmd->execute_cmd = sbc_compare_and_write;
 		cmd->transport_complete_callback = compare_and_write_callback;
@@ -1046,10 +1048,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case SYNCHRONIZE_CACHE_16:
 		if (cdb[0] == SYNCHRONIZE_CACHE) {
 			sectors = transport_get_sectors_10(cdb);
-			cmd->t_task_lba = transport_lba_32(cdb);
+			cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 		} else {
 			sectors = transport_get_sectors_16(cdb);
-			cmd->t_task_lba = transport_lba_64(cdb);
+			cmd->t_iostate.t_task_lba = transport_lba_64(cdb);
 		}
 		if (ops->execute_sync_cache) {
 			cmd->execute_cmd = ops->execute_sync_cache;
@@ -1078,7 +1080,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		}
 
 		size = sbc_get_size(cmd, 1);
-		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
+		cmd->t_iostate.t_task_lba = get_unaligned_be64(&cdb[2]);
 
 		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
 		if (ret)
@@ -1092,7 +1094,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		}
 
 		size = sbc_get_size(cmd, 1);
-		cmd->t_task_lba = get_unaligned_be32(&cdb[2]);
+		cmd->t_iostate.t_task_lba = get_unaligned_be32(&cdb[2]);
 
 		/*
 		 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
@@ -1105,7 +1107,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case VERIFY:
 		size = 0;
 		sectors = transport_get_sectors_10(cdb);
-		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_iostate.t_task_lba = transport_lba_32(cdb);
 		cmd->execute_cmd = sbc_emulate_noop;
 		goto check_lba;
 	case REZERO_UNIT:
@@ -1138,11 +1140,11 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		unsigned long long end_lba;
 check_lba:
 		end_lba = dev->transport->get_blocks(dev) + 1;
-		if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
-		    ((cmd->t_task_lba + sectors) > end_lba)) {
+		if (((cmd->t_iostate.t_task_lba + sectors) < cmd->t_iostate.t_task_lba) ||
+		    ((cmd->t_iostate.t_task_lba + sectors) > end_lba)) {
 			pr_err("cmd exceeds last lba %llu "
 				"(lba %llu, sectors %u)\n",
-				end_lba, cmd->t_task_lba, sectors);
+				end_lba, cmd->t_iostate.t_task_lba, sectors);
 			return TCM_ADDRESS_OUT_OF_RANGE;
 		}
 
@@ -1176,14 +1178,14 @@ sbc_execute_unmap(struct se_cmd *cmd)
 	if (cmd->t_task_cdb[1])
 		return TCM_INVALID_CDB_FIELD;
 
-	if (cmd->data_length == 0) {
+	if (cmd->t_iostate.data_length == 0) {
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 		return 0;
 	}
 
-	if (cmd->data_length < 8) {
+	if (cmd->t_iostate.data_length < 8) {
 		pr_warn("UNMAP parameter list length %u too small\n",
-			cmd->data_length);
+			cmd->t_iostate.data_length);
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
@@ -1194,10 +1196,10 @@ sbc_execute_unmap(struct se_cmd *cmd)
 	dl = get_unaligned_be16(&buf[0]);
 	bd_dl = get_unaligned_be16(&buf[2]);
 
-	size = cmd->data_length - 8;
+	size = cmd->t_iostate.data_length - 8;
 	if (bd_dl > size)
 		pr_warn("UNMAP parameter list length %u too small, ignoring bd_dl %u\n",
-			cmd->data_length, bd_dl);
+			cmd->t_iostate.data_length, bd_dl);
 	else
 		size = bd_dl;
 
@@ -1248,7 +1250,7 @@ sbc_dif_generate(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	struct t10_pi_tuple *sdt;
 	struct scatterlist *dsg = cmd->t_iomem.t_data_sg, *psg;
-	sector_t sector = cmd->t_task_lba;
+	sector_t sector = cmd->t_iostate.t_task_lba;
 	void *daddr, *paddr;
 	int i, j, offset = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
@@ -1291,13 +1293,13 @@ sbc_dif_generate(struct se_cmd *cmd)
 			}
 
 			sdt->guard_tag = cpu_to_be16(crc);
-			if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
+			if (cmd->t_iostate.prot_type == TARGET_DIF_TYPE1_PROT)
 				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
 			sdt->app_tag = 0;
 
 			pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
 				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (cmd->data_direction == DMA_TO_DEVICE) ?
+				 (cmd->t_iostate.data_direction == DMA_TO_DEVICE) ?
 				 "WRITE" : "READ", (unsigned long long)sector,
 				 sdt->guard_tag, sdt->app_tag,
 				 be32_to_cpu(sdt->ref_tag));
@@ -1316,7 +1318,7 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 {
 	__be16 csum;
 
-	if (!(cmd->prot_checks & TARGET_DIF_CHECK_GUARD))
+	if (!(cmd->t_iostate.prot_checks & TARGET_DIF_CHECK_GUARD))
 		goto check_ref;
 
 	csum = cpu_to_be16(crc);
@@ -1329,10 +1331,10 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 	}
 
 check_ref:
-	if (!(cmd->prot_checks & TARGET_DIF_CHECK_REFTAG))
+	if (!(cmd->t_iostate.prot_checks & TARGET_DIF_CHECK_REFTAG))
 		return 0;
 
-	if (cmd->prot_type == TARGET_DIF_TYPE1_PROT &&
+	if (cmd->t_iostate.prot_type == TARGET_DIF_TYPE1_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
 		pr_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
 		       " sector MSB: 0x%08x\n", (unsigned long long)sector,
@@ -1340,7 +1342,7 @@ check_ref:
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
 
-	if (cmd->prot_type == TARGET_DIF_TYPE2_PROT &&
+	if (cmd->t_iostate.prot_type == TARGET_DIF_TYPE2_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
 		pr_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
 		       " ei_lba: 0x%08x\n", (unsigned long long)sector,
@@ -1463,7 +1465,7 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			if (rc) {
 				kunmap_atomic(daddr - dsg->offset);
 				kunmap_atomic(paddr - psg->offset);
-				cmd->bad_sector = sector;
+				cmd->t_iostate.bad_sector = sector;
 				return rc;
 			}
 next:
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 2a91ed3..2364de7 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -752,7 +752,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 out:
 	rbuf = transport_kmap_data_sg(cmd);
 	if (rbuf) {
-		memcpy(rbuf, buf, min_t(u32, SE_INQUIRY_BUF, cmd->data_length));
+		memcpy(rbuf, buf, min_t(u32, SE_INQUIRY_BUF, cmd->t_iostate.data_length));
 		transport_kunmap_data_sg(cmd);
 	}
 	kfree(buf);
@@ -1099,7 +1099,7 @@ set_length:
 
 	rbuf = transport_kmap_data_sg(cmd);
 	if (rbuf) {
-		memcpy(rbuf, buf, min_t(u32, SE_MODE_PAGE_BUF, cmd->data_length));
+		memcpy(rbuf, buf, min_t(u32, SE_MODE_PAGE_BUF, cmd->t_iostate.data_length));
 		transport_kunmap_data_sg(cmd);
 	}
 
@@ -1120,12 +1120,12 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	sense_reason_t ret = 0;
 	int i;
 
-	if (!cmd->data_length) {
+	if (!cmd->t_iostate.data_length) {
 		target_complete_cmd(cmd, GOOD);
 		return 0;
 	}
 
-	if (cmd->data_length < off + 2)
+	if (cmd->t_iostate.data_length < off + 2)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 
 	buf = transport_kmap_data_sg(cmd);
@@ -1152,7 +1152,7 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	goto out;
 
 check_contents:
-	if (cmd->data_length < off + length) {
+	if (cmd->t_iostate.data_length < off + length) {
 		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
 		goto out;
 	}
@@ -1194,7 +1194,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	else
 		scsi_build_sense_buffer(desc_format, buf, NO_SENSE, 0x0, 0x0);
 
-	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+	memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->t_iostate.data_length));
 	transport_kunmap_data_sg(cmd);
 
 	target_complete_cmd(cmd, GOOD);
@@ -1212,7 +1212,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	__be32 len;
 
 	buf = transport_kmap_data_sg(cmd);
-	if (cmd->data_length && !buf)
+	if (cmd->t_iostate.data_length && !buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	/*
@@ -1233,12 +1233,12 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		 * See SPC2-R20 7.19.
 		 */
 		lun_count++;
-		if (offset >= cmd->data_length)
+		if (offset >= cmd->t_iostate.data_length)
 			continue;
 
 		int_to_scsilun(deve->mapped_lun, &slun);
 		memcpy(buf + offset, &slun,
-		       min(8u, cmd->data_length - offset));
+		       min(8u, cmd->t_iostate.data_length - offset));
 		offset += 8;
 	}
 	rcu_read_unlock();
@@ -1252,15 +1252,15 @@ done:
 	 */
 	if (lun_count == 0) {
 		int_to_scsilun(0, &slun);
-		if (cmd->data_length > 8)
+		if (cmd->t_iostate.data_length > 8)
 			memcpy(buf + offset, &slun,
-			       min(8u, cmd->data_length - offset));
+			       min(8u, cmd->t_iostate.data_length - offset));
 		lun_count = 1;
 	}
 
 	if (buf) {
 		len = cpu_to_be32(lun_count * 8);
-		memcpy(buf, &len, min_t(int, sizeof len, cmd->data_length));
+		memcpy(buf, &len, min_t(int, sizeof len, cmd->t_iostate.data_length));
 		transport_kunmap_data_sg(cmd);
 	}
 
@@ -1316,7 +1316,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		if (cdb[0] == RELEASE_10)
 			*size = (cdb[7] << 8) | cdb[8];
 		else
-			*size = cmd->data_length;
+			*size = cmd->t_iostate.data_length;
 
 		cmd->execute_cmd = target_scsi2_reservation_release;
 		break;
@@ -1329,7 +1329,7 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		if (cdb[0] == RESERVE_10)
 			*size = (cdb[7] << 8) | cdb[8];
 		else
-			*size = cmd->data_length;
+			*size = cmd->t_iostate.data_length;
 
 		cmd->execute_cmd = target_scsi2_reservation_reserve;
 		break;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e1e7c49..18661da 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -754,15 +754,15 @@ EXPORT_SYMBOL(target_complete_cmd);
 
 void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
 {
-	if (scsi_status == SAM_STAT_GOOD && length < cmd->data_length) {
+	if (scsi_status == SAM_STAT_GOOD && length < cmd->t_iostate.data_length) {
 		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
-			cmd->residual_count += cmd->data_length - length;
+			cmd->residual_count += cmd->t_iostate.data_length - length;
 		} else {
 			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-			cmd->residual_count = cmd->data_length - length;
+			cmd->residual_count = cmd->t_iostate.data_length - length;
 		}
 
-		cmd->data_length = length;
+		cmd->t_iostate.data_length = length;
 	}
 
 	target_complete_cmd(cmd, scsi_status);
@@ -818,7 +818,7 @@ void target_qf_do_work(struct work_struct *work)
 
 unsigned char *transport_dump_cmd_direction(struct se_cmd *cmd)
 {
-	switch (cmd->data_direction) {
+	switch (cmd->t_iostate.data_direction) {
 	case DMA_NONE:
 		return "NONE";
 	case DMA_FROM_DEVICE:
@@ -1118,21 +1118,21 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
 		return TCM_NO_SENSE;
 	/*
 	 * Check if fabric enforced maximum SGL entries per I/O descriptor
-	 * exceeds se_cmd->data_length.  If true, set SCF_UNDERFLOW_BIT +
-	 * residual_count and reduce original cmd->data_length to maximum
+	 * exceeds se_cmd->t_iostate.data_length.  If true, set SCF_UNDERFLOW_BIT +
+	 * residual_count and reduce original cmd->t_iostate.data_length to maximum
 	 * length based on single PAGE_SIZE entry scatter-lists.
 	 */
 	mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE);
-	if (cmd->data_length > mtl) {
+	if (cmd->t_iostate.data_length > mtl) {
 		/*
 		 * If an existing CDB overflow is present, calculate new residual
 		 * based on CDB size minus fabric maximum transfer length.
 		 *
 		 * If an existing CDB underflow is present, calculate new residual
-		 * based on original cmd->data_length minus fabric maximum transfer
+		 * based on original cmd->t_iostate.data_length minus fabric maximum transfer
 		 * length.
 		 *
-		 * Otherwise, set the underflow residual based on cmd->data_length
+		 * Otherwise, set the underflow residual based on cmd->t_iostate.data_length
 		 * minus fabric maximum transfer length.
 		 */
 		if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
@@ -1142,16 +1142,16 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
 			cmd->residual_count = (orig_dl - mtl);
 		} else {
 			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-			cmd->residual_count = (cmd->data_length - mtl);
+			cmd->residual_count = (cmd->t_iostate.data_length - mtl);
 		}
-		cmd->data_length = mtl;
+		cmd->t_iostate.data_length = mtl;
 		/*
 		 * Reset sbc_check_prot() calculated protection payload
 		 * length based upon the new smaller MTL.
 		 */
-		if (cmd->prot_length) {
+		if (cmd->t_iostate.prot_length) {
 			u32 sectors = (mtl / dev->dev_attrib.block_size);
-			cmd->prot_length = dev->prot_length * sectors;
+			cmd->t_iostate.prot_length = dev->prot_length * sectors;
 		}
 	}
 	return TCM_NO_SENSE;
@@ -1163,14 +1163,14 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 	struct se_device *dev = cmd->se_dev;
 
 	if (cmd->unknown_data_length) {
-		cmd->data_length = size;
-	} else if (size != cmd->data_length) {
+		cmd->t_iostate.data_length = size;
+	} else if (size != cmd->t_iostate.data_length) {
 		pr_warn("TARGET_CORE[%s]: Expected Transfer Length:"
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
-				cmd->data_length, size, cmd->t_task_cdb[0]);
+				cmd->t_iostate.data_length, size, cmd->t_task_cdb[0]);
 
-		if (cmd->data_direction == DMA_TO_DEVICE &&
+		if (cmd->t_iostate.data_direction == DMA_TO_DEVICE &&
 		    cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
 			pr_err("Rejecting underflow/overflow WRITE data\n");
 			return TCM_INVALID_CDB_FIELD;
@@ -1188,17 +1188,17 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 		}
 		/*
 		 * For the overflow case keep the existing fabric provided
-		 * ->data_length.  Otherwise for the underflow case, reset
-		 * ->data_length to the smaller SCSI expected data transfer
+		 * ->t_iostate.data_length.  Otherwise for the underflow case, reset
+		 * ->t_iostate.data_length to the smaller SCSI expected data transfer
 		 * length.
 		 */
-		if (size > cmd->data_length) {
+		if (size > cmd->t_iostate.data_length) {
 			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
-			cmd->residual_count = (size - cmd->data_length);
+			cmd->residual_count = (size - cmd->t_iostate.data_length);
 		} else {
 			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-			cmd->residual_count = (cmd->data_length - size);
-			cmd->data_length = size;
+			cmd->residual_count = (cmd->t_iostate.data_length - size);
+			cmd->t_iostate.data_length = size;
 		}
 	}
 
@@ -1233,8 +1233,8 @@ void transport_init_se_cmd(
 
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
-	cmd->data_length = data_length;
-	cmd->data_direction = data_direction;
+	cmd->t_iostate.data_length = data_length;
+	cmd->t_iostate.data_direction = data_direction;
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 
@@ -1418,7 +1418,7 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
  * @cdb: pointer to SCSI CDB
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @data_length: fabric expected data transfer length
+ * @t_iostate.data_length: fabric expected data transfer length
  * @task_addr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
@@ -1525,7 +1525,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		 * -> transport_generic_cmd_sequencer().
 		 */
 		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
-		     se_cmd->data_direction == DMA_FROM_DEVICE) {
+		     se_cmd->t_iostate.data_direction == DMA_FROM_DEVICE) {
 			unsigned char *buf = NULL;
 
 			if (sgl)
@@ -1564,7 +1564,7 @@ EXPORT_SYMBOL(target_submit_cmd_map_sgls);
  * @cdb: pointer to SCSI CDB
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @data_length: fabric expected data transfer length
+ * @t_iostate.data_length: fabric expected data transfer length
  * @task_addr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
@@ -1810,7 +1810,7 @@ static int target_write_prot_action(struct se_cmd *cmd)
 	 * device has PI enabled, if the transport has not already generated
 	 * PI using hardware WRITE_INSERT offload.
 	 */
-	switch (cmd->prot_op) {
+	switch (cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DOUT_INSERT:
 		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
 			sbc_dif_generate(cmd);
@@ -1819,8 +1819,8 @@ static int target_write_prot_action(struct se_cmd *cmd)
 		if (cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_STRIP)
 			break;
 
-		sectors = cmd->data_length >> ilog2(cmd->se_dev->dev_attrib.block_size);
-		cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
+		sectors = cmd->t_iostate.data_length >> ilog2(cmd->se_dev->dev_attrib.block_size);
+		cmd->pi_err = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba,
 					     sectors, 0, cmd->t_iomem.t_prot_sg, 0);
 		if (unlikely(cmd->pi_err)) {
 			spin_lock_irq(&cmd->t_state_lock);
@@ -1998,7 +1998,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		goto out;
 	}
 
-	switch (cmd->data_direction) {
+	switch (cmd->t_iostate.data_direction) {
 	case DMA_FROM_DEVICE:
 		if (cmd->scsi_status)
 			goto queue_status;
@@ -2044,13 +2044,13 @@ static void transport_handle_queue_full(
 
 static bool target_read_prot_action(struct se_cmd *cmd)
 {
-	switch (cmd->prot_op) {
+	switch (cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DIN_STRIP:
 		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
-			u32 sectors = cmd->data_length >>
+			u32 sectors = cmd->t_iostate.data_length >>
 				  ilog2(cmd->se_dev->dev_attrib.block_size);
 
-			cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
+			cmd->pi_err = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba,
 						     sectors, 0,
 						     cmd->t_iomem.t_prot_sg, 0);
 			if (cmd->pi_err)
@@ -2111,7 +2111,7 @@ static void target_complete_ok_work(struct work_struct *work)
 	if (cmd->transport_complete_callback) {
 		sense_reason_t rc;
 		bool caw = (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE);
-		bool zero_dl = !(cmd->data_length);
+		bool zero_dl = !(cmd->t_iostate.data_length);
 		int post_ret = 0;
 
 		rc = cmd->transport_complete_callback(cmd, true, &post_ret);
@@ -2133,12 +2133,12 @@ static void target_complete_ok_work(struct work_struct *work)
 	}
 
 queue_rsp:
-	switch (cmd->data_direction) {
+	switch (cmd->t_iostate.data_direction) {
 	case DMA_FROM_DEVICE:
 		if (cmd->scsi_status)
 			goto queue_status;
 
-		atomic_long_add(cmd->data_length,
+		atomic_long_add(cmd->t_iostate.data_length,
 				&cmd->se_lun->lun_stats.tx_data_octets);
 		/*
 		 * Perform READ_STRIP of PI using software emulation when
@@ -2162,13 +2162,13 @@ queue_rsp:
 			goto queue_full;
 		break;
 	case DMA_TO_DEVICE:
-		atomic_long_add(cmd->data_length,
+		atomic_long_add(cmd->t_iostate.data_length,
 				&cmd->se_lun->lun_stats.rx_data_octets);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
 		if (cmd->se_cmd_flags & SCF_BIDI) {
-			atomic_long_add(cmd->data_length,
+			atomic_long_add(cmd->t_iostate.data_length,
 					&cmd->se_lun->lun_stats.tx_data_octets);
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret == -EAGAIN || ret == -ENOMEM)
@@ -2193,7 +2193,7 @@ queue_status:
 
 queue_full:
 	pr_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
-		" data_direction: %d\n", cmd, cmd->data_direction);
+		" t_iostate.data_direction: %d\n", cmd, cmd->t_iostate.data_direction);
 	cmd->t_state = TRANSPORT_COMPLETE_QF_OK;
 	transport_handle_queue_full(cmd, cmd->se_dev);
 }
@@ -2381,11 +2381,11 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	int ret = 0;
 	bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
 
-	if (cmd->prot_op != TARGET_PROT_NORMAL &&
+	if (cmd->t_iostate.prot_op != TARGET_PROT_NORMAL &&
 	    !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
 		ret = target_alloc_sgl(&cmd->t_iomem.t_prot_sg,
 				       &cmd->t_iomem.t_prot_nents,
-				       cmd->prot_length, true, false);
+				       cmd->t_iostate.prot_length, true, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
@@ -2396,17 +2396,17 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * beforehand.
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) &&
-	    cmd->data_length) {
+	    cmd->t_iostate.data_length) {
 
 		if ((cmd->se_cmd_flags & SCF_BIDI) ||
 		    (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE)) {
 			u32 bidi_length;
 
 			if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE)
-				bidi_length = cmd->t_task_nolb *
+				bidi_length = cmd->t_iostate.t_task_nolb *
 					      cmd->se_dev->dev_attrib.block_size;
 			else
-				bidi_length = cmd->data_length;
+				bidi_length = cmd->t_iostate.data_length;
 
 			ret = target_alloc_sgl(&cmd->t_iomem.t_bidi_data_sg,
 					       &cmd->t_iomem.t_bidi_data_nents,
@@ -2417,16 +2417,16 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 
 		ret = target_alloc_sgl(&cmd->t_iomem.t_data_sg,
 				       &cmd->t_iomem.t_data_nents,
-				       cmd->data_length, zero_flag, false);
+				       cmd->t_iostate.data_length, zero_flag, false);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	} else if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
-		    cmd->data_length) {
+		    cmd->t_iostate.data_length) {
 		/*
 		 * Special case for COMPARE_AND_WRITE with fabrics
 		 * using SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC.
 		 */
-		u32 caw_length = cmd->t_task_nolb *
+		u32 caw_length = cmd->t_iostate.t_task_nolb *
 				 cmd->se_dev->dev_attrib.block_size;
 
 		ret = target_alloc_sgl(&cmd->t_iomem.t_bidi_data_sg,
@@ -2441,7 +2441,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * and let it call back once the write buffers are ready.
 	 */
 	target_add_to_state_list(cmd);
-	if (cmd->data_direction != DMA_TO_DEVICE || cmd->data_length == 0) {
+	if (cmd->t_iostate.data_direction != DMA_TO_DEVICE || cmd->t_iostate.data_length == 0) {
 		target_execute_cmd(cmd);
 		return 0;
 	}
@@ -2919,7 +2919,7 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	if (si->add_sector_info)
 		return scsi_set_sense_information(buffer,
 						  cmd->scsi_sense_length,
-						  cmd->bad_sector);
+						  cmd->t_iostate.bad_sector);
 
 	return 0;
 }
@@ -3016,7 +3016,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	 * response.  This response with TASK_ABORTED status will be
 	 * queued back to fabric module by transport_check_aborted_status().
 	 */
-	if (cmd->data_direction == DMA_TO_DEVICE) {
+	if (cmd->t_iostate.data_direction == DMA_TO_DEVICE) {
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			spin_lock_irqsave(&cmd->t_state_lock, flags);
 			if (cmd->se_cmd_flags & SCF_SEND_DELAYED_TAS) {
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5013611..d6758a1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -427,7 +427,7 @@ static int tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 
 	mb = udev->mb_addr;
 	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
-	data_length = se_cmd->data_length;
+	data_length = se_cmd->t_iostate.data_length;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		BUG_ON(!(se_cmd->t_iomem.t_bidi_data_sg &&
 			 se_cmd->t_iomem.t_bidi_data_nents));
@@ -493,7 +493,7 @@ static int tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	 */
 	iov = &entry->req.iov[0];
 	iov_cnt = 0;
-	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
+	copy_to_data_area = (se_cmd->t_iostate.data_direction == DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
 	alloc_and_scatter_data_area(udev, se_cmd->t_iomem.t_data_sg,
 		se_cmd->t_iomem.t_data_nents, &iov, &iov_cnt, copy_to_data_area);
@@ -587,18 +587,18 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		gather_data_area(udev, bitmap,
 			se_cmd->t_iomem.t_bidi_data_sg, se_cmd->t_iomem.t_bidi_data_nents);
 		free_data_area(udev, cmd);
-	} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+	} else if (se_cmd->t_iostate.data_direction == DMA_FROM_DEVICE) {
 		DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);
 
 		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
 		gather_data_area(udev, bitmap,
 			se_cmd->t_iomem.t_data_sg, se_cmd->t_iomem.t_data_nents);
 		free_data_area(udev, cmd);
-	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
+	} else if (se_cmd->t_iostate.data_direction == DMA_TO_DEVICE) {
 		free_data_area(udev, cmd);
-	} else if (se_cmd->data_direction != DMA_NONE) {
+	} else if (se_cmd->t_iostate.data_direction != DMA_NONE) {
 		pr_warn("TCMU: data direction was %d!\n",
-			se_cmd->data_direction);
+			se_cmd->t_iostate.data_direction);
 	}
 
 	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 0a4bd8a..b6aeb15 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -564,7 +564,7 @@ static int target_xcopy_setup_pt_cmd(
 	if (alloc_mem) {
 		rc = target_alloc_sgl(&cmd->t_iomem.t_data_sg,
 				      &cmd->t_iomem.t_data_nents,
-				      cmd->data_length, false, false);
+				      cmd->t_iostate.data_length, false, false);
 		if (rc < 0) {
 			ret = rc;
 			goto out;
@@ -607,7 +607,7 @@ static int target_xcopy_issue_pt_cmd(struct xcopy_pt_cmd *xpt_cmd)
 	if (sense_rc)
 		return -EINVAL;
 
-	if (se_cmd->data_direction == DMA_TO_DEVICE)
+	if (se_cmd->t_iostate.data_direction == DMA_TO_DEVICE)
 		target_execute_cmd(se_cmd);
 
 	wait_for_completion_interruptible(&xpt_cmd->xpt_passthrough_sem);
@@ -927,9 +927,9 @@ static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
 		return TCM_OUT_OF_RESOURCES;
 	}
 
-	if (se_cmd->data_length < 54) {
+	if (se_cmd->t_iostate.data_length < 54) {
 		pr_err("Receive Copy Results Op Parameters length"
-		       " too small: %u\n", se_cmd->data_length);
+		       " too small: %u\n", se_cmd->t_iostate.data_length);
 		transport_kunmap_data_sg(se_cmd);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -1013,7 +1013,7 @@ sense_reason_t target_do_receive_copy_results(struct se_cmd *se_cmd)
 	sense_reason_t rc = TCM_NO_SENSE;
 
 	pr_debug("Entering target_do_receive_copy_results: SA: 0x%02x, List ID:"
-		" 0x%02x, AL: %u\n", sa, list_id, se_cmd->data_length);
+		" 0x%02x, AL: %u\n", sa, list_id, se_cmd->t_iostate.data_length);
 
 	if (list_id != 0) {
 		pr_err("Receive Copy Results with non zero list identifier"
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 04c98d0..b3730e9 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -56,7 +56,7 @@ static void _ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 
 	pr_debug("%s: cmd %p data_nents %u len %u se_cmd_flags <0x%x>\n",
 		caller, cmd, se_cmd->t_iomem.t_data_nents,
-	       se_cmd->data_length, se_cmd->se_cmd_flags);
+	       se_cmd->t_iostate.data_length, se_cmd->se_cmd_flags);
 
 	for_each_sg(se_cmd->t_iomem.t_data_sg, sg, se_cmd->t_iomem.t_data_nents, count)
 		pr_debug("%s: cmd %p sg %p page %p "
@@ -191,7 +191,7 @@ int ft_write_pending_status(struct se_cmd *se_cmd)
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
 
-	return cmd->write_data_len != se_cmd->data_length;
+	return cmd->write_data_len != se_cmd->t_iostate.data_length;
 }
 
 /*
@@ -219,7 +219,7 @@ int ft_write_pending(struct se_cmd *se_cmd)
 
 	txrdy = fc_frame_payload_get(fp, sizeof(*txrdy));
 	memset(txrdy, 0, sizeof(*txrdy));
-	txrdy->ft_burst_len = htonl(se_cmd->data_length);
+	txrdy->ft_burst_len = htonl(se_cmd->t_iostate.data_length);
 
 	cmd->seq = lport->tt.seq_start_next(cmd->seq);
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_DATA_DESC, ep->did, ep->sid, FC_TYPE_FCP,
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 86ae4c5..0c98099 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -84,7 +84,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 	lport = ep->lp;
 	cmd->seq = lport->tt.seq_start_next(cmd->seq);
 
-	remaining = se_cmd->data_length;
+	remaining = se_cmd->t_iostate.data_length;
 
 	/*
 	 * Setup to use first mem list entry, unless no data.
@@ -279,10 +279,10 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		goto drop;
 	frame_len -= sizeof(*fh);
 	from = fc_frame_payload_get(fp, 0);
-	if (rel_off >= se_cmd->data_length)
+	if (rel_off >= se_cmd->t_iostate.data_length)
 		goto drop;
-	if (frame_len + rel_off > se_cmd->data_length)
-		frame_len = se_cmd->data_length - rel_off;
+	if (frame_len + rel_off > se_cmd->t_iostate.data_length)
+		frame_len = se_cmd->t_iostate.data_length - rel_off;
 
 	/*
 	 * Setup to use first mem list entry, unless no data.
@@ -328,7 +328,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		cmd->write_data_len += tlen;
 	}
 last_frame:
-	if (cmd->write_data_len == se_cmd->data_length) {
+	if (cmd->write_data_len == se_cmd->t_iostate.data_length) {
 		INIT_WORK(&cmd->work, ft_execute_work);
 		queue_work(cmd->sess->tport->tpg->workqueue, &cmd->work);
 	}
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 8986132..66a2803 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -213,14 +213,14 @@ static int bot_send_read_response(struct usbg_cmd *cmd)
 	}
 
 	if (!gadget->sg_supported) {
-		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_ATOMIC);
+		cmd->data_buf = kmalloc(se_cmd->t_iostate.data_length, GFP_ATOMIC);
 		if (!cmd->data_buf)
 			return -ENOMEM;
 
 		sg_copy_to_buffer(se_cmd->t_iomem.t_data_sg,
 				se_cmd->t_iomem.t_data_nents,
 				cmd->data_buf,
-				se_cmd->data_length);
+				se_cmd->t_iostate.data_length);
 
 		fu->bot_req_in->buf = cmd->data_buf;
 	} else {
@@ -230,7 +230,7 @@ static int bot_send_read_response(struct usbg_cmd *cmd)
 	}
 
 	fu->bot_req_in->complete = bot_read_compl;
-	fu->bot_req_in->length = se_cmd->data_length;
+	fu->bot_req_in->length = se_cmd->t_iostate.data_length;
 	fu->bot_req_in->context = cmd;
 	ret = usb_ep_queue(fu->ep_in, fu->bot_req_in, GFP_ATOMIC);
 	if (ret)
@@ -257,7 +257,7 @@ static int bot_send_write_request(struct usbg_cmd *cmd)
 	}
 
 	if (!gadget->sg_supported) {
-		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_KERNEL);
+		cmd->data_buf = kmalloc(se_cmd->t_iostate.data_length, GFP_KERNEL);
 		if (!cmd->data_buf)
 			return -ENOMEM;
 
@@ -269,7 +269,7 @@ static int bot_send_write_request(struct usbg_cmd *cmd)
 	}
 
 	fu->bot_req_out->complete = usbg_data_write_cmpl;
-	fu->bot_req_out->length = se_cmd->data_length;
+	fu->bot_req_out->length = se_cmd->t_iostate.data_length;
 	fu->bot_req_out->context = cmd;
 
 	ret = usbg_prepare_w_request(cmd, fu->bot_req_out);
@@ -515,14 +515,14 @@ static int uasp_prepare_r_request(struct usbg_cmd *cmd)
 	struct uas_stream *stream = cmd->stream;
 
 	if (!gadget->sg_supported) {
-		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_ATOMIC);
+		cmd->data_buf = kmalloc(se_cmd->t_iostate.data_length, GFP_ATOMIC);
 		if (!cmd->data_buf)
 			return -ENOMEM;
 
 		sg_copy_to_buffer(se_cmd->t_iomem.t_data_sg,
 				se_cmd->t_iomem.t_data_nents,
 				cmd->data_buf,
-				se_cmd->data_length);
+				se_cmd->t_iostate.data_length);
 
 		stream->req_in->buf = cmd->data_buf;
 	} else {
@@ -532,7 +532,7 @@ static int uasp_prepare_r_request(struct usbg_cmd *cmd)
 	}
 
 	stream->req_in->complete = uasp_status_data_cmpl;
-	stream->req_in->length = se_cmd->data_length;
+	stream->req_in->length = se_cmd->t_iostate.data_length;
 	stream->req_in->context = cmd;
 
 	cmd->state = UASP_SEND_STATUS;
@@ -963,7 +963,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
 		sg_copy_from_buffer(se_cmd->t_iomem.t_data_sg,
 				se_cmd->t_iomem.t_data_nents,
 				cmd->data_buf,
-				se_cmd->data_length);
+				se_cmd->t_iostate.data_length);
 	}
 
 	complete(&cmd->write_complete);
@@ -980,7 +980,7 @@ static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
 	struct usb_gadget *gadget = fuas_to_gadget(fu);
 
 	if (!gadget->sg_supported) {
-		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_ATOMIC);
+		cmd->data_buf = kmalloc(se_cmd->t_iostate.data_length, GFP_ATOMIC);
 		if (!cmd->data_buf)
 			return -ENOMEM;
 
@@ -992,7 +992,7 @@ static int usbg_prepare_w_request(struct usbg_cmd *cmd, struct usb_request *req)
 	}
 
 	req->complete = usbg_data_write_cmpl;
-	req->length = se_cmd->data_length;
+	req->length = se_cmd->t_iostate.data_length;
 	req->context = cmd;
 	return 0;
 }
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 9d6320e..ac46c55 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -793,7 +793,7 @@ static void vhost_scsi_submission_work(struct work_struct *work)
 		if (cmd->tvc_prot_sgl_count)
 			sg_prot_ptr = cmd->tvc_prot_sgl;
 		else
-			se_cmd->prot_pto = true;
+			se_cmd->t_iostate.prot_pto = true;
 	} else {
 		sg_ptr = NULL;
 	}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 29ee45b..bd4346b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -449,6 +449,29 @@ struct target_iomem {
 	unsigned int		t_prot_nents;
 };
 
+struct target_iostate {
+	unsigned long long	t_task_lba;
+	unsigned int		t_task_nolb;
+	/* Total size in bytes associated with command */
+	unsigned int		data_length;
+	/* See include/linux/dma-mapping.h */
+	enum dma_data_direction data_direction;
+
+	/* DIF related members */
+	enum target_prot_op	prot_op;
+	enum target_prot_type	prot_type;
+	u8			prot_checks;
+	bool			prot_pto;
+	u32			prot_length;
+	u32			reftag_seed;
+	sector_t		bad_sector;
+
+	struct target_iomem	*iomem;
+	struct se_device	*se_dev;
+	void			(*t_comp_func)(struct target_iostate *, u16);
+	void			*priv;
+};
+
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
@@ -461,8 +484,6 @@ struct se_cmd {
 	u64			tag; /* SAM command identifier aka task tag */
 	/* Delay for ALUA Active/NonOptimized state access in milliseconds */
 	int			alua_nonop_delay;
-	/* See include/linux/dma-mapping.h */
-	enum dma_data_direction	data_direction;
 	/* For SAM Task Attribute */
 	int			sam_task_attr;
 	/* Used for se_sess->sess_tag_pool */
@@ -471,8 +492,6 @@ struct se_cmd {
 	enum transport_state_table t_state;
 	/* See se_cmd_flags_table */
 	u32			se_cmd_flags;
-	/* Total size in bytes associated with command */
-	u32			data_length;
 	u32			residual_count;
 	u64			orig_fe_lun;
 	/* Persistent Reservation key */
@@ -495,8 +514,7 @@ struct se_cmd {
 
 	unsigned char		*t_task_cdb;
 	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
-	unsigned long long	t_task_lba;
-	unsigned int		t_task_nolb;
+
 	unsigned int		transport_state;
 #define CMD_T_ABORTED		(1 << 0)
 #define CMD_T_ACTIVE		(1 << 1)
@@ -512,6 +530,7 @@ struct se_cmd {
 	struct completion	t_transport_stop_comp;
 
 	struct work_struct	work;
+	struct target_iostate	t_iostate;
 	struct target_iomem	t_iomem;
 
 	/* Used for lun->lun_ref counting */
@@ -522,15 +541,7 @@ struct se_cmd {
 	/* backend private data */
 	void			*priv;
 
-	/* DIF related members */
-	enum target_prot_op	prot_op;
-	enum target_prot_type	prot_type;
-	u8			prot_checks;
-	bool			prot_pto;
-	u32			prot_length;
-	u32			reftag_seed;
 	sense_reason_t		pi_err;
-	sector_t		bad_sector;
 	int			cpuid;
 };
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 5cd6faa..86b84d0d 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -197,7 +197,7 @@ target_reverse_dma_direction(struct se_cmd *se_cmd)
 	if (se_cmd->se_cmd_flags & SCF_BIDI)
 		return DMA_BIDIRECTIONAL;
 
-	switch (se_cmd->data_direction) {
+	switch (se_cmd->t_iostate.data_direction) {
 	case DMA_TO_DEVICE:
 		return DMA_FROM_DEVICE;
 	case DMA_FROM_DEVICE:
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index 50fea66..7c3743d 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -146,7 +146,7 @@ TRACE_EVENT(target_sequencer_start,
 	TP_fast_assign(
 		__entry->unpacked_lun	= cmd->orig_fe_lun;
 		__entry->opcode		= cmd->t_task_cdb[0];
-		__entry->data_length	= cmd->data_length;
+		__entry->data_length	= cmd->t_iostate.data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
 		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
 		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
@@ -184,7 +184,7 @@ TRACE_EVENT(target_cmd_complete,
 	TP_fast_assign(
 		__entry->unpacked_lun	= cmd->orig_fe_lun;
 		__entry->opcode		= cmd->t_task_cdb[0];
-		__entry->data_length	= cmd->data_length;
+		__entry->data_length	= cmd->t_iostate.data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
 		__entry->scsi_status	= cmd->scsi_status;
 		__entry->sense_length	= cmd->scsi_status == SAM_STAT_CHECK_CONDITION ?
-- 
1.9.1
