From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libiscsi regression in 2.6.25: fix nop timer handling
Date: Wed,  7 May 2008 20:43:52 -0500
Message-ID: <1210211032-4590-2-git-send-email-michaelc@cs.wisc.edu>
References: <1210211032-4590-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbYEHBn4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 21:43:56 -0400
In-Reply-To: <1210211032-4590-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The following patch fixes a bug in the iscsi nop processing.
The target sends iscsi nops to ping the initiator and the
initiator has to send nops to reply and can send nops to
ping the target.

In 2.6.25 we moved the nop processing to the kernel to handle
problems when the userspace daemon is not up, but the target
is pinging us, and to handle when scsi commands timeout, but
the transport may be the cause (we can send a nop to check
the transport). When we added this code we added a bug where
if the transport timer wakes at the exact same time we are supposed to check
for a nop timeout we drop the session instead of checking the transport.

This patch checks if a iscsi ping is outstanding and if the ping has
timed out, to determine if we need to signal a connection problem.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 010c1b9..98164f3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1453,19 +1453,20 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 {
 	struct iscsi_conn *conn = (struct iscsi_conn *)data;
 	struct iscsi_session *session = conn->session;
-	unsigned long timeout, next_timeout = 0, last_recv;
+	unsigned long recv_timeout, next_timeout = 0, last_recv;
 
 	spin_lock(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN)
 		goto done;
 
-	timeout = conn->recv_timeout;
-	if (!timeout)
+	recv_timeout = conn->recv_timeout;
+	if (!recv_timeout)
 		goto done;
 
-	timeout *= HZ;
+	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
-	if (time_before_eq(last_recv + timeout + (conn->ping_timeout * HZ),
+	if (conn->ping_mtask &&
+	    time_before_eq(conn->last_ping + (conn->ping_timeout * HZ),
 			   jiffies)) {
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
 				  "expired, last rx %lu, last ping %lu, "
@@ -1476,15 +1477,15 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 		return;
 	}
 
-	if (time_before_eq(last_recv + timeout, jiffies)) {
+	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
 		if (time_before_eq(conn->last_ping, last_recv)) {
 			/* send a ping to try to provoke some traffic */
 			debug_scsi("Sending nopout as ping on conn %p\n", conn);
 			iscsi_send_nopout(conn, NULL);
 		}
-		next_timeout = last_recv + timeout + (conn->ping_timeout * HZ);
+		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
-		next_timeout = last_recv + timeout;
+		next_timeout = last_recv + recv_timeout;
 
 	debug_scsi("Setting next tmo %lu\n", next_timeout);
 	mod_timer(&conn->transport_timer, next_timeout);
-- 
1.5.4.1

