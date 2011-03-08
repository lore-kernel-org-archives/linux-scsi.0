From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 3/8] libfc, libfcoe, fcoe: Make use of FC subsystem
Date: Mon, 07 Mar 2011 18:31:59 -0800
Message-ID: <20110308023159.6205.29622.stgit@localhost6.localdomain6>
References: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41813 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab1CHCcc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 21:32:32 -0500
In-Reply-To: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

This patch makes libfc, libfcoe and fcoe use the FC subsystem instead of
directly interacting with existing FC Transport. The FC devices are allocated,
added to sysfs, deleted from sysfs and freed as follows:

Allocate/Add
* fcport allocated/added when an fcoe interface is created
* fcvport allocated when an fcoe interface is created
* fcfabric allocated/added when a FCF is discovered
* fcvport added when FLOGI ACC is received

Delete/Free
* fcvport deleted when LOGO sent
* fcfabric deleted/freed when FCFs are removed
* fcvport freed when an fcoe interface is created
* fcport deleted/freed when an fcoe interface is created

The allocation scheme for libfc, libfcoe and fcoe's primary data
structures is illustrated here:
http://www.open-fcoe.org/open-fcoe/wiki/fc-sysfs-diagrams

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/Kconfig          |    1 
 drivers/scsi/fcoe/fcoe.c      |  643 +++++++++++++++++++++--------------------
 drivers/scsi/fcoe/fcoe.h      |    6 
 drivers/scsi/fcoe/fcoe_ctlr.c |  299 ++++++++++++-------
 drivers/scsi/fcoe/libfcoe.h   |    4 
 drivers/scsi/libfc/fc_disc.c  |    4 
 drivers/scsi/libfc/fc_exch.c  |   11 -
 drivers/scsi/libfc/fc_fcp.c   |  120 +++-----
 drivers/scsi/libfc/fc_libfc.h |   40 +--
 drivers/scsi/libfc/fc_lport.c |  206 +++++++------
 drivers/scsi/libfc/fc_npiv.c  |   87 +++---
 drivers/scsi/libfc/fc_rport.c |   19 +
 include/scsi/fc_encode.h      |   40 ++-
 include/scsi/libfc.h          |   95 ++++--
 include/scsi/libfcoe.h        |   18 +
 15 files changed, 878 insertions(+), 715 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 47450a6..6b91d11 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -692,6 +692,7 @@ config LIBFCOE
 config FCOE
 	tristate "FCoE module"
 	depends on PCI
+	select SCSI_FCP_ATTRS
 	select LIBFCOE
 	---help---
 	  Fibre Channel over Ethernet module
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 488b7d9..baed0f4 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -32,16 +32,13 @@
 #include <linux/sysfs.h>
 #include <linux/ctype.h>
 #include <linux/workqueue.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsicam.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
 #include <net/rtnetlink.h>
 
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fip.h>
 
 #include <scsi/libfc.h>
+#include <fc/fc.h>
 #include <scsi/fc_frame.h>
 #include <scsi/libfcoe.h>
 
@@ -70,7 +67,7 @@ LIST_HEAD(fcoe_hostlist);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
 /* Function Prototypes */
-static int fcoe_reset(struct Scsi_Host *);
+static int fcoe_reset(struct fc_vport *);
 static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
 static int fcoe_rcv(struct sk_buff *, struct net_device *,
 		    struct packet_type *, struct net_device *);
@@ -118,6 +115,13 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 static void fcoe_recv_frame(struct sk_buff *skb);
 
 static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
+static void fcoe_set_symbolic_name(struct fc_lport *);
+/*
+static void fcoe_set_node_name(struct fc_lport *);
+static void fcoe_set_port_name(struct fc_lport *);
+static void fcoe_get_vport_ids(struct fc_lport *lport,
+			       struct fc_vport_identifiers *ids);
+*/
 
 /* notification function for packets from net device */
 static struct notifier_block fcoe_notifier = {
@@ -129,15 +133,45 @@ static struct notifier_block fcoe_cpu_notifier = {
 	.notifier_call = fcoe_cpu_callback,
 };
 
-static struct scsi_transport_template *fcoe_nport_scsi_transport;
-static struct scsi_transport_template *fcoe_vport_scsi_transport;
-
-static int fcoe_vport_destroy(struct fc_vport *);
-static int fcoe_vport_create(struct fc_vport *, bool disabled);
+static int fcoe_vport_destroy(struct fc_vport *nport, struct fc_vport *vport);
+static int fcoe_vport_create(struct fc_vport *nport, struct fc_vport *vport,
+			     bool disabled);
 static int fcoe_vport_disable(struct fc_vport *, bool disable);
 static void fcoe_set_vport_symbolic_name(struct fc_vport *);
 static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
 
+static void fcoe_fcpinit_add(struct fcp_init *fcpinit);
+static void fcoe_fcpinit_del(struct fcp_init *fcpinit);
+
+static struct fcp_template fcoe_fcp_template = {
+	.fcpinit_priv_size = sizeof(struct fc_fcp_internal),
+	.fcp_fcpinit_add = fcoe_fcpinit_add,
+	.fcp_fcpinit_del = fcoe_fcpinit_del,
+
+	.shost_template = {
+		.module = THIS_MODULE,
+		.name = "FCoE Driver",
+		.proc_name = FCOE_NAME,
+		.queuecommand = fc_queuecommand,
+		.eh_abort_handler = fc_eh_abort,
+		.eh_device_reset_handler = fc_eh_device_reset,
+		.eh_host_reset_handler = fc_eh_host_reset,
+		.slave_alloc = fc_slave_alloc,
+		.change_queue_depth = fc_change_queue_depth,
+		.change_queue_type = fc_change_queue_type,
+		.this_id = -1,
+		.cmd_per_lun = 3,
+		.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
+		.use_clustering = ENABLE_CLUSTERING,
+		.sg_tablesize = SG_ALL,
+		.max_sectors = 0xffff,
+	},
+
+	.show_fcpinit_port_state = 1,
+	.get_fcpinit_stats = fc_get_fcpinit_stats,
+	.bsg_request = fc_lport_bsg_request,
+};
+
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 	.ddp_setup = fcoe_ddp_setup,
@@ -147,99 +181,112 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.lport_set_port_id = fcoe_set_port_id,
 };
 
-struct fc_function_template fcoe_nport_fc_functions = {
-	.show_host_node_name = 1,
-	.show_host_port_name = 1,
-	.show_host_supported_classes = 1,
-	.show_host_supported_fc4s = 1,
-	.show_host_active_fc4s = 1,
-	.show_host_maxframe_size = 1,
-
-	.show_host_port_id = 1,
-	.show_host_supported_speeds = 1,
-	.get_host_speed = fc_get_host_speed,
-	.show_host_speed = 1,
-	.show_host_port_type = 1,
-	.get_host_port_state = fc_get_host_port_state,
-	.show_host_port_state = 1,
-	.show_host_symbolic_name = 1,
-
-	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
-	.show_rport_maxframe_size = 1,
-	.show_rport_supported_classes = 1,
-
-	.show_host_fabric_name = 1,
-	.show_starget_node_name = 1,
-	.show_starget_port_name = 1,
-	.show_starget_port_id = 1,
-	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
-	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
-
-	.terminate_rport_io = fc_rport_terminate_io,
-
-	.vport_create = fcoe_vport_create,
-	.vport_delete = fcoe_vport_destroy,
-	.vport_disable = fcoe_vport_disable,
-	.set_vport_symbolic_name = fcoe_set_vport_symbolic_name,
-
-	.bsg_request = fc_lport_bsg_request,
+struct fc_port_function_template fcoe_fcport_fcn_tmpl = {
+	.show_fcport_system_hostname = 1,
+	.show_fcport_fab_dev_loss_tmo = 1,
+	.show_fcport_maxframe_size = 1,
+	.show_fcport_supported_speeds = 1,
+	.show_fcport_supported_classes = 1,
+	.show_fcport_speed = 1,
+	.show_fcport_supported_fc4s = 1,
+	.show_fcport_active_fc4s = 1,
+	.show_fcport_serial_number = 1,
+
+	.dd_fcport_size = sizeof(struct fcoe_interface),
+
+	.fcvport_f = {
+		.vport_create = fcoe_vport_create,
+		.vport_delete = fcoe_vport_destroy,
+		.vport_disable = fcoe_vport_disable,
+
+		.show_fcvport_port_id = 1,
+		.show_fcvport_symbolic_name = 1,
+		.show_fcvport_node_name = 1,
+		.show_fcvport_port_name = 1,
+		.show_fcvport_port_type = 1,
+
+		.issue_fcvport_lip = fcoe_reset,
+		.set_fcvport_symbolic_name = fcoe_set_vport_symbolic_name,
+		.get_fcvport_port_state = fc_get_fcvport_port_state,
+		.dd_fcvport_size = (sizeof(struct fc_lport) +
+				    sizeof(struct fcoe_port)),
+
+		.fcrport_f = {
+			.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+			.show_rport_maxframe_size = 1,
+			.show_rport_supported_classes = 1,
+			.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
+			.show_rport_dev_loss_tmo = 1,
+			.terminate_rport_io = fc_rport_terminate_io,
+		},
+	},
 };
 
-struct fc_function_template fcoe_vport_fc_functions = {
-	.show_host_node_name = 1,
-	.show_host_port_name = 1,
-	.show_host_supported_classes = 1,
-	.show_host_supported_fc4s = 1,
-	.show_host_active_fc4s = 1,
-	.show_host_maxframe_size = 1,
-
-	.show_host_port_id = 1,
-	.show_host_supported_speeds = 1,
-	.get_host_speed = fc_get_host_speed,
-	.show_host_speed = 1,
-	.show_host_port_type = 1,
-	.get_host_port_state = fc_get_host_port_state,
-	.show_host_port_state = 1,
-	.show_host_symbolic_name = 1,
-
-	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
-	.show_rport_maxframe_size = 1,
-	.show_rport_supported_classes = 1,
-
-	.show_host_fabric_name = 1,
-	.show_starget_node_name = 1,
-	.show_starget_port_name = 1,
-	.show_starget_port_id = 1,
-	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
-	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
-
-	.terminate_rport_io = fc_rport_terminate_io,
+struct fc_fabric_function_template fcoe_fcfabric_fcn_tmpl = {
+	.fabric_match = fcoe_fcf_match,
 
-	.bsg_request = fc_lport_bsg_request,
+	.show_fcfabric_fabric_name = 1,
+	.show_fcfabric_dev_loss_tmo = 1,
+	.dd_fcfabric_size = sizeof(struct fcoe_fcf),
 };
 
-static struct scsi_host_template fcoe_shost_template = {
-	.module = THIS_MODULE,
-	.name = "FCoE Driver",
-	.proc_name = FCOE_NAME,
-	.queuecommand = fc_queuecommand,
-	.eh_abort_handler = fc_eh_abort,
-	.eh_device_reset_handler = fc_eh_device_reset,
-	.eh_host_reset_handler = fc_eh_host_reset,
-	.slave_alloc = fc_slave_alloc,
-	.change_queue_depth = fc_change_queue_depth,
-	.change_queue_type = fc_change_queue_type,
-	.this_id = -1,
-	.cmd_per_lun = 3,
-	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
-	.use_clustering = ENABLE_CLUSTERING,
-	.sg_tablesize = SG_ALL,
-	.max_sectors = 0xffff,
-};
+static void _fcoe_get_vport_ids(struct fcoe_interface *fcoe,
+				struct fc_vport_identifiers *ids)
+{
+	ids->node_name = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+	ids->port_name = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, 0);
+	ids->roles = FC_PORT_ROLE_FCP_INITIATOR;
+	ids->disable = 0;
+	ids->vport_type = FC_PORTTYPE_NPORT;
+	snprintf(ids->symbolic_name, FC_SYMBOLIC_NAME_SIZE,
+		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
+		 fcoe->netdev->name);
+}
+
+/*
+static void fcoe_get_vport_ids(struct fc_lport *lport,
+			       struct fc_vport_identifiers *ids)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+	_fcoe_get_vport_ids(fcoe, ids);
+
+	 * _fcoe_get_vport_ids sets the vport_type to
+	 * FC_PORTTYPE_NPORT, but we need to change that
+	 * for VN_Ports.
+
+	ids->vport_type = FC_PORTTYPE_NPIV;
+}
+*/
+
+static void fcoe_set_symbolic_name(struct fc_lport *lport)
+{
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
+	snprintf(fc_vport_symbolic_name(fcvport),
+		 FC_SYMBOLIC_NAME_SIZE, "%s v%s over %s",
+		 FCOE_NAME, FCOE_VERSION,
+		 fcoe_netdev(lport)->name);
+}
+
+/*
+static void fcoe_set_node_name(struct fc_lport *lport)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+
+	fc_vport_node_name(lport_to_fcvport(lport)) =
+		fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+}
+
+static void fcoe_set_port_name(struct fc_lport *lport)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+
+	fc_vport_port_name(lport_to_fcvport(lport)) =
+		fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, 0);
+}
+*/
 
 /**
  * fcoe_interface_setup() - Setup a FCoE interface
@@ -260,6 +307,9 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 
 	fcoe->netdev = netdev;
 
+	/* Initial fc port configuration */
+	fc_lport_port_config(fcoe_to_fcport(fcoe));
+
 	/* Let LLD initialize for FCoE */
 	ops = netdev->netdev_ops;
 	if (ops->ndo_fcoe_enable) {
@@ -337,6 +387,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 						    enum fip_state fip_mode)
 {
+	struct fc_port *fcport;
 	struct fcoe_interface *fcoe;
 	int err;
 
@@ -347,12 +398,15 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		goto out;
 	}
 
-	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
-	if (!fcoe) {
-		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
+	fcport = fc_port_add((struct device *)&netdev->dev.parent,
+			     &fcoe_fcport_fcn_tmpl, &fcoe_fcp_template);
+	if (!fcport) {
+		printk(KERN_ERR "Failed to add a fcport\n");
 		fcoe = ERR_PTR(-ENOMEM);
-		goto out_nomod;
-	}
+		goto out;
+ 	}
+
+	fcoe = fc_port_priv(fcport);
 
 	dev_hold(netdev);
 	kref_init(&fcoe->kref);
@@ -361,23 +415,21 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	 * Initialize FIP.
 	 */
 	fcoe_ctlr_init(&fcoe->ctlr, fip_mode);
+	fcoe->ctlr.fcfabric_f = &fcoe_fcfabric_fcn_tmpl;
 	fcoe->ctlr.send = fcoe_fip_send;
 	fcoe->ctlr.update_mac = fcoe_update_src_mac;
 	fcoe->ctlr.get_src_addr = fcoe_get_src_mac;
 
 	err = fcoe_interface_setup(fcoe, netdev);
-	if (err) {
-		fcoe_ctlr_destroy(&fcoe->ctlr);
-		kfree(fcoe);
-		dev_put(netdev);
-		fcoe = ERR_PTR(err);
-		goto out_nomod;
-	}
+	if (err)
+		goto out_free;
 
-	goto out;
+	return fcoe;
 
-out_nomod:
-	module_put(THIS_MODULE);
+out_free:
+	fcoe_ctlr_destroy(&fcoe->ctlr);
+	fc_port_del(fcport);
+	dev_put(netdev);
 out:
 	return fcoe;
 }
@@ -438,9 +490,8 @@ static void fcoe_interface_release(struct kref *kref)
 	netdev = fcoe->netdev;
 	/* tear-down the FCoE controller */
 	fcoe_ctlr_destroy(&fcoe->ctlr);
-	kfree(fcoe);
+	fc_port_del(fcoe_to_fcport(fcoe));
 	dev_put(netdev);
