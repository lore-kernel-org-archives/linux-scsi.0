From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/20] libfc: Replace ->seq_assign callback with function call
Date: Tue, 18 Oct 2016 10:01:53 +0200
Message-ID: <1476777714-3543-20-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758957AbcJRICf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:35 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->seq_assign callback only ever had one implementation,
so call the function directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c    | 6 ++----
 drivers/target/tcm_fc/tfc_cmd.c | 2 +-
 include/scsi/libfc.h            | 8 +-------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index ceeccd7..efb6a4b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1477,7 +1477,7 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
  * A reference will be held on the exchange/sequence for the caller, which
  * must call fc_seq_release().
  */
-static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
+struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_exch_mgr_anchor *ema;
 
@@ -1491,6 +1491,7 @@ static struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
 			break;
 	return fr_seq(fp);
 }
+EXPORT_SYMBOL(fc_seq_assign);
 
 /**
  * fc_seq_release() - Release the hold
@@ -2653,9 +2654,6 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.exch_mgr_reset)
 		lport->tt.exch_mgr_reset = fc_exch_mgr_reset;
 
-	if (!lport->tt.seq_assign)
-		lport->tt.seq_assign = fc_seq_assign;
-
 	if (!lport->tt.seq_release)
 		lport->tt.seq_release = fc_seq_release;
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 6029b90..e684862 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -461,7 +461,7 @@ static void ft_recv_cmd(struct ft_sess *sess, struct fc_frame *fp)
 
 	cmd->se_cmd.map_tag = tag;
 	cmd->sess = sess;
-	cmd->seq = lport->tt.seq_assign(lport, fp);
+	cmd->seq = fc_seq_assign(lport, fp);
 	if (!cmd->seq) {
 		percpu_ida_free(&se_sess->sess_tag_pool, tag);
 		goto busy;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index e8669f9..2baa255 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -515,13 +515,6 @@ struct libfc_function_template {
 	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
 
 	/*
-	 * Assign a sequence for an incoming request frame.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	struct fc_seq *(*seq_assign)(struct fc_lport *, struct fc_frame *);
-
-	/*
 	 * Release the reference on the sequence returned by seq_assign().
 	 *
 	 * STATUS: OPTIONAL
@@ -1006,6 +999,7 @@ void fc_seq_els_rsp_send(struct fc_frame *, enum fc_els_cmd,
 void fc_seq_set_resp(struct fc_seq *sp,
 		     void (*resp)(struct fc_seq *, struct fc_frame *, void *),
 		     void *arg);
+struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp);
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *,
 					   struct fc_exch_mgr *,
 					   bool (*match)(struct fc_frame *));
-- 
1.8.5.6

