From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 7/9] qla2xxx: Remove direct access to t_task_cdb/t_task_lba field
Date: Sun, 18 Dec 2016 01:02:47 -0800
Message-ID: <1482051769-22941-8-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0044.outbound.protection.outlook.com ([104.47.41.44]:7130
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756993AbcLRJSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Dec 2016 04:18:53 -0500
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

qla2xxx currently access t_task_cdb/t_task_lba field in
se_cmd struct. Remove access of TCM's private data struct.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 32 +++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_target.h  |  2 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 ++++
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1690794..14092472 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2100,7 +2100,6 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 	struct qla_tgt *tgt = cmd->tgt;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	prm->cmd = cmd;
 	prm->tgt = tgt;
@@ -2126,17 +2125,18 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 	if (cmd->residual < 0) {
 		prm->residual = -(cmd->residual);
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x305c,
-		    "Residual underflow: %d (tag %lld, op %x, bufflen %d, rq_result %x)\n",
-		       prm->residual, se_cmd->tag,
-		       se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
-		       cmd->bufflen, prm->rq_result);
+		    "Residual underflow: %d (tag %d, op %x, bufflen %d, rq_result %x)\n",
+		    prm->residual, cmd->atio.u.isp24.exchange_addr,
+		    cmd->cdb ? cmd->cdb[0] : 0,
+		    cmd->bufflen, prm->rq_result);
 		prm->rq_result |= SS_RESIDUAL_UNDER;
 	} else if (cmd->residual > 0) {
 		prm->residual = cmd->residual;
 		ql_dbg(ql_dbg_io, vha, 0x305d,
-		    "Residual overflow: %d (tag %lld, op %x, bufflen %d, rq_result %x)\n",
-		       prm->residual, se_cmd->tag, se_cmd->t_task_cdb ?
-		       se_cmd->t_task_cdb[0] : 0, cmd->bufflen, prm->rq_result);
+		    "Residual overflow: %d (tag %d, op %x, bufflen %d, rq_result %x)\n",
+		    prm->residual, cmd->atio.u.isp24.exchange_addr,
+		    cmd->cdb ? cmd->cdb[0] : 0,
+		    cmd->bufflen, prm->rq_result);
 		prm->rq_result |= SS_RESIDUAL_OVER;
 	}
 
@@ -2463,7 +2463,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	ql_dbg(ql_dbg_tgt, vha, 0xe071,
 		"qla_target(%d):%s: se_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
 		vha->vp_idx, __func__, se_cmd, se_cmd->prot_op,
-		prm->prot_sg, prm->prot_seg_cnt, se_cmd->t_task_lba);
+		prm->prot_sg, prm->prot_seg_cnt, cmd->lba);
 
 	if ((se_cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
 	    (se_cmd->prot_op == TARGET_PROT_DOUT_STRIP))
@@ -2905,7 +2905,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	uint32_t	e_ref_tag, a_ref_tag;
 	uint16_t	e_app_tag, a_app_tag;
 	uint16_t	e_guard, a_guard;
-	uint64_t	lba = cmd->se_cmd.t_task_lba;
+	uint64_t	lba = cmd->lba;
 
 	a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
 	a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
@@ -2987,7 +2987,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	/* check guard */
 	if (e_guard != a_guard) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
+		cmd->se_cmd.bad_sector = cmd->lba;
 
 		ql_log(ql_log_warn, vha, 0xe076,
 		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -3013,7 +3013,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	/* check appl tag */
 	if (e_app_tag != a_app_tag) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
+		cmd->se_cmd.bad_sector = cmd->lba;
 
 		ql_log(ql_log_warn, vha, 0xe078,
 			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -4813,9 +4813,11 @@ static void qlt_handle_srr_work(struct work_struct *work)
 		cmd->sg = se_cmd->t_data_sg;
 
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
-		       "SRR cmd %p (se_cmd %p, tag %lld, op %x), sg_cnt=%d, offset=%d",
-		       cmd, &cmd->se_cmd, se_cmd->tag, se_cmd->t_task_cdb ?
-		       se_cmd->t_task_cdb[0] : 0, cmd->sg_cnt, cmd->offset);
+		    "SRR cmd %p (se_cmd %p, tag %d, op %x), "
+		    "sg_cnt=%d, offset=%d",
+		    cmd, &cmd->se_cmd, cmd->atio.u.isp24.exchange_addr,
+		    cmd->cdb ? cmd->cdb[0] : 0,
+		    cmd->sg_cnt, cmd->offset);
 
 		qlt_handle_srr(vha, sctio, imm);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 305b798..ea8be78 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1020,6 +1020,8 @@ struct qla_tgt_cmd {
 	uint32_t prot_sg_cnt;
 	uint32_t blk_sz;
 	struct crc_context *ctx;
+	uint8_t  *cdb;
+	uint64_t lba;
 
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index ecb4067..016a27c 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -439,6 +439,8 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 	cmd->prot_sg = se_cmd->t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
+	cmd->cdb = se_cmd->t_task_cdb;
+	cmd->lba = se_cmd->t_task_lba;
 
 	/*
 	 * qla_target.c:qlt_rdy_to_xfer() will call pci_map_sg() to setup
@@ -709,6 +711,8 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->prot_sg = se_cmd->t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
+	cmd->cdb = se_cmd->t_task_cdb;
+	cmd->lba = se_cmd->t_task_lba;
 
 	tcm_qla2xxx_check_resid(se_cmd, cmd);
 
-- 
1.8.3.1

