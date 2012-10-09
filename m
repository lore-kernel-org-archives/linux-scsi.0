From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v4 4/5] fcoe: Use the fcoe_sysfs control interface
Date: Tue, 09 Oct 2012 15:19:12 -0700
Message-ID: <20121009221911.11139.34560.stgit@fritz>
References: <20121009221850.11139.39902.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab2JIWTU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2012 18:19:20 -0400
In-Reply-To: <20121009221850.11139.39902.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nhorman@redhat.com, bvanassche@acm.org, gregkh@linuxfoundation.org, cleech@redhat.com, bprakash@broadcom.com, devel@open-fcoe.org

This patch adds support for the new fcoe_sysfs
control interface to fcoe.ko. It keeps the deprecated
interface in tact and therefore either the legacy
or the new control interfaces can be used. A mixed mode
is not supported. A user must either use the new
interfaces or the old ones, but not both.

The fcoe_ctlr's link state is now driven by both the
netdev link state as well as the fcoe_ctlr_device's
enabled attribute. The link must be up and the
fcoe_ctlr_device must be enabled before the FCoE
Controller starts discovery or login.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |  147 +++++++++++++++++++++++++++++++++++++----
 drivers/scsi/fcoe/fcoe_ctlr.c |   17 ++---
 2 files changed, 140 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 99e9d02..995ef96 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -117,6 +117,11 @@ static int fcoe_destroy(struct net_device *netdev);
 static int fcoe_enable(struct net_device *netdev);
 static int fcoe_disable(struct net_device *netdev);
 
+/* fcoe_syfs control interface handlers */
+static int fcoe_ctlr_alloc(struct net_device *netdev);
+static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev);
+
+
 static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 				      u32 did, struct fc_frame *,
 				      unsigned int op,
