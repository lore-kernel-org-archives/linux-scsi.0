From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/30] libfc: wait for E_D_TOV when out-of-order sequence is received
Date: Fri, 26 Aug 2016 14:01:46 +0200
Message-ID: <1472212913-39810-24-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752381AbcHZMCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:13 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When detecting an out-of-order sequence we should be waiting for
E_D_TOV before trying to abort the sequence.
The response might still be stuck in the queue somewhere.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 3e059e4..f087c6e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -460,6 +460,22 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 }
 
 /**
+ * get_fsp_rec_tov() - Helper function to get REC_TOV
+ * @fsp: the FCP packet
+ *
+ * Returns rec tov in jiffies as rpriv->e_d_tov + 1 second
+ */
+static inline unsigned int get_fsp_rec_tov(struct fc_fcp_pkt *fsp)
+{
+	struct fc_rport_libfc_priv *rpriv = fsp->rport->dd_data;
+	unsigned int e_d_tov = FC_DEF_E_D_TOV;
+
+	if (rpriv && rpriv->e_d_tov > e_d_tov)
+		e_d_tov = rpriv->e_d_tov;
+	return msecs_to_jiffies(e_d_tov) + HZ;
+}
+
+/**
  * fc_fcp_recv_data() - Handler for receiving SCSI-FCP data from a target
  * @fsp: The FCP packet the data is on
  * @fp:	 The data frame
@@ -562,8 +578,10 @@ crc_err:
 	 * and completes the transfer, call the completion handler.
 	 */
 	if (unlikely(fsp->state & FC_SRB_RCV_STATUS) &&
-	    fsp->xfer_len == fsp->data_len - fsp->scsi_resid)
+	    fsp->xfer_len == fsp->data_len - fsp->scsi_resid) {
+		FC_FCP_DBG( fsp, "complete out-of-order sequence\n" );
 		fc_fcp_complete_locked(fsp);
+	}
 	return;
 err:
 	fc_fcp_recovery(fsp, host_bcode);
@@ -944,7 +962,7 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 				   "len %x, data len %x\n",
 				   fsp->rport->port_id,
 				   fsp->xfer_len, expected_len, fsp->data_len);
-			fc_fcp_timer_set(fsp, 2);
+			fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 			return;
 		}
 		fsp->status_code = FC_DATA_OVRRUN;
@@ -1154,22 +1172,6 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 }
 
 /**
- * get_fsp_rec_tov() - Helper function to get REC_TOV
- * @fsp: the FCP packet
- *
- * Returns rec tov in jiffies as rpriv->e_d_tov + 1 second
- */
-static inline unsigned int get_fsp_rec_tov(struct fc_fcp_pkt *fsp)
-{
-	struct fc_rport_libfc_priv *rpriv = fsp->rport->dd_data;
-	unsigned int e_d_tov = FC_DEF_E_D_TOV;
-
-	if (rpriv && rpriv->e_d_tov > e_d_tov)
-		e_d_tov = rpriv->e_d_tov;
-	return msecs_to_jiffies(e_d_tov) + HZ;
-}
-
-/**
  * fc_fcp_cmd_send() - Send a FCP command
  * @lport: The local port to send the command on
  * @fsp:   The FCP packet the command is on
-- 
1.8.5.6

