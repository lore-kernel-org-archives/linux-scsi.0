From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: block: remove the blk_execute_rq return value
Date: Tue, 18 Apr 2017 08:52:07 -0700
Message-ID: <20170418155229.5977-2-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

The function only returns -EIO if rq->errors is non-zero, which is not
very useful and lets a large number of callers ignore the return value.

Just let the callers figure out their error themselves.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-exec.c                 | 8 +-------
 block/scsi_ioctl.c               | 3 ++-
 drivers/block/paride/pd.c        | 3 ++-
 drivers/block/virtio_blk.c       | 3 ++-
 drivers/cdrom/cdrom.c            | 3 ++-
 drivers/ide/ide-atapi.c          | 3 ++-
 drivers/ide/ide-cd.c             | 3 ++-
 drivers/ide/ide-cd_ioctl.c       | 3 ++-
 drivers/ide/ide-devsets.c        | 4 ++--
 drivers/ide/ide-disk.c           | 3 +--
 drivers/ide/ide-ioctls.c         | 7 ++++---
 drivers/ide/ide-park.c           | 3 ++-
 drivers/ide/ide-pm.c             | 3 ++-
 drivers/ide/ide-taskfile.c       | 4 ++--
 drivers/scsi/osd/osd_initiator.c | 5 ++++-
 fs/nfsd/blocklayout.c            | 5 +++--
 include/linux/blkdev.h           | 2 +-
 17 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 8cd0e9bc8dc8..afa383248c7c 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -92,11 +92,10 @@ EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
  *    Insert a fully prepared request at the back of the I/O scheduler queue
  *    for execution and wait for completion.
  */
-int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
+void blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 		   struct request *rq, int at_head)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
-	int err = 0;
 	unsigned long hang_check;
 
 	rq->end_io_data = &wait;
@@ -108,10 +107,5 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 		while (!wait_for_completion_io_timeout(&wait, hang_check * (HZ/2)));
 	else
 		wait_for_completion_io(&wait);
-
-	if (rq->errors)
-		err = -EIO;
-
-	return err;
 }
 EXPORT_SYMBOL(blk_execute_rq);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 82a43bb19967..b1352143f12f 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -547,7 +547,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	scsi_req(rq)->cmd[0] = cmd;
 	scsi_req(rq)->cmd[4] = data;
 	scsi_req(rq)->cmd_len = 6;
