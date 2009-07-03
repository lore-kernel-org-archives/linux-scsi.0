From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] block: don't merge requests of different failfast settings
Date: Fri,  3 Jul 2009 17:48:15 +0900
Message-ID: <1246610898-22350-2-git-send-email-tj@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44651 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZGCIsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2009 04:48:31 -0400
In-Reply-To: <1246610898-22350-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Nie
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@mit.edu>

Block layer used to merge requests and bios with different failfast
settings.  This caused regular IOs to fail prematurely when they were
merged into failfast requests for readahead.

Niel Lambrechts could trigger the problem semi-reliably on ext4 when
resuming from STR.  ext4 uses readahead when reading inodes and
combined with the deterministic extra SATA PHY exception cycle during
resume on the specific configuration, non-readahead inode read would
fail causing ext4 errors.  Please read the following thread for
details.

  http://lkml.org/lkml/2009/5/23/21

This patch makes block layer reject merging if the failfast settings
don't match.  This is correct but likely to lower IO performance by
preventing regular IOs from mingling into surrounding readahead
requests.  Changes to allow such mixed merges and handle errors
correctly will be added later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Theodore Tso <tytso@mit.edu>
---
 block/blk-merge.c |    6 ++++++
 block/elevator.c  |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 39ce644..e199967 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -350,6 +350,12 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_integrity_rq(req) != blk_integrity_rq(next))
 		return 0;
 
+	/* don't merge requests of different failfast settings */
+	if (blk_failfast_dev(req)	!= blk_failfast_dev(next)	||
+	    blk_failfast_transport(req)	!= blk_failfast_transport(next)	||
+	    blk_failfast_driver(req)	!= blk_failfast_driver(next))
+		return 0;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
diff --git a/block/elevator.c b/block/elevator.c
index ca86192..6f23753 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -100,6 +100,14 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return 0;
 
+	/*
+	 * Don't merge if failfast settings don't match
+	 */
+	if (bio_failfast_dev(bio)	!= blk_failfast_dev(rq)		||
+	    bio_failfast_transport(bio)	!= blk_failfast_transport(rq)	||
+	    bio_failfast_driver(bio)	!= blk_failfast_driver(rq))
+		return 0;
+
 	if (!elv_iosched_allow_merge(rq, bio))
 		return 0;
 
-- 
1.6.0.2

