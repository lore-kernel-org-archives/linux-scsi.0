From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 24/28] libfc: don't require a local exchange for incoming
	requests
Date: Tue, 20 Jul 2010 15:21:12 -0700
Message-ID: <20100720222112.17116.30326.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47552 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819Ab0GTWVN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:13 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Incoming requests shouldn't require a local exchange if we're
just going to reply with one or two frames and don't expect
anything further.  Don't allocate exchanges for such requests
until requested by the upper-layer protocol.

The sequence is always NULL for new requests, so remove
that as an argument to request handlers.

Also change the first argument to lport->tt.seq_els_rsp_send
from the sequence pointer to the received frame pointer, to
supply the exchange IDs and destination ID info.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c   |    9 +-
 drivers/scsi/libfc/fc_disc.c  |   19 ++--
 drivers/scsi/libfc/fc_exch.c  |  188 ++++++++++++++++++++++-------------------
 drivers/scsi/libfc/fc_lport.c |   58 ++++---------
 drivers/scsi/libfc/fc_rport.c |  112 +++++++++---------------
 include/scsi/libfc.h          |   16 +--
 6 files changed, 174 insertions(+), 228 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 4de8ced..2c265fe 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -2341,20 +2341,19 @@ drop:
 
 /**
  * fcoe_ctlr_disc_recv - discovery receive handler for VN2VN mode.
- * @fip: The FCoE controller
+ * @lport: The local port
+ * @fp: The received frame
  *
  * This should never be called since we don't see RSCNs or other
  * fabric-generated ELSes.
  */
-static void fcoe_ctlr_disc_recv(struct fc_seq *seq, struct fc_frame *fp,
-				struct fc_lport *lport)
+static void fcoe_ctlr_disc_recv(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_seq_els_data rjt_data;
 
-	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_UNSUP;
 	rjt_data.explan = ELS_EXPL_NONE;
-	lport->tt.seq_els_rsp_send(seq, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &rjt_data);
 	fc_frame_free(fp);
 }
 
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 0447455..32f67c4 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -75,15 +75,13 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 
 /**
  * fc_disc_recv_rscn_req() - Handle Registered State Change Notification (RSCN)
- * @sp:	   The sequence of the RSCN exchange
+ * @disc:  The discovery object to which the RSCN applies
  * @fp:	   The RSCN frame
- * @lport: The local port that the request will be sent on
  *
  * Locking Note: This function expects that the disc_mutex is locked
  *		 before it is called.
  */
-static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
-				  struct fc_disc *disc)
+static void fc_disc_recv_rscn_req(struct fc_disc *disc, struct fc_frame *fp)
 {
 	struct fc_lport *lport;
 	struct fc_els_rscn *rp;
@@ -151,7 +149,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 			break;
 		}
 	}
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_ACC, NULL);
 
 	/*
 	 * If not doing a complete rediscovery, do GPN_ID on
@@ -177,25 +175,22 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 	return;
 reject:
 	FC_DISC_DBG(disc, "Received a bad RSCN frame\n");
-	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_LOGIC;
 	rjt_data.explan = ELS_EXPL_NONE;
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &rjt_data);
 	fc_frame_free(fp);
 }
 
 /**
  * fc_disc_recv_req() - Handle incoming requests
- * @sp:	   The sequence of the request exchange
- * @fp:	   The request frame
  * @lport: The local port receiving the request
+ * @fp:	   The request frame
  *
  * Locking Note: This function is called from the EM and will lock
  *		 the disc_mutex before calling the handler for the
  *		 request.
  */
-static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
-			     struct fc_lport *lport)
+static void fc_disc_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	u8 op;
 	struct fc_disc *disc = &lport->disc;
