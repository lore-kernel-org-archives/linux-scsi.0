From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] SG: Update ide/ to use sg_table
Date: Thu, 20 Dec 2007 16:06:56 +0200
Message-ID: <476A7700.6080008@panasas.com>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au> <20071220075814.GH13958@kernel.dk> <476A743D.2080506@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:56947 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452AbXLTOIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 09:08:44 -0500
In-Reply-To: <476A743D.2080506@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net

From: Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ide/arm/icside.c      |    6 +++---
 drivers/ide/cris/ide-cris.c   |    2 +-
 drivers/ide/ide-dma.c         |    8 ++++----
 drivers/ide/ide-io.c          |    2 +-
 drivers/ide/ide-probe.c       |    6 +-----
 drivers/ide/ide-taskfile.c    |    2 +-
 drivers/ide/ide.c             |    2 +-
 drivers/ide/mips/au1xxx-ide.c |    8 ++++----
 drivers/ide/pci/sgiioc4.c     |    4 ++--
 drivers/ide/ppc/pmac.c        |    6 +++---
 drivers/scsi/ide-scsi.c       |    2 +-
 include/linux/ide.h           |    2 +-
 12 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 93f71fc..a48a6bd 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -210,7 +210,7 @@ static void icside_build_sglist(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct icside_state *state = hwif->hwif_data;
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table.sgl;
 
 	ide_map_sg(drive, rq);
 
@@ -319,7 +319,7 @@ static int icside_dma_end(ide_drive_t *drive)
 	disable_dma(ECARD_DEV(state->dev)->dma);
 
 	/* Teardown mappings after DMA has completed. */
-	dma_unmap_sg(state->dev, hwif->sg_table, hwif->sg_nents,
+	dma_unmap_sg(state->dev, hwif->sg_table.sgl, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 
 	return get_dma_residue(ECARD_DEV(state->dev)->dma) != 0;
@@ -373,7 +373,7 @@ static int icside_dma_setup(ide_drive_t *drive)
 	 * Tell the DMA engine about the SG table and
 	 * data direction.
 	 */
-	set_dma_sg(ECARD_DEV(state->dev)->dma, hwif->sg_table, hwif->sg_nents);
+	set_dma_sg(ECARD_DEV(state->dev)->dma, hwif->sg_table.sgl, hwif->sg_nents);
 	set_dma_mode(ECARD_DEV(state->dev)->dma, dma_mode);
 
 	drive->waiting_for_dma = 1;
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 476e0d6..3701aca 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -919,7 +919,7 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 	unsigned int count = 0;
 	int i = 0;
 
-	sg = hwif->sg_table;
+	sg = hwif->sg_table.sgl;
 
 	ata_tot_size = 0;
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 4703837..33a2f56 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -190,7 +190,7 @@ static int ide_dma_good_drive(ide_drive_t *drive)
 int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table.sgl;
 
 	BUG_ON((rq->cmd_type == REQ_TYPE_ATA_TASKFILE) && rq->nr_sectors > 256);
 
@@ -234,7 +234,7 @@ int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 	if (!i)
 		return 0;
 
-	sg = hwif->sg_table;
+	sg = hwif->sg_table.sgl;
 	while (i) {
 		u32 cur_addr;
 		u32 cur_len;
@@ -293,7 +293,7 @@ int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 	printk(KERN_ERR "%s: empty DMA table?\n", drive->name);
 use_pio_instead:
 	pci_unmap_sg(hwif->pci_dev,
-		     hwif->sg_table,
+		     hwif->sg_table.sgl,
 		     hwif->sg_nents,
 		     hwif->sg_dma_direction);
 	return 0; /* revert to PIO for this request */
@@ -315,7 +315,7 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
 void ide_destroy_dmatable (ide_drive_t *drive)
 {
 	struct pci_dev *dev = HWIF(drive)->pci_dev;
-	struct scatterlist *sg = HWIF(drive)->sg_table;
+	struct scatterlist *sg = HWIF(drive)->sg_table.sgl;
 	int nents = HWIF(drive)->sg_nents;
 
 	pci_unmap_sg(dev, sg, nents, HWIF(drive)->sg_dma_direction);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index bef781f..638e2db 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -819,7 +819,7 @@ static ide_startstop_t do_special (ide_drive_t *drive)
 void ide_map_sg(ide_drive_t *drive, struct request *rq)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table.sgl;
 
 	if (hwif->sg_mapped)	/* needed by ide-scsi */
 		return;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 2994523..770f8cf 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1312,15 +1312,11 @@ static int hwif_init(ide_hwif_t *hwif)
 	if (!hwif->sg_max_nents)
 		hwif->sg_max_nents = PRD_ENTRIES;
 
-	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
-				 GFP_KERNEL);
-	if (!hwif->sg_table) {
+	if (sg_alloc_table(&hwif->sg_table, hwif->sg_max_nents, GFP_KERNEL)) {
 		printk(KERN_ERR "%s: unable to allocate SG table.\n", hwif->name);
 		goto out;
 	}
 
-	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
-	
 	if (init_irq(hwif) == 0)
 		goto done;
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 2b60f1b..0a898d9 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -246,7 +246,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table.sgl;
 	struct scatterlist *cursg = hwif->cursg;
 	struct page *page;
 #ifdef CONFIG_HIGHMEM
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 54943da..a2ad85a 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -594,7 +594,7 @@ void ide_unregister(unsigned int index)
 	 * Remove us from the kernel's knowledge
 	 */
 	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
-	kfree(hwif->sg_table);
+	sg_free_table(&hwif->sg_table);
 	unregister_blkdev(hwif->major, hwif->name);
 	spin_lock_irq(&ide_lock);
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index a4ce3ba..bccf3c0 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -216,7 +216,7 @@ static int auide_build_sglist(ide_drive_t *drive,  struct request *rq)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	_auide_hwif *ahwif = (_auide_hwif*)hwif->hwif_data;
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table.sgl;
 
 	ide_map_sg(drive, rq);
 
@@ -250,7 +250,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 		return 0;
 
 	/* fill the descriptors */
-	sg = hwif->sg_table;
+	sg = hwif->sg_table.sgl;
 	while (i && sg_dma_len(sg)) {
 		u32 cur_addr;
 		u32 cur_len;
@@ -303,7 +303,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 
  use_pio_instead:
 	dma_unmap_sg(ahwif->dev,
-		     hwif->sg_table,
+		     hwif->sg_table.sgl,
 		     hwif->sg_nents,
 		     hwif->sg_dma_direction);
 
@@ -316,7 +316,7 @@ static int auide_dma_end(ide_drive_t *drive)
 	_auide_hwif *ahwif = (_auide_hwif*)hwif->hwif_data;
 
 	if (hwif->sg_nents) {
-		dma_unmap_sg(ahwif->dev, hwif->sg_table, hwif->sg_nents,
+		dma_unmap_sg(ahwif->dev, hwif->sg_table.sgl, hwif->sg_nents,
 			     hwif->sg_dma_direction);
 		hwif->sg_nents = 0;
 	}
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index de820aa..3ad9e4b 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -487,7 +487,7 @@ sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 	if (!i)
 		return 0;	/* sglist of length Zero */
 
-	sg = hwif->sg_table;
+	sg = hwif->sg_table.sgl;
 	while (i && sg_dma_len(sg)) {
 		dma_addr_t cur_addr;
 		int cur_len;
@@ -535,7 +535,7 @@ sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 	}
 
 use_pio_instead:
-	pci_unmap_sg(hwif->pci_dev, hwif->sg_table, hwif->sg_nents,
+	pci_unmap_sg(hwif->pci_dev, hwif->sg_table.sgl, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 
 	return 0;		/* revert to PIO for this request */
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 7f7a598..b982180 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1503,7 +1503,7 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 		return 0;
 
 	/* Build DBDMA commands list */
-	sg = hwif->sg_table;
+	sg = hwif->sg_table.sgl;
 	while (i && sg_dma_len(sg)) {
 		u32 cur_addr;
 		u32 cur_len;
@@ -1555,7 +1555,7 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 	printk(KERN_DEBUG "%s: empty DMA table?\n", drive->name);
  use_pio_instead:
 	pci_unmap_sg(hwif->pci_dev,
-		     hwif->sg_table,
+		     hwif->sg_table.sgl,
 		     hwif->sg_nents,
 		     hwif->sg_dma_direction);
 	return 0; /* revert to PIO for this request */
@@ -1567,7 +1567,7 @@ pmac_ide_destroy_dmatable (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = HWIF(drive)->pci_dev;
-	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *sg = hwif->sg_table.sgl;
 	int nents = hwif->sg_nents;
 
 	if (nents) {
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 9706de9..762bd93 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -553,7 +553,7 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
 	if (idescsi_set_direction(pc))
 		return 1;
 
-	sg = hwif->sg_table;
+	sg = hwif->sg_table.sgl;
 	scsi_sg = scsi_sglist(pc->scsi_cmd);
 	segments = scsi_sg_count(pc->scsi_cmd);
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 9a6a41e..80ff2ee 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -750,7 +750,7 @@ typedef struct hwif_s {
 	/* dma physical region descriptor table (dma view) */
 	dma_addr_t	dmatable_dma;
 	/* Scatter-gather list used to build the above */
-	struct scatterlist *sg_table;
+	struct sg_table sg_table;
 	int sg_max_nents;		/* Maximum number of entries in it */
 	int sg_nents;			/* Current number of entries in it */
 	int sg_dma_direction;		/* dma transfer direction */
-- 
1.5.3.3


