From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/15] libfc: Convert debug statements in fc_lport.c to use
	new libfc debug macros.
Date: Fri, 03 Apr 2009 14:58:52 -0700
Message-ID: <20090403215852.10856.47791.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:38125 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759769AbZDCV64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:58:56 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert debug statements in fc_lport.c to use new libfc
debug macros.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |  156 ++++++++++++++++++++---------------------
 1 files changed, 75 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e0c2477..745fa55 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -101,14 +101,6 @@
 
 #define	DNS_DELAY	      3 /* Discovery delay after RSCN (in seconds)*/
 
-static int fc_lport_debug;
-
-#define FC_DEBUG_LPORT(fmt...)			\
-	do {					\
-		if (fc_lport_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static void fc_lport_error(struct fc_lport *, struct fc_frame *);
 
 static void fc_lport_enter_reset(struct fc_lport *);
@@ -151,8 +143,8 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				    struct fc_rport *rport,
 				    enum fc_rport_event event)
 {
-	FC_DEBUG_LPORT("Received a %d event for port (%6x)\n", event,
-		       rport->port_id);
+	FC_LPORT_DBG(lport, "Received a %d event for port (%6x)\n", event,
+		     rport->port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
@@ -162,19 +154,19 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				lport->dns_rp = rport;
 				fc_lport_enter_rpn_id(lport);
 			} else {
-				FC_DEBUG_LPORT("Received an CREATED event on "
-					       "port (%6x) for the directory "
-					       "server, but the lport is not "
-					       "in the DNS state, it's in the "
-					       "%d state", rport->port_id,
-					       lport->state);
+				FC_LPORT_DBG(lport, "Received an CREATED event "
+					     "on port (%6x) for the directory "
+					     "server, but the lport is not "
+					     "in the DNS state, it's in the "
+					     "%d state", rport->port_id,
+					     lport->state);
 				lport->tt.rport_logoff(rport);
 			}
 			mutex_unlock(&lport->lp_mutex);
 		} else
-			FC_DEBUG_LPORT("Received an event for port (%6x) "
-				       "which is not the directory server\n",
-				       rport->port_id);
+			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
+				     "which is not the directory server\n",
+				     rport->port_id);
 		break;
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
@@ -185,9 +177,9 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 			mutex_unlock(&lport->lp_mutex);
 
 		} else
-			FC_DEBUG_LPORT("Received an event for port (%6x) "
-				       "which is not the directory server\n",
-				       rport->port_id);
+			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
+				     "which is not the directory server\n",
+				     rport->port_id);
 		break;
 	case RPORT_EV_NONE:
 		break;
@@ -363,8 +355,8 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
 static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
 				   struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+		     fc_lport_state(lport));
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);
@@ -389,8 +381,8 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	void *dp;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+		     fc_lport_state(lport));
 
 	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
 	pp = fc_frame_payload_get(in_fp, len);
