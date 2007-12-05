From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE PATCH] Don't use netdev for FCoE if pause is not correctly
	set, even for VLANs.
Date: Tue, 04 Dec 2007 16:52:33 -0800
Message-ID: <20071205005233.26330.76264.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:54875 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751467AbXLEAwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:52:34 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 16:52:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Don't use netdev for FCoE if pause is not correctly set, even for VLANs.

This modifies the previous tests to require that the underlying net-dev
supports the ethtool get_pauseparam operation.

NICs that are 10/100/1000 must have pause autonegotiation turned on.
All NICs must have RX and TX pause on.  If not, they are treated as if
there is no link.

Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 drivers/scsi/ofc/fcoe/fcoe_def.h |    1 
 drivers/scsi/ofc/fcoe/fcoe_if.c  |   90 ++++++++++++++++++++++----------------
 drivers/scsi/ofc/fcoe/fcoeinit.c |   66 ++++++++--------------------
 3 files changed, 71 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/ofc/fcoe/fcoe_def.h b/drivers/scsi/ofc/fcoe/fcoe_def.h
index 0c71dc7..6550c73 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_def.h
+++ b/drivers/scsi/ofc/fcoe/fcoe_def.h
@@ -109,6 +109,7 @@ int		fcoe_create_interface(struct fcoe_info *, void *);
 int		fcoe_xmit(struct fcdev *, struct fc_frame *);
 int		fcoe_rcv(struct sk_buff *, struct net_device *,
 			 struct packet_type *, struct net_device *);
+int		fcoe_link_ok(struct fcdev *);
 struct fc_frame *fcoe_frame_alloc(size_t);
 void fcoe_put_dev(struct fcdev *dev);
 struct fcoe_softc *fcoe_find_fcdev(char *);
diff --git a/drivers/scsi/ofc/fcoe/fcoe_if.c b/drivers/scsi/ofc/fcoe/fcoe_if.c
index d87ede1..fd3c7a7 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_if.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_if.c
@@ -160,6 +160,48 @@ int fcoe_destroy_interface(struct fcdev *fd)
 }
 
 /*
+ * Return non-zero if link is OK for use by FCoE.
+ * Any permanently-disqualifying conditions have been previously checked.
+ * This checks pause settings, which can change with link.
+ * This also updates the speed setting, which may change with link for 100/1000.
+ */
+int fcoe_link_ok(struct fcdev *fdev)
+{
+	struct fcoe_softc *fc = (struct fcoe_softc *)fdev->drv_priv;
+	struct net_device *dev = fc->real_dev;
+	struct ethtool_pauseparam pause = { ETHTOOL_GPAUSEPARAM };
+	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
+	int rc = 0;
+
+	if ((dev->flags & IFF_UP) && netif_carrier_ok(dev)) {
+		dev->ethtool_ops->get_pauseparam(dev, &pause);
+		if (dev->ethtool_ops->get_settings) {
+			dev->ethtool_ops->get_settings(dev, &ecmd);
+			fdev->fd_speed_support &=
+			    ~(OFC_SPEED_1GBIT | OFC_SPEED_10GBIT);
+			if (ecmd.supported & (SUPPORTED_1000baseT_Half |
+					      SUPPORTED_1000baseT_Full))
+				fdev->fd_speed_support |= OFC_SPEED_1GBIT;
+			if (ecmd.supported & SUPPORTED_10000baseT_Full)
+				fdev->fd_speed_support |= OFC_SPEED_10GBIT;
+			if (ecmd.speed == SPEED_1000)
+				fdev->fd_speed = OFC_SPEED_1GBIT;
+			if (ecmd.speed == SPEED_10000)
+				fdev->fd_speed = OFC_SPEED_10GBIT;
+
+			/*
+			 * for 10 G (and faster), ignore autoneg requirement.
+			 */
+			if (ecmd.speed >= SPEED_10000)
+				pause.autoneg = 1;
+		}
+		if (pause.autoneg && pause.tx_pause && pause.rx_pause)
+			rc = 1;
+	}
+	return rc;
+}
+
+/*
  * This function creates the fcoe interface
  * create struct fcdev which is a shared structure between opefc
  * and transport level protocol.
@@ -171,8 +213,6 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	struct fcoe_cfg *cfg = ptr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *p;
-	struct ethtool_pauseparam pauseparam = { ETHTOOL_GPAUSEPARAM };
-	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 	int rc = 0;
 	int i;
 #ifdef HAVE_SET_RX_MODE
@@ -207,12 +247,6 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 		goto out;
 	}
 
-	fdev->fd_link_status = TRANS_LINK_DOWN;
-	if ((fc->real_dev->flags & IFF_UP) != 0 &&
-	    netif_carrier_ok(fc->real_dev)) {
-		fdev->fd_link_status = TRANS_LINK_UP;
-	}
-
 	/*
 	 * Do not support for bonding device
 	 */
