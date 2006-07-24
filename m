From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/11] iscsi bugfixes: fix abort handling
Date: Mon, 24 Jul 2006 15:47:22 -0500
Message-ID: <1153774042.1040.35.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:15552 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932068AbWGXUsm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:48:42 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKmLAd012543
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:48:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Abort handler fixes.

If a connection is dropped and reconnected while an abort is
running then we should assume the recovery code will clean up
the abort. Not doing so causes a oops.

And if a command completes then we get the status for the abort, we do not
need to call into the LLD to cleanup the resources. Doing this causes
and oops in iser because it ends up freeing some resources twice.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1a8cd20..4e2ca8f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -276,6 +276,25 @@ out:
 	return rc;
 }
 
+static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
+{
+	struct iscsi_tm_rsp *tmf = (struct iscsi_tm_rsp *)hdr;
+
+	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
+	conn->tmfrsp_pdus_cnt++;
+
+	if (conn->tmabort_state != TMABORT_INITIAL)
+		return;
+
+	if (tmf->response == ISCSI_TMF_RSP_COMPLETE)
+		conn->tmabort_state = TMABORT_SUCCESS;
+	else if (tmf->response == ISCSI_TMF_RSP_NO_TASK)
+		conn->tmabort_state = TMABORT_NOT_FOUND;
+	else
+		conn->tmabort_state = TMABORT_FAILED;
+	wake_up(&conn->ehwait);
+}
+
 /**
  * __iscsi_complete_pdu - complete pdu
  * @conn: iscsi conn
@@ -361,16 +380,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 				break;
 			}
 
-			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
-			conn->tmfrsp_pdus_cnt++;
-			if (conn->tmabort_state == TMABORT_INITIAL) {
-				conn->tmabort_state =
-					((struct iscsi_tm_rsp *)hdr)->
-					response == ISCSI_TMF_RSP_COMPLETE ?
-						TMABORT_SUCCESS:TMABORT_FAILED;
-				/* unblock eh_abort() */
-				wake_up(&conn->ehwait);
-			}
+			iscsi_tmf_rsp(conn, hdr);
 			break;
 		case ISCSI_OP_NOOP_IN:
 			if (hdr->ttt != ISCSI_RESERVED_TAG) {
@@ -1029,12 +1039,13 @@ static void fail_command(struct iscsi_co
 {
 	struct scsi_cmnd *sc;
 
-	conn->session->tt->cleanup_cmd_task(conn, ctask);
-	iscsi_ctask_mtask_cleanup(ctask);
-
 	sc = ctask->sc;
 	if (!sc)
 		return;
+
+	conn->session->tt->cleanup_cmd_task(conn, ctask);
+	iscsi_ctask_mtask_cleanup(ctask);
+
 	sc->result = err;
 	sc->resid = sc->request_bufflen;
 	iscsi_complete_command(conn->session, ctask);
@@ -1062,8 +1073,11 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto failed;
 
 	/* ctask completed before time out */
-	if (!ctask->sc)
-		goto success;
+	if (!ctask->sc) {
+		spin_unlock_bh(&session->lock);
+		debug_scsi("sc completed while abort in progress\n");
+		goto success_rel_mutex;
+	}
 
 	/* what should we do here ? */
 	if (conn->ctask == ctask) {
@@ -1073,7 +1087,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	if (ctask->state == ISCSI_TASK_PENDING)
-		goto success;
+		goto success_cleanup;
 
 	conn->tmabort_state = TMABORT_INITIAL;
 
@@ -1081,25 +1095,31 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	rc = iscsi_exec_abort_task(sc, ctask);
 	spin_lock_bh(&session->lock);
 
-	iscsi_ctask_mtask_cleanup(ctask);
 	if (rc || sc->SCp.phase != session->age ||
 	    session->state != ISCSI_STATE_LOGGED_IN)
 		goto failed;
+	iscsi_ctask_mtask_cleanup(ctask);
 
-	/* ctask completed before tmf abort response */
-	if (!ctask->sc) {
-		debug_scsi("sc completed while abort in progress\n");
-		goto success;
-	}
-
-	if (conn->tmabort_state != TMABORT_SUCCESS) {
+	switch (conn->tmabort_state) {
+	case TMABORT_SUCCESS:
+		goto success_cleanup;
+	case TMABORT_NOT_FOUND:
+		if (!ctask->sc) {
+			/* ctask completed before tmf abort response */
+			spin_unlock_bh(&session->lock);
+			debug_scsi("sc completed while abort in progress\n");
+			goto success_rel_mutex;
+		}
+		/* fall through */
+	default:
+		/* timedout or failed */
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
 		goto failed;
 	}
 
-success:
+success_cleanup:
 	debug_scsi("abort success [sc %lx itt 0x%x]\n", (long)sc, ctask->itt);
 	spin_unlock_bh(&session->lock);
 
@@ -1113,6 +1133,7 @@ success:
 	spin_unlock(&session->lock);
 	write_unlock_bh(conn->recv_lock);
 
+success_rel_mutex:
 	mutex_unlock(&conn->xmitmutex);
 	return SUCCESS;
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index e71d6e9..3f69f7e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -60,6 +60,7 @@ #define TMABORT_INITIAL			0x0
 #define TMABORT_SUCCESS			0x1
 #define TMABORT_FAILED			0x2
 #define TMABORT_TIMEDOUT		0x3
+#define TMABORT_NOT_FOUND		0x4
 
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1


