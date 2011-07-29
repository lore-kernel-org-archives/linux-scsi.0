From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 7/7] fcoe: Use the new FC Transport APIs for FC ports and
 fabrics
Date: Fri, 29 Jul 2011 16:39:00 -0700
Message-ID: <20110729233900.12794.75789.stgit@localhost6.localdomain6>
References: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63218 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1G2XjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 19:39:02 -0400
In-Reply-To: <20110729233823.12794.94487.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, giridhar.malavali@qlogic.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: neerav.parikh@intel.com

This patch adds the usage of the FC Port and FC Fabric
device API added to the FC Transport in a previous patch.

There is minimal impact to libfc with the currently limited
set of attributes on the FC Port and FC Fabric devices.
When more attributes are used on these new devices and are
not used on the FC Host there is likely to be more impact
on libfc.

libfcoe requires the following changes to use the new
FC Transport APIs.

* Creation of FCoE FCF Event Queue (fcoe_fcf_eq) to avoid
  locking issues when adding and deleting new FCFs from
  sysfs
* Allocation of 'struct fcoe_fcf' with 'struct fc_fabric'
* Implemention of fcoe_fabric_match to compare FCFs
* Helper routines for fabric adition and deletion
  (list manipulation for new FCFs)
* Break out fcoe_ctlr_process_fcf from fcoe_ctlr_recv_adv
  so that FCFs can be processed either in the receive
  context (for simple updates) or from the fcoe_fcf_wq
* Use of fc_fabric_add and fc_fabric_del

fcoe requires the following changes to use the new
FC Transport APIs.

* Use of libfcoe's fabric addition/deletion helper routines
* Allocation of 'struct fcoe_port' with 'struct fc_port'
* Use of fc_port_add and fc_port_del

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c           |  337 ++++++++++++++++++++++++------------
 drivers/scsi/fcoe/fcoe.h           |    3 
 drivers/scsi/fcoe/fcoe_ctlr.c      |  310 ++++++++++++++++++++++++++-------
 drivers/scsi/fcoe/fcoe_transport.c |    7 +
 drivers/scsi/libfc/fc_lport.c      |    1 
 include/scsi/libfcoe.h             |   34 ++++
 6 files changed, 513 insertions(+), 179 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 59f2ef8..2652e01 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -140,6 +140,26 @@ static void fcoe_set_vport_symbolic_name(struct fc_vport *);
 static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
 static int fcoe_validate_vport_create(struct fc_vport *);
 
