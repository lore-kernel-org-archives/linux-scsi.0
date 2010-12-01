From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 26/27] libfcoe: change fip_select to return new FCF
Date: Tue, 30 Nov 2010 16:20:12 -0800
Message-ID: <20101201002012.18369.44411.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5799 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0LAAUS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:20:18 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Neaten several calls to fip_select() by having it return the
pointer to the new FCF.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 1a0bb23..625c6be 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -55,7 +55,6 @@ static void fcoe_ctlr_timeout(unsigned long);
 static void fcoe_ctlr_timer_work(struct work_struct *);
 static void fcoe_ctlr_recv_work(struct work_struct *);
 static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *);
-static void fcoe_ctlr_select(struct fcoe_ctlr *);
 
 static void fcoe_ctlr_vn_start(struct fcoe_ctlr *);
 static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *, struct sk_buff *);
@@ -1398,6 +1397,8 @@ drop:
  * fcoe_ctlr_select() - Select the best FCF (if possible)
  * @fip: The FCoE controller
  *
+ * Returns the selected FCF, or NULL if none are usable.
+ *
  * If there are conflicting advertisements, no FCF can be chosen.
  *
  * If there is already a selected FCF, this will choose a better one or
@@ -1405,7 +1406,7 @@ drop:
  *
  * Called with lock held.
  */
-static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
+static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *best = fip->sel_fcf;
@@ -1450,6 +1451,7 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 		if (time_before(fip->ctlr_ka_time, fip->timer.expires))
 			mod_timer(&fip->timer, fip->ctlr_ka_time);
 	}
+	return best;
 }
 
 /**
@@ -1507,8 +1509,7 @@ static int fcoe_ctlr_flogi_retry(struct fcoe_ctlr *fip)
 	mutex_lock(&fip->ctlr_mutex);
 	spin_lock_bh(&fip->ctlr_lock);
 	LIBFCOE_FIP_DBG(fip, "re-sending FLOGI - reselect\n");
-	fcoe_ctlr_select(fip);
-	fcf = fip->sel_fcf;
+	fcf = fcoe_ctlr_select(fip);
 	if (!fcf || fcf->flogi_sent) {
 		kfree_skb(fip->flogi_req);
 		fip->flogi_req = NULL;
@@ -1548,14 +1549,12 @@ static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
 	 */
 	if (fcf->flogi_sent) {
 		LIBFCOE_FIP_DBG(fip, "sending FLOGI - reselect\n");
-		fcoe_ctlr_select(fip);
-		fcf = fip->sel_fcf;
+		fcf = fcoe_ctlr_select(fip);
 		if (!fcf || fcf->flogi_sent) {
 			LIBFCOE_FIP_DBG(fip, "sending FLOGI - clearing\n");
 			list_for_each_entry(fcf, &fip->fcfs, list)
 				fcf->flogi_sent = 0;
-			fcoe_ctlr_select(fip);
-			fcf = fip->sel_fcf;
+			fcf = fcoe_ctlr_select(fip);
 		}
 	}
 	if (fcf) {
@@ -1612,8 +1611,7 @@ static void fcoe_ctlr_timer_work(struct work_struct *work)
 	sel = fip->sel_fcf;
 	if (!sel && fip->sel_time) {
 		if (time_after_eq(jiffies, fip->sel_time)) {
-			fcoe_ctlr_select(fip);
-			sel = fip->sel_fcf;
+			sel = fcoe_ctlr_select(fip);
 			fip->sel_time = 0;
 		} else if (time_after(next_timer, fip->sel_time))
 			next_timer = fip->sel_time;

