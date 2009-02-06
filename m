From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/17] libfc: check for err when recv and state is incorrect
Date: Fri, 06 Feb 2009 10:56:21 -0800
Message-ID: <20090206185621.26188.50192.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345AbZBFS4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:34 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

If we've just created an interface and the an rport is
logging in we may have a request on the wire (say PRLI).
If we destroy the interface, we'll go through each rport
on the disc->rports list and set each rport's state to NONE.
Then the lport will reset the EM. The EM reset will send a
CLOSED event to the prli_resp() handler which will notice
that the state != PRLI. In this case it frees the frame
pointer, decrements the refcount and unlocks the rport.

The problem is that there isn't a frame in this case. It's
just a pointer with an embedded error code. The free causes
an Oops.

This patch moves the error checking to be before the state
checking.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   50 +++++++++++++++++++++--------------------
 drivers/scsi/libfc/fc_rport.c |   30 ++++++++++++-------------
 2 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 60ac36f..7dd433c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1031,17 +1031,17 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RFT_ID response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_RFT_ID) {
 		FC_DBG("Received a RFT_ID response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 
@@ -1083,17 +1083,17 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a RPN_ID response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_RPN_ID) {
 		FC_DBG("Received a RPN_ID response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
 	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
@@ -1133,17 +1133,17 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a SCR response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_SCR) {
 		FC_DBG("Received a SCR response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_ready(lport);
@@ -1359,17 +1359,17 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a LOGO response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_LOGO) {
 		FC_DBG("Received a LOGO response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC)
 		fc_lport_enter_reset(lport);
@@ -1443,17 +1443,17 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	FC_DEBUG_LPORT("Received a FLOGI response\n");
 
+	if (IS_ERR(fp)) {
+		fc_lport_error(lport, fp);
+		goto err;
+	}
+
 	if (lport->state != LPORT_ST_FLOGI) {
 		FC_DBG("Received a FLOGI response, but in state %s\n",
 		       fc_lport_state(lport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
 	fh = fc_frame_header_get(fp);
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 81b3ca1..4f23a9b 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -505,17 +505,17 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
 		       rport->port_id);
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
 		FC_DBG("Received a PLOGI response, but in state %s\n",
 		       fc_rport_state(rport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC &&
 	    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
@@ -614,17 +614,17 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
 		       rport->port_id);
 
+	if (IS_ERR(fp)) {
+		fc_rport_error_retry(rport, fp);
+		goto err;
+	}
+
 	if (rdata->rp_state != RPORT_ST_PRLI) {
 		FC_DBG("Received a PRLI response, but in state %s\n",
 		       fc_rport_state(rport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_rport_error_retry(rport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		pp = fc_frame_payload_get(fp, sizeof(*pp));
@@ -764,17 +764,17 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
 		       rport->port_id);
 
+	if (IS_ERR(fp)) {
+		fc_rport_error(rport, fp);
+		goto err;
+	}
+
 	if (rdata->rp_state != RPORT_ST_RTV) {
 		FC_DBG("Received a RTV response, but in state %s\n",
 		       fc_rport_state(rport));
 		goto out;
 	}
 
-	if (IS_ERR(fp)) {
-		fc_rport_error(rport, fp);
-		goto err;
-	}
-
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		struct fc_els_rtv_acc *rtv;

