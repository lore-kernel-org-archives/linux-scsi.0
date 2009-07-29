From: Robert Love <robert.w.love@intel.com>
Subject: [2.6.31-rc PATCH] libfc: fix a circular locking warning during
	sending RRQ
Date: Tue, 28 Jul 2009 17:33:37 -0700
Message-ID: <20090729003337.32137.98812.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZG2Adh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 20:33:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently the fc_exch_rrq is called with fc_exch's ex_lock held.
The fc_exch_rrq allocates new exch and that requires taking
ex_lock again after EM lock. This locking order causes warning,
see more details on this warning at :-

 http://www.open-fcoe.org/pipermail/devel/2009-July/003251.html

This patch fixes this by dropping the ex_lock before calling
fc_exch_rrq().

The fc_exch_rrq needs to grab ex_lock lock again to schedule
RRQ retry and in the meanwhile fc_exch_reset could occur before
ex_lock is grabbed inside fc_exch_rrq. So to handle this case,
this patch adds additional check to detect fc_exch_reset after
ex_lock acquired and in case the fc_exch_reset occurred then
abandons the RRQ retry and releases the exch.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 2bc22be..145ab9b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -415,9 +415,9 @@ static void fc_exch_timeout(struct work_struct *work)
 	e_stat = ep->esb_stat;
 	if (e_stat & ESB_ST_COMPLETE) {
 		ep->esb_stat = e_stat & ~ESB_ST_REC_QUAL;
+		spin_unlock_bh(&ep->ex_lock);
 		if (e_stat & ESB_ST_REC_QUAL)
 			fc_exch_rrq(ep);
-		spin_unlock_bh(&ep->ex_lock);
 		goto done;
 	} else {
 		resp = ep->resp;
@@ -1624,14 +1624,14 @@ static void fc_exch_rrq(struct fc_exch *ep)
 	struct fc_lport *lp;
 	struct fc_els_rrq *rrq;
 	struct fc_frame *fp;
-	struct fc_seq *rrq_sp;
 	u32 did;
 
 	lp = ep->lp;
 
 	fp = fc_frame_alloc(lp, sizeof(*rrq));
 	if (!fp)
-		return;
+		goto retry;
+
 	rrq = fc_frame_payload_get(fp, sizeof(*rrq));
 	memset(rrq, 0, sizeof(*rrq));
 	rrq->rrq_cmd = ELS_RRQ;
@@ -1647,13 +1647,20 @@ static void fc_exch_rrq(struct fc_exch *ep)
 		       fc_host_port_id(lp->host), FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
-	rrq_sp = fc_exch_seq_send(lp, fp, fc_exch_rrq_resp, NULL, ep,
-				  lp->e_d_tov);
-	if (!rrq_sp) {
-		ep->esb_stat |= ESB_ST_REC_QUAL;
-		fc_exch_timer_set_locked(ep, ep->r_a_tov);
+	if (fc_exch_seq_send(lp, fp, fc_exch_rrq_resp, NULL, ep, lp->e_d_tov))
+		return;
+
+retry:
+	spin_lock_bh(&ep->ex_lock);
+	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE)) {
+		spin_unlock_bh(&ep->ex_lock);
+		/* drop hold for rec qual */
+		fc_exch_release(ep);
 		return;
 	}
+	ep->esb_stat |= ESB_ST_REC_QUAL;
+	fc_exch_timer_set_locked(ep, ep->r_a_tov);
+	spin_unlock_bh(&ep->ex_lock);
 }
 
 

