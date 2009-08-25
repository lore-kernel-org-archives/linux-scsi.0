From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 55/64] libfc: improve debug messages for ELS response handlers
Date: Tue, 25 Aug 2009 14:03:21 -0700
Message-ID: <20090825210321.1553.98526.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbZHYVDT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:19 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Improve lport and rport debug messages to indicate whether
the response is LS_ACC, LS_RJT, closed, or timeout.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_elsct.c |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_lport.c |   20 ++++++++++----------
 drivers/scsi/libfc/fc_rport.c |    8 ++++----
 include/scsi/libfc.h          |    5 +++++
 4 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index 5e8b011..d655924 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -70,3 +70,41 @@ int fc_elsct_init(struct fc_lport *lport)
 	return 0;
 }
 EXPORT_SYMBOL(fc_elsct_init);
+
+/**
+ * fc_els_resp_type() - return string describing ELS response for debug.
+ * @fp: frame pointer with possible error code.
+ */
+const char *fc_els_resp_type(struct fc_frame *fp)
+{
+	const char *msg;
+	if (IS_ERR(fp)) {
+		switch (-PTR_ERR(fp)) {
+		case FC_NO_ERR:
+			msg = "response no error";
+			break;
+		case FC_EX_TIMEOUT:
+			msg = "response timeout";
+			break;
+		case FC_EX_CLOSED:
+			msg = "response closed";
+			break;
+		default:
+			msg = "response unknown error";
+			break;
+		}
+	} else {
+		switch (fc_frame_payload_op(fp)) {
+		case ELS_LS_ACC:
+			msg = "accept";
+			break;
+		case ELS_LS_RJT:
+			msg = "reject";
+			break;
+		default:
+			msg = "response unknown ELS";
+			break;
+		}
+	}
+	return msg;
+}
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index d3f4e0c..3f2f723 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1006,13 +1006,13 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_frame_header *fh;
 	struct fc_ct_hdr *ct;
 
+	FC_LPORT_DBG(lport, "Received a RFT_ID %s\n", fc_els_resp_type(fp));
+
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_LPORT_DBG(lport, "Received a RFT_ID response\n");
-
 	if (lport->state != LPORT_ST_RFT_ID) {
 		FC_LPORT_DBG(lport, "Received a RFT_ID response, but in state "
 			     "%s\n", fc_lport_state(lport));
@@ -1060,13 +1060,13 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_frame_header *fh;
 	struct fc_ct_hdr *ct;
 
+	FC_LPORT_DBG(lport, "Received a RPN_ID %s\n", fc_els_resp_type(fp));
+
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_LPORT_DBG(lport, "Received a RPN_ID response\n");
-
 	if (lport->state != LPORT_ST_RPN_ID) {
 		FC_LPORT_DBG(lport, "Received a RPN_ID response, but in state "
 			     "%s\n", fc_lport_state(lport));
@@ -1112,13 +1112,13 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_lport *lport = lp_arg;
 	u8 op;
 
+	FC_LPORT_DBG(lport, "Received a SCR %s\n", fc_els_resp_type(fp));
+
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_LPORT_DBG(lport, "Received a SCR response\n");
-
 	if (lport->state != LPORT_ST_SCR) {
 		FC_LPORT_DBG(lport, "Received a SCR response, but in state "
 			     "%s\n", fc_lport_state(lport));
@@ -1333,13 +1333,13 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_lport *lport = lp_arg;
 	u8 op;
 
+	FC_LPORT_DBG(lport, "Received a LOGO %s\n", fc_els_resp_type(fp));
+
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_LPORT_DBG(lport, "Received a LOGO response\n");
-
 	if (lport->state != LPORT_ST_LOGO) {
 		FC_LPORT_DBG(lport, "Received a LOGO response, but in state "
 			     "%s\n", fc_lport_state(lport));
@@ -1415,13 +1415,13 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int e_d_tov;
 	u16 mfs;
 
+	FC_LPORT_DBG(lport, "Received a FLOGI %s\n", fc_els_resp_type(fp));
+
 	if (fp == ERR_PTR(-FC_EX_CLOSED))
 		return;
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_LPORT_DBG(lport, "Received a FLOGI response\n");
-
 	if (lport->state != LPORT_ST_FLOGI) {
 		FC_LPORT_DBG(lport, "Received a FLOGI response, but in state "
 			     "%s\n", fc_lport_state(lport));
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 02200b2..d014b28 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -544,7 +544,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rdata, "Received a PLOGI response\n");
+	FC_RPORT_DBG(rdata, "Received a PLOGI %s\n", fc_els_resp_type(fp));
 
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
 		FC_RPORT_DBG(rdata, "Received a PLOGI response, but in state "
@@ -651,7 +651,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rdata, "Received a PRLI response\n");
+	FC_RPORT_DBG(rdata, "Received a PRLI %s\n", fc_els_resp_type(fp));
 
 	if (rdata->rp_state != RPORT_ST_PRLI) {
 		FC_RPORT_DBG(rdata, "Received a PRLI response, but in state "
@@ -717,7 +717,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rdata, "Received a LOGO response\n");
+	FC_RPORT_DBG(rdata, "Received a LOGO %s\n", fc_els_resp_type(fp));
 
 	if (rdata->rp_state != RPORT_ST_LOGO) {
 		FC_RPORT_DBG(rdata, "Received a LOGO response, but in state "
@@ -801,7 +801,7 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_RPORT_DBG(rdata, "Received a RTV response\n");
+	FC_RPORT_DBG(rdata, "Received a RTV %s\n", fc_els_resp_type(fp));
 
 	if (rdata->rp_state != RPORT_ST_RTV) {
 		FC_RPORT_DBG(rdata, "Received a RTV response, but in state "
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 265f106..e18e5ce 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1084,4 +1084,9 @@ void fc_destroy_exch_mgr(void);
 int fc_setup_rport(void);
 void fc_destroy_rport(void);
 
+/*
+ * Internal libfc functions.
+ */
+const char *fc_els_resp_type(struct fc_frame *);
+
 #endif /* _LIBFC_H_ */

