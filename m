From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 4/6] ide: avoid DMA on the stack for REQ_TYPE_ATA_PC
Date: Mon,  2 Jun 2008 15:57:30 +0900
Message-ID: <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, petkovbb@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
leads to memory corruption on a non-coherent platform.

With regard to alignment and padding, ide-cd has the the dma safe
check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buffer
check to that check.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e3f085c..e12d602 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1195,6 +1195,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
 		unsigned long addr;
+		unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 		if (rq->bio)
 			addr = (unsigned long)bio_data(rq->bio);
@@ -1212,6 +1213,10 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 		if (addr & alignment || rq->data_len & alignment)
 			info->dma = 0;
+
+		if (!((addr & stack_mask) ^
+		      ((unsigned long)current->stack & stack_mask)))
+			info->dma = 0;
 	}
 
 	/* start sending the command to the drive */
-- 
1.5.4.2

