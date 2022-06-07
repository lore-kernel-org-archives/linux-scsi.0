Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B92C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbiFGEqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiFGEqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:45 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE348D02A1
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXafp025411
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=AYsV+nZS+AH8S9uEuR/TylAhKXzRyfO6Z76qnKMGPI0=;
 b=g91+FX74Q07qeuyhPoJkF5LhTfnxl7dgyK2AMvV2gV7XEVYXJS1n+Wqtt8CybSsQIsAL
 1+V7oRPUhJ7PZ4FxdKCEKOJ3Rbxn7J8bFwIZecswmbx3uuVeTIXi+9ez3k/Q72qoRz9h
 TvVyWL9Q5QHt/M61Of7m7ohhKk2y8fpeluFUFBpHQifLccSs70Z7jrdjtbOdxGbvVF8W
 6XCJEJSCE1DskTo8S+ZhmseS/msVb6bTNiSi3QEagRS1wpeJwuew10LlwtayiJBS9ZM5
 NMOBYc8gCG7p5YriJ2Af0ZH8+9yhdwMTgnmdGKvoG/24cPr4bm9Jg0yGQIkb/vnRS73A AA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 21:46:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B49EB3F7058;
        Mon,  6 Jun 2022 21:46:40 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/11] qla2xxx: edif: wait for app to ack on sess down
Date:   Mon, 6 Jun 2022 21:46:19 -0700
Message-ID: <20220607044627.19563-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qoNLNxXm07woINdAyyfVaUxikxjAiprV
X-Proofpoint-GUID: qoNLNxXm07woINdAyyfVaUxikxjAiprV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On session deletion, wait for app to acknowledge before
moving on. This allow both app and driver to stay in
sync. In addition, this give a chance for authentication
app to do any type of cleanup before moving on.

Fixes: dd30706e73b70 ("scsi: qla2xxx: edif: Add key update")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 +-
 drivers/scsi/qla2xxx/qla_edif.c   | 66 +++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_init.c   |  4 --
 drivers/scsi/qla2xxx/qla_target.c | 35 ++++++++--------
 4 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 510fbeb04256..3e78bafa4011 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2626,7 +2626,6 @@ typedef struct fc_port {
 	struct {
 		uint32_t	enable:1;	/* device is edif enabled/req'd */
 		uint32_t	app_stop:2;
-		uint32_t	app_started:1;
 		uint32_t	aes_gmac:1;
 		uint32_t	app_sess_online:1;
 		uint32_t	tx_sa_set:1;
@@ -2637,6 +2636,7 @@ typedef struct fc_port {
 		uint32_t	rx_rekey_cnt;
 		uint64_t	tx_bytes;
 		uint64_t	rx_bytes;
+		uint8_t		sess_down_acked;
 		uint8_t		auth_state;
 		uint16_t	authok:1;
 		uint16_t	rekey_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 0a49834198ca..fffdf87d823a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -257,14 +257,8 @@ qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id)
 
 	f = NULL;
 	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
-		if ((f->flags & FCF_FCSP_DEVICE)) {
-			ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x2058,
-			    "Found secure fcport - nn %8phN pn %8phN portid=0x%x, 0x%x.\n",
-			    f->node_name, f->port_name,
-			    f->d_id.b24, id->b24);
-			if (f->d_id.b24 == id->b24)
-				return f;
-		}
+		if (f->d_id.b24 == id->b24)
+			return f;
 	}
 	return NULL;
 }
@@ -526,7 +520,6 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 			fcport->edif.app_stop = 0;
 			fcport->edif.app_sess_online = 0;
-			fcport->edif.app_started = 1;
 
 			if (fcport->scan_state != QLA_FCPORT_FOUND)
 				continue;
@@ -628,9 +621,6 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 			fcport->send_els_logo = 1;
 			qlt_schedule_sess_for_deletion(fcport);
-
-			/* qla_edif_flush_sa_ctl_lists(fcport); */
-			fcport->edif.app_started = 0;
 		}
 	}
 
@@ -1047,6 +1037,40 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	return rval;
 }
 
