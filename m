From: "hch@lst.de" <hch@lst.de>
Subject: Re: Fwd: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
        4.17.0-x64-08428-g7d3bf613e99a
Date: Thu, 14 Jun 2018 10:34:17 +0200
Message-ID: <20180614083417.GB18536@lst.de>
References: <201806130602.59441.randrianasulu@gmail.com> <3ab38d8d65c34d4109195f29bae61429f30b13aa.camel@wdc.com> <201806140133.52354.randrianasulu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201806140133.52354.randrianasulu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Randrianasulu <randrianasulu@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Andrew, can you test the patch below, please?

---
>From ccf385c63e30e8633b771604bed0e09c895e9175 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 14 Jun 2018 10:25:36 +0200
Subject: blk-mq: don't time out requests again that are in the timeout handler

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         | 5 +++++
 include/linux/blkdev.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e9da5e6a8526..54332db09e5d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -671,6 +671,7 @@ static void __blk_mq_requeue_request(struct request *rq)
 
 	if (blk_mq_request_started(rq)) {
 		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
+		rq->rq_flags &= ~RQF_TIMED_OUT;
 		if (q->dma_drain_size && blk_rq_bytes(rq))
 			rq->nr_phys_segments--;
 	}
@@ -770,6 +771,7 @@ EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
 static void blk_mq_rq_timed_out(struct request *req, bool reserved)
 {
+	req->rq_flags |= RQF_TIMED_OUT;
 	if (req->q->mq_ops->timeout) {
 		enum blk_eh_timer_return ret;
 
@@ -779,6 +781,7 @@ static void blk_mq_rq_timed_out(struct request *req, bool reserved)
 		WARN_ON_ONCE(ret != BLK_EH_RESET_TIMER);
 	}
 
+	req->rq_flags &= ~RQF_TIMED_OUT;
 	blk_add_timer(req);
 }
 
@@ -788,6 +791,8 @@ static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
 
 	if (blk_mq_rq_state(rq) != MQ_RQ_IN_FLIGHT)
 		return false;
+	if (rq->rq_flags & RQF_TIMED_OUT)
+		return false;
 
 	deadline = blk_rq_deadline(rq);
 	if (time_after_eq(jiffies, deadline))
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bca3a92eb55f..fa6f11751430 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -127,6 +127,8 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
 /* already slept for hybrid poll */
 #define RQF_MQ_POLL_SLEPT	((__force req_flags_t)(1 << 20))
+/* ->timeout has been called, don't expire again */
+#define RQF_TIMED_OUT		((__force req_flags_t)(1 << 21))
 
 /* flags that prevent us from merging requests: */
 #define RQF_NOMERGE_FLAGS \
-- 
2.17.1
