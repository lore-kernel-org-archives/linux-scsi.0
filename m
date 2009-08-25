From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 22/64] fcoe: Fix module ref count bug by adding NETDEV
	UNREGISTER handling
Date: Tue, 25 Aug 2009 14:00:23 -0700
Message-ID: <20090825210023.1553.47980.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:17714 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZHYVAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:22 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Fixes reference counting on fcoe_instance and net_device, and adds
NETDEV_UNREGISTER notifier handling so that you can unload network drivers.
FCoE no longer increments the module use count for the network driver.

On an NETDEV_UNREGISTER event, destroying the FCoE instance is deferred to a
workqueue context to avoid RTNL deadlocks.

Based in part by an earlier patch from John Fastabend

John's patch description:
Currently, the netdev module ref count is not decremented with module_put()
when the module is unloaded while fcoe instances are present. To fix this
removed reference count on netdev module completely and added functionality to
netdev event handling for NETDEV_UNREGISTER events.

This allows fcoe to remove devices cleanly when the netdev module is unloaded
so we no longer need to hold a reference count for the netdev module.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |  186 ++++++++++++++++------------------------------
 drivers/scsi/fcoe/fcoe.h |    2 
 2 files changed, 67 insertions(+), 121 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c9a0346..c0264a9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -74,12 +74,13 @@ static int fcoe_link_ok(struct fc_lport *lp);
 
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
 static int fcoe_hostlist_add(const struct fc_lport *);
-static int fcoe_hostlist_remove(const struct fc_lport *);
 
 static void fcoe_check_wait_queue(struct fc_lport *, struct sk_buff *);
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
 static void fcoe_dev_setup(void);
 static void fcoe_dev_cleanup(void);
+static struct fcoe_interface *
+	fcoe_hostlist_lookup_port(const struct net_device *dev);
 
 /* notification function from net device */
 static struct notifier_block fcoe_notifier = {
@@ -149,6 +150,7 @@ static int fcoe_fip_recv(struct sk_buff *skb, struct net_device *dev,
  * @netdev : ptr to the associated netdevice struct
  *
  * Returns : 0 for success
+ * Locking: must be called with the RTNL mutex held
  */
 static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 				struct net_device *netdev)
@@ -188,13 +190,11 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	 * or enter promiscuous mode if not capable of listening
 	 * for multiple unicast MACs.
 	 */
-	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_add(netdev, flogi_maddr);
 	if (fip->spma)
 		dev_unicast_add(netdev, fip->ctl_src_addr);
 	dev_mc_add(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
-	rtnl_unlock();
 
 	/*
 	 * setup the receive function from ethernet driver
@@ -215,6 +215,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 
 static void fcoe_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb);
 static void fcoe_update_src_mac(struct fcoe_ctlr *fip, u8 *old, u8 *new);
+static void fcoe_destroy_work(struct work_struct *work);
 
 /**
  * fcoe_interface_create()
@@ -232,6 +233,7 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 		return NULL;
 	}
 
+	dev_hold(netdev);
 	kref_init(&fcoe->kref);
 
 	/*
@@ -249,6 +251,8 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 /**
  * fcoe_interface_cleanup() - clean up netdev configurations
  * @fcoe:
+ *
+ * Caller must be holding the RTNL mutex
  */
 void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 {
@@ -266,11 +270,7 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	__dev_remove_pack(&fcoe->fip_packet_type);
 	synchronize_net();
 
-	/* tear-down the FCoE controller */
-	fcoe_ctlr_destroy(&fcoe->ctlr);
-
 	/* Delete secondary MAC addresses */
-	rtnl_lock();
 	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_unicast_delete(netdev, flogi_maddr);
 	if (!is_zero_ether_addr(fip->data_src_addr))
@@ -278,7 +278,6 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	if (fip->spma)
 		dev_unicast_delete(netdev, fip->ctl_src_addr);
 	dev_mc_delete(netdev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
-	rtnl_unlock();
 }
 
 /**
@@ -288,10 +287,14 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 static void fcoe_interface_release(struct kref *kref)
 {
 	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
 
 	fcoe = container_of(kref, struct fcoe_interface, kref);
-	fcoe_interface_cleanup(fcoe);
+	netdev = fcoe->netdev;
+	/* tear-down the FCoE controller */
+	fcoe_ctlr_destroy(&fcoe->ctlr);
 	kfree(fcoe);
+	dev_put(netdev);
 }
 
 /**
@@ -642,8 +645,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
-	/* Release the net_device and Scsi_Host */
-	dev_put(netdev);
+	/* Release the Scsi_Host */
 	scsi_host_put(lport->host);
 }
 
@@ -718,7 +720,9 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 	lport = shost_priv(shost);
 	port = lport_priv(lport);
+	port->lport = lport;
 	port->fcoe = fcoe;
+	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
 
 	/* configure fc_lport, e.g., em */
 	rc = fcoe_lport_config(lport);
@@ -769,7 +773,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
-	dev_hold(netdev);
 	fcoe_interface_get(fcoe);
 	return lport;
 
@@ -1530,19 +1533,19 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	struct fc_lport *lp = NULL;
 	struct net_device *netdev = ptr;
 	struct fcoe_interface *fcoe;
+	struct fcoe_port *port;
 	struct fcoe_dev_stats *stats;
 	u32 link_possible = 1;
 	u32 mfs;
 	int rc = NOTIFY_OK;
 
-	read_lock(&fcoe_hostlist_lock);
+	write_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
 		if (fcoe->netdev == netdev) {
 			lp = fcoe->ctlr.lp;
 			break;
 		}
 	}