@@ -437,8 +429,8 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	size_t len;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received RNID request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received RNID request while in state %s\n",
+		     fc_lport_state(lport));
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
@@ -498,8 +490,8 @@ static void fc_lport_recv_adisc_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	size_t len;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received ADISC request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received ADISC request while in state %s\n",
+		     fc_lport_state(lport));
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
@@ -574,8 +566,8 @@ EXPORT_SYMBOL(fc_fabric_login);
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Link is up for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+	printk(KERN_INFO "libfc: Link up on port (%6x)\n",
+	       fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
 	if (!lport->link_up) {
@@ -595,8 +587,8 @@ EXPORT_SYMBOL(fc_linkup);
 void fc_linkdown(struct fc_lport *lport)
 {
 	mutex_lock(&lport->lp_mutex);
-	FC_DEBUG_LPORT("Link is down for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+	printk(KERN_INFO "libfc: Link down on port (%6x)\n",
+	       fc_host_port_id(lport->host));
 
 	if (lport->link_up) {
 		lport->link_up = 0;
@@ -701,12 +693,11 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 {
 	switch (event) {
 	case DISC_EV_SUCCESS:
-		FC_DEBUG_LPORT("Got a SUCCESS event for port (%6x)\n",
-			       fc_host_port_id(lport->host));
+		FC_LPORT_DBG(lport, "Discovery succeeded\n");
 		break;
 	case DISC_EV_FAILED:
-		FC_DEBUG_LPORT("Got a FAILED event for port (%6x)\n",
-			       fc_host_port_id(lport->host));
+		printk(KERN_ERR "libfc: Discovery failed for port (%6x)\n",
+		       fc_host_port_id(lport->host));
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -726,8 +717,8 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
  */
 static void fc_lport_enter_ready(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Port (%6x) entered Ready from state %s\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered READY from state %s\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
 
@@ -762,8 +753,8 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	u32 local_fid;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received FLOGI request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received FLOGI request while in state %s\n",
+		     fc_lport_state(lport));
 
 	fh = fc_frame_header_get(rx_fp);
 	remote_fid = ntoh24(fh->fh_s_id);
@@ -772,12 +763,11 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
-		FC_DBG("FLOGI from port with same WWPN %llx "
-		       "possible configuration error\n",
-		       (unsigned long long)remote_wwpn);
+		printk(KERN_WARNING "libfc: Received FLOGI from port "
+		       "with same WWPN %llx\n", remote_wwpn);
 		goto out;
 	}
-	FC_DBG("FLOGI from port WWPN %llx\n", (unsigned long long)remote_wwpn);
+	FC_LPORT_DBG(lport, "FLOGI from port WWPN %llx\n", remote_wwpn);
 
 	/*
 	 * XXX what is the right thing to do for FIDs?
@@ -909,7 +899,8 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 			}
 		}
 	} else {
-		FC_DBG("dropping invalid frame (eof %x)\n", fr_eof(fp));
+		FC_LPORT_DBG(lport, "dropping invalid frame (eof %x)\n",
+			     fr_eof(fp));
 		fc_frame_free(fp);
 	}
 	mutex_unlock(&lport->lp_mutex);
@@ -947,8 +938,8 @@ EXPORT_SYMBOL(fc_lport_reset);
  */
 static void fc_lport_enter_reset(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Port (%6x) entered RESET state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered RESET state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
 
@@ -982,9 +973,9 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 {
 	unsigned long delay = 0;
-	FC_DEBUG_LPORT("Error %ld in state %s, retries %d\n",
-		       PTR_ERR(fp), fc_lport_state(lport),
-		       lport->retry_count);
+	FC_LPORT_DBG(lport, "Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_lport_state(lport),
+		     lport->retry_count);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
@@ -1040,11 +1031,11 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a RFT_ID response\n");
+	FC_LPORT_DBG(lport, "Received a RFT_ID response\n");
 
 	if (lport->state != LPORT_ST_RFT_ID) {
-		FC_DBG("Received a RFT_ID response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a RFT_ID response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1094,11 +1085,11 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a RPN_ID response\n");
+	FC_LPORT_DBG(lport, "Received a RPN_ID response\n");
 
 	if (lport->state != LPORT_ST_RPN_ID) {
-		FC_DBG("Received a RPN_ID response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a RPN_ID response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1146,11 +1137,11 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a SCR response\n");
+	FC_LPORT_DBG(lport, "Received a SCR response\n");
 
 	if (lport->state != LPORT_ST_SCR) {
-		FC_DBG("Received a SCR response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a SCR response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1184,8 +1175,8 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Port (%6x) entered SCR state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered SCR state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_SCR);
 
@@ -1213,8 +1204,8 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 	struct fc_ns_fts *lps;
 	int i;
 
-	FC_DEBUG_LPORT("Port (%6x) entered RFT_ID state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered RFT_ID state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RFT_ID);
 
@@ -1253,8 +1244,8 @@ static void fc_lport_enter_rpn_id(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Port (%6x) entered RPN_ID state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered RPN_ID state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RPN_ID);
 
@@ -1294,8 +1285,8 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	dp.lp = lport;
 
-	FC_DEBUG_LPORT("Port (%6x) entered DNS state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered DNS state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
@@ -1374,11 +1365,11 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a LOGO response\n");
+	FC_LPORT_DBG(lport, "Received a LOGO response\n");
 
 	if (lport->state != LPORT_ST_LOGO) {
-		FC_DBG("Received a LOGO response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a LOGO response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1413,8 +1404,8 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 	struct fc_frame *fp;
 	struct fc_els_logo *logo;
 
-	FC_DEBUG_LPORT("Port (%6x) entered LOGO state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered LOGO state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_LOGO);
 
@@ -1456,11 +1447,11 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a FLOGI response\n");
+	FC_LPORT_DBG(lport, "Received a FLOGI response\n");
 
 	if (lport->state != LPORT_ST_FLOGI) {
-		FC_DBG("Received a FLOGI response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a FLOGI response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1475,7 +1466,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
 
-		FC_DEBUG_LPORT("Assigned fid %x\n", did);
+		printk(KERN_INFO "libfc: Assigned FID (%6x) in FLOGI response\n",
+		       did);
 		fc_host_port_id(lport->host) = did;
 
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
@@ -1494,7 +1486,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				if (e_d_tov > lport->e_d_tov)
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
-				FC_DBG("Point-to-Point mode\n");
+				printk(KERN_INFO "libfc: Port (%6x) entered "
+				       "point to point mode\n", did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
@@ -1517,7 +1510,7 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			}
 		}
 	} else {
-		FC_DBG("bad FLOGI response\n");
+		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
 	}
 
 out:
@@ -1537,7 +1530,8 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Processing FLOGI state\n");
+	FC_LPORT_DBG(lport, "Entered FLOGI state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_FLOGI);
 