@@ -204,7 +199,7 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	switch (op) {
 	case ELS_RSCN:
 		mutex_lock(&disc->disc_mutex);
-		fc_disc_recv_rscn_req(sp, fp, disc);
+		fc_disc_recv_rscn_req(disc, fp);
 		mutex_unlock(&disc->disc_mutex);
 		break;
 	default:
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 027042a..b8560ad 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -129,11 +129,11 @@ struct fc_exch_mgr_anchor {
 };
 
 static void fc_exch_rrq(struct fc_exch *);
-static void fc_seq_ls_acc(struct fc_seq *);
-static void fc_seq_ls_rjt(struct fc_seq *, enum fc_els_rjt_reason,
+static void fc_seq_ls_acc(struct fc_frame *);
+static void fc_seq_ls_rjt(struct fc_frame *, enum fc_els_rjt_reason,
 			  enum fc_els_rjt_explan);
-static void fc_exch_els_rec(struct fc_seq *, struct fc_frame *);
-static void fc_exch_els_rrq(struct fc_seq *, struct fc_frame *);
+static void fc_exch_els_rec(struct fc_frame *);
+static void fc_exch_els_rrq(struct fc_frame *);
 
 /*
  * Internal implementation notes.
@@ -1003,28 +1003,30 @@ static void fc_exch_set_addr(struct fc_exch *ep,
 /**
  * fc_seq_els_rsp_send() - Send an ELS response using infomation from
  *			   the existing sequence/exchange.
- * @sp:	      The sequence/exchange to get information from
+ * @fp:	      The received frame
  * @els_cmd:  The ELS command to be sent
  * @els_data: The ELS data to be sent
+ *
+ * The received frame is not freed.
  */
-static void fc_seq_els_rsp_send(struct fc_seq *sp, enum fc_els_cmd els_cmd,
+static void fc_seq_els_rsp_send(struct fc_frame *fp, enum fc_els_cmd els_cmd,
 				struct fc_seq_els_data *els_data)
 {
 	switch (els_cmd) {
 	case ELS_LS_RJT:
-		fc_seq_ls_rjt(sp, els_data->reason, els_data->explan);
+		fc_seq_ls_rjt(fp, els_data->reason, els_data->explan);
 		break;
 	case ELS_LS_ACC:
-		fc_seq_ls_acc(sp);
+		fc_seq_ls_acc(fp);
 		break;
 	case ELS_RRQ:
-		fc_exch_els_rrq(sp, els_data->fp);
+		fc_exch_els_rrq(fp);
 		break;
 	case ELS_REC:
-		fc_exch_els_rec(sp, els_data->fp);
+		fc_exch_els_rec(fp);
 		break;
 	default:
-		FC_EXCH_DBG(fc_seq_exch(sp), "Invalid ELS CMD:%x\n", els_cmd);
+		FC_LPORT_DBG(fr_dev(fp), "Invalid ELS CMD:%x\n", els_cmd);
 	}
 }
 
@@ -1253,11 +1255,13 @@ static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
- * fc_exch_recv_req() - Handler for an incoming request where is other
- *			end is originating the sequence
+ * fc_exch_recv_req() - Handler for an incoming request
  * @lport: The local port that received the request
  * @mp:	   The EM that the exchange is on
  * @fp:	   The request frame
+ *
+ * This is used when the other end is originating the exchange
+ * and the sequence.
  */
 static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 			     struct fc_frame *fp)
@@ -1275,8 +1279,17 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 		fc_frame_free(fp);
 		return;
 	}
+	fr_dev(fp) = lport;
+
+	BUG_ON(fr_seq(fp));		/* XXX remove later */
+
+	/*
+	 * If the RX_ID is 0xffff, don't allocate an exchange.
+	 * The upper-level protocol may request one later, if needed.
+	 */
+	if (fh->fh_rx_id == htons(FC_XID_UNKNOWN))
+		return lport->tt.lport_recv(lport, fp);
 
-	fr_seq(fp) = NULL;
 	reject = fc_seq_lookup_recip(lport, mp, fp);
 	if (reject == FC_RJT_NONE) {
 		sp = fr_seq(fp);	/* sequence will be held */
@@ -1298,7 +1311,7 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 		if (ep->resp)
 			ep->resp(sp, fp, ep->arg);
 		else
-			lport->tt.lport_recv(lport, sp, fp);
+			lport->tt.lport_recv(lport, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
 		FC_LPORT_DBG(lport, "exch/seq lookup failed: reject %x\n",
@@ -1566,53 +1579,55 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 
 /**
  * fc_seq_ls_acc() - Accept sequence with LS_ACC
- * @req_sp: The request sequence
+ * @rx_fp: The received frame, not freed here.
  *
  * If this fails due to allocation or transmit congestion, assume the
  * originator will repeat the sequence.
  */
-static void fc_seq_ls_acc(struct fc_seq *req_sp)
+static void fc_seq_ls_acc(struct fc_frame *rx_fp)
 {
-	struct fc_seq *sp;
+	struct fc_lport *lport;
 	struct fc_els_ls_acc *acc;
 	struct fc_frame *fp;
 
-	sp = fc_seq_start_next(req_sp);
-	fp = fc_frame_alloc(fc_seq_exch(sp)->lp, sizeof(*acc));
-	if (fp) {
-		acc = fc_frame_payload_get(fp, sizeof(*acc));
-		memset(acc, 0, sizeof(*acc));
-		acc->la_cmd = ELS_LS_ACC;
-		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
-	}
+	lport = fr_dev(rx_fp);
+	fp = fc_frame_alloc(lport, sizeof(*acc));
+	if (!fp)
+		return;
+	acc = fc_frame_payload_get(fp, sizeof(*acc));
+	memset(acc, 0, sizeof(*acc));
+	acc->la_cmd = ELS_LS_ACC;
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 }
 
 /**
  * fc_seq_ls_rjt() - Reject a sequence with ELS LS_RJT
- * @req_sp: The request sequence
+ * @rx_fp: The received frame, not freed here.
  * @reason: The reason the sequence is being rejected
- * @explan: The explaination for the rejection
+ * @explan: The explanation for the rejection
  *
  * If this fails due to allocation or transmit congestion, assume the
  * originator will repeat the sequence.
  */
-static void fc_seq_ls_rjt(struct fc_seq *req_sp, enum fc_els_rjt_reason reason,
+static void fc_seq_ls_rjt(struct fc_frame *rx_fp, enum fc_els_rjt_reason reason,
 			  enum fc_els_rjt_explan explan)
 {
-	struct fc_seq *sp;
+	struct fc_lport *lport;
 	struct fc_els_ls_rjt *rjt;
 	struct fc_frame *fp;
 
-	sp = fc_seq_start_next(req_sp);
-	fp = fc_frame_alloc(fc_seq_exch(sp)->lp, sizeof(*rjt));
-	if (fp) {
-		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
-		memset(rjt, 0, sizeof(*rjt));
-		rjt->er_cmd = ELS_LS_RJT;
-		rjt->er_reason = reason;
-		rjt->er_explan = explan;
-		fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
-	}
+	lport = fr_dev(rx_fp);
+	fp = fc_frame_alloc(lport, sizeof(*rjt));
+	if (!fp)
+		return;
+	rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+	memset(rjt, 0, sizeof(*rjt));
+	rjt->er_cmd = ELS_LS_RJT;
+	rjt->er_reason = reason;
+	rjt->er_explan = explan;
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 }
 
 /**
@@ -1715,17 +1730,33 @@ void fc_exch_mgr_reset(struct fc_lport *lport, u32 sid, u32 did)
 EXPORT_SYMBOL(fc_exch_mgr_reset);
 
 /**
+ * fc_exch_lookup() - find an exchange
+ * @lport: The local port
+ * @xid: The exchange ID
+ *
+ * Returns exchange pointer with hold for caller, or NULL if not found.
+ */
+static struct fc_exch *fc_exch_lookup(struct fc_lport *lport, u32 xid)
+{
+	struct fc_exch_mgr_anchor *ema;
+
+	list_for_each_entry(ema, &lport->ema_list, ema_list)
+		if (ema->mp->min_xid <= xid && xid <= ema->mp->max_xid)
+			return fc_exch_find(ema->mp, xid);
+	return NULL;
+}
+
+/**
  * fc_exch_els_rec() - Handler for ELS REC (Read Exchange Concise) requests
- * @sp:	 The sequence the REC is on
- * @rfp: The REC frame
+ * @rfp: The REC frame, not freed here.
  *
  * Note that the requesting port may be different than the S_ID in the request.
  */
-static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
+static void fc_exch_els_rec(struct fc_frame *rfp)
 {
+	struct fc_lport *lport;
 	struct fc_frame *fp;
 	struct fc_exch *ep;
-	struct fc_exch_mgr *em;
 	struct fc_els_rec *rp;
 	struct fc_els_rec_acc *acc;
 	enum fc_els_rjt_reason reason = ELS_RJT_LOGIC;
@@ -1734,6 +1765,7 @@ static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
 	u16 rxid;
 	u16 oxid;
 
+	lport = fr_dev(rfp);
 	rp = fc_frame_payload_get(rfp, sizeof(*rp));
 	explan = ELS_EXPL_INV_LEN;
 	if (!rp)
@@ -1742,35 +1774,19 @@ static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
 	rxid = ntohs(rp->rec_rx_id);
 	oxid = ntohs(rp->rec_ox_id);
 
-	/*
-	 * Currently it's hard to find the local S_ID from the exchange
-	 * manager.  This will eventually be fixed, but for now it's easier
-	 * to lookup the subject exchange twice, once as if we were
-	 * the initiator, and then again if we weren't.
-	 */
-	em = fc_seq_exch(sp)->em;
-	ep = fc_exch_find(em, oxid);
+	ep = fc_exch_lookup(lport,
+			    sid == fc_host_port_id(lport->host) ? oxid : rxid);
 	explan = ELS_EXPL_OXID_RXID;
-	if (ep && ep->oid == sid) {
-		if (ep->rxid != FC_XID_UNKNOWN &&
-		    rxid != FC_XID_UNKNOWN &&
-		    ep->rxid != rxid)
-			goto rel;
-	} else {
-		if (ep)
-			fc_exch_release(ep);
-		ep = NULL;
-		if (rxid != FC_XID_UNKNOWN)
-			ep = fc_exch_find(em, rxid);
-		if (!ep)
-			goto reject;
-	}
-
-	fp = fc_frame_alloc(fc_seq_exch(sp)->lp, sizeof(*acc));
-	if (!fp) {
-		fc_exch_done(sp);
+	if (!ep)
+		goto reject;
+	if (ep->oid != sid || oxid != ep->oxid)
+		goto rel;
+	if (rxid != FC_XID_UNKNOWN && rxid != ep->rxid)
+		goto rel;
+	fp = fc_frame_alloc(lport, sizeof(*acc));
+	if (!fp)
 		goto out;
-	}
+
 	acc = fc_frame_payload_get(fp, sizeof(*acc));
 	memset(acc, 0, sizeof(*acc));
 	acc->reca_cmd = ELS_LS_ACC;
@@ -1785,18 +1801,16 @@ static void fc_exch_els_rec(struct fc_seq *sp, struct fc_frame *rfp)
 	acc->reca_e_stat = htonl(ep->esb_stat & (ESB_ST_RESP |
 						 ESB_ST_SEQ_INIT |
 						 ESB_ST_COMPLETE));
-	sp = fc_seq_start_next(sp);
-	fc_seq_send_last(sp, fp, FC_RCTL_ELS_REP, FC_TYPE_ELS);
+	fc_fill_reply_hdr(fp, rfp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 out:
 	fc_exch_release(ep);
-	fc_frame_free(rfp);
 	return;
 
 rel:
 	fc_exch_release(ep);
 reject:
-	fc_seq_ls_rjt(sp, reason, explan);
-	fc_frame_free(rfp);
+	fc_seq_ls_rjt(rfp, reason, explan);
 }
 
 /**
@@ -1971,20 +1985,20 @@ retry:
 	spin_unlock_bh(&ep->ex_lock);
 }
 
-
 /**
  * fc_exch_els_rrq() - Handler for ELS RRQ (Reset Recovery Qualifier) requests
- * @sp: The sequence that the RRQ is on
- * @fp: The RRQ frame
+ * @fp: The RRQ frame, not freed here.
  */
-static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
+static void fc_exch_els_rrq(struct fc_frame *fp)
 {
+	struct fc_lport *lport;
 	struct fc_exch *ep = NULL;	/* request or subject exchange */
 	struct fc_els_rrq *rp;
 	u32 sid;
 	u16 xid;
 	enum fc_els_rjt_explan explan;
 
+	lport = fr_dev(fp);
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
 	explan = ELS_EXPL_INV_LEN;
 	if (!rp)
@@ -1993,11 +2007,10 @@ static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
 	/*
 	 * lookup subject exchange.
 	 */
-	ep = fc_seq_exch(sp);
 	sid = ntoh24(rp->rrq_s_id);		/* subject source */
-	xid = ep->did == sid ? ntohs(rp->rrq_ox_id) : ntohs(rp->rrq_rx_id);
-	ep = fc_exch_find(ep->em, xid);
-
+	xid = fc_host_port_id(lport->host) == sid ?
+			ntohs(rp->rrq_ox_id) : ntohs(rp->rrq_rx_id);
+	ep = fc_exch_lookup(lport, xid);
 	explan = ELS_EXPL_OXID_RXID;
 	if (!ep)
 		goto reject;
@@ -2028,15 +2041,14 @@ static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
 	/*
 	 * Send LS_ACC.
 	 */
-	fc_seq_ls_acc(sp);
+	fc_seq_ls_acc(fp);
 	goto out;
 
 unlock_reject:
 	spin_unlock_bh(&ep->ex_lock);
 reject:
-	fc_seq_ls_rjt(sp, ELS_RJT_LOGIC, explan);
+	fc_seq_ls_rjt(fp, ELS_RJT_LOGIC, explan);
 out:
-	fc_frame_free(fp);
 	if (ep)
 		fc_exch_release(ep);	/* drop hold from fc_exch_find */
 }
@@ -2267,7 +2279,7 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
 			fc_exch_recv_seq_resp(ema->mp, fp);
 		else if (f_ctl & FC_FC_SEQ_CTX)
 			fc_exch_recv_resp(ema->mp, fp);
-		else
+		else	/* no EX_CTX and no SEQ_CTX */
 			fc_exch_recv_req(lport, ema->mp, fp);
 		break;
 	default:
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e50a660..1998c03 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -375,34 +375,31 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
 
 /**
  * fc_lport_recv_rlir_req() - Handle received Registered Link Incident Report.
- * @sp:	   The sequence in the RLIR exchange
- * @fp:	   The RLIR request frame
  * @lport: Fibre Channel local port recieving the RLIR
+ * @fp:	   The RLIR request frame
  *
  * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
-static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
-				   struct fc_lport *lport)
+static void fc_lport_recv_rlir_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
 		     fc_lport_state(lport));
 
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);
 }
 
 /**
  * fc_lport_recv_echo_req() - Handle received ECHO request
- * @sp:	   The sequence in the ECHO exchange
- * @fp:	   ECHO request frame
  * @lport: The local port recieving the ECHO
+ * @fp:	   ECHO request frame
  *
  * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
-static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
-				   struct fc_lport *lport)
+static void fc_lport_recv_echo_req(struct fc_lport *lport,
+				   struct fc_frame *in_fp)
 {
 	struct fc_frame *fp;
 	unsigned int len;
@@ -431,15 +428,14 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 
 /**
  * fc_lport_recv_rnid_req() - Handle received Request Node ID data request
- * @sp:	   The sequence in the RNID exchange
- * @fp:	   The RNID request frame
  * @lport: The local port recieving the RNID
+ * @fp:	   The RNID request frame
  *
  * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
-static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
-				   struct fc_lport *lport)
+static void fc_lport_recv_rnid_req(struct fc_lport *lport,
+				   struct fc_frame *in_fp)
 {
 	struct fc_frame *fp;
 	struct fc_els_rnid *req;
@@ -457,10 +453,9 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
-		rjt_data.fp = NULL;
 		rjt_data.reason = ELS_RJT_LOGIC;
 		rjt_data.explan = ELS_EXPL_NONE;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+		lport->tt.seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
 	} else {
 		fmt = req->rnid_fmt;
 		len = sizeof(*rp);
@@ -492,17 +487,15 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 
 /**
  * fc_lport_recv_logo_req() - Handle received fabric LOGO request
- * @sp:	   The sequence in the LOGO exchange
- * @fp:	   The LOGO request frame
  * @lport: The local port recieving the LOGO
+ * @fp:	   The LOGO request frame
  *
  * Locking Note: The lport lock is exected to be held before calling
  * this function.
  */
-static void fc_lport_recv_logo_req(struct fc_seq *sp, struct fc_frame *fp,
-				   struct fc_lport *lport)
+static void fc_lport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 {
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_ACC, NULL);
 	fc_lport_enter_reset(lport);
 	fc_frame_free(fp);
 }
@@ -773,9 +766,8 @@ EXPORT_SYMBOL(fc_lport_set_local_id);
 
 /**
  * fc_lport_recv_flogi_req() - Receive a FLOGI request
- * @sp_in: The sequence the FLOGI is on
- * @rx_fp: The FLOGI frame
  * @lport: The local port that recieved the request
+ * @rx_fp: The FLOGI frame
  *
  * A received FLOGI request indicates a point-to-point connection.
  * Accept it with the common service parameters indicating our N port.
@@ -784,13 +776,11 @@ EXPORT_SYMBOL(fc_lport_set_local_id);
  * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
-static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
-				    struct fc_frame *rx_fp,
-				    struct fc_lport *lport)
+static void fc_lport_recv_flogi_req(struct fc_lport *lport,
+				    struct fc_frame *rx_fp)
 {
 	struct fc_frame *fp;
 	struct fc_frame_header *fh;
-	struct fc_seq *sp;
 	struct fc_els_flogi *flp;
 	struct fc_els_flogi *new_flp;
 	u64 remote_wwpn;
@@ -850,16 +840,13 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	}
 	fc_lport_ptp_setup(lport, remote_fid, remote_wwpn,
 			   get_unaligned_be64(&flp->fl_wwnn));
-
 out:
-	sp = fr_seq(rx_fp);
 	fc_frame_free(rx_fp);
 }
 
 /**
  * fc_lport_recv_req() - The generic lport request handler
  * @lport: The local port that received the request
- * @sp:	   The sequence the request is on
  * @fp:	   The request frame
  *
  * This function will see if the lport handles the request or
@@ -868,11 +855,10 @@ out:
  * Locking Note: This function should not be called with the lport
  *		 lock held becuase it will grab the lock.
  */
-static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
-			      struct fc_frame *fp)
+static void fc_lport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
-	void (*recv) (struct fc_seq *, struct fc_frame *, struct fc_lport *);
+	void (*recv)(struct fc_lport *, struct fc_frame *);
 
 	mutex_lock(&lport->lp_mutex);
 
@@ -912,19 +898,13 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 			break;
 		}
 
-		recv(sp, fp, lport);
+		recv(lport, fp);
 	} else {
 		FC_LPORT_DBG(lport, "dropping invalid frame (eof %x)\n",
 			     fr_eof(fp));
 		fc_frame_free(fp);
 	}
 	mutex_unlock(&lport->lp_mutex);
-
-	/*
-	 *  The common exch_done for all request may not be good
-	 *  if any request requires longer hold on exhange. XXX
-	 */
-	lport->tt.exch_done(sp);
 }
 
 /**
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 5987951..25479cc 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -68,14 +68,10 @@ static void fc_rport_enter_ready(struct fc_rport_priv *);
 static void fc_rport_enter_logo(struct fc_rport_priv *);
 static void fc_rport_enter_adisc(struct fc_rport_priv *);
 
-static void fc_rport_recv_plogi_req(struct fc_lport *,
-				    struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_prli_req(struct fc_rport_priv *,
-				   struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_prlo_req(struct fc_rport_priv *,
-				   struct fc_seq *, struct fc_frame *);
-static void fc_rport_recv_logo_req(struct fc_lport *,
-				   struct fc_seq *, struct fc_frame *);
+static void fc_rport_recv_plogi_req(struct fc_lport *, struct fc_frame *);
+static void fc_rport_recv_prli_req(struct fc_rport_priv *, struct fc_frame *);
+static void fc_rport_recv_prlo_req(struct fc_rport_priv *, struct fc_frame *);
+static void fc_rport_recv_logo_req(struct fc_lport *, struct fc_frame *);
 static void fc_rport_timeout(struct work_struct *);
 static void fc_rport_error(struct fc_rport_priv *, struct fc_frame *);
 static void fc_rport_error_retry(struct fc_rport_priv *, struct fc_frame *);
@@ -736,11 +732,10 @@ static void fc_rport_enter_flogi(struct fc_rport_priv *rdata)
 /**
  * fc_rport_recv_flogi_req() - Handle Fabric Login (FLOGI) request in p-mp mode
  * @lport: The local port that received the PLOGI request
- * @sp:	   The sequence that the PLOGI request was on
  * @rx_fp: The PLOGI request frame
  */
 static void fc_rport_recv_flogi_req(struct fc_lport *lport,
-				    struct fc_seq *sp, struct fc_frame *rx_fp)
+				    struct fc_frame *rx_fp)
 {
 	struct fc_disc *disc;
 	struct fc_els_flogi *flp;
@@ -749,7 +744,6 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	struct fc_seq_els_data rjt_data;
 	u32 sid;
 
-	rjt_data.fp = NULL;
 	sid = fc_frame_sid(fp);
 
 	FC_RPORT_ID_DBG(lport, sid, "Received FLOGI request\n");
@@ -817,7 +811,6 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	if (!fp)
 		goto out;
 
-	sp = lport->tt.seq_start_next(sp);
 	fc_flogi_fill(lport, fp);
 	flp = fc_frame_payload_get(fp, sizeof(*flp));
 	flp->fl_cmd = ELS_LS_ACC;
@@ -837,7 +830,7 @@ out:
 
 reject:
 	mutex_unlock(&disc->disc_mutex);
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(rx_fp, ELS_LS_RJT, &rjt_data);
 	fc_frame_free(rx_fp);
 }
 
