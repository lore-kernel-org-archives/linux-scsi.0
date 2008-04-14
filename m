From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/4] block: add large command support
Date: Mon, 14 Apr 2008 19:50:37 +0900
Message-ID: <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080414010112W.tomof@acm.org>
 <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1208170266-1676-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1208170266-1676-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1208170266-1676-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:56698 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYDNLFM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 07:05:12 -0400
In-Reply-To: <1208170266-1676-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org

This patch changes rq->cmd from the static array to a pointer to
support large commands.

We rarely handle large commands. So for optimization, a struct request
still has a static array for a command. rq_init sets rq->cmd pointer
to the static array.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |    1 +
 drivers/ide/ide-io.c   |    1 +
 include/linux/blkdev.h |   12 ++++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6669238..6f0968f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -132,6 +132,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->errors = 0;
 	rq->ref_count = 1;
 	rq->cmd_len = 0;
+	rq->cmd = rq->__cmd;
 	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->data_len = 0;
 	rq->extra_len = 0;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7153796..bac5ea1 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1595,6 +1595,7 @@ void ide_init_drive_cmd (struct request *rq)
 {
 	memset(rq, 0, sizeof(*rq));
 	rq->ref_count = 1;
+	rq->cmd = rq->__cmd;
 }
 
 EXPORT_SYMBOL(ide_init_drive_cmd);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b3a58ad..5710ae4 100644
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
@@ -812,6 +813,13 @@ static inline void put_dev_sector(Sector p)
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
1.5.4.2

