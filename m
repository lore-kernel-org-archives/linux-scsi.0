From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/9] iscsi: check net namespace for all iscsi lookups
Date: Tue, 31 Oct 2017 15:41:01 -0700
Message-ID: <20171031224104.17735-7-cleech@redhat.com>
References: <20171031224104.17735-1-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBBI7Y4PHQKGQEOVQSIOQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20171031224104.17735-1-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Subbu Seetharaman <subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ketan Mukadam <ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jitendra Bhivare <jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "supporter:BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER" <QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QL41xxx ISCSI DRIVER" <QLogic-Storage-Upstream-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "open list:ISCSI EXTENSIONS FOR RDMA ISER INITIATOR" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

All internal lookups of iSCSI transport objects need to be filtered by
net namespace.

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   5 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |   4 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   4 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   4 +-
 drivers/scsi/qedi/qedi_iscsi.c           |   4 +-
 drivers/scsi/qla4xxx/ql4_os.c            |   6 +-
 drivers/scsi/scsi_transport_iscsi.c      | 201 +++++++++++++++++++------------
 include/scsi/scsi_transport_iscsi.h      |   5 +-
 8 files changed, 150 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 0a4214be4877..6d088634a806 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -464,15 +464,18 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
+	struct net *net;
 	int error;
 
 	error = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (error)
 		return error;
 
+
 	/* the transport ep handle comes from user space so it must be
 	 * verified against the global ib connections list */
