From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/11] iscsi bugfixes: fix oops when iser is flushing io
Date: Mon, 24 Jul 2006 15:47:26 -0500
Message-ID: <1153774046.1040.36.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:16576 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932162AbWGXUtI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:49:08 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKmlXE012547
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:49:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When we enter recovery and flush the running commands
we cannot freee the connection before flushing the commands.
Some commands may have a reference to the connection
that needs to be released before. iscsi_stop was forcing
the term and suspend too early and was causing a oops
in iser, so this patch removes those callbacks all together
and allows the LLD to handle that detail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 34b0da5..1437d7e 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -378,21 +378,6 @@ iscsi_iser_conn_start(struct iscsi_cls_c
 	return iser_conn_set_full_featured_mode(conn);
 }
 
-static void
-iscsi_iser_conn_terminate(struct iscsi_conn *conn)
-{
-	struct iscsi_iser_conn *iser_conn = conn->dd_data;
-	struct iser_conn *ib_conn = iser_conn->ib_conn;
-
-	BUG_ON(!ib_conn);
-	/* starts conn teardown process, waits until all previously   *
-	 * posted buffers get flushed, deallocates all conn resources */
-	iser_conn_terminate(ib_conn);
-	iser_conn->ib_conn = NULL;
-	conn->recv_lock = NULL;
-}
-
-
 static struct iscsi_transport iscsi_iser_transport;
 
 static struct iscsi_cls_session *
@@ -555,13 +540,13 @@ iscsi_iser_ep_poll(__u64 ep_handle, int 
 static void
 iscsi_iser_ep_disconnect(__u64 ep_handle)
 {
-	struct iser_conn *ib_conn = iscsi_iser_ib_conn_lookup(ep_handle);
+	struct iser_conn *ib_conn;
 
+	ib_conn = iscsi_iser_ib_conn_lookup(ep_handle);
 	if (!ib_conn)
 		return;
 
 	iser_err("ib conn %p state %d\n",ib_conn, ib_conn->state);
-
 	iser_conn_terminate(ib_conn);
 }
 
@@ -614,9 +599,6 @@ static struct iscsi_transport iscsi_iser
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn             = iscsi_iser_conn_start,
 	.stop_conn              = iscsi_conn_stop,
-	/* these are called as part of conn recovery */
-	.suspend_conn_recv	= NULL, /* FIXME is/how this relvant to iser? */
-	.terminate_conn		= iscsi_iser_conn_terminate,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_iser_conn_get_stats,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7d78459..b6c68be 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1040,9 +1040,8 @@ iscsi_conn_set_callbacks(struct iscsi_co
 }
 
 static void
-iscsi_conn_restore_callbacks(struct iscsi_conn *conn)
+iscsi_conn_restore_callbacks(struct iscsi_tcp_conn *tcp_conn)
 {
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct sock *sk = tcp_conn->sock->sk;
 
 	/* restore socket callbacks, see also: iscsi_conn_set_callbacks() */
@@ -1933,6 +1932,23 @@ tcp_conn_alloc_fail:
 }
 
 static void
+iscsi_tcp_release_conn(struct iscsi_conn *conn)
+{
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+
+	if (!tcp_conn->sock)
+		return;
+
+	sock_hold(tcp_conn->sock->sk);
+	iscsi_conn_restore_callbacks(tcp_conn);
+	sock_put(tcp_conn->sock->sk);
+
+	sock_release(tcp_conn->sock);
+	tcp_conn->sock = NULL;
+	conn->recv_lock = NULL;
+}
+
+static void
 iscsi_tcp_conn_destroy(struct iscsi_cls_conn *cls_conn)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
@@ -1942,6 +1958,7 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 	if (conn->hdrdgst_en || conn->datadgst_en)
 		digest = 1;
 
+	iscsi_tcp_release_conn(conn);
 	iscsi_conn_teardown(cls_conn);
 
 	/* now free tcp_conn */
@@ -1965,6 +1982,15 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 	kfree(tcp_conn);
 }
 
