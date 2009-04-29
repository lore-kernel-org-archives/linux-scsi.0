From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] ide: convert to rq pos and nr_sectors accessors
Date: Wed, 29 Apr 2009 18:13:44 +0900
Message-ID: <1240996428-10159-7-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbZD2JUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 05:20:31 -0400
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>

ide doesn't manipulate request fields anymore and thus all hard and
their soft equivalents are always equal.  Convert all references to
accessors.

[ Impact: use pos and nr_sectors accessors ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/ide/ide-cd.c       |    8 ++++----
 drivers/ide/ide-disk.c     |    8 ++++----
 drivers/ide/ide-dma.c      |    2 +-
 drivers/ide/ide-floppy.c   |    6 +++---
 drivers/ide/ide-io.c       |    4 ++--
 drivers/ide/ide-lib.c      |    2 +-
 drivers/ide/ide-tape.c     |    6 +++---
 drivers/ide/ide-taskfile.c |    2 +-
 drivers/ide/pdc202xx_old.c |    2 +-
 drivers/ide/tc86c001.c     |    2 +-
 drivers/ide/tx4939ide.c    |    2 +-
 11 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 182320d..eb4f3dc 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -775,8 +775,8 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	}
 
 	/* fs requests *must* be hardware frame aligned */
-	if ((rq->nr_sectors & (sectors_per_frame - 1)) ||
-	    (rq->sector & (sectors_per_frame - 1)))
+	if ((blk_rq_sectors(rq) & (sectors_per_frame - 1)) ||
+	    (blk_rq_pos(rq) & (sectors_per_frame - 1)))
 		return ide_stopped;
 
 	/* use DMA, if possible */
@@ -868,8 +868,8 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	cmd.rq = rq;
 
 	if (blk_fs_request(rq) || rq->data_len) {
-		ide_init_sg_cmd(&cmd, blk_fs_request(rq) ? (rq->nr_sectors << 9)
-							 : rq->data_len);
+		ide_init_sg_cmd(&cmd, blk_fs_request(rq) ?
+				(blk_rq_sectors(rq) << 9) : rq->data_len);
 		ide_map_sg(drive, &cmd);
 	}
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index c243880..ad18e14 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -82,7 +82,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 					sector_t block)
 {
 	ide_hwif_t *hwif	= drive->hwif;
-	u16 nsectors		= (u16)rq->nr_sectors;
+	u16 nsectors		= (u16)blk_rq_sectors(rq);
 	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
 	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
 	struct ide_cmd		cmd;
@@ -90,7 +90,7 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	ide_startstop_t		rc;
 
 	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
-		if (block + rq->nr_sectors > 1ULL << 28)
+		if (block + blk_rq_sectors(rq) > 1ULL << 28)
 			dma = 0;
 		else
 			lba48 = 0;
@@ -195,9 +195,9 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 
 	ledtrig_ide_activity();
 
-	pr_debug("%s: %sing: block=%llu, sectors=%lu, buffer=0x%08lx\n",
+	pr_debug("%s: %sing: block=%llu, sectors=%u, buffer=0x%08lx\n",
 		 drive->name, rq_data_dir(rq) == READ ? "read" : "writ",
-		 (unsigned long long)block, rq->nr_sectors,
+		 (unsigned long long)block, blk_rq_sectors(rq),
 		 (unsigned long)rq->buffer);
 
 	if (hwif->rw_disk)
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index d9123ec..001f68f 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -103,7 +103,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 				ide_finish_cmd(drive, cmd, stat);
 			else
 				ide_complete_rq(drive, 0,
-						cmd->rq->nr_sectors << 9);
+						blk_rq_sectors(cmd->rq) << 9);
 			return ide_stopped;
 		}
 		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 537b7c5..1c460bd 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -194,7 +194,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	int block = sector / floppy->bs_factor;
-	int blocks = rq->nr_sectors / floppy->bs_factor;
+	int blocks = blk_rq_sectors(rq) / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
 
 	ide_debug_log(IDE_DBG_FUNC, "block: %d, blocks: %d", block, blocks);
