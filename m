From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] scsi,block: update SCSI to handle mixed merge failures
Date: Fri,  3 Jul 2009 17:48:18 +0900
Message-ID: <1246610898-22350-5-git-send-email-tj@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbZGCIsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2009 04:48:41 -0400
In-Reply-To: <1246610898-22350-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Niel Lambrechts <niel.lambrechts@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Update scsi_io_completion() such that it only fails requests till the
next error boundary and retry the leftover.  This enables block layer
to merge requests with different failfast settings and still behave
correctly on errors.  Allow merge of requests of different failfast
settings.

As SCSI is currently the only subsystem which follows failfast status,
there's no need to worry about other block drivers for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-merge.c       |    6 ------
 block/elevator.c        |    8 --------
 drivers/scsi/scsi_lib.c |    6 ++++--
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7c9ca01..b0de857 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -380,12 +380,6 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_integrity_rq(req) != blk_integrity_rq(next))
 		return 0;
 
-	/* don't merge requests of different failfast settings */
-	if (blk_failfast_dev(req)	!= blk_failfast_dev(next)	||
-	    blk_failfast_transport(req)	!= blk_failfast_transport(next)	||
-	    blk_failfast_driver(req)	!= blk_failfast_driver(next))
-		return 0;
-
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
diff --git a/block/elevator.c b/block/elevator.c
index 6f23753..ca86192 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -100,14 +100,6 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return 0;
 
-	/*
-	 * Don't merge if failfast settings don't match
-	 */
-	if (bio_failfast_dev(bio)	!= blk_failfast_dev(rq)		||
-	    bio_failfast_transport(bio)	!= blk_failfast_transport(rq)	||
-	    bio_failfast_driver(bio)	!= blk_failfast_driver(rq))
-		return 0;
-
 	if (!elv_iosched_allow_merge(rq, bio))
 		return 0;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f3c4089..90c94da 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -897,8 +897,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
-		blk_end_request_all(req, -EIO);
-		scsi_next_command(cmd);
+		if (blk_end_request_err(req, -EIO))
+			scsi_requeue_command(q, cmd);
+		else
+			scsi_next_command(cmd);
 		break;
 	case ACTION_REPREP:
 		/* Unprep the request and put it back at the head of the queue.
-- 
1.6.0.2

