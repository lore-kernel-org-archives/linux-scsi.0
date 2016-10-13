From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 16/16] block: unexport bsg_softirq_done() again
Date: Thu, 13 Oct 2016 17:00:32 +0200
Message-ID: <dde8c4d8fcd0ad224f32a8036ce7793143633b53.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49735 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755957AbcJMPB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 11:01:57 -0400
In-Reply-To: <cover.1476369687.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>

Unexport bsg_softirq_done() again, we don't need it outside of bsg-lib.c
anymore now that scsi_transport_fc is a pure bsg-lib client.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/bsg-lib.c         | 3 +--
 include/linux/bsg-lib.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 803ec40..2d1df5c 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -96,13 +96,12 @@ void bsg_job_done(struct bsg_job *job, int result,
  * bsg_softirq_done - softirq done routine for destroying the bsg requests
  * @rq: BSG request that holds the job to be destroyed
  */
-void bsg_softirq_done(struct request *rq)
+static void bsg_softirq_done(struct request *rq)
 {
 	struct bsg_job *job = rq->special;
 
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

