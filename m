From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/6] iscsi update: support mutiple daemons
Date: Thu, 18 May 2006 20:31:39 -0500
Message-ID: <1148002299.3248.25.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61060 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932202AbWESBdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:33:47 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1XQwN007215
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:33:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Patch from david.somayajulu@qlogic.com and cleaned up by Tomo.

qla4xxx is going to have a different daemon so this patch
just routes the events to the right daemon.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 44adafa..5569fdc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -36,6 +36,7 @@
 #define ISCSI_HOST_ATTRS 0
 
 struct iscsi_internal {
+	int daemon_pid;
 	struct scsi_transport_template t;
 	struct iscsi_transport *iscsi_transport;
 	struct list_head list;
@@ -145,7 +146,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_con
 			       NULL);
 
 static struct sock *nls;
-static int daemon_pid;
 static DEFINE_MUTEX(rx_queue_mutex);
 
 struct mempool_zone {
@@ -572,13 +572,13 @@ mempool_zone_get_skb(struct mempool_zone
 }
 
 static int
-iscsi_unicast_skb(struct mempool_zone *zone, struct sk_buff *skb)
+iscsi_unicast_skb(struct mempool_zone *zone, struct sk_buff *skb, int pid)
 {
 	unsigned long flags;
 	int rc;
 
 	skb_get(skb);
-	rc = netlink_unicast(nls, skb, daemon_pid, MSG_DONTWAIT);
+	rc = netlink_unicast(nls, skb, pid, MSG_DONTWAIT);
 	if (rc < 0) {
 		mempool_free(skb, zone->pool);
 		printk(KERN_ERR "iscsi: can not unicast skb (%d)\n", rc);
@@ -600,9 +600,14 @@ int iscsi_recv_pdu(struct iscsi_cls_conn
 	struct sk_buff *skb;
 	struct iscsi_uevent *ev;
 	char *pdu;
+	struct iscsi_internal *priv;
 	int len = NLMSG_SPACE(sizeof(*ev) + sizeof(struct iscsi_hdr) +
 			      data_size);
 
+	priv = iscsi_if_transport_lookup(conn->transport);
+	if (!priv)
+		return -EINVAL;
+
 	mempool_zone_complete(conn->z_pdu);
 
 	skb = mempool_zone_get_skb(conn->z_pdu);
@@ -613,7 +618,7 @@ int iscsi_recv_pdu(struct iscsi_cls_conn
 		return -ENOMEM;
 	}
 
-	nlh = __nlmsg_put(skb, daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
+	nlh = __nlmsg_put(skb, priv->daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
 	ev = NLMSG_DATA(nlh);
 	memset(ev, 0, sizeof(*ev));
 	ev->transport_handle = iscsi_handle(conn->transport);
@@ -626,7 +631,7 @@ int iscsi_recv_pdu(struct iscsi_cls_conn
 	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
 	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
 
-	return iscsi_unicast_skb(conn->z_pdu, skb);
+	return iscsi_unicast_skb(conn->z_pdu, skb, priv->daemon_pid);
 }
 EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
@@ -635,8 +640,13 @@ void iscsi_conn_error(struct iscsi_cls_c
 	struct nlmsghdr	*nlh;
 	struct sk_buff	*skb;
 	struct iscsi_uevent *ev;
+	struct iscsi_internal *priv;
 	int len = NLMSG_SPACE(sizeof(*ev));
 
+	priv = iscsi_if_transport_lookup(conn->transport);
+	if (!priv)
+		return;
+
 	mempool_zone_complete(conn->z_error);
 
 	skb = mempool_zone_get_skb(conn->z_error);
@@ -646,7 +656,7 @@ void iscsi_conn_error(struct iscsi_cls_c
 		return;
 	}
 
-	nlh = __nlmsg_put(skb, daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
+	nlh = __nlmsg_put(skb, priv->daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
 	ev = NLMSG_DATA(nlh);
 	ev->transport_handle = iscsi_handle(conn->transport);
 	ev->type = ISCSI_KEVENT_CONN_ERROR;
@@ -656,7 +666,7 @@ void iscsi_conn_error(struct iscsi_cls_c
 	ev->r.connerror.cid = conn->cid;
 	ev->r.connerror.sid = iscsi_conn_get_sid(conn);
 
-	iscsi_unicast_skb(conn->z_error, skb);
+	iscsi_unicast_skb(conn->z_error, skb, priv->daemon_pid);
 
 	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
 		   error);
@@ -686,7 +696,7 @@ iscsi_if_send_reply(int pid, int seq, in
 	nlh = __nlmsg_put(skb, pid, seq, t, (len - sizeof(*nlh)), 0);
 	nlh->nlmsg_flags = flags;
 	memcpy(NLMSG_DATA(nlh), payload, size);
-	return iscsi_unicast_skb(z_reply, skb);
+	return iscsi_unicast_skb(z_reply, skb, pid);
 }
 
 static int
@@ -698,12 +708,17 @@ iscsi_if_get_stats(struct iscsi_transpor
 	struct iscsi_cls_conn *conn;
 	struct nlmsghdr	*nlhstat;
 	struct iscsi_uevent *evstat;
+	struct iscsi_internal *priv;
 	int len = NLMSG_SPACE(sizeof(*ev) +
 			      sizeof(struct iscsi_stats) +
 			      sizeof(struct iscsi_stats_custom) *
 			      ISCSI_STATS_CUSTOM_MAX);
 	int err = 0;
 
+	priv = iscsi_if_transport_lookup(transport);
+	if (!priv)
+		return -EINVAL;
+
 	conn = iscsi_conn_lookup(ev->u.get_stats.sid, ev->u.get_stats.cid);
 	if (!conn)
 		return -EEXIST;
@@ -720,7 +735,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 			return -ENOMEM;
 		}
 
-		nlhstat = __nlmsg_put(skbstat, daemon_pid, 0, 0,
+		nlhstat = __nlmsg_put(skbstat, priv->daemon_pid, 0, 0,
 				      (len - sizeof(*nlhstat)), 0);
 		evstat = NLMSG_DATA(nlhstat);
 		memset(evstat, 0, sizeof(*evstat));
@@ -746,7 +761,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 		skb_trim(skbstat, NLMSG_ALIGN(actual_size));
 		nlhstat->nlmsg_len = actual_size;
 
-		err = iscsi_unicast_skb(conn->z_pdu, skbstat);
+		err = iscsi_unicast_skb(conn->z_pdu, skbstat, priv->daemon_pid);
 	} while (err < 0 && err != -ECONNREFUSED);
 
 	return err;
@@ -981,6 +996,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	if (!try_module_get(transport->owner))
 		return -EINVAL;
 
+	priv->daemon_pid = NETLINK_CREDS(skb)->pid;
+
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
 		err = iscsi_if_create_session(priv, ev);
@@ -1073,7 +1090,6 @@ iscsi_if_rx(struct sock *sk, int len)
 			skb_pull(skb, skb->len);
 			goto free_skb;
 		}
-		daemon_pid = NETLINK_CREDS(skb)->pid;
 
 		while (skb->len >= NLMSG_SPACE(0)) {
 			int err;


