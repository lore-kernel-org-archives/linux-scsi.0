From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/17] libfc: Handle unsolicited PRLO request
Date: Fri, 11 Jun 2010 16:44:04 -0700
Message-ID: <20100611234404.4616.10763.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab0FKXol (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:41 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Resubmitting after incorporating Joe's review comment.

Unsolicited PRLO request is now handled by sending LS_ACC,
and then relogin to the remote port if an N-port login
session exists for that remote port.

Note that this patch should be applied on top of Joe Eykholt's
"Fix remote port restart problem" patch.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |   71 ++++++++++++++++++++++++++++++++++++-----
 include/scsi/fc/fc_els.h      |    9 +++++
 2 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e33c5c7..df85e19 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1573,30 +1573,85 @@ drop:
  * fc_rport_recv_prlo_req() - Handler for process logout (PRLO) requests
  * @rdata: The remote port that sent the PRLO request
  * @sp:	   The sequence that the PRLO was on
- * @fp:	   The PRLO request frame
+ * @rx_fp: The PRLO request frame
  *
  * Locking Note: The rport lock is exected to be held before calling
  * this function.
  */
 static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 				   struct fc_seq *sp,
-				   struct fc_frame *fp)
+				   struct fc_frame *rx_fp)
 {
 	struct fc_lport *lport = rdata->local_port;
-
 	struct fc_frame_header *fh;
+	struct fc_exch *ep;
+	struct fc_frame *fp;
+	struct {
+		struct fc_els_prlo prlo;
+		struct fc_els_spp spp;
+	} *pp;
+	struct fc_els_spp *rspp;	/* request service param page */
+	struct fc_els_spp *spp;		/* response spp */
+	unsigned int len;
+	unsigned int plen;
+	u32 f_ctl;
 	struct fc_seq_els_data rjt_data;
 
-	fh = fc_frame_header_get(fp);
+	rjt_data.fp = NULL;
+	fh = fc_frame_header_get(rx_fp);
 
 	FC_RPORT_DBG(rdata, "Received PRLO request while in state %s\n",
 		     fc_rport_state(rdata));
 
-	rjt_data.fp = NULL;
-	rjt_data.reason = ELS_RJT_UNAB;
-	rjt_data.explan = ELS_EXPL_NONE;
+	len = fr_len(rx_fp) - sizeof(*fh);
+	pp = fc_frame_payload_get(rx_fp, sizeof(*pp));
+	if (!pp)
+		goto reject_len;
+	plen = ntohs(pp->prlo.prlo_len);
+	if (plen != 20)
+		goto reject_len;
+	if (plen < len)
+		len = plen;
+
+	rspp = &pp->spp;
+
+	fp = fc_frame_alloc(lport, len);
+	if (!fp) {
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
+		goto reject;
+	}
+
+	sp = lport->tt.seq_start_next(sp);
+	WARN_ON(!sp);
+	pp = fc_frame_payload_get(fp, len);
+	WARN_ON(!pp);
+	memset(pp, 0, len);
+	pp->prlo.prlo_cmd = ELS_LS_ACC;
+	pp->prlo.prlo_obs = 0x10;
+	pp->prlo.prlo_len = htons(len);
+	spp = &pp->spp;
+	spp->spp_type = rspp->spp_type;
+	spp->spp_type_ext = rspp->spp_type_ext;
+	spp->spp_flags = FC_SPP_RESP_ACK;
+
+	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
+
+	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ;
+	f_ctl |= FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+	ep = fc_seq_exch(sp);
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+		       FC_TYPE_ELS, f_ctl, 0);
+	lport->tt.seq_send(lport, sp, fp);
+	goto drop;
+
+reject_len:
+	rjt_data.reason = ELS_RJT_PROT;
+	rjt_data.explan = ELS_EXPL_INV_LEN;
+reject:
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
-	fc_frame_free(fp);
+drop:
+	fc_frame_free(rx_fp);
 }
 
 /**
diff --git a/include/scsi/fc/fc_els.h b/include/scsi/fc/fc_els.h
index f943281..70a7e92 100644
--- a/include/scsi/fc/fc_els.h
+++ b/include/scsi/fc/fc_els.h
@@ -405,6 +405,15 @@ struct fc_els_prli {
 };
 
 /*
+ * ELS_PRLO - Process logout request and response.
+ */
+struct fc_els_prlo {
+	__u8            prlo_cmd;       /* command */
+	__u8            prlo_obs;       /* obsolete, but shall be set to 10h */
+	__be16          prlo_len;       /* payload length */
+};
+
+/*
  * ELS_ADISC payload
  */
 struct fc_els_adisc {

