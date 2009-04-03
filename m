From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/15] libfc: Convert debug statements in fc_disc.c to use new
	libfc debug macros.
Date: Fri, 03 Apr 2009 14:58:59 -0700
Message-ID: <20090403215859.10856.14365.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759769AbZDCV7D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:59:03 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert debug statements in fc_disc.c to use new libfc
debug macros.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |   83 ++++++++++++++++++------------------------
 1 files changed, 35 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4c88065..6fabf66 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -45,14 +45,6 @@
 
 #define	FC_DISC_DELAY		3
 
-static int fc_disc_debug;
-
-#define FC_DEBUG_DISC(fmt...)			\
-	do {					\
-		if (fc_disc_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static int fc_disc_new_target(struct fc_disc *, struct fc_rport *,
@@ -137,8 +129,8 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_disc *disc = &lport->disc;
 
-	FC_DEBUG_DISC("Received a %d event for port (%6x)\n", event,
-		      rport->port_id);
+	FC_DISC_DBG(disc, "Received a %d event for port (%6x)\n", event,
+		    rport->port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
@@ -191,8 +183,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 
 	lport = disc->lport;
 
-	FC_DEBUG_DISC("Received an RSCN event on port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG(disc, "Received an RSCN event\n");
 
 	/* make sure the frame contains an RSCN message */
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
@@ -225,8 +216,8 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		 */
 		switch (fmt) {
 		case ELS_ADDR_FMT_PORT:
-			FC_DEBUG_DISC("Port address format for port (%6x)\n",
-				      ntoh24(pp->rscn_fid));
+			FC_DISC_DBG(disc, "Port address format for port "
+				    "(%6x)\n", ntoh24(pp->rscn_fid));
 			dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 			if (!dp) {
 				redisc = 1;
@@ -243,19 +234,19 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		case ELS_ADDR_FMT_DOM:
 		case ELS_ADDR_FMT_FAB:
 		default:
-			FC_DEBUG_DISC("Address format is (%d)\n", fmt);
+			FC_DISC_DBG(disc, "Address format is (%d)\n", fmt);
 			redisc = 1;
 			break;
 		}
 	}
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	if (redisc) {
-		FC_DEBUG_DISC("RSCN received: rediscovering\n");
+		FC_DISC_DBG(disc, "RSCN received: rediscovering\n");
 		fc_disc_restart(disc);
 	} else {
-		FC_DEBUG_DISC("RSCN received: not rediscovering. "
-			      "redisc %d state %d in_prog %d\n",
-			      redisc, lport->state, disc->pending);
+		FC_DISC_DBG(disc, "RSCN received: not rediscovering. "
+			    "redisc %d state %d in_prog %d\n",
+			    redisc, lport->state, disc->pending);
 		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
 			list_del(&dp->peers);
 			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
@@ -270,7 +261,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 	fc_frame_free(fp);
 	return;
 reject:
-	FC_DEBUG_DISC("Received a bad RSCN frame\n");
+	FC_DISC_DBG(disc, "Received a bad RSCN frame\n");
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_LOGIC;
 	rjt_data.explan = ELS_EXPL_NONE;
@@ -302,7 +293,8 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		mutex_unlock(&disc->disc_mutex);
 		break;
 	default:
-		FC_DBG("Received an unsupported request. opcode (%x)\n", op);
+		FC_DISC_DBG(disc, "Received an unsupported request, "
+			    "the opcode is (%x)\n", op);
 		break;
 	}
 }
@@ -320,12 +312,10 @@ static void fc_disc_restart(struct fc_disc *disc)
 	struct fc_rport_libfc_priv *rdata, *next;
 	struct fc_lport *lport = disc->lport;
 
-	FC_DEBUG_DISC("Restarting discovery for port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG(disc, "Restarting discovery\n");
 
 	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
 		rport = PRIV_TO_RPORT(rdata);
-		FC_DEBUG_DISC("list_del(%6x)\n", rport->port_id);
 		list_del(&rdata->peers);
 		lport->tt.rport_logoff(rport);
 	}
@@ -485,8 +475,7 @@ static void fc_disc_done(struct fc_disc *disc)
 	struct fc_lport *lport = disc->lport;
 	enum fc_disc_event event;
 
-	FC_DEBUG_DISC("Discovery complete for port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG(disc, "Discovery complete\n");
 
 	event = disc->event;
 	disc->event = DISC_EV_NONE;
@@ -510,10 +499,10 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 {
 	struct fc_lport *lport = disc->lport;
 	unsigned long delay = 0;
-	if (fc_disc_debug)
-		FC_DBG("Error %ld, retries %d/%d\n",
-		       PTR_ERR(fp), disc->retry_count,
-		       FC_DISC_RETRY_LIMIT);
+
+	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
+		    PTR_ERR(fp), disc->retry_count,
+		    FC_DISC_RETRY_LIMIT);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
@@ -649,9 +638,9 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 					      &disc->rogue_rports);
 				lport->tt.rport_login(rport);
 			} else
-				FC_DBG("Failed to allocate memory for "
-				       "the newly discovered port (%6x)\n",
-				       dp.ids.port_id);
+				printk(KERN_WARNING "libfc: Failed to allocate "
+				       "memory for the newly discovered port "
+				       "(%6x)\n", dp.ids.port_id);
 		}
 
 		if (np->fp_flags & FC_NS_FID_LAST) {
@@ -671,9 +660,8 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	 */
 	if (error == 0 && len > 0 && len < sizeof(*np)) {
 		if (np != &disc->partial_buf) {
-			FC_DEBUG_DISC("Partial buffer remains "
-				      "for discovery by (%6x)\n",
-				      fc_host_port_id(lport->host));
+			FC_DISC_DBG(disc, "Partial buffer remains "
+				    "for discovery\n");
 			memcpy(&disc->partial_buf, np, len);
 		}
 		disc->buf_len = (unsigned char) len;
@@ -721,8 +709,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	int error;
 
 	mutex_lock(&disc->disc_mutex);
-	FC_DEBUG_DISC("Received a GPN_FT response on port (%6x)\n",
-		      fc_host_port_id(disc->lport->host));
+	FC_DISC_DBG(disc, "Received a GPN_FT response\n");
 
 	if (IS_ERR(fp)) {
 		fc_disc_error(disc, fp);
@@ -738,30 +725,30 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	    disc->seq_count == 0) {
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
 		if (!cp) {
-			FC_DBG("GPN_FT response too short, len %d\n",
-			       fr_len(fp));
+			FC_DISC_DBG(disc, "GPN_FT response too short, len %d\n",
+				    fr_len(fp));
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
 			/* Accepted, parse the response. */
 			buf = cp + 1;
 			len -= sizeof(*cp);
 		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
-			FC_DBG("GPN_FT rejected reason %x exp %x "
-			       "(check zoning)\n", cp->ct_reason,
-			       cp->ct_explan);
+			FC_DISC_DBG(disc, "GPN_FT rejected reason %x exp %x "
+				    "(check zoning)\n", cp->ct_reason,
+				    cp->ct_explan);
 			disc->event = DISC_EV_FAILED;
 			fc_disc_done(disc);
 		} else {
-			FC_DBG("GPN_FT unexpected response code %x\n",
-			       ntohs(cp->ct_cmd));
+			FC_DISC_DBG(disc, "GPN_FT unexpected response code "
+				    "%x\n", ntohs(cp->ct_cmd));
 		}
 	} else if (fr_sof(fp) == FC_SOF_N3 &&
 		   seq_cnt == disc->seq_count) {
 		buf = fh + 1;
 	} else {
-		FC_DBG("GPN_FT unexpected frame - out of sequence? "
-		       "seq_cnt %x expected %x sof %x eof %x\n",
-		       seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
+		FC_DISC_DBG(disc, "GPN_FT unexpected frame - out of sequence? "
+			    "seq_cnt %x expected %x sof %x eof %x\n",
+			    seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
 	}
 	if (buf) {
 		error = fc_disc_gpn_ft_parse(disc, buf, len);

