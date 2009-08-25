From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 56/64] libfc: correctly handle incoming PLOGI request.
Date: Tue, 25 Aug 2009 14:03:26 -0700
Message-ID: <20090825210326.1553.56939.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbZHYVDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:24 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

libfc receives PLOGIs from switches which are trying to discover what
kind of devices are present, and from other initiators to find out
if we're a target.

As an initiator, some argue we don't need to handle incoming PLOGI
requests, and we currently reject them from unknown remote ports,
but accept them is we're in the middle of a PLOGI to the remote port.

For eventual target implementations, we want to handle them always.

For incoming PLOGI, don't fail if the rport_priv doesn't exist.
Just create it and go become READY without going through PRLI.  If
PRLI occurs, then our roles will be set and we'll become READY again.

Also, allow incoming PRLI in RTV state.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |  185 +++++++++++++++++++++--------------------
 1 files changed, 93 insertions(+), 92 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d014b28..e121ff9 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -63,7 +63,7 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *);
 static void fc_rport_enter_ready(struct fc_rport_priv *);
 static void fc_rport_enter_logo(struct fc_rport_priv *);
 
-static void fc_rport_recv_plogi_req(struct fc_rport_priv *,
+static void fc_rport_recv_plogi_req(struct fc_lport *,
 				    struct fc_seq *, struct fc_frame *);
 static void fc_rport_recv_prli_req(struct fc_rport_priv *,
 				   struct fc_seq *, struct fc_frame *);
@@ -576,15 +576,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			csp_seq = cssp_seq;
 		rdata->max_seq = csp_seq;
 		rdata->maxframe_size = fc_plogi_get_maxframe(plp, lport->mfs);
-
-		/*
-		 * If the rport is one of the well known addresses
-		 * we skip PRLI and RTV and go straight to READY.
-		 */
-		if (rdata->ids.port_id >= FC_FID_DOM_MGR)
-			fc_rport_enter_ready(rdata);
-		else
-			fc_rport_enter_prli(rdata);
+		fc_rport_enter_prli(rdata);
 	} else
 		fc_rport_error_retry(rdata, fp);
 
@@ -763,6 +755,15 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 	} *pp;
 	struct fc_frame *fp;
 
+	/*
+	 * If the rport is one of the well known addresses
+	 * we skip PRLI and RTV and go straight to READY.
+	 */
+	if (rdata->ids.port_id >= FC_FID_DOM_MGR) {
+		fc_rport_enter_ready(rdata);
+		return;
+	}
+
 	FC_RPORT_DBG(rdata, "Port entered PRLI state from %s state\n",
 		     fc_rport_state(rdata));
 
@@ -929,6 +930,15 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	els_data.explan = ELS_EXPL_NONE;
 	els_data.reason = ELS_RJT_NONE;
 
+	op = fc_frame_payload_op(fp);
+	switch (op) {
+	case ELS_PLOGI:
+		fc_rport_recv_plogi_req(lport, sp, fp);
+		return;
+	default:
+		break;
+	}
+
 	fh = fc_frame_header_get(fp);
 	s_id = ntoh24(fh->fh_s_id);
 
@@ -944,11 +954,7 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	mutex_lock(&rdata->rp_mutex);
 	mutex_unlock(&lport->disc.disc_mutex);
 
