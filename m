From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/25] scsi: introduce a new result field in struct scsi_request
Date: Thu,  6 Apr 2017 17:39:28 +0200
Message-ID: <20170406153944.10058-10-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43512 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755322AbdDFPk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:40:28 -0400
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

This passes on the scsi_cmnd result field to users of passthrough
requests.  Currently we abuse req->errors for this purpose, but that
field will go away in its current form.

Note that the old IDE code abuses the errors field in very creative
ways and stores all kinds of different values in it.  I didn't dare
to touch this magic, so the abuses are brought forward 1:1.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg-lib.c                    |  8 ++++----
 block/bsg.c                        | 12 +++++------
 block/scsi_ioctl.c                 | 14 ++++++-------
 drivers/block/cciss.c              | 42 +++++++++++++++++++-------------------
 drivers/block/pktcdvd.c            |  2 +-
 drivers/block/virtio_blk.c         |  2 +-
 drivers/cdrom/cdrom.c              |  2 +-
 drivers/ide/ide-atapi.c            | 10 ++++-----
 drivers/ide/ide-cd.c               | 20 +++++++++---------
 drivers/ide/ide-cd_ioctl.c         |  2 +-
 drivers/ide/ide-devsets.c          |  4 ++--
 drivers/ide/ide-dma.c              |  2 +-
 drivers/ide/ide-eh.c               | 36 ++++++++++++++++----------------
 drivers/ide/ide-floppy.c           | 10 ++++-----
 drivers/ide/ide-io.c               | 10 ++++-----
 drivers/ide/ide-ioctls.c           |  4 ++--
 drivers/ide/ide-park.c             |  2 +-
 drivers/ide/ide-pm.c               |  8 ++++----
 drivers/ide/ide-tape.c             |  4 ++--
 drivers/ide/ide-taskfile.c         |  6 +++---
 drivers/scsi/osd/osd_initiator.c   |  2 +-
 drivers/scsi/osst.c                |  2 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  6 +++---
 drivers/scsi/scsi_lib.c            | 18 +++++++---------
 drivers/scsi/scsi_transport_sas.c  |  2 +-
 drivers/scsi/sg.c                  |  2 +-
 drivers/scsi/st.c                  |  6 +++---
 drivers/target/target_core_pscsi.c |  2 +-
 fs/nfsd/blocklayout.c              |  4 ++--
 include/linux/ide.h                |  2 +-
 include/scsi/scsi_request.h        |  1 +
 31 files changed, 122 insertions(+), 125 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index cd15f9dbb147..0a23dbba2d30 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -37,7 +37,7 @@ static void bsg_destroy_job(struct kref *kref)
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 	struct request *rq = job->req;
 
-	blk_end_request_all(rq, rq->errors);
+	blk_end_request_all(rq, scsi_req(rq)->result);
 
 	put_device(job->dev);	/* release reference for the request */
 
