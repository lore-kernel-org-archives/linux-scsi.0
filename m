From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/16] libfcoe,
 fcoe: move fcoe_link_speed_update() to libfcoe and export it
Date: Wed, 12 Dec 2012 15:23:02 -0800
Message-ID: <20121212232302.13084.54816.stgit@fritz>
References: <20121212232203.13084.3630.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab2LLXXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 18:23:05 -0500
In-Reply-To: <20121212232203.13084.3630.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

With the previous patch, fcoe_link_speed_update() can be moved into libfcoe and
exported to used by fcoe, bnx2fc, and etc.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c           |   35 -----------------------------------
 drivers/scsi/fcoe/fcoe_transport.c |   35 +++++++++++++++++++++++++++++++++++
 include/scsi/libfcoe.h             |    1 +
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 4cec9dd..64bb531 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -82,7 +82,6 @@ static int fcoe_rcv(struct sk_buff *, struct net_device *,
 		    struct packet_type *, struct net_device *);
 static int fcoe_percpu_receive_thread(void *);
 static void fcoe_percpu_clean(struct fc_lport *);
-static int fcoe_link_speed_update(struct fc_lport *);
 static int fcoe_link_ok(struct fc_lport *);
 
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
@@ -2388,40 +2387,6 @@ static int fcoe_ctlr_alloc(struct net_device *netdev)
 }
 
 /**
- * fcoe_link_speed_update() - Update the supported and actual link speeds
- * @lport: The local port to update speeds for
- *
- * Returns: 0 if the ethtool query was successful
- *          -1 if the ethtool query failed
- */
-static int fcoe_link_speed_update(struct fc_lport *lport)
-{
-	struct net_device *netdev = fcoe_netdev(lport);
-	struct ethtool_cmd ecmd;
-
-	if (!__ethtool_get_settings(netdev, &ecmd)) {
-		lport->link_supported_speeds &=
-			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
-		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
-				      SUPPORTED_1000baseT_Full))
-			lport->link_supported_speeds |= FC_PORTSPEED_1GBIT;
-		if (ecmd.supported & SUPPORTED_10000baseT_Full)
-			lport->link_supported_speeds |=
-				FC_PORTSPEED_10GBIT;
-		switch (ethtool_cmd_speed(&ecmd)) {
-		case SPEED_1000:
-			lport->link_speed = FC_PORTSPEED_1GBIT;
-			break;
-		case SPEED_10000:
-			lport->link_speed = FC_PORTSPEED_10GBIT;
-			break;
-		}
-		return 0;
-	}
-	return -1;
-}
-
-/**
  * fcoe_link_ok() - Check if the link is OK for a local port
  * @lport: The local port to check link on
  *
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 83e78f9..3c6846f 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -83,6 +83,41 @@ static struct notifier_block libfcoe_notifier = {
 	.notifier_call = libfcoe_device_notification,
 };
 
+/**
+ * fcoe_link_speed_update() - Update the supported and actual link speeds
+ * @lport: The local port to update speeds for
+ *
+ * Returns: 0 if the ethtool query was successful
+ *          -1 if the ethtool query failed
+ */
+int fcoe_link_speed_update(struct fc_lport *lport)
+{
+	struct net_device *netdev = fcoe_get_netdev(lport);
+	struct ethtool_cmd ecmd;
+
+	if (!__ethtool_get_settings(netdev, &ecmd)) {
+		lport->link_supported_speeds &=
+			~(FC_PORTSPEED_1GBIT | FC_PORTSPEED_10GBIT);
+		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
+				      SUPPORTED_1000baseT_Full))
+			lport->link_supported_speeds |= FC_PORTSPEED_1GBIT;
+		if (ecmd.supported & SUPPORTED_10000baseT_Full)
+			lport->link_supported_speeds |=
+				FC_PORTSPEED_10GBIT;
+		switch (ethtool_cmd_speed(&ecmd)) {
+		case SPEED_1000:
+			lport->link_speed = FC_PORTSPEED_1GBIT;
+			break;
+		case SPEED_10000:
+			lport->link_speed = FC_PORTSPEED_10GBIT;
+			break;
+		}
+		return 0;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(fcoe_link_speed_update);
+
 void __fcoe_get_lesb(struct fc_lport *lport,
 		     struct fc_els_lesb *fc_lesb,
 		     struct net_device *netdev)
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 746bc58..6c59ba7 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -260,6 +260,7 @@ void __fcoe_get_lesb(struct fc_lport *lport, struct fc_els_lesb *fc_lesb,
 		     struct net_device *netdev);
 void fcoe_wwn_to_str(u64 wwn, char *buf, int len);
 int fcoe_validate_vport_create(struct fc_vport *vport);
+int fcoe_link_speed_update(struct fc_lport *);
 
 /**
  * is_fip_mode() - returns true if FIP mode selected.

