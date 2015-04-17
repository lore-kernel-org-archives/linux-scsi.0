From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] nbd: stop using req->cmd
Date: Fri, 17 Apr 2015 22:37:21 +0200
Message-ID: <1429303042-12078-7-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbDQUig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:36 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c      | 48 +++++++++++++++++++++++-------------------------
 include/uapi/linux/nbd.h |  2 --
 2 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9cf52ac..83a7ba4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -230,29 +230,40 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 	int result, flags;
 	struct nbd_request request;
 	unsigned long size = blk_rq_bytes(req);
+	u32 type;
+
+	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
+		type = NBD_CMD_DISC;
+	else if (req->cmd_flags & REQ_DISCARD)
+		type = NBD_CMD_TRIM;
+	else if (req->cmd_flags & REQ_FLUSH)
+		type = NBD_CMD_FLUSH;
+	else if (rq_data_dir(req) == WRITE)
+		type = NBD_CMD_WRITE;
+	else
+		type = NBD_CMD_READ;
 
 	memset(&request, 0, sizeof(request));
 	request.magic = htonl(NBD_REQUEST_MAGIC);
-	request.type = htonl(nbd_cmd(req));
-
-	if (nbd_cmd(req) != NBD_CMD_FLUSH && nbd_cmd(req) != NBD_CMD_DISC) {
+	request.type = htonl(type);
+	if (type != NBD_CMD_FLUSH && type != NBD_CMD_DISC) {
 		request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
 		request.len = htonl(size);
 	}
 	memcpy(request.handle, &req, sizeof(req));
 
 	dev_dbg(nbd_to_dev(nbd), "request %p: sending control (%s@%llu,%uB)\n",
-		req, nbdcmd_to_ascii(nbd_cmd(req)),
+		req, nbdcmd_to_ascii(type),
 		(unsigned long long)blk_rq_pos(req) << 9, blk_rq_bytes(req));
 	result = sock_xmit(nbd, 1, &request, sizeof(request),
-			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
+			(type == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
 		dev_err(disk_to_dev(nbd->disk),
 			"Send control failed (result %d)\n", result);
 		return -EIO;
 	}
 
-	if (nbd_cmd(req) == NBD_CMD_WRITE) {
+	if (type == NBD_CMD_WRITE) {
 		struct req_iterator iter;
 		struct bio_vec bvec;
 		/*
@@ -352,7 +363,7 @@ static struct request *nbd_read_stat(struct nbd_device *nbd)
 	}
 
 	dev_dbg(nbd_to_dev(nbd), "request %p: got reply\n", req);
-	if (nbd_cmd(req) == NBD_CMD_READ) {
+	if (rq_data_dir(req) != WRITE) {
 		struct req_iterator iter;
 		struct bio_vec bvec;
 
@@ -452,23 +463,11 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
 	if (req->cmd_type != REQ_TYPE_FS)
 		goto error_out;
 
-	nbd_cmd(req) = NBD_CMD_READ;
-	if (rq_data_dir(req) == WRITE) {
-		if ((req->cmd_flags & REQ_DISCARD)) {
-			WARN_ON(!(nbd->flags & NBD_FLAG_SEND_TRIM));
-			nbd_cmd(req) = NBD_CMD_TRIM;
-		} else
-			nbd_cmd(req) = NBD_CMD_WRITE;
-		if (nbd->flags & NBD_FLAG_READ_ONLY) {
-			dev_err(disk_to_dev(nbd->disk),
-				"Write on read-only\n");
-			goto error_out;
-		}
-	}
-
-	if (req->cmd_flags & REQ_FLUSH) {
-		BUG_ON(unlikely(blk_rq_sectors(req)));
-		nbd_cmd(req) = NBD_CMD_FLUSH;
+	if (rq_data_dir(req) == WRITE &&
+	    (nbd->flags & NBD_FLAG_READ_ONLY)) {
+		dev_err(disk_to_dev(nbd->disk),
+			"Write on read-only\n");
+		goto error_out;
 	}
 
 	req->errors = 0;
@@ -593,7 +592,6 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		mutex_lock(&nbd->tx_lock);
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_DRV_PRIV;
-		nbd_cmd(&sreq) = NBD_CMD_DISC;
 
 		/* Check again after getting mutex back.  */
 		if (!nbd->sock)
diff --git a/include/uapi/linux/nbd.h b/include/uapi/linux/nbd.h
index 4f52549..e08e413 100644
--- a/include/uapi/linux/nbd.h
+++ b/include/uapi/linux/nbd.h
@@ -44,8 +44,6 @@ enum {
 /* there is a gap here to match userspace */
 #define NBD_FLAG_SEND_TRIM    (1 << 5) /* send trim/discard */
 
-#define nbd_cmd(req) ((req)->cmd[0])
-
 /* userspace doesn't need the nbd_device structure */
 
 /* These are sent over the network in the request/reply magic fields */
-- 
1.9.1

