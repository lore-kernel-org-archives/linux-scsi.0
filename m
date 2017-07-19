From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 7/7] qla2xxx: Refactor usage of Active command arrays
Date: Wed, 19 Jul 2017 11:51:51 -0700
Message-ID: <20170719185151.8564-8-himanshu.madhani@cavium.com>
References: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:23506
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755058AbdGSSwY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Jul 2017 14:52:24 -0400
In-Reply-To: <20170719185151.8564-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c    | 51 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_def.h    | 31 +++++++++++++++---------
 drivers/scsi/qla2xxx/qla_init.c   |  7 +++---
 drivers/scsi/qla2xxx/qla_inline.h | 23 +++++++++++-------
 drivers/scsi/qla2xxx/qla_iocb.c   | 16 ++++++------
 drivers/scsi/qla2xxx/qla_isr.c    | 31 +++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mbx.c    |  6 +++--
 drivers/scsi/qla2xxx/qla_mr.c     | 19 ++++++++-------
 drivers/scsi/qla2xxx/qla_nvme.c   |  2 +-
 drivers/scsi/qla2xxx/qla_nx.c     |  6 +++--
 drivers/scsi/qla2xxx/qla_os.c     | 29 +++++++++++++---------
 drivers/scsi/qla2xxx/qla_target.c | 18 ++++++++------
 drivers/scsi/qla2xxx/qla_target.h |  5 ----
 13 files changed, 139 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2ea0ef93f5cb..356cea400d19 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1920,7 +1920,7 @@ qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 	return rval;
 
 done_free_srb:
-	mempool_free(sp, ha->srb_mempool);
+	mempool_free(SRB_TO_U(sp), ha->srb_mempool);
 done_unmap_sg:
 	dma_unmap_sg(&ha->pdev->dev,
 	    bsg_job->reply_payload.sg_list,
@@ -2043,7 +2043,7 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x70cd,
 		    "qla2x00_start_sp failed=%d.\n", rval);
-		mempool_free(sp, ha->srb_mempool);
+		mempool_free(SRB_TO_U(sp), ha->srb_mempool);
 		rval = -EIO;
 		goto done_free_fcport;
 	}
@@ -2533,6 +2533,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	int cnt, que;
 	unsigned long flags;
 	struct req_que *req;
