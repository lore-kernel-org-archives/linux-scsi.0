From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] block: rename REQ_TYPE_SPECIAL to REQ_TYPE_DRV_PRIV
Date: Fri, 17 Apr 2015 22:37:16 +0200
Message-ID: <1429303042-12078-2-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbbDQUiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:20 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c        | 2 +-
 drivers/block/paride/pd.c  | 4 ++--
 drivers/block/sx8.c        | 4 ++--
 drivers/block/virtio_blk.c | 6 +++---
 drivers/ide/ide-atapi.c    | 4 ++--
 drivers/ide/ide-cd.c       | 2 +-
 drivers/ide/ide-cd_ioctl.c | 2 +-
 drivers/ide/ide-devsets.c  | 2 +-
 drivers/ide/ide-eh.c       | 2 +-
 drivers/ide/ide-floppy.c   | 6 +++---
 drivers/ide/ide-io.c       | 4 ++--
 drivers/ide/ide-ioctls.c   | 2 +-
 drivers/ide/ide-park.c     | 4 ++--
 drivers/ide/ide-tape.c     | 4 ++--
 include/linux/blkdev.h     | 4 ++--
 15 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 39e5f7f..9cf52ac 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -592,7 +592,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		fsync_bdev(bdev);
 		mutex_lock(&nbd->tx_lock);
 		blk_rq_init(NULL, &sreq);
-		sreq.cmd_type = REQ_TYPE_SPECIAL;
+		sreq.cmd_type = REQ_TYPE_DRV_PRIV;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
 
 		/* Check again after getting mutex back.  */
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index d48715b..dbb4da1 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -442,7 +442,7 @@ static char *pd_buf;		/* buffer for request in progress */
 
 static enum action do_pd_io_start(void)
 {
-	if (pd_req->cmd_type == REQ_TYPE_SPECIAL) {
+	if (pd_req->cmd_type == REQ_TYPE_DRV_PRIV) {
 		phase = pd_special;
 		return pd_special();
 	}
@@ -725,7 +725,7 @@ static int pd_special_command(struct pd_unit *disk,
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = func;
 
 	err = blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 5d55285..59c91d4 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -620,7 +620,7 @@ static int carm_array_info (struct carm_host *host, unsigned int array_idx)
 	spin_unlock_irq(&host->lock);
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", idx);
-	crq->rq->cmd_type = REQ_TYPE_SPECIAL;
+	crq->rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	crq->rq->special = crq;
 	blk_execute_rq_nowait(host->oob_q, NULL, crq->rq, true, NULL);
 
@@ -661,7 +661,7 @@ static int carm_send_special (struct carm_host *host, carm_sspc_t func)
 	crq->msg_bucket = (u32) rc;
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", idx);
-	crq->rq->cmd_type = REQ_TYPE_SPECIAL;
+	crq->rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	crq->rq->special = crq;
 	blk_execute_rq_nowait(host->oob_q, NULL, crq->rq, true, NULL);
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 5ea2f0b..d4d05f0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -124,7 +124,7 @@ static inline void virtblk_request_done(struct request *req)
 		req->resid_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.residual);
 		req->sense_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
 		req->errors = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.errors);
-	} else if (req->cmd_type == REQ_TYPE_SPECIAL) {
+	} else if (req->cmd_type == REQ_TYPE_DRV_PRIV) {
 		req->errors = (error != 0);
 	}
 
@@ -188,7 +188,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 			vbr->out_hdr.sector = 0;
 			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
 			break;
-		case REQ_TYPE_SPECIAL:
+		case REQ_TYPE_DRV_PRIV:
 			vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
 			vbr->out_hdr.sector = 0;
 			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(vbr->req));
@@ -251,7 +251,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 		return PTR_ERR(req);
 	}
 
