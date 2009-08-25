From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 57/64] libfc: fix rport error handling for login-required and
	invalid ops
Date: Tue, 25 Aug 2009 14:03:31 -0700
Message-ID: <20090825210331.1553.33189.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1813 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbZHYVD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:29 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When receiving an ELS request, if the request isn't recognized,
the unsupported operation error should be given even if the port
is not found or not logged in.

Also, the LOGO request shouldn't give the login-required explanation.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |  137 ++++++++++++++++++++++++++---------------
 1 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e121ff9..04e9846 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -69,7 +69,7 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *,
 				   struct fc_seq *, struct fc_frame *);
 static void fc_rport_recv_prlo_req(struct fc_rport_priv *,
 				   struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_logo_req(struct fc_rport_priv *,
+static void fc_rport_recv_logo_req(struct fc_lport *,
 				   struct fc_seq *, struct fc_frame *);
 static void fc_rport_timeout(struct work_struct *);
 static void fc_rport_error(struct fc_rport_priv *, struct fc_frame *);
@@ -908,62 +908,56 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 		kref_get(&rdata->kref);
 }
 
-
 /**
- * fc_rport_recv_req() - Receive a request from a rport
+ * fc_rport_recv_els_req() - handle a validated ELS request.
+ * @lport: Fibre Channel local port
  * @sp: current sequence in the PLOGI exchange
  * @fp: response frame
- * @lport: Fibre Channel local port
+ *
+ * Handle incoming ELS requests that require port login.
+ * The ELS opcode has already been validated by the caller.
  *
  * Locking Note: Called with the lport lock held.
  */
-void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
-		       struct fc_lport *lport)
+static void fc_rport_recv_els_req(struct fc_lport *lport,
+				  struct fc_seq *sp, struct fc_frame *fp)
 {
 	struct fc_rport_priv *rdata;
 	struct fc_frame_header *fh;
 	struct fc_seq_els_data els_data;
-	u32 s_id;
-	u8 op;
 
 	els_data.fp = NULL;
-	els_data.explan = ELS_EXPL_NONE;
-	els_data.reason = ELS_RJT_NONE;
-
-	op = fc_frame_payload_op(fp);
-	switch (op) {
-	case ELS_PLOGI:
-		fc_rport_recv_plogi_req(lport, sp, fp);
-		return;
-	default:
-		break;
-	}
+	els_data.reason = ELS_RJT_UNAB;
+	els_data.explan = ELS_EXPL_PLOGI_REQD;
 
 	fh = fc_frame_header_get(fp);
-	s_id = ntoh24(fh->fh_s_id);
 
 	mutex_lock(&lport->disc.disc_mutex);
-	rdata = lport->tt.rport_lookup(lport, s_id);
+	rdata = lport->tt.rport_lookup(lport, ntoh24(fh->fh_s_id));
 	if (!rdata) {
 		mutex_unlock(&lport->disc.disc_mutex);
-		els_data.reason = ELS_RJT_UNAB;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
-		fc_frame_free(fp);
-		return;
+		goto reject;
 	}
 	mutex_lock(&rdata->rp_mutex);
 	mutex_unlock(&lport->disc.disc_mutex);
 
-	switch (op) {
+	switch (rdata->rp_state) {
+	case RPORT_ST_PRLI:
+	case RPORT_ST_RTV:
+	case RPORT_ST_READY:
+		break;
+	default:
+		mutex_unlock(&rdata->rp_mutex);
+		goto reject;
+	}
+
+	switch (fc_frame_payload_op(fp)) {
 	case ELS_PRLI:
 		fc_rport_recv_prli_req(rdata, sp, fp);
 		break;
 	case ELS_PRLO:
 		fc_rport_recv_prlo_req(rdata, sp, fp);
 		break;
-	case ELS_LOGO:
-		fc_rport_recv_logo_req(rdata, sp, fp);
-		break;
 	case ELS_RRQ:
 		els_data.fp = fp;
 		lport->tt.seq_els_rsp_send(sp, ELS_RRQ, &els_data);
@@ -973,12 +967,58 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		lport->tt.seq_els_rsp_send(sp, ELS_REC, &els_data);
 		break;
 	default:
-		els_data.reason = ELS_RJT_UNSUP;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+		fc_frame_free(fp);	/* can't happen */
 		break;
 	}
 
 	mutex_unlock(&rdata->rp_mutex);
+	return;
+
+reject:
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_rport_recv_req() - Handle a received ELS request from a rport
+ * @sp: current sequence in the PLOGI exchange
+ * @fp: response frame
+ * @lport: Fibre Channel local port
+ *
+ * Locking Note: Called with the lport lock held.
+ */
+void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
+		       struct fc_lport *lport)
+{
+	struct fc_seq_els_data els_data;
+
+	/*
+	 * Handle PLOGI and LOGO requests separately, since they
+	 * don't require prior login.
+	 * Check for unsupported opcodes first and reject them.
+	 * For some ops, it would be incorrect to reject with "PLOGI required".
+	 */
+	switch (fc_frame_payload_op(fp)) {
+	case ELS_PLOGI:
+		fc_rport_recv_plogi_req(lport, sp, fp);
+		break;
+	case ELS_LOGO:
+		fc_rport_recv_logo_req(lport, sp, fp);
+		break;
+	case ELS_PRLI:
+	case ELS_PRLO:
+	case ELS_RRQ:
+	case ELS_REC:
+		fc_rport_recv_els_req(lport, sp, fp);
+		break;
+	default:
+		fc_frame_free(fp);
+		els_data.fp = NULL;
+		els_data.reason = ELS_RJT_UNSUP;
+		els_data.explan = ELS_EXPL_NONE;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+		break;
+	}
 }
 
 /**
@@ -1276,11 +1316,6 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 	FC_RPORT_DBG(rdata, "Received PRLO request while in state %s\n",
 		     fc_rport_state(rdata));
 
-	if (rdata->rp_state == RPORT_ST_DELETE) {
-		fc_frame_free(fp);
-		return;
-	}
-
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_UNAB;
 	rjt_data.explan = ELS_EXPL_NONE;
@@ -1290,32 +1325,36 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 
 /**
  * fc_rport_recv_logo_req() - Handle incoming Logout (LOGO) request
- * @rdata: private remote port data
+ * @lport: local port.
  * @sp: current sequence in the LOGO exchange
  * @fp: LOGO request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
-static void fc_rport_recv_logo_req(struct fc_rport_priv *rdata,
+static void fc_rport_recv_logo_req(struct fc_lport *lport,
 				   struct fc_seq *sp,
 				   struct fc_frame *fp)
 {
 	struct fc_frame_header *fh;
-	struct fc_lport *lport = rdata->local_port;
+	struct fc_rport_priv *rdata;
+	u32 sid;
 
 	fh = fc_frame_header_get(fp);
+	sid = ntoh24(fh->fh_s_id);
 
-	FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
-		     fc_rport_state(rdata));
-
-	if (rdata->rp_state == RPORT_ST_DELETE) {
-		fc_frame_free(fp);
-		return;
-	}
-
-	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
-
+	mutex_lock(&lport->disc.disc_mutex);
+	rdata = lport->tt.rport_lookup(lport, sid);
+	if (rdata) {
+		mutex_lock(&rdata->rp_mutex);
+		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
+			     fc_rport_state(rdata));
+		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
+		mutex_unlock(&rdata->rp_mutex);
+	} else
+		FC_RPORT_ID_DBG(lport, sid,
+				"Received LOGO from non-logged-in port\n");
+	mutex_unlock(&lport->disc.disc_mutex);
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);
 }

