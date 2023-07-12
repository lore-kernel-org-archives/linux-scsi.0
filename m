Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B04BEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 09:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjGLJGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbjGLJFx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 05:05:53 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7224172C
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:41 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C7OZ3U029250
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=/47n3fyIKHvRfEbXVZ9xCAPF/HztZo5OT1mKRSx31xg=;
 b=WzWBzSnWgdJnbKwJEQlGTrgmWnszrMiTAkUuMD1tAaEphwv8906LGMUNhUD/LWwLvZWu
 /5HBDH+EMxGiV8pKHXxcbJpCGDeBLeQXdLD+DgEnOcoDhj5KslqdCvW7LEREPJirltnS
 9X5cAtoXjpJPwdeFdJz+O3zadSgqHzlXh1E3C0p7JvDaENbWUIQFWfvx/MTsShx55Gx1
 +kk6OOHzbRLAkjpNWlQAvvphoHTarAzP5Y37n0NJLr9w2ecAxyyTadXngMkpTvl1xnav
 qhiv9LUKWlbtkjYan4gnGy1zwqNkhWUYu/kuYtOiupMbVtW+L7cEUVL8lu23azcrrhGK rw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rsb7rb0ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 12 Jul
 2023 02:05:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 12 Jul 2023 02:05:40 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 745753F7076;
        Wed, 12 Jul 2023 02:05:38 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 01/10] qla2xxx: Fix deletion race condition
Date:   Wed, 12 Jul 2023 14:35:26 +0530
Message-ID: <20230712090535.34894-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230712090535.34894-1-njavali@marvell.com>
References: <20230712090535.34894-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: zkdNZeV7QU2dE62uDd-WZ47nbUbn7sir
X-Proofpoint-ORIG-GUID: zkdNZeV7QU2dE62uDd-WZ47nbUbn7sir
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

System crash when using debug kernel due
to link list corruption. The cause of the link list corruption
is due to session deletion was allowed to queue up twice.
Here's the internal trace that show the same port was allowed to double
queue for deletion on different cpu.

20808683956 015 qla2xxx [0000:13:00.1]-e801:4: Scheduling sess ffff93ebf9306800 for deletion 50:06:0e:80:12:48:ff:50 fc4_type 1
20808683957 027 qla2xxx [0000:13:00.1]-e801:4: Scheduling sess ffff93ebf9306800 for deletion 50:06:0e:80:12:48:ff:50 fc4_type 1

Move the clearing/setting of deleted flag lock.

Cc: stable@vger.kernel.org
Fixes: 726b85487067 (“qla2xxx: Add framework for async fabric discovery”)
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 16 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c | 14 +++++++-------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b22b0516da29..f8f64ed4de07 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -508,6 +508,7 @@ static
 void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
 	struct fc_port *fcport = ea->fcport;
+	unsigned long flags;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d2,
 	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d lid %d\n",
@@ -522,9 +523,15 @@ void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x2066,
 		    "%s %8phC: adisc fail: post delete\n",
 		    __func__, ea->fcport->port_name);
+
+		spin_lock_irqsave(&vha->work_lock, flags);
 		/* deleted = 0 & logout_on_delete = force fw cleanup */
-		fcport->deleted = 0;
+		if (fcport->deleted == QLA_SESS_DELETED)
+			fcport->deleted = 0;
+
 		fcport->logout_on_delete = 1;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+
 		qlt_schedule_sess_for_deletion(ea->fcport);
 		return;
 	}
@@ -1446,7 +1453,6 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	ea->fcport->login_gen++;
-	ea->fcport->deleted = 0;
 	ea->fcport->logout_on_delete = 1;
 
 	if (!ea->fcport->login_succ && !IS_SW_RESV_ADDR(ea->fcport->d_id)) {
@@ -6090,6 +6096,8 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 void
 qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 {
+	unsigned long flags;
+
 	if (IS_SW_RESV_ADDR(fcport->d_id))
 		return;
 
@@ -6099,7 +6107,11 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	qla2x00_set_fcport_disc_state(fcport, DSC_UPD_FCPORT);
 	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+
+	spin_lock_irqsave(&vha->work_lock, flags);
 	fcport->deleted = 0;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
 	if (vha->hw->current_topology == ISP_CFG_NL)
 		fcport->logout_on_delete = 0;
 	else
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5258b07687a9..2b815a9928ea 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1068,10 +1068,6 @@ void qlt_free_session_done(struct work_struct *work)
 			(struct imm_ntfy_from_isp *)sess->iocb, SRB_NACK_LOGO);
 	}
 
-	spin_lock_irqsave(&vha->work_lock, flags);
-	sess->flags &= ~FCF_ASYNC_SENT;
-	spin_unlock_irqrestore(&vha->work_lock, flags);
-
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	if (sess->se_sess) {
 		sess->se_sess = NULL;
@@ -1081,7 +1077,6 @@ void qlt_free_session_done(struct work_struct *work)
 
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETED);
 	sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
-	sess->deleted = QLA_SESS_DELETED;
 
 	if (sess->login_succ && !IS_SW_RESV_ADDR(sess->d_id)) {
 		vha->fcport_count--;
@@ -1133,10 +1128,15 @@ void qlt_free_session_done(struct work_struct *work)
 
 	sess->explicit_logout = 0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-	sess->free_pending = 0;
 
 	qla2x00_dfs_remove_rport(vha, sess);
 
+	spin_lock_irqsave(&vha->work_lock, flags);
+	sess->flags &= ~FCF_ASYNC_SENT;
+	sess->deleted = QLA_SESS_DELETED;
+	sess->free_pending = 0;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
 	ql_dbg(ql_dbg_disc, vha, 0xf001,
 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
 		sess, sess->port_name, vha->fcport_count);
@@ -1185,12 +1185,12 @@ void qlt_unreg_sess(struct fc_port *sess)
 	 * management from being sent.
 	 */
 	sess->flags |= FCF_ASYNC_SENT;
+	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
 	if (sess->se_sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 	qla2x00_set_fcport_disc_state(sess, DSC_DELETE_PEND);
 	sess->last_rscn_gen = sess->rscn_gen;
 	sess->last_login_gen = sess->login_gen;
-- 
2.23.1

