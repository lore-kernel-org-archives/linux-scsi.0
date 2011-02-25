From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/8] libfcoe: Remove stale fcoe-netdev entries
Date: Fri, 25 Feb 2011 15:03:17 -0800
Message-ID: <20110225230317.9310.44392.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXDS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:03:18 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When L2 driver is unloaded, libfcoe_destroy tries to access the fcoe
transport structure matching the netdev. However, since the netdev is
unregistered by that time, it fails to do so. Hence the stale mappings
exists in the fcoe-netdev list. Handle NETDEV_UREGISTER device
notification mechanism to remove the stale fcoe-netdev mapping.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |   46 +++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 745eb9a..2586841 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -39,10 +39,13 @@ static struct fcoe_transport *fcoe_transport_lookup(struct net_device *device);
 static struct fcoe_transport *fcoe_netdev_map_lookup(struct net_device *device);
 static int fcoe_transport_enable(const char *, struct kernel_param *);
 static int fcoe_transport_disable(const char *, struct kernel_param *);
+static int libfcoe_device_notification(struct notifier_block *notifier,
+				    ulong event, void *ptr);
 
 static LIST_HEAD(fcoe_transports);
-static LIST_HEAD(fcoe_netdevs);
 static DEFINE_MUTEX(ft_mutex);
+static LIST_HEAD(fcoe_netdevs);
+static DEFINE_MUTEX(fn_mutex);
 
 unsigned int libfcoe_debug_logging;
 module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
@@ -75,6 +78,11 @@ module_param_call(disable, fcoe_transport_disable, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(disable, "string");
 MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
 
+/* notification function for packets from net device */
+static struct notifier_block libfcoe_notifier = {
+	.notifier_call = libfcoe_device_notification,
+};
+
 /**
  * fcoe_fc_crc() - Calculates the CRC for a given frame
  * @fp: The frame to be checksumed
@@ -375,6 +383,7 @@ static int fcoe_transport_show(char *buffer, const struct kernel_param *kp)
 
 static int __init fcoe_transport_init(void)
 {
+	register_netdevice_notifier(&libfcoe_notifier);
 	return 0;
 }
 
@@ -382,6 +391,7 @@ static int __exit fcoe_transport_exit(void)
 {
 	struct fcoe_transport *ft;
 
+	unregister_netdevice_notifier(&libfcoe_notifier);
 	mutex_lock(&ft_mutex);
 	list_for_each_entry(ft, &fcoe_transports, list)
 		printk(KERN_ERR "FCoE transport %s is still attached!\n",
@@ -405,7 +415,9 @@ static int fcoe_add_netdev_mapping(struct net_device *netdev,
 	nm->netdev = netdev;
 	nm->ft = ft;
 
+	mutex_lock(&fn_mutex);
 	list_add(&nm->list, &fcoe_netdevs);
+	mutex_unlock(&fn_mutex);
 	return 0;
 }
 
@@ -414,13 +426,16 @@ static void fcoe_del_netdev_mapping(struct net_device *netdev)
 {
 	struct fcoe_netdev_mapping *nm = NULL, *tmp;
 
+	mutex_lock(&fn_mutex);
 	list_for_each_entry_safe(nm, tmp, &fcoe_netdevs, list) {
 		if (nm->netdev == netdev) {
 			list_del(&nm->list);
 			kfree(nm);
+			mutex_unlock(&fn_mutex);
 			return;
 		}
 	}
+	mutex_unlock(&fn_mutex);
 }
 
 
@@ -438,13 +453,16 @@ static struct fcoe_transport *fcoe_netdev_map_lookup(struct net_device *netdev)
 	struct fcoe_transport *ft = NULL;
 	struct fcoe_netdev_mapping *nm;
 
+	mutex_lock(&fn_mutex);
 	list_for_each_entry(nm, &fcoe_netdevs, list) {
 		if (netdev == nm->netdev) {
 			ft = nm->ft;
+			mutex_unlock(&fn_mutex);
 			return ft;
 		}
 	}
 
+	mutex_unlock(&fn_mutex);
 	return NULL;
 }
 
@@ -470,6 +488,32 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
+ * libfcoe_device_notification() - Handler for net device events
+ * @notifier: The context of the notification
+ * @event:    The type of event
+ * @ptr:      The net device that the event was on
+ *
+ * This function is called by the Ethernet driver in case of link change event.
+ *
+ * Returns: 0 for success
+ */
+static int libfcoe_device_notification(struct notifier_block *notifier,
+				    ulong event, void *ptr)
+{
+	struct net_device *netdev = ptr;
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		printk(KERN_ERR "libfcoe_device_notification: NETDEV_UNREGISTER %s\n",
+				netdev->name);
+		fcoe_del_netdev_mapping(netdev);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+
+/**
  * fcoe_transport_create() - Create a fcoe interface
  * @buffer: The name of the Ethernet interface to create on
  * @kp:	    The associated kernel param

