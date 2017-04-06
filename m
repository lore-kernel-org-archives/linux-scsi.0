From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/25] nbd: don't use req->errors
Date: Thu,  6 Apr 2017 17:39:33 +0200
Message-ID: <20170406153944.10058-15-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Add a nbd-specific field instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 03ae72985c79..4f045fab9659 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -83,6 +83,7 @@ struct nbd_device {
 struct nbd_cmd {
 	struct nbd_device *nbd;
 	struct completion send_complete;
+	int status;
 };
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -152,16 +153,14 @@ static void nbd_size_set(struct nbd_device *nbd, struct block_device *bdev,
 		nbd_size_update(nbd, bdev);
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
@@ -193,7 +192,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 
 	dev_err(nbd_to_dev(nbd), "Connection timed out, shutting down connection\n");
 	set_bit(NBD_TIMEDOUT, &nbd->runtime_flags);
-	req->errors = -EIO;
+	cmd->status = -EIO;
 
 	mutex_lock(&nbd->config_lock);
 	sock_shutdown(nbd);
@@ -433,7 +432,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 	if (ntohl(reply.error)) {
 		dev_err(disk_to_dev(nbd->disk), "Other side returned error (%d)\n",
 			ntohl(reply.error));
-		req->errors = -EIO;
+		cmd->status = -EIO;
 		return cmd;
 	}
 
@@ -449,7 +448,7 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 			if (result <= 0) {
 				dev_err(disk_to_dev(nbd->disk), "Receive data failed (result %d)\n",
 					result);
-				req->errors = -EIO;
+				cmd->status = -EIO;
 				return cmd;
 			}
 			dev_dbg(nbd_to_dev(nbd), "request %p: got %d bytes data\n",
@@ -499,7 +498,7 @@ static void recv_work(struct work_struct *work)
 			break;
 		}
 
-		nbd_end_request(cmd);
+		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd), 0);
 	}
 
 	/*
@@ -519,8 +518,8 @@ static void nbd_clear_req(struct request *req, void *data, bool reserved)
 	if (!blk_mq_request_started(req))
 		return;
 	cmd = blk_mq_rq_to_pdu(req);
-	req->errors = -EIO;
-	nbd_end_request(cmd);
+	cmd->status = -EIO;
+	blk_mq_complete_request(req, 0);
 }
 
 static void nbd_clear_que(struct nbd_device *nbd)
@@ -551,7 +550,7 @@ static int nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 		return -EINVAL;
 	}
 
-	req->errors = 0;
+	cmd->status = 0;
 
 	nsock = nbd->socks[index];
 	mutex_lock(&nsock->tx_lock);
@@ -1037,6 +1036,7 @@ static int nbd_init_request(void *data, struct request *rq,
 
 static const struct blk_mq_ops nbd_mq_ops = {
 	.queue_rq	= nbd_queue_rq,
+	.complete	= nbd_complete_rq,
 	.init_request	= nbd_init_request,
 	.timeout	= nbd_xmit_timeout,
 };
-- 
2.11.0
