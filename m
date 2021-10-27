Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE987C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F86610A3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241492AbhJ0KCv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:51 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241520AbhJ0KCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 06:02:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I99L032380
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=iUYj1bVZ/G6NkbKHFH/Rya9slwZKu6AFTae5xW6PgCs=;
 b=B+j5vyVKrfhkL4CZvB9J03OoYTjVViZsIgwklP5n/Tk91b8sciYWUjdrlYgzIyFyk1RL
 gI3sq4nk7Uuq8m/DPtd4fgasDqqVBWySlyAq+ZAWR01T4ONJcInz/zcP2wISfgnci/9L
 BQyyeARZiT2+dwKGWRi4nMHnsq+Rr005GvW1JKnKOmlijWG+HP3+wmHaQ9bwzL1KRR34
 3ufRdZYAqYB4X1N3nAnWwl+KBjfJWRYTei0ebtzd7jl3n66wfcd42GCRNziSOiSQOoQ4
 hOF5X8AZpZ15daHO1hQeA2LhrNoJrf95tg58tGc5nIEDcwJkLvOluViXMOjR2lmtoNRm NA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8tjs-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:59:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 02:59:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3E8DD3F7093;
        Wed, 27 Oct 2021 02:59:41 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19R9xfnN016441;
        Wed, 27 Oct 2021 02:59:41 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19R9xfNP016440;
        Wed, 27 Oct 2021 02:59:41 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 11/13] qla2xxx: edif: fix inconsistent check of db_flags
Date:   Wed, 27 Oct 2021 02:58:49 -0700
Message-ID: <20211027095851.16362-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211027095851.16362-1-njavali@marvell.com>
References: <20211027095851.16362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 5gVjP_7emcmXkPsj8hkmKQXM78oncZWJ
X-Proofpoint-ORIG-GUID: 5gVjP_7emcmXkPsj8hkmKQXM78oncZWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

db_flags field is a bit field. Replace value check with bit flag check.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c   | 26 +++++++++++++-------------
 drivers/scsi/qla2xxx/qla_edif.h   |  7 +++++--
 drivers/scsi/qla2xxx/qla_init.c   | 13 ++++++-------
 drivers/scsi/qla2xxx/qla_iocb.c   |  3 +--
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 5 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 3d84543a95d3..74a1656e696d 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -218,7 +218,7 @@ fc_port_t *fcport)
 		    "%s edif not enabled\n", __func__);
 		goto done;
 	}
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
 		goto done;
@@ -482,9 +482,9 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app_vid=%x app_start_flags %x\n",
 	     __func__, appstart.app_info.app_vid, appstart.app_start_flags);
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* mark doorbell as active since an app is now present */
-		vha->e_dbell.db_flags = EDB_ACTIVE;
+		vha->e_dbell.db_flags |= EDB_ACTIVE;
 	} else {
 		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
 		     __func__);
