From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/24] libfc: safeguard against invalid exchange index
Date: Thu, 13 Oct 2016 15:10:49 +0200
Message-ID: <1476364260-12191-14-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40757 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755624AbcJMNXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:49 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The cached exchange index might be invalid, in which case
we should drop down to allocate a new one.
And we should not try to access an invalid exchange when
responding to a BA_ABTS.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 5e0a57f..e8784a7 100644
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

