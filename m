From: michaelc@cs.wisc.edu
Subject: [PATCH 3/6] libiscsi: reset cmd timer if cmds are making progress
Date: Wed, 10 Feb 2010 16:51:45 -0600
Message-ID: <1265842308-2051-4-git-send-email-michaelc@cs.wisc.edu>
References: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-2-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0BJWuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:50:10 -0500
In-Reply-To: <1265842308-2051-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch resets the cmd timer if cmds started before
the timedout command are making progress. The idea is
that the cmd probably timed out because we are trying
to exeucte too many commands. If it turns out that the
device the IO timedout on was bad or the cmd just got
screwed up but other IO/devs were ok then we will
will figure this out when the cmds ahead of the timed
out one complete ok.

This also fixes a bug where we were sort of detecting
this by setting the last_timeout and last_xfer to the
same value when the task was allocated. That caught
the case where we never got to send any IO for it. However,
if the problem had started right before we started the
new task, then we were forced to wait an extra cmd
timeout seconds to start the scsi eh.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   53 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c28a712..703eb6a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1919,10 +1919,11 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	enum blk_eh_timer_return rc = BLK_EH_NOT_HANDLED;
-	struct iscsi_task *task = NULL;
+	struct iscsi_task *task = NULL, *running_task;
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
+	int i;
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -1947,8 +1948,15 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	}
 
 	task = (struct iscsi_task *)sc->SCp.ptr;
-	if (!task)
+	if (!task) {
+		/*
+		 * Raced with completion. Just reset timer, and let it
+		 * complete normally
+		 */
+		rc = BLK_EH_RESET_TIMER;
 		goto done;
+	}
+
 	/*
 	 * If we have sent (at least queued to the network layer) a pdu or
 	 * recvd one for the task since the last timeout ask for
@@ -1956,10 +1964,10 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	 * we can check if it is the task or connection when we send the
 	 * nop as a ping.
 	 */
-	if (time_after_eq(task->last_xfer, task->last_timeout)) {
+	if (time_after(task->last_xfer, task->last_timeout)) {
 		ISCSI_DBG_EH(session, "Command making progress. Asking "
 			     "scsi-ml for more time to complete. "
-			     "Last data recv at %lu. Last timeout was at "
+			     "Last data xfer at %lu. Last timeout was at "
 			     "%lu\n.", task->last_xfer, task->last_timeout);
 		task->have_checked_conn = false;
 		rc = BLK_EH_RESET_TIMER;
@@ -1977,6 +1985,43 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		goto done;
 	}
 
+	for (i = 0; i < conn->session->cmds_max; i++) {
+		running_task = conn->session->cmds[i];
+		if (!running_task->sc || running_task == task ||
+		     running_task->state != ISCSI_TASK_RUNNING)
+			continue;
+
+		/*
+		 * Only check if cmds started before this one have made
+		 * progress, or this could never fail
+		 */
+		if (time_after(running_task->sc->jiffies_at_alloc,
+			       task->sc->jiffies_at_alloc))
+			continue;
+
+		if (time_after(running_task->last_xfer, task->last_timeout)) {
+			/*
+			 * This task has not made progress, but a task
+			 * started before us has transferred data since
+			 * we started/last-checked. We could be queueing
+			 * too many tasks or the LU is bad.
+			 *
+			 * If the device is bad the cmds ahead of us on
+			 * other devs will complete, and this loop will
+			 * eventually fail starting the scsi eh.
+			 */
+			ISCSI_DBG_EH(session, "Command has not made progress "
+				     "but commands ahead of it have. "
+				     "Asking scsi-ml for more time to "
+				     "complete. Our last xfer vs running task "
+				     "last xfer %lu/%lu. Last check %lu.\n",
+				     task->last_xfer, running_task->last_xfer,
+				     task->last_timeout);
+			rc = BLK_EH_RESET_TIMER;
+			goto done;
+		}
+	}
+
 	/* Assumes nop timeout is shorter than scsi cmd timeout */
 	if (task->have_checked_conn)
 		goto done;
-- 
1.6.6

