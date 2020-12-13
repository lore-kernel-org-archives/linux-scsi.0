Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F68C2BB48
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648E523124
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389613AbgLMDKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:10:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732651AbgLMDKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD34thP074914;
        Sun, 13 Dec 2020 03:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=wRVrlwlT24dVrU0R51JGpVUsKdJX1qvb1Z8b8U7uoX0=;
 b=HtLOaV19TOLjgpakzdOI0fQ+PpY3rkfoBI29E7X2nj8fPNm1bjwcqTk2Vuy3vSYTF/tf
 S+v9QnnhILEL0UT3igp/p7tKEGOHc3UOZA7ouk763aNVTQQKiJCJVXGLUzW3Rn/yk9Xw
 m9ui8zJZPhxQaY0sNucMBLax7VAkT67hmuhuCRgl8TwvFBM1S17cCbF5+rrmUvLwf/bP
 K+vaR24ZgO9OEknu9uziAeYEOQeLorwbsvDI98R6nx2NpAHQecHNf5xHGY9Cr+O5igLq
 IJiBxmehaeO7LEkcL7L8yEYejfmjtMTK26L8j+LueVTC6v9/70IpQWC8QRboeuInTsMT Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9r1jar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD36i2M181199;
        Sun, 13 Dec 2020 03:09:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35d7rvaefw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD390Df013816;
        Sun, 13 Dec 2020 03:09:01 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:00 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 05/18] libiscsi: remove queued_cmdsn
Date:   Sat, 12 Dec 2020 21:08:33 -0600
Message-Id: <1607828926-3658-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

queue_cmdsn was meant to prevent cmds from sitting in the cmdqueue too
long, but iscsi_eh_cmd_timed_out already handles this. By dropping it
and moving the window check to iscsi_data_xmit we will no longer need
the frwd lock for the cmdsn for the iscsi xmit wq based drivers. This
will be more useful for future patches where we drop the frwd lock
from queuecommand for these drivers, but today it only has the benefit
that we can now detect when a nop carries the cmdsn info that opens
a window.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c     | 119 ++++++++++++++++++++++++++------------------
 drivers/scsi/libiscsi_tcp.c |   4 +-
 include/scsi/libiscsi.h     |  10 ++--
 3 files changed, 77 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0907f2d..f023bee 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,9 +93,30 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
 
-static void __iscsi_update_cmdsn(struct iscsi_session *session,
-				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
+static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
 {
+	struct iscsi_session *session = conn->session;
+
+	/* make sure we see the updated SNs */
+	smp_rmb();
+	/*
+	 * Check for iSCSI window and take care of CmdSN wrap-around
+	 */
+	if (!iscsi_sna_lte(session->cmdsn, session->max_cmdsn)) {
+		ISCSI_DBG_SESSION(session, "iSCSI CmdSN closed. ExpCmdSn %u MaxCmdSN %u CmdSN %u\n",
+				  session->exp_cmdsn, session->max_cmdsn,
+				  session->cmdsn);
+		return -ENOSPC;
+	}
+	return 0;
+}
+
+static void __iscsi_update_cmdsn(struct iscsi_conn *conn, uint32_t exp_cmdsn,
+				 uint32_t max_cmdsn)
+{
+	struct iscsi_session *session = conn->session;
+	bool win_closed = false;
+
 	/*
 	 * standard specifies this check for when to update expected and
 	 * max sequence numbers
@@ -108,13 +129,26 @@ static void __iscsi_update_cmdsn(struct iscsi_session *session,
 		session->exp_cmdsn = exp_cmdsn;
 
 	if (max_cmdsn != session->max_cmdsn &&
-	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn))
+	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
+
+		if (iscsi_check_cmdsn_window_closed(conn))
+			win_closed = true;
+
 		session->max_cmdsn = max_cmdsn;
+		if (win_closed)
+			session->win_opened = true;
+		/*
+		 *  Make sure we see the max_cmdsn from the xmit/queue paths.
+		 *  And if the pdu that opened the windows did not complete
+		 *  the pdu sure we see win_openend when the cmd is finished.
+		 */
+		smp_wmb();
+	}
 }
 
