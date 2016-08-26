From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/30] libfc: don't advance state machine for incoming FLOGI
Date: Fri, 26 Aug 2016 14:01:33 +0200
Message-ID: <1472212913-39810-11-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35057 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbcHZMCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:06 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we receive an FLOGI but have already sent our own we should
not advance the state machine but rather wait for our FLOGI to
return before continuing with PLOGI.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index f9b6f59..91866a5 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -775,6 +775,7 @@ static void fc_rport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	flogi = fc_frame_payload_get(fp, sizeof(*flogi));
 	if (!flogi) {
+		FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
 		err = -FC_EX_ALLOC_ERR;
 		goto bad;
 	}
@@ -794,7 +795,6 @@ put:
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 	return;
 bad:
-	FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
 	fc_rport_error_retry(rdata, err);
 	goto out;
 }
@@ -940,11 +940,17 @@ static void fc_rport_recv_flogi_req(struct fc_lport *lport,
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
 	lport->tt.frame_send(lport, fp);
 
-	if (rdata->ids.port_name < lport->wwpn)
-		fc_rport_enter_plogi(rdata);
-	else
-		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
-
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
 	mutex_unlock(&rdata->rp_mutex);
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 	fc_frame_free(rx_fp);
-- 
1.8.5.6

