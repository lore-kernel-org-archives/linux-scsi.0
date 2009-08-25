From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 61/64] libfc: fix handling of incoming Discover Address
	(ADISC) requests
Date: Tue, 25 Aug 2009 14:03:52 -0700
Message-ID: <20090825210352.1553.44434.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbZHYVDv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:51 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The local port facility has been replying to ADISC requests without
looking to see if the remote port is logged in.  This is incorrect.
An ADISC request requires PLOGI first.  It should be rejected if
the sending remote port is not logged in.

This is like other incoming requests that require login, all of
which should be handled in the remote port module.

Move the ADISC request handling from fc_lport.c to fc_rport.c.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   53 -----------------------------------------
 drivers/scsi/libfc/fc_rport.c |   48 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 3f2f723..bd2f771 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -452,56 +452,6 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 }
 
 /**
- * fc_lport_recv_adisc_req() - Handle received Address Discovery Request
- * @lport: Fibre Channel local port recieving the ADISC
- * @sp: current sequence in the ADISC exchange
- * @fp: ADISC request frame
- *
- * Locking Note: The lport lock is expected to be held before calling
- * this function.
- */
-static void fc_lport_recv_adisc_req(struct fc_seq *sp, struct fc_frame *in_fp,
-				    struct fc_lport *lport)
-{
-	struct fc_frame *fp;
-	struct fc_exch *ep = fc_seq_exch(sp);
-	struct fc_els_adisc *req, *rp;
-	struct fc_seq_els_data rjt_data;
-	size_t len;
-	u32 f_ctl;
-
-	FC_LPORT_DBG(lport, "Received ADISC request while in state %s\n",
-		     fc_lport_state(lport));
-
-	req = fc_frame_payload_get(in_fp, sizeof(*req));
-	if (!req) {
-		rjt_data.fp = NULL;
-		rjt_data.reason = ELS_RJT_LOGIC;
-		rjt_data.explan = ELS_EXPL_NONE;
-		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
-	} else {
-		len = sizeof(*rp);
-		fp = fc_frame_alloc(lport, len);
-		if (fp) {
-			rp = fc_frame_payload_get(fp, len);
-			memset(rp, 0, len);
-			rp->adisc_cmd = ELS_LS_ACC;
-			rp->adisc_wwpn = htonll(lport->wwpn);
-			rp->adisc_wwnn = htonll(lport->wwnn);
-			hton24(rp->adisc_port_id,
-			       fc_host_port_id(lport->host));
-			sp = lport->tt.seq_start_next(sp);
-			f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
-			f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-			fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-				       FC_TYPE_ELS, f_ctl, 0);
-			lport->tt.seq_send(lport, sp, fp);
-		}
-	}
-	fc_frame_free(in_fp);
-}
-
-/**
  * fc_lport_recv_logo_req() - Handle received fabric LOGO request
  * @lport: Fibre Channel local port recieving the LOGO
  * @sp: current sequence in the LOGO exchange
@@ -849,9 +799,6 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 		case ELS_RNID:
 			recv = fc_lport_recv_rnid_req;
 			break;
-		case ELS_ADISC:
-			recv = fc_lport_recv_adisc_req;
-			break;
 		}
 
 		recv(sp, fp, lport);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c33e258..03ea674 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1012,6 +1012,50 @@ static void fc_rport_enter_adisc(struct fc_rport_priv *rdata)
 }
 
 /**
+ * fc_rport_recv_adisc_req() - Handle incoming Address Discovery (ADISC) Request
+ * @rdata: remote port private
+ * @sp: current sequence in the ADISC exchange
+ * @in_fp: ADISC request frame
+ *
+ * Locking Note:  Called with the lport and rport locks held.
+ */
+static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
+				    struct fc_seq *sp, struct fc_frame *in_fp)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+	struct fc_exch *ep = fc_seq_exch(sp);
+	struct fc_els_adisc *adisc;
+	struct fc_seq_els_data rjt_data;
+	u32 f_ctl;
+
+	FC_RPORT_DBG(rdata, "Received ADISC request\n");
+
+	adisc = fc_frame_payload_get(in_fp, sizeof(*adisc));
+	if (!adisc) {
+		rjt_data.fp = NULL;
+		rjt_data.reason = ELS_RJT_PROT;
+		rjt_data.explan = ELS_EXPL_INV_LEN;
+		lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+		goto drop;
+	}
+
+	fp = fc_frame_alloc(lport, sizeof(*adisc));
+	if (!fp)
+		goto drop;
+	fc_adisc_fill(lport, fp);
+	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
+	adisc->adisc_cmd = ELS_LS_ACC;
+	sp = lport->tt.seq_start_next(sp);
+	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+		       FC_TYPE_ELS, f_ctl, 0);
+	lport->tt.seq_send(lport, sp, fp);
+drop:
+	fc_frame_free(in_fp);
+}
+
+/**
  * fc_rport_recv_els_req() - handle a validated ELS request.
  * @lport: Fibre Channel local port
  * @sp: current sequence in the PLOGI exchange
@@ -1062,6 +1106,9 @@ static void fc_rport_recv_els_req(struct fc_lport *lport,
 	case ELS_PRLO:
 		fc_rport_recv_prlo_req(rdata, sp, fp);
 		break;
+	case ELS_ADISC:
+		fc_rport_recv_adisc_req(rdata, sp, fp);
+		break;
 	case ELS_RRQ:
 		els_data.fp = fp;
 		lport->tt.seq_els_rsp_send(sp, ELS_RRQ, &els_data);
@@ -1111,6 +1158,7 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		break;
 	case ELS_PRLI:
 	case ELS_PRLO:
+	case ELS_ADISC:
 	case ELS_RRQ:
 	case ELS_REC:
 		fc_rport_recv_els_req(lport, sp, fp);

