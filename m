From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 2/5] nbd: use __blk_mq_complete_request in timeout path
Date: Wed, 20 Jun 2018 21:22:41 +0800
Message-ID: <1529500964-28429-3-git-send-email-jianchao.w.wang@oracle.com>
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
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 3b7083b..d7e533a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -354,7 +354,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	sock_shutdown(nbd);
 	nbd_config_put(nbd);
 done:
-	blk_mq_complete_request(req);
+	__blk_mq_complete_request(req);
 	return BLK_EH_DONE;
 }
 
-- 
2.7.4
