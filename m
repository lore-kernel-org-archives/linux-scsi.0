From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 5/9] qla2xxx: Move Command residual check from qla2xxx to tcm_qla2xxx
Date: Sun, 18 Dec 2016 01:02:45 -0800
Message-ID: <1482051769-22941-6-git-send-email-himanshu.madhani@cavium.com>
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

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |  8 ++++----
 drivers/scsi/qla2xxx/qla_target.h  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 14 ++++++++++++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8640561..20f1b50 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2123,16 +2123,16 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 
 	*full_req_cnt = prm->req_cnt;
 
-	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
-		prm->residual = se_cmd->residual_count;
+	if (cmd->residual < 0) {
+		prm->residual = -(cmd->residual);
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x305c,
 		    "Residual underflow: %d (tag %lld, op %x, bufflen %d, rq_result %x)\n",
 		       prm->residual, se_cmd->tag,
 		       se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
 		       cmd->bufflen, prm->rq_result);
 		prm->rq_result |= SS_RESIDUAL_UNDER;
-	} else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
-		prm->residual = se_cmd->residual_count;
+	} else if (cmd->residual > 0) {
+		prm->residual = cmd->residual;
 		ql_dbg(ql_dbg_io, vha, 0x305d,
 		    "Residual overflow: %d (tag %lld, op %x, bufflen %d, rq_result %x)\n",
 		       prm->residual, se_cmd->tag, se_cmd->t_task_cdb ?
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 027bed3..305b798 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1007,6 +1007,7 @@ struct qla_tgt_cmd {
 	uint32_t unpacked_lun;
 	enum dma_data_direction dma_data_direction;
 	uint32_t reset_count;
+	int residual;				/* + = over, - = under */
 
 	uint16_t loop_id;	/* to save extra sess dereferences */
 	struct qla_tgt *tgt;	/* to save extra sess dereferences */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7026f3e..ecb4067 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -265,6 +265,15 @@ static void tcm_qla2xxx_complete_mcmd(struct work_struct *work)
 	transport_generic_free_cmd(&mcmd->se_cmd, 0);
 }
 
+static void tcm_qla2xxx_check_resid(struct se_cmd *se_cmd,
+    struct qla_tgt_cmd *cmd)
+{
+	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT)
+		cmd->residual = -(se_cmd->residual_count);
+	else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		cmd->residual = se_cmd->residual_count;
+}
+
 /*
  * Called from qla_target_template->free_mcmd(), and will call
  * tcm_qla2xxx_release_cmd() via normal struct target_core_fabric_ops
@@ -701,6 +710,8 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
 
+	tcm_qla2xxx_check_resid(se_cmd, cmd);
+
 	/*
 	 * Now queue completed DATA_IN the qla2xxx LLD and response ring
 	 */
@@ -739,6 +750,9 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 
 		cmd->bufflen = 0;
 	}
+
+	tcm_qla2xxx_check_resid(se_cmd, cmd);
+
 	/*
 	 * Now queue status response to qla2xxx LLD code and response ring
 	 */
-- 
1.8.3.1
