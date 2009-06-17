From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] block: revert "bsg: setting rq->bio to NULL"
Date: Wed, 17 Jun 2009 15:10:11 +0900
Message-ID: <1245219011-20481-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1245219011-20481-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47171 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZFQGMw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jun 2009 02:12:52 -0400
In-Reply-To: <1245219011-20481-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com

The SMP handler (sas_smp_request) was fixed to use the block API
properly, so we don't need this workaround to avoid blk_put_request()
warning.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 5358f9a..2d746e3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -315,7 +315,6 @@ out:
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
-		next_rq->bio = NULL;
 		blk_put_request(next_rq);
 	}
 	return ERR_PTR(ret);
@@ -449,7 +448,6 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		hdr->dout_resid = rq->resid_len;
 		hdr->din_resid = rq->next_rq->resid_len;
 		blk_rq_unmap_user(bidi_bio);
-		rq->next_rq->bio = NULL;
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
 		hdr->din_resid = rq->resid_len;
@@ -468,7 +466,6 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	blk_rq_unmap_user(bio);
 	if (rq->cmd != rq->__cmd)
 		kfree(rq->cmd);
-	rq->bio = NULL;
 	blk_put_request(rq);
 
 	return ret;
-- 
1.6.0.6

