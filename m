From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 6/6] libfc, libfcoe, fcoe: Make use of FC sysfs
Date: Wed, 27 Jan 2010 15:24:48 -0800
Message-ID: <20100127232448.10343.38621.stgit@localhost.localdomain>
References: <20100127232415.10343.86703.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab0A0XYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2010 18:24:50 -0500
In-Reply-To: <20100127232415.10343.86703.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: giridhar.malavali@qlogic.com

Previously the lport was allocated with the scsi_host,
but with FC sysfs the scsi_host is not allocated until
the lport is READY. This patch changes libfc such that
the lport is allocated with the fcport and not with the
scsi_host. FCP information is still allocated with the
scsi_host.

libfc, libfcoe and fcoe also needed to create the
various FC sysfs object as information was discovered
durring login.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |  522 ++++++++++++++++++++++++++---------------
 drivers/scsi/fcoe/libfcoe.c   |   43 ++-
 drivers/scsi/libfc/fc_disc.c  |    4 
 drivers/scsi/libfc/fc_exch.c  |    2 
 drivers/scsi/libfc/fc_fcp.c   |  130 ++++++----
 drivers/scsi/libfc/fc_libfc.h |   28 +-
 drivers/scsi/libfc/fc_lport.c |  189 ++++++++-------
 drivers/scsi/libfc/fc_npiv.c  |   52 ++--
 drivers/scsi/libfc/fc_rport.c |   12 +
 include/scsi/fc.h             |    3 
 include/scsi/fc_encode.h      |   30 +-
 include/scsi/libfc.h          |  127 +++++++---
 12 files changed, 697 insertions(+), 445 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a719994..7734638 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -40,6 +40,7 @@
 #include <scsi/fc/fc_fip.h>
 
 #include <scsi/libfc.h>
+#include <scsi/fc.h>
 #include <scsi/fc_frame.h>
 #include <scsi/libfcoe.h>
 
@@ -116,6 +117,15 @@ static void fcoe_recv_frame(struct sk_buff *skb);
 
 static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
 
