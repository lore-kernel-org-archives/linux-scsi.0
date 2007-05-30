From: michaelc@cs.wisc.edu
Subject: [PATCH 18/19] iscsi class, qla4xxx, iscsi_tcp: export local address
Date: Wed, 30 May 2007 12:57:24 -0500
Message-ID: <11805478643847-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu> <11805478601019-git-send-email-michaelc@cs.wisc.edu> <11805478611832-git-send-email-michaelc@cs.wisc.edu> <11805478623536-git-send-email-michaelc@cs.wisc.edu> <11805478623287-git-send-email-michaelc@cs.w
 isc.edu> <11805478632103-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXE3R5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:52 -0400
In-Reply-To: <11805478632103-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch exports the local address for the session. For
qla4xxx this is the ip of the hba's port. For software
this is the src addr of the socket.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c            |  127 +++++++++++++++++++++++++++--------
 drivers/scsi/qla4xxx/ql4_os.c       |    8 ++
 drivers/scsi/scsi_transport_iscsi.c |    4 +
 include/scsi/iscsi_if.h             |    2 +
 include/scsi/libiscsi.h             |    8 ++
 5 files changed, 118 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7ce177e..da66fb5 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1870,18 +1870,22 @@ tcp_conn_alloc_fail:
 static void
 iscsi_tcp_release_conn(struct iscsi_conn *conn)
 {
+	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct socket *sock = tcp_conn->sock;
 
-	if (!tcp_conn->sock)
+	if (!sock)
 		return;
 
-	sock_hold(tcp_conn->sock->sk);
+	sock_hold(sock->sk);
 	iscsi_conn_restore_callbacks(tcp_conn);
-	sock_put(tcp_conn->sock->sk);
+	sock_put(sock->sk);
 
-	sockfd_put(tcp_conn->sock);
+	spin_lock_bh(&session->lock);
 	tcp_conn->sock = NULL;
 	conn->recv_lock = NULL;
+	spin_unlock_bh(&session->lock);
+	sockfd_put(sock);
 }
 
 static void
@@ -1912,6 +1916,46 @@ iscsi_tcp_conn_stop(struct iscsi_cls_con
 	tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
 }
 
+static int iscsi_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
+			      char *buf, int *port,
+			      int (*getname)(struct socket *, struct sockaddr *,
+					int *addrlen))
+{
+	struct sockaddr_storage *addr;
+	struct sockaddr_in6 *sin6;
+	struct sockaddr_in *sin;
+	int rc = 0, len;
+
+	addr = kmalloc(GFP_KERNEL, sizeof(*addr));
+	if (!addr)
+		return -ENOMEM;
+
+	if (getname(sock, (struct sockaddr *) addr, &len)) {
+		rc = -ENODEV;
+		goto free_addr;
+	}
+
+	switch (addr->ss_family) {
+	case AF_INET:
+		sin = (struct sockaddr_in *)addr;
+		spin_lock_bh(&conn->session->lock);
+		sprintf(buf, NIPQUAD_FMT, NIPQUAD(sin->sin_addr.s_addr));
+		*port = be16_to_cpu(sin->sin_port);
+		spin_unlock_bh(&conn->session->lock);
+		break;
+	case AF_INET6:
+		sin6 = (struct sockaddr_in6 *)addr;
+		spin_lock_bh(&conn->session->lock);
+		sprintf(buf, NIP6_FMT, NIP6(sin6->sin6_addr));
+		*port = be16_to_cpu(sin6->sin6_port);
+		spin_unlock_bh(&conn->session->lock);
+		break;
+	}
+free_addr:
+	kfree(addr);
+	return rc;
+}
+
 static int
 iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		    struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
@@ -1929,10 +1973,24 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 		printk(KERN_ERR "iscsi_tcp: sockfd_lookup failed %d\n", err);
 		return -EEXIST;
 	}
