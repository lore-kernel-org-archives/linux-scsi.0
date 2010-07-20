From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 22/28] libfc: add fc_fill_reply_hdr() and fc_fill_hdr()
Date: Tue, 20 Jul 2010 15:21:01 -0700
Message-ID: <20100720222101.17116.66260.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:52397 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab0GTWVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:03 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Add functions to fill in an FC header given a request header.
These reduces code lines in fc_lport and fc_rport and works
without an exchange/sequence assigned.

fc_fill_reply_hdr() fills a header for a final reply frame.

fc_fill_hdr() which is similar but allows specifying the
f_ctl parameter.

Add defines for F_CTL values FC_FCTL_REQ and FC_FCTL_RESP.
These can be used for most request and response sequences.

v2 of patch adds a line to copy the frame encapsulation
info from the received frame.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_elsct.c |    2 +
 drivers/scsi/libfc/fc_fcp.c   |    6 ++-
 drivers/scsi/libfc/fc_libfc.c |   78 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_lport.c |   39 ++++++---------------
 drivers/scsi/libfc/fc_rport.c |   64 ++++++++--------------------------
 include/scsi/fc_encode.h      |    7 ++++
 include/scsi/libfc.h          |    4 ++
 7 files changed, 121 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index e9412b7..9b25969 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -64,7 +64,7 @@ struct fc_seq *fc_elsct_send(struct fc_lport *lport, u32 did,
 	}
 
 	fc_fill_fc_hdr(fp, r_ctl, did, lport->port_id, fh_type,
-		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+		       FC_FCTL_REQ, 0);
 
 	return lport->tt.exch_seq_send(lport, fp, resp, NULL, arg, timer_msec);
 }
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 61a1297..eac4d09 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1108,7 +1108,7 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_UNSOL_CMD, rport->port_id,
 		       rpriv->local_port->port_id, FC_TYPE_FCP,
-		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+		       FC_FCTL_REQ, 0);
 
 	seq = lport->tt.exch_seq_send(lport, fp, resp, fc_fcp_pkt_destroy,
 				      fsp, 0);
@@ -1381,7 +1381,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	fr_seq(fp) = fsp->seq_ptr;
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rport->port_id,
 		       rpriv->local_port->port_id, FC_TYPE_ELS,
-		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+		       FC_FCTL_REQ, 0);
 	if (lport->tt.elsct_send(lport, rport->port_id, fp, ELS_REC,
 				 fc_fcp_rec_resp, fsp,
 				 jiffies_to_msecs(FC_SCSI_REC_TOV))) {
@@ -1639,7 +1639,7 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS4_REQ, rport->port_id,
 		       rpriv->local_port->port_id, FC_TYPE_FCP,
-		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+		       FC_FCTL_REQ, 0);
 
 	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp, NULL,
 				      fsp, jiffies_to_msecs(FC_SCSI_REC_TOV));
diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index 39f4b6a..6a48c28 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -23,6 +23,7 @@
 #include <linux/crc32.h>
 
 #include <scsi/libfc.h>
+#include <scsi/fc_encode.h>
 
 #include "fc_libfc.h"
 
@@ -132,3 +133,80 @@ u32 fc_copy_buffer_to_sglist(void *buf, size_t len,
 	}
 	return copy_len;
 }
