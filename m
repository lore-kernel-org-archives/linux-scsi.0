From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/10] nbd: remove REQ_TYPE_DRV_PRIV leftovers
Date: Tue, 31 Jan 2017 16:57:27 +0100
Message-ID: <1485878251-6107-7-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Disconnects don't use block layer requests these days, so all handling
of private requests is dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9fd06ee..d4c6281 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -193,13 +193,6 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	set_bit(NBD_TIMEDOUT, &nbd->runtime_flags);
 	req->errors++;
 
-	/*
-	 * If our disconnect packet times out then we're already holding the
-	 * config_lock and could deadlock here, so just set an error and return,
-	 * we'll handle shutting everything down later.
-	 */
-	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
-		return BLK_EH_HANDLED;
 	mutex_lock(&nbd->config_lock);
 	sock_shutdown(nbd);
 	mutex_unlock(&nbd->config_lock);
@@ -510,8 +503,7 @@ static void nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 		goto error_out;
 	}
 
-	if (req->cmd_type != REQ_TYPE_FS &&
-	    req->cmd_type != REQ_TYPE_DRV_PRIV)
+	if (req->cmd_type != REQ_TYPE_FS)
 		goto error_out;
 
 	if (req->cmd_type == REQ_TYPE_FS &&
-- 
2.1.4

