From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 01/12] blk-mq: Do not invoke .queue_rq() for a stopped queue
Date: Wed, 26 Oct 2016 15:50:44 -0700
Message-ID: <1debcf7f-c950-308b-d297-3e48a77e08d7@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

The meaning of the BLK_MQ_S_STOPPED flag is "do not call
.queue_rq()". Hence modify blk_mq_make_request() such that requests
are queued instead of issued if a queue has been stopped.

Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: <stable@vger.kernel.org>
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ddc2eed..b5dcafb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1332,9 +1332,9 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (!blk_mq_direct_issue_request(old_rq, &cookie))
-			goto done;
-		blk_mq_insert_request(old_rq, false, true, true);
+		if (test_bit(BLK_MQ_S_STOPPED, &data.hctx->state) ||
+		    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+			blk_mq_insert_request(old_rq, false, true, true);
 		goto done;
 	}
 
-- 
2.10.1

