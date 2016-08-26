From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/30] libfc: safeguard against invalid exchange index
Date: Fri, 26 Aug 2016 14:01:41 +0200
Message-ID: <1472212913-39810-19-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35115 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbcHZMCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:11 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The cached exchange index might be invalid, in which case
we should drop down to allocate a new one.
And we should not try to access an invalid exchange when
responding to a BA_ABTS.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7d0e7ca..da9c727 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -827,14 +827,18 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 
 	/* peek cache of free slot */
 	if (pool->left != FC_XID_UNKNOWN) {
-		index = pool->left;
-		pool->left = FC_XID_UNKNOWN;
-		goto hit;
+		if (!WARN_ON(fc_exch_ptr_get(pool, pool->left))) {
+			index = pool->left;
+			pool->left = FC_XID_UNKNOWN;
+			goto hit;
+		}
 	}
 	if (pool->right != FC_XID_UNKNOWN) {
-		index = pool->right;
-		pool->right = FC_XID_UNKNOWN;
-		goto hit;
+		if (!WARN_ON(fc_exch_ptr_get(pool, pool->right))) {
+			index = pool->right;
+			pool->right = FC_XID_UNKNOWN;
+			goto hit;
+		}
 	}
 
 	index = pool->next_index;
@@ -1777,7 +1781,10 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 				fc_frame_free(fp);
 			break;
 		case FC_RCTL_BA_ABTS:
-			fc_exch_recv_abts(ep, fp);
+			if (ep)
+				fc_exch_recv_abts(ep, fp);
+			else
+				fc_frame_free(fp);
 			break;
 		default:			/* ignore junk */
 			fc_frame_free(fp);
-- 
1.8.5.6

