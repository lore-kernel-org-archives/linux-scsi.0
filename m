From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] block: allocate block_pc data separate from struct request
Date: Fri, 17 Apr 2015 22:37:22 +0200
Message-ID: <1429303042-12078-8-git-send-email-hch@lst.de>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbDQUio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 16:38:44 -0400
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

Don't bloat struct request with BLOCK_PC specific fields.

WIP, breaks dm BLOCK_PC passthrough and the old IDE driver for now.
---
 block/blk-core.c                            | 23 ++++++---
 block/blk-exec.c                            | 17 -------
 block/blk-mq.c                              |  4 --
 block/bsg-lib.c                             | 10 ++--
 block/bsg.c                                 | 31 ++++--------
 block/scsi_ioctl.c                          | 68 +++++++++++--------------
 drivers/ata/libata-scsi.c                   |  2 +-
 drivers/block/pktcdvd.c                     |  9 ++--
 drivers/block/virtio_blk.c                  |  9 ++--
 drivers/cdrom/cdrom.c                       | 36 +++++++------
 drivers/md/dm.c                             |  4 ++
 drivers/message/fusion/mptsas.c             |  4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  | 78 ++++++++++++++---------------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 52 +++++++++----------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 38 ++++++++------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 43 ++++++++--------
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  4 +-
 drivers/scsi/osd/osd_initiator.c            | 32 ++++++------
 drivers/scsi/osst.c                         | 10 ++--
 drivers/scsi/qla2xxx/qla_bsg.c              |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  6 ++-
 drivers/scsi/qla2xxx/qla_mr.c               |  2 +-
 drivers/scsi/scsi_error.c                   | 22 ++++----
 drivers/scsi/scsi_lib.c                     | 22 ++++----
 drivers/scsi/scsi_transport_fc.c            | 10 ++--
 drivers/scsi/sd.c                           | 47 ++---------------
 drivers/scsi/sg.c                           | 21 +++-----
 drivers/scsi/st.c                           | 21 ++++----
 drivers/target/target_core_pscsi.c          | 14 +++---
 include/linux/blkdev.h                      | 27 ++++++----
 include/linux/blktrace_api.h                |  4 +-
 include/scsi/scsi_cmnd.h                    |  2 +-
 kernel/trace/blktrace.c                     | 11 ++--
 34 files changed, 319 insertions(+), 370 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2e5020f..5d78a85 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -105,8 +105,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->__sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
-	rq->cmd = rq->__cmd;
-	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
@@ -149,7 +147,7 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		printk(KERN_INFO "  cdb: ");
 		for (bit = 0; bit < BLK_MAX_CDB; bit++)
-			printk("%02x ", rq->cmd[bit]);
+			printk("%02x ", rq->block_pc->cmd[bit]);
 		printk("\n");
 	}
 }
@@ -1253,8 +1251,6 @@ struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 	if (IS_ERR(rq))
 		return rq;
 
-	blk_rq_set_block_pc(rq);
-
 	for_each_bio(bio) {
 		struct bio *bounce_bio = bio;
 		int ret;
@@ -1274,15 +1270,24 @@ EXPORT_SYMBOL(blk_make_request);
 /**
  * blk_rq_set_block_pc - initialize a request to type BLOCK_PC
  * @rq:		request to be initialized
+ * @cmd_len:	length of the CDB
+ * @gfp:	kmalloc flags
  *
  */
-void blk_rq_set_block_pc(struct request *rq)
+int blk_rq_set_block_pc(struct request *rq, unsigned short cmd_len,
+		u8 *sense, gfp_t gfp)
 {
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->__data_len = 0;
 	rq->__sector = (sector_t) -1;
 	rq->bio = rq->biotail = NULL;
-	memset(rq->__cmd, 0, sizeof(rq->__cmd));
+
+	rq->block_pc = kzalloc(sizeof(*rq->block_pc) + cmd_len, gfp);
+	if (!rq->block_pc)
+		return -ENOMEM;
+	rq->block_pc->cmd_len = cmd_len;
+	rq->block_pc->sense = sense;
+	return 0;
 }
 EXPORT_SYMBOL(blk_rq_set_block_pc);
 
@@ -1379,6 +1384,10 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(!q))
 		return;
 