+static int fcoe_fabric_create(struct fc_port *port,
+			      struct fc_fabric *fabric)
+{
+	struct fcoe_interface *fcoe = fc_port_priv(port);
+	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+
+	return fcoe_ctlr_fabric_create(fip, fcf);
+}
+
+static int fcoe_fabric_destroy(struct fc_port *port,
+			       struct fc_fabric *fabric)
+{
+	struct fcoe_interface *fcoe = fc_port_priv(port);
+	struct fcoe_ctlr *fip = &fcoe->ctlr;
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+
+	return fcoe_ctlr_fabric_destroy(fip, fcf);
+}
+
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 	.ddp_setup = fcoe_ddp_setup,
@@ -151,12 +171,22 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 };
 
 struct fc_function_template fcoe_nport_fc_functions = {
+	.dd_fcport_size = sizeof(struct fcoe_interface),
+	.show_port_maxframe_size = 1,
+
+	.dd_fcfabric_size = sizeof(struct fcoe_fcf),
+	.fabric_match = fcoe_fabric_match,
+	.show_fabric_fabric_name = 1,
+
+	.fabric_create = fcoe_fabric_create,
+	.fabric_destroy = fcoe_fabric_destroy,
+
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
 	.show_host_supported_fc4s = 1,
 	.show_host_active_fc4s = 1,
-	.show_host_maxframe_size = 1,
+//	.show_host_maxframe_size = 1,
 
 	.show_host_port_id = 1,
 	.show_host_supported_speeds = 1,
@@ -171,7 +201,7 @@ struct fc_function_template fcoe_nport_fc_functions = {
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 
-	.show_host_fabric_name = 1,
+//	.show_host_fabric_name = 1,
 	.show_starget_node_name = 1,
 	.show_starget_port_name = 1,
 	.show_starget_port_id = 1,
@@ -196,7 +226,7 @@ struct fc_function_template fcoe_vport_fc_functions = {
 	.show_host_supported_classes = 1,
 	.show_host_supported_fc4s = 1,
 	.show_host_active_fc4s = 1,
-	.show_host_maxframe_size = 1,
+//	.show_host_maxframe_size = 1,
 
 	.show_host_port_id = 1,
 	.show_host_supported_speeds = 1,
@@ -211,7 +241,7 @@ struct fc_function_template fcoe_vport_fc_functions = {
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 
-	.show_host_fabric_name = 1,
+//	.show_host_fabric_name = 1,
 	.show_starget_node_name = 1,
 	.show_starget_port_name = 1,
 	.show_starget_port_id = 1,
@@ -261,6 +291,8 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
 
+	rtnl_lock();
+
 	fcoe->netdev = netdev;
 
 	/* Let LLD initialize for FCoE */
@@ -325,19 +357,25 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	fcoe->fip_packet_type.dev = netdev;
 	dev_add_pack(&fcoe->fip_packet_type);
 
+	rtnl_unlock();
+
 	return 0;
 }
 
 /**
  * fcoe_interface_create() - Create a FCoE interface on a net device
+ * @shost: The SCSI Host to attach the FC Port to
  * @netdev: The net device to create the FCoE interface on
  * @fip_mode: The mode to use for FIP
  *
  * Returns: pointer to a struct fcoe_interface or NULL on error
+ * Note: Called after fcoe_shost_create()
  */
-static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
+static struct fcoe_interface *fcoe_interface_create(struct Scsi_Host *shost,
+						    struct net_device *netdev,
 						    enum fip_state fip_mode)
 {
+	struct fc_port *port;
 	struct fcoe_interface *fcoe;
 	int err;
 
@@ -348,18 +386,21 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		goto out;
 	}
 
-	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
-	if (!fcoe) {
-		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
+	port = fc_port_add(shost);
+	if (!port) {
+		printk(KERN_ERR "Failed to add a fcport\n");
 		fcoe = ERR_PTR(-ENOMEM);
 		goto out_putmod;
 	}
 
+	fcoe = fc_port_priv(port);
+
 	dev_hold(netdev);
 
 	/*
 	 * Initialize FIP.
 	 */
+	fcoe->ctlr.port = port;
 	fcoe_ctlr_init(&fcoe->ctlr, fip_mode);
 	fcoe->ctlr.send = fcoe_fip_send;
 	fcoe->ctlr.update_mac = fcoe_update_src_mac;
@@ -367,11 +408,9 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 
 	err = fcoe_interface_setup(fcoe, netdev);
 	if (err) {
-		fcoe_ctlr_destroy(&fcoe->ctlr);
-		kfree(fcoe);
-		dev_put(netdev);
+		fc_port_del(port);
 		fcoe = ERR_PTR(err);
-		goto out_putmod;
+		goto out;
 	}
 
 	goto out;
@@ -505,9 +544,8 @@ static u8 *fcoe_get_src_mac(struct fc_lport *lport)
  * fcoe_lport_config() - Set up a local port
  * @lport: The local port to be setup
  *
- * Returns: 0 for success
  */
-static int fcoe_lport_config(struct fc_lport *lport)
+static void fcoe_lport_config(struct fc_lport *lport)
 {
 	lport->link_up = 0;
 	lport->qfull = 0;
@@ -530,8 +568,6 @@ static int fcoe_lport_config(struct fc_lport *lport)
 	lport->lro_enabled = 0;
 	lport->lro_xid = 0;
 	lport->lso_max = 0;
-
-	return 0;
 }
 
 /**
@@ -552,6 +588,26 @@ static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
 }
 
 /**
+ * fcoe_set_mfs() - Sets the lport and fc port max frame size
+ * @lport: The lport to change
+ * @mfs:   The new max frame size
+ */
+static int fcoe_set_mfs(struct fc_lport *lport, u32 mfs)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->priv;
+	struct fc_port *fcport = fcoe_to_fcport(fcoe);
+	int rc;
+
+	rc = fc_set_mfs(lport, mfs);
+
+	if (!rc)
+		fc_port_maxframe_size(fcport) = mfs;
+
+	return rc;
+}
+
+/**
  * fcoe_netdev_features_change - Updates the lport's offload flags based
  * on the LLD netdev's FCoE feature flags
  */
@@ -626,7 +682,7 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 		FCOE_NETDEV_DBG(netdev, "Supports FCOE_MTU of %d bytes\n", mfs);
 	}
 	mfs -= (sizeof(struct fcoe_hdr) + sizeof(struct fcoe_crc_eof));
-	if (fc_set_mfs(lport, mfs))
+	if (fcoe_set_mfs(lport, mfs))
 		return -EINVAL;
 
 	/* offload features support */
@@ -686,10 +742,6 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 	if (!lport->vport)
 		fc_host_max_npiv_vports(lport->host) = USHRT_MAX;
 
-	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
-		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
-		 fcoe_netdev(lport)->name);
-
 	return 0;
 }
 
@@ -920,86 +972,42 @@ static int fcoe_ddp_done(struct fc_lport *lport, u16 xid)
 }
 
 /**
- * fcoe_if_create() - Create a FCoE instance on an interface
- * @fcoe:   The FCoE interface to create a local port on
- * @parent: The device pointer to be the parent in sysfs for the SCSI host
- * @npiv:   Indicates if the port is a vport or not
+ * fcoe_if_config() - Configure an FCoE instance on an interface
+ * @fcoe: The FCoE interface to configure a local port on
+ * @port: The FCoE port assocated with the local port
+ * @vport: The vport, if configuring on a vport. NULL if N_Port.
  *
  * Creates a fc_lport instance and a Scsi_Host instance and configure them.
- *
- * Returns: The allocated fc_lport or an error pointer
  */
