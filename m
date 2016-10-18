From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/20] libfc: Replace ->exch_seq_send callback with function call
Date: Tue, 18 Oct 2016 10:01:38 +0200
Message-ID: <1476777714-3543-5-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47269 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752363AbcJRIC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:26 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->exch_seq_send callback only ever had one implementation,
so we can call the function directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_elsct.c |  2 +-
 drivers/scsi/libfc/fc_exch.c  | 37 ++++++++++++++++++++++++++-----------
 drivers/scsi/libfc/fc_fcp.c   | 11 +++++------
 drivers/scsi/libfc/fc_lport.c |  8 ++++----
 drivers/scsi/libfc/fc_rport.c |  4 ++--
 include/scsi/libfc.h          | 38 +++++++-------------------------------
 6 files changed, 45 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index c2384d5..6384a98 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -67,7 +67,7 @@ struct fc_seq *fc_elsct_send(struct fc_lport *lport, u32 did,
 	fc_fill_fc_hdr(fp, r_ctl, did, lport->port_id, fh_type,
 		       FC_FCTL_REQ, 0);
 
-	return lport->tt.exch_seq_send(lport, fp, resp, NULL, arg, timer_msec);
+	return fc_exch_seq_send(lport, fp, resp, NULL, arg, timer_msec);
 }
 EXPORT_SYMBOL(fc_elsct_send);
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index cc320a9..f5c3c1d 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2127,6 +2127,24 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
  * @arg:	The argument to be passed to the response handler
  * @timer_msec: The timeout period for the exchange
  *
+ * The exchange response handler is set in this routine to resp()
+ * function pointer. It can be called in two scenarios: if a timeout
+ * occurs or if a response frame is received for the exchange. The
+ * fc_frame pointer in response handler will also indicate timeout
+ * as error using IS_ERR related macros.
+ *
+ * The exchange destructor handler is also set in this routine.
+ * The destructor handler is invoked by EM layer when exchange
+ * is about to free, this can be used by caller to free its
+ * resources along with exchange free.
+ *
+ * The arg is passed back to resp and destructor handler.
+ *
+ * The timeout value (in msec) for an exchange is set if non zero
+ * timer_msec argument is specified. The timer is canceled when
+ * it fires or when the exchange is done. The exchange timeout handler
+ * is registered by EM layer.
+ *
  * The frame pointer with some of the header's fields must be
  * filled before calling this routine, those fields are:
  *
@@ -2137,14 +2155,13 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
  * - frame control
  * - parameter or relative offset
  */
-static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
-				       struct fc_frame *fp,
-				       void (*resp)(struct fc_seq *,
-						    struct fc_frame *fp,
-						    void *arg),
-				       void (*destructor)(struct fc_seq *,
-							  void *),
-				       void *arg, u32 timer_msec)
+struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
+				struct fc_frame *fp,
+				void (*resp)(struct fc_seq *,
+					     struct fc_frame *fp,
+					     void *arg),
+				void (*destructor)(struct fc_seq *, void *),
+				void *arg, u32 timer_msec)
 {
 	struct fc_exch *ep;
 	struct fc_seq *sp = NULL;
@@ -2197,6 +2214,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 		fc_exch_delete(ep);
 	return NULL;
 }
