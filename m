From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: [PATCH] iscsi transport endpoint calls
Date: Tue, 11 Apr 2006 16:47:15 +0300 (IDT)
Message-ID: <Pine.LNX.4.44.0604111646040.18200-100000@zuben>
References: <Pine.LNX.4.44.0604111644140.18200-100000@zuben>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:62374 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP
	id S1750924AbWDKNrR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 09:47:17 -0400
In-Reply-To: <Pine.LNX.4.44.0604111644140.18200-100000@zuben>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch allows for iscsi transport to have its connection 
being established and disconnected from the kernel.

The patch is the sixth iscsi update to 2.6.18 and is needed by iser,
it is relative to the five iscsi patches sent by Mike Christie.

Doing this is a must for iSER and some of the iscsi offloads but on the
other hand not needed for TCP where a socket (fd) is connected in user space
and then sent down to the kernel where struct sock is retrieved from the fd.

The iscsi user space implementation was enhanced to have a user space
transport where TCP is doing things directly from user space and iSER
is using the extension to the iscsi u/k IPC ABI to do things in the kernel.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>


Index: linux-2.6.17-rc1-iscsi/include/scsi/iscsi_if.h
===================================================================
--- linux-2.6.17-rc1-iscsi.orig/include/scsi/iscsi_if.h
+++ linux-2.6.17-rc1-iscsi/include/scsi/iscsi_if.h
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
 
Index: linux-2.6.17-rc1-iscsi/drivers/scsi/iscsi_tcp.c
===================================================================
--- linux-2.6.17-rc1-iscsi.orig/drivers/scsi/iscsi_tcp.c
+++ linux-2.6.17-rc1-iscsi/drivers/scsi/iscsi_tcp.c
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
Index: linux-2.6.17-rc1-iscsi/drivers/scsi/scsi_transport_iscsi.c
===================================================================
--- linux-2.6.17-rc1-iscsi.orig/drivers/scsi/scsi_transport_iscsi.c
+++ linux-2.6.17-rc1-iscsi/drivers/scsi/scsi_transport_iscsi.c
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
Index: linux-2.6.17-rc1-iscsi/include/scsi/scsi_transport_iscsi.h
===================================================================
--- linux-2.6.17-rc1-iscsi.orig/include/scsi/scsi_transport_iscsi.h
+++ linux-2.6.17-rc1-iscsi/include/scsi/scsi_transport_iscsi.h
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

