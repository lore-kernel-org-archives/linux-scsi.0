From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] iscsi class: fix slab corruption during restart
Date: Mon, 16 Oct 2006 18:09:38 -0400
Message-ID: <1161036583544-git-send-email-michaelc@cs.wisc.edu>
References: <11610365823995-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59585 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422896AbWJPXJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:09:37 -0400
In-Reply-To: <11610365823995-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The transport class recv mempools are causing slab corruption.
We could hack around netlink's lack of mempool support like dm,
but it is just too ulgy (dm's hack is ugly enough :) when you need
to support broadcast.

This patch removes the recv pools. We have not used them even when
we were allocting 20 MB per session and the system only had 64 MBs.
And we have no pools on the send side and have been ok there. When
Peter's work gets merged we can use that since the network guys
are in favor of that approach and are not going to add mempools
everywhere.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |  246 ++---------------------------------
 include/scsi/scsi_transport_iscsi.h |    4 -
 2 files changed, 17 insertions(+), 233 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 7b0019c..2d3baa9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -21,7 +21,6 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <linux/module.h>
-#include <linux/mempool.h>
 #include <linux/mutex.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
@@ -149,30 +148,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_con
 static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
-struct mempool_zone {
-	mempool_t *pool;
-	atomic_t allocated;
-	int size;
-	int hiwat;
-	struct list_head freequeue;
-	spinlock_t freelock;
-};
-
-static struct mempool_zone *z_reply;
-
-/*
- * Z_MAX_* - actual mempool size allocated at the mempool_zone_init() time
- * Z_HIWAT_* - zone's high watermark when if_error bit will be set to -ENOMEM
- *             so daemon will notice OOM on NETLINK tranposrt level and will
- *             be able to predict or change operational behavior
- */
-#define Z_MAX_REPLY	8
-#define Z_HIWAT_REPLY	6
-#define Z_MAX_PDU	8
-#define Z_HIWAT_PDU	6
-#define Z_MAX_ERROR	16
-#define Z_HIWAT_ERROR	12
-
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
@@ -414,59 +389,11 @@ int iscsi_destroy_session(struct iscsi_c
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_session);
 
-static void mempool_zone_destroy(struct mempool_zone *zp)
-{
-	mempool_destroy(zp->pool);
-	kfree(zp);
-}
-
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
 static void iscsi_conn_release(struct device *dev)
 {
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
 	struct device *parent = conn->dev.parent;
 
-	mempool_zone_destroy(conn->z_pdu);
-	mempool_zone_destroy(conn->z_error);
-
 	kfree(conn);
 	put_device(parent);
 }
@@ -476,31 +403,6 @@ static int iscsi_is_conn_dev(const struc
 	return dev->release == iscsi_conn_release;
 }
 
-static int iscsi_create_event_pools(struct iscsi_cls_conn *conn)
-{
-	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
-			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
-				    sizeof(struct iscsi_hdr) +
-				    DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH),
-			Z_HIWAT_PDU);
-	if (!conn->z_pdu) {
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
-			   "pdu zone for new conn\n");
-		return -ENOMEM;
-	}
-
-	conn->z_error = mempool_zone_init(Z_MAX_ERROR,
-			NLMSG_SPACE(sizeof(struct iscsi_uevent)),
-			Z_HIWAT_ERROR);
-	if (!conn->z_error) {
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not allocate "
-			   "error zone for new conn\n");
-		mempool_zone_destroy(conn->z_pdu);
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 /**
  * iscsi_create_conn - create iscsi class connection
  * @session: iscsi cls session
@@ -533,12 +435,9 @@ iscsi_create_conn(struct iscsi_cls_sessi
 	conn->transport = transport;
 	conn->cid = cid;
 
-	if (iscsi_create_event_pools(conn))
-		goto free_conn;
-
 	/* this is released in the dev's release function */
 	if (!get_device(&session->dev))
-		goto free_conn_pools;
+		goto free_conn;
 
 	snprintf(conn->dev.bus_id, BUS_ID_SIZE, "connection%d:%u",
 		 session->sid, cid);
