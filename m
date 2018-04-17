From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] blk-mq: Clear out elevator private data
Date: Tue, 17 Apr 2018 14:42:18 -0700
Message-ID: <20180417214218.GA44753@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, linux-kernel@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some elevators may not correctly check rq->rq_flags & RQF_ELVPRIV, and
may attempt to read rq->elv fields. When requests got reused, this
caused BFQ to think it already had a bfqq (rq->elv.priv[1]) allocated.
This could lead to odd behaviors like having the sense buffer address
slowly start incrementing. This eventually tripped HARDENED_USERCOPY
and KASAN.

This patch wipes all of rq->elv instead of just rq->elv.icq. While
it shouldn't technically be needed, this ends up being a robustness
improvement that should lead to at least finding bugs in elevators faster.

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Fixes: bd166ef183c26 ("blk-mq-sched: add framework for MQ capable IO schedulers")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
In theory, BFQ needs to also check the RQF_ELVPRIV flag, but I'll leave that
to Paolo to figure out. Also, my Fixes line is kind of a best-guess. This
is where icq was originally wiped, so it seemed as good a commit as any.
---
 block/blk-mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0dc9e341c2a7..859df3160303 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -363,7 +363,7 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 
 	rq = blk_mq_rq_ctx_init(data, tag, op);
 	if (!op_is_flush(op)) {
-		rq->elv.icq = NULL;
+		memset(&rq->elv, 0, sizeof(rq->elv));
 		if (e && e->type->ops.mq.prepare_request) {
 			if (e->type->icq_cache && rq_ioc(bio))
 				blk_mq_sched_assign_ioc(rq, bio);
@@ -461,7 +461,7 @@ void blk_mq_free_request(struct request *rq)
 			e->type->ops.mq.finish_request(rq);
 		if (rq->elv.icq) {
 			put_io_context(rq->elv.icq->ioc);
-			rq->elv.icq = NULL;
+			memset(&rq->elv, 0, sizeof(rq->elv));
 		}
 	}
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
