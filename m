From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/4] ide: use the dma safe check for REQ_TYPE_ATA_PC
Date: Tue, 20 May 2008 13:58:33 +0900
Message-ID: <1211259514-9131-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1211259514-9131-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1211259514-9131-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

This uses the dma safe check for REQ_TYPE_ATA_PC. The dma safe check
is used for only sg requests but it should be used for other non fs
commands.

This uses blk_queue_update_dma_pad to make the intention clear though
ide don't use the blk APIs so it doesn't change anything.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 68e7f19..1d8d510 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1178,10 +1178,15 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	info->dma = 0;
 
 	/* sg request */
-	if (rq->bio) {
-		int mask = drive->queue->dma_alignment;
-		unsigned long addr =
-			(unsigned long)page_address(bio_page(rq->bio));
+	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
+		struct request_queue *q = drive->queue;
+		unsigned int alignment;
+		unsigned long addr;
+
+		if (rq->bio)
+			addr = (unsigned long)bio_data(rq->bio);
+		else
+			addr = (unsigned long)rq->data;
 
 		info->dma = drive->using_dma;
 
@@ -1191,7 +1196,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 * NOTE! The "len" and "addr" checks should possibly have
 		 * separate masks.
 		 */
-		if ((rq->data_len & 15) || (addr & mask))
+		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
 	}
 
@@ -1869,6 +1875,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
+	blk_queue_update_dma_pad(drive->queue, 15);
 	drive->queue->unplug_delay = (1 * HZ) / 1000;
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
-- 
1.5.4.2