+	/* could also be other type-specific data */
+	if (req->block_pc)
+		kfree(req->block_pc);
+
 	if (q->mq_ops) {
 		blk_mq_free_request(req);
 		return;
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 3fec8a2..94e909e 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -10,11 +10,6 @@
 
 #include "blk.h"
 
-/*
- * for max sense size
- */
-#include <scsi/scsi_cmnd.h>
-
 /**
  * blk_end_sync_rq - executes a completion event on a request
  * @rq: request to complete
@@ -100,16 +95,9 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 		   struct request *rq, int at_head)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
-	char sense[SCSI_SENSE_BUFFERSIZE];
 	int err = 0;
 	unsigned long hang_check;
 
-	if (!rq->sense) {
-		memset(sense, 0, sizeof(sense));
-		rq->sense = sense;
-		rq->sense_len = 0;
-	}
-
 	rq->end_io_data = &wait;
 	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
 
@@ -123,11 +111,6 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 	if (rq->errors)
 		err = -EIO;
 
-	if (rq->sense == sense)	{
-		rq->sense = NULL;
-		rq->sense_len = 0;
-	}
-
 	return err;
 }
 EXPORT_SYMBOL(blk_execute_rq);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ade8a2d..715e3c0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -210,12 +210,8 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	/* tag was already set */
 	rq->errors = 0;
 
-	rq->cmd = rq->__cmd;
-
 	rq->extra_len = 0;
-	rq->sense_len = 0;
 	rq->resid_len = 0;
-	rq->sense = NULL;
 
 	INIT_LIST_HEAD(&rq->timeout_list);
 	rq->timeout = 0;
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 650f427..6b73dca 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -59,9 +59,9 @@ void bsg_job_done(struct bsg_job *job, int result,
 	err = job->req->errors = result;
 	if (err < 0)
 		/* we're only returning the result field in the reply */
-		job->req->sense_len = sizeof(u32);
+		job->req->block_pc->sense_len = sizeof(u32);
 	else
-		job->req->sense_len = job->reply_len;
+		job->req->block_pc->sense_len = job->reply_len;
 	/* we assume all request payload was transferred, residual == 0 */
 	req->resid_len = 0;
 
@@ -124,9 +124,9 @@ static int bsg_create_job(struct device *dev, struct request *req)
 	job->req = req;
 	if (q->bsg_job_size)
 		job->dd_data = (void *)&job[1];
-	job->request = req->cmd;
-	job->request_len = req->cmd_len;
-	job->reply = req->sense;
+	job->request = req->block_pc->cmd;
+	job->request_len = req->block_pc->cmd_len;
+	job->reply = req->block_pc->sense;
 	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
 						 * allocated */
 	if (req->bio) {
diff --git a/block/bsg.c b/block/bsg.c
index d214e92..ebf0dc1 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -140,18 +140,13 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, struct bsg_device *bd,
 				fmode_t has_write_perm)
 {
-	if (hdr->request_len > BLK_MAX_CDB) {
-		rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
-		if (!rq->cmd)
-			return -ENOMEM;
-	}
-
-	if (copy_from_user(rq->cmd, (void __user *)(unsigned long)hdr->request,
+	if (copy_from_user(rq->block_pc->cmd,
+			   (void __user *)(unsigned long)hdr->request,
 			   hdr->request_len))
 		return -EFAULT;
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(rq->cmd, has_write_perm))
+		if (blk_verify_command(rq->block_pc->cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -159,8 +154,6 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->request_len;
-
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
@@ -236,7 +229,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 	if (IS_ERR(rq))
 		return rq;
-	blk_rq_set_block_pc(rq);
+
+	ret = blk_rq_set_block_pc(rq, hdr->request_len, sense, GFP_KERNEL);
+	if (ret)
+		goto out;
 
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
 	if (ret)
@@ -280,13 +276,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 			goto out;
 	}
 
-	rq->sense = sense;
-	rq->sense_len = 0;
-
 	return rq;
 out:
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
@@ -407,12 +398,12 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		hdr->info |= SG_INFO_CHECK;
 	hdr->response_len = 0;
 
-	if (rq->sense_len && hdr->response) {
+	if (rq->block_pc->sense_len && hdr->response) {
 		int len = min_t(unsigned int, hdr->max_response_len,
-					rq->sense_len);
+					rq->block_pc->sense_len);
 
 		ret = copy_to_user((void __user *)(unsigned long)hdr->response,
-				   rq->sense, len);
+				   rq->block_pc->sense, len);
 		if (!ret)
 			hdr->response_len = len;
 		else
@@ -439,8 +430,6 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		ret = rq->errors;
 
 	blk_rq_unmap_user(bio);
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
 	blk_put_request(rq);
 
 	return ret;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 55b6f15..62f4e16 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -227,16 +227,14 @@ EXPORT_SYMBOL(blk_verify_command);
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, fmode_t mode)
 {
-	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
+	if (copy_from_user(rq->block_pc->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, mode & FMODE_WRITE))
+	if (blk_verify_command(rq->block_pc->cmd, mode & FMODE_WRITE))
 		return -EPERM;
 
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->cmd_len;
-
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
@@ -267,10 +265,11 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->resid = rq->resid_len;
 	hdr->sb_len_wr = 0;
 
-	if (rq->sense_len && hdr->sbp) {
-		int len = min((unsigned int) hdr->mx_sb_len, rq->sense_len);
+	if (rq->block_pc->sense_len && hdr->sbp) {
+		int len = min((unsigned int) hdr->mx_sb_len,
+				rq->block_pc->sense_len);
 
-		if (!copy_to_user(hdr->sbp, rq->sense, len))
+		if (!copy_to_user(hdr->sbp, rq->block_pc->sense, len))
 			hdr->sb_len_wr = len;
 		else
 			ret = -EFAULT;
@@ -291,7 +290,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	int writing = 0;
 	int at_head = 0;
 	struct request *rq;
-	char sense[SCSI_SENSE_BUFFERSIZE];
 	struct bio *bio;
 
 	if (hdr->interface_id != 'S')
@@ -318,17 +316,14 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	blk_rq_set_block_pc(rq);
 
-	if (hdr->cmd_len > BLK_MAX_CDB) {
-		rq->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
-		if (!rq->cmd)
-			goto out_put_request;
-	}
+	ret = blk_rq_set_block_pc(rq, hdr->cmd_len, NULL, GFP_KERNEL);
+	if (ret)
+		goto out_put_request;
 
 	ret = -EFAULT;
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode))
-		goto out_free_cdb;
+		goto out_put_request;
 
 	ret = 0;
 	if (hdr->iovec_count) {
@@ -339,7 +334,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 				   hdr->dxferp, hdr->iovec_count,
 				   0, &iov, &i);
 		if (ret < 0)
-			goto out_free_cdb;
+			goto out_put_request;
 
 		/* SG_IO howto says that the shorter of the two wins */
 		iov_iter_truncate(&i, hdr->dxfer_len);
@@ -351,12 +346,9 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 				      GFP_KERNEL);
 
 	if (ret)
-		goto out_free_cdb;
+		goto out_put_request;
 
 	bio = rq->bio;
-	memset(sense, 0, sizeof(sense));
-	rq->sense = sense;
-	rq->sense_len = 0;
 	rq->retries = 0;
 
 	start_time = jiffies;
@@ -371,9 +363,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	ret = blk_complete_sghdr_rq(rq, hdr, bio);
 
-out_free_cdb:
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
 out_put_request:
 	blk_put_request(rq);
 	return ret;
@@ -449,22 +438,23 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
 	}
-	blk_rq_set_block_pc(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
+	err = blk_rq_set_block_pc(rq, cmdlen, sense, GFP_KERNEL);
+	if (err)
+		goto error;
 
 	/*
 	 * get command and data to send to device, if any
 	 */
 	err = -EFAULT;
-	rq->cmd_len = cmdlen;
-	if (copy_from_user(rq->cmd, sic->data, cmdlen))
+	if (copy_from_user(rq->block_pc->cmd, sic->data, cmdlen))
 		goto error;
 
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(rq->cmd, mode & FMODE_WRITE);
+	err = blk_verify_command(rq->block_pc->cmd, mode & FMODE_WRITE);
 	if (err)
 		goto error;
 
@@ -500,18 +490,14 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		goto error;
 	}
 
-	memset(sense, 0, sizeof(sense));
-	rq->sense = sense;
-	rq->sense_len = 0;
-
 	blk_execute_rq(q, disk, rq, 0);
 
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
-		if (rq->sense_len && rq->sense) {
-			bytes = (OMAX_SB_LEN > rq->sense_len) ?
-				rq->sense_len : OMAX_SB_LEN;
-			if (copy_to_user(sic->data, rq->sense, bytes))
+		if (rq->block_pc->sense_len) {
+			bytes = (OMAX_SB_LEN > rq->block_pc->sense_len) ?
+				rq->block_pc->sense_len : OMAX_SB_LEN;
+			if (copy_to_user(sic->data, rq->block_pc->sense, bytes))
 				err = -EFAULT;
 		}
 	} else {
@@ -539,14 +525,16 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	blk_rq_set_block_pc(rq);
+	err = blk_rq_set_block_pc(rq, 6, NULL, GFP_KERNEL);
+	if (err)
+		goto out_put_request;
+
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
-	rq->cmd[0] = cmd;
-	rq->cmd[4] = data;
-	rq->cmd_len = 6;
+	rq->block_pc->cmd[0] = cmd;
+	rq->block_pc->cmd[4] = data;
 	err = blk_execute_rq(q, bd_disk, rq, 0);
+out_put_request:
 	blk_put_request(rq);
-
 	return err;
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3131adc..d8cb4ec 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1143,7 +1143,7 @@ static int atapi_drain_needed(struct request *rq)
 	if (!blk_rq_bytes(rq) || (rq->cmd_flags & REQ_WRITE))
 		return 0;
 
-	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
+	return atapi_cmd_type(rq->block_pc->cmd[0]) == ATAPI_MISC;
 }
 
 static int ata_scsi_dev_config(struct scsi_device *sdev,
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628da..51f919d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -706,7 +706,11 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			     WRITE : READ, __GFP_WAIT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	blk_rq_set_block_pc(rq);
+
+	ret = blk_rq_set_block_pc(rq, COMMAND_SIZE(cgc->cmd[0]), NULL,
+			GFP_KERNEL);
+	if (ret)
+		goto out;
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
@@ -715,8 +719,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			goto out;
 	}
 
-	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
-	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	memcpy(rq->block_pc->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 
 	rq->timeout = 60*HZ;
 	if (cgc->quiet)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index d4d05f0..cd3bcc0 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -90,7 +90,8 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	 * inhdr with additional status information.
 	 */
 	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
-		sg_init_one(&cmd, vbr->req->cmd, vbr->req->cmd_len);
+		sg_init_one(&cmd, vbr->req->block_pc->cmd,
+				vbr->req->block_pc->cmd_len);
 		sgs[num_out++] = &cmd;
 	}
 
@@ -102,7 +103,8 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	}
 
 	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
-		sg_init_one(&sense, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
+		sg_init_one(&sense, vbr->req->block_pc->sense,
+				SCSI_SENSE_BUFFERSIZE);
 		sgs[num_out + num_in++] = &sense;
 		sg_init_one(&inhdr, &vbr->in_hdr, sizeof(vbr->in_hdr));
 		sgs[num_out + num_in++] = &inhdr;
@@ -122,7 +124,8 @@ static inline void virtblk_request_done(struct request *req)
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
 		req->resid_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.residual);
-		req->sense_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
+		req->block_pc->sense_len =
+			virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
 		req->errors = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.errors);
 	} else if (req->cmd_type == REQ_TYPE_DRV_PRIV) {
 		req->errors = (error != 0);
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 5d28a45..7a5672a 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2160,6 +2160,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			       int lba, int nframes)
 {
 	struct request_queue *q = cdi->disk->queue;
+	struct request_sense sense;
 	struct request *rq;
 	struct bio *bio;
 	unsigned int len;
@@ -2184,7 +2185,14 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			ret = PTR_ERR(rq);
 			break;
 		}