@@ -1269,7 +1269,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		goto done;
 	}
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_log(ql_log_warn, vha, 0x70a1, "App not started\n");
 		rval = -EIO;
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
@@ -1772,7 +1772,7 @@ qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
 void
 qla_edb_init(scsi_qla_host_t *vha)
 {
-	if (vha->e_dbell.db_flags == EDB_ACTIVE) {
+	if (DBELL_ACTIVE(vha)) {
 		/* list already init'd - error */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "edif db already initialized, cannot reinit\n");
@@ -1815,7 +1815,7 @@ static void qla_edb_clear(scsi_qla_host_t *vha, port_id_t portid)
 	port_id_t sid;
 	LIST_HEAD(edb_list);
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		       "%s doorbell not enabled\n", __func__);
@@ -1867,7 +1867,7 @@ qla_edb_stop(scsi_qla_host_t *vha)
 	unsigned long flags;
 	struct edb_node *node, *q;
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
@@ -1918,7 +1918,7 @@ qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
 {
 	unsigned long		flags;
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
@@ -1949,7 +1949,7 @@ qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
 		return;
 	}
 
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		if (fcport)
 			fcport->edif.auth_state = dbtype;
 		/* doorbell list not enabled */
@@ -2044,7 +2044,7 @@ qla_edif_timer(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!vha->vp_idx && N2N_TOPO(ha) && ha->flags.n2n_fw_acc_sec) {
-		if (vha->e_dbell.db_flags != EDB_ACTIVE &&
+		if (DBELL_INACTIVE(vha) &&
 		    ha->edif_post_stop_cnt_down) {
 			ha->edif_post_stop_cnt_down--;
 
@@ -2082,7 +2082,7 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 	sz = 256;
 
 	/* stop new threads from waiting if we're not init'd */
-	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+	if (DBELL_INACTIVE(vha)) {
 		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
 		    "%s error - edif db not enabled\n", __func__);
 		return 0;
@@ -2430,7 +2430,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 
 	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
 
-	if (host->e_dbell.db_flags != EDB_ACTIVE ||
+	if (DBELL_INACTIVE(vha) ||
 	    (fcport && EDIF_SESSION_DOWN(fcport))) {
 		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
 		    __func__, host->e_dbell.db_flags,
@@ -3456,7 +3456,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 {
-	if (sess->edif.app_sess_online && vha->e_dbell.db_flags & EDB_ACTIVE) {
+	if (sess->edif.app_sess_online && DBELL_ACTIVE(vha)) {
 		ql_dbg(ql_dbg_disc, vha, 0xf09c,
 			"%s: sess %8phN send port_offline event\n",
 			__func__, sess->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 2517005fb08c..a965ca8e47ce 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -41,9 +41,12 @@ struct pur_core {
 };
 
 enum db_flags_t {
-	EDB_ACTIVE = 0x1,
+	EDB_ACTIVE = BIT_0,
 };
 
+#define DBELL_ACTIVE(_v) (_v->e_dbell.db_flags & EDB_ACTIVE)
+#define DBELL_INACTIVE(_v) (!(_v->e_dbell.db_flags & EDB_ACTIVE))
+
 struct edif_dbell {
 	enum db_flags_t		db_flags;
 	spinlock_t		db_lock;
@@ -134,7 +137,7 @@ struct enode {
 	 !_s->edif.app_sess_online))
 
 #define EDIF_NEGOTIATION_PENDING(_fcport) \
-	((_fcport->vha.e_dbell.db_flags & EDB_ACTIVE) && \
+	(DBELL_ACTIVE(_fcport->vha) && \
 	 (_fcport->disc_state == DSC_LOGIN_AUTH_PEND))
 
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2bc5593645ec..c0b813fc1ec4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -330,7 +330,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
 	} else {
 		if (vha->hw->flags.edif_enabled &&
-		    vha->e_dbell.db_flags & EDB_ACTIVE) {
+		    DBELL_ACTIVE(vha)) {
 			lio->u.logio.flags |=
 				(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
 		} else {
@@ -861,7 +861,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				break;
 			case DSC_LS_PLOGI_COMP:
 				if (vha->hw->flags.edif_enabled &&
-				    vha->e_dbell.db_flags & EDB_ACTIVE) {
+				    DBELL_ACTIVE(vha)) {
 					/* check to see if App support secure or not */
 					qla24xx_post_gpdb_work(vha, fcport, 0);
 					break;
@@ -1451,7 +1451,7 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
 			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
 			    fcport->d_id.b24);
 
-			if (vha->e_dbell.db_flags ==  EDB_ACTIVE) {
+			if (DBELL_ACTIVE(vha)) {
 				ql_dbg(ql_dbg_disc, vha, 0x20ef,
 				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
 				    __func__, __LINE__, fcport->port_name);
@@ -1794,7 +1794,7 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 				return;
 			}
 
-			if (vha->hw->flags.edif_enabled && vha->e_dbell.db_flags & EDB_ACTIVE) {
+			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
 				/*
 				 * On ipsec start by remote port, Target port
 				 * may use RSCN to trigger initiator to
@@ -4240,7 +4240,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 		 * fw shal not send PRLI after PLOGI Acc
 		 */
 		if (ha->flags.edif_enabled &&
-		    vha->e_dbell.db_flags & EDB_ACTIVE) {
+		    DBELL_ACTIVE(vha)) {
 			ha->fw_options[3] |= BIT_15;
 			ha->flags.n2n_fw_acc_sec = 1;
 		} else {
@@ -5396,8 +5396,7 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			 * use link up to wake up app to get ready for
 			 * authentication.
 			 */
-			if (ha->flags.edif_enabled &&
-			    !(vha->e_dbell.db_flags & EDB_ACTIVE))
+			if (ha->flags.edif_enabled && DBELL_INACTIVE(vha))
 				qla2x00_post_aen_work(vha, FCH_EVT_LINKUP,
 						      ha->link_data_rate);
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9d4ad1d2b00a..ed604f2185bf 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3034,8 +3034,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	elsio->u.els_plogi.els_cmd = els_opcode;
 	elsio->u.els_plogi.els_plogi_pyld->opcode = els_opcode;
 
-	if (els_opcode == ELS_DCMD_PLOGI && vha->hw->flags.edif_enabled &&
-	    vha->e_dbell.db_flags & EDB_ACTIVE) {
+	if (els_opcode == ELS_DCMD_PLOGI && DBELL_ACTIVE(vha)) {
 		struct fc_els_flogi *p = ptr;
 
 		p->fl_csp.sp_features |= cpu_to_be16(FC_SP_FT_SEC);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index edc34e69d75b..031233729ff4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4817,7 +4817,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 	}
 
 	if (vha->hw->flags.edif_enabled) {
-		if (!(vha->e_dbell.db_flags & EDB_ACTIVE)) {
+		if (DBELL_INACTIVE(vha)) {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
 			       "%s %d Term INOT due to app not started lid=%d, NportID %06X ",
 			       __func__, __LINE__, loop_id, port_id.b24);
-- 
2.19.0.rc0