@@ -1296,13 +1289,12 @@ static void fc_rport_enter_adisc(struct fc_rport_priv *rdata)
 /**
  * fc_rport_recv_adisc_req() - Handler for Address Discovery (ADISC) requests
  * @rdata: The remote port that sent the ADISC request
- * @sp:	   The sequence the ADISC request was on
  * @in_fp: The ADISC request frame
  *
  * Locking Note:  Called with the lport and rport locks held.
  */
 static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
-				    struct fc_seq *sp, struct fc_frame *in_fp)
+				    struct fc_frame *in_fp)
 {
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
@@ -1313,10 +1305,9 @@ static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
 
 	adisc = fc_frame_payload_get(in_fp, sizeof(*adisc));
 	if (!adisc) {
-		rjt_data.fp = NULL;
 		rjt_data.reason = ELS_RJT_PROT;
 		rjt_data.explan = ELS_EXPL_INV_LEN;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+		lport->tt.seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
 		goto drop;
 	}
 
@@ -1335,14 +1326,13 @@ drop:
 /**
  * fc_rport_recv_rls_req() - Handle received Read Link Status request
  * @rdata: The remote port that sent the RLS request
- * @sp:	The sequence that the RLS was on
  * @rx_fp: The PRLI request frame
  *
  * Locking Note: The rport lock is expected to be held before calling
  * this function.
  */
 static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
-				  struct fc_seq *sp, struct fc_frame *rx_fp)
+				  struct fc_frame *rx_fp)
 
 {
 	struct fc_lport *lport = rdata->local_port;
@@ -1393,8 +1383,7 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 	goto out;
 
 out_rjt:
-	rjt_data.fp = NULL;
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(rx_fp, ELS_LS_RJT, &rjt_data);
 out:
 	fc_frame_free(rx_fp);
 }