-		blk_rq_set_block_pc(rq);
+
+		memset(&sense, 0, sizeof(sense));
+
+		ret = blk_rq_set_block_pc(rq, 10, (u8 *)&sense, GFP_KERNEL);
+		if (ret) {
+			blk_put_request(rq);
+			break;
+		}
 
 		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
 		if (ret) {
@@ -2192,25 +2200,23 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			break;
 		}
 
-		rq->cmd[0] = GPCMD_READ_CD;
-		rq->cmd[1] = 1 << 2;
-		rq->cmd[2] = (lba >> 24) & 0xff;
-		rq->cmd[3] = (lba >> 16) & 0xff;
-		rq->cmd[4] = (lba >>  8) & 0xff;
-		rq->cmd[5] = lba & 0xff;
-		rq->cmd[6] = (nr >> 16) & 0xff;
-		rq->cmd[7] = (nr >>  8) & 0xff;
-		rq->cmd[8] = nr & 0xff;
-		rq->cmd[9] = 0xf8;
-
-		rq->cmd_len = 12;
+		rq->block_pc->cmd[0] = GPCMD_READ_CD;
+		rq->block_pc->cmd[1] = 1 << 2;
+		rq->block_pc->cmd[2] = (lba >> 24) & 0xff;
+		rq->block_pc->cmd[3] = (lba >> 16) & 0xff;
+		rq->block_pc->cmd[4] = (lba >>  8) & 0xff;
+		rq->block_pc->cmd[5] = lba & 0xff;
+		rq->block_pc->cmd[6] = (nr >> 16) & 0xff;
+		rq->block_pc->cmd[7] = (nr >>  8) & 0xff;
+		rq->block_pc->cmd[8] = nr & 0xff;
+		rq->block_pc->cmd[9] = 0xf8;
+
 		rq->timeout = 60 * HZ;
 		bio = rq->bio;
 
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
-			struct request_sense *s = rq->sense;
 			ret = -EIO;
-			cdi->last_sense = s->sense_key;
+			cdi->last_sense = sense.sense_key;
 		}
 
 		if (blk_rq_unmap_user(bio))
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8001fe9..17df896 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1069,6 +1069,7 @@ static void dm_end_request(struct request *clone, int error)
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
+#if 0
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		rq->errors = clone->errors;
 		rq->resid_len = clone->resid_len;
@@ -1081,6 +1082,7 @@ static void dm_end_request(struct request *clone, int error)
 			 */
 			rq->sense_len = clone->sense_len;
 	}
+#endif
 
 	free_rq_clone(clone);
 	blk_end_request_all(rq, error);
@@ -1773,9 +1775,11 @@ static int setup_clone(struct request *clone, struct request *rq,
 	if (r)
 		return r;
 
+#if 0
 	clone->cmd = rq->cmd;
 	clone->cmd_len = rq->cmd_len;
 	clone->sense = rq->sense;
+#endif
 	clone->end_io = end_clone_request;
 	clone->end_io_data = tio;
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5bdaae1..34127ac 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2321,8 +2321,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		SmpPassthroughReply_t *smprep;
 
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
-		memcpy(req->sense, smprep, sizeof(*smprep));
-		req->sense_len = sizeof(*smprep);
+		memcpy(req->block_pc->sense, smprep, sizeof(*smprep));
+		req->block_pc->sense_len = sizeof(*smprep);
 		req->resid_len = 0;
 		rsp->resid_len -= smprep->ResponseDataLength;
 	} else {
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 854b568..9d2d781 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -107,7 +107,7 @@ static int realloc_buffer(struct alua_dh_data *h, unsigned len)
 }
 
 static struct request *get_alua_req(struct scsi_device *sdev,
-				    void *buffer, unsigned buflen, int rw)
+		struct alua_dh_data *h, unsigned buflen, int rw)
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
@@ -119,9 +119,16 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 			    "%s: blk_get_request failed\n", __func__);
 		return NULL;
 	}