+
+/**
+ * fc_fill_hdr() -  fill FC header fields based on request
+ * @fp: reply frame containing header to be filled in
+ * @in_fp: request frame containing header to use in filling in reply
+ * @r_ctl: R_CTL value for header
+ * @f_ctl: F_CTL value for header, with 0 pad
+ * @seq_cnt: sequence count for the header, ignored if frame has a sequence
+ * @parm_offset: parameter / offset value
+ */
+void fc_fill_hdr(struct fc_frame *fp, const struct fc_frame *in_fp,
+		 enum fc_rctl r_ctl, u32 f_ctl, u16 seq_cnt, u32 parm_offset)
+{
+	struct fc_frame_header *fh;
+	struct fc_frame_header *in_fh;
+	struct fc_seq *sp;
+	u32 fill;
+
+	fh = __fc_frame_header_get(fp);
+	in_fh = __fc_frame_header_get(in_fp);
+
+	if (f_ctl & FC_FC_END_SEQ) {
+		fill = -fr_len(fp) & 3;
+		if (fill) {
+			/* TODO, this may be a problem with fragmented skb */
+			memset(skb_put(fp_skb(fp), fill), 0, fill);
+			f_ctl |= fill;
+		}
+		fr_eof(fp) = FC_EOF_T;
+	} else {
+		WARN_ON(fr_len(fp) % 4 != 0);	/* no pad to non last frame */
+		fr_eof(fp) = FC_EOF_N;
+	}
+
+	fh->fh_r_ctl = r_ctl;
+	memcpy(fh->fh_d_id, in_fh->fh_s_id, sizeof(fh->fh_d_id));
+	memcpy(fh->fh_s_id, in_fh->fh_d_id, sizeof(fh->fh_s_id));
+	fh->fh_type = in_fh->fh_type;
+	hton24(fh->fh_f_ctl, f_ctl);
+	fh->fh_ox_id = in_fh->fh_ox_id;
+	fh->fh_rx_id = in_fh->fh_rx_id;
+	fh->fh_cs_ctl = 0;
+	fh->fh_df_ctl = 0;
+	fh->fh_parm_offset = htonl(parm_offset);
+
+	sp = fr_seq(in_fp);
+	if (sp) {
+		fr_seq(fp) = sp;
+		fh->fh_seq_id = sp->id;
+		seq_cnt = sp->cnt;
+	} else {
+		fh->fh_seq_id = 0;
+	}
+	fh->fh_seq_cnt = ntohs(seq_cnt);
+	fr_sof(fp) = seq_cnt ? FC_SOF_N3 : FC_SOF_I3;
+	fr_encaps(fp) = fr_encaps(in_fp);
+}
+EXPORT_SYMBOL(fc_fill_hdr);
+
+/**
+ * fc_fill_reply_hdr() -  fill FC reply header fields based on request
+ * @fp: reply frame containing header to be filled in
+ * @in_fp: request frame containing header to use in filling in reply
+ * @r_ctl: R_CTL value for reply
+ * @parm_offset: parameter / offset value
+ */
+void fc_fill_reply_hdr(struct fc_frame *fp, const struct fc_frame *in_fp,
+		       enum fc_rctl r_ctl, u32 parm_offset)
+{
+	struct fc_seq *sp;
+
+	sp = fr_seq(in_fp);
+	if (sp)
+		fr_seq(fp) = fr_dev(in_fp)->tt.seq_start_next(sp);
+	fc_fill_hdr(fp, in_fp, r_ctl, FC_FCTL_RESP, 0, parm_offset);
+}
+EXPORT_SYMBOL(fc_fill_reply_hdr);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index be3c2ce..e50a660 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -405,11 +405,9 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 				   struct fc_lport *lport)
 {
 	struct fc_frame *fp;
-	struct fc_exch *ep = fc_seq_exch(sp);
 	unsigned int len;
 	void *pp;
 	void *dp;
-	u32 f_ctl;
 
 	FC_LPORT_DBG(lport, "Received ECHO request while in state %s\n",
 		     fc_lport_state(lport));
@@ -425,11 +423,8 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 		dp = fc_frame_payload_get(fp, len);
 		memcpy(dp, pp, len);
 		*((__be32 *)dp) = htonl(ELS_LS_ACC << 24);
-		sp = lport->tt.seq_start_next(sp);
-		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
-		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-			       FC_TYPE_ELS, f_ctl, 0);
-		lport->tt.seq_send(lport, sp, fp);
+		fc_fill_reply_hdr(fp, in_fp, FC_RCTL_ELS_REP, 0);
+		lport->tt.frame_send(lport, fp);
 	}
 	fc_frame_free(in_fp);
 }
