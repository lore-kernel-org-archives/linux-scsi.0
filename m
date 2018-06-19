From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: export __blk_complete_request
Date: Tue, 19 Jun 2018 16:09:42 +0200
Message-ID: <20180619140942.GA13089@lst.de>
References: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Does the patch below fix your FC issue?

---
>From 5e5b4fc51c84a0f5c27f2f770be7a4eaed0f6e8c Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 19 Jun 2018 13:59:52 +0200
Subject: block: fix timeout changes for legacy request drivers

blk_mq_complete_request can only be called for blk-mq drivers, but when
removing the BLK_EH_HANDLED return value, two legacy request timeout
methods incorrectly got switched to call blk_mq_complete_request.
Call __blk_complete_request instead to reinstance the previous behavior.
For that __blk_complete_request needs to be exported.

Fixes: 1fc2b62e ("scsi_transport_fc: complete requests from ->timeout")
Fixes: 0df0bb08 ("null_blk: complete requests from ->timeout")
Reported-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-softirq.c              | 1 +
 drivers/block/null_blk.c         | 2 +-
 drivers/scsi/scsi_transport_fc.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 01e2b353a2b9..15c1f5e12eb8 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -144,6 +144,7 @@ void __blk_complete_request(struct request *req)
 
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(__blk_complete_request);
 
 /**
  * blk_complete_request - end I/O on a request
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 7948049f6c43..042c778e5a4e 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -1365,7 +1365,7 @@ static blk_qc_t null_queue_bio(struct request_queue *q, struct bio *bio)
 static enum blk_eh_timer_return null_rq_timed_out_fn(struct request *rq)
 {
 	pr_info("null: rq %p timed out\n", rq);
-	blk_mq_complete_request(rq);
+	__blk_complete_request(rq);
 	return BLK_EH_DONE;
 }
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1da3d71e9f61..13948102ca29 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3592,7 +3592,7 @@ fc_bsg_job_timeout(struct request *req)
 
 	/* the blk_end_sync_io() doesn't check the error */
 	if (inflight)
-		blk_mq_complete_request(req);
+		__blk_complete_request(req);
 	return BLK_EH_DONE;
 }
 
-- 
2.17.1