@@ -74,7 +74,7 @@ void bsg_job_done(struct bsg_job *job, int result,
 	struct scsi_request *rq = scsi_req(req);
 	int err;
 
-	err = job->req->errors = result;
+	err = scsi_req(job->req)->result = result;
 	if (err < 0)
 		/* we're only returning the result field in the reply */
 		rq->sense_len = sizeof(u32);
@@ -177,7 +177,7 @@ static int bsg_create_job(struct device *dev, struct request *req)
  * @q: request queue to manage
  *
  * On error the create_bsg_job function should return a -Exyz error value
- * that will be set to the req->errors.
+ * that will be set to ->result.
  *
  * Drivers/subsys should pass this to the queue init function.
  */
@@ -201,7 +201,7 @@ static void bsg_request_fn(struct request_queue *q)
 
 		ret = bsg_create_job(dev, req);
 		if (ret) {
-			req->errors = ret;
+			scsi_req(req)->result = ret;
 			blk_end_request_all(req, ret);
 			spin_lock_irq(q->queue_lock);
 			continue;
diff --git a/block/bsg.c b/block/bsg.c
index 74835dbf0c47..e54daf9f2ee0 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -391,13 +391,13 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	struct scsi_request *req = scsi_req(rq);
 	int ret = 0;
 
-	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
+	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->result);
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = rq->errors & 0xff;
-	hdr->transport_status = host_byte(rq->errors);
-	hdr->driver_status = driver_byte(rq->errors);
+	hdr->device_status = req->result & 0xff;
+	hdr->transport_status = host_byte(req->result);
+	hdr->driver_status = driver_byte(req->result);
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
@@ -431,8 +431,8 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	 * just a protocol response (i.e. non negative), that gets
 	 * processed above.
 	 */
-	if (!ret && rq->errors < 0)
-		ret = rq->errors;
+	if (!ret && req->result < 0)
+		ret = req->result;
 
 	blk_rq_unmap_user(bio);
 	scsi_req_free_cmd(req);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b1352143f12f..4a294a5f7fab 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -262,11 +262,11 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->status = rq->errors & 0xff;
-	hdr->masked_status = status_byte(rq->errors);
-	hdr->msg_status = msg_byte(rq->errors);
-	hdr->host_status = host_byte(rq->errors);
-	hdr->driver_status = driver_byte(rq->errors);
+	hdr->status = req->result & 0xff;
+	hdr->masked_status = status_byte(req->result);
+	hdr->msg_status = msg_byte(req->result);
+	hdr->host_status = host_byte(req->result);
+	hdr->driver_status = driver_byte(req->result);
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
@@ -509,7 +509,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
+	err = req->result & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (req->sense_len && req->sense) {
 			bytes = (OMAX_SB_LEN > req->sense_len) ?
@@ -548,7 +548,7 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	scsi_req(rq)->cmd[4] = data;
 	scsi_req(rq)->cmd_len = 6;
 	blk_execute_rq(q, bd_disk, rq, 0);
-	err = rq->errors ? -EIO : 0;
+	err = scsi_req(rq)->result ? -EIO : 0;
 	blk_put_request(rq);
 
 	return err;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8e1a4554951c..cd375503f7b0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1864,8 +1864,7 @@ static void cciss_softirq_done(struct request *rq)
 	/* set the residual count for pc requests */
 	if (blk_rq_is_passthrough(rq))
 		scsi_req(rq)->resid_len = c->err_info->ResidualCnt;
-
-	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
+	blk_end_request_all(rq, scsi_req(rq)->result ? -EIO : 0);
 
 	spin_lock_irqsave(&h->lock, flags);
 	cmd_free(h, c);
@@ -3140,18 +3139,19 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 {
 	int retry_cmd = 0;
 	struct request *rq = cmd->rq;
+	struct scsi_request *sreq = scsi_req(rq);
 
-	rq->errors = 0;
+	sreq->result = 0;
 
 	if (timeout)
-		rq->errors = make_status_bytes(0, 0, 0, DRIVER_TIMEOUT);
+		sreq->result = make_status_bytes(0, 0, 0, DRIVER_TIMEOUT);
 
 	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
 		goto after_error_processing;
 
 	switch (cmd->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		rq->errors = evaluate_target_status(h, cmd, &retry_cmd);
+		sreq->result = evaluate_target_status(h, cmd, &retry_cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (!blk_rq_is_passthrough(cmd->rq)) {
@@ -3169,7 +3169,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	case CMD_INVALID:
 		dev_warn(&h->pdev->dev, "cciss: cmd %p is "
 		       "reported invalid\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3177,7 +3177,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	case CMD_PROTOCOL_ERR:
 		dev_warn(&h->pdev->dev, "cciss: cmd %p has "
 		       "protocol error\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3185,7 +3185,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	case CMD_HARDWARE_ERR:
 		dev_warn(&h->pdev->dev, "cciss: cmd %p had "
 		       " hardware error\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3193,7 +3193,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	case CMD_CONNECTION_LOST:
 		dev_warn(&h->pdev->dev, "cciss: cmd %p had "
 		       "connection lost\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3201,7 +3201,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	case CMD_ABORTED:
 		dev_warn(&h->pdev->dev, "cciss: cmd %p was "
 		       "aborted\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ABORT);
@@ -3209,7 +3209,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 	case CMD_ABORT_FAILED:
 		dev_warn(&h->pdev->dev, "cciss: cmd %p reports "
 		       "abort failed\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3224,21 +3224,21 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		} else
 			dev_warn(&h->pdev->dev,
 				"%p retried too many times\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_TIMEOUT:
 		dev_warn(&h->pdev->dev, "cmd %p timedout\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNABORTABLE:
 		dev_warn(&h->pdev->dev, "cmd %p unabortable\n", cmd);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3247,7 +3247,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		dev_warn(&h->pdev->dev, "cmd %p returned "
 		       "unknown status %x\n", cmd,
 		       cmd->err_info->CommandStatus);
-		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+		sreq->result = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			blk_rq_is_passthrough(cmd->rq) ?
 				DID_PASSTHROUGH : DID_ERROR);
@@ -3380,9 +3380,9 @@ static void do_cciss_request(struct request_queue *q)
 		if (dma_mapping_error(&h->pdev->dev, temp64.val)) {
 			dev_warn(&h->pdev->dev,
 				"%s: error mapping page for DMA\n", __func__);
-			creq->errors = make_status_bytes(SAM_STAT_GOOD,
-							0, DRIVER_OK,
-							DID_SOFT_ERROR);
+			scsi_req(creq)->result =
+				make_status_bytes(SAM_STAT_GOOD, 0, DRIVER_OK,
+						  DID_SOFT_ERROR);
 			cmd_free(h, c);
 			return;
 		}
@@ -3395,9 +3395,9 @@ static void do_cciss_request(struct request_queue *q)
 		if (cciss_map_sg_chain_block(h, c, h->cmd_sg_list[c->cmdindex],
 			(seg - (h->max_cmd_sgentries - 1)) *
 				sizeof(SGDescriptor_struct))) {
-			creq->errors = make_status_bytes(SAM_STAT_GOOD,
-							0, DRIVER_OK,
-							DID_SOFT_ERROR);
+			scsi_req(creq)->result =
+				make_status_bytes(SAM_STAT_GOOD, 0, DRIVER_OK,
+						  DID_SOFT_ERROR);
 			cmd_free(h, c);
 			return;
 		}
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 66d846ba85a9..205b865ebeb9 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -724,7 +724,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 		rq->rq_flags |= RQF_QUIET;
 
 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
-	if (rq->errors)
+	if (scsi_req(rq)->result)
 		ret = -EIO;
 out:
 	blk_put_request(rq);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 8378ad480f77..dea2a58d6734 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -119,7 +119,7 @@ static inline void virtblk_scsi_request_done(struct request *req)
 
 	sreq->resid_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.residual);
 	sreq->sense_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
-	req->errors = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.errors);
+	sreq->result = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.errors);
 }
 
 static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 308501730ab3..76c952fd9ab9 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2219,7 +2219,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		bio = rq->bio;
 
 		blk_execute_rq(q, cdi->disk, rq, 0);
-		if (rq->errors) {
+		if (scsi_req(rq)->result) {
 			struct request_sense *s = req->sense;
 			ret = -EIO;
 			cdi->last_sense = s->sense_key;
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 1524797e1776..5901937284e7 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -108,7 +108,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	if (drive->media == ide_tape)
 		scsi_req(rq)->cmd[13] = REQ_IDETAPE_PC1;
 	blk_execute_rq(drive->queue, disk, rq, 0);
-	error = rq->errors ? -EIO : 0;
+	error = scsi_req(rq)->result ? -EIO : 0;
 put_req:
 	blk_put_request(rq);
 	return error;
@@ -455,7 +455,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			debug_log("%s: I/O error\n", drive->name);
 
 			if (drive->media != ide_tape)
-				pc->rq->errors++;
+				scsi_req(pc->rq)->result++;
 
 			if (scsi_req(rq)->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR PFX "%s: I/O error in request "
@@ -489,13 +489,13 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			drive->failed_pc = NULL;
 
 		if (ata_misc_request(rq)) {
-			rq->errors = 0;
+			scsi_req(rq)->result = 0;
 			error = 0;
 		} else {
 
 			if (blk_rq_is_passthrough(rq) && uptodate <= 0) {
-				if (rq->errors == 0)
-					rq->errors = -EIO;
+				if (scsi_req(rq)->result == 0)
+					scsi_req(rq)->result = -EIO;
 			}
 
 			error = uptodate ? 0 : -EIO;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 95c40afa9120..07e5ff3a64c3 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -247,10 +247,10 @@ static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
 
 	struct cdrom_info *info = drive->driver_data;
 
-	if (!rq->errors)
+	if (!scsi_req(rq)->result)
 		info->write_timeout = jiffies +	ATAPI_WAIT_WRITE_BUSY;
 
-	rq->errors = 1;
+	scsi_req(rq)->result = 1;
 
 	if (time_after(jiffies, info->write_timeout))
 		return 0;
@@ -294,8 +294,8 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	}
 
 	/* if we have an error, pass CHECK_CONDITION as the SCSI status byte */
-	if (blk_rq_is_scsi(rq) && !rq->errors)
-		rq->errors = SAM_STAT_CHECK_CONDITION;
+	if (blk_rq_is_scsi(rq) && !scsi_req(rq)->result)
+		scsi_req(rq)->result = SAM_STAT_CHECK_CONDITION;
 
 	if (blk_noretry_request(rq))
 		do_end_request = 1;
@@ -325,7 +325,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 * Arrange to retry the request but be sure to give up if we've
 		 * retried too many times.
 		 */
-		if (++rq->errors > ERROR_MAX)
+		if (++scsi_req(rq)->result > ERROR_MAX)
 			do_end_request = 1;
 		break;
 	case ILLEGAL_REQUEST:
@@ -372,7 +372,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			/* go to the default handler for other errors */
 			ide_error(drive, "cdrom_decode_status", stat);
 			return 1;
-		} else if (++rq->errors > ERROR_MAX)
+		} else if (++scsi_req(rq)->result > ERROR_MAX)
 			/* we've racked up too many retries, abort */
 			do_end_request = 1;
 	}
@@ -453,7 +453,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		}
 
 		blk_execute_rq(drive->queue, info->disk, rq, 0);
-		error = rq->errors ? -EIO : 0;
+		error = scsi_req(rq)->result ? -EIO : 0;
 
 		if (buffer)
 			*bufflen = scsi_req(rq)->resid_len;
@@ -684,8 +684,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (cmd->nleft == 0)
 				uptodate = 1;
 		} else {
-			if (uptodate <= 0 && rq->errors == 0)
-				rq->errors = -EIO;
+			if (uptodate <= 0 && scsi_req(rq)->result == 0)
+				scsi_req(rq)->result = -EIO;
 		}
 
 		if (uptodate == 0 && rq->bio)
@@ -1380,7 +1380,7 @@ static int ide_cdrom_prep_pc(struct request *rq)
 	 * appropriate action
 	 */
 	if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
-		rq->errors = ILLEGAL_REQUEST;
+		scsi_req(rq)->result = ILLEGAL_REQUEST;
 		return BLKPREP_KILL;
 	}
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index f1ab726bd430..55cd736c39c6 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -308,7 +308,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->rq_flags = RQF_QUIET;
 	blk_execute_rq(drive->queue, cd->disk, rq, 0);
-	ret = rq->errors ? -EIO : 0;
+	ret = scsi_req(rq)->result ? -EIO : 0;
 	blk_put_request(rq);
 	/*
 	 * A reset will unlock the door. If it was previously locked,
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index eea6a7cb80b5..b1223234037d 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -174,7 +174,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	rq->special = setting->set;
 
 	blk_execute_rq(q, NULL, rq, 0);
-	ret = rq->errors;
+	ret = scsi_req(rq)->result;
 	blk_put_request(rq);
 
 	return ret;
@@ -186,7 +186,7 @@ ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
 
 	err = setfunc(drive, *(int *)&scsi_req(rq)->cmd[1]);
 	if (err)
-		rq->errors = err;
+		scsi_req(rq)->result = err;
 	ide_complete_rq(drive, err, blk_rq_bytes(rq));
 	return ide_stopped;
 }
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 17a65ac56491..51c81223e56d 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -490,7 +490,7 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 	 * make sure request is sane
 	 */
 	if (hwif->rq)
-		hwif->rq->errors = 0;
+		scsi_req(hwif->rq)->result = 0;
 	return ret;
 }
 
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index cf3af6840368..4b7ffd7d158d 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -12,7 +12,7 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 	if ((stat & ATA_BUSY) ||
 	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
-		rq->errors |= ERROR_RESET;
+		scsi_req(rq)->result |= ERROR_RESET;
 	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
 		if (err == ATA_ABORTED) {
@@ -25,10 +25,10 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 			drive->crc_count++;
 		} else if (err & (ATA_BBK | ATA_UNC)) {
 			/* retries won't help these */
-			rq->errors = ERROR_MAX;
+			scsi_req(rq)->result = ERROR_MAX;
 		} else if (err & ATA_TRK0NF) {
 			/* help it find track zero */
-			rq->errors |= ERROR_RECAL;
+			scsi_req(rq)->result |= ERROR_RECAL;
 		}
 	}
 
@@ -39,23 +39,23 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 		ide_pad_transfer(drive, READ, nsect * SECTOR_SIZE);
 	}
 
-	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
+	if (scsi_req(rq)->result >= ERROR_MAX || blk_noretry_request(rq)) {
 		ide_kill_rq(drive, rq);
 		return ide_stopped;
 	}
 
 	if (hwif->tp_ops->read_status(hwif) & (ATA_BUSY | ATA_DRQ))
-		rq->errors |= ERROR_RESET;
+		scsi_req(rq)->result |= ERROR_RESET;
 
-	if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-		++rq->errors;
+	if ((scsi_req(rq)->result & ERROR_RESET) == ERROR_RESET) {
+		++scsi_req(rq)->result;
 		return ide_do_reset(drive);
 	}
 
-	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
+	if ((scsi_req(rq)->result & ERROR_RECAL) == ERROR_RECAL)
 		drive->special_flags |= IDE_SFLAG_RECALIBRATE;
 
-	++rq->errors;
+	++scsi_req(rq)->result;
 
 	return ide_stopped;
 }
@@ -68,7 +68,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
 	if ((stat & ATA_BUSY) ||
 	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
 		/* other bits are useless when BUSY */
-		rq->errors |= ERROR_RESET;
+		scsi_req(rq)->result |= ERROR_RESET;
 	} else {
 		/* add decoding error stuff */
 	}
@@ -77,14 +77,14 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
 		/* force an abort */
 		hwif->tp_ops->exec_command(hwif, ATA_CMD_IDLEIMMEDIATE);
 
-	if (rq->errors >= ERROR_MAX) {
+	if (scsi_req(rq)->result >= ERROR_MAX) {
 		ide_kill_rq(drive, rq);
 	} else {
-		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
-			++rq->errors;
+		if ((scsi_req(rq)->result & ERROR_RESET) == ERROR_RESET) {
+			++scsi_req(rq)->result;
 			return ide_do_reset(drive);
 		}
-		++rq->errors;
+		++scsi_req(rq)->result;
 	}
 
 	return ide_stopped;
@@ -130,11 +130,11 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 			if (cmd)
 				ide_complete_cmd(drive, cmd, stat, err);
 		} else if (ata_pm_request(rq)) {
-			rq->errors = 1;
+			scsi_req(rq)->result = 1;
 			ide_complete_pm_rq(drive, rq);
 			return ide_stopped;
 		}
-		rq->errors = err;
+		scsi_req(rq)->result = err;
 		ide_complete_rq(drive, err ? -EIO : 0, blk_rq_bytes(rq));
 		return ide_stopped;
 	}
@@ -149,8 +149,8 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 
 	if (rq && ata_misc_request(rq) &&
 	    scsi_req(rq)->cmd[0] == REQ_DRIVE_RESET) {
-		if (err <= 0 && rq->errors == 0)
-			rq->errors = -EIO;
+		if (err <= 0 && scsi_req(rq)->result == 0)
+			scsi_req(rq)->result = -EIO;
 		ide_complete_rq(drive, err ? err : 0, blk_rq_bytes(rq));
 	}
 }
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index a69e8013f1df..8ac6048cd2df 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -98,7 +98,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 	}
 
 	if (ata_misc_request(rq))
