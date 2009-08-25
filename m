From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 28/64] libfc: change elsct to use FC_ID instead of rdata
Date: Tue, 25 Aug 2009 14:00:55 -0700
Message-ID: <20090825210055.1553.61332.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbZHYVAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:54 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

tt.elsct_send is used by both FCP and by the rport state machine.
After further patches, these two modules will use different
structures for the remote port.

So, change elsct_send to use the FC_ID instead of the fc_rport_priv
as its argument.  It currently only uses the FC_ID anyway.

For CT requests the destination FC_ID is still implicitly 0xfffffc.
After further patches the did arg on CT requests will be used to
specify the FC_ID being inquired about for GPN_ID or other queries.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |    2 +-
 drivers/scsi/libfc/fc_elsct.c |   11 ++++++-----
 drivers/scsi/libfc/fc_fcp.c   |    2 +-
 drivers/scsi/libfc/fc_lport.c |   12 ++++++------
 drivers/scsi/libfc/fc_rport.c |    8 ++++----
 include/scsi/fc_encode.h      |   26 +++++---------------------
 include/scsi/libfc.h          |    2 +-
 7 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 448ffc3..4b1f9fa 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -526,7 +526,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 	if (!fp)
 		goto err;
 
-	if (lport->tt.elsct_send(lport, NULL, fp,
+	if (lport->tt.elsct_send(lport, 0, fp,
 				 FC_NS_GPN_FT,
 				 fc_disc_gpn_ft_resp,
 				 disc, lport->e_d_tov))
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index 2b8a3bb..5e8b011 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -32,7 +32,7 @@
  * fc_elsct_send - sends ELS/CT frame
  */
 static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
-				    struct fc_rport_priv *rdata,
+				    u32 did,
 				    struct fc_frame *fp,
 				    unsigned int op,
 				    void (*resp)(struct fc_seq *,
@@ -41,16 +41,17 @@ static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
 				    void *arg, u32 timer_msec)
 {
 	enum fc_rctl r_ctl;
-	u32 did = FC_FID_NONE;
 	enum fc_fh_type fh_type;
 	int rc;
 
 	/* ELS requests */
 	if ((op >= ELS_LS_RJT) && (op <= ELS_AUTH_ELS))
-		rc = fc_els_fill(lport, rdata, fp, op, &r_ctl, &did, &fh_type);
-	else
+		rc = fc_els_fill(lport, did, fp, op, &r_ctl, &fh_type);
+	else {
 		/* CT requests */
-		rc = fc_ct_fill(lport, fp, op, &r_ctl, &did, &fh_type);
+		rc = fc_ct_fill(lport, fp, op, &r_ctl, &fh_type);
+		did = FC_FID_DIR_SERV;
+	}
 
 	if (rc)
 		return NULL;
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a622096..59a4408 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1308,7 +1308,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rport->port_id,
 		       fc_host_port_id(rp->local_port->host), FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
-	if (lp->tt.elsct_send(lp, rport->dd_data, fp, ELS_REC, fc_fcp_rec_resp,
+	if (lp->tt.elsct_send(lp, rport->port_id, fp, ELS_REC, fc_fcp_rec_resp,
 			      fsp, jiffies_to_msecs(FC_SCSI_REC_TOV))) {
 		fc_fcp_pkt_hold(fsp);		/* hold while REC outstanding */
 		return;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 3c15abd..aa605d2 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1217,7 +1217,7 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, NULL, fp, ELS_SCR,
+	if (!lport->tt.elsct_send(lport, FC_FID_FCTRL, fp, ELS_SCR,
 				  fc_lport_scr_resp, lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }
@@ -1258,7 +1258,7 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, NULL, fp, FC_NS_RFT_ID,
+	if (!lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RFT_ID,
 				  fc_lport_rft_id_resp,
 				  lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
@@ -1287,7 +1287,7 @@ static void fc_lport_enter_rpn_id(struct fc_lport *lport)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, NULL, fp, FC_NS_RPN_ID,
+	if (!lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RPN_ID,
 				  fc_lport_rpn_id_resp,
 				  lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
@@ -1443,8 +1443,8 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, NULL, fp, ELS_LOGO, fc_lport_logo_resp,
-				  lport, lport->e_d_tov))
+	if (!lport->tt.elsct_send(lport, FC_FID_FLOGI, fp, ELS_LOGO,
+				  fc_lport_logo_resp, lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }
 
@@ -1567,7 +1567,7 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 	if (!fp)
 		return fc_lport_error(lport, fp);
 
-	if (!lport->tt.elsct_send(lport, NULL, fp, ELS_FLOGI,
+	if (!lport->tt.elsct_send(lport, FC_FID_FLOGI, fp, ELS_FLOGI,
 				  fc_lport_flogi_resp, lport, lport->e_d_tov))
 		fc_lport_error(lport, fp);
 }
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 13d3d75..20371b4 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -593,7 +593,7 @@ static void fc_rport_enter_plogi(struct fc_rport_priv *rdata)
 	}
 	rdata->e_d_tov = lport->e_d_tov;
 
-	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_PLOGI,
+	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_PLOGI,
 				  fc_rport_plogi_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
@@ -747,7 +747,7 @@ static void fc_rport_enter_prli(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_PRLI,
+	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_PRLI,
 				  fc_rport_prli_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
@@ -845,7 +845,7 @@ static void fc_rport_enter_rtv(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_RTV,
+	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_RTV,
 				     fc_rport_rtv_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
@@ -876,7 +876,7 @@ static void fc_rport_enter_logo(struct fc_rport_priv *rdata)
 		return;
 	}
 
-	if (!lport->tt.elsct_send(lport, rdata, fp, ELS_LOGO,
+	if (!lport->tt.elsct_send(lport, rport->port_id, fp, ELS_LOGO,
 				  fc_rport_logo_resp, rdata, lport->e_d_tov))
 		fc_rport_error_retry(rdata, fp);
 	else
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 3ede1ab..24bf764 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -79,8 +79,9 @@ static inline struct fc_ct_req *fc_ct_hdr_fill(const struct fc_frame *fp,
 /**
  * fc_ct_fill - Fill in a name service request frame
  */
-static inline int fc_ct_fill(struct fc_lport *lport, struct fc_frame *fp,
-		      unsigned int op, enum fc_rctl *r_ctl, u32 *did,
+static inline int fc_ct_fill(struct fc_lport *lport,
+		      struct fc_frame *fp,
+		      unsigned int op, enum fc_rctl *r_ctl,
 		      enum fc_fh_type *fh_type)
 {
 	struct fc_ct_req *ct;
@@ -110,7 +111,6 @@ static inline int fc_ct_fill(struct fc_lport *lport, struct fc_frame *fp,
 		return -EINVAL;
 	}
 	*r_ctl = FC_RCTL_DD_UNSOL_CTL;
-	*did = FC_FID_DIR_SERV;
 	*fh_type = FC_TYPE_CT;
 	return 0;
 }
@@ -250,53 +250,37 @@ static inline void fc_scr_fill(struct fc_lport *lport, struct fc_frame *fp)
  * fc_els_fill - Fill in an ELS  request frame
  */
 static inline int fc_els_fill(struct fc_lport *lport,
-		       struct fc_rport_priv *rdata,
+		       u32 did,
 		       struct fc_frame *fp, unsigned int op,
-		       enum fc_rctl *r_ctl, u32 *did, enum fc_fh_type *fh_type)
+		       enum fc_rctl *r_ctl, enum fc_fh_type *fh_type)
 {
-	struct fc_rport *rport = PRIV_TO_RPORT(rdata);
-
 	switch (op) {
 	case ELS_PLOGI:
 		fc_plogi_fill(lport, fp, ELS_PLOGI);
-		*did = rport->port_id;
 		break;
 
 	case ELS_FLOGI:
 		fc_flogi_fill(lport, fp);
-		*did = FC_FID_FLOGI;
 		break;
 
 	case ELS_LOGO:
 		fc_logo_fill(lport, fp);
-		*did = FC_FID_FLOGI;
-		/*
-		 * if rport is valid then it
-		 * is port logo, therefore
-		 * set did to rport id.
-		 */
-		if (rdata)
-			*did = rport->port_id;
 		break;
 
 	case ELS_RTV:
 		fc_rtv_fill(lport, fp);
-		*did = rport->port_id;
 		break;
 
 	case ELS_REC:
 		fc_rec_fill(lport, fp);
-		*did = rport->port_id;
 		break;
 
 	case ELS_PRLI:
 		fc_prli_fill(lport, fp);
-		*did = rport->port_id;
 		break;
 
 	case ELS_SCR:
 		fc_scr_fill(lport, fp);
-		*did = FC_FID_FCTRL;
 		break;
 
 	default:
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index df57cb7..2473167 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -424,7 +424,7 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*elsct_send)(struct fc_lport *lport,
-				     struct fc_rport_priv *,
+				     u32 did,
 				     struct fc_frame *fp,
 				     unsigned int op,
 				     void (*resp)(struct fc_seq *,

