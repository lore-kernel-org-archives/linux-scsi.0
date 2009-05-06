From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/8] fcoe: removes fcoe_watchdog
Date: Wed, 06 May 2009 10:52:40 -0700
Message-ID: <20090506175240.26695.34712.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34266 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbZEFRwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:46 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Removes periodic fcoe_watchdog timer used across all fcoe interface
maintained in fcoe_hostlist instead added new fcoe_queue_timer
per fcoe interface.

Added timer is armed only when some pending skb need to be flushed
as oppose to periodic 1 second fcoe_watchdog, since now
fcoe_queue_timer is used on demand thus set this to 2 jiffies.

Now fcoe_queue_timer is much simple than fcoe_watchdog using lock to
process all fcoe interface from fcoe_hostlist.

I noticed +ve performance result with using 2 jiffies timer as
this helps flushing fcoe_pending_queue quickly.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   52 ++++++++++++++++------------------------------
 drivers/scsi/fcoe/fcoe.h |    1 +
 2 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 7d44a49..cf62e99 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -54,7 +54,6 @@ MODULE_LICENSE("GPL v2");
 /* fcoe host list */
 LIST_HEAD(fcoe_hostlist);
 DEFINE_RWLOCK(fcoe_hostlist_lock);
-DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
 /* Function Prototypes */
@@ -167,6 +166,18 @@ static int fcoe_lport_config(struct fc_lport *lp)
 }
 
 /**
+ * fcoe_queue_timer() - fcoe queue timer
+ * @lp: the fc_lport pointer
+ *
+ * Calls fcoe_check_wait_queue on timeout
+ *
+ */
+static void fcoe_queue_timer(ulong lp)
+{
+	fcoe_check_wait_queue((struct fc_lport *)lp, NULL);
+}
+
+/**
  * fcoe_netdev_config() - Set up netdev for SW FCoE
  * @lp : ptr to the fc_lport
  * @netdev : ptr to the associated netdevice struct
@@ -236,6 +247,7 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 	}
 	skb_queue_head_init(&fc->fcoe_pending_queue);
 	fc->fcoe_pending_queue_active = 0;
+	setup_timer(&fc->timer, fcoe_queue_timer, (unsigned long)lp);
 
 	/* setup Source Mac Address */
 	memcpy(fc->ctlr.ctl_src_addr, fc->real_dev->dev_addr,
@@ -386,6 +398,9 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	/* Free existing skbs */
 	fcoe_clean_pending_queue(lp);
 
+	/* Stop the timer */
+	del_timer_sync(&fc->timer);
+
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lp);
 
@@ -1259,32 +1274,6 @@ int fcoe_percpu_receive_thread(void *arg)
 }
 
 /**
- * fcoe_watchdog() - fcoe timer callback
- * @vp:
- *
- * This checks the pending queue length for fcoe and set lport qfull
- * if the FCOE_MAX_QUEUE_DEPTH is reached. This is done for all fc_lport on the
- * fcoe_hostlist.
- *
- * Returns: 0 for success
- */
-void fcoe_watchdog(ulong vp)
-{
-	struct fcoe_softc *fc;
-
-	read_lock(&fcoe_hostlist_lock);
-	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		if (fc->ctlr.lp)
-			fcoe_check_wait_queue(fc->ctlr.lp, NULL);
-	}
-	read_unlock(&fcoe_hostlist_lock);
-
-	fcoe_timer.expires = jiffies + (1 * HZ);
-	add_timer(&fcoe_timer);
-}
-
-
-/**
  * fcoe_check_wait_queue() - attempt to clear the transmit backlog
  * @lp: the fc_lport
  *
@@ -1332,6 +1321,8 @@ static void fcoe_check_wait_queue(struct fc_lport *lp, struct sk_buff *skb)
 
 	if (fc->fcoe_pending_queue.qlen < FCOE_LOW_QUEUE_DEPTH)
 		lp->qfull = 0;
+	if (fc->fcoe_pending_queue.qlen && !timer_pending(&fc->timer))
+		mod_timer(&fc->timer, jiffies + 2);
 	fc->fcoe_pending_queue_active = 0;
 out:
 	if (fc->fcoe_pending_queue.qlen > FCOE_MAX_QUEUE_DEPTH)
@@ -1808,10 +1799,6 @@ static int __init fcoe_init(void)
 	/* Setup link change notification */
 	fcoe_dev_setup();
 
-	setup_timer(&fcoe_timer, fcoe_watchdog, 0);
-
-	mod_timer(&fcoe_timer, jiffies + (10 * HZ));
-
 	fcoe_if_init();
 
 	return 0;
@@ -1837,9 +1824,6 @@ static void __exit fcoe_exit(void)
 
 	fcoe_dev_cleanup();
 
-	/* Stop the timer */
-	del_timer_sync(&fcoe_timer);
-
 	/* releases the associated fcoe hosts */
 	list_for_each_entry_safe(fc, tmp, &fcoe_hostlist, list)
 		fcoe_if_destroy(fc->real_dev);
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 917aae8..a1eb8c1 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -61,6 +61,7 @@ struct fcoe_softc {
 	struct packet_type  fip_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
 	u8	fcoe_pending_queue_active;
+	struct timer_list timer;		/* queue timer */
 	struct fcoe_ctlr ctlr;
 };
 

