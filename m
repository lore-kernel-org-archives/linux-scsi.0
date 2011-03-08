From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH 5/8] libfcoe, fcoe: Use FCoE attributes
Date: Mon, 07 Mar 2011 18:32:10 -0800
Message-ID: <20110308023210.6205.70249.stgit@localhost6.localdomain6>
References: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1CHCfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 21:35:05 -0500
In-Reply-To: <20110308023143.6205.54720.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

Use the new interfaces to add fcoe attributes to the
FC syfs layout.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |  101 ++++++++++++++++++++++++++++++++++-------
 drivers/scsi/fcoe/fcoe_ctlr.c |   24 ++++++----
 drivers/scsi/libfc/fc_lport.c |    6 ++
 include/scsi/libfc.h          |    1 
 4 files changed, 104 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5064086..8603b8c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -123,6 +123,10 @@ static void fcoe_get_vport_ids(struct fc_lport *lport,
 			       struct fc_vport_identifiers *ids);
 */
 
+static void fcoe_get_fcport_vn_port_mac_address(struct fc_port *);
+static int fcoe_get_fcvport_fcoe_lesb(struct fc_vport *,
+				      struct fc_vport_fcoe_lesb *);
+
 /* notification function for packets from net device */
 static struct notifier_block fcoe_notifier = {
 	.notifier_call = fcoe_device_notification,
@@ -211,6 +215,8 @@ struct fc_port_function_template fcoe_fcport_fcn_tmpl = {
 		.dd_fcvport_size = (sizeof(struct fc_lport) +
 				    sizeof(struct fcoe_port)),
 
+		.get_fcvport_fcoe_lesb = fcoe_get_fcvport_fcoe_lesb,
+
 		.fcrport_f = {
 			.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 			.show_rport_maxframe_size = 1,
@@ -220,6 +226,11 @@ struct fc_port_function_template fcoe_fcport_fcn_tmpl = {
 			.terminate_rport_io = fc_rport_terminate_io,
 		},
 	},
+
+	.show_fcport_enode_mac_address = 1,
+	.show_fcport_vlan_id = 1,
+
+	.get_fcport_vn_port_mac_address = fcoe_get_fcport_vn_port_mac_address,
 };
 
 struct fc_fabric_function_template fcoe_fcfabric_fcn_tmpl = {
@@ -228,6 +239,12 @@ struct fc_fabric_function_template fcoe_fcfabric_fcn_tmpl = {
 	.show_fcfabric_fabric_name = 1,
 	.show_fcfabric_dev_loss_tmo = 1,
 	.dd_fcfabric_size = sizeof(struct fcoe_fcf),
+
+	.show_fcfabric_fc_map = 1,
+	.show_fcfabric_vfid = 1,
+	.show_fcfabric_mac_address = 1,
+	.show_fcfabric_priority = 1,
+	.show_fcfabric_fka_period = 1,
 };
 
 static void _fcoe_get_vport_ids(struct fcoe_interface *fcoe,
@@ -288,6 +305,32 @@ static void fcoe_set_port_name(struct fc_lport *lport)
 }
 */
 
+
+static int fcoe_get_san_mac(struct net_device *netdev, u8 mac_addr[ETH_ALEN])
+{
+	struct netdev_hw_addr *ha;
+	struct net_device *real_dev;
+	int ret = -ENOENT;
+
+	/* look for SAN MAC address, if multiple SAN MACs exist, only
+	 * use the first one for SPMA */
+	real_dev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
+		vlan_dev_real_dev(netdev) : netdev;
+	rcu_read_lock();
+	for_each_dev_addr(real_dev, ha) {
+		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
+		    (is_valid_ether_addr(ha->addr))) {
+			memcpy(mac_addr, ha->addr, ETH_ALEN);
+			ret = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
+
 /**
  * fcoe_interface_setup() - Setup a FCoE interface
  * @fcoe:   The new FCoE interface
@@ -300,8 +343,6 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 				struct net_device *netdev)
 {
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
-	struct netdev_hw_addr *ha;
-	struct net_device *real_dev;
 	u8 flogi_maddr[ETH_ALEN];
 	const struct net_device_ops *ops;
 
@@ -326,20 +367,9 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 		return -EOPNOTSUPP;
 	}
 
-	/* look for SAN MAC address, if multiple SAN MACs exist, only
-	 * use the first one for SPMA */
-	real_dev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
-		vlan_dev_real_dev(netdev) : netdev;
-	rcu_read_lock();
-	for_each_dev_addr(real_dev, ha) {
-		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(ha->addr))) {
-			memcpy(fip->ctl_src_addr, ha->addr, ETH_ALEN);
-			fip->spma = 1;
-			break;
-		}
-	}
-	rcu_read_unlock();
+	/* Will not change ctlr_src_addr if there is no SAN MAC */
+	if (!fcoe_get_san_mac(netdev, fip->ctl_src_addr))
+		fip->spma = 1;
 
 	/* setup Source Mac Address */
 	if (!fip->spma)
@@ -388,9 +418,14 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 						    enum fip_state fip_mode)
 {
 	struct fc_port *fcport;
+	struct fc_port_fcoe_attrs fcoe_attrs;
 	struct fcoe_interface *fcoe;
 	int err;
 
+	fcoe_get_san_mac(netdev, fcoe_attrs.enode_mac_address);
+	if (netdev->priv_flags & IFF_802_1Q_VLAN)
+		fcoe_attrs.vlan_id = vlan_dev_vlan_id(netdev);
+
 	if (!try_module_get(THIS_MODULE)) {
 		FCOE_NETDEV_DBG(netdev,
 				"Could not get a reference to the module\n");
@@ -399,7 +434,8 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	}
 
 	fcport = fc_port_add((struct device *)&netdev->dev.parent,
-			     &fcoe_fcport_fcn_tmpl, &fcoe_fcp_template, NULL);
+			     &fcoe_fcport_fcn_tmpl, &fcoe_fcp_template,
+			     &fcoe_attrs);
 	if (!fcport) {
 		printk(KERN_ERR "Failed to add a fcport\n");
 		fcoe = ERR_PTR(-ENOMEM);
@@ -585,6 +621,7 @@ static u8 *fcoe_get_src_mac(struct fc_lport *lport)
  */
 static int fcoe_lport_config(struct fc_lport *lport)
 {
+	lport->fcoe = 1;
 	lport->link_up = 0;
 	lport->qfull = 0;
 	lport->max_retry_count = 3;
@@ -2559,3 +2596,33 @@ static void fcoe_set_port_id(struct fc_lport *lport,
 	if (fp && fc_frame_payload_op(fp) == ELS_FLOGI)
 		fcoe_ctlr_recv_flogi(&fcoe->ctlr, lport, fp);
 }
+
+static void fcoe_get_fcport_vn_port_mac_address(struct fc_port *fcport)
+{
+	struct fcoe_interface *fcoe = fc_port_priv(fcport);
+	struct fc_lport *lport = fcoe->ctlr.lp;
+	struct fcoe_port *port = lport_priv(lport);
+
+	memcpy(fcport->fcoe_attrs.vn_port_mac_address,
+	       port->data_src_addr, ETH_ALEN);
+}
+
+static int fcoe_get_fcvport_fcoe_lesb(struct fc_vport *fcvport,
+				      struct fc_vport_fcoe_lesb *lesb)
+{
+	struct fc_lport *lport = fc_vport_priv(fcvport);
+	struct fc_els_lesb fc_lesb;
+	struct fcoe_fc_els_lesb *fcoe_lesb;
+
+	fcoe_get_lesb(lport, &fc_lesb);
+	fcoe_lesb = (struct fcoe_fc_els_lesb *)(&fc_lesb);
+
+	lesb->link_failure_count = fcoe_lesb->lesb_link_fail;
+	lesb->vlink_failure_count = fcoe_lesb->lesb_vlink_fail;
+	lesb->miss_fka_count = fcoe_lesb->lesb_miss_fka;
+	lesb->symb_err_count = fcoe_lesb->lesb_symb_err;
+	lesb->err_block_count = fcoe_lesb->lesb_err_block;
+	lesb->fcs_err_count = fcoe_lesb->lesb_fcs_error;
+
+	return 0;
+}
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 27c5e67..e8e191c 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -190,14 +190,12 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 void fcoe_ctlr_destroy(struct fcoe_ctlr *fip)
 {
 	struct fc_port *fcport = fip->lp->fcport;
-	struct fc_vport *fcvport = lport_to_fcvport(fip->lp);
 
 	cancel_work_sync(&fip->recv_work);
 	skb_queue_purge(&fip->fip_recv_list);
 
 	mutex_lock(&fcport->lock);
 	fcoe_ctlr_set_state(fip, FIP_ST_DISABLED);
-	fcvport->fcfabric = NULL;
 	fcoe_ctlr_reset_fcfs(fip);
 	mutex_unlock(&fcport->lock);
 	del_timer_sync(&fip->timer);
@@ -931,6 +929,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	struct fc_fabric *fcfabric;
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf new;
+	struct fc_fabric_fcoe_attrs fcoe_attrs;
 	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
 	int first = 0;
 	int mtu_valid;
@@ -955,8 +954,14 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	 */
 	first = list_empty(&fcport->fabrics);
 
+	fcoe_attrs.fc_map = new.fc_map;
+	fcoe_attrs.vfid = new.vfid;
+	memcpy(fcoe_attrs.mac_address, new.fcf_mac, ETH_ALEN);
+	fcoe_attrs.priority = new.pri;
+	fcoe_attrs.fka_period = new.fka_period;
+
 	fcfabric = fc_fabric_add(fcport, fip->fcfabric_f,
-				 new_fcfabric, NULL);
+				 new_fcfabric, &fcoe_attrs);
 	if (unlikely(!fcfabric))
 		goto out;
 
@@ -2732,11 +2737,13 @@ unlock:
 	mutex_unlock(&fcport->lock);
 
 	/* If port ID is new, notify local port after dropping ctlr_mutex */
-	if (new_port_id) {
-		fcvport->fcfabric = fc_fabric_add(fcport, fip->fcfabric_f,
-						  0, NULL);
-		fc_lport_set_local_id(fip->lp, new_port_id);
-	}
+        if (new_port_id) {
+                struct fc_fabric_fcoe_attrs fcoe_attrs;
+                /* Add a dummy fabric for VN2VN */
+                fcvport->fcfabric = fc_fabric_add(fcport, fip->fcfabric_f,
+                                                  NULL, &fcoe_attrs);
+                fc_lport_set_local_id(fip->lp, new_port_id);
+        }
 }
 
 /**
@@ -2744,7 +2751,6 @@ unlock:
  * @lp: The local port to configure libfc for
  * @fip: The FCoE controller in use by the local port
  * @tt: The libfc function template
- * @init_fcp: If non-zero, the FCP portion of libfc should be initialized
  *
  * Returns : 0 for success
  */
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 37a4bad..1bd4ddc 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -760,7 +760,8 @@ void fc_lport_set_local_id(struct fc_lport *lport, u32 port_id)
 	case LPORT_ST_FLOGI:
 		if (port_id) {
 			mutex_lock(&fcport->lock);
-			fc_vport_add(lport->fcfabric, fcvport, 0);
+			fc_vport_add(lport->fcfabric, fcvport,
+				     lport->fcoe);
 			mutex_unlock(&fcport->lock);
 
 			fc_lport_enter_ready(lport);
@@ -1554,7 +1555,8 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				fc_lport_set_port_id(lport, did, fp);
 
 				mutex_lock(&fcport->lock);
-				fc_vport_add(lport->fcfabric, fcvport, 0);
+				fc_vport_add(lport->fcfabric, fcvport,
+					     lport->fcoe);
 				mutex_unlock(&fcport->lock);
 
 				fc_lport_enter_dns(lport);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 1086568..0c67b87 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -872,6 +872,7 @@ struct fc_lport {
 	struct fc_els_rnid_gen	       rnid_gen;
 
 	/* Capabilities */
+	u32                            fcoe:1;
 	u32			       sg_supp:1;
 	u32			       seq_offload:1;
 	u32			       crc_offload:1;

