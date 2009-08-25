From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 60/64] libfc: use ADISC to verify rport login state
Date: Tue, 25 Aug 2009 14:03:47 -0700
Message-ID: <20090825210347.1553.10899.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbZHYVDp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:45 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When rport_login is called on an rport that is already thought
to be logged in, use ADISC.  If that fails, redo PLOGI.
This is less disruptive after fabric changes that don't affect
the state of the target.

Implement the sending of ADISC via fc_els_fill.

Add ADISC state to the rport state machine.  This is entered from READY
and returns to READY after successful completion.  If it fails, the rport
is either logged off and deleted or re-does PLOGI.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |  122 +++++++++++++++++++++++++++++++++++++++--
 include/scsi/fc_encode.h      |   21 +++++++
 include/scsi/libfc.h          |    1 
 3 files changed, 139 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b5bc872..c33e258 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -62,6 +62,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *);
 static void fc_rport_enter_rtv(struct fc_rport_priv *);
 static void fc_rport_enter_ready(struct fc_rport_priv *);
 static void fc_rport_enter_logo(struct fc_rport_priv *);
+static void fc_rport_enter_adisc(struct fc_rport_priv *);
 
 static void fc_rport_recv_plogi_req(struct fc_lport *,
 				    struct fc_seq *, struct fc_frame *);
@@ -83,6 +84,7 @@ static const char *fc_rport_state_names[] = {
 	[RPORT_ST_RTV] = "RTV",
 	[RPORT_ST_READY] = "Ready",
 	[RPORT_ST_LOGO] = "LOGO",
+	[RPORT_ST_ADISC] = "ADISC",
 	[RPORT_ST_DELETE] = "Delete",
 };
 
@@ -326,15 +328,25 @@ static void fc_rport_work(struct work_struct *work)
  * Locking Note: Called without the rport lock held. This
  * function will hold the rport lock, call an _enter_*
  * function and then unlock the rport.
+ *
+ * This indicates the intent to be logged into the remote port.
+ * If it appears we are already logged in, ADISC is used to verify
+ * the setup.
  */
 int fc_rport_login(struct fc_rport_priv *rdata)
 {
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rdata, "Login to port\n");
-
-	fc_rport_enter_plogi(rdata);
-
+	switch (rdata->rp_state) {
+	case RPORT_ST_READY:
+		FC_RPORT_DBG(rdata, "ADISC port\n");
+		fc_rport_enter_adisc(rdata);
+		break;
+	default:
+		FC_RPORT_DBG(rdata, "Login to port\n");
+		fc_rport_enter_plogi(rdata);
+		break;
+	}
 	mutex_unlock(&rdata->rp_mutex);
 
 	return 0;
@@ -448,6 +460,9 @@ static void fc_rport_timeout(struct work_struct *work)
 	case RPORT_ST_LOGO:
 		fc_rport_enter_logo(rdata);
 		break;
+	case RPORT_ST_ADISC:
+		fc_rport_enter_adisc(rdata);
+		break;
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
 	case RPORT_ST_DELETE:
@@ -473,13 +488,16 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
-	case RPORT_ST_PRLI:
 	case RPORT_ST_LOGO:
 		fc_rport_enter_delete(rdata, RPORT_EV_FAILED);
 		break;
 	case RPORT_ST_RTV:
 		fc_rport_enter_ready(rdata);
 		break;
+	case RPORT_ST_PRLI:
+	case RPORT_ST_ADISC:
+		fc_rport_enter_logo(rdata);
+		break;
 	case RPORT_ST_DELETE:
 	case RPORT_ST_READY:
 	case RPORT_ST_INIT:
