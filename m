From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] iscsi: add newlines to debug messages
Date: Sat, 4 Nov 2006 18:36:01 -0500
Message-ID: <20061104233601.GB14929@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d60-77-190.col.wideopenwest.com ([65.60.190.77]:45249 "EHLO
	pw.padd.com") by vger.kernel.org with ESMTP id S965743AbWKDXgC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 18:36:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Some messages from debug_scsi do not have trailing newlines,
making console messages difficult to read.  Fix that.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2865ebd..5d88621 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -975,13 +975,13 @@ int iscsi_eh_host_reset(struct scsi_cmnd
 	if (session->state == ISCSI_STATE_TERMINATE) {
 failed:
 		debug_scsi("failing host reset: session terminated "
-			   "[CID %d age %d]", conn->id, session->age);
+			   "[CID %d age %d]\n", conn->id, session->age);
 		spin_unlock_bh(&session->lock);
 		return FAILED;
 	}
 
 	if (sc->SCp.phase == session->age) {
-		debug_scsi("failing connection CID %d due to SCSI host reset",
+		debug_scsi("failing connection CID %d due to SCSI host reset\n",
 			   conn->id);
 		fail_session = 1;
 	}
@@ -1054,7 +1054,8 @@ static int iscsi_exec_abort_task(struct 
 				     NULL, 0);
 	if (rc) {
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		debug_scsi("abort sent failure [itt 0x%x] %d", ctask->itt, rc);
+		debug_scsi("abort sent failure [itt 0x%x] %d\n", ctask->itt,
+		           rc);
 		return rc;
 	}
 
@@ -1071,7 +1072,7 @@ static int iscsi_exec_abort_task(struct 
 		conn->tmabort_timer.function = iscsi_tmabort_timedout;
 		conn->tmabort_timer.data = (unsigned long)ctask;
 		add_timer(&conn->tmabort_timer);
-		debug_scsi("abort set timeout [itt 0x%x]", ctask->itt);
+		debug_scsi("abort set timeout [itt 0x%x]\n", ctask->itt);
 	}
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&conn->xmitmutex);
