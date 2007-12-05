From: michaelc@cs.wisc.edu
Subject: [PATCH 14/23] clear conn->ctask when task is completed early
Date: Tue,  4 Dec 2007 18:42:28 -0600
Message-ID: <11968153831244-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXLEAnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:09 -0500
In-Reply-To: <1196815382808-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the current ctask is failed early, we legt the conn->ctask pointer
pointing to a invalid task. When the xmit thread would send data for
it, we would then oops.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b17081b..4461317 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -248,13 +248,16 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_cmd_task *ctask)
  */
 static void iscsi_complete_command(struct iscsi_cmd_task *ctask)
 {
-	struct iscsi_session *session = ctask->conn->session;
+	struct iscsi_conn *conn = ctask->conn;
+	struct iscsi_session *session = conn->session;
 	struct scsi_cmnd *sc = ctask->sc;
 
 	ctask->state = ISCSI_TASK_COMPLETED;
 	ctask->sc = NULL;
 	/* SCSI eh reuses commands to verify us */
 	sc->SCp.ptr = NULL;
+	if (conn->ctask == ctask)
+		conn->ctask = NULL;
 	list_del_init(&ctask->running);
 	__kfifo_put(session->cmdpool.queue, (void*)&ctask, sizeof(void*));
 	sc->scsi_done(sc);
-- 
1.5.1.2