-	blk_rq_set_block_pc(rq);
 
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
+	memset(h->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	h->senselen = 0;
+
+	if (blk_rq_set_block_pc(rq, 16, h->sense, GFP_NOIO)) {
+		blk_put_request(rq);
+		return NULL;
+	}
+
+	if (buflen && blk_rq_map_kern(q, rq, h->buff, buflen, GFP_NOIO)) {
 		blk_put_request(rq);
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: blk_rq_map_kern failed\n", __func__);
@@ -145,27 +152,23 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	struct request *rq;
 	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
+	rq = get_alua_req(sdev, h, h->bufflen, READ);
 	if (!rq)
 		goto done;
 
 	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 1;
-	rq->cmd[2] = 0x83;
-	rq->cmd[4] = h->bufflen;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->block_pc->cmd[0] = INQUIRY;
+	rq->block_pc->cmd[1] = 1;
+	rq->block_pc->cmd[2] = 0x83;
+	rq->block_pc->cmd[4] = h->bufflen;
+	rq->block_pc->cmd_len = COMMAND_SIZE(INQUIRY);
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: evpd inquiry failed with %x\n",
 			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
+		h->senselen = rq->block_pc->sense_len;
 		err = SCSI_DH_IO;
 	}
 	blk_put_request(rq);
@@ -183,32 +186,28 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 	struct request *rq;
 	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
+	rq = get_alua_req(sdev, h, h->bufflen, READ);
 	if (!rq)
 		goto done;
 
 	/* Prepare the command. */
-	rq->cmd[0] = MAINTENANCE_IN;
+	rq->block_pc->cmd[0] = MAINTENANCE_IN;
 	if (rtpg_ext_hdr_req)
-		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
+		rq->block_pc->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
-		rq->cmd[1] = MI_REPORT_TARGET_PGS;
-	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
-	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
-	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
-	rq->cmd[9] = h->bufflen & 0xff;
-	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+		rq->block_pc->cmd[1] = MI_REPORT_TARGET_PGS;
+	rq->block_pc->cmd[6] = (h->bufflen >> 24) & 0xff;
+	rq->block_pc->cmd[7] = (h->bufflen >> 16) & 0xff;
+	rq->block_pc->cmd[8] = (h->bufflen >>  8) & 0xff;
+	rq->block_pc->cmd[9] = h->bufflen & 0xff;
+	rq->block_pc->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (err == -EIO) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg failed with %x\n",
 			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
+		h->senselen = rq->block_pc->sense_len;
 		err = SCSI_DH_IO;
 	}
 	blk_put_request(rq);
@@ -237,7 +236,7 @@ static void stpg_endio(struct request *req, int error)
 		goto done;
 	}
 
