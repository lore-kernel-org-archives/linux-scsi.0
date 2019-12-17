Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64586C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2006920716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ad/4Ekko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLQWIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:08:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60162 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfLQWIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:08:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5aBo029957;
        Tue, 17 Dec 2019 14:07:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=VcgqejubJ5B4IjCeDSoxY61sjNik10nsrANi6cTCYUM=;
 b=Ad/4Ekkoc1gwK048WS1WMEfDq58KFtaB1JgVnsMdxrKQ8ZM1M2wiMVTeWDuuMYcCHJWD
 MJmfvfwsnCV6wjsi6hJDHG5UUHWLo0MC7FlDIIIB6dFlDbcdKBNtnMEufmnusknYyMOY
 6crfCu2QcqU8JgUZQCUO8lAsbo8Ovf58/6DVTz1N/9idZAALammOUV1+9bCpPLjL+WrE
 5wX8D//d4wytjaNhYwbzHjkjcee57hY308qdvbX6YVOq6J2qKCOQjn9gW/4O7OV1dOhz
 a/9yvDiSOVPDaAvMQMXC/OyQ4mPmnN2tItJ/CNYjj+TzsWBJMLvBGWLtNRKutz9RkXrd 3g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22h-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:08 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:27 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:27 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A7CF93F703F;
        Tue, 17 Dec 2019 14:06:27 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6RmS028131;
        Tue, 17 Dec 2019 14:06:27 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6Rrx028130;
        Tue, 17 Dec 2019 14:06:27 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 03/14] qla2xxx: Add a shadow variable to hold disc_state history of fcport
Date:   Tue, 17 Dec 2019 14:06:06 -0800
Message-ID: <20191217220617.28084-4-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

This patch adds a shadow variable to hold disc_state history for the
fcport and prints state transition when the logging is enabled.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |  2 +-
 drivers/scsi/qla2xxx/qla_def.h    | 14 ++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     |  2 +-
 drivers/scsi/qla2xxx/qla_init.c   | 29 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_inline.h | 24 ++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   |  7 ++++---
 drivers/scsi/qla2xxx/qla_os.c     |  2 +-
 drivers/scsi/qla2xxx/qla_target.c | 11 ++++++-----
 9 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 30afc59c1870..e5500bba06ca 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -18,7 +18,7 @@
  * | Device Discovery             |       0x2134       | 0x210e-0x2116  |
  * |				  | 		       | 0x211a         |
  * |                              |                    | 0x211c-0x2128  |
