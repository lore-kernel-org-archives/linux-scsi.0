From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/54] libfc: combine name server registration response
	handlers
Date: Tue, 03 Nov 2009 11:47:07 -0800
Message-ID: <20091103194707.4085.88541.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2037 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbZKCTrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:47:02 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

They all do the same thing, so combine them into a single function.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |  205 ++++++-----------------------------------
 1 files changed, 30 insertions(+), 175 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 28a35da..f67ca68 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -985,9 +985,9 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 }
 
 /**
- * fc_lport_rft_id_resp() - Handle response to Register Fibre
- *			    Channel Types by ID (RFT_ID) request
- * @sp: current sequence in RFT_ID exchange
+ * fc_lport_ns_resp() - Handle response to a name server
+ * 			registration exchange
+ * @sp: current sequence in exchange
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
  *
@@ -995,130 +995,23 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
  * held, but it will lock, call an _enter_* function or fc_lport_error
  * and then unlock the lport.
  */
-static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
-				 void *lp_arg)
+static void fc_lport_ns_resp(struct fc_seq *sp, struct fc_frame *fp,
+			     void *lp_arg)
 {
 	struct fc_lport *lport = lp_arg;
 	struct fc_frame_header *fh;
 	struct fc_ct_hdr *ct;
 
-	FC_LPORT_DBG(lport, "Received a RFT_ID %s\n", fc_els_resp_type(fp));
+	FC_LPORT_DBG(lport, "Received a ns %s\n", fc_els_resp_type(fp));
 
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
 	mutex_lock(&lport->lp_mutex);
 
-	if (lport->state != LPORT_ST_RFT_ID) {
-		FC_LPORT_DBG(lport, "Received a RFT_ID response, but in state "
-			     "%s\n", fc_lport_state(lport));
-		if (IS_ERR(fp))
-			goto err;
-		goto out;
-	}
-
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
-	fh = fc_frame_header_get(fp);
-	ct = fc_frame_payload_get(fp, sizeof(*ct));
-
-	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
-	    ct->ct_fs_type == FC_FST_DIR &&
-	    ct->ct_fs_subtype == FC_NS_SUBTYPE &&
-	    ntohs(ct->ct_cmd) == FC_FS_ACC)
-		fc_lport_enter_scr(lport);
-	else
-		fc_lport_error(lport, fp);
-out:
-	fc_frame_free(fp);
-err:
-	mutex_unlock(&lport->lp_mutex);
-}
-
-/**
- * fc_lport_rspn_id_resp() - Handle response to Register Symbolic Port Name
- *			     by ID (RSPN_ID) request
- * @sp: current sequence in RSPN_ID exchange
- * @fp: response frame
- * @lp_arg: Fibre Channel host port instance
- *
- * Locking Note: This function will be called without the lport lock
- * held, but it will lock, call an _enter_* function or fc_lport_error
- * and then unlock the lport.
- */
-static void fc_lport_rspn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
-				  void *lp_arg)
-{
-	struct fc_lport *lport = lp_arg;
-	struct fc_frame_header *fh;
-	struct fc_ct_hdr *ct;
-
-	FC_LPORT_DBG(lport, "Received a RSPN_ID %s\n", fc_els_resp_type(fp));
-
-	if (fp == ERR_PTR(-FC_EX_CLOSED))
-		return;
-
-	mutex_lock(&lport->lp_mutex);
-
-	if (lport->state != LPORT_ST_RSPN_ID) {
-		FC_LPORT_DBG(lport, "Received a RSPN_ID response, but in state "
-			     "%s\n", fc_lport_state(lport));
-		if (IS_ERR(fp))
-			goto err;
-		goto out;
-	}
-
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
-	fh = fc_frame_header_get(fp);
-	ct = fc_frame_payload_get(fp, sizeof(*ct));
-	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
-	    ct->ct_fs_type == FC_FST_DIR &&
-	    ct->ct_fs_subtype == FC_NS_SUBTYPE &&
-	    ntohs(ct->ct_cmd) == FC_FS_ACC)
-		fc_lport_enter_rspn_id(lport);
-	else
-		fc_lport_error(lport, fp);
-
-out:
-	fc_frame_free(fp);
-err:
-	mutex_unlock(&lport->lp_mutex);
-}
-/**
- * fc_lport_rsnn_nn_resp() - Handle response to Register Symbolic Node Name
- *			     by Node Name (RSNN_NN) request
- * @sp: current sequence in RSNN_NN exchange
- * @fp: response frame
- * @lp_arg: Fibre Channel host port instance
- *
- * Locking Note: This function will be called without the lport lock
- * held, but it will lock, call an _enter_* function or fc_lport_error
- * and then unlock the lport.
- */
-static void fc_lport_rsnn_nn_resp(struct fc_seq *sp, struct fc_frame *fp,
-				  void *lp_arg)
-{
-	struct fc_lport *lport = lp_arg;
-	struct fc_frame_header *fh;
-	struct fc_ct_hdr *ct;
-
-	FC_LPORT_DBG(lport, "Received a RSNN_NN %s\n", fc_els_resp_type(fp));
-
-	if (fp == ERR_PTR(-FC_EX_CLOSED))
-		return;
-
-	mutex_lock(&lport->lp_mutex);
-
-	if (lport->state != LPORT_ST_RSNN_NN) {
-		FC_LPORT_DBG(lport, "Received a RSNN_NN response, but in state "
-			     "%s\n", fc_lport_state(lport));
+	if (lport->state < LPORT_ST_RNN_ID || lport->state > LPORT_ST_RFT_ID) {
+		FC_LPORT_DBG(lport, "Received a name server response, "
+				    "but in state %s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1131,68 +1024,30 @@ static void fc_lport_rsnn_nn_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	fh = fc_frame_header_get(fp);
 	ct = fc_frame_payload_get(fp, sizeof(*ct));
-	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
-	    ct->ct_fs_type == FC_FST_DIR &&
-	    ct->ct_fs_subtype == FC_NS_SUBTYPE &&
-	    ntohs(ct->ct_cmd) == FC_FS_ACC)
-		fc_lport_enter_rsnn_nn(lport);
-	else
-		fc_lport_error(lport, fp);
-
-out:
-	fc_frame_free(fp);
-err:
-	mutex_unlock(&lport->lp_mutex);
-}
 
-/**
- * fc_lport_rnn_id_resp() - Handle response to Register Node
- *			    Name by ID (RNN_ID) request
- * @sp: current sequence in RNN_ID exchange
- * @fp: response frame
- * @lp_arg: Fibre Channel host port instance
- *
- * Locking Note: This function will be called without the lport lock
- * held, but it will lock, call an _enter_* function or fc_lport_error
- * and then unlock the lport.
- */
-static void fc_lport_rnn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
-				 void *lp_arg)
-{
-	struct fc_lport *lport = lp_arg;
-	struct fc_frame_header *fh;
-	struct fc_ct_hdr *ct;
-
-	FC_LPORT_DBG(lport, "Received a RNN_ID %s\n", fc_els_resp_type(fp));
-
-	if (fp == ERR_PTR(-FC_EX_CLOSED))
-		return;
-
-	mutex_lock(&lport->lp_mutex);
-
-	if (lport->state != LPORT_ST_RNN_ID) {
-		FC_LPORT_DBG(lport, "Received a RNN_ID response, but in state "
-			     "%s\n", fc_lport_state(lport));
-		if (IS_ERR(fp))
-			goto err;
-		goto out;
-	}
-
-	if (IS_ERR(fp)) {
-		fc_lport_error(lport, fp);
-		goto err;
-	}
-
-	fh = fc_frame_header_get(fp);
-	ct = fc_frame_payload_get(fp, sizeof(*ct));
 	if (fh && ct && fh->fh_type == FC_TYPE_CT &&
 	    ct->ct_fs_type == FC_FST_DIR &&
 	    ct->ct_fs_subtype == FC_NS_SUBTYPE &&
 	    ntohs(ct->ct_cmd) == FC_FS_ACC)
-		fc_lport_enter_rft_id(lport);
+		switch (lport->state) {
+		case LPORT_ST_RNN_ID:
+			fc_lport_enter_rsnn_nn(lport);
+			break;
+		case LPORT_ST_RSNN_NN:
+			fc_lport_enter_rspn_id(lport);
+			break;
+		case LPORT_ST_RSPN_ID:
+			fc_lport_enter_rft_id(lport);
+			break;
+		case LPORT_ST_RFT_ID:
+			fc_lport_enter_scr(lport);
+			break;
+		default:
+			/* should have already been caught by state checks */
+			break;
+		}
 	else
 		fc_lport_error(lport, fp);
-
 out:
 	fc_frame_free(fp);
 err:
@@ -1311,7 +1166,7 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 	}
 
 	if (!lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RFT_ID,
-				  fc_lport_rft_id_resp,
+				  fc_lport_ns_resp,
 				  lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }
@@ -1342,7 +1197,7 @@ static void fc_lport_enter_rspn_id(struct fc_lport *lport)
 	}
 
 	if (!lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RSPN_ID,
-				  fc_lport_rspn_id_resp,
+				  fc_lport_ns_resp,
 				  lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }
@@ -1373,7 +1228,7 @@ static void fc_lport_enter_rsnn_nn(struct fc_lport *lport)
 	}
 
 	if (!lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RSNN_NN,
-				  fc_lport_rsnn_nn_resp,
+				  fc_lport_ns_resp,
 				  lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }
@@ -1402,7 +1257,7 @@ static void fc_lport_enter_rnn_id(struct fc_lport *lport)
 	}
 
 	if (!lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RNN_ID,
-				  fc_lport_rnn_id_resp,
+				  fc_lport_ns_resp,
 				  lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }

