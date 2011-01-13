From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 08/10] fcoe: convert fcoe.ko to become an fcoe transport
	provider driver
Date: Wed, 12 Jan 2011 18:20:29 -0800
Message-ID: <20110113022028.12798.12947.stg.yi.zou@intel.com>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab1AMCXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:23:24 -0500
In-Reply-To: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

Remove the existing sysfs entry points of the fcoe.ko module parameters that
are used to create/destroy/enable/disable an FCoE instance, rather, use the
newly added fcoe transport code to attach itself as an FCoE transport provider
when fcoe.ko gets loaded. There is no functionality change on the logic of
fcoe interacts with upper libfc and lower netdev. The fcoe transport only acts
as thin layer to provide a unified interface for all fcoe transport providers
so all FCoE instances on any network interfaces from all vendors can be
managed through the same Open-FCoE.org's user space tool package, which also
has full DCB support.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---

 drivers/scsi/fcoe/fcoe.c |  154 ++++++++++++++--------------------------------
 1 files changed, 46 insertions(+), 108 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6d6c8bf..cd40fc8 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -101,10 +101,10 @@ static int fcoe_ddp_done(struct fc_lport *, u16);
 
 static int fcoe_cpu_callback(struct notifier_block *, unsigned long, void *);
 
-static int fcoe_create(const char *, struct kernel_param *);
-static int fcoe_destroy(const char *, struct kernel_param *);
-static int fcoe_enable(const char *, struct kernel_param *);
-static int fcoe_disable(const char *, struct kernel_param *);
+static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode);
+static int fcoe_destroy(struct net_device *netdev);
+static int fcoe_enable(struct net_device *netdev);
+static int fcoe_disable(struct net_device *netdev);
 
 static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 				      u32 did, struct fc_frame *,
@@ -117,24 +117,6 @@ static void fcoe_recv_frame(struct sk_buff *skb);
 
 static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
 
-module_param_call(create, fcoe_create, NULL, (void *)FIP_MODE_FABRIC, S_IWUSR);
-__MODULE_PARM_TYPE(create, "string");
-MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
-module_param_call(create_vn2vn, fcoe_create, NULL,
-		  (void *)FIP_MODE_VN2VN, S_IWUSR);
-__MODULE_PARM_TYPE(create_vn2vn, "string");
-MODULE_PARM_DESC(create_vn2vn, " Creates a VN_node to VN_node FCoE instance "
-		 "on an Ethernet interface");
-module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
-__MODULE_PARM_TYPE(destroy, "string");
-MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
-module_param_call(enable, fcoe_enable, NULL, NULL, S_IWUSR);
-__MODULE_PARM_TYPE(enable, "string");
-MODULE_PARM_DESC(enable, " Enables fcoe on a ethernet interface.");
-module_param_call(disable, fcoe_disable, NULL, NULL, S_IWUSR);
-__MODULE_PARM_TYPE(disable, "string");
-MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
-
 /* notification function for packets from net device */
 static struct notifier_block fcoe_notifier = {
 	.notifier_call = fcoe_device_notification,
@@ -1939,39 +1921,16 @@ out:
 }
 
 /**
- * fcoe_if_to_netdev() - Parse a name buffer to get a net device
- * @buffer: The name of the net device
- *
- * Returns: NULL or a ptr to net_device
- */
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
-/**
  * fcoe_disable() - Disables a FCoE interface
- * @buffer: The name of the Ethernet interface to be disabled
- * @kp:	    The associated kernel parameter
+ * @netdev  : The net_device object the Ethernet interface to create on
  *
- * Called from sysfs.
+ * Called from fcoe transport.
  *
  * Returns: 0 for success
  */
-static int fcoe_disable(const char *buffer, struct kernel_param *kp)
+static int fcoe_disable(struct net_device *netdev)
 {
 	struct fcoe_interface *fcoe;
-	struct net_device *netdev;
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -1987,16 +1946,9 @@ static int fcoe_disable(const char *buffer, struct kernel_param *kp)
 	}
 #endif
 
-	netdev = fcoe_if_to_netdev(buffer);
-	if (!netdev) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-
 	if (!rtnl_trylock()) {
-		dev_put(netdev);
 		mutex_unlock(&fcoe_config_mutex);
-		return restart_syscall();
+		return -ENODEV;
 	}
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
@@ -2008,7 +1960,6 @@ static int fcoe_disable(const char *buffer, struct kernel_param *kp)
 	} else
 		rc = -ENODEV;
 
-	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
@@ -2016,17 +1967,15 @@ out_nodev:
 
 /**
  * fcoe_enable() - Enables a FCoE interface
- * @buffer: The name of the Ethernet interface to be enabled
- * @kp:     The associated kernel parameter
+ * @netdev  : The net_device object the Ethernet interface to create on
  *
- * Called from sysfs.
+ * Called from fcoe transport.
  *
  * Returns: 0 for success
  */
