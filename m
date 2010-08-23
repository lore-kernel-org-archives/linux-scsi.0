From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] block: simplify queue_next_fseq
Date: Mon, 23 Aug 2010 16:15:12 +0200
Message-ID: <20100823141512.GA23771@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60377 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0HWOPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 10:15:38 -0400
Content-Disposition: inline
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

We need to call blk_rq_init and elv_insert for all cases in queue_next_fseq,
so take these calls into common code.  Also move the end_io initialization
from queue_flush into queue_next_fseq and rename queue_flush to
init_flush_request now that it's old name doesn't apply anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/block/blk-flush.c
===================================================================
--- linux-2.6.orig/block/blk-flush.c	2010-08-17 15:34:27.864004351 +0200
+++ linux-2.6/block/blk-flush.c	2010-08-17 16:12:53.504253827 +0200
@@ -74,16 +74,11 @@ static void post_flush_end_io(struct req
 	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }
 
-static void queue_flush(struct request_queue *q, struct request *rq,
-			rq_end_io_fn *end_io)
+static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
-	blk_rq_init(q, rq);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_FLUSH;
-	rq->rq_disk = q->orig_flush_rq->rq_disk;
-	rq->end_io = end_io;
-
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	rq->rq_disk = disk;
 }
 
 static struct request *queue_next_fseq(struct request_queue *q)
@@ -91,29 +86,28 @@ static struct request *queue_next_fseq(s
 	struct request *orig_rq = q->orig_flush_rq;
 	struct request *rq = &q->flush_rq;
 
+	blk_rq_init(q, rq);
+
 	switch (blk_flush_cur_seq(q)) {
 	case QUEUE_FSEQ_PREFLUSH:
-		queue_flush(q, rq, pre_flush_end_io);
+		init_flush_request(rq, orig_rq->rq_disk);
+		rq->end_io = pre_flush_end_io;
 		break;
-
 	case QUEUE_FSEQ_DATA:
-		/* initialize proxy request, inherit FLUSH/FUA and queue it */
-		blk_rq_init(q, rq);
 		init_request_from_bio(rq, orig_rq->bio);
 		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
 		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
-
-		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 		break;
-
 	case QUEUE_FSEQ_POSTFLUSH:
-		queue_flush(q, rq, post_flush_end_io);
+		init_flush_request(rq, orig_rq->rq_disk);
+		rq->end_io = post_flush_end_io;
 		break;
-
 	default:
 		BUG();
 	}
+
+	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 	return rq;
 }
 
