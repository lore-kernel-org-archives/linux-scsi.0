From: vikas.chaudhary@qlogic.com
Subject: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration in sysfs
Date: Sat,  2 Apr 2011 11:34:20 -0700
Message-ID: <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39519 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756413Ab1DBSjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2011 14:39:10 -0400
In-Reply-To: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

To support multiple network addresses per adapter need to have a new way to
represent network interface (net iface) in sysfs.

Currently only one ipaddress and hwaddress is displayed

\# ls /sys/class/iscsi_host/host18
device  hwaddress  initiatorname  ipaddress  power  subsystem  uevent

In this patch the net iface is presented as a separate class device.
The one that can be added/removed dynamically or statically, based on how
the user configures the multiple net iface on the adapter.

The new sysfs directory would look like this
\# /sys/class/iscsi_iface/
|
|- ipv4-iface-<host_no>-<iface_no>/                             <-- for ipv4
                                |- ipaddress
                                |- subnet
                                |- gateway
                                |- bootproto
                                |- state
|- ipv6-iface-<host_no>-<iface_no>/                             <-- for ipv6
                                |- ipaddress
                                |- link_local_addr
                                |- router_addr
                                |- ipaddr_autocfg
                                |- linklocal_autocfg
                                |- state

We can also get above .iscsi_iface. class from:-
\# /sys/class/iscsi_host/host12/device/iscsi_iface/

With this change, iscsadm would need changes to create iface by getting
hw/ip related data from new sysfs path.
The old path still can be maintained to keep backward compatibility.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Reviewed-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |  215 ++++++++++++++++++++++++++++++++++-
 include/scsi/iscsi_if.h             |   17 +++
 include/scsi/scsi_transport_iscsi.h |   24 ++++
 3 files changed, 255 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 38fcfc0..35ec15d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -270,6 +271,190 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
