From: giridhar.malavali@qlogic.com
Subject: [PATCH 16/17] qla2xxx: Cleanup some dead-code and make some functions static.
Date: Fri, 23 Jul 2010 15:28:37 +0500
Message-ID: <1279880918-62876-17-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47971 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:59 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ----
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 drivers/scsi/qla2xxx/qla_mid.c  |   51 +--------------------------------------
 drivers/scsi/qla2xxx/qla_os.c   |    4 +-
 5 files changed, 5 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b7d940f..1a1b281 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -175,10 +175,7 @@ extern int qla2x00_start_scsi(srb_t *sp);
 extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 						uint16_t, uint16_t, uint8_t);
-int __qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
-						uint16_t, uint16_t, uint8_t);
 extern int qla2x00_start_sp(srb_t *);
-extern void qla2x00_ctx_sp_free(srb_t *);
 extern uint16_t qla24xx_calc_iocbs(uint16_t);
 extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *, uint16_t);
 extern int qla24xx_dif_start_scsi(srb_t *);
@@ -489,11 +486,8 @@ extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
 	uint16_t, int, uint8_t);
 extern int qla25xx_create_rsp_que(struct qla_hw_data *, uint16_t, uint8_t,
 	uint16_t, int);
-extern int qla25xx_update_req_que(struct scsi_qla_host *, uint8_t, uint8_t);
 extern void qla2x00_init_response_q_entries(struct rsp_que *);
 extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
-extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
-extern int qla25xx_create_queues(struct scsi_qla_host *, uint8_t);
 extern int qla25xx_delete_queues(struct scsi_qla_host *);
 extern uint16_t qla24xx_rd_req_reg(struct qla_hw_data *, uint16_t);
 extern uint16_t qla25xx_rd_req_reg(struct qla_hw_data *, uint16_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1b7d80b..d863ed2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -64,7 +64,7 @@ qla2x00_ctx_sp_timeout(unsigned long __data)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-void
+static void
 qla2x00_ctx_sp_free(srb_t *sp)
 {
 	struct srb_ctx *ctx = sp->ctx;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c9c709e..d2b299f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -461,7 +461,7 @@ queuing_error:
  *
  * Returns non-zero if a failure occurred, else zero.
  */
-int
+static int
 __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 			struct rsp_que *rsp, uint16_t loop_id,
 			uint16_t lun, uint8_t type)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 642cd79..9a82c34 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -482,7 +482,7 @@ qla25xx_delete_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	return ret;
 }
 
-int
+static int
 qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	int ret = -1;
@@ -497,23 +497,6 @@ qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	return ret;
 }
 
-int qla25xx_update_req_que(struct scsi_qla_host *vha, uint8_t que, uint8_t qos)
-{
-	int ret = 0;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req_q_map[que];
-
-	req->options |= BIT_3;
-	req->qos = qos;
-	ret = qla25xx_init_req_que(vha, req);
-	if (ret != QLA_SUCCESS)
-		DEBUG2_17(printk(KERN_WARNING "%s failed\n", __func__));
-	/* restore options bit */
-	req->options &= ~BIT_3;
-	return ret;
-}
-
-
 /* Delete all queues for a given vhost */
 int
 qla25xx_delete_queues(struct scsi_qla_host *vha)
@@ -740,35 +723,3 @@ que_failed:
 failed:
 	return 0;
 }
-
-int
-qla25xx_create_queues(struct scsi_qla_host *vha, uint8_t qos)
-{
-	uint16_t options = 0;
-	uint8_t ret = 0;
-	struct qla_hw_data *ha = vha->hw;
-	struct rsp_que *rsp;
-
-	options |= BIT_1;
-	ret = qla25xx_create_rsp_que(ha, options, vha->vp_idx, 0, -1);
-	if (!ret) {
-		qla_printk(KERN_WARNING, ha, "Response Que create failed\n");
-		return ret;
-	} else
-		qla_printk(KERN_INFO, ha, "Response Que:%d created.\n", ret);
-	rsp = ha->rsp_q_map[ret];
-
-	options = 0;
-	if (qos & BIT_7)
-		options |= BIT_8;
-	ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, ret,
-					qos & ~BIT_7);
-	if (ret) {
-		vha->req = ha->req_q_map[ret];
-		qla_printk(KERN_INFO, ha, "Request Que:%d created.\n", ret);
-	} else
-		qla_printk(KERN_WARNING, ha, "Request Que create failed\n");
-	rsp->req = ha->req_q_map[ret];
-
-	return ret;
-}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 50f6854..aeb2f1b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -701,7 +701,7 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
  *    Success (Adapter is online/no flash ops) : 0
  *    Failed  (Adapter is offline/disabled/flash ops in progress) : 1
  */
-int
+static int
 qla2x00_wait_for_reset_ready(scsi_qla_host_t *vha)
 {
 	int		return_status;
@@ -3469,7 +3469,7 @@ qla2x00_sp_free_dma(srb_t *sp)
 	CMD_SP(cmd) = NULL;
 }
 
-void
+static void
 qla2x00_sp_final_compl(struct qla_hw_data *ha, srb_t *sp)
 {
 	struct scsi_cmnd *cmd = sp->cmd;
-- 
1.6.0.2

