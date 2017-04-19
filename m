From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/23] nbd: don't use req->errors
Date: Wed, 19 Apr 2017 21:26:58 +0200
Message-ID: <20170419192708.22098-14-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Add a nbd-specific field instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 drivers/block/nbd.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 6e592c2ba8fd..09a74a66beb1 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -115,6 +115,7 @@ struct nbd_cmd {
 	int index;
 	int cookie;
 	struct completion send_complete;
+	int status;
 };
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -244,16 +245,14 @@ static void nbd_size_set(struct nbd_device *nbd, loff_t blocksize,
 	nbd_size_update(nbd);
 }
 
-static void nbd_end_request(struct nbd_cmd *cmd)
+static void nbd_complete_rq(struct request *req)
 {
-	struct nbd_device *nbd = cmd->nbd;
-	struct request *req = blk_mq_rq_from_pdu(cmd);
-	int error = req->errors ? -EIO : 0;
+	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(req);
 
-	dev_dbg(nbd_to_dev(nbd), "request %p: %s\n", cmd,
-		error ? "failed" : "done");
+	dev_dbg(nbd_to_dev(cmd->nbd), "request %p: %s\n", cmd,
+		cmd->status ? "failed" : "done");
 
-	blk_mq_complete_request(req, error);
+	blk_mq_end_request(req, cmd->status);
 }
 
 /*
@@ -286,7 +285,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	struct nbd_config *config;
 
 	if (!refcount_inc_not_zero(&nbd->config_refs)) {
-		req->errors = -EIO;
+		cmd->status = -EIO;
 		return BLK_EH_HANDLED;
 	}
 
@@ -331,7 +330,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 				    "Connection timed out\n");
 	}
 	set_bit(NBD_TIMEDOUT, &config->runtime_flags);
-	req->errors = -EIO;
+	cmd->status = -EIO;
 	sock_shutdown(nbd);
 	nbd_config_put(nbd);
 
@@ -574,7 +573,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 	if (ntohl(reply.error)) {
 		dev_err(disk_to_dev(nbd->disk), "Other side returned error (%d)\n",
 			ntohl(reply.error));
-		req->errors = -EIO;
+		cmd->status = -EIO;
 		return cmd;
 	}
 
@@ -599,7 +598,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 				 */
 				if (nbd_disconnected(config) ||
 				    config->num_connections <= 1) {
-					req->errors = -EIO;
+					cmd->status = -EIO;
 					return cmd;
 				}
 				return ERR_PTR(-EIO);
@@ -636,7 +635,7 @@ static void recv_work(struct work_struct *work)
 			break;
 		}
 
-		nbd_end_request(cmd);
+		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd), 0);
 	}
 	atomic_dec(&config->recv_threads);
 	wake_up(&config->recv_wq);
@@ -651,8 +650,8 @@ static void nbd_clear_req(struct request *req, void *data, bool reserved)
 	if (!blk_mq_request_started(req))
 		return;
 	cmd = blk_mq_rq_to_pdu(req);
-	req->errors = -EIO;
-	nbd_end_request(cmd);
+	cmd->status = -EIO;
+	blk_mq_complete_request(req, 0);
 }
 
 static void nbd_clear_que(struct nbd_device *nbd)
@@ -740,7 +739,7 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 		nbd_config_put(nbd);
 		return -EINVAL;
 	}
-	req->errors = 0;
+	cmd->status = 0;
 again:
 	nsock = config->socks[index];
 	mutex_lock(&nsock->tx_lock);
@@ -1408,6 +1407,7 @@ static int nbd_init_request(void *data, struct request *rq,
 
 static const struct blk_mq_ops nbd_mq_ops = {
 	.queue_rq	= nbd_queue_rq,
+	.complete	= nbd_complete_rq,
 	.init_request	= nbd_init_request,
 	.timeout	= nbd_xmit_timeout,
 };
-- 
2.11.0
