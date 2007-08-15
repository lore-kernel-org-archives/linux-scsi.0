From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] libiscsi: fix null ptr regression when aborting a command with data to transfer
Date: Wed, 15 Aug 2007 01:38:29 -0500
Message-ID: <11871599112120-git-send-email-michaelc@cs.wisc.edu>
References: <11871599101926-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXHOGig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 02:38:36 -0400
In-Reply-To: <11871599101926-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We do not want to send data if we are aborting a task. There is
a check in iscsi_xmit_ctask, but right before calling this we overwrite
the state so we always go right past the test. Sending data causes problems
because when we clean up from a successful abort the LLD assumes that
the task is not running.

The patch was made over scsi-rc-fixes. If there is time left for bug fixes
for 2.6.23 please add this. It is small and it fixes a regression added
in the 2.6.22 patches.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5606d1e..f5915d4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -737,12 +737,19 @@ check_mgmt:
 		 */
 		conn->ctask = list_entry(conn->xmitqueue.next,
 					 struct iscsi_cmd_task, running);
-		if (conn->ctask->state == ISCSI_TASK_PENDING) {
+		switch (conn->ctask->state) {
+		case ISCSI_TASK_ABORTING:
+			break;
+		case ISCSI_TASK_PENDING:
 			iscsi_prep_scsi_cmd_pdu(conn->ctask);
 			conn->session->tt->init_cmd_task(conn->ctask);
+			/* fall through */
+		default:
+			conn->ctask->state = ISCSI_TASK_RUNNING;
+			break;
 		}
-		conn->ctask->state = ISCSI_TASK_RUNNING;
 		list_move_tail(conn->xmitqueue.next, &conn->run_list);
+
 		rc = iscsi_xmit_ctask(conn);
 		if (rc)
 			goto again;
-- 
1.5.1.2