-	if (req->sense_len > 0) {
+	if (req->block_pc->sense_len > 0) {
 		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					   &sense_hdr);
 		if (!err) {
@@ -293,22 +292,19 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	h->buff[6] = (h->group_id >> 8) & 0xff;
 	h->buff[7] = h->group_id & 0xff;
 
-	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
+	rq = get_alua_req(sdev, h, stpg_len, WRITE);
 	if (!rq)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	/* Prepare the command. */
-	rq->cmd[0] = MAINTENANCE_OUT;
-	rq->cmd[1] = MO_SET_TARGET_PGS;
-	rq->cmd[6] = (stpg_len >> 24) & 0xff;
-	rq->cmd[7] = (stpg_len >> 16) & 0xff;
-	rq->cmd[8] = (stpg_len >>  8) & 0xff;
-	rq->cmd[9] = stpg_len & 0xff;
-	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
+	rq->block_pc->cmd[0] = MAINTENANCE_OUT;
+	rq->block_pc->cmd[1] = MO_SET_TARGET_PGS;
+	rq->block_pc->cmd[6] = (stpg_len >> 24) & 0xff;
+	rq->block_pc->cmd[7] = (stpg_len >> 16) & 0xff;
+	rq->block_pc->cmd[8] = (stpg_len >>  8) & 0xff;
+	rq->block_pc->cmd[9] = stpg_len & 0xff;
+	rq->block_pc->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
+
 	rq->end_io_data = h;
 
 	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6ed1caa..a009bf2 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -267,8 +267,8 @@ out:
  * Uses data and sense buffers in hardware handler context structure and
  * assumes serial servicing of commands, both issuance and completion.
  */
-static struct request *get_req(struct scsi_device *sdev, int cmd,
-				unsigned char *buffer)
+static struct request *get_req(struct scsi_device *sdev,
+		struct clariion_dh_data *csdev, int cmd)
 {
 	struct request *rq;
 	int len = 0;
@@ -280,25 +280,31 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 		return NULL;
 	}
 
-	blk_rq_set_block_pc(rq);
-	rq->cmd_len = COMMAND_SIZE(cmd);
-	rq->cmd[0] = cmd;
+	memset(csdev->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	csdev->senselen = 0;
+
+	if (blk_rq_set_block_pc(rq, COMMAND_SIZE(cmd),
+			csdev->sense, GFP_NOIO)) {
+		blk_put_request(rq);
+		return NULL;
+	}
+	rq->block_pc->cmd[0] = cmd;
 
 	switch (cmd) {
 	case MODE_SELECT:
 		len = sizeof(short_trespass);
-		rq->cmd[1] = 0x10;
-		rq->cmd[4] = len;
+		rq->block_pc->cmd[1] = 0x10;
+		rq->block_pc->cmd[4] = len;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
-		rq->cmd[1] = 0x10;
-		rq->cmd[8] = len;
+		rq->block_pc->cmd[1] = 0x10;
+		rq->block_pc->cmd[8] = len;
 		break;
 	case INQUIRY:
 		len = CLARIION_BUFFER_SIZE;
-		rq->cmd[4] = len;
-		memset(buffer, 0, len);
+		rq->block_pc->cmd[4] = len;
+		memset(csdev->buffer, 0, len);
 		break;
 	default:
 		BUG_ON(1);
@@ -310,7 +316,7 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 	rq->timeout = CLARIION_TIMEOUT;
 	rq->retries = CLARIION_RETRIES;
 
-	if (blk_rq_map_kern(rq->q, rq, buffer, len, GFP_NOIO)) {
+	if (blk_rq_map_kern(rq->q, rq, csdev->buffer, len, GFP_NOIO)) {
 		blk_put_request(rq);
 		return NULL;
 	}
@@ -321,20 +327,16 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 static int send_inquiry_cmd(struct scsi_device *sdev, int page,
 			    struct clariion_dh_data *csdev)
 {
-	struct request *rq = get_req(sdev, INQUIRY, csdev->buffer);
+	struct request *rq = get_req(sdev, csdev, INQUIRY);
 	int err;
 
 	if (!rq)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	rq->sense = csdev->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = csdev->senselen = 0;
-
-	rq->cmd[0] = INQUIRY;
+	rq->block_pc->cmd[0] = INQUIRY;
 	if (page != 0) {
-		rq->cmd[1] = 1;
-		rq->cmd[2] = page;
+		rq->block_pc->cmd[1] = 1;
+		rq->block_pc->cmd[2] = page;
 	}
 	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
 	if (err == -EIO) {
@@ -342,7 +344,7 @@ static int send_inquiry_cmd(struct scsi_device *sdev, int page,
 			    "%s: failed to send %s INQUIRY: %x\n",
 			    CLARIION_NAME, page?"EVPD":"standard",
 			    rq->errors);
-		csdev->senselen = rq->sense_len;
+		csdev->senselen = rq->block_pc->sense_len;
 		err = SCSI_DH_IO;
 	}
 
@@ -376,17 +378,13 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	rq = get_req(sdev, cmd, csdev->buffer);
+	rq = get_req(sdev, csdev, cmd);
 	if (!rq)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	rq->sense = csdev->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = csdev->senselen = 0;
-
 	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
 	if (err == -EIO) {
-		if (rq->sense_len) {
+		if (rq->block_pc->sense_len) {
 			err = trespass_endio(sdev, csdev->sense);
 		} else {
 			sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 485d995..06f2c36 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -119,19 +119,21 @@ retry:
 	if (IS_ERR(req))
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	blk_rq_set_block_pc(req);
+	memset(h->sense, 0, SCSI_SENSE_BUFFERSIZE);
+
+	ret = blk_rq_set_block_pc(req, 16, h->sense, GFP_NOIO);
+	if (ret)
+		goto out;
+
 	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			  REQ_FAILFAST_DRIVER;
-	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
-	req->cmd[0] = TEST_UNIT_READY;
+	req->block_pc->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
+	req->block_pc->cmd[0] = TEST_UNIT_READY;
 	req->timeout = HP_SW_TIMEOUT;
-	req->sense = h->sense;
-	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	req->sense_len = 0;
 
 	ret = blk_execute_rq(req->q, NULL, req, 1);
 	if (ret == -EIO) {
-		if (req->sense_len > 0) {
+		if (req->block_pc->sense_len > 0) {
 			ret = tur_done(sdev, h->sense);
 		} else {
 			sdev_printk(KERN_WARNING, sdev,
@@ -152,8 +154,8 @@ retry:
 		ret = SCSI_DH_OK;
 	}
 
+out:
 	blk_put_request(req);
-
 	return ret;
 }
 
@@ -212,7 +214,7 @@ static void start_stop_endio(struct request *req, int error)
 		goto done;
 	}
 
-	if (req->sense_len > 0) {
+	if (req->block_pc->sense_len > 0) {
 		err = start_done(h->sdev, h->sense);
 		if (err == SCSI_DH_RETRY) {
 			err = SCSI_DH_IO;
@@ -249,16 +251,20 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	if (IS_ERR(req))
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
-	blk_rq_set_block_pc(req);
+	memset(h->sense, 0, SCSI_SENSE_BUFFERSIZE);
+
+	if (blk_rq_set_block_pc(req, 16, h->sense, GFP_ATOMIC) < 0) {
+		blk_put_request(req);
+		return SCSI_DH_RES_TEMP_UNAVAIL;
+	}
+		
 	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			  REQ_FAILFAST_DRIVER;
-	req->cmd_len = COMMAND_SIZE(START_STOP);
-	req->cmd[0] = START_STOP;
-	req->cmd[4] = 1;	/* Start spin cycle */
+	req->block_pc->cmd_len = COMMAND_SIZE(START_STOP);
+	req->block_pc->cmd[0] = START_STOP;
+	req->block_pc->cmd[4] = 1;	/* Start spin cycle */
 	req->timeout = HP_SW_TIMEOUT;
-	req->sense = h->sense;
-	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	req->sense_len = 0;
+
 	req->end_io_data = h;
 
 	blk_execute_rq_nowait(req->q, NULL, req, 1, start_stop_endio);
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b46ace3..78552ae 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -266,7 +266,7 @@ static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
 }
 
 static struct request *get_rdac_req(struct scsi_device *sdev,
-			void *buffer, unsigned buflen, int rw)
+		struct rdac_dh_data *h, void *buffer, unsigned buflen, int rw)
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
@@ -278,7 +278,12 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 				"get_rdac_req: blk_get_request failed.\n");
 		return NULL;
 	}
-	blk_rq_set_block_pc(rq);
+
+	memset(h->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	if (blk_rq_set_block_pc(rq, 16, h->sense, GFP_NOIO)) {
+		blk_put_request(rq);
+		return NULL;
+	}
 
 	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
 		blk_put_request(rq);
@@ -336,24 +341,20 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 	}
 
 	/* get request for block layer packet command */
-	rq = get_rdac_req(sdev, &h->ctlr->mode_select, data_size, WRITE);
+	rq = get_rdac_req(sdev, h, &h->ctlr->mode_select, data_size, WRITE);
 	if (!rq)
 		return NULL;
 
 	/* Prepare the command. */
 	if (h->ctlr->use_ms10) {
-		rq->cmd[0] = MODE_SELECT_10;
-		rq->cmd[7] = data_size >> 8;
-		rq->cmd[8] = data_size & 0xff;
+		rq->block_pc->cmd[0] = MODE_SELECT_10;
+		rq->block_pc->cmd[7] = data_size >> 8;
+		rq->block_pc->cmd[8] = data_size & 0xff;
 	} else {
-		rq->cmd[0] = MODE_SELECT;
-		rq->cmd[4] = data_size;
+		rq->block_pc->cmd[0] = MODE_SELECT;
+		rq->block_pc->cmd[4] = data_size;
 	}
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
+	rq->block_pc->cmd_len = COMMAND_SIZE(rq->block_pc->cmd[0]);
 
 	return rq;
 }
@@ -409,20 +410,16 @@ static int submit_inquiry(struct scsi_device *sdev, int page_code,
 	struct request_queue *q = sdev->request_queue;
 	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 
-	rq = get_rdac_req(sdev, &h->inq, len, READ);
+	rq = get_rdac_req(sdev, h, &h->inq, len, READ);
 	if (!rq)
 		goto done;
 
 	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 1;
-	rq->cmd[2] = page_code;
-	rq->cmd[4] = len;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
+	rq->block_pc->cmd[0] = INQUIRY;
+	rq->block_pc->cmd[1] = 1;
+	rq->block_pc->cmd[2] = page_code;
+	rq->block_pc->cmd[4] = len;
+	rq->block_pc->cmd_len = COMMAND_SIZE(INQUIRY);
 
 	err = blk_execute_rq(q, NULL, rq, 1);
 	if (err == -EIO)
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index ff2500a..672597c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -2094,8 +2094,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    ioc->name, __func__,
 		    le16_to_cpu(mpi_reply->ResponseDataLength)));
 
-		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
-		req->sense_len = sizeof(*mpi_reply);
+		memcpy(req->block_pc->sense, mpi_reply, sizeof(*mpi_reply));
+		req->block_pc->sense_len = sizeof(*mpi_reply);
 		req->resid_len = 0;
 		rsp->resid_len -=
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index efb98af..b558442 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -2054,8 +2054,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    ioc->name, __func__,
 		    le16_to_cpu(mpi_reply->ResponseDataLength)));
 
-		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
-		req->sense_len = sizeof(*mpi_reply);
+		memcpy(req->block_pc->sense, mpi_reply, sizeof(*mpi_reply));
+		req->block_pc->sense_len = sizeof(*mpi_reply);
 		req->resid_len = 0;
 		rsp->resid_len -=
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0cccd60..055714d 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -480,7 +480,7 @@ static void _set_error_resid(struct osd_request *or, struct request *req,
 {
 	or->async_error = error;
 	or->req_errors = req->errors ? : error;
-	or->sense_len = req->sense_len;
+	or->sense_len = req->block_pc->sense_len;
 	if (or->out.req)
 		or->out.residual = or->out.req->resid_len;
 	if (or->in.req)
@@ -1563,16 +1563,8 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
 {
 	if (oii->bio)
 		return blk_make_request(q, oii->bio, flags);
-	else {
-		struct request *req;
-
-		req = blk_get_request(q, has_write ? WRITE : READ, flags);
-		if (IS_ERR(req))
-			return req;
-
-		blk_rq_set_block_pc(req);
-		return req;
-	}
+	else 
+		return blk_get_request(q, has_write ? WRITE : READ, flags);
 }
 
 static int _init_blk_request(struct osd_request *or,
@@ -1590,13 +1582,22 @@ static int _init_blk_request(struct osd_request *or,
 		goto out;
 	}
 
+	/* 
+	 * XXX: allocating max size here to avoid having to reorder all
+	 * the code below.
+	 */
+	ret = blk_rq_set_block_pc(req, 255, req->block_pc->sense, flags);
+	if (ret) {
+		blk_put_request(req);
+		goto out;
+	}
+
 	or->request = req;
 	req->cmd_flags |= REQ_QUIET;
 
 	req->timeout = or->timeout;
 	req->retries = or->retries;
-	req->sense = or->sense;
-	req->sense_len = 0;
+	req->block_pc->sense_len = 0;
 
 	if (has_out) {
 		or->out.req = req;
@@ -1608,7 +1609,6 @@ static int _init_blk_request(struct osd_request *or,
 				ret = PTR_ERR(req);
 				goto out;
 			}
-			blk_rq_set_block_pc(req);
 			or->in.req = or->request->next_rq = req;
 		}
 	} else if (has_in)
@@ -1695,8 +1695,8 @@ int osd_finalize_request(struct osd_request *or,
 
 	osd_sec_sign_cdb(&or->cdb, cap_key);
 
-	or->request->cmd = or->cdb.buff;
-	or->request->cmd_len = _osd_req_cdb_len(or);
+	memcpy(or->request->block_pc->cmd, or->cdb.buff, _osd_req_cdb_len(or));
+	or->request->block_pc->cmd_len = _osd_req_cdb_len(or);
 
 	return 0;
 }
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 5033223..79b57fe 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -367,7 +367,9 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
-	blk_rq_set_block_pc(req);
+	err = blk_rq_set_block_pc(req, cmd_len, SRpnt->sense, GFP_KERNEL);
+	if (err)
+		goto free_req;
 	req->cmd_flags |= REQ_QUIET;
 
 	SRpnt->bio = NULL;
@@ -404,11 +406,7 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 			goto free_req;
 	}
 
-	req->cmd_len = cmd_len;
-	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = SRpnt->sense;
-	req->sense_len = 0;
+	memcpy(req->block_pc->cmd, cmd, cmd_len);
 	req->timeout = timeout;
 	req->retries = retries;
 	req->end_io_data = SRpnt;
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2e2bb6f..f6bf256 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -909,7 +909,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 	    sizeof(response) + sizeof(uint8_t);
-	fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+	fw_sts_ptr = ((uint8_t *)bsg_job->req->block_pc->sense) +
 	    sizeof(struct fc_bsg_reply);
 	memcpy(fw_sts_ptr, response, sizeof(response));
 	fw_sts_ptr += sizeof(response);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6dc14cd..724eaa4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1418,7 +1418,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				pkt)->total_byte_count));
-			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+			fw_sts_ptr = ((uint8_t*)bsg_job->req->block_pc->sense) +
+					sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		else {
@@ -1432,7 +1433,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
 			bsg_job->reply->reply_payload_rcv_len = 0;
-			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+			fw_sts_ptr = ((uint8_t*)bsg_job->req->block_pc->sense) +
+					sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6d190b4..2ac1886 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2242,7 +2242,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		memcpy(fstatus.reserved_3,
 		    pkt->reserved_2, 20 * sizeof(uint8_t));
 
-		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+		fw_sts_ptr = ((uint8_t *)bsg_job->req->block_pc->sense) +
 		    sizeof(struct fc_bsg_reply);
 
 		memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c95a4e9..85d659e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1968,16 +1968,18 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	if (IS_ERR(req))
 		return;
 
-	blk_rq_set_block_pc(req);
-
-	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
-	req->cmd[1] = 0;
-	req->cmd[2] = 0;
-	req->cmd[3] = 0;
-	req->cmd[4] = SCSI_REMOVAL_PREVENT;
-	req->cmd[5] = 0;
+	if (blk_rq_set_block_pc(req, COMMAND_SIZE(ALLOW_MEDIUM_REMOVAL),
+				NULL, GFP_KERNEL) < 0) {
+		blk_put_request(req);
+		return;
+	}
 
-	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
+	req->block_pc->cmd[0] = ALLOW_MEDIUM_REMOVAL;
+	req->block_pc->cmd[1] = 0;
+	req->block_pc->cmd[2] = 0;
+	req->block_pc->cmd[3] = 0;
+	req->block_pc->cmd[4] = SCSI_REMOVAL_PREVENT;
+	req->block_pc->cmd[5] = 0;
 
 	req->cmd_flags |= REQ_QUIET;
 	req->timeout = 10 * HZ;
@@ -2332,8 +2334,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	blk_rq_init(NULL, &req);
 	scmd->request = &req;
 
-	scmd->cmnd = req.cmd;
-
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b1a2631..29e0cd6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -224,16 +224,15 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
 	if (IS_ERR(req))
 		return ret;
-	blk_rq_set_block_pc(req);
+
+	if (blk_rq_set_block_pc(req, COMMAND_SIZE(cmd[0]), sense, GFP_KERNEL))
+		goto out;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_WAIT))
 		goto out;
 
-	req->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = sense;
-	req->sense_len = 0;
+	memcpy(req->block_pc->cmd, cmd, req->block_pc->cmd_len);
 	req->retries = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags | REQ_QUIET | REQ_PREEMPT;
@@ -835,7 +834,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
 		if (result) {
-			if (sense_valid && req->sense) {
+			if (sense_valid && req->block_pc->sense) {
 				/*
 				 * SG_IO wants current and deferred errors
 				 */
@@ -843,8 +842,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 				if (len > SCSI_SENSE_BUFFERSIZE)
 					len = SCSI_SENSE_BUFFERSIZE;
-				memcpy(req->sense, cmd->sense_buffer,  len);
-				req->sense_len = len;
+				memcpy(req->block_pc->sense, cmd->sense_buffer,  len);
+				req->block_pc->sense_len = len;
 			}
 			if (!sense_deferred)
 				error = __scsi_error_from_host_byte(cmd, result);
@@ -1208,7 +1207,6 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 	cmd->tag = req->tag;
 	cmd->request = req;
 
-	cmd->cmnd = req->cmd;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	return cmd;
@@ -1234,7 +1232,8 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 	}
 
-	cmd->cmd_len = req->cmd_len;
+	cmd->cmd_len = req->block_pc->cmd_len;
+	cmd->cmnd = req->block_pc->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = req->retries;
 	return BLKPREP_OK;
@@ -1255,7 +1254,7 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 			return ret;
 	}
 
-	memset(cmd->cmnd, 0, BLK_MAX_CDB);
+	cmd->cmnd = cmd->__cmnd;
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
@@ -1911,7 +1910,6 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	cmd->tag = req->tag;
 
-	cmd->cmnd = req->cmd;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	INIT_LIST_HEAD(&cmd->list);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 24eaaf6..6024e6c 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3593,9 +3593,9 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 
 	if (err < 0)
 		/* we're only returning the result field in the reply */
-		job->req->sense_len = sizeof(uint32_t);
+		job->req->block_pc->sense_len = sizeof(uint32_t);
 	else
-		job->req->sense_len = job->reply_len;
+		job->req->block_pc->sense_len = job->reply_len;
 
 	/* we assume all request payload was transferred, residual == 0 */
 	req->resid_len = 0;
@@ -3725,9 +3725,9 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 	if (i->f->dd_bsg_size)
 		job->dd_data = (void *)&job[1];
 	spin_lock_init(&job->job_lock);
-	job->request = (struct fc_bsg_request *)req->cmd;
-	job->request_len = req->cmd_len;
-	job->reply = req->sense;
+	job->request = (struct fc_bsg_request *)req->block_pc->cmd;
+	job->request_len = req->block_pc->cmd_len;
+	job->reply = req->block_pc->sense;
 	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
 						 * allocated */
 	if (req->bio) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dcc4244..7883fd9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -126,9 +126,6 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
-static struct kmem_cache *sd_cdb_cache;
-static mempool_t *sd_cdb_pool;
-
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -1016,13 +1013,6 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 		protect = 0;
 
 	if (protect && sdkp->protection_type == SD_DIF_TYPE2_PROTECTION) {
-		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
-
-		if (unlikely(SCpnt->cmnd == NULL)) {
-			ret = BLKPREP_DEFER;
-			goto out;
-		}
-
 		SCpnt->cmd_len = SD_EXT_CDB_SIZE;
 		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
 		SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
@@ -1138,12 +1128,6 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 
 	if (rq->cmd_flags & REQ_DISCARD)
 		__free_page(rq->completion_data);
-
-	if (SCpnt->cmnd != rq->cmd) {
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
 }
 
 /**
@@ -3221,38 +3205,17 @@ static int __init init_sd(void)
 
 	err = class_register(&sd_disk_class);
 	if (err)
-		goto err_out;
-
-	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
-					 0, 0, NULL);
-	if (!sd_cdb_cache) {
-		printk(KERN_ERR "sd: can't init extended cdb cache\n");
-		err = -ENOMEM;
-		goto err_out_class;
-	}
-
-	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
-	if (!sd_cdb_pool) {
-		printk(KERN_ERR "sd: can't init extended cdb pool\n");
-		err = -ENOMEM;
-		goto err_out_cache;
-	}
+		goto out_unregister_blkdev;
 
 	err = scsi_register_driver(&sd_template.gendrv);
 	if (err)
-		goto err_out_driver;
+		goto out_unregister_class;
 
 	return 0;
 
-err_out_driver:
-	mempool_destroy(sd_cdb_pool);
-
-err_out_cache:
-	kmem_cache_destroy(sd_cdb_cache);
-
-err_out_class:
+out_unregister_class:
 	class_unregister(&sd_disk_class);
-err_out:
+out_unregister_blkdev:
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
 	return err;
@@ -3270,8 +3233,6 @@ static void __exit exit_sd(void)
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
 	scsi_unregister_driver(&sd_template.gendrv);
-	mempool_destroy(sd_cdb_pool);
-	kmem_cache_destroy(sd_cdb_cache);
 
 	class_unregister(&sd_disk_class);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9d7b7db..a266319 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1297,7 +1297,7 @@ sg_rq_end_io(struct request *rq, int uptodate)
 	if (unlikely(atomic_read(&sdp->detaching)))
 		pr_info("%s: device detaching\n", __func__);
 
-	sense = rq->sense;
+	sense = rq->block_pc->sense;
 	result = rq->errors;
 	resid = rq->resid_len;
 
@@ -1342,8 +1342,6 @@ sg_rq_end_io(struct request *rq, int uptodate)
 	 * blk_rq_unmap_user() can be called from user context.
 	 */
 	srp->rq = NULL;
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
 	__blk_put_request(rq->q, rq);
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -1701,16 +1699,16 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 		return PTR_ERR(rq);
 	}
 
-	blk_rq_set_block_pc(rq);
+	res = blk_rq_set_block_pc(rq, hp->cmd_len, srp->sense_b, GFP_KERNEL);
+	if (res) {
+		blk_put_request(rq);
+		return res;
+	}
 
-	if (hp->cmd_len > BLK_MAX_CDB)
-		rq->cmd = long_cmdp;
-	memcpy(rq->cmd, cmd, hp->cmd_len);
-	rq->cmd_len = hp->cmd_len;
+	memcpy(rq->block_pc->cmd, cmd, hp->cmd_len);
 
 	srp->rq = rq;
 	rq->end_io_data = srp;
-	rq->sense = srp->sense_b;
 	rq->retries = SG_DEFAULT_RETRIES;
 
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
@@ -1785,11 +1783,8 @@ sg_finish_rem_req(Sg_request *srp)
 	if (srp->bio)
 		ret = blk_rq_unmap_user(srp->bio);
 
-	if (srp->rq) {
-		if (srp->rq->cmd != srp->rq->__cmd)
-			kfree(srp->rq->cmd);
+	if (srp->rq)
 		blk_put_request(srp->rq);
-	}
 
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9a1c342..7b4445f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -502,7 +502,10 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
-	blk_rq_set_block_pc(req);
+	err = blk_rq_set_block_pc(req, COMMAND_SIZE(cmd[0]), SRpnt->sense,
+			GFP_KERNEL);
+	if (err)
+		goto out_put_request;
 	req->cmd_flags |= REQ_QUIET;
 
 	mdata->null_mapped = 1;
@@ -510,24 +513,22 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	if (bufflen) {
 		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen,
 				      GFP_KERNEL);
-		if (err) {
-			blk_put_request(req);
-			return DRIVER_ERROR << 24;
-		}
+		if (err)
+			goto out_put_request;
 	}
 
 	SRpnt->bio = req->bio;
-	req->cmd_len = COMMAND_SIZE(cmd[0]);
-	memset(req->cmd, 0, BLK_MAX_CDB);
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = SRpnt->sense;
-	req->sense_len = 0;
+	memcpy(req->block_pc->cmd, cmd, req->block_pc->cmd_len);
 	req->timeout = timeout;
 	req->retries = retries;
 	req->end_io_data = SRpnt;
 
 	blk_execute_rq_nowait(req->q, NULL, req, 1, st_scsi_execute_end);
 	return 0;
+
+out_put_request:
+	blk_put_request(req);
+	return DRIVER_ERROR << 24;
 }
 
 /* Do the scsi command. Waits until command performed if do_wait is true.
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f6c954c..023accd 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1064,8 +1064,6 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto fail;
 		}
-
-		blk_rq_set_block_pc(req);
 	} else {
 		BUG_ON(!cmd->data_length);
 
@@ -1082,12 +1080,16 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		}
 	}
 
+	if (blk_rq_set_block_pc(req, scsi_command_size(pt->pscsi_cdb),
+			&pt->pscsi_sense[0], GFP_KERNEL)) {
+		blk_put_request(req);
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto fail;
+	}
+
 	req->end_io = pscsi_req_done;
 	req->end_io_data = cmd;
-	req->cmd_len = scsi_command_size(pt->pscsi_cdb);
-	req->cmd = &pt->pscsi_cdb[0];
-	req->sense = &pt->pscsi_sense[0];
-	req->sense_len = 0;
+	memcpy(req->block_pc->cmd, &pt->pscsi_cdb[0], req->block_pc->cmd_len);
 	if (pdv->pdv_sd->type == TYPE_DISK)
 		req->timeout = PS_TIMEOUT_DISK;
 	else
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2da818a..e64a01b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -80,6 +80,16 @@ enum rq_cmd_type_bits {
 #define BLK_MAX_CDB	16
 
 /*
+ * when request is used as a packet command carrier
+ */
+struct block_pc_request {
+	unsigned short cmd_len;
+	unsigned int sense_len;
+	void *sense;
+	unsigned char cmd[];
+};
+
+/*
  * Try to put the fields that are referenced together in the same cacheline.
  *
  * If you modify this structure, make sure to update blk_rq_init() and
@@ -172,23 +182,19 @@ struct request {
 	int tag;
 	int errors;
 
-	/*
-	 * when request is used as a packet command carrier
-	 */
-	unsigned char __cmd[BLK_MAX_CDB];
-	unsigned char *cmd;
-	unsigned short cmd_len;
-
 	unsigned int extra_len;	/* length of alignment and padding */
