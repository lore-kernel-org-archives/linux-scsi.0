From: michaelc@cs.wisc.edu
Subject: [PATCH 13/24] Do not fail commands immediately during logout
Date: Thu, 13 Dec 2007 12:43:32 -0600
Message-ID: <11975714413336-git-send-email-michaelc@cs.wisc.edu>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759612AbXLMSoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:10 -0500
In-Reply-To: <11975714404116-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the target requests a logout, then we do not want
to fail commands to scsi-ml right away. This patch just
fails in pending commands for a requeue immediately, and then lets
iscsid handle running commands like normal recovery.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9688361..b17081b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -917,7 +917,7 @@ check_mgmt:
 		conn->ctask = list_entry(conn->xmitqueue.next,
 					 struct iscsi_cmd_task, running);
 		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
-			fail_command(conn, conn->ctask, DID_NO_CONNECT << 16);
+			fail_command(conn, conn->ctask, DID_IMM_RETRY << 16);
 			continue;
 		}
 		if (iscsi_prep_scsi_cmd_pdu(conn->ctask)) {
@@ -1024,21 +1024,19 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		 * be entering our queuecommand while a block is starting
 		 * up because the block code is not locked)
 		 */
-		if (session->state == ISCSI_STATE_IN_RECOVERY) {
+		switch (session->state) {
+		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
 			goto reject;
-		}
-
-		switch (session->state) {
+		case ISCSI_STATE_LOGGING_OUT:
+			reason = FAILURE_SESSION_LOGGING_OUT;
+			goto reject;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
 			break;
 		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
 			break;
-		case ISCSI_STATE_LOGGING_OUT:
-			reason = FAILURE_SESSION_LOGGING_OUT;
-			break;
 		default:
 			reason = FAILURE_SESSION_FREED;
 		}
-- 
1.5.1.2

