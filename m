From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/16] libfc: Avoid that sending after an abort triggers a
 kernel warning
Date: Thu, 05 Sep 2013 12:13:11 -0700
Message-ID: <20130905191311.15235.39902.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab3IETNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:13:12 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

Calling fc_seq_send() after an ABTS message has been received triggers
a kernel warning (WARN_ON(!(ep->esb_stat & ESB_ST_SEQ_INIT))). Avoid
this by returning -ENXIO to the caller if fc_seq_send() is invoked after
an ABTS message has been received.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   59 ++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index bc0aba4..2a7fd5a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -463,15 +463,21 @@ static void fc_exch_delete(struct fc_exch *ep)
 }
 
 static int fc_seq_send_locked(struct fc_lport *lport, struct fc_seq *sp,
-		       struct fc_frame *fp)
+			      struct fc_frame *fp)
 {
 	struct fc_exch *ep;
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
-	int error;
+	int error = -ENXIO;
 	u32 f_ctl;
 	u8 fh_type = fh->fh_type;
 
 	ep = fc_seq_exch(sp);
+
+	if (ep->esb_stat & (ESB_ST_COMPLETE | ESB_ST_ABNORMAL)) {
+		fc_frame_free(fp);
+		goto out;
+	}
+
 	WARN_ON(!(ep->esb_stat & ESB_ST_SEQ_INIT));
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
@@ -514,6 +520,9 @@ out:
  * @lport: The local port that the exchange will be sent on
  * @sp:	   The sequence to be sent
  * @fp:	   The frame to be sent on the exchange
+ *
+ * Note: The frame will be freed either by a direct call to fc_frame_free(fp)
+ * or indirectly by calling libfc_function_template.frame_send().
  */
 static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 		       struct fc_frame *fp)
@@ -621,27 +630,31 @@ static int fc_exch_abort_locked(struct fc_exch *ep,
 	if (!sp)
 		return -ENOMEM;
 
-	ep->esb_stat |= ESB_ST_SEQ_INIT | ESB_ST_ABNORMAL;
 	if (timer_msec)
 		fc_exch_timer_set_locked(ep, timer_msec);
 
-	/*
-	 * If not logged into the fabric, don't send ABTS but leave
-	 * sequence active until next timeout.
-	 */
-	if (!ep->sid)
-		return 0;
-
-	/*
-	 * Send an abort for the sequence that timed out.
-	 */
-	fp = fc_frame_alloc(ep->lp, 0);
-	if (fp) {
-		fc_fill_fc_hdr(fp, FC_RCTL_BA_ABTS, ep->did, ep->sid,
-			       FC_TYPE_BLS, FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
-		error = fc_seq_send_locked(ep->lp, sp, fp);
-	} else
-		error = -ENOBUFS;
+	if (ep->sid) {
+		/*
+		 * Send an abort for the sequence that timed out.
+		 */
+		fp = fc_frame_alloc(ep->lp, 0);
+		if (fp) {
+			ep->esb_stat |= ESB_ST_SEQ_INIT;
+			fc_fill_fc_hdr(fp, FC_RCTL_BA_ABTS, ep->did, ep->sid,
+				       FC_TYPE_BLS, FC_FC_END_SEQ |
+				       FC_FC_SEQ_INIT, 0);
+			error = fc_seq_send_locked(ep->lp, sp, fp);
+		} else {
+			error = -ENOBUFS;
+		}
+	} else {
+		/*
+		 * If not logged into the fabric, don't send ABTS but leave
+		 * sequence active until next timeout.
+		 */
+		error = 0;
+	}
+	ep->esb_stat |= ESB_ST_ABNORMAL;
 	return error;
 }
 
@@ -1299,9 +1312,10 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 		spin_unlock_bh(&ep->ex_lock);
 		goto reject;
 	}
-	if (!(ep->esb_stat & ESB_ST_REC_QUAL))
+	if (!(ep->esb_stat & ESB_ST_REC_QUAL)) {
+		ep->esb_stat |= ESB_ST_REC_QUAL;
 		fc_exch_hold(ep);		/* hold for REC_QUAL */
-	ep->esb_stat |= ESB_ST_ABNORMAL | ESB_ST_REC_QUAL;
+	}
 	fc_exch_timer_set_locked(ep, ep->r_a_tov);
 
 	fp = fc_frame_alloc(ep->lp, sizeof(*ap));
@@ -1322,6 +1336,7 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 	}
 	sp = fc_seq_start_next_locked(sp);
 	fc_seq_send_last(sp, fp, FC_RCTL_BA_ACC, FC_TYPE_BLS);
+	ep->esb_stat |= ESB_ST_ABNORMAL;
 	spin_unlock_bh(&ep->ex_lock);
 	fc_frame_free(rx_fp);
 	return;

