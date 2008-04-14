From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] block: no need to initialize rq->cmd in prepare_flush_fn hook
Date: Mon, 14 Apr 2008 19:50:34 +0900
Message-ID: <1208170266-1676-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080414010112W.tomof@acm.org>
 <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:56868 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbYDNLG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 07:06:26 -0400
In-Reply-To: <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bharrosh@panasas.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

The block layer initializes rq->cmd (queue_flush calls rq_init) so
prepare_flush_fn hooks don't need to do that.

This is a preparation for changing rq->cmd from the static array to a
pointer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/ps3disk.c |    1 -
 drivers/scsi/sd.c       |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 7483f94..9c32b75 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -406,7 +406,6 @@ static void ps3disk_prepare_flush(struct request_queue *q, struct request *req)
 
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
-	memset(req->cmd, 0, sizeof(req->cmd));
 	req->cmd_type = REQ_TYPE_FLUSH;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5fe7aae..338566a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -850,7 +850,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
-	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
-- 
1.5.4.2

