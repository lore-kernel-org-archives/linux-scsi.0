From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/5] allow blk_rq_map_kern to append to requests
Date: Sun, 17 May 2009 18:55:18 +0300
Message-ID: <4A103366.9040200@panasas.com>
References: <4A1032B0.5000003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:14278 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750893AbZEQPzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2009 11:55:23 -0400
In-Reply-To: <4A1032B0.5000003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: James Bottomley <James.Bottomley@HansenPartnership.com>

Use blk_rq_append_bio() internally instead of blk_rq_bio_prep()
so blk_rq_map_kern can be called multiple times, to map multiple
buffers.

This is in the effort to un-export blk_rq_append_bio()

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-map.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 56082be..caa05a6 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -282,7 +282,8 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
  *
  * Description:
  *    Data will be mapped directly if possible. Otherwise a bounce
- *    buffer is used.
+ *    buffer is used. Can be called multple times to append multple
+ *    buffers.
  */
 int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		    unsigned int len, gfp_t gfp_mask)
@@ -290,6 +291,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
+	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -311,7 +313,13 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
 
-	blk_rq_bio_prep(q, rq, bio);
+	ret = blk_rq_append_bio(q, rq, bio);
+	if (unlikely(ret)) {
+		/* request is too big */
+		bio_put(bio);
+		return ret;
+	}
+
 	blk_queue_bounce(q, &rq->bio);
 	rq->buffer = NULL;
 	return 0;
-- 
1.6.2.1