@@ -155,6 +160,8 @@ static void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *);
 static void fcoe_fcf_get_vlan_id(struct fcoe_fcf_device *);
 
 static struct fcoe_sysfs_function_template fcoe_sysfs_templ = {
+	.set_fcoe_ctlr_mode = fcoe_ctlr_set_fip_mode,
+	.set_fcoe_ctlr_enabled = fcoe_ctlr_enabled,
 	.get_fcoe_ctlr_link_fail = fcoe_ctlr_get_lesb,
 	.get_fcoe_ctlr_vlink_fail = fcoe_ctlr_get_lesb,
 	.get_fcoe_ctlr_miss_fka = fcoe_ctlr_get_lesb,
@@ -1966,6 +1973,7 @@ static int fcoe_dcb_app_notification(struct notifier_block *notifier,
 static int fcoe_device_notification(struct notifier_block *notifier,
 				    ulong event, void *ptr)
 {
+	struct fcoe_ctlr_device *cdev;
 	struct fc_lport *lport = NULL;
 	struct net_device *netdev = ptr;
 	struct fcoe_ctlr *ctlr;
@@ -2022,13 +2030,29 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 
 	fcoe_link_speed_update(lport);
 
-	if (link_possible && !fcoe_link_ok(lport))
-		fcoe_ctlr_link_up(ctlr);
-	else if (fcoe_ctlr_link_down(ctlr)) {
-		stats = per_cpu_ptr(lport->stats, get_cpu());
-		stats->LinkFailureCount++;
-		put_cpu();
-		fcoe_clean_pending_queue(lport);
+	cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
+
+	if (link_possible && !fcoe_link_ok(lport)) {
+		switch (cdev->enabled) {
+		case FCOE_CTLR_DISABLED:
+			pr_info("Link up while interface is disabled.\n");
+			break;
+		case FCOE_CTLR_ENABLED:
+		case FCOE_CTLR_UNUSED:
+			fcoe_ctlr_link_up(ctlr);
+		};
+	} else if (fcoe_ctlr_link_down(ctlr)) {
+		switch (cdev->enabled) {
+		case FCOE_CTLR_DISABLED:
+			pr_info("Link down while interface is disabled.\n");
+			break;
+		case FCOE_CTLR_ENABLED:
+		case FCOE_CTLR_UNUSED:
+			stats = per_cpu_ptr(lport->stats, get_cpu());
+			stats->LinkFailureCount++;
+			put_cpu();
+			fcoe_clean_pending_queue(lport);
+		};
 	}
 out:
 	return rc;
@@ -2041,6 +2065,8 @@ out:
  * Called from fcoe transport.
  *
  * Returns: 0 for success
+ *
+ * Deprecated: use fcoe_ctlr_enabled()
  */
 static int fcoe_disable(struct net_device *netdev)
 {
@@ -2100,6 +2126,33 @@ out:
 }
 
 /**
+ * fcoe_ctlr_enabled() - Enable or disable an FCoE Controller
+ * @cdev: The FCoE Controller that is being enabled or disabled
+ *
+ * fcoe_sysfs will ensure that the state of 'enabled' has
+ * changed, so no checking is necessary here. This routine simply
+ * calls fcoe_enable or fcoe_disable, both of which are deprecated.
+ * When those routines are removed the functionality can be merged
+ * here.
+ */
+static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev)
+{
+	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(cdev);
+	struct fc_lport *lport = ctlr->lp;
+	struct net_device *netdev = fcoe_netdev(lport);
+
+	switch (cdev->enabled) {
+	case FCOE_CTLR_ENABLED:
+		return fcoe_enable(netdev);
+	case FCOE_CTLR_DISABLED:
+		return fcoe_disable(netdev);
+	case FCOE_CTLR_UNUSED:
+	default:
+		return -ENOTSUPP;
+	};
+}
+
+/**
  * fcoe_destroy() - Destroy a FCoE interface
  * @netdev  : The net_device object the Ethernet interface to create on
  *
@@ -2207,16 +2260,26 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 #endif
 }
 
+enum fcoe_create_link_state {
+	FCOE_CREATE_LINK_DOWN,
+	FCOE_CREATE_LINK_UP,
+};
+
 /**
- * fcoe_create() - Create a fcoe interface
- * @netdev  : The net_device object the Ethernet interface to create on
- * @fip_mode: The FIP mode for this creation
+ * _fcoe_create() - (internal) Create a fcoe interface
+ * @netdev  :   The net_device object the Ethernet interface to create on
+ * @fip_mode:   The FIP mode for this creation
+ * @link_state: The ctlr link state on creation
  *
- * Called from fcoe transport
+ * Called from either the libfcoe 'create' module parameter
+ * via fcoe_create or from fcoe_syfs's ctlr_create file.
  *
- * Returns: 0 for success
+ * libfcoe's 'create' module parameter is deprecated so some
+ * consolidation of code can be done when that interface is
+ * removed.
  */
-static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
+static int _fcoe_create(struct net_device *netdev, enum fip_state fip_mode,
+			enum fcoe_create_link_state link_state)
 {
 	int rc = 0;
 	struct fcoe_ctlr_device *ctlr_dev;
@@ -2263,7 +2326,26 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	/* start FIP Discovery and FLOGI */
 	lport->boot_time = jiffies;
 	fc_fabric_login(lport);
-	if (!fcoe_link_ok(lport)) {
+
+	/*
+	 * If the fcoe_ctlr_device is to be set to DISABLED
+	 * it must be done after the lport is added to the
+	 * hostlist, but before the rtnl_lock is released.
+	 * This is because the rtnl_lock protects the
+	 * hostlist that fcoe_device_notification uses. If
+	 * the FCoE Controller is intended to be created
+	 * DISABLED then 'enabled' needs to be considered
+	 * handling link events. 'enabled' must be set
+	 * before the lport can be found in the hostlist
+	 * when a link up event is received.
+	 */
+	if (link_state == FCOE_CREATE_LINK_UP)
+		ctlr_dev->enabled = FCOE_CTLR_ENABLED;
+	else
+		ctlr_dev->enabled = FCOE_CTLR_DISABLED;
+
+	if (link_state == FCOE_CREATE_LINK_UP &&
+	    !fcoe_link_ok(lport)) {
 		rtnl_unlock();
 		fcoe_ctlr_link_up(ctlr);
 		mutex_unlock(&fcoe_config_mutex);
@@ -2278,6 +2360,37 @@ out_nortnl:
 }
 
 /**
+ * fcoe_create() - Create a fcoe interface
+ * @netdev  : The net_device object the Ethernet interface to create on
+ * @fip_mode: The FIP mode for this creation
+ *
+ * Called from fcoe transport
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
+{
+	return _fcoe_create(netdev, fip_mode, FCOE_CREATE_LINK_UP);
+}
+
+/**
+ * fcoe_ctlr_alloc() - Allocate a fcoe interface from fcoe_sysfs
+ * @netdev: The net_device to be used by the allocated FCoE Controller
+ *
+ * This routine is called from fcoe_sysfs. It will start the fcoe_ctlr
+ * in a link_down state. The allows the user an opportunity to configure
+ * the FCoE Controller from sysfs before enabling the FCoE Controller.
+ *
+ * Creating in with this routine starts the FCoE Controller in Fabric
+ * mode. The user can change to VN2VN or another mode before enabling.
+ */
+static int fcoe_ctlr_alloc(struct net_device *netdev)
+{
+	return _fcoe_create(netdev, FIP_MODE_FABRIC,
+			    FCOE_CREATE_LINK_DOWN);
+}
+
+/**
  * fcoe_link_speed_update() - Update the supported and actual link speeds
  * @lport: The local port to update speeds for
  *
@@ -2378,10 +2491,13 @@ static int fcoe_reset(struct Scsi_Host *shost)
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->priv;
 	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
+	struct fcoe_ctlr_device *cdev = fcoe_ctlr_to_ctlr_dev(ctlr);
 
 	fcoe_ctlr_link_down(ctlr);
 	fcoe_clean_pending_queue(ctlr->lp);
-	if (!fcoe_link_ok(ctlr->lp))
+
+	if (cdev->enabled != FCOE_CTLR_DISABLED &&
+	    !fcoe_link_ok(ctlr->lp))
 		fcoe_ctlr_link_up(ctlr);
 	return 0;
 }
@@ -2454,6 +2570,7 @@ static struct fcoe_transport fcoe_sw_transport = {
 	.attached = false,
 	.list = LIST_HEAD_INIT(fcoe_sw_transport.list),
 	.match = fcoe_match,
+	.alloc = fcoe_ctlr_alloc,
 	.create = fcoe_create,
 	.destroy = fcoe_destroy,
 	.enable = fcoe_enable,
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 2ebe03a..7583425 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2864,22 +2864,21 @@ void fcoe_fcf_get_selected(struct fcoe_fcf_device *fcf_dev)
 }
 EXPORT_SYMBOL(fcoe_fcf_get_selected);
 
-void fcoe_ctlr_get_fip_mode(struct fcoe_ctlr_device *ctlr_dev)
+void fcoe_ctlr_set_fip_mode(struct fcoe_ctlr_device *ctlr_dev)
 {
 	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
 
 	mutex_lock(&ctlr->ctlr_mutex);
-	switch (ctlr->mode) {
-	case FIP_MODE_FABRIC:
-		ctlr_dev->mode = FIP_CONN_TYPE_FABRIC;
-		break;
-	case FIP_MODE_VN2VN:
-		ctlr_dev->mode = FIP_CONN_TYPE_VN2VN;
+	switch (ctlr_dev->mode) {
+	case FIP_CONN_TYPE_VN2VN:
+		ctlr->mode = FIP_MODE_VN2VN;
 		break;
+	case FIP_CONN_TYPE_FABRIC:
 	default:
-		ctlr_dev->mode = FIP_CONN_TYPE_UNKNOWN;
+		ctlr->mode = FIP_MODE_FABRIC;
 		break;
 	}
+
 	mutex_unlock(&ctlr->ctlr_mutex);
 }
-EXPORT_SYMBOL(fcoe_ctlr_get_fip_mode);
+EXPORT_SYMBOL(fcoe_ctlr_set_fip_mode);