-static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
-				       struct device *parent, int npiv)
+static int fcoe_if_config(struct fcoe_interface *fcoe,
+			  struct fcoe_port *port,
+			  struct fc_vport *vport)
 {
 	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *lport, *n_port;
-	struct fcoe_port *port;
+	struct fc_lport *n_lport;
 	struct Scsi_Host *shost;
 	int rc;
-	/*
-	 * parent is only a vport if npiv is 1,
-	 * but we'll only use vport in that case so go ahead and set it
-	 */
-	struct fc_vport *vport = dev_to_vport(parent);
 
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
-	if (!npiv)
-		lport = libfc_host_alloc(&fcoe_shost_template, sizeof(*port));
-	else
-		lport = libfc_vport_create(vport, sizeof(*port));
-
-	if (!lport) {
-		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-	port = lport_priv(lport);
-	port->lport = lport;
+	/* Associate the interface with the port */
 	port->priv = fcoe;
-	port->max_queue_depth = FCOE_MAX_QUEUE_DEPTH;
-	port->min_queue_depth = FCOE_MIN_QUEUE_DEPTH;
-	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
-
-	/* configure a fc_lport including the exchange manager */
-	rc = fcoe_lport_config(lport);
-	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure lport for the "
-				"interface\n");
-		goto out_host_put;
-	}
-
-	if (npiv) {
-		FCOE_NETDEV_DBG(netdev, "Setting vport names, "
-				"%16.16llx %16.16llx\n",
-				vport->node_name, vport->port_name);
-		fc_set_wwnn(lport, vport->node_name);
-		fc_set_wwpn(lport, vport->port_name);
-	}
 
 	/* configure lport network properties */
-	rc = fcoe_netdev_config(lport, netdev);
+	rc = fcoe_netdev_config(port->lport, netdev);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure netdev for the "
 				"interface\n");
-		goto out_lp_destroy;
-	}
-
-	/* configure lport scsi host properties */
-	rc = fcoe_shost_config(lport, parent);
-	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
-				"interface\n");
-		goto out_lp_destroy;
+		goto out;
 	}
 
 	/* Initialize the library */
-	rc = fcoe_libfc_config(lport, &fcoe->ctlr, &fcoe_libfc_fcn_templ, 1);
+	rc = fcoe_libfc_config(port->lport, &fcoe->ctlr,
+			       &fcoe_libfc_fcn_templ, 1);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
 				"interface\n");
-		goto out_lp_destroy;
+		goto out;
 	}
 
 	/*
@@ -1011,28 +1019,22 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	 * This is currently handled through the fcoe_config_mutex
 	 * begin held.
 	 */
-	if (!npiv)
+	if (!vport)
 		/* lport exch manager allocation */
-		rc = fcoe_em_config(lport);
+		rc = fcoe_em_config(port->lport);
 	else {
 		shost = vport_to_shost(vport);
-		n_port = shost_priv(shost);
-		rc = fc_exch_mgr_list_clone(n_port, lport);
+		n_lport = shost_priv(shost);
+		rc = fc_exch_mgr_list_clone(n_lport, port->lport);
 	}
 
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure the EM\n");
-		goto out_lp_destroy;
+		goto out;
 	}
 
-	return lport;
-
-out_lp_destroy:
-	fc_exch_mgr_free(lport);
-out_host_put:
-	scsi_host_put(lport->host);
 out:
