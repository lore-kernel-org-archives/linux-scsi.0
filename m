From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 01/43] qla2xxx: Fix stale memory access for name pointer
Date: Tue, 19 Dec 2017 22:56:02 -0800
Message-ID: <20171220065644.21511-2-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0050.outbound.protection.outlook.com ([104.47.40.50]:2481
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932295AbdLTG4x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:56:53 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Name pointer for sp describing each command is assigned with stack
frame's memory. The stack frame could eventually be re-use, where
name pointer access can get get garbage. This patch designates
static memory for name pointer to fix this problem.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c    |  7 +++---
 drivers/scsi/qla2xxx/qla_def.h    | 36 +++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     | 51 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_init.c   | 16 ++++++------
 drivers/scsi/qla2xxx/qla_iocb.c   |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c    |  5 ++--
 drivers/scsi/qla2xxx/qla_mr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  4 +--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 10 files changed, 105 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e3ac7078d2aa..3fc3ae9abb39 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -376,7 +376,8 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		 SRB_ELS_CMD_RPT : SRB_ELS_CMD_HST);
 	sp->name =
 		(bsg_request->msgcode == FC_BSG_RPT_ELS ?
-		 "bsg_els_rpt" : "bsg_els_hst");
+		 sp_to_str(SPCN_BSG_RPT) : sp_to_str(SPCN_BSG_HST));
+
 	sp->u.bsg_job = bsg_job;
 	sp->free = qla2x00_bsg_sp_free;
 	sp->done = qla2x00_bsg_job_done;
@@ -522,7 +523,7 @@ qla2x00_process_ct(struct bsg_job *bsg_job)
 	}
 
 	sp->type = SRB_CT_CMD;
-	sp->name = "bsg_ct";
+	sp->name = sp_to_str(SPCN_BSG_CT);
 	sp->iocbs = qla24xx_calc_ct_iocbs(req_sg_cnt + rsp_sg_cnt);
 	sp->u.bsg_job = bsg_job;
 	sp->free = qla2x00_bsg_sp_free;
@@ -2028,7 +2029,7 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
 	fcport->loop_id = piocb_rqst->dataword;
 
 	sp->type = SRB_FXIOCB_BCMD;
-	sp->name = "bsg_fx_mgmt";
+	sp->name = sp_to_str(SPCN_BSG_FX_MGMT);
 	sp->iocbs = qla24xx_calc_ct_iocbs(req_sg_cnt + rsp_sg_cnt);
 	sp->u.bsg_job = bsg_job;
 	sp->free = qla2x00_bsg_sp_free;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 93ff92e2363f..4d65fd973a12 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -478,6 +478,42 @@ struct srb_iocb {
 	void (*timeout)(void *);
 };
 
+enum {
+	SPCN_UNKNOWN,
+	SPCN_GIDPN,
+	SPCN_GPSC,
+	SPCN_GPNID,
+	SPCN_GPNFT,
+	SPCN_GNNID,
+	SPCN_GFPNID,
+	SPCN_LOGIN,
+	SPCN_LOGOUT,
+	SPCN_ADISC,
+	SPCN_GNLIST,
+	SPCN_GPDB,
+	SPCN_TMF,
+	SPCN_ABORT,
+	SPCN_NACK,
+	SPCN_BSG_RPT,
+	SPCN_BSG_HST,
+	SPCN_BSG_CT,
+	SPCN_BSG_FX_MGMT,
+	SPCN_ELS_DCMD,
+	SPCN_FXDISC,
+	SPCN_GIDLIST,
+	SPCN_STATS,
+	SPCN_MB_GPDB,
+	SPCN_GFFID,
+	SPCN_PRLI,
+	SPCN_NVME_LS,
+	SPCN_NVME_CMD,
+};
+
+struct sp_name {
+	uint16_t cmd;
+	const char *str;
+};
+
 /* Values for srb_ctx type */
 #define SRB_LOGIN_CMD	1
 #define SRB_LOGOUT_CMD	2
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fa115c7433e5..bf907386f177 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -647,6 +647,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
 int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
 void qla24xx_handle_gffid_event(scsi_qla_host_t *vha, struct event_arg *ea);
 int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport);
