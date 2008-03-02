From: michaelc@cs.wisc.edu
Subject: [PATCH 5/9] libiscsi: use iscsi queueing helper.
Date: Sun,  2 Mar 2008 03:03:18 -0600
Message-ID: <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYCBJEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:10 -0500
In-Reply-To: <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Convert libiscsi to use new helper.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 156ec1a..1ee1cc9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1000,7 +1000,7 @@ enum {
 int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *host;
-	int reason = 0;
+	int reason = 0, err = 0;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_cmd_task *ctask = NULL;
@@ -1014,12 +1014,13 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	session = iscsi_hostdata(host->hostdata);
 	spin_lock(&session->lock);
-
-	reason = iscsi_session_chkready(session_to_cls(session));
-	if (reason) {
-		sc->result = reason;
-		goto fault;
+	err = iscsi_session_queue_ready(session_to_cls(session), sc);
+	if (err) {
+		reason = FAILURE_SESSION_NOT_READY;
+		goto reject;
 	}
+	if (sc->result)
+		goto fault;
 
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
@@ -1032,6 +1033,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		case ISCSI_STATE_FAILED:
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
+			err = SCSI_MLQUEUE_TARGET_BUSY;
 			goto reject;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
@@ -1061,12 +1063,14 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	if (iscsi_check_cmdsn_window_closed(conn)) {
 		reason = FAILURE_WINDOW_CLOSED;
+		err = SCSI_MLQUEUE_TARGET_BUSY;
 		goto reject;
 	}
 
 	if (!__kfifo_get(session->cmdpool.queue, (void*)&ctask,
 			 sizeof(void*))) {
 		reason = FAILURE_OOM;
+		err = SCSI_MLQUEUE_TARGET_BUSY;
 		goto reject;
 	}
 	session->queued_cmdsn++;
@@ -1091,7 +1095,7 @@ reject:
 	spin_unlock(&session->lock);
 	debug_scsi("cmd 0x%x rejected (%d)\n", sc->cmnd[0], reason);
 	spin_lock(host->host_lock);
-	return SCSI_MLQUEUE_TARGET_BUSY;
+	return err;
 
 fault:
 	spin_unlock(&session->lock);
-- 
1.5.4.1