+static int32_t
+qla_edif_ack(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	struct fc_port *fcport;
+	struct aen_complete_cmd ack;
+	struct fc_bsg_reply     *bsg_reply = bsg_job->reply;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			  bsg_job->request_payload.sg_cnt, &ack, sizeof(ack));
+
+	ql_dbg(ql_dbg_edif, vha, 0x70cf,
+	       "%s: %06x event_code %x\n",
+	       __func__, ack.port_id.b24, ack.event_code);
+
+	fcport = qla2x00_find_fcport_by_pid(vha, &ack.port_id);
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+
+	if (!fcport) {
+		ql_dbg(ql_dbg_edif, vha, 0x70cf,
+		       "%s: unable to find fcport %06x \n",
+		       __func__, ack.port_id.b24);
+		return 0;
+	}
+
+	switch (ack.event_code) {
+	case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+		fcport->edif.sess_down_acked = 1;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 int32_t
 qla_edif_app_mgmt(struct bsg_job *bsg_job)
 {
@@ -1109,6 +1133,9 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	case QL_VND_SC_GET_STATS:
 		rval = qla_edif_app_getstats(vha, bsg_job);
 		break;
+	case QL_VND_SC_AEN_COMPLETE:
+		rval = qla_edif_ack(vha, bsg_job);
+		break;
 	default:
 		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
 		    __func__,
@@ -3512,14 +3539,29 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 {
+	u16 cnt = 0;
+
 	if (sess->edif.app_sess_online && DBELL_ACTIVE(vha)) {
 		ql_dbg(ql_dbg_disc, vha, 0xf09c,
 			"%s: sess %8phN send port_offline event\n",
 			__func__, sess->port_name);
 		sess->edif.app_sess_online = 0;
+		sess->edif.sess_down_acked = 0;
 		qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SESSION_SHUTDOWN,
 		    sess->d_id.b24, 0, sess);
 		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
+
+		while (!READ_ONCE(sess->edif.sess_down_acked) &&
+		       !test_bit(VPORT_DELETE, &vha->dpc_flags)) {
+			msleep(100);
+			cnt++;
+			if (cnt > 100)
+				break;
+		}
+		sess->edif.sess_down_acked = 0;
+		ql_dbg(ql_dbg_disc, vha, 0xf09c,
+		       "%s: sess %8phN port_offline event completed\n",
+		       __func__, sess->port_name);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f3417a3e891..ec1722e86f10 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1480,7 +1480,6 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
 				ql_dbg(ql_dbg_disc, vha, 0x20ef,
 				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
 				    __func__, __LINE__, fcport->port_name);
-				fcport->edif.app_started = 1;
 				fcport->edif.app_sess_online = 1;
 
 				qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED,
@@ -5273,9 +5272,6 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	INIT_LIST_HEAD(&fcport->edif.tx_sa_list);
 	INIT_LIST_HEAD(&fcport->edif.rx_sa_list);
 
-	if (vha->e_dbell.db_flags == EDB_ACTIVE)
-		fcport->edif.app_started = 1;
-
 	spin_lock_init(&fcport->edif.indx_list_lock);
 	INIT_LIST_HEAD(&fcport->edif.edif_indx_list);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2d30578aebcf..56673b691e26 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -988,22 +988,6 @@ void qlt_free_session_done(struct work_struct *work)
 		sess->send_els_logo);
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
-		if (ha->flags.edif_enabled &&
-		    (!own || own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
-			sess->edif.authok = 0;
-			if (!ha->flags.host_shutting_down) {
-				ql_dbg(ql_dbg_edif, vha, 0x911e,
-					"%s wwpn %8phC calling qla2x00_release_all_sadb\n",
-					__func__, sess->port_name);
-				qla2x00_release_all_sadb(vha, sess);
-			} else {
-				ql_dbg(ql_dbg_edif, vha, 0x911e,
-					"%s bypassing release_all_sadb\n",
-					__func__);
-			}
-			qla_edif_clear_appdata(vha, sess);
-			qla_edif_sess_down(vha, sess);
-		}
 		qla2x00_mark_device_lost(vha, sess, 0);
 
 		if (sess->send_els_logo) {
@@ -1049,6 +1033,25 @@ void qlt_free_session_done(struct work_struct *work)
 			sess->nvme_flag |= NVME_FLAG_DELETING;
 			qla_nvme_unregister_remote_port(sess);
 		}
+
+		if (ha->flags.edif_enabled &&
+		    (!own || (own &&
+			      own->iocb.u.isp24.status_subcode == ELS_PLOGI))) {
+			sess->edif.authok = 0;
+			if (!ha->flags.host_shutting_down) {
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+				       "%s wwpn %8phC calling qla2x00_release_all_sadb\n",
+				       __func__, sess->port_name);
+				qla2x00_release_all_sadb(vha, sess);
+			} else {
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+				       "%s bypassing release_all_sadb\n",
+				       __func__);
+			}
+
+			qla_edif_clear_appdata(vha, sess);
+			qla_edif_sess_down(vha, sess);
+		}
 	}
 
 	/*
-- 
2.19.0.rc0

