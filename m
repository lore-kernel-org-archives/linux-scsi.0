From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/5] iscsi: add transport end point callbacks
Date: Tue, 02 May 2006 19:46:36 -0500
Message-ID: <1146617196.2601.14.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61101 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964980AbWECAoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 20:44:22 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k430iL7k010710
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 2 May 2006 19:44:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

from ogerlitz@voltaire.com:

add transport end point callbacks so iscsi drivers that cannot connect
from userspace, like iscsi tcp, using sockets do not have to
implement their own socket infrastructure.

Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com> 
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index fe00a3f..ac507da 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1975,7 +1975,7 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 
 static int
 iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
-		    struct iscsi_cls_conn *cls_conn, uint32_t transport_fd,
+		    struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		    int is_leading)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
@@ -1985,7 +1985,7 @@ iscsi_tcp_conn_bind(struct iscsi_cls_ses
 	int err;
 
 	/* lookup for existing socket */
-	sock = sockfd_lookup(transport_fd, &err);
+	sock = sockfd_lookup((int)transport_eph, &err);
 	if (!sock) {
 		printk(KERN_ERR "iscsi_tcp: sockfd_lookup failed %d\n", err);
 		return -EEXIST;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bc9071d..7b7a194 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -929,6 +929,40 @@ iscsi_set_param(struct iscsi_transport *
 }
 
 static int
+iscsi_if_transport_ep(struct iscsi_transport *transport,
+		      struct iscsi_uevent *ev, int msg_type)
+{
+	struct sockaddr *dst_addr;
+	int rc = 0;
+
+	switch (msg_type) {
+	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
+		if (!transport->ep_connect)
+			return -EINVAL;
+
+		dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
+		rc = transport->ep_connect(dst_addr,
+					   ev->u.ep_connect.non_blocking,
+					   &ev->r.ep_connect_ret.handle);
+		break;
+	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
+		if (!transport->ep_poll)
+			return -EINVAL;
+
+		ev->r.retcode = transport->ep_poll(ev->u.ep_poll.ep_handle,
+						   ev->u.ep_poll.timeout_ms);
+		break;
+	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
+		if (!transport->ep_disconnect)
+			return -EINVAL;
+
+		transport->ep_disconnect(ev->u.ep_disconnect.ep_handle);
+		break;
+	}
+	return rc;
+}
+
+static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	int err = 0;
@@ -974,7 +1008,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 
 		if (session && conn)
 			ev->r.retcode =	transport->bind_conn(session, conn,
-					ev->u.b_conn.transport_fd,
+					ev->u.b_conn.transport_eph,
 					ev->u.b_conn.is_leading);
 		else
 			err = -EINVAL;
@@ -1009,6 +1043,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(transport, nlh);
 		break;
+	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
+	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
+	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
+		err = iscsi_if_transport_ep(transport, ev, nlh->nlmsg_type);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 47524c7..feff74e 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -43,6 +43,10 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_GET_STATS		= UEVENT_BASE + 10,
 	ISCSI_UEVENT_GET_PARAM		= UEVENT_BASE + 11,
 
+	ISCSI_UEVENT_TRANSPORT_EP_CONNECT	= UEVENT_BASE + 12,
+	ISCSI_UEVENT_TRANSPORT_EP_POLL		= UEVENT_BASE + 13,
+	ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT	= UEVENT_BASE + 14,
+
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
 	ISCSI_KEVENT_CONN_ERROR		= KEVENT_BASE + 2,
@@ -69,7 +73,7 @@ struct iscsi_uevent {
 		struct msg_bind_conn {
 			uint32_t	sid;
 			uint32_t	cid;
-			uint32_t	transport_fd;
+			uint64_t	transport_eph;
 			uint32_t	is_leading;
 		} b_conn;
 		struct msg_destroy_conn {
@@ -102,6 +106,16 @@ struct iscsi_uevent {
 			uint32_t	sid;
 			uint32_t	cid;
 		} get_stats;
+		struct msg_transport_connect {
+			uint32_t	non_blocking;
+		} ep_connect;
+		struct msg_transport_poll {
+			uint64_t	ep_handle;
+			uint32_t	timeout_ms;
+		} ep_poll;
+		struct msg_transport_disconnect {
+			uint64_t	ep_handle;
+		} ep_disconnect;
 	} u;
 	union {
 		/* messages k -> u */
@@ -124,6 +138,9 @@ struct iscsi_uevent {
 			uint32_t	cid;
 			uint32_t	error; /* enum iscsi_err */
 		} connerror;
+		struct msg_transport_connect_ret {
+			uint64_t	handle;
+		} ep_connect_ret;
 	} r;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b332d6e..c9e9475 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -88,7 +88,7 @@ struct iscsi_transport {
 				uint32_t cid);
 	int (*bind_conn) (struct iscsi_cls_session *session,
 			  struct iscsi_cls_conn *cls_conn,
-			  uint32_t transport_fd, int is_leading);
+			  uint64_t transport_eph, int is_leading);
 	int (*start_conn) (struct iscsi_cls_conn *conn);
 	void (*stop_conn) (struct iscsi_cls_conn *conn, int flag);
 	void (*destroy_conn) (struct iscsi_cls_conn *conn);
@@ -119,6 +119,10 @@ struct iscsi_transport {
 	int (*xmit_mgmt_task) (struct iscsi_conn *conn,
 			       struct iscsi_mgmt_task *mtask);
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
+	int (*ep_connect) (struct sockaddr *dst_addr, int non_blocking,
+			   uint64_t *ep_handle);
+	int (*ep_poll) (uint64_t ep_handle, int timeout_ms);
+	void (*ep_disconnect) (uint64_t ep_handle);
 };
 
 /*


