From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] fcoe: Update multicast addresses on FIP mode change
Date: Mon,  4 Jul 2016 10:29:21 +0200
Message-ID: <1467620963-67047-5-git-send-email-hare@suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbcGDI3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 04:29:33 -0400
In-Reply-To: <1467620963-67047-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the FIP mode is changed we need to update the multicast
addresses to ensure we get the correct frames.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 41c67e5..61eda74 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -115,7 +115,7 @@ static int fcoe_disable(struct net_device *netdev);
 /* fcoe_syfs control interface handlers */
 static int fcoe_ctlr_alloc(struct net_device *netdev);
 static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev);
-
+static void fcoe_ctlr_mode(struct fcoe_ctlr_device *ctlr_dev);
 
 static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 				      u32 did, struct fc_frame *,
@@ -146,8 +146,9 @@ static void fcoe_set_vport_symbolic_name(struct fc_vport *);
 static void fcoe_set_port_id(struct fc_lport *, u32, struct fc_frame *);
 static void fcoe_fcf_get_vlan_id(struct fcoe_fcf_device *);
 
+
 static struct fcoe_sysfs_function_template fcoe_sysfs_templ = {
-	.set_fcoe_ctlr_mode = fcoe_ctlr_set_fip_mode,
+	.set_fcoe_ctlr_mode = fcoe_ctlr_mode,
 	.set_fcoe_ctlr_enabled = fcoe_ctlr_enabled,
 	.get_fcoe_ctlr_link_fail = fcoe_ctlr_get_lesb,
 	.get_fcoe_ctlr_vlink_fail = fcoe_ctlr_get_lesb,
@@ -1976,6 +1977,32 @@ static int fcoe_ctlr_enabled(struct fcoe_ctlr_device *cdev)
 }
 
 /**
+ * fcoe_ctlr_mode() - Switch FIP mode
+ * @cdev: The FCoE Controller that is being modified
+ *
+ * When the FIP mode has been changed we need to update
+ * the multicast addresses to ensure we get the correct
+ * frames.
+ */
+static void fcoe_ctlr_mode(struct fcoe_ctlr_device *ctlr_dev)
+{
+	struct fcoe_ctlr *ctlr = fcoe_ctlr_device_priv(ctlr_dev);
+	struct fcoe_interface *fcoe = fcoe_ctlr_priv(ctlr);
+
+	if (ctlr_dev->mode == FIP_CONN_TYPE_VN2VN &&
+	    ctlr->mode != FIP_MODE_VN2VN) {
+		dev_mc_del(fcoe->netdev, FIP_ALL_ENODE_MACS);
+		dev_mc_add(fcoe->netdev, FIP_ALL_VN2VN_MACS);
+		dev_mc_add(fcoe->netdev, FIP_ALL_P2P_MACS);
+	} else if (ctlr->mode != FIP_MODE_FABRIC) {
+		dev_mc_del(fcoe->netdev, FIP_ALL_VN2VN_MACS);
+		dev_mc_del(fcoe->netdev, FIP_ALL_P2P_MACS);
+		dev_mc_add(fcoe->netdev, FIP_ALL_ENODE_MACS);
+	}
+	fcoe_ctlr_set_fip_mode(ctlr_dev);
+}
+
+/**
  * fcoe_destroy() - Destroy a FCoE interface
  * @netdev  : The net_device object the Ethernet interface to create on
  *
-- 
1.8.5.6