-static int fcoe_enable(const char *buffer, struct kernel_param *kp)
+static int fcoe_enable(struct net_device *netdev)
 {
 	struct fcoe_interface *fcoe;
-	struct net_device *netdev;
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -2041,17 +1990,9 @@ static int fcoe_enable(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 #endif
-
-	netdev = fcoe_if_to_netdev(buffer);
-	if (!netdev) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-
 	if (!rtnl_trylock()) {
-		dev_put(netdev);
 		mutex_unlock(&fcoe_config_mutex);
-		return restart_syscall();
+		return -ENODEV;
 	}
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
@@ -2062,7 +2003,6 @@ static int fcoe_enable(const char *buffer, struct kernel_param *kp)
 	else if (!fcoe_link_ok(fcoe->ctlr.lp))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 
-	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
@@ -2070,17 +2010,15 @@ out_nodev:
 
 /**
  * fcoe_destroy() - Destroy a FCoE interface
- * @buffer: The name of the Ethernet interface to be destroyed
- * @kp:	    The associated kernel parameter
+ * @netdev  : The net_device object the Ethernet interface to create on
  *
- * Called from sysfs.
+ * Called from fcoe transport
  *
  * Returns: 0 for success
  */
-static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
+static int fcoe_destroy(struct net_device *netdev)
 {
 	struct fcoe_interface *fcoe;
-	struct net_device *netdev;
 	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -2095,32 +2033,21 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 #endif
-
-	netdev = fcoe_if_to_netdev(buffer);
-	if (!netdev) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-
 	if (!rtnl_trylock()) {
-		dev_put(netdev);
 		mutex_unlock(&fcoe_config_mutex);
-		return restart_syscall();
+		return -ENODEV;
 	}
 
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	if (!fcoe) {
 		rtnl_unlock();
 		rc = -ENODEV;
-		goto out_putdev;
+		goto out_nodev;
 	}
 	fcoe_interface_cleanup(fcoe);
 	list_del(&fcoe->list);
 	/* RTNL mutex is dropped by fcoe_if_destroy */
 	fcoe_if_destroy(fcoe->ctlr.lp);
-
-out_putdev:
-	dev_put(netdev);
 out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
@@ -2144,26 +2071,24 @@ static void fcoe_destroy_work(struct work_struct *work)
 
 /**
  * fcoe_create() - Create a fcoe interface
- * @buffer: The name of the Ethernet interface to create on
- * @kp:	    The associated kernel param
+ * @netdev  : The net_device object the Ethernet interface to create on
+ * @fip_mode: The FIP mode for this creation
  *
- * Called from sysfs.
+ * Called from fcoe transport
  *
  * Returns: 0 for success
  */
-static int fcoe_create(const char *buffer, struct kernel_param *kp)
+static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 {
-	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
 	int rc;
 	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
-	struct net_device *netdev;
 
 	mutex_lock(&fcoe_config_mutex);
 
 	if (!rtnl_trylock()) {
 		mutex_unlock(&fcoe_config_mutex);
-		return restart_syscall();
+		return -EIO;
 	}
 
 #ifdef CONFIG_FCOE_MODULE
@@ -2178,22 +2103,16 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 #endif
 
-	netdev = fcoe_if_to_netdev(buffer);
-	if (!netdev) {
-		rc = -ENODEV;
-		goto out_nodev;
-	}
-
 	/* look for existing lport */
 	if (fcoe_hostlist_lookup(netdev)) {
 		rc = -EEXIST;
-		goto out_putdev;
+		goto out_nodev;
 	}
 
 	fcoe = fcoe_interface_create(netdev, fip_mode);
 	if (IS_ERR(fcoe)) {
 		rc = PTR_ERR(fcoe);
-		goto out_putdev;
+		goto out_nodev;
 	}
 
 	lport = fcoe_if_create(fcoe, &netdev->dev, 0);
@@ -2222,15 +2141,12 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	 * should be holding a reference taken in fcoe_if_create().
 	 */
 	fcoe_interface_put(fcoe);
-	dev_put(netdev);
 	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
 
 	return 0;
 out_free:
 	fcoe_interface_put(fcoe);
-out_putdev:
-	dev_put(netdev);
 out_nodev:
 	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
@@ -2433,6 +2349,17 @@ static int fcoe_hostlist_add(const struct fc_lport *lport)
 	return 0;
 }
 
+
+static struct fcoe_transport fcoe_sw_transport = {
+	.name = {"fcoe"},
+	.attached = false,
+	.list = LIST_HEAD_INIT(fcoe_sw_transport.list),
+	.create = fcoe_create,
+	.destroy = fcoe_destroy,
+	.enable = fcoe_enable,
+	.disable = fcoe_disable,
+};
+
 /**
  * fcoe_init() - Initialize fcoe.ko
  *
@@ -2444,6 +2371,14 @@ static int __init fcoe_init(void)
 	unsigned int cpu;
 	int rc = 0;
 
+	/* register as a fcoe transport */
+	rc = fcoe_transport_attach(&fcoe_sw_transport);
+	if (rc) {
+		printk(KERN_ERR "failed to register an fcoe transport, check "
+			"if libfcoe is loaded\n");
+		return rc;
+	}
+
 	mutex_lock(&fcoe_config_mutex);
 
 	for_each_possible_cpu(cpu) {
@@ -2520,6 +2455,9 @@ static void __exit fcoe_exit(void)
 	/* detach from scsi transport
 	 * must happen after all destroys are done, therefor after the flush */
 	fcoe_if_exit();
+
+	/* detach from fcoe transport */
+	fcoe_transport_detach(&fcoe_sw_transport);
 }
 module_exit(fcoe_exit);
 