-	module_put(THIS_MODULE);
 }
 
 /**
@@ -634,9 +685,11 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	u32 mfs;
 	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
+	struct fc_vport *fcvport;
 	struct fcoe_port *port;
 
 	/* Setup lport private data to point to fcoe softc */
+	fcvport = lport_to_fcvport(lport);
 	port = lport_priv(lport);
 	fcoe = port->priv;
 
@@ -661,9 +714,14 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
 
-	fcoe_link_speed_update(lport);
+	/*
+	 * TODO: Is the NPIV port's speed, wwnn and wwpn getting set?
+	 */
+
+	if (fc_vport_is_nport(fcvport)) {
+
+		fcoe_link_speed_update(lport);
 
-	if (!lport->vport) {
 		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
 			wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
 		fc_set_wwnn(lport, wwnn);
@@ -676,46 +734,27 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	return 0;
 }
 
-/**
- * fcoe_shost_config() - Set up the SCSI host associated with a local port
- * @lport: The local port
- * @dev:   The device associated with the SCSI host
- *
- * Must be called after fcoe_lport_config() and fcoe_netdev_config()
- *
- * Returns: 0 for success
- */
-static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
+static void fcoe_fcpinit_add(struct fcp_init *fcpinit)
 {
-	int rc = 0;
-
-	/* lport scsi host config */
-	lport->host->max_lun = FCOE_MAX_LUN;
-	lport->host->max_id = FCOE_MAX_FCP_TARGET;
-	lport->host->max_channel = 0;
-	lport->host->max_cmd_len = FCOE_MAX_CMD_LEN;
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
 
-	if (lport->vport)
-		lport->host->transportt = fcoe_vport_scsi_transport;
-	else
-		lport->host->transportt = fcoe_nport_scsi_transport;
-
-	/* add the new host to the SCSI-ml */
-	rc = scsi_add_host(lport->host, dev);
-	if (rc) {
-		FCOE_NETDEV_DBG(fcoe_netdev(lport), "fcoe_shost_config: "
-				"error on scsi_add_host\n");
-		return rc;
-	}
-
-	if (!lport->vport)
-		fc_host_max_npiv_vports(lport->host) = USHRT_MAX;
+	/*
+	 * Must be done after fcoe_libfc_config because that is where
+	 * the libfc function template is initialized.
+	 */
+	fc_fcp_init(fcpinit);
 
-	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
-		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
-		 fcoe_netdev(lport)->name);
+	/* lport scsi host config */
+	si->host->max_lun = FCOE_MAX_LUN;
+	si->host->max_id = FCOE_MAX_FCP_TARGET;
+	si->host->max_channel = 0;
+}
 
-	return 0;
+static void fcoe_fcpinit_del(struct fcp_init *fcpinit)
+{
+	struct fc_vport *fcvport = fcpinit_to_fcvport(fcpinit);
+	struct fc_lport *lport = fc_vport_priv(fcvport);
+	fc_fcp_destroy(lport);
 }
 
 /**
@@ -831,6 +870,7 @@ skip_oem:
  */
 static void fcoe_if_destroy(struct fc_lport *lport)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fcoe_port *port = lport_priv(lport);
 	struct fcoe_interface *fcoe = port->priv;
 	struct net_device *netdev = fcoe->netdev;
@@ -859,21 +899,18 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
 
-	/* Detach from the scsi-ml */
-	fc_remove_host(lport->host);
-	scsi_remove_host(lport->host);
-
-	/* Destroy lport scsi_priv */
-	fc_fcp_destroy(lport);
-
 	/* There are no more rports or I/O, free the EM */
 	fc_exch_mgr_free(lport);
 
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
-	/* Release the Scsi_Host */
-	scsi_host_put(lport->host);
+	/*
+	 * Release the last reference. This will free the NPIV
+	 * vport/lport/fcoe_port, but the N_Port vport/lport/fcoe_port
+	 * will not be free'd until fc_vport_free is called
+	 */
+	put_device(&fcvport->dev);
 }
 
 /**
@@ -924,33 +961,25 @@ static int fcoe_ddp_done(struct fc_lport *lport, u16 xid)
  *
  * Returns: The allocated fc_lport or an error pointer
  */
-static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
-				       struct device *parent, int npiv)
+static int fcoe_if_create(struct fc_lport *lport, struct fcoe_interface *fcoe,
+			  int npiv)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *lport, *n_port;
-	struct fcoe_port *port;
-	struct Scsi_Host *shost;
+	struct fcoe_port *port = lport_priv(lport);
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
+	/*
+	 * Since the rtnl lock needs to be held for fcoe_if_destroy,
+	 * that work needs to be done in a different thread from the
+	 * vport_delete callback. To enusure that the NPIV vport's
+	 * fcoe_port instance (LLD priv) isn't free'd before
+	 * fcoe_if_destroy we need to get another reference.
+	 */
+	get_device(&fcvport->dev);
 
-	if (!lport) {
-		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-	port = lport_priv(lport);
 	port->lport = lport;
 	port->priv = fcoe;
 	port->max_queue_depth = FCOE_MAX_QUEUE_DEPTH;
@@ -962,15 +991,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure lport for the "
 				"interface\n");
-		goto out_host_put;
-	}
-
-	if (npiv) {
-		FCOE_NETDEV_DBG(netdev, "Setting vport names, "
-				"%16.16llx %16.16llx\n",
-				vport->node_name, vport->port_name);
-		fc_set_wwnn(lport, vport->node_name);
-		fc_set_wwpn(lport, vport->port_name);
+		goto out;
 	}
 
 	/* configure lport network properties */
@@ -981,21 +1002,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
-	/* configure lport scsi host properties */
-	rc = fcoe_shost_config(lport, parent);
-	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
-				"interface\n");
-		goto out_lp_destroy;
-	}
-
-	/* Initialize the library */
-	rc = fcoe_libfc_config(lport, &fcoe->ctlr, &fcoe_libfc_fcn_templ, 1);
-	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
-				"interface\n");
-		goto out_lp_destroy;
-	}
 
 	/*
 	 * fcoe_em_alloc() and fcoe_hostlist_add() both
@@ -1006,14 +1012,18 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	 * This is currently handled through the fcoe_config_mutex
 	 * begin held.
 	 */
+
+	/* lport exch manager allocation */
 	if (!npiv)
-		/* lport exch manager allocation */
 		rc = fcoe_em_config(lport);
-	else {
-		shost = vport_to_shost(vport);
-		n_port = shost_priv(shost);
-		rc = fc_exch_mgr_list_clone(n_port, lport);
-	}
+
+	/*
+	 * TODO: There was some EM cloning code here that got
+	 * a bit tricky over rebases. If the EM isn't being
+	 * re-used by NPIV ports that's probably the reason.
+	 *
+	 * Need to double check this.
+	 */
 
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure the EM\n");
@@ -1021,53 +1031,13 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 
 	fcoe_interface_get(fcoe);
-	return lport;
+
+	return rc;
 
 out_lp_destroy:
 	fc_exch_mgr_free(lport);
-out_host_put:
-	scsi_host_put(lport->host);
 out:
-	return ERR_PTR(rc);
-}
-
-/**
- * fcoe_if_init() - Initialization routine for fcoe.ko
- *
- * Attaches the SW FCoE transport to the FC transport
- *
- * Returns: 0 on success
- */
-static int __init fcoe_if_init(void)
-{
-	/* attach to scsi transport */
-	fcoe_nport_scsi_transport =
-		fc_attach_transport(&fcoe_nport_fc_functions);
-	fcoe_vport_scsi_transport =
-		fc_attach_transport(&fcoe_vport_fc_functions);
-
-	if (!fcoe_nport_scsi_transport) {
-		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-/**
- * fcoe_if_exit() - Tear down fcoe.ko
- *
- * Detaches the SW FCoE transport from the FC transport
- *
- * Returns: 0 on success
- */
-int __exit fcoe_if_exit(void)
-{
-	fc_release_transport(fcoe_nport_scsi_transport);
-	fc_release_transport(fcoe_vport_scsi_transport);
-	fcoe_nport_scsi_transport = NULL;
-	fcoe_vport_scsi_transport = NULL;
-	return 0;
+	return rc;
 }
 
 /**
@@ -1861,6 +1831,7 @@ out_nodev:
  */
 static int fcoe_destroy(struct net_device *netdev)
 {
+	struct fc_lport *lport;
 	struct fcoe_interface *fcoe;
 	int rc = 0;
 
@@ -1885,8 +1856,15 @@ static int fcoe_destroy(struct net_device *netdev)
 	}
 	fcoe_interface_cleanup(fcoe);
 	list_del(&fcoe->list);
+
+	lport = fcoe->ctlr.lp;
+
 	/* RTNL mutex is dropped by fcoe_if_destroy */
-	fcoe_if_destroy(fcoe->ctlr.lp);
+	fcoe_if_destroy(lport);
+
+	fc_vport_free(lport_to_fcvport(lport));
+
+	module_put(THIS_MODULE);
 out_nodev:
 	mutex_unlock(&fcoe_config_mutex);
 	return rc;
@@ -1934,7 +1912,9 @@ static bool fcoe_match(struct net_device *netdev)
 static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 {
 	int rc;
+	struct fc_vport_identifiers ids;
 	struct fcoe_interface *fcoe;
+	struct fc_vport *fcvport;
 	struct fc_lport *lport;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -1958,24 +1938,42 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 		goto out_nodev;
 	}
 
+	/* fcport allocate/added in fcoe_interface_create */
 	fcoe = fcoe_interface_create(netdev, fip_mode);
 	if (IS_ERR(fcoe)) {
 		rc = PTR_ERR(fcoe);
 		goto out_nodev;
 	}
 
-	lport = fcoe_if_create(fcoe, &netdev->dev, 0);
-	if (IS_ERR(lport)) {
-		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
-		       netdev->name);
-		rc = -EIO;
-		fcoe_interface_cleanup(fcoe);
+	_fcoe_get_vport_ids(fcoe, &ids);
+	fcvport = fc_vport_alloc(NULL, &ids, &fcoe_fcport_fcn_tmpl.fcvport_f,
+				 0, FC4_FCP_INITIATOR);
+	if (!fcvport) {
+		rc = -ENOMEM;
 		goto out_free;
 	}
 
+	fc_vport_port_type(fcvport) = FC_PORTTYPE_NPORT;
+
+	lport = fc_vport_priv(fcvport);
+	lport->fcport = fcoe_to_fcport(fcoe);
+
+	/* Initialize the library */
+	fcoe_libfc_config(lport, &fcoe->ctlr, &fcoe_libfc_fcn_templ);
+	lport->fcport->maxframe_size = lport->mfs;
+
 	/* Make this the "master" N_Port */
 	fcoe->ctlr.lp = lport;
 
+	rc = fcoe_if_create(lport, fcoe, 0);
+	if (rc) {
+		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
+		       netdev->name);
+		rc = -EIO;
+		fcoe_interface_cleanup(fcoe);
+		goto out_del;
+	}
+
 	/* add to lports list */
 	fcoe_hostlist_add(lport);
 
@@ -1994,6 +1992,8 @@ static int fcoe_create(struct net_device *netdev, enum fip_state fip_mode)
 	mutex_unlock(&fcoe_config_mutex);
 
 	return 0;
+out_del:
+	fc_vport_del(fcvport);
 out_free:
 	fcoe_interface_put(fcoe);
 out_nodev:
@@ -2014,19 +2014,21 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 	struct net_device *netdev = fcoe_netdev(lport);
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 
+	u32 link_supported_speeds = FC_PORTSPEED_UNKNOWN;
+
 	if (!dev_ethtool_get_settings(netdev, &ecmd)) {
-		lport->link_supported_speeds &=
-			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
 		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
 				      SUPPORTED_1000baseT_Full))
-			lport->link_supported_speeds |= FC_PORTSPEED_1GBIT;
+			link_supported_speeds |= FC_PORTSPEED_1GBIT;
 		if (ecmd.supported & SUPPORTED_10000baseT_Full)
-			lport->link_supported_speeds |=
-				FC_PORTSPEED_10GBIT;
+			link_supported_speeds |= FC_PORTSPEED_10GBIT;
+
+		fc_port_supported_speeds(lport->fcport) = link_supported_speeds;
+
 		if (ecmd.speed == SPEED_1000)
-			lport->link_speed = FC_PORTSPEED_1GBIT;
+			fc_port_speed(lport->fcport) = FC_PORTSPEED_1GBIT;
 		if (ecmd.speed == SPEED_10000)
-			lport->link_speed = FC_PORTSPEED_10GBIT;
+			fc_port_speed(lport->fcport) = FC_PORTSPEED_10GBIT;
 
 		return 0;
 	}
@@ -2111,16 +2113,10 @@ void fcoe_percpu_clean(struct fc_lport *lport)
  *
  * Returns: Always 0 (return value required by FC transport template)
  */
-int fcoe_reset(struct Scsi_Host *shost)
+int fcoe_reset(struct fc_vport *fcvport)
 {
-	struct fc_lport *lport = shost_priv(shost);
-	struct fcoe_port *port = lport_priv(lport);
-	struct fcoe_interface *fcoe = port->priv;
-
-	fcoe_ctlr_link_down(&fcoe->ctlr);
-	fcoe_clean_pending_queue(fcoe->ctlr.lp);
-	if (!fcoe_link_ok(fcoe->ctlr.lp))
-		fcoe_ctlr_link_up(&fcoe->ctlr);
+	struct fc_lport *lport = fc_vport_priv(fcvport);
+	fc_lport_reset(lport);
 	return 0;
 }
 
@@ -2237,10 +2233,6 @@ static int __init fcoe_init(void)
 	/* Setup link change notification */
 	fcoe_dev_setup();
 
-	rc = fcoe_if_init();
-	if (rc)
-		goto out_free;
-
 	mutex_unlock(&fcoe_config_mutex);
 	return 0;
 
@@ -2292,13 +2284,6 @@ static void __exit fcoe_exit(void)
 	 */
 	destroy_workqueue(fcoe_wq);
 
-	/*
-	 * Detaching from the scsi transport must happen after all
-	 * destroys are done on the fcoe_wq. destroy_workqueue will
-	 * enusre the fcoe_wq is flushed.
-	 */
-	fcoe_if_exit();
-
 	/* detach from fcoe transport */
 	fcoe_transport_detach(&fcoe_sw_transport);
 }
@@ -2398,34 +2383,57 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
  * @vport: fc_vport object to create a new fc_host for
  * @disabled: start the new fc_host in a disabled state by default?
  *
+ * Only called on NPIV ports, never the N_Port.
+ *
  * Returns: 0 for success
  */
-static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
+static int fcoe_vport_create(struct fc_vport *fcnport,
+			     struct fc_vport *fcvport,
+			     bool disabled)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fcoe_port *port = lport_priv(n_port);
-	struct fcoe_interface *fcoe = port->priv;
-	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *vn_port;
+	struct fc_lport *lport;
+	struct fcoe_port *port;
+	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
+	struct fc_lport *vn_lport;
+	int error = 0;
+
+	lport = fc_vport_priv(fcnport);
+	port = lport_priv(lport);
+	fcoe = port->priv;
+	netdev = fcoe->netdev;
+
+	vn_lport = fc_vport_priv(fcvport);
+	if (!vn_lport) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
+		return -ENOMEM;
+	}
+
+	vn_lport->fcfabric = lport->fcfabric;
+
+	/* Initialize the library */
+	fcoe_libfc_config(vn_lport, &fcoe->ctlr, &fcoe_libfc_fcn_templ);
 
 	mutex_lock(&fcoe_config_mutex);
-	vn_port = fcoe_if_create(fcoe, &vport->dev, 1);
+	error = fcoe_if_create(vn_lport, fcoe, 1);
 	mutex_unlock(&fcoe_config_mutex);
+	if (error)
+		return -EIO;
 