+
+/* Inerface to display network param to sysfs */
+
+static void iscsi_iface_release(struct device *dev)
+{
+	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);
+	kfree(iface);
+}
+
+static struct class iscsi_iface_class = {
+	.name = "iscsi_iface",
+	.dev_release = iscsi_iface_release,
+};
+
+#define ISCSI_IFACE_ATTR(_prefix, _name, _mode, _show, _store)	\
+struct device_attribute dev_attr_##_prefix##_##_name =		\
+	__ATTR(_name, _mode, _show, _store)
+
+/* iface attrs show */
+#define iscsi_iface_attr_show(type, name, param)			\
+static ssize_t								\
+show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
+			char *buf)					\
+{									\
+	struct iscsi_iface *iface = iscsi_dev_to_iface(dev);		\
+	struct iscsi_transport *t = iface->transport;			\
+	return t->get_iface_param(iface, param, buf);			\
+}									\
+
+#define iscsi_iface_attr(type, name, param)				\
+	iscsi_iface_attr_show(type, name, param)			\
+static ISCSI_IFACE_ATTR(type, name, S_IRUGO, show_##type##_##name, NULL);
+
+/* generic read only ipvi4 attribute */
+iscsi_iface_attr(ipv4_iface, ipaddress, ISCSI_NET_PARAM_IPV4_ADDR);
+iscsi_iface_attr(ipv4_iface, gateway, ISCSI_NET_PARAM_IPV4_GW);
+iscsi_iface_attr(ipv4_iface, subnet, ISCSI_NET_PARAM_IPV4_SUBNET);
+iscsi_iface_attr(ipv4_iface, state, ISCSI_NET_PARAM_IFACE_STATE);
+iscsi_iface_attr(ipv4_iface, bootproto, ISCSI_NET_PARAM_IPV4_BOOTPROTO);
+
+/* generic read only ipv6 attribute */
+iscsi_iface_attr(ipv6_iface, ipaddress, ISCSI_NET_PARAM_IPV6_ADDR);
+iscsi_iface_attr(ipv6_iface, link_local_addr, ISCSI_NET_PARAM_IPV6_LINKLOCAL);
+iscsi_iface_attr(ipv6_iface, router_addr, ISCSI_NET_PARAM_IPV6_ROUTER);
+iscsi_iface_attr(ipv6_iface, ipaddr_autocfg,
+		 ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG);
+iscsi_iface_attr(ipv6_iface, linklocal_autocfg,
+		 ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG);
+iscsi_iface_attr(ipv6_iface, state, ISCSI_NET_PARAM_IFACE_STATE);
+
+/* IPv4 Attrs */
+#define ISCSI_IPV4_IFACE_ATTRS	5
+static struct attribute *iscsi_ipv4_iface_attrs[ISCSI_IPV4_IFACE_ATTRS + 1];
+
+#define SETUP_IPV4_IFACE_RD_ATTR(field, param_flag)			\
+do {									\
+	if (tt->ipv4_iface_param_mask & param_flag) {			\
+		iscsi_ipv4_iface_attrs[count] =				\
+		    &dev_attr_ipv4_iface_##field.attr;			\
+		count++;						\
+	}								\
+} while (0)
+
+static struct attribute_group iscsi_ipv4_iface_group = {
+	.attrs = iscsi_ipv4_iface_attrs,
+};
+
+/* IPv6 Attrs */
+#define ISCSI_IPV6_IFACE_ATTRS	6
+static struct attribute *iscsi_ipv6_iface_attrs[ISCSI_IPV6_IFACE_ATTRS + 1];
+
+#define SETUP_IPV6_IFACE_RD_ATTR(field, param_flag)			\
+do {									\
+	if (tt->ipv6_iface_param_mask & param_flag) {			\
+		iscsi_ipv6_iface_attrs[count] =				\
+		    &dev_attr_ipv6_iface_##field.attr;			\
+		count++;						\
+	}								\
+} while (0)
+
+static struct attribute_group iscsi_ipv6_iface_group = {
+	.attrs = iscsi_ipv6_iface_attrs,
+};
+
+static DEFINE_IDR(iscsi_iface_idr);
+static DEFINE_SPINLOCK(iscsi_iface_lock);
+
+struct iscsi_iface *
+iscsi_create_iface(struct Scsi_Host *shost, struct iscsi_transport *transport,
+		   uint32_t iface_type, uint32_t iface_num, int dd_size)
+{
+	struct iscsi_iface *iface;
+	int id;
+	int err;
+
+	iface = kzalloc(sizeof(*iface) + dd_size, GFP_KERNEL);
+	if (!iface)
+		return NULL;
+
+iface_idr_again:
+	if (!idr_pre_get(&iscsi_iface_idr, GFP_KERNEL))
+		goto free_iface;
+
+	spin_lock(&iscsi_iface_lock);
+	err = idr_get_new(&iscsi_iface_idr, iface, &id);
+	if (err == -EAGAIN) {
+		spin_unlock(&iscsi_iface_lock);
+		goto iface_idr_again;
+	}
+	spin_unlock(&iscsi_iface_lock);
+
+	if (err)
+		goto free_iface;
+
+	iface->id = id;
+	iface->transport = transport;
+	iface->iface_type = iface_type;
+	iface->iface_num = iface_num;
+	iface->dev.class = &iscsi_iface_class;
+	/* parent reference */
+	iface->dev.parent = get_device(&shost->shost_gendev);
+	if (iface_type == IFACE_TYPE_IPV4)
+		dev_set_name(&iface->dev, "ipv4-iface-%u-%u", shost->host_no,
+			     iface_num);
+	else if (iface_type == IFACE_TYPE_IPV6)
+		dev_set_name(&iface->dev, "ipv6-iface-%u-%u", shost->host_no,
+			     iface_num);
+	else
+		goto free_iface;
+
+	err = device_register(&iface->dev);
+	if (err)
+		goto free_iface;
+
+	if (iface_type == IFACE_TYPE_IPV4)
+		err = sysfs_create_group(&iface->dev.kobj,
+					 &iscsi_ipv4_iface_group);
+	else if (iface_type == IFACE_TYPE_IPV6)
+		err = sysfs_create_group(&iface->dev.kobj,
+					 &iscsi_ipv6_iface_group);
+
+	if (err)
+		goto iface_unregister_dev;
+
+	if (dd_size)
+		iface->dd_data = &iface[1];
+	return iface;
+
+iface_unregister_dev:
+	idr_remove(&iscsi_iface_idr, id);
+	device_unregister(&iface->dev);
+
+free_iface:
+	kfree(iface);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(iscsi_create_iface);
+
+void iscsi_destroy_iface(struct iscsi_iface *iface)
+{
+	if (iface->iface_type == IFACE_TYPE_IPV6)
+		sysfs_remove_group(&iface->dev.kobj, &iscsi_ipv6_iface_group);
+	else
+		sysfs_remove_group(&iface->dev.kobj, &iscsi_ipv4_iface_group);
+
+	idr_remove(&iscsi_iface_idr, iface->id);
+	device_unregister(&iface->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_destroy_iface);
+
+struct iscsi_iface *iscsi_lookup_iface(int handle)
+{
+	struct iscsi_iface *iface;
+
+	iface = idr_find(&iscsi_iface_idr, handle);
+
+	return iface;
+}
+EXPORT_SYMBOL_GPL(iscsi_lookup_iface);
+
+
+/* end */
+
+
 static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 			    struct device *cdev)
 {
@@ -2175,6 +2360,27 @@ iscsi_register_transport(struct iscsi_transport *tt)
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	priv->session_attrs[count] = NULL;
+	count = 0;
+
+	SETUP_IPV4_IFACE_RD_ATTR(ipaddress, ISCSI_NET_IPV4_ADDR);
+	SETUP_IPV4_IFACE_RD_ATTR(gateway, ISCSI_NET_IPV4_ADDR);
+	SETUP_IPV4_IFACE_RD_ATTR(bootproto, ISCSI_NET_IPV4_ADDR);
+	SETUP_IPV4_IFACE_RD_ATTR(subnet, ISCSI_NET_IPV4_ADDR);
+	SETUP_IPV4_IFACE_RD_ATTR(state, ISCSI_NET_IPV4_ADDR);
+	BUG_ON(count > ISCSI_IPV4_IFACE_ATTRS);
+	iscsi_ipv4_iface_attrs[count] = NULL;
+	count = 0;
+
+	SETUP_IPV6_IFACE_RD_ATTR(ipaddress, ISCSI_NET_IPV6_ADDR);
+	SETUP_IPV6_IFACE_RD_ATTR(link_local_addr, ISCSI_NET_IPV6_LINKLOCAL);
+	SETUP_IPV6_IFACE_RD_ATTR(router_addr, ISCSI_NET_IPV6_ROUTER);
+	SETUP_IPV6_IFACE_RD_ATTR(ipaddr_autocfg,
+				 ISCSI_NET_IPV6_ADDR_AUTOCFG);
+	SETUP_IPV6_IFACE_RD_ATTR(linklocal_autocfg,
+				 ISCSI_NET_IPV6_LINKLOCAL_AUTOCFG);
+	SETUP_IPV6_IFACE_RD_ATTR(state, ISCSI_NET_IFACE_STATE);
+	BUG_ON(count > ISCSI_IPV6_IFACE_ATTRS);
+	iscsi_ipv6_iface_attrs[count] = NULL;
 
 	spin_lock_irqsave(&iscsi_transport_lock, flags);
 	list_add(&priv->list, &iscsi_transports);
@@ -2237,10 +2443,14 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_transport_class;
 
-	err = transport_class_register(&iscsi_host_class);
+	err = class_register(&iscsi_iface_class);
 	if (err)
 		goto unregister_endpoint_class;
 
+	err = transport_class_register(&iscsi_host_class);
+	if (err)
+		goto unregister_iface_class;
+
 	err = transport_class_register(&iscsi_connection_class);
 	if (err)
 		goto unregister_host_class;
@@ -2270,6 +2480,8 @@ unregister_conn_class:
 	transport_class_unregister(&iscsi_connection_class);
 unregister_host_class:
 	transport_class_unregister(&iscsi_host_class);
+unregister_iface_class:
+	class_unregister(&iscsi_iface_class);
 unregister_endpoint_class:
 	class_unregister(&iscsi_endpoint_class);
 unregister_transport_class:
@@ -2285,6 +2497,7 @@ static void __exit iscsi_transport_exit(void)
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
 	class_unregister(&iscsi_endpoint_class);
+	class_unregister(&iscsi_iface_class);
 	class_unregister(&iscsi_transport_class);
 }
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 312b495..a55ee82 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -272,6 +272,23 @@ enum iscsi_net_param_type {
 	ISCSI_NET_PARAM_IFACE_STATE	= 13,
 };
 
+#define ISCSI_NET_IPV4_ADDR		(1ULL << ISCSI_NET_PARAM_IPV4_ADDR)
+#define ISCSI_NET_IPV4_SUBNET		(1ULL << ISCSI_NET_PARAM_IPV4_SUBNET)
+#define ISCSI_NET_IPV4_GW		(1ULL << ISCSI_NET_PARAM_IPV4_GW)
+#define ISCSI_NET_IPV4_BOOTPROTO	(1ULL << ISCSI_NET_PARAM_IPV4_BOOTPROTO)
+#define ISCSI_NET_VLAN			(1ULL << ISCSI_NET_PARAM_VLAN)
+#define ISCSI_NET_MAC			(1ULL << ISCSI_NET_PARAM_MAC)
+#define ISCSI_NET_IPV6_LINKLOCAL	(1ULL << ISCSI_NET_PARAM_IPV6_LINKLOCAL)
+#define ISCSI_NET_IPV6_ADDR		(1ULL << ISCSI_NET_PARAM_IPV6_ADDR)
+#define ISCSI_NET_IPV6_ROUTER		(1ULL << ISCSI_NET_PARAM_IPV6_ROUTER)
+#define ISCSI_NET_IPV6_AUTOCFG		(1ULL << ISCSI_NET_PARAM_IPV6_AUTOCFG)
+#define ISCSI_NET_IPV6_ADDR_AUTOCFG			\
+				(1ULL << ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG)
+#define ISCSI_NET_IPV6_LINKLOCAL_AUTOCFG		\
+				(1ULL << ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG)
+#define ISCSI_NET_IFACE_STATE		(1ULL << ISCSI_NET_PARAM_IFACE_STATE)
+
+
 /* 20 param per iface * 10 iface per port = 200 params */
 #define ISCSI_MAX_IFACE_PER_HW		10
 #define ISCSI_MAX_PARAM_PER_IFACE	20
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 45b9df9..29d314a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -37,6 +37,7 @@ struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
+struct iscsi_iface;
 
 /**
  * struct iscsi_transport - iSCSI Transport template
@@ -87,6 +88,8 @@ struct iscsi_transport {
 	/* LLD sets this to indicate what values it can export to sysfs */
 	uint64_t param_mask;
 	uint64_t host_param_mask;
+	uint64_t ipv4_iface_param_mask;
+	uint64_t ipv6_iface_param_mask;
 	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
 					uint16_t cmds_max, uint16_t qdepth,
 					uint32_t sn);
@@ -138,6 +141,8 @@ struct iscsi_transport {
 			  uint32_t enable, struct sockaddr *dst_addr);
 	int (*set_path) (struct Scsi_Host *shost, struct iscsi_path *params);
 	int (*set_net_config) (struct Scsi_Host *shost, char *data, int count);
+	int (*get_iface_param) (struct iscsi_iface *iface,
+				enum iscsi_net_param_type param, char *buf);
 };
 
 /*
@@ -229,6 +234,20 @@ struct iscsi_endpoint {
 	struct iscsi_cls_conn *conn;
 };
 
+struct iscsi_iface {
+	struct device dev;
+	struct iscsi_transport *transport;
+	uint64_t id;
+	uint32_t iface_type;	/* IPv4 or IPv6 */
+	uint32_t iface_num;	/* iface number, 0 - n */
+	void *dd_data;		/* LLD private data */
+};
+
+#define iscsi_dev_to_iface(_dev) \
+	container_of(_dev, struct iscsi_iface, dev)
+#define iscsi_iface_to_shost(_iface) \
+	dev_to_shost(_iface->dev.parent)
+
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
@@ -262,5 +281,10 @@ extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
+extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
+			struct iscsi_transport *transport, uint32_t iface_type,
+			uint32_t iface_num, int dd_size);
+extern void iscsi_destroy_iface(struct iscsi_iface *iface);
+extern struct iscsi_iface *iscsi_lookup_iface(int handle);
 
 #endif
-- 
1.7.3.2