-	return ERR_PTR(rc);
+	return rc;
 }
 
 /**
@@ -1782,7 +1784,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
 				     sizeof(struct fcoe_crc_eof));
 		if (mfs >= FC_MIN_MAX_FRAME)
-			fc_set_mfs(lport, mfs);
+			fcoe_set_mfs(lport, mfs);
 		break;
 	case NETDEV_REGISTER:
 		break;
@@ -1930,6 +1932,82 @@ static bool fcoe_match(struct net_device *netdev)
 	return true;
 }
 
+static struct Scsi_Host *fcoe_shost_create(struct net_device *netdev,
+					   struct fc_vport *vport)
+{
+	struct fc_lport *lport;
+	struct fcoe_port *port;
+	int rc;
+
+	if (!vport)
+		lport = libfc_host_alloc(&fcoe_shost_template, sizeof(*port));
+	else
+		lport = libfc_vport_create(vport, sizeof(*port));
+
+	if (!lport) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
+		rc = -ENOMEM;
+		return NULL;
+	}
+
+	port = lport_priv(lport);
+	port->lport = lport;
+	port->max_queue_depth = FCOE_MAX_QUEUE_DEPTH;
+	port->min_queue_depth = FCOE_MIN_QUEUE_DEPTH;
+	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
+
+	/* configure a fc_lport including the exchange manager */
+	fcoe_lport_config(lport);
+
+	if (vport) {
+		FCOE_NETDEV_DBG(netdev, "Setting vport names, "
+				"%16.16llx %16.16llx\n",
+				vport->node_name, vport->port_name);
+		fc_set_wwnn(lport, vport->node_name);
+		fc_set_wwpn(lport, vport->port_name);
+	}
+
+	/* configure lport scsi host properties */
+	rc = fcoe_shost_config(lport, &netdev->dev);
+	if (rc) {
+		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
+				"interface\n");
+//		goto out_lp_destroy;
+	}
+
+	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
+		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
+		 netdev->name);
+
+	return lport->host;
+}
+
+/**
+ * fcoe_shost_destroy() - Destroy the FC and Scsi_Host
+ * @shost: The host to be removed and destroyed
+ *
+ * This routine is called when fcoe_shost_create fails.
+ * In that scenario the EM has not been created so this
+ * routine doesn't call fc_exch_mgr_free or for that matter
+ * fc_lport_free_stats. Those routines are needed to
+ * destroy a completely allocated and configured
+ * fc_host/scsi_host.
+ */
+static void fcoe_shost_destroy(struct Scsi_Host *shost)
+{
+	struct fc_lport *lport = shost_priv(shost);
+
+	/* Detach from the scsi-ml */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+
+	/* Destroy lport scsi_priv */
+	fc_fcp_destroy(lport);
+
+	/* Release the Scsi_Host */
+	scsi_host_put(shost);
+}
+
 /**
  * fcoe_create() - Create a fcoe interface
  * @netdev  : The net_device object the Ethernet interface to create on
@@ -1941,12 +2019,13 @@ static bool fcoe_match(struct net_device *netdev)
  */
 static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 {
-	int rc = 0;
+	struct Scsi_Host *shost;
 	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
+	struct fcoe_port *port;
+	int rc = 0;
 
 	mutex_lock(&fcoe_config_mutex);
-	rtnl_lock();
 
 	/* look for existing lport */
 	if (fcoe_hostlist_lookup(netdev)) {
@@ -1954,20 +2033,28 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 		goto out_nodev;
 	}
 
-	fcoe = fcoe_interface_create(netdev, fip_mode);
+	/* allocate and add the shost */
+	shost = fcoe_shost_create(netdev, NULL);
+	if (IS_ERR(shost)) {
+		rc = PTR_ERR(shost);
+		goto out_nodev;
+	}
+
+	fcoe = fcoe_interface_create(shost, netdev, fip_mode);
 	if (IS_ERR(fcoe)) {
 		rc = PTR_ERR(fcoe);
-		goto out_nodev;
+		goto out_shost_destroy;
 	}
 
-	lport = fcoe_if_create(fcoe, &netdev->dev, 0);
-	if (IS_ERR(lport)) {
+	lport = shost_priv(shost);
+	port = lport_priv(lport);
+
+	rc = fcoe_if_config(fcoe, port, NULL);
+	if (rc) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
-		rc = -EIO;
-		rtnl_unlock();
 		fcoe_interface_cleanup(fcoe);
-		goto out_nortnl;
+		goto out_shost_destroy;
 	}
 
 	/* Make this the "master" N_Port */
@@ -1982,9 +2069,12 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	if (!fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 
+	mutex_unlock(&fcoe_config_mutex);
+	return rc;
+
+out_shost_destroy:
+	fcoe_shost_destroy(shost);
 out_nodev:
-	rtnl_unlock();
-out_nortnl:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
 }
@@ -2391,12 +2481,14 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
  */
 static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fcoe_port *port = lport_priv(n_port);
-	struct fcoe_interface *fcoe = port->priv;
+	struct Scsi_Host *n_shost = vport_to_shost(vport);
+	struct fc_lport *n_lport = shost_priv(n_shost);
+	struct fcoe_port *n_fcoe_port = lport_priv(n_lport);
+	struct fcoe_interface *fcoe = n_fcoe_port->priv;
 	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *vn_port;
+	struct Scsi_Host *vn_shost;
+	struct fc_lport *vn_lport;
+	struct fcoe_port *vn_fcoe_port;
 	int rc;
 	char buf[32];
 
@@ -2410,23 +2502,40 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
 	}
 
 	mutex_lock(&fcoe_config_mutex);
-	vn_port = fcoe_if_create(fcoe, &vport->dev, 1);
+
+	/* TODO: Should this be called within the fcoe_config_mutex?*/
+	vn_shost = fcoe_shost_create(netdev, vport);
+	if (IS_ERR(vn_shost)) {
+		rc = PTR_ERR(vn_shost);
+		mutex_unlock(&fcoe_config_mutex);
+		goto out;
+	}
+
+	vn_lport = shost_priv(vn_shost);
+	vn_fcoe_port = lport_priv(vn_lport);
+
+	rc = fcoe_if_config(fcoe, vn_fcoe_port, vport);
 	mutex_unlock(&fcoe_config_mutex);
 
