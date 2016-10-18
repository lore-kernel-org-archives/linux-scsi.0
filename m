From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/20] libfc: Replace ->seq_start_next callback with function call
Date: Tue, 18 Oct 2016 10:01:51 +0200
Message-ID: <1476777714-3543-18-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47411 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758964AbcJRICh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:37 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->seq_start_next callback only ever had one implementation,
so call the function directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c    | 6 ++----
 drivers/scsi/libfc/fc_fcp.c     | 4 ++--
 drivers/scsi/libfc/fc_libfc.c   | 2 +-
 drivers/target/tcm_fc/tfc_cmd.c | 4 ++--
 drivers/target/tcm_fc/tfc_io.c  | 2 +-
 include/scsi/libfc.h            | 8 +-------
 6 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index b98ad3f..8a99f84 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -585,7 +585,7 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp)
  *			 for a given sequence/exchange pair
  * @sp: The sequence/exchange to get a new exchange for
  */
-static struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
+struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
 {
 	struct fc_exch *ep = fc_seq_exch(sp);
 
@@ -595,6 +595,7 @@ static struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
 
 	return sp;
 }
+EXPORT_SYMBOL(fc_seq_start_next);
 
 /*
  * Set the response handler for the exchange associated with a sequence.
@@ -2649,9 +2650,6 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
  */
 int fc_exch_init(struct fc_lport *lport)
 {
-	if (!lport->tt.seq_start_next)
-		lport->tt.seq_start_next = fc_seq_start_next;
-
 	if (!lport->tt.seq_set_resp)
 		lport->tt.seq_set_resp = fc_seq_set_resp;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 4fadd62..0e67621 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -653,7 +653,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	remaining = seq_blen;
 	fh_parm_offset = frame_offset = offset;
 	tlen = 0;
-	seq = lport->tt.seq_start_next(seq);
+	seq = fc_seq_start_next(seq);
 	f_ctl = FC_FC_REL_OFF;
 	WARN_ON(!seq);
 
@@ -1024,7 +1024,7 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 			struct fc_frame *conf_frame;
 			struct fc_seq *csp;
 
-			csp = lport->tt.seq_start_next(seq);
+			csp = fc_seq_start_next(seq);
 			conf_frame = fc_fcp_frame_alloc(fsp->lp, 0);
 			if (conf_frame) {
 				f_ctl = FC_FC_SEQ_INIT;
diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index c11a638..d623d08 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -226,7 +226,7 @@ void fc_fill_reply_hdr(struct fc_frame *fp, const struct fc_frame *in_fp,
 
 	sp = fr_seq(in_fp);
 	if (sp)
-		fr_seq(fp) = fr_dev(in_fp)->tt.seq_start_next(sp);
+		fr_seq(fp) = fc_seq_start_next(sp);
 	fc_fill_hdr(fp, in_fp, r_ctl, FC_FCTL_RESP, 0, parm_offset);
 }
 EXPORT_SYMBOL(fc_fill_reply_hdr);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 07d392b..bf6ab3f 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -161,7 +161,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
 	/*
 	 * Send response.
 	 */
-	cmd->seq = lport->tt.seq_start_next(cmd->seq);
+	cmd->seq = fc_seq_start_next(cmd->seq);
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_CMD_STATUS, ep->did, ep->sid, FC_TYPE_FCP,
 		       FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ, 0);
 
@@ -221,7 +221,7 @@ int ft_write_pending(struct se_cmd *se_cmd)
 	memset(txrdy, 0, sizeof(*txrdy));
 	txrdy->ft_burst_len = htonl(se_cmd->data_length);
 
-	cmd->seq = lport->tt.seq_start_next(cmd->seq);
+	cmd->seq = fc_seq_start_next(cmd->seq);
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_DATA_DESC, ep->did, ep->sid, FC_TYPE_FCP,
 		       FC_FC_EX_CTX | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index b10ebfd..1eb1f58 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -82,7 +82,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 
 	ep = fc_seq_exch(cmd->seq);
 	lport = ep->lp;
-	cmd->seq = lport->tt.seq_start_next(cmd->seq);
+	cmd->seq = fc_seq_start_next(cmd->seq);
 
 	remaining = se_cmd->data_length;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 19f38eb..39143ca 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -515,13 +515,6 @@ struct libfc_function_template {
 	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
 
 	/*
-	 * Start a new sequence on the same exchange/sequence tuple.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	struct fc_seq *(*seq_start_next)(struct fc_seq *);
-
-	/*
 	 * Set a response handler for the exchange of the sequence.
 	 *
 	 * STATUS: OPTIONAL
@@ -1019,6 +1012,7 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 				void *arg, u32 timer_msec);
 void fc_seq_els_rsp_send(struct fc_frame *, enum fc_els_cmd,
 			 struct fc_seq_els_data *);
+struct fc_seq *fc_seq_start_next(struct fc_seq *sp);
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *,
 					   struct fc_exch_mgr *,
 					   bool (*match)(struct fc_frame *));
-- 
1.8.5.6

