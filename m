From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] ide: cleanup rq->data_len usages
Date: Wed, 29 Apr 2009 18:13:47 +0900
Message-ID: <1240996428-10159-10-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZD2JS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 05:18:28 -0400
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>

With recent unification of fields, it's now guaranteed that
rq->data_len always equals blk_rq_bytes().  Convert all direct users
to accessors.

[ Impact: convert direct rq->data_len usages to blk_rq_bytes() ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/ide/ide-atapi.c  |    4 ++--
 drivers/ide/ide-cd.c     |   25 +++++++------------------
 drivers/ide/ide-floppy.c |    4 ++--
 drivers/ide/ide-io.c     |    2 +-
 4 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e4a02a0..792534d 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -255,7 +255,7 @@ void ide_retry_pc(ide_drive_t *drive)
 	ide_init_pc(pc);
 	memcpy(pc->c, sense_rq->cmd, 12);
 	pc->buf = bio_data(sense_rq->bio);	/* pointer to mapped address */
-	pc->req_xfer = sense_rq->data_len;
+	pc->req_xfer = blk_rq_bytes(sense_rq);
 
 	if (drive->media == ide_tape)
 		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
@@ -303,7 +303,7 @@ int ide_cd_get_xferlen(struct request *rq)
 		return 32768;
 	else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 			 rq->cmd_type == REQ_TYPE_ATA_PC)
-		return rq->data_len;
+		return blk_rq_bytes(rq);
 	else
 		return 0;
 }
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index eb4f3dc..2eadc9d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -577,7 +577,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0, nsectors;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
@@ -707,9 +707,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 out_end:
 	if (blk_pc_request(rq) && rc == 0) {
-		if (blk_end_request(rq, 0, rq->data_len))
-			BUG();
-
+		blk_end_request_all(rq, 0);
 		hwif->rq = NULL;
 	} else {
 		if (sense && uptodate)
@@ -727,22 +725,14 @@ out_end:
 			ide_cd_error_cmd(drive, cmd);
 
 		/* make sure it's fully ended */
-		if (blk_pc_request(rq))
-			nsectors = (rq->data_len + 511) >> 9;
-		else
-			nsectors = blk_rq_sectors(rq);
-
-		if (nsectors == 0)
-			nsectors = 1;
-
 		if (blk_fs_request(rq) == 0) {
-			rq->resid_len = rq->data_len -
+			rq->resid_len = blk_rq_bytes(rq) -
 				(cmd->nbytes - cmd->nleft);
 			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
 				rq->resid_len += cmd->last_xfer_len;
 		}
 
-		ide_complete_rq(drive, uptodate ? 0 : -EIO, nsectors << 9);
+		ide_complete_rq(drive, uptodate ? 0 : -EIO, blk_rq_bytes(rq));
 
 		if (sense && rc == 2)
 			ide_error(drive, "request sense failure", stat);
@@ -819,7 +809,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 		 */
 		alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 		if ((unsigned long)buf & alignment
-		    || rq->data_len & q->dma_pad_mask
+		    || blk_rq_bytes(rq) & q->dma_pad_mask
 		    || object_is_on_stack(buf))
 			drive->dma = 0;
 	}
@@ -867,9 +857,8 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	cmd.rq = rq;
 
-	if (blk_fs_request(rq) || rq->data_len) {
-		ide_init_sg_cmd(&cmd, blk_fs_request(rq) ?
-				(blk_rq_sectors(rq) << 9) : rq->data_len);
+	if (blk_fs_request(rq) || blk_rq_bytes(rq)) {
+		ide_init_sg_cmd(&cmd, blk_rq_bytes(rq));
 		ide_map_sg(drive, &cmd);
 	}
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 1c460bd..6509817 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -220,14 +220,14 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 	ide_init_pc(pc);
 	memcpy(pc->c, rq->cmd, sizeof(pc->c));
 	pc->rq = rq;
-	if (rq->data_len) {
+	if (blk_rq_bytes(rq)) {
 		pc->flags |= PC_FLAG_DMA_OK;
 		if (rq_data_dir(rq) == WRITE)
 			pc->flags |= PC_FLAG_WRITING;
 	}
 	/* pio will be performed by ide_pio_bytes() which handles sg fine */
 	pc->buf = NULL;
-	pc->req_xfer = pc->buf_size = rq->data_len;
+	pc->req_xfer = pc->buf_size = blk_rq_bytes(rq);
 }
 
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 59799ca..ca2519d 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -116,7 +116,7 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 unsigned int ide_rq_bytes(struct request *rq)
 {
 	if (blk_pc_request(rq))
-		return rq->data_len;
+		return blk_rq_bytes(rq);
 	else
 		return blk_rq_cur_sectors(rq) << 9;
 }
-- 
1.6.0.2

