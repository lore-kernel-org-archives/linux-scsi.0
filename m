From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/9] iscsi: add async notification of session events
Date: Wed, 28 Jun 2006 12:00:32 -0500
Message-ID: <1151514032.11553.55.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32435 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423381AbWF1RFW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:05:22 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH50Vo019965
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:05:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds or modifies the transport class functions
used to notify userspace of session state events.

We modify the session addition up event and add a destruction event
to notify userspace of session creation, relogin and destruction.

And we modify the conn error event to be sent by broadcast
since multiple listeners may want to listen for it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7963c05..2e1dfbd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -413,11 +413,59 @@ int iscsi_destroy_session(struct iscsi_c
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_session);
 
+static void mempool_zone_destroy(struct mempool_zone *zp)
+{
+	mempool_destroy(zp->pool);
+	kfree(zp);
+}
+
+static void*
+mempool_zone_alloc_skb(gfp_t gfp_mask, void *pool_data)
+{
+	struct mempool_zone *zone = pool_data;
+
+	return alloc_skb(zone->size, gfp_mask);
+}
+
+static void
+mempool_zone_free_skb(void *element, void *pool_data)
+{
+	kfree_skb(element);
+}
+
+static struct mempool_zone *
+mempool_zone_init(unsigned max, unsigned size, unsigned hiwat)
+{
+	struct mempool_zone *zp;
+
+	zp = kzalloc(sizeof(*zp), GFP_KERNEL);
+	if (!zp)
+		return NULL;
+
+	zp->size = size;
+	zp->hiwat = hiwat;
+	INIT_LIST_HEAD(&zp->freequeue);
+	spin_lock_init(&zp->freelock);
+	atomic_set(&zp->allocated, 0);
+
+	zp->pool = mempool_create(max, mempool_zone_alloc_skb,
+				  mempool_zone_free_skb, zp);
+	if (!zp->pool) {
+		kfree(zp);
+		return NULL;
+	}
+
+	return zp;
+}
+
 static void iscsi_conn_release(struct device *dev)
 {
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
 	struct device *parent = conn->dev.parent;
 
+	mempool_zone_destroy(conn->z_pdu);
+	mempool_zone_destroy(conn->z_error);
+
 	kfree(conn);
 	put_device(parent);
 }
@@ -427,6 +475,31 @@ static int iscsi_is_conn_dev(const struc
 	return dev->release == iscsi_conn_release;
 }
 
+static int iscsi_create_event_pools(struct iscsi_cls_conn *conn)
+{
+	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
+			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
+				    sizeof(struct iscsi_hdr) +
+				    DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH),
+			Z_HIWAT_PDU);
+	if (!conn->z_pdu) {
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
+			   "pdu zone for new conn\n");
+		return -ENOMEM;
+	}
+
+	conn->z_error = mempool_zone_init(Z_MAX_ERROR,
+			NLMSG_SPACE(sizeof(struct iscsi_uevent)),
+			Z_HIWAT_ERROR);
+	if (!conn->z_error) {
+		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
+			   "error zone for new conn\n");
+		mempool_zone_destroy(conn->z_pdu);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 /**
  * iscsi_create_conn - create iscsi class connection
  * @session: iscsi cls session
@@ -459,9 +532,12 @@ iscsi_create_conn(struct iscsi_cls_sessi
 	conn->transport = transport;
 	conn->cid = cid;
 
+	if (iscsi_create_event_pools(conn))
+		goto free_conn;
+
 	/* this is released in the dev's release function */
 	if (!get_device(&session->dev))
-		goto free_conn;
+		goto free_conn_pools;
 
 	snprintf(conn->dev.bus_id, BUS_ID_SIZE, "connection%d:%u",
 		 session->sid, cid);
@@ -478,6 +554,8 @@ iscsi_create_conn(struct iscsi_cls_sessi
 
 release_parent_ref:
 	put_device(&session->dev);
+free_conn_pools:
+
 free_conn:
 	kfree(conn);
 	return NULL;
@@ -525,20 +603,6 @@ static inline struct list_head *skb_to_l
 	return (struct list_head *)&skb->cb;
 }
 
