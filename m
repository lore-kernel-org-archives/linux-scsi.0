From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 12/12] qla2xxx: Simplify usage of SRB structure in driver.
Date: Mon, 16 Jan 2017 12:35:24 -0800
Message-ID: <1484598924-29066-13-git-send-email-himanshu.madhani@cavium.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This patch simplifies SRB structure usage in driver.

- Simplify sp->done() and sp->free() interfaces.
- Remove sp->fcport->vha to use vha pointer from sp.
- Use sp->vha context in qla2x00_rel_sp().

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c    | 23 ++++-----
 drivers/scsi/qla2xxx/qla_def.h    |  6 +--
 drivers/scsi/qla2xxx/qla_gbl.h    | 14 +++---
 drivers/scsi/qla2xxx/qla_gs.c     | 32 ++++++-------
 drivers/scsi/qla2xxx/qla_init.c   | 99 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_inline.h | 13 +++--
 drivers/scsi/qla2xxx/qla_iocb.c   | 96 +++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_isr.c    | 36 +++++++-------
 drivers/scsi/qla2xxx/qla_mr.c     | 48 +++++++++----------
 drivers/scsi/qla2xxx/qla_os.c     | 35 +++++++-------
 drivers/scsi/qla2xxx/qla_target.c |  8 ++--
 11 files changed, 199 insertions(+), 211 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 1bf8061..975e7a1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -13,28 +13,25 @@
 
 /* BSG support for ELS/CT pass through */
 void
-qla2x00_bsg_job_done(void *data, void *ptr, int res)
+qla2x00_bsg_job_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
+	srb_t *sp = ptr;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
 
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 void
-qla2x00_bsg_sp_free(void *data, void *ptr)
+qla2x00_bsg_sp_free(void *ptr)
 {
-	srb_t *sp = (srb_t *)ptr;
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	srb_t *sp = ptr;
+	struct qla_hw_data *ha = sp->vha->hw;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	struct fc_bsg_request *bsg_request = bsg_job->request;
-
-	struct qla_hw_data *ha = vha->hw;
 	struct qla_mt_iocb_rqst_fx00 *piocb_rqst;
 
 	if (sp->type == SRB_FXIOCB_BCMD) {
@@ -62,7 +59,7 @@
 	    sp->type == SRB_FXIOCB_BCMD ||
 	    sp->type == SRB_ELS_CMD_HST)
 		kfree(sp->fcport);
-	qla2x00_rel_sp(vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 int
@@ -394,7 +391,7 @@
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
 		    "qla2x00_start_sp failed = %d\n", rval);
-		qla2x00_rel_sp(vha, sp);
+		qla2x00_rel_sp(sp);
 		rval = -EIO;
 		goto done_unmap_sg;
 	}
@@ -542,7 +539,7 @@
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x7017,
 		    "qla2x00_start_sp failed=%d.\n", rval);
-		qla2x00_rel_sp(vha, sp);
+		qla2x00_rel_sp(sp);
 		rval = -EIO;
 		goto done_free_fcport;
 	}
