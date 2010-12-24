From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/3] libfcoe: transport structure lookup based on driver
 name
Date: Thu, 23 Dec 2010 21:35:52 -0800
Message-ID: <1293168952.4676.510.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4653 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0LXFg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:36:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu, yi.zou@intel.com

This is extension of Yi's patches to modify the following:

1. Input parameter for create/destroy/enable/disable will be a
buffer containing "if_name:drv_name".

2. Eliminate match() callback in the fcoe_transport structure and
introduce a new structure containing the mapping of fcoe_transport &
netdev (fcoe_netdev_mapping), and a list of these structures
(fcoe_netdev list).

3. During fcoe_transport_create(), the lookup will be based on the
"drv_name" to fetch the fcoe_transport structure. The pointers to netdev
obtained from "if_name" and the fcoe_transport structure are saved in
'fcoe_netdev_mapping' and added to the 'fcoe_netdev' list.  Subsequent
destroy/disable/enable will lookup fcoe_netdev_list using netdev as the
key and obtain fcoe_transport structure, and call ft->destroy,
ft->disable and ft->enable.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/libfcoe.h           |    2 +-
 drivers/scsi/fcoe/libfcoe_transport.c |  200 ++++++++++++++++++++++++--------
 include/scsi/libfcoe.h                |   14 ++-
 3 files changed, 162 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.h b/drivers/scsi/fcoe/libfcoe.h
index 21ff0bb..8289291 100644
--- a/drivers/scsi/fcoe/libfcoe.h
+++ b/drivers/scsi/fcoe/libfcoe.h
@@ -26,6 +26,6 @@ do {							\
 #define LIBFCOE_TRANSPORT_DBG(fmt, args...)				\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_TRANSPORT_LOGGING,		\
 			      printk(KERN_INFO "%s: " fmt,		\
-			      __func__, ##args);)
+				     __func__, ##args);)
 
 #endif /* _FCOE_LIBFCOE_H_ */
diff --git a/drivers/scsi/fcoe/libfcoe_transport.c b/drivers/scsi/fcoe/libfcoe_transport.c
index 8fd29ea..03c1d2a 100644
--- a/drivers/scsi/fcoe/libfcoe_transport.c
+++ b/drivers/scsi/fcoe/libfcoe_transport.c
@@ -33,11 +33,13 @@ MODULE_LICENSE("GPL v2");
 static int fcoe_transport_create(const char *, struct kernel_param *);
 static int fcoe_transport_destroy(const char *, struct kernel_param *);
 static int fcoe_transport_show(char *buffer, const struct kernel_param *kp);
-static struct fcoe_transport *fcoe_transport_lookup(struct net_device *device);
+static struct fcoe_transport *fcoe_transport_lookup(const char *drv_name);
+static struct fcoe_transport *fcoe_netdev_map_lookup(struct net_device *device);
 static int fcoe_transport_enable(const char *, struct kernel_param *);
 static int fcoe_transport_disable(const char *, struct kernel_param *);
 
 static LIST_HEAD(fcoe_transports);
+static LIST_HEAD(fcoe_netdevs);
 static DEFINE_MUTEX(ft_mutex);
 
 unsigned int libfcoe_debug_logging;
@@ -71,40 +73,23 @@ module_param_call(disable, fcoe_transport_disable, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(disable, "string");
 MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
 
-static struct net_device *fcoe_if_to_netdev(const char *buffer)
-{
-	char *cp;
-	char ifname[IFNAMSIZ + 2];
-
-	if (buffer) {
-		strlcpy(ifname, buffer, IFNAMSIZ);
-		cp = ifname + strlen(ifname);
-		while (--cp >= ifname && *cp == '\n')
-			*cp = '\0';
-		return dev_get_by_name(&init_net, ifname);
-	}
-	return NULL;
-}
-
-
 /**
- * fcoe_transport_lookup - find an fcoe transport that supports the netdev
- * @ft: The fcoe transport to be attached
+ * fcoe_transport_lookup - find an fcoe transport that matches drv_name
  *
  * Returns : ptr to the fcoe transport that supports this netdev or NULL
  * if not found.
  *
  * The ft_mutex should be held when this is called
  */
-static struct fcoe_transport *fcoe_transport_lookup(struct net_device *netdev)
+static struct fcoe_transport *fcoe_transport_lookup(const char *drv_name)
 {
-	struct fcoe_transport *ft;
+	struct fcoe_transport *ft = NULL;
+
+	list_for_each_entry(ft, &fcoe_transports, list) {
+		if (strcmp(drv_name, ft->name) == 0)
+			break;
+	}
 
-	list_for_each_entry(ft, &fcoe_transports, list)
-		if (ft->match && ft->match(netdev))
-			goto ft_match;
-	ft = NULL;
-ft_match:
 	return ft;
 }
 
@@ -121,17 +106,12 @@ int fcoe_transport_attach(struct fcoe_transport *ft)
 	mutex_lock(&ft_mutex);
 	if (ft->attached) {
 		LIBFCOE_TRANSPORT_DBG("transport %s already attached\n",
-			ft->name);
+				       ft->name);
 		rc = -EEXIST;
 		goto out_attach;
 	}
 
-	/* Add vendor specific transport to the head */
-	if (ft->is_vendor)
-		list_add(&ft->list, &fcoe_transports);
-	else
-		list_add_tail(&ft->list, &fcoe_transports);
-
+	list_add_tail(&ft->list, &fcoe_transports);
 	ft->attached = true;
 	LIBFCOE_TRANSPORT_DBG("attaching transport %s\n", ft->name);
 
@@ -197,12 +177,101 @@ static int __exit fcoe_transport_exit(void)
 	mutex_lock(&ft_mutex);
 	list_for_each_entry(ft, &fcoe_transports, list) {
 		LIBFCOE_TRANSPORT_DBG("transport going away with "
-			"attached transport %s\n", ft->name);
+			  "attached transport %s\n", ft->name);
 	}
 	mutex_unlock(&ft_mutex);
 	return 0;
 }
 
