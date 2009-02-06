From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 14/17] libfc,
	fcoe: Remove unnecessary cast by removing inline wrapper
Date: Fri, 06 Feb 2009 10:57:04 -0800
Message-ID: <20090206185704.26188.79425.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21849 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZBFS5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:57:07 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Comment from "Andrew Morton <akpm@linux-foundation.org>"

> +{
> +     return (struct fcoe_softc *)lport_priv(lp);

unneeded/undesirable cast of void*.  There are probably zillions of
instances of this - there always are.

This whole inline function was unnecessary. The FCoE layer knows
that it's data structure is stored in the lport private data, it
can just access it from lport_priv().

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe_sw.c |    2 +-
 drivers/scsi/fcoe/libfcoe.c |   12 ++++++------
 include/scsi/libfcoe.h      |    8 +-------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index b5b2abf..91bae90 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -298,7 +298,7 @@ static int fcoe_sw_destroy(struct net_device *netdev)
 	if (!lp)
 		return -ENODEV;
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 
 	/* Logout of the fabric */
 	fc_fabric_logoff(lp);
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index e76e4f6..5dae859 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -387,7 +387,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 
 	WARN_ON((fr_len(fp) % sizeof(u32)) != 0);
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 	/*
 	 * if it is a flogi then we need to learn gw-addr
 	 * and my own fcid
@@ -770,7 +770,7 @@ static int fcoe_check_wait_queue(struct fc_lport *lp)
 	struct sk_buff *skb;
 	struct fcoe_softc *fc;
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
 
 	/*
@@ -807,7 +807,7 @@ static void fcoe_insert_wait_queue_head(struct fc_lport *lp,
 {
 	struct fcoe_softc *fc;
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
 	__skb_queue_head(&fc->fcoe_pending_queue, skb);
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
@@ -825,7 +825,7 @@ static void fcoe_insert_wait_queue(struct fc_lport *lp,
 {
 	struct fcoe_softc *fc;
 
-	fc = fcoe_softc(lp);
+	fc = lport_priv(lp);
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
 	__skb_queue_tail(&fc->fcoe_pending_queue, skb);
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
@@ -1115,7 +1115,7 @@ MODULE_PARM_DESC(destroy, "Destroy fcoe port");
  */
 int fcoe_link_ok(struct fc_lport *lp)
 {
-	struct fcoe_softc *fc = fcoe_softc(lp);
+	struct fcoe_softc *fc = lport_priv(lp);
 	struct net_device *dev = fc->real_dev;
 	struct ethtool_cmd ecmd = { ETHTOOL_GSET };
 	int rc = 0;
@@ -1331,7 +1331,7 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 
 	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
 	if (!fc) {
-		fc = fcoe_softc(lp);
+		fc = lport_priv(lp);
 		write_lock_bh(&fcoe_hostlist_lock);
 		list_add_tail(&fc->list, &fcoe_hostlist);
 		write_unlock_bh(&fcoe_hostlist_lock);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 89fdbb9..f43d383 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -58,16 +58,10 @@ struct fcoe_softc {
 	u8 address_mode;
 };
 
-static inline struct fcoe_softc *fcoe_softc(
-	const struct fc_lport *lp)
-{
-	return (struct fcoe_softc *)lport_priv(lp);
-}
-
 static inline struct net_device *fcoe_netdev(
 	const struct fc_lport *lp)
 {
-	return fcoe_softc(lp)->real_dev;
+	return ((struct fcoe_softc *)lport_priv(lp))->real_dev;
 }
 
 static inline struct fcoe_hdr *skb_fcoe_header(const struct sk_buff *skb)

