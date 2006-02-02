From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/9] iscsi update: cleanup iscsi class interface
Date: Wed, 01 Feb 2006 21:06:49 -0600
Message-ID: <1138849609.3456.33.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:28340 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423066AbWBBDHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

From:
michaelc@cs.wisc.edu
fujita.tomonori@lab.ntt.co.jp
da-x@monatomic.org

and err path fixup from:
ogerlitz@voltaire.com


This patch cleans up that interface by having the lld and class
pass a iscsi_cls_session or iscsi_cls_conn between each other when
the function is used by HW and SW iscsi llds. This way the lld
does not have to remember if it has to send a handle or pointer
and a handle or pointer to connection, session or host.

This also has the class verify the session handle that gets passed from
userspace instead of using the pointer passed into the kernel directly.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1b495af..323fd19 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -146,7 +146,7 @@ iscsi_conn_failure(struct iscsi_conn *co
 	spin_unlock_irqrestore(&session->lock, flags);
 	set_bit(SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(SUSPEND_BIT, &conn->suspend_rx);
-	iscsi_conn_error(iscsi_handle(conn), err);
+	iscsi_conn_error(conn->cls_conn, err);
 }
 
 static inline int
@@ -689,7 +689,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 				break;
 
 			if (!conn->in.datalen) {
-				rc = iscsi_recv_pdu(iscsi_handle(conn), hdr,
+				rc = iscsi_recv_pdu(conn->cls_conn, hdr,
 						    NULL, 0);
 				if (conn->login_mtask != mtask) {
 					spin_lock(&session->lock);
@@ -737,7 +737,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 			if (!conn->in.datalen) {
 				struct iscsi_mgmt_task *mtask;
 
-				rc = iscsi_recv_pdu(iscsi_handle(conn), hdr,
+				rc = iscsi_recv_pdu(conn->cls_conn, hdr,
 						    NULL, 0);
 				mtask = (struct iscsi_mgmt_task *)
 					session->mgmt_cmds[conn->in.itt -
@@ -761,7 +761,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 				rc = iscsi_check_assign_cmdsn(session,
 						 (struct iscsi_nopin*)hdr);
 				if (!rc && hdr->ttt != ISCSI_RESERVED_TAG)
-					rc = iscsi_recv_pdu(iscsi_handle(conn),
+					rc = iscsi_recv_pdu(conn->cls_conn,
 							    hdr, NULL, 0);
 			} else
 				rc = ISCSI_ERR_PROTO;
@@ -1044,7 +1044,7 @@ iscsi_data_recv(struct iscsi_conn *conn)
 			goto exit;
 		}
 
-		rc = iscsi_recv_pdu(iscsi_handle(conn), conn->in.hdr,
+		rc = iscsi_recv_pdu(conn->cls_conn, conn->in.hdr,
 				    conn->data, conn->in.datalen);
 
 		if (!rc && conn->datadgst_en &&
@@ -2428,19 +2428,20 @@ iscsi_pool_free(struct iscsi_queue *q, v
 }
 
 static struct iscsi_cls_conn *
-iscsi_conn_create(struct Scsi_Host *shost, uint32_t conn_idx)
+iscsi_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
 
-	cls_conn = iscsi_create_conn(hostdata_session(shost->hostdata),
-				     conn_idx);
+	cls_conn = iscsi_create_conn(cls_session, conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
+	memset(conn, 0, sizeof(*conn));
 
-	memset(conn, 0, sizeof(struct iscsi_conn));
+	conn->cls_conn = cls_conn;
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
 	conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 	conn->id = conn_idx;
@@ -2625,11 +2626,13 @@ iscsi_conn_destroy(struct iscsi_cls_conn
 }
 
 static int
-iscsi_conn_bind(iscsi_sessionh_t sessionh, iscsi_connh_t connh,
-		uint32_t transport_fd, int is_leading)
+iscsi_conn_bind(struct iscsi_cls_session *cls_session,
+		struct iscsi_cls_conn *cls_conn, uint32_t transport_fd,
+		int is_leading)
 {
-	struct iscsi_session *session = iscsi_ptr(sessionh);
-	struct iscsi_conn *tmp = ERR_PTR(-EEXIST), *conn = iscsi_ptr(connh);
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_conn *tmp = ERR_PTR(-EEXIST), *conn = cls_conn->dd_data;
 	struct sock *sk;
 	struct socket *sock;
 	int err;
@@ -2703,9 +2706,9 @@ iscsi_conn_bind(iscsi_sessionh_t session
 }
 
 static int
-iscsi_conn_start(iscsi_connh_t connh)
+iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 	struct sock *sk;
 
@@ -2754,9 +2757,9 @@ iscsi_conn_start(iscsi_connh_t connh)
 }
 
 static void
-iscsi_conn_stop(iscsi_connh_t connh, int flag)
+iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 	struct sock *sk;
 	unsigned long flags;
@@ -3253,9 +3256,9 @@ static struct scsi_host_template iscsi_s
 
 static struct iscsi_transport iscsi_tcp_transport;
 
-static struct Scsi_Host *
+static struct iscsi_cls_session *
 iscsi_session_create(struct scsi_transport_template *scsit,
-		     uint32_t initial_cmdsn)
+		     uint32_t initial_cmdsn, uint32_t *sid)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_session *session;
@@ -3275,6 +3278,7 @@ iscsi_session_create(struct scsi_transpo
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
 	session->max_r2t = 1;
+	*sid = shost->host_no;
 
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
@@ -3311,7 +3315,7 @@ iscsi_session_create(struct scsi_transpo
 	if (iscsi_r2tpool_alloc(session))
 		goto r2tpool_alloc_fail;
 
-	return shost;
+	return hostdata_session(shost->hostdata);
 
 r2tpool_alloc_fail:
 	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
@@ -3321,12 +3325,14 @@ immdata_alloc_fail:
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 cmdpool_alloc_fail:
+	iscsi_transport_destroy_session(shost);
 	return NULL;
 }
 
 static void
-iscsi_session_destroy(struct Scsi_Host *shost)
+iscsi_session_destroy(struct iscsi_cls_session *cls_session)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	int cmd_i;
 	struct iscsi_data_task *dtask, *n;
@@ -3350,10 +3356,10 @@ iscsi_session_destroy(struct Scsi_Host *
 }
 
 static int
-iscsi_conn_set_param(iscsi_connh_t connh, enum iscsi_param param,
+iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
 		     uint32_t value)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 
 	spin_lock_bh(&session->lock);
@@ -3495,9 +3501,10 @@ iscsi_conn_set_param(iscsi_connh_t connh
 }
 
 static int
-iscsi_session_get_param(struct Scsi_Host *shost,
+iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 			enum iscsi_param param, uint32_t *value)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 
 	switch(param) {
@@ -3539,9 +3546,10 @@ iscsi_session_get_param(struct Scsi_Host
 }
 
 static int
-iscsi_conn_get_param(void *data, enum iscsi_param param, uint32_t *value)
+iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+		     enum iscsi_param param, uint32_t *value)
 {
-	struct iscsi_conn *conn = data;
+	struct iscsi_conn *conn = cls_conn->dd_data;
 
 	switch(param) {
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
@@ -3564,9 +3572,9 @@ iscsi_conn_get_param(void *data, enum is
 }
 
 static void
-iscsi_conn_get_stats(iscsi_connh_t connh, struct iscsi_stats *stats)
+iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = cls_conn->dd_data;
 
 	stats->txdata_octets = conn->txdata_octets;
 	stats->rxdata_octets = conn->rxdata_octets;
@@ -3587,10 +3595,10 @@ iscsi_conn_get_stats(iscsi_connh_t connh
 }
 
 static int
-iscsi_conn_send_pdu(iscsi_connh_t connh, struct iscsi_hdr *hdr, char *data,
-		    uint32_t data_size)
+iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
+		    char *data, uint32_t data_size)
 {
-	struct iscsi_conn *conn = iscsi_ptr(connh);
+	struct iscsi_conn *conn = cls_conn->dd_data;
 	int rc;
 
 	mutex_lock(&conn->xmitmutex);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index f95e61b..6766b81 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -113,7 +113,10 @@ struct iscsi_tcp_recv {
 	int			datadgst;
 };
 
+struct iscsi_cls_conn;
+
 struct iscsi_conn {
+	struct iscsi_cls_conn	*cls_conn;	/* ptr to class connection */
 	struct iscsi_hdr	hdr;		/* header placeholder */
 	char			hdrext[4*sizeof(__u16) +
 				    sizeof(__u32)];
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 59a1c9d..b618685 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -164,9 +164,43 @@ static struct mempool_zone *z_reply;
 #define Z_MAX_ERROR	16
 #define Z_HIWAT_ERROR	12
 
+static LIST_HEAD(sesslist);
+static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
 static DEFINE_SPINLOCK(connlock);
 
+static struct iscsi_cls_session *iscsi_session_lookup(uint64_t handle)
+{
+	unsigned long flags;
+	struct iscsi_cls_session *sess;
+
+	spin_lock_irqsave(&sesslock, flags);
+	list_for_each_entry(sess, &sesslist, sess_list) {
+		if (sess == iscsi_ptr(handle)) {
+			spin_unlock_irqrestore(&sesslock, flags);
+			return sess;
+		}
+	}
+	spin_unlock_irqrestore(&sesslock, flags);
+	return NULL;
+}
+
+static struct iscsi_cls_conn *iscsi_conn_lookup(uint64_t handle)
+{
+	unsigned long flags;
+	struct iscsi_cls_conn *conn;
+
+	spin_lock_irqsave(&connlock, flags);
+	list_for_each_entry(conn, &connlist, conn_list) {
+		if (conn == iscsi_ptr(handle)) {
+			spin_unlock_irqrestore(&connlock, flags);
+			return conn;
+		}
+	}
+	spin_unlock_irqrestore(&connlock, flags);
+	return NULL;
+}
+
 /*
  * The following functions can be used by LLDs that allocate
  * their own scsi_hosts or by software iscsi LLDs
@@ -365,6 +399,7 @@ iscsi_transport_create_session(struct sc
 {
 	struct iscsi_cls_session *session;
 	struct Scsi_Host *shost;
+	unsigned long flags;
 
 	shost = scsi_host_alloc(transport->host_template,
 				hostdata_privsize(transport));
@@ -389,6 +424,9 @@ iscsi_transport_create_session(struct sc
 		goto remove_host;
 
 	*(unsigned long*)shost->hostdata = (unsigned long)session;
+	spin_lock_irqsave(&sesslock, flags);
+	list_add(&session->sess_list, &sesslist);
+	spin_unlock_irqrestore(&sesslock, flags);
 	return shost;
 
 remove_host:
@@ -410,9 +448,13 @@ EXPORT_SYMBOL_GPL(iscsi_transport_create
 int iscsi_transport_destroy_session(struct Scsi_Host *shost)
 {
 	struct iscsi_cls_session *session;
+	unsigned long flags;
 
 	scsi_remove_host(shost);
 	session = hostdata_session(shost->hostdata);
+	spin_lock_irqsave(&sesslock, flags);
+	list_del(&session->sess_list);
+	spin_unlock_irqrestore(&sesslock, flags);
 	iscsi_destroy_session(session);
 	/* ref from host alloc */
 	scsi_host_put(shost);
@@ -424,22 +466,6 @@ EXPORT_SYMBOL_GPL(iscsi_transport_destro
 /*
  * iscsi interface functions
  */
-static struct iscsi_cls_conn*
-iscsi_if_find_conn(uint64_t key)
-{
-	unsigned long flags;
-	struct iscsi_cls_conn *conn;
-
-	spin_lock_irqsave(&connlock, flags);
-	list_for_each_entry(conn, &connlist, conn_list)
-		if (conn->connh == key) {
-			spin_unlock_irqrestore(&connlock, flags);
-			return conn;
-		}
-	spin_unlock_irqrestore(&connlock, flags);
-	return NULL;
-}
-
 static struct iscsi_internal *
 iscsi_if_transport_lookup(struct iscsi_transport *tt)
 {
@@ -559,25 +585,21 @@ iscsi_unicast_skb(struct mempool_zone *z
 	return 0;
 }
 
-int iscsi_recv_pdu(iscsi_connh_t connh, struct iscsi_hdr *hdr,
+int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 		   char *data, uint32_t data_size)
 {
 	struct nlmsghdr	*nlh;
 	struct sk_buff *skb;
 	struct iscsi_uevent *ev;
-	struct iscsi_cls_conn *conn;
 	char *pdu;
 	int len = NLMSG_SPACE(sizeof(*ev) + sizeof(struct iscsi_hdr) +
 			      data_size);
 
-	conn = iscsi_if_find_conn(connh);
-	BUG_ON(!conn);
-
 	mempool_zone_complete(conn->z_pdu);
 
 	skb = mempool_zone_get_skb(conn->z_pdu);
 	if (!skb) {
-		iscsi_conn_error(connh, ISCSI_ERR_CONN_FAILED);
+		iscsi_conn_error(conn, ISCSI_ERR_CONN_FAILED);
 		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not deliver "
 			   "control PDU: OOM\n");
 		return -ENOMEM;
@@ -590,7 +612,7 @@ int iscsi_recv_pdu(iscsi_connh_t connh, 
 	ev->type = ISCSI_KEVENT_RECV_PDU;
 	if (atomic_read(&conn->z_pdu->allocated) >= conn->z_pdu->hiwat)
 		ev->iferror = -ENOMEM;
-	ev->r.recv_req.conn_handle = connh;
+	ev->r.recv_req.conn_handle = iscsi_handle(conn);
 	pdu = (char*)ev + sizeof(*ev);
 	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
 	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
@@ -599,17 +621,13 @@ int iscsi_recv_pdu(iscsi_connh_t connh, 
 }
 EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
-void iscsi_conn_error(iscsi_connh_t connh, enum iscsi_err error)
+void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
 	struct sk_buff	*skb;
 	struct iscsi_uevent *ev;
-	struct iscsi_cls_conn *conn;
 	int len = NLMSG_SPACE(sizeof(*ev));
 
-	conn = iscsi_if_find_conn(connh);
-	BUG_ON(!conn);
-
 	mempool_zone_complete(conn->z_error);
 
 	skb = mempool_zone_get_skb(conn->z_error);
@@ -626,7 +644,7 @@ void iscsi_conn_error(iscsi_connh_t conn
 	if (atomic_read(&conn->z_error->allocated) >= conn->z_error->hiwat)
 		ev->iferror = -ENOMEM;
 	ev->r.connerror.error = error;
-	ev->r.connerror.conn_handle = connh;
+	ev->r.connerror.conn_handle = iscsi_handle(conn);
 
 	iscsi_unicast_skb(conn->z_error, skb);
 
@@ -677,7 +695,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 			      ISCSI_STATS_CUSTOM_MAX);
 	int err = 0;
 
-	conn = iscsi_if_find_conn(ev->u.get_stats.conn_handle);
+	conn = iscsi_conn_lookup(ev->u.get_stats.conn_handle);
 	if (!conn)
 		return -EEXIST;
 
@@ -707,7 +725,7 @@ iscsi_if_get_stats(struct iscsi_transpor
 			((char*)evstat + sizeof(*evstat));
 		memset(stats, 0, sizeof(*stats));
 
-		transport->get_stats(ev->u.get_stats.conn_handle, stats);
+		transport->get_stats(conn, stats);
 		actual_size = NLMSG_SPACE(sizeof(struct iscsi_uevent) +
 					  sizeof(struct iscsi_stats) +
 					  sizeof(struct iscsi_stats_custom) *
@@ -727,58 +745,34 @@ static int
 iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
-	struct Scsi_Host *shost;
-
-	if (!transport->create_session)
-		return -EINVAL;
+	struct iscsi_cls_session *session;
+	uint32_t sid;
 
-	shost = transport->create_session(&priv->t,
-					  ev->u.c_session.initial_cmdsn);
-	if (!shost)
+	session = transport->create_session(&priv->t,
+					    ev->u.c_session.initial_cmdsn,
+					    &sid);
+	if (!session)
 		return -ENOMEM;
 
-	ev->r.c_session_ret.session_handle = iscsi_handle(iscsi_hostdata(shost->hostdata));
-	ev->r.c_session_ret.sid = shost->host_no;
+	ev->r.c_session_ret.session_handle = iscsi_handle(session);
+	ev->r.c_session_ret.sid = sid;
 	return 0;
 }
 
 static int
-iscsi_if_destroy_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
+iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
-	struct iscsi_transport *transport = priv->iscsi_transport;
-
-	struct Scsi_Host *shost;
-
-	if (!transport->destroy_session)
-		return -EINVAL;
-
-	shost = scsi_host_lookup(ev->u.d_session.sid);
-	if (shost == ERR_PTR(-ENXIO))
-		return -EEXIST;
-
-	if (transport->destroy_session)
-		transport->destroy_session(shost);
-        /* ref from host lookup */
-        scsi_host_put(shost);
-	return 0;
-}
-
-static int
-iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev){
-	struct Scsi_Host *shost;
 	struct iscsi_cls_conn *conn;
+	struct iscsi_cls_session *session;
 	unsigned long flags;
 
-	if (!transport->create_conn)
+	session = iscsi_session_lookup(ev->u.c_conn.session_handle);
+	if (!session)
 		return -EINVAL;
 
-	shost = scsi_host_lookup(ev->u.c_conn.sid);
-	if (shost == ERR_PTR(-ENXIO))
-		return -EEXIST;
-
-	conn = transport->create_conn(shost, ev->u.c_conn.cid);
+	conn = transport->create_conn(session, ev->u.c_conn.cid);
 	if (!conn)
-		goto release_ref;
+		return -ENOMEM;
 
 	conn->z_pdu = mempool_zone_init(Z_MAX_PDU,
 			NLMSG_SPACE(sizeof(struct iscsi_uevent) +
@@ -800,14 +794,13 @@ iscsi_if_create_conn(struct iscsi_transp
 		goto free_pdu_pool;
 	}
 
-	ev->r.handle = conn->connh = iscsi_handle(conn->dd_data);
+	ev->r.handle = iscsi_handle(conn);
 
 	spin_lock_irqsave(&connlock, flags);
 	list_add(&conn->conn_list, &connlist);
 	conn->active = 1;
 	spin_unlock_irqrestore(&connlock, flags);
 
-	scsi_host_put(shost);
 	return 0;
 
 free_pdu_pool:
@@ -815,8 +808,6 @@ free_pdu_pool:
 destroy_conn:
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn->dd_data);
-release_ref:
-	scsi_host_put(shost);
 	return -ENOMEM;
 }
 
@@ -827,13 +818,9 @@ iscsi_if_destroy_conn(struct iscsi_trans
 	struct iscsi_cls_conn *conn;
 	struct mempool_zone *z_error, *z_pdu;
 
-	conn = iscsi_if_find_conn(ev->u.d_conn.conn_handle);
+	conn = iscsi_conn_lookup(ev->u.d_conn.conn_handle);
 	if (!conn)
-		return -EEXIST;
-
-	if (!transport->destroy_conn)
 		return -EINVAL;
-
 	spin_lock_irqsave(&connlock, flags);
 	conn->active = 0;
 	list_del(&conn->conn_list);
@@ -858,6 +845,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
+	struct iscsi_cls_session *session;
+	struct iscsi_cls_conn *conn;
 
 	if (NETLINK_CREDS(skb)->uid)
 		return -EPERM;
@@ -867,6 +856,9 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		return -EINVAL;
 	transport = priv->iscsi_transport;
 
+	if (!try_module_get(transport->owner))
+		return -EINVAL;
+
 	daemon_pid = NETLINK_CREDS(skb)->pid;
 
 	switch (nlh->nlmsg_type) {
@@ -874,7 +866,11 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		err = iscsi_if_create_session(priv, ev);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
-		err = iscsi_if_destroy_session(priv, ev);
+		session = iscsi_session_lookup(ev->u.d_session.session_handle);
+		if (session)
+			transport->destroy_session(session);
+		else
+			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_CREATE_CONN:
 		err = iscsi_if_create_conn(transport, ev);
@@ -883,41 +879,48 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		err = iscsi_if_destroy_conn(transport, ev);
 		break;
 	case ISCSI_UEVENT_BIND_CONN:
-		if (!iscsi_if_find_conn(ev->u.b_conn.conn_handle))
-			return -EEXIST;
-		ev->r.retcode = transport->bind_conn(
-			ev->u.b_conn.session_handle,
-			ev->u.b_conn.conn_handle,
-			ev->u.b_conn.transport_fd,
-			ev->u.b_conn.is_leading);
+		session = iscsi_session_lookup(ev->u.b_conn.session_handle);
+		conn = iscsi_conn_lookup(ev->u.b_conn.conn_handle);
+
+		if (session && conn)
+			ev->r.retcode =	transport->bind_conn(session, conn,
+					ev->u.b_conn.transport_fd,
+					ev->u.b_conn.is_leading);
+		else
+			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		if (!iscsi_if_find_conn(ev->u.set_param.conn_handle))
-			return -EEXIST;
-		ev->r.retcode = transport->set_param(
-			ev->u.set_param.conn_handle,
-			ev->u.set_param.param, ev->u.set_param.value);
+		conn = iscsi_conn_lookup(ev->u.set_param.conn_handle);
+		if (conn)
+			ev->r.retcode =	transport->set_param(conn,
+				ev->u.set_param.param, ev->u.set_param.value);
+		else
+			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_START_CONN:
-		if (!iscsi_if_find_conn(ev->u.start_conn.conn_handle))
-			return -EEXIST;
-		ev->r.retcode = transport->start_conn(
-			ev->u.start_conn.conn_handle);
+		conn = iscsi_conn_lookup(ev->u.start_conn.conn_handle);
+		if (conn)
+			ev->r.retcode = transport->start_conn(conn);
+		else
+			err = -EINVAL;
+
 		break;
 	case ISCSI_UEVENT_STOP_CONN:
-		if (!iscsi_if_find_conn(ev->u.stop_conn.conn_handle))
-			return -EEXIST;
-		transport->stop_conn(ev->u.stop_conn.conn_handle,
-			ev->u.stop_conn.flag);
+		conn = iscsi_conn_lookup(ev->u.stop_conn.conn_handle);
+		if (conn)
+			transport->stop_conn(conn, ev->u.stop_conn.flag);
+		else
+			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
-		if (!iscsi_if_find_conn(ev->u.send_pdu.conn_handle))
-			return -EEXIST;
-		ev->r.retcode = transport->send_pdu(
-		       ev->u.send_pdu.conn_handle,
-		       (struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
-		       (char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
-			ev->u.send_pdu.data_size);
+		conn = iscsi_conn_lookup(ev->u.send_pdu.conn_handle);
+		if (conn)
+			ev->r.retcode =	transport->send_pdu(conn,
+				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
+				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
+				ev->u.send_pdu.data_size);
+		else
+			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(transport, skb, nlh);
@@ -927,6 +930,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 		break;
 	}
 
+	module_put(transport->owner);
 	return err;
 }
 
@@ -997,7 +1001,7 @@ show_conn_int_param_##param(struct class
 	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
 	struct iscsi_transport *t = conn->transport;			\
 									\
-	t->get_conn_param(conn->dd_data, param, &value);		\
+	t->get_conn_param(conn, param, &value);				\
 	return snprintf(buf, 20, format"\n", value);			\
 }
 
@@ -1024,10 +1028,9 @@ show_session_int_param_##param(struct cl
 {									\
 	uint32_t value = 0;						\
 	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev);	\
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
 	struct iscsi_transport *t = session->transport;			\
 									\
-	t->get_session_param(shost, param, &value);			\
+	t->get_session_param(session, param, &value);			\
 	return snprintf(buf, 20, format"\n", value);			\
 }
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 3e5cb5a..e5618b9 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -163,9 +163,6 @@ enum iscsi_param {
 };
 #define ISCSI_PARAM_MAX			14
 
-typedef uint64_t iscsi_sessionh_t;	/* iSCSI Data-Path session handle */
-typedef uint64_t iscsi_connh_t;		/* iSCSI Data-Path connection handle */
-
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
 #define hostdata_session(_hostdata) (iscsi_ptr(*(unsigned long *)_hostdata))
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 16602a5..b41cf07 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -63,25 +63,28 @@ struct iscsi_transport {
 	int max_lun;
 	unsigned int max_conn;
 	unsigned int max_cmd_len;
-	struct Scsi_Host *(*create_session) (struct scsi_transport_template *t,
-					     uint32_t initial_cmdsn);
-	void (*destroy_session) (struct Scsi_Host *shost);
-	struct iscsi_cls_conn *(*create_conn) (struct Scsi_Host *shost,
+	struct iscsi_cls_session *(*create_session)
+		(struct scsi_transport_template *t, uint32_t sn, uint32_t *sid);
+	void (*destroy_session) (struct iscsi_cls_session *session);
+	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
-	int (*bind_conn) (iscsi_sessionh_t session, iscsi_connh_t conn,
+	int (*bind_conn) (struct iscsi_cls_session *session,
+			  struct iscsi_cls_conn *cls_conn,
 			  uint32_t transport_fd, int is_leading);
-	int (*start_conn) (iscsi_connh_t conn);
-	void (*stop_conn) (iscsi_connh_t conn, int flag);
+	int (*start_conn) (struct iscsi_cls_conn *conn);
+	void (*stop_conn) (struct iscsi_cls_conn *conn, int flag);
 	void (*destroy_conn) (struct iscsi_cls_conn *conn);
-	int (*set_param) (iscsi_connh_t conn, enum iscsi_param param,
+	int (*set_param) (struct iscsi_cls_conn *conn, enum iscsi_param param,
 			  uint32_t value);
-	int (*get_conn_param) (void *conndata, enum iscsi_param param,
+	int (*get_conn_param) (struct iscsi_cls_conn *conn,
+			       enum iscsi_param param,
 			       uint32_t *value);
-	int (*get_session_param) (struct Scsi_Host *shost,
+	int (*get_session_param) (struct iscsi_cls_session *session,
 				  enum iscsi_param param, uint32_t *value);
-	int (*send_pdu) (iscsi_connh_t conn, struct iscsi_hdr *hdr,
+	int (*send_pdu) (struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, uint32_t data_size);
-	void (*get_stats) (iscsi_connh_t conn, struct iscsi_stats *stats);
+	void (*get_stats) (struct iscsi_cls_conn *conn,
+			   struct iscsi_stats *stats);
 };
 
 /*
@@ -93,15 +96,14 @@ extern int iscsi_unregister_transport(st
 /*
  * control plane upcalls
  */
-extern void iscsi_conn_error(iscsi_connh_t conn, enum iscsi_err error);
-extern int iscsi_recv_pdu(iscsi_connh_t conn, struct iscsi_hdr *hdr,
+extern void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error);
+extern int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			  char *data, uint32_t data_size);
 
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
-	iscsi_connh_t connh;
 	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
 	struct mempool_zone *z_error;
@@ -113,7 +115,7 @@ struct iscsi_cls_conn {
 	container_of(_dev, struct iscsi_cls_conn, dev)
 
 struct iscsi_cls_session {
-	struct list_head list;	/* item in session_list */
+	struct list_head sess_list;		/* item in session_list */
 	struct iscsi_transport *transport;
 	struct device dev;	/* sysfs transport/container device */
 };


