From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/24] libfc: use error code for fc_rport_error()
Date: Thu, 13 Oct 2016 15:10:44 +0200
Message-ID: <1476364260-12191-9-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755517AbcJMNXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:46 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We only ever use the 'fp' argument for fc_rport_error() to
encapsulate the error code, so we can as well do away with that
and pass the error directly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 101 +++++++++++++++++++++++++-----------------
 include/scsi/libfc.h          |   5 +++
 2 files changed, 66 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 3d2baba..d2d8607 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -87,8 +87,8 @@
 static void fc_rport_recv_prlo_req(struct fc_rport_priv *, struct fc_frame *);
 static void fc_rport_recv_logo_req(struct fc_lport *, struct fc_frame *);
 static void fc_rport_timeout(struct work_struct *);
-static void fc_rport_error(struct fc_rport_priv *, struct fc_frame *);
-static void fc_rport_error_retry(struct fc_rport_priv *, struct fc_frame *);
+static void fc_rport_error(struct fc_rport_priv *, int);
+static void fc_rport_error_retry(struct fc_rport_priv *, int);
 static void fc_rport_work(struct work_struct *);
 
 static const char *fc_rport_state_names[] = {
@@ -604,20 +604,19 @@ static void fc_rport_timeout(struct work_struct *work)
 /**
  * fc_rport_error() - Error handler, called once retries have been exhausted
  * @rdata: The remote port the error is happened on
- * @fp:	   The error code encapsulated in a frame pointer
+ * @err:   The error code
  *
  * Locking Note: The rport lock is expected to be held before
  * calling this routine
  *
  * Reference counting: does not modify kref
  */
-static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
+static void fc_rport_error(struct fc_rport_priv *rdata, int err)
 {
 	struct fc_lport *lport = rdata->local_port;
 
-	FC_RPORT_DBG(rdata, "Error %ld in state %s, retries %d\n",
-		     IS_ERR(fp) ? -PTR_ERR(fp) : 0,
-		     fc_rport_state(rdata), rdata->retries);
+	FC_RPORT_DBG(rdata, "Error %d in state %s, retries %d\n",
+		     -err, fc_rport_state(rdata), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_FLOGI:
@@ -649,7 +648,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 /**
  * fc_rport_error_retry() - Handler for remote port state retries
  * @rdata: The remote port whose state is to be retried
- * @fp:	   The error code encapsulated in a frame pointer
+ * @err:   The error code
  *
  * If the error was an exchange timeout retry immediately,
  * otherwise wait for E_D_TOV.
@@ -659,22 +658,21 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
  *
  * Reference counting: increments kref when scheduling retry_work
  */
-static void fc_rport_error_retry(struct fc_rport_priv *rdata,
-				 struct fc_frame *fp)
+static void fc_rport_error_retry(struct fc_rport_priv *rdata, int err)
 {
 	unsigned long delay = msecs_to_jiffies(rdata->e_d_tov);
 	struct fc_lport *lport = rdata->local_port;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
-	if (PTR_ERR(fp) == -FC_EX_CLOSED)
+	if (err == -FC_EX_CLOSED)
 		goto out;
 
 	if (rdata->retries < rdata->local_port->max_rport_retry_count) {
-		FC_RPORT_DBG(rdata, "Error %ld in state %s, retrying\n",
-			     PTR_ERR(fp), fc_rport_state(rdata));
+		FC_RPORT_DBG(rdata, "Error %d in state %s, retrying\n",
+			     err, fc_rport_state(rdata));
 		rdata->retries++;
 		/* no additional delay on exchange timeouts */
-		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
+		if (err == -FC_EX_TIMEOUT)
 			delay = 0;
 		kref_get(&rdata->kref);
 		if (!schedule_delayed_work(&rdata->retry_work, delay))
@@ -683,7 +681,7 @@ static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 	}
 
 out:
-	fc_rport_error(rdata, fp);
+	fc_rport_error(rdata, err);
 }
 
 /**
@@ -743,8 +741,11 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_els_flogi *flogi;
 	unsigned int r_a_tov;
+	u8 opcode;
+	int err = 0;
 
-	FC_RPORT_DBG(rdata, "Received a FLOGI %s\n", fc_els_resp_type(fp));
+	FC_RPORT_DBG(rdata, "Received a FLOGI %s\n",
+		     IS_ERR(fp) ? "error" : fc_els_resp_type(fp));
 
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		goto put;
@@ -760,18 +761,32 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error(rdata, fp);
+		fc_rport_error(rdata, PTR_ERR(fp));
 		goto err;
 	}
+	opcode = fc_frame_payload_op(fp);
+	if (opcode == ELS_LS_RJT) {
+		struct fc_els_ls_rjt *rjt;
 
-	if (fc_frame_payload_op(fp) != ELS_LS_ACC)
+		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+		FC_RPORT_DBG(rdata, "FLOGI ELS rejected, reason %x expl %x\n",
+			     rjt->er_reason, rjt->er_explan);
+		err = -FC_EX_ELS_RJT;
+		goto bad;
+	} else if (opcode != ELS_LS_ACC) {
+		FC_RPORT_DBG(rdata, "FLOGI ELS invalid opcode %x\n", opcode);
+		err = -FC_EX_ELS_RJT;
 		goto bad;
-	if (fc_rport_login_complete(rdata, fp))
+	}
+	if (fc_rport_login_complete(rdata, fp)) {
+		FC_RPORT_DBG(rdata, "FLOGI failed, no login\n");
+		err = -FC_EX_INV_LOGIN;
 		goto bad;
+	}
 
 	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
 	if (!flogi) {
-		FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
+		err = -FC_EX_ALLOC_ERR;
 		goto bad;
 	}
 	r_a_tov = ntohl(flogi->fl_csp.sp_r_a_tov);
@@ -790,7 +805,8 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 	return;
 bad:
-	fc_rport_error_retry(rdata, fp);
+	FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
+	fc_rport_error_retry(rdata, err);
 	goto out;
 }
 
@@ -818,13 +834,13 @@ static void fc_rport_enter_flogi(struct fc_rport_priv *rdata)
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp)
-		return fc_rport_error_retry(rdata, fp);
+		return fc_rport_error_retry(rdata, -FC_EX_ALLOC_ERR);
 
 	kref_get(&rdata->kref);
 	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_FLOGI,
 				  fc_rport_flogi_resp, rdata,
 				  2 * lport->r_a_tov)) {
-		fc_rport_error_retry(rdata, NULL);
+		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
 }
@@ -991,7 +1007,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rdata, fp);
+		fc_rport_error_retry(rdata, PTR_ERR(fp));
 		goto err;
 	}
 
@@ -1013,9 +1029,14 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rdata->max_seq = csp_seq;
 		rdata->maxframe_size = fc_plogi_get_maxframe(plp, lport->mfs);
 		fc_rport_enter_prli(rdata);
-	} else
-		fc_rport_error_retry(rdata, fp);
+	} else {
+		struct fc_els_ls_rjt *rjt;
 
+		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+		FC_RPORT_DBG(rdata, "PLOGI ELS rejected, reason %x expl %x\n",
+			     rjt->er_reason, rjt->er_explan);
+		fc_rport_error_retry(rdata, -FC_EX_ELS_RJT);
+	}
 out:
 	fc_frame_free(fp);
 err:
@@ -1067,7 +1088,7 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp) {
 		FC_RPORT_DBG(rdata, "%s frame alloc failed\n", __func__);
-		fc_rport_error_retry(rdata, fp);
+		fc_rport_error_retry(rdata, -FC_EX_ALLOC_ERR);
 		return;
 	}
 	rdata->e_d_tov = lport->e_d_tov;
@@ -1076,7 +1097,7 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_PLOGI,
 				  fc_rport_plogi_resp, rdata,
 				  2 * lport->r_a_tov)) {
-		fc_rport_error_retry(rdata, NULL);
+		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
 }
@@ -1123,7 +1144,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rdata, fp);
+		fc_rport_error_retry(rdata, PTR_ERR(fp));
 		goto err;
 	}
 
@@ -1142,9 +1163,9 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
-				fc_rport_error(rdata, fp);
+				fc_rport_error(rdata, -FC_EX_SEQ_ERR);
 			else
-				fc_rport_error_retry(rdata, fp);
+				fc_rport_error_retry(rdata, -FC_EX_SEQ_ERR);
 			goto out;
 		}
 		if (pp->prli.prli_spp_len < sizeof(pp->spp))
@@ -1176,7 +1197,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
 			     rjt->er_reason, rjt->er_explan);
-		fc_rport_error_retry(rdata, NULL);
+		fc_rport_error_retry(rdata, FC_EX_ELS_RJT);
 	}
 
 out:
@@ -1222,7 +1243,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 
 	fp = fc_frame_alloc(lport, sizeof(*pp));
 	if (!fp) {
-		fc_rport_error_retry(rdata, fp);
+		fc_rport_error_retry(rdata, -FC_EX_ALLOC_ERR);
 		return;
 	}
 
@@ -1241,7 +1262,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 	kref_get(&rdata->kref);
 	if (!lport->tt.exch_seq_send(lport, fp, fc_rport_prli_resp,
 				     NULL, rdata, 2 * lport->r_a_tov)) {
-		fc_rport_error_retry(rdata, NULL);
+		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
 }
@@ -1280,7 +1301,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error(rdata, fp);
+		fc_rport_error(rdata, PTR_ERR(fp));
 		goto err;
 	}
 
@@ -1339,7 +1360,7 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_rtv));
 	if (!fp) {
-		fc_rport_error_retry(rdata, fp);
+		fc_rport_error_retry(rdata, -FC_EX_ALLOC_ERR);
 		return;
 	}
 
@@ -1347,7 +1368,7 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_RTV,
 				  fc_rport_rtv_resp, rdata,
 				  2 * lport->r_a_tov)) {
-		fc_rport_error_retry(rdata, NULL);
+		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
 }
@@ -1430,7 +1451,7 @@ static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	if (IS_ERR(fp)) {
-		fc_rport_error(rdata, fp);
+		fc_rport_error(rdata, PTR_ERR(fp));
 		goto err;
 	}
 
@@ -1480,14 +1501,14 @@ static void fc_rport_enter_adisc(struct fc_rport_priv *rdata)
 
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_adisc));
 	if (!fp) {
-		fc_rport_error_retry(rdata, fp);
+		fc_rport_error_retry(rdata, -FC_EX_ALLOC_ERR);
 		return;
 	}
 	kref_get(&rdata->kref);
 	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_ADISC,
 				  fc_rport_adisc_resp, rdata,
 				  2 * lport->r_a_tov)) {
-		fc_rport_error_retry(rdata, NULL);
+		fc_rport_error_retry(rdata, -FC_EX_XMIT_ERR);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 	}
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7428a53..dc42d80 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -44,6 +44,11 @@
 #define	FC_NO_ERR	0	/* no error */
 #define	FC_EX_TIMEOUT	1	/* Exchange timeout */
 #define	FC_EX_CLOSED	2	/* Exchange closed */
+#define FC_EX_ALLOC_ERR	3	/* Exchange allocation failed */
+#define FC_EX_XMIT_ERR	4	/* Exchange transmit failed */
+#define FC_EX_ELS_RJT	5	/* ELS rejected */
+#define FC_EX_INV_LOGIN	6	/* Login not completed */
+#define FC_EX_SEQ_ERR	6	/* Exchange sequence error */
 
 /**
  * enum fc_lport_state - Local port states
-- 
1.8.5.6