+	/*
+	 * copy these values now because if we drop the session
+	 * userspace may still want to query the values since we will
+	 * be using them for the reconnect
+	 */
+	err = iscsi_tcp_get_addr(conn, sock, conn->portal_address,
+				 &conn->portal_port, kernel_getpeername);
+	if (err)
+		goto free_socket;
+
+	err = iscsi_tcp_get_addr(conn, sock, conn->local_address,
+				&conn->local_port, kernel_getsockname);
+	if (err)
+		goto free_socket;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (err)
-		return err;
+		goto free_socket;
 
 	/* bind iSCSI connection and socket */
 	tcp_conn->sock = sock;
@@ -1956,8 +2014,11 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 	 * set receive state machine into initial state
 	 */
 	tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
-
 	return 0;
+
+free_socket:
+	sockfd_put(sock);
+	return err;
 }
 
 /* called with host lock */
@@ -2077,33 +2138,18 @@ iscsi_tcp_conn_get_param(struct iscsi_cl
 			 enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct inet_sock *inet;
-	struct ipv6_pinfo *np;
-	struct sock *sk;
 	int len;
 
 	switch(param) {
 	case ISCSI_PARAM_CONN_PORT:
-		if (!tcp_conn->sock)
-			return -EINVAL;
-
-		inet = inet_sk(tcp_conn->sock->sk);
-		len = sprintf(buf, "%hu\n", be16_to_cpu(inet->dport));
+		spin_lock_bh(&conn->session->lock);
+		len = sprintf(buf, "%hu\n", conn->portal_port);
+		spin_unlock_bh(&conn->session->lock);
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		if (!tcp_conn->sock)
-			return -EINVAL;
-
-		sk = tcp_conn->sock->sk;
-		if (sk->sk_family == PF_INET) {
-			inet = inet_sk(sk);
-			len = sprintf(buf, NIPQUAD_FMT "\n",
-				      NIPQUAD(inet->daddr));
-		} else {
-			np = inet6_sk(sk);
-			len = sprintf(buf, NIP6_FMT "\n", NIP6(np->daddr));
-		}
+		spin_lock_bh(&conn->session->lock);
+		len = sprintf(buf, "%s\n", conn->portal_address);
+		spin_unlock_bh(&conn->session->lock);
 		break;
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
@@ -2112,6 +2158,29 @@ iscsi_tcp_conn_get_param(struct iscsi_cl
 	return len;
 }
 
+static int
+iscsi_tcp_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
+			 char *buf)
+{
+        struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	int len;
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_IPADDRESS:
+		spin_lock_bh(&session->lock);
+		if (!session->leadconn)
+			len = -ENODEV;
+		else
+			len = sprintf(buf, "%s\n",
+				     session->leadconn->local_address);
+		spin_unlock_bh(&session->lock);
+		break;
+	default:
+		return iscsi_host_get_param(shost, param, buf);
+	}
+	return len;
+}
+
 static void
 iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 {
@@ -2233,7 +2302,7 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_TARGET_NAME | ISCSI_TPGT |
 				  ISCSI_USERNAME | ISCSI_PASSWORD |
 				  ISCSI_USERNAME_IN | ISCSI_PASSWORD_IN,
-	.host_param_mask	= ISCSI_HOST_HWADDRESS |
+	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
@@ -2252,7 +2321,7 @@ static struct iscsi_transport iscsi_tcp_
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_tcp_conn_stop,
 	/* iscsi host params */
-	.get_host_param		= iscsi_host_get_param,
+	.get_host_param		= iscsi_tcp_host_get_param,
 	.set_host_param		= iscsi_host_set_param,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 315ab69..b87b460 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -106,6 +106,7 @@ static struct iscsi_transport qla4xxx_is
 	.param_mask		= ISCSI_CONN_PORT | ISCSI_CONN_ADDRESS |
 				  ISCSI_TARGET_NAME | ISCSI_TPGT,
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
+				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
 	.sessiondata_size	= sizeof(struct ddb_entry),
 	.host_template		= &qla4xxx_driver_template,
@@ -192,8 +193,13 @@ static int qla4xxx_host_get_param(struct
 	case ISCSI_HOST_PARAM_HWADDRESS:
 		len = format_addr(buf, ha->my_mac, MAC_ADDR_LEN);
 		break;
+	case ISCSI_HOST_PARAM_IPADDRESS:
+		len = sprintf(buf, "%d.%d.%d.%d\n", ha->ip_address[0],
+			      ha->ip_address[1], ha->ip_address[2],
+			      ha->ip_address[3]);
+		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		len = sprintf(buf, ha->name_string);
+		len = sprintf(buf, "%s\n", ha->name_string);
 		break;
 	default:
 		return -ENOSYS;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 859bd21..9b54eea 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -32,7 +32,7 @@ #include <scsi/iscsi_if.h>
 
 #define ISCSI_SESSION_ATTRS 15
 #define ISCSI_CONN_ATTRS 11
-#define ISCSI_HOST_ATTRS 2
+#define ISCSI_HOST_ATTRS 3
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
 
 struct iscsi_internal {
@@ -1261,6 +1261,7 @@ #define iscsi_host_attr(field, param)			
 static ISCSI_CLASS_ATTR(host, field, S_IRUGO, show_host_param_##param,	\
 			NULL);
 
+iscsi_host_attr(ipaddress, ISCSI_HOST_PARAM_IPADDRESS);
 iscsi_host_attr(hwaddress, ISCSI_HOST_PARAM_HWADDRESS);
 iscsi_host_attr(initiatorname, ISCSI_HOST_PARAM_INITIATOR_NAME);
 
@@ -1398,6 +1399,7 @@ iscsi_register_transport(struct iscsi_tr
 	priv->t.host_size = sizeof(struct iscsi_host);
 	transport_container_register(&priv->t.host_attrs);
 
+	SETUP_HOST_RD_ATTR(ipaddress, ISCSI_HOST_IPADDRESS);
 	SETUP_HOST_RD_ATTR(hwaddress, ISCSI_HOST_HWADDRESS);
 	SETUP_HOST_RD_ATTR(initiatorname, ISCSI_HOST_INITIATOR_NAME);
 	BUG_ON(count > ISCSI_HOST_ATTRS);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 81a5425..6429980 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -271,11 +271,13 @@ #define ISCSI_PASSWORD_IN		(1 << ISCSI_P
 enum iscsi_host_param {
 	ISCSI_HOST_PARAM_HWADDRESS,
 	ISCSI_HOST_PARAM_INITIATOR_NAME,
+	ISCSI_HOST_PARAM_IPADDRESS,
 	ISCSI_HOST_PARAM_MAX,
 };
 
 #define ISCSI_HOST_HWADDRESS		(1 << ISCSI_HOST_PARAM_HWADDRESS)
 #define ISCSI_HOST_INITIATOR_NAME	(1 << ISCSI_HOST_PARAM_INITIATOR_NAME)
+#define ISCSI_HOST_IPADDRESS		(1 << ISCSI_HOST_PARAM_IPADDRESS)
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 2f303a3..eea33f7 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -72,6 +72,8 @@ #define ISCSI_CID_MASK			(0xffff << ISCS
 #define ISCSI_AGE_SHIFT			28
 #define ISCSI_AGE_MASK			(0xf << ISCSI_AGE_SHIFT)
 
+#define ISCSI_ADDRESS_BUF_LEN		64
+
 struct iscsi_mgmt_task {
 	/*
 	 * Becuae LLDs allocate their hdr differently, this is a pointer to
@@ -174,6 +176,12 @@ struct iscsi_conn {
 	/* values userspace uses to id a conn */
 	int			persistent_port;
 	char			*persistent_address;
+	/* remote portal currently connected to */
+	int			portal_port;
+	char			portal_address[ISCSI_ADDRESS_BUF_LEN];
+	/* local address */
+	int			local_port;
+	char			local_address[ISCSI_ADDRESS_BUF_LEN];
 
 	/* MIB-statistics */
 	uint64_t		txdata_octets;
-- 
1.4.1.1

