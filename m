From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 02/14] qla2xxx: Allow relogin to proceed if remote login did not finish
Date: Fri, 24 Feb 2017 13:37:31 -0800
Message-ID: <1487972263-3795-3-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0046.outbound.protection.outlook.com ([104.47.42.46]:43535
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751219AbdBXVhx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:37:53 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

If the remote port have started the login process, then the
PLOGI and PRLI should be back to back. Driver will allow
the remote port to complete the process. For the case where
the remote port decide to back off from sending PRLI, this
local port sets an expiration timer for the PRLI. Once the
expiration time passes, the relogin retry logic is allowed
to go through and perform login with the remote port.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 ++
 drivers/scsi/qla2xxx/qla_init.c   | 12 ++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c    | 25 +++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_target.c |  1 +
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c264ced..fea4b79 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2300,6 +2300,8 @@ enum rscn_addr_format {
 	struct ct_sns_desc ct_desc;
 	enum discovery_state disc_state;
 	enum login_state fw_login_state;
+	unsigned long plogi_nack_done_deadline;
+
 	u32 login_gen, last_login_gen;
 	u32 rscn_gen, last_rscn_gen;
 	u32 chip_reset;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6b0ec11..08f8536 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -876,10 +876,14 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	fcport->login_retry--;
 
 	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
 	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
 		return 0;
 
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline))
+			return 0;
+	}
+
 	/* for pure Target Mode. Login will not be initiated */
 	if (vha->host->active_mode == MODE_TARGET)
 		return 0;
@@ -1041,10 +1045,14 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 		fcport->flags);
 
 	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
 	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
 		return;
 
+	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline))
+			return;
+	}
+
 	if (fcport->flags & FCF_ASYNC_SENT) {
 		fcport->login_retry++;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a5faf37..dd4d76c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1632,9 +1632,9 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
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
@@ -1645,8 +1645,9 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
 		ql_dbg(ql_dbg_async, fcport->vha, 0x5036,
-		    "Async-%s complete - hdl=%x portid=%02x%02x%02x "
-		    "iop0=%x.\n", type, sp->handle, fcport->d_id.b.domain,
+		    "Async-%s complete - %8phC hdl=%x portid=%02x%02x%02x "
+		    "iop0=%x.\n", type, fcport->port_name, sp->handle,
+		    fcport->d_id.b.domain,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 		    le32_to_cpu(logio->io_parameter[0]));
 
@@ -1686,6 +1687,17 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	case LSC_SCODE_NPORT_USED:
 		data[0] = MBS_LOOP_ID_USED;
 		break;
+	case LSC_SCODE_CMD_FAILED:
+		if (iop[1] == 0x0606) {
+			/*
+			 * PLOGI/PRLI Completed. We must have Recv PLOGI/PRLI,
+			 * Target side acked.
+			 */
+			data[0] = MBS_COMMAND_COMPLETE;
+			goto logio_done;
+		}
+		data[0] = MBS_COMMAND_ERROR;
+		break;
 	case LSC_SCODE_NOXCB:
 		vha->hw->exch_starvation++;
 		if (vha->hw->exch_starvation > 5) {
@@ -1707,8 +1719,9 @@ static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
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
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d7fc9db..5d650f6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -554,6 +554,7 @@ void qla2x00_async_nack_sp_done(void *s, int res)
 		sp->fcport->login_gen++;
 		sp->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
 		sp->fcport->logout_on_delete = 1;
+		sp->fcport->plogi_nack_done_deadline = jiffies + HZ;
 		break;
 
 	case SRB_NACK_PRLI:
-- 
1.8.3.1
