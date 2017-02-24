From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 06/14] qla2xxx: Improve T10-DIF/PI handling in driver.
Date: Fri, 24 Feb 2017 13:37:35 -0800
Message-ID: <1487972263-3795-7-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add routines to support T10 DIF tag.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h     |   1 +
 drivers/scsi/qla2xxx/qla_dfs.c     |   8 +
 drivers/scsi/qla2xxx/qla_target.c  | 521 ++++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_target.h  |  35 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  49 ++--
 5 files changed, 377 insertions(+), 237 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index e1fc4e6..c6bffe9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -348,6 +348,7 @@ void __attribute__((format (printf, 4, 5)))
 #define ql_dbg_tgt	0x00004000 /* Target mode */
 #define ql_dbg_tgt_mgt	0x00002000 /* Target mode management */
 #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
+#define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
 
 extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 0fb33e6..dabeb8b 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -360,6 +360,14 @@
 		goto out;
 	}
 
+	ha->tgt.dfs_tgt_port_database = debugfs_create_file("tgt_port_database",
+	    S_IRUSR,  ha->dfs_dir, vha, &dfs_tgt_port_database_ops);
+	if (!ha->tgt.dfs_tgt_port_database) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		    "Unable to create debugFS tgt_port_database node.\n");
+		goto out;
+	}
+
 	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, vha,
 	    &dfs_fce_ops);
 	if (!ha->dfs_fce) {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6b60765b5..873cbf7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -140,6 +140,20 @@ static struct fc_port *qlt_create_sess(struct scsi_qla_host *vha,
 static DEFINE_MUTEX(qla_tgt_mutex);
 static LIST_HEAD(qla_tgt_glist);
 
+static const char *prot_op_str(u32 prot_op)
+{
+	switch (prot_op) {
+	case TARGET_PROT_NORMAL:	return "NORMAL";
+	case TARGET_PROT_DIN_INSERT:	return "DIN_INSERT";
+	case TARGET_PROT_DOUT_INSERT:	return "DOUT_INSERT";
+	case TARGET_PROT_DIN_STRIP:	return "DIN_STRIP";
+	case TARGET_PROT_DOUT_STRIP:	return "DOUT_STRIP";
+	case TARGET_PROT_DIN_PASS:	return "DIN_PASS";
+	case TARGET_PROT_DOUT_PASS:	return "DOUT_PASS";
+	default:			return "UNKNOWN";
+	}
+}
+
 /* This API intentionally takes dest as a parameter, rather than returning
  * int value to avoid caller forgetting to issue wmb() after the store */
 void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
@@ -2018,6 +2032,71 @@ void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 }
 EXPORT_SYMBOL(qlt_free_mcmd);
 
+/*
+ * ha->hardware_lock supposed to be held on entry. Might drop it, then
+ * reacquire
+ */
+void qlt_send_resp_ctio(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
+    uint8_t scsi_status, uint8_t sense_key, uint8_t asc, uint8_t ascq)
+{
+	struct atio_from_isp *atio = &cmd->atio;
+	struct ctio7_to_24xx *ctio;
+	uint16_t temp;
+
+	ql_dbg(ql_dbg_tgt_dif, vha, 0x3066,
+	    "Sending response CTIO7 (vha=%p, atio=%p, scsi_status=%02x, "
+	    "sense_key=%02x, asc=%02x, ascq=%02x",
+	    vha, atio, scsi_status, sense_key, asc, ascq);
+
+	ctio = (struct ctio7_to_24xx *)qla2x00_alloc_iocbs(vha, NULL);
+	if (!ctio) {
+		ql_dbg(ql_dbg_async, vha, 0x3067,
+		    "qla2x00t(%ld): %s failed: unable to allocate request packet",
+		    vha->host_no, __func__);
+		goto out;
+	}
+
+	ctio->entry_type = CTIO_TYPE7;
+	ctio->entry_count = 1;
+	ctio->handle = QLA_TGT_SKIP_HANDLE;
+	ctio->nport_handle = cmd->sess->loop_id;
+	ctio->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
+	ctio->vp_index = vha->vp_idx;
+	ctio->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
+	ctio->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
+	ctio->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
+	ctio->exchange_addr = atio->u.isp24.exchange_addr;
+	ctio->u.status1.flags = (atio->u.isp24.attr << 9) |
+	    cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS);
+	temp = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
+	ctio->u.status1.ox_id = cpu_to_le16(temp);
+	ctio->u.status1.scsi_status =
+	    cpu_to_le16(SS_RESPONSE_INFO_LEN_VALID | scsi_status);
+	ctio->u.status1.response_len = cpu_to_le16(18);
+	ctio->u.status1.residual = cpu_to_le32(get_datalen_for_atio(atio));
+
+	if (ctio->u.status1.residual != 0)
+		ctio->u.status1.scsi_status |=
+		    cpu_to_le16(SS_RESIDUAL_UNDER);
+
+	/* Response code and sense key */
+	put_unaligned_le32(((0x70 << 24) | (sense_key << 8)),
+	    (&ctio->u.status1.sense_data)[0]);
+	/* Additional sense length */
+	put_unaligned_le32(0x0a,
+	    (&ctio->u.status1.sense_data)[1]);
+	/* ASC and ASCQ */
+	put_unaligned_le32(((asc << 24) | (ascq << 16)),
+	    (&ctio->u.status1.sense_data)[3]);
+
+	/* Memory Barrier */
+	wmb();
+
+	qla2x00_start_iocbs(vha, vha->req);
+out:
+	return;
+}
+
 /* callback from target fabric module code */
 void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 {
@@ -2268,7 +2347,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_tgt_prm *prm,
 	} else
 		ha->tgt.cmds[h-1] = prm->cmd;
 