@@ -2578,6 +2575,6 @@
 
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	sp->free(vha, sp);
+	sp->free(sp);
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 329aebf..e6bbd63 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -433,7 +433,7 @@ struct srb_iocb {
 typedef struct srb {
 	atomic_t ref_count;
 	struct fc_port *fcport;
-	void *vha;
+	struct scsi_qla_host *vha;
 	uint32_t handle;
 	uint16_t flags;
 	uint16_t type;
@@ -447,8 +447,8 @@ struct srb_iocb {
 		struct bsg_job *bsg_job;
 		struct srb_cmd scmd;
 	} u;
-	void (*done)(void *, void *, int);
-	void (*free)(void *, void *);
+	void (*done)(void *, int);
+	void (*free)(void *);
 } srb_t;
 
 #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e091457..b3d6441 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -186,9 +186,9 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 
 extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
-extern void qla2x00_sp_compl(void *, void *, int);
-extern void qla2xxx_qpair_sp_free_dma(void *, void *);
-extern void qla2xxx_qpair_sp_compl(void *, void *, int);
+extern void qla2x00_sp_compl(void *, int);
+extern void qla2xxx_qpair_sp_free_dma(void *);
+extern void qla2xxx_qpair_sp_compl(void *, int);
 extern int qla24xx_post_upd_fcport_work(struct scsi_qla_host *, fc_port_t *);
 void qla2x00_handle_login_done_event(struct scsi_qla_host *, fc_port_t *,
 	uint16_t *);
@@ -215,7 +215,7 @@ extern void qla24xx_report_id_acquisition(scsi_qla_host_t *,
 extern int qla24xx_vport_create_req_sanity_check(struct fc_vport *);
 extern scsi_qla_host_t * qla24xx_create_vhost(struct fc_vport *);
 
-extern void qla2x00_sp_free_dma(void *, void *);
+extern void qla2x00_sp_free_dma(void *);
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
 extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
@@ -733,10 +733,10 @@ extern int qla82xx_write_optrom_data(struct scsi_qla_host *, uint8_t *,
 
 /* IOCB related functions */
 extern int qla82xx_start_scsi(srb_t *);
-extern void qla2x00_sp_free(void *, void *);
+extern void qla2x00_sp_free(void *);
 extern void qla2x00_sp_timeout(unsigned long);
-extern void qla2x00_bsg_job_done(void *, void *, int);
-extern void qla2x00_bsg_sp_free(void *, void *);
+extern void qla2x00_bsg_job_done(void *, int);
+extern void qla2x00_bsg_sp_free(void *);
 extern void qla2x00_start_iocbs(struct scsi_qla_host *, struct req_que *);
 
 /* Interrupt related */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d1074fb..6d500fd 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2822,10 +2822,10 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	}
 } /* gidpn_event */
 
-static void qla2x00_async_gidpn_sp_done(void *v, void *s, int res)
+static void qla2x00_async_gidpn_sp_done(void *s, int res)
 {
-	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
-	struct srb *sp = (struct srb *)s;
+	struct srb *sp = s;
+	struct scsi_qla_host *vha = sp->vha;
 	fc_port_t *fcport = sp->fcport;
 	u8 *id = fcport->ct_desc.ct_sns->p.rsp.rsp.gid_pn.port_id;
 	struct event_arg ea;
@@ -2847,7 +2847,7 @@ static void qla2x00_async_gidpn_sp_done(void *v, void *s, int res)
 
 	qla2x00_fcport_event_handler(vha, &ea);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -2905,7 +2905,7 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -2941,11 +2941,11 @@ int qla24xx_post_gpsc_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return qla2x00_post_work(vha, e);
 }
 
-static void qla24xx_async_gpsc_sp_done(void *v, void *s, int res)
+static void qla24xx_async_gpsc_sp_done(void *s, int res)
 {
-	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
+	struct srb *sp = s;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct srb *sp = (struct srb *)s;
 	fc_port_t *fcport = sp->fcport;
 	struct ct_sns_rsp       *ct_rsp;
 	struct event_arg ea;
@@ -3011,7 +3011,7 @@ static void qla24xx_async_gpsc_sp_done(void *v, void *s, int res)
 	ea.fcport = fcport;
 	qla2x00_fcport_event_handler(vha, &ea);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -3066,7 +3066,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -3104,7 +3104,7 @@ void qla24xx_async_gpnid_done(scsi_qla_host_t *vha, srb_t *sp)
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
 
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
@@ -3138,10 +3138,10 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	}
 }
 
-static void qla2x00_async_gpnid_sp_done(void *v, void *s, int res)
+static void qla2x00_async_gpnid_sp_done(void *s, int res)
 {
-	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
-	struct srb *sp = (struct srb *)s;
+	struct srb *sp = s;
+	struct scsi_qla_host *vha = sp->vha;
 	struct ct_sns_req *ct_req =
 	    (struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
 	struct ct_sns_rsp *ct_rsp =
@@ -3183,7 +3183,7 @@ static void qla2x00_async_gpnid_sp_done(void *v, void *s, int res)
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 		}
 
-		sp->free(vha, sp);
+		sp->free(sp);
 		return;
 	}
 
@@ -3272,7 +3272,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
 
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a233467..f46d9f8 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -47,29 +47,27 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 {
 	srb_t *sp = (srb_t *)__data;
 	struct srb_iocb *iocb;
-	scsi_qla_host_t *vha = (scsi_qla_host_t *)sp->vha;
-	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = ha->req_q_map[0];
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	req = vha->hw->req_q_map[0];
 	req->outstanding_cmds[sp->handle] = NULL;
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
-	sp->free(vha, sp);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	sp->free(sp);
+	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 }
 
 void
-qla2x00_sp_free(void *data, void *ptr)
+qla2x00_sp_free(void *ptr)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct srb_iocb *iocb = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 
 	del_timer(&iocb->timer);
-	qla2x00_rel_sp(vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 /* Asynchronous Login/Logout Routines -------------------------------------- */
@@ -97,7 +95,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 void
 qla2x00_async_iocb_timeout(void *data)
 {
-	srb_t *sp = (srb_t *)data;
+	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	struct event_arg ea;
@@ -133,22 +131,21 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	case SRB_NACK_PLOGI:
 	case SRB_NACK_PRLI:
 	case SRB_NACK_LOGO:
-		sp->done(sp->vha, sp, QLA_FUNCTION_TIMEOUT);
+		sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		break;
 	}
 }
 
 static void
-qla2x00_async_login_sp_done(void *data, void *ptr, int res)
+qla2x00_async_login_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
+	struct scsi_qla_host *vha = sp->vha;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 	struct event_arg ea;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
-		"%s %8phC res %d \n",
-		   __func__, sp->fcport->port_name, res);
+	    "%s %8phC res %d \n", __func__, sp->fcport->port_name, res);
 
 	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 	if (!test_bit(UNLOADING, &vha->dpc_flags)) {
@@ -163,7 +160,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 		qla2x00_fcport_event_handler(vha, &ea);
 	}
 
-	sp->free(sp->fcport->vha, sp);
+	sp->free(sp);
 }
 
 int
@@ -215,24 +212,23 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
 static void
