From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] Fix uses of dma_max_pfn() when converting to a limiting
 address
Date: Tue, 11 Feb 2014 17:28:07 +0000
Message-ID: <E1WDH7v-00038J-2k@rmk-PC.arm.linux.org.uk>
Return-path: <linux-mmc-owner@vger.kernel.org>
Sender: linux-mmc-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Chris Ball <chris@printf.net>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>
List-Id: linux-scsi@vger.kernel.org

We must use a 64-bit for this, otherwise overflowed bits get lost, and
that can result in a lower than intended value set.

Fixes: 8e0cb8a1f6ac ("ARM: 7797/1: mmc: Use dma_max_pfn(dev) helper for bounce_limit calculations")
Fixes: 7d35496dd982 ("ARM: 7796/1: scsi: Use dma_max_pfn(dev) helper for bounce_limit calculations")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
While poking about with the Cubox-i4 and investigating why my UHS-1
SD card wasn't achieving its full potential, I came across a slight
problem... the SDHCI host sets a mask of 0xffffffff, but with the
start of memory at pfn 0x10000, the blk code sees this when setting
the bounce limit:

	max addr 0x0ffff000 bounce limit 0xffff dma 1

and this results in the bounce functions appearing in the profile:

00000000c00f8b70 copy_to_high_bio_irq                  1139 2.5886
00000000c00f8d28 bounce_end_io                           12 0.0714
00000000c00f8dd0 bounce_end_io_read_isa                   8 0.1053

which, compared to the cost of copying the data to userland and
request handling, this is quite significant:

00000000c04b1794 sdhci_request                          268 0.5447
00000000c02d0740 __copy_to_user_std                     398 0.4252

With this calculation fixed, we avoid the bouncing code entirely.

	max addr 0x10ffff000 bounce limit 0x10ffff dma 0

 drivers/mmc/card/queue.c | 2 +-
 drivers/scsi/scsi_lib.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 357bbc54fe4b..3e049c13429c 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -197,7 +197,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
-		limit = dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
+		limit = (u64)dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
 
 	mq->card = card;
 	mq->queue = blk_init_queue(mmc_request_fn, lock);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d5f050..62ec84b42e31 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1684,7 +1684,7 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 
 	host_dev = scsi_get_device(shost);
 	if (host_dev && host_dev->dma_mask)
-		bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
+		bounce_limit = (u64)dma_max_pfn(host_dev) << PAGE_SHIFT;
 
 	return bounce_limit;
 }
-- 
1.8.3.1

