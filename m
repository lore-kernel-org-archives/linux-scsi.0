From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 37/43] qla2xxx: Prevent multiple active discovery commands per session
Date: Tue, 19 Dec 2017 22:56:38 -0800
Message-ID: <20171220065644.21511-38-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:10627
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932463AbdLTG5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:43 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add check to allow single discovery command per session to be sent

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 16 ++++++++--------
 drivers/scsi/qla2xxx/qla_init.c | 11 ++++++-----
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8256b65e9e7a..29b63c2a380b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3176,16 +3176,16 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		goto done;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GID_PN;
 	fcport->scan_state = QLA_FCPORT_SCAN;
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = sp_to_str(SPCN_GIDPN);
 	sp->gen1 = fcport->rscn_gen;
@@ -3226,8 +3226,8 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -3368,14 +3368,14 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		goto done;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = sp_to_str(SPCN_GPSC);
 	sp->gen1 = fcport->rscn_gen;
@@ -3415,8 +3415,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -3829,7 +3829,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
@@ -4525,12 +4525,12 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!vha->flags.online)
 		goto done;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GFPN_ID;
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = sp_to_str(SPCN_GFPNID);
 	sp->gen1 = fcport->rscn_gen;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 185c106cec0c..f42f2f16343f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -206,7 +206,6 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		fcport->flags &= ~FCF_ASYNC_SENT;
 		fcport->flags |= FCF_LOGIN_NEEDED;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		goto done_free_sp;
@@ -221,8 +220,8 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -244,9 +243,11 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	srb_t *sp;
 	struct srb_iocb *lio;
-	int rval;
+	int rval = QLA_FUNCTION_FAILED;
+
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
-	rval = QLA_FUNCTION_FAILED;
 	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -717,7 +718,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	unsigned long flags;
 	u16 *mb;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		goto done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
-- 
2.12.0