-	unsigned int sense_len;
 	unsigned int resid_len;	/* residual count */
-	void *sense;
 
 	unsigned long deadline;
 	struct list_head timeout_list;
 	unsigned int timeout;
 	int retries;
 
+	union {
+		struct block_pc_request *block_pc;
+		void *drv_private;
+	};
+
 	/*
 	 * completion callback.
 	 */
@@ -769,7 +775,8 @@ extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
-extern void blk_rq_set_block_pc(struct request *);
+int blk_rq_set_block_pc(struct request *rq, unsigned short cmd_len,
+		u8 *sense, gfp_t gfp);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index afc1343..8c63eca 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -105,7 +105,9 @@ struct compat_blk_user_trace_setup {
 
 static inline int blk_cmd_buf_len(struct request *rq)
 {
-	return (rq->cmd_type == REQ_TYPE_BLOCK_PC) ? rq->cmd_len * 3 : 1;
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
+		return rq->block_pc->cmd_len * 3;
+	return 1;
 }
 
 extern void blk_dump_cmd(char *buf, struct request *rq);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9fc1aec..de6d7d0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -92,7 +92,7 @@ struct scsi_cmnd {
 
 	/* These elements define the operation we are about to perform */
 	unsigned char *cmnd;
-
+	unsigned char __cmnd[32];
 
 	/* These elements define the operation we ultimately want to perform */
 	struct scsi_data_buffer sdb;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 483cecf..e87c0ac 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -720,7 +720,9 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, nr_bytes, rq->cmd_flags,
-				what, rq->errors, rq->cmd_len, rq->cmd);
+				what, rq->errors,
+				rq->block_pc->cmd_len,
+				rq->block_pc->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes,
@@ -1762,14 +1764,17 @@ void blk_trace_remove_sysfs(struct device *dev)
 void blk_dump_cmd(char *buf, struct request *rq)
 {
 	int i, end;
-	int len = rq->cmd_len;
-	unsigned char *cmd = rq->cmd;
+	int len;
+	unsigned char *cmd;
 
 	if (rq->cmd_type != REQ_TYPE_BLOCK_PC) {
 		buf[0] = '\0';
 		return;
 	}
 
+	len = rq->block_pc->cmd_len;
+	cmd = rq->block_pc->cmd;
+
 	for (end = len - 1; end >= 0; end--)
 		if (cmd[end])
 			break;
-- 
1.9.1

