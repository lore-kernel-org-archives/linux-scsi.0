From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/6] libfc: add exch timer debug info
Date: Fri, 06 Jul 2012 10:40:10 -0700
Message-ID: <20120706174010.4102.18520.stgit@fritz>
References: <20120706173959.4102.12091.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56498 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab2GFRkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jul 2012 13:40:10 -0400
In-Reply-To: <20120706173959.4102.12091.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Add exch timeout info to have debug log with exch timeout
value to match with retries, also add debug info
on exch timer cancel.

Added common fc_exch_timer_cancel() func and grouped this
along with fc_exch_timer_set() function, so that
added debug code is not repeated.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   96 +++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index aceffad..0c8a61b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -339,6 +339,52 @@ static void fc_exch_release(struct fc_exch *ep)
 }
 
 /**
+ * fc_exch_timer_cancel() - cancel exch timer
+ * @ep:		The exchange whose timer to be canceled
+ */
+static inline  void fc_exch_timer_cancel(struct fc_exch *ep)
+{
+	if (cancel_delayed_work(&ep->timeout_work)) {
+		FC_EXCH_DBG(ep, "Exchange timer canceled\n");
+		atomic_dec(&ep->ex_refcnt); /* drop hold for timer */
+	}
+}
+
+/**
+ * fc_exch_timer_set_locked() - Start a timer for an exchange w/ the
+ *				the exchange lock held
+ * @ep:		The exchange whose timer will start
+ * @timer_msec: The timeout period
+ *
+ * Used for upper level protocols to time out the exchange.
+ * The timer is cancelled when it fires or when the exchange completes.
+ */
+static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
+					    unsigned int timer_msec)
+{
+	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
+		return;
+
+	FC_EXCH_DBG(ep, "Exchange timer armed : %d msecs\n", timer_msec);
+
+	if (queue_delayed_work(fc_exch_workqueue, &ep->timeout_work,
+			       msecs_to_jiffies(timer_msec)))
+		fc_exch_hold(ep);		/* hold for timer */
+}
+
+/**
+ * fc_exch_timer_set() - Lock the exchange and set the timer
+ * @ep:		The exchange whose timer will start
+ * @timer_msec: The timeout period
+ */
+static void fc_exch_timer_set(struct fc_exch *ep, unsigned int timer_msec)
+{
+	spin_lock_bh(&ep->ex_lock);
+	fc_exch_timer_set_locked(ep, timer_msec);
+	spin_unlock_bh(&ep->ex_lock);
+}
+
+/**
  * fc_exch_done_locked() - Complete an exchange with the exchange lock held
  * @ep: The exchange that is complete
  */
@@ -359,8 +405,7 @@ static int fc_exch_done_locked(struct fc_exch *ep)
 
 	if (!(ep->esb_stat & ESB_ST_REC_QUAL)) {
 		ep->state |= FC_EX_DONE;
-		if (cancel_delayed_work(&ep->timeout_work))
-			atomic_dec(&ep->ex_refcnt); /* drop hold for timer */
+		fc_exch_timer_cancel(ep);
 		rc = 0;
 	}
 	return rc;
@@ -424,40 +469,6 @@ static void fc_exch_delete(struct fc_exch *ep)
 }
 
 /**
- * fc_exch_timer_set_locked() - Start a timer for an exchange w/ the
- *				the exchange lock held
- * @ep:		The exchange whose timer will start
- * @timer_msec: The timeout period
- *
- * Used for upper level protocols to time out the exchange.
- * The timer is cancelled when it fires or when the exchange completes.
- */
-static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
-					    unsigned int timer_msec)
-{
-	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
-		return;
-
-	FC_EXCH_DBG(ep, "Exchange timer armed\n");
-
-	if (queue_delayed_work(fc_exch_workqueue, &ep->timeout_work,
-			       msecs_to_jiffies(timer_msec)))
-		fc_exch_hold(ep);		/* hold for timer */
-}
-
-/**
- * fc_exch_timer_set() - Lock the exchange and set the timer
- * @ep:		The exchange whose timer will start
- * @timer_msec: The timeout period
- */
-static void fc_exch_timer_set(struct fc_exch *ep, unsigned int timer_msec)
-{
-	spin_lock_bh(&ep->ex_lock);
-	fc_exch_timer_set_locked(ep, timer_msec);
-	spin_unlock_bh(&ep->ex_lock);
-}
-
-/**
  * fc_seq_send() - Send a frame using existing sequence/exchange pair
  * @lport: The local port that the exchange will be sent on
  * @sp:	   The sequence to be sent
@@ -1549,8 +1560,10 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	FC_EXCH_DBG(ep, "exch: BLS rctl %x - %s\n", fh->fh_r_ctl,
 		    fc_exch_rctl_name(fh->fh_r_ctl));
 
-	if (cancel_delayed_work_sync(&ep->timeout_work))
+	if (cancel_delayed_work_sync(&ep->timeout_work)) {
+		FC_EXCH_DBG(ep, "Exchange timer canceled\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+	}
 
 	spin_lock_bh(&ep->ex_lock);
 	switch (fh->fh_r_ctl) {
@@ -1737,8 +1750,7 @@ static void fc_exch_reset(struct fc_exch *ep)
 	spin_lock_bh(&ep->ex_lock);
 	fc_exch_abort_locked(ep, 0);
 	ep->state |= FC_EX_RST_CLEANUP;
-	if (cancel_delayed_work(&ep->timeout_work))
-		atomic_dec(&ep->ex_refcnt);	/* drop hold for timer */
+	fc_exch_timer_cancel(ep);
 	resp = ep->resp;
 	ep->resp = NULL;
 	if (ep->esb_stat & ESB_ST_REC_QUAL)
@@ -2133,10 +2145,8 @@ static void fc_exch_els_rrq(struct fc_frame *fp)
 		ep->esb_stat &= ~ESB_ST_REC_QUAL;
 		atomic_dec(&ep->ex_refcnt);	/* drop hold for rec qual */
 	}
-	if (ep->esb_stat & ESB_ST_COMPLETE) {
-		if (cancel_delayed_work(&ep->timeout_work))
-			atomic_dec(&ep->ex_refcnt);	/* drop timer hold */
-	}
+	if (ep->esb_stat & ESB_ST_COMPLETE)
+		fc_exch_timer_cancel(ep);
 
 	spin_unlock_bh(&ep->ex_lock);
 

