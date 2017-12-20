From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 38/43] qla2xxx: Prevent relogin trigger from sending too many commands
Date: Tue, 19 Dec 2017 22:56:39 -0800
Message-ID: <20171220065644.21511-39-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:33315
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932515AbdLTG5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:40 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch adds check for pending work event before queueing
relogin work to prevent redundant work to be active at the
same time.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_gs.c   |  6 ++++--
 drivers/scsi/qla2xxx/qla_init.c | 14 +++++++++-----
 drivers/scsi/qla2xxx/qla_os.c   |  4 +++-
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3811ccd1c60b..0c31c8ad0c1e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2504,6 +2504,7 @@ static const char * const port_state_str[] = {
 #define FCF_FCP2_DEVICE		BIT_2
 #define FCF_ASYNC_SENT		BIT_3
 #define FCF_CONF_COMP_SUPPORTED BIT_4
+#define FCF_ASYNC_ACTIVE	BIT_5
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 29b63c2a380b..dd02cbfd0fb1 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3137,7 +3137,7 @@ static void qla2x00_async_gidpn_sp_done(void *s, int res)
 	u8 *id = fcport->ct_desc.ct_sns->p.rsp.rsp.gid_pn.port_id;
 	struct event_arg ea;
 
-	fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 
 	memset(&ea, 0, sizeof(ea));
 	ea.fcport = fcport;
@@ -3246,6 +3246,7 @@ int qla24xx_post_gidpn_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.fcport.fcport = fcport;
+	fcport->flags |= FCF_ASYNC_ACTIVE;
 	return qla2x00_post_work(vha, e);
 }
 
@@ -3258,6 +3259,7 @@ int qla24xx_post_gpsc_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.fcport.fcport = fcport;
+	fcport->flags |= FCF_ASYNC_ACTIVE;
 	return qla2x00_post_work(vha, e);
 }
 
@@ -3305,7 +3307,7 @@ static void qla24xx_async_gpsc_sp_done(void *s, int res)
 	    "Async done-%s res %x, WWPN %8phC \n",
 	    sp->name, res, fcport->port_name);
 
-	fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 
 	if (res == (DID_ERROR << 16)) {
 		/* entry status error */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f42f2f16343f..85bdb6928ea2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -109,7 +109,7 @@ qla2x00_async_iocb_timeout(void *data)
 		    "Async-%s timeout - hdl=%x portid=%06x %8phC.\n",
 		    sp->name, sp->handle, fcport->d_id.b24, fcport->port_name);
 
-		fcport->flags &= ~FCF_ASYNC_SENT;
+		fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	} else {
 		pr_info("Async-%s timeout - hdl=%x.\n",
 		    sp->name, sp->handle);
@@ -154,7 +154,8 @@ qla2x00_async_login_sp_done(void *ptr, int res)
 	ql_dbg(ql_dbg_disc, vha, 0x20dd,
 	    "%s %8phC res %d \n", __func__, sp->fcport->port_name, res);
 
-	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+
 	if (!test_bit(UNLOADING, &vha->dpc_flags)) {
 		memset(&ea, 0, sizeof(ea));
 		ea.event = FCME_PLOGI_DONE;
@@ -231,7 +232,7 @@ qla2x00_async_logout_sp_done(void *ptr, int res)
 	srb_t *sp = ptr;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
-	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	if (!test_bit(UNLOADING, &sp->vha->dpc_flags))
 		qla2x00_post_async_logout_done_work(sp->vha, sp->fcport,
 		    lio->u.logio.data);
@@ -667,7 +668,7 @@ qla24xx_async_gnl_sp_done(void *s, int res)
 
 	list_for_each_entry_safe(fcport, tf, &h, gnl_entry) {
 		list_del_init(&fcport->gnl_entry);
-		fcport->flags &= ~FCF_ASYNC_SENT;
+		fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 		ea.fcport = fcport;
 
 		qla2x00_fcport_event_handler(vha, &ea);
@@ -790,6 +791,7 @@ int qla24xx_post_gnl_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return QLA_FUNCTION_FAILED;
 
 	e->u.fcport.fcport = fcport;
+	fcport->flags |= FCF_ASYNC_ACTIVE;
 	return qla2x00_post_work(vha, e);
 }
 
@@ -807,7 +809,7 @@ void qla24xx_async_gpdb_sp_done(void *s, int res)
 	    "Async done-%s res %x, WWPN %8phC mb[1]=%x mb[2]=%x \n",
 	    sp->name, res, fcport->port_name, mb[1], mb[2]);
 
-	fcport->flags &= ~FCF_ASYNC_SENT;
+	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 
 	memset(&ea, 0, sizeof(ea));
 	ea.event = FCME_GPDB_DONE;
@@ -930,6 +932,7 @@ int qla24xx_post_gpdb_work(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 
 	e->u.fcport.fcport = fcport;
 	e->u.fcport.opt = opt;
+	fcport->flags |= FCF_ASYNC_ACTIVE;
 	return qla2x00_post_work(vha, e);
 }
 
@@ -1519,6 +1522,7 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 done_free_sp:
 	sp->free(sp);
+	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 77fa8809cf4a..22ab1a6dd577 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4686,6 +4686,7 @@ int qla2x00_post_async_##name##_work(		\
 		e->u.logio.data[0] = data[0];	\
 		e->u.logio.data[1] = data[1];	\
 	}					\
+	fcport->flags |= FCF_ASYNC_ACTIVE;	\
 	return qla2x00_post_work(vha, e);	\
 }
 
@@ -5065,7 +5066,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 		 * to it if we haven't run out of retries.
 		 */
 		if (atomic_read(&fcport->state) != FCS_ONLINE &&
-		    fcport->login_retry && !(fcport->flags & FCF_ASYNC_SENT)) {
+		    fcport->login_retry &&
+		    !(fcport->flags & (FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE))) {
 			if (vha->hw->current_topology != ISP_CFG_NL) {
 				ql_dbg(ql_dbg_disc, fcport->vha, 0x2108,
 				    "%s %8phC DS %d LS %d\n", __func__,
-- 
2.12.0