-	op = fc_frame_payload_op(fp);
 	switch (op) {
-	case ELS_PLOGI:
-		fc_rport_recv_plogi_req(rdata, sp, fp);
-		break;
 	case ELS_PRLI:
 		fc_rport_recv_prli_req(rdata, sp, fp);
 		break;
@@ -977,48 +983,56 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 
 /**
  * fc_rport_recv_plogi_req() - Handle incoming Port Login (PLOGI) request
- * @rdata: private remote port data
+ * @lport: local port
  * @sp: current sequence in the PLOGI exchange
  * @fp: PLOGI request frame
  *
- * Locking Note: The rport lock is exected to be held before calling
- * this function.
+ * Locking Note: The rport lock is held before calling this function.
  */
-static void fc_rport_recv_plogi_req(struct fc_rport_priv *rdata,
+static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 				    struct fc_seq *sp, struct fc_frame *rx_fp)
 {
-	struct fc_lport *lport = rdata->local_port;
+	struct fc_disc *disc;
+	struct fc_rport_priv *rdata;
 	struct fc_frame *fp = rx_fp;
 	struct fc_exch *ep;
 	struct fc_frame_header *fh;
 	struct fc_els_flogi *pl;
 	struct fc_seq_els_data rjt_data;
-	u32 sid;
-	u64 wwpn;
-	u64 wwnn;
-	enum fc_els_rjt_reason reject = 0;
-	u32 f_ctl;
-	rjt_data.fp = NULL;
+	u32 sid, f_ctl;
 
+	rjt_data.fp = NULL;
 	fh = fc_frame_header_get(fp);
+	sid = ntoh24(fh->fh_s_id);
 
-	FC_RPORT_DBG(rdata, "Received PLOGI request while in state %s\n",
-		     fc_rport_state(rdata));
+	FC_RPORT_ID_DBG(lport, sid, "Received PLOGI request\n");
 
-	sid = ntoh24(fh->fh_s_id);
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
-		FC_RPORT_DBG(rdata, "Received PLOGI too short\n");
-		WARN_ON(1);
-		/* XXX TBD: send reject? */
-		fc_frame_free(fp);
-		return;
+		FC_RPORT_ID_DBG(lport, sid, "Received PLOGI too short\n");
+		rjt_data.reason = ELS_RJT_PROT;
+		rjt_data.explan = ELS_EXPL_INV_LEN;
+		goto reject;
+	}
+
+	disc = &lport->disc;
+	mutex_lock(&disc->disc_mutex);
+	rdata = lport->tt.rport_create(lport, sid);
+	if (!rdata) {
+		mutex_unlock(&disc->disc_mutex);
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
+		goto reject;
 	}
-	wwpn = get_unaligned_be64(&pl->fl_wwpn);
-	wwnn = get_unaligned_be64(&pl->fl_wwnn);
+
+	mutex_lock(&rdata->rp_mutex);
+	mutex_unlock(&disc->disc_mutex);
+
+	rdata->ids.port_name = get_unaligned_be64(&pl->fl_wwpn);
+	rdata->ids.node_name = get_unaligned_be64(&pl->fl_wwnn);
 
 	/*
-	 * If the session was just created, possibly due to the incoming PLOGI,
+	 * If the rport was just created, possibly due to the incoming PLOGI,
 	 * set the state appropriately and accept the PLOGI.
 	 *
 	 * If we had also sent a PLOGI, and if the received PLOGI is from a
@@ -1030,72 +1044,58 @@ static void fc_rport_recv_plogi_req(struct fc_rport_priv *rdata,
 	 */
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
-		FC_RPORT_DBG(rdata, "Received PLOGI, wwpn %llx state INIT "
-			     "- reject\n", (unsigned long long)wwpn);
-		reject = ELS_RJT_UNSUP;
+		FC_RPORT_DBG(rdata, "Received PLOGI in INIT state\n");
 		break;
 	case RPORT_ST_PLOGI:
-		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state %d\n",
-			     rdata->rp_state);
-		if (wwpn < lport->wwpn)
-			reject = ELS_RJT_INPROG;
+		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state\n");
+		if (rdata->ids.port_name < lport->wwpn) {
+			mutex_unlock(&rdata->rp_mutex);
+			rjt_data.reason = ELS_RJT_INPROG;
+			rjt_data.explan = ELS_EXPL_NONE;
+			goto reject;
+		}
 		break;
 	case RPORT_ST_PRLI:
 	case RPORT_ST_READY:
-		FC_RPORT_DBG(rdata, "Received PLOGI in logged-in state %d "
-			     "- ignored for now\n", rdata->rp_state);
-		/* XXX TBD - should reset */
 		break;
 	case RPORT_ST_DELETE:
 	default:
-		FC_RPORT_DBG(rdata, "Received PLOGI in unexpected "
-			     "state %d\n", rdata->rp_state);
-		fc_frame_free(fp);
-		return;
-		break;
+		FC_RPORT_DBG(rdata, "Received PLOGI in unexpected state %d\n",
+			     rdata->rp_state);
+		fc_frame_free(rx_fp);
+		goto out;
 	}
 
-	if (reject) {
-		rjt_data.reason = reject;
-		rjt_data.explan = ELS_EXPL_NONE;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
-		fc_frame_free(fp);
-	} else {
-		fp = fc_frame_alloc(lport, sizeof(*pl));
-		if (fp == NULL) {
-			fp = rx_fp;
-			rjt_data.reason = ELS_RJT_UNAB;
-			rjt_data.explan = ELS_EXPL_NONE;
-			lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
-			fc_frame_free(fp);
-		} else {
-			sp = lport->tt.seq_start_next(sp);
-			WARN_ON(!sp);
-			rdata->ids.port_name = wwpn;
-			rdata->ids.node_name = wwnn;
-
-			/*
-			 * Get session payload size from incoming PLOGI.
-			 */
-			rdata->maxframe_size =
-				fc_plogi_get_maxframe(pl, lport->mfs);
-			fc_frame_free(rx_fp);
-			fc_plogi_fill(lport, fp, ELS_LS_ACC);
-
-			/*
-			 * Send LS_ACC.	 If this fails,
-			 * the originator should retry.
-			 */
-			f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
-			f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-			ep = fc_seq_exch(sp);
-			fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-				       FC_TYPE_ELS, f_ctl, 0);
-			lport->tt.seq_send(lport, sp, fp);
-			if (rdata->rp_state == RPORT_ST_PLOGI)
-				fc_rport_enter_prli(rdata);
-		}
-	}
+	/*
+	 * Get session payload size from incoming PLOGI.
+	 */
+	rdata->maxframe_size = fc_plogi_get_maxframe(pl, lport->mfs);
+	fc_frame_free(rx_fp);
+
+	/*
+	 * Send LS_ACC.	 If this fails, the originator should retry.
+	 */
+	sp = lport->tt.seq_start_next(sp);
+	if (!sp)
+		goto out;
+	fp = fc_frame_alloc(lport, sizeof(*pl));
+	if (!fp)
+		goto out;
+
+	fc_plogi_fill(lport, fp, ELS_LS_ACC);
+	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+	ep = fc_seq_exch(sp);
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+		       FC_TYPE_ELS, f_ctl, 0);
+	lport->tt.seq_send(lport, sp, fp);
+	fc_rport_enter_prli(rdata);
+out:
+	mutex_unlock(&rdata->rp_mutex);
+	return;
+
+reject:
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	fc_frame_free(fp);
 }
 
 /**
@@ -1138,6 +1138,7 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PRLI:
+	case RPORT_ST_RTV:
 	case RPORT_ST_READY:
 		reason = ELS_RJT_NONE;
 		break;

