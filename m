From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 33/33] IDE: sg chaining support
Date: Mon, 16 Jul 2007 11:47:47 +0200
Message-ID: <11845792694102-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9343 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761580AbXGPJsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:39 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, bzolnier@gmail.com

Cc: bzolnier@gmail.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ide/cris/ide-cris.c   |    3 ++-
 drivers/ide/ide-dma.c         |    2 +-
 drivers/ide/ide-io.c          |    3 ++-
 drivers/ide/ide-probe.c       |    2 +-
 drivers/ide/ide-taskfile.c    |   17 +++++++++++++----
 drivers/ide/mips/au1xxx-ide.c |    2 +-
 drivers/ide/pci/sgiioc4.c     |    2 +-
 drivers/ide/ppc/pmac.c        |    2 +-
 include/linux/ide.h           |    2 +-
 9 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 886091b..e1b2d01 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -951,7 +951,8 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 		/* group sequential buffers into one large buffer */
 		addr = page_to_phys(sg->page) + sg->offset;
 		size = sg_dma_len(sg);
-		while (sg++, --i) {
+		while (--i) {
+			sg = sg_next(sg);
 			if ((addr + size) != page_to_phys(sg->page) + sg->offset)
 				break;
 			size += sg_dma_len(sg);
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 5fe1d72..a9a18a1 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -294,7 +294,7 @@ int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
 			}
 		}
 
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c5b5011..2465c24 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -836,7 +836,8 @@ void ide_init_sg_cmd(ide_drive_t *drive, struct request *rq)
 	ide_hwif_t *hwif = drive->hwif;
 
 	hwif->nsect = hwif->nleft = rq->nr_sectors;
-	hwif->cursg = hwif->cursg_ofs = 0;
+	hwif->cursg_ofs = 0;
+	hwif->cursg = NULL;
 }
 
 EXPORT_SYMBOL_GPL(ide_init_sg_cmd);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index cc58013..111ec02 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1352,7 +1352,7 @@ static int hwif_init(ide_hwif_t *hwif)
 	if (!hwif->sg_max_nents)
 		hwif->sg_max_nents = PRD_ENTRIES;
 
-	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
+	hwif->sg_table = kzalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
 				 GFP_KERNEL);
 	if (!hwif->sg_table) {
 		printk(KERN_ERR "%s: unable to allocate SG table.\n", hwif->name);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index aa06daf..3c92790 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -263,6 +263,7 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
+	struct scatterlist *cursg = hwif->cursg;
 	struct page *page;
 #ifdef CONFIG_HIGHMEM
 	unsigned long flags;
@@ -270,8 +271,14 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 	unsigned int offset;
 	u8 *buf;
 
-	page = sg[hwif->cursg].page;
-	offset = sg[hwif->cursg].offset + hwif->cursg_ofs * SECTOR_SIZE;
+	cursg = hwif->cursg;
+	if (!cursg) {
+		cursg = sg;
+		hwif->cursg = sg;
+	}
+
+	page = cursg->page;
+	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -285,8 +292,8 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 	hwif->nleft--;
 	hwif->cursg_ofs++;
 
-	if ((hwif->cursg_ofs * SECTOR_SIZE) == sg[hwif->cursg].length) {
-		hwif->cursg++;
+	if ((hwif->cursg_ofs * SECTOR_SIZE) == cursg->length) {
+		hwif->cursg = sg_next(hwif->cursg);
 		hwif->cursg_ofs = 0;
 	}
 
@@ -367,6 +374,8 @@ static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
 
 static void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
+	HWIF(drive)->cursg = NULL;
+
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = rq->special;
 
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 2e7013a..48cfb62 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -324,7 +324,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 			cur_addr += tc;
 			cur_len -= tc;
 		}
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index d396b29..9e36b29 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -531,7 +531,7 @@ sgiioc4_build_dma_table(ide_drive_t * drive, struct request *rq, int ddir)
 			}
 		}
 
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index e46f472..9f78c6a 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1648,7 +1648,7 @@ pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 			cur_len -= tc;
 			++table;
 		}
-		sg++;
+		sg = sg_next(sg);
 		i--;
 	}
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 19ab258..1e6639e 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -767,7 +767,7 @@ typedef struct hwif_s {
 
 	unsigned int nsect;
 	unsigned int nleft;
-	unsigned int cursg;
+	struct scatterlist *cursg;
 	unsigned int cursg_ofs;
 
 	int		rqsize;		/* max sectors per request */
-- 
1.5.3.rc0.90.gbaa79