@@ -907,6 +925,93 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 }
 
 /**
+ * fc_rport_els_adisc_resp() - Address Discovery response handler
+ * @sp: current sequence in the ADISC exchange
+ * @fp: response frame
+ * @rdata_arg: remote port private.
+ *
+ * Locking Note: This function will be called without the rport lock
+ * held, but it will lock, call an _enter_* function or fc_rport_error
+ * and then unlock the rport.
+ */
+static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
+			      void *rdata_arg)
+{
+	struct fc_rport_priv *rdata = rdata_arg;
+	struct fc_els_adisc *adisc;
+	u8 op;
+
+	mutex_lock(&rdata->rp_mutex);
+
+	FC_RPORT_DBG(rdata, "Received a ADISC response\n");
+
+	if (rdata->rp_state != RPORT_ST_ADISC) {
+		FC_RPORT_DBG(rdata, "Received a ADISC resp but in state %s\n",
+			     fc_rport_state(rdata));
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
+	/*
+	 * If address verification failed.  Consider us logged out of the rport.
+	 * Since the rport is still in discovery, we want to be
+	 * logged in, so go to PLOGI state.  Otherwise, go back to READY.
+	 */
+	op = fc_frame_payload_op(fp);
+	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
+	if (op != ELS_LS_ACC || !adisc ||
+	    ntoh24(adisc->adisc_port_id) != rdata->ids.port_id ||
+	    get_unaligned_be64(&adisc->adisc_wwpn) != rdata->ids.port_name ||
+	    get_unaligned_be64(&adisc->adisc_wwnn) != rdata->ids.node_name) {
+		FC_RPORT_DBG(rdata, "ADISC error or mismatch\n");
+		fc_rport_enter_plogi(rdata);
+	} else {
+		FC_RPORT_DBG(rdata, "ADISC OK\n");
+		fc_rport_enter_ready(rdata);
+	}
+out:
+	fc_frame_free(fp);
+err:
+	mutex_unlock(&rdata->rp_mutex);
+	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
+}
+
+/**
+ * fc_rport_enter_adisc() - Send Address Discover (ADISC) request to peer
+ * @rdata: remote port private data
+ *
+ * Locking Note: The rport lock is expected to be held before calling
+ * this routine.
+ */
+static void fc_rport_enter_adisc(struct fc_rport_priv *rdata)
+{
+	struct fc_lport *lport = rdata->local_port;
+	struct fc_frame *fp;
+
+	FC_RPORT_DBG(rdata, "sending ADISC from %s state\n",
+		     fc_rport_state(rdata));
+
+	fc_rport_state_enter(rdata, RPORT_ST_ADISC);
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_els_adisc));
+	if (!fp) {
+		fc_rport_error_retry(rdata, fp);
+		return;
+	}
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, ELS_ADISC,
+				  fc_rport_adisc_resp, rdata, lport->e_d_tov))
+		fc_rport_error_retry(rdata, fp);
+	else
+		kref_get(&rdata->kref);
+}
+
+/**
  * fc_rport_recv_els_req() - handle a validated ELS request.
  * @lport: Fibre Channel local port
  * @sp: current sequence in the PLOGI exchange
@@ -943,6 +1048,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport,
 	case RPORT_ST_PRLI:
 	case RPORT_ST_RTV:
 	case RPORT_ST_READY:
+	case RPORT_ST_ADISC:
 		break;
 	default:
 		mutex_unlock(&rdata->rp_mutex);
@@ -1095,6 +1201,10 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 		break;
 	case RPORT_ST_PRLI:
 	case RPORT_ST_READY:
+	case RPORT_ST_ADISC:
+		FC_RPORT_DBG(rdata, "Received PLOGI in logged-in state %d "
+			     "- ignored for now\n", rdata->rp_state);
+		/* XXX TBD - should reset */
 		break;
 	case RPORT_ST_DELETE:
 	default:
@@ -1178,6 +1288,7 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	case RPORT_ST_PRLI:
 	case RPORT_ST_RTV:
 	case RPORT_ST_READY:
+	case RPORT_ST_ADISC:
 		reason = ELS_RJT_NONE;
 		break;
 	default:
@@ -1283,6 +1394,7 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 			fc_rport_enter_ready(rdata);
 			break;
 		case RPORT_ST_READY:
+		case RPORT_ST_ADISC:
 			break;
 		default:
 			break;
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 24bf764..c5ee6bb 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -57,6 +57,23 @@ static inline void fc_fill_fc_hdr(struct fc_frame *fp, enum fc_rctl r_ctl,
 }
 
 /**
+ * fc_adisc_fill() - Fill in adisc request frame
+ * @lport: local port.
+ * @fp: fc frame where payload will be placed.
+ */
+static inline void fc_adisc_fill(struct fc_lport *lport, struct fc_frame *fp)
+{
+	struct fc_els_adisc *adisc;
+
+	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
+	memset(adisc, 0, sizeof(*adisc));
+	adisc->adisc_cmd = ELS_ADISC;
+	put_unaligned_be64(lport->wwpn, &adisc->adisc_wwpn);
+	put_unaligned_be64(lport->wwnn, &adisc->adisc_wwnn);
+	hton24(adisc->adisc_port_id, fc_host_port_id(lport->host));
+}
+
+/**
  * fc_ct_hdr_fill- fills ct header and reset ct payload
  * returns pointer to ct request.
  */
@@ -255,6 +272,10 @@ static inline int fc_els_fill(struct fc_lport *lport,
 		       enum fc_rctl *r_ctl, enum fc_fh_type *fh_type)
 {
 	switch (op) {
+	case ELS_ADISC:
+		fc_adisc_fill(lport, fp);
+		break;
+
 	case ELS_PLOGI:
 		fc_plogi_fill(lport, fp, ELS_PLOGI);
 		break;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index e18e5ce..65dc9aa 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -143,6 +143,7 @@ enum fc_rport_state {
 	RPORT_ST_RTV,		/* waiting for RTV completion */
 	RPORT_ST_READY,		/* ready for use */
 	RPORT_ST_LOGO,		/* port logout sent */
+	RPORT_ST_ADISC,		/* Discover Address sent */
 	RPORT_ST_DELETE,	/* port being deleted */
 };
 

