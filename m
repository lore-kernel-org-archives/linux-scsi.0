From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 27/28] libfc: Add retry logic to lport state machine when
	receiving LS_RJT
Date: Tue, 20 Jul 2010 15:21:27 -0700
Message-ID: <20100720222127.17116.40815.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:48877 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab0GTWV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:28 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Call fc_lport_error to retry upto max retry count when
FLOGI/SCR/NS gets rejected.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |   63 ++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 1998c03..6eb334a 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1012,38 +1012,24 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 		     PTR_ERR(fp), fc_lport_state(lport),
 		     lport->retry_count);
 
-	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
-		/*
-		 * Memory allocation failure, or the exchange timed out.
-		 *  Retry after delay
-		 */
-		if (lport->retry_count < lport->max_retry_count) {
-			lport->retry_count++;
-			if (!fp)
-				delay = msecs_to_jiffies(500);
-			else
-				delay =	msecs_to_jiffies(lport->e_d_tov);
-
-			schedule_delayed_work(&lport->retry_work, delay);
-		} else {
-			switch (lport->state) {
-			case LPORT_ST_DISABLED:
-			case LPORT_ST_READY:
-			case LPORT_ST_RESET:
-			case LPORT_ST_RNN_ID:
-			case LPORT_ST_RSNN_NN:
-			case LPORT_ST_RSPN_ID:
-			case LPORT_ST_RFT_ID:
-			case LPORT_ST_RFF_ID:
-			case LPORT_ST_SCR:
-			case LPORT_ST_DNS:
-			case LPORT_ST_FLOGI:
-			case LPORT_ST_LOGO:
-				fc_lport_enter_reset(lport);
-				break;
-			}
-		}
-	}
+	if (PTR_ERR(fp) == -FC_EX_CLOSED)
+		return;
+
+	/*
+	 * Memory allocation failure, or the exchange timed out
+	 * or we received LS_RJT.
+	 * Retry after delay
+	 */
+	if (lport->retry_count < lport->max_retry_count) {
+		lport->retry_count++;
+		if (!fp)
+			delay = msecs_to_jiffies(500);
+		else
+			delay =	msecs_to_jiffies(lport->e_d_tov);
+
+		schedule_delayed_work(&lport->retry_work, delay);
+	} else
+		fc_lport_enter_reset(lport);
 }
 
 /**
@@ -1461,7 +1447,13 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	did = fc_frame_did(fp);
-	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
+
+	if (!did) {
+		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
+		goto out;
+	}
+
+	if (fc_frame_payload_op(fp) == ELS_LS_ACC) {
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
 		if (flp) {
 			mfs = ntohs(flp->fl_csp.sp_bb_data) &
@@ -1500,9 +1492,8 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				fc_lport_enter_dns(lport);
 			}
 		}
-	} else {
-		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
-	}
+	} else
+		fc_lport_error(lport, fp);
 
 out:
 	fc_frame_free(fp);