@@ -1402,7 +1391,6 @@ out:
 /**
  * fc_rport_recv_els_req() - Handler for validated ELS requests
  * @lport: The local port that received the ELS request
- * @sp:	   The sequence that the ELS request was on
  * @fp:	   The ELS request frame
  *
  * Handle incoming ELS requests that require port login.
@@ -1410,16 +1398,11 @@ out:
  *
  * Locking Note: Called with the lport lock held.
  */
-static void fc_rport_recv_els_req(struct fc_lport *lport,
-				  struct fc_seq *sp, struct fc_frame *fp)
+static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_rport_priv *rdata;
 	struct fc_seq_els_data els_data;
 
-	els_data.fp = NULL;
-	els_data.reason = ELS_RJT_UNAB;
-	els_data.explan = ELS_EXPL_PLOGI_REQD;
-
 	mutex_lock(&lport->disc.disc_mutex);
 	rdata = lport->tt.rport_lookup(lport, fc_frame_sid(fp));
 	if (!rdata) {
@@ -1442,24 +1425,24 @@ static void fc_rport_recv_els_req(struct fc_lport *lport,
 
 	switch (fc_frame_payload_op(fp)) {
 	case ELS_PRLI:
-		fc_rport_recv_prli_req(rdata, sp, fp);
+		fc_rport_recv_prli_req(rdata, fp);
 		break;
 	case ELS_PRLO:
-		fc_rport_recv_prlo_req(rdata, sp, fp);
+		fc_rport_recv_prlo_req(rdata, fp);
 		break;
 	case ELS_ADISC:
-		fc_rport_recv_adisc_req(rdata, sp, fp);
+		fc_rport_recv_adisc_req(rdata, fp);
 		break;
 	case ELS_RRQ:
-		els_data.fp = fp;
-		lport->tt.seq_els_rsp_send(sp, ELS_RRQ, &els_data);
+		lport->tt.seq_els_rsp_send(fp, ELS_RRQ, NULL);
+		fc_frame_free(fp);
 		break;
 	case ELS_REC:
-		els_data.fp = fp;
-		lport->tt.seq_els_rsp_send(sp, ELS_REC, &els_data);
+		lport->tt.seq_els_rsp_send(fp, ELS_REC, NULL);
+		fc_frame_free(fp);
 		break;
 	case ELS_RLS:
-		fc_rport_recv_rls_req(rdata, sp, fp);
+		fc_rport_recv_rls_req(rdata, fp);
 		break;
 	default:
 		fc_frame_free(fp);	/* can't happen */
@@ -1470,20 +1453,20 @@ static void fc_rport_recv_els_req(struct fc_lport *lport,
 	return;
 
 reject:
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+	els_data.reason = ELS_RJT_UNAB;
+	els_data.explan = ELS_EXPL_PLOGI_REQD;
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &els_data);
 	fc_frame_free(fp);
 }
 
 /**
  * fc_rport_recv_req() - Handler for requests
- * @sp:	   The sequence the request was on
- * @fp:	   The request frame
  * @lport: The local port that received the request
+ * @fp:	   The request frame
  *
  * Locking Note: Called with the lport lock held.
  */
-void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
-		       struct fc_lport *lport)
+void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_seq_els_data els_data;
 
@@ -1495,13 +1478,13 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	 */
 	switch (fc_frame_payload_op(fp)) {
 	case ELS_FLOGI:
-		fc_rport_recv_flogi_req(lport, sp, fp);
+		fc_rport_recv_flogi_req(lport, fp);
 		break;
 	case ELS_PLOGI:
-		fc_rport_recv_plogi_req(lport, sp, fp);
+		fc_rport_recv_plogi_req(lport, fp);
 		break;
 	case ELS_LOGO:
-		fc_rport_recv_logo_req(lport, sp, fp);
+		fc_rport_recv_logo_req(lport, fp);
 		break;
 	case ELS_PRLI:
 	case ELS_PRLO:
@@ -1509,14 +1492,13 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	case ELS_RRQ:
 	case ELS_REC:
 	case ELS_RLS:
-		fc_rport_recv_els_req(lport, sp, fp);
+		fc_rport_recv_els_req(lport, fp);
 		break;
 	default:
-		fc_frame_free(fp);
-		els_data.fp = NULL;
 		els_data.reason = ELS_RJT_UNSUP;
 		els_data.explan = ELS_EXPL_NONE;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &els_data);
+		lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &els_data);
+		fc_frame_free(fp);
 		break;
 	}
 }
