From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] ide: don't abuse cmd_type
Date: Tue, 31 Jan 2017 16:57:30 +0100
Message-ID: <1485878251-6107-10-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently the legacy ide driver defines several request types of it's own,
which is in the way of removing that field entirely.

Instead add a type field to struct ide_request and use that to distinguish
the different types of IDE-internal requests.

It's a bit of a mess, but so is the surrounding code..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-atapi.c    | 18 ++++++++++-----
 drivers/ide/ide-cd.c       | 25 ++++++++++++---------
 drivers/ide/ide-cd_ioctl.c |  1 +
 drivers/ide/ide-devsets.c  |  1 +
 drivers/ide/ide-disk.c     |  6 +++--
 drivers/ide/ide-eh.c       |  4 ++--
 drivers/ide/ide-floppy.c   | 18 ++++++++++-----
 drivers/ide/ide-io.c       |  8 +++----
 drivers/ide/ide-ioctls.c   |  4 +++-
 drivers/ide/ide-park.c     |  2 ++
 drivers/ide/ide-pm.c       | 16 ++++++++-----
 drivers/ide/ide-tape.c     |  6 +++--
 drivers/ide/ide-taskfile.c |  3 ++-
 include/linux/ide.h        | 56 +++++++++++++++++++++++++++++++++++++---------
 14 files changed, 117 insertions(+), 51 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7c826ec..a8c650e 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -95,6 +95,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->special = (char *)pc;
 
 	if (buf && bufflen) {
@@ -193,7 +194,7 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 
 	BUG_ON(sense_len > sizeof(*sense));
 
-	if (rq->cmd_type == REQ_TYPE_ATA_SENSE || drive->sense_rq_armed)
+	if (ata_sense_request(rq) || drive->sense_rq_armed)
 		return;
 
 	memset(sense, 0, sizeof(*sense));
@@ -211,7 +212,8 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	}
 
 	sense_rq->rq_disk = rq->rq_disk;
-	sense_rq->cmd_type = REQ_TYPE_ATA_SENSE;
+	sense_rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
 	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
@@ -313,10 +315,14 @@ int ide_cd_get_xferlen(struct request *rq)
 	switch (rq->cmd_type) {
 	case REQ_TYPE_FS:
 		return 32768;
-	case REQ_TYPE_ATA_SENSE:
 	case REQ_TYPE_BLOCK_PC:
-	case REQ_TYPE_ATA_PC:
 		return blk_rq_bytes(rq);
+	case REQ_TYPE_DRV_PRIV:
+		switch (ide_req(rq)->type) {
+		case ATA_PRIV_PC:
+		case ATA_PRIV_SENSE:
+			return blk_rq_bytes(rq);
+		}
 	default:
 		return 0;
 	}
@@ -377,7 +383,7 @@ int ide_check_ireason(ide_drive_t *drive, struct request *rq, int len,
 				drive->name, __func__, ireason);
 	}
 
-	if (dev_is_idecd(drive) && rq->cmd_type == REQ_TYPE_ATA_PC)
+	if (dev_is_idecd(drive) && ata_pc_request(rq))
 		rq->rq_flags |= RQF_FAILED;
 
 	return 1;
@@ -480,7 +486,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		if (uptodate == 0)
 			drive->failed_pc = NULL;
 
