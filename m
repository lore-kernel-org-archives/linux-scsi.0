From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/27] libfc: use rport timeout values for fcp recovery
Date: Tue, 30 Nov 2010 16:18:44 -0800
Message-ID: <20101201001844.18369.42776.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab0LAASo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:44 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: John Fastabend <john.r.fastabend@intel.com>

From: john fastabend <john.r.fastabend@intel.com>

Use the rport value for rec_tov for timeout values when
sending fcp commands. Currently, defaults are being used
which may or may not match the advertised values.

The default may cause i/o to timeout on networks that
set this value larger then the default value. To make
the timeout more configurable in the non-REC mode we
remove the FC_SCSI_ER_TIMEOUT completely allowing the
scsi-ml to do the timeout. This removes an unneeded
timer and allows the i/o timeout to be configured
using the scsi-ml knobs.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   58 +++++++++++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 87361cc..3cf81b9 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -57,6 +57,9 @@ struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_READ		(1 << 1)
 #define FC_SRB_WRITE		(1 << 0)
 
+/* constant added to e_d_tov timeout to get rec_tov value */
+#define REC_TOV_CONST		1
+
 /*
  * The SCp.ptr should be tested and set under the scsi_pkt_queue lock
  */
@@ -126,9 +129,7 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *, struct fc_frame *);
 /*
  * Error recovery timeout values.
  */
-#define FC_SCSI_ER_TIMEOUT	(10 * HZ)
 #define FC_SCSI_TM_TOV		(10 * HZ)
-#define FC_SCSI_REC_TOV		(2 * HZ)
 #define FC_HOST_RESET_TIMEOUT	(30 * HZ)
 #define FC_CAN_QUEUE_PERIOD	(60 * HZ)
 
@@ -1083,6 +1084,21 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 }
 
 /**
+ * get_fsp_rec_tov() - Helper function to get REC_TOV
+ * @fsp: the FCP packet
+ */
+static inline unsigned int get_fsp_rec_tov(struct fc_fcp_pkt *fsp)
+{
+	struct fc_rport *rport;
+	struct fc_rport_libfc_priv *rpriv;
+
+	rport = fsp->rport;
+	rpriv = rport->dd_data;
+
+	return rpriv->e_d_tov + REC_TOV_CONST;
+}
+
+/**
  * fc_fcp_cmd_send() - Send a FCP command
  * @lport: The local port to send the command on
  * @fsp:   The FCP packet the command is on
@@ -1099,6 +1115,7 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	struct fc_rport_libfc_priv *rpriv;
 	const size_t len = sizeof(fsp->cdb_cmd);
 	int rc = 0;
+	unsigned int rec_tov;
 
 	if (fc_fcp_lock_pkt(fsp))
 		return 0;
@@ -1129,10 +1146,12 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	fsp->seq_ptr = seq;
 	fc_fcp_pkt_hold(fsp);	/* hold for fc_fcp_pkt_destroy */
 
+	rec_tov = get_fsp_rec_tov(fsp);
+
 	setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
-	fc_fcp_timer_set(fsp,
-			 (fsp->tgt_flags & FC_RP_FLAGS_REC_SUPPORTED) ?
-			 FC_SCSI_REC_TOV : FC_SCSI_ER_TIMEOUT);
+
+	if (fsp->tgt_flags & FC_RP_FLAGS_REC_SUPPORTED)
+		fc_fcp_timer_set(fsp, rec_tov);
 unlock:
 	fc_fcp_unlock_pkt(fsp);
 	return rc;
@@ -1207,13 +1226,16 @@ static void fc_lun_reset_send(unsigned long data)
 {
 	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)data;
 	struct fc_lport *lport = fsp->lp;
+	unsigned int rec_tov;
+
 	if (lport->tt.fcp_cmd_send(lport, fsp, fc_tm_done)) {
 		if (fsp->recov_retry++ >= FC_MAX_RECOV_RETRY)
 			return;
 		if (fc_fcp_lock_pkt(fsp))
 			return;
+		rec_tov = get_fsp_rec_tov(fsp);
 		setup_timer(&fsp->timer, fc_lun_reset_send, (unsigned long)fsp);
-		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+		fc_fcp_timer_set(fsp, rec_tov);
 		fc_fcp_unlock_pkt(fsp);
 	}
 }