-	req->cmd_type = REQ_TYPE_SPECIAL;
+	req->cmd_type = REQ_TYPE_DRV_PRIV;
 	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
 	blk_put_request(req);
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index fac3d9d..b367300 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -93,7 +93,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	int error;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = (char *)pc;
 
 	if (buf && bufflen) {
@@ -477,7 +477,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		if (uptodate == 0)
 			drive->failed_pc = NULL;
 
-		if (rq->cmd_type == REQ_TYPE_SPECIAL) {
+		if (rq->cmd_type == REQ_TYPE_DRV_PRIV) {
 			rq->errors = 0;
 			error = 0;
 		} else {
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0b510ba..9a32603 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -799,7 +799,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 		cdrom_do_block_pc(drive, rq);
 		break;
-	case REQ_TYPE_SPECIAL:
+	case REQ_TYPE_DRV_PRIV:
 		/* right now this can only be a reset... */
 		uptodate = 1;
 		goto out_end;
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 02caa7d..066e390 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -304,7 +304,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	int ret;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd_flags = REQ_QUIET;
 	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
 	blk_put_request(rq);
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index 9e98122..b05a74d 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -166,7 +166,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 		return setting->set(drive, arg);
 
 	rq = blk_get_request(q, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd_len = 5;
 	rq->cmd[0] = REQ_DEVSET_EXEC;
 	*(int *)&rq->cmd[1] = arg;
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 3297066..19d809c 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -147,7 +147,7 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
 	struct request *rq = drive->hwif->rq;
 
-	if (rq && rq->cmd_type == REQ_TYPE_SPECIAL &&
+	if (rq && rq->cmd_type == REQ_TYPE_DRV_PRIV &&
 	    rq->cmd[0] == REQ_DRIVE_RESET) {
 		if (err <= 0 && rq->errors == 0)
 			rq->errors = -EIO;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8c6363c..3dbfa5b 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -97,7 +97,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 			       "Aborting request!\n");
 	}
 
-	if (rq->cmd_type == REQ_TYPE_SPECIAL)
+	if (rq->cmd_type == REQ_TYPE_DRV_PRIV)
 		rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
 	return uptodate;
@@ -246,7 +246,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		} else
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
-		if (rq->cmd_type == REQ_TYPE_SPECIAL) {
+		if (rq->cmd_type == REQ_TYPE_DRV_PRIV) {
 			rq->errors = 0;
 			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 			return ide_stopped;
@@ -265,7 +265,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
 		break;
-	case REQ_TYPE_SPECIAL:
+	case REQ_TYPE_DRV_PRIV:
 	case REQ_TYPE_SENSE:
 		pc = (struct ide_atapi_pc *)rq->special;
 		break;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 177db6d..8e55abd 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -135,7 +135,7 @@ EXPORT_SYMBOL(ide_complete_rq);
 
 void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 {
-	u8 drv_req = (rq->cmd_type == REQ_TYPE_SPECIAL) && rq->rq_disk;
+	u8 drv_req = (rq->cmd_type == REQ_TYPE_DRV_PRIV) && rq->rq_disk;
 	u8 media = drive->media;
 
 	drive->failed_pc = NULL;
@@ -353,7 +353,7 @@ static ide_startstop_t start_request (ide_drive_t *drive, struct request *rq)
 			    pm->pm_step == IDE_PM_COMPLETED)
 				ide_complete_pm_rq(drive, rq);
 			return startstop;
-		} else if (!rq->rq_disk && rq->cmd_type == REQ_TYPE_SPECIAL)
+		} else if (!rq->rq_disk && rq->cmd_type == REQ_TYPE_DRV_PRIV)
 			/*
 			 * TODO: Once all ULDs have been modified to
 			 * check for specific op codes rather than
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 6233fa2c..aa2e9b7 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -222,7 +222,7 @@ static int generic_drive_reset(ide_drive_t *drive)
 	int ret = 0;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd_len = 1;
 	rq->cmd[0] = REQ_DRIVE_RESET;
 	if (blk_execute_rq(drive->queue, NULL, rq, 1))
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index ca95860..c808685 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -34,7 +34,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	rq = blk_get_request(q, READ, __GFP_WAIT);
 	rq->cmd[0] = REQ_PARK_HEADS;
 	rq->cmd_len = 1;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = &timeout;
 	rc = blk_execute_rq(q, NULL, rq, 1);
 	blk_put_request(rq);
@@ -51,7 +51,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 
 	rq->cmd[0] = REQ_UNPARK_HEADS;
 	rq->cmd_len = 1;
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
 
 out:
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6eb738c..2a5d543 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -576,7 +576,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		      rq->cmd[0], (unsigned long long)blk_rq_pos(rq),
 		      blk_rq_sectors(rq));
 
-	BUG_ON(!(rq->cmd_type == REQ_TYPE_SPECIAL ||
+	BUG_ON(!(rq->cmd_type == REQ_TYPE_DRV_PRIV ||
 		 rq->cmd_type == REQ_TYPE_SENSE));
 
 	/* Retry a failed packet command */
@@ -853,7 +853,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	BUG_ON(size < 0 || size % tape->blk_size);
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
 	rq->__sector = tape->first_frame;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516..98c9027 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -79,10 +79,10 @@ enum rq_cmd_type_bits {
 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
 	REQ_TYPE_PM_RESUME,		/* resume request */
 	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
-	REQ_TYPE_SPECIAL,		/* driver defined type */
+	REQ_TYPE_DRV_PRIV,		/* driver defined type */
 	/*
 	 * for ATA/ATAPI devices. this really doesn't belong here, ide should
-	 * use REQ_TYPE_SPECIAL and use rq->cmd[0] with the range of driver
+	 * use REQ_TYPE_DRV_PRIV and use rq->cmd[0] with the range of driver
 	 * private REQ_LB opcodes to differentiate what type of request this is
 	 */
 	REQ_TYPE_ATA_TASKFILE,
-- 
1.9.1