@@ -1524,13 +1506,12 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 /**
  * fc_rport_recv_plogi_req() - Handler for Port Login (PLOGI) requests
  * @lport: The local port that received the PLOGI request
- * @sp:	   The sequence that the PLOGI request was on
  * @rx_fp: The PLOGI request frame
  *
  * Locking Note: The rport lock is held before calling this function.
  */
 static void fc_rport_recv_plogi_req(struct fc_lport *lport,
-				    struct fc_seq *sp, struct fc_frame *rx_fp)
+				    struct fc_frame *rx_fp)
 {
 	struct fc_disc *disc;
 	struct fc_rport_priv *rdata;
@@ -1539,7 +1520,6 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	struct fc_seq_els_data rjt_data;
 	u32 sid;
 
-	rjt_data.fp = NULL;
 	sid = fc_frame_sid(fp);
 
 	FC_RPORT_ID_DBG(lport, sid, "Received PLOGI request\n");
@@ -1635,21 +1615,20 @@ out:
 	return;
 
 reject:
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_RJT, &rjt_data);
 	fc_frame_free(fp);
 }
 
 /**
  * fc_rport_recv_prli_req() - Handler for process login (PRLI) requests
  * @rdata: The remote port that sent the PRLI request
- * @sp:	   The sequence that the PRLI was on
  * @rx_fp: The PRLI request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
 static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
-				   struct fc_seq *sp, struct fc_frame *rx_fp)
+				   struct fc_frame *rx_fp)
 {
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
@@ -1666,7 +1645,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	u32 fcp_parm;
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 
-	rjt_data.fp = NULL;
 	FC_RPORT_DBG(rdata, "Received PRLI request while in state %s\n",
 		     fc_rport_state(rdata));
 
@@ -1759,7 +1737,7 @@ reject_len:
 	rjt_data.reason = ELS_RJT_PROT;
 	rjt_data.explan = ELS_EXPL_INV_LEN;
 reject:
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(rx_fp, ELS_LS_RJT, &rjt_data);
 drop:
 	fc_frame_free(rx_fp);
 }
@@ -1767,18 +1745,15 @@ drop:
 /**
  * fc_rport_recv_prlo_req() - Handler for process logout (PRLO) requests
  * @rdata: The remote port that sent the PRLO request
- * @sp:	   The sequence that the PRLO was on
  * @rx_fp: The PRLO request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
 static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
-				   struct fc_seq *sp,
 				   struct fc_frame *rx_fp)
 {
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_exch *ep;
 	struct fc_frame *fp;
 	struct {
 		struct fc_els_prlo prlo;
@@ -1790,8 +1765,6 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 	unsigned int plen;
 	struct fc_seq_els_data rjt_data;
 
-	rjt_data.fp = NULL;
-
 	FC_RPORT_DBG(rdata, "Received PRLO request while in state %s\n",
 		     fc_rport_state(rdata));
 
@@ -1814,8 +1787,6 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 		goto reject;
 	}
 
-	sp = lport->tt.seq_start_next(sp);
-	WARN_ON(!sp);
 	pp = fc_frame_payload_get(fp, len);
 	WARN_ON(!pp);
 	memset(pp, 0, len);
@@ -1829,17 +1800,15 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 
 	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
 
-	ep = fc_seq_exch(sp);
-	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, FC_FCTL_RESP, 0);
-	lport->tt.seq_send(lport, sp, fp);
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 	goto drop;
 
 reject_len:
 	rjt_data.reason = ELS_RJT_PROT;
 	rjt_data.explan = ELS_EXPL_INV_LEN;
 reject:
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	lport->tt.seq_els_rsp_send(rx_fp, ELS_LS_RJT, &rjt_data);
 drop:
 	fc_frame_free(rx_fp);
 }
@@ -1847,20 +1816,17 @@ drop:
 /**
  * fc_rport_recv_logo_req() - Handler for logout (LOGO) requests
  * @lport: The local port that received the LOGO request
- * @sp:	   The sequence that the LOGO request was on
  * @fp:	   The LOGO request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
-static void fc_rport_recv_logo_req(struct fc_lport *lport,
-				   struct fc_seq *sp,
-				   struct fc_frame *fp)
+static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_rport_priv *rdata;
 	u32 sid;
 
-	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+	lport->tt.seq_els_rsp_send(fp, ELS_LS_ACC, NULL);
 
 	sid = fc_frame_sid(fp);
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 605f1d7..14be49b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -249,14 +249,12 @@ struct fcoe_dev_stats {
 
 /**
  * struct fc_seq_els_data - ELS data used for passing ELS specific responses
- * @fp:     The ELS frame
  * @reason: The reason for rejection
  * @explan: The explaination of the rejection
  *
  * Mainly used by the exchange manager layer.
  */
 struct fc_seq_els_data {
-	struct fc_frame *fp;
 	enum fc_els_rjt_reason reason;
 	enum fc_els_rjt_explan explan;
 };
