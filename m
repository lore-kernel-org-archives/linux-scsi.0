From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] iscsi_tcp: fix locking around iscsi sk user data
Date: Fri, 24 Jun 2011 15:11:54 -0500
Message-ID: <1308946315-9240-4-git-send-email-michaelc@cs.wisc.edu>
References: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab1FXUKS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 16:10:18 -0400
In-Reply-To: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_sw_tcp_conn_restore_callbacks could have set
the sk_user_data field to NULL then iscsi_sw_tcp_data_ready
could read that and try to access the NULL pointer. This
adds some checks for NULL sk_user_data in the sk
callback functions and it uses the sk_callback_lock to
set/get that sk_user_data field.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   61 +++++++++++++++++++++++++++++++---------------
 1 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 3df9853..7724414 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -107,10 +107,12 @@ static int iscsi_sw_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
  * If the socket is in CLOSE or CLOSE_WAIT we should
  * not close the connection if there is still some
  * data pending.
+ *
+ * Must be called with sk_callback_lock.
  */
 static inline int iscsi_sw_sk_state_check(struct sock *sk)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn*)sk->sk_user_data;
+	struct iscsi_conn *conn = sk->sk_user_data;
 
 	if ((sk->sk_state == TCP_CLOSE_WAIT || sk->sk_state == TCP_CLOSE) &&
 	    !atomic_read(&sk->sk_rmem_alloc)) {
@@ -123,11 +125,17 @@ static inline int iscsi_sw_sk_state_check(struct sock *sk)
 
 static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 {
-	struct iscsi_conn *conn = sk->sk_user_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_conn *conn;
+	struct iscsi_tcp_conn *tcp_conn;
 	read_descriptor_t rd_desc;
 
 	read_lock(&sk->sk_callback_lock);
+	conn = sk->sk_user_data;
+	if (!conn) {
+		read_unlock(&sk->sk_callback_lock);
+		return;
+	}
+	tcp_conn = conn->dd_data;
 
 	/*
 	 * Use rd_desc to pass 'conn' to iscsi_tcp_recv.
@@ -141,11 +149,10 @@ static void iscsi_sw_tcp_data_ready(struct sock *sk, int flag)
 
 	iscsi_sw_sk_state_check(sk);
 
-	read_unlock(&sk->sk_callback_lock);
-
 	/* If we had to (atomically) map a highmem page,
 	 * unmap it now. */
 	iscsi_tcp_segment_unmap(&tcp_conn->in.segment);
+	read_unlock(&sk->sk_callback_lock);
 }
 
 static void iscsi_sw_tcp_state_change(struct sock *sk)
@@ -157,8 +164,11 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
 	void (*old_state_change)(struct sock *);
 
 	read_lock(&sk->sk_callback_lock);
-
-	conn = (struct iscsi_conn*)sk->sk_user_data;
+	conn = sk->sk_user_data;
+	if (!conn) {
+		read_unlock(&sk->sk_callback_lock);
+		return;
+	}
 	session = conn->session;
 
 	iscsi_sw_sk_state_check(sk);
@@ -178,11 +188,25 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
  **/
 static void iscsi_sw_tcp_write_space(struct sock *sk)
 {
-	struct iscsi_conn *conn = (struct iscsi_conn*)sk->sk_user_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct iscsi_conn *conn;
+	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
+	void (*old_write_space)(struct sock *);
+
+	read_lock_bh(&sk->sk_callback_lock);
+	conn = sk->sk_user_data;
+	if (!conn) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		return;
+	}
+
+	tcp_conn = conn->dd_data;
+	tcp_sw_conn = tcp_conn->dd_data;
+	old_write_space = tcp_sw_conn->old_write_space;
+	read_unlock_bh(&sk->sk_callback_lock);
+
+	old_write_space(sk);
 
-	tcp_sw_conn->old_write_space(sk);
 	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
 	iscsi_conn_queue_work(conn);
 }
@@ -592,20 +616,17 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	/* userspace may have goofed up and not bound us */
 	if (!sock)
 		return;
-	/*
-	 * Make sure our recv side is stopped.
-	 * Older tools called conn stop before ep_disconnect
-	 * so IO could still be coming in.
-	 */
-	write_lock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 
 	sock->sk->sk_err = EIO;
 	wake_up_interruptible(sk_sleep(sock->sk));
 
-	iscsi_conn_stop(cls_conn, flag);
+	/* stop xmit side */
+	iscsi_suspend_tx(conn);
+
+	/* stop recv side and release socket */
 	iscsi_sw_tcp_release_conn(conn);
+
+	iscsi_conn_stop(cls_conn, flag);
 }
 
 static int
-- 
1.7.2.3