@@ -447,7 +442,6 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 				   struct fc_lport *lport)
 {
 	struct fc_frame *fp;
-	struct fc_exch *ep = fc_seq_exch(sp);
 	struct fc_els_rnid *req;
 	struct {
 		struct fc_els_rnid_resp rnid;
@@ -457,7 +451,6 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	struct fc_seq_els_data rjt_data;
 	u8 fmt;
 	size_t len;
-	u32 f_ctl;
 
 	FC_LPORT_DBG(lport, "Received RNID request while in state %s\n",
 		     fc_lport_state(lport));
@@ -490,12 +483,8 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 				memcpy(&rp->gen, &lport->rnid_gen,
 				       sizeof(rp->gen));
 			}
-			sp = lport->tt.seq_start_next(sp);
-			f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
-			f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-			fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-				       FC_TYPE_ELS, f_ctl, 0);
-			lport->tt.seq_send(lport, sp, fp);
+			fc_fill_reply_hdr(fp, in_fp, FC_RCTL_ELS_REP, 0);
+			lport->tt.frame_send(lport, fp);
 		}
 	}
 	fc_frame_free(in_fp);
@@ -800,14 +789,13 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 				    struct fc_lport *lport)
 {
 	struct fc_frame *fp;
+	struct fc_frame_header *fh;
 	struct fc_seq *sp;
-	struct fc_exch *ep;
 	struct fc_els_flogi *flp;
 	struct fc_els_flogi *new_flp;
 	u64 remote_wwpn;
 	u32 remote_fid;
 	u32 local_fid;
-	u32 f_ctl;
 
 	FC_LPORT_DBG(lport, "Received FLOGI request while in state %s\n",
 		     fc_lport_state(lport));
@@ -843,7 +831,6 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 
 	fp = fc_frame_alloc(lport, sizeof(*flp));
 	if (fp) {
-		sp = lport->tt.seq_start_next(fr_seq(rx_fp));
 		new_flp = fc_frame_payload_get(fp, sizeof(*flp));
 		fc_lport_flogi_fill(lport, new_flp, ELS_FLOGI);
 		new_flp->fl_cmd = (u8) ELS_LS_ACC;
@@ -852,11 +839,11 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		 * Send the response.  If this fails, the originator should
 		 * repeat the sequence.
 		 */
-		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
-		ep = fc_seq_exch(sp);
-		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, remote_fid, local_fid,
-			       FC_TYPE_ELS, f_ctl, 0);
-		lport->tt.seq_send(lport, sp, fp);
+		fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+		fh = fc_frame_header_get(fp);
+		hton24(fh->fh_s_id, local_fid);
+		hton24(fh->fh_d_id, remote_fid);
+		lport->tt.frame_send(lport, fp);
 
 	} else {
 		fc_lport_error(lport, fp);
@@ -1731,8 +1718,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
 	hton24(fh->fh_d_id, did);
 	hton24(fh->fh_s_id, lport->port_id);
 	fh->fh_type = FC_TYPE_ELS;
-	hton24(fh->fh_f_ctl, FC_FC_FIRST_SEQ |
-	       FC_FC_END_SEQ | FC_FC_SEQ_INIT);
+	hton24(fh->fh_f_ctl, FC_FCTL_REQ);
 	fh->fh_cs_ctl = 0;
 	fh->fh_df_ctl = 0;
 	fh->fh_parm_offset = 0;
@@ -1791,8 +1777,7 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
 	hton24(fh->fh_d_id, did);
 	hton24(fh->fh_s_id, lport->port_id);
 	fh->fh_type = FC_TYPE_CT;
-	hton24(fh->fh_f_ctl, FC_FC_FIRST_SEQ |
-	       FC_FC_END_SEQ | FC_FC_SEQ_INIT);
+	hton24(fh->fh_f_ctl, FC_FCTL_REQ);
 	fh->fh_cs_ctl = 0;
 	fh->fh_df_ctl = 0;
 	fh->fh_parm_offset = 0;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 1234931..5987951 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -746,9 +746,8 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	struct fc_els_flogi *flp;
 	struct fc_rport_priv *rdata;
 	struct fc_frame *fp = rx_fp;
-	struct fc_exch *ep;
 	struct fc_seq_els_data rjt_data;
-	u32 sid, f_ctl;
+	u32 sid;
 
 	rjt_data.fp = NULL;
 	sid = fc_frame_sid(fp);
@@ -813,7 +812,6 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		rjt_data.explan = ELS_EXPL_NONE;
 		goto reject;
 	}