+EXPORT_SYMBOL(fc_exch_seq_send);
 
 /**
  * fc_exch_rrq() - Send an ELS RRQ (Reinstate Recovery Qualifier) command
@@ -2630,9 +2648,6 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_set_resp)
 		lport->tt.seq_set_resp = fc_seq_set_resp;
 
-	if (!lport->tt.exch_seq_send)
-		lport->tt.exch_seq_send = fc_exch_seq_send;
-
 	if (!lport->tt.seq_send)
 		lport->tt.seq_send = fc_seq_send;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 831de3e..5cf1d2e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -196,7 +196,7 @@ static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
  * @seq: The sequence that the FCP packet is on (required by destructor API)
  * @fsp: The FCP packet to be released
  *
- * This routine is called by a destructor callback in the exch_seq_send()
+ * This routine is called by a destructor callback in the fc_exch_seq_send()
  * routine of the libfc Transport Template. The 'struct fc_seq' is a required
  * argument even though it is not used by this routine.
  *
@@ -1206,8 +1206,7 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 		       rpriv->local_port->port_id, FC_TYPE_FCP,
 		       FC_FCTL_REQ, 0);
 
-	seq = lport->tt.exch_seq_send(lport, fp, resp, fc_fcp_pkt_destroy,
-				      fsp, 0);
+	seq = fc_exch_seq_send(lport, fp, resp, fc_fcp_pkt_destroy, fsp, 0);
 	if (!seq) {
 		rc = -1;
 		goto unlock;
@@ -1757,9 +1756,9 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 		       rpriv->local_port->port_id, FC_TYPE_FCP,
 		       FC_FCTL_REQ, 0);
 
-	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp,
-				      fc_fcp_pkt_destroy,
-				      fsp, get_fsp_rec_tov(fsp));
+	seq = fc_exch_seq_send(lport, fp, fc_fcp_srr_resp,
+			       fc_fcp_pkt_destroy,
+			       fsp, get_fsp_rec_tov(fsp));
 	if (!seq)
 		goto retry;
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 42dcb72..1a4f176 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2006,8 +2006,8 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
 	info->nents = job->reply_payload.sg_cnt;
 	info->sg = job->reply_payload.sg_list;
 
-	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
-				     NULL, info, tov)) {
+	if (!fc_exch_seq_send(lport, fp, fc_lport_bsg_resp,
+			      NULL, info, tov)) {
 		kfree(info);
 		return -ECOMM;
 	}
@@ -2067,8 +2067,8 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
 	info->nents = job->reply_payload.sg_cnt;
 	info->sg = job->reply_payload.sg_list;
 
-	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
-				     NULL, info, tov)) {
+	if (!fc_exch_seq_send(lport, fp, fc_lport_bsg_resp,
+			      NULL, info, tov)) {
 		kfree(info);
 		return -ECOMM;
 	}
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 4ca0f40..d275df0 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1282,8 +1282,8 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
 	kref_get(&rdata->kref);
-	if (!lport->tt.exch_seq_send(lport, fp, fc_rport_prli_resp,
-				     NULL, rdata, 2 * lport->r_a_tov)) {
+	if (!fc_exch_seq_send(lport, fp, fc_rport_prli_resp,
+			      NULL, rdata, 2 * lport->r_a_tov)) {
 		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7bba81e..5e8a208 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -485,37 +485,6 @@ struct libfc_function_template {
 				     void *arg, u32 timer_msec);
 
 	/*
-	 * Send the FC frame payload using a new exchange and sequence.
-	 *
-	 * The exchange response handler is set in this routine to resp()
-	 * function pointer. It can be called in two scenarios: if a timeout
-	 * occurs or if a response frame is received for the exchange. The
-	 * fc_frame pointer in response handler will also indicate timeout
-	 * as error using IS_ERR related macros.
-	 *
-	 * The exchange destructor handler is also set in this routine.
-	 * The destructor handler is invoked by EM layer when exchange
-	 * is about to free, this can be used by caller to free its
-	 * resources along with exchange free.
-	 *
-	 * The arg is passed back to resp and destructor handler.
-	 *
-	 * The timeout value (in msec) for an exchange is set if non zero
-	 * timer_msec argument is specified. The timer is canceled when
-	 * it fires or when the exchange is done. The exchange timeout handler
-	 * is registered by EM layer.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	struct fc_seq *(*exch_seq_send)(struct fc_lport *, struct fc_frame *,
-					void (*resp)(struct fc_seq *,
-						     struct fc_frame *,
-						     void *),
-					void (*destructor)(struct fc_seq *,
-							   void *),
-					void *, unsigned int timer_msec);
-
-	/*
 	 * Sets up the DDP context for a given exchange id on the given
 	 * scatterlist if LLD supports DDP for large receive.
 	 *
@@ -1117,6 +1086,13 @@ void fc_fill_hdr(struct fc_frame *, const struct fc_frame *,
  *****************************/
 int fc_exch_init(struct fc_lport *);
 void fc_exch_update_stats(struct fc_lport *lport);
+struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
+				struct fc_frame *fp,
+				void (*resp)(struct fc_seq *,
+					     struct fc_frame *fp,
+					     void *arg),
+				void (*destructor)(struct fc_seq *, void *),
+				void *arg, u32 timer_msec);
 void fc_seq_els_rsp_send(struct fc_frame *, enum fc_els_cmd,
 			 struct fc_seq_els_data *);
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *,
-- 
1.8.5.6

