From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] libiscsi: do not take host lock in queuecommand
Date: Fri, 31 Dec 2010 02:22:21 -0600
Message-ID: <1293783742-8238-5-git-send-email-michaelc@cs.wisc.edu>
References: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0LaIW1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 03:22:27 -0500
In-Reply-To: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_tcp, ib_iser, cxgb*, be2iscsi and bnx2i do not use
the host lock and do not take the session lock against
a irq, so this patch drops the DEF_SCSI_QCMD use. Instead
we just take the session lock and disable bhs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   37 ++++++++++++++-----------------------
 include/scsi/libiscsi.h |    3 ++-
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 434d9ae..f460637 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -505,6 +505,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = task->sc;
+	int oldstate = task->state;
 
 	ISCSI_DBG_SESSION(session, "freeing task itt 0x%x state %d sc %p\n",
 			  task->itt, task->state, task->sc);
@@ -525,10 +526,10 @@ static void iscsi_free_task(struct iscsi_task *task)
 		/* SCSI eh reuses commands to verify us */
 		sc->SCp.ptr = NULL;
 		/*
-		 * queue command may call this to free the task, but
-		 * not have setup the sc callback
+		 * queue command may call this to free the task, so
+		 * it will decide how to return sc to scsi-ml.
 		 */
-		if (sc->scsi_done)
+		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
 			sc->scsi_done(sc);
 	}
 }
@@ -571,7 +572,8 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
 			  task->itt, task->state, task->sc);
 	if (task->state == ISCSI_TASK_COMPLETED ||
 	    task->state == ISCSI_TASK_ABRT_TMF ||
-	    task->state == ISCSI_TASK_ABRT_SESS_RECOV)
+	    task->state == ISCSI_TASK_ABRT_SESS_RECOV ||
+	    task->state == ISCSI_TASK_REQUEUE_SCSIQ)
 		return;
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
 	task->state = state;
@@ -1599,27 +1601,23 @@ enum {
 	FAILURE_SESSION_NOT_READY,
 };
 
-static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
+int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
-	struct Scsi_Host *host;
 	struct iscsi_host *ihost;
 	int reason = 0;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_task *task = NULL;
 
-	sc->scsi_done = done;
 	sc->result = 0;
 	sc->SCp.ptr = NULL;
 
-	host = sc->device->host;
 	ihost = shost_priv(host);
-	spin_unlock(host->host_lock);
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock(&session->lock);
+	spin_lock_bh(&session->lock);
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
@@ -1705,25 +1703,21 @@ static int iscsi_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi
 	}
 
 	session->queued_cmdsn++;
-	spin_unlock(&session->lock);
-	spin_lock(host->host_lock);
+	spin_unlock_bh(&session->lock);
 	return 0;
 
 prepd_reject:
-	sc->scsi_done = NULL;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 reject:
-	spin_unlock(&session->lock);
+	spin_unlock_bh(&session->lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
-	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
-	sc->scsi_done = NULL;
-	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
+	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 fault:
-	spin_unlock(&session->lock);
+	spin_unlock_bh(&session->lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	if (!scsi_bidi_cmnd(sc))
@@ -1732,12 +1726,9 @@ fault:
 		scsi_out(sc)->resid = scsi_out(sc)->length;
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
-	done(sc);
-	spin_lock(host->host_lock);
+	sc->scsi_done(sc);
 	return 0;
 }
-
-DEF_SCSI_QCMD(iscsi_queuecommand)
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
 
 int iscsi_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b81d969..f1ff600 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -89,6 +89,7 @@ enum {
 	ISCSI_TASK_RUNNING,
 	ISCSI_TASK_ABRT_TMF,		/* aborted due to TMF */
 	ISCSI_TASK_ABRT_SESS_RECOV,	/* aborted due to session recovery */
+	ISCSI_TASK_REQUEUE_SCSIQ,	/* qcmd requeueing to scsi-ml */
 };
 
 struct iscsi_r2t_info {
@@ -341,7 +342,7 @@ extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
-extern int iscsi_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *sc);
+extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 
 /*
  * iSCSI host helpers.
-- 
1.7.0.1

