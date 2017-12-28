From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 14/37] qla2xxx: Allow target mode to accept PRLI in dual mode
Date: Thu, 28 Dec 2017 12:33:22 -0800
Message-ID: <20171228203345.2702-15-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:8768
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751220AbdL1UeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:13 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

For Dual Mode, Initiator side of the driver finish login,
target side receive PRLI, but driver terminates PRLI.
This patch allows target side to go ahead and accept PRLI.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c   |  5 +++++
 drivers/scsi/qla2xxx/qla_target.c | 16 +++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4e6d3eb4caa4..34ee8c755655 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1537,6 +1537,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 	port_id_t cid;	/* conflict Nport id */
 	u16 lid;
 	struct fc_port *conflict_fcport;
+	unsigned long flags;
 
 	switch (ea->data[0]) {
 	case MBS_COMMAND_COMPLETE:
@@ -1557,10 +1558,14 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			    ea->fcport->loop_id, ea->fcport->d_id.b24);
 
 			set_bit(ea->fcport->loop_id, vha->hw->loop_id_map);
+			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			ea->fcport->loop_id = FC_NO_LOOP_ID;
 			ea->fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 			ea->fcport->logout_on_delete = 1;
 			ea->fcport->send_els_logo = 0;
+			ea->fcport->fw_login_state = DSC_LS_PRLI_COMP;
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
 			qla24xx_post_gpdb_work(vha, ea->fcport, 0);
 		}
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index db6fd3b747ed..52a412132abb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4682,7 +4682,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	uint16_t wd3_lo;
 	int res = 0;
 	struct qlt_plogi_ack_t *pla;
-	unsigned long flags;
+	unsigned long flags = 0;
 
 	wwn = wwn_to_u64(iocb->u.isp24.port_name);
 
@@ -4818,8 +4818,14 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 
 		if (sess != NULL) {
-			if (sess->fw_login_state != DSC_LS_PLOGI_PEND &&
-			    sess->fw_login_state != DSC_LS_PLOGI_COMP) {
+			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
+			switch (sess->fw_login_state) {
+			case DSC_LS_PLOGI_COMP:
+			case DSC_LS_PRLI_COMP:
+				break;
+			default:
+				spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock,
+				    flags);
 				/*
 				 * Impatient initiator sent PRLI before last
 				 * PLOGI could finish. Will force him to re-try,
@@ -4830,6 +4836,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				    sess);
 				qlt_send_term_imm_notif(vha, iocb, 1);
 				res = 0;
+				spin_lock_irqsave(&tgt->ha->tgt.sess_lock,
+				    flags);
 				break;
 			}
 
@@ -4853,6 +4861,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				sess->port_type = FCT_INITIATOR;
 			else
 				sess->port_type = FCT_TARGET;
+
+			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
 		}
 		res = 1; /* send notify ack */
 
-- 
2.12.0
