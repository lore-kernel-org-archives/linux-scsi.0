From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 23/24] fcoe: fix handling of pending queue,
	prevent out of order frames (v3)
Date: Fri, 27 Feb 2009 10:56:32 -0800
Message-ID: <20090227185632.25509.38768.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64381 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbZB0S4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:34 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Chris Leech <christopher.leech@intel.com>

In fcoe_check_wait_queue() the queue length could temporarily drop to 0,
before the last frame was successfully sent.  This resulted in out of order
data frames within a single sequence, leading to IO timeout errors.

This builds on the approach from Vasu Dev to only fix the queue management in
fcoe_check_wait_queue, where my first patch added locking to the transmit
path even when the pending queue was not in use.

This patch continues to use fcoe_pending_queue.qlen instead of introducing a
new length counter, but takes precautions to ensure it never drops to 0 before
the final frame in the queue has successfully been passed to the netdev qdisc
layer.  It also includes some cleanup of fcoe_check_wait_queue and removes the
fcoe_insert_wait_queue(_head) wrapper functions.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   81 +++++++++++++------------------------------
 1 files changed, 24 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 14dd8a0..0e0b494 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -70,8 +70,6 @@ struct fcoe_percpu_s *fcoe_percpu[NR_CPUS];
 
 /* Function Prototyes */
 static int fcoe_check_wait_queue(struct fc_lport *);
-static void fcoe_insert_wait_queue_head(struct fc_lport *, struct sk_buff *);
-static void fcoe_insert_wait_queue(struct fc_lport *, struct sk_buff *);
 static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
 #ifdef CONFIG_HOTPLUG_CPU
 static int fcoe_cpu_callback(struct notifier_block *, ulong, void *);
@@ -501,7 +499,9 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		rc = fcoe_start_io(skb);
 
 	if (rc) {
-		fcoe_insert_wait_queue(lp, skb);
+		spin_lock_bh(&fc->fcoe_pending_queue.lock);
+		__skb_queue_tail(&fc->fcoe_pending_queue, skb);
+		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
 		if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
 			lp->qfull = 1;
 	}
@@ -756,33 +756,36 @@ void fcoe_watchdog(ulong vp)
  */
 static int fcoe_check_wait_queue(struct fc_lport *lp)
 {
+	struct fcoe_softc *fc = lport_priv(lp);
 	struct sk_buff *skb;
-	struct fcoe_softc *fc;
 	int rc = -1;
 
-	fc = lport_priv(lp);
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
-
 	if (fc->fcoe_pending_queue_active)
 		goto out;
 	fc->fcoe_pending_queue_active = 1;
-	if (fc->fcoe_pending_queue.qlen) {
-		while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
-			spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-			rc = fcoe_start_io(skb);
-			if (rc)
-				fcoe_insert_wait_queue_head(lp, skb);
-			spin_lock_bh(&fc->fcoe_pending_queue.lock);
-			if (rc)
-				break;
+
+	while (fc->fcoe_pending_queue.qlen) {
+		/* keep qlen > 0 until fcoe_start_io succeeds */
+		fc->fcoe_pending_queue.qlen++;
+		skb = __skb_dequeue(&fc->fcoe_pending_queue);
+
+		spin_unlock_bh(&fc->fcoe_pending_queue.lock);
+		rc = fcoe_start_io(skb);
+		spin_lock_bh(&fc->fcoe_pending_queue.lock);
+
+		if (rc) {
+			__skb_queue_head(&fc->fcoe_pending_queue, skb);
+			/* undo temporary increment above */
+			fc->fcoe_pending_queue.qlen--;
+			break;
 		}
-		/*
-		 * if interface pending queue is below FCOE_LOW_QUEUE_DEPTH
-		 * then clear qfull flag.
-		 */
-		if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
-			lp->qfull = 0;
+		/* undo temporary increment above */
+		fc->fcoe_pending_queue.qlen--;
 	}
+
+	if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
+		lp->qfull = 0;
 	fc->fcoe_pending_queue_active = 0;
 	rc = fc->fcoe_pending_queue.qlen;
 out:
@@ -791,42 +794,6 @@ out:
 }
 
 /**
- * fcoe_insert_wait_queue_head() - puts skb to fcoe pending queue head
- * @lp: the fc_port for this skb
- * @skb: the associated skb to be xmitted
- *
- * Returns: none
- */
-static void fcoe_insert_wait_queue_head(struct fc_lport *lp,
-					struct sk_buff *skb)
-{
-	struct fcoe_softc *fc;
-
-	fc = lport_priv(lp);
-	spin_lock_bh(&fc->fcoe_pending_queue.lock);
-	__skb_queue_head(&fc->fcoe_pending_queue, skb);
-	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-}
-
-/**
- * fcoe_insert_wait_queue() - put the skb into fcoe pending queue tail
- * @lp: the fc_port for this skb
- * @skb: the associated skb to be xmitted
- *
- * Returns: none
- */
-static void fcoe_insert_wait_queue(struct fc_lport *lp,
-				   struct sk_buff *skb)
-{
-	struct fcoe_softc *fc;
-
-	fc = lport_priv(lp);
-	spin_lock_bh(&fc->fcoe_pending_queue.lock);
-	__skb_queue_tail(&fc->fcoe_pending_queue, skb);
-	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-}
-
-/**
  * fcoe_dev_setup() - setup link change notification interface
  */
 static void fcoe_dev_setup()