- * |                              |                    | 0x212a-0x2130  |
+ * |                              |                    | 0x212a-0x2134  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
  * |                              |                    | 0x3027-0x3028  |
  * |                              |                    | 0x303d-0x3041  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2edd9f7b3074..81362517b404 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2464,6 +2464,7 @@ typedef struct fc_port {
 	struct qla_tgt_sess *tgt_session;
 	struct ct_sns_desc ct_desc;
 	enum discovery_state disc_state;
+	atomic_t shadow_disc_state;
 	enum discovery_state next_disc_state;
 	enum login_state fw_login_state;
 	unsigned long dm_login_expire;
@@ -2510,6 +2511,19 @@ struct event_arg {
 
 extern const char *const port_state_str[5];
 
+static const char * const port_dstate_str[] = {
+	"DELETED",
+	"GNN_ID",
+	"GNL",
+	"LOGIN_PEND",
+	"LOGIN_FAILED",
+	"GPDB",
+	"UPD_FCPORT",
+	"LOGIN_COMPLETE",
+	"ADISC",
+	"DELETE_PEND"
+};
+
 /*
  * FC port flags.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0678d18144e3..5098bb96aa2c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -80,6 +80,7 @@ extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
 int qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e);
 extern void *qla2x00_alloc_iocbs_ready(struct qla_qpair *, srb_t *);
 extern int qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *, fc_port_t *);
+extern int qla24xx_async_abort_cmd(srb_t *, bool);
 
 extern void qla2x00_set_fcport_state(fc_port_t *fcport, int state);
 extern fc_port_t *
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 446a9d6ba255..f11fb00bfc43 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -4290,7 +4290,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
-	fcport->disc_state = DSC_GNN_ID;
+	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0758b1cefffe..73de5ada9bc9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -316,10 +316,10 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (!sp)
 		goto done;
 
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
 	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->logout_completed = 0;
 
-	fcport->disc_state = DSC_LOGIN_PEND;
 	sp->type = SRB_LOGIN_CMD;
 	sp->name = "login";
 	sp->gen1 = fcport->rscn_gen;
@@ -523,7 +523,7 @@ static int qla_post_els_plogi_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	e->u.fcport.fcport = fcport;
 	fcport->flags |= FCF_ASYNC_ACTIVE;
-	fcport->disc_state = DSC_LOGIN_PEND;
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
 	return qla2x00_post_work(vha, e);
 }
 
@@ -826,7 +826,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				 * with GNL. Push disc_state back to DELETED
 				 * so GNL can go out again
 				 */
-				fcport->disc_state = DSC_DELETED;
+				qla2x00_set_fcport_disc_state(fcport,
+				    DSC_DELETED);
 				break;
 			case DSC_LS_PRLI_COMP:
 				if ((e->prli_svc_param_word_3[0] & BIT_4) == 0)
@@ -902,7 +903,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			qla24xx_fcport_handle_login(vha, fcport);
 			break;
 		case ISP_CFG_N:
-			fcport->disc_state = DSC_DELETED;
+			qla2x00_set_fcport_disc_state(fcport, DSC_DELETED);
 			if (time_after_eq(jiffies, fcport->dm_login_expire)) {
 				if (fcport->n2n_link_reset_cnt < 2) {
 					fcport->n2n_link_reset_cnt++;
@@ -1062,7 +1063,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	fcport->flags |= FCF_ASYNC_SENT;
-	fcport->disc_state = DSC_GNL;
+	qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 	fcport->last_rscn_gen = fcport->rscn_gen;
 	fcport->last_login_gen = fcport->login_gen;
 
@@ -1285,12 +1286,12 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 		return rval;
 	}
 
-	fcport->disc_state = DSC_GPDB;
-
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
 
+	qla2x00_set_fcport_disc_state(fcport, DSC_GPDB);
+
 	fcport->flags |= FCF_ASYNC_SENT;
 	sp->type = SRB_MB_IOCB;
 	sp->name = "gpdb";
@@ -1369,7 +1370,7 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x20d6,
 		    "%s %d %8phC session revalidate success\n",
 		    __func__, __LINE__, ea->fcport->port_name);
-		ea->fcport->disc_state = DSC_LOGIN_COMPLETE;
+		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_COMPLETE);
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
@@ -1423,7 +1424,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		/* Set discovery state back to GNL to Relogin attempt */
 		if (qla_dual_mode_enabled(vha) ||
 		    qla_ini_mode_enabled(vha)) {
-			fcport->disc_state = DSC_GNL;
+			qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		}
 		return;
@@ -2000,7 +2001,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		    __func__, __LINE__, ea->fcport->port_name, ea->data[1]);
 
 		ea->fcport->flags &= ~FCF_ASYNC_SENT;
-		ea->fcport->disc_state = DSC_LOGIN_FAILED;
+		qla2x00_set_fcport_disc_state(ea->fcport, DSC_LOGIN_FAILED);
 		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		else
@@ -5389,7 +5390,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	ql_dbg(ql_dbg_disc, vha, 0x20ef, "%s %8phC\n",
 	    __func__, fcport->port_name);
 
-	fcport->disc_state = DSC_UPD_FCPORT;
+	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 	fcport->deleted = 0;
@@ -5409,7 +5410,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	if (NVME_TARGET(vha->hw, fcport)) {
 		qla_nvme_register_remote(vha, fcport);
-		fcport->disc_state = DSC_LOGIN_COMPLETE;
+		qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
 		qla2x00_set_fcport_state(fcport, FCS_ONLINE);
 		return;
 	}
@@ -5454,7 +5455,7 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 		}
 	}
 
-	fcport->disc_state = DSC_LOGIN_COMPLETE;
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
 }
 
 void qla_register_fcport_fn(struct work_struct *work)
@@ -5863,7 +5864,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 
 		if (NVME_TARGET(vha->hw, fcport)) {
 			if (fcport->disc_state == DSC_DELETE_PEND) {
-				fcport->disc_state = DSC_GNL;
+				qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 				vha->fcport_count--;
 				fcport->login_succ = 0;
 			}
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 352aba4127f7..364b3db8b2dc 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -105,6 +105,30 @@ qla2x00_clean_dsd_pool(struct qla_hw_data *ha, struct crc_context *ctx)
 	INIT_LIST_HEAD(&ctx->dsd_list);
 }
 
