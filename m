From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/2] blk-mq-debugfs: Also show requests that have not yet been started
Date: Mon,  4 Dec 2017 16:38:09 -0800
Message-ID: <20171205003809.1705-3-bart.vanassche@wdc.com>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171205003809.1705-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

When debugging e.g. the SCSI timeout handler it is important that
requests that have not yet been started or that already have
completed are also reported through debugfs.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-mq-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index f7db73f1698e..886b37163f17 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -409,7 +409,7 @@ static void hctx_show_busy_rq(struct request *rq, void *data, bool reserved)
 	const struct show_busy_params *params = data;
 
 	if (blk_mq_map_queue(rq->q, rq->mq_ctx->cpu) == params->hctx &&
-	    test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
+	    list_empty(&rq->queuelist))
 		__blk_mq_debugfs_rq_show(params->m,
 					 list_entry_rq(&rq->queuelist));
 }
-- 
2.15.0
