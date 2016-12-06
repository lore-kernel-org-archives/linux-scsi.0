From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 20/22] qla2xxx: Allow relogin to go through if remote login did not finish
Date: Tue, 6 Dec 2016 12:30:49 -0800
Message-ID: <1481056251-2310-21-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 ++
 drivers/scsi/qla2xxx/qla_init.c   | 14 ++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c    | 25 +++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_os.c     |  2 +-
 drivers/scsi/qla2xxx/qla_target.c |  2 ++
 5 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3464d65..404acee 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2216,6 +2216,8 @@ enum rscn_addr_format {
 	struct ct_sns_desc ct_desc;
 	enum discovery_state disc_state;
 	enum login_state fw_login_state;
+	unsigned long plogi_nack_done_jiff;
+
 	u32 login_gen, last_login_gen;
 	u32 rscn_gen, last_rscn_gen;
 	u32 chip_reset;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d8b18a9..549a7c6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -895,10 +895,15 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	fcport->login_retry--;
 
 	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
 	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
 		return 0;
 
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+		unsigned long t = fcport->plogi_nack_done_jiff + HZ;
+		if (time_before_eq(jiffies, t))
+			return 0;
+	}
+
 	if (vha->host->active_mode == MODE_TARGET)
 		/* for pure Target Mode. Login will not be initiated */
 		return 0;
@@ -1060,10 +1065,15 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 		fcport->flags);
 
 	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
 	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
 		return;
 
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+		unsigned long t = fcport->plogi_nack_done_jiff + HZ;
+		if (time_before_eq(jiffies, t))
+			return;
+	}
+
 	if (fcport->flags & FCF_ASYNC_SENT) {
 		fcport->login_retry++;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c81ada0..c02033b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1625,9 +1625,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (logio->entry_status) {
 		ql_log(ql_log_warn, fcport->vha, 0x5034,
-		    "Async-%s error entry - hdl=%x"
+		    "Async-%s error entry - %8phC hdl=%x"
 		    "portid=%02x%02x%02x entry-status=%x.\n",
-		    type, sp->handle, fcport->d_id.b.domain,
+		    type, fcport->port_name, sp->handle, fcport->d_id.b.domain,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    logio->entry_status);
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x504d,
@@ -1638,8 +1638,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
 		ql_dbg(ql_dbg_async, fcport->vha, 0x5036,
-		    "Async-%s complete - hdl=%x portid=%02x%02x%02x "
-		    "iop0=%x.\n", type, sp->handle, fcport->d_id.b.domain,
+		    "Async-%s complete - %8phC hdl=%x portid=%02x%02x%02x "
+			"iop0=%x.\n", type, fcport->port_name, sp->handle,
+			fcport->d_id.b.domain,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    le32_to_cpu(logio->io_parameter[0]));
 
@@ -1679,6 +1680,17 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	case LSC_SCODE_NPORT_USED:
 		data[0] = MBS_LOOP_ID_USED;
 		break;
+	case LSC_SCODE_CMD_FAILED:
+		if (iop[1] == 0x0606) {
+			/* PLOGI/PRLI Completed. We must have Recv PLOGI/PRLI,
+			 * Target side acked.
+			 */
+			data[0] = MBS_COMMAND_COMPLETE;
+			goto logio_done;
+			break;
+		}
+		data[0] = MBS_COMMAND_ERROR;
+		break;
 	case LSC_SCODE_NOXCB:
 		vha->hw->exch_starvation++;
 		if (vha->hw->exch_starvation > 5) {
@@ -1700,8 +1712,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	}
 
 	ql_dbg(ql_dbg_async, fcport->vha, 0x5037,
-	    "Async-%s failed - hdl=%x portid=%02x%02x%02x comp=%x "
-	    "iop0=%x iop1=%x.\n", type, sp->handle, fcport->d_id.b.domain,
+	    "Async-%s failed - %8phC hdl=%x portid=%02x%02x%02x comp=%x "
+	    "iop0=%x iop1=%x.\n", type, fcport->port_name,
+		sp->handle, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 	    le16_to_cpu(logio->comp_status),
 	    le32_to_cpu(logio->io_parameter[0]),
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8137238..3e089c3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4512,7 +4512,7 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			fcport->flags |= FCF_FABRIC_DEVICE;
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
 
-			memcpy(&fcport->port_name, e->u.new_sess.port_name,
+			memcpy(fcport->port_name, e->u.new_sess.port_name,
 				   WWN_SIZE);
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8a4b506..521b114 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -576,6 +576,7 @@ void qla2x00_async_nack_sp_done(void *v, void *s, int res)
 		sp->fcport->login_gen++;
 		sp->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
 		sp->fcport->logout_on_delete = 1;
+		sp->fcport->plogi_nack_done_jiff = jiffies;
 		break;
 
 	case SRB_NACK_PRLI:
@@ -3509,6 +3510,7 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 		return -ENOMEM;
 	}
 
+	vha->vha_tgt.qla_tgt->notify_ack_expected++;
 	pkt->entry_type = NOTIFY_ACK_TYPE;
 	pkt->entry_count = 1;
 	pkt->handle = QLA_TGT_SKIP_HANDLE;
-- 
1.8.3.1
