From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/11] libfc: rec tov value and REC_TOV_CONST units usages is
	incorrect
Date: Fri, 01 Apr 2011 16:06:40 -0700
Message-ID: <20110401230640.15001.74871.stgit@localhost6.localdomain6>
References: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab1DAXGl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 19:06:41 -0400
In-Reply-To: <20110401230548.15001.2009.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Added REC_TOV_CONST intent was to have rec tov as e_d_tov + 1s
but currently it is e_d_tov + 1ms since e_d_tov is stored in ms
unit.

Also returned rec tov by get_fsp_rec_tov is in ms and this ms tov
is used as-is with fc_fcp_timer_set expecting jiffies tov.

Fixed this by having get_fsp_rec_tov return rec tov in jiffies
as e_d_tov + 1s and then use jiffies tov w/ fc_fcp_timer_set.

Also some cleanup, no need to cache get_fsp_rec_tov return value
in local rec_tov at various places.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   32 +++++++++-----------------------
 1 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 92ba9f0..a879c96 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -57,9 +57,6 @@ static struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_READ		(1 << 1)
 #define FC_SRB_WRITE		(1 << 0)
 
-/* constant added to e_d_tov timeout to get rec_tov value */
-#define REC_TOV_CONST		1
-
 /*
  * The SCp.ptr should be tested and set under the scsi_pkt_queue lock
  */
@@ -248,7 +245,7 @@ static inline void fc_fcp_unlock_pkt(struct fc_fcp_pkt *fsp)
 /**
  * fc_fcp_timer_set() - Start a timer for a fcp_pkt
  * @fsp:   The FCP packet to start a timer for
- * @delay: The timeout period for the timer
+ * @delay: The timeout period in jiffies
  */
 static void fc_fcp_timer_set(struct fc_fcp_pkt *fsp, unsigned long delay)
 {
@@ -1098,16 +1095,14 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 /**
  * get_fsp_rec_tov() - Helper function to get REC_TOV
  * @fsp: the FCP packet
+ *
+ * Returns rec tov in jiffies as rpriv->e_d_tov + 1 second
  */
 static inline unsigned int get_fsp_rec_tov(struct fc_fcp_pkt *fsp)
 {
-	struct fc_rport *rport;
-	struct fc_rport_libfc_priv *rpriv;
+	struct fc_rport_libfc_priv *rpriv = fsp->rport->dd_data;
 
-	rport = fsp->rport;
-	rpriv = rport->dd_data;
-
-	return rpriv->e_d_tov + REC_TOV_CONST;
+	return msecs_to_jiffies(rpriv->e_d_tov) + HZ;
 }
 
 /**
@@ -1127,7 +1122,6 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	struct fc_rport_libfc_priv *rpriv;
 	const size_t len = sizeof(fsp->cdb_cmd);
 	int rc = 0;
-	unsigned int rec_tov;
 
 	if (fc_fcp_lock_pkt(fsp))
 		return 0;
@@ -1158,12 +1152,9 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	fsp->seq_ptr = seq;
 	fc_fcp_pkt_hold(fsp);	/* hold for fc_fcp_pkt_destroy */
 
-	rec_tov = get_fsp_rec_tov(fsp);
-
 	setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
-
 	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
-		fc_fcp_timer_set(fsp, rec_tov);
+		fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 
 unlock:
 	fc_fcp_unlock_pkt(fsp);
@@ -1240,16 +1231,14 @@ static void fc_lun_reset_send(unsigned long data)
 {
 	struct fc_fcp_pkt *fsp = (struct fc_fcp_pkt *)data;
 	struct fc_lport *lport = fsp->lp;
-	unsigned int rec_tov;
 
 	if (lport->tt.fcp_cmd_send(lport, fsp, fc_tm_done)) {
 		if (fsp->recov_retry++ >= FC_MAX_RECOV_RETRY)
 			return;
 		if (fc_fcp_lock_pkt(fsp))
 			return;
-		rec_tov = get_fsp_rec_tov(fsp);
 		setup_timer(&fsp->timer, fc_lun_reset_send, (unsigned long)fsp);
-		fc_fcp_timer_set(fsp, rec_tov);
+		fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 		fc_fcp_unlock_pkt(fsp);
 	}
 }
@@ -1541,12 +1530,11 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 			}
 			fc_fcp_srr(fsp, r_ctl, offset);
 		} else if (e_stat & ESB_ST_SEQ_INIT) {
-			unsigned int rec_tov = get_fsp_rec_tov(fsp);
 			/*
 			 * The remote port has the initiative, so just
 			 * keep waiting for it to complete.
 			 */
-			fc_fcp_timer_set(fsp, rec_tov);
+			fc_fcp_timer_set(fsp,  get_fsp_rec_tov(fsp));
 		} else {
 
 			/*
@@ -1710,7 +1698,6 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 {
 	struct fc_fcp_pkt *fsp = arg;
 	struct fc_frame_header *fh;
-	unsigned int rec_tov;
 
 	if (IS_ERR(fp)) {
 		fc_fcp_srr_error(fsp, fp);
@@ -1737,8 +1724,7 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	switch (fc_frame_payload_op(fp)) {
 	case ELS_LS_ACC:
 		fsp->recov_retry = 0;
-		rec_tov = get_fsp_rec_tov(fsp);
-		fc_fcp_timer_set(fsp, rec_tov);
+		fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 		break;
 	case ELS_LS_RJT:
 	default:

