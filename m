From: michaelc@cs.wisc.edu
Subject: [PATCH 18/25] iscsi class: add endpoint class
Date: Wed, 21 May 2008 15:54:13 -0500
Message-ID: <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937068AbYEUUyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:35 -0400
In-Reply-To: <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Add sysfs representation for the endpoint, so userspace can match the
host and session to the endpoint. This will allow us to set the host's
parent correctly at host creation time.

The next patches will convert tcp and iser, and fix iser's dma_mask
bug.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |  190 +++++++++++++++++++++++++++++------
 include/scsi/iscsi_if.h             |    2 +-
 include/scsi/scsi_transport_iscsi.h |   19 +++-
 3 files changed, 172 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ac9d298..c3c07cc 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -33,6 +33,7 @@
 #define ISCSI_SESSION_ATTRS 19
 #define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
+
 #define ISCSI_TRANSPORT_VERSION "2.0-869"
 
 struct iscsi_internal {
@@ -112,6 +113,123 @@ static struct attribute_group iscsi_transport_group = {
 	.attrs = iscsi_transport_attrs,
 };
 
+/*
+ * iSCSI endpoint attrs
+ */
+#define iscsi_dev_to_endpoint(_dev) \
+	container_of(_dev, struct iscsi_endpoint, dev)
+
+#define ISCSI_ATTR(_prefix,_name,_mode,_show,_store)	\
+struct device_attribute dev_attr_##_prefix##_##_name =	\
+        __ATTR(_name,_mode,_show,_store)
+
+static void iscsi_endpoint_release(struct device *dev)
+{
+	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+	kfree(ep);
+}
+
+static struct class iscsi_endpoint_class = {
+	.name = "iscsi_endpoint",
+	.dev_release = iscsi_endpoint_release,
+};
+
+static ssize_t
+show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+	return sprintf(buf, "%u\n", ep->id);
+}
+static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
+
+static struct attribute *iscsi_endpoint_attrs[] = {
+	&dev_attr_ep_handle.attr,
+	NULL,
+};
+
+static struct attribute_group iscsi_endpoint_group = {
+	.attrs = iscsi_endpoint_attrs,
+};
+
+#define ISCSI_MAX_EPID -1
+
+static int iscsi_match_epid(struct device *dev, void *data)
+{
+	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+	unsigned int *epid = (unsigned int *) data;
+
+	return *epid == ep->id;
+}
+
+struct iscsi_endpoint *
+iscsi_create_endpoint(int dd_size)
+{
+	struct device *dev;
+	struct iscsi_endpoint *ep;
+	unsigned int id;
+	int err;
+
+	for (id = 1; id < ISCSI_MAX_EPID; id++) {
+		dev = class_find_device(&iscsi_endpoint_class, &id,
+					iscsi_match_epid);
+		if (!dev)
+			break;
+	}
+	if (id == ISCSI_MAX_EPID) {
+		printk(KERN_ERR "Too many connections. Max supported %u\n",
+		       ISCSI_MAX_EPID - 1);
+		return NULL;
+	}
+
+	ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
+	if (!ep)
+		return NULL;
+
+	ep->id = id;
+	ep->dev.class = &iscsi_endpoint_class;
+	snprintf(ep->dev.bus_id, BUS_ID_SIZE, "ep-%u", id);
+	err = device_register(&ep->dev);
+        if (err)
+                goto free_ep;
+
+	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
+	if (err)
+		goto unregister_dev;
+
+	if (dd_size)
+		ep->dd_data = &ep[1];
+	return ep;
+
+unregister_dev:
+	device_unregister(&ep->dev);
+	return NULL;
+
+free_ep:
+	kfree(ep);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(iscsi_create_endpoint);
+
+void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
+{
+	sysfs_remove_group(&ep->dev.kobj, &iscsi_endpoint_group);
+	device_unregister(&ep->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
+
+struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
+{
+	struct device *dev;
+
+	dev = class_find_device(&iscsi_endpoint_class, &handle,
+				iscsi_match_epid);
+	if (!dev)
+		return NULL;
+
+	return iscsi_dev_to_endpoint(dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
+
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct device *cdev)
 {
@@ -1094,33 +1212,16 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 EXPORT_SYMBOL_GPL(iscsi_session_event);
 
 static int
-iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev,
-			uint32_t host_no, uint32_t initial_cmdsn,
+iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
+			struct iscsi_uevent *ev, uint32_t initial_cmdsn,
 			uint16_t cmds_max, uint16_t queue_depth)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
-	struct Scsi_Host *shost = NULL;
+	uint32_t host_no;
 
-	/*
-	 * Software iscsi allocates a host per session, but
-	 * offload drivers (and possibly iser one day) allocate a host per
-	 * hba/nic/rnic. Offload will match a host here, but software will
-	 * return a new hostno after the create_session callback has returned.
-	 */
-	if (host_no != UINT_MAX) {
-		shost = scsi_host_lookup(host_no);
-		if (IS_ERR(shost)) {
-			printk(KERN_ERR "Could not find host no %u to "
-			       "create session\n", host_no);
-			return -ENODEV;
-		}
-	}
-
-	session = transport->create_session(shost, cmds_max, queue_depth,
+	session = transport->create_session(ep, cmds_max, queue_depth,
 					    initial_cmdsn, &host_no);
-	if (shost)
-		scsi_host_put(shost);
 	if (!session)
 		return -ENOMEM;
 
@@ -1199,6 +1300,7 @@ static int
 iscsi_if_transport_ep(struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
 {
+	struct iscsi_endpoint *ep;
 	struct sockaddr *dst_addr;
 	int rc = 0;
 
@@ -1208,22 +1310,33 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 			return -EINVAL;
 
 		dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-		rc = transport->ep_connect(dst_addr,
-					   ev->u.ep_connect.non_blocking,
-					   &ev->r.ep_connect_ret.handle);
+		ep = transport->ep_connect(dst_addr,
+					   ev->u.ep_connect.non_blocking);
+		if (IS_ERR(ep))
+			return PTR_ERR(ep);
+
+		ev->r.ep_connect_ret.handle = ep->id;
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
 		if (!transport->ep_poll)
 			return -EINVAL;
 
-		ev->r.retcode = transport->ep_poll(ev->u.ep_poll.ep_handle,
+		ep = iscsi_lookup_endpoint(ev->u.ep_poll.ep_handle);
+		if (!ep)
+			return -EINVAL;
+
+		ev->r.retcode = transport->ep_poll(ep,
 						   ev->u.ep_poll.timeout_ms);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		if (!transport->ep_disconnect)
 			return -EINVAL;
 
-		transport->ep_disconnect(ev->u.ep_disconnect.ep_handle);
+		ep = iscsi_lookup_endpoint(ev->u.ep_disconnect.ep_handle);
+		if (!ep)
+			return -EINVAL;
+
+		transport->ep_disconnect(ep);
 		break;
 	}
 	return rc;
@@ -1283,12 +1396,12 @@ static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	int err = 0;
-	uint32_t host_no = UINT_MAX;
 	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
 	struct iscsi_cls_session *session;
 	struct iscsi_cls_conn *conn;
+	struct iscsi_endpoint *ep = NULL;
 
 	priv = iscsi_if_transport_lookup(iscsi_ptr(ev->transport_handle));
 	if (!priv)
@@ -1302,14 +1415,17 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
-		err = iscsi_if_create_session(priv, ev, host_no,
+		err = iscsi_if_create_session(priv, ep, ev,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
 		break;
 	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
-		err = iscsi_if_create_session(priv, ev,
-					ev->u.c_bound_session.host_no,
+		ep = iscsi_lookup_endpoint(ev->u.c_bound_session.ep_handle);
+		if (!ep)
+			return -EINVAL;
+
+		err = iscsi_if_create_session(priv, ep, ev,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
@@ -1774,6 +1890,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 
 unregister_dev:
 	device_unregister(&priv->dev);
+	return NULL;
 free_priv:
 	kfree(priv);
 	return NULL;
@@ -1821,10 +1938,14 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		return err;
 
-	err = transport_class_register(&iscsi_host_class);
+	err = class_register(&iscsi_endpoint_class);
 	if (err)
 		goto unregister_transport_class;
 
+	err = transport_class_register(&iscsi_host_class);
+	if (err)
+		goto unregister_endpoint_class;
+
 	err = transport_class_register(&iscsi_connection_class);
 	if (err)
 		goto unregister_host_class;
@@ -1833,8 +1954,8 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_conn_class;
 
-	nls = netlink_kernel_create(&init_net, NETLINK_ISCSI, 1, iscsi_if_rx, NULL,
-			THIS_MODULE);
+	nls = netlink_kernel_create(&init_net, NETLINK_ISCSI, 1, iscsi_if_rx,
+				    NULL, THIS_MODULE);
 	if (!nls) {
 		err = -ENOBUFS;
 		goto unregister_session_class;
@@ -1854,6 +1975,8 @@ unregister_conn_class:
 	transport_class_unregister(&iscsi_connection_class);
 unregister_host_class:
 	transport_class_unregister(&iscsi_host_class);
+unregister_endpoint_class:
+	class_unregister(&iscsi_endpoint_class);
 unregister_transport_class:
 	class_unregister(&iscsi_transport_class);
 	return err;
@@ -1866,6 +1989,7 @@ static void __exit iscsi_transport_exit(void)
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
+	class_unregister(&iscsi_endpoint_class);
 	class_unregister(&iscsi_transport_class);
 }
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 801a677..a0f13a2 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -80,7 +80,7 @@ struct iscsi_uevent {
 			uint16_t	queue_depth;
 		} c_session;
 		struct msg_create_bound_session {
-			uint32_t	host_no;
+			uint64_t	ep_handle;
 			uint32_t	initial_cmdsn;
 			uint16_t	cmds_max;
 			uint16_t	queue_depth;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d6b8231..f5444e0 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -30,6 +30,7 @@
 
 struct scsi_transport_template;
 struct iscsi_transport;
+struct iscsi_endpoint;
 struct Scsi_Host;
 struct iscsi_cls_conn;
 struct iscsi_conn;
@@ -85,7 +86,7 @@ struct iscsi_transport {
 	/* LLD sets this to indicate what values it can export to sysfs */
 	uint64_t param_mask;
 	uint64_t host_param_mask;
-	struct iscsi_cls_session *(*create_session) (struct Scsi_Host *shost,
+	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
 					uint16_t cmds_max, uint16_t qdepth,
 					uint32_t sn, uint32_t *hn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
@@ -117,10 +118,10 @@ struct iscsi_transport {
 	void (*cleanup_task) (struct iscsi_conn *conn,
 				  struct iscsi_task *task);
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
-	int (*ep_connect) (struct sockaddr *dst_addr, int non_blocking,
-			   uint64_t *ep_handle);
-	int (*ep_poll) (uint64_t ep_handle, int timeout_ms);
-	void (*ep_disconnect) (uint64_t ep_handle);
+	struct iscsi_endpoint *(*ep_connect) (struct sockaddr *dst_addr,
+					      int non_blocking);
+	int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
+	void (*ep_disconnect) (struct iscsi_endpoint *ep);
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
 			  uint32_t enable, struct sockaddr *dst_addr);
 };
@@ -203,6 +204,11 @@ struct iscsi_cls_host {
 extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
 				void (*fn)(struct iscsi_cls_session *));
 
+struct iscsi_endpoint {
+	void *dd_data;			/* LLD private data */
+	struct device dev;
+	unsigned int id;
+};
 
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
@@ -233,5 +239,8 @@ extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
 extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
+extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
+extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
+extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
 
 #endif
-- 
1.5.4.1

