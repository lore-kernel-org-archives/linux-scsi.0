From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 3/3] libfc, libfcoe, fcoe: Make use of FC subsystem
Date: Wed, 12 May 2010 13:20:20 -0700
Message-ID: <20100512202020.27512.36234.stgit@localhost.localdomain>
References: <20100512202003.27512.34851.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab0ELUUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 16:20:22 -0400
In-Reply-To: <20100512202003.27512.34851.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, hare@suse.de, christof.schmitt@de.ibm.com, james.bottomley@suse.de

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
structures is illustrated here: http://open-fcoe.org/rwlove/libfc_alloc.jpg

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig          |    1 
 drivers/scsi/fcoe/fcoe.c      |  619 ++++++++++++++++++++++++-----------------
 drivers/scsi/fcoe/libfcoe.c   |  167 +++++++++--
 drivers/scsi/libfc/fc_disc.c  |    4 
 drivers/scsi/libfc/fc_exch.c  |    2 
 drivers/scsi/libfc/fc_fcp.c   |  130 ++++-----
 drivers/scsi/libfc/fc_libfc.h |   28 +-
 drivers/scsi/libfc/fc_lport.c |  195 +++++++------
 drivers/scsi/libfc/fc_npiv.c  |   44 +--
 drivers/scsi/libfc/fc_rport.c |   15 +
 include/scsi/fc_encode.h      |   34 +-
 include/scsi/libfc.h          |  119 ++++----
 include/scsi/libfcoe.h        |   17 +
 13 files changed, 812 insertions(+), 563 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f0e56ce..54ef2c7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -682,6 +682,7 @@ config LIBFCOE
 config FCOE
 	tristate "FCoE module"
 	depends on PCI
+	select SCSI_FCP_ATTRS
 	select LIBFCOE
 	---help---
 	  Fibre Channel over Ethernet module
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ba75a98..02ea681 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -33,14 +33,13 @@
 #include <linux/ctype.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
 #include <net/rtnetlink.h>
 
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fip.h>
 
 #include <scsi/libfc.h>
+#include <fc/fc.h>
 #include <scsi/fc_frame.h>
 #include <scsi/libfcoe.h>
 
@@ -67,7 +66,7 @@ LIST_HEAD(fcoe_hostlist);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
 /* Function Prototypes */
-static int fcoe_reset(struct Scsi_Host *);
+static int fcoe_reset(struct fc_fcvport *);
 static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
 static int fcoe_rcv(struct sk_buff *, struct net_device *,
 		    struct packet_type *, struct net_device *);
@@ -116,6 +115,12 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 static void fcoe_recv_frame(struct sk_buff *skb);
 
 static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
+static void fcoe_set_symbolic_name(struct fc_lport *);
+static void fcoe_set_node_name(struct fc_lport *);
+static void fcoe_set_port_name(struct fc_lport *);
+static void fcoe_get_vport_ids(struct fc_lport *lport,
+			       struct fc_vport_identifiers *ids);
+
 
 module_param_call(create, fcoe_create, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
@@ -140,15 +145,43 @@ static struct notifier_block fcoe_cpu_notifier = {
 	.notifier_call = fcoe_cpu_callback,
 };
 
-static struct scsi_transport_template *fcoe_transport_template;
-static struct scsi_transport_template *fcoe_vport_transport_template;
-
-static int fcoe_vport_destroy(struct fc_vport *);
-static int fcoe_vport_create(struct fc_vport *, bool disabled);
-static int fcoe_vport_disable(struct fc_vport *, bool disable);
-static void fcoe_set_vport_symbolic_name(struct fc_vport *);
+static int fcoe_vport_destroy(void *, struct fc_fcvport *);
+static int fcoe_vport_create(void *, struct fc_fcvport *, bool disabled);
+static int fcoe_vport_disable(struct fc_fcvport *, bool disable);
+static void fcoe_set_vport_symbolic_name(struct fc_fcvport *);
 static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
 
+static void fcoe_fcpinit_callback(struct fc_fcpinit *fcpinit);
+
+static struct fcp_template fcoe_fcp_template = {
+	.fcpinit_priv_size = sizeof(struct fc_fcp_internal),
+	.fcp_fcpinit_callback = fcoe_fcpinit_callback,
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
+	.get_fcpinit_port_state = fc_get_fcpinit_port_state,
+	.show_fcpinit_port_state = 1,
+	.get_fcpinit_stats = fc_get_fcpinit_stats,
+	.bsg_request = fc_lport_bsg_request,
+};
+
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 	.ddp_setup = fcoe_ddp_setup,
@@ -156,101 +189,138 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.elsct_send = fcoe_elsct_send,
 	.get_lesb = fcoe_get_lesb,
 	.lport_set_port_id = fcoe_set_port_id,
+	.set_fcvport_symbolic_name = fcoe_set_symbolic_name,
+	.set_fcvport_node_name = fcoe_set_node_name,
+	.set_fcvport_port_name = fcoe_set_port_name,
+	.get_vport_ids = fcoe_get_vport_ids,
 };
 
-struct fc_function_template fcoe_transport_function = {
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
+struct fcrport_function_template fcoe_fcrport_fcn_tmpl = {
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
-
-	.show_host_fabric_name = 1,
-	.show_starget_node_name = 1,
-	.show_starget_port_name = 1,
-	.show_starget_port_id = 1,
 	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
-
 	.terminate_rport_io = fc_rport_terminate_io,
+};
+
+struct fcport_function_template fcoe_fcport_fcn_tmpl = {
+	.show_fcport_maxframe_size = 1,
+	.show_fcport_supported_speeds = 1,
+	.show_fcport_supported_classes = 1,
+	.show_fcport_speed = 1,
+	.show_fcport_supported_fc4s = 1,
+	.show_fcport_active_fc4s = 1,
+	.show_fcport_serial_number = 1,
+};
 
+struct fcfabric_function_template fcoe_fcfabric_fcn_tmpl = {
 	.vport_create = fcoe_vport_create,
 	.vport_delete = fcoe_vport_destroy,
 	.vport_disable = fcoe_vport_disable,
-	.set_vport_symbolic_name = fcoe_set_vport_symbolic_name,
 
-	.bsg_request = fc_lport_bsg_request,
+	.show_fcfabric_fabric_name = 1,
+	.dd_fcvport_size = (sizeof(struct fc_lport) + sizeof(struct fcoe_port)),
 };
 
-struct fc_function_template fcoe_vport_transport_function = {
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
+struct fcvport_function_template fcoe_fcvport_fcn_tmpl = {
+	.show_fcvport_port_id = 1,
+	.show_fcvport_symbolic_name = 1,
+	.show_fcvport_node_name = 1,
+	.show_fcvport_port_name = 1,
+	.show_fcvport_port_type = 1,
 
-	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
-	.show_rport_maxframe_size = 1,
-	.show_rport_supported_classes = 1,
+	.issue_fcvport_lip = fcoe_reset,
+	.set_fcvport_symbolic_name = fcoe_set_vport_symbolic_name,
+};
 
-	.show_host_fabric_name = 1,
-	.show_starget_node_name = 1,
-	.show_starget_port_name = 1,
-	.show_starget_port_id = 1,
-	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
-	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
+static void _fcoe_get_vport_ids(struct fcoe_interface *fcoe,
+				struct fc_vport_identifiers *ids)
+{
+	int vid = 0;
 
-	.terminate_rport_io = fc_rport_terminate_io,
+	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
+		vid = vlan_dev_vlan_id(fcoe->netdev);
 
-	.bsg_request = fc_lport_bsg_request,
-};
+	ids->node_name = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+	ids->port_name = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, vid);
 
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
+	/*
+	 * TODO: This needs to be determined, not hard coded.
+	 */
+	ids->roles = FC_PORT_ROLE_FCP_INITIATOR;
+
+	/*
+	 * TODO: I don't know where these values should come from,
+	 * guess that disable should be 0 and NPIV.
+	 */
+	ids->disable = 0;
+	ids->vport_type = FC_PORTTYPE_NPIV;
+
+	snprintf(ids->symbolic_name, FC_SYMBOLIC_NAME_SIZE,
+		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
+		 fcoe->netdev->name);
+}
+
+static void fcoe_get_vport_ids(struct fc_lport *lport,
+			       struct fc_vport_identifiers *ids)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+	_fcoe_get_vport_ids(fcoe, ids);
+}
+
+static void fcoe_set_symbolic_name(struct fc_lport *lport)
+{
+	snprintf(lport->fcvport->symbolic_name, FC_SYMBOLIC_NAME_SIZE,
+		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
+		 fcoe_netdev(lport)->name);
+}
+
+static void fcoe_set_node_name(struct fc_lport *lport)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+	int vid = 0;
+
+	/*
+	 * TODO: removed a if(!lport->vport) check, since this routine shoud
+	 * be used for all vports (real or virtual) I think it should be OK
+	 */
+
+	/*
+	 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
+	 * For WWNN, we use NAA 1 w/ bit 27-16 of word 0 as 0.
+	 * For WWPN, we use NAA 2 w/ bit 27-16 of word 0 from VLAN ID
+	 */
+	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
+		vid = vlan_dev_vlan_id(fcoe->netdev);
+	fcvport_node_name(lport->fcvport) =
+		fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+}
+
+static void fcoe_set_port_name(struct fc_lport *lport)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+	int vid = 0;
+
+	/*
+	 * TODO: removed a if(!lport->vport) check. Since this routine
+	 * should be used for all vports (real or virtual) I think it
+	 * should be OK
+	 */
+
+	/*
+	 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
+	 * For WWNN, we use NAA 1 w/ bit 27-16 of word 0 as 0.
+	 * For WWPN, we use NAA 2 w/ bit 27-16 of word 0 from VLAN ID
+	 */
+	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
+		vid = vlan_dev_vlan_id(fcoe->netdev);
+	fcvport_port_name(lport->fcvport) =
+		fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, vid);
+}
 
 /**
  * fcoe_interface_setup() - Setup a FCoE interface
@@ -520,8 +590,11 @@ static u8 *fcoe_get_src_mac(struct fc_lport *lport)
  */
 static int fcoe_lport_config(struct fc_lport *lport)
 {
+	lport->fcfabric_f = &fcoe_fcfabric_fcn_tmpl;
+	lport->fcvport_f = &fcoe_fcvport_fcn_tmpl;
+	lport->fcrport_f = &fcoe_fcrport_fcn_tmpl;
+
 	lport->link_up = 0;
-	lport->qfull = 0;
 	lport->max_retry_count = 3;
 	lport->max_rport_retry_count = 3;
 	lport->e_d_tov = 2 * 1000;	/* FC-FS default */
@@ -585,10 +658,8 @@ static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
 static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 {
 	u32 mfs;
-	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
-	int vid = 0;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lport);
@@ -632,69 +703,32 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
 
-	fcoe_link_speed_update(lport);
-
-	if (!lport->vport) {
-		/*
-		 * Use NAA 1&2 (FC-FS Rev. 2.0, Sec. 15) to generate WWNN/WWPN:
-		 * For WWNN, we use NAA 1 w/ bit 27-16 of word 0 as 0.
-		 * For WWPN, we use NAA 2 w/ bit 27-16 of word 0 from VLAN ID
-		 */
-		if (netdev->priv_flags & IFF_802_1Q_VLAN)
-			vid = vlan_dev_vlan_id(netdev);
-
-		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
-			wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
-		fc_set_wwnn(lport, wwnn);
-		if (fcoe_get_wwn(netdev, &wwpn, NETDEV_FCOE_WWPN))
-			wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr,
-						 2, vid);
-		fc_set_wwpn(lport, wwpn);
-	}
+	/*
+	 * TODO: This is a bad to have a special case for the N_Port
+	 * lport.
+	 */
+	if (lport->fcport)
+		fcoe_link_speed_update(lport);
 
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
+static void fcoe_fcpinit_callback(struct fc_fcpinit *fcpinit)
 {
-	int rc = 0;
-
-	/* lport scsi host config */
-	lport->host->max_lun = FCOE_MAX_LUN;
-	lport->host->max_id = FCOE_MAX_FCP_TARGET;
-	lport->host->max_channel = 0;
-	lport->host->max_cmd_len = FCOE_MAX_CMD_LEN;
-
-	if (lport->vport)
-		lport->host->transportt = fcoe_vport_transport_template;
-	else
-		lport->host->transportt = fcoe_transport_template;
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
 
-	/* add the new host to the SCSI-ml */
-	rc = scsi_add_host(lport->host, dev);
-	if (rc) {
-		FCOE_NETDEV_DBG(fcoe_netdev(lport), "fcoe_shost_config: "
-				"error on scsi_add_host\n");
-		return rc;
-	}
-
-	if (!lport->vport)
-		fc_host_max_npiv_vports(lport->host) = USHORT_MAX;
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
 
-	return 0;
+	si->qfull = 0;
 }
 
 /**
@@ -821,7 +855,14 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 
 	/* Cleanup the fc_lport */
 	fc_lport_destroy(lport);
