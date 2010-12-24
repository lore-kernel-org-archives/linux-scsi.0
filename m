From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 5/8] libfcoe: remove libfcoe.c, use the same
 libfcoe_fip.c instead
Date: Thu, 23 Dec 2010 21:18:29 -0800
Message-ID: <1293167909.4676.464.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2614 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0LXFTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:19:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, yi.zou@intel.com, michaelc@cs.wisc.edu

From: Yi Zou <yi.zou@intel.com>

now we can take out the libfcoe.c and let libfcoe_fip.c continue to do the
same job.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/libfcoe_transport.c |  413 +++++++++++++++++++++++++++++++++
 1 files changed, 413 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fcoe/libfcoe_transport.c

diff --git a/drivers/scsi/fcoe/libfcoe_transport.c b/drivers/scsi/fcoe/libfcoe_transport.c
new file mode 100644
index 0000000..b52d55a
--- /dev/null
+++ b/drivers/scsi/fcoe/libfcoe_transport.c
@@ -0,0 +1,413 @@
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
+static struct fcoe_transport *fcoe_transport_lookup(struct net_device *device);
+static int fcoe_transport_enable(const char *, struct kernel_param *);
+static int fcoe_transport_disable(const char *, struct kernel_param *);
+
+static LIST_HEAD(fcoe_transports);
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
+static struct net_device *fcoe_if_to_netdev(const char *buffer)
+{
+	char *cp;
+	char ifname[IFNAMSIZ + 2];
+
+	if (buffer) {
+		strlcpy(ifname, buffer, IFNAMSIZ);
+		cp = ifname + strlen(ifname);
+		while (--cp >= ifname && *cp == '\n')
+			*cp = '\0';
+		return dev_get_by_name(&init_net, ifname);
+	}
+	return NULL;
+}
+
+
+/**
+ * fcoe_transport_lookup - find an fcoe transport that supports the netdev
+ * @ft: The fcoe transport to be attached
+ *
+ * Returns : ptr to the fcoe transport that supports this netdev or NULL
+ * if not found.
+ *
+ * The ft_mutex should be held when this is called
+ */
+static struct fcoe_transport *fcoe_transport_lookup(struct net_device *netdev)
+{
+	struct fcoe_transport *ft;
+
+	list_for_each_entry(ft, &fcoe_transports, list)
+		if (ft->match && ft->match(netdev))
+			goto ft_match;
+	ft = NULL;
+ft_match:
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
+			ft->name);
+		rc = -EEXIST;
+		goto out_attach;
+	}
+
+	/* Add vendor specific transport to the head */
+	if (!ft->is_vendor)
+		list_add(&ft->list, &fcoe_transports);
+	else
+		list_add_tail(&ft->list, &fcoe_transports);
+
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
+			"attached transport %s\n", ft->name);
+	}
+	mutex_unlock(&ft_mutex);
+	return 0;
+}
+
+/**
+ * fcoe_transport_create() - Create a fcoe interface
+ * @buffer: The name of the Ethernet interface to create on
+ * @kp:            The associated kernel param
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
+	/* TODO: module ref gets when transport gets registered */
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev)
+		goto out_nodev;
+
+	/* TODO: pass to transport */
+	ft = fcoe_transport_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	/* pass to transport create */
+	rc = ft->create(netdev, fip_mode);
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
+ * @kp:            The associated kernel parameter
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
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev)
+		goto out_nodev;
+
+	/* TODO: pass to transport */
+	ft = fcoe_transport_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	/* pass to transport create */
+	rc = ft->destroy(netdev);
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
+ * @kp:            The associated kernel parameter
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
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev)
+		goto out_nodev;
+
+	ft = fcoe_transport_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	rc = ft->disable(netdev);
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
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev)
+		goto out_nodev;
+
+	ft = fcoe_transport_lookup(netdev);
+	if (!ft)
+		goto out_putdev;
+
+	rc = ft->enable(netdev);
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
-- 
1.7.0.6