@@ -1351,9 +1373,6 @@ static void fc_fcp_timeout(unsigned long data)
 
 	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
 		fc_fcp_rec(fsp);
-	else if (time_after_eq(fsp->last_pkt_time + (FC_SCSI_ER_TIMEOUT / 2),
-			       jiffies))
-		fc_fcp_timer_set(fsp, FC_SCSI_ER_TIMEOUT);
 	else if (fsp->state & FC_SRB_RCV_STATUS)
 		fc_fcp_complete_locked(fsp);
 	else
@@ -1373,6 +1392,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	struct fc_frame *fp;
 	struct fc_rport *rport;
 	struct fc_rport_libfc_priv *rpriv;
+	unsigned int rec_tov;
 
 	lport = fsp->lp;
 	rport = fsp->rport;
@@ -1383,6 +1403,9 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 		fc_fcp_complete_locked(fsp);
 		return;
 	}
+
+	rec_tov = get_fsp_rec_tov(fsp);
+
 	fp = fc_fcp_frame_alloc(lport, sizeof(struct fc_els_rec));
 	if (!fp)
 		goto retry;
@@ -1393,13 +1416,13 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 		       FC_FCTL_REQ, 0);
 	if (lport->tt.elsct_send(lport, rport->port_id, fp, ELS_REC,
 				 fc_fcp_rec_resp, fsp,
-				 jiffies_to_msecs(FC_SCSI_REC_TOV))) {
+				 jiffies_to_msecs(rec_tov))) {
 		fc_fcp_pkt_hold(fsp);		/* hold while REC outstanding */
 		return;
 	}
 retry:
 	if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
-		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+		fc_fcp_timer_set(fsp, rec_tov);
 	else
 		fc_fcp_recovery(fsp, FC_TIMED_OUT);
 }
@@ -1455,7 +1478,6 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 			 * making progress.
 			 */
 			rpriv->flags &= ~FC_RP_FLAGS_REC_SUPPORTED;
-			fc_fcp_timer_set(fsp, FC_SCSI_ER_TIMEOUT);
 			break;
 		case ELS_RJT_LOGIC:
 		case ELS_RJT_UNAB:
@@ -1508,12 +1530,12 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 			}
 			fc_fcp_srr(fsp, r_ctl, offset);
 		} else if (e_stat & ESB_ST_SEQ_INIT) {
-
+			unsigned int rec_tov = get_fsp_rec_tov(fsp);
 			/*
 			 * The remote port has the initiative, so just
 			 * keep waiting for it to complete.
 			 */
-			fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+			fc_fcp_timer_set(fsp, rec_tov);
 		} else {
 
 			/*
@@ -1626,6 +1648,7 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 	struct fcp_srr *srr;
 	struct fc_frame *fp;
 	u8 cdb_op;
+	unsigned int rec_tov;
 
 	rport = fsp->rport;
 	rpriv = rport->dd_data;
@@ -1650,8 +1673,9 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 		       rpriv->local_port->port_id, FC_TYPE_FCP,
 		       FC_FCTL_REQ, 0);
 
+	rec_tov = get_fsp_rec_tov(fsp);
 	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp, NULL,
-				      fsp, jiffies_to_msecs(FC_SCSI_REC_TOV));
+				      fsp, jiffies_to_msecs(rec_tov));
 	if (!seq)
 		goto retry;
 
@@ -1675,6 +1699,7 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 {
 	struct fc_fcp_pkt *fsp = arg;
 	struct fc_frame_header *fh;
+	unsigned int rec_tov;
 
 	if (IS_ERR(fp)) {
 		fc_fcp_srr_error(fsp, fp);
@@ -1701,7 +1726,8 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	switch (fc_frame_payload_op(fp)) {
 	case ELS_LS_ACC:
 		fsp->recov_retry = 0;
-		fc_fcp_timer_set(fsp, FC_SCSI_REC_TOV);
+		rec_tov = get_fsp_rec_tov(fsp);
+		fc_fcp_timer_set(fsp, rec_tov);
 		break;
 	case ELS_LS_RJT:
 	default:

