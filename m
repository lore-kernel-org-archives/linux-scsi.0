From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/22] fcoe: modifies fcoe_hostlist_lock uses as prep work to
	add shared offload EM
Date: Wed, 29 Jul 2009 17:05:15 -0700
Message-ID: <20090730000515.24658.72918.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6680 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbZG3AFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:15 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Modifies fcoe_hostlist_lock uses such that a new EM allocation in
fcoe_em_config and adding new fcoe_softc using fcoe_hostlist_add
are atomic, this is to ensure that a shared offload EM gets allocated
only once per eth device for its all lports.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ebf2e20..86410b9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -419,6 +419,8 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
  * fcoe_em_config() - allocates em for this lport
  * @lp: the port that em is to allocated for
  *
+ * Called with write fcoe_hostlist_lock held.
+ *
  * Returns : 0 on success
  */
 static inline int fcoe_em_config(struct fc_lport *lp)
@@ -607,6 +609,13 @@ static int fcoe_if_create(struct net_device *netdev)
 		goto out_lp_destroy;
 	}
 
+	/*
+	 * fcoe_em_alloc() and fcoe_hostlist_add() both
+	 * need to be atomic under fcoe_hostlist_lock
+	 * since fcoe_em_alloc() looks for an existing EM
+	 * instance on host list updated by fcoe_hostlist_add().
+	 */
+	write_lock(&fcoe_hostlist_lock);
 	/* lport exch manager allocation */
 	rc = fcoe_em_config(lp);
 	if (rc) {
@@ -617,6 +626,7 @@ static int fcoe_if_create(struct net_device *netdev)
 
 	/* add to lports list */
 	fcoe_hostlist_add(lp);
+	write_unlock(&fcoe_hostlist_lock);
 
 	lp->boot_time = jiffies;
 
@@ -1720,6 +1730,8 @@ int fcoe_reset(struct Scsi_Host *shost)
  * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
  * @dev: this is currently ptr to net_device
  *
+ * Called with fcoe_hostlist_lock held.
+ *
  * Returns: NULL or the located fcoe_softc
  */
 static struct fcoe_softc *
@@ -1727,14 +1739,10 @@ fcoe_hostlist_lookup_softc(const struct net_device *dev)
 {
 	struct fcoe_softc *fc;
 
-	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->real_dev == dev) {
-			read_unlock(&fcoe_hostlist_lock);
+		if (fc->real_dev == dev)
 			return fc;
-		}
 	}
-	read_unlock(&fcoe_hostlist_lock);
 	return NULL;
 }
 
@@ -1748,7 +1756,9 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 {
 	struct fcoe_softc *fc;
 
+	read_lock(&fcoe_hostlist_lock);
 	fc = fcoe_hostlist_lookup_softc(netdev);
+	read_unlock(&fcoe_hostlist_lock);
 
 	return (fc) ? fc->ctlr.lp : NULL;
 }
@@ -1757,6 +1767,8 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
  * fcoe_hostlist_add() - Add a lport to lports list
  * @lp: ptr to the fc_lport to be added
  *
+ * Called with write fcoe_hostlist_lock held.
+ *
  * Returns: 0 for success
  */
 int fcoe_hostlist_add(const struct fc_lport *lp)
@@ -1766,9 +1778,7 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
 	if (!fc) {
 		fc = lport_priv(lp);
-		write_lock_bh(&fcoe_hostlist_lock);
 		list_add_tail(&fc->list, &fcoe_hostlist);
-		write_unlock_bh(&fcoe_hostlist_lock);
 	}
 	return 0;
 }
@@ -1783,9 +1793,9 @@ int fcoe_hostlist_remove(const struct fc_lport *lp)
 {
 	struct fcoe_softc *fc;
 
+	write_lock_bh(&fcoe_hostlist_lock);
 	fc = fcoe_hostlist_lookup_softc(fcoe_netdev(lp));
 	BUG_ON(!fc);
-	write_lock_bh(&fcoe_hostlist_lock);
 	list_del(&fc->list);
 	write_unlock_bh(&fcoe_hostlist_lock);
 

