From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH] Allow FCoE to run on top of VLAN driver even though it has no
	pause.
Date: Fri, 11 Jan 2008 09:39:34 -0800
Message-ID: <20080111173934.8813.72954.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759660AbYALCHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 21:07:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If the net_device has no ethtool ops and it is a VLAN,
find the underlying physical device using the VLAN driver's macro, and
use it's ethtool ops.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/fcoe/fcoe_def.h |    1 +
 drivers/scsi/ofc/fcoe/fcoe_if.c  |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ofc/fcoe/fcoe_def.h b/drivers/scsi/ofc/fcoe/fcoe_def.h
index 6550c73..22c5934 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_def.h
+++ b/drivers/scsi/ofc/fcoe/fcoe_def.h
@@ -67,6 +67,7 @@ struct fcoe_softc {
 	struct list_head list;
 	struct fcdev *fd;
 	struct net_device *real_dev;
+	struct net_device *phys_dev;		/* device with ethtool_ops */
 	struct packet_type  fcoe_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
 
diff --git a/drivers/scsi/ofc/fcoe/fcoe_if.c b/drivers/scsi/ofc/fcoe/fcoe_if.c
index 74e5ffc..9963593 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_if.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_if.c
@@ -34,6 +34,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 #include <net/rtnetlink.h>
 
 /*
@@ -174,6 +175,7 @@ int fcoe_link_ok(struct fcdev *fdev)
 	int rc = 0;
 
 	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev)) {
+		dev = fc->phys_dev;
 		dev->ethtool_ops->get_pauseparam(dev, &pause);
 		if (dev->ethtool_ops->get_settings) {
 			dev->ethtool_ops->get_settings(dev, &ecmd);
@@ -213,6 +215,7 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	struct fcoe_cfg *cfg = ptr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *p;
+	struct net_device *net_dev;
 	int rc = 0;
 	int i;
 #ifdef HAVE_SET_RX_MODE
@@ -260,11 +263,14 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	/*
 	 * Require support for get_pauseparam ethtool op.
 	 */
-	if (!fc->real_dev->ethtool_ops ||
-	    !fc->real_dev->ethtool_ops->get_pauseparam) {
+	net_dev = fc->real_dev;
+	if (!net_dev->ethtool_ops && (net_dev->priv_flags & IFF_802_1Q_VLAN))
+		net_dev = VLAN_DEV_INFO(net_dev)->real_dev;
+	if (!net_dev->ethtool_ops || !net_dev->ethtool_ops->get_pauseparam) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
+	fc->phys_dev = net_dev;
 	fdev->fd_link_status = TRANS_LINK_DOWN;
 	if (fcoe_link_ok(fdev))
 		fdev->fd_link_status = TRANS_LINK_UP;

