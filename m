From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/27] libfc: fix fc_tm_done not freeing the allocated fsp pkt
Date: Tue, 30 Nov 2010 16:19:35 -0800
Message-ID: <20101201001935.18369.44484.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0LAATg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:36 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Frame should be freed in fc_tm_done, this is an updated patch on the one
initially submitted by Hillf Danton.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a25057d..12b639d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1321,27 +1321,27 @@ static void fc_tm_done(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		 *
 		 * scsi-eh will escalate for when either happens.
 		 */
-		return;
+		goto out;
 	}
 
 	if (fc_fcp_lock_pkt(fsp))
-		return;
+		goto out;
 
 	/*
 	 * raced with eh timeout handler.
 	 */
-	if (!fsp->seq_ptr || !fsp->wait_for_comp) {
-		spin_unlock_bh(&fsp->scsi_pkt_lock);
-		return;
-	}
+	if (!fsp->seq_ptr || !fsp->wait_for_comp)
+		goto out_unlock;
 
 	fh = fc_frame_header_get(fp);
 	if (fh->fh_type != FC_TYPE_BLS)
 		fc_fcp_resp(fsp, fp);
 	fsp->seq_ptr = NULL;
 	fsp->lp->tt.exch_done(seq);
-	fc_frame_free(fp);
+out_unlock:
 	fc_fcp_unlock_pkt(fsp);
+out:
+	fc_frame_free(fp);
 }
 
 /**