+
+static int fcoe_add_netdev_mapping(struct net_device *netdev,
+					struct fcoe_transport *ft)
+{
+	struct fcoe_netdev_mapping *nm;
+
+	nm = kmalloc(sizeof(*nm), GFP_KERNEL);
+	if (!nm) {
+		printk(KERN_ERR "Unable to allocate netdev_mapping");
+		return -ENOMEM;
+	}
+
+	nm->netdev = netdev;
+	nm->ft = ft;
+
+	list_add(&nm->list, &fcoe_netdevs);
+	return 0;
+}
+
+
+static void fcoe_del_netdev_mapping(struct net_device *netdev)
+{
+	struct fcoe_netdev_mapping *nm = NULL, *tmp;
+
+	list_for_each_entry_safe(nm, tmp, &fcoe_netdevs, list) {
+		if (nm->netdev == netdev) {
+			list_del(&nm->list);
+			break;
+		}
+	}
+
+	kfree(nm);
+}
+
+
+/**
+ * fcoe_netdev_map_lookup - find the fcoe transport that matches the netdev on which
+ * it was created
+ *
+ * Returns : ptr to the fcoe transport that supports this netdev or NULL
+ * if not found.
+ *
+ * The ft_mutex should be held when this is called
+ */
+static struct fcoe_transport *fcoe_netdev_map_lookup(struct net_device *netdev)
+{
+	struct fcoe_transport *ft = NULL;
+	struct fcoe_netdev_mapping *nm;
+
+	list_for_each_entry(nm, &fcoe_netdevs, list) {
+		if (netdev == nm->netdev) {
+			ft = nm->ft;
+			break;
+		}
+	}
+
+	return ft;
+}
+
+int fcoe_parse_buffer(const char *buffer, char *ifname, char *drv_name)
+{
+	char copy[IFNAMSIZ * 2 + 2];
+	char *token;
+	char *index = copy;
+
+	strlcpy(copy, buffer, sizeof(copy));
+
+	/* Parse ifname */
+	token = strsep(&index, ":");
+	if (!token || !*token)
+		goto parse_fail;
+
+	strlcpy(ifname, token, IFNAMSIZ + 1);
+
+	/* Parse drv_name.
+	 * strsep will handle the drv_name NULL case
+	 */
+	token = strsep(&index, ":");
+	if (!token || !*token)
+		goto parse_fail;
+
+	strlcpy(drv_name, token, IFNAMSIZ + 1);
+
+	return 0;
+
+parse_fail:
+	return -1;
+}
+
 /**
  * fcoe_transport_create() - Create a fcoe interface
  * @buffer: The name of the Ethernet interface to create on
@@ -220,6 +289,10 @@ static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
 	struct fcoe_transport *ft = NULL;
 	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
 
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
 	if (!mutex_trylock(&ft_mutex))
 		return restart_syscall();
 
@@ -232,18 +305,24 @@ static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
 	if (THIS_MODULE->state != MODULE_STATE_LIVE)
 		goto out_nodev;
 #endif
-	/* TODO: module ref gets when transport gets registered */
-	netdev = fcoe_if_to_netdev(buffer);
+
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
 	if (!netdev)
 		goto out_nodev;
 
