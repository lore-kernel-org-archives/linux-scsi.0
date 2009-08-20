From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] libiscsi, iscsi_tcp: check suspend bit before each call to xmit_task
Date: Thu, 20 Aug 2009 15:11:03 -0500
Message-ID: <1250799063-1843-8-git-send-email-michaelc@cs.wisc.edu>
References: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-3-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-4-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-5-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-6-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZHTULX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:23 -0400
In-Reply-To: <1250799063-1843-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we had multiple tasks on the cmd or requeue  lists, and iscsi_tcp
returns a error, the write_space function can still run and queue
iscsi_data_xmit. If it was a legetimate problem and iscsi_conn_failure
was run but we raced and iscsi_data_xmit was run first it could miss
the suspend bit checks, and start trying to send data again and hit
another timeout. A similar problem is present when using cxgb3i.

This has libiscsi check the suspend bit before calling the xmit
task callout, so we at least do not try sending multiple tasks
(one could be sent).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 957fe25..91789c1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1280,6 +1280,9 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
 	struct iscsi_task *task = conn->task;
 	int rc;
 
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
+		return -ENODATA;
+
 	__iscsi_get_task(task);
 	spin_unlock_bh(&conn->session->lock);
 	rc = conn->session->tt->xmit_task(task);
@@ -1329,7 +1332,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	spin_lock_bh(&conn->session->lock);
-	if (unlikely(conn->suspend_tx)) {
+	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->lock);
 		return -ENODATA;
@@ -1338,7 +1341,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	if (conn->task) {
 		rc = iscsi_xmit_task(conn);
 	        if (rc)
-		        goto again;
+		        goto done;
 	}
 
 	/*
@@ -1358,7 +1361,7 @@ check_mgmt:
 		}
 		rc = iscsi_xmit_task(conn);
 		if (rc)
-			goto again;
+			goto done;
 	}
 
 	/* process pending command queue */
@@ -1379,14 +1382,14 @@ check_mgmt:
 				list_add_tail(&conn->task->running,
 					      &conn->cmdqueue);
 				conn->task = NULL;
-				goto again;
+				goto done;
 			} else
 				fail_scsi_task(conn->task, DID_ABORT);
 			continue;
 		}
 		rc = iscsi_xmit_task(conn);
 		if (rc)
-			goto again;
+			goto done;
 		/*
 		 * we could continuously get new task requests so
 		 * we need to check the mgmt queue for nops that need to
@@ -1412,16 +1415,14 @@ check_mgmt:
 		conn->task->state = ISCSI_TASK_RUNNING;
 		rc = iscsi_xmit_task(conn);
 		if (rc)
-			goto again;
+			goto done;
 		if (!list_empty(&conn->mgmtqueue))
 			goto check_mgmt;
 	}
 	spin_unlock_bh(&conn->session->lock);
 	return -ENODATA;
 
-again:
-	if (unlikely(conn->suspend_tx))
-		rc = -ENODATA;
+done:
 	spin_unlock_bh(&conn->session->lock);
 	return rc;
 }
-- 
1.6.2.2