-		if (rq->cmd_type == REQ_TYPE_DRV_PRIV) {
+		if (ata_misc_request(rq)) {
 			rq->errors = 0;
 			error = 0;
 		} else {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6eb9872..207af78 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -210,7 +210,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 {
 	/*
-	 * For REQ_TYPE_ATA_SENSE, "rq->special" points to the original
+	 * For ATA_PRIV_SENSE, "rq->special" points to the original
 	 * failed request.  Also, the sense data should be read
 	 * directly from rq which might be different from the original
 	 * sense buffer if it got copied during mapping.
@@ -282,7 +282,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 				  "stat 0x%x",
 				  rq->cmd[0], rq->cmd_type, err, stat);
 
-	if (rq->cmd_type == REQ_TYPE_ATA_SENSE) {
+	if (ata_sense_request(rq)) {
 		/*
 		 * We got an error trying to get sense info from the drive
 		 * (probably while trying to recover from a former error).
@@ -438,7 +438,8 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		rq = blk_get_request(drive->queue, write, __GFP_RECLAIM);
 		scsi_req_init(rq);
 		memcpy(scsi_req(rq)->cmd, cmd, BLK_MAX_CDB);
-		rq->cmd_type = REQ_TYPE_ATA_PC;
+		rq->cmd_type = REQ_TYPE_DRV_PRIV;
+		ide_req(rq)->type = ATA_PRIV_PC;
 		rq->rq_flags |= rq_flags;
 		rq->timeout = timeout;
 		if (buffer) {
@@ -520,7 +521,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0;
-	int sense = (rq->cmd_type == REQ_TYPE_ATA_SENSE);
+	int sense = ata_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
 	u8 ireason, stat;
@@ -785,18 +786,22 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
 			goto out_end;
 		break;
-	case REQ_TYPE_ATA_SENSE:
 	case REQ_TYPE_BLOCK_PC:
-	case REQ_TYPE_ATA_PC:
+	handle_pc:
 		if (!rq->timeout)
 			rq->timeout = ATAPI_WAIT_PC;
-
 		cdrom_do_block_pc(drive, rq);
 		break;
 	case REQ_TYPE_DRV_PRIV:
-		/* right now this can only be a reset... */
-		uptodate = 1;
-		goto out_end;
+		switch (ide_req(rq)->type) {
+		case ATA_PRIV_MISC:
+			/* right now this can only be a reset... */
+			uptodate = 1;
+			goto out_end;
+		case ATA_PRIV_SENSE:
+		case ATA_PRIV_PC:
+			goto handle_pc;
+		}
 	default:
 		BUG();
 	}
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index da0aa01..3f03eed 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -306,6 +306,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->rq_flags = RQF_QUIET;
 	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
 	blk_put_request(rq);
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index fd56c9d..c040b9d 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -168,6 +168,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	rq = blk_get_request(q, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd_len = 5;
 	scsi_req(rq)->cmd[0] = REQ_DEVSET_EXEC;
 	*(int *)&scsi_req(rq)->cmd[1] = arg;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 3437c5b..69cf717 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -453,7 +453,8 @@ static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
 	cmd->tf_flags = IDE_TFLAG_DYN;
 	cmd->protocol = ATA_PROT_NODATA;
 
-	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_TASKFILE;
 	rq->special = cmd;
 	cmd->rq = rq;
 
@@ -479,7 +480,8 @@ static int set_multcount(ide_drive_t *drive, int arg)
 
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_TASKFILE;
 
 	drive->mult_req = arg;
 	drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 35e5b89..1e4b147 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -124,7 +124,7 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 
 	/* retry only "normal" I/O: */
 	if (rq->cmd_type != REQ_TYPE_FS) {
-		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+		if (ata_taskfile_request(rq)) {
 			struct ide_cmd *cmd = rq->special;
 
 			if (cmd)
@@ -147,7 +147,7 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
 	struct request *rq = drive->hwif->rq;
 
-	if (rq && rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+	if (rq && ata_misc_request(rq) &&
 	    scsi_req(rq)->cmd[0] == REQ_DRIVE_RESET) {
 		if (err <= 0 && rq->errors == 0)
 			rq->errors = -EIO;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3bd678a..24c6d36 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -97,7 +97,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 			       "Aborting request!\n");
 	}
 
-	if (rq->cmd_type == REQ_TYPE_DRV_PRIV)
+	if (ata_misc_request(rq))
 		rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
 	return uptodate;
@@ -246,7 +246,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		} else
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
-		if (rq->cmd_type == REQ_TYPE_DRV_PRIV) {
+		if (ata_misc_request(rq)) {
 			rq->errors = 0;
 			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 			return ide_stopped;
@@ -265,14 +265,20 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
 		break;
-	case REQ_TYPE_DRV_PRIV:
-	case REQ_TYPE_ATA_SENSE:
-		pc = (struct ide_atapi_pc *)rq->special;
-		break;
 	case REQ_TYPE_BLOCK_PC:
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 		break;
+	case REQ_TYPE_DRV_PRIV:
+		switch (ide_req(rq)->type) {
+		case ATA_PRIV_MISC:
+		case ATA_PRIV_SENSE:
+			pc = (struct ide_atapi_pc *)rq->special;
+			break;
+		default:
+			BUG();
+		}
+		break;
 	default:
 		BUG();
 	}
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 3378503..6735c92 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -102,7 +102,7 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 			drive->dev_flags |= IDE_DFLAG_PARKED;
 	}
 
-	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+	if (rq && ata_taskfile_request(rq)) {
 		struct ide_cmd *orig_cmd = rq->special;
 
 		if (cmd->tf_flags & IDE_TFLAG_DYN)
@@ -135,7 +135,7 @@ EXPORT_SYMBOL(ide_complete_rq);
 
 void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
-	u8 drv_req = (rq->cmd_type == REQ_TYPE_DRV_PRIV) && rq->rq_disk;
+	u8 drv_req = ata_misc_request(rq) && rq->rq_disk;
 	u8 media = drive->media;
 
 	drive->failed_pc = NULL;
@@ -340,7 +340,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 		if (drive->current_speed == 0xff)
 			ide_config_drive_speed(drive, drive->desired_speed);
 
-		if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
+		if (ata_taskfile_request(rq))
 			return execute_drive_cmd(drive, rq);
 		else if (ata_pm_request(rq)) {
 			struct ide_pm_state *pm = rq->special;
@@ -353,7 +353,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			    pm->pm_step == IDE_PM_COMPLETED)
 				ide_complete_pm_rq(drive, rq);
 			return startstop;
-		} else if (!rq->rq_disk && rq->cmd_type == REQ_TYPE_DRV_PRIV)
+		} else if (!rq->rq_disk && ata_misc_request(rq))
 			/*
 			 * TODO: Once all ULDs have been modified to
 			 * check for specific op codes rather than
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index a5d22c6..fc19e84 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -127,7 +127,8 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 
 		rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 		scsi_req_init(rq);
-		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+		rq->cmd_type = REQ_TYPE_DRV_PRIV;
+		ide_req(rq)->type = ATA_PRIV_TASKFILE;
 		err = blk_execute_rq(drive->queue, NULL, rq, 0);
 		blk_put_request(rq);
 
@@ -225,6 +226,7 @@ static int generic_drive_reset(ide_drive_t *drive)
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd_len = 1;
 	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
 	if (blk_execute_rq(drive->queue, NULL, rq, 1))
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index c37604a..fc3c944 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -36,6 +36,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	scsi_req(rq)->cmd[0] = REQ_PARK_HEADS;
 	scsi_req(rq)->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->special = &timeout;
 	rc = blk_execute_rq(q, NULL, rq, 1);
 	blk_put_request(rq);
@@ -54,6 +55,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	scsi_req(rq)->cmd[0] = REQ_UNPARK_HEADS;
 	scsi_req(rq)->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
 
 out:
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index f6767ab..0c12968 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -20,7 +20,8 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_ATA_PM_SUSPEND;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_PM_SUSPEND;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
 	if (mesg.event == PM_EVENT_PRETHAW)
@@ -91,7 +92,8 @@ int generic_ide_resume(struct device *dev)
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_ATA_PM_RESUME;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	rq->rq_flags |= RQF_PREEMPT;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
@@ -223,10 +225,10 @@ void ide_complete_pm_rq(ide_drive_t *drive, struct request *rq)
 
 #ifdef DEBUG_PM
 	printk("%s: completing PM request, %s\n", drive->name,
-	       (rq->cmd_type == REQ_TYPE_ATA_PM_SUSPEND) ? "suspend" : "resume");
+	       (ide_req(rq)->type == ATA_PRIV_PM_SUSPEND) ? "suspend" : "resume");
 #endif
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (rq->cmd_type == REQ_TYPE_ATA_PM_SUSPEND)
+	if (ide_req(rq)->type == ATA_PRIV_PM_SUSPEND)
 		blk_stop_queue(q);
 	else
 		drive->dev_flags &= ~IDE_DFLAG_BLOCKED;
@@ -242,11 +244,13 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
 	struct ide_pm_state *pm = rq->special;
 
-	if (rq->cmd_type == REQ_TYPE_ATA_PM_SUSPEND &&
+	if (rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+	    ide_req(rq)->type == ATA_PRIV_PM_SUSPEND &&
 	    pm->pm_step == IDE_PM_START_SUSPEND)
 		/* Mark drive blocked when starting the suspend sequence. */
 		drive->dev_flags |= IDE_DFLAG_BLOCKED;
-	else if (rq->cmd_type == REQ_TYPE_ATA_PM_RESUME &&
+	else if (rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+	         ide_req(rq)->type == ATA_PRIV_PM_RESUME &&
 		 pm->pm_step == IDE_PM_START_RESUME) {
 		/*
 		 * The first thing we do on wakeup is to wait for BSY bit to
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index f6bc1e2..37c7bea 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -577,8 +577,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		      req->cmd[0], (unsigned long long)blk_rq_pos(rq),
 		      blk_rq_sectors(rq));
 
-	BUG_ON(!(rq->cmd_type == REQ_TYPE_DRV_PRIV ||
-		 rq->cmd_type == REQ_TYPE_ATA_SENSE));
+	BUG_ON(rq->cmd_type != REQ_TYPE_DRV_PRIV);
+	BUG_ON(ide_req(rq)->type != ATA_PRIV_MISC &&
+	       ide_req(rq)->type != ATA_PRIV_SENSE);
 
 	/* Retry a failed packet command */
 	if (drive->failed_pc && drive->pc->c[0] == REQUEST_SENSE) {
@@ -856,6 +857,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
 	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
 	rq->__sector = tape->first_frame;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a393e13..9ccc1d5 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -432,7 +432,8 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 
 	rq = blk_get_request(drive->queue, rw, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	ide_req(rq)->type = ATA_PRIV_TASKFILE;
 
 	/*
 	 * (ks) We transfer currently only whole sectors.
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 086fbe1..5cc6caa 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -40,24 +40,58 @@
 
 struct device;
 
-/* IDE-specific values for req->cmd_type */
-enum ata_cmd_type_bits {
-	REQ_TYPE_ATA_TASKFILE = REQ_TYPE_DRV_PRIV + 1,
-	REQ_TYPE_ATA_PC,
-	REQ_TYPE_ATA_SENSE,	/* sense request */
-	REQ_TYPE_ATA_PM_SUSPEND,/* suspend request */
-	REQ_TYPE_ATA_PM_RESUME,	/* resume request */
+/* values for ide_request.type */
+enum ata_priv_type {
+	ATA_PRIV_MISC,
+	ATA_PRIV_TASKFILE,
+	ATA_PRIV_PC,
+	ATA_PRIV_SENSE,		/* sense request */
+	ATA_PRIV_PM_SUSPEND,	/* suspend request */
+	ATA_PRIV_PM_RESUME,	/* resume request */
 };
 
-#define ata_pm_request(rq)	\
-	((rq)->cmd_type == REQ_TYPE_ATA_PM_SUSPEND || \
-	 (rq)->cmd_type == REQ_TYPE_ATA_PM_RESUME)
-
 struct ide_request {
 	struct scsi_request sreq;
 	u8 sense[SCSI_SENSE_BUFFERSIZE];
+	u8 type;
 };
 
+static inline struct ide_request *ide_req(struct request *rq)
+{
+	return blk_mq_rq_to_pdu(rq);
+}
+
+static inline bool ata_misc_request(struct request *rq)
+{
+	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+               ide_req(rq)->type == ATA_PRIV_MISC;
+}
+
+static inline bool ata_taskfile_request(struct request *rq)
+{
+	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+               ide_req(rq)->type == ATA_PRIV_TASKFILE;
+}
+
+static inline bool ata_pc_request(struct request *rq)
+{
+	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+               ide_req(rq)->type == ATA_PRIV_PC;
+}
+
+static inline bool ata_sense_request(struct request *rq)
+{
+	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+               ide_req(rq)->type == ATA_PRIV_SENSE;
+}
+
+static inline bool ata_pm_request(struct request *rq)
+{
+	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+		(ide_req(rq)->type == ATA_PRIV_PM_SUSPEND ||
+		 ide_req(rq)->type == ATA_PRIV_PM_RESUME);
+}
+
 /* Error codes returned in rq->errors to the higher part of the driver. */
 enum {
 	IDE_DRV_ERROR_GENERAL	= 101,
-- 
2.1.4

