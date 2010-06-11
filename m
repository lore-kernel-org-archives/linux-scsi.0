From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/17] libfcoe: fix lenient aging of FCF advertisements
Date: Fri, 11 Jun 2010 16:44:10 -0700
Message-ID: <20100611234410.4616.37384.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0FKXoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:11 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

[This patch has several improvements to the code in
the fip timers.  It hasn't been tested yet.
I'm sending it out for review.  Vasu, perhaps you can
merge this with your patch and test it together.]

The current code allows an advertisement to be used
even if it has been 3 times the FCF keep-alive
advertisement period (FKA) since one was received from
that FCF.  The spec. calls for 2.5 times FKA.

Fix this and make sure we detect missed keep-alives promptly.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   76 ++++++++++++++++++++++++-------------------
 1 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 1d5b949..3ab3db3 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -557,38 +557,44 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  *
  * Called with lock held and preemption disabled.
  *
- * An FCF is considered old if we have missed three advertisements.
- * That is, there have been no valid advertisement from it for three
- * times its keep-alive period including fuzz.
+ * An FCF is considered old if we have missed two advertisements.
+ * That is, there have been no valid advertisement from it for 2.5
+ * times its keep-alive period.
  *
  * In addition, determine the time when an FCF selection can occur.
  *
  * Also, increment the MissDiscAdvCount when no advertisement is received
  * for the corresponding FCF for 1.5 * FKA_ADV_PERIOD (FC-BB-5 LESB).
+ *
+ * Returns the time in jiffies for the next call.
  */
-static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
+static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
+	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
+	unsigned long deadline;
 	unsigned long sel_time = 0;
-	unsigned long mda_time = 0;
 	struct fcoe_dev_stats *stats;
 
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
-		mda_time = fcf->fka_period + (fcf->fka_period >> 1);
-		if ((fip->sel_fcf == fcf) &&
-		    (time_after(jiffies, fcf->time + mda_time))) {
-			mod_timer(&fip->timer, jiffies + mda_time);
-			stats = per_cpu_ptr(fip->lp->dev_stats,
-					    smp_processor_id());
-			stats->MissDiscAdvCount++;
-			printk(KERN_INFO "libfcoe: host%d: Missing Discovery "
-			       "Advertisement for fab %16.16llx count %lld\n",
-			       fip->lp->host->host_no, fcf->fabric_name,
-			       stats->MissDiscAdvCount);
+		deadline = fcf->time + fcf->fka_period + fcf->fka_period / 2;
+		if (fip->sel_fcf == fcf) {
+			if (time_after(jiffies, deadline)) {
+				stats = per_cpu_ptr(fip->lp->dev_stats,
+						    smp_processor_id());
+				stats->MissDiscAdvCount++;
+				printk(KERN_INFO "libfcoe: host%d: "
+				       "Missing Discovery Advertisement "
+				       "for fab %16.16llx count %lld\n",
+				       fip->lp->host->host_no, fcf->fabric_name,
+				       stats->MissDiscAdvCount);
+			} else if (time_after(next_timer, deadline))
+				next_timer = deadline;
 		}
-		if (time_after(jiffies, fcf->time + fcf->fka_period * 3 +
-			       msecs_to_jiffies(FIP_FCF_FUZZ * 3))) {
+
+		deadline += fcf->fka_period;
+		if (time_after(jiffies, deadline)) {
 			if (fip->sel_fcf == fcf)
 				fip->sel_fcf = NULL;
 			list_del(&fcf->list);
@@ -598,19 +604,21 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 			stats = per_cpu_ptr(fip->lp->dev_stats,
 					    smp_processor_id());
 			stats->VLinkFailureCount++;
-		} else if (fcoe_ctlr_mtu_valid(fcf) &&
-			   (!sel_time || time_before(sel_time, fcf->time))) {
-			sel_time = fcf->time;
+		} else {
+			if (time_after(next_timer, deadline))
+				next_timer = deadline;
+			if (fcoe_ctlr_mtu_valid(fcf) &&
+			    (!sel_time || time_before(sel_time, fcf->time)))
+				sel_time = fcf->time;
 		}
 	}
 	if (sel_time) {
 		sel_time += msecs_to_jiffies(FCOE_CTLR_START_DELAY);
 		fip->sel_time = sel_time;
-		if (time_before(sel_time, fip->timer.expires))
-			mod_timer(&fip->timer, sel_time);
 	} else {
 		fip->sel_time = 0;
 	}
+	return next_timer;
 }
 
 /**
@@ -1148,7 +1156,7 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 	struct fcoe_ctlr *fip = (struct fcoe_ctlr *)arg;
 	struct fcoe_fcf *sel;
 	struct fcoe_fcf *fcf;
-	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
+	unsigned long next_timer;
 
 	spin_lock_bh(&fip->lock);
 	if (fip->state == FIP_ST_DISABLED) {
@@ -1157,13 +1165,16 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 	}
 
 	fcf = fip->sel_fcf;
-	fcoe_ctlr_age_fcfs(fip);
+	next_timer = fcoe_ctlr_age_fcfs(fip);
 
 	sel = fip->sel_fcf;
-	if (!sel && fip->sel_time && time_after_eq(jiffies, fip->sel_time)) {
-		fcoe_ctlr_select(fip);
-		sel = fip->sel_fcf;
-		fip->sel_time = 0;
+	if (!sel && fip->sel_time) {
+		if (time_after_eq(jiffies, fip->sel_time)) {
+			fcoe_ctlr_select(fip);
+			sel = fip->sel_fcf;
+			fip->sel_time = 0;
+		} else if (time_after(next_timer, fip->sel_time))
+			next_timer = fip->sel_time;
 	}
 
 	if (sel != fcf) {
@@ -1201,12 +1212,9 @@ static void fcoe_ctlr_timeout(unsigned long arg)
 		}
 		if (time_after(next_timer, fip->port_ka_time))
 			next_timer = fip->port_ka_time;
-		mod_timer(&fip->timer, next_timer);
-	} else if (fip->sel_time) {
-		next_timer = fip->sel_time +
-			msecs_to_jiffies(FCOE_CTLR_START_DELAY);
-		mod_timer(&fip->timer, next_timer);
 	}
+	if (!list_empty(&fip->fcfs))
+		mod_timer(&fip->timer, next_timer);
 	if (fip->send_ctlr_ka || fip->send_port_ka)
 		schedule_work(&fip->timer_work);
 	spin_unlock_bh(&fip->lock);