-	read_unlock(&fcoe_hostlist_lock);
 	if (lp == NULL) {
 		rc = NOTIFY_DONE;
 		goto out;
@@ -1564,6 +1567,13 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		break;
 	case NETDEV_REGISTER:
 		break;
+	case NETDEV_UNREGISTER:
+		list_del(&fcoe->list);
+		port = lport_priv(fcoe->ctlr.lp);
+		fcoe_interface_cleanup(fcoe);
+		schedule_work(&port->destroy_work);
+		goto out;
+		break;
 	default:
 		FCOE_NETDEV_DBG(netdev, "Unknown event %ld "
 				"from netdev netlink\n", event);
@@ -1576,6 +1586,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		fcoe_clean_pending_queue(lp);
 	}
 out:
+	write_unlock(&fcoe_hostlist_lock);
 	return rc;
 }
 
@@ -1601,75 +1612,6 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
- * fcoe_netdev_to_module_owner() - finds out the driver module of the netdev
- * @netdev: the target netdev
- *
- * Returns: ptr to the struct module, NULL for failure
- */
-static struct module *
-fcoe_netdev_to_module_owner(const struct net_device *netdev)
-{
-	struct device *dev;
-
-	if (!netdev)
-		return NULL;
-
-	dev = netdev->dev.parent;
-	if (!dev)
-		return NULL;
-
-	if (!dev->driver)
-		return NULL;
-
-	return dev->driver->owner;
-}
-
-/**
- * fcoe_ethdrv_get() - Hold the Ethernet driver
- * @netdev: the target netdev
- *
- * Holds the Ethernet driver module by try_module_get() for
- * the corresponding netdev.
- *
- * Returns: 0 for success
- */
-static int fcoe_ethdrv_get(const struct net_device *netdev)
-{
-	struct module *owner;
-
-	owner = fcoe_netdev_to_module_owner(netdev);
-	if (owner) {
-		FCOE_NETDEV_DBG(netdev, "Hold driver module %s\n",
-				module_name(owner));
-		return  try_module_get(owner);
-	}
-	return -ENODEV;
-}
-
-/**
- * fcoe_ethdrv_put() - Release the Ethernet driver
- * @netdev: the target netdev
- *
- * Releases the Ethernet driver module by module_put for
- * the corresponding netdev.
- *
- * Returns: 0 for success
- */
-static int fcoe_ethdrv_put(const struct net_device *netdev)
-{
-	struct module *owner;
-
-	owner = fcoe_netdev_to_module_owner(netdev);
-	if (owner) {
-		FCOE_NETDEV_DBG(netdev, "Release driver module %s\n",
-				module_name(owner));
-		module_put(owner);
-		return 0;
-	}
-	return -ENODEV;
-}
-
-/**
  * fcoe_destroy() - handles the destroy from sysfs
  * @buffer: expected to be an eth if name
  * @kp: associated kernel param
@@ -1678,10 +1620,8 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
  */
 static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
-	struct net_device *netdev;
 	struct fcoe_interface *fcoe;
-	struct fcoe_port *port;
-	struct fc_lport *lport;
+	struct net_device *netdev;
 	int rc;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -1702,19 +1642,20 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		rc = -ENODEV;
 		goto out_nodev;
 	}
-	/* look for existing lport */
-	lport = fcoe_hostlist_lookup(netdev);
-	if (!lport) {
+
+	write_lock(&fcoe_hostlist_lock);
+	fcoe = fcoe_hostlist_lookup_port(netdev);
+	if (!fcoe) {
+		write_unlock(&fcoe_hostlist_lock);
 		rc = -ENODEV;
 		goto out_putdev;
 	}
-	/* Remove the instance from fcoe's list */
-	fcoe_hostlist_remove(lport);
-	port = lport_priv(lport);
-	fcoe = port->fcoe;
-	fcoe_if_destroy(lport);
-	fcoe_ethdrv_put(netdev);
-	rc = 0;
+	list_del(&fcoe->list);
+	write_unlock(&fcoe_hostlist_lock);
+	rtnl_lock();
+	fcoe_interface_cleanup(fcoe);
+	rtnl_unlock();
+	fcoe_if_destroy(fcoe->ctlr.lp);
 out_putdev:
 	dev_put(netdev);
 out_nodev:
@@ -1722,6 +1663,16 @@ out_nodev:
 	return rc;
 }
 
