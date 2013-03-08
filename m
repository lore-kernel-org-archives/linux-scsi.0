From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 02/11] iscsi-target: Initial traditional TCP conversion to iscsit_transport
Date: Fri,  8 Mar 2013 01:45:07 +0000
Message-ID: <1362707116-31406-3-git-send-email-nab@linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch performs the initial conversion of existing traditional iscsi
to use iscsit_transport API callers.  This includes:

- iscsi-np cleanups for iscsit_transport_type
- Add iscsi-np transport calls w/ ->iscsit_setup_up() and ->iscsit_free_np()
- Convert login thread process context to use ->iscsit_accept_np() for
  connections with pre-allocated struct iscsi_conn
- Convert existing socket accept code to iscsit_accept_np()
- Convert login RX/TX callers to use ->iscsit_get_login_rx() and
  ->iscsit_put_login_tx() to exchange request/response PDUs
- Convert existing socket login RX/TX calls into iscsit_get_login_rx()
  and iscsit_put_login_tx()
- Change iscsit_close_connection() to invoke ->iscsit_free_conn() +
  iscsit_put_transport() calls.
- Add iscsit_create_transport() + iscsit_destroy_transport() calls
  to module init/exit

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c            |   35 ++-
 drivers/target/iscsi/iscsi_target_core.h       |   15 +-
 drivers/target/iscsi/iscsi_target_login.c      |  411 ++++++++++++++++--------
 drivers/target/iscsi/iscsi_target_login.h      |    6 +
 drivers/target/iscsi/iscsi_target_nego.c       |  185 ++----------
 drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   12 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_util.c       |   27 +--
 9 files changed, 376 insertions(+), 332 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 23a98e6..4dc1c9b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -49,6 +49,8 @@
 #include "iscsi_target_device.h"
 #include "iscsi_target_stat.h"
 
+#include <target/iscsi/iscsi_transport.h>
+
 static LIST_HEAD(g_tiqn_list);
 static LIST_HEAD(g_np_list);
 static DEFINE_SPINLOCK(tiqn_lock);
@@ -400,8 +402,7 @@ struct iscsi_np *iscsit_add_np(
 	spin_unlock_bh(&np_lock);
 
 	pr_debug("CORE[0] - Added Network Portal: %s:%hu on %s\n",
-		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
-		"TCP" : "SCTP");
+		np->np_ip, np->np_port, np->np_transport->name);
 
 	return np;
 }
@@ -440,11 +441,10 @@ int iscsit_reset_np_thread(
 	return 0;
 }
 
-static int iscsit_del_np_comm(struct iscsi_np *np)
+static void iscsit_free_np(struct iscsi_np *np)
 {
 	if (np->np_socket)
 		sock_release(np->np_socket);
-	return 0;
 }
 
 int iscsit_del_np(struct iscsi_np *np)
@@ -466,20 +466,32 @@ int iscsit_del_np(struct iscsi_np *np)
 		send_sig(SIGINT, np->np_thread, 1);
 		kthread_stop(np->np_thread);
 	}
-	iscsit_del_np_comm(np);
+
+	np->np_transport->iscsit_free_np(np);
 
 	spin_lock_bh(&np_lock);
 	list_del(&np->np_list);
 	spin_unlock_bh(&np_lock);
 
 	pr_debug("CORE[0] - Removed Network Portal: %s:%hu on %s\n",
-		np->np_ip, np->np_port, (np->np_network_transport == ISCSI_TCP) ?
-		"TCP" : "SCTP");
+		np->np_ip, np->np_port, np->np_transport->name);
 
+	iscsit_put_transport(np->np_transport);
 	kfree(np);
 	return 0;
 }
 
+static struct iscsit_transport iscsi_target_transport = {
+	.name			= "iSCSI/TCP",
+	.transport_type		= ISCSI_TCP,
+	.owner			= NULL,
+	.iscsit_setup_np	= iscsit_setup_np,
+	.iscsit_accept_np	= iscsit_accept_np,
+	.iscsit_free_np		= iscsit_free_np,
+	.iscsit_get_login_rx	= iscsit_get_login_rx,
+	.iscsit_put_login_tx	= iscsit_put_login_tx,
+};
+
 static int __init iscsi_target_init_module(void)
 {
 	int ret = 0;
@@ -556,6 +568,8 @@ static int __init iscsi_target_init_module(void)
 		goto ooo_out;
 	}
 
+	iscsit_create_transport(&iscsi_target_transport);
+
 	if (iscsit_load_discovery_tpg() < 0)
 		goto r2t_out;
 
@@ -586,6 +600,7 @@ static void __exit iscsi_target_cleanup_module(void)
 	iscsi_deallocate_thread_sets();
 	iscsi_thread_set_free();
 	iscsit_release_discovery_tpg();
+	iscsit_destroy_transport(&iscsi_target_transport);
 	kmem_cache_destroy(lio_cmd_cache);
 	kmem_cache_destroy(lio_qr_cache);
 	kmem_cache_destroy(lio_dr_cache);