-		rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
+		scsi_req(rq)->result = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
 
 	return uptodate;
 }
@@ -239,7 +239,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 					? rq->rq_disk->disk_name
 					: "dev?"));
 
-	if (rq->errors >= ERROR_MAX) {
+	if (scsi_req(rq)->result >= ERROR_MAX) {
 		if (drive->failed_pc) {
 			ide_floppy_report_error(floppy, drive->failed_pc);
 			drive->failed_pc = NULL;
@@ -247,7 +247,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 			printk(KERN_ERR PFX "%s: I/O error\n", drive->name);
 
 		if (ata_misc_request(rq)) {
-			rq->errors = 0;
+			scsi_req(rq)->result = 0;
 			ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 			return ide_stopped;
 		} else
@@ -301,8 +301,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	return ide_floppy_issue_pc(drive, &cmd, pc);
 out_end:
 	drive->failed_pc = NULL;
-	if (blk_rq_is_passthrough(rq) && rq->errors == 0)
-		rq->errors = -EIO;
+	if (blk_rq_is_passthrough(rq) && scsi_req(rq)->result == 0)
+		scsi_req(rq)->result = -EIO;
 	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
 	return ide_stopped;
 }
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 043b1fb963cb..45b3f41a43d4 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -141,12 +141,12 @@ void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 	drive->failed_pc = NULL;
 
 	if ((media == ide_floppy || media == ide_tape) && drv_req) {
-		rq->errors = 0;
+		scsi_req(rq)->result = 0;
 	} else {
 		if (media == ide_tape)
-			rq->errors = IDE_DRV_ERROR_GENERAL;
-		else if (blk_rq_is_passthrough(rq) && rq->errors == 0)
-			rq->errors = -EIO;
+			scsi_req(rq)->result = IDE_DRV_ERROR_GENERAL;
+		else if (blk_rq_is_passthrough(rq) && scsi_req(rq)->result == 0)
+			scsi_req(rq)->result = -EIO;
 	}
 
 	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
@@ -271,7 +271,7 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	rq->errors = 0;
+	scsi_req(rq)->result = 0;
 	ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 
  	return ide_stopped;
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 3e96e531b367..8c0d17297a7a 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -129,7 +129,7 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 		scsi_req_init(rq);
 		ide_req(rq)->type = ATA_PRIV_TASKFILE;
 		blk_execute_rq(drive->queue, NULL, rq, 0);
-		err = rq->errors ? -EIO : 0;
+		err = scsi_req(rq)->result ? -EIO : 0;
 		blk_put_request(rq);
 
 		return err;
@@ -229,7 +229,7 @@ static int generic_drive_reset(ide_drive_t *drive)
 	scsi_req(rq)->cmd_len = 1;
 	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
 	blk_execute_rq(drive->queue, NULL, rq, 1);
-	ret = rq->errors;
+	ret = scsi_req(rq)->result;
 	blk_put_request(rq);
 	return ret;
 }
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index b4f577016f5a..94e3107f59b9 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -38,7 +38,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->special = &timeout;
 	blk_execute_rq(q, NULL, rq, 1);
-	rc = rq->errors ? -EIO : 0;
+	rc = scsi_req(rq)->result ? -EIO : 0;
 	blk_put_request(rq);
 	if (rc)
 		goto out;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index bf513f886f3c..277c2bb7616f 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -28,7 +28,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	rqpm.pm_state = mesg.event;
 
 	blk_execute_rq(drive->queue, NULL, rq, 0);
-	ret = rq->errors ? -EIO : 0;
+	ret = scsi_req(rq)->result ? -EIO : 0;
 	blk_put_request(rq);
 
 	if (ret == 0 && ide_port_acpi(hwif)) {
@@ -56,8 +56,8 @@ static int ide_pm_execute_rq(struct request *rq)
 	spin_lock_irq(q->queue_lock);
 	if (unlikely(blk_queue_dying(q))) {
 		rq->rq_flags |= RQF_QUIET;
-		rq->errors = -ENXIO;
-		__blk_end_request_all(rq, rq->errors);
+		scsi_req(rq)->result = -ENXIO;
+		__blk_end_request_all(rq, scsi_req(rq)->result);
 		spin_unlock_irq(q->queue_lock);
 		return -ENXIO;
 	}
@@ -67,7 +67,7 @@ static int ide_pm_execute_rq(struct request *rq)
 
 	wait_for_completion_io(&wait);
 
-	return rq->errors ? -EIO : 0;
+	return scsi_req(rq)->result ? -EIO : 0;
 }
 
 int generic_ide_resume(struct device *dev)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index d8a552b47718..a0651f948b76 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -366,7 +366,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 			err = pc->error;
 		}
 	}
