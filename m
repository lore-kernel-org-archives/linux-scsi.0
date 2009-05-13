From: michaelc@cs.wisc.edu
Subject: [PATCH 01/13] iscsi: pass ep connect shost
Date: Wed, 13 May 2009 17:57:38 -0500
Message-ID: <12422554711659-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762089AbZEMW5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:53 -0400
In-Reply-To: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When we create the tcp/ip connection by calling ep_connect, we currently
just go by the routing table info.

I think there are two problems with this.

1. Some drivers do not have access to a routing table. Some drivers like
qla4xxx do not even know about other ports.

2. If you have two initiator ports on the same subnet, the user may have
set things up so that session1 was supposed to be run through port1. and
session2 was supposed to be run through port2. It looks like we could
end with both sessions going through one of the ports.

Fixes for cxgb3i from Karen Xie.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 +-
 drivers/scsi/cxgb3i/cxgb3i.h             |    1 -
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |   25 ++++++++++++--
 drivers/scsi/cxgb3i/cxgb3i_offload.c     |   23 ++++++++-----
 drivers/scsi/cxgb3i/cxgb3i_offload.h     |    3 +-
 drivers/scsi/scsi_transport_iscsi.c      |   51 +++++++++++++++++++++++------
 include/scsi/iscsi_if.h                  |    7 +++-
 include/scsi/scsi_transport_iscsi.h      |    3 +-
 8 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 75223f5..ffbe0c7 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -517,7 +517,8 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 }
 
 static struct iscsi_endpoint *
-iscsi_iser_ep_connect(struct sockaddr *dst_addr, int non_blocking)
+iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
+		      int non_blocking)
 {
 	int err;
 	struct iser_conn *ib_conn;
diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index 59b0958..e3133b5 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -144,7 +144,6 @@ struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *);
 void cxgb3i_adapter_open(struct t3cdev *);
 void cxgb3i_adapter_close(struct t3cdev *);
 
-struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *);
 struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *,
 				       struct net_device *);
 void cxgb3i_hba_host_remove(struct cxgb3i_hba *);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 9212400..04a4374 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -178,7 +178,7 @@ void cxgb3i_adapter_close(struct t3cdev *t3dev)
  * cxgb3i_hba_find_by_netdev - find the cxgb3i_hba structure via net_device
  * @t3dev: t3cdev adapter
  */
-struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
+static struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
 {
 	struct cxgb3i_adapter *snic;
 	int i;
@@ -261,20 +261,27 @@ void cxgb3i_hba_host_remove(struct cxgb3i_hba *hba)
 
 /**
  * cxgb3i_ep_connect - establish TCP connection to target portal
+ * @shost:		scsi host to use
  * @dst_addr:		target IP address
  * @non_blocking:	blocking or non-blocking call
  *
  * Initiates a TCP/IP connection to the dst_addr
  */
-static struct iscsi_endpoint *cxgb3i_ep_connect(struct sockaddr *dst_addr,
+static struct iscsi_endpoint *cxgb3i_ep_connect(struct Scsi_Host *shost,
+						struct sockaddr *dst_addr,
 						int non_blocking)
 {
 	struct iscsi_endpoint *ep;
 	struct cxgb3i_endpoint *cep;
-	struct cxgb3i_hba *hba;
+	struct cxgb3i_hba *hba = NULL;
 	struct s3_conn *c3cn = NULL;
 	int err = 0;
 
+	if (shost)
+		hba = iscsi_host_priv(shost);
+
+	cxgb3i_api_debug("shost 0x%p, hba 0x%p.\n", shost, hba);
+
 	c3cn = cxgb3i_c3cn_create();
 	if (!c3cn) {
 		cxgb3i_log_info("ep connect OOM.\n");
@@ -282,17 +289,27 @@ static struct iscsi_endpoint *cxgb3i_ep_connect(struct sockaddr *dst_addr,
 		goto release_conn;
 	}
 
-	err = cxgb3i_c3cn_connect(c3cn, (struct sockaddr_in *)dst_addr);
+	err = cxgb3i_c3cn_connect(hba ? hba->ndev : NULL, c3cn,
+				 (struct sockaddr_in *)dst_addr);
 	if (err < 0) {
 		cxgb3i_log_info("ep connect failed.\n");
 		goto release_conn;
 	}
+
 	hba = cxgb3i_hba_find_by_netdev(c3cn->dst_cache->dev);
 	if (!hba) {
 		err = -ENOSPC;
 		cxgb3i_log_info("NOT going through cxgbi device.\n");
 		goto release_conn;
 	}
+
+	if (shost && hba != iscsi_host_priv(shost)) {
+		err = -ENOSPC;
+		cxgb3i_log_info("Could not connect through request host%u\n",
+				shost->host_no);
+		goto release_conn;
+	}
+
 	if (c3cn_is_closing(c3cn)) {
 		err = -ENOSPC;
 		cxgb3i_log_info("ep connect unable to connect.\n");
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index e11c9c1..c1d5be4 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1479,12 +1479,13 @@ static struct net_device *cxgb3_egress_dev(struct net_device *root_dev,
 	return NULL;
 }
 
-static struct rtable *find_route(__be32 saddr, __be32 daddr,
+static struct rtable *find_route(struct net_device *dev,
+				 __be32 saddr, __be32 daddr,
 				 __be16 sport, __be16 dport)
 {
 	struct rtable *rt;
 	struct flowi fl = {
-		.oif = 0,
+		.oif = dev ? dev->ifindex : 0,
 		.nl_u = {
 			 .ip4_u = {
 				   .daddr = daddr,
@@ -1573,36 +1574,40 @@ out_err:
  *
  * return 0 if active open request is sent, < 0 otherwise.
  */
-int cxgb3i_c3cn_connect(struct s3_conn *c3cn, struct sockaddr_in *usin)
+int cxgb3i_c3cn_connect(struct net_device *dev, struct s3_conn *c3cn,
+			struct sockaddr_in *usin)
 {
 	struct rtable *rt;
-	struct net_device *dev;
 	struct cxgb3i_sdev_data *cdata;
 	struct t3cdev *cdev;
 	__be32 sipv4;
 	int err;
 
+	c3cn_conn_debug("c3cn 0x%p, dev 0x%p.\n", c3cn, dev);
+
 	if (usin->sin_family != AF_INET)
 		return -EAFNOSUPPORT;
 
 	c3cn->daddr.sin_port = usin->sin_port;
 	c3cn->daddr.sin_addr.s_addr = usin->sin_addr.s_addr;
 
-	rt = find_route(c3cn->saddr.sin_addr.s_addr,
+	rt = find_route(dev, c3cn->saddr.sin_addr.s_addr,
 			c3cn->daddr.sin_addr.s_addr,
 			c3cn->saddr.sin_port,
 			c3cn->daddr.sin_port);
 	if (rt == NULL) {
-		c3cn_conn_debug("NO route to 0x%x, port %u.\n",
+		c3cn_conn_debug("NO route to 0x%x, port %u, dev %s.\n",
 				c3cn->daddr.sin_addr.s_addr,
-				ntohs(c3cn->daddr.sin_port));
+				ntohs(c3cn->daddr.sin_port),
+				dev ? dev->name : "any");
 		return -ENETUNREACH;
 	}
 
 	if (rt->rt_flags & (RTCF_MULTICAST | RTCF_BROADCAST)) {
-		c3cn_conn_debug("multi-cast route to 0x%x, port %u.\n",
+		c3cn_conn_debug("multi-cast route to 0x%x, port %u, dev %s.\n",
 				c3cn->daddr.sin_addr.s_addr,
-				ntohs(c3cn->daddr.sin_port));
+				ntohs(c3cn->daddr.sin_port),
+				dev ? dev->name : "any");
 		ip_rt_put(rt);
 		return -ENETUNREACH;
 	}
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index ebfca96..6a1d86b 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -169,7 +169,8 @@ void cxgb3i_sdev_add(struct t3cdev *, struct cxgb3_client *);
 void cxgb3i_sdev_remove(struct t3cdev *);
 
 struct s3_conn *cxgb3i_c3cn_create(void);
-int cxgb3i_c3cn_connect(struct s3_conn *, struct sockaddr_in *);
+int cxgb3i_c3cn_connect(struct net_device *, struct s3_conn *,
+			struct sockaddr_in *);
 void cxgb3i_c3cn_rx_credits(struct s3_conn *, int);
 int cxgb3i_c3cn_send_pdus(struct s3_conn *, struct sk_buff *);
 void cxgb3i_c3cn_release(struct s3_conn *);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0947954..858baff 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1268,26 +1268,54 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	return err;
 }
 
+static int iscsi_if_ep_connect(struct iscsi_transport *transport,
+			       struct iscsi_uevent *ev, int msg_type)
+{
+	struct iscsi_endpoint *ep;
+	struct sockaddr *dst_addr;
+	struct Scsi_Host *shost = NULL;
+	int non_blocking, err = 0;
+
+	if (!transport->ep_connect)
+		return -EINVAL;
+
+	if (msg_type == ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST) {
+		shost = scsi_host_lookup(ev->u.ep_connect_through_host.host_no);
+		if (!shost) {
+			printk(KERN_ERR "ep connect failed. Could not find "
+			       "host no %u\n",
+			       ev->u.ep_connect_through_host.host_no);
+			return -ENODEV;
+		}
+		non_blocking = ev->u.ep_connect_through_host.non_blocking;
+	} else
+		non_blocking = ev->u.ep_connect.non_blocking;
+
+	dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
+	ep = transport->ep_connect(shost, dst_addr, non_blocking);
+	if (IS_ERR(ep)) {
+		err = PTR_ERR(ep);
+		goto release_host;
+	}
+
+	ev->r.ep_connect_ret.handle = ep->id;
+release_host:
+	if (shost)
+		scsi_host_put(shost);
+	return err;
+}
+
 static int
 iscsi_if_transport_ep(struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
-	struct sockaddr *dst_addr;
 	int rc = 0;
 
 	switch (msg_type) {
+	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST:
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
-		if (!transport->ep_connect)
-			return -EINVAL;
-
-		dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-		ep = transport->ep_connect(dst_addr,
-					   ev->u.ep_connect.non_blocking);
-		if (IS_ERR(ep))
-			return PTR_ERR(ep);
-
-		ev->r.ep_connect_ret.handle = ep->id;
+		rc = iscsi_if_ep_connect(transport, ev, msg_type);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 		if (!transport->ep_poll)
@@ -1469,6 +1497,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
+	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST:
 		err = iscsi_if_transport_ep(transport, ev, nlh->nlmsg_type);
 		break;
 	case ISCSI_UEVENT_TGT_DSCVR:
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index d0ed522..2c1a4af 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -50,7 +50,8 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_TGT_DSCVR		= UEVENT_BASE + 15,
 	ISCSI_UEVENT_SET_HOST_PARAM	= UEVENT_BASE + 16,
 	ISCSI_UEVENT_UNBIND_SESSION	= UEVENT_BASE + 17,
-	ISCSI_UEVENT_CREATE_BOUND_SESSION	= UEVENT_BASE + 18,
+	ISCSI_UEVENT_CREATE_BOUND_SESSION		= UEVENT_BASE + 18,
+	ISCSI_UEVENT_TRANSPORT_EP_CONNECT_THROUGH_HOST	= UEVENT_BASE + 19,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -131,6 +132,10 @@ struct iscsi_uevent {
 		struct msg_transport_connect {
 			uint32_t	non_blocking;
 		} ep_connect;
+		struct msg_transport_connect_through_host {
+			uint32_t	host_no;
+			uint32_t	non_blocking;
+		} ep_connect_through_host;
 		struct msg_transport_poll {
 			uint64_t	ep_handle;
 			uint32_t	timeout_ms;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 457588e..8cb7a31 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -126,7 +126,8 @@ struct iscsi_transport {
 			       int *index, int *age);
 
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
-	struct iscsi_endpoint *(*ep_connect) (struct sockaddr *dst_addr,
+	struct iscsi_endpoint *(*ep_connect) (struct Scsi_Host *shost,
+					      struct sockaddr *dst_addr,
 					      int non_blocking);
 	int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
 	void (*ep_disconnect) (struct iscsi_endpoint *ep);
-- 
1.5.2.1

