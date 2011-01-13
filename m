From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 03/10] libfcoe: add implementation to support fcoe transport
Date: Wed, 12 Jan 2011 18:19:57 -0800
Message-ID: <20110113021955.12798.84485.stg.yi.zou@intel.com>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1AMCWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:22:52 -0500
In-Reply-To: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

Add the new fcoe_transport.c file that implements basic fcoe transport
interface. Eventually, the sysfs entries to create/destroy/enable/disable
an FCoE instance will be coming to the fcoe transport layer, who does a
look-up to find the corresponding transport provide and pass the corresponding
action over to the identified provider.

The fcoe.ko will become the default fcoe transport provider that can support
FCoE on any given netdev interfaces, as the Open-FCoE.org's default software
FCoE HBA solution. Any vendor specific FCoE HBA driver that is built on top
of Open-FCoE's kernel stack of libfc & libfcoe as well as the user land tool
of fcoe-utils can easily plug-in and start running FCoE on their network
interfaces. The fcoe.ko will be converted to act as the default provider if
no vendor specific transport provider is found, as it is always added to the
very end of the list of attached transports.

The lookup is based on the "drv_name" to fetch the fcoe_transport
structure. The pointers to netdev obtained from "if_name" and the
fcoe_transport structure are saved in 'fcoe_netdev_mapping' and added to the
'fcoe_netdev' list.  Subsequent destroy/disable/enable will lookup
fcoe_netdev_list using netdev as the key and obtain fcoe_transport structure,
and call ft->destroy, ft->disable and ft->enable.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---

 drivers/scsi/fcoe/fcoe_transport.c |  540 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/libfcoe.h        |    6 
 2 files changed, 546 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe_transport.c

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
new file mode 100644
index 0000000..517c29b
--- /dev/null
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -0,0 +1,540 @@
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <linux/errno.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <net/rtnetlink.h>
+
+#include <scsi/fc/fc_els.h>
+#include <scsi/fc/fc_fs.h>
+#include <scsi/fc/fc_fip.h>
+#include <scsi/fc/fc_encaps.h>
+#include <scsi/fc/fc_fcoe.h>
+#include <scsi/fc/fc_fcp.h>
+
+#include <scsi/libfc.h>
+#include <scsi/libfcoe.h>
+
+#include "libfcoe.h"
+
+static int fcoe_transport_create(const char *, struct kernel_param *);
+static int fcoe_transport_destroy(const char *, struct kernel_param *);
+static int fcoe_transport_show(char *buffer, const struct kernel_param *kp);
+static struct fcoe_transport *fcoe_transport_lookup(const char *drv_name);
+static struct fcoe_transport *fcoe_netdev_map_lookup(struct net_device *device);
+static int fcoe_transport_enable(const char *, struct kernel_param *);
+static int fcoe_transport_disable(const char *, struct kernel_param *);
+
+static LIST_HEAD(fcoe_transports);
+static LIST_HEAD(fcoe_netdevs);
+static DEFINE_MUTEX(ft_mutex);
+
+module_param_call(show, NULL, fcoe_transport_show, NULL, S_IRUSR);
+__MODULE_PARM_TYPE(show, "string");
+MODULE_PARM_DESC(show, " Show registered FCoE transports");
+
+module_param_call(create, fcoe_transport_create, NULL,
+		  (void *)FIP_MODE_FABRIC, S_IWUSR);
+__MODULE_PARM_TYPE(create, "string");
+MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
+
+module_param_call(create_vn2vn, fcoe_transport_create, NULL,
+		  (void *)FIP_MODE_VN2VN, S_IWUSR);
+__MODULE_PARM_TYPE(create_vn2vn, "string");
+MODULE_PARM_DESC(create_vn2vn, " Creates a VN_node to VN_node FCoE instance "
+		 "on an Ethernet interface");
+
+module_param_call(destroy, fcoe_transport_destroy, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(destroy, "string");
+MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
+
+module_param_call(enable, fcoe_transport_enable, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(enable, "string");
+MODULE_PARM_DESC(enable, " Enables fcoe on a ethernet interface.");
+
+module_param_call(disable, fcoe_transport_disable, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(disable, "string");
+MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
+
+/**
+ * fcoe_transport_lookup - find an fcoe transport that matches drv_name
+ *
+ * Returns : ptr to the fcoe transport that supports this netdev or NULL
+ * if not found.
+ *
+ * The ft_mutex should be held when this is called
+ */
+static struct fcoe_transport *fcoe_transport_lookup(const char *drv_name)
+{
+	struct fcoe_transport *ft = NULL;
+
+	list_for_each_entry(ft, &fcoe_transports, list) {
+		if (strcmp(drv_name, ft->name) == 0)
+			break;
+	}
+
+	return ft;
+}
+
+/**
+ * fcoe_transport_attach - Attaches an FCoE transport
+ * @ft: The fcoe transport to be attached
+ *
+ * Returns : 0 for success
+ */
+int fcoe_transport_attach(struct fcoe_transport *ft)
+{
+	int rc = 0;
+
+	mutex_lock(&ft_mutex);
+	if (ft->attached) {
+		LIBFCOE_TRANSPORT_DBG("transport %s already attached\n",
+				       ft->name);
+		rc = -EEXIST;
+		goto out_attach;
+	}
+
+	list_add_tail(&ft->list, &fcoe_transports);
+	ft->attached = true;
+	LIBFCOE_TRANSPORT_DBG("attaching transport %s\n", ft->name);
+
+out_attach:
+	mutex_unlock(&ft_mutex);
+	return rc;
+}
+EXPORT_SYMBOL(fcoe_transport_attach);
+
+/**
+ * fcoe_transport_attach - Detaches an FCoE transport
+ * @ft: The fcoe transport to be attached
+ *
+ * Returns : 0 for success
+ */
+int fcoe_transport_detach(struct fcoe_transport *ft)
+{
+	int rc = 0;
+
+	mutex_lock(&ft_mutex);
+	if (!ft->attached) {
+		LIBFCOE_TRANSPORT_DBG("transport %s already detached\n",
+			ft->name);
+		rc = -ENODEV;
+		goto out_attach;
+	}
+
+	list_del(&ft->list);
+	ft->attached = false;
+	LIBFCOE_TRANSPORT_DBG("detaching transport %s\n", ft->name);
+
+out_attach:
+	mutex_unlock(&ft_mutex);
+	return rc;
+
+}
+EXPORT_SYMBOL(fcoe_transport_detach);
+
+static int fcoe_transport_show(char *buffer, const struct kernel_param *kp)
+{
+	int i;
+	struct fcoe_transport *ft;
+
+	i = sprintf(buffer, "Attached FCoE transports:");
+	mutex_lock(&ft_mutex);
+	list_for_each_entry(ft, &fcoe_transports, list)
+		i += snprintf(&buffer[i], IFNAMSIZ, "%s ", ft->name);
+	mutex_unlock(&ft_mutex);
+	return 0;
+}
+
+static int __init fcoe_transport_init(void)
+{
+	libfcoe_debug_logging |= LIBFCOE_TRANSPORT_LOGGING;
+	return 0;
+}
+
+static int __exit fcoe_transport_exit(void)
+{
+	/* TODO inform */
+	struct fcoe_transport *ft;
+
+	mutex_lock(&ft_mutex);
+	list_for_each_entry(ft, &fcoe_transports, list) {
+		LIBFCOE_TRANSPORT_DBG("transport going away with "
+			  "attached transport %s\n", ft->name);
+	}
+	mutex_unlock(&ft_mutex);
+	return 0;
+}
+
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
+/**
+ * fcoe_parse_buffer() - Parse the sysfs entry buffer
+ * @buffer: The name of the Ethernet interface to create on
+ * @ifname: Output buffer for interface name
+ * @drv_name: Output buffer for transport driver name
+ *
+ * The input buffer is expected to be in the format of
+ * "ifname:drv_name".
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_parse_buffer(const char *buffer, char *ifname, char *drv_name)
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
+	token = ifname + strlen(ifname);
+	while (--token >= ifname && *token == '\n')
+		*token = '\0';
+
+	/* If no token of ":" is found, fill default driver as fcoe */
+	if (!index) {
+		strlcpy(drv_name, "fcoe", IFNAMSIZ + 1);
+		goto parse_good;
+	}
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
+	token = drv_name + strlen(drv_name);
+	while (--token >= drv_name && *token == '\n')
+		*token = '\0';
+
+parse_good:
+	return 0;
+
+parse_fail:
+	return -1;
+}
+
+/**
+ * fcoe_transport_create() - Create a fcoe interface
+ * @buffer: The name of the Ethernet interface to create on
+ * @kp:	    The associated kernel param
+ *
+ * Called from sysfs. This holds the ft_mutex while calling the
+ * registered fcoe transport's create function.
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
+{
+	int rc = -ENODEV;
+	struct net_device *netdev = NULL;
+	struct fcoe_transport *ft = NULL;
+	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
+
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
+	if (!mutex_trylock(&ft_mutex))
+		return restart_syscall();
+
+#ifdef CONFIG_LIBFCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+		goto out_nodev;
+#endif
+
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev)
+		goto out_nodev;
+
+	ft = fcoe_transport_lookup(drv_name);
+	if (!ft)
+		goto out_putdev;
+
+	rc = fcoe_add_netdev_mapping(netdev, ft);
+	if (rc)
+		goto out_putdev;
+
+	/* pass to transport create */
+	rc = ft->create ? ft->create(netdev, fip_mode) : -ENODEV;
+	if (rc)
+		fcoe_del_netdev_mapping(netdev);
+
+out_putdev:
+	dev_put(netdev);
+out_nodev:
+	mutex_unlock(&ft_mutex);
+	LIBFCOE_TRANSPORT_DBG("transport %s %s to create fcoe on %s\n",
+		(ft) ? ft->name : "n/a",
+		(rc) ? "failed" : "succeeded",
+		(netdev) ? netdev->name : "n/a");
+
+	return rc;
+}
+
+/**
+ * fcoe_transport_destroy() - Destroy a FCoE interface
+ * @buffer: The name of the Ethernet interface to be destroyed
+ * @kp:	    The associated kernel parameter
+ *
+ * Called from sysfs. This holds the ft_mutex while calling the
+ * registered fcoe transport's destroy function.
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_transport_destroy(const char *buffer, struct kernel_param *kp)
+{
+	int rc = -ENODEV;
+	struct net_device *netdev = NULL;
+	struct fcoe_transport *ft = NULL;
+
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
+	if (!mutex_trylock(&ft_mutex))
+		return restart_syscall();
+
+#ifdef CONFIG_LIBFCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+		goto out_nodev;
+#endif
+
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev)
+		goto out_nodev;
+
+	ft = fcoe_netdev_map_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	/* pass to transport destroy */
+	rc = ft->destroy ? ft->destroy(netdev) : -ENODEV;
+	fcoe_del_netdev_mapping(netdev);
+
+out_putdev:
+	dev_put(netdev);
+out_nodev:
+	mutex_unlock(&ft_mutex);
+	LIBFCOE_TRANSPORT_DBG("transport %s %s to destroy fcoe on %s\n",
+		(ft) ? ft->name : "n/a",
+		(rc) ? "failed" : "succeeded",
+		(netdev) ? netdev->name : "n/a");
+
+	return rc;
+}
+
+/**
+ * fcoe_transport_disable() - Disables a FCoE interface
+ * @buffer: The name of the Ethernet interface to be disabled
+ * @kp:	    The associated kernel parameter
+ *
+ * Called from sysfs.
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_transport_disable(const char *buffer, struct kernel_param *kp)
+{
+	int rc = -ENODEV;
+	struct net_device *netdev = NULL;
+	struct fcoe_transport *ft = NULL;
+
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
+	if (!mutex_trylock(&ft_mutex))
+		return restart_syscall();
+
+#ifdef CONFIG_LIBFCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+		goto out_nodev;
+#endif
+
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev)
+		goto out_nodev;
+
+	ft = fcoe_netdev_map_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	rc = ft->disable ? ft->disable(netdev) : -ENODEV;
+
+out_putdev:
+	dev_put(netdev);
+out_nodev:
+	mutex_unlock(&ft_mutex);
+	return rc;
+}
+
+/**
+ * fcoe_transport_enable() - Enables a FCoE interface
+ * @buffer: The name of the Ethernet interface to be enabled
+ * @kp:     The associated kernel parameter
+ *
+ * Called from sysfs.
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_transport_enable(const char *buffer, struct kernel_param *kp)
+{
+	int rc = -ENODEV;
+	struct net_device *netdev = NULL;
+	struct fcoe_transport *ft = NULL;
+
+	/* Reserve extra space to not overflow in case the input is bad */
+	char ifname[IFNAMSIZ * 2 + 2];
+	char drv_name[IFNAMSIZ * 2 + 2];
+
+	if (!mutex_trylock(&ft_mutex))
+		return restart_syscall();
+
+#ifdef CONFIG_LIBFCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE)
+		goto out_nodev;
+#endif
+
+	if (fcoe_parse_buffer(buffer, ifname, drv_name))
+		goto out_nodev;
+
+	netdev = dev_get_by_name(&init_net, ifname);
+	if (!netdev)
+		goto out_nodev;
+
+	ft = fcoe_netdev_map_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	rc = ft->enable ? ft->enable(netdev) : -ENODEV;
+
+out_putdev:
+	dev_put(netdev);
+out_nodev:
+	mutex_unlock(&ft_mutex);
+	return rc;
+}
+
+/**
+ * libfcoe_init() - Initialization routine for libfcoe.ko
+ */
+static int __init libfcoe_init(void)
+{
+	fcoe_transport_init();
+
+	return 0;
+}
+module_init(libfcoe_init);
+
+/**
+ * libfcoe_exit() - Tear down libfcoe.ko
+ */
+static void __exit libfcoe_exit(void)
+{
+	fcoe_transport_exit();
+}
+module_exit(libfcoe_exit);
diff --git a/drivers/scsi/fcoe/libfcoe.h b/drivers/scsi/fcoe/libfcoe.h
index c3fe316..6af5fc3 100644
--- a/drivers/scsi/fcoe/libfcoe.h
+++ b/drivers/scsi/fcoe/libfcoe.h
@@ -4,6 +4,7 @@
 extern unsigned int libfcoe_debug_logging;
 #define LIBFCOE_LOGGING	    0x01 /* General logging, not categorized */
 #define LIBFCOE_FIP_LOGGING 0x02 /* FIP logging */
+#define LIBFCOE_TRANSPORT_LOGGING	0x04 /* FCoE transport logging */
 
 #define LIBFCOE_CHECK_LOGGING(LEVEL, CMD)		\
 do {							\
@@ -22,4 +23,9 @@ do {							\
 			      printk(KERN_INFO "host%d: fip: " fmt,	\
 				     (fip)->lp->host->host_no, ##args);)
 
+#define LIBFCOE_TRANSPORT_DBG(fmt, args...)				\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_TRANSPORT_LOGGING,		\
+			      printk(KERN_INFO "%s: " fmt,		\
+				     __func__, ##args);)
+
 #endif /* _FCOE_LIBFCOE_H_ */

