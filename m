From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 6/7] libfc: don't advance state machine for incoming FLOGI
Date: Fri, 30 Sep 2016 11:01:19 +0200
Message-ID: <1475226080-60365-7-git-send-email-hare@suse.de>
References: <1475226080-60365-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34039 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752998AbcI3JBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 05:01:31 -0400
In-Reply-To: <1475226080-60365-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we receive an FLOGI but have already sent our own we should
not advance the state machine but rather wait for our FLOGI to
return before continuing with PLOGI.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 72a7183..4b9bb6d 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -765,8 +765,10 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 		goto bad;
 
 	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
-	if (!flogi)
+	if (!flogi) {
+		FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
 		goto bad;
+	}
 	r_a_tov = ntohl(flogi->fl_csp.sp_r_a_tov);
 	if (r_a_tov > rdata->r_a_tov)
 		rdata->r_a_tov = r_a_tov;
@@ -783,7 +785,6 @@ put:
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 	return;
 bad:
-	FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
 	fc_rport_error_retry(rdata, fp);
 	goto out;
 }
@@ -925,10 +926,17 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
 	lport->tt.frame_send(lport, fp);
 
-	if (rdata->ids.port_name < lport->wwpn)
-		fc_rport_enter_plogi(rdata);
-	else
-		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
+	/*
+	 * Do not proceed with the state machine if our
+	 * FLOGI has crossed with an FLOGI from the
+	 * remote port; wait for the FLOGI response instead.
+	 */
+	if (rdata->rp_state != RPORT_ST_FLOGI) {
+		if (rdata->ids.port_name < lport->wwpn)
+			fc_rport_enter_plogi(rdata);
+		else
+			fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
+	}
 out:
 	mutex_unlock(&rdata->rp_mutex);
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
-- 
1.8.5.6

