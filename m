From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] libiscsi: fix login/text checks in pdu injection code
Date: Wed, 11 Nov 2009 16:34:31 -0600
Message-ID: <1257978876-2742-3-git-send-email-michaelc@cs.wisc.edu>
References: <1257978876-2742-1-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464AbZKKWek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 17:34:40 -0500
In-Reply-To: <1257978876-2742-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

For some reason we used to check for the the immediate bit
set and the opcocde in many places instead of just masking
the opcode. In the passthrough code this is a problem
because userspace may or may not have set the immediate bit
and it does not have to. This fixes up the opcode checks
in the passthrough code, so we mask off the opcode then
check against the iscsi proto definition like is done in
other places.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 67d0f3f..8c29480 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -577,12 +577,12 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	struct iscsi_session *session = conn->session;
 	struct iscsi_hdr *hdr = task->hdr;
 	struct iscsi_nopout *nop = (struct iscsi_nopout *)hdr;
+	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 
 	if (conn->session->state == ISCSI_STATE_LOGGING_OUT)
 		return -ENOTCONN;
 
-	if (hdr->opcode != (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) &&
-	    hdr->opcode != (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
+	if (opcode != ISCSI_OP_LOGIN && opcode != ISCSI_OP_TEXT)
 		nop->exp_statsn = cpu_to_be32(conn->exp_statsn);
 	/*
 	 * pre-format CmdSN for outgoing PDU.
@@ -590,9 +590,12 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	nop->cmdsn = cpu_to_be32(session->cmdsn);
 	if (hdr->itt != RESERVED_ITT) {
 		/*
-		 * TODO: We always use immediate, so we never hit this.
+		 * TODO: We always use immediate for normal session pdus.
 		 * If we start to send tmfs or nops as non-immediate then
 		 * we should start checking the cmdsn numbers for mgmt tasks.
+		 *
+		 * During discovery sessions iscsid sends TEXT as non immediate,
+		 * but we always only send one PDU at a time.
 		 */
 		if (conn->c_stage == ISCSI_CONN_STARTED &&
 		    !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
@@ -620,22 +623,28 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_host *ihost = shost_priv(session->host);
+	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
 
 	if (session->state == ISCSI_STATE_TERMINATE)
 		return NULL;
 
-	if (hdr->opcode == (ISCSI_OP_LOGIN | ISCSI_OP_IMMEDIATE) ||
-	    hdr->opcode == (ISCSI_OP_TEXT | ISCSI_OP_IMMEDIATE))
+	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
 		/*
 		 * Login and Text are sent serially, in
 		 * request-followed-by-response sequence.
 		 * Same task can be used. Same ITT must be used.
 		 * Note that login_task is preallocated at conn_create().
 		 */
+		if (conn->login_task->state != ISCSI_TASK_FREE) {
+			iscsi_conn_printk(KERN_ERR, conn, "Login/Text in "
+					  "progress. Cannot start new task.\n");
+			return NULL;
+		}
+
 		task = conn->login_task;
-	else {
+	} else {
 		if (session->state != ISCSI_STATE_LOGGED_IN)
 			return NULL;
 
-- 
1.6.2.2

