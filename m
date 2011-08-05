From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 08/18] bnx2fc: Handle NETDEV_UNREGISTER for vlan
 devices
Date: Thu, 4 Aug 2011 17:38:42 -0700
Message-ID: <1312504732-4572-9-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4919 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1HEAjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:16 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Since the driver holds the reference for vlan netdev, the reference has to be
released by the driver when the vlan device is removed. Driver handles this in
NETDEV_UNREGISTER event.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   92 +++++++++++++++++++++++--------------
 1 files changed, 57 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 673c97c..dccabaf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -56,6 +56,7 @@ static struct scsi_host_template bnx2fc_shost_template;
 static struct fc_function_template bnx2fc_transport_function;
 static struct fc_function_template bnx2fc_vport_xport_function;
 static int bnx2fc_create(struct net_device *netdev, enum fip_state fip_mode);
+static void __bnx2fc_destroy(struct bnx2fc_interface *interface, bool schedule);
 static int bnx2fc_destroy(struct net_device *net_device);
 static int bnx2fc_enable(struct net_device *netdev);
 static int bnx2fc_disable(struct net_device *netdev);
@@ -78,6 +79,7 @@ static void bnx2fc_destroy_work(struct work_struct *work);
 static struct bnx2fc_hba *bnx2fc_hba_lookup(struct net_device *phys_dev);
 static struct bnx2fc_interface *bnx2fc_interface_lookup(struct net_device
 							*phys_dev);
+static inline void bnx2fc_interface_put(struct bnx2fc_interface *interface);
 static struct bnx2fc_hba *bnx2fc_find_hba_for_cnic(struct cnic_dev *cnic);
 
 static int bnx2fc_fw_init(struct bnx2fc_hba *hba);
@@ -783,7 +785,7 @@ static void bnx2fc_destroy_timer(unsigned long data)
  * @vlan_id:	vlan id - associated vlan id with this event
  *
  * Handles NETDEV_UP, NETDEV_DOWN, NETDEV_GOING_DOWN,NETDEV_CHANGE and
- * NETDEV_CHANGE_MTU events
+ * NETDEV_CHANGE_MTU events. Handle NETDEV_UNREGISTER only for vlans.
  */
 static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 				     u16 vlan_id)
@@ -791,12 +793,11 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 	struct bnx2fc_hba *hba = (struct bnx2fc_hba *)context;
 	struct fc_lport *lport;
 	struct fc_lport *vport;
-	struct bnx2fc_interface *interface;
+	struct bnx2fc_interface *interface, *tmp;
 	int wait_for_upload = 0;
 	u32 link_possible = 1;
 
-	/* Ignore vlans for now */
-	if (vlan_id != 0)
+	if (vlan_id != 0 && event != NETDEV_UNREGISTER)
 		return;
 
 	switch (event) {
@@ -820,6 +821,18 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 	case NETDEV_CHANGE:
 		break;
 
+	case NETDEV_UNREGISTER:
+		if (!vlan_id)
+			return;
+		mutex_lock(&bnx2fc_dev_lock);
+		list_for_each_entry_safe(interface, tmp, &if_list, list) {
+			if (interface->hba != hba)
+				continue;
+			__bnx2fc_destroy(interface, true);
+		}
+		mutex_unlock(&bnx2fc_dev_lock);
+		return;
+
 	default:
 		printk(KERN_ERR PFX "Unkonwn netevent %ld", event);
 		return;
@@ -1022,12 +1035,27 @@ static int bnx2fc_vport_create(struct fc_vport *vport, bool disabled)
 	return 0;
 }
 
+static void bnx2fc_free_vport(struct bnx2fc_hba *hba, struct fc_lport *lport)
+{
+	struct bnx2fc_lport *blport, *tmp;
+
+	spin_lock_bh(&hba->hba_lock);
+	list_for_each_entry_safe(blport, tmp, &hba->vports, list) {
+		if (blport->lport == lport) {
+			list_del(&blport->list);
+			kfree(blport);
+		}
+	}
+	spin_unlock_bh(&hba->hba_lock);
+}
+
 static int bnx2fc_vport_destroy(struct fc_vport *vport)
 {
 	struct Scsi_Host *shost = vport_to_shost(vport);
 	struct fc_lport *n_port = shost_priv(shost);
 	struct fc_lport *vn_port = vport->dd_data;
 	struct fcoe_port *port = lport_priv(vn_port);
+	struct bnx2fc_interface *interface = port->priv;
 	struct fc_lport *v_port;
 	bool found = false;
 
@@ -1044,6 +1072,9 @@ static int bnx2fc_vport_destroy(struct fc_vport *vport)
 	}
 	list_del(&vn_port->list);
 	mutex_unlock(&n_port->lp_mutex);
