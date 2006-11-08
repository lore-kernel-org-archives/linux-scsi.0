From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/4] iscsi: add newlines to debug messages
Date: Wed, 08 Nov 2006 15:58:32 -0600
Message-ID: <11630231161743-git-send-email-michaelc@cs.wisc.edu>
References: <11630231143038-git-send-email-michaelc@cs.wisc.edu> <11630231152581-git-send-email-michaelc@cs.wisc.edu>
Reply-To: Mike Christie <michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28570 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965722AbWKHV6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 16:58:37 -0500
In-Reply-To: <11630231152581-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Pete Wyckoff <pw@osc.edu>

From: Pete Wyckoff <pw@osc.edu>

Some messages from debug_scsi do not have trailing newlines,
making console messages difficult to read.  Fix that.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

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
-- 
1.4.1.1