@@ -224,38 +258,16 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	}
 
 	/*
-	 * if it is not a vlan driver then do more check */
-	if (!(fc->real_dev->priv_flags & IFF_802_1Q_VLAN)) {
-
-		if (!fc->real_dev->ethtool_ops) {
-			rc = -EOPNOTSUPP;
-			goto out;
-		}
-		if (!fc->real_dev->ethtool_ops->get_pauseparam) {
-			rc = -EOPNOTSUPP;
-			goto out;
-		}
-		fc->real_dev->ethtool_ops->get_pauseparam(fc->real_dev,
-							  &pauseparam);
-		if (!pauseparam.rx_pause || !pauseparam.tx_pause) {
-			rc = -EOPNOTSUPP;
-			goto out;
-		}
-		if (fc->real_dev->ethtool_ops->get_settings) {
-			fc->real_dev->ethtool_ops->get_settings(fc->real_dev,
-								&ecmd);
-			if (ecmd.
-			    supported & (SUPPORTED_1000baseT_Half |
-					 SUPPORTED_1000baseT_Full))
-				fdev->fd_speed_support |= OFC_SPEED_1GBIT;
-			if (ecmd.supported & SUPPORTED_10000baseT_Full)
-				fdev->fd_speed_support |= OFC_SPEED_10GBIT;
-			if (ecmd.speed == SPEED_1000)
-				fdev->fd_speed = OFC_SPEED_1GBIT;
-			if (ecmd.speed == SPEED_10000)
-				fdev->fd_speed = OFC_SPEED_10GBIT;
-		}
+	 * Require support for get_pauseparam ethtool op.
+	 */
+	if (!fc->real_dev->ethtool_ops ||
+	    !fc->real_dev->ethtool_ops->get_pauseparam) {
+		rc = -EOPNOTSUPP;
+		goto out;
 	}
+	fdev->fd_link_status = TRANS_LINK_DOWN;
+	if (fcoe_link_ok(fdev))
+		fdev->fd_link_status = TRANS_LINK_UP;
 
 	if (fc->real_dev->features & NETIF_F_SG)
 		fdev->capabilities = TRANS_C_SG;
diff --git a/drivers/scsi/ofc/fcoe/fcoeinit.c b/drivers/scsi/ofc/fcoe/fcoeinit.c
index 182a9b1..3b80946 100644
--- a/drivers/scsi/ofc/fcoe/fcoeinit.c
+++ b/drivers/scsi/ofc/fcoe/fcoeinit.c
@@ -170,7 +170,6 @@ static void fcoe_dev_cleanup(void)
  * This function is called by the ethernet driver
  * this is called in case of link change event
  */
-
 static int fcoe_device_notification(struct notifier_block *notifier,
 				    ulong event, void *ptr)
 {
@@ -179,7 +178,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	struct fcdev *fc_dev = NULL;
 	struct fcoe_dev_stats *stats;
 	struct fcoe_info *fci = &fcoei;
-	struct ethtool_pauseparam pauseparam = { ETHTOOL_GPAUSEPARAM };
+	int new_status;
 	int rc;
 
 	read_lock(&fci->fcoe_hostlist_lock);
@@ -190,67 +189,40 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		}
 	}
 	read_unlock(&fci->fcoe_hostlist_lock);
-
 	if (fc_dev == NULL) {
 		rc = NOTIFY_DONE;
 		goto out;
 	}
+	new_status = fc_dev->fd_link_status;
 	switch (event) {
 	case NETDEV_DOWN:
-		fc_dev->fd_link_status = TRANS_LINK_DOWN;
-		/* notify upper layer about link down */
-		openfc_linkdown(fc_dev);
-		stats = fc_dev->dev_stats[smp_processor_id()];
-		stats->LinkFailureCount++;
-		fcoe_clean_pending_queue(fc_dev);
-		rc = NOTIFY_OK;
+	case NETDEV_GOING_DOWN:
+		new_status = TRANS_LINK_DOWN;
 		break;
 	case NETDEV_UP:
-		fc_dev->fd_link_status = TRANS_LINK_UP;
-		/* notify upper layer about link up */
-		if (netif_carrier_ok(real_dev)) {
-			if ((real_dev->priv_flags & IFF_802_1Q_VLAN) == 0) {
-				real_dev->ethtool_ops->get_pauseparam(fc->
-								      real_dev,
-								      &pauseparam);
-				if (!pauseparam.rx_pause
-				    || !pauseparam.tx_pause) {
-					rc = NOTIFY_OK;
-					goto out;
-				}
-			}
-			openfc_linkup(fc_dev);
-		}
-		rc = NOTIFY_OK;
-		break;
 	case NETDEV_CHANGE:
-		if (netif_carrier_ok(real_dev)) {
-			if ((real_dev->priv_flags & IFF_802_1Q_VLAN) == 0) {
-				real_dev->ethtool_ops->get_pauseparam(fc->
-								      real_dev,
-								      &pauseparam);
-				if (!pauseparam.rx_pause
-				    || !pauseparam.tx_pause) {
-					rc = NOTIFY_OK;
-					goto out;
-				}
-			}
-			if (fc->real_dev->flags & IFF_UP)
-				openfc_linkup(fc_dev);
-		} else {
-			openfc_linkdown(fc_dev);
-			fcoe_clean_pending_queue(fc_dev);
-		}
-		rc = NOTIFY_OK;
+		new_status = TRANS_LINK_DOWN;
+		if (fcoe_link_ok(fc_dev))
+			new_status = TRANS_LINK_UP;
 		break;
 	case NETDEV_REGISTER:
-	case NETDEV_GOING_DOWN:
 		rc = NOTIFY_OK;
 		break;
 	default:
-		SA_LOG("unknow event %d call", event);
+		SA_LOG("unknown event %d call", event);
 		rc = NOTIFY_OK;
 	}
+	if (fc_dev->fd_link_status != new_status) {
+		fc_dev->fd_link_status = new_status;
+		if (new_status == TRANS_LINK_UP) {
+			openfc_linkup(fc_dev);
+		} else {
+			stats = fc_dev->dev_stats[smp_processor_id()];
+			stats->LinkFailureCount++;
+			openfc_linkdown(fc_dev);
+			fcoe_clean_pending_queue(fc_dev);
+		}
+	}
 out:
 	return rc;
 }


