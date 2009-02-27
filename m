From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 22/24] fcoe: Out of order tx frames was causing several check
	condition SCSI status
Date: Fri, 27 Feb 2009 10:56:27 -0800
Message-ID: <20090227185627.25509.31518.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbZB0S43 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:29 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

frames followed by these errors in log.

	[sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
	[sdp] Sense Key : Aborted Command [current]
	[sdp] Add. Sense: Data phase error

This was causing some test apps to exit due to write failure under heavy
load.

This was due to a race around adding and removing tx frame skb in
fcoe_pending_queue, Chris Leech helped me to find that brief unlocking
period when pulling skb from fcoe_pending_queue in various contexts
(fcoe_watchdog and fcoe_xmit) and then adding skb back into fcoe_pending_queue
up on a failed fcoe_start_io could change skb/tx frame order in
fcoe_pending_queue. Thanks Chris.

This patch allows only single context to pull skb from fcoe_pending_queue
at any time to prevent above described ordering issue/race by use of
fcoe_pending_queue_active flag.

This patch simplified fcoe_watchdog with modified fcoe_check_wait_queue by
use of FCOE_LOW_QUEUE_DEPTH instead previously used several conditionals
to clear and set lp->qfull.

I think FCOE_MAX_QUEUE_DEPTH with FCOE_LOW_QUEUE_DEPTH  will work better
in re/setting lp->qfull and these could be fine tuned for performance.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe_sw.c |    1 +
 drivers/scsi/fcoe/libfcoe.c |   45 ++++++++++++++++++++-----------------------
 include/scsi/libfcoe.h      |    1 +
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index 37d359d..da210eb 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -188,6 +188,7 @@ static int fcoe_sw_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 
 
 	skb_queue_head_init(&fc->fcoe_pending_queue);
+	fc->fcoe_pending_queue_active = 0;
 
 	/* setup Source Mac Address */
 	memcpy(fc->ctl_src_addr, fc->real_dev->dev_addr,
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 7265e09..14dd8a0 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -49,6 +49,7 @@
 static int debug_fcoe;
 
 #define FCOE_MAX_QUEUE_DEPTH  256
+#define FCOE_LOW_QUEUE_DEPTH  32
 
 /* destination address mode */
 #define FCOE_GW_ADDR_MODE	    0x00
@@ -723,21 +724,12 @@ static void fcoe_recv_flogi(struct fcoe_softc *fc, struct fc_frame *fp, u8 *sa)
  */
 void fcoe_watchdog(ulong vp)
 {
-	struct fc_lport *lp;
 	struct fcoe_softc *fc;
-	int qfilled = 0;
 
 	read_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		lp = fc->lp;
-		if (lp) {
-			if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-				qfilled = 1;
-			if (fcoe_check_wait_queue(lp) <	 FCOE_MAX_QUEUE_DEPTH) {
-				if (qfilled)
-					lp->qfull = 0;
-			}
-		}
+		if (fc->lp)
+			fcoe_check_wait_queue(fc->lp);
 	}
 	read_unlock(&fcoe_hostlist_lock);
 
@@ -753,8 +745,8 @@ void fcoe_watchdog(ulong vp)
  *
  * This empties the wait_queue, dequeue the head of the wait_queue queue
  * and calls fcoe_start_io() for each packet, if all skb have been
- * transmitted, return 0 if a error occurs, then restore wait_queue and
- * try again later.
+ * transmitted, return qlen or -1 if a error occurs, then restore
+ * wait_queue and  try again later.
  *
  * The wait_queue is used when the skb transmit fails. skb will go
  * in the wait_queue which will be emptied by the time function OR
@@ -764,33 +756,38 @@ void fcoe_watchdog(ulong vp)
  */
 static int fcoe_check_wait_queue(struct fc_lport *lp)
 {
-	int rc;
 	struct sk_buff *skb;
 	struct fcoe_softc *fc;
+	int rc = -1;
 
 	fc = lport_priv(lp);
 	spin_lock_bh(&fc->fcoe_pending_queue.lock);
 
-	/*
-	 * if interface pending queue full then set qfull in lport.
-	 */
-	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
-		lp->qfull = 1;
+	if (fc->fcoe_pending_queue_active)
+		goto out;
+	fc->fcoe_pending_queue_active = 1;
 	if (fc->fcoe_pending_queue.qlen) {
 		while ((skb = __skb_dequeue(&fc->fcoe_pending_queue)) != NULL) {
 			spin_unlock_bh(&fc->fcoe_pending_queue.lock);
 			rc = fcoe_start_io(skb);
-			if (rc) {
+			if (rc)
 				fcoe_insert_wait_queue_head(lp, skb);
-				return rc;
-			}
 			spin_lock_bh(&fc->fcoe_pending_queue.lock);
+			if (rc)
+				break;
 		}
-		if (fc->fcoe_pending_queue.qlen < FCOE_MAX_QUEUE_DEPTH)
+		/*
+		 * if interface pending queue is below FCOE_LOW_QUEUE_DEPTH
+		 * then clear qfull flag.
+		 */
+		if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
 			lp->qfull = 0;
 	}
+	fc->fcoe_pending_queue_active = 0;
+	rc = fc->fcoe_pending_queue.qlen;
+out:
 	spin_unlock_bh(&fc->fcoe_pending_queue.lock);
-	return fc->fcoe_pending_queue.qlen;
+	return rc;
 }
 
 /**
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index f43d383..941818f 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -46,6 +46,7 @@ struct fcoe_softc {
 	struct net_device *phys_dev;		/* device with ethtool_ops */
 	struct packet_type  fcoe_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
+	u8	fcoe_pending_queue_active;
 
 	u8 dest_addr[ETH_ALEN];
 	u8 ctl_src_addr[ETH_ALEN];

