From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/16] libfcoe,
 fcoe: consolidate the fcoe_ctlr_get_lesb/fcoe_get_lesb
Date: Wed, 12 Dec 2012 15:23:08 -0800
Message-ID: <20121212232308.13084.2948.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LLXXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:23:09 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Similarly they can be moved into libfcoe instead of being private to fcoe now.
Also add comments particularly on the term LESB to the corresponding function.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c           |   40 ---------------------------
 drivers/scsi/fcoe/fcoe_transport.c |   54 ++++++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h             |    2 +
 3 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 64bb531..0b33368 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -130,8 +130,6 @@ static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 				      void *, u32 timeout);
 static void fcoe_recv_frame(struct sk_buff *skb);
 
-static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
-
 /* notification function for packets from net device */
 static struct notifier_block fcoe_notifier = {
 	.notifier_call = fcoe_device_notification,
@@ -155,7 +153,6 @@ static int fcoe_vport_create(struct fc_vport *, bool disabled);
 static int fcoe_vport_disable(struct fc_vport *, bool disable);
 static void fcoe_set_vport_symbolic_name(struct fc_vport *);
 static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
-static void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *);
 static void fcoe_fcf_get_vlan_id(struct fcoe_fcf_device *);
 
 static struct fcoe_sysfs_function_template fcoe_sysfs_templ = {
@@ -2858,43 +2855,6 @@ static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
 			     NULL, NULL, 3 * lport->r_a_tov);
 }
 
-/**
- * fcoe_get_lesb() - Fill the FCoE Link Error Status Block
- * @lport: the local port
- * @fc_lesb: the link error status block
- */
-static void fcoe_get_lesb(struct fc_lport *lport,
-			 struct fc_els_lesb *fc_lesb)
-{
-	struct net_device *netdev = fcoe_netdev(lport);
-
-	__fcoe_get_lesb(lport, fc_lesb, netdev);
-}
-
-static void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
-{
-	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr_dev);
-	struct net_device *netdev = fcoe_netdev(fip->lp);
-	struct fcoe_fc_els_lesb *fcoe_lesb;
-	struct fc_els_lesb fc_lesb;
-
-	__fcoe_get_lesb(fip->lp, &fc_lesb, netdev);
-	fcoe_lesb = (struct fcoe_fc_els_lesb *)(&fc_lesb);
-
-	ctlr_dev->lesb.lesb_link_fail =
-		ntohl(fcoe_lesb->lesb_link_fail);
-	ctlr_dev->lesb.lesb_vlink_fail =
-		ntohl(fcoe_lesb->lesb_vlink_fail);
-	ctlr_dev->lesb.lesb_miss_fka =
-		ntohl(fcoe_lesb->lesb_miss_fka);
-	ctlr_dev->lesb.lesb_symb_err =
-		ntohl(fcoe_lesb->lesb_symb_err);
-	ctlr_dev->lesb.lesb_err_block =
-		ntohl(fcoe_lesb->lesb_err_block);
-	ctlr_dev->lesb.lesb_fcs_error =
-		ntohl(fcoe_lesb->lesb_fcs_error);
-}
-
 static void fcoe_fcf_get_vlan_id(struct fcoe_fcf_device *fcf_dev)
 {
 	struct fcoe_ctlr_device *ctlr_dev =
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 3c6846f..dd1aeb4 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -118,6 +118,15 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 }
 EXPORT_SYMBOL_GPL(fcoe_link_speed_update);
 
+/**
+ * __fcoe_get_lesb() - Get the Link Error Status Block (LESB) for a given lport
+ * @lport: The local port to update speeds for
+ * @fc_lesb: Pointer to the LESB to be filled up
+ * @netdev: Pointer to the netdev that is associated with the lport
+ *
+ * Note, the Link Error Status Block (LESB) for FCoE is defined in FC-BB-6
+ * Clause 7.11 in v1.04.
+ */
 void __fcoe_get_lesb(struct fc_lport *lport,
 		     struct fc_els_lesb *fc_lesb,
 		     struct net_device *netdev)
@@ -147,6 +156,51 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 }
 EXPORT_SYMBOL_GPL(__fcoe_get_lesb);
 
+/**
+ * fcoe_get_lesb() - Fill the FCoE Link Error Status Block
+ * @lport: the local port
+ * @fc_lesb: the link error status block
+ */
+void fcoe_get_lesb(struct fc_lport *lport,
+			 struct fc_els_lesb *fc_lesb)
+{
+	struct net_device *netdev = fcoe_get_netdev(lport);
+
+	__fcoe_get_lesb(lport, fc_lesb, netdev);
+}
+EXPORT_SYMBOL_GPL(fcoe_get_lesb);
+
+/**
+ * fcoe_ctlr_get_lesb() - Get the Link Error Status Block (LESB) for a given
+ * fcoe controller device
+ * @ctlr_dev: The given fcoe controller device
+ *
+ */
+void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev)
+{
+	struct fcoe_ctlr *fip = fcoe_ctlr_device_priv(ctlr_dev);
+	struct net_device *netdev = fcoe_get_netdev(fip->lp);
+	struct fcoe_fc_els_lesb *fcoe_lesb;
+	struct fc_els_lesb fc_lesb;
+
+	__fcoe_get_lesb(fip->lp, &fc_lesb, netdev);
+	fcoe_lesb = (struct fcoe_fc_els_lesb *)(&fc_lesb);
+
+	ctlr_dev->lesb.lesb_link_fail =
+		ntohl(fcoe_lesb->lesb_link_fail);
+	ctlr_dev->lesb.lesb_vlink_fail =
+		ntohl(fcoe_lesb->lesb_vlink_fail);
+	ctlr_dev->lesb.lesb_miss_fka =
+		ntohl(fcoe_lesb->lesb_miss_fka);
+	ctlr_dev->lesb.lesb_symb_err =
+		ntohl(fcoe_lesb->lesb_symb_err);
+	ctlr_dev->lesb.lesb_err_block =
+		ntohl(fcoe_lesb->lesb_err_block);
+	ctlr_dev->lesb.lesb_fcs_error =
+		ntohl(fcoe_lesb->lesb_fcs_error);
+}
+EXPORT_SYMBOL_GPL(fcoe_ctlr_get_lesb);
+
 void fcoe_wwn_to_str(u64 wwn, char *buf, int len)
 {
 	u8 wwpn[8];
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 6c59ba7..4427393 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -261,6 +261,8 @@ void __fcoe_get_lesb(struct fc_lport *lport, struct fc_els_lesb *fc_lesb,
 void fcoe_wwn_to_str(u64 wwn, char *buf, int len);
 int fcoe_validate_vport_create(struct fc_vport *vport);
 int fcoe_link_speed_update(struct fc_lport *);
+void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
+void fcoe_ctlr_get_lesb(struct fcoe_ctlr_device *ctlr_dev);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.