@@ -555,8 +454,6 @@ iscsi_create_conn(struct iscsi_cls_sessi
 
 release_parent_ref:
 	put_device(&session->dev);
-free_conn_pools:
-
 free_conn:
 	kfree(conn);
 	return NULL;
@@ -599,81 +496,31 @@ iscsi_if_transport_lookup(struct iscsi_t
 	return NULL;
 }
 
-static inline struct list_head *skb_to_lh(struct sk_buff *skb)
-{
-	return (struct list_head *)&skb->cb;
-}
-
-static void
-mempool_zone_complete(struct mempool_zone *zone)
-{
-	unsigned long flags;
-	struct list_head *lh, *n;
-
-	spin_lock_irqsave(&zone->freelock, flags);
-	list_for_each_safe(lh, n, &zone->freequeue) {
-		struct sk_buff *skb = (struct sk_buff *)((char *)lh -
-				offsetof(struct sk_buff, cb));
-		if (!skb_shared(skb)) {
-			list_del(skb_to_lh(skb));
-			mempool_free(skb, zone->pool);
-			atomic_dec(&zone->allocated);
-		}
-	}
-	spin_unlock_irqrestore(&zone->freelock, flags);
-}
-
-static struct sk_buff*
-mempool_zone_get_skb(struct mempool_zone *zone)
-{
-	struct sk_buff *skb;
-
-	skb = mempool_alloc(zone->pool, GFP_ATOMIC);
-	if (skb)
-		atomic_inc(&zone->allocated);
-	return skb;
-}
-
 static int
-iscsi_broadcast_skb(struct mempool_zone *zone, struct sk_buff *skb, gfp_t gfp)
+iscsi_broadcast_skb(struct sk_buff *skb, gfp_t gfp)
 {
-	unsigned long flags;
 	int rc;
 
-	skb_get(skb);
 	rc = netlink_broadcast(nls, skb, 0, 1, gfp);
 	if (rc < 0) {
-		mempool_free(skb, zone->pool);
 		printk(KERN_ERR "iscsi: can not broadcast skb (%d)\n", rc);
 		return rc;
 	}
 
-	spin_lock_irqsave(&zone->freelock, flags);
-	INIT_LIST_HEAD(skb_to_lh(skb));
-	list_add(skb_to_lh(skb), &zone->freequeue);
-	spin_unlock_irqrestore(&zone->freelock, flags);
 	return 0;
 }
 
 static int
-iscsi_unicast_skb(struct mempool_zone *zone, struct sk_buff *skb, int pid)
+iscsi_unicast_skb(struct sk_buff *skb, int pid)
 {
-	unsigned long flags;
 	int rc;
 
-	skb_get(skb);
 	rc = netlink_unicast(nls, skb, pid, MSG_DONTWAIT);
 	if (rc < 0) {
-		mempool_free(skb, zone->pool);
 		printk(KERN_ERR "iscsi: can not unicast skb (%d)\n", rc);
 		return rc;
 	}
 
-	spin_lock_irqsave(&zone->freelock, flags);
-	INIT_LIST_HEAD(skb_to_lh(skb));
-	list_add(skb_to_lh(skb), &zone->freequeue);
-	spin_unlock_irqrestore(&zone->freelock, flags);
-
 	return 0;
 }
 
@@ -692,9 +539,7 @@ int iscsi_recv_pdu(struct iscsi_cls_conn
 	if (!priv)
 		return -EINVAL;
 
-	mempool_zone_complete(conn->z_pdu);
-
-	skb = mempool_zone_get_skb(conn->z_pdu);
+	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
 		iscsi_conn_error(conn, ISCSI_ERR_CONN_FAILED);
 		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not deliver "
@@ -707,15 +552,13 @@ int iscsi_recv_pdu(struct iscsi_cls_conn
 	memset(ev, 0, sizeof(*ev));
 	ev->transport_handle = iscsi_handle(conn->transport);
 	ev->type = ISCSI_KEVENT_RECV_PDU;
-	if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
-		ev->iferror = -ENOMEM;
 	ev->r.recv_req.cid = conn->cid;
 	ev->r.recv_req.sid = iscsi_conn_get_sid(conn);
 	pdu = (char*)ev + sizeof(*ev);
 	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
 	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
 
-	return iscsi_unicast_skb(conn->z_pdu, skb, priv->daemon_pid);
+	return iscsi_unicast_skb(skb, priv->daemon_pid);
 }
 EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
@@ -731,9 +574,7 @@ void iscsi_conn_error(struct iscsi_cls_c
 	if (!priv)
 		return;
 
-	mempool_zone_complete(conn->z_error);
-
-	skb = mempool_zone_get_skb(conn->z_error);
+	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
 		dev_printk(KERN_ERR, &conn->dev, "iscsi: gracefully ignored "
 			  "conn error (%d)\n", error);
@@ -744,13 +585,11 @@ void iscsi_conn_error(struct iscsi_cls_c
 	ev = NLMSG_DATA(nlh);
 	ev->transport_handle = iscsi_handle(conn->transport);
 	ev->type = ISCSI_KEVENT_CONN_ERROR;
-	if (atomic_read(&conn->z_error->allocated) >= conn->z_error->hiwat)
-		ev->iferror = -ENOMEM;
 	ev->r.connerror.error = error;
 	ev->r.connerror.cid = conn->cid;
 	ev->r.connerror.sid = iscsi_conn_get_sid(conn);
 
-	iscsi_broadcast_skb(conn->z_error, skb, GFP_ATOMIC);
+	iscsi_broadcast_skb(skb, GFP_ATOMIC);
 
 	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
 		   error);
@@ -767,9 +606,7 @@ iscsi_if_send_reply(int pid, int seq, in
 	int flags = multi ? NLM_F_MULTI : 0;
 	int t = done ? NLMSG_DONE : type;
 
-	mempool_zone_complete(z_reply);
-
-	skb = mempool_zone_get_skb(z_reply);
+	skb = alloc_skb(len, GFP_ATOMIC);
 	/*
 	 * FIXME:
 	 * user is supposed to react on iferror == -ENOMEM;
@@ -780,7 +617,7 @@ iscsi_if_send_reply(int pid, int seq, in
 	nlh = __nlmsg_put(skb, pid, seq, t, (len - sizeof(*nlh)), 0);
 	nlh->nlmsg_flags = flags;
 	memcpy(NLMSG_DATA(nlh), payload, size);
-	return iscsi_unicast_skb(z_reply, skb, pid);
+	return iscsi_unicast_skb(skb, pid);
 }
 
 static int
@@ -810,9 +647,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 	do {
 		int actual_size;
 
-		mempool_zone_complete(conn->z_pdu);
-
-		skbstat = mempool_zone_get_skb(conn->z_pdu);
+		skbstat = alloc_skb(len, GFP_ATOMIC);
 		if (!skbstat) {
 			dev_printk(KERN_ERR, &conn->dev, "iscsi: can not "
 				   "deliver stats: OOM\n");
@@ -825,8 +660,6 @@ iscsi_if_get_stats(struct iscsi_transpor
 		memset(evstat, 0, sizeof(*evstat));
 		evstat->transport_handle = iscsi_handle(conn->transport);
 		evstat->type = nlh->nlmsg_type;
-		if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
-			evstat->iferror = -ENOMEM;
 		evstat->u.get_stats.cid =
 			ev->u.get_stats.cid;
 		evstat->u.get_stats.sid =
@@ -845,7 +678,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 		skb_trim(skbstat, NLMSG_ALIGN(actual_size));
 		nlhstat->nlmsg_len = actual_size;
 
-		err = iscsi_unicast_skb(conn->z_pdu, skbstat, priv->daemon_pid);
+		err = iscsi_unicast_skb(skbstat, priv->daemon_pid);
 	} while (err < 0 && err != -ECONNREFUSED);
 
 	return err;
@@ -876,9 +709,7 @@ int iscsi_if_destroy_session_done(struct
 	session = iscsi_dev_to_session(conn->dev.parent);
 	shost = iscsi_session_to_shost(session);
 
-	mempool_zone_complete(conn->z_pdu);
-
-	skb = mempool_zone_get_skb(conn->z_pdu);
+	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb) {
 		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
 			  "session creation event\n");
@@ -896,7 +727,7 @@ int iscsi_if_destroy_session_done(struct
 	 * this will occur if the daemon is not up, so we just warn
 	 * the user and when the daemon is restarted it will handle it
 	 */
-	rc = iscsi_broadcast_skb(conn->z_pdu, skb, GFP_KERNEL);
+	rc = iscsi_broadcast_skb(skb, GFP_KERNEL);
 	if (rc < 0)
 		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
 			  "session destruction event. Check iscsi daemon\n");
@@ -939,9 +770,7 @@ int iscsi_if_create_session_done(struct 
 	session = iscsi_dev_to_session(conn->dev.parent);
 	shost = iscsi_session_to_shost(session);
 
-	mempool_zone_complete(conn->z_pdu);
-
-	skb = mempool_zone_get_skb(conn->z_pdu);
+	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb) {
 		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
 			  "session creation event\n");
@@ -959,7 +788,7 @@ int iscsi_if_create_session_done(struct 
 	 * this will occur if the daemon is not up, so we just warn
 	 * the user and when the daemon is restarted it will handle it
 	 */
-	rc = iscsi_broadcast_skb(conn->z_pdu, skb, GFP_KERNEL);
+	rc = iscsi_broadcast_skb(skb, GFP_KERNEL);
 	if (rc < 0)
 		dev_printk(KERN_ERR, &conn->dev, "Cannot notify userspace of "
 			  "session creation event. Check iscsi daemon\n");
@@ -1278,9 +1107,6 @@ iscsi_if_rx(struct sock *sk, int len)
 				err = iscsi_if_send_reply(
 					NETLINK_CREDS(skb)->pid, nlh->nlmsg_seq,
 					nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
-				if (atomic_read(&z_reply->allocated) >=
-						z_reply->hiwat)
-					ev->iferror = -ENOMEM;
 			} while (err < 0 && err != -ECONNREFUSED);
 			skb_pull(skb, rlen);
 		}
@@ -1584,32 +1410,6 @@ int iscsi_unregister_transport(struct is
 }
 EXPORT_SYMBOL_GPL(iscsi_unregister_transport);
 
-static int
-iscsi_rcv_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
-{
-	struct netlink_notify *n = ptr;
-
-	if (event == NETLINK_URELEASE &&
-	    n->protocol == NETLINK_ISCSI && n->pid) {
-		struct iscsi_cls_conn *conn;
-		unsigned long flags;
-
-		mempool_zone_complete(z_reply);
-		spin_lock_irqsave(&connlock, flags);
-		list_for_each_entry(conn, &connlist, conn_list) {
-			mempool_zone_complete(conn->z_error);
-			mempool_zone_complete(conn->z_pdu);
-		}
-		spin_unlock_irqrestore(&connlock, flags);
-	}
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block iscsi_nl_notifier = {
-	.notifier_call	= iscsi_rcv_nl_event,
-};
-
 static __init int iscsi_transport_init(void)
 {
 	int err;
@@ -1633,25 +1433,15 @@ static __init int iscsi_transport_init(v
 	if (err)
 		goto unregister_conn_class;
 
-	err = netlink_register_notifier(&iscsi_nl_notifier);
-	if (err)
-		goto unregister_session_class;
-
 	nls = netlink_kernel_create(NETLINK_ISCSI, 1, iscsi_if_rx,
 			THIS_MODULE);
 	if (!nls) {
 		err = -ENOBUFS;
-		goto unregister_notifier;
+		goto unregister_session_class;
 	}
 
-	z_reply = mempool_zone_init(Z_MAX_REPLY,
-		NLMSG_SPACE(sizeof(struct iscsi_uevent)), Z_HIWAT_REPLY);
-	if (z_reply)
-		return 0;
+	return 0;
 
-	sock_release(nls->sk_socket);
-unregister_notifier:
-	netlink_unregister_notifier(&iscsi_nl_notifier);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -1665,9 +1455,7 @@ unregister_transport_class:
 
 static void __exit iscsi_transport_exit(void)
 {
-	mempool_zone_destroy(z_reply);
 	sock_release(nls->sk_socket);
-	netlink_unregister_notifier(&iscsi_nl_notifier);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 39e8332..4b95c89 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -29,7 +29,6 @@ #include <scsi/iscsi_if.h>
 struct scsi_transport_template;
 struct iscsi_transport;
 struct Scsi_Host;
-struct mempool_zone;
 struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_cmd_task;
@@ -157,9 +156,6 @@ struct iscsi_cls_conn {
 
 	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
-	struct mempool_zone *z_error;
-	struct mempool_zone *z_pdu;
-	struct list_head freequeue;
 };
 
 #define iscsi_dev_to_conn(_dev) \
-- 
1.4.1