-	pkt->handle = h | CTIO_COMPLETION_HANDLE_MARK;
+	pkt->handle = CTIO_COMPLETION_HANDLE_MARK;
 	pkt->nport_handle = prm->cmd->loop_id;
 	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
 	pkt->initiator_id[0] = atio->u.isp24.fcp_hdr.s_id[2];
@@ -2396,6 +2475,50 @@ static inline int qlt_has_data(struct qla_tgt_cmd *cmd)
 	return cmd->bufflen > 0;
 }
 
+static void qlt_print_dif_err(struct qla_tgt_prm *prm)
+{
+	struct qla_tgt_cmd *cmd;
+	struct scsi_qla_host *vha;
+
+	/* asc 0x10=dif error */
+	if (prm->sense_buffer && (prm->sense_buffer[12] == 0x10)) {
+		cmd = prm->cmd;
+		vha = cmd->vha;
+		/* ASCQ */
+		switch (prm->sense_buffer[13]) {
+		case 1:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			    "BE detected Guard TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+			    "se_cmd=%p tag[%x]",
+			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+			    cmd->atio.u.isp24.exchange_addr);
+			break;
+		case 2:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			    "BE detected APP TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+			    "se_cmd=%p tag[%x]",
+			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+			    cmd->atio.u.isp24.exchange_addr);
+			break;
+		case 3:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			    "BE detected REF TAG ERR: lba[0x%llx|%lld] len[0x%x] "
+			    "se_cmd=%p tag[%x]",
+			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+			    cmd->atio.u.isp24.exchange_addr);
+			break;
+		default:
+			ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			    "BE detected Dif ERR: lba[%llx|%lld] len[%x] "
+			    "se_cmd=%p tag[%x]",
+			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
+			    cmd->atio.u.isp24.exchange_addr);
+			break;
+		}
+		ql_dump_buffer(ql_dbg_tgt_dif, vha, 0xffff, cmd->cdb, 16);
+	}
+}
+
 /*
  * Called without ha->hardware_lock held
  */
@@ -2517,18 +2640,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		for (i = 0; i < prm->sense_buffer_len/4; i++)
 			((uint32_t *)ctio->u.status1.sense_data)[i] =
 				cpu_to_be32(((uint32_t *)prm->sense_buffer)[i]);
-#if 0
-		if (unlikely((prm->sense_buffer_len % 4) != 0)) {
-			static int q;
-			if (q < 10) {
-				ql_dbg(ql_dbg_tgt, vha, 0xe04f,
-				    "qla_target(%d): %d bytes of sense "
-				    "lost", prm->tgt->ha->vp_idx,
-				    prm->sense_buffer_len % 4);
-				q++;
-			}
-		}
-#endif
+
+		qlt_print_dif_err(prm);
+
 	} else {
 		ctio->u.status1.flags &=
 		    ~cpu_to_le16(CTIO7_FLAGS_STATUS_MODE_0);
@@ -2542,19 +2656,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	/* Sense with len > 24, is it possible ??? */
 }
 