+static void fcoe_shost_config(struct fc_lport *lport, struct fc_fcp_internal *si);
+static void fcoe_set_symbolic_name(struct fc_lport *);
+static void fcoe_set_node_name(struct fc_lport *);
+static void fcoe_set_port_name(struct fc_lport *);
+static void fcoe_set_max_npiv_vports(struct fc_lport *);
+static void fcoe_get_vport_ids(struct fc_lport *lport,
+			       struct fc_vport_identifiers *ids);
+
+
 module_param_call(create, fcoe_create, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
 MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
@@ -142,10 +152,29 @@ static struct notifier_block fcoe_cpu_notifier = {
 static struct scsi_transport_template *fcoe_transport_template;
 static struct scsi_transport_template *fcoe_vport_transport_template;
 
-static int fcoe_vport_destroy(struct fc_vport *);
-static int fcoe_vport_create(struct fc_vport *, bool disabled);
-static int fcoe_vport_disable(struct fc_vport *, bool disable);
-static void fcoe_set_vport_symbolic_name(struct fc_vport *);
+static int fcoe_vport_destroy(void *, struct fc_fcvport *);
+static int fcoe_vport_create(void *, struct fc_fcvport *, bool disabled);
+static int fcoe_vport_disable(struct fc_fcvport *, bool disable);
+static void fcoe_set_vport_symbolic_name(struct fc_fcvport *);
+
+static struct scsi_host_template fcoe_shost_template = {
+	.module = THIS_MODULE,
+	.name = "FCoE Driver",
+	.proc_name = FCOE_NAME,
+	.queuecommand = fc_queuecommand,
+	.eh_abort_handler = fc_eh_abort,
+	.eh_device_reset_handler = fc_eh_device_reset,
+	.eh_host_reset_handler = fc_eh_host_reset,
+	.slave_alloc = fc_slave_alloc,
+	.change_queue_depth = fc_change_queue_depth,
+	.change_queue_type = fc_change_queue_type,
+	.this_id = -1,
+	.cmd_per_lun = 3,
+	.can_queue = FCOE_MAX_OUTSTANDING_COMMANDS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.sg_tablesize = SG_ALL,
+	.max_sectors = 0xffff,
+};
 
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
@@ -153,102 +182,169 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.ddp_done = fcoe_ddp_done,
 	.elsct_send = fcoe_elsct_send,
 	.get_lesb = fcoe_get_lesb,
+	.shost_template = &fcoe_shost_template,
+	.shost_config = fcoe_shost_config,
+	.set_fcvport_symbolic_name = fcoe_set_symbolic_name,
+	.set_fcvport_node_name = fcoe_set_node_name,
+	.set_fcvport_port_name = fcoe_set_port_name,
+	.set_fcfabric_max_npiv_vports = fcoe_set_max_npiv_vports,
+	.get_vport_ids = fcoe_get_vport_ids,
 };
 
 struct fc_function_template fcoe_transport_function = {
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
 	.get_host_port_state = fc_get_host_port_state,
 	.show_host_port_state = 1,
-	.show_host_symbolic_name = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 
-	.show_host_fabric_name = 1,
 	.show_starget_node_name = 1,
 	.show_starget_port_name = 1,
 	.show_starget_port_id = 1,
 	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
+	.get_fcpinit_stats = fc_get_host_stats,
+	.issue_fcpinit_lip = fcoe_reset,
 
 	.terminate_rport_io = fc_rport_terminate_io,
 
-	.vport_create = fcoe_vport_create,
-	.vport_delete = fcoe_vport_destroy,
-	.vport_disable = fcoe_vport_disable,
-	.set_vport_symbolic_name = fcoe_set_vport_symbolic_name,
-
 	.bsg_request = fc_lport_bsg_request,
 };
 
 struct fc_function_template fcoe_vport_transport_function = {
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
 	.get_host_port_state = fc_get_host_port_state,
 	.show_host_port_state = 1,
-	.show_host_symbolic_name = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 
-	.show_host_fabric_name = 1,
 	.show_starget_node_name = 1,
 	.show_starget_port_name = 1,
 	.show_starget_port_id = 1,
 	.set_rport_dev_loss_tmo = fc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
-	.get_fc_host_stats = fc_get_host_stats,
-	.issue_fc_host_lip = fcoe_reset,
+	.get_fcpinit_stats = fc_get_host_stats,
+	.issue_fcpinit_lip = fcoe_reset,
 
 	.terminate_rport_io = fc_rport_terminate_io,
 
 	.bsg_request = fc_lport_bsg_request,
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
+struct fcport_function_template fcoe_fcport_fcn_tmpl = {
+	.show_fcport_maxframe_size = 1,
+	.show_fcport_supported_speeds = 1,
+	.show_fcport_supported_classes = 1,
+	.show_fcport_speed = 1,
+	.show_fcport_supported_fc4s = 1,
+	.show_fcport_active_fc4s = 1,
+	.show_fcport_serial_number = 1,
 };
 
+struct fcfabric_function_template fcoe_fcfabric_fcn_tmpl = {
+	.vport_create = fcoe_vport_create,
+	.vport_delete = fcoe_vport_destroy,
+	.vport_disable = fcoe_vport_disable,
+
+	.show_fcfabric_fabric_name = 1,
+};
+
+struct fcvport_function_template fcoe_fcvport_fcn_tmpl = {
+	.show_fcvport_port_id = 1,
+	.show_fcvport_symbolic_name = 1,
+	.show_fcvport_node_name = 1,
+	.show_fcvport_port_name = 1,
+	.show_fcvport_port_type = 1,
+};
+
+static void fcoe_get_vport_ids(struct fc_lport *lport,
+			       struct fc_vport_identifiers *ids)
+{
+	struct fcoe_port *port = lport_priv(lport);
+	struct fcoe_interface *fcoe = port->fcoe;
+	int vid = 0;
+
+	if (fcoe->netdev->priv_flags & IFF_802_1Q_VLAN)
+		vid = vlan_dev_vlan_id(fcoe->netdev);
+
+	ids->node_name = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+	ids->port_name = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, vid);
+
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
+		 fcoe_netdev(lport)->name);
+}
+
+static void fcoe_set_max_npiv_vports(struct fc_lport *lport)
+{
+	fcfabric_max_npiv_vports(lport->fcfabric) = USHORT_MAX;
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
+	  RWL - removed a if(!lport->vport) check, since this routine shoud
+	  be used for all vports (real or virtual) I think it should be OK 
+	*/
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
+	  RWL - removed a if(!lport->vport) check, since this routine shoud
+	  be used for all vports (real or virtual) I think it should be OK 
+	*/
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
+
 /**
  * fcoe_interface_setup() - Setup a FCoE interface
  * @fcoe:   The new FCoE interface
@@ -517,8 +613,10 @@ static u8 *fcoe_get_src_mac(struct fc_lport *lport)
  */
 static int fcoe_lport_config(struct fc_lport *lport)
 {
+	lport->fcfabric_f = &fcoe_fcfabric_fcn_tmpl;
+	lport->fcvport_f = &fcoe_fcvport_fcn_tmpl;
+
 	lport->link_up = 0;
-	lport->qfull = 0;
 	lport->max_retry_count = 3;
 	lport->max_rport_retry_count = 3;
 	lport->e_d_tov = 2 * 1000;	/* FC-FS default */
@@ -582,10 +680,8 @@ static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
 static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 {
 	u32 mfs;
-	u64 wwnn, wwpn;
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
-	int vid = 0;
 
 	/* Setup lport private data to point to fcoe softc */
 	port = lport_priv(lport);
@@ -629,25 +725,12 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
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
@@ -656,42 +739,25 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
  * fcoe_shost_config() - Set up the SCSI host associated with a local port
  * @lport: The local port
  * @shost: The SCSI host to associate with the local port
- * @dev:   The device associated with the SCSI host
  *
  * Must be called after fcoe_lport_config() and fcoe_netdev_config()
  *
  * Returns: 0 for success
  */
-static int fcoe_shost_config(struct fc_lport *lport, struct Scsi_Host *shost,
-			     struct device *dev)
+static void fcoe_shost_config(struct fc_lport *lport, struct fc_fcp_internal *si)
 {
-	int rc = 0;
-
 	/* lport scsi host config */
-	lport->host->max_lun = FCOE_MAX_LUN;
-	lport->host->max_id = FCOE_MAX_FCP_TARGET;
-	lport->host->max_channel = 0;
-	if (lport->vport)
-		lport->host->transportt = fcoe_vport_transport_template;
-	else
-		lport->host->transportt = fcoe_transport_template;
+	si->host->max_lun = FCOE_MAX_LUN;
+	si->host->max_id = FCOE_MAX_FCP_TARGET;
+	si->host->max_channel = 0;
 
-	/* add the new host to the SCSI-ml */
-	rc = scsi_add_host(lport->host, dev);
-	if (rc) {
-		FCOE_NETDEV_DBG(fcoe_netdev(lport), "fcoe_shost_config: "
-				"error on scsi_add_host\n");
-		return rc;
-	}
+	/* RWL - Should this directly change the scsi_host? what is this val used for */
+	si->qfull = 0;
 
-	if (!lport->vport)
-		fc_host_max_npiv_vports(lport->host) = USHORT_MAX;
-
-	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
-		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
-		 fcoe_netdev(lport)->name);
-
-	return 0;
+	if (!fc_fcvport_is_nport(&lport->fcvport->gendev, NULL))
+		si->host->transportt = fcoe_vport_transport_template;
+	else
+		si->host->transportt = fcoe_transport_template;
 }
 
 /**
@@ -812,8 +878,15 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 
 	/* Cleanup the fc_lport */
 	fc_lport_destroy(lport);
+
+	/*
+	 * TODO: It cannot be assumed that FCP was initiatlized.
+	 */
 	fc_fcp_destroy(lport);
 
+	if (!lport->fcpinit)
+		printk(KERN_ERR "RWL: fcoe_if_destroy - NO fcpinit\n");
+
 	/* Stop the transmit retry timer */
 	del_timer_sync(&port->timer);
 
@@ -831,18 +904,17 @@ static void fcoe_if_destroy(struct fc_lport *lport)
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
+	/*
+	 * TODO: Where does the fcport get freed?
+	 */
+
+	fc_lport_free(lport);
 }
 
 /**
@@ -883,6 +955,25 @@ static int fcoe_ddp_done(struct fc_lport *lport, u16 xid)
 	return 0;
 }
 
+static struct fc_lport *fcoe_lport_create(struct fcoe_interface *fcoe)
+{
+	struct fc_lport *lport;
+	struct fcoe_port *port;
+
+	lport = fc_lport_alloc(sizeof(struct fcoe_port));
+	if (!lport)
+		return NULL;
+
+	port = lport_priv(lport);
+
+	port->lport = lport;
+	port->fcoe = fcoe;
+	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
+
+	return lport;
+}
+
+
 /**
  * fcoe_if_create() - Create a FCoE instance on an interface
  * @fcoe:   The FCoE interface to create a local port on
@@ -893,53 +984,24 @@ static int fcoe_ddp_done(struct fc_lport *lport, u16 xid)
  *
  * Returns: The allocated fc_lport or an error pointer
  */
-static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
-				       struct device *parent, int npiv)
+static int fcoe_if_create(struct fc_lport *lport, struct fcoe_interface *fcoe,
+			  struct device *parent, int npiv)
 {
 	struct net_device *netdev = fcoe->netdev;
-	struct fc_lport *lport = NULL;
-	struct fcoe_port *port;
-	struct Scsi_Host *shost;
-	int rc;
+	int rc = 0;
 	/*
 	 * parent is only a vport if npiv is 1,
 	 * but we'll only use vport in that case so go ahead and set it
 	 */
-	struct fc_vport *vport = dev_to_vport(parent);
 
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
-	shost = lport->host;
-	port = lport_priv(lport);
-	port->lport = lport;
-	port->fcoe = fcoe;
-	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
-
 	/* configure a fc_lport including the exchange manager */
 	rc = fcoe_lport_config(lport);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure lport for the "
 				"interface\n");
-		goto out_host_put;
-	}
-
-	if (npiv) {
-		FCOE_NETDEV_DBG(netdev, "Setting vport names, 0x%llX 0x%llX\n",
-				vport->node_name, vport->port_name);
-		fc_set_wwnn(lport, vport->node_name);
-		fc_set_wwpn(lport, vport->port_name);
+		goto out;
 	}
 
 	/* configure lport network properties */
@@ -950,14 +1012,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
-	/* configure lport scsi host properties */
-	rc = fcoe_shost_config(lport, shost, parent);
-	if (rc) {
-		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
-				"interface\n");
-		goto out_lp_destroy;
-	}
-
 	/* Initialize the library */
 	rc = fcoe_libfc_config(lport, &fcoe_libfc_fcn_templ);
 	if (rc) {
@@ -987,14 +1041,13 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
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
@@ -1717,6 +1770,7 @@ int fcoe_percpu_receive_thread(void *arg)
 static void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb)
 {
 	struct fcoe_port *port = lport_priv(lport);
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	int rc;
 
 	spin_lock_bh(&port->fcoe_pending_queue.lock);
@@ -1748,13 +1802,13 @@ static void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb)
 	}
 
 	if (port->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
-		lport->qfull = 0;
+		si->qfull = 0;
 	if (port->fcoe_pending_queue.qlen && !timer_pending(&port->timer))
 		mod_timer(&port->timer, jiffies + 2);
 	port->fcoe_pending_queue_active = 0;
 out:
 	if (port->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-		lport->qfull = 1;
+		si->qfull = 1;
 	spin_unlock_bh(&port->fcoe_pending_queue.lock);
 	return;
 }
@@ -1838,7 +1892,13 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 				"from netdev netlink\n", event);
 	}
 