-void iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
+void iscsi_update_cmdsn(struct iscsi_conn *conn, struct iscsi_nopin *hdr)
 {
-	__iscsi_update_cmdsn(session, be32_to_cpu(hdr->exp_cmdsn),
+	__iscsi_update_cmdsn(conn, be32_to_cpu(hdr->exp_cmdsn),
 			     be32_to_cpu(hdr->max_cmdsn));
 }
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
@@ -424,14 +458,15 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 
 	task->state = ISCSI_TASK_RUNNING;
 	session->cmdsn++;
+	/* make sure window checkers see the update */
+	smp_wmb();
 
 	conn->scsicmd_pdus_cnt++;
 	ISCSI_DBG_SESSION(session, "iscsi prep [%s cid %d sc %p cdb 0x%x "
 			  "itt 0x%x len %d cmdsn %d win %d]\n",
 			  sc->sc_data_direction == DMA_TO_DEVICE ?
 			  "write" : "read", conn->id, sc, sc->cmnd[0],
-			  task->itt, transfer_length,
-			  session->cmdsn,
+			  task->itt, transfer_length, session->cmdsn,
 			  session->max_cmdsn - session->exp_cmdsn + 1);
 	return 0;
 }
@@ -465,6 +500,16 @@ static void iscsi_free_task(struct iscsi_task *task)
 
 	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
 
+	/*
+	 * if the window opened when we processed a data/r2t pdu make sure we
+	 * see the updated win_opened value.
+	 */
+	smp_rmb();
+	if (session->win_opened && !work_pending(&conn->xmitwork)) {
+		session->win_opened = false;
+		iscsi_conn_queue_work(conn);
+	}
+
 	if (sc) {
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
@@ -549,7 +594,7 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
 	ISCSI_DBG_SESSION(conn->session, "[itt 0x%x]\n", task->itt);
 
 	conn->last_recv = jiffies;
-	__iscsi_update_cmdsn(conn->session, exp_cmdsn, max_cmdsn);
+	__iscsi_update_cmdsn(conn, exp_cmdsn, max_cmdsn);
 	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 }
 EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
@@ -613,11 +658,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 	}
 
 	if (task->state == ISCSI_TASK_PENDING) {
-		/*
-		 * cmd never made it to the xmit thread, so we should not count
-		 * the cmd in the sequencing
-		 */
-		conn->session->queued_cmdsn--;
 		/* it was never sent so just complete like normal */
 		state = ISCSI_TASK_COMPLETED;
 	} else if (err == DID_TRANSPORT_DISRUPTED)
@@ -658,10 +698,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		 * but we always only send one PDU at a time.
 		 */
 		if (conn->c_stage == ISCSI_CONN_STARTED &&
-		    !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
-			session->queued_cmdsn++;
+		    !(hdr->opcode & ISCSI_OP_IMMEDIATE))
 			session->cmdsn++;
-		}
 	}
 
 	if (session->tt->init_task && session->tt->init_task(task))
@@ -820,7 +858,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
 
-	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
+	iscsi_update_cmdsn(conn, (struct iscsi_nopin *)rhdr);
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
@@ -920,7 +958,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
 		return;
 
