Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5B0C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A59120716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="euvQ9dlA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfLQWHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:07:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbfLQWHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:07:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5eEk030252;
        Tue, 17 Dec 2019 14:07:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ebq53QuRTAp8aqWEOR5SSU1w1JA2TbERbJoKSlspFkg=;
 b=euvQ9dlAW4SlQrfBQ58KE0KTdFC9975jmQIyqJ7R/xRk3YSest+aV2xeMfnkstSg6WYu
 AUL+XedZgclW1bZqOcZwHZ12Ka2yGMVupajlZNfcQ1gQGx2eTm707yWA2G80qHGnaaik
 llYVMqD/tFcyzMjKQPjOr7dPMz/t8BPqZ2TdZFDmY6KhdQjrrtwgrs5W3nRUXMb/hBgd
 hIQnLohZ0BZC1XvZR8D7YnUzyOlrfUztd5fIzZTkAZzqCDJWmQ7FcwqDmzVdS6dNRYif
 VOCESHXIiEIOro4yxFlYHFaqlSjXndwI8koeTgeK57w+YfPOgCV1qmDnbqem+YJz2hFf bQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm224-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:02 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:54 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:54 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DC1A43F703F;
        Tue, 17 Dec 2019 14:06:54 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6som028175;
        Tue, 17 Dec 2019 14:06:54 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6sQa028174;
        Tue, 17 Dec 2019 14:06:54 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 12/14] qla2xxx: Fix stuck session in GNL
Date:   Tue, 17 Dec 2019 14:06:15 -0800
Message-ID: <20191217220617.28084-13-hmadhani@marvell.com>
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

From: Quinn Tran <qutran@marvell.com>

Fix race condition between GNL completion processing and
GNL request. Late submission of GNL request was not seen
by the GNL completion thread. This patch will re-submit
the GNL request for late submission fcport.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 15 +++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c | 21 +++++++++++++++------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4f849b12b546..a5076f43edea 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -990,7 +990,7 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int res)
 		set_bit(loop_id, vha->hw->loop_id_map);
 		wwn = wwn_to_u64(e->port_name);
 
-		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20e8,
+		ql_dbg(ql_dbg_disc, vha, 0x20e8,
 		    "%s %8phC %02x:%02x:%02x CLS %x/%x lid %x \n",
 		    __func__, (void *)&wwn, e->port_id[2], e->port_id[1],
 		    e->port_id[0], e->current_login_state, e->last_login_state,
@@ -1049,6 +1049,16 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int res)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	vha->gnl.sent = 0;
+	if (!list_empty(&vha->gnl.fcports)) {
+		/* retrigger gnl */
+		list_for_each_entry_safe(fcport, tf, &vha->gnl.fcports,
+		    gnl_entry) {
+			list_del_init(&fcport->gnl_entry);
+			fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+			if (qla24xx_post_gnl_work(vha, fcport) == QLA_SUCCESS)
+				break;
+		}
+	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	sp->free(sp);
@@ -2000,7 +2010,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			qla24xx_post_prli_work(vha, ea->fcport);
 		} else {
 			ql_dbg(ql_dbg_disc, vha, 0x20ea,
-			    "%s %d %8phC LoopID 0x%x in use with %06x. post gnl\n",
+			    "%s %d %8phC LoopID 0x%x in use with %06x. post gpdb\n",
 			    __func__, __LINE__, ea->fcport->port_name,
 			    ea->fcport->loop_id, ea->fcport->d_id.b24);
 
@@ -2071,6 +2081,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			set_bit(lid, vha->hw->loop_id_map);
 			ea->fcport->loop_id = lid;
 			ea->fcport->keep_nport_handle = 0;
+			ea->fcport->logout_on_delete = 1;
 			qlt_schedule_sess_for_deletion(ea->fcport);
 		}
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0ef76743a26d..97af678ed9e0 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -958,7 +958,7 @@ void qlt_free_session_done(struct work_struct *work)
 	struct qlt_plogi_ack_t *own =
 		sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf084,
+	ql_dbg(ql_dbg_disc, vha, 0xf084,
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
 		" s_id %02x:%02x:%02x logout %d keep %d els_logo %d\n",
 		__func__, sess->se_sess, sess, sess->port_name, sess->loop_id,
@@ -1025,7 +1025,7 @@ void qlt_free_session_done(struct work_struct *work)
 
 		while (!READ_ONCE(sess->logout_completed)) {
 			if (!traced) {
-				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf086,
+				ql_dbg(ql_dbg_disc, vha, 0xf086,
 					"%s: waiting for sess %p logout\n",
 					__func__, sess);
 				traced = true;
@@ -1046,6 +1046,10 @@ void qlt_free_session_done(struct work_struct *work)
 			(struct imm_ntfy_from_isp *)sess->iocb, SRB_NACK_LOGO);
 	}
 
+	spin_lock_irqsave(&vha->work_lock, flags);
+	sess->flags &= ~FCF_ASYNC_SENT;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	if (sess->se_sess) {
 		sess->se_sess = NULL;
@@ -1109,7 +1113,7 @@ void qlt_free_session_done(struct work_struct *work)
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
+	ql_dbg(ql_dbg_disc, vha, 0xf001,
 	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
 		sess, sess->port_name, vha->fcport_count);
 
@@ -1152,6 +1156,11 @@ void qlt_unreg_sess(struct fc_port *sess)
 		return;
 	}
 	sess->free_pending = 1;
+	/*
+	 * Use FCF_ASYNC_SENT flag to block other cmds used in sess
+	 * management from being sent.
+	 */
+	sess->flags |= FCF_ASYNC_SENT;
 	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
 
 	if (sess->se_sess)
@@ -4581,7 +4590,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 		/* find other sess with nport_id collision */
 		if (port_id.b24 == other_sess->d_id.b24) {
 			if (loop_id != other_sess->loop_id) {
-				ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000c,
+				ql_dbg(ql_dbg_disc, vha, 0x1000c,
 				    "Invalidating sess %p loop_id %d wwn %llx.\n",
 				    other_sess, other_sess->loop_id, other_wwn);
 
@@ -4597,7 +4606,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 				 * Another wwn used to have our s_id/loop_id
 				 * kill the session, but don't free the loop_id
 				 */
-				ql_dbg(ql_dbg_tgt_tmr, vha, 0xf01b,
+				ql_dbg(ql_dbg_disc, vha, 0xf01b,
 				    "Invalidating sess %p loop_id %d wwn %llx.\n",
 				    other_sess, other_sess->loop_id, other_wwn);
 
@@ -4612,7 +4621,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 		/* find other sess with nport handle collision */
 		if ((loop_id == other_sess->loop_id) &&
 			(loop_id != FC_NO_LOOP_ID)) {
-			ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000d,
+			ql_dbg(ql_dbg_disc, vha, 0x1000d,
 			       "Invalidating sess %p loop_id %d wwn %llx.\n",
 			       other_sess, other_sess->loop_id, other_wwn);
 
-- 
2.12.0

