From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 16/16] block: unexport bsg_softirq_done() again
Date: Wed, 12 Oct 2016 15:06:42 +0200
Message-ID: <992fceabad26e146a728e8c80694ccb856182dc5.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Unexport bsg_softirq_done() again, we don't need it outside of bsg-lib.c
anymore now that scsi_transport_fc is a pure bsg-lib client.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c         | 3 +--
 include/linux/bsg-lib.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 46a4fee..4ac0ade 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -93,14 +93,13 @@ EXPORT_SYMBOL_GPL(bsg_job_done);
  * bsg_softirq_done - softirq done routine for destroying the bsg requests
  * @rq: BSG request that holds the job to be destroyed
  */
-void bsg_softirq_done(struct request *rq)
+static void bsg_softirq_done(struct request *rq)
 {
 	struct bsg_job *job = rq->special;
 
 	blk_end_request_all(rq, rq->errors);
 	bsg_job_put(job);
 }
-EXPORT_SYMBOL_GPL(bsg_softirq_done);
 
 static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 {
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index b708db9..657a718 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -69,7 +69,6 @@ void bsg_job_done(struct bsg_job *job, int result,
 int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
-void bsg_softirq_done(struct request *rq);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
 
-- 
1.8.5.6