+const char *sp_to_str(uint16_t);
 /*
  * Global Function Prototypes in qla_attr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 07fe17a986b0..7e88e8289157 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -15,6 +15,49 @@ static int qla2x00_sns_gnn_id(scsi_qla_host_t *, sw_info_t *);
 static int qla2x00_sns_rft_id(scsi_qla_host_t *);
 static int qla2x00_sns_rnn_id(scsi_qla_host_t *);
 
+struct sp_name sp_str[] = {
+	{ SPCN_UNKNOWN, "unknown" },
+	{ SPCN_GIDPN, "gidpn" },
+	{ SPCN_GPSC, "gpsc" },
+	{ SPCN_GPNID, "gpnid" },
+	{ SPCN_GPNFT, "gpnft" },
+	{ SPCN_GNNID, "gnnid" },
+	{ SPCN_GFPNID, "gfpnid" },
+	{ SPCN_GFFID, "gffid" },
+	{ SPCN_LOGIN, "login" },
+	{ SPCN_LOGOUT, "logout" },
+	{ SPCN_ADISC, "adisc" },
+	{ SPCN_GNLIST, "gnlist" },
+	{ SPCN_GPDB, "gpdb" },
+	{ SPCN_TMF, "tmf" },
+	{ SPCN_ABORT, "abort" },
+	{ SPCN_NACK, "nack" },
+	{ SPCN_BSG_RPT, "bsg_els_rpt" },
+	{ SPCN_BSG_HST, "bsg_els_hst" },
+	{ SPCN_BSG_CT, "bsg_ct" },
+	{ SPCN_BSG_FX_MGMT, "bsg_fx_mgmt" },
+	{ SPCN_ELS_DCMD, "ELS_DCMD" },
+	{ SPCN_FXDISC, "fxdisc" },
+	{ SPCN_PRLI, "prli" },
+	{ SPCN_NVME_LS, "nvme_ls" },
+	{ SPCN_NVME_CMD, "nvme_cmd" },
+};
+
+const char *sp_to_str(uint16_t cmd)
+{
+	int i;
+	struct sp_name *e;
+
+	for (i = 1; i < ARRAY_SIZE(sp_str); i++) {
+		e = sp_str + i;
+		if (cmd == e->cmd)
+			return e->str;
+	}
+
+	return sp_str[0].str;
+}
+
+
 /**
  * qla2x00_prep_ms_iocb() - Prepare common MS/CT IOCB fields for SNS CT query.
  * @ha: HA context
@@ -2931,7 +2974,7 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 		goto done;
 
 	sp->type = SRB_CT_PTHRU_CMD;
-	sp->name = "gidpn";
+	sp->name = sp_to_str(SPCN_GIDPN);
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
@@ -3091,7 +3134,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 		goto done;
 
 	sp->type = SRB_CT_PTHRU_CMD;
-	sp->name = "gpsc";
+	sp->name = sp_to_str(SPCN_GPSC);
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
@@ -3398,7 +3441,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 		goto done;
 
 	sp->type = SRB_CT_PTHRU_CMD;
-	sp->name = "gpnid";
+	sp->name = sp_to_str(SPCN_GPNID);
 	sp->u.iocb_cmd.u.ctarg.id = *id;
 	sp->gen1 = 0;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
@@ -3550,7 +3593,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_CT_PTHRU_CMD;
-	sp->name = "gffid";
+	sp->name = sp_to_str(SPCN_GFFID);
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 58663df38627..7fa71170d6ff 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -186,7 +186,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	fcport->logout_completed = 0;
 
 	sp->type = SRB_LOGIN_CMD;
-	sp->name = "login";
+	sp->name = sp_to_str(SPCN_LOGIN);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
@@ -248,7 +248,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 		goto done;
 
 	sp->type = SRB_LOGOUT_CMD;
-	sp->name = "logout";
+	sp->name = sp_to_str(SPCN_LOGOUT);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
@@ -300,7 +300,7 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 		goto done;
 
 	sp->type = SRB_ADISC_CMD;
-	sp->name = "adisc";
+	sp->name = sp_to_str(SPCN_ADISC);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
@@ -583,7 +583,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (!sp)
 		goto done;
 	sp->type = SRB_MB_IOCB;
-	sp->name = "gnlist";
+	sp->name = sp_to_str(SPCN_GNLIST);
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
@@ -741,7 +741,7 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	fcport->logout_completed = 0;
 
 	sp->type = SRB_PRLI_CMD;
-	sp->name = "prli";
+	sp->name = sp_to_str(SPCN_PRLI);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
@@ -807,7 +807,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 		goto done;
 
 	sp->type = SRB_MB_IOCB;
-	sp->name = "gpdb";
+	sp->name = sp_to_str(SPCN_GPDB);
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
@@ -1298,7 +1298,7 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 
 	tm_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_TM_CMD;
-	sp->name = "tmf";
+	sp->name = sp_to_str(SPCN_TMF);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
 	tm_iocb->u.tmf.flags = flags;
 	tm_iocb->u.tmf.lun = lun;
@@ -1376,7 +1376,7 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp)
 
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
-	sp->name = "abort";
+	sp->name = sp_to_str(SPCN_ABORT);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
 	sp->done = qla24xx_abort_sp_done;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8ea59586f4f1..b5d1423f933d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2454,7 +2454,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	sp->type = SRB_ELS_DCMD;
-	sp->name = "ELS_DCMD";
+	sp->name = sp_to_str(SPCN_ELS_DCMD);
 	sp->fcport = fcport;
 	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	elsio->timeout = qla2x00_els_dcmd_iocb_timeout;
@@ -2652,7 +2652,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
 
 	sp->type = SRB_ELS_DCMD;
-	sp->name = "ELS_DCMD";
+	sp->name = sp_to_str(SPCN_ELS_DCMD);
 	sp->fcport = fcport;
 	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e2b5fa47bb57..f5cbdaeaea1f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -14,6 +14,7 @@ static struct mb_cmd_name {
 	uint16_t cmd;
 	const char *str;
 } mb_str[] = {
+	{0, "unknown mb"},
 	{MBC_GET_PORT_DATABASE,		"GPDB"},
 	{MBC_GET_ID_LIST,		"GIDList"},
 	{MBC_GET_LINK_PRIV_STATS,	"Stats"},
@@ -24,12 +25,12 @@ static const char *mb_to_str(uint16_t cmd)
 	int i;
 	struct mb_cmd_name *e;
 
-	for (i = 0; i < ARRAY_SIZE(mb_str); i++) {
+	for (i = 1; i < ARRAY_SIZE(mb_str); i++) {
 		e = mb_str + i;
 		if (cmd == e->cmd)
 			return e->str;
 	}
-	return "unknown";
+	return mb_str[0].str;
 }
 
 static struct rom_cmd {
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index d5da3981cefe..9184f6016fe0 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1820,7 +1820,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		goto done;
 
 	sp->type = SRB_FXIOCB_DCMD;
-	sp->name = "fxdisc";
+	sp->name = sp_to_str(SPCN_FXDISC);
 	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
 
 	fdisc = &sp->u.iocb_cmd;
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 6b33a1f24f56..d398d45f937f 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -239,7 +239,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 		return rval;
 
 	sp->type = SRB_NVME_LS;
-	sp->name = "nvme_ls";
+	sp->name = sp_to_str(SPCN_NVME_LS);
 	sp->done = qla_nvme_sp_ls_done;
 	atomic_set(&sp->ref_count, 1);
 	nvme = &sp->u.iocb_cmd;
@@ -526,7 +526,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	init_waitqueue_head(&sp->nvme_ls_waitq);
 	priv->sp = sp;
 	sp->type = SRB_NVME_CMD;
-	sp->name = "nvme_cmd";
+	sp->name = sp_to_str(SPCN_NVME_CMD);
 	sp->done = qla_nvme_sp_done;
 	sp->qpair = qpair;
 	nvme = &sp->u.iocb_cmd;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 067bcc57a9ad..fcfdbe1420cd 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -661,7 +661,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 		goto done;
 
 	sp->type = type;
-	sp->name = "nack";
+	sp->name = sp_to_str(SPCN_NACK);
 
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
 
-- 
2.12.0