@@ -259,8 +259,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 			goto out_end;
 	}
 	if (blk_fs_request(rq)) {
-		if (((long)rq->sector % floppy->bs_factor) ||
-		    (rq->nr_sectors % floppy->bs_factor)) {
+		if (((long)blk_rq_pos(rq) % floppy->bs_factor) ||
+		    (blk_rq_sectors(rq) % floppy->bs_factor)) {
 			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
 				drive->name);
 			goto out_end;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index df23bcb..59799ca 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -279,7 +279,7 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 
 	if (cmd) {
 		if (cmd->protocol == ATA_PROT_PIO) {
-			ide_init_sg_cmd(cmd, rq->nr_sectors << 9);
+			ide_init_sg_cmd(cmd, blk_rq_sectors(rq) << 9);
 			ide_map_sg(drive, cmd);
 		}
 
@@ -387,7 +387,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 
 		drv = *(struct ide_driver **)rq->rq_disk->private_data;
 
-		return drv->do_request(drive, rq, rq->sector);
+		return drv->do_request(drive, rq, blk_rq_pos(rq));
 	}
 	return do_special(drive);
 kill_rq:
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 56ff8c4..05b7fbc 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -114,7 +114,7 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 
 		if (rq)
 			printk(KERN_CONT ", sector=%llu",
-			       (unsigned long long)rq->sector);
+			       (unsigned long long)blk_rq_pos(rq));
 	}
 	printk(KERN_CONT "\n");
 }
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3813a0e..e166045 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -586,7 +586,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 				   struct ide_atapi_pc *pc, struct request *rq,
 				   u8 opcode)
 {
-	unsigned int length = rq->nr_sectors;
+	unsigned int length = blk_rq_sectors(rq);
 
 	ide_init_pc(pc);
 	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
@@ -617,8 +617,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct ide_cmd cmd;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu\n"
-		  (unsigned long long)rq->sector, rq->nr_sectors);
+	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
+		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
 
 	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
 		/* We do not support buffer cache originated requests. */
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index f400eb4..a0c3e1b 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -385,7 +385,7 @@ out_end:
 	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
 		ide_finish_cmd(drive, cmd, stat);
 	else
-		ide_complete_rq(drive, 0, cmd->rq->nr_sectors << 9);
+		ide_complete_rq(drive, 0, blk_rq_sectors(cmd->rq) << 9);
 	return ide_stopped;
 out_err:
 	ide_error_cmd(drive, cmd);
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 248a54b..c2a16a8 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -177,7 +177,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 		u8 clock = inb(high_16 + 0x11);
 
 		outb(clock | (hwif->channel ? 0x08 : 0x02), high_16 + 0x11);
-		word_count = (rq->nr_sectors << 8);
+		word_count = (blk_rq_sectors(rq) << 8);
 		word_count = (rq_data_dir(rq) == READ) ?
 					word_count | 0x05000000 :
 					word_count | 0x06000000;
diff --git a/drivers/ide/tc86c001.c b/drivers/ide/tc86c001.c
index b4cf42d..05a93d6 100644
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -112,7 +112,7 @@ static void tc86c001_dma_start(ide_drive_t *drive)
 	ide_hwif_t *hwif	= drive->hwif;
 	unsigned long sc_base	= hwif->config_data;
 	unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
-	unsigned long nsectors	= hwif->rq->nr_sectors;
+	unsigned long nsectors	= blk_rq_sectors(hwif->rq);
 
 	/*
 	 * We have to manually load the sector count and size into
diff --git a/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
index 564422d..5ca7622 100644
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -307,7 +307,7 @@ static int tx4939ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 	tx4939ide_writew(SECTOR_SIZE / 2, base, drive->dn ?
 			 TX4939IDE_Xfer_Cnt_2 : TX4939IDE_Xfer_Cnt_1);
 
-	tx4939ide_writew(cmd->rq->nr_sectors, base, TX4939IDE_Sec_Cnt);
+	tx4939ide_writew(blk_rq_sectors(cmd->rq), base, TX4939IDE_Sec_Cnt);
 
 	return 0;
 }
-- 
1.6.0.2