-	fc_frame_free(rx_fp);
 
 	fp = fc_frame_alloc(lport, sizeof(*flp));
 	if (!fp)
@@ -824,11 +822,8 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	flp = fc_frame_payload_get(fp, sizeof(*flp));
 	flp->fl_cmd = ELS_LS_ACC;
 
-	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-	ep = fc_seq_exch(sp);
-	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, f_ctl, 0);
-	lport->tt.seq_send(lport, sp, fp);
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 
 	if (rdata->ids.port_name < lport->wwpn)
 		fc_rport_enter_plogi(rdata);
@@ -837,12 +832,13 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 out:
 	mutex_unlock(&rdata->rp_mutex);
 	mutex_unlock(&disc->disc_mutex);
+	fc_frame_free(rx_fp);
 	return;
 
 reject:
 	mutex_unlock(&disc->disc_mutex);
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
-	fc_frame_free(fp);
+	fc_frame_free(rx_fp);
 }
 
 /**
@@ -1310,10 +1306,8 @@ static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
 {
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
-	struct fc_exch *ep = fc_seq_exch(sp);
 	struct fc_els_adisc *adisc;
 	struct fc_seq_els_data rjt_data;
-	u32 f_ctl;
 
 	FC_RPORT_DBG(rdata, "Received ADISC request\n");
 
@@ -1332,11 +1326,8 @@ static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
 	fc_adisc_fill(lport, fp);
 	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
 	adisc->adisc_cmd = ELS_LS_ACC;
-	sp = lport->tt.seq_start_next(sp);
-	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, f_ctl, 0);
-	lport->tt.seq_send(lport, sp, fp);
+	fc_fill_reply_hdr(fp, in_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 drop:
 	fc_frame_free(in_fp);
 }
@@ -1356,13 +1347,11 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 {
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
-	struct fc_exch *ep = fc_seq_exch(sp);
 	struct fc_els_rls *rls;
 	struct fc_els_rls_resp *rsp;
 	struct fc_els_lesb *lesb;
 	struct fc_seq_els_data rjt_data;
 	struct fc_host_statistics *hst;
-	u32 f_ctl;
 
 	FC_RPORT_DBG(rdata, "Received RLS request while in state %s\n",
 		     fc_rport_state(rdata));
@@ -1399,11 +1388,8 @@ static void fc_rport_recv_rls_req(struct fc_rport_priv *rdata,
 		lesb->lesb_inv_crc = htonl(hst->invalid_crc_count);
 	}
 
-	sp = lport->tt.seq_start_next(sp);
-	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
-	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, f_ctl, 0);
-	lport->tt.seq_send(lport, sp, fp);
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 	goto out;
 
 out_rjt:
@@ -1549,10 +1535,9 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	struct fc_disc *disc;
 	struct fc_rport_priv *rdata;
 	struct fc_frame *fp = rx_fp;
-	struct fc_exch *ep;
 	struct fc_els_flogi *pl;
 	struct fc_seq_els_data rjt_data;
-	u32 sid, f_ctl;
+	u32 sid;
 
 	rjt_data.fp = NULL;
 	sid = fc_frame_sid(fp);
@@ -1632,27 +1617,21 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	 * Get session payload size from incoming PLOGI.
 	 */
 	rdata->maxframe_size = fc_plogi_get_maxframe(pl, lport->mfs);