-	fc_fcp_destroy(lport);
+
+	/*
+	 * TODO: Don't like lport->fcpinit, is there something
+	 *       better to check? Check should be here because
+	 *       eventually fcoe should know if it's init or targ.
+	 */
+	if (lport->fcpinit)
+		fc_fcp_destroy(lport);
 
 	/* Stop the transmit retry timer */
 	del_timer_sync(&port->timer);
@@ -839,18 +880,12 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
 
-	/* Detach from the scsi-ml */
-	fc_remove_host(lport->host);
-	scsi_remove_host(lport->host);
-
 	/* There are no more rports or I/O, free the EM */
 	fc_exch_mgr_free(lport);
 
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
-	/* Release the Scsi_Host */
-	scsi_host_put(lport->host);
 	module_put(THIS_MODULE);
 }
 
@@ -902,34 +937,15 @@ static int fcoe_ddp_done(struct fc_lport *lport, u16 xid)
  *
  * Returns: The allocated fc_lport or an error pointer
  */
-static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
-				       struct device *parent, int npiv)
+static int fcoe_if_create(struct fc_lport *lport, struct fcoe_interface *fcoe,
+			  int npiv)
 {
 	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *lport = NULL;
-	struct fcoe_port *port;
-	int rc;
-	/*
-	 * parent is only a vport if npiv is 1,
-	 * but we'll only use vport in that case so go ahead and set it
-	 */
-	struct fc_vport *vport = dev_to_vport(parent);
+	struct fcoe_port *port = lport_priv(lport);
+	int rc = 0;
 
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
-	if (!npiv) {
-		lport = libfc_host_alloc(&fcoe_shost_template,
-					 sizeof(struct fcoe_port));
-	} else	{
-		lport = libfc_vport_create(vport,
-					   sizeof(struct fcoe_port));
-	}
-	if (!lport) {
-		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-	port = lport_priv(lport);
 	port->lport = lport;
 	port->fcoe = fcoe;
 	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
@@ -939,15 +955,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
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
@@ -958,22 +966,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
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
-	rc = fcoe_libfc_config(lport, &fcoe_libfc_fcn_templ);
-	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
-				"interface\n");
-		goto out_lp_destroy;
-	}
-
 	if (!npiv) {
 		/*
 		 * fcoe_em_alloc() and fcoe_hostlist_add() both
@@ -995,14 +987,13 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
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
+	return rc;
 }
 
 /**
@@ -1014,16 +1005,6 @@ out:
  */
 static int __init fcoe_if_init(void)
 {
-	/* attach to scsi transport */
-	fcoe_transport_template = fc_attach_transport(&fcoe_transport_function);
-	fcoe_vport_transport_template =
-		fc_attach_transport(&fcoe_vport_transport_function);
-
-	if (!fcoe_transport_template) {
-		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
-		return -ENODEV;
-	}
-
 	return 0;
 }
 
@@ -1036,10 +1017,6 @@ static int __init fcoe_if_init(void)
  */
 int __exit fcoe_if_exit(void)
 {
-	fc_release_transport(fcoe_transport_template);
-	fc_release_transport(fcoe_vport_transport_template);
-	fcoe_transport_template = NULL;
-	fcoe_vport_transport_template = NULL;
 	return 0;
 }
 
@@ -1718,8 +1695,20 @@ int fcoe_percpu_receive_thread(void *arg)
 static void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb)
 {
 	struct fcoe_port *port = lport_priv(lport);
+	struct fc_fcp_internal *si;
 	int rc;
 
+	/*
+	 * TODO: I think this is a problem because we're not guaranteed
+	 * to have logged into the fabric yet. For example, this is called
+	 * from fcoe_xmit, which will be called for the FLOGI itself. I'm
+	 * pretty sure the si will never be set in that case, so what exactly
+	 * are we filling out later in this routine with si->qfull?
+	 *
+	 * Added bad lport->fcpinit checks at the end of this routine. I do
+	 * not trust them.
+	 */
+
 	spin_lock_bh(&port->fcoe_pending_queue.lock);
 
 	if (skb)
@@ -1748,14 +1737,22 @@ static void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb)
 		port->fcoe_pending_queue.qlen--;
 	}
 
-	if (port->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
-		lport->qfull = 0;
+	if (port->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH) {
+		if (lport->fcpinit) {
+			si = fc_get_scsi_internal(lport);
+			si->qfull = 0;
+		}
+	}
 	if (port->fcoe_pending_queue.qlen && !timer_pending(&port->timer))
 		mod_timer(&port->timer, jiffies + 2);
 	port->fcoe_pending_queue_active = 0;
 out:
-	if (port->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-		lport->qfull = 1;
+	if (port->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH) {
+		if (lport->fcpinit) {
+			si = fc_get_scsi_internal(lport);
+			si->qfull = 1;
+		}
+	}
 	spin_unlock_bh(&port->fcoe_pending_queue.lock);
 	return;
 }
@@ -1996,6 +1993,7 @@ out_nodev:
  */
 static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
+	struct fc_lport *lport;
 	struct fcoe_interface *fcoe;
 	struct net_device *netdev;
 	int rc = 0;
@@ -2032,9 +2030,21 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_putdev;
 	}
 	list_del(&fcoe->list);
+
+	lport = fcoe->ctlr.lp;
+
+	/*
+	 * TODO: Should the fcport be deleted before or after
+	 * fcoe_interface_cleanup? Probably before.
+	 */
+	fc_fcport_del(lport->fcport);
+
 	fcoe_interface_cleanup(fcoe);
+
 	/* RTNL mutex is dropped by fcoe_if_destroy */
-	fcoe_if_destroy(fcoe->ctlr.lp);
+	fcoe_if_destroy(lport);
+
+	fc_fcvport_free(lport->fcvport);
 
 out_putdev:
 	dev_put(netdev);
@@ -2070,8 +2080,16 @@ static void fcoe_destroy_work(struct work_struct *work)
  */
 static int fcoe_create(const char *buffer, struct kernel_param *kp)
 {
-	int rc;
+	/*
+	 * TODO: rc and error can probably be consolidated.
+	 */
+	int rc = 0;
+	int error = 0;
+	int priv_size;
+	struct fc_vport_identifiers ids;
 	struct fcoe_interface *fcoe;
+	struct fc_fcport *fcport;
+	struct fc_fcvport *fcvport;
 	struct fc_lport *lport;
 	struct net_device *netdev;
 
@@ -2117,8 +2135,53 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 		goto out_putdev;
 	}
 
