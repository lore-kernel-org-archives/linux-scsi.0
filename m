From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 9/9] libfc: add support of receiving ELS_RLS
Date: Fri, 20 Nov 2009 14:55:24 -0800
Message-ID: <20091120225524.495.89014.stgit@localhost.localdomain>
References: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbZKTWzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:55:18 -0500
In-Reply-To: <20091120225436.495.88600.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Upon receiving ELS_RLS, send the Link Error Status Block (LESB) back.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |   76 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 91e2ba2..35ca0e7 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1098,6 +1098,78 @@ drop:
 }
 
 /**
+ * fc_rport_recv_rls_req() - Handle received Read Link Status request
+ * @rdata: The remote port that sent the RLS request
+ * @sp:	The sequence that the RLS was on
+ * @rx_fp: The PRLI request frame
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this function.
+ */
+static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
+				  struct fc_seq *sp, struct fc_frame *rx_fp)
+
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+	struct fc_exch *ep = fc_seq_exch(sp);
+	struct fc_els_rls *rls;
+	struct fc_els_rls_resp *rsp;
+	struct fc_els_lesb *lesb;
+	struct fc_seq_els_data rjt_data;
+	struct fc_host_statistics *hst;
+	u32 f_ctl;
+
+	FC_RPORT_DBG(rdata, "Received RLS request while in state %s\n",
+		     fc_rport_state(rdata));
+
+	rls = fc_frame_payload_get(rx_fp, sizeof(*rls));
+	if (!rls) {
+		rjt_data.reason = ELS_RJT_PROT;
+		rjt_data.explan = ELS_EXPL_INV_LEN;
+		goto out_rjt;
+	}
+
+	fp = fc_frame_alloc(lport, sizeof(*rsp));
+	if (!fp) {
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
+		goto out_rjt;
+	}
+
+	rsp = fc_frame_payload_get(fp, sizeof(*rsp));
+	memset(rsp, 0, sizeof(*rsp));
+	rsp->rls_cmd = ELS_LS_ACC;
+	lesb = &rsp->rls_lesb;
+	if (lport->tt.get_lesb) {
+		/* get LESB from LLD if it supports it */
+		lport->tt.get_lesb(lport, lesb);
+	} else {
+		fc_get_host_stats(lport->host);
+		hst = &lport->host_stats;
+		lesb->lesb_link_fail = htonl(hst->link_failure_count);
+		lesb->lesb_sync_loss = htonl(hst->loss_of_sync_count);
+		lesb->lesb_sig_loss = htonl(hst->loss_of_signal_count);
+		lesb->lesb_prim_err = htonl(hst->prim_seq_protocol_err_count);
+		lesb->lesb_inv_word = htonl(hst->invalid_tx_word_count);
+		lesb->lesb_inv_crc = htonl(hst->invalid_crc_count);
+	}
+
+	sp = lport->tt.seq_start_next(sp);
+	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+		       FC_TYPE_ELS, f_ctl, 0);
+	lport->tt.seq_send(lport, sp, fp);
+	goto out;
+
+out_rjt:
+	rjt_data.fp = NULL;
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+out:
+	fc_frame_free(rx_fp);
+}
+
+/**
  * fc_rport_recv_els_req() - Handler for validated ELS requests
  * @lport: The local port that received the ELS request
  * @sp:	   The sequence that the ELS request was on
@@ -1159,6 +1231,9 @@ static void fc_rport_recv_els_req(struct fc_lport *lport,
 		els_data.fp = fp;
 		lport->tt.seq_els_rsp_send(sp, ELS_REC, &els_data);
 		break;
+	case ELS_RLS:
+		fc_rport_recv_rls_req(rdata, sp, fp);
+		break;
 	default:
 		fc_frame_free(fp);	/* can't happen */
 		break;
@@ -1203,6 +1278,7 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	case ELS_ADISC:
 	case ELS_RRQ:
 	case ELS_REC:
+	case ELS_RLS:
 		fc_rport_recv_els_req(lport, sp, fp);
 		break;
 	default:

