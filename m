From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 6/12] repost: cciss: set sector_size to 2048 for performance
Date: Mon, 6 Nov 2006 14:20:55 -0600
Message-ID: <20061106202055.GF17847@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753486AbWKFUU6@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

PATCH 6/11

This patch changes the blk_queue_max_sectors from 512 to 2048. This helps
increase performance.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

--------------------------------------------------------------------------------
---

 drivers/block/cciss.c |   12 +++++++++---
 drivers/block/cciss.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/block/cciss.c~cciss_sector_size_for_lx2619-rc4 drivers/block/cciss.c
--- linux-2.6/drivers/block/cciss.c~cciss_sector_size_for_lx2619-rc4	2006-11-06 13:27:44.000000000 -0600
+++ linux-2.6-root/drivers/block/cciss.c	2006-11-06 13:27:44.000000000 -0600
@@ -269,6 +269,7 @@ static int cciss_proc_get_info(char *buf
 		       "Firmware Version: %c%c%c%c\n"
 		       "IRQ: %d\n"
 		       "Logical drives: %d\n"
+		       "Sector size: %d\n"
 		       "Current Q depth: %d\n"
 		       "Current # commands on controller: %d\n"
 		       "Max Q depth since init: %d\n"
@@ -279,7 +280,9 @@ static int cciss_proc_get_info(char *buf
 		       (unsigned long)h->board_id,
 		       h->firm_ver[0], h->firm_ver[1], h->firm_ver[2],
 		       h->firm_ver[3], (unsigned int)h->intr[SIMPLE_MODE_INT],
-		       h->num_luns, h->Qdepth, h->commands_outstanding,
+		       h->num_luns,
+		       h->cciss_sector_size,
+		       h->Qdepth, h->commands_outstanding,
 		       h->maxQsinceinit, h->max_outstanding, h->maxSG);
 
 	pos += size;
@@ -1389,7 +1392,7 @@ static void cciss_update_drive_info(int 
 		/* This is a limit in the driver and could be eliminated. */
 		blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
 
-		blk_queue_max_sectors(disk->queue, 512);
+		blk_queue_max_sectors(disk->queue, h->cciss_sector_size);
 
 		blk_queue_softirq_done(disk->queue, cciss_softirq_done);
 
@@ -3341,6 +3344,9 @@ static int __devinit cciss_init_one(stru
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
 
 	cciss_procinit(i);
+
+	hba[i]->cciss_sector_size = 2048;
+
 	hba[i]->busy_initializing = 0;
 
 	for (j = 0; j < NWD; j++) {	/* mfm */
@@ -3365,7 +3371,7 @@ static int __devinit cciss_init_one(stru
 		/* This is a limit in the driver and could be eliminated. */
 		blk_queue_max_phys_segments(q, MAXSGENTRIES);
 
-		blk_queue_max_sectors(q, 512);
+		blk_queue_max_sectors(q, hba[i]->cciss_sector_size);
 
 		blk_queue_softirq_done(q, cciss_softirq_done);
 
diff -puN drivers/block/cciss.h~cciss_sector_size_for_lx2619-rc4 drivers/block/cciss.h
--- linux-2.6/drivers/block/cciss.h~cciss_sector_size_for_lx2619-rc4	2006-11-06 13:27:44.000000000 -0600
+++ linux-2.6-root/drivers/block/cciss.h	2006-11-06 13:27:44.000000000 -0600
@@ -77,6 +77,7 @@ struct ctlr_info 
 	unsigned int intr[4];
 	unsigned int msix_vector;
 	unsigned int msi_vector;
+	int 	cciss_sector_size;
 	BYTE	cciss_read;
 	BYTE	cciss_write;
 	BYTE	cciss_read_capacity;
_