-	ep = iscsi_lookup_endpoint(transport_eph);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_eph);
 	if (!ep) {
 		iser_err("can't bind eph %llx\n",
 			 (unsigned long long)transport_eph);
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 33f79f385660..1f4b1b98b4e6 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -181,8 +181,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 	uint16_t cri_index;
+	struct net *net;
 
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 19fadb5d3b3c..58dca20f0ba0 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1414,9 +1414,11 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	struct bnx2i_hba *hba = iscsi_host_priv(shost);
 	struct bnx2i_endpoint *bnx2i_ep;
 	struct iscsi_endpoint *ep;
+	struct net *net;
 	int ret_code;
 
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
 	/*
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 558484f72738..e768fe285e85 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2373,9 +2373,11 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	struct iscsi_endpoint *ep;
 	struct cxgbi_endpoint *cep;
 	struct cxgbi_sock *csk;
+	struct net *net;
 	int err;
 
-	ep = iscsi_lookup_endpoint(transport_eph);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_eph);
 	if (!ep)
 		return -EINVAL;
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 5ae589ea1dd2..5cd267a457f4 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -381,8 +381,10 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_endpoint *qedi_ep;
 	struct iscsi_endpoint *ep;
+	struct net *net;
 
-	ep = iscsi_lookup_endpoint(transport_fd);
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
 	if (!ep)
 		return -EINVAL;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5785bf6c3ec0..770313d0b986 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3178,6 +3178,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	struct ddb_entry *ddb_entry;
 	struct scsi_qla_host *ha;
 	struct iscsi_session *sess;
+	struct net *net;
 
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
@@ -3186,9 +3187,12 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: sid = %d, cid = %d\n", __func__,
 			  cls_session->sid, cls_conn->cid));
 
+	net = iscsi_sess_net(cls_session);
+	ep = iscsi_lookup_endpoint(net, transport_fd);
+	if (!ep)
+		return -EINVAL;
 	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
 		return -EINVAL;
-	ep = iscsi_lookup_endpoint(transport_fd);
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2ec10f6ac3a2..fbec3a019f00 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -274,10 +274,11 @@ void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
 
-struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
+struct iscsi_endpoint *iscsi_lookup_endpoint(struct net *net, u64 handle)
 {
 	struct iscsi_endpoint *ep;
 	struct device *dev;
+	struct net *ns;
 
 	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
 				iscsi_match_epid);
@@ -285,6 +286,9 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 		return NULL;
 
 	ep = iscsi_dev_to_endpoint(dev);
+	ns = iscsi_endpoint_net(ep);
+	if (ns != net)
+		ep = NULL;
 	/*
 	 * we can drop this now because the interface will prevent
 	 * removals and lookups from racing.
@@ -1658,13 +1662,14 @@ static DECLARE_TRANSPORT_CLASS_NS(iscsi_host_class,
 				  &net_ns_type_operations,
 				  iscsi_host_namespace);
 
-static struct net *iscsi_sess_net(struct iscsi_cls_session *cls_session)
+struct net *iscsi_sess_net(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_cls_host *ihost = shost->shost_data;
 
 	return iscsi_host_net(ihost);
 }
+EXPORT_SYMBOL_GPL(iscsi_sess_net);
 
 static const void *iscsi_sess_namespace(struct device *dev)
 {
@@ -1724,14 +1729,19 @@ static uint32_t iscsi_conn_get_sid(struct iscsi_cls_conn *conn)
 /*
  * Returns the matching session to a given sid
  */
-static struct iscsi_cls_session *iscsi_session_lookup(uint32_t sid)
+static struct iscsi_cls_session *iscsi_session_lookup(struct net *net,
+						      uint32_t sid)
 {
 	unsigned long flags;
 	struct iscsi_cls_session *sess;
+	struct net *ns;
 
 	spin_lock_irqsave(&sesslock, flags);
 	list_for_each_entry(sess, &sesslist, sess_list) {
 		if (sess->sid == sid) {
+			ns = iscsi_sess_net(sess);
+			if (ns != net)
+				continue;
 			spin_unlock_irqrestore(&sesslock, flags);
 			return sess;
 		}
@@ -1743,14 +1753,19 @@ static struct iscsi_cls_session *iscsi_session_lookup(uint32_t sid)
 /*
  * Returns the matching connection to a given sid / cid tuple
  */
-static struct iscsi_cls_conn *iscsi_conn_lookup(uint32_t sid, uint32_t cid)
+static struct iscsi_cls_conn *iscsi_conn_lookup(struct net *net, uint32_t sid,
+						uint32_t cid)
 {
 	unsigned long flags;
 	struct iscsi_cls_conn *conn;
+	struct net *ns;
 
 	spin_lock_irqsave(&connlock, flags);
 	list_for_each_entry(conn, &connlist, conn_list) {
 		if ((conn->cid == cid) && (iscsi_conn_get_sid(conn) == sid)) {
+			ns = iscsi_conn_net(conn);
+			if (ns != net)
+				continue;
 			spin_unlock_irqrestore(&connlock, flags);
 			return conn;
 		}
@@ -2703,7 +2718,7 @@ iscsi_if_get_stats(struct net *net, struct iscsi_transport *transport,
 	if (!priv)
 		return -EINVAL;
 
-	conn = iscsi_conn_lookup(ev->u.get_stats.sid, ev->u.get_stats.cid);
+	conn = iscsi_conn_lookup(net, ev->u.get_stats.sid, ev->u.get_stats.cid);
 	if (!conn)
 		return -EEXIST;
 
@@ -2845,12 +2860,13 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
 }
 
 static int
-iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_create_conn(struct net *net, struct iscsi_transport *transport,
+		     struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
 
-	session = iscsi_session_lookup(ev->u.c_conn.sid);
+	session = iscsi_session_lookup(net, ev->u.c_conn.sid);
 	if (!session) {
 		printk(KERN_ERR "iscsi: invalid session %d.\n",
 		       ev->u.c_conn.sid);
@@ -2872,11 +2888,12 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }
 
 static int
-iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_if_destroy_conn(struct net *net, struct iscsi_transport *transport,
+		      struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
 
-	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
+	conn = iscsi_conn_lookup(net, ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
 
@@ -2888,15 +2905,16 @@ iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev
 }
 
 static int
-iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_set_param(struct net *net, struct iscsi_transport *transport,
+		struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
 	int err = 0, value = 0;
 
-	session = iscsi_session_lookup(ev->u.set_param.sid);
-	conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
+	session = iscsi_session_lookup(net, ev->u.set_param.sid);
+	conn = iscsi_conn_lookup(net, ev->u.set_param.sid, ev->u.set_param.cid);
 	if (!conn || !session)
 		return -EINVAL;
 
@@ -2914,7 +2932,21 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	return err;
 }
 
-static int iscsi_if_ep_connect(struct iscsi_transport *transport,
+static struct Scsi_Host *iscsi_host_lookup(struct net *net,
+					   unsigned short hostnum)
+{
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_lookup(hostnum);
+	if (shost && iscsi_host_net(shost->shost_data) != net) {
+		scsi_host_put(shost);
+		shost = NULL;
+	}
+	return shost;
+}
+
+static int iscsi_if_ep_connect(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
@@ -2926,7 +2958,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 		return -EINVAL;
 
 	if (msg_type == ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST) {
-		shost = scsi_host_lookup(ev->u.ep_connect_through_host.host_no);
+		shost = iscsi_host_lookup(net,
+					ev->u.ep_connect_through_host.host_no);
 		if (!shost) {
 			printk(KERN_ERR "ep connect failed. Could not find "
 			       "host no %u\n",
@@ -2951,7 +2984,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
+static int iscsi_if_ep_disconnect(struct net *net,
+				  struct iscsi_transport *transport,
 				  u64 ep_handle)
 {
 	struct iscsi_cls_conn *conn;
@@ -2960,7 +2994,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	if (!transport->ep_disconnect)
 		return -EINVAL;
 
-	ep = iscsi_lookup_endpoint(ep_handle);
+	ep = iscsi_lookup_endpoint(net, ep_handle);
 	if (!ep)
 		return -EINVAL;
 	conn = ep->conn;
@@ -2975,7 +3009,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_if_transport_ep(struct iscsi_transport *transport,
+iscsi_if_transport_ep(struct net *net, struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
@@ -2984,13 +3018,13 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 	switch (msg_type) {
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST:
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
-		rc = iscsi_if_ep_connect(transport, ev, msg_type);
+		rc = iscsi_if_ep_connect(net, transport, ev, msg_type);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 		if (!transport->ep_poll)
 			return -EINVAL;
 
-		ep = iscsi_lookup_endpoint(ev->u.ep_poll.ep_handle);
+		ep = iscsi_lookup_endpoint(net, ev->u.ep_poll.ep_handle);
 		if (!ep)
 			return -EINVAL;
 
@@ -2998,7 +3032,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 						   ev->u.ep_poll.timeout_ms);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
-		rc = iscsi_if_ep_disconnect(transport,
+		rc = iscsi_if_ep_disconnect(net, transport,
 					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
@@ -3006,7 +3040,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_tgt_dscvr(struct iscsi_transport *transport,
+iscsi_tgt_dscvr(struct net *net, struct iscsi_transport *transport,
 		struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3016,7 +3050,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *transport,
 	if (!transport->tgt_dscvr)
 		return -EINVAL;
 
-	shost = scsi_host_lookup(ev->u.tgt_dscvr.host_no);
+	shost = iscsi_host_lookup(net, ev->u.tgt_dscvr.host_no);
 	if (!shost) {
 		printk(KERN_ERR "target discovery could not find host no %u\n",
 		       ev->u.tgt_dscvr.host_no);
@@ -3032,7 +3066,7 @@ iscsi_tgt_dscvr(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_set_host_param(struct iscsi_transport *transport,
+iscsi_set_host_param(struct net *net, struct iscsi_transport *transport,
 		     struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
@@ -3042,7 +3076,7 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 	if (!transport->set_host_param)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_host_param.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_host_param.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set_host_param could not find host no %u\n",
 		       ev->u.set_host_param.host_no);
@@ -3056,7 +3090,8 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_set_path(struct net *net, struct iscsi_transport *transport,
+	       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_path *params;
@@ -3065,7 +3100,7 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (!transport->set_path)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_path.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set path could not find host no %u\n",
 		       ev->u.set_path.host_no);
@@ -3080,7 +3115,7 @@ iscsi_set_path(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }
 
 static int
-iscsi_set_iface_params(struct iscsi_transport *transport,
+iscsi_set_iface_params(struct net *net, struct iscsi_transport *transport,
 		       struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3090,7 +3125,7 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 	if (!transport->set_iface_param)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_iface_params.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_iface_params.host_no);
 	if (!shost) {
 		printk(KERN_ERR "set_iface_params could not find host no %u\n",
 		       ev->u.set_iface_params.host_no);
@@ -3103,7 +3138,8 @@ iscsi_set_iface_params(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+iscsi_send_ping(struct net *net, struct iscsi_transport *transport,
+		struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
 	struct sockaddr *dst_addr;
@@ -3112,7 +3148,7 @@ iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	if (!transport->send_ping)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.iscsi_ping.host_no);
+	shost = iscsi_host_lookup(net, ev->u.iscsi_ping.host_no);
 	if (!shost) {
 		printk(KERN_ERR "iscsi_ping could not find host no %u\n",
 		       ev->u.iscsi_ping.host_no);
@@ -3154,7 +3190,7 @@ iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
 	chap_buf_size = (ev->u.get_chap.num_entries * sizeof(*chap_rec));
 	len = nlmsg_total_size(sizeof(*ev) + chap_buf_size);
 
-	shost = scsi_host_lookup(ev->u.get_chap.host_no);
+	shost = iscsi_host_lookup(net, ev->u.get_chap.host_no);
 	if (!shost) {
 		printk(KERN_ERR "%s: failed. Could not find host no %u\n",
 		       __func__, ev->u.get_chap.host_no);
@@ -3199,7 +3235,7 @@ iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_set_chap(struct iscsi_transport *transport,
+static int iscsi_set_chap(struct net *net, struct iscsi_transport *transport,
 			  struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3209,7 +3245,7 @@ static int iscsi_set_chap(struct iscsi_transport *transport,
 	if (!transport->set_chap)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.set_path.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_path.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_path.host_no);
@@ -3221,7 +3257,7 @@ static int iscsi_set_chap(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_delete_chap(struct iscsi_transport *transport,
+static int iscsi_delete_chap(struct net *net, struct iscsi_transport *transport,
 			     struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3230,7 +3266,7 @@ static int iscsi_delete_chap(struct iscsi_transport *transport,
 	if (!transport->delete_chap)
 		return -ENOSYS;
 
-	shost = scsi_host_lookup(ev->u.delete_chap.host_no);
+	shost = iscsi_host_lookup(net, ev->u.delete_chap.host_no);
 	if (!shost) {
 		printk(KERN_ERR "%s could not find host no %u\n",
 		       __func__, ev->u.delete_chap.host_no);
@@ -3266,7 +3302,8 @@ char *iscsi_get_discovery_parent_name(int parent_type)
 }
 EXPORT_SYMBOL_GPL(iscsi_get_discovery_parent_name);
 
-static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
+static int iscsi_set_flashnode_param(struct net *net,
+				     struct iscsi_transport *transport,
 				     struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3282,7 +3319,7 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 		goto exit_set_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.set_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.set_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.set_flashnode.host_no);
@@ -3319,7 +3356,8 @@ static int iscsi_set_flashnode_param(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_new_flashnode(struct iscsi_transport *transport,
+static int iscsi_new_flashnode(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev, uint32_t len)
 {
 	char *data = (char *)ev + sizeof(*ev);
@@ -3332,7 +3370,7 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 		goto exit_new_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.new_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.new_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.new_flashnode.host_no);
@@ -3354,7 +3392,8 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_del_flashnode(struct iscsi_transport *transport,
+static int iscsi_del_flashnode(struct net *net,
+			       struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3367,7 +3406,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		goto exit_del_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.del_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.del_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.del_flashnode.host_no);
@@ -3394,7 +3433,8 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_login_flashnode(struct iscsi_transport *transport,
+static int iscsi_login_flashnode(struct net *net,
+				 struct iscsi_transport *transport,
 				 struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3409,7 +3449,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		goto exit_login_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.login_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.login_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.login_flashnode.host_no);
@@ -3446,7 +3486,8 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_logout_flashnode(struct iscsi_transport *transport,
+static int iscsi_logout_flashnode(struct net *net,
+				  struct iscsi_transport *transport,
 				  struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3461,7 +3502,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		goto exit_logout_fnode;
 	}
 
-	shost = scsi_host_lookup(ev->u.logout_flashnode.host_no);
+	shost = iscsi_host_lookup(net, ev->u.logout_flashnode.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
@@ -3499,7 +3540,8 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 	return err;
 }
 
-static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
+static int iscsi_logout_flashnode_sid(struct net *net,
+				      struct iscsi_transport *transport,
 				      struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
@@ -3511,7 +3553,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		goto exit_logout_sid;
 	}
 
-	shost = scsi_host_lookup(ev->u.logout_flashnode_sid.host_no);
+	shost = iscsi_host_lookup(net, ev->u.logout_flashnode_sid.host_no);
 	if (!shost) {
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
@@ -3519,7 +3561,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		goto put_host;
 	}
 
-	session = iscsi_session_lookup(ev->u.logout_flashnode_sid.sid);
+	session = iscsi_session_lookup(net, ev->u.logout_flashnode_sid.sid);
 	if (!session) {
 		pr_err("%s could not find session id %u\n",
 		       __func__, ev->u.logout_flashnode_sid.sid);
@@ -3560,7 +3602,7 @@ iscsi_get_host_stats(struct net *net, struct iscsi_transport *transport,
 	host_stats_size = sizeof(struct iscsi_offload_host_stats);
 	len = nlmsg_total_size(sizeof(*ev) + host_stats_size);
 
-	shost = scsi_host_lookup(ev->u.get_host_stats.host_no);
+	shost = iscsi_host_lookup(net, ev->u.get_host_stats.host_no);
 	if (!shost) {
 		pr_err("%s: failed. Cound not find host no %u\n",
 		       __func__, ev->u.get_host_stats.host_no);
@@ -3641,8 +3683,10 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
 		break;
+	/* MARK */
 	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
-		ep = iscsi_lookup_endpoint(ev->u.c_bound_session.ep_handle);
+		ep = iscsi_lookup_endpoint(net,
+					   ev->u.c_bound_session.ep_handle);
 		if (!ep) {
 			err = -EINVAL;
 			break;
@@ -3655,14 +3699,14 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					ev->u.c_bound_session.queue_depth);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (session)
 			transport->destroy_session(session);
 		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
-		session = iscsi_session_lookup(ev->u.d_session.sid);
+		session = iscsi_session_lookup(net, ev->u.d_session.sid);
 		if (session)
 			scsi_queue_work(iscsi_session_to_shost(session),
 					&session->unbind_work);
@@ -3670,17 +3714,18 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_CREATE_CONN:
-		err = iscsi_if_create_conn(transport, ev);
+		err = iscsi_if_create_conn(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_DESTROY_CONN:
-		err = iscsi_if_destroy_conn(transport, ev);
+		err = iscsi_if_destroy_conn(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.sid);
-		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
+		session = iscsi_session_lookup(net, ev->u.b_conn.sid);
+		conn = iscsi_conn_lookup(net, ev->u.b_conn.sid,
+					 ev->u.b_conn.cid);
 
 		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id);
+			iscsi_if_ep_disconnect(net, transport, conn->ep->id);
 
 		if (!session || !conn) {
 			err = -EINVAL;
@@ -3693,7 +3738,7 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
 
-		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		ep = iscsi_lookup_endpoint(net, ev->u.b_conn.transport_eph);
 		if (ep) {
 			ep->conn = conn;
 
@@ -3706,24 +3751,27 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 					      "binding\n");
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		err = iscsi_set_param(transport, ev);
+		err = iscsi_set_param(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_START_CONN:
-		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
+		conn = iscsi_conn_lookup(net, ev->u.start_conn.sid,
+					 ev->u.start_conn.cid);
 		if (conn)
 			ev->r.retcode = transport->start_conn(conn);
 		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_STOP_CONN:
-		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
+		conn = iscsi_conn_lookup(net, ev->u.stop_conn.sid,
+					 ev->u.stop_conn.cid);
 		if (conn)
 			transport->stop_conn(conn, ev->u.stop_conn.flag);
 		else
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
-		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
+		conn = iscsi_conn_lookup(net, ev->u.send_pdu.sid,
+					 ev->u.send_pdu.cid);
 		if (conn)
 			ev->r.retcode =	transport->send_pdu(conn,
 				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
@@ -3739,53 +3787,54 @@ iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST:
-		err = iscsi_if_transport_ep(transport, ev, nlh->nlmsg_type);
+		err = iscsi_if_transport_ep(net, transport, ev,
+					    nlh->nlmsg_type);
 		break;
 	case ISCSI_UEVENT_TGT_DSCVR:
-		err = iscsi_tgt_dscvr(transport, ev);
+		err = iscsi_tgt_dscvr(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_HOST_PARAM:
-		err = iscsi_set_host_param(transport, ev);
+		err = iscsi_set_host_param(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_PATH_UPDATE:
-		err = iscsi_set_path(transport, ev);
+		err = iscsi_set_path(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_IFACE_PARAMS:
-		err = iscsi_set_iface_params(transport, ev,
+		err = iscsi_set_iface_params(net, transport, ev,
 					     nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_PING:
-		err = iscsi_send_ping(transport, ev);
+		err = iscsi_send_ping(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_GET_CHAP:
 		err = iscsi_get_chap(net, transport, nlh);
 		break;
 	case ISCSI_UEVENT_DELETE_CHAP:
-		err = iscsi_delete_chap(transport, ev);
+		err = iscsi_delete_chap(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_FLASHNODE_PARAMS:
-		err = iscsi_set_flashnode_param(transport, ev,
+		err = iscsi_set_flashnode_param(net, transport, ev,
 						nlmsg_attrlen(nlh,
 							      sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_NEW_FLASHNODE:
-		err = iscsi_new_flashnode(transport, ev,
+		err = iscsi_new_flashnode(net, transport, ev,
 					  nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_DEL_FLASHNODE:
-		err = iscsi_del_flashnode(transport, ev);
+		err = iscsi_del_flashnode(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_LOGIN_FLASHNODE:
-		err = iscsi_login_flashnode(transport, ev);
+		err = iscsi_login_flashnode(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_LOGOUT_FLASHNODE:
-		err = iscsi_logout_flashnode(transport, ev);
+		err = iscsi_logout_flashnode(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_LOGOUT_FLASHNODE_SID:
-		err = iscsi_logout_flashnode_sid(transport, ev);
+		err = iscsi_logout_flashnode_sid(net, transport, ev);
 		break;
 	case ISCSI_UEVENT_SET_CHAP:
-		err = iscsi_set_chap(transport, ev,
+		err = iscsi_set_chap(net, transport, ev,
 				     nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_GET_HOST_STATS:
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 3c4cd4779f72..601e8633d495 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -271,6 +271,8 @@ struct iscsi_cls_session {
 #define iscsi_endpoint_to_shost(_ep) \
 	dev_to_shost(_ep->dev.parent)
 
+extern struct net *iscsi_sess_net(struct iscsi_cls_session *session);
+
 #define starget_to_session(_stgt) \
 	iscsi_dev_to_session(_stgt->dev.parent)
 
@@ -448,7 +450,8 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(struct Scsi_Host *shost,
 						    int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
-extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern struct iscsi_endpoint *iscsi_lookup_endpoint(struct net *net,
+						    u64 handle);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
-- 
2.9.5

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