-	if (IS_ERR(vn_port)) {
-		printk(KERN_ERR "fcoe: fcoe_vport_create(%s) failed\n",
-		       netdev->name);
+	error = libfc_vport_config(lport, vn_lport, fcvport);
+	if (error)
 		return -EIO;
-	}
+
+	fcoe_set_symbolic_name(vn_lport);
 
 	if (disabled) {
-		fc_vport_set_state(vport, FC_VPORT_DISABLED);
+		fc_vport_set_state(fcvport, FC_VPORT_DISABLED);
 	} else {
-		vn_port->boot_time = jiffies;
-		fc_fabric_login(vn_port);
-		fc_vport_setlink(vn_port);
+		vn_lport->boot_time = jiffies;
+		fc_fabric_login(vn_lport);
+		fc_vport_setlink(vn_lport);
 	}
+
 	return 0;
 }
 
@@ -2435,16 +2443,12 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
  *
  * Returns: 0 for success
  */
-static int fcoe_vport_destroy(struct fc_vport *vport)
+static int fcoe_vport_destroy(struct fc_vport *nport,
+			      struct fc_vport *vport)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fc_lport *vn_port = vport->dd_data;
+	struct fc_lport *vn_port = fc_vport_priv(vport);
 	struct fcoe_port *port = lport_priv(vn_port);
 
-	mutex_lock(&n_port->lp_mutex);
-	list_del(&vn_port->list);
-	mutex_unlock(&n_port->lp_mutex);
 	queue_work(fcoe_wq, &port->destroy_work);
 	return 0;
 }
@@ -2456,7 +2460,7 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
  */
 static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
 {
-	struct fc_lport *lport = vport->dd_data;
+	struct fc_lport *lport = fc_vport_priv(vport);
 
 	if (disable) {
 		fc_vport_set_state(vport, FC_VPORT_DISABLED);
@@ -2480,18 +2484,19 @@ static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
  */
 static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
 {
-	struct fc_lport *lport = vport->dd_data;
+	struct fc_lport *lport = fc_vport_priv(vport);
 	struct fc_frame *fp;
 	size_t len;
 
-	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
-		 "%s v%s over %s : %s", FCOE_NAME, FCOE_VERSION,
-		 fcoe_netdev(lport)->name, vport->symbolic_name);
+	snprintf(fc_vport_symbolic_name(vport),
+		 FC_SYMBOLIC_NAME_SIZE, "%s v%s over %s : %s",
+		 FCOE_NAME, FCOE_VERSION, fcoe_netdev(lport)->name,
+		 vport->symbolic_name);
 
 	if (lport->state != LPORT_ST_READY)
 		return;
 
-	len = strnlen(fc_host_symbolic_name(lport->host), 255);
+	len = strnlen(fc_vport_symbolic_name(lport_to_fcvport(lport)), 255);
 	fp = fc_frame_alloc(lport,
 			    sizeof(struct fc_ct_hdr) +
 			    sizeof(struct fc_ns_rspn) + len);
@@ -2507,7 +2512,7 @@ static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
  * @fc_lesb: the link error status block
  */
 static void fcoe_get_lesb(struct fc_lport *lport,
-			 struct fc_els_lesb *fc_lesb)
+			  struct fc_els_lesb *fc_lesb)
 {
 	unsigned int cpu;
 	u32 lfc, vlfc, mdac;
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 408a6fd..a052e5b 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -89,6 +89,12 @@ struct fcoe_interface {
 
 #define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)
 
+#define fcoe_to_fcport(fcoe)						\
+	((struct fc_port *)(((struct fc_port *)(fcoe)) - 1))
+
+#define ctlr_to_fcport(x)						\
+	fcoe_to_fcport(container_of((x), struct fcoe_interface, ctlr));
+
 /**
  * fcoe_netdev() - Return the net device associated with a local port
  * @lport: The local port to get the net device from
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index c93f007..501fcc0 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -149,8 +149,6 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
 {
 	fcoe_ctlr_set_state(fip, FIP_ST_LINK_WAIT);
 	fip->mode = mode;
-	INIT_LIST_HEAD(&fip->fcfs);
-	mutex_init(&fip->ctlr_mutex);
 	spin_lock_init(&fip->ctlr_lock);
 	fip->flogi_oxid = FC_XID_UNKNOWN;
 	setup_timer(&fip->timer, fcoe_ctlr_timeout, (unsigned long)fip);
@@ -168,14 +166,11 @@ EXPORT_SYMBOL(fcoe_ctlr_init);
  */
 static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 {
-	struct fcoe_fcf *fcf;
-	struct fcoe_fcf *next;
+	struct fc_port *fcport = fip->lp->fcport;
 
 	fip->sel_fcf = NULL;
-	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
-		list_del(&fcf->list);
-		kfree(fcf);
-	}
+	fip->lp->fcfabric = NULL;
+	fc_port_del_fabrics(fcport);
 	fip->fcf_count = 0;
 	fip->sel_time = 0;
 }
@@ -194,13 +189,17 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
  */
 void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
+	struct fc_vport *fcvport = lport_to_fcvport(fip->lp);
+
 	cancel_work_sync(&fip->recv_work);
 	skb_queue_purge(&fip->fip_recv_list);
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	fcoe_ctlr_set_state(fip, FIP_ST_DISABLED);
+	fcvport->fcfabric = NULL;
 	fcoe_ctlr_reset_fcfs(fip);
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 	del_timer_sync(&fip->timer);
 	cancel_work_sync(&fip->timer_work);
 }
@@ -216,16 +215,21 @@ EXPORT_SYMBOL(fcoe_ctlr_destroy);
  */
 static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
 {
+	struct fc_fabric *fcfabric;
+	struct fc_lport *lport = fip->lp;
+	struct fc_port *fcport = lport->fcport;
 	struct fcoe_fcf *sel;
 	struct fcoe_fcf *fcf;
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	spin_lock_bh(&fip->ctlr_lock);
 
 	kfree_skb(fip->flogi_req);
 	fip->flogi_req = NULL;
-	list_for_each_entry(fcf, &fip->fcfs, list)
+	list_for_each_entry(fcfabric, &fcport->fabrics, peers) {
+		fcf = fc_fabric_priv(fcfabric);
 		fcf->flogi_sent = 0;
+	}
 
 	spin_unlock_bh(&fip->ctlr_lock);
 	sel = fip->sel_fcf;
@@ -233,20 +237,20 @@ static void fcoe_ctlr_announce(struct fcoe_ctlr *fip)
 	if (sel && !compare_ether_addr(sel->fcf_mac, fip->dest_addr))
 		goto unlock;
 	if (!is_zero_ether_addr(fip->dest_addr)) {
-		printk(KERN_NOTICE "libfcoe: host%d: "
+		printk(KERN_NOTICE "libfcoe: fcport%u: "
 		       "FIP Fibre-Channel Forwarder MAC %pM deselected\n",
-		       fip->lp->host->host_no, fip->dest_addr);
+		       fc_port_id(fcport), fip->dest_addr);
 		memset(fip->dest_addr, 0, ETH_ALEN);
 	}
 	if (sel) {
-		printk(KERN_INFO "libfcoe: host%d: FIP selected "
+		printk(KERN_INFO "libfcoe: fcport%u: FIP selected "
 		       "Fibre-Channel Forwarder MAC %pM\n",
-		       fip->lp->host->host_no, sel->fcf_mac);
+		       fc_port_id(fcport), sel->fcf_mac);
 		memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
 		fip->map_dest = 0;
 	}
 unlock:
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 }
 
 /**
@@ -311,7 +315,8 @@ static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
 
 	sol->desc.wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
 	sol->desc.wwnn.fd_desc.fip_dlen = sizeof(sol->desc.wwnn) / FIP_BPW;
-	put_unaligned_be64(fip->lp->wwnn, &sol->desc.wwnn.fd_wwn);
+	put_unaligned_be64(fc_vport_node_name(lport_to_fcvport(fip->lp)),
+			   &sol->desc.wwnn.fd_wwn);
 
 	fcoe_size = fcoe_ctlr_fcoe_size(fip);
 	sol->desc.size.fd_desc.fip_dtype = FIP_DT_FCOE_SIZE;
@@ -336,9 +341,10 @@ static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
  */
 void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 {
-	mutex_lock(&fip->ctlr_mutex);
+	struct fc_port *fcport = fip->lp->fcport;
+	mutex_lock(&fcport->lock);
 	if (fip->state == FIP_ST_NON_FIP || fip->state == FIP_ST_AUTO) {
-		mutex_unlock(&fip->ctlr_mutex);
+		mutex_unlock(&fcport->lock);
 		fc_linkup(fip->lp);
 	} else if (fip->state == FIP_ST_LINK_WAIT) {
 		fcoe_ctlr_set_state(fip, fip->mode);
@@ -351,18 +357,18 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
 			/* fall-through */
 		case FIP_MODE_FABRIC:
 		case FIP_MODE_NON_FIP:
-			mutex_unlock(&fip->ctlr_mutex);
+			mutex_unlock(&fcport->lock);
 			fc_linkup(fip->lp);
 			fcoe_ctlr_solicit(fip, NULL);
 			break;
 		case FIP_MODE_VN2VN:
 			fcoe_ctlr_vn_start(fip);
-			mutex_unlock(&fip->ctlr_mutex);
+			mutex_unlock(&fcport->lock);
 			fc_linkup(fip->lp);
 			break;
 		}
 	} else
-		mutex_unlock(&fip->ctlr_mutex);
+		mutex_unlock(&fcport->lock);
 }
 EXPORT_SYMBOL(fcoe_ctlr_link_up);
 
@@ -392,14 +398,15 @@ static void fcoe_ctlr_reset(struct fcoe_ctlr *fip)
  */
 int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
 	int link_dropped;
 
 	LIBFCOE_FIP_DBG(fip, "link down.\n");
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	fcoe_ctlr_reset(fip);
 	link_dropped = fip->state != FIP_ST_LINK_WAIT;
 	fcoe_ctlr_set_state(fip, FIP_ST_LINK_WAIT);
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 
 	if (link_dropped)
 		fc_linkdown(fip->lp);
@@ -470,7 +477,8 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 		vn->fd_desc.fip_dlen = sizeof(*vn) / FIP_BPW;
 		memcpy(vn->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
 		hton24(vn->fd_fc_id, lport->port_id);
-		put_unaligned_be64(lport->wwpn, &vn->fd_wwpn);
+		put_unaligned_be64(fc_vport_port_name(lport_to_fcvport(lport)),
+				   &vn->fd_wwpn);
 	}
 	skb_put(skb, len);
 	skb->protocol = htons(ETH_P_FIP);
@@ -709,8 +717,9 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  */
 static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
+	struct fc_fabric *fcfabric, *next;
 	struct fcoe_fcf *fcf;
-	struct fcoe_fcf *next;
 	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
 	unsigned long deadline;
 	unsigned long sel_time = 0;
@@ -718,15 +727,16 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 
 	stats = per_cpu_ptr(fip->lp->dev_stats, get_cpu());
 
