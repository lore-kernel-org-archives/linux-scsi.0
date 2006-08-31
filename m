From: michaelc@cs.wisc.edu
Subject: [PATCH 10/12] libiscsi: check that command ptr is set before accessing it
Date: Thu, 31 Aug 2006 18:09:33 -0400
Message-ID: <11570621871297-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu> <11570621832165-git-send-email-michaelc@cs.wisc.edu> <1157062184454-git-send-email-michaelc@cs.wisc.edu> <11570621852186-git-send-email-michaelc@cs.wisc.edu> <1157062186420-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35974 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932413AbWHaXJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:31 -0400
In-Reply-To: <1157062186420-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the scsi eh sends a TUR and the session is down we could
return SCSI_ML_HOST_BUSY. scsi eh will ignore this and send
ask us to abort the command and we blindly accesst the
command ptr.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9387624..1799dc8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -192,6 +192,8 @@ static void iscsi_complete_command(struc
 
 	ctask->state = ISCSI_TASK_COMPLETED;
 	ctask->sc = NULL;
+	/* SCSI eh reuses commands to verify us */
+	sc->SCp.ptr = NULL;
 	list_del_init(&ctask->running);
 	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
 	sc->scsi_done(sc);
@@ -737,6 +739,7 @@ int iscsi_queuecommand(struct scsi_cmnd 
 
 	sc->scsi_done = done;
 	sc->result = 0;
+	sc->SCp.ptr = NULL;
 
 	host = sc->device->host;
 	session = iscsi_hostdata(host->hostdata);
@@ -801,9 +804,10 @@ int iscsi_queuecommand(struct scsi_cmnd 
 
 	list_add_tail(&ctask->running, &conn->xmitqueue);
 	debug_scsi(
-	       "ctask enq [%s cid %d sc %lx itt 0x%x len %d cmdsn %d win %d]\n",
+	       "ctask enq [%s cid %d sc %p cdb 0x%x itt 0x%x len %d cmdsn %d "
+		"win %d]\n",
 		sc->sc_data_direction == DMA_TO_DEVICE ? "write" : "read",
-		conn->id, (long)sc, ctask->itt, sc->request_bufflen,
+		conn->id, sc, sc->cmnd[0], ctask->itt, sc->request_bufflen,
 		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	spin_unlock(&session->lock);
 
@@ -1134,11 +1138,24 @@ static void fail_command(struct iscsi_co
 
 int iscsi_eh_abort(struct scsi_cmnd *sc)
 {
-	struct iscsi_cmd_task *ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
-	struct iscsi_conn *conn = ctask->conn;
-	struct iscsi_session *session = conn->session;
+	struct iscsi_cmd_task *ctask;
+	struct iscsi_conn *conn;
+	struct iscsi_session *session;
 	int rc;
 
+	/*
+	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
+	 * got the command.
+	 */
+	if (!sc->SCp.ptr) {
+		debug_scsi("sc never reached iscsi layer or it completed.\n");
+		return SUCCESS;
+	}
+
+	ctask = (struct iscsi_cmd_task *)sc->SCp.ptr;
+	conn = ctask->conn;
+	session = conn->session;
+
 	conn->eh_abort_cnt++;
 	debug_scsi("aborting [sc %p itt 0x%x]\n", sc, ctask->itt);
 
-- 
1.4.1.1