-	/* TODO: pass to transport */
-	ft = fcoe_transport_lookup(netdev);
+	ft = fcoe_transport_lookup(drv_name);
 	if (!ft)
 		goto out_putdev;
 
+	rc = fcoe_add_netdev_mapping(netdev, ft);
+	if (rc)
+		goto out_putdev;
+
 	/* pass to transport create */
-	rc = ft->create(netdev, fip_mode);
+	rc = ft->create ? ft->create(netdev, fip_mode) : -ENODEV;
 
 out_putdev:
 	dev_put(netdev);
@@ -273,6 +352,10 @@ static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
 	if (!mutex_trylock(&ft_mutex))
 		return restart_syscall();
 
@@ -286,17 +369,20 @@ static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
-	netdev = fcoe_if_to_netdev(buffer);
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
 	if (!netdev)
 		goto out_nodev;
 
-	/* TODO: pass to transport */
-	ft = fcoe_transport_lookup(netdev);
+	ft = fcoe_netdev_map_lookup(netdev);
 	if (!ft)
 		goto out_putdev;
 
-	/* pass to transport create */
-	rc = ft->destroy(netdev);
+	/* pass to transport destroy */
+	rc = ft->destroy ? ft->destroy(netdev) : -ENODEV;
+	fcoe_del_netdev_mapping(netdev);
 
 out_putdev:
 	dev_put(netdev);
@@ -325,6 +411,10 @@ static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
 	if (!mutex_trylock(&ft_mutex))
 		return restart_syscall();
 
@@ -338,15 +428,18 @@ static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
-	netdev = fcoe_if_to_netdev(buffer);
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
 	if (!netdev)
 		goto out_nodev;
 
-	ft = fcoe_transport_lookup(netdev);
+	ft = fcoe_netdev_map_lookup(netdev);
 	if (!ft)
 		goto out_putdev;
 
-	rc = ft->disable(netdev);
+	rc = ft->disable ? ft->disable(netdev) : -ENODEV;
 
 out_putdev:
 	dev_put(netdev);
@@ -370,6 +463,10 @@ static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
 
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
 	if (!mutex_trylock(&ft_mutex))
 		return restart_syscall();
 
@@ -383,15 +480,18 @@ static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 #endif
 
-	netdev = fcoe_if_to_netdev(buffer);
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
 	if (!netdev)
 		goto out_nodev;
 
-	ft = fcoe_transport_lookup(netdev);
+	ft = fcoe_netdev_map_lookup(netdev);
 	if (!ft)
 		goto out_putdev;
 
-	rc = ft->enable(netdev);
+	rc = ft->enable ? ft->enable(netdev) : -ENODEV;
 
 out_putdev:
 	dev_put(netdev);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 79a64ec..3594f30 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -245,7 +245,6 @@ static inline bool is_fip_mode(struct fcoe_ctlr *fip)
 /* struct fcoe_transport - The FCoE transport interface
  * @name:	a vendor specific name for their FCoE transport driver
  * @attached:	whether this transport is already attached
- * @is_vendor:	whether from vendor or the default Open-FCoE fcoe driver
  * @list:	list linkage to all attached transports
  * @match:	handler to allow the transport to match up a given netdev
  * @create:	handler to sysfs entry of create for FCoE instances
@@ -256,15 +255,24 @@ static inline bool is_fip_mode(struct fcoe_ctlr *fip)
 struct fcoe_transport {
 	char name[IFNAMSIZ];
 	bool attached;
-	bool is_vendor;
 	struct list_head list;
-	bool (*match) (struct net_device *device);
 	int (*create) (struct net_device *device, enum fip_state fip_mode);
 	int (*destroy) (struct net_device *device);
 	int (*enable) (struct net_device *device);
 	int (*disable) (struct net_device *device);
 };
 
+
+/**
+ * struct netdev_list
+ * A mapping from netdevice to fcoe_transport
+ */
+struct fcoe_netdev_mapping {
+	struct list_head list;
+	struct net_device *netdev;
+	struct fcoe_transport *ft;
+};
+
 /* fcoe transports registration and deregistration */
 int fcoe_transport_attach(struct fcoe_transport *ft);
 int fcoe_transport_detach(struct fcoe_transport *ft);
-- 
1.7.0.6




