From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/20] libfc: Replace ->seq_set_resp callback with direct function call
Date: Tue, 18 Oct 2016 10:01:52 +0200
Message-ID: <1476777714-3543-19-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47323 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758956AbcJRICf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:35 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->seq_set_resp callback only ever had one implementation,
so call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c    | 11 ++++-------
 drivers/target/tcm_fc/tfc_cmd.c |  2 +-
 include/scsi/libfc.h            | 13 +++----------
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 8a99f84..ceeccd7 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -602,10 +602,9 @@ struct fc_seq *fc_seq_start_next(struct fc_seq *sp)
  *
  * Note: May sleep if invoked from outside a response handler.
  */
-static void fc_seq_set_resp(struct fc_seq *sp,
-			    void (*resp)(struct fc_seq *, struct fc_frame *,
-					 void *),
-			    void *arg)
+void fc_seq_set_resp(struct fc_seq *sp,
+		     void (*resp)(struct fc_seq *, struct fc_frame *, void *),
+		     void *arg)
 {
 	struct fc_exch *ep = fc_seq_exch(sp);
 	DEFINE_WAIT(wait);
@@ -624,6 +623,7 @@ static void fc_seq_set_resp(struct fc_seq *sp,
 	ep->arg = arg;
 	spin_unlock_bh(&ep->ex_lock);
 }
+EXPORT_SYMBOL(fc_seq_set_resp);
 
 /**
  * fc_exch_abort_locked() - Abort an exchange
@@ -2650,9 +2650,6 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
  */
 int fc_exch_init(struct fc_lport *lport)
 {
-	if (!lport->tt.seq_set_resp)
-		lport->tt.seq_set_resp = fc_seq_set_resp;
-
 	if (!lport->tt.exch_mgr_reset)
 		lport->tt.exch_mgr_reset = fc_exch_mgr_reset;
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index bf6ab3f..6029b90 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -563,7 +563,7 @@ static void ft_send_work(struct work_struct *work)
 		task_attr = TCM_SIMPLE_TAG;
 	}
 
-	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
+	fc_seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 	cmd->se_cmd.tag = fc_seq_exch(cmd->seq)->rxid;
 	/*
 	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 39143ca..e8669f9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -515,16 +515,6 @@ struct libfc_function_template {
 	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
 
 	/*
-	 * Set a response handler for the exchange of the sequence.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*seq_set_resp)(struct fc_seq *sp,
-			     void (*resp)(struct fc_seq *, struct fc_frame *,
-					  void *),
-			     void *arg);
-
-	/*
 	 * Assign a sequence for an incoming request frame.
 	 *
 	 * STATUS: OPTIONAL
@@ -1013,6 +1003,9 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 void fc_seq_els_rsp_send(struct fc_frame *, enum fc_els_cmd,
 			 struct fc_seq_els_data *);
 struct fc_seq *fc_seq_start_next(struct fc_seq *sp);
+void fc_seq_set_resp(struct fc_seq *sp,
+		     void (*resp)(struct fc_seq *, struct fc_frame *, void *),
+		     void *arg);
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *,
 					   struct fc_exch_mgr *,
 					   bool (*match)(struct fc_frame *));
-- 
1.8.5.6

