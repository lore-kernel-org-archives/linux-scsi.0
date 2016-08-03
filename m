From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/22] libfc: don't fail sequence abort for completed exchanges
Date: Wed,  3 Aug 2016 15:13:12 +0200
Message-ID: <1470230002-37737-13-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbcHCNNf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:35 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If a sequence should be aborted the exchange might already
be completed (eg if the response is still queued in the rx
queue), so this shouldn't considered as an error.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 289c481..ceb4a65 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -258,6 +258,17 @@ static void fc_fcp_timer_set(struct fc_fcp_pkt *fsp, unsigned long delay)
 		mod_timer(&fsp->timer, jiffies + delay);
 }
 
+static void fc_fcp_abort_done(struct fc_fcp_pkt *fsp)
+{
+	fsp->state |= FC_SRB_ABORTED;
+	fsp->state &= ~FC_SRB_ABORT_PENDING;
+
+	if (fsp->wait_for_comp)
+		complete(&fsp->tm_done);
+	else
+		fc_fcp_complete_locked(fsp);
+}
+
 /**
  * fc_fcp_send_abort() - Send an abort for exchanges associated with a
  *			 fcp_pkt
@@ -265,6 +276,8 @@ static void fc_fcp_timer_set(struct fc_fcp_pkt *fsp, unsigned long delay)
  */
 static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 {
+	int rc;
+
 	if (!fsp->seq_ptr)
 		return -EINVAL;
 
@@ -272,7 +285,16 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 	put_cpu();
 
 	fsp->state |= FC_SRB_ABORT_PENDING;
-	return fsp->lp->tt.seq_exch_abort(fsp->seq_ptr, 0);
+	rc = fsp->lp->tt.seq_exch_abort(fsp->seq_ptr, 0);
+	/*
+	 * ->seq_exch_abort() might return -ENXIO if
+	 * the sequence is already completed
+	 */
+	if (rc == -ENXIO) {
+		fc_fcp_abort_done(fsp);
+		rc = 0;
+	}
+	return rc;
 }
 
 /**
@@ -728,15 +750,8 @@ static void fc_fcp_abts_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		ba_done = 0;
 	}
 
-	if (ba_done) {
-		fsp->state |= FC_SRB_ABORTED;
-		fsp->state &= ~FC_SRB_ABORT_PENDING;
-
-		if (fsp->wait_for_comp)
-			complete(&fsp->tm_done);
-		else
-			fc_fcp_complete_locked(fsp);
-	}
+	if (ba_done)
+		fc_fcp_abort_done(fsp);
 }
 
 /**
@@ -1242,6 +1257,11 @@ static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 		return FAILED;
 	}
 
+	if (fsp->state & FC_SRB_ABORTED) {
+		FC_FCP_DBG(fsp, "target abort cmd  completed\n");
+		return SUCCESS;
+	}
+
 	init_completion(&fsp->tm_done);
 	fsp->wait_for_comp = 1;
 
-- 
1.8.5.6

