From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/25] loop: zero-fill bio on the submitting cpu
Date: Thu,  6 Apr 2017 17:39:29 +0200
Message-ID: <20170406153944.10058-11-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

In thruth I've just audited which blk-mq drivers don't currently have a
complete callback, but I think this change is at least borderline useful.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 30 ++++++++++++++----------------
 drivers/block/loop.h |  1 +
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cc981f34e017..6924ec611a49 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -445,32 +445,27 @@ static int lo_req_flush(struct loop_device *lo, struct request *rq)
 	return ret;
 }
 
-static inline void handle_partial_read(struct loop_cmd *cmd, long bytes)
+static void lo_complete_rq(struct request *rq)
 {
-	if (bytes < 0 || op_is_write(req_op(cmd->rq)))
-		return;
+	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
-	if (unlikely(bytes < blk_rq_bytes(cmd->rq))) {
+	if (unlikely(req_op(cmd->rq) == REQ_OP_READ && cmd->use_aio &&
+		     cmd->ret >= 0 && cmd->ret < blk_rq_bytes(cmd->rq))) {
 		struct bio *bio = cmd->rq->bio;
 
-		bio_advance(bio, bytes);
+		bio_advance(bio, cmd->ret);
 		zero_fill_bio(bio);
 	}
+
+	blk_mq_end_request(rq, cmd->ret < 0 ? -EIO : 0);
 }
 
 static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 {
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
-	struct request *rq = cmd->rq;
-
-	handle_partial_read(cmd, ret);
 
-	if (ret > 0)
-		ret = 0;
-	else if (ret < 0)
-		ret = -EIO;
-
-	blk_mq_complete_request(rq, ret);
+	cmd->ret = ret;
+	blk_mq_complete_request(cmd->rq, 0);
 }
 
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
@@ -1686,8 +1681,10 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	ret = do_req_filebacked(lo, cmd->rq);
  failed:
 	/* complete non-aio request */
-	if (!cmd->use_aio || ret)
-		blk_mq_complete_request(cmd->rq, ret ? -EIO : 0);
+	if (!cmd->use_aio || ret) {
+		cmd->ret = ret ? -EIO : 0;
+		blk_mq_complete_request(cmd->rq, 0);
+	}
 }
 
 static void loop_queue_work(struct kthread_work *work)
@@ -1713,6 +1710,7 @@ static int loop_init_request(void *data, struct request *rq,
 static const struct blk_mq_ops loop_mq_ops = {
 	.queue_rq       = loop_queue_rq,
 	.init_request	= loop_init_request,
+	.complete	= lo_complete_rq,
 };
 
 static int loop_add(struct loop_device **l, int i)
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index fb2237c73e61..fecd3f97ef8c 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -70,6 +70,7 @@ struct loop_cmd {
 	struct request *rq;
 	struct list_head list;
 	bool use_aio;           /* use AIO interface to handle I/O */
+	long ret;
 	struct kiocb iocb;
 };
 
-- 
2.11.0