-	err = blk_execute_rq(q, bd_disk, rq, 0);
+	blk_execute_rq(q, bd_disk, rq, 0);
+	err = rq->errors ? -EIO : 0;
 	blk_put_request(rq);
 
 	return err;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index b05e151c9b38..82c6d02193ae 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -747,7 +747,8 @@ static int pd_special_command(struct pd_unit *disk,
 
 	rq->special = func;
 
-	err = blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
+	blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
+	err = req->errors ? -EIO : 0;
 
 	blk_put_request(rq);
 	return err;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2d8290169271..eaf99022bdc6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -310,7 +310,8 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	if (err)
 		goto out;
 
-	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	err = req->errors ? -EIO : 0;
 out:
 	blk_put_request(req);
 	return err;
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 87739649eac2..308501730ab3 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2218,7 +2218,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		rq->timeout = 60 * HZ;
 		bio = rq->bio;
 
-		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
+		blk_execute_rq(q, cdi->disk, rq, 0);
+		if (rq->errors) {
 			struct request_sense *s = req->sense;
 			ret = -EIO;
 			cdi->last_sense = s->sense_key;
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index feb30061123b..1524797e1776 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -107,7 +107,8 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	memcpy(scsi_req(rq)->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
 		scsi_req(rq)->cmd[13] = REQ_IDETAPE_PC1;
-	error = blk_execute_rq(drive->queue, disk, rq, 0);
+	blk_execute_rq(drive->queue, disk, rq, 0);
+	error = rq->errors ? -EIO : 0;
 put_req:
 	blk_put_request(rq);
 	return error;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 74f1b7dc03f7..95c40afa9120 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -452,7 +452,8 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 			}
 		}
 
-		error = blk_execute_rq(drive->queue, info->disk, rq, 0);
+		blk_execute_rq(drive->queue, info->disk, rq, 0);
+		error = rq->errors ? -EIO : 0;
 
 		if (buffer)
 			*bufflen = scsi_req(rq)->resid_len;
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 9fcefbc8425e..f1ab726bd430 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -307,7 +307,8 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	scsi_req_init(rq);
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->rq_flags = RQF_QUIET;
-	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
+	blk_execute_rq(drive->queue, cd->disk, rq, 0);
+	ret = rq->errors ? -EIO : 0;
 	blk_put_request(rq);
 	/*
 	 * A reset will unlock the door. If it was previously locked,
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index a45dda5386e4..eea6a7cb80b5 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -173,8 +173,8 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	*(int *)&scsi_req(rq)->cmd[1] = arg;
 	rq->special = setting->set;
 
-	if (blk_execute_rq(q, NULL, rq, 0))
-		ret = rq->errors;
+	blk_execute_rq(q, NULL, rq, 0);
+	ret = rq->errors;
 	blk_put_request(rq);
 
 	return ret;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 186159715b71..7c06237f3479 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -470,7 +470,6 @@ ide_devset_get(multcount, mult_count);
 static int set_multcount(ide_drive_t *drive, int arg)
 {
 	struct request *rq;
-	int error;
 
 	if (arg < 0 || arg > (drive->id[ATA_ID_MAX_MULTSECT] & 0xff))
 		return -EINVAL;
@@ -484,7 +483,7 @@ static int set_multcount(ide_drive_t *drive, int arg)
 
 	drive->mult_req = arg;
 	drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
-	error = blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
 
 	return (drive->mult_count == arg) ? 0 : -EIO;
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 248a3e0ceb46..3e96e531b367 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -128,7 +128,8 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 		rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 		scsi_req_init(rq);
 		ide_req(rq)->type = ATA_PRIV_TASKFILE;
-		err = blk_execute_rq(drive->queue, NULL, rq, 0);
+		blk_execute_rq(drive->queue, NULL, rq, 0);
+		err = rq->errors ? -EIO : 0;
 		blk_put_request(rq);
 
 		return err;
@@ -227,8 +228,8 @@ static int generic_drive_reset(ide_drive_t *drive)
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd_len = 1;
 	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
-	if (blk_execute_rq(drive->queue, NULL, rq, 1))
-		ret = rq->errors;
+	blk_execute_rq(drive->queue, NULL, rq, 1);
+	ret = rq->errors;
 	blk_put_request(rq);
 	return ret;
 }
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 101aed9a61ca..b4f577016f5a 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -37,7 +37,8 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	scsi_req(rq)->cmd_len = 1;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->special = &timeout;
-	rc = blk_execute_rq(q, NULL, rq, 1);
+	blk_execute_rq(q, NULL, rq, 1);
+	rc = rq->errors ? -EIO : 0;
 	blk_put_request(rq);
 	if (rc)
 		goto out;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index ec951be4b0c8..bf513f886f3c 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -27,7 +27,8 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 		mesg.event = PM_EVENT_FREEZE;
 	rqpm.pm_state = mesg.event;
 
-	ret = blk_execute_rq(drive->queue, NULL, rq, 0);
+	blk_execute_rq(drive->queue, NULL, rq, 0);
+	ret = rq->errors ? -EIO : 0;
 	blk_put_request(rq);
 
 	if (ret == 0 && ide_port_acpi(hwif)) {
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 4c0007cb74e3..78924c7c9478 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -452,8 +452,8 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	rq->special = cmd;
 	cmd->rq = rq;
 
-	error = blk_execute_rq(drive->queue, NULL, rq, 0);
-
+	blk_execute_rq(drive->queue, NULL, rq, 0);
+	error = rq->errors ? -EIO : 0;
 put_req:
 	blk_put_request(rq);
 	return error;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 9d0727b2bdec..44e03c3eb250 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -489,7 +489,10 @@ static void _set_error_resid(struct osd_request *or, struct request *req,
 
 int osd_execute_request(struct osd_request *or)
 {
-	int error = blk_execute_rq(or->request->q, NULL, or->request, 0);
+	int error;
+
+	blk_execute_rq(or->request->q, NULL, or->request, 0);
+	error = or->request ? -EIO : 0;
 
 	_set_error_resid(or, or->request, error);
 	return error;
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 92b4b41d19d2..9f618b77ffee 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -242,10 +242,11 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	req->cmd[4] = bufflen & 0xff;
 	req->cmd_len = COMMAND_SIZE(INQUIRY);
 
-	error = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (error) {
+	blk_execute_rq(rq->q, NULL, rq, 1);
+	if (rq->errors) {
 		pr_err("pNFS: INQUIRY 0x83 failed with: %x\n",
 			rq->errors);
+		error = -EIO;
 		goto out_put_request;
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ec993573e0a8..5986e1250d7d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -969,7 +969,7 @@ extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, uns
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, const struct iov_iter *,
 			       gfp_t);
-extern int blk_execute_rq(struct request_queue *, struct gendisk *,
+extern void blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
-- 
2.11.0
