From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/20] libfc: Replace ->seq_send callback with function call
Date: Tue, 18 Oct 2016 10:01:48 +0200
Message-ID: <1476777714-3543-15-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752363AbcJRICc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:32 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->seq_send callback only ever had one implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c    | 7 ++-----
 drivers/scsi/libfc/fc_fcp.c     | 4 ++--
 drivers/target/tcm_fc/tfc_cmd.c | 6 +++---
 drivers/target/tcm_fc/tfc_io.c  | 2 +-
 include/scsi/libfc.h            | 8 +-------
 5 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index f5c3c1d..ee34cc6 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -533,8 +533,7 @@ static int fc_seq_send_locked(struct fc_lport *lport, struct fc_seq *sp,
  * Note: The frame will be freed either by a direct call to fc_frame_free(fp)
  * or indirectly by calling libfc_function_template.frame_send().
  */
-static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
-		       struct fc_frame *fp)
+int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp, struct fc_frame *fp)
 {
 	struct fc_exch *ep;
 	int error;
@@ -544,6 +543,7 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 	spin_unlock_bh(&ep->ex_lock);
 	return error;
 }
+EXPORT_SYMBOL(fc_seq_send);
 
 /**
  * fc_seq_alloc() - Allocate a sequence for a given exchange
@@ -2648,9 +2648,6 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_set_resp)
 		lport->tt.seq_set_resp = fc_seq_set_resp;
 
-	if (!lport->tt.seq_send)
-		lport->tt.seq_send = fc_seq_send;
-
 	if (!lport->tt.exch_done)
 		lport->tt.exch_done = fc_exch_done;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5cf1d2e..daad70f 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -731,7 +731,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 		/*
 		 * send fragment using for a sequence.
 		 */
-		error = lport->tt.seq_send(lport, seq, fp);
+		error = fc_seq_send(lport, seq, fp);
 		if (error) {
 			WARN_ON(1);		/* send error should be rare */
 			return error;
@@ -1033,7 +1033,7 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 				fc_fill_fc_hdr(conf_frame, FC_RCTL_DD_SOL_CTL,
 					       ep->did, ep->sid,
 					       FC_TYPE_FCP, f_ctl, 0);
-				lport->tt.seq_send(lport, csp, conf_frame);
+				fc_seq_send(lport, csp, conf_frame);
 			}
 		}
 		lport->tt.exch_done(seq);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 216e18c..7dc0eb7 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -165,7 +165,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_CMD_STATUS, ep->did, ep->sid, FC_TYPE_FCP,
 		       FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ, 0);
 
-	rc = lport->tt.seq_send(lport, cmd->seq, fp);
+	rc = fc_seq_send(lport, cmd->seq, fp);
 	if (rc) {
 		pr_info_ratelimited("%s: Failed to send response frame %p, "
 				    "xid <0x%x>\n", __func__, fp, ep->xid);
@@ -242,7 +242,7 @@ int ft_write_pending(struct se_cmd *se_cmd)
 				cmd->was_ddp_setup = 1;
 		}
 	}
-	lport->tt.seq_send(lport, cmd->seq, fp);
+	fc_seq_send(lport, cmd->seq, fp);
 	return 0;
 }
 
@@ -323,7 +323,7 @@ static void ft_send_resp_status(struct fc_lport *lport,
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_DD_CMD_STATUS, 0);
 	sp = fr_seq(fp);
 	if (sp) {
-		lport->tt.seq_send(lport, sp, fp);
+		fc_seq_send(lport, sp, fp);
 		lport->tt.exch_done(sp);
 	} else {
 		lport->tt.frame_send(lport, fp);
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 6f7c65a..b10ebfd 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -174,7 +174,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			f_ctl |= FC_FC_END_SEQ;
 		fc_fill_fc_hdr(fp, FC_RCTL_DD_SOL_DATA, ep->did, ep->sid,
 			       FC_TYPE_FCP, f_ctl, fh_off);
-		error = lport->tt.seq_send(lport, seq, fp);
+		error = fc_seq_send(lport, seq, fp);
 		if (error) {
 			pr_info_ratelimited("%s: Failed to send frame %p, "
 						"xid <0x%x>, remaining %zu, "
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a776901..7514cc9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -513,13 +513,6 @@ struct libfc_function_template {
 	 * STATUS: OPTIONAL
 	 */
 	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
-	/*
-	 * Send a frame using an existing sequence and exchange.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	int (*seq_send)(struct fc_lport *, struct fc_seq *,
-			struct fc_frame *);
 
 	/*
 	 * Abort an exchange and sequence. Generally called because of a
@@ -1058,6 +1051,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *, enum fc_class class,
 void fc_exch_mgr_free(struct fc_lport *);
 void fc_exch_recv(struct fc_lport *, struct fc_frame *);
 void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
+int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp, struct fc_frame *fp);
 
 /*
  * Functions for fc_functions_template
-- 
1.8.5.6