-	fcoe_link_speed_update(lport);
+	/*
+	 * TODO: This is bad to have a special case for
+	 * the N_Port since it's the only vport/lport with
+	 * a fcport.
+	 */
+	if (lport->fcport)
+		fcoe_link_speed_update(lport);
 
 	if (link_possible && !fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
@@ -2015,6 +2075,7 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	fcoe_interface_cleanup(fcoe);
 	rtnl_unlock();
 	fcoe_if_destroy(fcoe->ctlr.lp);
+
 out_putdev:
 	dev_put(netdev);
 out_nodev:
@@ -2047,7 +2108,12 @@ static void fcoe_destroy_work(struct work_struct *work)
  */
 static int fcoe_create(const char *buffer, struct kernel_param *kp)
 {
-	int rc;
+	/*
+	 * TODO: rc and error can probably be consolidated.
+	 */
+	int rc = 0;
+	int error = 0;
+	struct fc_vport_identifiers ids;
 	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
 	struct net_device *netdev;
@@ -2084,8 +2150,31 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 		goto out_putdev;
 	}
 
-	lport = fcoe_if_create(fcoe, &netdev->dev, 0);
-	if (IS_ERR(lport)) {
+	/*
+	 * TODO: Check error conditions here and from the return of fc_fcport_add
+	 */
+	lport = fcoe_lport_create(fcoe);
+	if (!lport) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
+		rc = -ENOMEM;
+		/*
+		 * TODO: This is probably very incorrect.
+		 */
+		goto out;
+	}
+
+	lport->fcport = fc_fcport_add((struct device *)&netdev->dev.parent, &fcoe_fcport_fcn_tmpl);
+	if (!lport->fcport) {
+		printk(KERN_ERR "Failed to add a fcport\n");
+		goto out_free;
+	}
+
+	fc_lport_port_config(lport->fcport);
+
+	lport->fcport->maxframe_size = lport->mfs;
+
+	error = fcoe_if_create(lport, fcoe, &netdev->dev, 0);
+	if (error) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		rc = -EIO;
@@ -2096,6 +2185,24 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	/* Make this the "master" N_Port */
 	fcoe->ctlr.lp = lport;
 
+	/* replace individual set_*() routines below with a
+	 * get_vport_identifiers routine, or don't require ids
+	 * in fcvport_alloc().
+	 */
+	fcoe_get_vport_ids(lport, &ids);
+	lport->fcvport = fc_fcvport_alloc(NULL, &ids, lport->fcvport_f, 0);
+	lport->fcvport->priv_data = lport;
+	fcvport_port_type(lport->fcvport) = FC_PORTTYPE_NPORT;
+
+	if (!lport->fcvport) {
+		/*
+		 * RWL - TODO: remove the fcfabric. I don't think that it will
+		 * come to that though. I think the fabric_add will move instead.
+		 * Let's not worry about it now.
+		 */
+		return rc;
+	}
+
 	/* add to lports list */
 	fcoe_hostlist_add(lport);
 
@@ -2117,6 +2224,7 @@ out_putdev:
 out_nodev:
 	rtnl_unlock();
 	mutex_unlock(&fcoe_config_mutex);
+out:
 	return rc;
 }
 
@@ -2134,19 +2242,21 @@ int fcoe_link_speed_update(struct fc_lport *lport)
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
@@ -2252,7 +2362,8 @@ void fcoe_clean_pending_queue(struct fc_lport *lport)
  */
 int fcoe_reset(struct Scsi_Host *shost)
 {
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_fcp_internal *si = shost_priv(shost);
+	struct fc_lport *lport = si->lport;
 	fc_lport_reset(lport);
 	return 0;
 }
@@ -2501,24 +2612,53 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *lport, u32 did,
  *
  * Returns: 0 for success
  */
-static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
+static int fcoe_vport_create(void *data, struct fc_fcvport *vport, bool disabled)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
-	struct fcoe_port *port = lport_priv(n_port);
-	struct fcoe_interface *fcoe = port->fcoe;
-	struct net_device *netdev = fcoe->netdev;
+	struct fc_lport *lport;
+	struct fcoe_port *port;
+	struct fcoe_interface *fcoe;
+	struct net_device *netdev;
 	struct fc_lport *vn_port;
+	int error = 0;
+
+	lport = (struct fc_lport *)data;
+
+	port = lport_priv(lport);
+	fcoe = port->fcoe;
+	netdev = fcoe->netdev;
+
+	vn_port = fcoe_lport_create(fcoe);
+	if (!vn_port) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
+		return -ENOMEM;
+	}	
 
 	mutex_lock(&fcoe_config_mutex);
-	vn_port = fcoe_if_create(fcoe, &vport->dev, 1);
+	error = fcoe_if_create(vn_port, fcoe, &vport->gendev, 1);
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
+	error = libfc_vport_config(lport, vn_port, vport);
+	if (error)
 		return -EIO;
-	}
+
+	if (IS_ERR(vn_port))
+		return -EIO;
+
+	/*
+	 * TODO: This routine is not currently setting a unique
+	 * name for the vports.
+	 */
+	fcoe_set_symbolic_name(lport);
+
 
 	if (disabled) {
 		fc_vport_set_state(vport, FC_VPORT_DISABLED);
@@ -2527,6 +2667,7 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
 		fc_fabric_login(vn_port);
 		fc_vport_setlink(vn_port);
 	}
+
 	return 0;
 }
 
@@ -2536,10 +2677,9 @@ static int fcoe_vport_create(struct fc_vport *vport, bool disabled)
  *
  * Returns: 0 for success
  */