-qla2x00_async_logout_sp_done(void *data, void *ptr, int res)
+qla2x00_async_logout_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 
 	sp->fcport->flags &= ~FCF_ASYNC_SENT;
-	if (!test_bit(UNLOADING, &vha->dpc_flags))
-		qla2x00_post_async_logout_done_work(sp->fcport->vha, sp->fcport,
+	if (!test_bit(UNLOADING, &sp->vha->dpc_flags))
+		qla2x00_post_async_logout_done_work(sp->vha, sp->fcport,
 		    lio->u.logio.data);
-	sp->free(sp->fcport->vha, sp);
+	sp->free(sp);
 }
 
 int
@@ -267,23 +263,23 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp);
 done:
 	sp->fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
 static void
-qla2x00_async_adisc_sp_done(void *data, void *ptr, int res)
+qla2x00_async_adisc_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
+	struct scsi_qla_host *vha = sp->vha;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)data;
 
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
-		qla2x00_post_async_adisc_done_work(sp->fcport->vha, sp->fcport,
+		qla2x00_post_async_adisc_done_work(sp->vha, sp->fcport,
 		    lio->u.logio.data);
-	sp->free(sp->fcport->vha, sp);
+	sp->free(sp);
 }
 
 int
@@ -320,7 +316,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -482,10 +478,10 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 } /* gnl_event */
 
 static void
-qla24xx_async_gnl_sp_done(void *v, void *s, int res)
+qla24xx_async_gnl_sp_done(void *s, int res)
 {
-	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
-	struct srb *sp = (struct srb *)s;
+	struct srb *sp = s;
+	struct scsi_qla_host *vha = sp->vha;
 	unsigned long flags;
 	struct fc_port *fcport = NULL, *tf;
 	u16 i, n = 0, loop_id;
@@ -544,7 +540,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -612,7 +608,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(fcport->vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
@@ -631,10 +627,10 @@ int qla24xx_post_gnl_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 }
 
 static
-void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
+void qla24xx_async_gpdb_sp_done(void *s, int res)
 {
-	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
-	struct srb *sp = (struct srb *)s;
+	struct srb *sp = s;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	uint64_t zero = 0;
 	struct port_database_24xx *pd;
@@ -711,7 +707,7 @@ void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 		sp->u.iocb_cmd.u.mbx.in_dma);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 static int qla24xx_post_gpdb_work(struct scsi_qla_host *vha, fc_port_t *fcport,
@@ -793,7 +789,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	if (pd)
 		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	qla24xx_post_gpdb_work(vha, fcport, opt);
@@ -1171,7 +1167,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 static void
 qla2x00_tmf_iocb_timeout(void *data)
 {
-	srb_t *sp = (srb_t *)data;
+	srb_t *sp = data;
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
 
 	tmf->u.tmf.comp_status = CS_TIMEOUT;
@@ -1179,10 +1175,11 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 }
 
 static void
-qla2x00_tmf_sp_done(void *data, void *ptr, int res)
+qla2x00_tmf_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct srb_iocb *tmf = &sp->u.iocb_cmd;
+
 	complete(&tmf->u.tmf.comp);
 }
 
@@ -1240,7 +1237,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	}
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	return rval;
 }
@@ -1248,7 +1245,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 static void
 qla24xx_abort_iocb_timeout(void *data)
 {
-	srb_t *sp = (srb_t *)data;
+	srb_t *sp = data;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
 	abt->u.abt.comp_status = CS_TIMEOUT;
@@ -1256,9 +1253,9 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 }
 
 static void
-qla24xx_abort_sp_done(void *data, void *ptr, int res)
+qla24xx_abort_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
 	complete(&abt->u.abt.comp);
@@ -1267,7 +1264,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 static int
 qla24xx_async_abort_cmd(srb_t *cmd_sp)
 {
-	scsi_qla_host_t *vha = cmd_sp->fcport->vha;
+	scsi_qla_host_t *vha = cmd_sp->vha;
 	fc_port_t *fcport = cmd_sp->fcport;
 	struct srb_iocb *abt_iocb;
 	srb_t *sp;
@@ -1300,7 +1297,7 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	    QLA_SUCCESS : QLA_FUNCTION_FAILED;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 647828b..6090323 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -249,14 +249,13 @@
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
-	struct qla_hw_data *ha = vha->hw;
 	uint8_t bail;
 
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (unlikely(bail))
 		return NULL;
 
-	sp = mempool_alloc(ha->srb_mempool, flag);
+	sp = mempool_alloc(vha->hw->srb_mempool, flag);
 	if (!sp)
 		goto done;
 
@@ -267,14 +266,15 @@
 done:
 	if (!sp)
 		QLA_VHA_MARK_NOT_BUSY(vha);
+
 	return sp;
 }
 
 static inline void
-qla2x00_rel_sp(scsi_qla_host_t *vha, srb_t *sp)
+qla2x00_rel_sp(srb_t *sp)
 {
-	mempool_free(sp, vha->hw->srb_mempool);
-	QLA_VHA_MARK_NOT_BUSY(vha);
+	QLA_VHA_MARK_NOT_BUSY(sp->vha);
+	mempool_free(sp, sp->vha->hw->srb_mempool);
 }
 
 static inline void
