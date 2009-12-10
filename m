From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/3] fcoe, libfc: adds enable/disable for fcoe interface
Date: Thu, 10 Dec 2009 09:59:31 -0800
Message-ID: <20091210175931.12227.44974.stgit@localhost.localdomain>
References: <20091210175915.12227.50544.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761305AbZLJR7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 12:59:25 -0500
In-Reply-To: <20091210175915.12227.50544.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

This is to allow fcoemon util to enable or disable a fcoe interface
according to DCB link state change.

Adds sysfs module param enable and disable for this and also
updates existing other module param description to be consistent
and more accurate since older description had double "fcoe" word
with less meaningful netdev reference to user space.

Adds code to ignore redundant fc_lport_enter_reset handling for a
already disabled fcoe interface by checking LPORT_ST_DISABLED
or LPORT_ST_LOGO states, this also prevents lport state transition
on link flap on a disabled interface.

Above changes required lport state transition to get out of
disabled or logo state on call to fc_fabric_login.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |  110 ++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/libfc/fc_lport.c |    7 ++-
 2 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a30ffaa..2ecb2f0 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -101,6 +101,8 @@ static int fcoe_cpu_callback(struct notifier_block *, unsigned long, void *);
 
 static int fcoe_create(const char *, struct kernel_param *);
 static int fcoe_destroy(const char *, struct kernel_param *);
+static int fcoe_enable(const char *, struct kernel_param *);
+static int fcoe_disable(const char *, struct kernel_param *);
 
 static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 				      u32 did, struct fc_frame *,
@@ -115,10 +117,16 @@ static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
 
 module_param_call(create, fcoe_create, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
-MODULE_PARM_DESC(create, "Create fcoe fcoe using net device passed in.");
+MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
 module_param_call(destroy, fcoe_destroy, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(destroy, "string");
-MODULE_PARM_DESC(destroy, "Destroy fcoe fcoe");
+MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
+module_param_call(enable, fcoe_enable, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(enable, "string");
+MODULE_PARM_DESC(enable, " Enables fcoe on a ethernet interface.");
+module_param_call(disable, fcoe_disable, NULL, NULL, S_IWUSR);
+__MODULE_PARM_TYPE(disable, "string");
+MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
 
 /* notification function for packets from net device */
 static struct notifier_block fcoe_notifier = {
@@ -1838,6 +1846,104 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
+ * fcoe_disable() - Disables a FCoE interface
+ * @buffer: The name of the Ethernet interface to be disabled
+ * @kp:	    The associated kernel parameter
+ *
+ * Called from sysfs.
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_disable(const char *buffer, struct kernel_param *kp)
+{
+	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
+	int rc = 0;
+
+	mutex_lock(&fcoe_config_mutex);
+#ifdef CONFIG_FCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+#endif
+
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+
+	rtnl_lock();
+	fcoe = fcoe_hostlist_lookup_port(netdev);
+	rtnl_unlock();
+
+	if (fcoe)
+		fc_fabric_logoff(fcoe->ctlr.lp);
+	else
+		rc = -ENODEV;
+
+	dev_put(netdev);
+out_nodev:
+	mutex_unlock(&fcoe_config_mutex);
+	return rc;
+}
+
+/**
+ * fcoe_enable() - Enables a FCoE interface
+ * @buffer: The name of the Ethernet interface to be enabled
+ * @kp:     The associated kernel parameter
+ *
+ * Called from sysfs.
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_enable(const char *buffer, struct kernel_param *kp)
+{
+	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
+	int rc = 0;
+
+	mutex_lock(&fcoe_config_mutex);
+#ifdef CONFIG_FCOE_MODULE
+	/*
+	 * Make sure the module has been initialized, and is not about to be
+	 * removed.  Module paramter sysfs files are writable before the
+	 * module_init function is called and after module_exit.
+	 */
+	if (THIS_MODULE->state != MODULE_STATE_LIVE) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+#endif
+
+	netdev = fcoe_if_to_netdev(buffer);
+	if (!netdev) {
+		rc = -ENODEV;
+		goto out_nodev;
+	}
+
+	rtnl_lock();
+	fcoe = fcoe_hostlist_lookup_port(netdev);
+	rtnl_unlock();
+
+	if (fcoe)
+		rc = fc_fabric_login(fcoe->ctlr.lp);
+	else
+		rc = -ENODEV;
+
+	dev_put(netdev);
+out_nodev:
+	mutex_unlock(&fcoe_config_mutex);
+	return rc;
+}
+
+/**
  * fcoe_destroy() - Destroy a FCoE interface
  * @buffer: The name of the Ethernet interface to be destroyed
  * @kp:	    The associated kernel parameter
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bbf4152..99fcef9 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -537,7 +537,9 @@ int fc_fabric_login(struct fc_lport *lport)
 	int rc = -1;
 
 	mutex_lock(&lport->lp_mutex);
-	if (lport->state == LPORT_ST_DISABLED) {
+	if (lport->state == LPORT_ST_DISABLED ||
+	    lport->state == LPORT_ST_LOGO) {
+		fc_lport_state_enter(lport, LPORT_ST_RESET);
 		fc_lport_enter_reset(lport);
 		rc = 0;
 	}
@@ -967,6 +969,9 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 	FC_LPORT_DBG(lport, "Entered RESET state from %s state\n",
 		     fc_lport_state(lport));
 
+	if (lport->state == LPORT_ST_DISABLED || lport->state == LPORT_ST_LOGO)
+		return;
+
 	if (lport->vport) {
 		if (lport->link_up)
 			fc_vport_set_state(lport->vport, FC_VPORT_INITIALIZING);

