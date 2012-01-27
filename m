From: michaelc@cs.wisc.edu
Subject: [PATCH 3/3] libiscsi: fix cmd timeout/completion race
Date: Thu, 26 Jan 2012 21:13:11 -0600
Message-ID: <1327633991-2615-4-git-send-email-michaelc@cs.wisc.edu>
References: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab2A0DEs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 22:04:48 -0500
In-Reply-To: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the driver/lib has called scsi_done and cleaned up internally but
scsi layer has not yet called blk_mark_rq_complete when the command
times out we hit a problem if the timeout code calls blk_mark_rq_complete first.
When the time out code calls into the driver we were returning
BLK_EH_RESET_TIMER and that causes the timeout code to just call
us again later.

We need to be calling BLK_EH_HANDLED so the timeout code can complete
the completion process because it had called blk_mark_rq_complete
on the command and now owns its processing.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 911a4a9..b189227 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1909,6 +1909,16 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
 
 	spin_lock(&session->lock);
+	task = (struct iscsi_task *)sc->SCp.ptr;
+	if (!task) {
+		/*
+		 * Raced with completion. Blk layer has taken ownership
+		 * so let timeout code complete it now.
+		 */
+		rc = BLK_EH_HANDLED;
+		goto done;
+	}
+
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		/*
 		 * We are probably in the middle of iscsi recovery so let
@@ -1925,16 +1935,6 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		goto done;
 	}
 
-	task = (struct iscsi_task *)sc->SCp.ptr;
-	if (!task) {
-		/*
-		 * Raced with completion. Just reset timer, and let it
-		 * complete normally
-		 */
-		rc = BLK_EH_RESET_TIMER;
-		goto done;
-	}
-
 	/*
 	 * If we have sent (at least queued to the network layer) a pdu or
 	 * recvd one for the task since the last timeout ask for
-- 
1.7.6

