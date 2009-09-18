From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/24] fcoe: Use NETIF_F_FCOE_MTU flag to set up max frame
	size (lport->mfs)
Date: Fri, 18 Sep 2009 15:50:01 -0700
Message-ID: <20090918225001.5928.20613.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813AbZIRWuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:50:09 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Add a define of FCOE_MTU as 2158 bytes and use FCOE_MTU when the LLD is found
to support NETIF_F_FCOE_MTU. The lport->mfs is then calculated out of the
2158 FCOE_MTU. Otherwise, we stick with the netdev->mtu, i.e., LAN MTU. Also,
change the notification on NETDEV_CHANGEMTU event to bypass changing mfs when
LAN MTU is changed if NETIF_F_FCOE_MTU is supported.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   10 ++++++++--
 drivers/scsi/fcoe/fcoe.h |    6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 27fcfdc..c104ad6 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -536,8 +536,12 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 	 * user-configured limit.  If the MFS is too low, fcoe_link_ok()
 	 * will return 0, so do this first.
 	 */
-	mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
-			     sizeof(struct fcoe_crc_eof));
+	mfs = netdev->mtu;
+	if (netdev->features & NETIF_F_FCOE_MTU) {
+		mfs = FCOE_MTU;
+		FCOE_NETDEV_DBG(netdev, "Supports FCOE_MTU of %d bytes\n", mfs);
+	}
+	mfs -= (sizeof(struct fcoe_hdr) + sizeof(struct fcoe_crc_eof));
 	if (fc_set_mfs(lport, mfs))
 		return -EINVAL;
 
@@ -1717,6 +1721,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_CHANGE:
 		break;
 	case NETDEV_CHANGEMTU:
+		if (netdev->features & NETIF_F_FCOE_MTU)
+			break;
 		mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
 				     sizeof(struct fcoe_crc_eof));
 		if (mfs >= FC_MIN_MAX_FRAME)
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index fc2da8a..c69b2c5 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -40,6 +40,12 @@
 #define FCOE_MIN_XID		0x0000	/* the min xid supported by fcoe_sw */
 #define FCOE_MAX_XID		0x0FFF	/* the max xid supported by fcoe_sw */
 
+/*
+ * Max MTU for FCoE: 14 (FCoE header) + 24 (FC header) + 2112 (max FC payload)
+ * + 4 (FC CRC) + 4 (FCoE trailer) =  2158 bytes
+ */
+#define FCOE_MTU	2158
+
 unsigned int fcoe_debug_logging;
 module_param_named(debug_logging, fcoe_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");

