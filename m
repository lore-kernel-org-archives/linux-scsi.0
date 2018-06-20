From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 3/5] null_blk: use __blk_mq_complete_request in timeout path
Date: Wed, 20 Jun 2018 21:22:42 +0800
Message-ID: <1529500964-28429-4-git-send-email-jianchao.w.wang@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, keith.busch@intel.com, josef@toxicpanda.com, ulf.hansson@linaro.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To regain the capability to prevent normal completion path from
entering a timeout request, blk_mq_mark_rq_complete is introduced
in blk_mq_complete_request. Have to use __blk_mq_complete_request
in timeout path to complete a timeout request.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/block/null_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 7948049..d756539 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -1428,7 +1428,7 @@ static void null_request_fn(struct request_queue *q)
 static enum blk_eh_timer_return null_timeout_rq(struct request *rq, bool res)
 {
 	pr_info("null: rq %p timed out\n", rq);
-	blk_mq_complete_request(rq);
+	__blk_mq_complete_request(rq);
 	return BLK_EH_DONE;
 }
 
-- 
2.7.4