+static inline void
+qla2x00_set_fcport_disc_state(fc_port_t *fcport, int state)
+{
+	int old_val;
+	uint8_t shiftbits, mask;
+
+	/* This will have to change when the max no. of states > 16 */
+	shiftbits = 4;
+	mask = (1 << shiftbits) - 1;
+
+	fcport->disc_state = state;
+	while (1) {
+		old_val = atomic_read(&fcport->shadow_disc_state);
+		if (old_val == atomic_cmpxchg(&fcport->shadow_disc_state,
+		    old_val, (old_val << shiftbits) | state)) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
+			    "FCPort %8phC disc_state transition: %s to %s - portid=%06x.\n",
+			    fcport->port_name, port_dstate_str[old_val & mask],
+			    port_dstate_str[state], fcport->d_id.b24);
+			return;
+		}
+	}
+}
+
 static inline int
 qla2x00_hba_err_chk_enabled(srb_t *sp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 15c76b9a4502..3ee080a2564c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2877,7 +2877,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 				    fw_status[0], fw_status[1], fw_status[2]);
 
 				fcport->flags &= ~FCF_ASYNC_SENT;
-				fcport->disc_state = DSC_LOGIN_FAILED;
+				qla2x00_set_fcport_disc_state(fcport,
+				    DSC_LOGIN_FAILED);
 				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 				break;
 			}
@@ -2890,7 +2891,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			    fw_status[0], fw_status[1], fw_status[2]);
 
 			sp->fcport->flags &= ~FCF_ASYNC_SENT;
-			sp->fcport->disc_state = DSC_LOGIN_FAILED;
+			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_FAILED);
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			break;
 		}
@@ -2927,7 +2928,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 	fcport->flags |= FCF_ASYNC_SENT;
-	fcport->disc_state = DSC_LOGIN_PEND;
+	qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND);
 	elsio = &sp->u.iocb_cmd;
 	ql_dbg(ql_dbg_io, vha, 0x3073,
 	    "Enter: PLOGI portid=%06x\n", fcport->d_id.b24);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 936036375f73..6b6fabed99e2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5009,7 +5009,7 @@ void qla24xx_sched_upd_fcport(fc_port_t *fcport)
 	fcport->jiffies_at_registration = jiffies;
 	fcport->sec_since_registration = 0;
 	fcport->next_disc_state = DSC_DELETED;
-	fcport->disc_state = DSC_UPD_FCPORT;
+	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	spin_unlock_irqrestore(&fcport->vha->work_lock, flags);
 
 	queue_work(system_unbound_wq, &fcport->reg_work);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a43f7c9463c8..fecc2b2aabf9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -596,7 +596,8 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 		} else {
 			sp->fcport->login_retry = 0;
-			sp->fcport->disc_state = DSC_LOGIN_COMPLETE;
+			qla2x00_set_fcport_disc_state(sp->fcport,
+			    DSC_LOGIN_COMPLETE);
 			sp->fcport->deleted = 0;
 			sp->fcport->logout_on_delete = 1;
 		}
@@ -1052,7 +1053,7 @@ void qlt_free_session_done(struct work_struct *work)
 			tgt->sess_count--;
 	}
 
-	sess->disc_state = DSC_DELETED;
+	qla2x00_set_fcport_disc_state(sess, DSC_DELETED);
 	sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
 	sess->deleted = QLA_SESS_DELETED;
 
@@ -1157,7 +1158,7 @@ void qlt_unreg_sess(struct fc_port *sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-	sess->disc_state = DSC_DELETE_PEND;
+	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
 
@@ -1257,7 +1258,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
-	sess->disc_state = DSC_DELETE_PEND;
+	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 
 	qla24xx_chk_fcp_state(sess);
 
@@ -6053,7 +6054,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		if (!IS_SW_RESV_ADDR(fcport->d_id))
 		   vha->fcport_count++;
 		fcport->login_gen++;
-		fcport->disc_state = DSC_LOGIN_COMPLETE;
+		qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_COMPLETE);
 		fcport->login_succ = 1;
 		newfcport = 1;
 	}
-- 
2.12.0

