From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] block: move REQ_TYPE_SENSE to the ide driver
Date: Fri, 17 Apr 2015 22:37:18 +0200
Message-ID: <1429303042-12078-4-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbDQUi0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:26 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-atapi.c  | 6 +++---
 drivers/ide/ide-cd.c     | 8 ++++----
 drivers/ide/ide-floppy.c | 2 +-
 drivers/ide/ide-tape.c   | 2 +-
 include/linux/blkdev.h   | 1 -
 include/linux/ide.h      | 1 +
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index b367300..1362ad8 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -191,7 +191,7 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 
 	BUG_ON(sense_len > sizeof(*sense));
 
-	if (rq->cmd_type == REQ_TYPE_SENSE || drive->sense_rq_armed)
+	if (rq->cmd_type == REQ_TYPE_ATA_SENSE || drive->sense_rq_armed)
 		return;
 
 	memset(sense, 0, sizeof(*sense));
@@ -210,7 +210,7 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	sense_rq->rq_disk = rq->rq_disk;
 	sense_rq->cmd[0] = GPCMD_REQUEST_SENSE;
 	sense_rq->cmd[4] = cmd_len;
-	sense_rq->cmd_type = REQ_TYPE_SENSE;
+	sense_rq->cmd_type = REQ_TYPE_ATA_SENSE;
 	sense_rq->cmd_flags |= REQ_PREEMPT;
 
 	if (drive->media == ide_tape)
@@ -310,7 +310,7 @@ int ide_cd_get_xferlen(struct request *rq)
 	switch (rq->cmd_type) {
 	case REQ_TYPE_FS:
 		return 32768;
-	case REQ_TYPE_SENSE:
+	case REQ_TYPE_ATA_SENSE:
 	case REQ_TYPE_BLOCK_PC:
 	case REQ_TYPE_ATA_PC:
 		return blk_rq_bytes(rq);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9a32603..64a6b82 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -210,7 +210,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 {
 	/*
-	 * For REQ_TYPE_SENSE, "rq->special" points to the original
+	 * For REQ_TYPE_ATA_SENSE, "rq->special" points to the original
 	 * failed request.  Also, the sense data should be read
 	 * directly from rq which might be different from the original
 	 * sense buffer if it got copied during mapping.
@@ -285,7 +285,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 				  "stat 0x%x",
 				  rq->cmd[0], rq->cmd_type, err, stat);
 
-	if (rq->cmd_type == REQ_TYPE_SENSE) {
+	if (rq->cmd_type == REQ_TYPE_ATA_SENSE) {
 		/*
 		 * We got an error trying to get sense info from the drive
 		 * (probably while trying to recover from a former error).
@@ -526,7 +526,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0;
-	int sense = (rq->cmd_type == REQ_TYPE_SENSE);
+	int sense = (rq->cmd_type == REQ_TYPE_ATA_SENSE);
 	unsigned int timeout;
 	u16 len;
 	u8 ireason, stat;
@@ -791,7 +791,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
 			goto out_end;
 		break;
-	case REQ_TYPE_SENSE:
+	case REQ_TYPE_ATA_SENSE:
 	case REQ_TYPE_BLOCK_PC:
 	case REQ_TYPE_ATA_PC:
 		if (!rq->timeout)
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3dbfa5b..2fb5350 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -266,7 +266,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
 		break;
 	case REQ_TYPE_DRV_PRIV:
-	case REQ_TYPE_SENSE:
+	case REQ_TYPE_ATA_SENSE:
 		pc = (struct ide_atapi_pc *)rq->special;
 		break;
 	case REQ_TYPE_BLOCK_PC:
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2a5d543..f5d51d1 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -577,7 +577,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		      blk_rq_sectors(rq));
 
 	BUG_ON(!(rq->cmd_type == REQ_TYPE_DRV_PRIV ||
-		 rq->cmd_type == REQ_TYPE_SENSE));
+		 rq->cmd_type == REQ_TYPE_ATA_SENSE));
 
 	/* Retry a failed packet command */
 	if (drive->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9cb4d80..6076b9e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -75,7 +75,6 @@ struct request_list {
 enum rq_cmd_type_bits {
 	REQ_TYPE_FS		= 1,	/* fs request */
 	REQ_TYPE_BLOCK_PC,		/* scsi command */
-	REQ_TYPE_SENSE,			/* sense request */
 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
 	REQ_TYPE_PM_RESUME,		/* resume request */
 	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 62ac399..9856b7d 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -43,6 +43,7 @@ struct device;
 enum ata_cmd_type_bits {
 	REQ_TYPE_ATA_TASKFILE = REQ_TYPE_DRV_PRIV + 1,
 	REQ_TYPE_ATA_PC,
+	REQ_TYPE_ATA_SENSE,	/* sense request */
 };
 
 /* Error codes returned in rq->errors to the higher part of the driver. */
-- 
1.9.1