+	struct unify_cmd *u;
 
 	/* find the bsg job from the active list of commands */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -2542,30 +2543,30 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 			continue;
 
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (sp) {
-				if (((sp->type == SRB_CT_CMD) ||
-					(sp->type == SRB_ELS_CMD_HST) ||
-					(sp->type == SRB_FXIOCB_BCMD))
-					&& (sp->u.bsg_job == bsg_job)) {
-					req->outstanding_cmds[cnt] = NULL;
-					spin_unlock_irqrestore(&ha->hardware_lock, flags);
-					if (ha->isp_ops->abort_command(sp)) {
-						ql_log(ql_log_warn, vha, 0x7089,
-						    "mbx abort_command "
-						    "failed.\n");
-						scsi_req(bsg_job->req)->result =
-						bsg_reply->result = -EIO;
-					} else {
-						ql_dbg(ql_dbg_user, vha, 0x708a,
-						    "mbx abort_command "
-						    "success.\n");
-						scsi_req(bsg_job->req)->result =
-						bsg_reply->result = 0;
-					}
-					spin_lock_irqsave(&ha->hardware_lock, flags);
-					goto done;
+			u = req->outstanding_cmds[cnt];
+			if (!u || u->cmd_type != TYPE_SRB)
+				continue;
+
+			sp = &u->srb;
+			if (((sp->type == SRB_CT_CMD) ||
+			    (sp->type == SRB_ELS_CMD_HST) ||
+			    (sp->type == SRB_FXIOCB_BCMD))
+				&& (sp->u.bsg_job == bsg_job)) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(&ha->hardware_lock, flags);
+				if (ha->isp_ops->abort_command(sp)) {
+					ql_log(ql_log_warn, vha, 0x7089,
+					    "mbx abort_command failed.\n");
+					scsi_req(bsg_job->req)->result =
+					    bsg_reply->result = -EIO;
+				} else {
+					ql_dbg(ql_dbg_user, vha, 0x708a,
+					    "mbx abort_command success.\n");
+					scsi_req(bsg_job->req)->result =
+					    bsg_reply->result = 0;
 				}
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+				goto done;
 			}
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index caee4a2b4002..a17042649eab 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -291,6 +291,7 @@ struct name_list_extended {
 
 struct req_que;
 struct qla_tgt_sess;
+struct unify_cmd;
 
 /*
  * SCSI Request Block
@@ -458,18 +459,7 @@ struct srb_iocb {
 #define SRB_NVME_LS	20
 #define SRB_PRLI_CMD	21
 
-enum {
-	TYPE_SRB,
-	TYPE_TGT_CMD,
-};
-
 typedef struct srb {
-	/*
-	 * Do not move cmd_type field, it needs to
-	 * line up with qla_tgt_cmd->cmd_type
-	 */
-	uint8_t cmd_type;
-	uint8_t pad[3];
 	atomic_t ref_count;
 	wait_queue_head_t nvme_ls_waitq;
 	struct fc_port *fcport;
@@ -3286,7 +3276,7 @@ struct req_que {
 	uint16_t  qos;
 	uint16_t  vp_idx;
 	struct rsp_que *rsp;
-	srb_t **outstanding_cmds;
+	struct unify_cmd **outstanding_cmds;
 	uint32_t current_outstanding_cmd;
 	uint16_t num_outstanding_cmds;
 	int max_q_depth;
@@ -4383,6 +4373,23 @@ enum nexus_wait_type {
 	(IS_QLA27XX(_ha) || IS_QLA83XX(_ha)))
 
 #include "qla_target.h"
+
+typedef enum {
+	TYPE_SRB,
+	TYPE_TGT_CMD,
+} cmd_type_t;
+
+struct unify_cmd {
+	cmd_type_t  cmd_type;
+	union {
+		struct srb srb;
+		struct qla_tgt_cmd tcmd;
+	};
+};
+
+#define SRB_TO_U(_p) container_of(_p, struct unify_cmd, srb)
+#define TCMD_TO_U(_p) container_of(_p, struct unify_cmd, tcmd)
+
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 072ad1aa5505..8c6dd13982be 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1404,10 +1404,11 @@ qla24xx_async_abort_command(srb_t *sp)
 	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = vha->req;
+	struct unify_cmd *u = SRB_TO_U(sp);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
-		if (req->outstanding_cmds[handle] == sp)
+		if (req->outstanding_cmds[handle] == u)
 			break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2799,7 +2800,7 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *ha, struct req_que *req)
 			req->num_outstanding_cmds = ha->cur_fw_iocb_count;
 	}
 
-	req->outstanding_cmds = kzalloc(sizeof(srb_t *) *
+	req->outstanding_cmds = kzalloc(sizeof(struct unify_cmd *) *
 	    req->num_outstanding_cmds, GFP_KERNEL);
 
 	if (!req->outstanding_cmds) {
@@ -2808,7 +2809,7 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *ha, struct req_que *req)
 		 * initialization.
 		 */
 		req->num_outstanding_cmds = MIN_OUTSTANDING_COMMANDS;
-		req->outstanding_cmds = kzalloc(sizeof(srb_t *) *
+		req->outstanding_cmds = kzalloc(sizeof(struct unify_cmd *) *
 		    req->num_outstanding_cmds, GFP_KERNEL);
 
 		if (!req->outstanding_cmds) {
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 9a2c86eacf44..a2c29334a5bd 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -206,6 +206,7 @@ qla2x00_reset_active(scsi_qla_host_t *vha)
 static inline srb_t *
 qla2xxx_get_qpair_sp(struct qla_qpair *qpair, fc_port_t *fcport, gfp_t flag)
 {
+	struct unify_cmd *u;
 	srb_t *sp = NULL;
 	uint8_t bail;
 
@@ -213,11 +214,13 @@ qla2xxx_get_qpair_sp(struct qla_qpair *qpair, fc_port_t *fcport, gfp_t flag)
 	if (unlikely(bail))
 		return NULL;
 
-	sp = mempool_alloc(qpair->srb_mempool, flag);
-	if (!sp)
+	u = mempool_alloc(qpair->srb_mempool, flag);
+	if (!u)
 		goto done;
 
-	memset(sp, 0, sizeof(*sp));
+	memset(u, 0, sizeof(*u));
+	u->cmd_type = TYPE_SRB;
+	sp = &u->srb;
 	sp->fcport = fcport;
 	sp->iocbs = 1;
 	sp->vha = qpair->vha;
@@ -230,7 +233,7 @@ qla2xxx_get_qpair_sp(struct qla_qpair *qpair, fc_port_t *fcport, gfp_t flag)
 static inline void
 qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
 {
-	mempool_free(sp, qpair->srb_mempool);
+	mempool_free(SRB_TO_U(sp), qpair->srb_mempool);
 	QLA_QPAIR_MARK_NOT_BUSY(qpair);
 }
 
@@ -238,19 +241,21 @@ static inline srb_t *
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
+	struct unify_cmd *u;
 	uint8_t bail;
 
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (unlikely(bail))
 		return NULL;
 
-	sp = mempool_alloc(vha->hw->srb_mempool, flag);
-	if (!sp)
+	u = mempool_alloc(vha->hw->srb_mempool, flag);
+	if (!u)
 		goto done;
 
-	memset(sp, 0, sizeof(*sp));
+	memset(u, 0, sizeof(*u));
+	u->cmd_type = TYPE_SRB;
+	sp = &u->srb;
 	sp->fcport = fcport;
-	sp->cmd_type = TYPE_SRB;
 	sp->iocbs = 1;
 	sp->vha = vha;
 done:
@@ -263,7 +268,7 @@ static inline void
 qla2x00_rel_sp(srb_t *sp)
 {
 	QLA_VHA_MARK_NOT_BUSY(sp->vha);
-	mempool_free(sp, sp->vha->hw->srb_mempool);
+	mempool_free(SRB_TO_U(sp), sp->vha->hw->srb_mempool);
 }
 
 static inline void
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a36c485fae50..838b5e338701 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -384,7 +384,7 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Build command packet */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -1474,7 +1474,7 @@ qla24xx_start_scsi(srb_t *sp)
 
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -1677,7 +1677,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 
 	/* Build header part of command packet (excluding the OPCODE). */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -1827,7 +1827,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -2044,7 +2044,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	/* Build header part of command packet (excluding the OPCODE). */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -2148,7 +2148,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 
 	/* Prep command array. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 
 	/* Adjust entry-counts as needed. */
@@ -3033,7 +3033,7 @@ qla82xx_start_scsi(srb_t *sp)
 	}
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -3459,7 +3459,7 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	cmd_pkt->entry_status = (uint8_t) rsp->id;
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	req->cnt -= req_cnt;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c14fab35fc36..fba8bfdd1627 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1251,6 +1251,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
+	struct unify_cmd *u;
 
 	/* Validate handle. */
 	if (index >= req->num_outstanding_cmds) {
@@ -1264,8 +1265,9 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		return;
 	}
 
-	sp = req->outstanding_cmds[index];
-	if (sp) {
+	u = req->outstanding_cmds[index];
+	if (u) {
+		sp = &u->srb;
 		/* Free outstanding command slot. */
 		req->outstanding_cmds[index] = NULL;
 
@@ -1289,6 +1291,7 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	sts_entry_t *pkt = iocb;
 	srb_t *sp = NULL;
 	uint16_t index;
+	struct unify_cmd *u;
 
 	index = LSW(pkt->handle);
 	if (index >= req->num_outstanding_cmds) {
@@ -1301,12 +1304,14 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		goto done;
 	}
-	sp = req->outstanding_cmds[index];
-	if (!sp) {
+	u = req->outstanding_cmds[index];
+	if (!u) {
 		ql_log(ql_log_warn, vha, 0x5032,
 		    "Invalid completion handle (%x) -- timed-out.\n", index);
-		return sp;
+		return NULL;
 	}
+	sp = &u->srb;
+
 	if (sp->handle != index) {
 		ql_log(ql_log_warn, vha, 0x5033,
 		    "SRB handle (%x) mismatch %x.\n", sp->handle, index);
@@ -2165,6 +2170,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	struct fc_bsg_reply *bsg_reply;
 	sts_entry_t *sts;
 	struct sts_entry_24xx *sts24;
+	struct unify_cmd *u;
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
 
@@ -2176,8 +2182,8 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 		return;
 	}
 
-	sp = req->outstanding_cmds[index];
-	if (!sp) {
+	u = req->outstanding_cmds[index];
+	if (!u) {
 		ql_log(ql_log_warn, vha, 0x70b0,
 		    "Req:%d: Invalid ISP SCSI completion handle(0x%x)\n",
 		    req->id, index);
@@ -2188,6 +2194,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 
 	/* Free outstanding command slot. */
 	req->outstanding_cmds[index] = NULL;
+	sp = &u->srb;
 	bsg_job = sp->u.bsg_job;
 	bsg_request = bsg_job->request;
 	bsg_reply = bsg_job->reply;
@@ -2330,6 +2337,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	uint16_t state_flags = 0;
 	uint16_t retry_delay = 0;
 	uint8_t no_logout = 0;
+	struct unify_cmd *u;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -2356,8 +2364,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	/* Validate handle. */
 	if (handle < req->num_outstanding_cmds) {
-		sp = req->outstanding_cmds[handle];
-		if (!sp) {
+		u = req->outstanding_cmds[handle];
+		if (!u) {
 			ql_dbg(ql_dbg_io, vha, 0x3075,
 			    "%s(%ld): Already returned command for status handle (0x%x).\n",
 			    __func__, vha->host_no, sts->handle);
@@ -2378,14 +2386,15 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
-	if (sp->cmd_type != TYPE_SRB) {
+	if (u->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
 		ql_dbg(ql_dbg_io, vha, 0x3015,
 		    "Unknown sp->cmd_type %x %p).\n",
-		    sp->cmd_type, sp);
+		    u->cmd_type, u);
 		return;
 	}
 
+	sp = &u->srb;
 	/* NVME completion. */
 	if (sp->type == SRB_NVME_CMD) {
 		qla24xx_nvme_iocb_entry(vha, req, pkt);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b271c3f78c85..582896c37af7 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1306,7 +1306,8 @@ qla2x00_abort_command(srb_t *sp)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
-		if (req->outstanding_cmds[handle] == sp)
+		struct unify_cmd *u = SRB_TO_U(sp);
+		if (req->outstanding_cmds[handle] == u)
 			break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -2923,7 +2924,8 @@ qla24xx_abort_command(srb_t *sp)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
-		if (req->outstanding_cmds[handle] == sp)
+		struct unify_cmd *u = SRB_TO_U(sp);
+		if (req->outstanding_cmds[handle] == u)
 			break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 10b742d27e16..fe5b990a88ad 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2292,7 +2292,7 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	struct req_que *req;
 	int logit = 1;
 	int res = 0;
-
+	struct unify_cmd *u;
 	sts = (struct sts_entry_fx00 *) pkt;
 
 	comp_status = sts->comp_status;
@@ -2305,11 +2305,11 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	/* Validate handle. */
 	if (handle < req->num_outstanding_cmds)
-		sp = req->outstanding_cmds[handle];
+		u = req->outstanding_cmds[handle];
 	else
-		sp = NULL;
+		u = NULL;
 
-	if (sp == NULL) {
+	if (u == NULL) {
 		ql_dbg(ql_dbg_io, vha, 0x3034,
 		    "Invalid status handle (0x%x).\n", handle);
 
@@ -2317,6 +2317,7 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		qla2xxx_wake_dpc(vha);
 		return;
 	}
+	sp = &u->srb;
 
 	if (sp->type == SRB_TM_CMD) {
 		req->outstanding_cmds[handle] = NULL;
@@ -2626,7 +2627,7 @@ static void
 qlafx00_multistatus_entry(struct scsi_qla_host *vha,
 	struct rsp_que *rsp, void *pkt)
 {
-	srb_t		*sp;
+	struct unify_cmd *u;
 	struct multi_sts_entry_fx00 *stsmfx;
 	struct qla_hw_data *ha = vha->hw;
 	uint32_t handle, hindex, handle_count, i;
@@ -2656,11 +2657,11 @@ qlafx00_multistatus_entry(struct scsi_qla_host *vha,
 
 		/* Validate handle. */
 		if (handle < req->num_outstanding_cmds)
-			sp = req->outstanding_cmds[handle];
+			u = req->outstanding_cmds[handle];
 		else
-			sp = NULL;
+			u = NULL;
 
-		if (sp == NULL) {
+		if (u == NULL) {
 			ql_dbg(ql_dbg_io, vha, 0x3044,
 			    "Invalid status handle (0x%x).\n", handle);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -3134,7 +3135,7 @@ qlafx00_start_scsi(srb_t *sp)
 
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index da32a06f17a0..faa1b4a40f42 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -377,7 +377,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
-	req->outstanding_cmds[handle] = sp;
+	req->outstanding_cmds[handle] = SRB_TO_U(sp);
 	sp->handle = handle;
 	req->cnt -= req_cnt;
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index a77c33987703..8b86c2b3c286 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3668,6 +3668,7 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 		int cnt, que;
 		srb_t *sp;
 		struct req_que *req;
+		struct unify_cmd *u;
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		for (que = 0; que < ha->max_req_queues; que++) {
@@ -3675,8 +3676,9 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 			if (!req)
 				continue;
 			for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-				sp = req->outstanding_cmds[cnt];
-				if (sp) {
+				u = req->outstanding_cmds[cnt];
+				if (u) {
+					sp = &u->srb;
 					if ((!sp->u.scmd.ctx ||
 					    (sp->flags &
 						SRB_FCP_CMND_DMA_VALID)) &&
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 256d3a34d4ee..45482c9c73b0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1335,6 +1335,7 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 	struct req_que *req;
 	srb_t *sp;
 	struct scsi_cmnd *cmd;
+	struct unify_cmd *u;
 
 	status = QLA_SUCCESS;
 
@@ -1342,9 +1343,11 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 	req = vha->req;
 	for (cnt = 1; status == QLA_SUCCESS &&
 		cnt < req->num_outstanding_cmds; cnt++) {
-		sp = req->outstanding_cmds[cnt];
-		if (!sp)
+		u = req->outstanding_cmds[cnt];
+		if (!u)
 			continue;
+
+		sp = &u->srb;
 		if (sp->type != SRB_SCSI_CMD)
 			continue;
 		if (vha->vp_idx != sp->vha->vp_idx)
@@ -1697,6 +1700,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 	int que, cnt, status;
 	unsigned long flags;
 	srb_t *sp;
+	struct unify_cmd *u;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
@@ -1711,10 +1715,11 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 		if (!req->outstanding_cmds)
 			continue;
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (sp) {
+			u = req->outstanding_cmds[cnt];
+			if (u) {
 				req->outstanding_cmds[cnt] = NULL;
-				if (sp->cmd_type == TYPE_SRB) {
+				if (u->cmd_type == TYPE_SRB) {
+					sp = &u->srb;
 					if (sp->type == SRB_NVME_CMD ||
 					    sp->type == SRB_NVME_LS) {
 						sp_get(sp);
@@ -1768,7 +1773,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 							    vha->dpc_flags);
 						continue;
 					}
-					cmd = (struct qla_tgt_cmd *)sp;
+					cmd = &u->tcmd;
 					qlt_abort_cmd_on_host_reset(cmd->vha,
 					    cmd);
 				}
@@ -5926,6 +5931,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	uint16_t        w;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+	struct unify_cmd *u;
 
 	if (ha->flags.eeh_busy) {
 		ql_dbg(ql_dbg_timer, vha, 0x6000,
@@ -5986,11 +5992,12 @@ qla2x00_timer(scsi_qla_host_t *vha)
 				    index++) {
 					fc_port_t *sfcp;
 
-					sp = req->outstanding_cmds[index];
-					if (!sp)
+					u = req->outstanding_cmds[index];
+					if (!u)
 						continue;
-					if (sp->cmd_type != TYPE_SRB)
+					if (u->cmd_type != TYPE_SRB)
 						continue;
+					sp = &u->srb;
 					if (sp->type != SRB_SCSI_CMD)
 						continue;
 					sfcp = sp->fcport;
@@ -6571,8 +6578,8 @@ qla2x00_module_init(void)
 	int ret = 0;
 
 	/* Allocate cache for SRBs. */
-	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
-	    SLAB_HWCACHE_ALIGN, NULL);
+	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(struct unify_cmd),
+	    0, SLAB_HWCACHE_ALIGN, NULL);
 	if (srb_cachep == NULL) {
 		ql_log(ql_log_fatal, NULL, 0x0001,
 		    "Unable to allocate SRB cache...Failing load!.\n");
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e101cd3043b9..0aa0088f2988 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2379,7 +2379,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
 		 */
 		return -EAGAIN;
 	} else
-		qpair->req->outstanding_cmds[h] = (srb_t *)prm->cmd;
+		qpair->req->outstanding_cmds[h] = TCMD_TO_U(prm->cmd);
 
 	pkt->handle = MAKE_HANDLE(qpair->req->id, h);
 	pkt->handle |= CTIO_COMPLETION_HANDLE_MARK;
@@ -2908,7 +2908,7 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 		 */
 		return -EAGAIN;
 	} else
-		qpair->req->outstanding_cmds[h] = (srb_t *)prm->cmd;
+		qpair->req->outstanding_cmds[h] = TCMD_TO_U(prm->cmd);
 
 	pkt->handle  = MAKE_HANDLE(qpair->req->id, h);
 	pkt->handle |= CTIO_COMPLETION_HANDLE_MARK;
@@ -3709,6 +3709,7 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 	struct req_que *req;
 	int qid = GET_QID(handle);
 	uint32_t h = handle & ~QLA_TGT_HANDLE_MASK;
+	struct unify_cmd *u;
 
 	if (unlikely(h == QLA_TGT_SKIP_HANDLE))
 		return NULL;
@@ -3734,13 +3735,14 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 			return NULL;
 		}
 
-		cmd = (struct qla_tgt_cmd *)req->outstanding_cmds[h];
-		if (unlikely(cmd == NULL)) {
+		u = req->outstanding_cmds[h];
+		if (unlikely(u == NULL)) {
 			ql_dbg(ql_dbg_async, vha, 0xe053,
 			    "qla_target(%d): Suspicious: unable to find the command with handle %x req->id %d rsp->id %d\n",
 				vha->vp_idx, handle, req->id, rsp->id);
 			return NULL;
 		}
+		cmd = &u->tcmd;
 		req->outstanding_cmds[h] = NULL;
 	} else if (ctio != NULL) {
 		/* We can't get loop ID from CTIO7 */
@@ -4161,14 +4163,16 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_cmd *cmd;
 	int tag;
+	struct unify_cmd *u;
 
 	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
 	if (tag < 0)
 		return NULL;
 
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
-	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
-	cmd->cmd_type = TYPE_TGT_CMD;
+	u = &((struct unify_cmd *)se_sess->sess_cmd_map)[tag];
+	memset(u, 0, sizeof(*u));
+	u->cmd_type = TYPE_TGT_CMD;
+	cmd = &u->tcmd;
 	memcpy(&cmd->atio, atio, sizeof(*atio));
 	cmd->state = QLA_TGT_STATE_NEW;
 	cmd->tgt = vha->vha_tgt.qla_tgt;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 7fe02d036bdf..b2032a4efbc2 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -872,11 +872,6 @@ enum trace_flags {
 };
 
 struct qla_tgt_cmd {
-	/*
-	 * Do not move cmd_type field. it needs to line up with srb->cmd_type
-	 */
-	uint8_t cmd_type;
-	uint8_t pad[7];
 	struct se_cmd se_cmd;
 	struct fc_port *sess;
 	struct qla_qpair *qpair;
-- 
2.12.0
