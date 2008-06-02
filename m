From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 2/6] ide: use the dma safe check for REQ_TYPE_ATA_PC
Date: Mon,  2 Jun 2008 15:57:28 +0900
Message-ID: <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

This uses the dma safe check for REQ_TYPE_ATA_PC. The dma safe check
is used for only sg requests but it should be used for other non fs
commands.

This uses blk_queue_update_dma_pad to make the intention clear though
ide don't use the blk APIs so it doesn't change anything.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index d998471..e3f085c 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1191,10 +1191,15 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
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
 
@@ -1204,7 +1209,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 * NOTE! The "len" and "addr" checks should possibly have
 		 * separate masks.
 		 */
-		if ((rq->data_len & 15) || (addr & mask))
+		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
 	}
 
@@ -1872,6 +1878,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
 	blk_queue_dma_alignment(drive->queue, 31);
+	blk_queue_update_dma_pad(drive->queue, 15);
 	drive->queue->unplug_delay = (1 * HZ) / 1000;
 	if (!drive->queue->unplug_delay)
 		drive->queue->unplug_delay = 1;
-- 
1.5.4.2