-
-
-/* diff  */
 static inline int
 qlt_hba_err_chk_enabled(struct se_cmd *se_cmd)
 {
-	/*
-	 * Uncomment when corresponding SCSI changes are done.
-	 *
-	 if (!sp->cmd->prot_chk)
-	 return 0;
-	 *
-	 */
 	switch (se_cmd->prot_op) {
 	case TARGET_PROT_DOUT_INSERT:
 	case TARGET_PROT_DIN_STRIP:
@@ -2575,16 +2679,37 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	return 0;
 }
 
+static inline int
+qla_tgt_ref_mask_check(struct se_cmd *se_cmd)
+{
+	switch (se_cmd->prot_op) {
+	case TARGET_PROT_DIN_INSERT:
+	case TARGET_PROT_DOUT_INSERT:
+	case TARGET_PROT_DIN_STRIP:
+	case TARGET_PROT_DOUT_STRIP:
+	case TARGET_PROT_DIN_PASS:
+	case TARGET_PROT_DOUT_PASS:
+	    return 1;
+	default:
+	    return 0;
+	}
+}
+
 /*
- * qla24xx_set_t10dif_tags_from_cmd - Extract Ref and App tags from SCSI command
- *
+ * qla_tgt_set_dif_tags - Extract Ref and App tags from SCSI command
  */
-static inline void
-qlt_set_t10dif_tags(struct se_cmd *se_cmd, struct crc_context *ctx)
+static void
+qla_tgt_set_dif_tags(struct qla_tgt_cmd *cmd, struct crc_context *ctx,
+    uint16_t *pfw_prot_opts)
 {
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	uint32_t lba = 0xffffffff & se_cmd->t_task_lba;
+	scsi_qla_host_t *vha = cmd->tgt->vha;
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t t32 = 0;
 
-	/* wait til Mode Sense/Select cmd, modepage Ah, subpage 2
+	/*
+	 * wait till Mode Sense/Select cmd, modepage Ah, subpage 2
 	 * have been immplemented by TCM, before AppTag is avail.
 	 * Look for modesense_handlers[]
 	 */
@@ -2592,65 +2717,73 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	ctx->app_tag_mask[0] = 0x0;
 	ctx->app_tag_mask[1] = 0x0;
 
+	if (IS_PI_UNINIT_CAPABLE(ha)) {
+		if ((se_cmd->prot_type == TARGET_DIF_TYPE1_PROT) ||
+		    (se_cmd->prot_type == TARGET_DIF_TYPE2_PROT))
+			*pfw_prot_opts |= PO_DIS_VALD_APP_ESC;
+		else if (se_cmd->prot_type == TARGET_DIF_TYPE3_PROT)
+			*pfw_prot_opts |= PO_DIS_VALD_APP_REF_ESC;
+	}
+
+	t32 = ha->tgt.tgt_ops->get_dif_tags(cmd, pfw_prot_opts);
+
 	switch (se_cmd->prot_type) {
 	case TARGET_DIF_TYPE0_PROT:
 		/*
-		 * No check for ql2xenablehba_err_chk, as it would be an
-		 * I/O error if hba tag generation is not done.
+		 * No check for ql2xenablehba_err_chk, as it
+		 * would be an I/O error if hba tag generation
+		 * is not done.
 		 */
 		ctx->ref_tag = cpu_to_le32(lba);
-
-		if (!qlt_hba_err_chk_enabled(se_cmd))
-			break;
-
 		/* enable ALL bytes of the ref tag */
 		ctx->ref_tag_mask[0] = 0xff;
 		ctx->ref_tag_mask[1] = 0xff;
 		ctx->ref_tag_mask[2] = 0xff;
 		ctx->ref_tag_mask[3] = 0xff;
 		break;
-	/*
-	 * For TYpe 1 protection: 16 bit GUARD tag, 32 bit REF tag, and
-	 * 16 bit app tag.
-	 */
 	case TARGET_DIF_TYPE1_PROT:
-		ctx->ref_tag = cpu_to_le32(lba);
-
-		if (!qlt_hba_err_chk_enabled(se_cmd))
-			break;
-
-		/* enable ALL bytes of the ref tag */
-		ctx->ref_tag_mask[0] = 0xff;
-		ctx->ref_tag_mask[1] = 0xff;
-		ctx->ref_tag_mask[2] = 0xff;
-		ctx->ref_tag_mask[3] = 0xff;
-		break;
-	/*
-	 * For TYPE 2 protection: 16 bit GUARD + 32 bit REF tag has to
-	 * match LBA in CDB + N
-	 */
+	    /*
+	     * For TYPE 1 protection: 16 bit GUARD tag, 32 bit
+	     * REF tag, and 16 bit app tag.
+	     */
+	    ctx->ref_tag = cpu_to_le32(lba);
+	    if (!qla_tgt_ref_mask_check(se_cmd) ||
+		!(ha->tgt.tgt_ops->chk_dif_tags(t32))) {
+		    *pfw_prot_opts |= PO_DIS_REF_TAG_VALD;
+		    break;
+	    }
+	    /* enable ALL bytes of the ref tag */
+	    ctx->ref_tag_mask[0] = 0xff;
+	    ctx->ref_tag_mask[1] = 0xff;
+	    ctx->ref_tag_mask[2] = 0xff;
+	    ctx->ref_tag_mask[3] = 0xff;
+	    break;
 	case TARGET_DIF_TYPE2_PROT:
-		ctx->ref_tag = cpu_to_le32(lba);
-
-		if (!qlt_hba_err_chk_enabled(se_cmd))
-			break;
-
-		/* enable ALL bytes of the ref tag */
-		ctx->ref_tag_mask[0] = 0xff;
-		ctx->ref_tag_mask[1] = 0xff;
-		ctx->ref_tag_mask[2] = 0xff;
-		ctx->ref_tag_mask[3] = 0xff;
-		break;
-
-	/* For Type 3 protection: 16 bit GUARD only */
+	    /*
+	     * For TYPE 2 protection: 16 bit GUARD + 32 bit REF
+	     * tag has to match LBA in CDB + N
+	     */
+	    ctx->ref_tag = cpu_to_le32(lba);
+	    if (!qla_tgt_ref_mask_check(se_cmd) ||
+		!(ha->tgt.tgt_ops->chk_dif_tags(t32))) {
+		    *pfw_prot_opts |= PO_DIS_REF_TAG_VALD;
+		    break;
+	    }
+	    /* enable ALL bytes of the ref tag */
+	    ctx->ref_tag_mask[0] = 0xff;
+	    ctx->ref_tag_mask[1] = 0xff;
+	    ctx->ref_tag_mask[2] = 0xff;
+	    ctx->ref_tag_mask[3] = 0xff;
+	    break;
 	case TARGET_DIF_TYPE3_PROT:
-		ctx->ref_tag_mask[0] = ctx->ref_tag_mask[1] =
-			ctx->ref_tag_mask[2] = ctx->ref_tag_mask[3] = 0x00;
-		break;
+	    /* For TYPE 3 protection: 16 bit GUARD only */
+	    *pfw_prot_opts |= PO_DIS_REF_TAG_VALD;
+	    ctx->ref_tag_mask[0] = ctx->ref_tag_mask[1] =
+		ctx->ref_tag_mask[2] = ctx->ref_tag_mask[3] = 0x00;
+	    break;
 	}
 }
 
-
 static inline int
 qlt_build_ctio_crc2_pkt(struct qla_tgt_prm *prm, scsi_qla_host_t *vha)
 {
@@ -2696,14 +2829,12 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		transfer_length = data_bytes;
 		data_bytes += dif_bytes;
 		break;
-
 	case TARGET_PROT_DIN_STRIP:
 	case TARGET_PROT_DOUT_INSERT:
 	case TARGET_PROT_DIN_PASS:
 	case TARGET_PROT_DOUT_PASS:
 		transfer_length = data_bytes + dif_bytes;
 		break;
-
 	default:
 		BUG();
 		break;
@@ -2739,7 +2870,6 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		break;
 	}
 
-
 	/* ---- PKT ---- */
 	/* Update entry type to indicate Command Type CRC_2 IOCB */
 	pkt->entry_type  = CTIO_CRC2;
@@ -2757,7 +2887,6 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	} else
 		ha->tgt.cmds[h-1] = prm->cmd;
 