-	lport = fcoe_if_create(fcoe, &netdev->dev, 0);
-	if (IS_ERR(lport)) {
+	fcport = fc_fcport_add((struct device *)&netdev->dev.parent,
+			       &fcoe_fcport_fcn_tmpl, &fcoe_fcp_template);
+	if (!fcport) {
+		printk(KERN_ERR "Failed to add a fcport\n");
+		goto out_free;
+	}
+
+	/*
+	 * TODO: This is rather goofy. Is there a better way to
+	 * have the get_vport_ids callback and this call better
+	 * integrated? Does the callback need to pass an lport?
+	 * Probably, since we don't know the LLD is fcoe.ko.
+	 */
+	_fcoe_get_vport_ids(fcoe, &ids);
+
+	priv_size = sizeof(struct fc_lport) + sizeof(struct fcoe_port);
+
+	fcvport = fc_fcvport_alloc(NULL, &ids, &fcoe_fcvport_fcn_tmpl,
+				   priv_size, fcport);
+
+	if (!fcvport) {
+		/*
+		 * TODO: What is the correct thing to do if
+		 * we fail to allocate the N_Port?
+		 */
+		return rc;
+	}
+
+	lport = fcvport_priv(fcvport);
+	lport->fcport = fcport;
+	lport->fcvport = fcvport;
+
+	fcvport_port_type(fcvport) = FC_PORTTYPE_NPORT;
+
+	fc_lport_port_config(lport->fcport);
+
+	/* Initialize the library */
+	fcoe_libfc_config(lport, &fcoe_libfc_fcn_templ);
+
+	/*
+	 * TODO: Does this need to before fcoe_if_create?
+	 */
+	/* Make this the "master" N_Port */
+	fcoe->ctlr.lp = lport;
+
+	error = fcoe_if_create(lport, fcoe, 0);
+	if (error) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		rc = -EIO;
@@ -2126,14 +2189,14 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 		goto out_free;
 	}
 
-	/* Make this the "master" N_Port */
-	fcoe->ctlr.lp = lport;
+	lport->fcport->maxframe_size = lport->mfs;
 
 	/* add to lports list */
 	fcoe_hostlist_add(lport);
 
 	/* start FIP Discovery and FLOGI */
 	lport->boot_time = jiffies;
+
 	fc_fabric_login(lport);
 	if (!fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
@@ -2173,19 +2236,21 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 	struct net_device *netdev = port->fcoe->netdev;
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
+		fcport_supported_speeds(lport->fcport) = link_supported_speeds;
+
 		if (ecmd.speed == SPEED_1000)
-			lport->link_speed = FC_PORTSPEED_1GBIT;
+			fcport_speed(lport->fcport) = FC_PORTSPEED_1GBIT;
 		if (ecmd.speed == SPEED_10000)
-			lport->link_speed = FC_PORTSPEED_10GBIT;
+			fcport_speed(lport->fcport) = FC_PORTSPEED_10GBIT;
 
 		return 0;
 	}
@@ -2289,9 +2354,9 @@ void fcoe_clean_pending_queue(struct fc_lport *lport)
  *
  * Returns: Always 0 (return value required by FC transport template)
  */
-int fcoe_reset(struct Scsi_Host *shost)
+int fcoe_reset(struct fc_fcvport *fcvport)
 {
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_lport *lport = fcvport_priv(fcvport);
 	fc_lport_reset(lport);
 	return 0;
 }
@@ -2540,32 +2605,65 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
  *
  * Returns: 0 for success
  */
-static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
+static int fcoe_vport_create(void *data, struct fc_fcvport *vport,
+			     bool disabled)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fcoe_port *port = lport_priv(n_port);
-	struct fcoe_interface *fcoe = port->fcoe;
-	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *vn_port;
+	struct fc_lport *lport;
+	struct fcoe_port *port;
+	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
+	struct fc_lport *vn_lport;
+	int error = 0;
+
+	lport = (struct fc_lport *)data;
+
+	port = lport_priv(lport);
+	fcoe = port->fcoe;
+	netdev = fcoe->netdev;
+
+	vn_lport = fcvport_priv(vport);
+	if (!vn_lport) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
+		return -ENOMEM;
+	}
+
+	/* Initialize the library */
+	fcoe_libfc_config(vn_lport, &fcoe_libfc_fcn_templ);
 
 	mutex_lock(&fcoe_config_mutex);
-	vn_port = fcoe_if_create(fcoe, &vport->dev, 1);
+	error = fcoe_if_create(vn_lport, fcoe, 1);
 	mutex_unlock(&fcoe_config_mutex);
 
-	if (IS_ERR(vn_port)) {
-		printk(KERN_ERR "fcoe: fcoe_vport_create(%s) failed\n",
-		       netdev->name);
+	/*
+	 * TODO: Need to free the vn_port (lport) in this case.
+	 */
+	if (error)
+		return error;
+
+	/*
+	 * TODO: Check the failure case here.
+	 */
+	error = libfc_vport_config(lport, vn_lport, vport);
+	if (error)
 		return -EIO;
-	}
+
+	if (IS_ERR(vn_lport))
+		return -EIO;
+
+	/*
+	 * TODO: This routine is not currently setting a unique
+	 * name for the vports.
+	 */
+	fcoe_set_symbolic_name(lport);
 
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
+
 	return 0;
 }
 
@@ -2575,11 +2673,10 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
  *
  * Returns: 0 for success
  */
-static int fcoe_vport_destroy(struct fc_vport *vport)
+static int fcoe_vport_destroy(void *data, struct fc_fcvport *vport)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fc_lport *vn_port = vport->dd_data;
+	struct fc_lport *n_port = data;
+	struct fc_lport *vn_port = fcvport_priv(vport);
 	struct fcoe_port *port = lport_priv(vn_port);
 
 	mutex_lock(&n_port->lp_mutex);
@@ -2594,9 +2691,9 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
  * @vport: vport to bring online/offline
  * @disable: should the vport be disabled?
  */
