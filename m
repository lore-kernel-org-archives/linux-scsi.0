From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 10/10] libfcoe, fcoe: Use FC Port Attributes
Date: Mon, 22 Aug 2011 15:49:14 -0700
Message-ID: <20110822224914.1854.77120.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab1HVWtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:49:14 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch allows the SW FCoE kernel module to expose
FCoE properties through the fc_port's sysfs attributes.

Helper routines were added to libfcoe to update the
'struct fc_port' fields with their 'struct fcoe_ctlr'
conterparts. Other drivers that use libfcoe for FIP
management can make use of these routines when they
support the new sysfs extensions.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |   60 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_ctlr.c |   57 +++++++++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h        |   10 +++++++
 3 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4825c0a..b336487 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -160,6 +160,21 @@ static int fcoe_fabric_destroy(struct fc_port *port,
 	return fcoe_ctlr_fabric_destroy(fip, fcf);
 }
 
+#define fcoe_get_port_attr_from_ctlr(field)			\
+static void fcoe_get_##field(struct fc_port *port)	\
+{							\
+	struct fcoe_interface *fcoe = fc_port_priv(port);	\
+	return fcoe_get_port_##field(port, &fcoe->ctlr);	\
+}
+
+fcoe_get_port_attr_from_ctlr(sol_time)
+fcoe_get_port_attr_from_ctlr(sel_time)
+fcoe_get_port_attr_from_ctlr(port_ka_time)
+fcoe_get_port_attr_from_ctlr(ctlr_ka_time)
+fcoe_get_port_attr_from_ctlr(probe_tries)
+fcoe_get_port_attr_from_ctlr(port_dest_addr)
+fcoe_get_port_attr_from_ctlr(ctlr_src_addr)
+
 static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.frame_send = fcoe_xmit,
 	.ddp_setup = fcoe_ddp_setup,