-
 	pkt->handle  = h | CTIO_COMPLETION_HANDLE_MARK;
 	pkt->nport_handle = prm->cmd->loop_id;
 	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
@@ -2780,12 +2909,10 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	else if (cmd->dma_data_direction == DMA_FROM_DEVICE)
 		pkt->flags = cpu_to_le16(CTIO7_FLAGS_DATA_OUT);
 
-
 	pkt->dseg_count = prm->tot_dsds;
 	/* Fibre channel byte count */
 	pkt->transfer_length = cpu_to_le32(transfer_length);
 
-
 	/* ----- CRC context -------- */
 
 	/* Allocate CRC context from global pool */
@@ -2805,13 +2932,12 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	/* Set handle */
 	crc_ctx_pkt->handle = pkt->handle;
 
-	qlt_set_t10dif_tags(se_cmd, crc_ctx_pkt);
+	qla_tgt_set_dif_tags(cmd, crc_ctx_pkt, &fw_prot_opts);
 
 	pkt->crc_context_address[0] = cpu_to_le32(LSD(crc_ctx_dma));
 	pkt->crc_context_address[1] = cpu_to_le32(MSD(crc_ctx_dma));
 	pkt->crc_context_len = CRC_CONTEXT_LEN_FW;
 
-
 	if (!bundling) {
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.nobundling.data_address;
 	} else {
@@ -2832,7 +2958,6 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	crc_ctx_pkt->byte_count = cpu_to_le32(data_bytes);
 	crc_ctx_pkt->guard_seed = cpu_to_le16(0);
 
-
 	/* Walks data segments */
 	pkt->flags |= cpu_to_le16(CTIO7_FLAGS_DSD_PTR);
 
@@ -2857,11 +2982,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 
 crc_queuing_error:
 	/* Cleanup will be performed by the caller */
-
 	return QLA_FUNCTION_FAILED;
 }
 
