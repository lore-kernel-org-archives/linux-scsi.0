From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/11] libfc: Do not retry if the new state is not the same as
	old state
Date: Tue, 21 Apr 2009 16:26:58 -0700
Message-ID: <20090421232657.8165.3546.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1665 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZDUX07 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:26:59 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

For instance, if there is a Plogi pending (remote port is in Plogi state),
and the state changes to say NONE (because the port is being logged off),
then when the Plogi resp times out, do not start a retry.

This patch partially reverts an earlier patch (libfc: check for err when
recv and state is incorrect), by moving the state check back to before
checking for error. However, if the state does not match, then there is
an additional check to see if its an error ptr or a real frame before
jumping to err or out respectively.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   60 ++++++++++++++++++++++++-----------------
 drivers/scsi/libfc/fc_rport.c |   48 +++++++++++++++++++--------------
 2 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index b8178ef..52c4f2d 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1032,17 +1032,19 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RFT_ID response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_RFT_ID) {
 		FC_DBG("Received a RFT_ID response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 
@@ -1084,17 +1086,19 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RPN_ID response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_RPN_ID) {
 		FC_DBG("Received a RPN_ID response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
@@ -1134,17 +1138,19 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a SCR response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_SCR) {
 		FC_DBG("Received a SCR response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_ready(lport);
@@ -1360,17 +1366,19 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a LOGO response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_LOGO) {
 		FC_DBG("Received a LOGO response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_reset(lport);
@@ -1444,17 +1452,19 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a FLOGI response\n");
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	if (lport->state != LPORT_ST_FLOGI) {
 		FC_DBG("Received a FLOGI response, but in state %s\n",
 		       fc_lport_state(lport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	fh = fc_frame_header_get(fp);
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 0472bb7..eef70b4 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -505,17 +505,19 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
 		FC_DBG("Received a PLOGI response, but in state %s\n",
 		       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC &&
 	    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
@@ -614,17 +616,19 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_PRLI) {
 		FC_DBG("Received a PRLI response, but in state %s\n",
 		       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		pp = fc_frame_payload_get(fp, sizeof(*pp));
@@ -678,17 +682,19 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a LOGO response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_LOGO) {
 		FC_DEBUG_RPORT("Received a LOGO response, but in state %s\n",
 			       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		fc_rport_enter_rtv(rport);
@@ -764,17 +770,19 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
 		       rport->port_id);
 
-	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
-		goto err;
-	}
-
 	if (rdata->rp_state != RPORT_ST_RTV) {
 		FC_DBG("Received a RTV response, but in state %s\n",
 		       fc_rport_state(rport));
+		if (IS_ERR(fp))
+			goto err;
 		goto out;
 	}
 
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		struct fc_els_rtv_acc *rtv;

