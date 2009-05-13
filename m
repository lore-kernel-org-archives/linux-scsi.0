From: michaelc@cs.wisc.edu
Subject: [PATCH 08/13] libiscsi: fix iscsi transport checks to account for slower links
Date: Wed, 13 May 2009 17:57:45 -0500
Message-ID: <12422554743206-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
 <12422554742374-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762081AbZEMW54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:56 -0400
In-Reply-To: <12422554742374-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we have not got any pdus for recv_timeout seconds, then we will
send a iscsi ping/nop to make sure the target is still around. The
problem is if this is a slow link, and the ping got queued after
the data for a data_out (read), then the transport code could think
the ping has failed when it is just slowly making its way through
the network. This patch has us check if we are making progress while
the nop is outstanding. If we are still reading in data, then we
do not fail the session at that time.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 212fe20..c648bd3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1677,6 +1677,22 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 		iscsi_conn_queue_work(conn);
 }
 
+/*
+ * We want to make sure a ping is in flight. It has timed out.
+ * And we are not busy processing a pdu that is making
+ * progress but got started before the ping and is taking a while
+ * to complete so the ping is just stuck behind it in a queue.
+ */
+static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
+{
+	if (conn->ping_task &&
+	    time_before_eq(conn->last_recv + (conn->recv_timeout * HZ) +
+			   (conn->ping_timeout * HZ), jiffies))
+		return 1;
+	else
+		return 0;
+}
+
 static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 {
 	struct iscsi_cls_session *cls_session;
@@ -1712,16 +1728,20 @@ static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 	 * if the ping timedout then we are in the middle of cleaning up
 	 * and can let the iscsi eh handle it
 	 */
-	if (time_before_eq(conn->last_recv + (conn->recv_timeout * HZ) +
-			    (conn->ping_timeout * HZ), jiffies))
+	if (iscsi_has_ping_timed_out(conn)) {
 		rc = BLK_EH_RESET_TIMER;
+		goto done;
+	}
 	/*
 	 * if we are about to check the transport then give the command
 	 * more time
 	 */
 	if (time_before_eq(conn->last_recv + (conn->recv_timeout * HZ),
-			   jiffies))
+			   jiffies)) {
 		rc = BLK_EH_RESET_TIMER;
+		goto done;
+	}
+
 	/* if in the middle of checking the transport then give us more time */
 	if (conn->ping_task)
 		rc = BLK_EH_RESET_TIMER;
@@ -1748,13 +1768,13 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 
 	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
-	if (conn->ping_task &&
-	    time_before_eq(conn->last_ping + (conn->ping_timeout * HZ),
-			   jiffies)) {
+
+	if (iscsi_has_ping_timed_out(conn)) {
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
-				  "expired, last rx %lu, last ping %lu, "
-				  "now %lu\n", conn->ping_timeout, last_recv,
-				  conn->last_ping, jiffies);
+				  "expired, recv timeout %d, last rx %lu, "
+				  "last ping %lu, now %lu\n",
+				  conn->ping_timeout, conn->recv_timeout,
+				  last_recv, conn->last_ping, jiffies);
 		spin_unlock(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		return;
-- 
1.5.2.1

