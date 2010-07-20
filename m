From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 25/28] fcoe: fix offload feature flag change from netdev
Date: Tue, 20 Jul 2010 15:21:17 -0700
Message-ID: <20100720222117.17116.56926.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab0GTWVS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:18 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Currently, when FCoE netdev feature flags are toggled by the LLD, lport's
corresponding flags are not updated. This causes the fc_fcp to still try to
offload the I/O. This patch adds support of NETDEV_FEAT_CHANGE event in fcoe
netdev device notification callback so we can update the lport offload flags
appropriately.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   68 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ab6ea60..cf9d718 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -589,6 +589,50 @@ static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
 }
 
 /**
+ * fcoe_netdev_features_change - Updates the lport's offload flags based
+ * on the LLD netdev's FCoE feature flags
+ */
+static void fcoe_netdev_features_change(struct fc_lport *lport,
+					struct net_device *netdev)
+{
+	mutex_lock(&lport->lp_mutex);
+
+	if (netdev->features & NETIF_F_SG)
+		lport->sg_supp = 1;
+	else
+		lport->sg_supp = 0;
+
+	if (netdev->features & NETIF_F_FCOE_CRC) {
+		lport->crc_offload = 1;
+		FCOE_NETDEV_DBG(netdev, "Supports FCCRC offload\n");
+	} else {
+		lport->crc_offload = 0;
+	}
+
+	if (netdev->features & NETIF_F_FSO) {
+		lport->seq_offload = 1;
+		lport->lso_max = netdev->gso_max_size;
+		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
+				lport->lso_max);
+	} else {
+		lport->seq_offload = 0;
+		lport->lso_max = 0;
+	}
+
+	if (netdev->fcoe_ddp_xid) {
+		lport->lro_enabled = 1;
+		lport->lro_xid = netdev->fcoe_ddp_xid;
+		FCOE_NETDEV_DBG(netdev, "Supports LRO for max xid 0x%x\n",
+				lport->lro_xid);
+	} else {
+		lport->lro_enabled = 0;
+		lport->lro_xid = 0;
+	}
+
+	mutex_unlock(&lport->lp_mutex);
+}
+
+/**
  * fcoe_netdev_config() - Set up net devive for SW FCoE
  * @lport:  The local port that is associated with the net device
  * @netdev: The associated net device
@@ -624,25 +668,8 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 		return -EINVAL;
 
 	/* offload features support */
-	if (netdev->features & NETIF_F_SG)
-		lport->sg_supp = 1;
+	fcoe_netdev_features_change(lport, netdev);
 
-	if (netdev->features & NETIF_F_FCOE_CRC) {
-		lport->crc_offload = 1;
-		FCOE_NETDEV_DBG(netdev, "Supports FCCRC offload\n");
-	}
-	if (netdev->features & NETIF_F_FSO) {
-		lport->seq_offload = 1;
-		lport->lso_max = netdev->gso_max_size;
-		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
-				lport->lso_max);
-	}
-	if (netdev->fcoe_ddp_xid) {
-		lport->lro_enabled = 1;
-		lport->lro_xid = netdev->fcoe_ddp_xid;
-		FCOE_NETDEV_DBG(netdev, "Supports LRO for max xid 0x%x\n",
-				lport->lro_xid);
-	}
 	skb_queue_head_init(&port->fcoe_pending_queue);
 	port->fcoe_pending_queue_active = 0;
 	setup_timer(&port->timer, fcoe_queue_timer, (unsigned long)lport);
@@ -1861,6 +1888,9 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		schedule_work(&port->destroy_work);
 		goto out;
 		break;
+	case NETDEV_FEAT_CHANGE:
+		fcoe_netdev_features_change(lport, netdev);
+		break;
 	default:
 		FCOE_NETDEV_DBG(netdev, "Unknown event %ld "
 				"from netdev netlink\n", event);
@@ -2056,8 +2086,8 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		rc = -ENODEV;
 		goto out_putdev;
 	}
-	list_del(&fcoe->list);
 	fcoe_interface_cleanup(fcoe);
+	list_del(&fcoe->list);
 	/* RTNL mutex is dropped by fcoe_if_destroy */
 	fcoe_if_destroy(fcoe->ctlr.lp);
 

