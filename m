From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 30/43] qla2xxx: Properly extract ADISC error codes
Date: Tue, 19 Dec 2017 22:56:31 -0800
Message-ID: <20171220065644.21511-31-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0048.outbound.protection.outlook.com ([104.47.33.48]:26719
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932386AbdLTG5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:22 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch fixes issue with extraction of ADISC error codes
for decoding the error returned

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e58faa1e984c..bd28a0e6a95c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -338,16 +338,21 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 static
 void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
-	if (ea->rc) {
+	struct fc_port *fcport = ea->fcport;
+
+	ql_dbg(ql_dbg_disc, vha, 0x20d2,
+	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d lid %d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, ea->rc, fcport->login_gen, ea->sp->gen2,
+	    fcport->rscn_gen, ea->sp->gen1, fcport->loop_id);
+
+	if (ea->data[0] != MBS_COMMAND_COMPLETE) {
 		ql_dbg(ql_dbg_disc, vha, 0x2066,
 		    "%s %8phC: adisc fail: post delete\n",
 		    __func__, ea->fcport->port_name);
 		qlt_schedule_sess_for_deletion(ea->fcport, 1);
 		return;
 	}
-	ql_dbg(ql_dbg_disc, vha, 0x20d2,
-	    "%s %8phC DS %d LS %d\n", __func__, ea->fcport->port_name,
-	    ea->fcport->disc_state, ea->fcport->fw_login_state);
 
 	if (ea->fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -355,10 +360,8 @@ void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (ea->sp->gen2 != ea->fcport->login_gen) {
 		/* target side must have changed it. */
 		ql_dbg(ql_dbg_disc, vha, 0x20d3,
-		    "%s %8phC generation changed rscn %d|%d login %d|%d\n",
-		    __func__, ea->fcport->port_name, ea->fcport->last_rscn_gen,
-		    ea->fcport->rscn_gen, ea->fcport->last_login_gen,
-		    ea->fcport->login_gen);
+		    "%s %8phC generation changed\n",
+		    __func__, ea->fcport->port_name);
 		return;
 	} else if (ea->sp->gen1 != ea->fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20d4, "%s %d %8phC post gidpn\n",
@@ -376,6 +379,7 @@ qla2x00_async_adisc_sp_done(void *ptr, int res)
 	srb_t *sp = ptr;
 	struct scsi_qla_host *vha = sp->vha;
 	struct event_arg ea;
+	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2066,
 	    "Async done-%s res %x %8phC\n",
@@ -384,6 +388,10 @@ qla2x00_async_adisc_sp_done(void *ptr, int res)
 	memset(&ea, 0, sizeof(ea));
 	ea.event = FCME_ADISC_DONE;
 	ea.rc = res;
+	ea.data[0] = lio->u.logio.data[0];
+	ea.data[1] = lio->u.logio.data[1];
+	ea.iop[0] = lio->u.logio.iop[0];
+	ea.iop[1] = lio->u.logio.iop[1];
 	ea.fcport = sp->fcport;
 	ea.sp = sp;
 
-- 
2.12.0
