From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/20] libfc: Replace ->exch_done callback with function call
Date: Tue, 18 Oct 2016 10:01:50 +0200
Message-ID: <1476777714-3543-17-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752448AbcJRICe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:34 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->exch_done callback only ever had one implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c    |  6 ++----
 drivers/scsi/libfc/fc_fcp.c     | 20 +++++++++-----------
 drivers/scsi/libfc/fc_lport.c   |  2 +-
 drivers/target/tcm_fc/tfc_cmd.c |  4 ++--
 include/scsi/libfc.h            |  9 +--------
 5 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index fffb9a3..b98ad3f 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -969,7 +969,7 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
  *
  * Note: May sleep if invoked from outside a response handler.
  */
-static void fc_exch_done(struct fc_seq *sp)
+void fc_exch_done(struct fc_seq *sp)
 {
 	struct fc_exch *ep = fc_seq_exch(sp);
 	int rc;
@@ -982,6 +982,7 @@ static void fc_exch_done(struct fc_seq *sp)
 	if (!rc)
 		fc_exch_delete(ep);
 }
+EXPORT_SYMBOL(fc_exch_done);
 
 /**
  * fc_exch_resp() - Allocate a new exchange for a response frame
@@ -2654,9 +2655,6 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_set_resp)
 		lport->tt.seq_set_resp = fc_seq_set_resp;
 
-	if (!lport->tt.exch_done)
-		lport->tt.exch_done = fc_exch_done;
-
 	if (!lport->tt.exch_mgr_reset)
 		lport->tt.exch_mgr_reset = fc_exch_mgr_reset;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 2bb3f9f..4fadd62 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -311,7 +311,7 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 static void fc_fcp_retry_cmd(struct fc_fcp_pkt *fsp, int status_code)
 {
 	if (fsp->seq_ptr) {
-		fsp->lp->tt.exch_done(fsp->seq_ptr);
+		fc_exch_done(fsp->seq_ptr);
 		fsp->seq_ptr = NULL;
 	}
 
@@ -1036,7 +1036,7 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 				fc_seq_send(lport, csp, conf_frame);
 			}
 		}
-		lport->tt.exch_done(seq);
+		fc_exch_done(seq);
 	}
 	/*
 	 * Some resets driven by SCSI are not I/Os and do not have
@@ -1054,10 +1054,8 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
  */
 static void fc_fcp_cleanup_cmd(struct fc_fcp_pkt *fsp, int error)
 {
-	struct fc_lport *lport = fsp->lp;
-
 	if (fsp->seq_ptr) {
-		lport->tt.exch_done(fsp->seq_ptr);
+		fc_exch_done(fsp->seq_ptr);
 		fsp->seq_ptr = NULL;
 	}
 	fsp->status_code = error;
@@ -1349,7 +1347,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	if (fsp->seq_ptr) {
-		lport->tt.exch_done(fsp->seq_ptr);
+		fc_exch_done(fsp->seq_ptr);
 		fsp->seq_ptr = NULL;
 	}
 	fsp->wait_for_comp = 0;
@@ -1403,7 +1401,7 @@ static void fc_tm_done(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	if (fh->fh_type != FC_TYPE_BLS)
 		fc_fcp_resp(fsp, fp);
 	fsp->seq_ptr = NULL;
-	fsp->lp->tt.exch_done(seq);
+	fc_exch_done(seq);
 out_unlock:
 	fc_fcp_unlock_pkt(fsp);
 out:
@@ -1793,9 +1791,9 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 
 	fh = fc_frame_header_get(fp);
 	/*
-	 * BUG? fc_fcp_srr_error calls exch_done which would release
+	 * BUG? fc_fcp_srr_error calls fc_exch_done which would release
 	 * the ep. But if fc_fcp_srr_error had got -FC_EX_TIMEOUT,
-	 * then fc_exch_timeout would be sending an abort. The exch_done
+	 * then fc_exch_timeout would be sending an abort. The fc_exch_done
 	 * call by fc_fcp_srr_error would prevent fc_exch.c from seeing
 	 * an abort response though.
 	 */
@@ -1816,7 +1814,7 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	}
 	fc_fcp_unlock_pkt(fsp);
 out:
-	fsp->lp->tt.exch_done(seq);
+	fc_exch_done(seq);
 	fc_frame_free(fp);
 }
 
@@ -1846,7 +1844,7 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	}
 	fc_fcp_unlock_pkt(fsp);
 out:
-	fsp->lp->tt.exch_done(fsp->recov_seq);
+	fc_exch_done(fsp->recov_seq);
 }
 
 /**
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7315675..2d3133f 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -980,7 +980,7 @@ void fc_lport_recv(struct fc_lport *lport, struct fc_frame *fp)
 	FC_LPORT_DBG(lport, "dropping unexpected frame type %x\n", fh->fh_type);
 	fc_frame_free(fp);
 	if (sp)
-		lport->tt.exch_done(sp);
+		fc_exch_done(sp);
 }
 EXPORT_SYMBOL(fc_lport_recv);
 
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 7dc0eb7..07d392b 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -177,7 +177,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
 		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
 		return -ENOMEM;
 	}
-	lport->tt.exch_done(cmd->seq);
+	fc_exch_done(cmd->seq);
 	/*
 	 * Drop the extra ACK_KREF reference taken by target_submit_cmd()
 	 * ahead of ft_check_stop_free() -> transport_generic_free_cmd()
@@ -324,7 +324,7 @@ static void ft_send_resp_status(struct fc_lport *lport,
 	sp = fr_seq(fp);
 	if (sp) {
 		fc_seq_send(lport, sp, fp);
-		lport->tt.exch_done(sp);
+		fc_exch_done(sp);
 	} else {
 		lport->tt.frame_send(lport, fp);
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 50d1af1..19f38eb 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -515,14 +515,6 @@ struct libfc_function_template {
 	void (*get_lesb)(struct fc_lport *, struct fc_els_lesb *lesb);
 
 	/*
-	 * Indicate that an exchange/sequence tuple is complete and the memory
-	 * allocated for the related objects may be freed.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*exch_done)(struct fc_seq *);
-
-	/*
 	 * Start a new sequence on the same exchange/sequence tuple.
 	 *
 	 * STATUS: OPTIONAL
@@ -1040,6 +1032,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *, enum fc_class class,
 void fc_exch_mgr_reset(struct fc_lport *, u32 s_id, u32 d_id);
 int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp, struct fc_frame *fp);
 int fc_seq_exch_abort(const struct fc_seq *, unsigned int timer_msec);
+void fc_exch_done(struct fc_seq *sp);
 
 /*
  * Functions for fc_functions_template
-- 
1.8.5.6