-	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin *)hdr);
+	iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
@@ -1172,7 +1210,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			  opcode, conn->id, itt, datalen);
 
 	if (itt == ~0U) {
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 
 		switch(opcode) {
 		case ISCSI_OP_NOOP_IN:
@@ -1240,7 +1278,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_data_in_rsp(conn, hdr, task);
 		break;
 	case ISCSI_OP_LOGOUT_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1249,14 +1287,14 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		goto recv_pdu;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		/*
 		 * login related PDU's exp_statsn is handled in
 		 * userspace
 		 */
 		goto recv_pdu;
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		if (datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1266,7 +1304,7 @@ int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
 		break;
 	case ISCSI_OP_NOOP_IN:
-		iscsi_update_cmdsn(session, (struct iscsi_nopin*)hdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)hdr);
 		if (hdr->ttt != cpu_to_be32(ISCSI_RESERVED_TAG) || datalen) {
 			rc = ISCSI_ERR_PROTO;
 			break;
@@ -1416,23 +1454,6 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
-static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
-{
-	struct iscsi_session *session = conn->session;
-
-	/*
-	 * Check for iSCSI window and take care of CmdSN wrap-around
-	 */
-	if (!iscsi_sna_lte(session->queued_cmdsn, session->max_cmdsn)) {
-		ISCSI_DBG_SESSION(session, "iSCSI CmdSN closed. ExpCmdSn "
-				  "%u MaxCmdSN %u CmdSN %u/%u\n",
-				  session->exp_cmdsn, session->max_cmdsn,
-				  session->cmdsn, session->queued_cmdsn);
-		return -ENOSPC;
-	}
-	return 0;
-}
-
 static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 {
 	struct iscsi_task *task = conn->task;
@@ -1564,6 +1585,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 
 	/* process pending command queue */
 	while (!list_empty(&conn->cmdqueue)) {
+		rc = iscsi_check_cmdsn_window_closed(conn);
+		if (rc)
+			goto done;
+
 		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
 				  running);
 		list_del_init(&task->running);
@@ -1750,11 +1775,6 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (iscsi_check_cmdsn_window_closed(conn)) {
-		reason = FAILURE_WINDOW_CLOSED;
-		goto reject;
-	}
-
 	task = iscsi_alloc_task(conn, sc);
 	if (!task) {
 		reason = FAILURE_OOM;
@@ -1762,6 +1782,11 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	}
 
 	if (!ihost->workq) {
+		if (iscsi_check_cmdsn_window_closed(conn)) {
+			reason = FAILURE_WINDOW_CLOSED;
+			goto prepd_reject;
+		}
+
 		reason = iscsi_prep_scsi_cmd_pdu(task);
 		if (reason) {
 			if (reason == -ENOMEM ||  reason == -EACCES) {
@@ -1782,7 +1807,6 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		iscsi_conn_queue_work(conn);
 	}
 
-	session->queued_cmdsn++;
 	spin_unlock_bh(&session->frwd_lock);
 	return 0;
 
@@ -2831,7 +2855,7 @@ struct iscsi_cls_session *
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
 	session->cmds_max = total_cmds;
-	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
+	session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
@@ -3063,7 +3087,6 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	spin_lock_bh(&session->frwd_lock);
 	conn->c_stage = ISCSI_CONN_STARTED;
 	session->state = ISCSI_STATE_LOGGED_IN;
-	session->queued_cmdsn = session->cmdsn;
 
 	conn->last_recv = jiffies;
 	conn->last_ping = jiffies;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 14c9169..ea11788 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -496,7 +496,7 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 	 * is status.
 	 */
 	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
-		iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
+		iscsi_update_cmdsn(conn, (struct iscsi_nopin *)rhdr);
 
 	if (tcp_conn->in.datalen == 0)
 		return 0;
@@ -563,7 +563,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
 	/* fill-in new R2T associated with the task */
-	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
+	iscsi_update_cmdsn(conn, (struct iscsi_nopin *)rhdr);
 	spin_unlock(&session->back_lock);
 
 	if (tcp_conn->in.datalen) {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 44a9554..287e46b 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -275,9 +275,7 @@ struct iscsi_session {
 	uint32_t		cmdsn;
 	uint32_t		exp_cmdsn;
 	uint32_t		max_cmdsn;
-
-	/* This tracks the reqs queued into the initiator */
-	uint32_t		queued_cmdsn;
+	bool			win_opened;
 
 	/* configuration */
 	int			abort_timeout;
@@ -329,8 +327,8 @@ struct iscsi_session {
 	 * but not vice versa.
 	 */
 	spinlock_t		frwd_lock;	/* protects session state, *
-						 * cmdsn, queued_cmdsn     *
-						 * session resources:      *
+						 * cmdsn and session       *
+						 * resources:              *
 						 * - cmdpool kfifo_out ,   *
 						 * - mgmtpool, queues	   */
 	spinlock_t		back_lock;	/* protects cmdsn_exp      *
@@ -440,7 +438,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 /*
  * pdu and task processing
  */
-extern void iscsi_update_cmdsn(struct iscsi_session *, struct iscsi_nopin *);
+extern void iscsi_update_cmdsn(struct iscsi_conn *conn, struct iscsi_nopin *hdr);
 extern void iscsi_prep_data_out_pdu(struct iscsi_task *task,
 				    struct iscsi_r2t_info *r2t,
 				    struct iscsi_data *hdr);
-- 
1.8.3.1