-
 /*
  * Callback to setup response of xmit_type of QLA_TGT_XMIT_DATA and *
  * QLA_TGT_XMIT_STATUS for >= 24xx silicon
@@ -3109,139 +3232,113 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 
 /*
- * Checks the guard or meta-data for the type of error
- * detected by the HBA.
+ * it is assumed either hardware_lock or qpair lock is held.
  */
-static inline int
+static void
 qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
-		struct ctio_crc_from_fw *sts)
+	struct ctio_crc_from_fw *sts)
 {
 	uint8_t		*ap = &sts->actual_dif[0];
 	uint8_t		*ep = &sts->expected_dif[0];
-	uint32_t	e_ref_tag, a_ref_tag;
-	uint16_t	e_app_tag, a_app_tag;
-	uint16_t	e_guard, a_guard;
 	uint64_t	lba = cmd->se_cmd.t_task_lba;
+	uint8_t scsi_status, sense_key, asc, ascq;
+	unsigned long flags;
 
-	a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
-	a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
-	a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
-
-	e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
-	e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
-	e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
-
-	ql_dbg(ql_dbg_tgt, vha, 0xe075,
-	    "iocb(s) %p Returned STATUS.\n", sts);
-
-	ql_dbg(ql_dbg_tgt, vha, 0xf075,
-	    "dif check TGT cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x]\n",
-	    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-	    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag, a_guard, e_guard);
-
-	/*
-	 * Ignore sector if:
-	 * For type     3: ref & app tag is all 'f's
-	 * For type 0,1,2: app tag is all 'f's
-	 */
-	if ((a_app_tag == 0xffff) &&
-	    ((cmd->se_cmd.prot_type != TARGET_DIF_TYPE3_PROT) ||
-	     (a_ref_tag == 0xffffffff))) {
-		uint32_t blocks_done;
-
-		/* 2TB boundary case covered automatically with this */
-		blocks_done = e_ref_tag - (uint32_t)lba + 1;
-		cmd->se_cmd.bad_sector = e_ref_tag;
-		cmd->se_cmd.pi_err = 0;
-		ql_dbg(ql_dbg_tgt, vha, 0xf074,
-			"need to return scsi good\n");
-
-		/* Update protection tag */
-		if (cmd->prot_sg_cnt) {
-			uint32_t i, k = 0, num_ent;
-			struct scatterlist *sg, *sgl;
-
+	cmd->trc_flags |= TRC_DIF_ERR;
 
-			sgl = cmd->prot_sg;
+	cmd->a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
+	cmd->a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
+	cmd->a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
 
-			/* Patch the corresponding protection tags */
-			for_each_sg(sgl, sg, cmd->prot_sg_cnt, i) {
-				num_ent = sg_dma_len(sg) / 8;
-				if (k + num_ent < blocks_done) {
-					k += num_ent;
-					continue;
-				}
-				k = blocks_done;
-				break;
-			}
+	cmd->e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
+	cmd->e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
+	cmd->e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
 
-			if (k != blocks_done) {
-				ql_log(ql_log_warn, vha, 0xf076,
-				    "unexpected tag values tag:lba=%u:%llu)\n",
-				    e_ref_tag, (unsigned long long)lba);
-				goto out;
-			}
+	ql_dbg(ql_dbg_tgt_dif, vha, 0xf075,
+	    "%s: aborted %d state %d\n", __func__, cmd->aborted, cmd->state);
 
-#if 0
-			struct sd_dif_tuple *spt;
-			/* TODO:
-			 * This section came from initiator. Is it valid here?
-			 * should ulp be override with actual val???
-			 */
-			spt = page_address(sg_page(sg)) + sg->offset;
-			spt += j;
+	scsi_status = sense_key = asc = ascq = 0;
 
-			spt->app_tag = 0xffff;
-			if (cmd->se_cmd.prot_type == SCSI_PROT_DIF_TYPE3)
-				spt->ref_tag = 0xffffffff;
-#endif
-		}
-
-		return 0;
-	}
-
-	/* check guard */
-	if (e_guard != a_guard) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
-
-		ql_log(ql_log_warn, vha, 0xe076,
-		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-		    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-		    a_guard, e_guard, cmd);
-		goto out;
+	/* check appl tag */
+	if (cmd->e_app_tag != cmd->a_app_tag) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			"App Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] "
+			"Ref[%x|%x], App[%x|%x], "
+			"Guard [%x|%x] cmd=%p ox_id[%04x]",
+			cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
+			cmd->a_ref_tag, cmd->e_ref_tag,
+			cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard,
+			cmd, cmd->atio.u.isp24.fcp_hdr.ox_id);
+
+		cmd->dif_err_code = DIF_ERR_APP;
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+		sense_key = ABORTED_COMMAND;
+		asc = 0x10;
+		ascq = 0x2;
 	}
 
 	/* check ref tag */
-	if (e_ref_tag != a_ref_tag) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = e_ref_tag;
-
-		ql_log(ql_log_warn, vha, 0xe077,
-			"Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-			a_guard, e_guard, cmd);
+	if (cmd->e_ref_tag != cmd->a_ref_tag) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			"Ref Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] "
+			"Ref[%x|%x], App[%x|%x], "
+			"Guard[%x|%x] cmd=%p ox_id[%04x] ",
+			cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
+			cmd->a_ref_tag, cmd->e_ref_tag,
+			cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard,
+			cmd, cmd->atio.u.isp24.fcp_hdr.ox_id);
+
+		cmd->dif_err_code = DIF_ERR_REF;
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+		sense_key = ABORTED_COMMAND;
+		asc = 0x10;
+		ascq = 0x3;
 		goto out;
 	}
 
-	/* check appl tag */
-	if (e_app_tag != a_app_tag) {
-		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
-
-		ql_log(ql_log_warn, vha, 0xe078,
-			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
-			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-			a_guard, e_guard, cmd);
-		goto out;
+	/* check guard */
+	if (cmd->e_guard != cmd->a_guard) {
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+			"Guard ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] "
+			"Ref[%x|%x], App[%x|%x], "
+			"Guard [%x|%x] cmd=%p ox_id[%04x]",
+			cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
+			cmd->a_ref_tag, cmd->e_ref_tag,
+			cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard,
+			cmd, cmd->atio.u.isp24.fcp_hdr.ox_id);
+		cmd->dif_err_code = DIF_ERR_GRD;
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+		sense_key = ABORTED_COMMAND;
+		asc = 0x10;
+		ascq = 0x1;
 	}
 out:
-	return 1;
-}
+	switch (cmd->state) {
+	case QLA_TGT_STATE_NEED_DATA:
+		/* handle_data will load DIF error code  */
+		cmd->state = QLA_TGT_STATE_DATA_IN;
+		vha->hw->tgt.tgt_ops->handle_data(cmd);
+		break;
+	default:
+		spin_lock_irqsave(&cmd->cmd_lock, flags);
+		if (cmd->aborted) {
+			spin_unlock_irqrestore(&cmd->cmd_lock, flags);
+			vha->hw->tgt.tgt_ops->free_cmd(cmd);
+			break;
+		}
+		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
+		qlt_send_resp_ctio(vha, cmd, scsi_status, sense_key, asc, ascq);
+		/* assume scsi status gets out on the wire.
+		 * Will not wait for completion.
+		 */
+		vha->hw->tgt.tgt_ops->free_cmd(cmd);
+		break;
+	}
+}
 
 /* If hardware_lock held on entry, might drop it, then reaquire */
 /* This function sends the appropriate CTIO to ISP 2xxx or 24xx */