-static int fcoe_vport_destroy(struct fc_vport *vport)
+static int fcoe_vport_destroy(void *data, struct fc_fcvport *vport)
 {
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
+	struct fc_lport *n_port = data;
 	struct fc_lport *vn_port = vport->dd_data;
 	struct fcoe_port *port = lport_priv(vn_port);
 
@@ -2555,7 +2695,7 @@ static int fcoe_vport_destroy(struct fc_vport *vport)
  * @vport: vport to bring online/offline
  * @disable: should the vport be disabled?
  */
-static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
+static int fcoe_vport_disable(struct fc_fcvport *vport, bool disable)
 {
 	struct fc_lport *lport = vport->dd_data;
 
@@ -2579,20 +2719,20 @@ static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
  * sent to the name server.  There is no response handler, so if it fails
  * for some reason it will not be retried.
  */
-static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
+static void fcoe_set_vport_symbolic_name(struct fc_fcvport *vport)
 {
 	struct fc_lport *lport = vport->dd_data;
 	struct fc_frame *fp;
 	size_t len;
-
-	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
+	
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
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index a554672..2de3887 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -39,6 +39,7 @@
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fcoe.h>
 
+#include <scsi/fc.h>
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
 
@@ -76,8 +77,8 @@ do {							\
 
 #define LIBFCOE_FIP_DBG(fip, fmt, args...)				\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_FIP_LOGGING,			\
-			      printk(KERN_INFO "host%d: fip: " fmt, 	\
-				     (fip)->lp->host->host_no, ##args);)
+			      printk(KERN_INFO "fcport%d: fip: " fmt, 	\
+				     (fip)->lp->fcport->id, ##args);)
 
 /**
  * fcoe_ctlr_mtu_valid() - Check if a FCF's MTU is valid
@@ -229,7 +230,7 @@ static void fcoe_ctlr_solicit(struct fcoe_ctlr *fip, struct fcoe_fcf *fcf)
 
 	sol->desc.wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
 	sol->desc.wwnn.fd_desc.fip_dlen = sizeof(sol->desc.wwnn) / FIP_BPW;
-	put_unaligned_be64(fip->lp->wwnn, &sol->desc.wwnn.fd_wwn);
+	put_unaligned_be64(fcvport_node_name(fip->lp->fcvport), &sol->desc.wwnn.fd_wwn);
 
 	fcoe_size = fcoe_ctlr_fcoe_size(fip);
 	sol->desc.size.fd_desc.fip_dtype = FIP_DT_FCOE_SIZE;
@@ -303,6 +304,7 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 	int link_dropped;
 
 	LIBFCOE_FIP_DBG(fip, "link down.\n");
+
 	spin_lock_bh(&fip->lock);
 	fcoe_ctlr_reset(fip);
 	link_dropped = fip->link;
@@ -310,7 +312,6 @@ int fcoe_ctlr_link_down(struct fcoe_ctlr *fip)
 	fip->last_link = 0;
 	fip->state = FIP_ST_LINK_WAIT;
 	spin_unlock_bh(&fip->lock);
-
 	if (link_dropped)
 		fc_linkdown(fip->lp);
 	return link_dropped;
@@ -370,7 +371,6 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 	kal->fip.fip_flags = htons(FIP_FL_FPMA);
 	if (fip->spma)
 		kal->fip.fip_flags |= htons(FIP_FL_SPMA);
-
 	kal->mac.fd_desc.fip_dtype = FIP_DT_MAC;
 	kal->mac.fd_desc.fip_dlen = sizeof(kal->mac) / FIP_BPW;
 	memcpy(kal->mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
@@ -380,7 +380,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 		vn->fd_desc.fip_dlen = sizeof(*vn) / FIP_BPW;
 		memcpy(vn->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
 		hton24(vn->fd_fc_id, lp->port_id);
-		put_unaligned_be64(lp->wwpn, &vn->fd_wwpn);
+		put_unaligned_be64(fcvport_port_name(lp->fcvport), &vn->fd_wwpn);
 	}
 	skb_put(skb, len);
 	skb->protocol = htons(ETH_P_FIP);
@@ -568,6 +568,7 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  */
 static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 {
+	struct fc_fcp_internal *si = fc_get_scsi_internal(fip->lp);
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
 	unsigned long sel_time = 0;
@@ -581,7 +582,7 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 			fc_lport_get_stats(fip->lp)->MissDiscAdvCount++;
 			printk(KERN_INFO "libfcoe: host%d: Missing Discovery "
 			       "Advertisement for fab %llx count %lld\n",
-			       fip->lp->host->host_no, fcf->fabric_name,
+			       si->host->host_no, fcf->fabric_name,
 			       fc_lport_get_stats(fip->lp)->MissDiscAdvCount);
 		}
 		if (time_after(jiffies, fcf->time + fcf->fka_period * 3 +
@@ -773,6 +774,8 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		memcpy(fcf->fcf_mac, new.fcf_mac, ETH_ALEN);
 	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
+
+
 	fcf->time = jiffies;
 	if (!found) {
 		LIBFCOE_FIP_DBG(fip, "New FCF for fab %llx map %x val %d\n",
@@ -806,6 +809,19 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		    time_before(fip->sel_time, fip->timer.expires))
 			mod_timer(&fip->timer, fip->sel_time);
 	}
+
+	if (!found) {
+		spin_unlock_bh(&fip->lock);
+		/* RWL */
+		fip->lp->fcfport = fc_fcfport_add(fip->lp->fcport, fcf->switch_name);
+		if (!fip->lp->fcfport) {
+			fc_fcport_del(fip->lp->fcport);
+			goto out;
+		}
+
+		return;
+	}
+
 out:
 	spin_unlock_bh(&fip->lock);
 }
@@ -979,7 +995,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 				return;
 			if (compare_ether_addr(vp->fd_mac,
 					       fip->get_src_addr(lport)) == 0 &&
-			    get_unaligned_be64(&vp->fd_wwpn) == lport->wwpn &&
+			    get_unaligned_be64(&vp->fd_wwpn) == fcvport_port_name(lport->fcvport) &&
 			    ntoh24(vp->fd_fc_id) == lport->port_id)
 				desc_mask &= ~BIT(FIP_DT_VN_ID);
 			break;
@@ -1159,18 +1175,18 @@ static void fcoe_ctlr_timeout(unsigned long arg)
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
 			schedule_work(&fip->link_work);
 		}
@@ -1236,7 +1252,6 @@ static void fcoe_ctlr_link_work(struct work_struct *work)
 			fc_linkdown(fip->lp);
 	} else if (reset && link)
 		fc_lport_reset(fip->lp);
-
 	if (fip->send_ctlr_ka) {
 		fip->send_ctlr_ka = 0;
 		fcoe_ctlr_send_keep_alive(fip, NULL, 0, fip->ctl_src_addr);
@@ -1395,8 +1410,6 @@ int fcoe_libfc_config(struct fc_lport *lport,
 {
 	/* Set the function pointers set by the LLDD */
 	memcpy(&lport->tt, tt, sizeof(*tt));
-	if (fc_fcp_init(lport))
-		return -ENOMEM;
 	fc_exch_init(lport);
 	fc_elsct_init(lport);
 	fc_lport_init(lport);
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index dd703fd..dd0344d 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -387,6 +387,7 @@ err:
 static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 {
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	struct fc_gpn_ft_resp *np;
 	char *bp;
 	size_t plen;
@@ -396,6 +397,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	struct fc_rport_priv *rdata;
 
 	lport = disc->lport;
+	si = fc_get_scsi_internal(lport);
 	disc->seq_count++;
 
 	/*
@@ -440,7 +442,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		ids.port_name = ntohll(np->fp_wwpn);
 
 		if (ids.port_id != lport->port_id &&
-		    ids.port_name != lport->wwpn) {
+		    ids.port_name != fcvport_port_name(lport->fcvport)) {
 			rdata = lport->tt.rport_create(lport, ids.port_id);
 			if (rdata) {
 				rdata->ids.port_name = ids.port_name;
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 425f4dd..3cffbb3 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1922,11 +1922,13 @@ err:
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
index d2da31e..2f89dde 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -66,26 +66,6 @@ struct kmem_cache *scsi_pkt_cachep;
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
@@ -351,13 +331,13 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
 
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
 
@@ -385,12 +365,12 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 
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
 
@@ -405,6 +385,7 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 						  size_t len)
 {
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	struct fc_frame *fp;
 	unsigned long flags;
 
@@ -413,9 +394,10 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
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
 
@@ -484,6 +466,7 @@ crc_err:
 				printk(KERN_WARNING "libfc: CRC error on data "
 				       "frame for port (%6x)\n",
 				       lport->port_id);
+
 			/*
 			 * Assume the frame is total garbage.
 			 * We may have copied it over the good part
@@ -991,7 +974,7 @@ static void fc_fcp_cleanup_each_cmd(struct fc_lport *lport, unsigned int id,
 	struct scsi_cmnd *sc_cmd;
 	unsigned long flags;
 
-	spin_lock_irqsave(&si->scsi_queue_lock, flags);
+	spin_lock_irqsave(si->host->host_lock, flags);
 restart:
 	list_for_each_entry(fsp, &si->scsi_pkt_queue, list) {
 		sc_cmd = fsp->cmd;
@@ -1002,7 +985,7 @@ restart:
 			continue;
 
 		fc_fcp_pkt_hold(fsp);
-		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
+		spin_unlock_irqrestore(si->host->host_lock, flags);
 
 		if (!fc_fcp_lock_pkt(fsp)) {
 			fc_fcp_cleanup_cmd(fsp, error);
@@ -1011,14 +994,14 @@ restart:
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
@@ -1356,8 +1339,10 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	struct fc_frame *fp;
 	struct fc_rport *rport;
 	struct fc_rport_libfc_priv *rpriv;
+	struct fc_fcp_internal *si;
 
 	lport = fsp->lp;
+	si = fc_get_scsi_internal(lport);
 	rport = fsp->rport;
 	rpriv = rport->dd_data;
 	if (!fsp->seq_ptr || rpriv->rp_state != RPORT_ST_READY) {
@@ -1735,7 +1720,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
 {
 	/* lock ? */
 	return (lport->state == LPORT_ST_READY) &&
-		lport->link_up && !lport->qfull;
+		lport->link_up && !fc_get_scsi_internal(lport)->qfull;
 }
 
 /**
@@ -1749,6 +1734,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
 int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 {
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport_libfc_priv *rpriv;
@@ -1756,9 +1742,9 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
 
-	lport = shost_priv(sc_cmd->device->host);
-	spin_unlock_irq(lport->host->host_lock);
-
+	si = shost_priv(sc_cmd->device->host);
+	lport = si->lport;
+	spin_unlock_irq(si->host->host_lock);
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
@@ -1779,7 +1765,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	rpriv = rport->dd_data;
 
 	if (!fc_fcp_lport_queue_ready(lport)) {
-		if (lport->qfull)
+		if (si->qfull)
 			fc_fcp_can_queue_ramp_down(lport);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
@@ -1840,7 +1826,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 out:
-	spin_lock_irq(lport->host->host_lock);
+	spin_lock_irq(si->host->host_lock);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
@@ -1968,25 +1954,27 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 {
 	struct fc_fcp_pkt *fsp;
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	int rc = FAILED;
 	unsigned long flags;
 
-	lport = shost_priv(sc_cmd->device->host);
+	si = shost_priv(sc_cmd->device->host);
+	lport = si->lport;
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
@@ -2013,6 +2001,7 @@ EXPORT_SYMBOL(fc_eh_abort);
 int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 {
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	int rc = FAILED;
@@ -2022,7 +2011,8 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (rval)
 		goto out;
 
-	lport = shost_priv(sc_cmd->device->host);
+	si = shost_priv(sc_cmd->device->host); 
+	lport = si->lport;
 
 	if (lport->state != LPORT_ST_READY)
 		return rc;
@@ -2062,7 +2052,8 @@ EXPORT_SYMBOL(fc_eh_device_reset);
 int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 {
 	struct Scsi_Host *shost = sc_cmd->device->host;
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_fcp_internal *si = shost_priv(shost);
+	struct fc_lport *lport = si->lport;
 	unsigned long wait_tmo;
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
@@ -2167,7 +2158,12 @@ void fc_fcp_destroy(struct fc_lport *lport)
 		       "port (%6x)\n", lport->port_id);
 
 	mempool_destroy(si->scsi_pkt_pool);
-	kfree(si);
+
+	/* Detach from the scsi-ml */
+	fc_remove_host(si->host);
+	scsi_remove_host(si->host);
+	scsi_host_put(si->host);	
+
 	lport->scsi_priv = NULL;
 }
 EXPORT_SYMBOL(fc_fcp_destroy);
@@ -2200,8 +2196,9 @@ void fc_destroy_fcp()
  */
 int fc_fcp_init(struct fc_lport *lport)
 {
-	int rc;
+	struct Scsi_Host *shost;
 	struct fc_fcp_internal *si;
+	int rc = 0;
 
 	if (!lport->tt.fcp_cmd_send)
 		lport->tt.fcp_cmd_send = fc_fcp_cmd_send;
@@ -2212,23 +2209,48 @@ int fc_fcp_init(struct fc_lport *lport)
 	if (!lport->tt.fcp_abort_io)
 		lport->tt.fcp_abort_io = fc_fcp_abort_io;
 
-	si = kzalloc(sizeof(struct fc_fcp_internal), GFP_KERNEL);
-	if (!si)
-		return -ENOMEM;
-	lport->scsi_priv = si;
-	si->max_can_queue = lport->host->can_queue;
+	shost = scsi_host_alloc(lport->tt.shost_template,
+				sizeof(struct fc_fcp_internal));
+	if (!shost) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	si = shost_priv(shost);
+	si->host = shost;
+	lport->scsi_priv = si;	
+	si->lport = lport;
+
+	lport->fcpinit = shost_to_fcpinit(shost);
+	lport->fcfabric->shost = shost;
+
+	lport->tt.shost_config(lport, si);
+
+	/* add the new host to the SCSI-ml */
+	/*
+	 * TODO: I don't think this is right and I'm not sure how to get the
+	 * order right at this time. It should be vport/fcpinit/host.
+	 */
+	rc = scsi_add_host(si->host, &lport->fcvport->gendev);
+	if (rc)
+		goto out_free_host;
+
+	si->max_can_queue = si->host->can_queue;
+
 	INIT_LIST_HEAD(&si->scsi_pkt_queue);
 	spin_lock_init(&si->scsi_queue_lock);
 
 	si->scsi_pkt_pool = mempool_create_slab_pool(2, scsi_pkt_cachep);
 	if (!si->scsi_pkt_pool) {
 		rc = -ENOMEM;
-		goto free_internal;
+		goto out_free_host;
 	}
+
 	return 0;
 
-free_internal:
-	kfree(si);
+out_free_host:
+	scsi_host_put(shost);
+out:
 	return rc;
 }
 EXPORT_SYMBOL(fc_fcp_init);
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index a79c42d..e5ec03e 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -45,20 +45,20 @@ extern unsigned int fc_debug_logging;
 
 #define FC_LPORT_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: lport %6x: " fmt,	\
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
-			 printk(KERN_INFO "host%u: rport %6x: " fmt,	\
-				(lport)->host->host_no,			\
+			 printk(KERN_INFO "fcport%u: rport %6x: " fmt,	\
+				(lport)->fcport->id,			\
 				(port_id), ##args))
 
 #define FC_RPORT_DBG(rdata, fmt, args...)				\
@@ -66,20 +66,20 @@ extern unsigned int fc_debug_logging;
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
-			 printk(KERN_INFO "host%u: fcp: %6x: " fmt,	\
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
index 9da4c15..0466553 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -245,48 +245,38 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
  */
 void fc_get_host_port_state(struct Scsi_Host *shost)
 {
-	struct fc_lport *lport = shost_priv(shost);
+	struct fc_fcp_internal *si = shost_priv(shost);
+	struct fc_lport *lport = si->lport;
 
 	mutex_lock(&lport->lp_mutex);
 	if (!lport->link_up)
-		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+		fcpinit_port_state(shost) = FC_PORTSTATE_LINKDOWN;
 	else
 		switch (lport->state) {
 		case LPORT_ST_READY:
-			fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+			fcpinit_port_state(shost) = FC_PORTSTATE_ONLINE;
 			break;
 		default:
-			fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+			fcpinit_port_state(shost) = FC_PORTSTATE_OFFLINE;
 		}
 	mutex_unlock(&lport->lp_mutex);
 }
 EXPORT_SYMBOL(fc_get_host_port_state);
 
 /**
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
-
-/**
  * fc_get_host_stats() - Return the Scsi_Host's statistics
  * @shost: The SCSI host whose statistics are to be returned
  */
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
+struct fcpinit_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 {
-	struct fc_host_statistics *fcoe_stats;
-	struct fc_lport *lport = shost_priv(shost);
+	struct fcpinit_statistics *fcoe_stats;
+	struct fc_fcp_internal *si = shost_priv(shost);
+	struct fc_lport *lport = si->lport;
 	struct timespec v0, v1;
 	unsigned int cpu;
 
-	fcoe_stats = &lport->host_stats;
-	memset(fcoe_stats, 0, sizeof(struct fc_host_statistics));
+	fcoe_stats = &si->host_stats;
+	memset(fcoe_stats, 0, sizeof(struct fcpinit_statistics));
 
 	jiffies_to_timespec(jiffies, &v0);
 	jiffies_to_timespec(lport->boot_time, &v1);
@@ -335,8 +325,8 @@ static void fc_lport_flogi_fill(struct fc_lport *lport,
 
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) op;
-	put_unaligned_be64(lport->wwpn, &flogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &flogi->fl_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &flogi->fl_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &flogi->fl_wwnn);
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -479,8 +469,8 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
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
@@ -548,7 +538,6 @@ void __fc_linkup(struct fc_lport *lport)
 {
 	if (!lport->link_up) {
 		lport->link_up = 1;
-
 		if (lport->state == LPORT_ST_RESET)
 			fc_lport_enter_flogi(lport);
 	}
@@ -560,8 +549,8 @@ void __fc_linkup(struct fc_lport *lport)
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link up on port (%6x)\n",
-	       lport->host->host_no, lport->port_id);
+	printk(KERN_INFO "fcport%d: libfc: Link up on port (%6x)\n",
+	       lport->fcport->id, lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkup(lport);
@@ -580,7 +569,8 @@ void __fc_linkdown(struct fc_lport *lport)
 	if (lport->link_up) {
 		lport->link_up = 0;
 		fc_lport_enter_reset(lport);
-		lport->tt.fcp_cleanup(lport);
+		if (lport->tt.fcp_cleanup)
+			lport->tt.fcp_cleanup(lport);
 	}
 }
 
@@ -590,8 +580,8 @@ void __fc_linkdown(struct fc_lport *lport)
  */
 void fc_linkdown(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link down on port (%6x)\n",
-	       lport->host->host_no, lport->port_id);
+	printk(KERN_INFO "fcport%d: libfc: Link down on port (%6x)\n",
+	       lport->fcport->id, lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkdown(lport);
@@ -640,7 +630,13 @@ int fc_lport_destroy(struct fc_lport *lport)
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
@@ -691,9 +687,9 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 		FC_LPORT_DBG(lport, "Discovery succeeded\n");
 		break;
 	case DISC_EV_FAILED:
-		printk(KERN_ERR "host%d: libfc: "
+		printk(KERN_ERR "fcport%d: libfc: "
 		       "Discovery failed for port (%6x)\n",
-		       lport->host->host_no, lport->port_id);
+		       lport->fcport->id, lport->port_id);
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -717,8 +713,8 @@ static void fc_lport_enter_ready(struct fc_lport *lport)
 		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
-	if (lport->vport)
-		fc_vport_set_state(lport->vport, FC_VPORT_ACTIVE);
+	if (!fc_fcvport_is_nport(&lport->fcvport->gendev, NULL))
+		fc_vport_set_state(lport->fcvport, FC_VPORT_ACTIVE);
 	fc_vports_linkchange(lport);
 
 	if (!lport->ptp_rdata)
@@ -738,10 +734,11 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 				 struct fc_frame *fp)
 {
 	if (port_id)
-		printk(KERN_INFO "host%d: Assigned Port ID %6x\n",
-		       lport->host->host_no, port_id);
+		printk(KERN_INFO "fcport%d: Assigned Port ID %6x\n",
+		       lport->fcport->id, port_id);
 
 	lport->port_id = port_id;
+
 	if (lport->tt.lport_set_port_id)
 		lport->tt.lport_set_port_id(lport, port_id, fp);
 }
@@ -783,10 +780,10 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	if (!flp)
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
-	if (remote_wwpn == lport->wwpn) {
-		printk(KERN_WARNING "host%d: libfc: Received FLOGI from port "
+	if (remote_wwpn == fcvport_port_name(lport->fcvport)) {
+		printk(KERN_WARNING "fcport%d: libfc: Received FLOGI from port "
 		       "with same WWPN %llx\n",
-		       lport->host->host_no, remote_wwpn);
+		       lport->fcport->id, remote_wwpn);
 		goto out;
 	}
 	FC_LPORT_DBG(lport, "FLOGI from port WWPN %llx\n", remote_wwpn);
@@ -797,7 +794,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	 * But if so, both of us could end up with the same FID.
 	 */
 	local_fid = FC_LOCAL_PTP_FID_LO;
-	if (remote_wwpn < lport->wwpn) {
+	if (remote_wwpn < fcvport_port_name(lport->fcvport)) {
 		local_fid = FC_LOCAL_PTP_FID_HI;
 		if (!remote_fid || remote_fid == local_fid)
 			remote_fid = FC_LOCAL_PTP_FID_LO;
@@ -940,7 +937,9 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	lport->tt.disc_stop(lport);
 
 	lport->tt.exch_mgr_reset(lport, 0, 0);
-	fc_host_fabric_name(lport->host) = 0;
+
+	if (lport->fcfabric)
+		fcfabric_fabric_name(lport->fcfabric) = 0;
 
 	if (lport->port_id)
 		fc_lport_set_port_id(lport, 0, NULL);
@@ -961,15 +960,16 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 	if (lport->state == LPORT_ST_DISABLED || lport->state == LPORT_ST_LOGO)
 		return;
 
-	if (lport->vport) {
+	if (!fc_fcvport_is_nport(&lport->fcvport->gendev, NULL)) {
 		if (lport->link_up)
-			fc_vport_set_state(lport->vport, FC_VPORT_INITIALIZING);
+			fc_vport_set_state(lport->fcvport, FC_VPORT_INITIALIZING);
 		else
-			fc_vport_set_state(lport->vport, FC_VPORT_LINKDOWN);
+			fc_vport_set_state(lport->fcvport, FC_VPORT_LINKDOWN);
 	}
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
 	fc_vports_linkchange(lport);
 	fc_lport_reset_locked(lport);
+
 	if (lport->link_up)
 		fc_lport_enter_flogi(lport);
 }
@@ -1216,7 +1216,7 @@ static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 		size += sizeof(struct fc_ns_rn_id);
 		break;
 	case LPORT_ST_RSNN_NN:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 		/* if there is no symbolic name, skip to RFT_ID */
 		if (!len)
 			return fc_lport_enter_ns(lport, LPORT_ST_RFT_ID);
@@ -1224,7 +1224,7 @@ static void fc_lport_enter_ns(struct fc_lport *lport, enum fc_lport_state state)
 		size += sizeof(struct fc_ns_rsnn) + len;
 		break;
 	case LPORT_ST_RSPN_ID:
-		len = strnlen(fc_host_symbolic_name(lport->host), 255);
+		len = strnlen(fcvport_symbolic_name(lport->fcvport), 255);
 		/* if there is no symbolic name, skip to RFT_ID */
 		if (!len)
 			return fc_lport_enter_ns(lport, LPORT_ST_RFT_ID);
@@ -1436,8 +1436,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int e_d_tov;
 	u16 mfs;
 
-	FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc_els_resp_type(fp));
-
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
@@ -1479,10 +1477,6 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
 				fc_lport_set_port_id(lport, did, fp);
-				printk(KERN_INFO "host%d: libfc: "
-				       "Port (%6x) entered "
-				       "point-to-point mode\n",
-				       lport->host->host_no, did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
@@ -1491,15 +1485,40 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			} else {
 				lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = r_a_tov;
-				fc_host_fabric_name(lport->host) =
-					get_unaligned_be64(&flp->fl_wwnn);
+
+				/*
+				 * TODO: There needs to be a lot more error handling here.
+				 */
+				if (!lport->fcfabric) {
+					lport->fcfabric = fc_fcfabric_add(lport->fcfport,
+									  lport->fcfabric_f);
+					if (!lport->fcfabric)
+						goto out;
+
+					lport->fcfabric->fcvport_f = lport->fcvport_f;
+					lport->tt.set_fcfabric_max_npiv_vports(lport);
+					fcfabric_fabric_name(lport->fcfabric) = get_unaligned_be64(&flp->fl_wwnn);
+				}
+
+				fc_fcvport_add(lport->fcvport, lport->fcfabric);
+
+				/* RWL - this seems redundant, doesn't it? */
 				fc_lport_set_port_id(lport, did, fp);
+				fcvport_port_id(lport->fcvport) = lport->port_id;
+
+/* TODO: How do I link the fcpinit to the fcvport?
+				lport->fcpinit = fc_fcpinit_add(lport->fcvport, 0);
+				if (!lport->fcpinit)
+					goto out;
+*/
+				if (fc_fcp_init(lport))
+					goto out;
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
@@ -1529,10 +1548,10 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 		return fc_lport_error(lport, fp);
 
 	if (!lport->tt.elsct_send(lport, FC_FID_FLOGI, fp,
-				  lport->vport ? ELS_FDISC : ELS_FLOGI,
+				  fc_fcvport_is_nport(&lport->fcvport->gendev, NULL) ? ELS_FLOGI : ELS_FDISC,
 				  fc_lport_flogi_resp, lport,
-				  lport->vport ? 2 * lport->r_a_tov :
-				  lport->e_d_tov))
+				  fc_fcvport_is_nport(&lport->fcvport->gendev, NULL) ? lport->e_d_tov :
+				  2 * lport->r_a_tov))
 		fc_lport_error(lport, NULL);
 }
 
@@ -1547,6 +1566,12 @@ int fc_lport_config(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_DISABLED);
 
+	/*
+	 * TODO: This is a bit goofy. We either need to
+	 * use the fcport speeds and not have a lport copy
+	 * or have a lport copy and have a get_fcport_*speed*()
+	 * routine.
+	 */
 	fc_lport_add_fc4_type(lport, FC_TYPE_FCP);
 	fc_lport_add_fc4_type(lport, FC_TYPE_CT);
 
@@ -1554,6 +1579,27 @@ int fc_lport_config(struct fc_lport *lport)
 }
 EXPORT_SYMBOL(fc_lport_config);
 
+void fc_lport_port_config(struct fc_fcport *fcport)
+{
+
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
@@ -1566,27 +1612,6 @@ int fc_lport_init(struct fc_lport *lport)
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
index 0e90f00..608f9eb 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -24,38 +24,38 @@
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
+//	vn_port->vport = vport;
 	vport->dd_data = vn_port;
 
+	/*
+	 * TODO: This is done a bit blindly, are there considerations
+	 * befre making these associations?
+	 */
+	vn_port->fcvport = vport;
+	vn_port->fcfabric = n_port->fcfabric;
+	vn_port->fcfport = n_port->fcfport;
+	vn_port->fcport = n_port->fcport;
+
+//	FCOE_NETDEV_DBG(netdev, "Setting vport names, 0x%llX 0x%llX\n",
+//			vport->node_name, vport->port_name);
+
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
@@ -105,7 +105,7 @@ enum libfc_lport_mutex_class {
 static void __fc_vport_setlink(struct fc_lport *n_port,
 			       struct fc_lport *vn_port)
 {
-	struct fc_vport *vport = vn_port->vport;
+	struct fc_fcvport *vport = vn_port->fcvport;
 
 	if (vn_port->state == LPORT_ST_DISABLED)
 		return;
@@ -130,9 +130,15 @@ static void __fc_vport_setlink(struct fc_lport *n_port,
  */
 void fc_vport_setlink(struct fc_lport *vn_port)
 {
-	struct fc_vport *vport = vn_port->vport;
-	struct Scsi_Host *shost = vport_to_shost(vport);
-	struct fc_lport *n_port = shost_priv(shost);
+	struct fc_fcvport *vport = fc_fcfabric_find_nport(vn_port->fcfabric);
+	struct fc_lport *n_port = vport->priv_data;
+
+	/*
+	 * TODO: This is terrible. There needs to be a return code that is
+	 * checked by the caller.
+	 */
+	if (!n_port)
+		return;
 
 	mutex_lock(&n_port->lp_mutex);
 	mutex_lock_nested(&vn_port->lp_mutex, LPORT_MUTEX_VN_PORT);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 97923bb..29b9683 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -246,6 +246,7 @@ static void fc_rport_work(struct work_struct *work)
 	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
 	int restart = 0;
+	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 
 	mutex_lock(&rdata->rp_mutex);
 	event = rdata->event;
@@ -262,7 +263,7 @@ static void fc_rport_work(struct work_struct *work)
 		mutex_unlock(&rdata->rp_mutex);
 
 		if (!rport)
-			rport = fc_remote_port_add(lport->host, 0, &ids);
+			rport = fc_remote_port_add(si->host, 0, &ids);
 		if (!rport) {
 			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
 			lport->tt.rport_logoff(rdata);
@@ -1112,13 +1113,14 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 
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
@@ -1146,8 +1148,8 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 		/* get LESB from LLD if it supports it */
 		lport->tt.get_lesb(lport, lesb);
 	} else {
-		fc_get_host_stats(lport->host);
-		hst = &lport->host_stats;
+		fc_get_host_stats(si->host);
+		hst = &si->host_stats;
 		lesb->lesb_link_fail = htonl(hst->link_failure_count);
 		lesb->lesb_sync_loss = htonl(hst->loss_of_sync_count);
 		lesb->lesb_sig_loss = htonl(hst->loss_of_signal_count);
@@ -1359,7 +1361,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		break;
 	case RPORT_ST_PLOGI:
 		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state\n");
-		if (rdata->ids.port_name < lport->wwpn) {
+		if (rdata->ids.port_name < fcvport_port_name(lport->fcvport)) {
 			mutex_unlock(&rdata->rp_mutex);
 			rjt_data.reason = ELS_RJT_INPROG;
 			rjt_data.explan = ELS_EXPL_NONE;
diff --git a/include/scsi/fc.h b/include/scsi/fc.h
index 7ca20fb..27e7f03 100644
--- a/include/scsi/fc.h
+++ b/include/scsi/fc.h
@@ -381,8 +381,7 @@ struct fc_fcfport *fc_fcfport_lookup(struct fc_fcport *fcport, const u64 name);
 struct fc_fcvport *fc_fcvport_lookup(struct fc_fcfabric *fcfabric, const u32 id);
 
 struct fc_fcport *fc_fcport_add(struct device *pdev, 
-				struct fcport_function_template *,
-				int priv_size);
+				struct fcport_function_template *);
 struct fc_fcfport *fc_fcfport_add(struct fc_fcport *fcport, const u64 name);
 struct fc_fcfabric *fc_fcfabric_add(struct fc_fcfport *fcfport,
 				    struct fcfabric_function_template *);
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 9b4867c..d8e8904 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -72,8 +72,8 @@ static inline void fc_adisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
 	memset(adisc, 0, sizeof(*adisc));
 	adisc->adisc_cmd = ELS_ADISC;
-	put_unaligned_be64(lport->wwpn, &adisc->adisc_wwpn);
-	put_unaligned_be64(lport->wwnn, &adisc->adisc_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &adisc->adisc_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &adisc->adisc_wwnn);
 	hton24(adisc->adisc_port_id, lport->port_id);
 }
 
@@ -144,24 +144,24 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 	case FC_NS_RNN_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rn_id));
 		hton24(ct->payload.rn.fr_fid.fp_fid, lport->port_id);
-		put_unaligned_be64(lport->wwnn, &ct->payload.rn.fr_wwn);
+		put_unaligned_be64(fcvport_node_name(lport->fcvport), &ct->payload.rn.fr_wwn);
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
+		put_unaligned_be64(fcvport_node_name(lport->fcvport), &ct->payload.snn.fr_wwn);
 		strncpy(ct->payload.snn.fr_name,
-			fc_host_symbolic_name(lport->host), len);
+			fcvport_symbolic_name(lport->fcvport), len);
 		ct->payload.snn.fr_name_len = len;
 		break;
 
@@ -186,8 +186,8 @@ static inline void fc_plogi_fill(struct fc_lport *lport, struct fc_frame *fp,
 	plogi = fc_frame_payload_get(fp, sizeof(*plogi));
 	memset(plogi, 0, sizeof(*plogi));
 	plogi->fl_cmd = (u8) op;
-	put_unaligned_be64(lport->wwpn, &plogi->fl_wwpn);
-	put_unaligned_be64(lport->wwnn, &plogi->fl_wwnn);
+	put_unaligned_be64(fcvport_port_name(lport->fcvport), &plogi->fl_wwpn);
+	put_unaligned_be64(fcvport_node_name(lport->fcvport), &plogi->fl_wwnn);
 
 	csp = &plogi->fl_csp;
 	csp->sp_hi_ver = 0x20;
@@ -218,8 +218,8 @@ static inline void fc_flogi_fill(struct fc_lport *lport, struct fc_frame *fp)
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
@@ -243,8 +243,8 @@ static inline void fc_fdisc_fill(struct fc_lport *lport, struct fc_frame *fp)
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
@@ -265,7 +265,7 @@ static inline void fc_logo_fill(struct fc_lport *lport, struct fc_frame *fp)
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
 	hton24(logo->fl_n_port_id, lport->port_id);
-	logo->fl_n_port_wwn = htonll(lport->wwpn);
+	logo->fl_n_port_wwn = htonll(fcvport_port_name(lport->fcvport));
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 0919409..8cd0c63 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -24,6 +24,7 @@
 #include <linux/if.h>
 #include <linux/percpu.h>
 
+#include <scsi/fc.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
@@ -144,6 +145,7 @@ enum fc_rport_event {
 };
 
 struct fc_rport_priv;
+struct fc_fcp_internal;
 
 /**
  * struct fc_rport_operations - Operations for a remote port
@@ -688,6 +690,19 @@ struct libfc_function_template {
 	void (*fcp_abort_io)(struct fc_lport *);
 
 	/*
+	 * Scsi_Host tempate if this initiator is for SCSI-FCP
+	 *
+	 * STATUS: REQUIRED (if doing SCSI-FCP)
+	 */
+	struct scsi_host_template *shost_template;
+
+	/*
+	 * Let the LLD configure the Scsi_Host if it
+	 * wants to.
+	 */
+	void (*shost_config)(struct fc_lport *, struct fc_fcp_internal *);
+
+	/*
 	 * Receive a request for the discovery layer.
 	 *
 	 * STATUS: OPTIONAL
@@ -720,6 +735,14 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	void (*disc_stop_final) (struct fc_lport *);
+
+	void (*set_fcvport_symbolic_name)(struct fc_lport *);
+	void (*set_fcvport_node_name)(struct fc_lport *);
+	void (*set_fcvport_port_name)(struct fc_lport *);
+	void (*set_fcfabric_max_npiv_vports)(struct fc_lport *);
+
+	void (*get_vport_ids)(struct fc_lport *,
+			      struct fc_vport_identifiers *);
 };
 
 /**
@@ -799,30 +822,23 @@ struct fc_disc {
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
 
 	/* Fabric information */
-	u64			       wwpn;
-	u64			       wwnn;
 	unsigned int		       service_params;
 	unsigned int		       e_d_tov;
 	unsigned int		       r_a_tov;
@@ -844,14 +860,54 @@ struct fc_lport {
 	unsigned int		       lso_max;
 	struct fc_ns_fts	       fcts;
 
+	/* sysfs representation */
+	struct fc_fcport               *fcport;
+	struct fc_fcfport              *fcfport;
+	struct fc_fcfabric             *fcfabric;
+	struct fc_fcvport              *fcvport;
+	struct fc_fcpinit              *fcpinit;
+
 	/* Miscellaneous */
 	struct mutex                   lp_mutex;
 	struct list_head               list;
 	struct delayed_work	       retry_work;
 
+	struct fcfabric_function_template *fcfabric_f;
+	struct fcvport_function_template *fcvport_f;
+
 	u32                            port_id;
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
+	struct fcpinit_statistics      host_stats;
 };
 
+#define fc_get_scsi_internal(x)	((struct fc_fcp_internal *)(x)->scsi_priv)
+
+
 /*
  * FC_LPORT HELPER FUNCTIONS
  *****************************/
@@ -866,26 +922,6 @@ static inline int fc_lport_test_ready(struct fc_lport *lport)
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
@@ -938,26 +974,30 @@ static inline void *lport_priv(const struct fc_lport *lport)
 }
 
 /**
- * libfc_host_alloc() - Allocate a Scsi_Host with room for a local port and
- *                      LLD private data
- * @sht:       The SCSI host template
- * @priv_size: Size of private data
- *
- * Returns: libfc lport
+ * fc_lport_free() - Free a local port
+ * @lport: The local port to be free'd
  */
-static inline struct fc_lport *
-libfc_host_alloc(struct scsi_host_template *sht, int priv_size)
+static inline void fc_lport_free(struct fc_lport *lport)
+{
+	printk(KERN_ERR "RWL: fc_lport_free: kfree(lport)\n");
+	kfree(lport);
+}
+
+static inline struct fc_lport *fc_lport_alloc(int priv_size)
 {
 	struct fc_lport *lport;
-	struct Scsi_Host *shost;
 
-	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
-	if (!shost)
+	printk(KERN_ERR "RWL: libfc_lport_alloc: kzalloc(lport)\n");
+	lport = kzalloc(sizeof(struct fc_lport) + priv_size, GFP_KERNEL);
+	if (!lport)
 		return NULL;
-	lport = shost_priv(shost);
-	lport->host = shost;
+
+	printk(KERN_ERR "RWL: libfc_lport_alloc - allocated lport = %p\n",
+	       lport);
+
 	INIT_LIST_HEAD(&lport->ema_list);
 	INIT_LIST_HEAD(&lport->vports);
+
 	return lport;
 }
 
@@ -987,7 +1027,7 @@ void fc_vports_linkchange(struct fc_lport *);
 int fc_lport_config(struct fc_lport *);
 int fc_lport_reset(struct fc_lport *);
 int fc_set_mfs(struct fc_lport *, u32 mfs);
-struct fc_lport *libfc_vport_create(struct fc_vport *, int privsize);
+int libfc_vport_config(struct fc_lport *n_port, struct fc_lport *vn_port, struct fc_fcvport *);
 struct fc_lport *fc_vport_id_lookup(struct fc_lport *, u32 port_id);
 int fc_lport_bsg_request(struct fc_bsg_job *);
 
@@ -1054,9 +1094,10 @@ void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 /*
  * Functions for fc_functions_template
  */
-void fc_get_host_speed(struct Scsi_Host *);
 void fc_get_host_port_state(struct Scsi_Host *);
 void fc_set_rport_loss_tmo(struct fc_rport *, u32 timeout);
-struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *);
+struct fcpinit_statistics *fc_get_host_stats(struct Scsi_Host *);
+
 
+void fc_lport_port_config(struct fc_fcport *fcport);
 #endif /* _LIBFC_H_ */

