From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/24] libfc: wait for E_D_TOV when out-of-order sequence is received
Date: Thu, 13 Oct 2016 15:10:54 +0200
Message-ID: <1476364260-12191-19-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbcJMNeC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:34:02 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When detecting an out-of-order sequence we should be waiting for
E_D_TOV before trying to abort the sequence.
The response might still be stuck in the queue somewhere.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index fb2ebc7..c033946 100644
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
@@ -562,8 +578,10 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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
@@ -943,7 +961,7 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 				   "len %x, data len %x\n",
 				   fsp->rport->port_id,
 				   fsp->xfer_len, expected_len, fsp->data_len);
-			fc_fcp_timer_set(fsp, 2);
+			fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 			return;
 		}
 		fsp->status_code = FC_DATA_OVRRUN;
@@ -1152,22 +1170,6 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
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

