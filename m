From: michaelc@cs.wisc.edu
Subject: [PATCH 13/13] libiscsi: add debug printks for iscsi command completion path
Date: Wed, 13 May 2009 17:57:50 -0500
Message-ID: <12422554774004-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
 <12422554742374-git-send-email-michaelc@cs.wisc.edu>
 <12422554743206-git-send-email-michaelc@cs.wisc.edu>
 <12422554752623-git-send-email-michaelc@cs.wisc.edu>
 <12422554753201-git-send-email-michaelc@cs.wisc.edu>
 <12422554764013-git-send-email-michaelc@cs.wisc.edu>
 <12422554763029-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065AbZEMW57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:59 -0400
In-Reply-To: <12422554763029-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch just adds some debug statements for the abort
and completion paths.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b00be6c..59908ae 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -393,10 +393,12 @@ static void iscsi_free_task(struct iscsi_task *task)
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
 
+	ISCSI_DBG_SESSION(session, "freeing task itt 0x%x state %d sc %p\n",
+			  task->itt, task->state, task->sc);
+
 	session->tt->cleanup_task(task);
 	task->state = ISCSI_TASK_FREE;
 	task->sc = NULL;
-
 	/*
 	 * login task is preallocated so do not free
 	 */
@@ -451,6 +453,9 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 {
 	struct iscsi_conn *conn = task->conn;
 
+	ISCSI_DBG_SESSION(conn->session,
+			  "complete task itt 0x%x state %d sc %p\n",
+			  task->itt, task->state, task->sc);
 	if (task->state == ISCSI_TASK_COMPLETED ||
 	    task->state == ISCSI_TASK_ABRT_TMF ||
 	    task->state == ISCSI_TASK_ABRT_SESS_RECOV)
@@ -1836,6 +1841,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
 
+	ISCSI_DBG_SESSION(session, "aborting sc %p\n", sc);
+
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	/*
@@ -1858,6 +1865,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	    sc->SCp.phase != session->age) {
 		spin_unlock_bh(&session->lock);
 		mutex_unlock(&session->eh_mutex);
+		ISCSI_DBG_SESSION(session, "failing abort due to dropped "
+				  "session.\n");
 		return FAILED;
 	}
 
-- 
1.5.2.1

