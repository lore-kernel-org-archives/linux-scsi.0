From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 53/64] libfc: move remote port lookup for ELS requests into
	fc_rport.c.
Date: Tue, 25 Aug 2009 14:03:10 -0700
Message-ID: <20090825210310.1553.97552.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45233 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136AbZHYVDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:08 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

This moves the remote port lookup for incoming ELS requests into
fc_rport.c, in preparation for handing PLOGI and LOGO from
unknown rports.

This changes the arg to rport_recv_req from an rdata to an lport.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   30 +---------------
 drivers/scsi/libfc/fc_rport.c |   78 ++++++++++++++++++++++-------------------
 include/scsi/libfc.h          |    2 +
 3 files changed, 44 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index caf6824..d3f4e0c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -812,10 +812,6 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	void (*recv) (struct fc_seq *, struct fc_frame *, struct fc_lport *);
-	struct fc_rport_priv *rdata;
-	u32 s_id;
-	u32 d_id;
-	struct fc_seq_els_data rjt_data;
 
 	mutex_lock(&lport->lp_mutex);
 
@@ -831,7 +827,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 		/*
 		 * Check opcode.
 		 */
-		recv = NULL;
+		recv = lport->tt.rport_recv_req;
 		switch (fc_frame_payload_op(fp)) {
 		case ELS_FLOGI:
 			recv = fc_lport_recv_flogi_req;
@@ -858,29 +854,7 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 			break;
 		}
 
-		if (recv)
-			recv(sp, fp, lport);
-		else {
-			/*
-			 * Find session.
-			 * If this is a new incoming PLOGI, we won't find it.
-			 */
-			s_id = ntoh24(fh->fh_s_id);
-			d_id = ntoh24(fh->fh_d_id);
-
-			rdata = lport->tt.rport_lookup(lport, s_id);
-			if (rdata)
-				lport->tt.rport_recv_req(sp, fp, rdata);
-			else {
-				rjt_data.fp = NULL;
-				rjt_data.reason = ELS_RJT_UNAB;
-				rjt_data.explan = ELS_EXPL_NONE;
-				lport->tt.seq_els_rsp_send(sp,
-							   ELS_LS_RJT,
-							   &rjt_data);
-				fc_frame_free(fp);
-			}
-		}
+		recv(sp, fp, lport);
 	} else {
 		FC_LPORT_DBG(lport, "dropping invalid frame (eof %x)\n",
 			     fr_eof(fp));
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index cb54115..acdc72d 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -912,57 +912,61 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
  * fc_rport_recv_req() - Receive a request from a rport
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
- * @rdata_arg: private remote port data
+ * @lport: Fibre Channel local port
  *
- * Locking Note: Called without the rport lock held. This
- * function will hold the rport lock, call an _enter_*
- * function and then unlock the rport.
+ * Locking Note: Called with the lport lock held.
  */
 void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
-		       struct fc_rport_priv *rdata)
+		       struct fc_lport *lport)
 {
-	struct fc_lport *lport = rdata->local_port;
-
+	struct fc_rport_priv *rdata;
 	struct fc_frame_header *fh;
 	struct fc_seq_els_data els_data;
+	u32 s_id;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
-
 	els_data.fp = NULL;
 	els_data.explan = ELS_EXPL_NONE;
 	els_data.reason = ELS_RJT_NONE;
 
 	fh = fc_frame_header_get(fp);
+	s_id = ntoh24(fh->fh_s_id);
 
-	if (fh->fh_r_ctl == FC_RCTL_ELS_REQ && fh->fh_type == FC_TYPE_ELS) {
-		op = fc_frame_payload_op(fp);
-		switch (op) {
-		case ELS_PLOGI:
-			fc_rport_recv_plogi_req(rdata, sp, fp);
-			break;
-		case ELS_PRLI:
-			fc_rport_recv_prli_req(rdata, sp, fp);
-			break;
-		case ELS_PRLO:
-			fc_rport_recv_prlo_req(rdata, sp, fp);
-			break;
-		case ELS_LOGO:
-			fc_rport_recv_logo_req(rdata, sp, fp);
-			break;
-		case ELS_RRQ:
-			els_data.fp = fp;
-			lport->tt.seq_els_rsp_send(sp, ELS_RRQ, &els_data);
-			break;
-		case ELS_REC:
-			els_data.fp = fp;
-			lport->tt.seq_els_rsp_send(sp, ELS_REC, &els_data);
-			break;
-		default:
-			els_data.reason = ELS_RJT_UNSUP;
-			lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
-			break;
-		}
+	rdata = lport->tt.rport_lookup(lport, s_id);
+	if (!rdata) {
+		els_data.reason = ELS_RJT_UNAB;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+		fc_frame_free(fp);
+		return;
+	}
+	mutex_lock(&rdata->rp_mutex);
+
+	op = fc_frame_payload_op(fp);
+	switch (op) {
+	case ELS_PLOGI:
+		fc_rport_recv_plogi_req(rdata, sp, fp);
+		break;
+	case ELS_PRLI:
+		fc_rport_recv_prli_req(rdata, sp, fp);
+		break;
+	case ELS_PRLO:
+		fc_rport_recv_prlo_req(rdata, sp, fp);
+		break;
+	case ELS_LOGO:
+		fc_rport_recv_logo_req(rdata, sp, fp);
+		break;
+	case ELS_RRQ:
+		els_data.fp = fp;
+		lport->tt.seq_els_rsp_send(sp, ELS_RRQ, &els_data);
+		break;
+	case ELS_REC:
+		els_data.fp = fp;
+		lport->tt.seq_els_rsp_send(sp, ELS_REC, &els_data);
+		break;
+	default:
+		els_data.reason = ELS_RJT_UNSUP;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+		break;
 	}
 
 	mutex_unlock(&rdata->rp_mutex);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index cd410c1..265f106 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -598,7 +598,7 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	void (*rport_recv_req)(struct fc_seq *, struct fc_frame *,
-			       struct fc_rport_priv *);
+			       struct fc_lport *);
 
 	/*
 	 * lookup an rport by it's port ID.

