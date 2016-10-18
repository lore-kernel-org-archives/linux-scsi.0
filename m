From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/20] libfc: Replace ->seq_release callback with function call
Date: Tue, 18 Oct 2016 10:01:54 +0200
Message-ID: <1476777714-3543-21-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755524AbcJRICh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:37 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->seq_release callback only ever had one implementation,
so call the function directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c    | 6 ++----
 drivers/target/tcm_fc/tfc_cmd.c | 2 +-
 include/scsi/libfc.h            | 8 +-------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index efb6a4b..442a6c1 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1497,10 +1497,11 @@ struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp)
  * fc_seq_release() - Release the hold
  * @sp:    The sequence.
  */
-static void fc_seq_release(struct fc_seq *sp)
+void fc_seq_release(struct fc_seq *sp)
 {
 	fc_exch_release(fc_seq_exch(sp));
 }
+EXPORT_SYMBOL(fc_seq_release);
 
 /**
  * fc_exch_recv_req() - Handler for an incoming request
@@ -2654,9 +2655,6 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.exch_mgr_reset)
 		lport->tt.exch_mgr_reset = fc_exch_mgr_reset;
 
-	if (!lport->tt.seq_release)
-		lport->tt.seq_release = fc_seq_release;
-
 	return 0;
 }
 EXPORT_SYMBOL(fc_exch_init);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index e684862..2581fff 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -92,7 +92,7 @@ static void ft_free_cmd(struct ft_cmd *cmd)
 	fp = cmd->req_frame;
 	lport = fr_dev(fp);
 	if (fr_seq(fp))
-		lport->tt.seq_release(fr_seq(fp));
+		fc_seq_release(fr_seq(fp));
 	fc_frame_free(fp);
 	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 	ft_sess_put(sess);	/* undo get from lookup at recv */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 2baa255..6f81b28 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -515,13 +515,6 @@ struct libfc_function_template {
 	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
 
 	/*
-	 * Release the reference on the sequence returned by seq_assign().
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*seq_release)(struct fc_seq *);
-
-	/*
 	 * Reset an exchange manager, completing all sequences and exchanges.
 	 * If s_id is non-zero, reset only exchanges originating from that FID.
 	 * If d_id is non-zero, reset only exchanges sending to that FID.
@@ -1000,6 +993,7 @@ void fc_seq_set_resp(struct fc_seq *sp,
 		     void (*resp)(struct fc_seq *, struct fc_frame *, void *),
 		     void *arg);
 struct fc_seq *fc_seq_assign(struct fc_lport *lport, struct fc_frame *fp);
+void fc_seq_release(struct fc_seq *sp);
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *,
 					   struct fc_exch_mgr *,
 					   bool (*match)(struct fc_frame *));
-- 
1.8.5.6

