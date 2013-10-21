From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/19] libfc: Debug code fixes
Date: Mon, 21 Oct 2013 11:00:52 -0700
Message-ID: <20131021180052.31563.65050.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab3JUSAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:00:52 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

The second argument of fc_lport_error() may be a valid frame pointer.
Hence only print it as an error code if it really is an error code.

Debug statements must end in a newline. Add one where it is missing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c  |    8 ++++----
 drivers/scsi/libfc/fc_lport.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index b233a2d..cb2b900 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1659,7 +1659,7 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 			break;
 		default:
 			if (ep)
-				FC_EXCH_DBG(ep, "BLS rctl %x - %s received",
+				FC_EXCH_DBG(ep, "BLS rctl %x - %s received\n",
 					    fh->fh_r_ctl,
 					    fc_exch_rctl_name(fh->fh_r_ctl));
 			break;
@@ -1953,13 +1953,13 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 	switch (op) {
 	case ELS_LS_RJT:
-		FC_EXCH_DBG(aborted_ep, "LS_RJT for RRQ");
+		FC_EXCH_DBG(aborted_ep, "LS_RJT for RRQ\n");
 		/* fall through */
 	case ELS_LS_ACC:
 		goto cleanup;
 	default:
-		FC_EXCH_DBG(aborted_ep, "unexpected response op %x "
-			    "for RRQ", op);
+		FC_EXCH_DBG(aborted_ep, "unexpected response op %x for RRQ\n",
+			    op);
 		return;
 	}
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a32f314..e01a298 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1088,7 +1088,7 @@ static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 {
 	unsigned long delay = 0;
 	FC_LPORT_DBG(lport, "Error %ld in state %s, retries %d\n",
-		     PTR_ERR(fp), fc_lport_state(lport),
+		     IS_ERR(fp) ? -PTR_ERR(fp) : 0, fc_lport_state(lport),
 		     lport->retry_count);
 
 	if (PTR_ERR(fp) == -FC_EX_CLOSED)