@@ -519,12 +517,11 @@ struct libfc_function_template {
 			struct fc_frame *);
 
 	/*
-	 * Send an ELS response using infomation from a previous
-	 * exchange and sequence.
+	 * Send an ELS response using infomation from the received frame.
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	void (*seq_els_rsp_send)(struct fc_seq *, enum fc_els_cmd,
+	void (*seq_els_rsp_send)(struct fc_frame *, enum fc_els_cmd,
 				 struct fc_seq_els_data *);
 
 	/*
@@ -583,8 +580,7 @@ struct libfc_function_template {
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	void (*lport_recv)(struct fc_lport *, struct fc_seq *,
-			   struct fc_frame *);
+	void (*lport_recv)(struct fc_lport *, struct fc_frame *);
 
 	/*
 	 * Reset the local port.
@@ -646,8 +642,7 @@ struct libfc_function_template {
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	void (*rport_recv_req)(struct fc_seq *, struct fc_frame *,
-			       struct fc_lport *);
+	void (*rport_recv_req)(struct fc_lport *, struct fc_frame *);
 
 	/*
 	 * lookup an rport by it's port ID.
@@ -693,8 +688,7 @@ struct libfc_function_template {
 	 *
 	 * STATUS: OPTIONAL
 	 */
-	void (*disc_recv_req)(struct fc_seq *, struct fc_frame *,
-			      struct fc_lport *);
+	void (*disc_recv_req)(struct fc_lport *, struct fc_frame *);
 
 	/*
 	 * Start discovery for a local port.

