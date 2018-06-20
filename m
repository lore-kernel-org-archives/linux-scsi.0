From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 4/5] mmc: use __blk_mq_complete_request in timeout path
Date: Wed, 20 Jun 2018 21:22:43 +0800
Message-ID: <1529500964-28429-5-git-send-email-jianchao.w.wang@oracle.com>
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
 drivers/mmc/core/queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 648eb67..43dcd7a 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -112,7 +112,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct request *req)
 			return BLK_EH_RESET_TIMER;
 		}
 		/* No timeout (XXX: huh? comment doesn't make much sense) */
-		blk_mq_complete_request(req);
+		__blk_mq_complete_request(req);
 		return BLK_EH_DONE;
 	default:
 		/* Timeout is handled by mmc core */
-- 
2.7.4
