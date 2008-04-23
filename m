From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/5] block: add large command support
Date: Wed, 23 Apr 2008 18:13:04 +0300
Message-ID: <480F5200.3040003@panasas.com>
References: <480F4CC2.7070804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <480F4CC2.7070804@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch changes rq->cmd from the static array to a pointer to
support large commands.

We rarely handle large commands. So for optimization, a struct request
still has a static array for a command. blk_init_rq sets rq->cmd pointer
to the static array.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |    1 +
 include/linux/blkdev.h |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ca103d1..4c97fe2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -119,6 +119,7 @@ void blk_init_rq(struct request_queue *q, struct request *rq, int cmd_flags)
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->tag = -1;
 	rq->ref_count = 1;
+	rq->cmd = rq->__cmd;
 }
 EXPORT_SYMBOL(blk_init_rq);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7121783..32ae32b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -215,8 +215,9 @@ struct request {
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	unsigned short cmd_len;
+	unsigned char __cmd[BLK_MAX_CDB];
+	unsigned char *cmd;
 
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
@@ -818,6 +819,13 @@ static inline void put_dev_sector(Sector p)
 	page_cache_release(p.v);
 }
 
+static inline void rq_set_cmd(struct request *rq, unsigned char *cmd,
+			      unsigned short cmd_len)
+{
+	rq->cmd = cmd;
+	rq->cmd_len = cmd_len;
+}
+
 struct work_struct;
 int kblockd_schedule_work(struct work_struct *work);
 void kblockd_flush_work(struct work_struct *work);
-- 
1.5.3.3