-	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
+	list_for_each_entry_safe(fcfabric, next, &fcport->fabrics, peers) {
+		fcf = fc_fabric_priv(fcfabric);
 		deadline = fcf->time + fcf->fka_period + fcf->fka_period / 2;
 		if (fip->sel_fcf == fcf) {
 			if (time_after(jiffies, deadline)) {
 				stats->MissDiscAdvCount++;
-				printk(KERN_INFO "libfcoe: host%d: "
+				printk(KERN_INFO "libfcoe: fcport%u: "
 				       "Missing Discovery Advertisement "
 				       "for fab %16.16llx count %lld\n",
-				       fip->lp->host->host_no, fcf->fabric_name,
+				       fc_port_id(fcport), fcf->fabric_name,
 				       stats->MissDiscAdvCount);
 			} else if (time_after(next_timer, deadline))
 				next_timer = deadline;
@@ -734,12 +744,13 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 
 		deadline += fcf->fka_period;
 		if (time_after_eq(jiffies, deadline)) {
-			if (fip->sel_fcf == fcf)
+			if (fip->sel_fcf == fcf) {
 				fip->sel_fcf = NULL;
-			list_del(&fcf->list);
+				fip->lp->fcfabric = NULL;
+			}
 			WARN_ON(!fip->fcf_count);
 			fip->fcf_count--;
-			kfree(fcf);
+			fc_fabric_del(fcf_to_fabric(fcf));
 			stats->VLinkFailureCount++;
 		} else {
 			if (time_after(next_timer, deadline))
@@ -890,16 +901,36 @@ len_err:
 	return -EINVAL;
 }
 
+int fcoe_fcf_match(struct fc_fabric *new, struct fc_fabric *old)
+{
+	struct fcoe_fcf *new_fcf = fc_fabric_priv(new);
+	struct fcoe_fcf *old_fcf = fc_fabric_priv(old);
+
+	if (new_fcf->switch_name == old_fcf->switch_name &&
+	    new_fcf->fabric_name == old_fcf->fabric_name &&
+	    new_fcf->fc_map == old_fcf->fc_map &&
+	    compare_ether_addr(new_fcf->fcf_mac, old_fcf->fcf_mac) == 0)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(fcoe_fcf_match);
+
 /**
  * fcoe_ctlr_recv_adv() - Handle an incoming advertisement
  * @fip: The FCoE controller receiving the advertisement
  * @skb: The received FIP packet
+ *
+ * This routine creates a temporary fcfabric and fcoe_fcf before
+ * calling fabric_add because that routine will search the list
+ * of fabrics for an existing entry.
  */
 static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
+	struct fc_port *fcport = fip->lp->fcport;
+	struct fc_fabric *new_fcfabric;
+	struct fc_fabric *fcfabric;
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf new;
-	struct fcoe_fcf *found;
 	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
 	int first = 0;
 	int mtu_valid;
@@ -907,29 +938,37 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	if (fcoe_ctlr_parse_adv(fip, skb, &new))
 		return;
 
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
+	new_fcfabric = kzalloc(sizeof(struct fc_fabric) +
+			       sizeof(struct fcoe_fcf), GFP_ATOMIC);
+	memcpy(fc_fabric_priv(new_fcfabric), &new, sizeof(struct fcoe_fcf));
+	new_fcfabric->fabric_name = new.fabric_name;
 
-		fcf = kmalloc(sizeof(*fcf), GFP_ATOMIC);
-		if (!fcf)
-			goto out;
+	mutex_lock(&fcport->lock);
+
+	if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT)
+		goto out;
 
+	/*
+	 * Must check if the list is empty before
+	 * we do the fc_fabric_add, as it will add
+	 * the new fabric to the list.
+	 */
+	first = list_empty(&fcport->fabrics);
+
+	fcfabric = fc_fabric_add(fcport, fip->fcfabric_f,
+				 new_fcfabric);
+	if (unlikely(!fcfabric))
+		goto out;
+
+	fcf = fc_fabric_priv(fcfabric);
+
+	/* Check to see if this is a duplicate FCF */
+	if (!fcoe_fcf_match(new_fcfabric, fcfabric)) {
+		fc_fabric_max_npiv_vports(fcfabric) = USHRT_MAX;
 		fip->fcf_count++;
 		memcpy(fcf, &new, sizeof(new));
-		list_add(&fcf->list, &fip->fcfs);
+		LIBFCOE_FIP_DBG(fip, "New FCF fab %16.16llx mac %pM\n",
+				fcf->fabric_name, fcf->fcf_mac);
 	} else {
 		/*
 		 * Update the FCF's keep-alive descriptor flags.
@@ -952,9 +991,6 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
 	fcf->time = jiffies;
-	if (!found)
-		LIBFCOE_FIP_DBG(fip, "New FCF fab %16.16llx mac %pM\n",
-				fcf->fabric_name, fcf->fcf_mac);
 
 	/*
 	 * If this advertisement is not solicited and our max receive size
@@ -979,8 +1015,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	 * are sending periodic multicast advertisements.
 	 */
 	if (mtu_valid) {
-		list_del(&fcf->list);
-		list_add(&fcf->list, &fip->fcfs);
+		list_del(&fcfabric->peers);
+		list_add(&fcfabric->peers, &fcport->fabrics);
 	}
 
 	/*
@@ -995,7 +1031,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 			mod_timer(&fip->timer, fip->sel_time);
 	}
 out:
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
+	kfree(new_fcfabric);
 }
 
 /**
@@ -1165,6 +1202,10 @@ drop:
 static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 				     struct fip_header *fh)
 {
+	struct fc_fabric *fcfabric = fcf_to_fabric(fip->sel_fcf);
+	struct fc_lport *lport = fip->lp;
+	struct fc_port *fcport = lport->fcport;
+	struct fc_vport *fcvport;
 	struct fip_desc *desc;
 	struct fip_mac_desc *mp;
 	struct fip_wwn_desc *wp;
@@ -1172,7 +1213,6 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	size_t rlen;
 	size_t dlen;
 	struct fcoe_fcf *fcf = fip->sel_fcf;
-	struct fc_lport *lport = fip->lp;
 	struct fc_lport *vn_port = NULL;
 	u32 desc_mask;
 	int is_vn_port = 0;
@@ -1223,26 +1263,28 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 				return;
 			if (compare_ether_addr(vp->fd_mac,
 					       fip->get_src_addr(lport)) == 0 &&
-			    get_unaligned_be64(&vp->fd_wwpn) == lport->wwpn &&
+			    get_unaligned_be64(&vp->fd_wwpn) ==
+			    fc_vport_port_name(lport_to_fcvport(lport)) &&
 			    ntoh24(vp->fd_fc_id) == lport->port_id) {
 				desc_mask &= ~BIT(FIP_DT_VN_ID);
 				break;
 			}
 			/* check if clr_vlink is for NPIV port */
-			mutex_lock(&lport->lp_mutex);
-			list_for_each_entry(vn_port, &lport->vports, list) {
+			mutex_lock(&fcport->lock);
+			list_for_each_entry(fcvport, &fcfabric->vports, peers) {
+				vn_port = fc_vport_priv(fcvport);
 				if (compare_ether_addr(vp->fd_mac,
 				    fip->get_src_addr(vn_port)) == 0 &&
 				    (get_unaligned_be64(&vp->fd_wwpn)
 							== vn_port->wwpn) &&
 				    (ntoh24(vp->fd_fc_id) ==
-					    fc_host_port_id(vn_port->host))) {
+				     lport->port_id)) {
 					desc_mask &= ~BIT(FIP_DT_VN_ID);
 					is_vn_port = 1;
 					break;
 				}
 			}
-			mutex_unlock(&lport->lp_mutex);
+			mutex_unlock(&fcport->lock);
 
 			break;
 		default:
@@ -1267,12 +1309,12 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		if (is_vn_port)
 			fc_lport_reset(vn_port);
 		else {
-			mutex_lock(&fip->ctlr_mutex);
+			mutex_lock(&fcport->lock);
 			per_cpu_ptr(lport->dev_stats,
 				    get_cpu())->VLinkFailureCount++;
 			put_cpu();
 			fcoe_ctlr_reset(fip);
-			mutex_unlock(&fip->ctlr_mutex);
+			mutex_unlock(&fcport->lock);
 
 			fc_lport_reset(fip->lp);
 			fcoe_ctlr_solicit(fip, NULL);
@@ -1303,6 +1345,7 @@ EXPORT_SYMBOL(fcoe_ctlr_recv);
  */
 static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
+	struct fc_port *fcport = fip->lp->fcport;
 	struct fip_header *fiph;
 	struct ethhdr *eh;
 	enum fip_state state;
@@ -1331,7 +1374,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	if (ntohs(fiph->fip_dl_len) * FIP_BPW + sizeof(*fiph) > skb->len)
 		goto drop;
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	state = fip->state;
 	if (state == FIP_ST_AUTO) {
 		fip->map_dest = 0;
@@ -1339,7 +1382,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		state = FIP_ST_ENABLED;
 		LIBFCOE_FIP_DBG(fip, "Using FIP mode\n");
 	}
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 
 	if (fip->mode == FIP_MODE_VN2VN && op == FIP_OP_VN2VN)
 		return fcoe_ctlr_vn_recv(fip, skb);
@@ -1367,6 +1410,19 @@ drop:
 	return -1;
 }
 
+static void fcoe_ctlr_assign_fcf(struct fcoe_ctlr *fip,
+				 struct fcoe_fcf *fcf)
+{
+	/*
+	 * TODO: Does the fip->sel_fcf assignment need
+	 * to be protected and if it isn't in the current
+	 * code then why not? Maybe there should be a
+	 * comment explaining it.
+	 */
+	fip->sel_fcf = fcf;
+	fip->lp->fcfabric = fcf_to_fabric(fip->sel_fcf);
+}
+
 /**
  * fcoe_ctlr_select() - Select the best FCF (if possible)
  * @fip: The FCoE controller
@@ -1382,19 +1438,28 @@ drop:
  */
 static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
+	struct fc_fabric *fcfabric;
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *best = fip->sel_fcf;
 	struct fcoe_fcf *first;
 
-	first = list_first_entry(&fip->fcfs, struct fcoe_fcf, list);
+	fcfabric = list_first_entry(&fcport->fabrics, struct fc_fabric, peers);
+	first = fc_fabric_priv(fcfabric);
 
-	list_for_each_entry(fcf, &fip->fcfs, list) {
+	list_for_each_entry(fcfabric, &fcport->fabrics, peers) {
+		fcf = fc_fabric_priv(fcfabric);
 		LIBFCOE_FIP_DBG(fip, "consider FCF fab %16.16llx "
 				"VFID %d mac %pM map %x val %d "
 				"sent %u pri %u\n",
 				fcf->fabric_name, fcf->vfid, fcf->fcf_mac,
 				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf),
 				fcf->flogi_sent, fcf->pri);
+
+		/*
+		 * Can these checks be added to fcoe_fcf_match so
+		 * that we can use that routine here?
+		 */
 		if (fcf->fabric_name != first->fabric_name ||
 		    fcf->vfid != first->vfid ||
 		    fcf->fc_map != first->fc_map) {
@@ -1416,7 +1481,9 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 		if (!best || fcf->pri < best->pri || best->flogi_sent)
 			best = fcf;
 	}
-	fip->sel_fcf = best;
+
+	fcoe_ctlr_assign_fcf(fip, best);
+
 	if (best) {
 		LIBFCOE_FIP_DBG(fip, "using FCF mac %pM\n", best->fcf_mac);
 		fip->port_ka_time = jiffies +
@@ -1477,10 +1544,11 @@ static int fcoe_ctlr_flogi_send_locked(struct fcoe_ctlr *fip)
  */
 static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
 	struct fcoe_fcf *fcf;
 	int error;
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	spin_lock_bh(&fip->ctlr_lock);
 	LIBFCOE_FIP_DBG(fip, "re-sending FLOGI - reselect\n");
 	fcf = fcoe_ctlr_select(fip);
@@ -1493,7 +1561,7 @@ static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *fip)
 		error = fcoe_ctlr_flogi_send_locked(fip);
 	}
 	spin_unlock_bh(&fip->ctlr_lock);
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 	return error;
 }
 
@@ -1508,6 +1576,8 @@ static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *fip)
  */
 static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
+	struct fc_fabric *fcfabric;
 	struct fcoe_fcf *fcf;
 
 	spin_lock_bh(&fip->ctlr_lock);
@@ -1526,8 +1596,12 @@ static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
 		fcf = fcoe_ctlr_select(fip);
 		if (!fcf || fcf->flogi_sent) {
 			LIBFCOE_FIP_DBG(fip, "sending FLOGI - clearing\n");
-			list_for_each_entry(fcf, &fip->fcfs, list)
+			mutex_lock(&fcport->lock);
+			list_for_each_entry(fcfabric, &fcport->fabrics, peers) {
+				fcf = fc_fabric_priv(fcfabric);
 				fcf->flogi_sent = 0;
+			}
+			mutex_unlock(&fcport->lock);
 			fcf = fcoe_ctlr_select(fip);
 		}
 	}
@@ -1560,8 +1634,11 @@ static void fcoe_ctlr_timeout(unsigned long arg)
  */
 static void fcoe_ctlr_timer_work(struct work_struct *work)
 {
+	struct fc_port *fcport;
 	struct fcoe_ctlr *fip;
-	struct fc_lport *vport;
+	struct fc_lport *vn_lport;
+	struct fc_vport *fcvport = NULL;
+	struct fc_fabric *fcfabric = NULL;
 	u8 *mac;
 	u8 reset = 0;
 	u8 send_ctlr_ka = 0;
@@ -1573,9 +1650,12 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 	fip = container_of(work, struct fcoe_ctlr, timer_work);
 	if (fip->mode == FIP_MODE_VN2VN)
 		return fcoe_ctlr_vn_timeout(fip);
-	mutex_lock(&fip->ctlr_mutex);
+
+	fcport = fip->lp->fcport;
+	mutex_lock(&fcport->lock);
+
 	if (fip->state == FIP_ST_DISABLED) {
-		mutex_unlock(&fip->ctlr_mutex);
+		mutex_unlock(&fcport->lock);
 		return;
 	}
 
@@ -1612,9 +1692,9 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 		if (time_after(next_timer, fip->port_ka_time))
 			next_timer = fip->port_ka_time;
 	}
-	if (!list_empty(&fip->fcfs))
+	if (!list_empty(&fcport->fabrics))
 		mod_timer(&fip->timer, next_timer);
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 
 	if (reset) {
 		fc_lport_reset(fip->lp);
@@ -1626,14 +1706,22 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 		fcoe_ctlr_send_keep_alive(fip, NULL, 0, fip->ctl_src_addr);
 
 	if (send_port_ka) {
-		mutex_lock(&fip->lp->lp_mutex);
+		/*
+		 * TODO: lp_mutex previously protected the get_src_addr
+		 * and send_keep_alive as well as the for_each vports search.
+		 * Is it a problem that now only the fabric mutex is
+		 * protecting the for_each vports search?
+		 */
 		mac = fip->get_src_addr(fip->lp);
 		fcoe_ctlr_send_keep_alive(fip, fip->lp, 1, mac);
-		list_for_each_entry(vport, &fip->lp->vports, list) {
-			mac = fip->get_src_addr(vport);
-			fcoe_ctlr_send_keep_alive(fip, vport, 1, mac);
+		fcfabric = fcf_to_fabric(fip->sel_fcf);
+		mutex_lock(&fcport->lock);
+		list_for_each_entry(fcvport, &fcfabric->vports, peers) {
+			vn_lport = fc_vport_priv(fcvport);
+			mac = fip->get_src_addr(vn_lport);
+			fcoe_ctlr_send_keep_alive(fip, vn_lport, 1, mac);
 		}
-		mutex_unlock(&fip->lp->lp_mutex);
+		mutex_unlock(&fcport->lock);
 	}
 }
 
@@ -1669,6 +1757,7 @@ static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
 int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			 struct fc_frame *fp)
 {
+	struct fc_port *fcport = lport->fcport;
 	struct fc_frame_header *fh;
 	u8 op;
 	u8 *sa;
@@ -1682,9 +1771,9 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	if (op == ELS_LS_ACC && fh->fh_r_ctl == FC_RCTL_ELS_REP &&
 	    fip->flogi_oxid == ntohs(fh->fh_ox_id)) {
 
-		mutex_lock(&fip->ctlr_mutex);
+		mutex_lock(&fcport->lock);
 		if (fip->state != FIP_ST_AUTO && fip->state != FIP_ST_NON_FIP) {
-			mutex_unlock(&fip->ctlr_mutex);
+			mutex_unlock(&fcport->lock);
 			return -EINVAL;
 		}
 		fcoe_ctlr_set_state(fip, FIP_ST_NON_FIP);
@@ -1704,13 +1793,13 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 			fip->map_dest = 0;
 		}
 		fip->flogi_oxid = FC_XID_UNKNOWN;
-		mutex_unlock(&fip->ctlr_mutex);
+		mutex_unlock(&fcport->lock);
 		fc_fcoe_set_mac(fr_cb(fp)->granted_mac, fh->fh_d_id);
 	} else if (op == ELS_FLOGI && fh->fh_r_ctl == FC_RCTL_ELS_REQ && sa) {
 		/*
 		 * Save source MAC for point-to-point responses.
 		 */
-		mutex_lock(&fip->ctlr_mutex);
+		mutex_lock(&fcport->lock);
 		if (fip->state == FIP_ST_AUTO || fip->state == FIP_ST_NON_FIP) {
 			memcpy(fip->dest_addr, sa, ETH_ALEN);
 			fip->map_dest = 0;
@@ -1719,7 +1808,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *fip, struct fc_lport *lport,
 						"Setting non-FIP mode\n");
 			fcoe_ctlr_set_state(fip, FIP_ST_NON_FIP);
 		}
-		mutex_unlock(&fip->ctlr_mutex);
+		mutex_unlock(&fcport->lock);
 	}
 	return 0;
 }
@@ -1884,13 +1973,14 @@ static void fcoe_ctlr_vn_rport_callback(struct fc_lport *lport,
 					struct fc_rport_priv *rdata,
 					enum fc_rport_event event)
 {
+	struct fc_port *fcport = lport->fcport;
 	struct fcoe_ctlr *fip = lport->disc.priv;
 	struct fcoe_rport *frport = fcoe_ctlr_rport(rdata);
 
 	LIBFCOE_FIP_DBG(fip, "vn_rport_callback %x event %d\n",
 			rdata->ids.port_id, event);
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	switch (event) {
 	case RPORT_EV_READY:
 		frport->login_count = 0;
@@ -1909,7 +1999,7 @@ static void fcoe_ctlr_vn_rport_callback(struct fc_lport *lport,
 	default:
 		break;
 	}
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 }
 
 static struct fc_rport_operations fcoe_ctlr_vn_rport_ops = {
@@ -1938,11 +2028,11 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
  */
 static void fcoe_ctlr_disc_stop(struct fc_lport *lport)
 {
-	struct fcoe_ctlr *fip = lport->disc.priv;
+	struct fc_port *fcport = lport->fcport;
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	fcoe_ctlr_disc_stop_locked(lport);
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 }
 
 /**
@@ -2450,6 +2540,7 @@ static unsigned long fcoe_ctlr_vn_age(struct fcoe_ctlr *fip)
  */
 static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
+	struct fc_port *fcport = fip->lp->fcport;
 	struct fip_header *fiph;
 	enum fip_vn2vn_subcode sub;
 	struct {
@@ -2467,7 +2558,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		goto drop;
 	}
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	switch (sub) {
 	case FIP_SC_VN_PROBE_REQ:
 		fcoe_ctlr_vn_probe_req(fip, &buf.rdata);
@@ -2489,7 +2580,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		rc = -1;
 		break;
 	}
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 drop:
 	kfree_skb(skb);
 	return rc;
@@ -2575,11 +2666,13 @@ static void fcoe_ctlr_vn_disc(struct fcoe_ctlr *fip)
  */
 static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 {
+	struct fc_port *fcport = fip->lp->fcport;
+	struct fc_vport *fcvport = lport_to_fcvport(fip->lp);
 	unsigned long next_time;
 	u8 mac[ETH_ALEN];
 	u32 new_port_id = 0;
 
-	mutex_lock(&fip->ctlr_mutex);
+	mutex_lock(&fcport->lock);
 	switch (fip->state) {
 	case FIP_ST_VNMP_START:
 		fcoe_ctlr_set_state(fip, FIP_ST_VNMP_PROBE1);
@@ -2636,11 +2729,13 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 	}
 	mod_timer(&fip->timer, next_time);
 unlock:
-	mutex_unlock(&fip->ctlr_mutex);
+	mutex_unlock(&fcport->lock);
 
 	/* If port ID is new, notify local port after dropping ctlr_mutex */
-	if (new_port_id)
+	if (new_port_id) {
+		fcvport->fcfabric = fc_fabric_add(fcport, fip->fcfabric_f, 0);
 		fc_lport_set_local_id(fip->lp, new_port_id);
+	}
 }
 
 /**
@@ -2653,12 +2748,10 @@ unlock:
  * Returns : 0 for success
  */
 int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
-		      const struct libfc_function_template *tt, int init_fcp)
+		      const struct libfc_function_template *tt)
 {
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lport->tt, tt, sizeof(*tt));
-	if (init_fcp && fc_fcp_init(lport))
-		return -ENOMEM;
 	fc_exch_init(lport);
 	fc_elsct_init(lport);
 	fc_lport_init(lport);