@@ -173,6 +188,23 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 struct fc_function_template fcoe_nport_fc_functions = {
 	.dd_fcport_size = sizeof(struct fcoe_interface),
 	.show_port_maxframe_size = 1,
+	.show_port_supported_classes = 1,
+	.show_port_supported_fc4s = 1,
+	.show_port_supported_speeds = 1,
+	.show_port_sol_time = 1,
+	.show_port_sel_time = 1,
+	.show_port_port_ka_time = 1,
+	.show_port_ctlr_ka_time = 1,
+	.show_port_port_dest_addr = 1,
+	.show_port_ctlr_src_addr = 1,
+
+	.get_port_sol_time = fcoe_get_sol_time,
+	.get_port_sel_time = fcoe_get_sel_time,
+	.get_port_port_ka_time = fcoe_get_port_ka_time,
+	.get_port_ctlr_ka_time = fcoe_get_ctlr_ka_time,
+	.get_port_probe_tries = fcoe_get_probe_tries,
+	.get_port_port_dest_addr = fcoe_get_port_dest_addr,
+	.get_port_ctlr_src_addr = fcoe_get_ctlr_src_addr,
 
 	.dd_fcfabric_size = sizeof(struct fcoe_fcf),
 	.fabric_match = fcoe_fabric_match,
@@ -180,6 +212,7 @@ struct fc_function_template fcoe_nport_fc_functions = {
 	.get_fabric_r_a_tov = fcoe_get_fabric_ra_tov,
 	.get_fabric_e_d_tov = fcoe_get_fabric_ed_tov,
 	.get_fabric_selected = fcoe_get_fabric_selected,
+
 	.show_fabric_fabric_name = 1,
 	.show_fabric_switch_name = 1,
 	.show_fabric_fc_map = 1,
@@ -194,6 +227,7 @@ struct fc_function_template fcoe_nport_fc_functions = {
 
 	.fabric_create = fcoe_fabric_create,
 	.fabric_destroy = fcoe_fabric_destroy,
+	.set_fabric_dev_loss_tmo = fcoe_set_fabric_dev_loss_tmo,
 
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
@@ -387,6 +421,7 @@ static struct fcoe_interface *fcoe_interface_create(struct Scsi_Host *shost,
 {
 	struct fc_port *port;
 	struct fcoe_interface *fcoe;
+	struct ethtool_cmd ecmd;
 	int err;
 
 	if (!try_module_get(THIS_MODULE)) {
@@ -405,8 +440,33 @@ static struct fcoe_interface *fcoe_interface_create(struct Scsi_Host *shost,
 
 	fcoe = fc_port_priv(port);
 
+	/* Initialize the FC Port fixed attributes */
+	memset(fc_port_supported_fc4s(port), 0,
+	       sizeof(fc_port_supported_fc4s(port)));
+	fc_port_supported_fc4s(port)[2] = 1;
+	fc_port_supported_fc4s(port)[7] = 1;
+	fc_port_supported_classes(port) = FC_COS_CLASS3;
+
 	dev_hold(netdev);
 
+	/* TODO: Can this be folded into another routine?
+	 * fcoe_link_speed_update - per-lport, delay in
+	 * populating sysfs.
+	 * fcoe_interface_setup - currently takes a
+	 * fcoe_interface, already has the netdev held.
+	 * This is probably best candidate.
+	 */
+	fc_port_supported_speeds(port) = 0;
+	if (!dev_ethtool_get_settings(netdev, &ecmd)) {
+		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
+				      SUPPORTED_1000baseT_Full))
+			fc_port_supported_speeds(port) |=
+				FC_PORTSPEED_1GBIT;
+		if (ecmd.supported & SUPPORTED_10000baseT_Full)
+			fc_port_supported_speeds(port) |=
+				FC_PORTSPEED_10GBIT;
+	}
+
 	/*
 	 * Initialize FIP.
 	 */
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index d731ca9..4a887e1 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2897,6 +2897,63 @@ unlock:
 }
 
 /**
+ * fcoe_set_fabric_dev_loss_tmo() - Set the fabric's timeout period
+ * @fabric:  The fabric who'se timout value is to be updated
+ * @timeout: The new timout period
+ */
+void fcoe_set_fabric_dev_loss_tmo(struct fc_fabric *fabric, u32 timeout)
+{
+	if (timeout)
+		fabric->dev_loss_tmo = timeout;
+	else
+		fabric->dev_loss_tmo = 1;
+}
+EXPORT_SYMBOL(fcoe_set_fabric_dev_loss_tmo);
+
+void fcoe_get_port_sol_time(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	port->sol_time = fip->sol_time;
+}
+EXPORT_SYMBOL(fcoe_get_port_sol_time);
+
+void fcoe_get_port_sel_time(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	port->sel_time = fip->sel_time;
+}
+EXPORT_SYMBOL(fcoe_get_port_sel_time);
+
+void fcoe_get_port_port_ka_time(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	port->port_ka_time = fip->port_ka_time;
+}
+EXPORT_SYMBOL(fcoe_get_port_port_ka_time);
+
+void fcoe_get_port_ctlr_ka_time(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	port->ctlr_ka_time = fip->ctlr_ka_time;
+}
+EXPORT_SYMBOL(fcoe_get_port_ctlr_ka_time);
+
+void fcoe_get_port_probe_tries(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	port->probe_tries = fip->probe_tries;
+}
+EXPORT_SYMBOL(fcoe_get_port_probe_tries);
+
+void fcoe_get_port_port_dest_addr(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	memcpy(port->port_dest_addr, fip->dest_addr, ETH_ALEN);
+}
+EXPORT_SYMBOL(fcoe_get_port_port_dest_addr);
+
+void fcoe_get_port_ctlr_src_addr(struct fc_port *port, struct fcoe_ctlr *fip)
+{
+	memcpy(port->ctlr_src_addr, fip->ctl_src_addr, ETH_ALEN);
+	printk(KERN_ERR "ctlr_src_addr\n");
+}
+EXPORT_SYMBOL(fcoe_get_port_ctlr_src_addr);
+
+/**
  * fcoe_libfc_config() - Sets up libfc related properties for local port
  * @lport:    The local port to configure libfc for
  * @fip:      The FCoE controller in use by the local port
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index bc5ff13..acfd56c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -369,6 +369,16 @@ void fcoe_get_fabric_pri(struct fc_fabric *);
 void fcoe_get_fabric_ed_tov(struct fc_fabric *);
 void fcoe_get_fabric_ra_tov(struct fc_fabric *);
 void fcoe_get_fabric_selected(struct fc_fabric *);
+void fcoe_get_fabric_state(struct fc_fabric *);
+void fcoe_set_fabric_dev_loss_tmo(struct fc_fabric *, u32);
+
+void fcoe_get_port_sol_time(struct fc_port *, struct fcoe_ctlr *);
+void fcoe_get_port_sel_time(struct fc_port *, struct fcoe_ctlr *);
+void fcoe_get_port_port_ka_time(struct fc_port *, struct fcoe_ctlr *);
+void fcoe_get_port_ctlr_ka_time(struct fc_port *, struct fcoe_ctlr *);
+void fcoe_get_port_probe_tries(struct fc_port *, struct fcoe_ctlr *);
+void fcoe_get_port_port_dest_addr(struct fc_port *, struct fcoe_ctlr *);
+void fcoe_get_port_ctlr_src_addr(struct fc_port *, struct fcoe_ctlr *);
 
 /* fcoe transports registration and deregistration */
 int fcoe_transport_attach(struct fcoe_transport *ft);