-	fc_frame_free(rx_fp);
 
 	/*
 	 * Send LS_ACC.	 If this fails, the originator should retry.
 	 */
-	sp = lport->tt.seq_start_next(sp);
-	if (!sp)
-		goto out;
 	fp = fc_frame_alloc(lport, sizeof(*pl));
 	if (!fp)
 		goto out;
 
 	fc_plogi_fill(lport, fp, ELS_LS_ACC);
-	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-	ep = fc_seq_exch(sp);
-	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, f_ctl, 0);
-	lport->tt.seq_send(lport, sp, fp);
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 	fc_rport_enter_prli(rdata);
 out:
 	mutex_unlock(&rdata->rp_mutex);
+	fc_frame_free(rx_fp);
 	return;
 
 reject:
@@ -1673,7 +1652,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 				   struct fc_seq *sp, struct fc_frame *rx_fp)
 {
 	struct fc_lport *lport = rdata->local_port;
-	struct fc_exch *ep;
 	struct fc_frame *fp;
 	struct {
 		struct fc_els_prli prli;
@@ -1685,7 +1663,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	unsigned int plen;
 	enum fc_els_spp_resp resp;
 	struct fc_seq_els_data rjt_data;
-	u32 f_ctl;
 	u32 fcp_parm;
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 
@@ -1714,8 +1691,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 		rjt_data.explan = ELS_EXPL_INSUF_RES;
 		goto reject;
 	}
-	sp = lport->tt.seq_start_next(sp);
-	WARN_ON(!sp);
 	pp = fc_frame_payload_get(fp, len);
 	WARN_ON(!pp);
 	memset(pp, 0, len);
@@ -1768,12 +1743,8 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	/*
 	 * Send LS_ACC.	 If this fails, the originator should retry.
 	 */
-	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
-	f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
-	ep = fc_seq_exch(sp);
-	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, f_ctl, 0);
-	lport->tt.seq_send(lport, sp, fp);
+	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
+	lport->tt.frame_send(lport, fp);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PRLI:
@@ -1817,7 +1788,6 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 	struct fc_els_spp *spp;		/* response spp */
 	unsigned int len;
 	unsigned int plen;
-	u32 f_ctl;
 	struct fc_seq_els_data rjt_data;
 
 	rjt_data.fp = NULL;
@@ -1859,11 +1829,9 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 
 	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
 
-	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
-	f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
 	ep = fc_seq_exch(sp);
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
-		       FC_TYPE_ELS, f_ctl, 0);
+		       FC_TYPE_ELS, FC_FCTL_RESP, 0);
 	lport->tt.seq_send(lport, sp, fp);
 	goto drop;
 
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 9b4867c..6d293c8 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -21,6 +21,13 @@
 #define _FC_ENCODE_H_
 #include <asm/unaligned.h>
 
+/*
+ * F_CTL values for simple requests and responses.
+ */
+#define FC_FCTL_REQ	(FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT)
+#define FC_FCTL_RESP	(FC_FC_EX_CTX | FC_FC_LAST_SEQ | \
+			FC_FC_END_SEQ | FC_FC_SEQ_INIT)
+
 struct fc_ns_rft {
 	struct fc_ns_fid fid;	/* port ID object */
 	struct fc_ns_fts fts;	/* FC4-types object */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f1ce793..a6414ec 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1027,6 +1027,10 @@ struct fc_seq *fc_elsct_send(struct fc_lport *, u32 did,
 				    void *arg, u32 timer_msec);
 void fc_lport_flogi_resp(struct fc_seq *, struct fc_frame *, void *);
 void fc_lport_logo_resp(struct fc_seq *, struct fc_frame *, void *);
+void fc_fill_reply_hdr(struct fc_frame *, const struct fc_frame *,
+		       enum fc_rctl, u32 parm_offset);
+void fc_fill_hdr(struct fc_frame *, const struct fc_frame *,
+		 enum fc_rctl, u32 f_ctl, u16 seq_cnt, u32 parm_offset);
 
 
 /*