diff --git a/drivers/scsi/fcoe/libfcoe.h b/drivers/scsi/fcoe/libfcoe.h
index 6af5fc3..b447955 100644
--- a/drivers/scsi/fcoe/libfcoe.h
+++ b/drivers/scsi/fcoe/libfcoe.h
@@ -20,8 +20,8 @@ do {							\
 
 #define LIBFCOE_FIP_DBG(fip, fmt, args...)				\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_FIP_LOGGING,			\
-			      printk(KERN_INFO "host%d: fip: " fmt,	\
-				     (fip)->lp->host->host_no, ##args);)
+			      printk(KERN_INFO "fcport%u: fip: " fmt,	\
+				     fc_port_id((fip)->lp->fcport), ##args);)
 
 #define LIBFCOE_TRANSPORT_DBG(fmt, args...)				\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_TRANSPORT_LOGGING,		\
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 911b273..4310426 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -382,6 +382,7 @@ err:
  */
 static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 {
+	struct fc_vport *fcvport;
 	struct fc_lport *lport;
 	struct fc_gpn_ft_resp *np;
 	char *bp;
@@ -392,6 +393,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	struct fc_rport_priv *rdata;
 
 	lport = fc_disc_lport(disc);
+	fcvport = lport_to_fcvport(lport);
 	disc->seq_count++;
 
 	/*
@@ -436,7 +438,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		ids.port_name = ntohll(np->fp_wwpn);
 
 		if (ids.port_id != lport->port_id &&
-		    ids.port_name != lport->wwpn) {
+		    ids.port_name != fc_vport_port_name(fcvport)) {
 			rdata = lport->tt.rport_create(lport, ids.port_id);
 			if (rdata) {
 				rdata->ids.port_name = ids.port_name;
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 28231ba..bb2d31c 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1826,8 +1826,7 @@ static void fc_exch_els_rec(struct fc_frame *rfp)
 	rxid = ntohs(rp->rec_rx_id);
 	oxid = ntohs(rp->rec_ox_id);
 
-	ep = fc_exch_lookup(lport,
-			    sid == fc_host_port_id(lport->host) ? oxid : rxid);
+	ep = fc_exch_lookup(lport, sid == lport->port_id ? oxid : rxid);
 	explan = ELS_EXPL_OXID_RXID;
 	if (!ep)
 		goto reject;
@@ -1994,13 +1993,11 @@ err:
  */
 static void fc_exch_rrq(struct fc_exch *ep)
 {
-	struct fc_lport *lport;
+	struct fc_lport *lport = ep->lp;
 	struct fc_els_rrq *rrq;
 	struct fc_frame *fp;
 	u32 did;
 
-	lport = ep->lp;
-
 	fp = fc_frame_alloc(lport, sizeof(*rrq));
 	if (!fp)
 		goto retry;
@@ -2060,8 +2057,8 @@ static void fc_exch_els_rrq(struct fc_frame *fp)
 	 * lookup subject exchange.
 	 */
 	sid = ntoh24(rp->rrq_s_id);		/* subject source */
-	xid = fc_host_port_id(lport->host) == sid ?
-			ntohs(rp->rrq_ox_id) : ntohs(rp->rrq_rx_id);
+	xid = lport->port_id == sid ?
+		ntohs(rp->rrq_ox_id) : ntohs(rp->rrq_rx_id);
 	ep = fc_exch_lookup(lport, xid);
 	explan = ELS_EXPL_OXID_RXID;
 	if (!ep)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index b1b03af..fc9c97f 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -69,26 +69,6 @@ static struct kmem_cache *scsi_pkt_cachep;
 #define CMD_SCSI_STATUS(Cmnd)	    ((Cmnd)->SCp.Status)
 #define CMD_RESID_LEN(Cmnd)	    ((Cmnd)->SCp.buffers_residual)
 
-/**
- * struct fc_fcp_internal - FCP layer internal data
- * @scsi_pkt_pool: Memory pool to draw FCP packets from
- * @scsi_queue_lock: Protects the scsi_pkt_queue
- * @scsi_pkt_queue: Current FCP packets
- * @last_can_queue_ramp_down_time: ramp down time
- * @last_can_queue_ramp_up_time: ramp up time
- * @max_can_queue: max can_queue size
- */
-struct fc_fcp_internal {
-	mempool_t		*scsi_pkt_pool;
-	spinlock_t		scsi_queue_lock;
-	struct list_head	scsi_pkt_queue;
-	unsigned long		last_can_queue_ramp_down_time;
-	unsigned long		last_can_queue_ramp_up_time;
-	int			max_can_queue;
-};
-
-#define fc_get_scsi_internal(x)	((struct fc_fcp_internal *)(x)->scsi_priv)
-
 /*
  * function prototypes
  * FC scsi I/O related functions
@@ -354,13 +334,13 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 
 	si->last_can_queue_ramp_up_time = jiffies;
 
-	can_queue = lport->host->can_queue << 1;
+	can_queue = si->host->can_queue << 1;
 	if (can_queue >= si->max_can_queue) {
 		can_queue = si->max_can_queue;
 		si->last_can_queue_ramp_down_time = 0;
 	}
-	lport->host->can_queue = can_queue;
-	shost_printk(KERN_ERR, lport->host, "libfc: increased "
+	si->host->can_queue = can_queue;
+	shost_printk(KERN_ERR, si->host, "libfc: increased "
 		     "can_queue to %d.\n", can_queue);
 }
 
@@ -388,12 +368,12 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 
 	si->last_can_queue_ramp_down_time = jiffies;
 
-	can_queue = lport->host->can_queue;
+	can_queue = si->host->can_queue;
 	can_queue >>= 1;
 	if (!can_queue)
 		can_queue = 1;
-	lport->host->can_queue = can_queue;
-	shost_printk(KERN_ERR, lport->host, "libfc: Could not allocate frame.\n"
+	si->host->can_queue = can_queue;
+	shost_printk(KERN_ERR, si->host, "libfc: Could not allocate frame.\n"
 		     "Reducing can_queue to %d.\n", can_queue);
 }
 
@@ -408,6 +388,7 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 						  size_t len)
 {
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	struct fc_frame *fp;
 	unsigned long flags;
 
@@ -416,9 +397,10 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 		return fp;
 
 	/* error case */
-	spin_lock_irqsave(lport->host->host_lock, flags);
+	spin_lock_irqsave(si->host->host_lock, flags);
 	fc_fcp_can_queue_ramp_down(lport);
-	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	spin_unlock_irqrestore(si->host->host_lock, flags);
+
 	return NULL;
 }
 
@@ -1016,7 +998,7 @@ static void fc_fcp_cleanup_each_cmd(struct fc_lport *lport, unsigned int id,
 	struct scsi_cmnd *sc_cmd;
 	unsigned long flags;
 
-	spin_lock_irqsave(&si->scsi_queue_lock, flags);
+	spin_lock_irqsave(si->host->host_lock, flags);
 restart:
 	list_for_each_entry(fsp, &si->scsi_pkt_queue, list) {
 		sc_cmd = fsp->cmd;
@@ -1027,7 +1009,7 @@ restart:
 			continue;
 
 		fc_fcp_pkt_hold(fsp);
-		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+		spin_unlock_irqrestore(si->host->host_lock, flags);
 
 		if (!fc_fcp_lock_pkt(fsp)) {
 			fc_fcp_cleanup_cmd(fsp, error);
@@ -1036,14 +1018,14 @@ restart:
 		}
 
 		fc_fcp_pkt_release(fsp);
-		spin_lock_irqsave(&si->scsi_queue_lock, flags);
+		spin_lock_irqsave(si->host->host_lock, flags);
 		/*
 		 * while we dropped the lock multiple pkts could
 		 * have been released, so we have to start over.
 		 */
 		goto restart;
 	}
-	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+	spin_unlock_irqrestore(si->host->host_lock, flags);
 }
 
 /**
@@ -1796,8 +1778,12 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
  */
 int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 {
-	struct fc_lport *lport = shost_priv(shost);
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct scsi_target *starget = scsi_target(sc_cmd->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
+	struct fcp_init *fcpinit = shost_priv(sc_cmd->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport_libfc_priv *rpriv;
 	int rval;
@@ -1811,7 +1797,9 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		return 0;
 	}
 
-	if (!*(struct fc_remote_port **)rport->dd_data) {
+	rpriv = rport->dd_data;
+
+	if (!rpriv->local_port) {
 		/*
 		 * rport is transitioning from blocked/deleted to
 		 * online
@@ -1821,8 +1809,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		goto out;
 	}
 
-	rpriv = rport->dd_data;
-
 	if (!fc_fcp_lport_queue_ready(lport)) {
 		if (lport->qfull)
 			fc_fcp_can_queue_ramp_down(lport);
@@ -2028,29 +2014,28 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
  */
 int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 {
+	struct fcp_init *fcpinit = shost_priv(sc_cmd->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
 	struct fc_fcp_pkt *fsp;
-	struct fc_lport *lport;
-	struct fc_fcp_internal *si;
 	int rc = FAILED;
 	unsigned long flags;
 
-	lport = shost_priv(sc_cmd->device->host);
 	if (lport->state != LPORT_ST_READY)
 		return rc;
 	else if (!lport->link_up)
 		return rc;
 
-	si = fc_get_scsi_internal(lport);
-	spin_lock_irqsave(&si->scsi_queue_lock, flags);
+	spin_lock_irqsave(si->host->host_lock, flags);
 	fsp = CMD_SP(sc_cmd);
 	if (!fsp) {
 		/* command completed while scsi eh was setting up */
-		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+		spin_unlock_irqrestore(si->host->host_lock, flags);
 		return SUCCESS;
 	}
 	/* grab a ref so the fsp and sc_cmd cannot be relased from under us */
 	fc_fcp_pkt_hold(fsp);
-	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+	spin_unlock_irqrestore(si->host->host_lock, flags);
 
 	if (fc_fcp_lock_pkt(fsp)) {
 		/* completed while we were waiting for timer to be deleted */
@@ -2076,9 +2061,13 @@ EXPORT_SYMBOL(fc_eh_abort);
  */
 int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 {
-	struct fc_lport *lport;
+	struct fcp_init *fcpinit = shost_priv(sc_cmd->device->host);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
+	struct scsi_target *starget = scsi_target(sc_cmd->device);
+	struct fcp_targ *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
 	struct fc_fcp_pkt *fsp;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	int rc = FAILED;
 	int rval;
 
@@ -2086,8 +2075,6 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (rval)
 		goto out;
 
-	lport = shost_priv(sc_cmd->device->host);
-
 	if (lport->state != LPORT_ST_READY)
 		return rc;
 
@@ -2125,7 +2112,9 @@ EXPORT_SYMBOL(fc_eh_device_reset);
 int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 {
 	struct Scsi_Host *shost = sc_cmd->device->host;
-	struct fc_lport *lport = shost_priv(shost);
+	struct fcp_init *fcpinit = shost_priv(shost);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
 	unsigned long wait_tmo;
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
@@ -2158,7 +2147,8 @@ EXPORT_SYMBOL(fc_eh_host_reset);
  */
 int fc_slave_alloc(struct scsi_device *sdev)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct fcp_targ *fcptarg = starget_to_fcptarg(scsi_target(sdev));
+	struct fc_rport *rport = fcptarg->rport;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
@@ -2231,8 +2221,6 @@ void fc_fcp_destroy(struct fc_lport *lport)
 		       "port (%6.6x)\n", lport->port_id);
 
 	mempool_destroy(si->scsi_pkt_pool);
-	kfree(si);
-	lport->scsi_priv = NULL;
 }
 EXPORT_SYMBOL(fc_fcp_destroy);
 
@@ -2262,10 +2250,14 @@ void fc_destroy_fcp(void)
  * fc_fcp_init() - Initialize the FCP layer for a local port
  * @lport: The local port to initialize the exchange layer for
  */
-int fc_fcp_init(struct fc_lport *lport)
+int fc_fcp_init(struct fcp_init *fcpinit)
 {
-	int rc;
-	struct fc_fcp_internal *si;
+	struct fc_vport *fcvport = fcpinit_to_fcvport(fcpinit);
+	struct fc_lport *lport = fc_vport_priv(fcvport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
+
+	int rc = 0;
 
 	if (!lport->tt.fcp_cmd_send)
 		lport->tt.fcp_cmd_send = fc_fcp_cmd_send;
@@ -2276,23 +2268,17 @@ int fc_fcp_init(struct fc_lport *lport)
 	if (!lport->tt.fcp_abort_io)
 		lport->tt.fcp_abort_io = fc_fcp_abort_io;
 
-	si = kzalloc(sizeof(struct fc_fcp_internal), GFP_KERNEL);
-	if (!si)
-		return -ENOMEM;
-	lport->scsi_priv = si;
-	si->max_can_queue = lport->host->can_queue;
+	lport->fcpinit = fcpinit;
+	si->host = shost;
+	si->lport = lport;
+	si->max_can_queue = si->host->can_queue;
+
 	INIT_LIST_HEAD(&si->scsi_pkt_queue);
 	spin_lock_init(&si->scsi_queue_lock);
-
 	si->scsi_pkt_pool = mempool_create_slab_pool(2, scsi_pkt_cachep);
-	if (!si->scsi_pkt_pool) {
+	if (!si->scsi_pkt_pool)
 		rc = -ENOMEM;
-		goto free_internal;
-	}
-	return 0;
 
-free_internal:
-	kfree(si);
 	return rc;
 }
 EXPORT_SYMBOL(fc_fcp_init);
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index fedc819..e65d893 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -45,20 +45,20 @@ extern unsigned int fc_debug_logging;
 
 #define FC_LPORT_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: lport %6.6x: " fmt,	\
-				(lport)->host->host_no,			\
+			 printk(KERN_INFO "fcport%u: lport %6x: " fmt,	\
+				fc_port_id((lport)->fcport),		\
 				(lport)->port_id, ##args))
 
-#define FC_DISC_DBG(disc, fmt, args...)				\
-	FC_CHECK_LOGGING(FC_DISC_LOGGING,			\
-			 printk(KERN_INFO "host%u: disc: " fmt,	\
-				fc_disc_lport(disc)->host->host_no,	\
+#define FC_DISC_DBG(disc, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
+			 printk(KERN_INFO "fcport%u: disc: " fmt,	\
+				fc_port_id(fc_disc_lport(disc)->fcport), \
 				##args))
 
 #define FC_RPORT_ID_DBG(lport, port_id, fmt, args...)			\
 	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: rport %6.6x: " fmt,	\
-				(lport)->host->host_no,			\
+			 printk(KERN_INFO "fcport%u: rport %6x: " fmt,	\
+				fc_port_id((lport)->fcport),		\
 				(port_id), ##args))
 
 #define FC_RPORT_DBG(rdata, fmt, args...)				\
@@ -70,28 +70,28 @@ extern unsigned int fc_debug_logging;
 		if ((pkt)->seq_ptr) {					\
 			struct fc_exch *_ep = NULL;			\
 			_ep = fc_seq_exch((pkt)->seq_ptr);		\
-			printk(KERN_INFO "host%u: fcp: %6.6x: "		\
-				"xid %04x-%04x: " fmt,			\
-				(pkt)->lp->host->host_no,		\
-				(pkt)->rport->port_id,			\
-				(_ep)->oxid, (_ep)->rxid, ##args);	\
+			printk(KERN_INFO "fcport%u: fcp: %6.6x: "	\
+			       "xid %04x-%04x: " fmt,			\
+			       fc_port_id((pkt)->lp->fcport),		\
+			       (pkt)->rport->port_id,			\
+			       (_ep)->oxid, (_ep)->rxid, ##args);	\
 		} else {						\
-			printk(KERN_INFO "host%u: fcp: %6.6x: " fmt,	\
-				(pkt)->lp->host->host_no,		\
-				(pkt)->rport->port_id, ##args);		\
+			printk(KERN_INFO "fcport%u: fcp: %6.6x: " fmt,	\
+			       fc_port_id((pkt)->lp->fcport),		\
+			       (pkt)->rport->port_id, ##args);		\
 		}							\
 	})
 
 #define FC_EXCH_DBG(exch, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
-			 printk(KERN_INFO "host%u: xid %4x: " fmt,	\
-				(exch)->lp->host->host_no,		\
+			 printk(KERN_INFO "fcport%u: xid %4x: " fmt,	\
+				fc_port_id((exch)->lp->fcport),		\
 				exch->xid, ##args))
 
 #define FC_SCSI_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_SCSI_LOGGING,				\
-			 printk(KERN_INFO "host%u: scsi: " fmt,		\
-				(lport)->host->host_no,	##args))
+			 printk(KERN_INFO "fcport%u: scsi: " fmt,	\
+				fc_port_id((lport)->fcport), ##args))
 
 /*
  * FC-4 Providers.
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 8c08b21..d3f2b0c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -140,7 +140,7 @@ static const char *fc_lport_state_names[] = {
  * @offset:   The offset into the response data
  */
 struct fc_bsg_info {
-	struct fc_bsg_job *job;
+	struct fcp_bsg_job *job;
 	struct fc_lport *lport;
 	u16 rsp_code;
 	struct scatterlist *sg;
@@ -247,52 +247,41 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
  * fc_get_host_port_state() - Return the port state of the given Scsi_Host
  * @shost:  The SCSI host whose port state is to be determined
  */
-void fc_get_host_port_state(struct Scsi_Host *shost)
+void fc_get_fcvport_port_state(struct fc_vport *fcvport)
 {
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_lport *lport = fc_vport_priv(fcvport);
 
 	mutex_lock(&lport->lp_mutex);
 	if (!lport->link_up)
-		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+		fc_vport_port_state(fcvport) = FC_PORTSTATE_LINKDOWN;
 	else
 		switch (lport->state) {
 		case LPORT_ST_READY:
-			fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+			fc_vport_port_state(fcvport) = FC_PORTSTATE_ONLINE;
 			break;
 		default:
-			fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+			fc_vport_port_state(fcvport) = FC_PORTSTATE_OFFLINE;
 		}
 	mutex_unlock(&lport->lp_mutex);
 }
-EXPORT_SYMBOL(fc_get_host_port_state);
-
-/**
- * fc_get_host_speed() - Return the speed of the given Scsi_Host
- * @shost: The SCSI host whose port speed is to be determined
- */
-void fc_get_host_speed(struct Scsi_Host *shost)
-{
-	struct fc_lport *lport = shost_priv(shost);
-
-	fc_host_speed(shost) = lport->link_speed;
-}
-EXPORT_SYMBOL(fc_get_host_speed);
+EXPORT_SYMBOL(fc_get_fcvport_port_state);
 
 /**
  * fc_get_host_stats() - Return the Scsi_Host's statistics
  * @shost: The SCSI host whose statistics are to be returned
  */
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
+struct fcp_init_statistics *fc_get_fcpinit_stats(struct fcp_init *fcpinit)
 {
-	struct fc_host_statistics *fcoe_stats;
-	struct fc_lport *lport = shost_priv(shost);
+	struct fcp_init_statistics *fcoe_stats;
+	struct fc_lport *lport = fcpinit_to_lport(fcpinit);
+	struct fc_fcp_internal *si = fcp_init_priv(fcpinit);
 	struct timespec v0, v1;
 	unsigned int cpu;
 	u64 fcp_in_bytes = 0;
 	u64 fcp_out_bytes = 0;
 
-	fcoe_stats = &lport->host_stats;
-	memset(fcoe_stats, 0, sizeof(struct fc_host_statistics));
+	fcoe_stats = &si->fcpinit_stats;
+	memset(fcoe_stats, 0, sizeof(struct fcp_init_statistics));
 
 	jiffies_to_timespec(jiffies, &v0);
 	jiffies_to_timespec(lport->boot_time, &v1);
@@ -326,7 +315,7 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	fcoe_stats->dumped_frames = -1;
 	return fcoe_stats;
 }
-EXPORT_SYMBOL(fc_get_host_stats);
+EXPORT_SYMBOL(fc_get_fcpinit_stats);
 
 /**
  * fc_lport_flogi_fill() - Fill in FLOGI command for request
@@ -338,13 +327,14 @@ static void fc_lport_flogi_fill(struct fc_lport *lport,
 				struct fc_els_flogi *flogi,
 				unsigned int op)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_csp *sp;
 	struct fc_els_cssp *cp;
 
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) op;
-	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	put_unaligned_be64(fc_vport_port_name(fcvport), &flogi->fl_wwpn);
+	put_unaligned_be64(fc_vport_node_name(fcvport), &flogi->fl_wwnn);
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -441,6 +431,7 @@ static void fc_lport_recv_echo_req(struct fc_lport *lport,
 static void fc_lport_recv_rnid_req(struct fc_lport *lport,
 				   struct fc_frame *in_fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_frame *fp;
 	struct fc_els_rnid *req;
 	struct {
@@ -475,8 +466,8 @@ static void fc_lport_recv_rnid_req(struct fc_lport *lport,
 			rp->rnid.rnid_cmd = ELS_LS_ACC;
 			rp->rnid.rnid_fmt = fmt;
 			rp->rnid.rnid_cid_len = sizeof(rp->cid);
-			rp->cid.rnid_wwpn = htonll(lport->wwpn);
-			rp->cid.rnid_wwnn = htonll(lport->wwnn);
+			rp->cid.rnid_wwpn = htonll(fc_vport_port_name(fcvport));
+			rp->cid.rnid_wwnn = htonll(fc_vport_node_name(fcvport));
 			if (fmt == ELS_RNIDF_GEN) {
 				rp->rnid.rnid_sid_len = sizeof(rp->gen);
 				memcpy(&rp->gen, &lport->rnid_gen,
@@ -550,8 +541,8 @@ void __fc_linkup(struct fc_lport *lport)
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link up on port (%6.6x)\n",
-	       lport->host->host_no, lport->port_id);
+	printk(KERN_INFO "fcport%u: libfc: Link up on port (%6x)\n",
+	       fc_port_id(lport->fcport), lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkup(lport);
@@ -570,7 +561,8 @@ void __fc_linkdown(struct fc_lport *lport)
 	if (lport->link_up) {
 		lport->link_up = 0;
 		fc_lport_enter_reset(lport);
-		lport->tt.fcp_cleanup(lport);
+		if (lport->tt.fcp_cleanup)
+			lport->tt.fcp_cleanup(lport);
 	}
 }
 
@@ -580,8 +572,8 @@ void __fc_linkdown(struct fc_lport *lport)
  */
 void fc_linkdown(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link down on port (%6.6x)\n",
-	       lport->host->host_no, lport->port_id);
+	printk(KERN_INFO "fcport%u: libfc: Link down on port (%6x)\n",
+	       fc_port_id(lport->fcport), lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkdown(lport);
@@ -630,7 +622,9 @@ int fc_lport_destroy(struct fc_lport *lport)
 	lport->tt.frame_send = fc_frame_drop;
 	mutex_unlock(&lport->lp_mutex);
 
-	lport->tt.fcp_abort_io(lport);
+	if (lport->tt.fcp_abort_io)
+		lport->tt.fcp_abort_io(lport);
+
 	lport->tt.disc_stop_final(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_fc4_del_lport(lport);
@@ -682,9 +676,9 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 		FC_LPORT_DBG(lport, "Discovery succeeded\n");
 		break;
 	case DISC_EV_FAILED:
-		printk(KERN_ERR "host%d: libfc: "
-		       "Discovery failed for port (%6.6x)\n",
-		       lport->host->host_no, lport->port_id);
+		printk(KERN_ERR "fcport%u: libfc: "
+		       "Discovery failed for port (%6x)\n",
+		       fc_port_id(lport->fcport), lport->port_id);
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -704,13 +698,15 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
  */
 static void fc_lport_enter_ready(struct fc_lport *lport)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	FC_LPORT_DBG(lport, "Entered READY from state %s\n",
 		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
-	if (lport->vport)
-		fc_vport_set_state(lport->vport, FC_VPORT_ACTIVE);
-	fc_vports_linkchange(lport);
+	if (!fc_vport_is_nport(fcvport))
+		fc_vport_set_state(fcvport, FC_VPORT_ACTIVE);
+	else
+		fc_vports_linkchange(lport);
 
 	if (!lport->ptp_rdata)
 		lport->tt.disc_start(fc_lport_disc_callback, lport);
@@ -728,14 +724,14 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 				 struct fc_frame *fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
+
 	if (port_id)
-		printk(KERN_INFO "host%d: Assigned Port ID %6.6x\n",
-		       lport->host->host_no, port_id);
+		printk(KERN_INFO "fcport%u: Assigned Port ID %6x\n",
+		       fc_port_id(lport->fcport), port_id);
 
 	lport->port_id = port_id;
-
-	/* Update the fc_host */
-	fc_host_port_id(lport->host) = port_id;
+	fc_vport_port_id(fcvport) = port_id;
 
 	if (lport->tt.lport_set_port_id)
 		lport->tt.lport_set_port_id(lport, port_id, fp);
@@ -752,6 +748,9 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
  */
 void fc_lport_set_local_id(struct fc_lport *lport, u32 port_id)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
+	struct fc_port *fcport = lport->fcport;
+
 	mutex_lock(&lport->lp_mutex);
 
 	fc_lport_set_port_id(lport, port_id, NULL);
@@ -759,8 +758,13 @@ void fc_lport_set_local_id(struct fc_lport *lport, u32 port_id)
 	switch (lport->state) {
 	case LPORT_ST_RESET:
 	case LPORT_ST_FLOGI:
-		if (port_id)
+		if (port_id) {
+			mutex_lock(&fcport->lock);
+			fc_vport_add(lport->fcfabric, fcvport);
+			mutex_unlock(&fcport->lock);
+
 			fc_lport_enter_ready(lport);
+		}
 		break;
 	default:
 		break;
@@ -784,6 +788,7 @@ EXPORT_SYMBOL(fc_lport_set_local_id);
 static void fc_lport_recv_flogi_req(struct fc_lport *lport,
 				    struct fc_frame *rx_fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_frame *fp;
 	struct fc_frame_header *fh;
 	struct fc_els_flogi *flp;
@@ -800,10 +805,10 @@ static void fc_lport_recv_flogi_req(struct fc_lport *lport,
 	if (!flp)
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
-	if (remote_wwpn == lport->wwpn) {
-		printk(KERN_WARNING "host%d: libfc: Received FLOGI from port "
-		       "with same WWPN %16.16llx\n",
-		       lport->host->host_no, remote_wwpn);
+	if (remote_wwpn == fc_vport_port_name(fcvport)) {
+		printk(KERN_WARNING "fcport%u: libfc: Received FLOGI from port "
+		       "with same WWPN %llx\n",
+		       fc_port_id(lport->fcport), remote_wwpn);
 		goto out;
 	}
 	FC_LPORT_DBG(lport, "FLOGI from port WWPN %16.16llx\n", remote_wwpn);
@@ -814,7 +819,7 @@ static void fc_lport_recv_flogi_req(struct fc_lport *lport,
 	 * But if so, both of us could end up with the same FID.
 	 */
 	local_fid = FC_LOCAL_PTP_FID_LO;
-	if (remote_wwpn < lport->wwpn) {
+	if (remote_wwpn < fc_vport_port_name(fcvport)) {
 		local_fid = FC_LOCAL_PTP_FID_HI;
 		if (!remote_fid || remote_fid == local_fid)
 			remote_fid = FC_LOCAL_PTP_FID_LO;
@@ -997,7 +1002,6 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	lport->tt.disc_stop(lport);
 
 	lport->tt.exch_mgr_reset(lport, 0, 0);
-	fc_host_fabric_name(lport->host) = 0;
 
 	if (lport->port_id && (!lport->point_to_multipoint || !lport->link_up))
 		fc_lport_set_port_id(lport, 0, NULL);
@@ -1012,21 +1016,26 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
  */
 static void fc_lport_enter_reset(struct fc_lport *lport)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
+
 	FC_LPORT_DBG(lport, "Entered RESET state from %s state\n",
 		     fc_lport_state(lport));
 
 	if (lport->state == LPORT_ST_DISABLED || lport->state == LPORT_ST_LOGO)
 		return;
 
-	if (lport->vport) {
+	if (!fc_vport_is_nport(fcvport)) {
 		if (lport->link_up)
-			fc_vport_set_state(lport->vport, FC_VPORT_INITIALIZING);
+			fc_vport_set_state(fcvport,
+					   FC_VPORT_INITIALIZING);
 		else
-			fc_vport_set_state(lport->vport, FC_VPORT_LINKDOWN);
+			fc_vport_set_state(fcvport,
+					   FC_VPORT_LINKDOWN);
 	}
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
 	fc_vports_linkchange(lport);
 	fc_lport_reset_locked(lport);
+
 	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
 }
@@ -1242,6 +1251,7 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
  */
 static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_frame *fp;
 	enum fc_ns_req cmd;
 	int size = sizeof(struct fc_ct_hdr);
@@ -1259,7 +1269,7 @@ static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 		size += sizeof(struct fc_ns_rn_id);
 		break;
 	case LPORT_ST_RSNN_NN:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fc_vport_symbolic_name(fcvport), 255);
 		/* if there is no symbolic name, skip to RFT_ID */
 		if (!len)
 			return fc_lport_enter_ns(lport, LPORT_ST_RFT_ID);
@@ -1267,7 +1277,7 @@ static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 		size += sizeof(struct fc_ns_rsnn) + len;
 		break;
 	case LPORT_ST_RSPN_ID:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fc_vport_symbolic_name(fcvport), 255);
 		/* if there is no symbolic name, skip to RFT_ID */
 		if (!len)
 			return fc_lport_enter_ns(lport, LPORT_ST_RFT_ID);
@@ -1436,6 +1446,8 @@ EXPORT_SYMBOL(fc_lport_logo_resp);
  */
 static void fc_lport_enter_logo(struct fc_lport *lport)
 {
+	struct fc_port *fcport = lport->fcport;
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_frame *fp;
 	struct fc_els_logo *logo;
 
@@ -1455,6 +1467,10 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 				  fc_lport_logo_resp, lport,
 				  2 * lport->r_a_tov))
 		fc_lport_error(lport, NULL);
+
+	mutex_lock(&fcport->lock);
+	fc_vport_del(fcvport);
+	mutex_unlock(&fcport->lock);
 }
 
 /**
@@ -1471,6 +1487,8 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			 void *lp_arg)
 {
 	struct fc_lport *lport = lp_arg;
+	struct fc_port *fcport = lport->fcport;
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_flogi *flp;
 	u32 did;
 	u16 csp_flags;
@@ -1478,8 +1496,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int e_d_tov;
 	u16 mfs;
 
-	FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc_els_resp_type(fp));
-
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
@@ -1520,10 +1536,12 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
 				fc_lport_set_port_id(lport, did, fp);
-				printk(KERN_INFO "host%d: libfc: "
+
+				printk(KERN_INFO "fcvport%d: libfc: "
 				       "Port (%6.6x) entered "
 				       "point-to-point mode\n",
-				       lport->host->host_no, did);
+				       fcvport->id, did);
+
 				fc_lport_ptp_setup(lport, fc_frame_sid(fp),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
@@ -1532,9 +1550,13 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			} else {
 				lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = r_a_tov;
-				fc_host_fabric_name(lport->host) =
-					get_unaligned_be64(&flp->fl_wwnn);
+
 				fc_lport_set_port_id(lport, did, fp);
+
+				mutex_lock(&fcport->lock);
+				fc_vport_add(lport->fcfabric, fcvport);
+				mutex_unlock(&fcport->lock);
+
 				fc_lport_enter_dns(lport);
 			}
 		}
@@ -1559,6 +1581,7 @@ EXPORT_SYMBOL(fc_lport_flogi_resp);
  */
 void fc_lport_enter_flogi(struct fc_lport *lport)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_frame *fp;
 
 	FC_LPORT_DBG(lport, "Entered FLOGI state from %s state\n",
@@ -1577,10 +1600,11 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 		return fc_lport_error(lport, fp);
 
 	if (!lport->tt.elsct_send(lport, FC_FID_FLOGI, fp,
-				  lport->vport ? ELS_FDISC : ELS_FLOGI,
+				  fc_vport_is_nport(fcvport) ?
+				  ELS_FLOGI : ELS_FDISC,
 				  fc_lport_flogi_resp, lport,
-				  lport->vport ? 2 * lport->r_a_tov :
-				  lport->e_d_tov))
+				  fc_vport_is_nport(fcvport) ?
+				  lport->e_d_tov : 2 * lport->r_a_tov))
 		fc_lport_error(lport, NULL);
 }
 
@@ -1604,6 +1628,26 @@ int fc_lport_config(struct fc_lport *lport)
 }
 EXPORT_SYMBOL(fc_lport_config);
 
+void fc_lport_port_config(struct fc_port *fcport)
+{
+	fc_port_supported_fc4s(fcport)[2] = 1;
+	fc_port_supported_fc4s(fcport)[7] = 1;
+	fc_port_active_fc4s(fcport)[2] = 1;
+	fc_port_active_fc4s(fcport)[7] = 1;
+
+	fc_port_supported_classes(fcport) = FC_COS_CLASS3;
+	memset(fcport->supported_fc4s, 0,
+	       sizeof(fcport->supported_fc4s));
+	fcport->supported_fc4s[2] = 1;
+	fcport->supported_fc4s[7] = 1;
+
+	memset(fcport->active_fc4s, 0,
+	       sizeof(fcport->active_fc4s));
+	fcport->active_fc4s[2] = 1;
+	fcport->active_fc4s[7] = 1;
+}
+EXPORT_SYMBOL(fc_lport_port_config);
+
 /**
  * fc_lport_init() - Initialize the lport layer for a local port
  * @lport: The local port to initialize the exchange layer for
@@ -1616,26 +1660,6 @@ int fc_lport_init(struct fc_lport *lport)
 	if (!lport->tt.lport_reset)
 		lport->tt.lport_reset = fc_lport_reset;
 
-	fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
-	fc_host_node_name(lport->host) = lport->wwnn;
-	fc_host_port_name(lport->host) = lport->wwpn;
-	fc_host_supported_classes(lport->host) = FC_COS_CLASS3;
-	memset(fc_host_supported_fc4s(lport->host), 0,
-	       sizeof(fc_host_supported_fc4s(lport->host)));
-	fc_host_supported_fc4s(lport->host)[2] = 1;
-	fc_host_supported_fc4s(lport->host)[7] = 1;
-
-	/* This value is also unchanging */
-	memset(fc_host_active_fc4s(lport->host), 0,
-	       sizeof(fc_host_active_fc4s(lport->host)));
-	fc_host_active_fc4s(lport->host)[2] = 1;
-	fc_host_active_fc4s(lport->host)[7] = 1;
-	fc_host_maxframe_size(lport->host) = lport->mfs;
-	fc_host_supported_speeds(lport->host) = 0;
-	if (lport->link_supported_speeds & FC_PORTSPEED_1GBIT)
-		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_1GBIT;
-	if (lport->link_supported_speeds & FC_PORTSPEED_10GBIT)
-		fc_host_supported_speeds(lport->host) |= FC_PORTSPEED_10GBIT;
 	fc_fc4_add_lport(lport);
 
 	return 0;
@@ -1652,7 +1676,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			      void *info_arg)
 {
 	struct fc_bsg_info *info = info_arg;
-	struct fc_bsg_job *job = info->job;
+	struct fcp_bsg_job *job = info->job;
 	struct fc_lport *lport = info->lport;
 	struct fc_frame_header *fh;
 	size_t len;
@@ -1714,7 +1738,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_els_request(struct fc_bsg_job *job,
+static int fc_lport_els_request(struct fcp_bsg_job *job,
 				struct fc_lport *lport,
 				u32 did, u32 tov)
 {
@@ -1775,7 +1799,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
  * Locking Note: The lport lock is expected to be held before calling
  * this routine.
  */
-static int fc_lport_ct_request(struct fc_bsg_job *job,
+static int fc_lport_ct_request(struct fcp_bsg_job *job,
 			       struct fc_lport *lport, u32 did, u32 tov)
 {
 	struct fc_bsg_info *info;
@@ -1831,7 +1855,7 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
  *			    FC Passthrough requests
  * @job: The BSG passthrough job
  */
-int fc_lport_bsg_request(struct fc_bsg_job *job)
+int fc_lport_bsg_request(struct fcp_bsg_job *job)
 {
 	struct request *rsp = job->req->next_rq;
 	struct Scsi_Host *shost = job->shost;
diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index f33b897..24f81dd 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -24,31 +24,21 @@
 #include <scsi/libfc.h>
 
 /**
- * fc_vport_create() - Create a new NPIV vport instance
+ * fc_vport_config() - Configure a new vport
  * @vport: fc_vport structure from scsi_transport_fc
  * @privsize: driver private data size to allocate along with the Scsi_Host
  */
-
-struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
+int libfc_vport_config(struct fc_lport *n_port, struct fc_lport *vn_port,
+		       struct fc_vport *vport)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fc_lport *vn_port;
-
-	vn_port = libfc_host_alloc(shost->hostt, privsize);
-	if (!vn_port)
-		return vn_port;
+	if (fc_exch_mgr_list_clone(n_port, vn_port))
+		return -ENOMEM;
 
-	vn_port->vport = vport;
-	vport->dd_data = vn_port;
+	vn_port->fcport = n_port->fcport;
 
-	mutex_lock(&n_port->lp_mutex);
-	list_add_tail(&vn_port->list, &n_port->vports);
-	mutex_unlock(&n_port->lp_mutex);
-
-	return vn_port;
+	return 0;
 }
-EXPORT_SYMBOL(libfc_vport_create);
+EXPORT_SYMBOL(libfc_vport_config);
 
 /**
  * fc_vport_id_lookup() - find NPIV lport that matches a given fabric ID
@@ -59,8 +49,9 @@ EXPORT_SYMBOL(libfc_vport_create);
  */
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *n_port, u32 port_id)
 {
-	struct fc_lport *lport = NULL;
-	struct fc_lport *vn_port;
+	struct fc_vport *fcvport = lport_to_fcvport(n_port);
+	struct fc_fabric *fcfabric = fcvport_to_fcfabric(fcvport);
+	struct fc_vport *fcvnport;
 
 	if (n_port->port_id == port_id)
 		return n_port;
@@ -68,16 +59,19 @@ struct fc_lport *fc_vport_id_lookup(struct fc_lport *n_port, u32 port_id)
 	if (port_id == FC_FID_FLOGI)
 		return n_port;		/* for point-to-point */
 
-	mutex_lock(&n_port->lp_mutex);
-	list_for_each_entry(vn_port, &n_port->vports, list) {
-		if (vn_port->port_id == port_id) {
-			lport = vn_port;
-			break;
-		}
-	}
-	mutex_unlock(&n_port->lp_mutex);
+	/*
+	 * If there isn't a fabric then this is the N_Port. We
+	 * haven't discovered a switch, haven't logged in and
+	 * don't have any NPIV ports.
+	 */
+	if (!fcfabric)
+		return NULL;
 
-	return lport;
+	fcvnport = fc_vport_lookup(fcfabric, port_id);
+	if (fcvnport)
+		return fc_vport_priv(fcvnport);
+
+	return NULL;
 }
 EXPORT_SYMBOL(fc_vport_id_lookup);
 
@@ -102,7 +96,7 @@ enum libfc_lport_mutex_class {
 static void __fc_vport_setlink(struct fc_lport *n_port,
 			       struct fc_lport *vn_port)
 {
-	struct fc_vport *vport = vn_port->vport;
+	struct fc_vport *vport = lport_to_fcvport(vn_port);
 
 	if (vn_port->state == LPORT_ST_DISABLED)
 		return;
@@ -127,9 +121,9 @@ static void __fc_vport_setlink(struct fc_lport *n_port,
  */
 void fc_vport_setlink(struct fc_lport *vn_port)
 {
-	struct fc_vport *vport = vn_port->vport;
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
+	struct fc_vport *fcvport = lport_to_fcvport(vn_port);
+	struct fc_vport *fcnport = fcvport->fcnport;
+	struct fc_lport *n_port = fc_vport_priv(fcnport);
 
 	mutex_lock(&n_port->lp_mutex);
 	mutex_lock_nested(&vn_port->lp_mutex, LPORT_MUTEX_VN_PORT);
@@ -147,12 +141,37 @@ EXPORT_SYMBOL(fc_vport_setlink);
  */
 void fc_vports_linkchange(struct fc_lport *n_port)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(n_port);
+	struct fc_fabric *fcfabric = fcvport->fcfabric;
+	struct fc_port *fcport;
+	struct fc_vport *vport;
 	struct fc_lport *vn_port;
 
-	list_for_each_entry(vn_port, &n_port->vports, list) {
+	/*
+	 * If this isn't the N_Port then there are no
+	 * NPIV portst to update.
+	 */
+	if (!fc_vport_is_nport(fcvport))
+		return;
+
+	/*
+	 * If there isn't a fabric then this is the N_Port. We
+	 * haven't discovered a switch, haven't logged in and
+	 * don't have any NPIV ports whose link states need
+	 * to be updated.
+	 */
+	if (!fcfabric)
+		return;
+
+	fcport = fcfabric_to_fcport(fcfabric);
+
+	mutex_lock(&fcport->lock);
+	list_for_each_entry(vport, &fcfabric->vports, peers) {
+		vn_port = fc_vport_priv(vport);
 		mutex_lock_nested(&vn_port->lp_mutex, LPORT_MUTEX_VN_PORT);
 		__fc_vport_setlink(n_port, vn_port);
 		mutex_unlock(&vn_port->lp_mutex);
 	}
+	mutex_unlock(&fcport->lock);
 }
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 49e1ccc..c09fc9a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -256,6 +256,7 @@ static void fc_rport_work(struct work_struct *work)
 	struct fc_rport_libfc_priv *rpriv;
 	enum fc_rport_event event;
 	struct fc_lport *lport = rdata->local_port;
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_rport_operations *rport_ops;
 	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
@@ -278,7 +279,7 @@ static void fc_rport_work(struct work_struct *work)
 		mutex_unlock(&rdata->rp_mutex);
 
 		if (!rport)
-			rport = fc_remote_port_add(lport->host, 0, &ids);
+			rport = fc_rport_add(fcvport, &ids);
 		if (!rport) {
 			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
 			lport->tt.rport_logoff(rdata);
@@ -293,11 +294,11 @@ static void fc_rport_work(struct work_struct *work)
 		rport->supported_classes = rdata->supported_classes;
 
 		rpriv = rport->dd_data;
-		rpriv->local_port = lport;
 		rpriv->rp_state = rdata->rp_state;
 		rpriv->flags = rdata->flags;
 		rpriv->e_d_tov = rdata->e_d_tov;
 		rpriv->r_a_tov = rdata->r_a_tov;
+		rpriv->local_port = lport;
 		mutex_unlock(&rdata->rp_mutex);
 
 		if (rport_ops && rport_ops->event_callback) {
@@ -348,7 +349,7 @@ static void fc_rport_work(struct work_struct *work)
 			mutex_lock(&rdata->rp_mutex);
 			rdata->rport = NULL;
 			mutex_unlock(&rdata->rp_mutex);
-			fc_remote_port_delete(rport);
+			fc_rport_del(rport);
 		}
 
 		mutex_lock(&lport->disc.disc_mutex);
@@ -1102,7 +1103,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 	}
 
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rdata->ids.port_id,
-		       fc_host_port_id(lport->host), FC_TYPE_ELS,
+		       lport->port_id, FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
 	if (!lport->tt.exch_seq_send(lport, fp, fc_rport_prli_resp,
@@ -1387,12 +1388,13 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 
 {
 	struct fc_lport *lport = rdata->local_port;
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	struct fc_frame *fp;
 	struct fc_els_rls *rls;
 	struct fc_els_rls_resp *rsp;
 	struct fc_els_lesb *lesb;
 	struct fc_seq_els_data rjt_data;
-	struct fc_host_statistics *hst;
+	struct fcp_init_statistics *hst;
 
 	FC_RPORT_DBG(rdata, "Received RLS request while in state %s\n",
 		     fc_rport_state(rdata));
@@ -1419,8 +1421,8 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 		/* get LESB from LLD if it supports it */
 		lport->tt.get_lesb(lport, lesb);
 	} else {
-		fc_get_host_stats(lport->host);
-		hst = &lport->host_stats;
+		fc_get_fcpinit_stats(lport->fcpinit);
+		hst = &si->fcpinit_stats;
 		lesb->lesb_link_fail = htonl(hst->link_failure_count);
 		lesb->lesb_sync_loss = htonl(hst->loss_of_sync_count);
 		lesb->lesb_sig_loss = htonl(hst->loss_of_signal_count);
@@ -1564,6 +1566,7 @@ void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 				    struct fc_frame *rx_fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_disc *disc;
 	struct fc_rport_priv *rdata;
 	struct fc_frame *fp = rx_fp;
@@ -1619,7 +1622,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		break;
 	case RPORT_ST_PLOGI:
 		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state\n");
-		if (rdata->ids.port_name < lport->wwpn) {
+		if (rdata->ids.port_name < fc_vport_port_name(fcvport)) {
 			mutex_unlock(&rdata->rp_mutex);
 			rjt_data.reason = ELS_RJT_INPROG;
 			rjt_data.explan = ELS_EXPL_NONE;
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index be418d8..5fb5bdc 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -82,13 +82,16 @@ static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
  */
 static inline void fc_adisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_adisc *adisc;
 
 	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
 	memset(adisc, 0, sizeof(*adisc));
 	adisc->adisc_cmd = ELS_ADISC;
-	put_unaligned_be64(lport->wwpn, &adisc->adisc_wwpn);
-	put_unaligned_be64(lport->wwnn, &adisc->adisc_wwnn);
+	put_unaligned_be64(fc_vport_port_name(fcvport),
+			   &adisc->adisc_wwpn);
+	put_unaligned_be64(fc_vport_node_name(fcvport),
+			   &adisc->adisc_wwnn);
 	hton24(adisc->adisc_port_id, lport->port_id);
 }
 
@@ -126,6 +129,7 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 		      unsigned int op, enum fc_rctl *r_ctl,
 		      enum fc_fh_type *fh_type)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_ct_req *ct;
 	size_t len;
 
@@ -159,24 +163,26 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 	case FC_NS_RNN_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rn_id));
 		hton24(ct->payload.rn.fr_fid.fp_fid, lport->port_id);
-		put_unaligned_be64(lport->wwnn, &ct->payload.rn.fr_wwn);
+		put_unaligned_be64(fc_vport_node_name(fcvport),
+				   &ct->payload.rn.fr_wwn);
 		break;
 
 	case FC_NS_RSPN_ID:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fc_vport_symbolic_name(fcvport), 255);
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rspn) + len);
 		hton24(ct->payload.spn.fr_fid.fp_fid, lport->port_id);
 		strncpy(ct->payload.spn.fr_name,
-			fc_host_symbolic_name(lport->host), len);
+			fc_vport_symbolic_name(fcvport), len);
 		ct->payload.spn.fr_name_len = len;
 		break;
 
 	case FC_NS_RSNN_NN:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fc_vport_symbolic_name(fcvport), 255);
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rsnn) + len);
-		put_unaligned_be64(lport->wwnn, &ct->payload.snn.fr_wwn);
+		put_unaligned_be64(fc_vport_node_name(fcvport),
+				   &ct->payload.snn.fr_wwn);
 		strncpy(ct->payload.snn.fr_name,
-			fc_host_symbolic_name(lport->host), len);
+			fc_vport_symbolic_name(fcvport), len);
 		ct->payload.snn.fr_name_len = len;
 		break;
 
@@ -194,6 +200,7 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 static inline void fc_plogi_fill(struct fc_lport *lport, struct fc_frame *fp,
 				 unsigned int op)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_flogi *plogi;
 	struct fc_els_csp *csp;
 	struct fc_els_cssp *cp;
@@ -201,8 +208,8 @@ static inline void fc_plogi_fill(struct fc_lport *lport, struct fc_frame *fp,
 	plogi = fc_frame_payload_get(fp, sizeof(*plogi));
 	memset(plogi, 0, sizeof(*plogi));
 	plogi->fl_cmd = (u8) op;
-	put_unaligned_be64(lport->wwpn, &plogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &plogi->fl_wwnn);
+	put_unaligned_be64(fc_vport_port_name(fcvport), &plogi->fl_wwpn);
+	put_unaligned_be64(fc_vport_node_name(fcvport), &plogi->fl_wwnn);
 
 	csp = &plogi->fl_csp;
 	csp->sp_hi_ver = 0x20;
@@ -226,6 +233,7 @@ static inline void fc_plogi_fill(struct fc_lport *lport, struct fc_frame *fp,
  */
 static inline void fc_flogi_fill(struct fc_lport *lport, struct fc_frame *fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_csp *sp;
 	struct fc_els_cssp *cp;
 	struct fc_els_flogi *flogi;
@@ -233,8 +241,8 @@ static inline void fc_flogi_fill(struct fc_lport *lport, struct fc_frame *fp)
 	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) ELS_FLOGI;
-	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	put_unaligned_be64(fc_vport_port_name(fcvport), &flogi->fl_wwpn);
+	put_unaligned_be64(fc_vport_node_name(fcvport), &flogi->fl_wwnn);
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -251,6 +259,7 @@ static inline void fc_flogi_fill(struct fc_lport *lport, struct fc_frame *fp)
  */
 static inline void fc_fdisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_csp *sp;
 	struct fc_els_cssp *cp;
 	struct fc_els_flogi *fdisc;
@@ -258,8 +267,8 @@ static inline void fc_fdisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 	fdisc = fc_frame_payload_get(fp, sizeof(*fdisc));
 	memset(fdisc, 0, sizeof(*fdisc));
 	fdisc->fl_cmd = (u8) ELS_FDISC;
-	put_unaligned_be64(lport->wwpn, &fdisc->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &fdisc->fl_wwnn);
+	put_unaligned_be64(fc_vport_port_name(fcvport), &fdisc->fl_wwpn);
+	put_unaligned_be64(fc_vport_node_name(fcvport), &fdisc->fl_wwnn);
 	sp = &fdisc->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -274,13 +283,14 @@ static inline void fc_fdisc_fill(struct fc_lport *lport, struct fc_frame *fp)
  */
 static inline void fc_logo_fill(struct fc_lport *lport, struct fc_frame *fp)
 {
+	struct fc_vport *fcvport = lport_to_fcvport(lport);
 	struct fc_els_logo *logo;
 
 	logo = fc_frame_payload_get(fp, sizeof(*logo));
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
 	hton24(logo->fl_n_port_id, lport->port_id);
-	logo->fl_n_port_wwn = htonll(lport->wwpn);
+	logo->fl_n_port_wwn = htonll(fc_vport_port_name(fcvport));
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 24193c1..1086568 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -24,8 +24,9 @@
 #include <linux/if.h>
 #include <linux/percpu.h>
 
+#include <fc/fc.h>
 #include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_transport_fcp.h>
 #include <scsi/scsi_bsg_fc.h>
 
 #include <scsi/fc/fc_fcp.h>
@@ -37,6 +38,9 @@
 
 #define	FC_FC4_PROV_SIZE	(FC_TYPE_FCP + 1)	/* size of tables */
 
+#define fcpinit_to_lport(x)						\
+	fc_vport_priv((struct fc_vport *)(fcpinit_to_fcvport(x)))
+
 /*
  * libfc error codes
  */
@@ -133,6 +137,7 @@ enum fc_rport_event {
 };
 
 struct fc_rport_priv;
+struct fc_fcp_internal;
 
 /**
  * struct fc_rport_operations - Operations for a remote port
@@ -800,7 +805,6 @@ enum fc_lport_event {
  * @ema_list:              Exchange manager anchor list
  * @dns_rdata:             The directory server remote port
  * @ptp_rdata:             Point to point remote port
- * @scsi_priv:             FCP layer internal data
  * @disc:                  Discovery context
  * @vports:                Child vports if N_Port
  * @vport:                 Parent vport if VN_Port
@@ -834,22 +838,18 @@ enum fc_lport_event {
  * @lso_max:               The maximum large offload send size
  * @fcts:                  FC-4 type mask
  * @lp_mutex:              Mutex to protect the local port
- * @list:                  Linkage on list of vport peers
  * @retry_work:            Handle to local port for delayed retry context
  * @prov:		   Pointers available for use by passive FC-4 providers
  * @lport_list:            Linkage on module-wide list of local ports
  */
 struct fc_lport {
 	/* Associations */
-	struct Scsi_Host	       *host;
 	struct list_head	       ema_list;
 	struct fc_rport_priv	       *dns_rdata;
 	struct fc_rport_priv	       *ptp_rdata;
-	void			       *scsi_priv;
 	struct fc_disc                 disc;
 
 	/* Virtual port information */
-	struct list_head	       vports;
 	struct fc_vport		       *vport;
 
 	/* Operational Information */
@@ -858,7 +858,6 @@ struct fc_lport {
 	u8			       qfull;
 	enum fc_lport_state	       state;
 	unsigned long		       boot_time;
-	struct fc_host_statistics      host_stats;
 	struct fcoe_dev_stats	       *dev_stats;
 	u8			       retry_count;
 
@@ -866,6 +865,7 @@ struct fc_lport {
 	u32                            port_id;
 	u64			       wwpn;
 	u64			       wwnn;
+
 	unsigned int		       service_params;
 	unsigned int		       e_d_tov;
 	unsigned int		       r_a_tov;
@@ -883,20 +883,56 @@ struct fc_lport {
 	u8			       max_retry_count;
 	u8			       max_rport_retry_count;
 	u16			       rport_priv_size;
-	u16			       link_speed;
-	u16			       link_supported_speeds;
 	u16			       lro_xid;
 	unsigned int		       lso_max;
 	struct fc_ns_fts	       fcts;
 
+	/* sysfs representation */
+	struct fc_port               *fcport;
+	struct fc_fabric             *fcfabric;
+	struct fcp_init              *fcpinit;
+
 	/* Miscellaneous */
 	struct mutex                   lp_mutex;
-	struct list_head               list;
 	struct delayed_work	       retry_work;
 	void			       *prov[FC_FC4_PROV_SIZE];
 	struct list_head               lport_list;
 };
 
+#define lport_to_fcvport(lport)					\
+	((struct fc_vport *)(((struct fc_vport *)(lport)) - 1))
+
+/**
+ * struct fc_fcp_internal - FCP layer internal data
+ * @scsi_pkt_pool:  Memory pool to draw FCP packets from
+ * @scsi_pkt_queue: Current FCP packets
+ * @last_can_queue_ramp_down_time: ramp down time
+ * @last_can_queue_ramp_up_time: ramp up time
+ * @max_can_queue: max can_queue size
+ */
+struct fc_fcp_internal {
+	mempool_t	 *scsi_pkt_pool;
+	struct list_head scsi_pkt_queue;
+	spinlock_t       scsi_queue_lock;
+	unsigned long last_can_queue_ramp_down_time;
+	unsigned long last_can_queue_ramp_up_time;
+	int max_can_queue;
+
+	/* Associations */
+	struct fc_lport                *lport;
+	struct Scsi_Host	       *host;
+
+	/* Operational Information */
+	struct fcp_init_statistics      fcpinit_stats;
+};
+
+/*
+ * TODO: This is really horrible, can this be removed?
+ */
+#define fc_get_scsi_internal(x)						\
+	((struct fc_fcp_internal *)(fcp_init_priv(			\
+			    fcvport_to_fcpinit(lport_to_fcvport(x)))))
+
 /**
  * struct fc4_prov - FC-4 provider registration
  * @prli:               Handler for incoming PRLI
@@ -995,30 +1031,6 @@ static inline void *lport_priv(const struct fc_lport *lport)
 	return (void *)(lport + 1);
 }
 
-/**
- * libfc_host_alloc() - Allocate a Scsi_Host with room for a local port and
- *                      LLD private data
- * @sht:       The SCSI host template
- * @priv_size: Size of private data
- *
- * Returns: libfc lport
- */
-static inline struct fc_lport *
-libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
-{
-	struct fc_lport *lport;
-	struct Scsi_Host *shost;
-
-	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
-	if (!shost)
-		return NULL;
-	lport = shost_priv(shost);
-	lport->host = shost;
-	INIT_LIST_HEAD(&lport->ema_list);
-	INIT_LIST_HEAD(&lport->vports);
-	return lport;
-}
-
 /*
  * FC_FCP HELPER FUNCTIONS
  *****************************/
@@ -1045,9 +1057,10 @@ void fc_vports_linkchange(struct fc_lport *);
 int fc_lport_config(struct fc_lport *);
 int fc_lport_reset(struct fc_lport *);
 int fc_set_mfs(struct fc_lport *, u32 mfs);
-struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
+int libfc_vport_config(struct fc_lport *n_port, struct fc_lport *vn_port,
+		       struct fc_vport *);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
-int fc_lport_bsg_request(struct fc_bsg_job *);
+int fc_lport_bsg_request(struct fcp_bsg_job *);
 void fc_lport_set_local_id(struct fc_lport *, u32 port_id);
 void fc_lport_iterate(void (*func)(struct fc_lport *, void *), void *);
 
@@ -1070,7 +1083,7 @@ static inline struct fc_lport *fc_disc_lport(struct fc_disc *disc)
 /*
  * FCP LAYER
  *****************************/
-int fc_fcp_init(struct fc_lport *);
+int fc_fcp_init(struct fcp_init *);
 void fc_fcp_destroy(struct fc_lport *);
 
 /*
@@ -1122,9 +1135,11 @@ void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 /*
  * Functions for fc_functions_template
  */
-void fc_get_host_speed(struct Scsi_Host *);
-void fc_get_host_port_state(struct Scsi_Host *);
+void fc_get_fcvport_port_state(struct fc_vport *);
 void fc_set_rport_loss_tmo(struct fc_rport *, u32 timeout);
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *);
+struct fcp_init_statistics *fc_get_fcpinit_stats(struct fcp_init *);
+
+
+void fc_lport_port_config(struct fc_port *fcport);
 
 #endif /* _LIBFC_H_ */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 8c1638b..9dc119f 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -88,7 +88,6 @@ enum fip_state {
  * @mode:	   LLD-selected mode.
  * @lp:		   &fc_lport: libfc local port.
  * @sel_fcf:	   currently selected FCF, or NULL.
- * @fcfs:	   list of discovered FCFs.
  * @fcf_count:	   number of discovered FCF entries.
  * @sol_time:	   time when a multicast solicitation was last sent.
  * @sel_time:	   time after which to select an FCF.
@@ -113,7 +112,6 @@ enum fip_state {
  * @send:	   LLD-supplied function to handle sending FIP Ethernet frames
  * @update_mac:    LLD-supplied function to handle changes to MAC addresses.
  * @get_src_addr:  LLD-supplied function to supply a source MAC address.
- * @ctlr_mutex:	   lock protecting this structure.
  * @ctlr_lock:     spinlock covering flogi_req
  *
  * This structure is used by all FCoE drivers.  It contains information
@@ -125,7 +123,6 @@ struct fcoe_ctlr {
 	enum fip_state mode;
 	struct fc_lport *lp;
 	struct fcoe_fcf *sel_fcf;
-	struct list_head fcfs;
 	u16 fcf_count;
 	unsigned long sol_time;
 	unsigned long sel_time;
@@ -150,16 +147,19 @@ struct fcoe_ctlr {
 	u8 dest_addr[ETH_ALEN];
 	u8 ctl_src_addr[ETH_ALEN];
 
+	struct fc_fabric_function_template *fcfabric_f;
+
 	void (*send)(struct fcoe_ctlr *, struct sk_buff *);
 	void (*update_mac)(struct fc_lport *, u8 *addr);
 	u8 * (*get_src_addr)(struct fc_lport *);
-	struct mutex ctlr_mutex;
+
 	spinlock_t ctlr_lock;
 };
 
+
+
 /**
  * struct fcoe_fcf - Fibre-Channel Forwarder
- * @list:	 list linkage
  * @time:	 system time (jiffies) when an advertisement was last received
  * @switch_name: WWN of switch from advertisement
  * @fabric_name: WWN of fabric from advertisement
@@ -179,7 +179,6 @@ struct fcoe_ctlr {
  * @fcf_mac together form the lookup key.
  */
 struct fcoe_fcf {
-	struct list_head list;
 	unsigned long time;
 
 	u64 switch_name;
@@ -195,6 +194,9 @@ struct fcoe_fcf {
 	u8 fd_flags:1;
 };
 
+#define fcf_to_fabric(fcf)					\
+	((struct fc_fabric *)(((struct fc_fabric *)(fcf)) - 1))
+
 /**
  * struct fcoe_rport - VN2VN remote port
  * @time:	time of create or last beacon packet received from node
@@ -226,9 +228,10 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 /* libfcoe funcs */
 u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
-		      const struct libfc_function_template *, int init_fcp);
+		      const struct libfc_function_template *);
 u32 fcoe_fc_crc(struct fc_frame *fp);
 int fcoe_start_io(struct sk_buff *skb);
+int fcoe_fcf_match(struct fc_fabric *, struct fc_fabric *);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.
@@ -238,7 +241,6 @@ static inline bool is_fip_mode(struct fcoe_ctlr *fip)
 {
 	return fip->state == FIP_ST_ENABLED;
 }
-
 /* helper for FCoE SW HBA drivers, can include subven and subdev if needed. The
  * modpost would use pci_device_id table to auto-generate formatted module alias
  * into the corresponding .mod.c file, but there may or may not be a pci device