@@ -3548,6 +3645,16 @@ static int qlt_term_ctio_exchange(struct scsi_qla_host *vha, void *ctio,
 {
 	int term = 0;
 
+	if (cmd->se_cmd.prot_op)
+		ql_dbg(ql_dbg_tgt_dif, vha, 0xffff,
+		    "Term DIF cmd: lba[0x%llx|%lld] len[0x%x] "
+		    "se_cmd=%p tag[%x] op %#x/%s",
+		     cmd->lba, cmd->lba,
+		     cmd->num_blks, &cmd->se_cmd,
+		     cmd->atio.u.isp24.exchange_addr,
+		     cmd->se_cmd.prot_op,
+		     prot_op_str(cmd->se_cmd.prot_op));
+
 	if (ctio != NULL) {
 		struct ctio7_from_24xx *c = (struct ctio7_from_24xx *)ctio;
 		term = !(c->flags &
@@ -3765,32 +3872,15 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 			struct ctio_crc_from_fw *crc =
 				(struct ctio_crc_from_fw *)ctio;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf073,
-			    "qla_target(%d): CTIO with DIF_ERROR status %x received (state %x, se_cmd %p) actual_dif[0x%llx] expect_dif[0x%llx]\n",
+			    "qla_target(%d): CTIO with DIF_ERROR status %x "
+			    "received (state %x, ulp_cmd %p) actual_dif[0x%llx] "
+			    "expect_dif[0x%llx]\n",
 			    vha->vp_idx, status, cmd->state, se_cmd,
 			    *((u64 *)&crc->actual_dif[0]),
 			    *((u64 *)&crc->expected_dif[0]));
 
-			if (qlt_handle_dif_error(vha, cmd, ctio)) {
-				if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
-					/* scsi Write/xfer rdy complete */
-					goto skip_term;
-				} else {
-					/* scsi read/xmit respond complete
-					 * call handle dif to send scsi status
-					 * rather than terminate exchange.
-					 */
-					cmd->state = QLA_TGT_STATE_PROCESSED;
-					ha->tgt.tgt_ops->handle_dif_err(cmd);
-					return;
-				}
-			} else {
-				/* Need to generate a SCSI good completion.
-				 * because FW did not send scsi status.
-				 */
-				status = 0;
-				goto skip_term;
-			}
-			break;
+			qlt_handle_dif_error(vha, cmd, ctio);
+			return;
 		}
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
@@ -3813,7 +3903,6 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 				return;
 		}
 	}
-skip_term:
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
 		cmd->trc_flags |= TRC_CTIO_DONE;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index a7f90dc..c73c938 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -378,6 +378,14 @@ static inline void adjust_corrupted_atio(struct atio_from_isp *atio)
 	atio->u.isp24.fcp_cmnd.add_cdb_len = 0;
 }
 
+static inline int get_datalen_for_atio(struct atio_from_isp *atio)
+{
+	int len = atio->u.isp24.fcp_cmnd.add_cdb_len;
+
+	return (be32_to_cpu(get_unaligned((uint32_t *)
+	    &atio->u.isp24.fcp_cmnd.add_cdb[len * 4])));
+}
+
 #define CTIO_TYPE7 0x12 /* Continue target I/O entry (for 24xx) */
 
 /*
@@ -667,7 +675,6 @@ struct qla_tgt_func_tmpl {
 	int (*handle_cmd)(struct scsi_qla_host *, struct qla_tgt_cmd *,
 			unsigned char *, uint32_t, int, int, int);
 	void (*handle_data)(struct qla_tgt_cmd *);
-	void (*handle_dif_err)(struct qla_tgt_cmd *);
 	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint16_t,
 			uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
@@ -684,6 +691,8 @@ struct qla_tgt_func_tmpl {
 	void (*clear_nacl_from_fcport_map)(struct fc_port *);
 	void (*put_sess)(struct fc_port *);
 	void (*shutdown_sess)(struct fc_port *);
+	int (*get_dif_tags)(struct qla_tgt_cmd *cmd, uint16_t *pfw_prot_opts);
+	int (*chk_dif_tags)(uint32_t tag);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
@@ -720,8 +729,8 @@ struct qla_tgt_func_tmpl {
 #define QLA_TGT_ABORT_ALL               0xFFFE
 #define QLA_TGT_NEXUS_LOSS_SESS         0xFFFD
 #define QLA_TGT_NEXUS_LOSS              0xFFFC
-#define QLA_TGT_ABTS					0xFFFB
-#define QLA_TGT_2G_ABORT_TASK			0xFFFA
+#define QLA_TGT_ABTS			0xFFFB
+#define QLA_TGT_2G_ABORT_TASK		0xFFFA
 
 /* Notify Acknowledge flags */
 #define NOTIFY_ACK_RES_COUNT        BIT_8