-	if (IS_ERR(vn_port)) {
+	if (rc) {
 		printk(KERN_ERR "fcoe: fcoe_vport_create(%s) failed\n",
 		       netdev->name);
-		return -EIO;
+		goto shost_destroy;
 	}
 
 	if (disabled) {
 		fc_vport_set_state(vport, FC_VPORT_DISABLED);
 	} else {
-		vn_port->boot_time = jiffies;
-		fc_fabric_login(vn_port);
-		fc_vport_setlink(vn_port);
+		vn_lport->boot_time = jiffies;
+		fc_fabric_login(vn_lport);
+		fc_vport_setlink(vn_lport);
 	}
 	return 0;
+
+shost_destroy:
+	fcoe_shost_destroy(vn_shost);
+out:
+	return rc;
 }
 
 /**
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index a1c3b54..129293f 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -84,6 +84,9 @@ struct fcoe_interface {
 	struct fc_exch_mgr *oem;
 };
 
+#define fcoe_to_fcport(fcoe)					\
+	(struct fc_port *)(((struct fc_port *)(fcoe)) - 1)
+
 #define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)
 
 /**
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index c74c4b8..3cabc08 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -46,6 +46,8 @@
 
 #include "libfcoe.h"
 
+static struct workqueue_struct *fcf_event_queue;
+
 #define	FCOE_CTLR_MIN_FKA	500		/* min keep alive (mS) */
 #define	FCOE_CTLR_DEF_FKA	FIP_DEF_FKA	/* default keep alive (mS) */
 
@@ -59,6 +61,9 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *, struct sk_buff *);
 static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *);
 static int fcoe_ctlr_vn_lookup(struct fcoe_ctlr *, u32, u8 *);
 
+static void fcoe_ctlr_process_fcf(struct fcoe_ctlr *, struct fcoe_fcf *,
+				  int first);
+
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
 static u8 fcoe_all_enode[ETH_ALEN] = FIP_ALL_ENODE_MACS;
 static u8 fcoe_all_vn2vn[ETH_ALEN] = FIP_ALL_VN2VN_MACS;