-static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
+static int fcoe_vport_disable(struct fc_fcvport *vport, bool disable)
 {
-	struct fc_lport *lport = vport->dd_data;
+	struct fc_lport *lport = fcvport_priv(vport);
 
 	if (disable) {
 		fc_vport_set_state(vport, FC_VPORT_DISABLED);
@@ -2618,20 +2715,20 @@ static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
  * sent to the name server.  There is no response handler, so if it fails
  * for some reason it will not be retried.
  */
-static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
+static void fcoe_set_vport_symbolic_name(struct fc_fcvport *vport)
 {
-	struct fc_lport *lport = vport->dd_data;
+	struct fc_lport *lport = fcvport_priv(vport);
 	struct fc_frame *fp;
 	size_t len;
 
-	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
+	snprintf(fcvport_symbolic_name(lport->fcvport), FC_SYMBOLIC_NAME_SIZE,
 		 "%s v%s over %s : %s", FCOE_NAME, FCOE_VERSION,
 		 fcoe_netdev(lport)->name, vport->symbolic_name);
 
 	if (lport->state != LPORT_ST_READY)
 		return;
 
-	len = strnlen(fc_host_symbolic_name(lport->host), 255);
+	len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 	fp = fc_frame_alloc(lport,
 			    sizeof(struct fc_ct_hdr) +
 			    sizeof(struct fc_ns_rspn) + len);
@@ -2647,7 +2744,7 @@ static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
  * @fc_lesb: the link error status block
  */
 static void fcoe_get_lesb(struct fc_lport *lport,
-			 struct fc_els_lesb *fc_lesb)
+			  struct fc_els_lesb *fc_lesb)
 {
 	unsigned int cpu;
 	u32 lfc, vlfc, mdac;
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 50aaa4b..4c6a5e8 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -40,6 +40,7 @@
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fcoe.h>
 
+#include <fc/fc.h>
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
 
@@ -53,6 +54,9 @@ MODULE_LICENSE("GPL v2");
 static void fcoe_ctlr_timeout(unsigned long);
 static void fcoe_ctlr_timer_work(struct work_struct *);
 static void fcoe_ctlr_recv_work(struct work_struct *);
+static void fcoe_ctlr_fcf_work(struct work_struct *);
+static int fcoe_ctlr_queue_work(struct fcoe_ctlr *ctlr,
+				struct work_struct *work);
 
 static u8 fcoe_all_fcfs[ETH_ALEN] = FIP_ALL_FCF_MACS;
 
@@ -77,8 +81,8 @@ do {							\
 
 #define LIBFCOE_FIP_DBG(fip, fmt, args...)				\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_FIP_LOGGING,			\
-			      printk(KERN_INFO "host%d: fip: " fmt, 	\
-				     (fip)->lp->host->host_no, ##args);)
+			      printk(KERN_INFO "fcport%d: fip: " fmt,	\
+				     (fip)->lp->fcport->id, ##args);)
 
 /**
  * fcoe_ctlr_mtu_valid() - Check if a FCF's MTU is valid
@@ -119,6 +123,17 @@ void fcoe_ctlr_init(struct fcoe_ctlr *fip)
 	INIT_WORK(&fip->timer_work, fcoe_ctlr_timer_work);
 	INIT_WORK(&fip->recv_work, fcoe_ctlr_recv_work);
 	skb_queue_head_init(&fip->fip_recv_list);
+	/*
+	 * TODO: Need to uniquely identify fip->work_q_name.
+	 * Currently cannot have more than one fip->work_q
+	 * because the names are not unique. Can I just use
+	 * a pointer address?
+	 */
+
+	snprintf(fip->work_q_name, sizeof(fip->work_q_name),
+		 "fcoe_ctlr_wq_%d", 0);
+	fip->work_q = create_singlethread_workqueue(
+		fip->work_q_name);
 }
 EXPORT_SYMBOL(fcoe_ctlr_init);
 
@@ -134,9 +149,14 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 	struct fcoe_fcf *next;
 
 	fip->sel_fcf = NULL;
+	/*
+	 * TODO: Does the fcfabric disassociation need to
+	 * be protected by the lp_lock?
+	 */
+	fip->lp->fcfabric = NULL;
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
 		list_del(&fcf->list);
-		kfree(fcf);
+		fcoe_ctlr_queue_work(fip, &fcf->fcf_work);
 	}
 	fip->fcf_count = 0;
 	fip->sel_time = 0;
@@ -158,13 +178,15 @@ void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 {
 	cancel_work_sync(&fip->recv_work);
 	skb_queue_purge(&fip->fip_recv_list);
-
 	spin_lock_bh(&fip->lock);
 	fip->state = FIP_ST_DISABLED;
+	fip->lp->fcfabric = NULL;
 	fcoe_ctlr_reset_fcfs(fip);
 	spin_unlock_bh(&fip->lock);
 	del_timer_sync(&fip->timer);
 	cancel_work_sync(&fip->timer_work);
+
+	destroy_workqueue(fip->work_q);
 }
 EXPORT_SYMBOL(fcoe_ctlr_destroy);
 
@@ -230,7 +252,8 @@ static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
 
 	sol->desc.wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
 	sol->desc.wwnn.fd_desc.fip_dlen = sizeof(sol->desc.wwnn) / FIP_BPW;
-	put_unaligned_be64(fip->lp->wwnn, &sol->desc.wwnn.fd_wwn);
+	put_unaligned_be64(fcvport_node_name(fip->lp->fcvport),
+			   &sol->desc.wwnn.fd_wwn);
 
 	fcoe_size = fcoe_ctlr_fcoe_size(fip);
 	sol->desc.size.fd_desc.fip_dtype = FIP_DT_FCOE_SIZE;
@@ -300,12 +323,12 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 	int link_dropped;
 
 	LIBFCOE_FIP_DBG(fip, "link down.\n");
+
 	spin_lock_bh(&fip->lock);
 	fcoe_ctlr_reset(fip);
 	link_dropped = fip->state != FIP_ST_LINK_WAIT;
 	fip->state = FIP_ST_LINK_WAIT;
 	spin_unlock_bh(&fip->lock);
-
 	if (link_dropped)
 		fc_linkdown(fip->lp);
 	return link_dropped;
@@ -365,7 +388,6 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 	kal->fip.fip_flags = htons(FIP_FL_FPMA);
 	if (fip->spma)
 		kal->fip.fip_flags |= htons(FIP_FL_SPMA);
-
 	kal->mac.fd_desc.fip_dtype = FIP_DT_MAC;
 	kal->mac.fd_desc.fip_dlen = sizeof(kal->mac) / FIP_BPW;
 	memcpy(kal->mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
@@ -375,7 +397,8 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 		vn->fd_desc.fip_dlen = sizeof(*vn) / FIP_BPW;
 		memcpy(vn->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
 		hton24(vn->fd_fc_id, lport->port_id);
-		put_unaligned_be64(lport->wwpn, &vn->fd_wwpn);
+		put_unaligned_be64(fcvport_port_name(lport->fcvport),
+				   &vn->fd_wwpn);
 	}
 	skb_put(skb, len);
 	skb->protocol = htons(ETH_P_FIP);
@@ -568,6 +591,7 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  */
 static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 {
+	struct fc_fcp_internal *si = fc_get_scsi_internal(fip->lp);
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
 	unsigned long sel_time = 0;
@@ -583,18 +607,20 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 					    smp_processor_id());
 			stats->MissDiscAdvCount++;
 			printk(KERN_INFO "libfcoe: host%d: Missing Discovery "
-			       "Advertisement for fab %16.16llx count %lld\n",
-			       fip->lp->host->host_no, fcf->fabric_name,
+			       "Advertisement for fab %llx count %lld\n",
+			       si->host->host_no, fcf->fabric_name,
 			       stats->MissDiscAdvCount);
 		}
 		if (time_after(jiffies, fcf->time + fcf->fka_period * 3 +
 			       msecs_to_jiffies(FIP_FCF_FUZZ * 3))) {
-			if (fip->sel_fcf == fcf)
+			if (fip->sel_fcf == fcf) {
 				fip->sel_fcf = NULL;
+				fip->lp->fcfabric = NULL;
+			}
 			list_del(&fcf->list);
 			WARN_ON(!fip->fcf_count);
 			fip->fcf_count--;
-			kfree(fcf);
+			fcoe_ctlr_queue_work(fip, &fcf->fcf_work);
 			stats = per_cpu_ptr(fip->lp->dev_stats,
 					    smp_processor_id());
 			stats->VLinkFailureCount++;
@@ -759,7 +785,29 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 
 		fip->fcf_count++;
 		memcpy(fcf, &new, sizeof(new));
+
+		INIT_WORK(&fcf->fcf_work, fcoe_ctlr_fcf_work);
+		/*
+		 * The fcport and fcfabric_f need to be added
+		 * to the new fcf so that when the fcfabric is
+		 * added to the system it knows which fcport to
+		 * attach it to.
+		 *
+		 * This could probably be improved by adding a lport
+		 * pointer in the fcf. Right now the fcf can't get to
+		 * the lport in the fcf_work queue, so we have to do
+		 * some funky stuff so the fcf can get these objects.
+		 */
+		fcf->fcport = fip->lp->fcport;
+		fcf->fcfabric_f = fip->lp->fcfabric_f;
+		fcf->fcvport_f = fip->lp->fcvport_f;
+
+		/*
+		 * TODO: Should the fcfs be added to the list
+		 * in the work context?
+		 */
 		list_add(&fcf->list, &fip->fcfs);
+		fcoe_ctlr_queue_work(fip, &fcf->fcf_work);
 	} else {
 		/*
 		 * Flags in advertisements are ignored once the FCF is
@@ -778,6 +826,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		memcpy(fcf->fcf_mac, new.fcf_mac, ETH_ALEN);
 	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
+
 	fcf->time = jiffies;
 	if (!found) {
 		LIBFCOE_FIP_DBG(fip, "New FCF for fab %16.16llx "
@@ -809,9 +858,11 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		fip->sel_time = jiffies +
 			msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		if (!timer_pending(&fip->timer) ||
-		    time_before(fip->sel_time, fip->timer.expires))
+		    time_before(fip->sel_time, fip->timer.expires)) {
 			mod_timer(&fip->timer, fip->sel_time);
+		}
 	}
+
 out:
 	spin_unlock_bh(&fip->lock);
 }
@@ -986,7 +1037,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 				return;
 			if (compare_ether_addr(vp->fd_mac,
 					       fip->get_src_addr(lport)) == 0 &&
-			    get_unaligned_be64(&vp->fd_wwpn) == lport->wwpn &&
+			    get_unaligned_be64(&vp->fd_wwpn) == fcvport_port_name(lport->fcvport) &&
 			    ntoh24(vp->fd_fc_id) == lport->port_id)
 				desc_mask &= ~BIT(FIP_DT_VN_ID);
 			break;
@@ -1093,6 +1144,19 @@ drop:
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
+	fip->lp->fcfabric = fip->sel_fcf->fcfabric;
+}
+
 /**
  * fcoe_ctlr_select() - Select the best FCF (if possible)
  * @fip: The FCoE controller
@@ -1134,7 +1198,7 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 		if (fcf->pri < best->pri)
 			best = fcf;
 	}
-	fip->sel_fcf = best;
+	fcoe_ctlr_assign_fcf(fip, best);
 }
 
 /**
@@ -1169,18 +1233,18 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 	if (sel != fcf) {
 		fcf = sel;		/* the old FCF may have been freed */
 		if (sel) {
-			printk(KERN_INFO "libfcoe: host%d: FIP selected "
+			printk(KERN_INFO "libfcoe: fcport%d: FIP selected "
 			       "Fibre-Channel Forwarder MAC %pM\n",
-			       fip->lp->host->host_no, sel->fcf_mac);
+			       fip->lp->fcport->id, sel->fcf_mac);
 			memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
 			fip->port_ka_time = jiffies +
 				msecs_to_jiffies(FIP_VN_KA_PERIOD);
 			fip->ctlr_ka_time = jiffies + sel->fka_period;
 		} else {
-			printk(KERN_NOTICE "libfcoe: host%d: "
+			printk(KERN_NOTICE "libfcoe: fcport%d: "
 			       "FIP Fibre-Channel Forwarder timed out.	"
 			       "Starting FCF discovery.\n",
-			       fip->lp->host->host_no);
+			       fip->lp->fcport->id);
 			fip->reset_req = 1;
 			schedule_work(&fip->timer_work);
 		}
@@ -1234,7 +1298,6 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 
 	if (reset)
 		fc_lport_reset(fip->lp);
-
 	if (fip->send_ctlr_ka) {
 		fip->send_ctlr_ka = 0;
 		fcoe_ctlr_send_keep_alive(fip, NULL, 0, fip->ctl_src_addr);
@@ -1385,23 +1448,71 @@ EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
  * fcoe_libfc_config() - Sets up libfc related properties for local port
  * @lp: The local port to configure libfc for
  * @tt: The libfc function template
- *
- * Returns : 0 for success
  */
-int fcoe_libfc_config(struct fc_lport *lport,
-		      struct libfc_function_template *tt)
+void fcoe_libfc_config(struct fc_lport *lport,
+		       struct libfc_function_template *tt)
 {
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lport->tt, tt, sizeof(*tt));
-	if (fc_fcp_init(lport))
-		return -ENOMEM;
 	fc_exch_init(lport);
 	fc_elsct_init(lport);
 	fc_lport_init(lport);
 	fc_rport_init(lport);
 	fc_disc_init(lport);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(fcoe_libfc_config);
 
+/**
+ * fcoe_ctlr_queue_work - Queue work to the fcoe_ctlr workqueue.
+ *
+ * Return value:
+ *      1 - work queued for execution
+ *      0 - work is already queued
+ *      -EINVAL - work queue doesn't exist
+ */
+static int fcoe_ctlr_queue_work(struct fcoe_ctlr *ctlr,
+				struct work_struct *work)
+{
+	if (unlikely(!fcoe_ctlr_work_q(ctlr))) {
+/*
+  printk(KERN_ERR
+  "ERROR: FC VN_Port '%d' attempted to queue work, "
+  "when no workqueue created.\n", fcvport->id);
+*/
+		dump_stack();
+
+		return -EINVAL;
+	}
+
+	return queue_work(fcoe_ctlr_work_q(ctlr), work);
+}
+
+static void fcoe_ctlr_fcf_work(struct work_struct *work)
+{
+	struct fcoe_fcf *fcf;
+
+	fcf = container_of(work, struct fcoe_fcf, fcf_work);
+	if (fcf->fcfabric) {
+		fc_fcfabric_del(fcf->fcfabric);
+		kfree(fcf);
+	} else {
+		fcf->fcfabric = fc_fcfabric_add(fcf->fcport,
+						fcf->fcfabric_f,
+						fcf->switch_name);
+
+		if (!fcf->fcfabric) {
+			/*
+			 * TODO: This needs to fail more severly because
+			 * vports will not be added to FC if there is no
+			 * fabric.
+			 */
+			return;
+		}
+		/*
+		 * TODO: I dislike putting the vport fcn tmpl in the
+		 *       lport and the fcfabric.
+		 */
+		fcf->fcfabric->fcvport_f = fcf->fcvport_f;
+		fcfabric_max_npiv_vports(fcf->fcfabric) = USHORT_MAX;
+	}
+}
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index c7985da..bae5014 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -388,6 +388,7 @@ err:
 static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 {
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	struct fc_gpn_ft_resp *np;
 	char *bp;
 	size_t plen;
@@ -397,6 +398,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
+	si = fc_get_scsi_internal(lport);
 	disc->seq_count++;
 
 	/*
@@ -441,7 +443,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		ids.port_name = ntohll(np->fp_wwpn);
 
 		if (ids.port_id != lport->port_id &&
-		    ids.port_name != lport->wwpn) {
+		    ids.port_name != fcvport_port_name(lport->fcvport)) {
 			rdata = lport->tt.rport_create(lport, ids.port_id);
 			if (rdata) {
 				rdata->ids.port_name = ids.port_name;
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 104e0fb..c73df63 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1905,11 +1905,13 @@ err:
 static void fc_exch_rrq(struct fc_exch *ep)
 {
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	struct fc_els_rrq *rrq;
 	struct fc_frame *fp;
 	u32 did;
 
 	lport = ep->lp;
+	si = fc_get_scsi_internal(lport);
 
 	fp = fc_frame_alloc(lport, sizeof(*rrq));
 	if (!fp)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ec1f66c..e784df8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -67,26 +67,6 @@ struct kmem_cache *scsi_pkt_cachep;
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
@@ -352,13 +332,13 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 
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
 
@@ -386,12 +366,12 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 
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
 
@@ -406,6 +386,7 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 						  size_t len)
 {
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	struct fc_frame *fp;
 	unsigned long flags;
 
@@ -414,9 +395,10 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
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
 
@@ -1001,7 +983,7 @@ static void fc_fcp_cleanup_each_cmd(struct fc_lport *lport, unsigned int id,
 	struct scsi_cmnd *sc_cmd;
 	unsigned long flags;
 
-	spin_lock_irqsave(&si->scsi_queue_lock, flags);
+	spin_lock_irqsave(si->host->host_lock, flags);
 restart:
 	list_for_each_entry(fsp, &si->scsi_pkt_queue, list) {
 		sc_cmd = fsp->cmd;
@@ -1012,7 +994,7 @@ restart:
 			continue;
 
 		fc_fcp_pkt_hold(fsp);
-		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+		spin_unlock_irqrestore(si->host->host_lock, flags);
 
 		if (!fc_fcp_lock_pkt(fsp)) {
 			fc_fcp_cleanup_cmd(fsp, error);
@@ -1021,14 +1003,14 @@ restart:
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
@@ -1061,10 +1043,10 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	int_to_scsilun(fsp->cmd->device->lun,
 		       (struct scsi_lun *)fsp->cdb_cmd.fc_lun);
 	memcpy(fsp->cdb_cmd.fc_cdb, fsp->cmd->cmnd, fsp->cmd->cmd_len);
-
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_add_tail(&fsp->list, &si->scsi_pkt_queue);
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+
 	rc = lport->tt.fcp_cmd_send(lport, fsp, fc_fcp_recv);
 	if (unlikely(rc)) {
 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
@@ -1366,8 +1348,10 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	struct fc_frame *fp;
 	struct fc_rport *rport;
 	struct fc_rport_libfc_priv *rpriv;
+	struct fc_fcp_internal *si;
 
 	lport = fsp->lp;
+	si = fc_get_scsi_internal(lport);
 	rport = fsp->rport;
 	rpriv = rport->dd_data;
 	if (!fsp->seq_ptr || rpriv->rp_state != RPORT_ST_READY) {
@@ -1745,7 +1729,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
 {
 	/* lock ? */
 	return (lport->state == LPORT_ST_READY) &&
-		lport->link_up && !lport->qfull;
+		lport->link_up && !fc_get_scsi_internal(lport)->qfull;
 }
 
 /**
@@ -1758,17 +1742,19 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
  */
 int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 {
-	struct fc_lport *lport;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct scsi_target *starget = scsi_target(sc_cmd->device);
+	struct fc_fcptarg *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
+	struct fc_fcpinit *fcpinit = shost_priv(sc_cmd->device->host);
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport_libfc_priv *rpriv;
 	int rval;
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
 
-	lport = shost_priv(sc_cmd->device->host);
-	spin_unlock_irq(lport->host->host_lock);
-
+	spin_unlock_irq(si->host->host_lock);
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
@@ -1789,7 +1775,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	rpriv = rport->dd_data;
 
 	if (!fc_fcp_lport_queue_ready(lport)) {
-		if (lport->qfull)
+		if (si->qfull)
 			fc_fcp_can_queue_ramp_down(lport);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -1844,14 +1830,16 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	 * if we get -1 return then put the request in the pending
 	 * queue.
 	 */
+
 	rval = fc_fcp_pkt_send(lport, fsp);
 	if (rval != 0) {
 		fsp->state = FC_SRB_FREE;
 		fc_fcp_pkt_release(fsp);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
+
 out:
-	spin_lock_irq(lport->host->host_lock);
+	spin_lock_irq(si->host->host_lock);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
@@ -1992,27 +1980,28 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
  */
 int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 {
+	struct fc_fcpinit *fcpinit = shost_priv(sc_cmd->device->host);
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
 	struct fc_fcp_pkt *fsp;
-	struct fc_lport *lport;
 	int rc = FAILED;
 	unsigned long flags;
 
-	lport = shost_priv(sc_cmd->device->host);
 	if (lport->state != LPORT_ST_READY)
 		return rc;
 	else if (!lport->link_up)
 		return rc;
 
-	spin_lock_irqsave(lport->host->host_lock, flags);
+	spin_lock_irqsave(si->host->host_lock, flags);
 	fsp = CMD_SP(sc_cmd);
 	if (!fsp) {
 		/* command completed while scsi eh was setting up */
-		spin_unlock_irqrestore(lport->host->host_lock, flags);
+		spin_unlock_irqrestore(si->host->host_lock, flags);
 		return SUCCESS;
 	}
 	/* grab a ref so the fsp and sc_cmd cannot be relased from under us */
 	fc_fcp_pkt_hold(fsp);
-	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	spin_unlock_irqrestore(si->host->host_lock, flags);
 
 	if (fc_fcp_lock_pkt(fsp)) {
 		/* completed while we were waiting for timer to be deleted */
@@ -2038,9 +2027,13 @@ EXPORT_SYMBOL(fc_eh_abort);
  */
 int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 {
-	struct fc_lport *lport;
+	struct fc_fcpinit *fcpinit = shost_priv(sc_cmd->device->host);
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
+	struct scsi_target *starget = scsi_target(sc_cmd->device);
+	struct fc_fcptarg *fcptarg = starget_to_fcptarg(starget);
+	struct fc_rport *rport = fcptarg->rport;
 	struct fc_fcp_pkt *fsp;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	int rc = FAILED;
 	int rval;
 
@@ -2048,8 +2041,6 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (rval)
 		goto out;
 
-	lport = shost_priv(sc_cmd->device->host);
-
 	if (lport->state != LPORT_ST_READY)
 		return rc;
 
@@ -2088,7 +2079,9 @@ EXPORT_SYMBOL(fc_eh_device_reset);
 int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 {
 	struct Scsi_Host *shost = sc_cmd->device->host;
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_fcpinit *fcpinit = shost_priv(shost);
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
+	struct fc_lport *lport = si->lport;
 	unsigned long wait_tmo;
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
@@ -2121,7 +2114,8 @@ EXPORT_SYMBOL(fc_eh_host_reset);
  */
 int fc_slave_alloc(struct scsi_device *sdev)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct fc_fcptarg *fcptarg = starget_to_fcptarg(scsi_target(sdev));
+	struct fc_rport *rport = fcptarg->rport;
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
@@ -2194,7 +2188,10 @@ void fc_fcp_destroy(struct fc_lport *lport)
 		       "port (%6.6x)\n", lport->port_id);
 
 	mempool_destroy(si->scsi_pkt_pool);
-	kfree(si);
+
+	/*
+	 * TODO: This should get set in the callback from FC
+	 */
 	lport->scsi_priv = NULL;
 }
 EXPORT_SYMBOL(fc_fcp_destroy);
@@ -2225,10 +2222,14 @@ void fc_destroy_fcp()
  * fc_fcp_init() - Initialize the FCP layer for a local port
  * @lport: The local port to initialize the exchange layer for
  */
-int fc_fcp_init(struct fc_lport *lport)
+int fc_fcp_init(struct fc_fcpinit *fcpinit)
 {
-	int rc;
-	struct fc_fcp_internal *si;
+	struct fc_fcvport *fcvport = fcpinit_to_fcvport(fcpinit);
+	struct fc_lport *lport = fcvport_priv(fcvport);
+	struct Scsi_Host *shost = fcpinit_to_shost(fcpinit);
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
+
+	int rc = 0;
 
 	if (!lport->tt.fcp_cmd_send)
 		lport->tt.fcp_cmd_send = fc_fcp_cmd_send;
@@ -2239,23 +2240,18 @@ int fc_fcp_init(struct fc_lport *lport)
 	if (!lport->tt.fcp_abort_io)
 		lport->tt.fcp_abort_io = fc_fcp_abort_io;
 
-	si = kzalloc(sizeof(struct fc_fcp_internal), GFP_KERNEL);
-	if (!si)
-		return -ENOMEM;
+	lport->fcpinit = fcpinit;
+	si->host = shost;
 	lport->scsi_priv = si;
-	si->max_can_queue = lport->host->can_queue;
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
index f5c0ca4..e5ec03e 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -45,20 +45,20 @@ extern unsigned int fc_debug_logging;
 
 #define FC_LPORT_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: lport %6.6x: " fmt,	\
-				(lport)->host->host_no,			\
+			 printk(KERN_INFO "fcport%u: lport %6x: " fmt,	\
+				(lport)->fcport->id,			\
 				(lport)->port_id, ##args))
 
-#define FC_DISC_DBG(disc, fmt, args...)				\
-	FC_CHECK_LOGGING(FC_DISC_LOGGING,			\
-			 printk(KERN_INFO "host%u: disc: " fmt,	\
-				(disc)->lport->host->host_no,	\
+#define FC_DISC_DBG(disc, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
+			 printk(KERN_INFO "fcport%u: disc: " fmt,	\
+				(disc)->lport->fcport->id,		\
 				##args))
 
 #define FC_RPORT_ID_DBG(lport, port_id, fmt, args...)			\
 	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: rport %6.6x: " fmt,	\
-				(lport)->host->host_no,			\
+			 printk(KERN_INFO "fcport%u: rport %6x: " fmt,	\
+				(lport)->fcport->id,			\
 				(port_id), ##args))
 
 #define FC_RPORT_DBG(rdata, fmt, args...)				\
@@ -66,20 +66,20 @@ extern unsigned int fc_debug_logging;
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
-			 printk(KERN_INFO "host%u: fcp: %6.6x: " fmt,	\
-				(pkt)->lp->host->host_no,		\
+			 printk(KERN_INFO "fcport%u: fcp: %6x: " fmt,	\
+				(pkt)->lp->fcport->id,			\
 				pkt->rport->port_id, ##args))
 
 #define FC_EXCH_DBG(exch, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
-			 printk(KERN_INFO "host%u: xid %4x: " fmt,	\
-				(exch)->lp->host->host_no,		\
+			 printk(KERN_INFO "fcport%u: xid %4x: " fmt,	\
+				(exch)->lp->fcport->id,			\
 				exch->xid, ##args))
 
 #define FC_SCSI_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_SCSI_LOGGING,				\
-			 printk(KERN_INFO "host%u: scsi: " fmt,		\
-				(lport)->host->host_no,	##args))
+			 printk(KERN_INFO "fcport%u: scsi: " fmt,	\
+				(lport)->fcport->id,	##args))
 
 /*
  * Set up direct-data placement for this I/O request
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 79c9e3c..2850405 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -247,50 +247,39 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
  * fc_get_host_port_state() - Return the port state of the given Scsi_Host
  * @shost:  The SCSI host whose port state is to be determined
  */
-void fc_get_host_port_state(struct Scsi_Host *shost)
+void fc_get_fcpinit_port_state(struct fc_fcpinit *fcpinit)
 {
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_lport *lport = fcpinit_to_lport(fcpinit);
 
 	mutex_lock(&lport->lp_mutex);
 	if (!lport->link_up)
-		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+		fcpinit_port_state(fcpinit) = FC_PORTSTATE_LINKDOWN;
 	else
 		switch (lport->state) {
 		case LPORT_ST_READY:
-			fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+			fcpinit_port_state(fcpinit) = FC_PORTSTATE_ONLINE;
 			break;
 		default:
-			fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+			fcpinit_port_state(fcpinit) = FC_PORTSTATE_OFFLINE;
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
+EXPORT_SYMBOL(fc_get_fcpinit_port_state);
 
 /**
  * fc_get_host_stats() - Return the Scsi_Host's statistics
  * @shost: The SCSI host whose statistics are to be returned
  */
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
+struct fcpinit_statistics *fc_get_fcpinit_stats(struct fc_fcpinit *fcpinit)
 {
-	struct fc_host_statistics *fcoe_stats;
-	struct fc_lport *lport = shost_priv(shost);
+	struct fcpinit_statistics *fcoe_stats;
+	struct fc_lport *lport = fcpinit_to_lport(fcpinit);
+	struct fc_fcp_internal *si = fcpinit_priv(fcpinit);
 	struct timespec v0, v1;
 	unsigned int cpu;
 
-	fcoe_stats = &lport->host_stats;
-	memset(fcoe_stats, 0, sizeof(struct fc_host_statistics));
+	fcoe_stats = &si->fcpinit_stats;
+	memset(fcoe_stats, 0, sizeof(struct fcpinit_statistics));
 
 	jiffies_to_timespec(jiffies, &v0);
 	jiffies_to_timespec(lport->boot_time, &v1);
@@ -322,7 +311,7 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	fcoe_stats->dumped_frames = -1;
 	return fcoe_stats;
 }
-EXPORT_SYMBOL(fc_get_host_stats);
+EXPORT_SYMBOL(fc_get_fcpinit_stats);
 
 /**
  * fc_lport_flogi_fill() - Fill in FLOGI command for request
@@ -339,8 +328,8 @@ static void fc_lport_flogi_fill(struct fc_lport *lport,
 
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) op;
-	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &flogi->fl_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &flogi->fl_wwnn);
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -483,8 +472,8 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 			rp->rnid.rnid_cmd = ELS_LS_ACC;
 			rp->rnid.rnid_fmt = fmt;
 			rp->rnid.rnid_cid_len = sizeof(rp->cid);
-			rp->cid.rnid_wwpn = htonll(lport->wwpn);
-			rp->cid.rnid_wwnn = htonll(lport->wwnn);
+			rp->cid.rnid_wwpn = htonll(fcvport_port_name(lport->fcvport));
+			rp->cid.rnid_wwnn = htonll(fcvport_node_name(lport->fcvport));
 			if (fmt == ELS_RNIDF_GEN) {
 				rp->rnid.rnid_sid_len = sizeof(rp->gen);
 				memcpy(&rp->gen, &lport->rnid_gen,
@@ -552,7 +541,6 @@ void __fc_linkup(struct fc_lport *lport)
 {
 	if (!lport->link_up) {
 		lport->link_up = 1;
-
 		if (lport->state == LPORT_ST_RESET)
 			fc_lport_enter_flogi(lport);
 	}
@@ -564,8 +552,8 @@ void __fc_linkup(struct fc_lport *lport)
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link up on port (%6.6x)\n",
-	       lport->host->host_no, lport->port_id);
+	printk(KERN_INFO "fcport%d: libfc: Link up on port (%6x)\n",
+	       lport->fcport->id, lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkup(lport);
@@ -584,7 +572,8 @@ void __fc_linkdown(struct fc_lport *lport)
 	if (lport->link_up) {
 		lport->link_up = 0;
 		fc_lport_enter_reset(lport);
-		lport->tt.fcp_cleanup(lport);
+		if (lport->tt.fcp_cleanup)
+			lport->tt.fcp_cleanup(lport);
 	}
 }
 
@@ -594,8 +583,8 @@ void __fc_linkdown(struct fc_lport *lport)
  */
 void fc_linkdown(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link down on port (%6.6x)\n",
-	       lport->host->host_no, lport->port_id);
+	printk(KERN_INFO "fcport%d: libfc: Link down on port (%6x)\n",
+	       lport->fcport->id, lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkdown(lport);
@@ -644,7 +633,13 @@ int fc_lport_destroy(struct fc_lport *lport)
 	lport->tt.frame_send = fc_frame_drop;
 	mutex_unlock(&lport->lp_mutex);
 
-	lport->tt.fcp_abort_io(lport);
+	/*
+	 * TODO: What should we be checking here? The existence of fcpinit or
+	 * the existence fcp_abort_io()?
+	 */
+	if (lport->fcpinit)
+		lport->tt.fcp_abort_io(lport);
+
 	lport->tt.disc_stop_final(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	return 0;
@@ -695,9 +690,9 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 		FC_LPORT_DBG(lport, "Discovery succeeded\n");
 		break;
 	case DISC_EV_FAILED:
-		printk(KERN_ERR "host%d: libfc: "
-		       "Discovery failed for port (%6.6x)\n",
-		       lport->host->host_no, lport->port_id);
+		printk(KERN_ERR "fcport%d: libfc: "
+		       "Discovery failed for port (%6x)\n",
+		       lport->fcport->id, lport->port_id);
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -721,8 +716,8 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
-	if (lport->vport)
-		fc_vport_set_state(lport->vport, FC_VPORT_ACTIVE);
+	if (!fc_fcvport_is_nport(lport->fcvport))
+		fc_vport_set_state(lport->fcvport, FC_VPORT_ACTIVE);
 	fc_vports_linkchange(lport);
 
 	if (!lport->ptp_rdata)
@@ -742,13 +737,11 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 				 struct fc_frame *fp)
 {
 	if (port_id)
-		printk(KERN_INFO "host%d: Assigned Port ID %6.6x\n",
-		       lport->host->host_no, port_id);
+		printk(KERN_INFO "fcport%d: Assigned Port ID %6x\n",
+		       lport->fcport->id, port_id);
 
 	lport->port_id = port_id;
-
-	/* Update the fc_host */
-	fc_host_port_id(lport->host) = port_id;
+	lport->fcvport->port_id = port_id;
 
 	if (lport->tt.lport_set_port_id)
 		lport->tt.lport_set_port_id(lport, port_id, fp);
@@ -791,10 +784,10 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	if (!flp)
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
-	if (remote_wwpn == lport->wwpn) {
-		printk(KERN_WARNING "host%d: libfc: Received FLOGI from port "
-		       "with same WWPN %16.16llx\n",
-		       lport->host->host_no, remote_wwpn);
+	if (remote_wwpn == fcvport_port_name(lport->fcvport)) {
+		printk(KERN_WARNING "fcport%d: libfc: Received FLOGI from port "
+		       "with same WWPN %llx\n",
+		       lport->fcport->id, remote_wwpn);
 		goto out;
 	}
 	FC_LPORT_DBG(lport, "FLOGI from port WWPN %16.16llx\n", remote_wwpn);
@@ -805,7 +798,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	 * But if so, both of us could end up with the same FID.
 	 */
 	local_fid = FC_LOCAL_PTP_FID_LO;
-	if (remote_wwpn < lport->wwpn) {
+	if (remote_wwpn < fcvport_port_name(lport->fcvport)) {
 		local_fid = FC_LOCAL_PTP_FID_HI;
 		if (!remote_fid || remote_fid == local_fid)
 			remote_fid = FC_LOCAL_PTP_FID_LO;
@@ -952,7 +945,9 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	lport->tt.disc_stop(lport);
 
 	lport->tt.exch_mgr_reset(lport, 0, 0);
-	fc_host_fabric_name(lport->host) = 0;
+
+	if (lport->fcfabric)
+		fcfabric_fabric_name(lport->fcfabric) = 0;
 
 	if (lport->port_id)
 		fc_lport_set_port_id(lport, 0, NULL);
@@ -973,15 +968,18 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 	if (lport->state == LPORT_ST_DISABLED || lport->state == LPORT_ST_LOGO)
 		return;
 
-	if (lport->vport) {
+	if (!fc_fcvport_is_nport(lport->fcvport)) {
 		if (lport->link_up)
-			fc_vport_set_state(lport->vport, FC_VPORT_INITIALIZING);
+			fc_vport_set_state(lport->fcvport,
+					   FC_VPORT_INITIALIZING);
 		else
-			fc_vport_set_state(lport->vport, FC_VPORT_LINKDOWN);
+			fc_vport_set_state(lport->fcvport,
+					   FC_VPORT_LINKDOWN);
 	}
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
 	fc_vports_linkchange(lport);
 	fc_lport_reset_locked(lport);
+
 	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
 }
@@ -1228,7 +1226,7 @@ static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 		size += sizeof(struct fc_ns_rn_id);
 		break;
 	case LPORT_ST_RSNN_NN:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 		/* if there is no symbolic name, skip to RFT_ID */
 		if (!len)
 			return fc_lport_enter_ns(lport, LPORT_ST_RFT_ID);
@@ -1236,7 +1234,7 @@ static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 		size += sizeof(struct fc_ns_rsnn) + len;
 		break;
 	case LPORT_ST_RSPN_ID:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 		/* if there is no symbolic name, skip to RFT_ID */
 		if (!len)
 			return fc_lport_enter_ns(lport, LPORT_ST_RFT_ID);
@@ -1411,6 +1409,15 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 	FC_LPORT_DBG(lport, "Entered LOGO state from %s state\n",
 		     fc_lport_state(lport));
 
+	/*
+	 * TODO: Is this check sufficient? The port_id is set in the
+	 * FLOGI response just after the vport is added. There's also
+	 * a vport->port_id that is set at the same time, but I don't
+	 * think that it is getting cleared.
+	 */
+	if (lport->port_id != 0)
+		fc_fcvport_del(lport->fcvport);
+
 	fc_lport_state_enter(lport, LPORT_ST_LOGO);
 	fc_vports_linkchange(lport);
 
@@ -1448,8 +1455,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int e_d_tov;
 	u16 mfs;
 
-	FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc_els_resp_type(fp));
-
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
@@ -1491,10 +1496,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
 				fc_lport_set_port_id(lport, did, fp);
-				printk(KERN_INFO "host%d: libfc: "
-				       "Port (%6.6x) entered "
-				       "point-to-point mode\n",
-				       lport->host->host_no, did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
@@ -1503,15 +1504,22 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			} else {
 				lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = r_a_tov;
-				fc_host_fabric_name(lport->host) =
-					get_unaligned_be64(&flp->fl_wwnn);
+
 				fc_lport_set_port_id(lport, did, fp);
+
+				fc_fcvport_add(lport->fcvport, lport->fcfabric);
+
+				/*
+				 * TODO: This seems redundant. Can't the vport
+				 * port_id get set in fc_lport_set_port_id()?
+				 */
+				fcvport_port_id(lport->fcvport) = lport->port_id;
+
 				fc_lport_enter_dns(lport);
 			}
 		}
-	} else {
+	} else
 		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
-	}
 
 out:
 	fc_frame_free(fp);
@@ -1541,10 +1549,10 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 		return fc_lport_error(lport, fp);
 
 	if (!lport->tt.elsct_send(lport, FC_FID_FLOGI, fp,
-				  lport->vport ? ELS_FDISC : ELS_FLOGI,
+				  fc_fcvport_is_nport(lport->fcvport) ? ELS_FLOGI : ELS_FDISC,
 				  fc_lport_flogi_resp, lport,
-				  lport->vport ? 2 * lport->r_a_tov :
-				  lport->e_d_tov))
+				  fc_fcvport_is_nport(lport->fcvport) ? lport->e_d_tov :
+				  2 * lport->r_a_tov))
 		fc_lport_error(lport, NULL);
 }
 
@@ -1554,11 +1562,19 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
  */
 int fc_lport_config(struct fc_lport *lport)
 {
+	INIT_LIST_HEAD(&lport->ema_list);
+	INIT_LIST_HEAD(&lport->vports);
 	INIT_DELAYED_WORK(&lport->retry_work, fc_lport_timeout);
 	mutex_init(&lport->lp_mutex);
 
 	fc_lport_state_enter(lport, LPORT_ST_DISABLED);
 
+	/*
+	 * TODO: This is a bit goofy. We either need to
+	 * use the fcport speeds and not have a lport copy
+	 * or have a lport copy and have a get_fcport_*speed*()
+	 * routine.
+	 */
 	fc_lport_add_fc4_type(lport, FC_TYPE_FCP);
 	fc_lport_add_fc4_type(lport, FC_TYPE_CT);
 
@@ -1566,6 +1582,26 @@ int fc_lport_config(struct fc_lport *lport)
 }
 EXPORT_SYMBOL(fc_lport_config);
 
+void fc_lport_port_config(struct fc_fcport *fcport)
+{
+	fcport_supported_fc4s(fcport)[2] = 1;
+	fcport_supported_fc4s(fcport)[7] = 1;
+	fcport_active_fc4s(fcport)[2] = 1;
+	fcport_active_fc4s(fcport)[7] = 1;
+
+	fcport_supported_classes(fcport) = FC_COS_CLASS3;
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
@@ -1578,27 +1614,6 @@ int fc_lport_init(struct fc_lport *lport)
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
-
 	return 0;
 }
 EXPORT_SYMBOL(fc_lport_init);
diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index dd2b43b..4154090 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -24,38 +24,32 @@
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
+		       struct fc_fcvport *vport)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fc_lport *vn_port;
-
-	vn_port = libfc_host_alloc(shost->hostt, privsize);
-	if (!vn_port)
-		goto err_out;
 	if (fc_exch_mgr_list_clone(n_port, vn_port))
-		goto err_put;
+		return -ENOMEM;
 
-	vn_port->vport = vport;
-	vport->dd_data = vn_port;
+	vn_port->fcvport = vport;
+	vn_port->fcfabric = n_port->fcfabric;
+	vn_port->fcport = n_port->fcport;
+
+/*
+	FCOE_NETDEV_DBG(netdev, "Setting vport names, 0x%llX 0x%llX\n",
+			vport->node_name, vport->port_name);
+*/
 
 	mutex_lock(&n_port->lp_mutex);
 	list_add_tail(&vn_port->list, &n_port->vports);
 	mutex_unlock(&n_port->lp_mutex);
 
-	return vn_port;
-
-err_put:
-	scsi_host_put(vn_port->host);
-err_out:
-	return NULL;
+	return 0;
 }
-EXPORT_SYMBOL(libfc_vport_create);
+EXPORT_SYMBOL(libfc_vport_config);
 
 /**
  * fc_vport_id_lookup() - find NPIV lport that matches a given fabric ID
@@ -108,10 +102,11 @@ enum libfc_lport_mutex_class {
 static void __fc_vport_setlink(struct fc_lport *n_port,
 			       struct fc_lport *vn_port)
 {
-	struct fc_vport *vport = vn_port->vport;
+	struct fc_fcvport *vport = vn_port->fcvport;
 
-	if (vn_port->state == LPORT_ST_DISABLED)
+	if (vn_port->state == LPORT_ST_DISABLED) {
 		return;
+	}
 
 	if (n_port->state == LPORT_ST_READY) {
 		if (n_port->npiv_enabled) {
@@ -133,9 +128,8 @@ static void __fc_vport_setlink(struct fc_lport *n_port,
  */
 void fc_vport_setlink(struct fc_lport *vn_port)
 {
-	struct fc_vport *vport = vn_port->vport;
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
+	struct fc_fcvport *vport = fc_fcfabric_find_nport(vn_port->fcfabric);
+	struct fc_lport *n_port = fcvport_priv(vport);
 
 	mutex_lock(&n_port->lp_mutex);
 	mutex_lock_nested(&vn_port->lp_mutex, LPORT_MUTEX_VN_PORT);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 39e440f..a1b445a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -263,7 +263,9 @@ static void fc_rport_work(struct work_struct *work)
 		mutex_unlock(&rdata->rp_mutex);
 
 		if (!rport)
-			rport = fc_remote_port_add(lport->host, 0, &ids);
+			rport = fc_fcrport_add(lport->fcvport,
+					       lport->fcrport_f,
+					       0, &ids);
 		if (!rport) {
 			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
 			lport->tt.rport_logoff(rdata);
@@ -334,7 +336,7 @@ static void fc_rport_work(struct work_struct *work)
 			mutex_lock(&rdata->rp_mutex);
 			rdata->rport = NULL;
 			mutex_unlock(&rdata->rp_mutex);
-			fc_remote_port_delete(rport);
+			fc_fcrport_del(rport);
 		}
 		if (restart) {
 			mutex_lock(&rdata->rp_mutex);
@@ -1113,13 +1115,14 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 
 {
 	struct fc_lport *lport = rdata->local_port;
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	struct fc_frame *fp;
 	struct fc_exch *ep = fc_seq_exch(sp);
 	struct fc_els_rls *rls;
 	struct fc_els_rls_resp *rsp;
 	struct fc_els_lesb *lesb;
 	struct fc_seq_els_data rjt_data;
-	struct fc_host_statistics *hst;
+	struct fcpinit_statistics *hst;
 	u32 f_ctl;
 
 	FC_RPORT_DBG(rdata, "Received RLS request while in state %s\n",
@@ -1147,8 +1150,8 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
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
@@ -1360,7 +1363,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		break;
 	case RPORT_ST_PLOGI:
 		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state\n");
-		if (rdata->ids.port_name < lport->wwpn) {
+		if (rdata->ids.port_name < fcvport_port_name(lport->fcvport)) {
 			mutex_unlock(&rdata->rp_mutex);
 			rjt_data.reason = ELS_RJT_INPROG;
 			rjt_data.explan = ELS_EXPL_NONE;
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 9b4867c..bb5c2cc 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -72,8 +72,10 @@ static inline void fc_adisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
 	memset(adisc, 0, sizeof(*adisc));
 	adisc->adisc_cmd = ELS_ADISC;
-	put_unaligned_be64(lport->wwpn, &adisc->adisc_wwpn);
-	put_unaligned_be64(lport->wwnn, &adisc->adisc_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport),
+			   &adisc->adisc_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport),
+			   &adisc->adisc_wwnn);
 	hton24(adisc->adisc_port_id, lport->port_id);
 }
 
@@ -144,24 +146,26 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 	case FC_NS_RNN_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rn_id));
 		hton24(ct->payload.rn.fr_fid.fp_fid, lport->port_id);
-		put_unaligned_be64(lport->wwnn, &ct->payload.rn.fr_wwn);
+		put_unaligned_be64(fcvport_node_name(lport->fcvport),
+				   &ct->payload.rn.fr_wwn);
 		break;
 
 	case FC_NS_RSPN_ID:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rspn) + len);
 		hton24(ct->payload.spn.fr_fid.fp_fid, lport->port_id);
 		strncpy(ct->payload.spn.fr_name,
-			fc_host_symbolic_name(lport->host), len);
+			fcvport_symbolic_name(lport->fcvport), len);
 		ct->payload.spn.fr_name_len = len;
 		break;
 
 	case FC_NS_RSNN_NN:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rsnn) + len);
-		put_unaligned_be64(lport->wwnn, &ct->payload.snn.fr_wwn);
+		put_unaligned_be64(fcvport_node_name(lport->fcvport),
+				   &ct->payload.snn.fr_wwn);
 		strncpy(ct->payload.snn.fr_name,
-			fc_host_symbolic_name(lport->host), len);
+			fcvport_symbolic_name(lport->fcvport), len);
 		ct->payload.snn.fr_name_len = len;
 		break;
 
@@ -186,8 +190,8 @@ static inline void fc_plogi_fill(struct fc_lport *lport, struct fc_frame *fp,
 	plogi = fc_frame_payload_get(fp, sizeof(*plogi));
 	memset(plogi, 0, sizeof(*plogi));
 	plogi->fl_cmd = (u8) op;
-	put_unaligned_be64(lport->wwpn, &plogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &plogi->fl_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &plogi->fl_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &plogi->fl_wwnn);
 
 	csp = &plogi->fl_csp;
 	csp->sp_hi_ver = 0x20;
@@ -218,8 +222,8 @@ static inline void fc_flogi_fill(struct fc_lport *lport, struct fc_frame *fp)
 	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) ELS_FLOGI;
-	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &flogi->fl_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &flogi->fl_wwnn);
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -243,8 +247,8 @@ static inline void fc_fdisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 	fdisc = fc_frame_payload_get(fp, sizeof(*fdisc));
 	memset(fdisc, 0, sizeof(*fdisc));
 	fdisc->fl_cmd = (u8) ELS_FDISC;
-	put_unaligned_be64(lport->wwpn, &fdisc->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &fdisc->fl_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &fdisc->fl_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &fdisc->fl_wwnn);
 	sp = &fdisc->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -265,7 +269,7 @@ static inline void fc_logo_fill(struct fc_lport *lport, struct fc_frame *fp)
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
 	hton24(logo->fl_n_port_id, lport->port_id);
-	logo->fl_n_port_wwn = htonll(lport->wwpn);
+	logo->fl_n_port_wwn = htonll(fcvport_port_name(lport->fcvport));
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7495c0b..3e924fa 100644
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
@@ -35,6 +36,9 @@
 
 #include <scsi/fc_frame.h>
 
+#define fcpinit_to_lport(x)						\
+	fcvport_priv((struct fc_fcvport *)(fcpinit_to_fcvport(x)))
+
 /*
  * libfc error codes
  */
@@ -149,6 +153,7 @@ enum fc_rport_event {
 };
 
 struct fc_rport_priv;
+struct fc_fcp_internal;
 
 /**
  * struct fc_rport_operations - Operations for a remote port
@@ -725,6 +730,12 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	void (*disc_stop_final) (struct fc_lport *);
+
+	void (*set_fcvport_symbolic_name)(struct fc_lport *);
+	void (*set_fcvport_node_name)(struct fc_lport *);
+	void (*set_fcvport_port_name)(struct fc_lport *);
+	void (*get_vport_ids)(struct fc_lport *,
+			      struct fc_vport_identifiers *);
 };
 
 /**
@@ -805,24 +816,19 @@ struct fc_disc {
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
 	struct list_head	       vports;
-	struct fc_vport		       *vport;
 
 	/* Operational Information */
 	struct libfc_function_template tt;
 	u8			       link_up;
-	u8			       qfull;
 	enum fc_lport_state	       state;
 	unsigned long		       boot_time;
-	struct fc_host_statistics      host_stats;
 	struct fcoe_dev_stats	       *dev_stats;
 	u8			       retry_count;
 
@@ -830,6 +836,7 @@ struct fc_lport {
 	u32                            port_id;
 	u64			       wwpn;
 	u64			       wwnn;
+
 	unsigned int		       service_params;
 	unsigned int		       e_d_tov;
 	unsigned int		       r_a_tov;
@@ -851,12 +858,55 @@ struct fc_lport {
 	unsigned int		       lso_max;
 	struct fc_ns_fts	       fcts;
 
+	/* sysfs representation */
+	struct fc_fcport               *fcport;
+	struct fc_fcfabric             *fcfabric;
+	struct fc_fcvport              *fcvport;
+	struct fc_fcpinit              *fcpinit;
+
 	/* Miscellaneous */
 	struct mutex                   lp_mutex;
 	struct list_head               list;
 	struct delayed_work	       retry_work;
+
+	struct fcfabric_function_template *fcfabric_f;
+	struct fcvport_function_template *fcvport_f;
+	struct fcrport_function_template *fcrport_f;
+
+	void			       *scsi_priv;
+};
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
+	u8			       qfull;
+	struct fcpinit_statistics      fcpinit_stats;
 };
 
+#define lport_to_fcvport(x)			\
+	(struct fc_fcvport *)((x)->fcvport)
+
+#define fc_get_scsi_internal(x)						\
+	((struct fc_fcp_internal *)(fcpinit_priv(fcvport_to_fcpinit(lport_to_fcvport(x)))))
+
 /*
  * FC_LPORT HELPER FUNCTIONS
  *****************************/
@@ -871,26 +921,6 @@ static inline int fc_lport_test_ready(struct fc_lport *lport)
 }
 
 /**
- * fc_set_wwnn() - Set the World Wide Node Name of a local port
- * @lport: The local port whose WWNN is to be set
- * @wwnn:  The new WWNN
- */
-static inline void fc_set_wwnn(struct fc_lport *lport, u64 wwnn)
-{
-	lport->wwnn = wwnn;
-}
-
-/**
- * fc_set_wwpn() - Set the World Wide Port Name of a local port
- * @lport: The local port whose WWPN is to be set
- * @wwnn:  The new WWPN
- */
-static inline void fc_set_wwpn(struct fc_lport *lport, u64 wwnn)
-{
-	lport->wwpn = wwnn;
-}
-
-/**
  * fc_lport_state_enter() - Change a local port's state
  * @lport: The local port whose state is to change
  * @state: The new state
@@ -933,30 +963,6 @@ static inline void *lport_priv(const struct fc_lport *lport)
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
@@ -983,7 +989,8 @@ void fc_vports_linkchange(struct fc_lport *);
 int fc_lport_config(struct fc_lport *);
 int fc_lport_reset(struct fc_lport *);
 int fc_set_mfs(struct fc_lport *, u32 mfs);
-struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
+int libfc_vport_config(struct fc_lport *n_port, struct fc_lport *vn_port,
+		       struct fc_fcvport *);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
 int fc_lport_bsg_request(struct fc_bsg_job *);
 
@@ -1001,7 +1008,7 @@ int fc_disc_init(struct fc_lport *);
 /*
  * FCP LAYER
  *****************************/
-int fc_fcp_init(struct fc_lport *);
+int fc_fcp_init(struct fc_fcpinit *);
 void fc_fcp_destroy(struct fc_lport *);
 
 /*
@@ -1050,9 +1057,11 @@ void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 /*
  * Functions for fc_functions_template
  */
-void fc_get_host_speed(struct Scsi_Host *);
-void fc_get_host_port_state(struct Scsi_Host *);
+void fc_get_fcpinit_port_state(struct fc_fcpinit *);
 void fc_set_rport_loss_tmo(struct fc_rport *, u32 timeout);
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *);
+struct fcpinit_statistics *fc_get_fcpinit_stats(struct fc_fcpinit *);
+
+
+void fc_lport_port_config(struct fc_fcport *fcport);
 
 #endif /* _LIBFC_H_ */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index ec13f51..c901b2f 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -114,11 +114,19 @@ struct fcoe_ctlr {
 	u8 dest_addr[ETH_ALEN];
 	u8 ctl_src_addr[ETH_ALEN];
 
+	char work_q_name[20];
+	struct workqueue_struct *work_q;
+
 	void (*send)(struct fcoe_ctlr *, struct sk_buff *);
 	void (*update_mac)(struct fc_lport *, u8 *addr);
 	u8 * (*get_src_addr)(struct fc_lport *);
 	spinlock_t lock;
 };
+#define fcoe_ctlr_work_q(x)			\
+	((x)->work_q)
+#define fcoe_ctlr_work_q_name(x)		\
+	((x)->work_q_name)
+
 
 /**
  * struct fcoe_fcf - Fibre-Channel Forwarder
@@ -154,6 +162,13 @@ struct fcoe_fcf {
 	u16 flags;
 	u32 fka_period;
 	u8 fd_flags:1;
+
+	struct fc_fcfabric *fcfabric;
+	struct fcfabric_function_template *fcfabric_f;
+	struct fcvport_function_template *fcvport_f;
+	struct fc_fcport *fcport;
+
+	struct work_struct fcf_work;
 };
 
 /* FIP API functions */
@@ -168,6 +183,6 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 
 /* libfcoe funcs */
 u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
-int fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
+void fcoe_libfc_config(struct fc_lport *, struct libfc_function_template *);
 
 #endif /* _LIBFCOE_H */

