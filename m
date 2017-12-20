From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 15/43] qla2xxx: Add ability to send PRLO
Date: Tue, 19 Dec 2017 22:56:16 -0800
Message-ID: <20171220065644.21511-16-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:62688
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932386AbdLTG5L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:11 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add ability to send Implicit PRLO to flush IOs
from FW back to driver.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  5 ++++
 drivers/scsi/qla2xxx/qla_gbl.h  |  8 ++++++
 drivers/scsi/qla2xxx/qla_gs.c   |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 59 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c | 17 ++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |  9 +++++++
 6 files changed, 99 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a2c0f3d78b35..ba659aa9ae83 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -514,6 +514,7 @@ enum {
 	SPCN_NVME_LS,
 	SPCN_NVME_CMD,
 	SPCN_CTRL_VP,
+	SPCN_PRLO,
 };
 
 struct sp_name {
@@ -544,6 +545,8 @@ struct sp_name {
 #define SRB_NVME_LS	20
 #define SRB_PRLI_CMD	21
 #define SRB_CTRL_VP	22
+#define SRB_PRLO_CMD	23
+
 enum {
 	TYPE_SRB,
 	TYPE_TGT_CMD,
@@ -3184,6 +3187,8 @@ enum qla_work_type {
 	QLA_EVT_GNL,
 	QLA_EVT_NACK,
 	QLA_EVT_RELOGIN,
+	QLA_EVT_ASYNC_PRLO,
+	QLA_EVT_ASYNC_PRLO_DONE,
 };
 
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 88c7746c023a..ea8f24e07409 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -66,6 +66,7 @@ extern void qla84xx_put_chip(struct scsi_qla_host *);
 extern int qla2x00_async_login(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_async_logout(struct scsi_qla_host *, fc_port_t *);
+extern int qla2x00_async_prlo(struct scsi_qla_host *, fc_port_t *);
 extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_t);
@@ -109,6 +110,13 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *, u8 *,
 int qla24xx_fcport_handle_login(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_detect_sfp(scsi_qla_host_t *vha);
 int qla24xx_post_gpdb_work(struct scsi_qla_host *, fc_port_t *, u8);
+void qla2x00_async_prlo_done(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_post_async_prlo_work(struct scsi_qla_host *, fc_port_t *,
+    uint16_t *);
+extern int qla2x00_post_async_prlo_done_work(struct scsi_qla_host *,
+    fc_port_t *, uint16_t *);
+
 /*
  * Global Data in qla_os.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b1c6485c307b..22702a8f5ce6 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -42,6 +42,7 @@ struct sp_name sp_str[] = {
 	{ SPCN_NVME_LS, "nvme_ls" },
 	{ SPCN_NVME_CMD, "nvme_cmd" },
 	{ SPCN_CTRL_VP, "ctrl_vp" },
+	{ SPCN_PRLO, "prlo" },
 };
 
 const char *sp_to_str(uint16_t cmd)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6223dfe20767..900f6d3f3a3a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -278,6 +278,65 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
+
+void
+qla2x00_async_prlo_done(struct scsi_qla_host *vha, fc_port_t *fcport,
+    uint16_t *data)
+{
+	/* Don't re-login in target mode */
+	if (!fcport->tgt_session)
+		qla2x00_mark_device_lost(vha, fcport, 1, 0);
+	qlt_logo_completion_handler(fcport, data[0]);
+}
+
+static void
+qla2x00_async_prlo_sp_done(void *s, int res)
+{
+	srb_t *sp = (srb_t *)s;
+	struct srb_iocb *lio = &sp->u.iocb_cmd;
+	struct scsi_qla_host *vha = sp->vha;
+
+	if (!test_bit(UNLOADING, &vha->dpc_flags))
+		qla2x00_post_async_prlo_done_work(sp->fcport->vha, sp->fcport,
+		    lio->u.logio.data);
+	sp->free(sp);
+}
+
+int
+qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	srb_t *sp;
+	struct srb_iocb *lio;
+	int rval;
+
+	rval = QLA_FUNCTION_FAILED;
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp)
+		goto done;
+
+	sp->type = SRB_PRLO_CMD;
+	sp->name = sp_to_str(SPCN_PRLO);
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	lio = &sp->u.iocb_cmd;
+	lio->timeout = qla2x00_async_iocb_timeout;
+	sp->done = qla2x00_async_prlo_sp_done;
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS)
+		goto done_free_sp;
+
+	ql_dbg(ql_dbg_disc, vha, 0x2070,
+	    "Async-prlo - hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
+	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	return rval;
+
+done_free_sp:
+	sp->free(sp);
+done:
+	return rval;
+}
+
 static
 void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 519a0d2920b8..b2cec8313f27 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3424,6 +3424,20 @@ qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
 	vce->vp_idx_map[map] |= 1 << pos;
 }
 
+static void
+qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
+{
+	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
+	logio->control_flags =
+	    cpu_to_le16(LCF_COMMAND_PRLO|LCF_IMPL_PRLO);
+
+	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
+	logio->port_id[1] = sp->fcport->d_id.b.area;
+	logio->port_id[2] = sp->fcport->d_id.b.domain;
+	logio->vp_index = sp->fcport->vha->vp_idx;
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -3505,6 +3519,9 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_CTRL_VP:
 		qla25xx_ctrlvp_iocb(sp, pkt);
 		break;
+	case SRB_PRLO_CMD:
+		qla24xx_prlo_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fd107c4feda5..13550a8584ca 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4679,6 +4679,8 @@ qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
 qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
 qla2x00_post_async_work(adisc, QLA_EVT_ASYNC_ADISC);
 qla2x00_post_async_work(adisc_done, QLA_EVT_ASYNC_ADISC_DONE);
+qla2x00_post_async_work(prlo, QLA_EVT_ASYNC_PRLO);
+qla2x00_post_async_work(prlo_done, QLA_EVT_ASYNC_PRLO_DONE);
 
 int
 qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
@@ -4932,6 +4934,13 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		case QLA_EVT_NACK:
 			qla24xx_do_nack_work(vha, e);
 			break;
+		case QLA_EVT_ASYNC_PRLO:
+			qla2x00_async_prlo(vha, e->u.logio.fcport);
+			break;
+		case QLA_EVT_ASYNC_PRLO_DONE:
+			qla2x00_async_prlo_done(vha, e->u.logio.fcport,
+			    e->u.logio.data);
+			break;
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-- 
2.12.0