@@ -4045,6 +4060,12 @@ int iscsit_close_connection(
 
 	if (conn->sock)
 		sock_release(conn->sock);
+
+	if (conn->conn_transport->iscsit_free_conn)
+		conn->conn_transport->iscsit_free_conn(conn);
+
+	iscsit_put_transport(conn->conn_transport);
+
 	conn->thread_set = NULL;
 
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 7a333d2..2587677 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -60,7 +60,7 @@
 
 #define ISCSI_IOV_DATA_BUFFER		5
 
-enum tpg_np_network_transport_table {
+enum iscsit_transport_type {
 	ISCSI_TCP				= 0,
 	ISCSI_SCTP_TCP				= 1,
 	ISCSI_SCTP_UDP				= 2,
@@ -503,6 +503,7 @@ struct iscsi_conn {
 	u16			login_port;
 	u16			local_port;
 	int			net_size;
+	int			login_family;
 	u32			auth_id;
 	u32			conn_flags;
 	/* Used for iscsi_tx_login_rsp() */
@@ -562,9 +563,12 @@ struct iscsi_conn {
 	struct list_head	immed_queue_list;
 	struct list_head	response_queue_list;
 	struct iscsi_conn_ops	*conn_ops;
+	struct iscsi_login	*conn_login;
+	struct iscsit_transport *conn_transport;
 	struct iscsi_param_list	*param_list;
 	/* Used for per connection auth state machine */
 	void			*auth_protocol;
+	void			*context;
 	struct iscsi_login_thread_s *login_thread;
 	struct iscsi_portal_group *tpg;
 	/* Pointer to parent session */
@@ -663,6 +667,8 @@ struct iscsi_login {
 	u8 first_request;
 	u8 version_min;
 	u8 version_max;
+	u8 login_complete;
+	u8 login_failed;
 	char isid[6];
 	u32 cmd_sn;
 	itt_t init_task_tag;
@@ -670,10 +676,11 @@ struct iscsi_login {
 	u32 rsp_length;
 	u16 cid;
 	u16 tsih;
-	char *req;
-	char *rsp;
+	char req[ISCSI_HDR_LEN];
+	char rsp[ISCSI_HDR_LEN];
 	char *req_buf;
 	char *rsp_buf;
+	struct iscsi_conn *conn;
 } ____cacheline_aligned;
 
 struct iscsi_node_attrib {
@@ -754,6 +761,8 @@ struct iscsi_np {
 	struct task_struct	*np_thread;
 	struct timer_list	np_login_timer;
 	struct iscsi_portal_group *np_login_tpg;
+	void			*np_context;
+	struct iscsit_transport *np_transport;
 	struct list_head	np_list;
 } ____cacheline_aligned;
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index fdb632f..9354a5f 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -39,8 +39,39 @@
 #include "iscsi_target.h"
 #include "iscsi_target_parameters.h"
 
-static int iscsi_login_init_conn(struct iscsi_conn *conn)
+#include <target/iscsi/iscsi_transport.h>
+
+static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 {
+	struct iscsi_login *login;
+
+	login = kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
+	if (!login) {
+		pr_err("Unable to allocate memory for struct iscsi_login.\n");
+		return NULL;
+	}
+	login->conn = conn;
+	login->first_request = 1;
+
+	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	if (!login->req_buf) {
+		pr_err("Unable to allocate memory for response buffer.\n");
+		goto out_login;
+	}
+
+	login->rsp_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	if (!login->rsp_buf) {
+		pr_err("Unable to allocate memory for request buffer.\n");
+		goto out_req_buf;
+	}
+
+	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
+	if (!conn->conn_ops) {
+		pr_err("Unable to allocate memory for"
+			" struct iscsi_conn_ops.\n");
+		goto out_rsp_buf;
+	}
+
 	init_waitqueue_head(&conn->queues_wq);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_LIST_HEAD(&conn->conn_cmd_list);
@@ -62,10 +93,21 @@ static int iscsi_login_init_conn(struct iscsi_conn *conn)
 
 	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
 		pr_err("Unable to allocate conn->conn_cpumask\n");
-		return -ENOMEM;
+		goto out_conn_ops;
 	}
+	conn->conn_login = login;
 
-	return 0;
+	return login;
+
+out_conn_ops:
+	kfree(conn->conn_ops);
+out_rsp_buf:
+	kfree(login->rsp_buf);
+out_req_buf:
+	kfree(login->req_buf);
+out_login:
+	kfree(login);
+	return NULL;
 }
 
 /*
@@ -635,7 +677,13 @@ static int iscsi_post_login_handler(
 		spin_unlock_bh(&sess->conn_lock);
 
 		iscsi_post_login_start_timers(conn);
-		iscsi_activate_thread_set(conn, ts);
+
+		if (conn->conn_transport == ISCSI_TCP) {
+			iscsi_activate_thread_set(conn, ts);
+		} else {
+			printk("Not calling iscsi_activate_thread_set....\n");
+			dump_stack();
+		}
 		/*
 		 * Determine CPU mask to ensure connection's RX and TX kthreads
 		 * are scheduled on the same CPU.
@@ -764,11 +812,11 @@ static void iscsi_stop_login_thread_timer(struct iscsi_np *np)
 	spin_unlock_bh(&np->np_thread_lock);
 }
 
-int iscsi_target_setup_login_socket(
+int iscsit_setup_np(
 	struct iscsi_np *np,
 	struct __kernel_sockaddr_storage *sockaddr)
 {
-	struct socket *sock;
+	struct socket *sock = NULL;
 	int backlog = 5, ret, opt = 0, len;
 
 	switch (np->np_network_transport) {
@@ -784,15 +832,15 @@ int iscsi_target_setup_login_socket(
 		np->np_ip_proto = IPPROTO_SCTP;
 		np->np_sock_type = SOCK_SEQPACKET;
 		break;
-	case ISCSI_IWARP_TCP:
-	case ISCSI_IWARP_SCTP:
-	case ISCSI_INFINIBAND:
 	default:
 		pr_err("Unsupported network_transport: %d\n",
 				np->np_network_transport);
 		return -EINVAL;
 	}
 
+	np->np_ip_proto = IPPROTO_TCP;
+	np->np_sock_type = SOCK_STREAM;
+
 	ret = sock_create(sockaddr->ss_family, np->np_sock_type,
 			np->np_ip_proto, &sock);
 	if (ret < 0) {
@@ -856,7 +904,6 @@ int iscsi_target_setup_login_socket(
 	}
 
 	return 0;
-
 fail:
 	np->np_socket = NULL;
 	if (sock)
@@ -864,21 +911,168 @@ fail:
 	return ret;
 }
 
+int iscsi_target_setup_login_socket(
+	struct iscsi_np *np,
+	struct __kernel_sockaddr_storage *sockaddr)
+{
+	struct iscsit_transport *t;
+	int rc;
+
+	t = iscsit_get_transport(np->np_network_transport);
+	if (!t)
+		return -EINVAL;
+
+	rc = t->iscsit_setup_np(np, sockaddr);
+	if (rc < 0)
+		return rc;
+
+	np->np_transport = t;
+	printk("Set np->np_transport to %p -> %s\n", np->np_transport,
+				np->np_transport->name);
+	return 0;
+}
+
+int iscsit_accept_np(struct iscsi_np *np, struct iscsi_conn *conn)
+{
+	struct socket *new_sock, *sock = np->np_socket;
+	struct sockaddr_in sock_in;
+	struct sockaddr_in6 sock_in6;
+	int rc, err;
+
+	rc = kernel_accept(sock, &new_sock, 0);
+	if (rc < 0)
+		return rc;
+
+	conn->sock = new_sock;
+	conn->login_family = np->np_sockaddr.ss_family;
+	printk("iSCSI/TCP: Setup conn->sock from new_sock: %p\n", new_sock);
+
+	if (np->np_sockaddr.ss_family == AF_INET6) {
+		memset(&sock_in6, 0, sizeof(struct sockaddr_in6));
+
+		rc = conn->sock->ops->getname(conn->sock,
+				(struct sockaddr *)&sock_in6, &err, 1);
+		if (!rc) {
+			snprintf(conn->login_ip, sizeof(conn->login_ip), "%pI6c",
+				&sock_in6.sin6_addr.in6_u);
+			conn->login_port = ntohs(sock_in6.sin6_port);
+		}
+
+		rc = conn->sock->ops->getname(conn->sock,
+				(struct sockaddr *)&sock_in6, &err, 0);
+		if (!rc) {
+			snprintf(conn->local_ip, sizeof(conn->local_ip), "%pI6c",
+				&sock_in6.sin6_addr.in6_u);
+			conn->local_port = ntohs(sock_in6.sin6_port);
+		}
+	} else {
+		memset(&sock_in, 0, sizeof(struct sockaddr_in));
+
+		rc = conn->sock->ops->getname(conn->sock,
+				(struct sockaddr *)&sock_in, &err, 1);
+		if (!rc) {
+			sprintf(conn->login_ip, "%pI4",
+					&sock_in.sin_addr.s_addr);
+			conn->login_port = ntohs(sock_in.sin_port);
+		}
+
+		rc = conn->sock->ops->getname(conn->sock,
+				(struct sockaddr *)&sock_in, &err, 0);
+		if (!rc) {
+			sprintf(conn->local_ip, "%pI4",
+					&sock_in.sin_addr.s_addr);
+			conn->local_port = ntohs(sock_in.sin_port);
+		}
+	}
+
+	return 0;
+}
+
+int iscsit_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
+{
+	struct iscsi_login_req *login_req;
+	u32 padding = 0, payload_length;
+
+	if (iscsi_login_rx_data(conn, login->req, ISCSI_HDR_LEN) < 0)
+		return -1;
+
+	login_req = (struct iscsi_login_req *)login->req;
+	payload_length	= ntoh24(login_req->dlength);
+	padding = ((-payload_length) & 3);
+
+	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
+		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
+		login_req->flags, login_req->itt, login_req->cmdsn,
+		login_req->exp_statsn, login_req->cid, payload_length);
+	/*
+	 * Setup the initial iscsi_login values from the leading
+	 * login request PDU.
+	 */
+	if (login->first_request) {
+		login_req = (struct iscsi_login_req *)login->req;
+		login->leading_connection = (!login_req->tsih) ? 1 : 0;
+		login->current_stage	=
+			(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) >> 2;
+		login->version_min	= login_req->min_version;
+		login->version_max	= login_req->max_version;
+		memcpy(login->isid, login_req->isid, 6);
+		login->cmd_sn		= be32_to_cpu(login_req->cmdsn);
+		login->init_task_tag	= login_req->itt;
+		login->initial_exp_statsn = be32_to_cpu(login_req->exp_statsn);
+		login->cid		= be16_to_cpu(login_req->cid);
+		login->tsih		= be16_to_cpu(login_req->tsih);
+	}
+
+	if (iscsi_target_check_login_request(conn, login) < 0)
+		return -1;
+
+	memset(login->req_buf, 0, MAX_KEY_VALUE_PAIRS);
+	if (iscsi_login_rx_data(conn, login->req_buf,
+				payload_length + padding) < 0)
+		return -1;
+
+	return 0;
+}
+
+int iscsit_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
+			u32 length)
+{
+	if (iscsi_login_tx_data(conn, login->rsp, login->rsp_buf, length) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int
+iscsit_conn_set_transport(struct iscsi_conn *conn, struct iscsit_transport *t)
+{
+	int rc;
+
+	if (!t->owner) {
+		conn->conn_transport = t;
+		return 0;
+	}
+
+	rc = try_module_get(t->owner);
+	if (!rc) {
+		pr_err("try_module_get() failed for %s\n", t->name);
+		return -EINVAL;
+	}
+
+	conn->conn_transport = t;
+	return 0;
+}
+
 static int __iscsi_target_login_thread(struct iscsi_np *np)
 {
-	u8 buffer[ISCSI_HDR_LEN], iscsi_opcode, zero_tsih = 0;
-	int err, ret = 0, stop;
+	u8 *buffer, zero_tsih = 0;
+	int ret = 0, rc, stop;
 	struct iscsi_conn *conn = NULL;
 	struct iscsi_login *login;
 	struct iscsi_portal_group *tpg = NULL;
-	struct socket *new_sock, *sock;
-	struct kvec iov;
 	struct iscsi_login_req *pdu;
-	struct sockaddr_in sock_in;
-	struct sockaddr_in6 sock_in6;
 
 	flush_signals(current);
-	sock = np->np_socket;
 
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
@@ -889,75 +1083,76 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
-	if (kernel_accept(sock, &new_sock, 0) < 0) {
-		spin_lock_bh(&np->np_thread_lock);
-		if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
-			spin_unlock_bh(&np->np_thread_lock);
-			complete(&np->np_restart_comp);
-			/* Get another socket */
-			return 1;
-		}
-		spin_unlock_bh(&np->np_thread_lock);
-		goto out;
-	}
-	iscsi_start_login_thread_timer(np);
-
 	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
 	if (!conn) {
 		pr_err("Could not allocate memory for"
 			" new connection\n");
-		sock_release(new_sock);
 		/* Get another socket */
 		return 1;
 	}
-
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
-	conn->sock = new_sock;
 
-	pr_debug("Moving to TARG_CONN_STATE_XPT_UP.\n");
-	conn->conn_state = TARG_CONN_STATE_XPT_UP;
+	if (iscsit_conn_set_transport(conn, np->np_transport) < 0) {
+		kfree(conn);
+		return 1;
+	}
 
-	/*
-	 * Allocate conn->conn_ops early as a failure calling
-	 * iscsit_tx_login_rsp() below will call tx_data().
-	 */
-	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
-	if (!conn->conn_ops) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_conn_ops.\n");
-		goto new_sess_out;
+	rc = np->np_transport->iscsit_accept_np(np, conn);
+	if (rc == -ENOSYS) {
+		complete(&np->np_restart_comp);
+		iscsit_put_transport(conn->conn_transport);
+		kfree(conn);
+		conn = NULL;
+		goto exit;
+	} else if (rc < 0) {
+		spin_lock_bh(&np->np_thread_lock);
+		if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
+			spin_unlock_bh(&np->np_thread_lock);
+			complete(&np->np_restart_comp);
+			if (ret == -ENODEV) {
+				iscsit_put_transport(conn->conn_transport);
+				kfree(conn);
+				conn = NULL;
+				goto out;
+			}
+			/* Get another socket */
+			return 1;
+		}
+		spin_unlock_bh(&np->np_thread_lock);
+		iscsit_put_transport(conn->conn_transport);
+		kfree(conn);
+		conn = NULL;
+		goto out;
 	}
 	/*
 	 * Perform the remaining iSCSI connection initialization items..
 	 */
-	if (iscsi_login_init_conn(conn) < 0)
-		goto new_sess_out;
-
-	memset(buffer, 0, ISCSI_HDR_LEN);
-	memset(&iov, 0, sizeof(struct kvec));
-	iov.iov_base	= buffer;
-	iov.iov_len	= ISCSI_HDR_LEN;
-
-	if (rx_data(conn, &iov, 1, ISCSI_HDR_LEN) <= 0) {
-		pr_err("rx_data() returned an error.\n");
+	login = iscsi_login_init_conn(conn);
+	if (!login) {
 		goto new_sess_out;
 	}
 
-	iscsi_opcode = (buffer[0] & ISCSI_OPCODE_MASK);
-	if (!(iscsi_opcode & ISCSI_OP_LOGIN)) {
-		pr_err("First opcode is not login request,"
-			" failing login request.\n");
-		goto new_sess_out;
-	}
+	iscsi_start_login_thread_timer(np);
 
-	pdu			= (struct iscsi_login_req *) buffer;
+	pr_debug("Moving to TARG_CONN_STATE_XPT_UP.\n");
+	conn->conn_state = TARG_CONN_STATE_XPT_UP;
+	/*
+	 * This will process the first login request + payload..
+	 */
+	rc = np->np_transport->iscsit_get_login_rx(conn, login);
+	if (rc == 1)
+		return 1;
+	else if (rc < 0)
+		goto new_sess_out;
 
+	buffer = &login->req[0];
+	pdu = (struct iscsi_login_req *)buffer;
 	/*
 	 * Used by iscsit_tx_login_rsp() for Login Resonses PDUs
 	 * when Status-Class != 0.
 	*/
-	conn->login_itt		= pdu->itt;
+	conn->login_itt	= pdu->itt;
 
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
@@ -970,61 +1165,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
-	if (np->np_sockaddr.ss_family == AF_INET6) {
-		memset(&sock_in6, 0, sizeof(struct sockaddr_in6));
-
-		if (conn->sock->ops->getname(conn->sock,
-				(struct sockaddr *)&sock_in6, &err, 1) < 0) {
-			pr_err("sock_ops->getname() failed.\n");
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-					ISCSI_LOGIN_STATUS_TARGET_ERROR);
-			goto new_sess_out;
-		}
-		snprintf(conn->login_ip, sizeof(conn->login_ip), "%pI6c",
-				&sock_in6.sin6_addr.in6_u);
-		conn->login_port = ntohs(sock_in6.sin6_port);
-
-		if (conn->sock->ops->getname(conn->sock,
-				(struct sockaddr *)&sock_in6, &err, 0) < 0) {
-			pr_err("sock_ops->getname() failed.\n");
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-					ISCSI_LOGIN_STATUS_TARGET_ERROR);
-			goto new_sess_out;
-		}
-		snprintf(conn->local_ip, sizeof(conn->local_ip), "%pI6c",
-				&sock_in6.sin6_addr.in6_u);
-		conn->local_port = ntohs(sock_in6.sin6_port);
-
-	} else {
-		memset(&sock_in, 0, sizeof(struct sockaddr_in));
-
-		if (conn->sock->ops->getname(conn->sock,
-				(struct sockaddr *)&sock_in, &err, 1) < 0) {
-			pr_err("sock_ops->getname() failed.\n");
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-					ISCSI_LOGIN_STATUS_TARGET_ERROR);
-			goto new_sess_out;
-		}
-		sprintf(conn->login_ip, "%pI4", &sock_in.sin_addr.s_addr);
-		conn->login_port = ntohs(sock_in.sin_port);
-
-		if (conn->sock->ops->getname(conn->sock,
-				(struct sockaddr *)&sock_in, &err, 0) < 0) {
-			pr_err("sock_ops->getname() failed.\n");
-			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-					ISCSI_LOGIN_STATUS_TARGET_ERROR);
-			goto new_sess_out;
-		}
-		sprintf(conn->local_ip, "%pI4", &sock_in.sin_addr.s_addr);
-		conn->local_port = ntohs(sock_in.sin_port);
-	}
-
 	conn->network_transport = np->np_network_transport;
 
 	pr_debug("Received iSCSI login request from %s on %s Network"
-			" Portal %s:%hu\n", conn->login_ip,
-		(conn->network_transport == ISCSI_TCP) ? "TCP" : "SCTP",
-			conn->local_ip, conn->local_port);
+		" Portal %s:%hu\n", conn->login_ip, np->np_transport->name,
+		conn->local_ip, conn->local_port);
 
 	pr_debug("Moving to TARG_CONN_STATE_IN_LOGIN.\n");
 	conn->conn_state	= TARG_CONN_STATE_IN_LOGIN;
@@ -1053,13 +1198,17 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		if (iscsi_login_non_zero_tsih_s1(conn, buffer) < 0)
 			goto new_sess_out;
 	}
