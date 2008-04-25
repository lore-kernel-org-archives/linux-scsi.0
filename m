From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/6] block: no need to initialize rq->cmd in
 prepare_flush_fn hook
Date: Sat, 26 Apr 2008 01:40:08 +0900
Message-ID: <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34196 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363AbYDYQmx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:42:53 -0400
In-Reply-To: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org, bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

The block layer initializes rq->cmd (queue_flush calls rq_init) so
prepare_flush_fn hooks don't need to do that.

The purpose of this patch is to remove sizeof(rq->cmd), as a
preparation for large command support, which changes rq->cmd from the
static array to a pointer. sizeof(rq->cmd) will not make sense.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/ps3disk.c |    1 -
 drivers/scsi/sd.c       |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 78e9ea7..d797e20 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -405,7 +405,6 @@ static void ps3disk_prepare_flush(struct request_queue *q, struct request *req)
 
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
-	memset(req->cmd, 0, sizeof(req->cmd));
 	req->cmd_type = REQ_TYPE_FLUSH;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3cea17d..01cefbb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -860,7 +860,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
-	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
-- 
1.5.4.2
