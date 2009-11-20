From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe: Use LLD's WWPN and WWNN for lport if LLD supports
	ndo_fcoe_get_wwn
Date: Fri, 20 Nov 2009 15:22:21 -0800
Message-ID: <20091120232221.3449.4170.stgit@localhost.localdomain>
References: <20091120232215.3449.44917.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZKTXWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 18:22:15 -0500
In-Reply-To: <20091120232215.3449.44917.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

If the LLD wants its own WWNN/WWPN to be used, it should implement the
netdev_ops.ndo_fcoe_get_wwn(). If that is the case, we query the LLD and use
the queried WWNN/WWPN from the LLD.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a30ffaa..9b6aebb 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -545,6 +545,23 @@ static void fcoe_queue_timer(ulong lport)
 }
 
 /**
+ * fcoe_get_wwn() - Get the world wide name from LLD if it supports it
+ * @netdev: the associated net device
+ * @wwn: the output WWN
+ * @type: the type of WWN (WWPN or WWNN)
+ *
+ * Returns: 0 for success
+ */
+static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
+{
+	const struct net_device_ops *ops = netdev->netdev_ops;
+
+	if (ops->ndo_fcoe_get_wwn)
+		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
+	return -EINVAL;
+}
+
+/**
  * fcoe_netdev_config() - Set up net devive for SW FCoE
  * @lport:  The local port that is associated with the net device
  * @netdev: The associated net device
@@ -611,9 +628,13 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 		 */
 		if (netdev->priv_flags & IFF_802_1Q_VLAN)
 			vid = vlan_dev_vlan_id(netdev);
-		wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
+
+		if (fcoe_get_wwn(netdev, &wwnn, NETDEV_FCOE_WWNN))
+			wwnn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 1, 0);
 		fc_set_wwnn(lport, wwnn);
-		wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr, 2, vid);
+		if (fcoe_get_wwn(netdev, &wwpn, NETDEV_FCOE_WWPN))
+			wwpn = fcoe_wwn_from_mac(fcoe->ctlr.ctl_src_addr,
+						 2, vid);
 		fc_set_wwpn(lport, wwpn);
 	}
 

