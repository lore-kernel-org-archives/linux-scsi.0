From: michaelc@cs.wisc.edu
Subject: [PATCH 12/17] iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function
Date: Wed, 16 Feb 2011 15:04:36 -0600
Message-ID: <1297890281-9076-13-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1BPVEj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:39 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4dEu027084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:39 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt1004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:38 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This has iscsi_tcp use the iscsi_conn_get_addr_param
libiscsi function. It also drops the use of the libiscsi
session portal buffers, so they can be removed in
the next patches. Instead of copying the values
at bind time we get them during get() time. If we are
not connected userspace will now get -ENOTCONN,
so it knows that connection is disconnected instead
of a possible stale value.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |  134 +++++++++++++++++++++++-----------------------
 drivers/scsi/iscsi_tcp.h |    4 ++
 2 files changed, 71 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index fec47de..a860452 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -608,54 +608,12 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	iscsi_sw_tcp_release_conn(conn);
 }
 
-static int iscsi_sw_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
-				 char *buf, int *port,
-				 int (*getname)(struct socket *,
-						struct sockaddr *,
-						int *addrlen))
-{
-	struct sockaddr_storage *addr;
-	struct sockaddr_in6 *sin6;
-	struct sockaddr_in *sin;
-	int rc = 0, len;
-
-	addr = kmalloc(sizeof(*addr), GFP_KERNEL);
-	if (!addr)
-		return -ENOMEM;
-
-	if (getname(sock, (struct sockaddr *) addr, &len)) {
-		rc = -ENODEV;
-		goto free_addr;
-	}
-
-	switch (addr->ss_family) {
-	case AF_INET:
-		sin = (struct sockaddr_in *)addr;
-		spin_lock_bh(&conn->session->lock);
-		sprintf(buf, "%pI4", &sin->sin_addr.s_addr);
-		*port = be16_to_cpu(sin->sin_port);
-		spin_unlock_bh(&conn->session->lock);
-		break;
-	case AF_INET6:
-		sin6 = (struct sockaddr_in6 *)addr;
-		spin_lock_bh(&conn->session->lock);
-		sprintf(buf, "%pI6", &sin6->sin6_addr);
-		*port = be16_to_cpu(sin6->sin6_port);
-		spin_unlock_bh(&conn->session->lock);
-		break;
-	}
-free_addr:
-	kfree(addr);
-	return rc;
-}
-
 static int
 iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		       int is_leading)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct iscsi_host *ihost = shost_priv(shost);
+	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
@@ -670,27 +628,15 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 				  "sockfd_lookup failed %d\n", err);
 		return -EEXIST;
 	}
-	/*
-	 * copy these values now because if we drop the session
-	 * userspace may still want to query the values since we will
-	 * be using them for the reconnect
-	 */
-	err = iscsi_sw_tcp_get_addr(conn, sock, conn->portal_address,
-				    &conn->portal_port, kernel_getpeername);
-	if (err)
-		goto free_socket;
-
-	err = iscsi_sw_tcp_get_addr(conn, sock, ihost->local_address,
-				    &ihost->local_port, kernel_getsockname);
-	if (err)
-		goto free_socket;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (err)
 		goto free_socket;
 
+	spin_lock_bh(&session->lock);
 	/* bind iSCSI connection and socket */
 	tcp_sw_conn->sock = sock;
+	spin_unlock_bh(&session->lock);
 
 	/* setup Socket parameters */
 	sk = sock->sk;
@@ -752,24 +698,74 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				       enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	int len;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
+	struct sockaddr_in6 addr;
+	int rc, len;
 
 	switch(param) {
 	case ISCSI_PARAM_CONN_PORT:
-		spin_lock_bh(&conn->session->lock);
-		len = sprintf(buf, "%hu\n", conn->portal_port);
-		spin_unlock_bh(&conn->session->lock);
-		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
 		spin_lock_bh(&conn->session->lock);
-		len = sprintf(buf, "%s\n", conn->portal_address);
+		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
+			spin_unlock_bh(&conn->session->lock);
+			return -ENOTCONN;
+		}
+		rc = kernel_getpeername(tcp_sw_conn->sock,
+					(struct sockaddr *)&addr, &len);
 		spin_unlock_bh(&conn->session->lock);
-		break;
+		if (rc)
+			return rc;
+
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+						 &addr, param, buf);
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
 	}
 
-	return len;
+	return 0;
+}
+
+static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
+				       enum iscsi_host_param param, char *buf)
+{
+	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
+	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_conn *conn;
+	struct iscsi_tcp_conn *tcp_conn;
+	struct iscsi_sw_tcp_conn *tcp_sw_conn;
+	struct sockaddr_in6 addr;
+	int rc, len;
+
+	switch (param) {
+	case ISCSI_HOST_PARAM_IPADDRESS:
+		spin_lock_bh(&session->lock);
+		conn = session->leadconn;
+		if (!conn) {
+			spin_unlock_bh(&session->lock);
+			return -ENOTCONN;
+		}
+		tcp_conn = conn->dd_data;
+
+		tcp_sw_conn = tcp_conn->dd_data;
+		if (!tcp_sw_conn->sock) {
+			spin_unlock_bh(&session->lock);
+			return -ENOTCONN;
+		}
+
+		rc = kernel_getsockname(tcp_sw_conn->sock,
+					(struct sockaddr *)&addr, &len);
+		spin_unlock_bh(&session->lock);
+		if (rc)
+			return rc;
+
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+						 &addr, param, buf);
+	default:
+		return iscsi_host_get_param(shost, param, buf);
+	}
+
+	return 0;
 }
 
 static void
@@ -797,6 +793,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
+	struct iscsi_sw_tcp_host *tcp_sw_host;
 	struct Scsi_Host *shost;
 
 	if (ep) {
@@ -804,7 +801,8 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		return NULL;
 	}
 
-	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht, 0, 1);
+	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht,
+				 sizeof(struct iscsi_sw_tcp_host), 1);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_sw_tcp_scsi_transport;
@@ -825,6 +823,8 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->session = session;
 
 	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
@@ -929,7 +929,7 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_sw_tcp_conn_stop,
 	/* iscsi host params */
-	.get_host_param		= iscsi_host_get_param,
+	.get_host_param		= iscsi_sw_tcp_host_get_param,
 	.set_host_param		= iscsi_host_set_param,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 94644ba..666fe09 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -55,6 +55,10 @@ struct iscsi_sw_tcp_conn {
 	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
 };
 
+struct iscsi_sw_tcp_host {
+	struct iscsi_session	*session;
+};
+
 struct iscsi_sw_tcp_hdrbuf {
 	struct iscsi_hdr	hdrbuf;
 	char			hdrextbuf[ISCSI_MAX_AHS_SIZE +
-- 
1.7.2.3