@@ -161,6 +166,32 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
 EXPORT_SYMBOL(fcoe_ctlr_init);
 
 /**
+ * fcoe_ctlr_fabric_create() - Callback after a new FC fabric is created
+ * @fip: The FCoE controller
+ * @fcf: The FCF that was just added
+ */
+int fcoe_ctlr_fabric_create(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
+{
+	return 0;
+}
+EXPORT_SYMBOL(fcoe_ctlr_fabric_create);
+
+/**
+ * fcoe_ctlr_fabric_destroy() - Callback after a new FC fabric is created
+ * @fip: The FCoE controller
+ * @fcf: The FCF that was just added
+ */
+int fcoe_ctlr_fabric_destroy(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
+{
+	mutex_lock(&fip->ctlr_mutex);
+	list_del(&fcf->list);
+	mutex_unlock(&fip->ctlr_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(fcoe_ctlr_fabric_destroy);
+
+/**
  * fcoe_ctlr_reset_fcfs() - Reset and free all FCFs for a controller
  * @fip: The FCoE controller whose FCFs are to be reset
  *
@@ -170,11 +201,12 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
+	struct fc_fabric *fabric;
 
 	fip->sel_fcf = NULL;
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
-		list_del(&fcf->list);
-		kfree(fcf);
+		fabric = fcf_to_fabric(fcf);
+		fc_fabric_del(fabric);
 	}
 	fip->fcf_count = 0;
 	fip->sel_time = 0;
@@ -206,6 +238,111 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 }
 EXPORT_SYMBOL(fcoe_ctlr_destroy);
 
+static int fcoe_fcf_match(struct fcoe_fcf *new_fcf, struct fcoe_fcf *old_fcf)
+{
+	if (new_fcf->switch_name == old_fcf->switch_name &&
+	    new_fcf->fabric_name == old_fcf->fabric_name &&
+	    new_fcf->fc_map == old_fcf->fc_map &&
+	    compare_ether_addr(new_fcf->fcf_mac, old_fcf->fcf_mac) == 0)
+		return 1;
+	return 0;
+}
+
+int fcoe_fabric_match(struct fc_fabric *new, struct fc_fabric *old)
+{
+	struct fcoe_fcf *new_fcf = fc_fabric_priv(new);
+	struct fcoe_fcf *old_fcf = fc_fabric_priv(old);
+	return fcoe_fcf_match(new_fcf, old_fcf);
+}
+EXPORT_SYMBOL(fcoe_fabric_match);
+
+/**
+ * fcoe_fcf_work() - Handler for fcf events in the fcf_event_queue
+ * @work: Handle to the remote port being dequeued
+ *
+ * This routine is responsible for freeing the new fcf that is
+ * passed in when processing the ADD event. This is because it's
+ * only a temporary fcf used for matching purposes.
+ *
+ */
+static void fcoe_fcf_work(struct work_struct *work)
+{
+	struct fcoe_fcf *new = container_of(work, struct fcoe_fcf,
+					    event_work);
+	struct fcoe_ctlr *fip = new->fip;
+	struct fc_port *port = ctlr_to_port(fip);
+	struct fcoe_fcf *fcf;
+	struct fc_fabric *temp, *fabric;
+	int first = 0;
+	int found;
+	int size;
+
+	mutex_lock(&fip->ctlr_mutex);
+
+	list_for_each_entry(fcf, &fip->fcfs, list) {
+		found = fcoe_fcf_match(new, fcf);
+		if (found)
+			break;
+	}
+
+	switch (new->event) {
+	case FCF_EV_ADD:
+		if (found) {
+			kfree(new);
+			goto out;
+		}
+
+		size = (sizeof(struct fc_fabric) + sizeof(struct fcoe_fcf));
+		temp = kzalloc(size, GFP_KERNEL);
+		if (unlikely(!temp)) {
+			kfree(new);
+			goto out;
+		}
+
+		LIBFCOE_FIP_DBG(fip, "New FCF fab %16.16llx mac %pM\n",
+				new->fabric_name, new->fcf_mac);
+
+		fcf = fc_fabric_priv(temp);
+		memcpy(fcf, new, sizeof(struct fcoe_fcf));
+
+		fabric = fc_fabric_add(port, temp);
+		if (unlikely(!fabric)) {
+			kfree(temp);
+			kfree(new);
+			goto out;
+		}
+
+		fcf = fc_fabric_priv(fabric);
+		memcpy(fcf, new, sizeof(struct fcoe_fcf));
+
+		INIT_WORK(&fcf->event_work, fcoe_fcf_work);
+		fcf->event = FCF_EV_NONE;
+
+		fip->fcf_count++;
+
+		first = list_empty(&fip->fcfs);
+
+		list_add(&fcf->list, &fip->fcfs);
+
+		fcoe_ctlr_process_fcf(fip, fcf, first);
+		fcf->event = FCF_EV_NONE;
+		kfree(temp);
+		kfree(new);
+		break;
+	case FCF_EV_DEL:
+		if (!found)
+			goto out;
+		fabric = fcf_to_fabric(fcf);
+		fc_fabric_del(fabric);
+		break;
+	default:
+		break;
+	}
+
+out:
+	mutex_unlock(&fip->ctlr_mutex);
+}
+
 /**
  * fcoe_ctlr_announce() - announce new FCF selection
  * @fip: The FCoE controller
@@ -736,10 +873,10 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 		if (time_after_eq(jiffies, deadline)) {
 			if (fip->sel_fcf == fcf)
 				fip->sel_fcf = NULL;
-			list_del(&fcf->list);
 			WARN_ON(!fip->fcf_count);
 			fip->fcf_count--;
-			kfree(fcf);
+			fcf->event = FCF_EV_DEL;
+			queue_work(fcf_event_queue, &fcf->event_work);
 			stats->VLinkFailureCount++;
 		} else {
 			if (time_after(next_timer, deadline))
@@ -891,70 +1028,20 @@ len_err:
 }
 
 /**
- * fcoe_ctlr_recv_adv() - Handle an incoming advertisement
- * @fip: The FCoE controller receiving the advertisement
- * @skb: The received FIP packet
+ * fcoe_ctlr_process_fcf() - Process a new FCF
+ * @fip:   The controller that discovered the new FCF
+ * @fcf:   The newly discovered FCF
+ * @first: Indicates that the FCF is the first FCF found
  */
-static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+static void fcoe_ctlr_process_fcf(struct fcoe_ctlr *fip,
+				  struct fcoe_fcf *fcf,
+				  int first)
 {
-	struct fcoe_fcf *fcf;
-	struct fcoe_fcf new;
-	struct fcoe_fcf *found;
 	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
-	int first = 0;
 	int mtu_valid;
 
-	if (fcoe_ctlr_parse_adv(fip, skb, &new))
-		return;
-
-	mutex_lock(&fip->ctlr_mutex);
-	first = list_empty(&fip->fcfs);
-	found = NULL;
-	list_for_each_entry(fcf, &fip->fcfs, list) {
-		if (fcf->switch_name == new.switch_name &&
-		    fcf->fabric_name == new.fabric_name &&
-		    fcf->fc_map == new.fc_map &&
-		    compare_ether_addr(fcf->fcf_mac, new.fcf_mac) == 0) {
-			found = fcf;
-			break;
-		}
-	}
-	if (!found) {
-		if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT)
-			goto out;
-
-		fcf = kmalloc(sizeof(*fcf), GFP_ATOMIC);
-		if (!fcf)
-			goto out;
-
-		fip->fcf_count++;
-		memcpy(fcf, &new, sizeof(new));
-		list_add(&fcf->list, &fip->fcfs);
-	} else {
-		/*
-		 * Update the FCF's keep-alive descriptor flags.
-		 * Other flag changes from new advertisements are
-		 * ignored after a solicited advertisement is
-		 * received and the FCF is selectable (usable).
-		 */
-		fcf->fd_flags = new.fd_flags;
-		if (!fcoe_ctlr_fcf_usable(fcf))
-			fcf->flags = new.flags;
-
-		if (fcf == fip->sel_fcf && !fcf->fd_flags) {
-			fip->ctlr_ka_time -= fcf->fka_period;
-			fip->ctlr_ka_time += new.fka_period;
-			if (time_before(fip->ctlr_ka_time, fip->timer.expires))
-				mod_timer(&fip->timer, fip->ctlr_ka_time);
-		}
-		fcf->fka_period = new.fka_period;
-		memcpy(fcf->fcf_mac, new.fcf_mac, ETH_ALEN);
-	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
 	fcf->time = jiffies;
-	if (!found)
-		LIBFCOE_FIP_DBG(fip, "New FCF fab %16.16llx mac %pM\n",
-				fcf->fabric_name, fcf->fcf_mac);
 
 	/*
 	 * If this advertisement is not solicited and our max receive size
@@ -992,6 +1079,82 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		    time_before(fip->sel_time, fip->timer.expires))
 			mod_timer(&fip->timer, fip->sel_time);
 	}
+}
+
+/**
+ * fcoe_ctlr_recv_adv() - Handle an incoming advertisement
+ * @fip: The FCoE controller receiving the advertisement
+ * @skb: The received FIP packet
+ */
+static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
+{
+	struct fcoe_fcf *fcf;
+	struct fcoe_fcf *new;
+	int first = 0;
+	int found;
+
+	new = kzalloc(sizeof(*new), GFP_ATOMIC); /* free'd in fcoe_fcf_work */
+	if (!new)
+		return;
+
+	if (fcoe_ctlr_parse_adv(fip, skb, new))
+		return;
+
+	/*
+	 * The fcf_work_queue is used for both temporary
+	 * and real (ones allocated by the FC Transport)
+	 * fcfs. The fcf to ctlr relationship needs to be
+	 * established so we can find the FC Port to add
+	 * the new FC fabric to.
+	 *
+	 * The ctlr pointer will be copied from the
+	 * temporary FCF to the real FCF with a memcpy in
+	 * fcoe_fcf_work().
+	 */
+	INIT_WORK(&new->event_work, fcoe_fcf_work);
+	new->fip = fip;
+
+	mutex_lock(&fip->ctlr_mutex);
+	first = list_empty(&fip->fcfs);
+	list_for_each_entry(fcf, &fip->fcfs, list) {
+		found = fcoe_fcf_match(new, fcf);
+		if (found)
+			break;
+	}
+	if (!found) {
+		if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT)
+			goto out;
+
+		/*
+		 * Need to queue temp fcf, work routine will
+		 * convert temp fcf to real fabric with fcf for priv
+		 */
+		new->event = FCF_EV_ADD;
+		queue_work(fcf_event_queue, &new->event_work);
+		/* fcoe_ctlr_process_fcf will be called from fcoe_fcf_work() */
+	} else {
+		/*
+		 * Update the FCF's keep-alive descriptor flags.
+		 * Other flag changes from new advertisements are
+		 * ignored after a solicited advertisement is
+		 * received and the FCF is selectable (usable).
+		 */
+		fcf->fd_flags = new->fd_flags;
+		if (!fcoe_ctlr_fcf_usable(fcf))
+			fcf->flags = new->flags;
+
+		if (fcf == fip->sel_fcf && !fcf->fd_flags) {
+			fip->ctlr_ka_time -= fcf->fka_period;
+			fip->ctlr_ka_time += new->fka_period;
+			if (time_before(fip->ctlr_ka_time, fip->timer.expires))
+				mod_timer(&fip->timer, fip->ctlr_ka_time);
+		}
+		fcf->fka_period = new->fka_period;
+		memcpy(fcf->fcf_mac, new->fcf_mac, ETH_ALEN);
+
+		fcoe_ctlr_process_fcf(fip, fcf, first);
+	}
+
 out:
 	mutex_unlock(&fip->ctlr_mutex);
 }
@@ -2690,9 +2853,9 @@ unlock:
 
 /**
  * fcoe_libfc_config() - Sets up libfc related properties for local port
- * @lp: The local port to configure libfc for
- * @fip: The FCoE controller in use by the local port
- * @tt: The libfc function template
+ * @lport:    The local port to configure libfc for
+ * @fip:      The FCoE controller in use by the local port
+ * @tt:       The libfc function template
  * @init_fcp: If non-zero, the FCP portion of libfc should be initialized
  *
  * Returns : 0 for success
@@ -2725,3 +2888,22 @@ int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
+
+/**
+ * fcoe_ctlr_setup() - Setup global structures
+ */
+int __init fcoe_ctlr_setup(void)
+{
+	fcf_event_queue = create_singlethread_workqueue("fcoe_fcf_eq");
+	if (!fcf_event_queue)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * fcoe_ctlr_teardown() - Tear down global structures
+ */
+void __exit fcoe_ctlr_teardown(void)
+{
+	destroy_workqueue(fcf_event_queue);
+}
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 41068e8..441e873 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -714,6 +714,12 @@ out_nodev:
  */
 static int __init libfcoe_init(void)
 {
+	int rc;
+
+	rc = fcoe_ctlr_setup();
+	if (rc)
+		return rc;
+
 	fcoe_transport_init();
 
 	return 0;
@@ -726,5 +732,6 @@ module_init(libfcoe_init);
 static void __exit libfcoe_exit(void)
 {
 	fcoe_transport_exit();
+	fcoe_ctlr_teardown();
 }
 module_exit(libfcoe_exit);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e008b16..4008aca 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1631,7 +1631,6 @@ int fc_lport_init(struct fc_lport *lport)
 	       sizeof(fc_host_active_fc4s(lport->host)));
 	fc_host_active_fc4s(lport->host)[2] = 1;
 	fc_host_active_fc4s(lport->host)[7] = 1;
-	fc_host_maxframe_size(lport->host) = lport->mfs;
 	fc_host_supported_speeds(lport->host) = 0;
 	if (lport->link_supported_speeds & FC_PORTSPEED_1GBIT)
 		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_1GBIT;
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 8c1638b..2c03c6c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -86,6 +86,7 @@ enum fip_state {
  * struct fcoe_ctlr - FCoE Controller and FIP state
  * @state:	   internal FIP state for network link and FIP or non-FIP mode.
  * @mode:	   LLD-selected mode.
+ * @port:          The FC port that this controller is associated with
  * @lp:		   &fc_lport: libfc local port.
  * @sel_fcf:	   currently selected FCF, or NULL.
  * @fcfs:	   list of discovered FCFs.
@@ -123,6 +124,7 @@ enum fip_state {
 struct fcoe_ctlr {
 	enum fip_state state;
 	enum fip_state mode;
+	struct fc_port *port;
 	struct fc_lport *lp;
 	struct fcoe_fcf *sel_fcf;
 	struct list_head fcfs;
@@ -157,9 +159,27 @@ struct fcoe_ctlr {
 	spinlock_t ctlr_lock;
 };
 
+#define ctlr_to_port(x)				\
+	((x)->port)
+
+/**
+ * enum fcoe_fcf_event - FCF events
+ * @FCF_EV_NONE: No event
+ * @FCF_EV_ADD: Add the FCF to the transport
+ * @FCF_EV_DEL: Delete the FCF from the transport
+ */
+enum fcoe_fcf_event {
+	FCF_EV_NONE = 0,
+	FCF_EV_ADD,
+	FCF_EV_DEL
+};
+
 /**
  * struct fcoe_fcf - Fibre-Channel Forwarder
  * @list:	 list linkage
+ * @event_work:  Work for FC Transport actions queue
+ * @event:       The event to be processed
+ * @fip:         The controller that the FCF was discovered on
  * @time:	 system time (jiffies) when an advertisement was last received
  * @switch_name: WWN of switch from advertisement
  * @fabric_name: WWN of fabric from advertisement
@@ -180,6 +200,9 @@ struct fcoe_ctlr {
  */
 struct fcoe_fcf {
 	struct list_head list;
+	struct work_struct event_work;
+	enum fcoe_fcf_event event;
+	struct fcoe_ctlr *fip;
 	unsigned long time;
 
 	u64 switch_name;
@@ -195,6 +218,9 @@ struct fcoe_fcf {
 	u8 fd_flags:1;
 };
 
+#define fcf_to_fabric(x)					\
+	(struct fc_fabric *)(((struct fc_fabric *)(x)) - 1)
+
 /**
  * struct fcoe_rport - VN2VN remote port
  * @time:	time of create or last beacon packet received from node
@@ -229,6 +255,7 @@ int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
 int fcoe_start_io(struct sk_buff *skb);
+int fcoe_fabric_match(struct fc_fabric *new, struct fc_fabric *old);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.
@@ -323,6 +350,10 @@ void fcoe_queue_timer(ulong lport);
 int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen,
 			   struct fcoe_percpu_s *fps);
 
+/* FCF create/destroy helpers (list_add/del) */
+int fcoe_ctlr_fabric_create(struct fcoe_ctlr *, struct fcoe_fcf *);
+int fcoe_ctlr_fabric_destroy(struct fcoe_ctlr *, struct fcoe_fcf *);
+
 /**
  * struct netdev_list
  * A mapping from netdevice to fcoe_transport
@@ -337,4 +368,7 @@ struct fcoe_netdev_mapping {
 int fcoe_transport_attach(struct fcoe_transport *ft);
 int fcoe_transport_detach(struct fcoe_transport *ft);
 
+int fcoe_ctlr_setup(void);
+void fcoe_ctlr_teardown(void);
+
 #endif /* _LIBFCOE_H */

