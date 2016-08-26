From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/30] libfc: sanitize E_D_TOV and R_A_TOV setting
Date: Fri, 26 Aug 2016 14:01:40 +0200
Message-ID: <1472212913-39810-18-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35193 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752300AbcHZMCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:12 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When setting the FCP timeout we need to ensure a lower boundary
for E_D_TOV and R_A_TOV, otherwise we'd be getting spurious I/O
issues due to the fcp timer firing too early.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c   | 9 +++++----
 drivers/scsi/libfc/fc_lport.c | 8 +++++---
 drivers/scsi/libfc/fc_rport.c | 6 ++++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index abddfe2..1cb2c59 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1139,8 +1139,11 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 static inline unsigned int get_fsp_rec_tov(struct fc_fcp_pkt *fsp)
 {
 	struct fc_rport_libfc_priv *rpriv = fsp->rport->dd_data;
+	unsigned int e_d_tov = FC_DEF_E_D_TOV;
 
-	return msecs_to_jiffies(rpriv->e_d_tov) + HZ;
+	if (rpriv && rpriv->e_d_tov > e_d_tov)
+		e_d_tov = rpriv->e_d_tov;
+	return msecs_to_jiffies(e_d_tov) + HZ;
 }
 
 /**
@@ -1696,7 +1699,6 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 	struct fc_seq *seq;
 	struct fcp_srr *srr;
 	struct fc_frame *fp;
-	unsigned int rec_tov;
 
 	rport = fsp->rport;
 	rpriv = rport->dd_data;
@@ -1720,10 +1722,9 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 		       rpriv->local_port->port_id, FC_TYPE_FCP,
 		       FC_FCTL_REQ, 0);
 
-	rec_tov = get_fsp_rec_tov(fsp);
 	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp,
 				      fc_fcp_pkt_destroy,
-				      fsp, jiffies_to_msecs(rec_tov));
+				      fsp, get_fsp_rec_tov(fsp));
 	if (!seq)
 		goto retry;
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 04ce7cf..ccf773a 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1772,7 +1772,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	if ((csp_flags & FC_SP_FT_FPORT) == 0) {
 		if (e_d_tov > lport->e_d_tov)
 			lport->e_d_tov = e_d_tov;
-		lport->r_a_tov = 2 * e_d_tov;
+		lport->r_a_tov = 2 * lport->e_d_tov;
 		fc_lport_set_port_id(lport, did, fp);
 		printk(KERN_INFO "host%d: libfc: "
 		       "Port (%6.6x) entered "
@@ -1784,8 +1784,10 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				   get_unaligned_be64(
 					   &flp->fl_wwnn));
 	} else {
-		lport->e_d_tov = e_d_tov;
-		lport->r_a_tov = r_a_tov;
+		if (e_d_tov > lport->e_d_tov)
+			lport->e_d_tov = e_d_tov;
+		if (r_a_tov > lport->r_a_tov)
+			lport->r_a_tov = r_a_tov;
 		fc_host_fabric_name(lport->host) =
 			get_unaligned_be64(&flp->fl_wwnn);
 		fc_lport_set_port_id(lport, did, fp);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 68d4c92..5a9c871 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1328,13 +1328,15 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 			tov = ntohl(rtv->rtv_r_a_tov);
 			if (tov == 0)
 				tov = 1;
-			rdata->r_a_tov = tov;
+			if (tov > rdata->r_a_tov)
+				rdata->r_a_tov = tov;
 			tov = ntohl(rtv->rtv_e_d_tov);
 			if (toq & FC_ELS_RTV_EDRES)
 				tov /= 1000000;
 			if (tov == 0)
 				tov = 1;
-			rdata->e_d_tov = tov;
+			if (tov > rdata->e_d_tov)
+				rdata->e_d_tov = tov;
 		}
 	}
 
-- 
1.8.5.6

