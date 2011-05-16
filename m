From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/8] libfc: fix race in SRR response
Date: Mon, 16 May 2011 16:45:51 -0700
Message-ID: <20110516234551.24502.76418.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1EPXpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:52 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

In this case fsp was freed before error handler was invoked,
this is fixed by having SRR fsp reference freed by exch
destructor so that fsp will be always held until it exch
is freed.

Also don't reset fsp->recov_seq since this is needed by
SRR error handler to do exch done.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f880d40..57704e8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1673,7 +1673,8 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 		       FC_FCTL_REQ, 0);
 
 	rec_tov = get_fsp_rec_tov(fsp);
-	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp, NULL,
+	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp,
+				      fc_fcp_pkt_destroy,
 				      fsp, jiffies_to_msecs(rec_tov));
 	if (!seq)
 		goto retry;
@@ -1720,7 +1721,6 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		return;
 	}
 
-	fsp->recov_seq = NULL;
 	switch (fc_frame_payload_op(fp)) {
 	case ELS_LS_ACC:
 		fsp->recov_retry = 0;
@@ -1732,10 +1732,9 @@ static void fc_fcp_srr_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
-	fsp->lp->tt.exch_done(seq);
 out:
+	fsp->lp->tt.exch_done(seq);
 	fc_frame_free(fp);
-	fc_fcp_pkt_release(fsp);	/* drop hold for outstanding SRR */
 }
 
 /**
@@ -1747,8 +1746,6 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 {
 	if (fc_fcp_lock_pkt(fsp))
 		goto out;
-	fsp->lp->tt.exch_done(fsp->recov_seq);
-	fsp->recov_seq = NULL;
 	switch (PTR_ERR(fp)) {
 	case -FC_EX_TIMEOUT:
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
@@ -1764,7 +1761,7 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	}
 	fc_fcp_unlock_pkt(fsp);
 out:
-	fc_fcp_pkt_release(fsp);	/* drop hold for outstanding SRR */
+	fsp->lp->tt.exch_done(fsp->recov_seq);
 }
 
 /**

