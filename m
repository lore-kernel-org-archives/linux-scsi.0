From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/22] libfc: Send LS_RJT responses on frame allocation failure
Date: Wed,  3 Aug 2016 15:13:17 +0200
Message-ID: <1470230002-37737-18-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbcHCNNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:36 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we fail to allocate a frame we should be sending an LS_RJT
response and not just silently drop the frame altogether.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index ec608ef..3edcc27 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -904,8 +904,12 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
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
@@ -918,7 +922,7 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 		fc_rport_enter_plogi(rdata);
 	else
 		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
-out:
+
 	mutex_unlock(&rdata->rp_mutex);
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 	fc_frame_free(rx_fp);
@@ -1481,8 +1485,12 @@ static void fc_rport_recv_adisc_req(struct fc_rport_priv *rdata,
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
@@ -1783,14 +1791,17 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
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

