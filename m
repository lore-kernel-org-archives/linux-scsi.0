From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 8/9] qla2xxx: Add T10-DIF opcode/type in qla_tgt_cmd
Date: Sun, 18 Dec 2016 01:02:48 -0800
Message-ID: <1482051769-22941-9-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add T10-DIF/PI protection opcode/type field to qla_tgt_cmd.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 126 ++++++++++++++++----------------------
 drivers/scsi/qla2xxx/qla_target.h |   4 ++
 2 files changed, 58 insertions(+), 72 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 14092472..c0d847a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1791,7 +1791,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 
 	prm->cmd->sg_mapped = 1;
 
-	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL) {
+	if (cmd->prot_op == TARGET_PROT_NORMAL) {
 		/*
 		 * If greater than four sg entries then we need to allocate
 		 * the continuation entries
@@ -1802,8 +1802,8 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 			prm->tgt->datasegs_per_cont);
 	} else {
 		/* DIF */
-		if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
-		    (cmd->se_cmd.prot_op == TARGET_PROT_DOUT_STRIP)) {
+		if ((cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
+		    (cmd->prot_op == TARGET_PROT_DOUT_STRIP)) {
 			prm->seg_cnt = DIV_ROUND_UP(cmd->bufflen, cmd->blk_sz);
 			prm->tot_dsds = prm->seg_cnt;
 		} else
@@ -1817,8 +1817,8 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 			if (unlikely(prm->prot_seg_cnt == 0))
 				goto out_err;
 
-			if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
-			    (cmd->se_cmd.prot_op == TARGET_PROT_DOUT_STRIP)) {
+			if ((cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
+			    (cmd->prot_op == TARGET_PROT_DOUT_STRIP)) {
 				/* Dif Bundling not support here */
 				prm->prot_seg_cnt = DIV_ROUND_UP(cmd->bufflen,
 								cmd->blk_sz);
@@ -2329,7 +2329,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 
 /* diff  */
 static inline int
-qlt_hba_err_chk_enabled(struct se_cmd *se_cmd)
+qlt_hba_err_chk_enabled(struct qla_tgt_cmd *cmd)
 {
 	/*
 	 * Uncomment when corresponding SCSI changes are done.
@@ -2338,17 +2338,17 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	 return 0;
 	 *
 	 */
-	switch (se_cmd->prot_op) {
+	switch (cmd->prot_op) {
 	case TARGET_PROT_DOUT_INSERT:
 	case TARGET_PROT_DIN_STRIP:
-		if (ql2xenablehba_err_chk >= 1)
-			return 1;
-		break;
+	    if (ql2xenablehba_err_chk >= 1)
+		    return 1;
+	    break;
 	case TARGET_PROT_DOUT_PASS:
 	case TARGET_PROT_DIN_PASS:
-		if (ql2xenablehba_err_chk >= 2)
-			return 1;
-		break;
+	    if (ql2xenablehba_err_chk >= 2)
+		    return 1;
+	    break;
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_STRIP:
 		return 1;
@@ -2363,8 +2363,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
  *
  */
 static inline void
-qlt_set_t10dif_tags(struct se_cmd *se_cmd, struct crc_context *ctx)
+qlt_set_t10dif_tags(struct qla_tgt_cmd *cmd, struct crc_context *ctx)
 {
+	struct se_cmd *se_cmd = &cmd->se_cmd;
 	uint32_t lba = 0xffffffff & se_cmd->t_task_lba;
 
 	/* wait til Mode Sense/Select cmd, modepage Ah, subpage 2
@@ -2375,7 +2376,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	ctx->app_tag_mask[0] = 0x0;
 	ctx->app_tag_mask[1] = 0x0;
 
-	switch (se_cmd->prot_type) {
+	switch (cmd->prot_type) {
 	case TARGET_DIF_TYPE0_PROT:
 		/*
 		 * No check for ql2xenablehba_err_chk, as it would be an
@@ -2383,7 +2384,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		 */
 		ctx->ref_tag = cpu_to_le32(lba);
 
-		if (!qlt_hba_err_chk_enabled(se_cmd))
+		if (!qlt_hba_err_chk_enabled(cmd))
 			break;
 
 		/* enable ALL bytes of the ref tag */
@@ -2399,7 +2400,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	case TARGET_DIF_TYPE1_PROT:
 		ctx->ref_tag = cpu_to_le32(lba);
 
-		if (!qlt_hba_err_chk_enabled(se_cmd))
+		if (!qlt_hba_err_chk_enabled(cmd))
 			break;
 
 		/* enable ALL bytes of the ref tag */
@@ -2415,7 +2416,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	case TARGET_DIF_TYPE2_PROT:
 		ctx->ref_tag = cpu_to_le32(lba);
 
-		if (!qlt_hba_err_chk_enabled(se_cmd))
+		if (!qlt_hba_err_chk_enabled(cmd))
 			break;
 
 		/* enable ALL bytes of the ref tag */
@@ -2492,18 +2493,18 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		break;
 	}
 
-	if (!qlt_hba_err_chk_enabled(se_cmd))
+	if (!qlt_hba_err_chk_enabled(cmd))
 		fw_prot_opts |= 0x10; /* Disable Guard tag checking */
 	/* HBA error checking enabled */
 	else if (IS_PI_UNINIT_CAPABLE(ha)) {
-		if ((se_cmd->prot_type == TARGET_DIF_TYPE1_PROT) ||
-		    (se_cmd->prot_type == TARGET_DIF_TYPE2_PROT))
+		if ((cmd->prot_type == TARGET_DIF_TYPE1_PROT) ||
+		    (cmd->prot_type == TARGET_DIF_TYPE2_PROT))
 			fw_prot_opts |= PO_DIS_VALD_APP_ESC;
-		else if (se_cmd->prot_type == TARGET_DIF_TYPE3_PROT)
+		else if (cmd->prot_type == TARGET_DIF_TYPE3_PROT)
 			fw_prot_opts |= PO_DIS_VALD_APP_REF_ESC;
 	}
 
-	switch (se_cmd->prot_op) {
+	switch (cmd->prot_op) {
 	case TARGET_PROT_DIN_INSERT:
 	case TARGET_PROT_DOUT_INSERT:
 		fw_prot_opts |= PO_MODE_DIF_INSERT;
@@ -2588,7 +2589,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	/* Set handle */
 	crc_ctx_pkt->handle = pkt->handle;
 
-	qlt_set_t10dif_tags(se_cmd, crc_ctx_pkt);
+	qlt_set_t10dif_tags(cmd, crc_ctx_pkt);
 
 	pkt->crc_context_address[0] = cpu_to_le32(LSD(crc_ctx_dma));
 	pkt->crc_context_address[1] = cpu_to_le32(MSD(crc_ctx_dma));
@@ -2715,7 +2716,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (unlikely(res))
 		goto out_unmap_unlock;
 
-	if (cmd->se_cmd.prot_op && (xmit_type & QLA_TGT_XMIT_DATA))
+	if (cmd->prot_op && (xmit_type & QLA_TGT_XMIT_DATA))
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
@@ -2731,7 +2732,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 		    cpu_to_le16(CTIO7_FLAGS_DATA_IN |
 			CTIO7_FLAGS_STATUS_MODE_0);
 
-		if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
+		if (cmd->prot_op == TARGET_PROT_NORMAL)
 			qlt_load_data_segments(&prm, vha);
 
 		if (prm.add_status_pkt == 0) {
@@ -2856,7 +2857,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	res = qlt_check_reserve_free_req(vha, prm.req_cnt);
 	if (res != 0)
 		goto out_unlock_free_unmap;
-	if (cmd->se_cmd.prot_op)
+	if (cmd->prot_op)
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
@@ -2870,7 +2871,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	pkt->u.status0.flags |= cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
 	    CTIO7_FLAGS_STATUS_MODE_0);
 
-	if (cmd->se_cmd.prot_op == TARGET_PROT_NORMAL)
+	if (cmd->prot_op == TARGET_PROT_NORMAL)
 		qlt_load_data_segments(&prm, vha);
 
 	cmd->state = QLA_TGT_STATE_NEED_DATA;
@@ -2902,40 +2903,38 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 {
 	uint8_t		*ap = &sts->actual_dif[0];
 	uint8_t		*ep = &sts->expected_dif[0];
-	uint32_t	e_ref_tag, a_ref_tag;
-	uint16_t	e_app_tag, a_app_tag;
-	uint16_t	e_guard, a_guard;
 	uint64_t	lba = cmd->lba;
 
-	a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
-	a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
-	a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
+	cmd->a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
+	cmd->a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
+	cmd->a_ref_tag = be32_to_cpu(*(uint32_t *)(ap + 4));
 
-	e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
-	e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
-	e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
+	cmd->e_guard   = be16_to_cpu(*(uint16_t *)(ep + 0));
+	cmd->e_app_tag = be16_to_cpu(*(uint16_t *)(ep + 2));
+	cmd->e_ref_tag = be32_to_cpu(*(uint32_t *)(ep + 4));
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe075,
 	    "iocb(s) %p Returned STATUS.\n", sts);
 
 	ql_dbg(ql_dbg_tgt, vha, 0xf075,
 	    "dif check TGT cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x]\n",
-	    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-	    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag, a_guard, e_guard);
+	    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba, cmd->a_ref_tag,
+	    cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag, cmd->a_guard,
+	    cmd->e_guard);
 
 	/*
 	 * Ignore sector if:
 	 * For type     3: ref & app tag is all 'f's
 	 * For type 0,1,2: app tag is all 'f's
 	 */
-	if ((a_app_tag == 0xffff) &&
-	    ((cmd->se_cmd.prot_type != TARGET_DIF_TYPE3_PROT) ||
-	     (a_ref_tag == 0xffffffff))) {
+	if ((cmd->a_app_tag == 0xffff) &&
+	    ((cmd->prot_type != TARGET_DIF_TYPE3_PROT) ||
+	     (cmd->a_ref_tag == 0xffffffff))) {
 		uint32_t blocks_done;
 
 		/* 2TB boundary case covered automatically with this */
-		blocks_done = e_ref_tag - (uint32_t)lba + 1;
-		cmd->se_cmd.bad_sector = e_ref_tag;
+		blocks_done = cmd->e_ref_tag - (uint32_t)lba + 1;
+		cmd->se_cmd.bad_sector = cmd->e_ref_tag;
 		cmd->se_cmd.pi_err = 0;
 		ql_dbg(ql_dbg_tgt, vha, 0xf074,
 			"need to return scsi good\n");
@@ -2962,64 +2961,47 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 			if (k != blocks_done) {
 				ql_log(ql_log_warn, vha, 0xf076,
 				    "unexpected tag values tag:lba=%u:%llu)\n",
-				    e_ref_tag, (unsigned long long)lba);
+				    cmd->e_ref_tag, (unsigned long long)lba);
 				goto out;
 			}
-
-#if 0
-			struct sd_dif_tuple *spt;
-			/* TODO:
-			 * This section came from initiator. Is it valid here?
-			 * should ulp be override with actual val???
-			 */
-			spt = page_address(sg_page(sg)) + sg->offset;
-			spt += j;
-
-			spt->app_tag = 0xffff;
-			if (cmd->se_cmd.prot_type == SCSI_PROT_DIF_TYPE3)
-				spt->ref_tag = 0xffffffff;
-#endif
 		}
 
 		return 0;
 	}
 
 	/* check guard */
-	if (e_guard != a_guard) {
+	if (cmd->e_guard != cmd->a_guard) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
 		cmd->se_cmd.bad_sector = cmd->lba;
-
 		ql_log(ql_log_warn, vha, 0xe076,
 		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
 		    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-		    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-		    a_guard, e_guard, cmd);
+		    cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+		    cmd->a_guard, cmd->e_guard, cmd);
 		goto out;
 	}
 
 	/* check ref tag */
-	if (e_ref_tag != a_ref_tag) {
+	if (cmd->e_ref_tag != cmd->a_ref_tag) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = e_ref_tag;
-
+		cmd->se_cmd.bad_sector = cmd->e_ref_tag;
 		ql_log(ql_log_warn, vha, 0xe077,
 			"Ref Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
 			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-			a_guard, e_guard, cmd);
+			cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard, cmd);
 		goto out;
 	}
 
 	/* check appl tag */
-	if (e_app_tag != a_app_tag) {
+	if (cmd->e_app_tag != cmd->a_app_tag) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
 		cmd->se_cmd.bad_sector = cmd->lba;
-
 		ql_log(ql_log_warn, vha, 0xe078,
 			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
 			cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
-			a_ref_tag, e_ref_tag, a_app_tag, e_app_tag,
-			a_guard, e_guard, cmd);
+			cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag, cmd->e_app_tag,
+			cmd->a_guard, cmd->e_guard, cmd);
 		goto out;
 	}
 out:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index ea8be78..df04663 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1020,8 +1020,12 @@ struct qla_tgt_cmd {
 	uint32_t prot_sg_cnt;
 	uint32_t blk_sz;
 	struct crc_context *ctx;
+	uint32_t prot_op;
+	uint32_t prot_type;
 	uint8_t  *cdb;
 	uint64_t lba;
+	uint32_t a_ref_tag, e_ref_tag;
+	uint16_t a_guard, e_guard, a_app_tag, e_app_tag;
 
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
-- 
1.8.3.1
