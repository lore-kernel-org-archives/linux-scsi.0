From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/8] fcoe: reduces lock cost when adding a new skb to
	fcoe_pending_queue
Date: Wed, 06 May 2009 10:52:34 -0700
Message-ID: <20090506175234.26695.38431.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33710 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZEFRwg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:36 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently fcoe_pending_queue.lock held twice for every new skb
adding to this queue when already least one pkt is pending in this
queue and that is not uncommon once skb pkts starts getting queued
here upon fcoe_start_io => dev_queue_xmit failure.

This patch moves most fcoe_pending_queue logic to fcoe_check_wait_queue
function, this new logic grabs fcoe_pending_queue.lock only once to
add a new skb instead twice as used to be.

I think after this patch call flow around fcoe_check_wait_queue
calling in fcoe_xmit is bit simplified with modified
fcoe_check_wait_queue function taking care of adding and
removing pending skb in one function.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 03e1926..7d44a49 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -71,7 +71,7 @@ static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
 static int fcoe_hostlist_add(const struct fc_lport *);
 static int fcoe_hostlist_remove(const struct fc_lport *);
 
-static int fcoe_check_wait_queue(struct fc_lport *);
+static void fcoe_check_wait_queue(struct fc_lport *, struct sk_buff *);
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
 static void fcoe_dev_setup(void);
 static void fcoe_dev_cleanup(void);
@@ -988,7 +988,7 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
  */
 int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 {
-	int wlen, rc = 0;
+	int wlen;
 	u32 crc;
 	struct ethhdr *eh;
 	struct fcoe_crc_eof *cp;
@@ -1107,18 +1107,9 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	/* send down to lld */
 	fr_dev(fp) = lp;
 	if (fc->fcoe_pending_queue.qlen)
-		rc = fcoe_check_wait_queue(lp);
-
-	if (rc == 0)
-		rc = fcoe_start_io(skb);
-
-	if (rc) {
-		spin_lock_bh(&fc->fcoe_pending_queue.lock);
-		__skb_queue_tail(&fc->fcoe_pending_queue, skb);
-		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-		if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-			lp->qfull = 1;
-	}
+		fcoe_check_wait_queue(lp, skb);
+	else if (fcoe_start_io(skb))
+		fcoe_check_wait_queue(lp, skb);
 
 	return 0;
 }
@@ -1284,7 +1275,7 @@ void fcoe_watchdog(ulong vp)
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
 		if (fc->ctlr.lp)
-			fcoe_check_wait_queue(fc->ctlr.lp);
+			fcoe_check_wait_queue(fc->ctlr.lp, NULL);
 	}
 	read_unlock(&fcoe_hostlist_lock);
 
@@ -1305,16 +1296,17 @@ void fcoe_watchdog(ulong vp)
  * The wait_queue is used when the skb transmit fails. skb will go
  * in the wait_queue which will be emptied by the timer function or
  * by the next skb transmit.
- *
- * Returns: 0 for success
  */
-static int fcoe_check_wait_queue(struct fc_lport *lp)
+static void fcoe_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb)
 {
 	struct fcoe_softc *fc = lport_priv(lp);
-	struct sk_buff *skb;
-	int rc = -1;
+	int rc;
 
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
+
+	if (skb)
+		__skb_queue_tail(&fc->fcoe_pending_queue, skb);
+
 	if (fc->fcoe_pending_queue_active)
 		goto out;
 	fc->fcoe_pending_queue_active = 1;
@@ -1341,10 +1333,11 @@ static int fcoe_check_wait_queue(struct fc_lport *lp)
 	if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
 		lp->qfull = 0;
 	fc->fcoe_pending_queue_active = 0;
-	rc = fc->fcoe_pending_queue.qlen;
 out:
+	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
+		lp->qfull = 1;
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-	return rc;
+	return;
 }
 
 /**

