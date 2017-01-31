From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/10] nbd: move request validity checking into nbd_send_cmd
Date: Tue, 31 Jan 2017 16:57:28 +0100
Message-ID: <1485878251-6107-8-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is where we do the rest of the request handling, which will
become much simpler soon, too.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index d4c6281..8bce1c7c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -271,6 +271,9 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	u32 type;
 	u32 tag = blk_mq_unique_tag(req);
 
+	if (req->cmd_type != REQ_TYPE_FS)
+		return -EIO;
+
 	if (req_op(req) == REQ_OP_DISCARD)
 		type = NBD_CMD_TRIM;
 	else if (req_op(req) == REQ_OP_FLUSH)
@@ -280,6 +283,13 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	else
 		type = NBD_CMD_READ;
 
+	if (rq_data_dir(req) == WRITE &&
+	    (nbd->flags & NBD_FLAG_READ_ONLY)) {
+		dev_err_ratelimited(disk_to_dev(nbd->disk),
+				    "Write on read-only\n");
+		return -EIO;
+	}
+
 	memset(&request, 0, sizeof(request));
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(type);
@@ -503,17 +513,6 @@ static void nbd_handle_cmd(struct nbd_cmd *cmd, int index)
 		goto error_out;
 	}
 
-	if (req->cmd_type != REQ_TYPE_FS)
-		goto error_out;
-
-	if (req->cmd_type == REQ_TYPE_FS &&
-	    rq_data_dir(req) == WRITE &&
-	    (nbd->flags & NBD_FLAG_READ_ONLY)) {
-		dev_err_ratelimited(disk_to_dev(nbd->disk),
-				    "Write on read-only\n");
-		goto error_out;
-	}
-
 	req->errors = 0;
 
 	nsock = nbd->socks[index];
-- 
2.1.4

