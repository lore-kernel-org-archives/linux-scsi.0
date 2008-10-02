From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] BUG: nr_phys_segments cannot be less than nr_hw_segments
Date: Thu, 2 Oct 2008 19:59:33 +0530
Message-ID: <200810021959.33616.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:45878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbYJBOai (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2008 10:30:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This is a follow-up to my earlier mail http://lkml.org/lkml/2008/9/23/294 
([PATCH] BUG: ll_merge_requests_fn() updates req->nr_phys_segments wrongly)

It is possible for the merging code to create lesser no of phys segments than 
hw segments, but every hw segment needs atleast one new phys segment. This 
triggers the BUG() on scsi_init_sgtable() as blk_rq_map_sg() returns more no 
of segments than rq->nr_phys_segments

The following blktrace shows a sequence of bio's to trigger such condition on 
my machine with max_sectors_kb=512 & max_hw_sectors_kb=32767.

  8,0    0       12     1.943680621  2261  Q   R 6184075 + 55 [bash]
  8,0    0       13     1.943684671  2261  G   R 6184075 + 55 [bash]
  8,0    0       14     1.943690189  2261  P   N [bash]
  8,0    0       15     1.943692075  2261  I   R 6184075 + 55 [bash]
  8,0    0       16     1.943712119  2261  D   R 6184075 + 55 [bash]
  8,0    0       17     1.943718684  2261  Q   R 6184130 + 55 [bash]
  8,0    0       18     1.943721897  2261  G   R 6184130 + 55 [bash]
  8,0    0       19     1.943726576  2261  P   N [bash]
  8,0    0       20     1.943727763  2261  I   R 6184130 + 55 [bash]
  8,0    0       21     1.943731675  2261  Q   R 6184241 + 56 [bash]
  8,0    0       22     1.943735167  2261  G   R 6184241 + 56 [bash]
  8,0    0       23     1.943739497  2261  I   R 6184241 + 56 [bash]
  8,0    0       24     1.943742081  2261  Q   R 6184185 + 56 [bash]
  8,0    0       25     1.943744875  2261  M   R 6184185 + 56 [bash]
  8,0    0       26     1.943753535  2261  Q   R 6184352 + 55 [bash]
  8,0    0       27     1.943756538  2261  G   R 6184352 + 55 [bash]
  8,0    0       28     1.943760868  2261  I   R 6184352 + 55 [bash]
  8,0    0       29     1.943763522  2261  Q   R 6184407 + 55 [bash]
  8,0    0       30     1.943766316  2261  M   R 6184407 + 55 [bash]
  8,0    0       31     1.943770506  2261  Q   R 6184297 + 55 [bash]
  8,0    0       32     1.943772951  2261  F   R 6184297 + 55 [bash]
  8,0    0       33     1.943780843  2261  Q   R 6184462 + 55 [bash]
  8,0    0       34     1.943783776  2261  M   R 6184462 + 55 [bash]
  8,0    0       35     1.944444684     0 UT   N [swapper] 2
  8,0    0       36     1.944453624    10  U   N [kblockd/0] 2
  8,0    0       37     1.944470595    10  D   R 6184130 + 387 [kblockd/0]
  8,0    0       38     1.970340853     0  C   R 6184075 + 55 [0]
  8,0    0       39     1.973576739     0  C   R 6184130 + 387 [0]

Patches against Jens git to fix this.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..44cc1d7 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -395,9 +395,6 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 	if (blk_phys_contig_segment(q, req->biotail, next->bio))
 		total_phys_segments--;
 
-	if (total_phys_segments > q->max_phys_segments)
-		return 0;
-
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
 	if (blk_hw_contig_segment(q, req->biotail, next->bio)) {
 		int len = req->biotail->bi_hw_back_size +
@@ -415,6 +412,15 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 	if (total_hw_segments > q->max_hw_segments)
 		return 0;
 
+	/*
+	 * FIXME: if 2 phys segments is used for a single hw segment?
+	 */
+	if (total_phys_segments < total_hw_segments)
+		total_phys_segments = total_hw_segments;
+
+	if (total_phys_segments > q->max_phys_segments)
+		return 0;
+
 	/* Merge is OK... */
 	req->nr_phys_segments = total_phys_segments;
 	req->nr_hw_segments = total_hw_segments;

But this may not be the complete fix? I am not sure whether the condition in 
FIXME comment can be triggered. The following patch may be a better fix.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..b2c37f4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -467,6 +467,8 @@ static int attempt_merge(struct request_queue *q, struct 
request *req,
 
 	req->nr_sectors = req->hard_nr_sectors += next->hard_nr_sectors;
 
+	blk_recalc_rq_segments(req);
+
 	elv_merge_requests(q, req, next);
 
 	if (req->rq_disk) {

But still wouldn't it be incomplete fix as blk_recalc_rq_segments() can 
produce nr_phys_segments > q->max_phys_segments? Do we need something like 
this.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..e4431db 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -427,6 +427,8 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 static int attempt_merge(struct request_queue *q, struct request *req,
 			  struct request *next)
 {
+	struct bio *req_biotail, *req_biotail_bi_next;
+
 	if (!rq_mergeable(req) || !rq_mergeable(next))
 		return 0;
 
@@ -462,11 +464,21 @@ static int attempt_merge(struct request_queue *q, struct 
request *req,
 	if (time_after(req->start_time, next->start_time))
 		req->start_time = next->start_time;
 
+	req_biotail = req->biotail;
+	req_biotail_bi_next = req->biotail->bi_next;
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
 
 	req->nr_sectors = req->hard_nr_sectors += next->hard_nr_sectors;
 
+	blk_recalc_rq_segments(req);
+	if (req->nr_phys_segments > q->max_phys_segments) {
+		req->biotail = req_biotail;
+		req->biotail->bi_next = req_biotail_bi_next;
+		blk_recalc_rq_segments(req);
+		return 0;
+	}
+
 	elv_merge_requests(q, req, next);
 
 	if (req->rq_disk) {

But blk_recalc_rq_segments() cannot increase nr_phys_segments by more than 
one. So checking for one lesser limit earlier should also work? But we would 
be mostly merging 1 lesser segment.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..d9b5289 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -256,7 +256,7 @@ static inline int ll_new_mergeable(struct request_queue 
*q,
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments - 1) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -395,7 +395,7 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 	if (blk_phys_contig_segment(q, req->biotail, next->bio))
 		total_phys_segments--;
 
-	if (total_phys_segments > q->max_phys_segments)
+	if (total_phys_segments > q->max_phys_segments - 1)
 		return 0;
 
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
@@ -467,6 +467,8 @@ static int attempt_merge(struct request_queue *q, struct 
request *req,
 
 	req->nr_sectors = req->hard_nr_sectors += next->hard_nr_sectors;
 
+	blk_recalc_rq_segments(req);
+
 	elv_merge_requests(q, req, next);
 
 	if (req->rq_disk) {


Thanks
Nikanth Karthikesan


