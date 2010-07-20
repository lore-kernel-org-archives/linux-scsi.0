From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/28] libfc: add FLOGI state to rport for VN2VN
Date: Tue, 20 Jul 2010 15:20:08 -0700
Message-ID: <20100720222008.17116.60441.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717Ab0GTWUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:11 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

The FIP proposal for VN_port to VN_port point-to-multipoint
operation requires a FLOGI be sent to each remote port.
The FLOGI is sent with the assigned S_ID and D_IDs of the
local and remote ports.  This and the response get
FIP-encapsulated for Ethernet.

Add FLOGI state to the remote port state machine.
This will be skipped if not in point-to-multipoint mode.

To reduce a little duplication between PLOGI and FLOGI
response handling, added fc_rport_login_complete(), which
handles the parameters for the rdata struct.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |    4 -
 drivers/scsi/libfc/fc_rport.c |  290 +++++++++++++++++++++++++++++++++++++++--
 include/scsi/fc/fc_els.h      |    2 
 include/scsi/libfc.h          |    4 +
 4 files changed, 286 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index f7bff2c..ec9850c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -906,10 +906,10 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 		recv = lport->tt.rport_recv_req;
 		switch (fc_frame_payload_op(fp)) {
 		case ELS_FLOGI:
-			recv = fc_lport_recv_flogi_req;
+			if (!lport->point_to_multipoint)
+				recv = fc_lport_recv_flogi_req;
 			break;
 		case ELS_LOGO:
-			fh = fc_frame_header_get(fp);
 			if (ntoh24(fh->fh_s_id) == FC_FID_FLOGI)
 				recv = fc_lport_recv_logo_req;
 			break;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6d68482..4d6adf2 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -60,6 +60,7 @@
 
 struct workqueue_struct *rport_event_queue;
 
+static void fc_rport_enter_flogi(struct fc_rport_priv *);
 static void fc_rport_enter_plogi(struct fc_rport_priv *);
 static void fc_rport_enter_prli(struct fc_rport_priv *);
 static void fc_rport_enter_rtv(struct fc_rport_priv *);
@@ -82,6 +83,8 @@ static void fc_rport_work(struct work_struct *);
 
 static const char *fc_rport_state_names[] = {
 	[RPORT_ST_INIT] = "Init",
+	[RPORT_ST_FLOGI] = "FLOGI",
+	[RPORT_ST_PLOGI_WAIT] = "PLOGI_WAIT",
 	[RPORT_ST_PLOGI] = "PLOGI",
 	[RPORT_ST_PRLI] = "PRLI",
 	[RPORT_ST_RTV] = "RTV",
@@ -207,7 +210,7 @@ EXPORT_SYMBOL(fc_set_rport_loss_tmo);
 /**
  * fc_plogi_get_maxframe() - Get the maximum payload from the common service
  *			     parameters in a FLOGI frame
- * @flp:    The FLOGI payload
+ * @flp:    The FLOGI or PLOGI payload
  * @maxval: The maximum frame size upper limit; this may be less than what
  *	    is in the service parameters
  */
@@ -344,7 +347,7 @@ static void fc_rport_work(struct work_struct *work)
 				rdata->major_retries++;
 				rdata->event = RPORT_EV_NONE;
 				FC_RPORT_DBG(rdata, "work restart\n");
-				fc_rport_enter_plogi(rdata);
+				fc_rport_enter_flogi(rdata);
 				mutex_unlock(&rdata->rp_mutex);
 			} else {
 				FC_RPORT_DBG(rdata, "work delete\n");
@@ -397,7 +400,7 @@ int fc_rport_login(struct fc_rport_priv *rdata)
 		break;
 	default:
 		FC_RPORT_DBG(rdata, "Login to port\n");
-		fc_rport_enter_plogi(rdata);
+		fc_rport_enter_flogi(rdata);
 		break;
 	}
 	mutex_unlock(&rdata->rp_mutex);
@@ -499,6 +502,9 @@ static void fc_rport_timeout(struct work_struct *work)
 	mutex_lock(&rdata->rp_mutex);
 
 	switch (rdata->rp_state) {
+	case RPORT_ST_FLOGI:
+		fc_rport_enter_flogi(rdata);
+		break;
 	case RPORT_ST_PLOGI:
 		fc_rport_enter_plogi(rdata);
 		break;
@@ -514,6 +520,7 @@ static void fc_rport_timeout(struct work_struct *work)
 	case RPORT_ST_ADISC:
 		fc_rport_enter_adisc(rdata);
 		break;
+	case RPORT_ST_PLOGI_WAIT:
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
 	case RPORT_ST_DELETE:
@@ -538,6 +545,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 		     fc_rport_state(rdata), rdata->retries);
 
 	switch (rdata->rp_state) {
+	case RPORT_ST_FLOGI:
 	case RPORT_ST_PLOGI:
 	case RPORT_ST_LOGO:
 		rdata->flags &= ~FC_RP_STARTED;
@@ -550,6 +558,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 	case RPORT_ST_ADISC:
 		fc_rport_enter_logo(rdata);
 		break;
+	case RPORT_ST_PLOGI_WAIT:
 	case RPORT_ST_DELETE:
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
@@ -592,7 +601,260 @@ static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 }
 
 /**
- * fc_rport_plogi_recv_resp() - Handler for ELS PLOGI responses
+ * fc_rport_login_complete() - Handle parameters and completion of p-mp login.
+ * @rdata:  The remote port which we logged into or which logged into us.
+ * @fp:     The FLOGI or PLOGI request or response frame
+ *
+ * Returns non-zero error if a problem is detected with the frame.
+ * Does not free the frame.
+ *
+ * This is only used in point-to-multipoint mode for FIP currently.
+ */
+static int fc_rport_login_complete(struct fc_rport_priv *rdata,
+				   struct fc_frame *fp)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_els_flogi *flogi;
+	unsigned int e_d_tov;
+	u16 csp_flags;
+
+	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
+	if (!flogi)
+		return -EINVAL;
+
+	csp_flags = ntohs(flogi->fl_csp.sp_features);
+
+	if (fc_frame_payload_op(fp) == ELS_FLOGI) {
+		if (csp_flags & FC_SP_FT_FPORT) {
+			FC_RPORT_DBG(rdata, "Fabric bit set in FLOGI\n");
+			return -EINVAL;
+		}
+	} else {
+
+		/*
+		 * E_D_TOV is not valid on an incoming FLOGI request.
+		 */
+		e_d_tov = ntohl(flogi->fl_csp.sp_e_d_tov);
+		if (csp_flags & FC_SP_FT_EDTR)
+			e_d_tov /= 1000000;
+		if (e_d_tov > rdata->e_d_tov)
+			rdata->e_d_tov = e_d_tov;
+	}
+	rdata->maxframe_size = fc_plogi_get_maxframe(flogi, lport->mfs);
+	return 0;
+}
+
+/**
+ * fc_rport_flogi_resp() - Handle response to FLOGI request for p-mp mode
+ * @sp:	    The sequence that the FLOGI was on
+ * @fp:	    The FLOGI response frame
+ * @rp_arg: The remote port that received the FLOGI response
+ */
+void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
+			 void *rp_arg)
+{
+	struct fc_rport_priv *rdata = rp_arg;
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_els_flogi *flogi;
+	unsigned int r_a_tov;
+
+	FC_RPORT_DBG(rdata, "Received a FLOGI %s\n", fc_els_resp_type(fp));
+
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		return;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	if (rdata->rp_state != RPORT_ST_FLOGI) {
+		FC_RPORT_DBG(rdata, "Received a FLOGI response, but in state "
+			     "%s\n", fc_rport_state(rdata));
+		if (IS_ERR(fp))
+			goto err;
+		goto out;
+	}
+
+	if (IS_ERR(fp)) {
+		fc_rport_error(rdata, fp);
+		goto err;
+	}
+
+	if (fc_frame_payload_op(fp) != ELS_LS_ACC)
+		goto bad;
+	if (fc_rport_login_complete(rdata, fp))
+		goto bad;
+
+	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
+	if (!flogi)
+		goto bad;
+	r_a_tov = ntohl(flogi->fl_csp.sp_r_a_tov);
+	if (r_a_tov > rdata->r_a_tov)
+		rdata->r_a_tov = r_a_tov;
+
+	if (rdata->ids.port_name < lport->wwpn)
+		fc_rport_enter_plogi(rdata);
+	else
+		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&rdata->rp_mutex);
+	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+	return;
+bad:
+	FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
+	fc_rport_error_retry(rdata, fp);
+	goto out;
+}
+
+/**
+ * fc_rport_enter_flogi() - Send a FLOGI request to the remote port for p-mp
+ * @rdata: The remote port to send a FLOGI to
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_flogi(struct fc_rport_priv *rdata)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+
+	if (!lport->point_to_multipoint)
+		return fc_rport_enter_plogi(rdata);
+
+	FC_RPORT_DBG(rdata, "Entered FLOGI state from %s state\n",
+		     fc_rport_state(rdata));
+
+	fc_rport_state_enter(rdata, RPORT_ST_FLOGI);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
+	if (!fp)
+		return fc_rport_error_retry(rdata, fp);
+
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_FLOGI,
+				  fc_rport_flogi_resp, rdata,
+				  2 * lport->r_a_tov))
+		fc_rport_error_retry(rdata, NULL);
+	else
+		kref_get(&rdata->kref);
+}
+
+/**
+ * fc_rport_recv_flogi_req() - Handle Fabric Login (FLOGI) request in p-mp mode
+ * @lport: The local port that received the PLOGI request
+ * @sp:	   The sequence that the PLOGI request was on
+ * @rx_fp: The PLOGI request frame
+ */
+static void fc_rport_recv_flogi_req(struct fc_lport *lport,
+				    struct fc_seq *sp, struct fc_frame *rx_fp)
+{
+	struct fc_disc *disc;
+	struct fc_els_flogi *flp;
+	struct fc_rport_priv *rdata;
+	struct fc_frame *fp = rx_fp;
+	struct fc_exch *ep;
+	struct fc_frame_header *fh;
+	struct fc_seq_els_data rjt_data;
+	u32 sid, f_ctl;
+
+	rjt_data.fp = NULL;
+	fh = fc_frame_header_get(fp);
+	sid = ntoh24(fh->fh_s_id);
+
+	FC_RPORT_ID_DBG(lport, sid, "Received FLOGI request\n");
+
+	disc = &lport->disc;
+	mutex_lock(&disc->disc_mutex);
+
+	if (!lport->point_to_multipoint) {
+		rjt_data.reason = ELS_RJT_UNSUP;
+		rjt_data.explan = ELS_EXPL_NONE;
+		goto reject;
+	}
+
+	flp = fc_frame_payload_get(fp, sizeof(*flp));
+	if (!flp) {
+		rjt_data.reason = ELS_RJT_LOGIC;
+		rjt_data.explan = ELS_EXPL_INV_LEN;
+		goto reject;
+	}
+
+	rdata = lport->tt.rport_lookup(lport, sid);
+	if (!rdata) {
+		rjt_data.reason = ELS_RJT_FIP;
+		rjt_data.explan = ELS_EXPL_NOT_NEIGHBOR;
+		goto reject;
+	}
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_RPORT_DBG(rdata, "Received FLOGI in %s state\n",
+		     fc_rport_state(rdata));
+
+	switch (rdata->rp_state) {
+	case RPORT_ST_INIT:
+	case RPORT_ST_LOGO:
+	case RPORT_ST_DELETE:
+		mutex_unlock(&rdata->rp_mutex);
+		rjt_data.reason = ELS_RJT_FIP;
+		rjt_data.explan = ELS_EXPL_NOT_NEIGHBOR;
+		goto reject;
+	case RPORT_ST_FLOGI:
+	case RPORT_ST_PLOGI_WAIT:
+	case RPORT_ST_PLOGI:
+		break;
+	case RPORT_ST_PRLI:
+	case RPORT_ST_RTV:
+	case RPORT_ST_READY:
+	case RPORT_ST_ADISC:
+		/*
+		 * Set the remote port to be deleted and to then restart.
+		 * This queues work to be sure exchanges are reset.
+		 */
+		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
+		mutex_unlock(&rdata->rp_mutex);
+		rjt_data.reason = ELS_RJT_BUSY;
+		rjt_data.explan = ELS_EXPL_NONE;
+		goto reject;
+	}
+	if (fc_rport_login_complete(rdata, fp)) {
+		mutex_unlock(&rdata->rp_mutex);
+		rjt_data.reason = ELS_RJT_LOGIC;
+		rjt_data.explan = ELS_EXPL_NONE;
+		goto reject;
+	}
+	fc_frame_free(rx_fp);
+
+	fp = fc_frame_alloc(lport, sizeof(*flp));
+	if (!fp)
+		goto out;
+
+	sp = lport->tt.seq_start_next(sp);
+	fc_flogi_fill(lport, fp);
+	flp = fc_frame_payload_get(fp, sizeof(*flp));
+	flp->fl_cmd = ELS_LS_ACC;
+
+	f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT;
+	ep = fc_seq_exch(sp);
+	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+		       FC_TYPE_ELS, f_ctl, 0);
+	lport->tt.seq_send(lport, sp, fp);
+
+	if (rdata->ids.port_name < lport->wwpn)
+		fc_rport_enter_plogi(rdata);
+	else
+		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
+out:
+	mutex_unlock(&rdata->rp_mutex);
+	mutex_unlock(&disc->disc_mutex);
+	return;
+
+reject:
+	mutex_unlock(&disc->disc_mutex);
+	lport->tt.seq_els_rsp_send(sp, ELS_LS_RJT, &rjt_data);
+	fc_frame_free(fp);
+}
+
+/**
+ * fc_rport_plogi_resp() - Handler for ELS PLOGI responses
  * @sp:	       The sequence the PLOGI is on
  * @fp:	       The PLOGI response frame
  * @rdata_arg: The remote port that sent the PLOGI response
@@ -607,7 +869,6 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_rport_priv *rdata = rdata_arg;
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_els_flogi *plp = NULL;
-	unsigned int tov;
 	u16 csp_seq;
 	u16 cssp_seq;
 	u8 op;
@@ -635,11 +896,8 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		rdata->ids.port_name = get_unaligned_be64(&plp->fl_wwpn);
 		rdata->ids.node_name = get_unaligned_be64(&plp->fl_wwnn);
 
-		tov = ntohl(plp->fl_csp.sp_e_d_tov);
-		if (ntohs(plp->fl_csp.sp_features) & FC_SP_FT_EDTR)
-			tov /= 1000000;
-		if (tov > rdata->e_d_tov)
-			rdata->e_d_tov = tov;
+		if (lport->point_to_multipoint)
+			fc_rport_login_complete(rdata, fp);
 		csp_seq = ntohs(plp->fl_csp.sp_tot_seq);
 		cssp_seq = ntohs(plp->fl_cssp[3 - 1].cp_con_seq);
 		if (cssp_seq < csp_seq)
@@ -677,6 +935,7 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 	rdata->maxframe_size = FC_MIN_MAX_PAYLOAD;
 	fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
 	if (!fp) {
+		FC_RPORT_DBG(rdata, "%s frame alloc failed\n", __func__);
 		fc_rport_error_retry(rdata, fp);
 		return;
 	}
@@ -1041,7 +1300,7 @@ static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
 	    get_unaligned_be64(&adisc->adisc_wwpn) != rdata->ids.port_name ||
 	    get_unaligned_be64(&adisc->adisc_wwnn) != rdata->ids.node_name) {
 		FC_RPORT_DBG(rdata, "ADISC error or mismatch\n");
-		fc_rport_enter_plogi(rdata);
+		fc_rport_enter_flogi(rdata);
 	} else {
 		FC_RPORT_DBG(rdata, "ADISC OK\n");
 		fc_rport_enter_ready(rdata);
@@ -1291,12 +1550,15 @@ void fc_rport_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_seq_els_data els_data;
 
 	/*
-	 * Handle PLOGI and LOGO requests separately, since they
+	 * Handle FLOGI, PLOGI and LOGO requests separately, since they
 	 * don't require prior login.
 	 * Check for unsupported opcodes first and reject them.
 	 * For some ops, it would be incorrect to reject with "PLOGI required".
 	 */
 	switch (fc_frame_payload_op(fp)) {
+	case ELS_FLOGI:
+		fc_rport_recv_flogi_req(lport, sp, fp);
+		break;
 	case ELS_PLOGI:
 		fc_rport_recv_plogi_req(lport, sp, fp);
 		break;
@@ -1386,6 +1648,9 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	case RPORT_ST_INIT:
 		FC_RPORT_DBG(rdata, "Received PLOGI in INIT state\n");
 		break;
+	case RPORT_ST_PLOGI_WAIT:
+		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI_WAIT state\n");
+		break;
 	case RPORT_ST_PLOGI:
 		FC_RPORT_DBG(rdata, "Received PLOGI in PLOGI state\n");
 		if (rdata->ids.port_name < lport->wwpn) {
@@ -1403,6 +1668,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 			     "- ignored for now\n", rdata->rp_state);
 		/* XXX TBD - should reset */
 		break;
+	case RPORT_ST_FLOGI:
 	case RPORT_ST_DELETE:
 	case RPORT_ST_LOGO:
 		FC_RPORT_DBG(rdata, "Received PLOGI in state %s - send busy\n",
diff --git a/include/scsi/fc/fc_els.h b/include/scsi/fc/fc_els.h
index 70a7e92..481abbd 100644
--- a/include/scsi/fc/fc_els.h
+++ b/include/scsi/fc/fc_els.h
@@ -191,6 +191,7 @@ enum fc_els_rjt_reason {
 	ELS_RJT_UNAB =		0x09,	/* unable to perform command request */
 	ELS_RJT_UNSUP =		0x0b,	/* command not supported */
 	ELS_RJT_INPROG =	0x0e,	/* command already in progress */
+	ELS_RJT_FIP =		0x20,	/* FIP error */
 	ELS_RJT_VENDOR =	0xff,	/* vendor specific error */
 };
 
@@ -212,6 +213,7 @@ enum fc_els_rjt_explan {
 	ELS_EXPL_UNAB_DATA =	0x2a,	/* unable to supply requested data */
 	ELS_EXPL_UNSUPR =	0x2c,	/* Request not supported */
 	ELS_EXPL_INV_LEN =	0x2d,	/* Invalid payload length */
+	ELS_EXPL_NOT_NEIGHBOR = 0x62,	/* VN2VN_Port not in neighbor set */
 	/* TBD - above definitions incomplete */
 };
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index bd05605..24b91c9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -97,6 +97,8 @@ enum fc_disc_event {
 /**
  * enum fc_rport_state - Remote port states
  * @RPORT_ST_INIT:    Initialized
+ * @RPORT_ST_FLOGI:   Waiting for FLOGI completion for point-to-multipoint
+ * @RPORT_ST_PLOGI_WAIT:   Waiting for peer to login for point-to-multipoint
  * @RPORT_ST_PLOGI:   Waiting for PLOGI completion
  * @RPORT_ST_PRLI:    Waiting for PRLI completion
  * @RPORT_ST_RTV:     Waiting for RTV completion
@@ -107,6 +109,8 @@ enum fc_disc_event {
 */
 enum fc_rport_state {
 	RPORT_ST_INIT,
+	RPORT_ST_FLOGI,
+	RPORT_ST_PLOGI_WAIT,
 	RPORT_ST_PLOGI,
 	RPORT_ST_PRLI,
 	RPORT_ST_RTV,

