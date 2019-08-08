From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 1/8] scsi: core: fix the dma_max_mapping_size call
Date: Thu,  8 Aug 2019 11:36:55 +0200
Message-ID: <20190808093702.29512-2-kraxel@redhat.com>
References: <20190808093702.29512-1-kraxel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190808093702.29512-1-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dri-devel@lists.freedesktop.org
Cc: tzimmermann@suse.de, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We should only call dma_max_mapping_size for devices that have a DMA mask
set, otherwise we can run into a NULL pointer dereference that will crash
the system.

Also we need to do right shift to get the sectors from the size in bytes,
not a left shift.

Fixes: bdd17bdef7d8 ("scsi: core: take the DMA max mapping size into account")
Reported-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
(cherry picked from commit 1b5d9a6e98350e0713b4faa1b04e8f239f63b581)
---
 drivers/scsi/scsi_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9381171c2fc0..11e64b50497f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1784,8 +1784,10 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
 	}
 
-	shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-			dma_max_mapping_size(dev) << SECTOR_SHIFT);
+	if (dev->dma_mask) {
+		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
+				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
+	}
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	if (shost->unchecked_isa_dma)
 		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
-- 
2.18.1
