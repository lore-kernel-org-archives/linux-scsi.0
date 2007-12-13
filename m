From: michaelc@cs.wisc.edu
Subject: [PATCH 14/24] clear conn->ctask when task is completed early
Date: Thu, 13 Dec 2007 12:43:33 -0600
Message-ID: <1197571442630-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
 <11975714363904-git-send-email-michaelc@cs.wisc.edu>
 <11975714372848-git-send-email-michaelc@cs.wisc.edu>
 <11975714382641-git-send-email-michaelc@cs.wisc.edu>
 <11975714404116-git-send-email-michaelc@cs.wisc.edu>
 <11975714413336-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319AbXLMSoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:11 -0500
In-Reply-To: <11975714413336-git-send-email-michaelc@cs.wisc.edu>
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