+static void fcoe_destroy_work(struct work_struct *work)
+{
+	struct fcoe_port *port;
+
+	port = container_of(work, struct fcoe_port, destroy_work);
+	mutex_lock(&fcoe_config_mutex);
+	fcoe_if_destroy(port->lport);
+	mutex_unlock(&fcoe_config_mutex);
+}
+
 /**
  * fcoe_create() - Handles the create call from sysfs
  * @buffer: expected to be an eth if name
@@ -1749,17 +1700,18 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 #endif
 
+	rtnl_lock();
 	netdev = fcoe_if_to_netdev(buffer);
 	if (!netdev) {
 		rc = -ENODEV;
 		goto out_nodev;
 	}
+
 	/* look for existing lport */
 	if (fcoe_hostlist_lookup(netdev)) {
 		rc = -EEXIST;
 		goto out_putdev;
 	}
-	fcoe_ethdrv_get(netdev);
 
 	fcoe = fcoe_interface_create(netdev);
 	if (!fcoe) {
@@ -1771,8 +1723,8 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	if (IS_ERR(lport)) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
-		fcoe_ethdrv_put(netdev);
 		rc = -EIO;
+		fcoe_interface_cleanup(fcoe);
 		goto out_free;
 	}
 
@@ -1798,6 +1750,7 @@ out_free:
 out_putdev:
 	dev_put(netdev);
 out_nodev:
+	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
@@ -1973,25 +1926,6 @@ int fcoe_hostlist_add(const struct fc_lport *lport)
 }
 
 /**
- * fcoe_hostlist_remove() - remove a lport from lports list
- * @lp: ptr to the fc_lport to be removed
- *
- * Returns: 0 for success
- */
-int fcoe_hostlist_remove(const struct fc_lport *lport)
-{
-	struct fcoe_interface *fcoe;
-
-	write_lock_bh(&fcoe_hostlist_lock);
-	fcoe = fcoe_hostlist_lookup_port(fcoe_netdev(lport));
-	BUG_ON(!fcoe);
-	list_del(&fcoe->list);
-	write_unlock_bh(&fcoe_hostlist_lock);
-
-	return 0;
-}
-
-/**
  * fcoe_init() - fcoe module loading initialization
  *
  * Returns 0 on success, negative on failure
@@ -2046,6 +1980,7 @@ static void __exit fcoe_exit(void)
 	unsigned int cpu;
 	struct fcoe_interface *fcoe, *tmp;
 	LIST_HEAD(local_list);
+	struct fcoe_port *port;
 
 	mutex_lock(&fcoe_config_mutex);
 
@@ -2058,7 +1993,11 @@ static void __exit fcoe_exit(void)
 
 	list_for_each_entry_safe(fcoe, tmp, &local_list, list) {
 		list_del(&fcoe->list);
-		fcoe_if_destroy(fcoe->ctlr.lp);
+		port = lport_priv(fcoe->ctlr.lp);
+		rtnl_lock();
+		fcoe_interface_cleanup(fcoe);
+		rtnl_unlock();
+		schedule_work(&port->destroy_work);
 	}
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
@@ -2066,9 +2005,14 @@ static void __exit fcoe_exit(void)
 	for_each_online_cpu(cpu)
 		fcoe_percpu_thread_destroy(cpu);
 
-	/* detach from scsi transport */
-	fcoe_if_exit();
-
 	mutex_unlock(&fcoe_config_mutex);
+
+	/* flush any asyncronous interface destroys,
+	 * this should happen after the netdev notifier is unregistered */
+	flush_scheduled_work();
+
+	/* detach from scsi transport
+	 * must happen after all destroys are done, therefor after the flush */
+	fcoe_if_exit();
 }
 module_exit(fcoe_exit);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index ff22928..ce7f60f 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -93,9 +93,11 @@ struct fcoe_interface {
  */
 struct fcoe_port {
 	struct fcoe_interface *fcoe;
+	struct fc_lport *lport;
 	struct sk_buff_head fcoe_pending_queue;
 	u8	fcoe_pending_queue_active;
 	struct timer_list timer;		/* queue timer */
+	struct work_struct destroy_work;	/* to prevent rtnl deadlocks */
 };
 
 #define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)

