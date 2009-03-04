From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 3/5] fcoe: libfcoe: fix FIP link logic
Date: Wed, 04 Mar 2009 10:53:52 -0800
Message-ID: <20090304185352.22010.73565.stgit@vi2.jf.intel.com>
References: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbZCDSxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 13:53:55 -0500
In-Reply-To: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Joe Eykholt <jeykholt@cisco.com>

FIP now controls whether the lport sees the link as up or not,
since the fabric connectivity not may exist even if the link is up.
So, the LLD (fcoe) should not depend on the lport->link_up info
to decide whether to report a link change to FIP.

The logic to control the link change has been moved into FIP and
under the fcoe_ctlr lock.  So that only true link changes cause
statistics increments, fcoe_ctlr_stop() returns non-zero if it
is a "true" link drop so that the LLD can increment statistics
appropriately.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---

 drivers/scsi/fcoe/libfcoe.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)


diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 42aa7d5..90d0136 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -793,7 +793,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	struct net_device *real_dev = ptr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *stats;
-	u32 new_link_up;
+	u32 link_possible = 1;
 	u32 mfs;
 	int rc = NOTIFY_OK;
 
@@ -810,15 +810,13 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		goto out;
 	}
 
-	new_link_up = lp->link_up;
 	switch (event) {
 	case NETDEV_DOWN:
 	case NETDEV_GOING_DOWN:
-		new_link_up = 0;
+		link_possible = 0;
 		break;
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
-		new_link_up = !fcoe_link_ok(lp);
 		break;
 	case NETDEV_CHANGEMTU:
 		mfs = fc->real_dev->mtu -
@@ -826,23 +824,19 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 			 sizeof(struct fcoe_crc_eof));
 		if (mfs >= FC_MIN_MAX_FRAME)
 			fc_set_mfs(lp, mfs);
-		new_link_up = !fcoe_link_ok(lp);
 		break;
 	case NETDEV_REGISTER:
 		break;
 	default:
-		FC_DBG("unknown event %ld call", event);
+		FC_DBG("Unknown event %ld from netdev netlink\n", event);
 	}
-	if (lp->link_up != new_link_up) {
-		if (new_link_up)
-			fcoe_ctlr_start(&fc->ctlr);
-		else {
-			stats = lp->dev_stats[smp_processor_id()];
-			if (stats)
-				stats->LinkFailureCount++;
-			fcoe_ctlr_stop(&fc->ctlr);
-			fcoe_clean_pending_queue(lp);
-		}
+	if (link_possible && !fcoe_link_ok(lp))
+		fcoe_ctlr_start(&fc->ctlr);
+	else if (fcoe_ctlr_stop(&fc->ctlr)) {
+		stats = lp->dev_stats[smp_processor_id()];
+		if (stats)
+			stats->LinkFailureCount++;
+		fcoe_clean_pending_queue(lp);
 	}
 out:
 	return rc;