-	rq->errors = err;
+	scsi_req(rq)->result = err;
 
 	return uptodate;
 }
@@ -879,7 +879,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 		tape->valid = 0;
 
 	ret = size;
-	if (rq->errors == IDE_DRV_ERROR_GENERAL)
+	if (scsi_req(rq)->result == IDE_DRV_ERROR_GENERAL)
 		ret = -EIO;
 out_put:
 	blk_put_request(rq);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 78924c7c9478..d71199d23c9e 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -287,7 +287,7 @@ static void ide_pio_datablock(ide_drive_t *drive, struct ide_cmd *cmd,
 	u8 saved_io_32bit = drive->io_32bit;
 
 	if (cmd->tf_flags & IDE_TFLAG_FS)
-		cmd->rq->errors = 0;
+		scsi_req(cmd->rq)->result = 0;
 
 	if (cmd->tf_flags & IDE_TFLAG_IO_16BIT)
 		drive->io_32bit = 0;
@@ -329,7 +329,7 @@ void ide_finish_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat)
 	u8 set_xfer = !!(cmd->tf_flags & IDE_TFLAG_SET_XFER);
 
 	ide_complete_cmd(drive, cmd, stat, err);
-	rq->errors = err;
+	scsi_req(rq)->result = err;
 
 	if (err == 0 && set_xfer) {
 		ide_set_xfer_rate(drive, nsect);
@@ -453,7 +453,7 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	cmd->rq = rq;
 
 	blk_execute_rq(drive->queue, NULL, rq, 0);
-	error = rq->errors ? -EIO : 0;
+	error = scsi_req(rq)->result ? -EIO : 0;
 put_req:
 	blk_put_request(rq);
 	return error;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 44e03c3eb250..8d6e2859d9f9 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -477,7 +477,7 @@ static void _set_error_resid(struct osd_request *or, struct request *req,
 			     int error)
 {
 	or->async_error = error;
-	or->req_errors = req->errors ? : error;
+	or->req_errors = scsi_req(req)->result ? : error;
 	or->sense_len = scsi_req(req)->sense_len;
 	if (or->sense_len)
 		memcpy(or->sense, scsi_req(req)->sense, or->sense_len);
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 41bc1d64bf86..67cbed92f07d 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -327,7 +327,7 @@ static void osst_end_async(struct request *req, int update)
 	struct osst_tape *STp = SRpnt->stp;
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 
-	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
+	STp->buffer->cmdstat.midlevel_result = SRpnt->result = rq->result;
 #if DEBUG
 	STp->write_pending = 0;
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 84c9098cc089..b6e40fd4c3c1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2553,13 +2553,13 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 						ql_log(ql_log_warn, vha, 0x7089,
 						    "mbx abort_command "
 						    "failed.\n");
-						bsg_job->req->errors =
+						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
-						bsg_job->req->errors =
+						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -2570,7 +2570,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	bsg_job->req->errors = bsg_reply->result = -ENXIO;
+	scsi_req(bsg_job->req)->result = bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 89b4d9e69866..8c7652f04900 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -229,8 +229,8 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * @rq_flags:	flags for ->rq_flags
  * @resid:	optional residual length
  *
- * returns the req->errors value which is the scsi_cmnd result
- * field.
+ * Returns the scsi_cmnd result field if a command was executed, or a negative
+ * Linux error code if we didn't get that war.
  */
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
@@ -281,7 +281,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		memcpy(sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	if (sshdr)
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
-	ret = req->errors;
+	ret = rq->result;
  out:
 	blk_put_request(req);
 
@@ -790,11 +790,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 						       SCSI_SENSE_BUFFERSIZE);
 		}
 
-		/*
-		 * __scsi_error_from_host_byte may have reset the host_byte
-		 */
-		req->errors = cmd->result;
-
+		scsi_req(req)->result = cmd->result;
 		scsi_req(req)->resid_len = scsi_get_resid(cmd);
 
 		if (scsi_bidi_cmnd(cmd)) {
@@ -824,7 +820,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	/*
 	 * Recovered errors need reporting, but they're always treated as
 	 * success, so fiddle the result code here.  For passthrough requests
-	 * we already took a copy of the original into rq->errors which
+	 * we already took a copy of the original into sreq->result which
 	 * is what gets returned to the user
 	 */
 	if (sense_valid && (sshdr.sense_key == RECOVERED_ERROR)) {
@@ -1267,7 +1263,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 	switch (ret) {
 	case BLKPREP_KILL:
 	case BLKPREP_INVALID:
-		req->errors = DID_NO_CONNECT << 16;
+		scsi_req(req)->result = DID_NO_CONNECT << 16;
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
@@ -1891,7 +1887,7 @@ static int scsi_mq_prep_fn(struct request *req)
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(cmd->request, cmd->request->errors);
+	blk_mq_complete_request(cmd->request, 0);
 }
 
 static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index cdbb293aca08..a2b279737a4b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -184,7 +184,7 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 				blk_rq_bytes(req->next_rq);
 		handler = to_sas_internal(shost->transportt)->f->smp_handler;
 		ret = handler(shost, rphy, req);
-		req->errors = ret;
+		scsi_req(req)->result = ret;
 
 		blk_end_request_all(req, ret);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c5aaceea8d77..504504beaa5e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1300,7 +1300,7 @@ sg_rq_end_io(struct request *rq, int uptodate)
 		pr_info("%s: device detaching\n", __func__);
 
 	sense = req->sense;
-	result = rq->errors;
+	result = req->result;
 	resid = req->resid_len;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 5408643431bb..1ea34d6f5437 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -480,7 +480,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->write_cnt);
-		if (req->errors) {
+		if (scsi_req(req)->result) {
 			atomic64_add(atomic_read(&STp->stats->last_write_size)
 				- STp->buffer->cmdstat.residual,
 				&STp->stats->write_byte_cnt);
@@ -494,7 +494,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->read_cnt);
-		if (req->errors) {
+		if (scsi_req(req)->result) {
 			atomic64_add(atomic_read(&STp->stats->last_read_size)
 				- STp->buffer->cmdstat.residual,
 				&STp->stats->read_byte_cnt);
@@ -518,7 +518,7 @@ static void st_scsi_execute_end(struct request *req, int uptodate)
 	struct scsi_tape *STp = SRpnt->stp;
 	struct bio *tmp;
 
-	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
+	STp->buffer->cmdstat.midlevel_result = SRpnt->result = rq->result;
 	STp->buffer->cmdstat.residual = rq->resid_len;
 
 	st_do_stats(STp, req);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c7fa372c527a..a93d94e68ab5 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1050,7 +1050,7 @@ static void pscsi_req_done(struct request *req, int uptodate)
 	struct se_cmd *cmd = req->end_io_data;
 	struct pscsi_plugin_task *pt = cmd->priv;
 
-	pt->pscsi_result = req->errors;
+	pt->pscsi_result = scsi_req(req)->result;
 	pt->pscsi_resid = scsi_req(req)->resid_len;
 
 	cmd->scsi_status = status_byte(pt->pscsi_result) << 1;
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 4b72fdf67548..91b72c1560ef 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -243,9 +243,9 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	req->cmd_len = COMMAND_SIZE(INQUIRY);
 
 	blk_execute_rq(rq->q, NULL, rq, 1);
-	if (rq->errors) {
+	if (req->result) {
 		pr_err("pNFS: INQUIRY 0x83 failed with: %x\n",
-			rq->errors);
+			req->result);
 		goto out_put_request;
 	}
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 2f51c1724b5a..6980ca322074 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -88,7 +88,7 @@ static inline bool ata_pm_request(struct request *rq)
 		 ide_req(rq)->type == ATA_PRIV_PM_RESUME);
 }
 
-/* Error codes returned in rq->errors to the higher part of the driver. */
+/* Error codes returned in result to the higher part of the driver. */
 enum {
 	IDE_DRV_ERROR_GENERAL	= 101,
 	IDE_DRV_ERROR_FILEMARK	= 102,
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index 7c583a0f363a..f0c76f9dc285 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -9,6 +9,7 @@ struct scsi_request {
 	unsigned char	__cmd[BLK_MAX_CDB];
 	unsigned char	*cmd;
 	unsigned short	cmd_len;
+	int		result;
 	unsigned int	sense_len;
 	unsigned int	resid_len;	/* residual count */
 	int		retries;
-- 
2.11.0
