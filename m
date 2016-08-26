From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/30] libfc: quarantine timed out xids
Date: Fri, 26 Aug 2016 14:01:42 +0200
Message-ID: <1472212913-39810-20-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbcHZMCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:12 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When a sequence times out we have no idea what happened to the
frame. And we do not know if we will ever receive the frame.
Hence we cannot re-use the xid as we would risk data corruption
if the xid had been re-used and the timed out frame would be
received after that.
So we need to quarantine the xid until the lport is reset.
Yes, I know this will (eventually) deplete the xid pool.
But for now it's the safest method.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 33 ++++++++++++++++++++++-----------
 drivers/scsi/libfc/fc_fcp.c  | 13 +++++++------
 include/scsi/libfc.h         |  1 +
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index da9c727..510f38c 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -94,6 +94,7 @@ struct fc_exch_pool {
 struct fc_exch_mgr {
 	struct fc_exch_pool __percpu *pool;
 	mempool_t	*ep_pool;
+	struct fc_lport	*lport;
 	enum fc_class	class;
 	struct kref	kref;
 	u16		min_xid;
@@ -408,6 +409,8 @@ static int fc_exch_done_locked(struct fc_exch *ep)
 	return rc;
 }
 
+static struct fc_exch fc_quarantine_exch;
+
 /**
  * fc_exch_ptr_get() - Return an exchange from an exchange pool
  * @pool:  Exchange Pool to get an exchange from
@@ -452,14 +455,17 @@ static void fc_exch_delete(struct fc_exch *ep)
 
 	/* update cache of free slot */
 	index = (ep->xid - ep->em->min_xid) >> fc_cpu_order;
-	if (pool->left == FC_XID_UNKNOWN)
-		pool->left = index;
-	else if (pool->right == FC_XID_UNKNOWN)
-		pool->right = index;
-	else
-		pool->next_index = index;
-
-	fc_exch_ptr_set(pool, index, NULL);
+	if (!(ep->state & FC_EX_QUARANTINE)) {
+		if (pool->left == FC_XID_UNKNOWN)
+			pool->left = index;
+		else if (pool->right == FC_XID_UNKNOWN)
+			pool->right = index;
+		else
+			pool->next_index = index;
+		fc_exch_ptr_set(pool, index, NULL);
+	} else {
+		fc_exch_ptr_set(pool, index, &fc_quarantine_exch);
+	}
 	list_del(&ep->ex_list);
 	spin_unlock_bh(&pool->lock);
 	fc_exch_release(ep);	/* drop hold for exch in mp */
@@ -916,14 +922,14 @@ static inline struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
  */
 static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 {
+	struct fc_lport *lport = mp->lport;
 	struct fc_exch_pool *pool;
 	struct fc_exch *ep = NULL;
 	u16 cpu = xid & fc_cpu_mask;
 
 	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
-		printk_ratelimited(KERN_ERR
-			"libfc: lookup request for XID = %d, "
-			"indicates invalid CPU %d\n", xid, cpu);
+		pr_err("host%u: lport %6.6x: xid %d invalid CPU %d\n:",
+		       lport->host->host_no, lport->port_id, xid, cpu);
 		return NULL;
 	}
 
@@ -931,6 +937,10 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 		pool = per_cpu_ptr(mp->pool, cpu);
 		spin_lock_bh(&pool->lock);
 		ep = fc_exch_ptr_get(pool, (xid - mp->min_xid) >> fc_cpu_order);
+		if (ep == &fc_quarantine_exch) {
+			FC_LPORT_DBG(lport, "xid %x quarantined\n", xid);
+			ep = NULL;
+		}
 		if (ep) {
 			WARN_ON(ep->xid != xid);
 			fc_exch_hold(ep);
@@ -2429,6 +2439,7 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lport,
 		return NULL;
 
 	mp->class = class;
+	mp->lport = lport;
 	/* adjust em exch xid range for offload */
 	mp->min_xid = min_xid;
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 1cb2c59..8694e87 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1531,13 +1531,14 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 				   fsp->rport->port_id, rjt->er_reason,
 				   rjt->er_explan, fsp->xfer_len);
 			/*
-			 * If no data transfer, the command frame got dropped
-			 * so we just retry.  If data was transferred, we
-			 * lost the response but the target has no record,
-			 * so we abort and retry.
+			 * If response got lost or is stuck in the
+			 * queue somewhere we have no idea if and when
+			 * the response will be received. So quarantine
+			 * the xid and retry the command.
 			 */
-			if (rjt->er_explan == ELS_EXPL_OXID_RXID &&
-			    fsp->xfer_len == 0) {
+			if (rjt->er_explan == ELS_EXPL_OXID_RXID) {
+				struct fc_exch *ep = fc_seq_exch(fsp->seq_ptr);
+				ep->state |= FC_EX_QUARANTINE;
 				fsp->state |= FC_SRB_ABORTED;
 				fc_fcp_retry_cmd(fsp, FC_TRANS_RESET);
 				break;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index dc42d80..8cb752f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -390,6 +390,7 @@ struct fc_seq {
 
 #define FC_EX_DONE		(1 << 0) /* ep is completed */
 #define FC_EX_RST_CLEANUP	(1 << 1) /* reset is forcing completion */
+#define FC_EX_QUARANTINE	(1 << 2) /* exch is quarantined */
 
 /**
  * struct fc_exch - Fibre Channel Exchange
-- 
1.8.5.6

