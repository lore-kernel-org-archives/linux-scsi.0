From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/16] fcp: Do not interpret check condition as underrun
Date: Thu, 05 Sep 2013 12:13:27 -0700
Message-ID: <20130905191327.15235.66327.stgit@fritz>
References: <20130905191218.15235.85917.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57068 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab3IETNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 15:13:37 -0400
In-Reply-To: <20130905191218.15235.85917.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

This patch avoids that the FCoE initiator sends a REC message after
having received a SCSI response with non-zero status and non-zero
DATA IN buffer length.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5fd0f1f..1d7e76e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -902,7 +902,8 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	/*
 	 * Check for missing or extra data frames.
 	 */
-	if (unlikely(fsp->xfer_len != expected_len)) {
+	if (unlikely(fsp->cdb_status == SAM_STAT_GOOD &&
+		     fsp->xfer_len != expected_len)) {
 		if (fsp->xfer_len < expected_len) {
 			/*
 			 * Some data may be queued locally,
@@ -955,12 +956,11 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 		 * Test for transport underrun, independent of response
 		 * underrun status.
 		 */
-		if (fsp->xfer_len < fsp->data_len && !fsp->io_status &&
+		if (fsp->cdb_status == SAM_STAT_GOOD &&
+		    fsp->xfer_len < fsp->data_len && !fsp->io_status &&
 		    (!(fsp->scsi_comp_flags & FCP_RESID_UNDER) ||
-		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid)) {
+		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid))
 			fsp->status_code = FC_DATA_UNDRUN;
-			fsp->io_status = 0;
-		}
 	}
 
 	seq = fsp->seq_ptr;

