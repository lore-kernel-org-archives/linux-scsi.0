From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/30] libfc: Send LS_RJT responses on frame allocation
Date: Fri, 26 Aug 2016 14:01:32 +0200
Message-ID: <1472212913-39810-10-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbcHZMCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:11 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we fail to allocate a frame we should be sending an LS_RJT
response and not just silently drop the frame altogether.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 29a51c6..f9b6f59 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -926,8 +926,12 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	}
 
 	fp = fc_frame_alloc(lport, sizeof(*flp));
-	if (!fp)
-		goto out;
+	if (!fp) {
+		mutex_unlock(&rdata->rp_mutex);
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
+		goto reject_put;
+	}
 
 	fc_flogi_fill(lport, fp);
 	flp = fc_frame_payload_get(fp, sizeof(*flp));
@@ -940,7 +944,7 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		fc_rport_enter_plogi(rdata);
 	else
 		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
-out:
+
 	mutex_unlock(&rdata->rp_mutex);
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 	fc_frame_free(rx_fp);
@@ -1503,8 +1507,12 @@ static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
 	}
 
 	fp = fc_frame_alloc(lport, sizeof(*adisc));
-	if (!fp)
+	if (!fp) {
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
+		lport->tt.seq_els_rsp_send(in_fp, ELS_LS_RJT, &rjt_data);
 		goto drop;
+	}
 	fc_adisc_fill(lport, fp);
 	adisc = fc_frame_payload_get(fp, sizeof(*adisc));
 	adisc->adisc_cmd = ELS_LS_ACC;
@@ -1812,14 +1820,17 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
 	 * Send LS_ACC.	 If this fails, the originator should retry.
 	 */
 	fp = fc_frame_alloc(lport, sizeof(*pl));
-	if (!fp)
-		goto out;
-
+	if (!fp) {
+		mutex_unlock(&rdata->rp_mutex);
+		rjt_data.reason = ELS_RJT_UNAB;
+		rjt_data.explan = ELS_EXPL_INSUF_RES;
+		goto reject;
+	}
 	fc_plogi_fill(lport, fp, ELS_LS_ACC);
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
 	lport->tt.frame_send(lport, fp);
 	fc_rport_enter_prli(rdata);
-out:
+
 	mutex_unlock(&rdata->rp_mutex);
 	fc_frame_free(rx_fp);
 	return;
-- 
1.8.5.6