@@ -845,6 +854,7 @@ enum trace_flags {
 	TRC_CMD_FREE = BIT_17,
 	TRC_DATA_IN = BIT_18,
 	TRC_ABORT = BIT_19,
+	TRC_DIF_ERR = BIT_20,
 };
 
 struct qla_tgt_cmd {
@@ -885,11 +895,23 @@ struct qla_tgt_cmd {
 	struct list_head cmd_list;
 
 	struct atio_from_isp atio;
-	/* t10dif */
+
+	/* T10-DIF */
+#define DIF_ERR_NONE 0
+#define DIF_ERR_GRD 1
+#define DIF_ERR_REF 2
+#define DIF_ERR_APP 3
+	int8_t dif_err_code;
 	struct scatterlist *prot_sg;
 	uint32_t prot_sg_cnt;
-	uint32_t blk_sz;
+	uint32_t blk_sz, num_blks;
+	uint8_t scsi_status, sense_key, asc, ascq;
+
 	struct crc_context *ctx;
+	uint8_t		*cdb;
+	uint64_t	lba;
+	uint16_t	a_guard, e_guard, a_app_tag, e_app_tag;
+	uint32_t	a_ref_tag, e_ref_tag;
 
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
@@ -1053,4 +1075,7 @@ extern void qlt_modify_vp_config(struct scsi_qla_host *,
 extern void qlt_logo_completion_handler(fc_port_t *, int);
 extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
+void qlt_send_resp_ctio(scsi_qla_host_t *, struct qla_tgt_cmd *, uint8_t,
+    uint8_t, uint8_t, uint8_t);
+
 #endif /* __QLA_TARGET_H */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c2f8c35..1d5ed79 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -531,6 +531,24 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 			return;
 		}
 
+		switch (cmd->dif_err_code) {
+		case DIF_ERR_GRD:
+			cmd->se_cmd.pi_err =
+			    TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+			break;
+		case DIF_ERR_REF:
+			cmd->se_cmd.pi_err =
+			    TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+			break;
+		case DIF_ERR_APP:
+			cmd->se_cmd.pi_err =
+			    TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+			break;
+		case DIF_ERR_NONE:
+		default:
+			break;
+		}
+
 		if (cmd->se_cmd.pi_err)
 			transport_generic_request_failure(&cmd->se_cmd,
 				cmd->se_cmd.pi_err);
@@ -555,25 +573,23 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
 }
 
-static void tcm_qla2xxx_handle_dif_work(struct work_struct *work)
+static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)
 {
-	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
-
-	/* take an extra kref to prevent cmd free too early.
-	 * need to wait for SCSI status/check condition to
-	 * finish responding generate by transport_generic_request_failure.
-	 */
-	kref_get(&cmd->se_cmd.cmd_kref);
-	transport_generic_request_failure(&cmd->se_cmd, cmd->se_cmd.pi_err);
+	return 0;
 }
 
-/*
- * Called from qla_target.c:qlt_do_ctio_completion()
- */
-static void tcm_qla2xxx_handle_dif_err(struct qla_tgt_cmd *cmd)
+static int tcm_qla2xxx_dif_tags(struct qla_tgt_cmd *cmd,
+    uint16_t *pfw_prot_opts)
 {
-	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_dif_work);
-	queue_work(tcm_qla2xxx_free_wq, &cmd->work);
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+
+	if (!(se_cmd->prot_checks & TARGET_DIF_CHECK_GUARD))
+		*pfw_prot_opts |= PO_DISABLE_GUARD_CHECK;
+
+	if (!(se_cmd->prot_checks & TARGET_DIF_CHECK_APPTAG))
+		*pfw_prot_opts |= PO_DIS_APP_TAG_VALD;
+
+	return 0;
 }
 
 /*
@@ -1610,7 +1626,6 @@ static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
 static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.handle_cmd		= tcm_qla2xxx_handle_cmd,
 	.handle_data		= tcm_qla2xxx_handle_data,
-	.handle_dif_err		= tcm_qla2xxx_handle_dif_err,
 	.handle_tmr		= tcm_qla2xxx_handle_tmr,
 	.free_cmd		= tcm_qla2xxx_free_cmd,
 	.free_mcmd		= tcm_qla2xxx_free_mcmd,
@@ -1622,6 +1637,8 @@ static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
 	.clear_nacl_from_fcport_map = tcm_qla2xxx_clear_nacl_from_fcport_map,
 	.put_sess		= tcm_qla2xxx_put_sess,
 	.shutdown_sess		= tcm_qla2xxx_shutdown_sess,
+	.get_dif_tags		= tcm_qla2xxx_dif_tags,
+	.chk_dif_tags		= tcm_qla2xxx_chk_dif_tags,
 };
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
-- 
1.8.3.1
