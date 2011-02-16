From: michaelc@cs.wisc.edu
Subject: [PATCH 09/17] iscsi: fix iscsi_endpoint leak
Date: Wed, 16 Feb 2011 15:04:33 -0600
Message-ID: <1297890281-9076-10-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1BPVEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:37 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4bIQ009085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:37 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsw004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:36 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

When iscsid restarts it does not know the connection's
endpoint, so it is getting leaked. This fixes the problem
by having the iscsi class force a disconnect before a
new connection is bound.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   63 +++++++++++++++++++++++++++-------
 include/scsi/scsi_transport_iscsi.h |    3 ++
 2 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f905ecb..4e09b68 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -954,6 +954,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 	if (dd_size)
 		conn->dd_data = &conn[1];
 
+	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
 	conn->transport = transport;
 	conn->cid = cid;
@@ -1430,6 +1431,29 @@ release_host:
 	return err;
 }
 
+static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
+				  u64 ep_handle)
+{
+	struct iscsi_cls_conn *conn;
+	struct iscsi_endpoint *ep;
+
+	if (!transport->ep_disconnect)
+		return -EINVAL;
+
+	ep = iscsi_lookup_endpoint(ep_handle);
+	if (!ep)
+		return -EINVAL;
+	conn = ep->conn;
+	if (conn) {
+		mutex_lock(&conn->ep_mutex);
+		conn->ep = NULL;
+		mutex_unlock(&conn->ep_mutex);
+	}
+
+	transport->ep_disconnect(ep);
+	return 0;
+}
+
 static int
 iscsi_if_transport_ep(struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
@@ -1454,14 +1478,8 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 						   ev->u.ep_poll.timeout_ms);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
-		if (!transport->ep_disconnect)
-			return -EINVAL;
-
-		ep = iscsi_lookup_endpoint(ev->u.ep_disconnect.ep_handle);
-		if (!ep)
-			return -EINVAL;
-
-		transport->ep_disconnect(ep);
+		rc = iscsi_if_ep_disconnect(transport,
+					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
 	return rc;
@@ -1609,12 +1627,31 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		session = iscsi_session_lookup(ev->u.b_conn.sid);
 		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
-		if (session && conn)
-			ev->r.retcode =	transport->bind_conn(session, conn,
-					ev->u.b_conn.transport_eph,
-					ev->u.b_conn.is_leading);
-		else
+		if (conn && conn->ep)
+			iscsi_if_ep_disconnect(transport, conn->ep->id);
+
+		if (!session || !conn) {
 			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->bind_conn(session, conn,
+						ev->u.b_conn.transport_eph,
+						ev->u.b_conn.is_leading);
+		if (ev->r.retcode || !transport->ep_connect)
+			break;
+
+		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		if (ep) {
+			ep->conn = conn;
+
+			mutex_lock(&conn->ep_mutex);
+			conn->ep = ep;
+			mutex_unlock(&conn->ep_mutex);
+		} else
+			iscsi_cls_conn_printk(KERN_ERR, conn,
+					      "Could not set ep conn "
+					      "binding\n");
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
 		err = iscsi_set_param(transport, ev);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7fff94b..b9ba349 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -160,6 +160,8 @@ struct iscsi_cls_conn {
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
+	struct mutex ep_mutex;
+	struct iscsi_endpoint *ep;
 
 	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
@@ -222,6 +224,7 @@ struct iscsi_endpoint {
 	void *dd_data;			/* LLD private data */
 	struct device dev;
 	uint64_t id;
+	struct iscsi_cls_conn *conn;
 };
 
 /*
-- 
1.7.2.3

