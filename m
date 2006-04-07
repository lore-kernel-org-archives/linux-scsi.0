From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/5] iscsi: rm kernel iscsi handles usage for session and
	connection
Date: Thu, 06 Apr 2006 21:13:33 -0500
Message-ID: <1144376013.11062.19.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54702 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932286AbWDGCOZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2006 22:14:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

from hare@suse.de and michaelc@cs.wisc.edu

hw iscsi like qla4xxx does not allocate a host per session and
for userspace it is difficult to restart iscsid using the
"iscsi handles" for the session and connection, so this
patch just has the class or userspace allocate the id for
the session and connection.

Note: this breaks userspace and requires users to upgrade to the newest
open-iscsi tools. Sorry about his but open-iscsi is still too new to
say we have a stable user-kernel api and we were not good nough
designers to know that other hw iscsi drivers and iscsid itself would
need such changes. Actually we sorta did but at the time we did not
have the HW available to us so we could only guess.

Luckily, the only tools hooking into the class are the open-iscsi ones
or other tools like iscsitart hook into the open-iscsi engine from
userspace or prgroams like anaconda call our tools so they are not affected.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 2068b66..6ecb4ba 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -3254,7 +3254,7 @@ static struct iscsi_transport iscsi_tcp_
 
 static struct iscsi_cls_session *
 iscsi_session_create(struct scsi_transport_template *scsit,
-		     uint32_t initial_cmdsn, uint32_t *sid)
+		     uint32_t initial_cmdsn, uint32_t *hostno)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_session *session;
@@ -3274,7 +3274,8 @@ iscsi_session_create(struct scsi_transpo
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
-	*sid = shost->host_no;
+
+	*hostno = shost->host_no;
 
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2730d50..10ff0f0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -56,6 +56,8 @@ struct iscsi_internal {
 	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
 };
 
+static int iscsi_session_nr;	/* sysfs session id for next new session */
+
 /*
  * list of registered transports and lock that must
  * be held while accessing list. The iscsi_transport_lock must
@@ -165,14 +167,23 @@ static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
 static DEFINE_SPINLOCK(connlock);
 
-static struct iscsi_cls_session *iscsi_session_lookup(uint64_t handle)
+static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
+{
+	struct iscsi_cls_session *sess = iscsi_dev_to_session(conn->dev.parent);
+	return sess->sid;
+}
+
+/*
+ * Returns the matching session to a given sid
+ */
+static struct iscsi_cls_session *iscsi_session_lookup(uint32_t sid)
 {
 	unsigned long flags;
 	struct iscsi_cls_session *sess;
 
 	spin_lock_irqsave(&sesslock, flags);
 	list_for_each_entry(sess, &sesslist, sess_list) {
-		if (sess == iscsi_ptr(handle)) {
+		if (sess->sid == sid) {
 			spin_unlock_irqrestore(&sesslock, flags);
 			return sess;
 		}
@@ -181,14 +192,17 @@ static struct iscsi_cls_session *iscsi_s
 	return NULL;
 }
 
-static struct iscsi_cls_conn *iscsi_conn_lookup(uint64_t handle)
+/*
+ * Returns the matching connection to a given sid / cid tuple
+ */
+static struct iscsi_cls_conn *iscsi_conn_lookup(uint32_t sid, uint32_t cid)
 {
 	unsigned long flags;
 	struct iscsi_cls_conn *conn;
 
 	spin_lock_irqsave(&connlock, flags);
 	list_for_each_entry(conn, &connlist, conn_list) {
-		if (conn == iscsi_ptr(handle)) {
+		if ((conn->cid == cid) && (iscsi_conn_get_sid(conn) == sid)) {
 			spin_unlock_irqrestore(&connlock, flags);
 			return conn;
 		}
@@ -223,7 +237,7 @@ static int iscsi_is_session_dev(const st
  * @shost: scsi host
  * @transport: iscsi transport
  *
- * This can be called from a LLD or iscsi_transport
+ * This can be called from a LLD or iscsi_transport.
  **/
 struct iscsi_cls_session *
 iscsi_create_session(struct Scsi_Host *shost, struct iscsi_transport *transport)
@@ -234,14 +248,20 @@ iscsi_create_session(struct Scsi_Host *s
 	if (!try_module_get(transport->owner))
 		return NULL;
 
-	session = kzalloc(sizeof(*session), GFP_KERNEL);
+	session = kzalloc(sizeof(*session) + transport->sessiondata_size,
+			  GFP_KERNEL);
 	if (!session)
 		goto module_put;
 	session->transport = transport;
 
+	if (transport->sessiondata_size)
+		session->dd_data = &session[1];
+
 	/* this is released in the dev's release function */
 	scsi_host_get(shost);
-	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u", shost->host_no);
+	session->sid = iscsi_session_nr++;
+	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
+		 session->sid);
 	session->dev.parent = &shost->shost_gendev;
 	session->dev.release = iscsi_session_release;
 	err = device_register(&session->dev);
@@ -301,12 +321,16 @@ static int iscsi_is_conn_dev(const struc
  * This can be called from a LLD or iscsi_transport. The connection
  * is child of the session so cid must be unique for all connections
  * on the session.
+ *
+ * Since we do not support MCS, cid will normally be zero. In some cases
+ * for software iscsi we could be trying to preallocate a connection struct
+ * in which case there could be two connection structs and cid would be
+ * non-zero.
  **/
 struct iscsi_cls_conn *
 iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
 {
 	struct iscsi_transport *transport = session->transport;
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_cls_conn *conn;
 	int err;
 
@@ -319,12 +343,14 @@ iscsi_create_conn(struct iscsi_cls_sessi
 
 	INIT_LIST_HEAD(&conn->conn_list);
 	conn->transport = transport;
+	conn->cid = cid;
 
 	/* this is released in the dev's release function */
 	if (!get_device(&session->dev))
 		goto free_conn;
+
 	snprintf(conn->dev.bus_id, BUS_ID_SIZE, "connection%d:%u",
-		 shost->host_no, cid);
+		 session->sid, cid);
 	conn->dev.parent = &session->dev;
 	conn->dev.release = iscsi_conn_release;
 	err = device_register(&conn->dev);
@@ -607,7 +633,8 @@ int iscsi_recv_pdu(struct iscsi_cls_conn
 	ev->type = ISCSI_KEVENT_RECV_PDU;
 	if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
 		ev->iferror = -ENOMEM;
-	ev->r.recv_req.conn_handle = iscsi_handle(conn);
+	ev->r.recv_req.cid = conn->cid;
+	ev->r.recv_req.sid = iscsi_conn_get_sid(conn);
 	pdu = (char*)ev + sizeof(*ev);
 	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
 	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
@@ -639,7 +666,8 @@ void iscsi_conn_error(struct iscsi_cls_c
 	if (atomic_read(&conn->z_error->allocated) >= conn->z_error->hiwat)
 		ev->iferror = -ENOMEM;
 	ev->r.connerror.error = error;
-	ev->r.connerror.conn_handle = iscsi_handle(conn);
+	ev->r.connerror.cid = conn->cid;
+	ev->r.connerror.sid = iscsi_conn_get_sid(conn);
 
 	iscsi_unicast_skb(conn->z_error, skb);
 
@@ -689,7 +717,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 			      ISCSI_STATS_CUSTOM_MAX);
 	int err = 0;
 
-	conn = iscsi_conn_lookup(ev->u.get_stats.conn_handle);
+	conn = iscsi_conn_lookup(ev->u.get_stats.sid, ev->u.get_stats.cid);
 	if (!conn)
 		return -EEXIST;
 
@@ -713,8 +741,10 @@ iscsi_if_get_stats(struct iscsi_transpor
 		evstat->type = nlh->nlmsg_type;
 		if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
 			evstat->iferror = -ENOMEM;
-		evstat->u.get_stats.conn_handle =
-			ev->u.get_stats.conn_handle;
+		evstat->u.get_stats.cid =
+			ev->u.get_stats.cid;
+		evstat->u.get_stats.sid =
+			ev->u.get_stats.sid;
 		stats = (struct iscsi_stats *)
 			((char*)evstat + sizeof(*evstat));
 		memset(stats, 0, sizeof(*stats));
@@ -740,16 +770,16 @@ iscsi_if_create_session(struct iscsi_int
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
-	uint32_t sid;
+	uint32_t hostno;
 
 	session = transport->create_session(&priv->t,
 					    ev->u.c_session.initial_cmdsn,
-					    &sid);
+					    &hostno);
 	if (!session)
 		return -ENOMEM;
 
-	ev->r.c_session_ret.session_handle = iscsi_handle(session);
-	ev->r.c_session_ret.sid = sid;
+	ev->r.c_session_ret.host_no = hostno;
+	ev->r.c_session_ret.sid = session->sid;
 	return 0;
 }
 
@@ -760,13 +790,20 @@ iscsi_if_create_conn(struct iscsi_transp
 	struct iscsi_cls_session *session;
 	unsigned long flags;
 
-	session = iscsi_session_lookup(ev->u.c_conn.session_handle);
-	if (!session)
+	session = iscsi_session_lookup(ev->u.c_conn.sid);
+	if (!session) {
+		printk(KERN_ERR "iscsi: invalid session %d\n",
+		       ev->u.c_conn.sid);
 		return -EINVAL;
+	}
 
 	conn = transport->create_conn(session, ev->u.c_conn.cid);
-	if (!conn)
+	if (!conn) {
+		printk(KERN_ERR "iscsi: couldn't create a new "
+			   "connection for session %d\n",
+			   session->sid);
 		return -ENOMEM;
+	}
 
 	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
 			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
@@ -788,7 +825,8 @@ iscsi_if_create_conn(struct iscsi_transp
 		goto free_pdu_pool;
 	}
 
-	ev->r.handle = iscsi_handle(conn);
+	ev->r.c_conn_ret.sid = session->sid;
+	ev->r.c_conn_ret.cid = conn->cid;
 
 	spin_lock_irqsave(&connlock, flags);
 	list_add(&conn->conn_list, &connlist);
@@ -812,7 +850,7 @@ iscsi_if_destroy_conn(struct iscsi_trans
 	struct iscsi_cls_conn *conn;
 	struct mempool_zone *z_error, *z_pdu;
 
-	conn = iscsi_conn_lookup(ev->u.d_conn.conn_handle);
+	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
 	spin_lock_irqsave(&connlock, flags);
@@ -855,7 +893,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		err = iscsi_if_create_session(priv, ev);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
-		session = iscsi_session_lookup(ev->u.d_session.session_handle);
+		session = iscsi_session_lookup(ev->u.d_session.sid);
 		if (session)
 			transport->destroy_session(session);
 		else
@@ -868,8 +906,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		err = iscsi_if_destroy_conn(transport, ev);
 		break;
 	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.session_handle);
-		conn = iscsi_conn_lookup(ev->u.b_conn.conn_handle);
+		session = iscsi_session_lookup(ev->u.b_conn.sid);
+		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
 		if (session && conn)
 			ev->r.retcode =	transport->bind_conn(session, conn,
@@ -879,7 +917,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		conn = iscsi_conn_lookup(ev->u.set_param.conn_handle);
+		conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
 		if (conn)
 			ev->r.retcode =	transport->set_param(conn,
 				ev->u.set_param.param, ev->u.set_param.value);
@@ -887,7 +925,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_START_CONN:
-		conn = iscsi_conn_lookup(ev->u.start_conn.conn_handle);
+		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
 		if (conn)
 			ev->r.retcode = transport->start_conn(conn);
 		else
@@ -895,14 +933,14 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 
 		break;
 	case ISCSI_UEVENT_STOP_CONN:
-		conn = iscsi_conn_lookup(ev->u.stop_conn.conn_handle);
+		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
 		if (conn)
 			transport->stop_conn(conn, ev->u.stop_conn.flag);
 		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
-		conn = iscsi_conn_lookup(ev->u.send_pdu.conn_handle);
+		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
 		if (conn)
 			ev->r.retcode =	transport->send_pdu(conn,
 				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
@@ -923,9 +961,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	return err;
 }
 
-/* Get message from skb (based on rtnetlink_rcv_skb).  Each message is
- * processed by iscsi_if_recv_msg.  Malformed skbs with wrong length are
- * or invalid creds discarded silently.  */
+/*
+ * Get message from skb (based on rtnetlink_rcv_skb).  Each message is
+ * processed by iscsi_if_recv_msg.  Malformed skbs with wrong lengths or
+ * invalid creds are discarded silently.
+ */
 static void
 iscsi_if_rx(struct sock *sk, int len)
 {
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index e5618b9..01ad50f 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -60,59 +60,68 @@ struct iscsi_uevent {
 			uint32_t	initial_cmdsn;
 		} c_session;
 		struct msg_destroy_session {
-			uint64_t	session_handle;
 			uint32_t	sid;
 		} d_session;
 		struct msg_create_conn {
-			uint64_t	session_handle;
-			uint32_t	cid;
 			uint32_t	sid;
+			uint32_t	cid;
 		} c_conn;
 		struct msg_bind_conn {
-			uint64_t	session_handle;
-			uint64_t	conn_handle;
+			uint32_t	sid;
+			uint32_t	cid;
 			uint32_t	transport_fd;
 			uint32_t	is_leading;
 		} b_conn;
 		struct msg_destroy_conn {
-			uint64_t	conn_handle;
+			uint32_t	sid;
 			uint32_t	cid;
 		} d_conn;
 		struct msg_send_pdu {
+			uint32_t	sid;
+			uint32_t	cid;
 			uint32_t	hdr_size;
 			uint32_t	data_size;
-			uint64_t	conn_handle;
 		} send_pdu;
 		struct msg_set_param {
-			uint64_t	conn_handle;
+			uint32_t	sid;
+			uint32_t	cid;
 			uint32_t	param; /* enum iscsi_param */
 			uint32_t	value;
 		} set_param;
 		struct msg_start_conn {
-			uint64_t	conn_handle;
+			uint32_t	sid;
+			uint32_t	cid;
 		} start_conn;
 		struct msg_stop_conn {
+			uint32_t	sid;
+			uint32_t	cid;
 			uint64_t	conn_handle;
 			uint32_t	flag;
 		} stop_conn;
 		struct msg_get_stats {
-			uint64_t	conn_handle;
+			uint32_t	sid;
+			uint32_t	cid;
 		} get_stats;
 	} u;
 	union {
 		/* messages k -> u */
-		uint64_t		handle;
 		int			retcode;
 		struct msg_create_session_ret {
-			uint64_t	session_handle;
 			uint32_t	sid;
+			uint32_t	host_no;
 		} c_session_ret;
+		struct msg_create_conn_ret {
+			uint32_t	sid;
+			uint32_t	cid;
+		} c_conn_ret;			
 		struct msg_recv_req {
+			uint32_t	sid;
+			uint32_t	cid;
 			uint64_t	recv_handle;
-			uint64_t	conn_handle;
 		} recv_req;
 		struct msg_conn_error {
-			uint64_t	conn_handle;
+			uint32_t	sid;
+			uint32_t	cid;
 			uint32_t	error; /* enum iscsi_err */
 		} connerror;
 	} r;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b41cf07..631463c 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -60,11 +60,13 @@ struct iscsi_transport {
 	int ihostdata_size;
 	/* LLD connection data size */
 	int conndata_size;
+	/* LLD session data size */
+	int sessiondata_size;
 	int max_lun;
 	unsigned int max_conn;
 	unsigned int max_cmd_len;
 	struct iscsi_cls_session *(*create_session)
-		(struct scsi_transport_template *t, uint32_t sn, uint32_t *sid);
+		(struct scsi_transport_template *t, uint32_t sn, uint32_t *hn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
@@ -104,6 +106,7 @@ struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
+	uint32_t cid;			/* connection id */
 	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
 	struct mempool_zone *z_error;
@@ -117,6 +120,8 @@ struct iscsi_cls_conn {
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */
 	struct iscsi_transport *transport;
+	int sid;				/* session id */
+	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */
 };
 


