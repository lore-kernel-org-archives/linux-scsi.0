From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 39/44] block: export bsg_softirq_done
Date: Tue, 11 Oct 2016 13:29:10 +0200
Message-ID: <848f22701f408fd0625dd941b4993df06b227a72.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Export bsg_softirq_done so it can be used by clients of bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c         | 3 ++-
 include/linux/bsg-lib.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 6b99c7f..5d24d25 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -82,13 +82,14 @@ EXPORT_SYMBOL_GPL(bsg_job_done);
  * bsg_softirq_done - softirq done routine for destroying the bsg requests
  * @rq: BSG request that holds the job to be destroyed
  */
-static void bsg_softirq_done(struct request *rq)
+void bsg_softirq_done(struct request *rq)
 {
 	struct bsg_job *job = rq->special;
 
 	blk_end_request_all(rq, rq->errors);
 	kref_put(&job->kref, bsg_destroy_job);
 }
+EXPORT_SYMBOL_GPL(bsg_softirq_done);
 
 static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 {
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 67f7de6..09f3044 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -70,5 +70,6 @@ int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
 void bsg_destroy_job(struct kref *kref);
+void bsg_softirq_done(struct request *rq);
 
 #endif
-- 
1.8.5.6

