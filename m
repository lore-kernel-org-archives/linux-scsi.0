From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] iscsi_tcp: add new conn error to indicate tcp conn closed
Date: Thu, 20 Aug 2009 15:11:02 -0500
Message-ID: <1250799063-1843-7-git-send-email-michaelc@cs.wisc.edu>
References: <1250799063-1843-1-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-2-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-3-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-4-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-5-git-send-email-michaelc@cs.wisc.edu>
 <1250799063-1843-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbZHTUL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 16:11:28 -0400
In-Reply-To: <1250799063-1843-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If a target closed the connection, we will detect it in the
state_changed or data_ready callout. This adds a new conn
error value to use for this problem, so it is not confused
with when the initiator throws a conn error and drops
the connection.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   23 +++++++++--------------
 include/scsi/iscsi_if.h  |    1 +
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c7e2ff2..2b1b834 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -109,11 +109,14 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
  */
 static inline int iscsi_sw_sk_state_check(struct sock *sk)
 {
-	if ((sk->sk_state == TCP_CLOSE_WAIT ||
-	     sk->sk_state == TCP_CLOSE) &&
-	    !atomic_read(&sk->sk_rmem_alloc))
-		return -ECONNRESET;
+	struct iscsi_conn *conn = (struct iscsi_conn*)sk->sk_user_data;
 
+	if ((sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) &&
+	    !atomic_read(&sk->sk_rmem_alloc)) {
+		ISCSI_SW_TCP_DBG(conn, "TCP_CLOSE|TCP_CLOSE_WAIT\n");
+		iscsi_conn_failure(conn, ISCSI_ERR_TCP_CONN_CLOSE);
+		return -ECONNRESET;
+	}
 	return 0;
 }
 
@@ -135,11 +138,7 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 	rd_desc.count = 1;
 	tcp_read_sock(sk, &rd_desc, iscsi_sw_tcp_recv);
 
-	if (iscsi_sw_sk_state_check(sk) < 0) {
-		ISCSI_SW_TCP_DBG(conn, "iscsi_tcp_data_ready: "
-				 "TCP_CLOSE|TCP_CLOSE_WAIT\n");
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-	}
+	iscsi_sw_sk_state_check(sk);
 
 	read_unlock(&sk->sk_callback_lock);
 
@@ -161,11 +160,7 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 	conn = (struct iscsi_conn*)sk->sk_user_data;
 	session = conn->session;
 
-	if (iscsi_sw_sk_state_check(sk) < 0) {
-		ISCSI_SW_TCP_DBG(conn, "iscsi_tcp_state_change: "
-				 "TCP_CLOSE|TCP_CLOSE_WAIT\n");
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-	}
+	iscsi_sw_sk_state_check(sk);
 
 	tcp_conn = conn->dd_data;
 	tcp_sw_conn = tcp_conn->dd_data;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 4426f00..d67dda2 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -262,6 +262,7 @@ enum iscsi_err {
 	ISCSI_ERR_NO_SCSI_CMD		= ISCSI_ERR_BASE + 17,
 	ISCSI_ERR_INVALID_HOST		= ISCSI_ERR_BASE + 18,
 	ISCSI_ERR_XMIT_FAILED		= ISCSI_ERR_BASE + 19,
+	ISCSI_ERR_TCP_CONN_CLOSE	= ISCSI_ERR_BASE + 20,
 };
 
 /*
-- 
1.6.2.2

