From: michaelc@cs.wisc.edu
Subject: [PATCH 1/7] iscsi_tcp: Evaluate socket state in data_ready()
Date: Thu, 20 Aug 2009 15:10:57 -0500
Message-ID: <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
References: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbZHTULI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:08 -0400
In-Reply-To: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

From: Hannes Reinecke <hare@suse.de>

The network core will call the state_change() callback
prior to the data_ready() callback, which might cause
us to lose a connection state change.
So we have to evaluate the socket state at the end
of the data_ready() callback, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 518dbd9..c7e2ff2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -99,6 +99,24 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 	return total_consumed;
 }
 
+/**
+ * iscsi_sw_sk_state_check - check socket state
+ * @sk: socket
+ *
+ * If the socket is in CLOSE or CLOSE_WAIT we should
+ * not close the connection if there is still some
+ * data pending.
+ */
+static inline int iscsi_sw_sk_state_check(struct sock *sk)
+{
+	if ((sk->sk_state == TCP_CLOSE_WAIT ||
+	     sk->sk_state == TCP_CLOSE) &&
+	    !atomic_read(&sk->sk_rmem_alloc))
+		return -ECONNRESET;
+
+	return 0;
+}
+
 static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 {
 	struct iscsi_conn *conn = sk->sk_user_data;
@@ -117,6 +135,12 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 	rd_desc.count = 1;
 	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
 
+	if (iscsi_sw_sk_state_check(sk) < 0) {
+		ISCSI_SW_TCP_DBG(conn, "iscsi_tcp_data_ready: "
+				 "TCP_CLOSE|TCP_CLOSE_WAIT\n");
+		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	}
+
 	read_unlock(&sk->sk_callback_lock);
 
 	/* If we had to (atomically) map a highmem page,
@@ -137,9 +161,7 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 	conn = (struct iscsi_conn*)sk->sk_user_data;
 	session = conn->session;
 
-	if ((sk->sk_state == TCP_CLOSE_WAIT ||
-	     sk->sk_state == TCP_CLOSE) &&
-	    !atomic_read(&sk->sk_rmem_alloc)) {
+	if (iscsi_sw_sk_state_check(sk) < 0) {
 		ISCSI_SW_TCP_DBG(conn, "iscsi_tcp_state_change: "
 				 "TCP_CLOSE|TCP_CLOSE_WAIT\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-- 
1.6.2.2

