From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 6/6] dm rq: Avoid that request processing stalls sporadically
Date: Fri, 7 Apr 2017 11:16:54 -0700
Message-ID: <20170407181654.27836-7-bart.vanassche@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

While running the srp-test software I noticed that request
processing stalls sporadically at the beginning of a test, namely
when mkfs is run against a dm-mpath device. Every time when that
happened the following command was sufficient to resume request
processing:

    echo run >/sys/kernel/debug/block/dm-0/state

This patch avoids that such request processing stalls occur. The
test I ran is as follows:

    while srp-test/run_tests -d -r 30 -t 02-mq; do :; done

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-rq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 6886bf160fb2..d19af1d21f4c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -755,6 +755,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
+		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
 		return BLK_MQ_RQ_QUEUE_BUSY;
 	}
 
-- 
2.12.0
