From: michaelc@cs.wisc.edu
Subject: [PATCH 09/13] libfc: use get/put_aligned_be helpers
Date: Sun, 29 Jun 2008 13:23:59 -0500
Message-ID: <1214763843-5548-10-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-8-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-9-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbYF2SYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:10 -0400
In-Reply-To: <1214763843-5548-9-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Use get/put_alignged_be helpers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_disc.c  |    2 +-
 drivers/scsi/libfc/fc_lport.c |   13 ++++++-------
 drivers/scsi/libfc/fc_rport.c |   13 +++++++------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index a1b5171..fe50388 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -996,7 +996,7 @@ static void fc_disc_enter_reg_pn(struct fc_lport *lp)
 	memset(req, 0, sizeof(*req));
 	fc_lport_fill_dns_hdr(lp, &req->ct, FC_NS_RPN_ID, sizeof(req->rn));
 	req->rn.fr_fid.fp_fid = hton24(lp->fl_fid);
-	put_unaligned(htonll(lp->wwpn), &req->rn.fr_wwn);
+	put_unaligned_be64(lp->wwpn, &req->rn.fr_wwn);
 	fc_frame_setup(fp, FC_RCTL_DD_UNSOL_CTL, FC_TYPE_CT);
 	dns_rp = lp->fl_dns_rp;
 	if (!lp->tt.exch_seq_send(lp, fp,
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a7ffab7..805cb71 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -242,9 +242,8 @@ fc_lport_flogi_fill(struct fc_lport *lp,
 
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) op;
-	put_unaligned(htonll(lp->wwpn), &flogi->fl_wwpn);
-	put_unaligned(htonll(lp->wwnn), &flogi->fl_wwnn);
-
+	put_unaligned_be64(lp->wwpn, &flogi->fl_wwpn);
+	put_unaligned_be64(lp->wwnn, &flogi->fl_wwnn);
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
 	sp->sp_lo_ver = 0x20;
@@ -310,8 +309,8 @@ fc_lport_flogi_resp(struct fc_seq *sp,
 				lp->fl_r_a_tov = 2 * e_d_tov;
 				FC_DBG("point-to-point mode");
 				fc_lport_ptp_setup(lp, ntoh24(fh->fh_s_id),
-					ntohll(get_unaligned(&flp->fl_wwpn)),
-					ntohll(get_unaligned(&flp->fl_wwnn)));
+					get_unaligned_be64(&flp->fl_wwpn),
+					get_unaligned_be64(&flp->fl_wwnn));
 			} else {
 				lp->fl_e_d_tov = e_d_tov;
 				lp->fl_r_a_tov = r_a_tov;
@@ -384,7 +383,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	flp = fc_frame_payload_get(rx_fp, sizeof(*flp));
 	if (!flp)
 		goto out;
-	remote_wwpn = ntohll(get_unaligned(&flp->fl_wwpn));
+	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lp->wwpn) {
 		FC_DBG("FLOGI from port with same WWPN %llx "
 		       "possible configuration error.", remote_wwpn);
@@ -435,7 +434,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		fc_lport_retry(lp);
 	}
 	fc_lport_ptp_setup(lp, remote_fid, remote_wwpn,
-			   ntohll(get_unaligned(&flp->fl_wwnn)));
+			   get_unaligned_be64(&flp->fl_wwnn));
 	fc_lport_unlock(lp);
 	if (!lp->tt.disc_start(lp))
 		FC_DBG("target discovery start error\n");
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 8b0e839..b121981 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -375,8 +375,8 @@ fc_lport_plogi_fill(struct fc_lport *lp,
 
 	memset(flogi, 0, sizeof(*flogi));
 	flogi->fl_cmd = (u8) op;
-	put_unaligned(htonll(lp->wwpn), &flogi->fl_wwpn);
-	put_unaligned(htonll(lp->wwnn), &flogi->fl_wwnn);
+	put_unaligned_be64(lp->wwpn, &flogi->fl_wwpn);
+	put_unaligned_be64(lp->wwnn, &flogi->fl_wwnn);
 
 	sp = &flogi->fl_csp;
 	sp->sp_hi_ver = 0x20;
@@ -809,8 +809,9 @@ static void fc_rport_plogi_recv_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_sess_lock(rp);
 		if (op == ELS_LS_ACC &&
 		    (plp = fc_frame_payload_get(fp, sizeof(*plp))) != NULL) {
-			wwpn = ntohll(get_unaligned(&plp->fl_wwpn));
-			wwnn = ntohll(get_unaligned(&plp->fl_wwnn));
+			wwpn = get_unaligned_be64(&plp->fl_wwpn);
+			wwnn = get_unaligned_be64(&plp->fl_wwnn);
+
 			fc_rport_set_name(rp, wwpn, wwnn);
 			tov = ntohl(plp->fl_csp.sp_e_d_tov);
 			if (ntohs(plp->fl_csp.sp_features) & FC_SP_FT_EDTR)
@@ -1194,8 +1195,8 @@ static void fc_rport_recv_plogi_req(struct fc_remote_port *rp,
 		fc_frame_free(fp);
 		return;
 	}
-	wwpn = ntohll(get_unaligned(&pl->fl_wwpn));
-	wwnn = ntohll(get_unaligned(&pl->fl_wwnn));
+	wwpn = get_unaligned_be64(&pl->fl_wwpn);
+	wwnn = get_unaligned_be64(&pl->fl_wwnn);
 	fc_sess_lock(rp);
 	lp = rp->local_port;
 
-- 
1.5.4.1

