From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] libiscsi: add more informative failure message during iscsi scsi eh
Date: Fri, 31 Dec 2010 02:22:18 -0600
Message-ID: <1293783742-8238-2-git-send-email-michaelc@cs.wisc.edu>
References: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0LaIWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 03:22:30 -0500
In-Reply-To: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This adds a more informative error code and message
for the iscsi scsi eh session drop paths. This allows
you to distinguish if the session was dropped due to
a connection failure vs the iscsi layer dropping
the session due to scsi eh failure processing.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   10 +++++-----
 include/scsi/iscsi_if.h |    1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c15fde8..434d9ae 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1795,9 +1795,9 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 				      NULL, 0);
 	if (!task) {
 		spin_unlock_bh(&session->lock);
+		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		spin_lock_bh(&session->lock);
-		ISCSI_DBG_EH(session, "tmf exec failure\n");
 		return -EPERM;
 	}
 	conn->tmfcmd_pdus_cnt++;
@@ -2202,7 +2202,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		goto success_unlocked;
 	case TMF_TIMEDOUT:
 		spin_unlock_bh(&session->lock);
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
 		if (!sc->SCp.ptr) {
@@ -2289,7 +2289,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 		break;
 	case TMF_TIMEDOUT:
 		spin_unlock_bh(&session->lock);
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
 		conn->tmf_state = TMF_INITIAL;
@@ -2370,7 +2370,7 @@ failed:
 	 * we drop the lock here but the leadconn cannot be destoyed while
 	 * we are in the scsi eh
 	 */
-	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 
 	ISCSI_DBG_EH(session, "wait for relogin\n");
 	wait_event_interruptible(conn->ehwait,
@@ -2452,7 +2452,7 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 		break;
 	case TMF_TIMEDOUT:
 		spin_unlock_bh(&session->lock);
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto done;
 	default:
 		conn->tmf_state = TMF_INITIAL;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index a8631ac..c3e1cbc 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -263,6 +263,7 @@ enum iscsi_err {
 	ISCSI_ERR_INVALID_HOST		= ISCSI_ERR_BASE + 18,
 	ISCSI_ERR_XMIT_FAILED		= ISCSI_ERR_BASE + 19,
 	ISCSI_ERR_TCP_CONN_CLOSE	= ISCSI_ERR_BASE + 20,
+	ISCSI_ERR_SCSI_EH_SESSION_RST	= ISCSI_ERR_BASE + 21,
 };
 
 /*
-- 
1.7.0.1

