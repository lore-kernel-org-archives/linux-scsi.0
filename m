From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/9] iscsi update: set deamon pid earlier
Date: Wed, 01 Feb 2006 21:07:01 -0600
Message-ID: <1138849621.3456.37.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30644 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423070AbWBBDHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>From michaelc@cs.wisc.edu:

If the transport lookup fails we set the daemon pid too late.
This can cause us deadlock since the netlink code will think we
meant to call back into our iscsi_if_rx function.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>



diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 448fd78..7fb6918 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -846,9 +846,6 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	struct iscsi_cls_session *session;
 	struct iscsi_cls_conn *conn;
 
-	if (NETLINK_CREDS(skb)->uid)
-		return -EPERM;
-
 	priv = iscsi_if_transport_lookup(iscsi_ptr(ev->transport_handle));
 	if (!priv)
 		return -EINVAL;
@@ -857,8 +854,6 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	if (!try_module_get(transport->owner))
 		return -EINVAL;
 
-	daemon_pid = NETLINK_CREDS(skb)->pid;
-
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
 		err = iscsi_if_create_session(priv, ev);
@@ -934,7 +929,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 
 /* Get message from skb (based on rtnetlink_rcv_skb).  Each message is
  * processed by iscsi_if_recv_msg.  Malformed skbs with wrong length are
- * discarded silently.  */
+ * or invalid creds discarded silently.  */
 static void
 iscsi_if_rx(struct sock *sk, int len)
 {
@@ -942,6 +937,12 @@ iscsi_if_rx(struct sock *sk, int len)
 
 	mutex_lock(&rx_queue_mutex);
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		if (NETLINK_CREDS(skb)->uid) {
+			skb_pull(skb, skb->len);
+			goto free_skb;
+		}
+		daemon_pid = NETLINK_CREDS(skb)->pid;
+
 		while (skb->len >= NLMSG_SPACE(0)) {
 			int err;
 			uint32_t rlen;
@@ -953,10 +954,12 @@ iscsi_if_rx(struct sock *sk, int len)
 			    skb->len < nlh->nlmsg_len) {
 				break;
 			}
+
 			ev = NLMSG_DATA(nlh);
 			rlen = NLMSG_ALIGN(nlh->nlmsg_len);
 			if (rlen > skb->len)
 				rlen = skb->len;
+
 			err = iscsi_if_recv_msg(skb, nlh);
 			if (err) {
 				ev->type = ISCSI_KEVENT_IF_ERROR;
@@ -980,6 +983,7 @@ iscsi_if_rx(struct sock *sk, int len)
 			} while (err < 0 && err != -ECONNREFUSED);
 			skb_pull(skb, rlen);
 		}
+free_skb:
 		kfree_skb(skb);
 	}
 	mutex_unlock(&rx_queue_mutex);