@@ -286,8 +286,7 @@
 	sp->u.iocb_cmd.timer.function = qla2x00_sp_timeout;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
-	if ((IS_QLAFX00(((scsi_qla_host_t *)sp->vha)->hw)) &&
-	    (sp->type == SRB_FXIOCB_DCMD))
+	if (IS_QLAFX00(sp->vha->hw) && (sp->type == SRB_FXIOCB_DCMD))
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
 	if (sp->type == SRB_ELS_DCMD)
 		init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 33d3d90..5350792 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -23,7 +23,7 @@
 {
 	uint16_t cflags;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 
 	cflags = 0;
 
@@ -210,7 +210,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Three DSDs are available in the Command Type 2 IOCB */
@@ -267,7 +267,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Two DSDs are available in the Command Type 3 IOCB */
@@ -324,7 +324,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct rsp_que *rsp;
 
 	/* Setup device pointers. */
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	ha = vha->hw;
 	reg = &ha->iobase->isp;
 	cmd = GET_CMD_SP(sp);
@@ -601,7 +601,7 @@ int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 		return 0;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	ha = vha->hw;
 
 	/* Set transfer direction */
@@ -716,7 +716,7 @@ int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 		return;
 	}
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -1108,7 +1108,7 @@ struct fw_dif_context {
 	if (sp) {
 		cmd = GET_CMD_SP(sp);
 		sgl = scsi_prot_sglist(cmd);
-		vha = sp->fcport->vha;
+		vha = sp->vha;
 	} else if (tc) {
 		vha = tc->vha;
 		sgl = tc->prot_sg;
@@ -1215,7 +1215,7 @@ struct fw_dif_context {
 	/* Update entry type to indicate Command Type CRC_2 IOCB */
 	*((uint32_t *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_TYPE_CRC_2);
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	ha = vha->hw;
 
 	/* No data transfer */
@@ -1225,7 +1225,7 @@ struct fw_dif_context {
 		return QLA_SUCCESS;
 	}
 
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	cmd_pkt->vp_index = sp->vha->vp_idx;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -1415,7 +1415,7 @@ struct fw_dif_context {
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Setup device pointers. */
@@ -1492,7 +1492,7 @@ struct fw_dif_context {
 	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
 	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+	cmd_pkt->vp_index = sp->vha->vp_idx;
 
 	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
@@ -1564,7 +1564,7 @@ struct fw_dif_context {
 	struct req_que		*req = NULL;
 	struct rsp_que		*rsp = NULL;
 	struct scsi_cmnd	*cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host	*vha = sp->fcport->vha;
+	struct scsi_qla_host	*vha = sp->vha;
 	struct qla_hw_data	*ha = vha->hw;
 	struct cmd_type_crc_2	*cmd_pkt;
 	uint32_t		status = 0;
@@ -2214,13 +2214,13 @@ struct fw_dif_context {
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
 qla2x00_login_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	uint16_t opts;
 
@@ -2238,7 +2238,7 @@ struct fw_dif_context {
 	mbx->mb2 = cpu_to_le16(sp->fcport->d_id.b.domain);
 	mbx->mb3 = cpu_to_le16(sp->fcport->d_id.b.area << 8 |
 	    sp->fcport->d_id.b.al_pa);
-	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
+	mbx->mb9 = cpu_to_le16(sp->vha->vp_idx);
 }
 
 static void
@@ -2254,13 +2254,13 @@ struct fw_dif_context {
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
 qla2x00_logout_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 
 	mbx->entry_type = MBX_IOCB_TYPE;
 	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
@@ -2271,7 +2271,7 @@ struct fw_dif_context {
 	mbx->mb2 = cpu_to_le16(sp->fcport->d_id.b.domain);
 	mbx->mb3 = cpu_to_le16(sp->fcport->d_id.b.area << 8 |
 	    sp->fcport->d_id.b.al_pa);
-	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
+	mbx->mb9 = cpu_to_le16(sp->vha->vp_idx);
 	/* Implicit: mbx->mbx10 = 0. */
 }
 
@@ -2281,13 +2281,13 @@ struct fw_dif_context {
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags = cpu_to_le16(LCF_COMMAND_ADISC);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	logio->vp_index = sp->fcport->vha->vp_idx;
+	logio->vp_index = sp->vha->vp_idx;
 }
 
 static void
 qla2x00_adisc_iocb(srb_t *sp, struct mbx_entry *mbx)
 {
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	struct qla_hw_data *ha = sp->vha->hw;
 
 	mbx->entry_type = MBX_IOCB_TYPE;
 	SET_TARGET_ID(ha, mbx->loop_id, sp->fcport->loop_id);
@@ -2302,7 +2302,7 @@ struct fw_dif_context {
 	mbx->mb3 = cpu_to_le16(LSW(ha->async_pd_dma));
 	mbx->mb6 = cpu_to_le16(MSW(MSD(ha->async_pd_dma)));
 	mbx->mb7 = cpu_to_le16(LSW(MSD(ha->async_pd_dma)));
-	mbx->mb9 = cpu_to_le16(sp->fcport->vha->vp_idx);
+	mbx->mb9 = cpu_to_le16(sp->vha->vp_idx);
 }
 
 static void
@@ -2338,32 +2338,30 @@ struct fw_dif_context {
 }
 
 static void
-qla2x00_els_dcmd_sp_free(void *ptr, void *data)
+qla2x00_els_dcmd_sp_free(void *data)
 {
-	struct scsi_qla_host *vha = (scsi_qla_host_t *)ptr;
-	struct qla_hw_data *ha = vha->hw;
-	srb_t *sp = (srb_t *)data;
+	srb_t *sp = data;
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
 	kfree(sp->fcport);
 
 	if (elsio->u.els_logo.els_logo_pyld)
-		dma_free_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
+		dma_free_coherent(&sp->vha->hw->pdev->dev, DMA_POOL_SIZE,
 		    elsio->u.els_logo.els_logo_pyld,
 		    elsio->u.els_logo.els_logo_pyld_dma);
 
 	del_timer(&elsio->timer);
-	qla2x00_rel_sp(vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 static void
 qla2x00_els_dcmd_iocb_timeout(void *data)
 {
-	srb_t *sp = (srb_t *)data;
-	struct srb_iocb *lio = &sp->u.iocb_cmd;
+	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
-	struct scsi_qla_host *vha = fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct srb_iocb *lio = &sp->u.iocb_cmd;
 	unsigned long flags = 0;
 
 	ql_dbg(ql_dbg_io, vha, 0x3069,
@@ -2386,12 +2384,12 @@ struct fw_dif_context {
 }
 
 static void
-qla2x00_els_dcmd_sp_done(void *data, void *ptr, int res)
+qla2x00_els_dcmd_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	fc_port_t *fcport = sp->fcport;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	struct scsi_qla_host *vha = fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 
 	ql_dbg(ql_dbg_io, vha, 0x3072,
 	    "%s hdl=%x, portid=%02x%02x%02x done\n",
@@ -2449,7 +2447,7 @@ struct fw_dif_context {
 			    GFP_KERNEL);
 
 	if (!elsio->u.els_logo.els_logo_pyld) {
-		sp->free(vha, sp);
+		sp->free(sp);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2468,7 +2466,7 @@ struct fw_dif_context {
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		sp->free(vha, sp);
+		sp->free(sp);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2479,14 +2477,14 @@ struct fw_dif_context {
 
 	wait_for_completion(&elsio->u.els_logo.comp);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 	return rval;
 }
 
 static void
 qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
 	els_iocb->entry_type = ELS_IOCB_TYPE;
@@ -2518,7 +2516,7 @@ struct fw_dif_context {
 	els_iocb->rx_address[1] = 0;
 	els_iocb->rx_len = 0;
 
-	sp->fcport->vha->qla_stats.control_requests++;
+	sp->vha->qla_stats.control_requests++;
 }
 
 static void
@@ -2534,7 +2532,7 @@ struct fw_dif_context {
         els_iocb->handle = sp->handle;
         els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	els_iocb->tx_dsd_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
-	els_iocb->vp_index = sp->fcport->vha->vp_idx;
+	els_iocb->vp_index = sp->vha->vp_idx;
         els_iocb->sof_type = EST_SOFI3;
 	els_iocb->rx_dsd_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 
@@ -2565,7 +2563,7 @@ struct fw_dif_context {
         els_iocb->rx_len = cpu_to_le32(sg_dma_len
             (bsg_job->reply_payload.sg_list));
 
-	sp->fcport->vha->qla_stats.control_requests++;
+	sp->vha->qla_stats.control_requests++;
 }
 
 static void
@@ -2576,7 +2574,7 @@ struct fw_dif_context {
 	struct scatterlist *sg;
 	int index;
 	uint16_t tot_dsds;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
@@ -2642,7 +2640,7 @@ struct fw_dif_context {
 	}
 	ct_iocb->entry_count = entry_count;
 
-	sp->fcport->vha->qla_stats.control_requests++;
+	sp->vha->qla_stats.control_requests++;
 }
 
 static void
@@ -2653,7 +2651,7 @@ struct fw_dif_context {
 	struct scatterlist *sg;
 	int index;
 	uint16_t tot_dsds;
-        scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct bsg_job *bsg_job = sp->u.bsg_job;
 	int loop_iterartion = 0;
@@ -2665,7 +2663,7 @@ struct fw_dif_context {
         ct_iocb->handle = sp->handle;
 
 	ct_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
-	ct_iocb->vp_index = sp->fcport->vha->vp_idx;
+	ct_iocb->vp_index = sp->vha->vp_idx;
 	ct_iocb->comp_status = cpu_to_le16(0);
 
 	ct_iocb->cmd_dsd_count =
@@ -2739,7 +2737,7 @@ struct fw_dif_context {
 	uint32_t *fcp_dl;
 	uint8_t additional_cdb_len;
 	struct ct6_dsd *ctx;
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
@@ -2901,7 +2899,7 @@ struct fw_dif_context {
 		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
 		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-		cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+		cmd_pkt->vp_index = sp->vha->vp_idx;
 
 		/* Build IOCB segments */
 		if (qla24xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds))
@@ -2974,7 +2972,7 @@ struct fw_dif_context {
 		cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
 		cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 		cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
-		cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+		cmd_pkt->vp_index = sp->vha->vp_idx;
 
 		int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun,
@@ -3060,7 +3058,7 @@ struct fw_dif_context {
 qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 {
 	struct srb_iocb *aio = &sp->u.iocb_cmd;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = vha->req;
 
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
@@ -3132,7 +3130,7 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
 qla2x00_start_sp(srb_t *sp)
 {
 	int rval;
-	scsi_qla_host_t *vha = (scsi_qla_host_t *)sp->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	void *pkt;
 	unsigned long flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6959b44..a23a294 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1245,7 +1245,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		req->outstanding_cmds[index] = NULL;
 
 		/* Save ISP completion status */
-		sp->done(vha, sp, DID_OK << 16);
+		sp->done(sp, DID_OK << 16);
 	} else {
 		ql_log(ql_log_warn, vha, 0x3016, "Invalid SCSI SRB.\n");
 
@@ -1377,7 +1377,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	    le16_to_cpu(mbx->mb7));
 
 logio_done:
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 }
 
 static void
@@ -1402,7 +1402,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 	res = (si->u.mbx.in_mb[0] & MBS_MASK);
 
-	sp->done(vha, sp, res);
+	sp->done(sp, res);
 }
 
 static void
@@ -1420,7 +1420,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	if (pkt->u.isp2x.status != cpu_to_le16(NOTIFY_ACK_SUCCESS))
 		res = QLA_FUNCTION_FAILED;
 
-	sp->done(vha, sp, res);
+	sp->done(sp, res);
 }
 
 static void
@@ -1493,7 +1493,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	     break;
 	}
 
-	sp->done(vha, sp, res);
+	sp->done(sp, res);
 }
 
 static void
@@ -1529,7 +1529,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		type = "Driver ELS logo";
 		ql_dbg(ql_dbg_user, vha, 0x5047,
 		    "Completing %s: (%p) type=%d.\n", type, sp, sp->type);
-		sp->done(vha, sp, 0);
+		sp->done(sp, 0);
 		return;
 	case SRB_CT_PTHRU_CMD:
 		/* borrowing sts_entry_24xx.comp_status.
@@ -1538,7 +1538,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		res = qla2x00_chk_ms_status(vha, (ms_iocb_entry_t *)pkt,
 			(struct ct_sns_rsp *)sp->u.iocb_cmd.u.ctarg.rsp,
 			sp->name);
-		sp->done(vha, sp, res);
+		sp->done(sp, res);
 		return;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x503e,
@@ -1594,7 +1594,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		bsg_job->reply_len = 0;
 	}
 
-	sp->done(vha, sp, res);
+	sp->done(sp, res);
 }
 
 static void
@@ -1706,7 +1706,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	    le32_to_cpu(logio->io_parameter[1]));
 
 logio_done:
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 }
 
 static void
@@ -1756,7 +1756,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5055,
 		    (uint8_t *)sts, sizeof(*sts));
 
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 }
 
 /**
@@ -1844,7 +1844,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 		     uint32_t sense_len, struct rsp_que *rsp, int res)
 {
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct scsi_cmnd *cp = GET_CMD_SP(sp);
 	uint32_t track_sense_len;
 
@@ -1872,7 +1872,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x301c,
 		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
-		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
+		    sp->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302b,
 		    cp->sense_buffer, sense_len);
@@ -1894,7 +1894,7 @@ struct scsi_dif_tuple {
 static inline int
 qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 {
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	uint8_t		*ap = &sts24->data[12];
 	uint8_t		*ep = &sts24->data[20];
@@ -2159,7 +2159,7 @@ struct scsi_dif_tuple {
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
-	sp->done(vha, sp, (DID_OK << 6));
+	sp->done(sp, DID_OK << 6);
 
 }
 
@@ -2532,7 +2532,7 @@ struct scsi_dif_tuple {
 		    resid_len, fw_resid_len, sp, cp);
 
 	if (rsp->status_srb == NULL)
-		sp->done(vha, sp, res);
+		sp->done(sp, res);
 }
 
 /**
@@ -2589,7 +2589,7 @@ struct scsi_dif_tuple {
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(vha, sp, cp->result);
+		sp->done(sp, cp->result);
 	}
 }
 
@@ -2625,7 +2625,7 @@ struct scsi_dif_tuple {
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(vha, sp, res);
+		sp->done(sp, res);
 		return;
 	}
 fatal:
@@ -2683,7 +2683,7 @@ struct scsi_dif_tuple {
 
 	abt = &sp->u.iocb_cmd;
 	abt->u.abt.comp_status = le32_to_cpu(pkt->nport_handle);
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index d38bc64..945b632 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1789,16 +1789,16 @@
 static void
 qla2x00_fxdisc_iocb_timeout(void *data)
 {
-	srb_t *sp = (srb_t *)data;
+	srb_t *sp = data;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	complete(&lio->u.fxiocb.fxiocb_comp);
 }
 
 static void
-qla2x00_fxdisc_sp_done(void *data, void *ptr, int res)
+qla2x00_fxdisc_sp_done(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	complete(&lio->u.fxiocb.fxiocb_comp);
@@ -1999,7 +1999,7 @@
 		dma_free_coherent(&ha->pdev->dev, fdisc->u.fxiocb.req_len,
 		    fdisc->u.fxiocb.req_addr, fdisc->u.fxiocb.req_dma_handle);
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	return rval;
 }
@@ -2127,7 +2127,7 @@
 qlafx00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 		     uint32_t sense_len, struct rsp_que *rsp, int res)
 {
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct scsi_cmnd *cp = GET_CMD_SP(sp);
 	uint32_t track_sense_len;
 
@@ -2162,7 +2162,7 @@
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3039,
 		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
-		    sp->fcport->vha->host_no, cp->device->id, cp->device->lun,
+		    sp->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x3049,
 		    cp->sense_buffer, sense_len);
@@ -2181,7 +2181,7 @@
 	    (sstatus & cpu_to_le16((uint16_t)SS_RESPONSE_INFO_LEN_VALID)))
 		cpstatus = cpu_to_le16((uint16_t)CS_INCOMPLETE);
 	tmf->u.tmf.comp_status = cpstatus;
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 }
 
 static void
@@ -2198,7 +2198,7 @@
 
 	abt = &sp->u.iocb_cmd;
 	abt->u.abt.comp_status = pkt->tgt_id_sts;
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 }
 
 static void
@@ -2264,7 +2264,7 @@
 		bsg_reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 	}
-	sp->done(vha, sp, res);
+	sp->done(sp, res);
 }
 
 /**
@@ -2537,7 +2537,7 @@
 		    par_sense_len, rsp_info_len);
 
 	if (rsp->status_srb == NULL)
-		sp->done(vha, sp, res);
+		sp->done(sp, res);
 }
 
 /**
@@ -2614,7 +2614,7 @@
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(vha, sp, cp->result);
+		sp->done(sp, cp->result);
 	}
 }
 
@@ -2695,7 +2695,7 @@
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(vha, sp, res);
+		sp->done(sp, res);
 		return;
 	}
 
@@ -2997,7 +2997,7 @@
 	cont_a64_entry_t lcont_pkt;
 	cont_a64_entry_t *cont_pkt;
 
-	vha = sp->fcport->vha;
+	vha = sp->vha;
 	req = vha->req;
 
 	cmd = GET_CMD_SP(sp);
@@ -3081,7 +3081,7 @@
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct cmd_type_7_fx00 *cmd_pkt;
 	struct cmd_type_7_fx00 lcmd_pkt;
@@ -3205,7 +3205,7 @@
 qlafx00_tm_iocb(srb_t *sp, struct tsk_mgmt_entry_fx00 *ptm_iocb)
 {
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = vha->req;
 	struct tsk_mgmt_entry_fx00 tm_iocb;
 	struct scsi_lun llun;
@@ -3232,7 +3232,7 @@
 qlafx00_abort_iocb(srb_t *sp, struct abort_iocb_entry_fx00 *pabt_iocb)
 {
 	struct srb_iocb *fxio = &sp->u.iocb_cmd;
-	scsi_qla_host_t *vha = sp->fcport->vha;
+	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req = vha->req;
 	struct abort_iocb_entry_fx00 abt_iocb;
 
@@ -3346,8 +3346,7 @@
 					    REQUEST_ENTRY_SIZE);
 					cont_pkt =
 					    qlafx00_prep_cont_type1_iocb(
-						sp->fcport->vha->req,
-						&lcont_pkt);
+						sp->vha->req, &lcont_pkt);
 					cur_dsd = (__le32 *)
 					    lcont_pkt.dseg_0_address;
 					avail_dsds = 5;
@@ -3368,7 +3367,7 @@
 					    &lcont_pkt, REQUEST_ENTRY_SIZE);
 					ql_dump_buffer(
 					    ql_dbg_user + ql_dbg_verbose,
-					    sp->fcport->vha, 0x3042,
+					    sp->vha, 0x3042,
 					    (uint8_t *)&lcont_pkt,
 					     REQUEST_ENTRY_SIZE);
 				}
@@ -3377,7 +3376,7 @@
 				memcpy_toio((void __iomem *)cont_pkt,
 				    &lcont_pkt, REQUEST_ENTRY_SIZE);
 				ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-				    sp->fcport->vha, 0x3043,
+				    sp->vha, 0x3043,
 				    (uint8_t *)&lcont_pkt, REQUEST_ENTRY_SIZE);
 			}
 		}
@@ -3409,8 +3408,7 @@
 					    REQUEST_ENTRY_SIZE);
 					cont_pkt =
 					    qlafx00_prep_cont_type1_iocb(
-						sp->fcport->vha->req,
-						&lcont_pkt);
+						sp->vha->req, &lcont_pkt);
 					cur_dsd = (__le32 *)
 					    lcont_pkt.dseg_0_address;
 					avail_dsds = 5;
@@ -3431,7 +3429,7 @@
 					    REQUEST_ENTRY_SIZE);
 					ql_dump_buffer(
 					    ql_dbg_user + ql_dbg_verbose,
-					    sp->fcport->vha, 0x3045,
+					    sp->vha, 0x3045,
 					    (uint8_t *)&lcont_pkt,
 					    REQUEST_ENTRY_SIZE);
 				}
@@ -3440,7 +3438,7 @@
 				memcpy_toio((void __iomem *)cont_pkt,
 				    &lcont_pkt, REQUEST_ENTRY_SIZE);
 				ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-				    sp->fcport->vha, 0x3046,
+				    sp->vha, 0x3046,
 				    (uint8_t *)&lcont_pkt, REQUEST_ENTRY_SIZE);
 			}
 		}
@@ -3452,7 +3450,7 @@
 	}
 
 	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose,
-	    sp->fcport->vha, 0x3047,
+	    sp->vha, 0x3047,
 	    (uint8_t *)&fx_iocb, sizeof(struct fxdisc_entry_fx00));
 
 	memcpy_toio((void __iomem *)pfxiocb, &fx_iocb,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 008ac9a..817c594 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -613,11 +613,11 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 }
 
 void
-qla2x00_sp_free_dma(void *vha, void *ptr)
+qla2x00_sp_free_dma(void *ptr)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
+	struct qla_hw_data *ha = sp->vha->hw;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
 	void *ctx = GET_CMD_CTX_SP(sp);
 
 	if (sp->flags & SRB_DMA_VALID) {
@@ -656,20 +656,19 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	}
 
 	CMD_SP(cmd) = NULL;
-	qla2x00_rel_sp(sp->fcport->vha, sp);
+	qla2x00_rel_sp(sp);
 }
 
 void
-qla2x00_sp_compl(void *data, void *ptr, int res)
+qla2x00_sp_compl(void *ptr, int res)
 {
-	struct qla_hw_data *ha = (struct qla_hw_data *)data;
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 
 	cmd->result = res;
 
 	if (atomic_read(&sp->ref_count) == 0) {
-		ql_dbg(ql_dbg_io, sp->fcport->vha, 0x3015,
+		ql_dbg(ql_dbg_io, sp->vha, 0x3015,
 		    "SP reference-count to ZERO -- sp=%p cmd=%p.\n",
 		    sp, GET_CMD_SP(sp));
 		if (ql2xextended_error_logging & ql_dbg_io)
@@ -679,12 +678,12 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	if (!atomic_dec_and_test(&sp->ref_count))
 		return;
 
-	qla2x00_sp_free_dma(ha, sp);
+	qla2x00_sp_free_dma(sp);
 	cmd->scsi_done(cmd);
 }
 
 void
-qla2xxx_qpair_sp_free_dma(void *vha, void *ptr)
+qla2xxx_qpair_sp_free_dma(void *ptr)
 {
 	srb_t *sp = (srb_t *)ptr;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
@@ -730,9 +729,9 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 }
 
 void
-qla2xxx_qpair_sp_compl(void *data, void *ptr, int res)
+qla2xxx_qpair_sp_compl(void *ptr, int res)
 {
-	srb_t *sp = (srb_t *)ptr;
+	srb_t *sp = ptr;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 
 	cmd->result = res;
@@ -748,7 +747,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	if (!atomic_dec_and_test(&sp->ref_count))
 		return;
 
-	qla2xxx_qpair_sp_free_dma(sp->fcport->vha, sp);
+	qla2xxx_qpair_sp_free_dma(sp);
 	cmd->scsi_done(cmd);
 }
 
@@ -869,7 +868,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	return 0;
 
 qc24_host_busy_free_sp:
-	qla2x00_sp_free_dma(ha, sp);
+	qla2x00_sp_free_dma(sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -958,7 +957,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	return 0;
 
 qc24_host_busy_free_sp:
-	qla2xxx_qpair_sp_free_dma(vha, sp);
+	qla2xxx_qpair_sp_free_dma(sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1238,7 +1237,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	sp->done(vha, sp, 0);
+	sp->done(sp, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Did the command return during mailbox execution? */
@@ -1283,7 +1282,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 			continue;
 		if (sp->type != SRB_SCSI_CMD)
 			continue;
-		if (vha->vp_idx != sp->fcport->vha->vp_idx)
+		if (vha->vp_idx != sp->vha->vp_idx)
 			continue;
 		match = 0;
 		cmd = GET_CMD_SP(sp);
@@ -1663,7 +1662,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 				}
 				req->outstanding_cmds[cnt] = NULL;
-				sp->done(vha, sp, res);
+				sp->done(sp, res);
 			}
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8c16756..f79cda6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -535,10 +535,10 @@ static int qla24xx_post_nack_work(struct scsi_qla_host *vha, fc_port_t *fcport,
 }
 
 static
-void qla2x00_async_nack_sp_done(void *v, void *s, int res)
+void qla2x00_async_nack_sp_done(void *s, int res)
 {
-	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
 	struct srb *sp = (struct srb *)s;
+	struct scsi_qla_host *vha = sp->vha;
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
@@ -595,7 +595,7 @@ void qla2x00_async_nack_sp_done(void *v, void *s, int res)
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(vha, sp);
+	sp->free(sp);
 }
 
 int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
@@ -645,7 +645,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	sp->free(vha, sp);
+	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
-- 
1.8.3.1
