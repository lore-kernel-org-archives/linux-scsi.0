From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 32/37] qla2xxx: Prevent multiple active discovery commands per session
Date: Thu, 28 Dec 2017 12:33:40 -0800
Message-ID: <20171228203345.2702-33-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0042.outbound.protection.outlook.com ([104.47.41.42]:45927
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754128AbdL1Ued (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:33 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add check to allow single discovery command per session to be sent

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 34 +++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_init.c | 30 +++++++++++++++---------------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8e09f6f16643..abc31b983b93 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3127,16 +3127,16 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GID_PN;
 	fcport->scan_state = QLA_FCPORT_SCAN;
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "gidpn";
 	sp->gen1 = fcport->rscn_gen;
@@ -3177,8 +3177,8 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -3319,14 +3319,14 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "gpsc";
 	sp->gen1 = fcport->rscn_gen;
@@ -3366,8 +3366,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -3780,7 +3780,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
@@ -4337,15 +4337,15 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GNN_ID;
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "gnnid";
 	sp->gen1 = fcport->rscn_gen;
@@ -4386,8 +4386,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -4474,15 +4474,15 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GFPN_ID;
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = "gfpnid";
 	sp->gen1 = fcport->rscn_gen;
@@ -4524,8 +4524,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6452f4c8df5e..93febc177aa7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -207,7 +207,6 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		fcport->flags &= ~FCF_ASYNC_SENT;
 		fcport->flags |= FCF_LOGIN_NEEDED;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		goto done_free_sp;
@@ -222,8 +221,8 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -245,9 +244,11 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
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
@@ -715,14 +716,13 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	unsigned long flags;
 	u16 *mb;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GNL;
 	fcport->last_rscn_gen = fcport->rscn_gen;
 	fcport->last_login_gen = fcport->login_gen;
@@ -730,8 +730,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports);
 	if (vha->gnl.sent) {
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		rval = QLA_SUCCESS;
-		goto done;
+		return QLA_SUCCESS;
 	}
 	vha->gnl.sent = 1;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
@@ -739,6 +738,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
+
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_MB_IOCB;
 	sp->name = "gnlist";
 	sp->gen1 = fcport->rscn_gen;
@@ -773,8 +774,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 done_free_sp:
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	return rval;
 }
 
@@ -898,7 +899,6 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		fcport->flags &= ~FCF_ASYNC_SENT;
 		fcport->flags |= FCF_LOGIN_NEEDED;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		goto done_free_sp;
@@ -940,16 +940,16 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	struct port_database_24xx *pd;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!vha->flags.online)
-		goto done;
+	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+		return rval;
 
-	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GPDB;
 
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_MB_IOCB;
 	sp->name = "gpdb";
 	sp->gen1 = fcport->rscn_gen;
@@ -995,8 +995,8 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
 	sp->free(sp);
-done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+done:
 	qla24xx_post_gpdb_work(vha, fcport, opt);
 	return rval;
 }
-- 
2.12.0