-static void*
-mempool_zone_alloc_skb(gfp_t gfp_mask, void *pool_data)
-{
-	struct mempool_zone *zone = pool_data;
-
-	return alloc_skb(zone->size, gfp_mask);
-}
-
-static void
-mempool_zone_free_skb(void *element, void *pool_data)
-{
-	kfree_skb(element);
-}
-
 static void
 mempool_zone_complete(struct mempool_zone *zone)
 {
@@ -558,37 +622,6 @@ mempool_zone_complete(struct mempool_zon
 	spin_unlock_irqrestore(&zone->freelock, flags);
 }
 
-static struct mempool_zone *
-mempool_zone_init(unsigned max, unsigned size, unsigned hiwat)
-{
-	struct mempool_zone *zp;
-
-	zp = kzalloc(sizeof(*zp), GFP_KERNEL);
-	if (!zp)
-		return NULL;
-
-	zp->size = size;
-	zp->hiwat = hiwat;
-	INIT_LIST_HEAD(&zp->freequeue);
-	spin_lock_init(&zp->freelock);
-	atomic_set(&zp->allocated, 0);
-
-	zp->pool = mempool_create(max, mempool_zone_alloc_skb,
-				  mempool_zone_free_skb, zp);
-	if (!zp->pool) {
-		kfree(zp);
-		return NULL;
-	}
-
-	return zp;
-}
-
-static void mempool_zone_destroy(struct mempool_zone *zp)
-{
-	mempool_destroy(zp->pool);
-	kfree(zp);
-}
-
 static struct sk_buff*
 mempool_zone_get_skb(struct mempool_zone *zone)
 {
@@ -601,6 +634,27 @@ mempool_zone_get_skb(struct mempool_zone
 }
 
 static int
+iscsi_broadcast_skb(struct mempool_zone *zone, struct sk_buff *skb)
+{
+	unsigned long flags;
+	int rc;
+
+	skb_get(skb);
+	rc = netlink_broadcast(nls, skb, 0, 1, GFP_KERNEL);
+	if (rc < 0) {
+		mempool_free(skb, zone->pool);
+		printk(KERN_ERR "iscsi: can not broadcast skb (%d)\n", rc);
+		return rc;
+	}
+
+	spin_lock_irqsave(&zone->freelock, flags);
+	INIT_LIST_HEAD(skb_to_lh(skb));
+	list_add(skb_to_lh(skb), &zone->freequeue);
+	spin_unlock_irqrestore(&zone->freelock, flags);
+	return 0;
+}
+
+static int
 iscsi_unicast_skb(struct mempool_zone *zone, struct sk_buff *skb, int pid)
 {
 	unsigned long flags;
@@ -695,7 +749,7 @@ void iscsi_conn_error(struct iscsi_cls_c
 	ev->r.connerror.cid = conn->cid;
 	ev->r.connerror.sid = iscsi_conn_get_sid(conn);
 
-	iscsi_unicast_skb(conn->z_error, skb, priv->daemon_pid);
+	iscsi_broadcast_skb(conn->z_error, skb);
 
 	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
 		   error);
@@ -796,6 +850,131 @@ iscsi_if_get_stats(struct iscsi_transpor
 	return err;
 }
 
+/**
+ * iscsi_if_destroy_session_done - send session destr. completion event
+ * @conn: last connection for session
+ *
+ * This is called by HW iscsi LLDs to notify userpsace that its HW has
+ * removed a session.
+ **/
+int iscsi_if_destroy_session_done(struct iscsi_cls_conn *conn)
+{
+	struct iscsi_internal *priv;
+	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+	struct iscsi_uevent *ev;
+	struct sk_buff  *skb;
+	struct nlmsghdr *nlh;
+	unsigned long flags;
+	int rc, len = NLMSG_SPACE(sizeof(*ev));
+
+	priv = iscsi_if_transport_lookup(conn->transport);
+	if (!priv)
+		return -EINVAL;
+
+	session = iscsi_dev_to_session(conn->dev.parent);
+	shost = iscsi_session_to_shost(session);
+
+	mempool_zone_complete(conn->z_pdu);
+
+	skb = mempool_zone_get_skb(conn->z_pdu);
+	if (!skb) {
+		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
+			  "session creation event\n");
+		return -ENOMEM;
+	}
+
+	nlh = __nlmsg_put(skb, priv->daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
+	ev = NLMSG_DATA(nlh);
+	ev->transport_handle = iscsi_handle(conn->transport);
+	ev->type = ISCSI_KEVENT_DESTROY_SESSION;
+	ev->r.d_session.host_no = shost->host_no;
+	ev->r.d_session.sid = session->sid;
+
+	/*
+	 * this will occur if the daemon is not up, so we just warn
+	 * the user and when the daemon is restarted it will handle it
+	 */
+	rc = iscsi_broadcast_skb(conn->z_pdu, skb);
+	if (rc < 0)
+		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
+			  "session destruction event. Check iscsi daemon\n");
+
+	spin_lock_irqsave(&sesslock, flags);
+	list_del(&session->sess_list);
+	spin_unlock_irqrestore(&sesslock, flags);
+
+	spin_lock_irqsave(&connlock, flags);
+	conn->active = 0;
+	list_del(&conn->conn_list);
+	spin_unlock_irqrestore(&connlock, flags);
+
+	return rc;	
+}
+EXPORT_SYMBOL_GPL(iscsi_if_destroy_session_done);
+
+/**
+ * iscsi_if_create_session_done - send session creation completion event
+ * @conn: leading connection for session
+ *
+ * This is called by HW iscsi LLDs to notify userpsace that its HW has
+ * created a session or a existing session is back in the logged in state.
+ **/
+int iscsi_if_create_session_done(struct iscsi_cls_conn *conn)
+{
+	struct iscsi_internal *priv;
+	struct iscsi_cls_session *session;
+	struct Scsi_Host *shost;
+	struct iscsi_uevent *ev;
+	struct sk_buff  *skb;
+	struct nlmsghdr *nlh;
+	unsigned long flags;
+	int rc, len = NLMSG_SPACE(sizeof(*ev));
+
+	priv = iscsi_if_transport_lookup(conn->transport);
+	if (!priv)
+		return -EINVAL;
+
+	session = iscsi_dev_to_session(conn->dev.parent);
+	shost = iscsi_session_to_shost(session);
+
+	mempool_zone_complete(conn->z_pdu);
+
+	skb = mempool_zone_get_skb(conn->z_pdu);
+	if (!skb) {
+		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
+			  "session creation event\n");
+		return -ENOMEM;
+	}
+
+	nlh = __nlmsg_put(skb, priv->daemon_pid, 0, 0, (len - sizeof(*nlh)), 0);
+	ev = NLMSG_DATA(nlh);
+	ev->transport_handle = iscsi_handle(conn->transport);
+	ev->type = ISCSI_UEVENT_CREATE_SESSION;
+	ev->r.c_session_ret.host_no = shost->host_no;
+	ev->r.c_session_ret.sid = session->sid;
+
+	/*
+	 * this will occur if the daemon is not up, so we just warn
+	 * the user and when the daemon is restarted it will handle it
+	 */
+	rc = iscsi_broadcast_skb(conn->z_pdu, skb);
+	if (rc < 0)
+		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
+			  "session creation event. Check iscsi daemon\n");
+
+	spin_lock_irqsave(&sesslock, flags);
+	list_add(&session->sess_list, &sesslist);
+	spin_unlock_irqrestore(&sesslock, flags);
+
+	spin_lock_irqsave(&connlock, flags);
+	list_add(&conn->conn_list, &connlist);
+	conn->active = 1;
+	spin_unlock_irqrestore(&connlock, flags);
+	return rc;	
+}
+EXPORT_SYMBOL_GPL(iscsi_if_create_session_done);
+
 static int
 iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
 {
@@ -841,26 +1020,6 @@ iscsi_if_create_conn(struct iscsi_transp
 		return -ENOMEM;
 	}
 
-	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
-			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
-				    sizeof(struct iscsi_hdr) +
-				    DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH),
-			Z_HIWAT_PDU);
-	if (!conn->z_pdu) {
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
-			   "pdu zone for new conn\n");
-		goto destroy_conn;
-	}
-
-	conn->z_error = mempool_zone_init(Z_MAX_ERROR,
-			NLMSG_SPACE(sizeof(struct iscsi_uevent)),
-			Z_HIWAT_ERROR);
-	if (!conn->z_error) {
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
-			   "error zone for new conn\n");
-		goto free_pdu_pool;
-	}
-
 	ev->r.c_conn_ret.sid = session->sid;
 	ev->r.c_conn_ret.cid = conn->cid;
 
