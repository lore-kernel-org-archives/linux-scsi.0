From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 07/18] bnx2fc: Reorganize cleanup code between
 interface_cleanup and if_destory
Date: Thu, 4 Aug 2011 17:38:41 -0700
Message-ID: <1312504732-4572-8-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4917 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1HEAjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:08 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Move interface specific cleanup functionality to from bnx2fc_if_destroy to
bnx2fc_interface_cleanup. Do not access interface/hba in bnx2fc_if_destroy as
by the time this function is called interface may already be destroyed. This
patch is in preparation to handle NETDEV_UNREGISTER on a vlan device.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   47 ++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 407a9b8..673c97c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1384,16 +1384,10 @@ free_blport:
 
 static void bnx2fc_interface_cleanup(struct bnx2fc_interface *interface)
 {
-	/* Dont listen for Ethernet packets anymore */
-	__dev_remove_pack(&interface->fcoe_packet_type);
-	__dev_remove_pack(&interface->fip_packet_type);
-	synchronize_net();
-}
-
-static void bnx2fc_if_destroy(struct fc_lport *lport, struct bnx2fc_hba *hba)
-{
+	struct fc_lport *lport = interface->ctlr.lp;
 	struct fcoe_port *port = lport_priv(lport);
 	struct bnx2fc_lport *blport, *tmp;
+	struct bnx2fc_hba *hba = interface->hba;
 
 	/* Stop the transmit retry timer */
 	del_timer_sync(&port->timer);
@@ -1401,6 +1395,24 @@ static void bnx2fc_if_destroy(struct fc_lport *lport, struct bnx2fc_hba *hba)
 	/* Free existing transmit skbs */
 	fcoe_clean_pending_queue(lport);
 
+	/* Dont listen for Ethernet packets anymore */
+	__dev_remove_pack(&interface->fcoe_packet_type);
+	__dev_remove_pack(&interface->fip_packet_type);
+	synchronize_net();
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
+static void bnx2fc_if_destroy(struct fc_lport *lport)
+{
+
 	/* Free queued packets for the receive thread */
 	bnx2fc_clean_rx_queue(lport);
 
@@ -1417,15 +1429,6 @@ static void bnx2fc_if_destroy(struct fc_lport *lport, struct bnx2fc_hba *hba)
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
-	spin_lock_bh(&hba->hba_lock);
-	list_for_each_entry_safe(blport, tmp, &hba->vports, list) {
-		if (blport->lport == lport) {
-			list_del(&blport->list);
-			kfree(blport);
-		}
-	}
-	spin_unlock_bh(&hba->hba_lock);
-
 	/* Release Scsi_Host */
 	scsi_host_put(lport->host);
 }
@@ -1443,7 +1446,6 @@ static void bnx2fc_if_destroy(struct fc_lport *lport, struct bnx2fc_hba *hba)
 static int bnx2fc_destroy(struct net_device *netdev)
 {
 	struct bnx2fc_interface *interface = NULL;
-	struct bnx2fc_hba *hba;
 	struct fc_lport *lport;
 	int rc = 0;
 
@@ -1457,7 +1459,6 @@ static int bnx2fc_destroy(struct net_device *netdev)
 		goto netdev_err;
 	}
 
-	hba = interface->hba;
 
 	bnx2fc_interface_cleanup(interface);
 	lport = interface->ctlr.lp;
@@ -1465,7 +1466,7 @@ static int bnx2fc_destroy(struct net_device *netdev)
 	list_del(&interface->list);
 	destroy_workqueue(interface->timer_work_queue);
 	bnx2fc_interface_put(interface);
-	bnx2fc_if_destroy(lport, hba);
+	bnx2fc_if_destroy(lport);
 
 netdev_err:
 	mutex_unlock(&bnx2fc_dev_lock);
@@ -1478,19 +1479,17 @@ static void bnx2fc_destroy_work(struct work_struct *work)
 	struct fcoe_port *port;
 	struct fc_lport *lport;
 	struct bnx2fc_interface *interface;
-	struct bnx2fc_hba *hba;
 
 	port = container_of(work, struct fcoe_port, destroy_work);
 	lport = port->lport;
 	interface = port->priv;
-	hba = interface->hba;
 
 	BNX2FC_HBA_DBG(lport, "Entered bnx2fc_destroy_work\n");
 
 	bnx2fc_port_shutdown(lport);
 	rtnl_lock();
 	mutex_lock(&bnx2fc_dev_lock);
-	bnx2fc_if_destroy(lport, hba);
+	bnx2fc_if_destroy(lport);
 	mutex_unlock(&bnx2fc_dev_lock);
 	rtnl_unlock();
 }
@@ -2063,7 +2062,7 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 			list_del(&interface->list);
 			lport = interface->ctlr.lp;
 			bnx2fc_interface_put(interface);
-			bnx2fc_if_destroy(lport, hba);
+			bnx2fc_if_destroy(lport);
 		}
 	}
 	mutex_unlock(&bnx2fc_dev_lock);
-- 
1.7.0.6


