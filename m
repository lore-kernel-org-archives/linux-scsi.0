From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/18] dm: remove incomple BLOCK_PC support
Date: Wed, 25 Jan 2017 18:25:14 +0100
Message-ID: <1485365126-23210-7-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

DM tries to copy a few fields around for BLOCK_PC requests, but given
that no dm-target ever wires up scsi_cmd_ioctl BLOCK_PC can't actually
be sent to dm.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-rq.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 93f6e9f..3f12916 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -270,19 +270,6 @@ static void dm_end_request(struct request *clone, int error)
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		rq->errors = clone->errors;
-		rq->resid_len = clone->resid_len;
-
-		if (rq->sense)
-			/*
-			 * We are using the sense buffer of the original
-			 * request.
-			 * So setting the length of the sense data is enough.
-			 */
-			rq->sense_len = clone->sense_len;
-	}
-
 	free_rq_clone(clone);
 	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
@@ -511,9 +498,6 @@ static int setup_clone(struct request *clone, struct request *rq,
 	if (r)
 		return r;
 
-	clone->cmd = rq->cmd;
-	clone->cmd_len = rq->cmd_len;
-	clone->sense = rq->sense;
 	clone->end_io = end_clone_request;
 	clone->end_io_data = tio;
 
-- 
2.1.4