@@ -870,13 +1029,6 @@ iscsi_if_create_conn(struct iscsi_transp
 	spin_unlock_irqrestore(&connlock, flags);
 
 	return 0;
-
-free_pdu_pool:
-	mempool_zone_destroy(conn->z_pdu);
-destroy_conn:
-	if (transport->destroy_conn)
-		transport->destroy_conn(conn->dd_data);
-	return -ENOMEM;
 }
 
 static int
@@ -884,7 +1036,6 @@ iscsi_if_destroy_conn(struct iscsi_trans
 {
 	unsigned long flags;
 	struct iscsi_cls_conn *conn;
-	struct mempool_zone *z_error, *z_pdu;
 
 	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
@@ -894,15 +1045,8 @@ iscsi_if_destroy_conn(struct iscsi_trans
 	list_del(&conn->conn_list);
 	spin_unlock_irqrestore(&connlock, flags);
 
-	z_pdu = conn->z_pdu;
-	z_error = conn->z_error;
-
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
-
-	mempool_zone_destroy(z_pdu);
-	mempool_zone_destroy(z_error);
-
 	return 0;
 }
 
@@ -1331,6 +1475,7 @@ iscsi_register_transport(struct iscsi_tr
 	if (!priv)
 		return NULL;
 	INIT_LIST_HEAD(&priv->list);
+	priv->daemon_pid = -1;
 	priv->iscsi_transport = tt;
 	priv->t.user_scan = iscsi_user_scan;
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 8813f0f..55ebf03 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -53,6 +53,7 @@ enum iscsi_uevent_e {
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
 	ISCSI_KEVENT_CONN_ERROR		= KEVENT_BASE + 2,
 	ISCSI_KEVENT_IF_ERROR		= KEVENT_BASE + 3,
+	ISCSI_KEVENT_DESTROY_SESSION	= KEVENT_BASE + 4,
 };
 
 enum iscsi_tgt_dscvr {
@@ -157,27 +158,13 @@ struct iscsi_uevent {
 			uint32_t	cid;
 			uint32_t	error; /* enum iscsi_err */
 		} connerror;
+		struct msg_session_destroyed {
+			uint32_t	host_no;
+			uint32_t	sid;
+		} d_session;
 		struct msg_transport_connect_ret {
 			uint64_t	handle;
 		} ep_connect_ret;
-		struct msg_tgt_dscvr_ret {
-			/*
-			 * session/connection pair used to reference
-			 * the connection to server
-			 */
-			uint32_t	sid;
-			uint32_t	cid;
-			union {
-				struct isns {
-					/* port # for conn to iSNS server */
-					uint16_t isns_port;
-					/* listening port to receive SCNs */
-					uint16_t scn_port;
-					/* listening port to receive ESIs */
-					uint16_t esi_port;
-				} isns_attrib;
-			} u;
-		} tgt_dscvr_ret;
 	} r;
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f7b0db5..5a3df1d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -214,6 +214,8 @@ extern struct iscsi_cls_session *iscsi_a
 					struct iscsi_transport *transport);
 extern int iscsi_add_session(struct iscsi_cls_session *session,
 			     unsigned int target_id);
+extern int iscsi_if_create_session_done(struct iscsi_cls_conn *conn);
+extern int iscsi_if_destroy_session_done(struct iscsi_cls_conn *conn);
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t,
 						unsigned int target_id);
@@ -226,4 +228,5 @@ extern int iscsi_destroy_conn(struct isc
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
 
+
 #endif


