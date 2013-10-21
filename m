From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/19] libfc: Reduce exchange lock contention in
 fc_exch_recv_abts()
Date: Mon, 21 Oct 2013 11:01:24 -0700
Message-ID: <20131021180124.31563.12958.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3JUSB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:01:29 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

Reduce the time during which the exchange lock is held by allocating
a frame before obtaining the exchange lock.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 2a7fd5a..47ebc7b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1307,9 +1307,16 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 
 	if (!ep)
 		goto reject;
+
+	fp = fc_frame_alloc(ep->lp, sizeof(*ap));
+	if (!fp)
+		goto free;
+
 	spin_lock_bh(&ep->ex_lock);
 	if (ep->esb_stat & ESB_ST_COMPLETE) {
 		spin_unlock_bh(&ep->ex_lock);
+
+		fc_frame_free(fp);
 		goto reject;
 	}
 	if (!(ep->esb_stat & ESB_ST_REC_QUAL)) {
@@ -1317,12 +1324,6 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 		fc_exch_hold(ep);		/* hold for REC_QUAL */
 	}
 	fc_exch_timer_set_locked(ep, ep->r_a_tov);
-
-	fp = fc_frame_alloc(ep->lp, sizeof(*ap));
-	if (!fp) {
-		spin_unlock_bh(&ep->ex_lock);
-		goto free;
-	}
 	fh = fc_frame_header_get(fp);
 	ap = fc_frame_payload_get(fp, sizeof(*ap));
 	memset(ap, 0, sizeof(*ap));
@@ -1338,13 +1339,14 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 	fc_seq_send_last(sp, fp, FC_RCTL_BA_ACC, FC_TYPE_BLS);
 	ep->esb_stat |= ESB_ST_ABNORMAL;
 	spin_unlock_bh(&ep->ex_lock);
+
+free:
 	fc_frame_free(rx_fp);
 	return;
 
 reject:
 	fc_exch_send_ba_rjt(rx_fp, FC_BA_RJT_UNABLE, FC_BA_RJT_INV_XID);
-free:
-	fc_frame_free(rx_fp);
+	goto free;
 }
 
 /**