-
 	/*
-	 * This will process the first login request, and call
-	 * iscsi_target_locate_portal(), and return a valid struct iscsi_login.
+	 * SessionType: Discovery
+	 *
+	 * 	Locates Default Portal
+	 *
+	 * SessionType: Normal
+	 *
+	 * 	Locates Target Portal from NP -> Target IQN
 	 */
-	login = iscsi_target_init_negotiation(np, conn, buffer);
-	if (!login) {
+	rc = iscsi_target_locate_portal(np, conn, login);
+	if (rc < 0) {
 		tpg = conn->tpg;
 		goto new_sess_out;
 	}
@@ -1071,15 +1220,11 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 
 	if (zero_tsih) {
-		if (iscsi_login_zero_tsih_s2(conn) < 0) {
-			iscsi_target_nego_release(login, conn);
+		if (iscsi_login_zero_tsih_s2(conn) < 0)
 			goto new_sess_out;
-		}
 	} else {
-		if (iscsi_login_non_zero_tsih_s2(conn, buffer) < 0) {
-			iscsi_target_nego_release(login, conn);
+		if (iscsi_login_non_zero_tsih_s2(conn, buffer) < 0)
 			goto old_sess_out;
-		}
 	}
 
 	if (iscsi_target_start_negotiation(login, conn) < 0)
@@ -1156,8 +1301,18 @@ old_sess_out:
 		iscsi_release_param_list(conn->param_list);
 		conn->param_list = NULL;
 	}
-	if (conn->sock)
+	iscsi_target_nego_release(conn);
+
+	if (conn->sock) {
 		sock_release(conn->sock);
+		conn->sock = NULL;
+	}
+
+	if (conn->conn_transport->iscsit_free_conn)
+		conn->conn_transport->iscsit_free_conn(conn);
+
+	iscsit_put_transport(conn->conn_transport);
+
 	kfree(conn);
 
 	if (tpg) {
@@ -1175,11 +1330,13 @@ out:
 	/* Wait for another socket.. */
 	if (!stop)
 		return 1;
-
+exit:
 	iscsi_stop_login_thread_timer(np);
 	spin_lock_bh(&np->np_thread_lock);
 	np->np_thread_state = ISCSI_NP_THREAD_EXIT;
+	np->np_thread = NULL;
 	spin_unlock_bh(&np->np_thread_lock);
+
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 091dcae..63efd28 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -4,8 +4,14 @@
 extern int iscsi_login_setup_crypto(struct iscsi_conn *);
 extern int iscsi_check_for_session_reinstatement(struct iscsi_conn *);
 extern int iscsi_login_post_auth_non_zero_tsih(struct iscsi_conn *, u16, u32);
+extern int iscsit_setup_np(struct iscsi_np *,
+				struct __kernel_sockaddr_storage *);
 extern int iscsi_target_setup_login_socket(struct iscsi_np *,
 				struct __kernel_sockaddr_storage *);
+extern int iscsit_accept_np(struct iscsi_np *, struct iscsi_conn *);
+extern int iscsit_get_login_rx(struct iscsi_conn *, struct iscsi_login *);
+extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
+extern void iscsit_free_conn(struct iscsi_np *, struct iscsi_conn *);
 extern int iscsi_target_login_thread(void *);
 extern int iscsi_login_disable_FIM_keys(struct iscsi_param_list *, struct iscsi_conn *);
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 9d902ae..8bc7e97 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -22,6 +22,7 @@
 #include <scsi/iscsi_proto.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
+#include <target/iscsi/iscsi_transport.h>
 
 #include "iscsi_target_core.h"
 #include "iscsi_target_parameters.h"
@@ -169,7 +170,7 @@ static void iscsi_remove_failed_auth_entry(struct iscsi_conn *conn)
 	kfree(conn->auth_protocol);
 }
 
-static int iscsi_target_check_login_request(
+int iscsi_target_check_login_request(
 	struct iscsi_conn *conn,
 	struct iscsi_login *login)
 {
@@ -352,11 +353,8 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 
 	padding = ((-login->rsp_length) & 3);
 
-	if (iscsi_login_tx_data(
-			conn,
-			login->rsp,
-			login->rsp_buf,
-			login->rsp_length + padding) < 0)
+	if (conn->conn_transport->iscsit_put_login_tx(conn, login,
+					login->rsp_length + padding) < 0)
 		return -1;
 
 	login->rsp_length		= 0;
@@ -368,72 +366,12 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
 	return 0;
 }
 
-static int iscsi_target_do_rx_login_io(struct iscsi_conn *conn, struct iscsi_login *login)
-{
-	u32 padding = 0, payload_length;
-	struct iscsi_login_req *login_req;
-
-	if (iscsi_login_rx_data(conn, login->req, ISCSI_HDR_LEN) < 0)
-		return -1;
-
-	login_req = (struct iscsi_login_req *) login->req;
-	payload_length			= ntoh24(login_req->dlength);
-
-	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
-		 login_req->flags, login_req->itt, login_req->cmdsn,
-		 login_req->exp_statsn, login_req->cid, payload_length);
-
-	if (iscsi_target_check_login_request(conn, login) < 0)
-		return -1;
-
-	padding = ((-payload_length) & 3);
-	memset(login->req_buf, 0, MAX_KEY_VALUE_PAIRS);
-
-	if (iscsi_login_rx_data(
-			conn,
-			login->req_buf,
-			payload_length + padding) < 0)
-		return -1;
-
-	return 0;
-}
-
 static int iscsi_target_do_login_io(struct iscsi_conn *conn, struct iscsi_login *login)
 {
 	if (iscsi_target_do_tx_login_io(conn, login) < 0)
 		return -1;
 
-	if (iscsi_target_do_rx_login_io(conn, login) < 0)
-		return -1;
-
-	return 0;
-}
-
-static int iscsi_target_get_initial_payload(
-	struct iscsi_conn *conn,
-	struct iscsi_login *login)
-{
-	u32 padding = 0, payload_length;
-	struct iscsi_login_req *login_req;
-
-	login_req = (struct iscsi_login_req *) login->req;
-	payload_length = ntoh24(login_req->dlength);
-
-	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
-		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, Length: %u\n",
-		login_req->flags, login_req->itt, login_req->cmdsn,
-		login_req->exp_statsn, payload_length);
-
-	if (iscsi_target_check_login_request(conn, login) < 0)
-		return -1;
-
-	padding = ((-payload_length) & 3);
-
-	if (iscsi_login_rx_data(
-			conn,
-			login->req_buf,
-			payload_length + padding) < 0)
+	if (conn->conn_transport->iscsit_get_login_rx(conn, login) < 0)
 		return -1;
 
 	return 0;
@@ -693,6 +631,7 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
 				return -1;
 			if (login_rsp->flags & ISCSI_FLAG_LOGIN_TRANSIT) {
 				login->tsih = conn->sess->tsih;
+				login->login_complete = 1;
 				if (iscsi_target_do_tx_login_io(conn,
 						login) < 0)
 					return -1;
@@ -737,7 +676,7 @@ static void iscsi_initiatorname_tolower(
 /*
  * Processes the first Login Request..
  */
-static int iscsi_target_locate_portal(
+int iscsi_target_locate_portal(
 	struct iscsi_np *np,
 	struct iscsi_conn *conn,
 	struct iscsi_login *login)
@@ -746,29 +685,13 @@ static int iscsi_target_locate_portal(
 	char *tmpbuf, *start = NULL, *end = NULL, *key, *value;
 	struct iscsi_session *sess = conn->sess;
 	struct iscsi_tiqn *tiqn;
-	struct iscsi_login_req *login_req;
+        struct iscsi_login_req *login_req;
 	u32 payload_length;
 	int sessiontype = 0, ret = 0;
 
 	login_req = (struct iscsi_login_req *) login->req;
 	payload_length = ntoh24(login_req->dlength);
 
-	login->first_request	= 1;
-	login->leading_connection = (!login_req->tsih) ? 1 : 0;
-	login->current_stage	=
-		(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) >> 2;
-	login->version_min	= login_req->min_version;
-	login->version_max	= login_req->max_version;
-	memcpy(login->isid, login_req->isid, 6);
-	login->cmd_sn		= be32_to_cpu(login_req->cmdsn);
-	login->init_task_tag	= login_req->itt;
-	login->initial_exp_statsn = be32_to_cpu(login_req->exp_statsn);
-	login->cid		= be16_to_cpu(login_req->cid);
-	login->tsih		= be16_to_cpu(login_req->tsih);
-
-	if (iscsi_target_get_initial_payload(conn, login) < 0)
-		return -1;
-
 	tmpbuf = kzalloc(payload_length + 1, GFP_KERNEL);
 	if (!tmpbuf) {
 		pr_err("Unable to allocate memory for tmpbuf.\n");
@@ -800,6 +723,8 @@ static int iscsi_target_locate_portal(
 		start += strlen(key) + strlen(value) + 2;
 	}
 
+	printk("i_buf: %s, s_buf: %s, t_buf: %s\n", i_buf, s_buf, t_buf);
+
 	/*
 	 * See 5.3.  Login Phase.
 	 */
@@ -958,100 +883,30 @@ out:
 	return ret;
 }
 
-struct iscsi_login *iscsi_target_init_negotiation(
-	struct iscsi_np *np,
-	struct iscsi_conn *conn,
-	char *login_pdu)
-{
-	struct iscsi_login *login;
-
-	login = kzalloc(sizeof(struct iscsi_login), GFP_KERNEL);
-	if (!login) {
-		pr_err("Unable to allocate memory for struct iscsi_login.\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		return NULL;
-	}
-
-	login->req = kmemdup(login_pdu, ISCSI_HDR_LEN, GFP_KERNEL);
-	if (!login->req) {
-		pr_err("Unable to allocate memory for Login Request.\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		goto out;
-	}
-
-	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
-	if (!login->req_buf) {
-		pr_err("Unable to allocate memory for response buffer.\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		goto out;
-	}
-	/*
-	 * SessionType: Discovery
-	 *
-	 *	Locates Default Portal
-	 *
-	 * SessionType: Normal
-	 *
-	 *	Locates Target Portal from NP -> Target IQN
-	 */
-	if (iscsi_target_locate_portal(np, conn, login) < 0) {
-		goto out;
-	}
-
-	return login;
-out:
-	kfree(login->req);
-	kfree(login->req_buf);
-	kfree(login);
-
-	return NULL;
-}
-
 int iscsi_target_start_negotiation(
 	struct iscsi_login *login,
 	struct iscsi_conn *conn)
 {
-	int ret = -1;
-
-	login->rsp = kzalloc(ISCSI_HDR_LEN, GFP_KERNEL);
-	if (!login->rsp) {
-		pr_err("Unable to allocate memory for"
-				" Login Response.\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		ret = -1;
-		goto out;
-	}
-
-	login->rsp_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
-	if (!login->rsp_buf) {
-		pr_err("Unable to allocate memory for"
-			" request buffer.\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		ret = -1;
-		goto out;
-	}
+	int ret;
 
 	ret = iscsi_target_do_login(conn, login);
-out:
 	if (ret != 0)
 		iscsi_remove_failed_auth_entry(conn);
 
-	iscsi_target_nego_release(login, conn);
+	iscsi_target_nego_release(conn);
 	return ret;
 }
 
-void iscsi_target_nego_release(
-	struct iscsi_login *login,
-	struct iscsi_conn *conn)
+void iscsi_target_nego_release(struct iscsi_conn *conn)
 {
-	kfree(login->req);
-	kfree(login->rsp);
+	struct iscsi_login *login = conn->conn_login;
+
+	if (!login)
+		return;
+
 	kfree(login->req_buf);
 	kfree(login->rsp_buf);
 	kfree(login);
+
+	conn->conn_login = NULL;
 }
diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/iscsi/iscsi_target_nego.h
index 92e133a..f021cbd 100644
--- a/drivers/target/iscsi/iscsi_target_nego.h
+++ b/drivers/target/iscsi/iscsi_target_nego.h
@@ -7,11 +7,14 @@
 extern void convert_null_to_semi(char *, int);
 extern int extract_param(const char *, const char *, unsigned int, char *,
 		unsigned char *);
-extern struct iscsi_login *iscsi_target_init_negotiation(
-		struct iscsi_np *, struct iscsi_conn *, char *);
+extern int iscsi_target_check_login_request(struct iscsi_conn *,
+		struct iscsi_login *);
+extern int iscsi_target_get_initial_payload(struct iscsi_conn *,
+		struct iscsi_login *);
+extern int iscsi_target_locate_portal(struct iscsi_np *, struct iscsi_conn *,
+		struct iscsi_login *);
 extern int iscsi_target_start_negotiation(
 		struct iscsi_login *, struct iscsi_conn *);
-extern void iscsi_target_nego_release(
-		struct iscsi_login *, struct iscsi_conn *);
+extern void iscsi_target_nego_release(struct iscsi_conn *);
 
 #endif /* ISCSI_TARGET_NEGO_H */
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index ca2be40..84ce94a 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -59,7 +59,7 @@ int iscsi_login_tx_data(
 	char *text_buf,
 	int text_length)
 {
-	int length, tx_sent;
+	int length, tx_sent, iov_cnt = 1;
 	struct kvec iov[2];
 
 	length = (ISCSI_HDR_LEN + text_length);
@@ -67,8 +67,12 @@ int iscsi_login_tx_data(
 	memset(&iov[0], 0, 2 * sizeof(struct kvec));
 	iov[0].iov_len		= ISCSI_HDR_LEN;
 	iov[0].iov_base		= pdu_buf;
-	iov[1].iov_len		= text_length;
-	iov[1].iov_base		= text_buf;
+
+	if (text_buf && text_length) {
+		iov[1].iov_len	= text_length;
+		iov[1].iov_base	= text_buf;
+		iov_cnt++;
+	}
 
 	/*
 	 * Initial Marker-less Interval.
@@ -77,7 +81,7 @@ int iscsi_login_tx_data(
 	 */
 	conn->if_marker += length;
 
-	tx_sent = tx_data(conn, &iov[0], 2, length);
+	tx_sent = tx_data(conn, &iov[0], iov_cnt, length);
 	if (tx_sent != length) {
 		pr_err("tx_data returned %d, expecting %d.\n",
 				tx_sent, length);
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index ee8f8c6..439260b 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -31,6 +31,8 @@
 #include "iscsi_target.h"
 #include "iscsi_target_parameters.h"
 
+#include <target/iscsi/iscsi_transport.h>
+
 struct iscsi_portal_group *iscsit_alloc_portal_group(struct iscsi_tiqn *tiqn, u16 tpgt)
 {
 	struct iscsi_portal_group *tpg;
@@ -508,7 +510,7 @@ struct iscsi_tpg_np *iscsit_tpg_add_network_portal(
 
 	pr_debug("CORE[%s] - Added Network Portal: %s:%hu,%hu on %s\n",
 		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
-		(np->np_network_transport == ISCSI_TCP) ? "TCP" : "SCTP");
+		np->np_transport->name);
 
 	return tpg_np;
 }
@@ -522,7 +524,7 @@ static int iscsit_tpg_release_np(
 
 	pr_debug("CORE[%s] - Removed Network Portal: %s:%hu,%hu on %s\n",
 		tpg->tpg_tiqn->tiqn, np->np_ip, np->np_port, tpg->tpgt,
-		(np->np_network_transport == ISCSI_TCP) ? "TCP" : "SCTP");
+		np->np_transport->name);
 
 	tpg_np->tpg_np = NULL;
 	tpg_np->tpg = NULL;
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 7ce3505..4cf1e7f 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -24,6 +24,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_configfs.h>
+#include <target/iscsi/iscsi_transport.h>
 
 #include "iscsi_target_core.h"
 #include "iscsi_target_parameters.h"
@@ -1226,34 +1227,19 @@ send_datacrc:
  */
 int iscsit_tx_login_rsp(struct iscsi_conn *conn, u8 status_class, u8 status_detail)
 {
-	u8 iscsi_hdr[ISCSI_HDR_LEN];
-	int err;
-	struct kvec iov;
 	struct iscsi_login_rsp *hdr;
+	struct iscsi_login *login = conn->conn_login;
 
+	login->login_failed = 1;
 	iscsit_collect_login_stats(conn, status_class, status_detail);
 
-	memset(&iov, 0, sizeof(struct kvec));
-	memset(&iscsi_hdr, 0x0, ISCSI_HDR_LEN);
-
-	hdr	= (struct iscsi_login_rsp *)&iscsi_hdr;
+	hdr	= (struct iscsi_login_rsp *)&login->rsp[0];
 	hdr->opcode		= ISCSI_OP_LOGIN_RSP;
 	hdr->status_class	= status_class;
 	hdr->status_detail	= status_detail;
 	hdr->itt		= conn->login_itt;
 
-	iov.iov_base		= &iscsi_hdr;
-	iov.iov_len		= ISCSI_HDR_LEN;
-
-	PRINT_BUFF(iscsi_hdr, ISCSI_HDR_LEN);
-
-	err = tx_data(conn, &iov, 1, ISCSI_HDR_LEN);
-	if (err != ISCSI_HDR_LEN) {
-		pr_err("tx_data returned less than expected\n");
-		return -1;
-	}
-
-	return 0;
+	return conn->conn_transport->iscsit_put_login_tx(conn, login, 0);
 }
 
 void iscsit_print_session_params(struct iscsi_session *sess)
@@ -1432,7 +1418,8 @@ void iscsit_collect_login_stats(
 		strcpy(ls->last_intr_fail_name,
 		       (intrname ? intrname->value : "Unknown"));
 
-		ls->last_intr_fail_ip_family = conn->sock->sk->sk_family;
+		ls->last_intr_fail_ip_family = conn->login_family;
+
 		snprintf(ls->last_intr_fail_ip_addr, IPV6_ADDRESS_SPACE,
 				"%s", conn->login_ip);
 		ls->last_fail_time = get_jiffies_64();
-- 
1.7.2.5