+static void
+iscsi_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+
+	iscsi_conn_stop(cls_conn, flag);
+	iscsi_tcp_release_conn(conn);
+}
+
 static int
 iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		    struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
@@ -2013,38 +2039,6 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 	return 0;
 }
 
-static void
-iscsi_tcp_suspend_conn_rx(struct iscsi_conn *conn)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct sock *sk;
-
-	if (!tcp_conn->sock)
-		return;
-
-	sk = tcp_conn->sock->sk;
-	write_lock_bh(&sk->sk_callback_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	write_unlock_bh(&sk->sk_callback_lock);
-}
-
-static void
-iscsi_tcp_terminate_conn(struct iscsi_conn *conn)
-{
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-
-	if (!tcp_conn->sock)
-		return;
-
-	sock_hold(tcp_conn->sock->sk);
-	iscsi_conn_restore_callbacks(conn);
-	sock_put(tcp_conn->sock->sk);
-
-	sock_release(tcp_conn->sock);
-	tcp_conn->sock = NULL;
-	conn->recv_lock = NULL;
-}
-
 /* called with host lock */
 static void
 iscsi_tcp_mgmt_init(struct iscsi_conn *conn, struct iscsi_mgmt_task *mtask,
@@ -2413,10 +2407,7 @@ static struct iscsi_transport iscsi_tcp_
 	.get_conn_param		= iscsi_tcp_conn_get_param,
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
-	.stop_conn		= iscsi_conn_stop,
-	/* these are called as part of conn recovery */
-	.suspend_conn_recv	= iscsi_tcp_suspend_conn_rx,
-	.terminate_conn		= iscsi_tcp_terminate_conn,
+	.stop_conn		= iscsi_tcp_conn_stop,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
 	.get_stats		= iscsi_conn_get_stats,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4e2ca8f..36f520b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1440,12 +1440,6 @@ void iscsi_conn_teardown(struct iscsi_cl
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	mutex_lock(&conn->xmitmutex);
-	if (conn->c_stage == ISCSI_CONN_INITIAL_STAGE) {
-		if (session->tt->suspend_conn_recv)
-			session->tt->suspend_conn_recv(conn);
-
-		session->tt->terminate_conn(conn);
-	}
 
 	spin_lock_bh(&session->lock);
 	conn->c_stage = ISCSI_CONN_CLEANUP_WAIT;
@@ -1622,8 +1616,9 @@ static void iscsi_start_session_recovery
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	spin_unlock_bh(&session->lock);
 
-	if (session->tt->suspend_conn_recv)
-		session->tt->suspend_conn_recv(conn);
+	write_lock_bh(conn->recv_lock);
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	write_unlock_bh(conn->recv_lock);
 
 	mutex_lock(&conn->xmitmutex);
 	/*
@@ -1642,7 +1637,6 @@ static void iscsi_start_session_recovery
 		}
 	}
 
-	session->tt->terminate_conn(conn);
 	/*
 	 * flush queues.
 	 */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 5a3df1d..39e8332 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -57,8 +57,6 @@ struct sockaddr;
  * @stop_conn:		suspend/recover/terminate connection
  * @send_pdu:		send iSCSI PDU, Login, Logout, NOP-Out, Reject, Text.
  * @session_recovery_timedout: notify LLD a block during recovery timed out
- * @suspend_conn_recv:	susepend the recv side of the connection
- * @termincate_conn:	destroy socket connection. Called with mutex lock.
  * @init_cmd_task:	Initialize a iscsi_cmd_task and any internal structs.
  *			Called from queuecommand with session lock held.
  * @init_mgmt_task:	Initialize a iscsi_mgmt_task and any internal structs.
@@ -112,8 +110,6 @@ struct iscsi_transport {
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
 			   struct iscsi_stats *stats);
-	void (*suspend_conn_recv) (struct iscsi_conn *conn);
-	void (*terminate_conn) (struct iscsi_conn *conn);
 	void (*init_cmd_task) (struct iscsi_cmd_task *ctask);
 	void (*init_mgmt_task) (struct iscsi_conn *conn,
 				struct iscsi_mgmt_task *mtask,


