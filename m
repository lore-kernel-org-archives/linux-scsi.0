From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/30] libfc: reset timeout on queue full
Date: Fri, 26 Aug 2016 14:01:45 +0200
Message-ID: <1472212913-39810-23-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751884AbcHZMCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:13 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we're receiving a timeout we should be checking for queue
full status; if there are still some packets pending we should
be resetting the counter to ensure we're not missing out any
packets which are still queued.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c | 21 ++++++++++++++++++---
 include/scsi/libfc.h        |  3 ++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 63c821b..3e059e4 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -254,8 +254,10 @@ static inline void fc_fcp_unlock_pkt(struct fc_fcp_pkt *fsp)
  */
 static void fc_fcp_timer_set(struct fc_fcp_pkt *fsp, unsigned long delay)
 {
-	if (!(fsp->state & FC_SRB_COMPL))
+	if (!(fsp->state & FC_SRB_COMPL)) {
 		mod_timer(&fsp->timer, jiffies + delay);
+		fsp->timer_delay = delay;
+	}
 }
 
 static void fc_fcp_abort_done(struct fc_fcp_pkt *fsp)
@@ -932,6 +934,12 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			 * Wait a at least one jiffy to see if it is delivered.
 			 * If this expires without data, we may do SRR.
 			 */
+			if (fsp->lp->qfull) {
+				FC_FCP_DBG(fsp, "tgt %6.6x data underrun, "
+					   "retry due to queue busy\n",
+					   fsp->rport->port_id);
+				return;
+			}
 			FC_FCP_DBG(fsp, "tgt %6.6x xfer len %zx data underrun "
 				   "len %x, data len %x\n",
 				   fsp->rport->port_id,
@@ -1435,8 +1443,15 @@ static void fc_fcp_timeout(unsigned long data)
 	if (fsp->cdb_cmd.fc_tm_flags)
 		goto unlock;
 
-	FC_FCP_DBG(fsp, "fcp timeout, flags %x state %x\n",
-		   rpriv->flags, fsp->state);
+	if (fsp->lp->qfull) {
+		FC_FCP_DBG(fsp, "fcp timeout, resetting timer delay %d\n",
+			   fsp->timer_delay);
+		setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
+		fc_fcp_timer_set(fsp, fsp->timer_delay);
+		goto unlock;
+	}
+	FC_FCP_DBG(fsp, "fcp timeout, delay %d flags %x state %x\n",
+		   fsp->timer_delay, rpriv->flags, fsp->state);
 	fsp->state |= FC_SRB_FCP_PROCESSING_TMO;
 
 	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 8cb752f..f5aa54b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -355,7 +355,8 @@ struct fc_fcp_pkt {
 
 	/* Timeout/error related information */
 	struct timer_list timer;
-	int	          wait_for_comp;
+	int		  wait_for_comp;
+	int		  timer_delay;
 	u32		  recov_retry;
 	struct fc_seq	  *recov_seq;
 	struct completion tm_done;
-- 
1.8.5.6

