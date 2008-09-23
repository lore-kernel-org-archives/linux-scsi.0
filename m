From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] BUG: ll_merge_requests_fn() updates req->nr_phys_segments wrongly
Date: Tue, 23 Sep 2008 23:58:02 +0530
Message-ID: <200809232358.02810.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:50198 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbYIWS2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 14:28:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


From: Nikanth Karthikesan <knikanth@suse.de>

ll_merge_requests_fn() decreases the req->nr_phys_segments if 
blk_phys_contig_segment() returns true, but it is perfectly possible that 
blk_hw_contig_segment() is false. A new hw_segment implies a new phys_segment. 
So decrementing nr_phys_segments wrongly here triggers the BUG_ON() in 
scsi_init_sgtable(), as blk_rq_map_sg() would map 1 phys_segment more than  
req->nr_phys_segment. This is easily reproducible. Other callers of 
blk_rq_map_sg() should also be affected by this bug.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---

 block/blk-merge.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..6e6d04b 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -392,11 +392,6 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (blk_phys_contig_segment(q, req->biotail, next->bio))
-		total_phys_segments--;
-
-	if (total_phys_segments > q->max_phys_segments)
-		return 0;
 
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
 	if (blk_hw_contig_segment(q, req->biotail, next->bio)) {
@@ -410,9 +405,12 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 		if (next->nr_hw_segments == 1)
 			next->biotail->bi_hw_back_size = len;
 		total_hw_segments--;
+		if (blk_phys_contig_segment(q, req->biotail, next->bio))
+			total_phys_segments--;
 	}
 
-	if (total_hw_segments > q->max_hw_segments)
+	if (total_phys_segments > q->max_phys_segments ||
+	    total_hw_segments > q->max_hw_segments)
 		return 0;
 
 	/* Merge is OK... */