+	bnx2fc_free_vport(interface->hba, port->lport);
+	bnx2fc_port_shutdown(port->lport);
+	bnx2fc_interface_put(interface);
 	queue_work(bnx2fc_wq, &port->destroy_work);
 	return 0;
 }
@@ -1386,7 +1417,6 @@ static void bnx2fc_interface_cleanup(struct bnx2fc_interface *interface)
 {
 	struct fc_lport *lport = interface->ctlr.lp;
 	struct fcoe_port *port = lport_priv(lport);
-	struct bnx2fc_lport *blport, *tmp;
 	struct bnx2fc_hba *hba = interface->hba;
 
 	/* Stop the transmit retry timer */
@@ -1400,14 +1430,7 @@ static void bnx2fc_interface_cleanup(struct bnx2fc_interface *interface)
 	__dev_remove_pack(&interface->fip_packet_type);
 	synchronize_net();
 
-	spin_lock_bh(&hba->hba_lock);
-	list_for_each_entry_safe(blport, tmp, &hba->vports, list) {
-		if (blport->lport == lport) {
-			list_del(&blport->list);
-			kfree(blport);
-		}
-	}
-	spin_unlock_bh(&hba->hba_lock);
+	bnx2fc_free_vport(hba, lport);
 }
 
 static void bnx2fc_if_destroy(struct fc_lport *lport)
@@ -1433,6 +1456,23 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 	scsi_host_put(lport->host);
 }
 
+static void __bnx2fc_destroy(struct bnx2fc_interface *interface, bool schedule)
+{
+	struct fc_lport *lport = interface->ctlr.lp;
+	struct fcoe_port *port = lport_priv(lport);
+
+	bnx2fc_interface_cleanup(interface);
+	bnx2fc_stop(interface);
+
+	list_del(&interface->list);
+	lport = interface->ctlr.lp;
+	bnx2fc_interface_put(interface);
+	if (schedule)
+		queue_work(bnx2fc_wq, &port->destroy_work);
+	else
+		bnx2fc_if_destroy(lport);
+}
+
 /**
  * bnx2fc_destroy - Destroy a bnx2fc FCoE interface
  *
@@ -1446,7 +1486,6 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 static int bnx2fc_destroy(struct net_device *netdev)
 {
 	struct bnx2fc_interface *interface = NULL;
-	struct fc_lport *lport;
 	int rc = 0;
 
 	rtnl_lock();
@@ -1460,13 +1499,8 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	}
 
 
-	bnx2fc_interface_cleanup(interface);
-	lport = interface->ctlr.lp;
-	bnx2fc_stop(interface);
-	list_del(&interface->list);
 	destroy_workqueue(interface->timer_work_queue);
-	bnx2fc_interface_put(interface);
-	bnx2fc_if_destroy(lport);
+	__bnx2fc_destroy(interface, false);
 
 netdev_err:
 	mutex_unlock(&bnx2fc_dev_lock);
@@ -1478,15 +1512,12 @@ static void bnx2fc_destroy_work(struct work_struct *work)
 {
 	struct fcoe_port *port;
 	struct fc_lport *lport;
-	struct bnx2fc_interface *interface;
 
 	port = container_of(work, struct fcoe_port, destroy_work);
 	lport = port->lport;
-	interface = port->priv;
 
 	BNX2FC_HBA_DBG(lport, "Entered bnx2fc_destroy_work\n");
 
-	bnx2fc_port_shutdown(lport);
 	rtnl_lock();
 	mutex_lock(&bnx2fc_dev_lock);
 	bnx2fc_if_destroy(lport);
@@ -2031,7 +2062,6 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 {
 	struct bnx2fc_hba *hba;
 	struct bnx2fc_interface *interface, *tmp;
-	struct fc_lport *lport;
 
 	BNX2FC_MISC_DBG("Entered bnx2fc_ulp_exit\n");
 
@@ -2053,18 +2083,10 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 	list_del_init(&hba->list);
 	adapter_count--;
 
-	list_for_each_entry_safe(interface, tmp, &if_list, list) {
+	list_for_each_entry_safe(interface, tmp, &if_list, list)
 		/* destroy not called yet, move to quiesced list */
-		if (interface->hba == hba) {
-			bnx2fc_interface_cleanup(interface);
-			bnx2fc_stop(interface);
-
-			list_del(&interface->list);
-			lport = interface->ctlr.lp;
-			bnx2fc_interface_put(interface);
-			bnx2fc_if_destroy(lport);
-		}
-	}
+		if (interface->hba == hba)
+			__bnx2fc_destroy(interface, false);
 	mutex_unlock(&bnx2fc_dev_lock);
 
 	bnx2fc_ulp_stop(hba);
-- 
1.7.0.6


