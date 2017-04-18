From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: mtip32xx: add a status field to struct mtip_cmd
Date: Tue, 18 Apr 2017 08:52:19 -0700
Message-ID: <20170418155229.5977-14-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Instead of using req->errors, which will go away.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/mtip32xx/mtip32xx.c | 16 +++++++++-------
 drivers/block/mtip32xx/mtip32xx.h |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 05e3e664ea1b..7406de29db58 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -241,7 +241,8 @@ static void mtip_async_complete(struct mtip_port *port,
 
 	rq = mtip_rq_from_tag(dd, tag);
 
-	blk_mq_complete_request(rq, status);
+	cmd->status = status;
+	blk_mq_complete_request(rq, 0);
 }
 
 /*
@@ -2910,18 +2911,19 @@ static void mtip_softirq_done_fn(struct request *rq)
 	if (unlikely(cmd->unaligned))
 		up(&dd->port->cmd_slot_unal);
 
-	blk_mq_end_request(rq, rq->errors);
+	blk_mq_end_request(rq, cmd->status);
 }
 
 static void mtip_abort_cmd(struct request *req, void *data,
 							bool reserved)
 {
+	struct mtip_cmd *cmd = blk_mq_rq_to_pdu(req);
 	struct driver_data *dd = data;
 
 	dbg_printk(MTIP_DRV_NAME " Aborting request, tag = %d\n", req->tag);
 
 	clear_bit(req->tag, dd->port->cmds_to_issue);
-	req->errors = -EIO;
+	cmd->status = -EIO;
 	mtip_softirq_done_fn(req);
 }
 
@@ -3816,7 +3818,6 @@ static int mtip_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (likely(!ret))
 		return BLK_MQ_RQ_QUEUE_OK;
 
-	rq->errors = ret;
 	return BLK_MQ_RQ_QUEUE_ERROR;
 }
 
@@ -4106,9 +4107,10 @@ static void mtip_no_dev_cleanup(struct request *rq, void *data, bool reserv)
 	struct driver_data *dd = (struct driver_data *)data;
 	struct mtip_cmd *cmd;
 
-	if (likely(!reserv))
-		blk_mq_complete_request(rq, -ENODEV);
-	else if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &dd->port->flags)) {
+	if (likely(!reserv)) {
+		cmd->status = -ENODEV;
+		blk_mq_complete_request(rq, 0);
+	} else if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &dd->port->flags)) {
 
 		cmd = mtip_cmd_from_tag(dd, MTIP_TAG_INTERNAL);
 		if (cmd->comp_func)
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 7617888f7944..57b41528a824 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -352,6 +352,7 @@ struct mtip_cmd {
 	int retries; /* The number of retries left for this command. */
 
 	int direction; /* Data transfer direction */
+	int status;
 };
 
 /* Structure used to describe a port. */
-- 
2.11.0
