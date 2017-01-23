From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/16] block: split scsi_request out of struct request
Date: Mon, 23 Jan 2017 16:29:20 +0100
Message-ID: <1485185361-29786-16-git-send-email-hch@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdAWPaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2017 10:30:11 -0500
In-Reply-To: <1485185361-29786-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

And require all drivers that want to support BLOCK_PC to allocate it
as the first thing of their private data.  To support this the legacy
IDE and BSG code is switched to set cmd_size on their queues to let
the block layer allocate the additional space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                         | 31 -----------
 block/blk-exec.c                         | 12 -----
 block/blk-mq.c                           | 10 ----
 block/bsg-lib.c                          | 34 ++++++++----
 block/bsg.c                              | 47 ++++++++---------
 block/scsi_ioctl.c                       | 87 ++++++++++++++++++------------
 drivers/ata/libata-scsi.c                |  2 +-
 drivers/block/cciss.c                    | 28 +++++-----
 drivers/block/pktcdvd.c                  |  6 +--
 drivers/block/virtio_blk.c               | 11 ++--
 drivers/cdrom/cdrom.c                    | 32 +++++------
 drivers/ide/ide-atapi.c                  | 43 ++++++++-------
 drivers/ide/ide-cd.c                     | 91 +++++++++++++++-----------------
 drivers/ide/ide-cd_ioctl.c               |  1 +
 drivers/ide/ide-cd_verbose.c             |  6 +--
 drivers/ide/ide-devsets.c                |  9 ++--
 drivers/ide/ide-disk.c                   |  1 +
 drivers/ide/ide-eh.c                     |  2 +-
 drivers/ide/ide-floppy.c                 |  4 +-
 drivers/ide/ide-io.c                     |  3 +-
 drivers/ide/ide-ioctls.c                 |  6 ++-
 drivers/ide/ide-park.c                   | 12 +++--
 drivers/ide/ide-pm.c                     |  2 +
 drivers/ide/ide-probe.c                  | 36 +++++++++++--
 drivers/ide/ide-tape.c                   | 32 +++++------
 drivers/ide/ide-taskfile.c               |  1 +
 drivers/ide/sis5513.c                    |  2 +-
 drivers/message/fusion/mptsas.c          |  8 +--
 drivers/scsi/libfc/fc_lport.c            |  2 +-
 drivers/scsi/libsas/sas_expander.c       |  8 +--
 drivers/scsi/libsas/sas_host_smp.c       | 38 ++++++-------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  8 +--
 drivers/scsi/osd/osd_initiator.c         | 19 +++----
 drivers/scsi/osst.c                      | 15 +++---
 drivers/scsi/qla2xxx/qla_bsg.c           |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c           |  6 ++-
 drivers/scsi/qla2xxx/qla_mr.c            |  2 +-
 drivers/scsi/scsi_error.c                | 22 ++++----
 drivers/scsi/scsi_lib.c                  | 48 +++++++++--------
 drivers/scsi/scsi_transport_sas.c        |  5 ++
 drivers/scsi/sd.c                        |  4 +-
 drivers/scsi/sg.c                        | 30 ++++++-----
 drivers/scsi/st.c                        | 22 ++++----
 drivers/target/target_core_pscsi.c       | 11 ++--
 fs/nfsd/blocklayout.c                    | 17 +++---
 include/linux/blkdev.h                   | 11 ----
 include/linux/blktrace_api.h             |  3 +-
 include/linux/ide.h                      |  8 ++-
 include/scsi/scsi_cmnd.h                 |  2 +
 include/scsi/scsi_request.h              | 28 ++++++++++
 kernel/trace/blktrace.c                  | 32 +++++------
 51 files changed, 483 insertions(+), 419 deletions(-)
 create mode 100644 include/scsi/scsi_request.h

diff --git a/block/blk-core.c b/block/blk-core.c
index 793ef96..fe5cc98 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -132,8 +132,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->__sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
-	rq->cmd = rq->__cmd;
-	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->internal_tag = -1;
 	rq->start_time = jiffies;
@@ -160,8 +158,6 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
 {
-	int bit;
-
 	printk(KERN_INFO "%s: dev %s: type=%x, flags=%llx\n", msg,
 		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
 		(unsigned long long) rq->cmd_flags);
@@ -171,13 +167,6 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
 	printk(KERN_INFO "  bio %p, biotail %p, len %u\n",
 	       rq->bio, rq->biotail, blk_rq_bytes(rq));
-
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		printk(KERN_INFO "  cdb: ");
-		for (bit = 0; bit < BLK_MAX_CDB; bit++)
-			printk("%02x ", rq->cmd[bit]);
-		printk("\n");
-	}
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
@@ -1316,18 +1305,6 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 EXPORT_SYMBOL(blk_get_request);
 
 /**
- * blk_rq_set_block_pc - initialize a request to type BLOCK_PC
- * @rq:		request to be initialized
- *
- */
-void blk_rq_set_block_pc(struct request *rq)
-{
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	memset(rq->__cmd, 0, sizeof(rq->__cmd));
-}
-EXPORT_SYMBOL(blk_rq_set_block_pc);
-
-/**
  * blk_requeue_request - put a request back on queue
  * @q:		request queue where request should be inserted
  * @rq:		request to be inserted
@@ -2459,14 +2436,6 @@ void blk_start_request(struct request *req)
 		wbt_issue(req->q->rq_wb, &req->issue_stat);
 	}
 
-	/*
-	 * We are now handing the request to the hardware, initialize
-	 * resid_len to full count and add the timeout handler.
-	 */
-	req->resid_len = blk_rq_bytes(req);
-	if (unlikely(blk_bidi_rq(req)))
-		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);
-
 	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
 	blk_add_timer(req);
 }
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 86656fd..8dd4a6d 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -101,16 +101,9 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
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
 
@@ -124,11 +117,6 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
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
index ee69e5e..779dbba 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -199,13 +199,7 @@ void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->special = NULL;
 	/* tag was already set */
 	rq->errors = 0;
-
-	rq->cmd = rq->__cmd;
-
 	rq->extra_len = 0;
-	rq->sense_len = 0;
-	rq->resid_len = 0;
-	rq->sense = NULL;
 
 	INIT_LIST_HEAD(&rq->timeout_list);
 	rq->timeout = 0;
@@ -487,10 +481,6 @@ void blk_mq_start_request(struct request *rq)
 
 	trace_block_rq_issue(q, rq);
 
-	rq->resid_len = blk_rq_bytes(rq);
-	if (unlikely(blk_bidi_rq(rq)))
-		rq->next_rq->resid_len = blk_rq_bytes(rq->next_rq);
-
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
 		blk_stat_set_issue_time(&rq->issue_stat);
 		rq->rq_flags |= RQF_STATS;
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index c74acf4..cd15f9d 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -71,22 +71,24 @@ void bsg_job_done(struct bsg_job *job, int result,
 {
 	struct request *req = job->req;
 	struct request *rsp = req->next_rq;
+	struct scsi_request *rq = scsi_req(req);
 	int err;
 
 	err = job->req->errors = result;
 	if (err < 0)
 		/* we're only returning the result field in the reply */
-		job->req->sense_len = sizeof(u32);
+		rq->sense_len = sizeof(u32);
 	else
-		job->req->sense_len = job->reply_len;
+		rq->sense_len = job->reply_len;
 	/* we assume all request payload was transferred, residual == 0 */
-	req->resid_len = 0;
+	rq->resid_len = 0;
 
 	if (rsp) {
-		WARN_ON(reply_payload_rcv_len > rsp->resid_len);
+		WARN_ON(reply_payload_rcv_len > scsi_req(rsp)->resid_len);
 
 		/* set reply (bidi) residual */
-		rsp->resid_len -= min(reply_payload_rcv_len, rsp->resid_len);
+		scsi_req(rsp)->resid_len -=
+			min(reply_payload_rcv_len, scsi_req(rsp)->resid_len);
 	}
 	blk_complete_request(req);
 }
@@ -113,6 +115,7 @@ static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 	if (!buf->sg_list)
 		return -ENOMEM;
 	sg_init_table(buf->sg_list, req->nr_phys_segments);
+	scsi_req(req)->resid_len = blk_rq_bytes(req);
 	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
 	buf->payload_len = blk_rq_bytes(req);
 	return 0;
@@ -127,6 +130,7 @@ static int bsg_create_job(struct device *dev, struct request *req)
 {
 	struct request *rsp = req->next_rq;
 	struct request_queue *q = req->q;
+	struct scsi_request *rq = scsi_req(req);
 	struct bsg_job *job;
 	int ret;
 
@@ -140,9 +144,9 @@ static int bsg_create_job(struct device *dev, struct request *req)
 	job->req = req;
 	if (q->bsg_job_size)
 		job->dd_data = (void *)&job[1];
-	job->request = req->cmd;
-	job->request_len = req->cmd_len;
-	job->reply = req->sense;
+	job->request = rq->cmd;
+	job->request_len = rq->cmd_len;
+	job->reply = rq->sense;
 	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
 						 * allocated */
 	if (req->bio) {
@@ -228,9 +232,15 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
 	struct request_queue *q;
 	int ret;
 
-	q = blk_init_queue(bsg_request_fn, NULL);
+	q = blk_alloc_queue(GFP_KERNEL);
 	if (!q)
 		return ERR_PTR(-ENOMEM);
+	q->cmd_size = sizeof(struct scsi_request);
+	q->request_fn = bsg_request_fn;
+
+	ret = blk_init_allocated_queue(q);
+	if (ret)
+		goto out_cleanup_queue;
 
 	q->queuedata = dev;
 	q->bsg_job_size = dd_job_size;
@@ -243,10 +253,12 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
 	if (ret) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 		       "initialize - register queue\n", dev->kobj.name);
-		blk_cleanup_queue(q);
-		return ERR_PTR(ret);
+		goto out_cleanup_queue;
 	}
 
 	return q;
+out_cleanup_queue:
+	blk_cleanup_queue(q);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(bsg_setup_queue);
diff --git a/block/bsg.c b/block/bsg.c
index a57046d..e34c332 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -85,7 +85,6 @@ struct bsg_command {
 	struct bio *bidi_bio;
 	int err;
 	struct sg_io_v4 hdr;
-	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
 static void bsg_free_command(struct bsg_command *bc)
@@ -140,18 +139,20 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 				struct sg_io_v4 *hdr, struct bsg_device *bd,
 				fmode_t has_write_perm)
 {
+	struct scsi_request *req = scsi_req(rq);
+
 	if (hdr->request_len > BLK_MAX_CDB) {
-		rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
-		if (!rq->cmd)
+		req->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
+		if (!req->cmd)
 			return -ENOMEM;
 	}
 
-	if (copy_from_user(rq->cmd, (void __user *)(unsigned long)hdr->request,
+	if (copy_from_user(req->cmd, (void __user *)(unsigned long)hdr->request,
 			   hdr->request_len))
 		return -EFAULT;
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(rq->cmd, has_write_perm))
+		if (blk_verify_command(req->cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -159,7 +160,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->request_len;
+	req->cmd_len = hdr->request_len;
 
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
@@ -205,8 +206,7 @@ bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *rw)
  * map sg_io_v4 to a request.
  */
 static struct request *
-bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
-	    u8 *sense)
+bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
@@ -236,7 +236,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 	if (IS_ERR(rq))
 		return rq;
-	blk_rq_set_block_pc(rq);
+	scsi_req_init(rq);
 
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
 	if (ret)
@@ -280,13 +280,9 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 			goto out;
 	}
 
-	rq->sense = sense;
-	rq->sense_len = 0;
-
 	return rq;
 out:
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
+	scsi_req_free_cmd(scsi_req(rq));
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
@@ -393,6 +389,7 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 				    struct bio *bio, struct bio *bidi_bio)
 {
+	struct scsi_request *req = scsi_req(rq);
 	int ret = 0;
 
 	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
@@ -407,12 +404,12 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		hdr->info |= SG_INFO_CHECK;
 	hdr->response_len = 0;
 
-	if (rq->sense_len && hdr->response) {
+	if (req->sense_len && hdr->response) {
 		int len = min_t(unsigned int, hdr->max_response_len,
-					rq->sense_len);
+					req->sense_len);
 
 		ret = copy_to_user((void __user *)(unsigned long)hdr->response,
-				   rq->sense, len);
+				   req->sense, len);
 		if (!ret)
 			hdr->response_len = len;
 		else
@@ -420,14 +417,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->resid_len;
-		hdr->din_resid = rq->next_rq->resid_len;
+		hdr->dout_resid = req->resid_len;
+		hdr->din_resid = scsi_req(rq->next_rq)->resid_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->resid_len;
+		hdr->din_resid = req->resid_len;
 	else
-		hdr->dout_resid = rq->resid_len;
+		hdr->dout_resid = req->resid_len;
 
 	/*
 	 * If the request generated a negative error number, return it
@@ -439,8 +436,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		ret = rq->errors;
 
 	blk_rq_unmap_user(bio);
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
+	scsi_req_free_cmd(req);
 	blk_put_request(rq);
 
 	return ret;
@@ -625,7 +621,7 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
 		/*
 		 * get a request, fill in the blanks, and add to request queue
 		 */
-		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm, bc->sense);
+		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			rq = NULL;
@@ -911,12 +907,11 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
 		int at_head;
-		u8 sense[SCSI_SENSE_BUFFERSIZE];
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
 			return -EFAULT;
 
-		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE, sense);
+		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE);
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c2b6492..e542144 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -230,15 +230,17 @@ EXPORT_SYMBOL(blk_verify_command);
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, fmode_t mode)
 {
-	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
+	struct scsi_request *req = scsi_req(rq);
+
+	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, mode & FMODE_WRITE))
+	if (blk_verify_command(req->cmd, mode & FMODE_WRITE))
 		return -EPERM;
 
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->cmd_len;
+	req->cmd_len = hdr->cmd_len;
 
 	rq->timeout = msecs_to_jiffies(hdr->timeout);
 	if (!rq->timeout)
@@ -254,6 +256,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 				 struct bio *bio)
 {
+	struct scsi_request *req = scsi_req(rq);
 	int r, ret = 0;
 
 	/*
@@ -267,13 +270,13 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->resid_len;
+	hdr->resid = req->resid_len;
 	hdr->sb_len_wr = 0;
 
-	if (rq->sense_len && hdr->sbp) {
-		int len = min((unsigned int) hdr->mx_sb_len, rq->sense_len);
+	if (req->sense_len && hdr->sbp) {
+		int len = min((unsigned int) hdr->mx_sb_len, req->sense_len);
 
-		if (!copy_to_user(hdr->sbp, rq->sense, len))
+		if (!copy_to_user(hdr->sbp, req->sense, len))
 			hdr->sb_len_wr = len;
 		else
 			ret = -EFAULT;
@@ -294,7 +297,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	int writing = 0;
 	int at_head = 0;
 	struct request *rq;
-	char sense[SCSI_SENSE_BUFFERSIZE];
+	struct scsi_request *req;
 	struct bio *bio;
 
 	if (hdr->interface_id != 'S')
@@ -321,11 +324,12 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	blk_rq_set_block_pc(rq);
+	req = scsi_req(rq);
+	scsi_req_init(rq);
 
 	if (hdr->cmd_len > BLK_MAX_CDB) {
-		rq->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
-		if (!rq->cmd)
+		req->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);
+		if (!req->cmd)
 			goto out_put_request;
 	}
 
@@ -357,9 +361,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		goto out_free_cdb;
 
 	bio = rq->bio;
-	memset(sense, 0, sizeof(sense));
-	rq->sense = sense;
-	rq->sense_len = 0;
 	rq->retries = 0;
 
 	start_time = jiffies;
@@ -375,8 +376,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	ret = blk_complete_sghdr_rq(rq, hdr, bio);
 
 out_free_cdb:
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
+	scsi_req_free_cmd(req);
 out_put_request:
 	blk_put_request(rq);
 	return ret;
@@ -420,9 +420,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		struct scsi_ioctl_command __user *sic)
 {
 	struct request *rq;
+	struct scsi_request *req;
 	int err;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
-	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
+	char *buffer = NULL;
 
 	if (!sic)
 		return -EINVAL;
@@ -452,7 +453,8 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
 	}
-	blk_rq_set_block_pc(rq);
+	req = scsi_req(rq);
+	scsi_req_init(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -460,14 +462,14 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	 * get command and data to send to device, if any
 	 */
 	err = -EFAULT;
-	rq->cmd_len = cmdlen;
-	if (copy_from_user(rq->cmd, sic->data, cmdlen))
+	req->cmd_len = cmdlen;
+	if (copy_from_user(req->cmd, sic->data, cmdlen))
 		goto error;
 
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(rq->cmd, mode & FMODE_WRITE);
+	err = blk_verify_command(req->cmd, mode & FMODE_WRITE);
 	if (err)
 		goto error;
 
@@ -503,18 +505,14 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
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
+		if (req->sense_len && req->sense) {
+			bytes = (OMAX_SB_LEN > req->sense_len) ?
+				req->sense_len : OMAX_SB_LEN;
+			if (copy_to_user(sic->data, req->sense, bytes))
 				err = -EFAULT;
 		}
 	} else {
@@ -542,11 +540,11 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	blk_rq_set_block_pc(rq);
+	scsi_req_init(rq);
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
-	rq->cmd[0] = cmd;
-	rq->cmd[4] = data;
-	rq->cmd_len = 6;
+	scsi_req(rq)->cmd[0] = cmd;
+	scsi_req(rq)->cmd[4] = data;
+	scsi_req(rq)->cmd_len = 6;
 	err = blk_execute_rq(q, bd_disk, rq, 0);
 	blk_put_request(rq);
 
@@ -743,6 +741,29 @@ int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
 }
 EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
 
+/**
+ * scsi_req_init - initialize a request to type BLOCK_PC
+ * @rq:		request to be initialized
+ *
+ */
+void scsi_req_init(struct request *rq)
+{
+	struct scsi_request *req = scsi_req(rq);
+
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	memset(req->__cmd, 0, sizeof(req->__cmd));
+	req->cmd = req->__cmd;
+	req->cmd_len = BLK_MAX_CDB;
+	req->sense_len = 0;
+}
+EXPORT_SYMBOL(scsi_req_init);
+
+int scsi_cmd_buf_len(struct request *rq)
+{
+	return scsi_req(rq)->cmd_len * 3;
+}
+EXPORT_SYMBOL(scsi_cmd_buf_len);
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1f863e7..6abd739 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1271,7 +1271,7 @@ static int atapi_drain_needed(struct request *rq)
 	if (!blk_rq_bytes(rq) || op_is_write(req_op(rq)))
 		return 0;
 
-	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
+	return atapi_cmd_type(scsi_req(rq)->cmd[0]) == ATAPI_MISC;
 }
 
 static int ata_scsi_dev_config(struct scsi_device *sdev,
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e5c5b8e..b93bb73 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -52,6 +52,7 @@
 #include <scsi/scsi.h>
 #include <scsi/sg.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
 #include <linux/cdrom.h>
 #include <linux/scatterlist.h>
 #include <linux/kthread.h>
@@ -1854,7 +1855,7 @@ static void cciss_softirq_done(struct request *rq)
 
 	/* set the residual count for pc requests */
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
-		rq->resid_len = c->err_info->ResidualCnt;
+		scsi_req(rq)->resid_len = c->err_info->ResidualCnt;
 
 	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
 
@@ -1941,9 +1942,16 @@ static void cciss_get_serial_no(ctlr_info_t *h, int logvol,
 static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
-	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	disk->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!disk->queue)
 		goto init_queue_failure;
+
+	disk->queue->cmd_size = sizeof(struct scsi_request);
+	disk->queue->request_fn = do_cciss_request;
+	disk->queue->queue_lock = &h->lock;
+	if (blk_init_allocated_queue(disk->queue) < 0)
+		goto cleanup_queue;
+
 	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
 	disk->major = h->major;
 	disk->first_minor = drv_index << NWD_SHIFT;
@@ -3111,15 +3119,7 @@ static inline int evaluate_target_status(ctlr_info_t *h,
 		return error_value;
 	}
 
-	/* SG_IO or similar, copy sense data back */
-	if (cmd->rq->sense) {
-		if (cmd->rq->sense_len > cmd->err_info->SenseLen)
-			cmd->rq->sense_len = cmd->err_info->SenseLen;
-		memcpy(cmd->rq->sense, cmd->err_info->SenseInfo,
-			cmd->rq->sense_len);
-	} else
-		cmd->rq->sense_len = 0;
-
+	scsi_req(cmd->rq)->sense_len = cmd->err_info->SenseLen;
 	return error_value;
 }
 
@@ -3150,7 +3150,6 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 			dev_warn(&h->pdev->dev, "cmd %p has"
 			       " completed with data underrun "
 			       "reported\n", cmd);
-			cmd->rq->resid_len = cmd->err_info->ResidualCnt;
 		}
 		break;
 	case CMD_DATA_OVERRUN:
@@ -3426,8 +3425,9 @@ static void do_cciss_request(struct request_queue *q)
 			c->Request.CDB[14] = c->Request.CDB[15] = 0;
 		}
 	} else if (creq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		c->Request.CDBLen = creq->cmd_len;
-		memcpy(c->Request.CDB, creq->cmd, BLK_MAX_CDB);
+		c->Request.CDBLen = scsi_req(creq)->cmd_len;
+		memcpy(c->Request.CDB, scsi_req(creq)->cmd, BLK_MAX_CDB);
+		scsi_req(creq)->sense = c->err_info->SenseInfo;
 	} else {
 		dev_warn(&h->pdev->dev, "bad request type %d\n",
 			creq->cmd_type);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1b94c1c..918a92c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -707,7 +707,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			     WRITE : READ, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
-	blk_rq_set_block_pc(rq);
+	scsi_req_init(rq);
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
@@ -716,8 +716,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 			goto out;
 	}
 
-	rq->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
-	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	scsi_req(rq)->cmd_len = COMMAND_SIZE(cgc->cmd[0]);
+	memcpy(scsi_req(rq)->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 
 	rq->timeout = 60*HZ;
 	if (cgc->quiet)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 10332c2..3027d2e 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -52,6 +52,7 @@ struct virtio_blk {
 };
 
 struct virtblk_req {
+	struct scsi_request sreq;	/* for SCSI passthrough */
 	struct request *req;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
@@ -91,7 +92,7 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	 * inhdr with additional status information.
 	 */
 	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
-		sg_init_one(&cmd, vbr->req->cmd, vbr->req->cmd_len);
+		sg_init_one(&cmd, vbr->sreq.cmd, vbr->sreq.cmd_len);
 		sgs[num_out++] = &cmd;
 	}
 
@@ -103,7 +104,6 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	}
 
 	if (type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_SCSI_CMD)) {
-		memcpy(vbr->sense, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
 		sg_init_one(&sense, vbr->sense, SCSI_SENSE_BUFFERSIZE);
 		sgs[num_out + num_in++] = &sense;
 		sg_init_one(&inhdr, &vbr->in_hdr, sizeof(vbr->in_hdr));
@@ -123,8 +123,10 @@ static inline void virtblk_request_done(struct request *req)
 	int error = virtblk_result(vbr);
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		req->resid_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.residual);
-		req->sense_len = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
+		scsi_req(req)->resid_len =
+			virtio32_to_cpu(vblk->vdev, vbr->in_hdr.residual);
+		vbr->sreq.sense_len =
+			virtio32_to_cpu(vblk->vdev, vbr->in_hdr.sense_len);
 		req->errors = virtio32_to_cpu(vblk->vdev, vbr->in_hdr.errors);
 	} else if (req->cmd_type == REQ_TYPE_DRV_PRIV) {
 		req->errors = (error != 0);
@@ -538,6 +540,7 @@ static int virtblk_init_request(void *data, struct request *rq,
 	struct virtio_blk *vblk = data;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(rq);
 
+	vbr->sreq.sense = vbr->sense;
 	sg_init_table(vbr->sg, vblk->sg_elems);
 	return 0;
 }
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 59cca72..36f5237 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -281,8 +281,8 @@
 #include <linux/fcntl.h>
 #include <linux/blkdev.h>
 #include <linux/times.h>
-
 #include <linux/uaccess.h>
+#include <scsi/scsi_request.h>
 
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
@@ -2172,6 +2172,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 {
 	struct request_queue *q = cdi->disk->queue;
 	struct request *rq;
+	struct scsi_request *req;
 	struct bio *bio;
 	unsigned int len;
 	int nr, ret = 0;
@@ -2195,7 +2196,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			ret = PTR_ERR(rq);
 			break;
 		}
-		blk_rq_set_block_pc(rq);
+		req = scsi_req(rq);
+		scsi_req_init(rq);
 
 		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
 		if (ret) {
@@ -2203,23 +2205,23 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
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
+		req->cmd[0] = GPCMD_READ_CD;
+		req->cmd[1] = 1 << 2;
+		req->cmd[2] = (lba >> 24) & 0xff;
+		req->cmd[3] = (lba >> 16) & 0xff;
+		req->cmd[4] = (lba >>  8) & 0xff;
+		req->cmd[5] = lba & 0xff;
+		req->cmd[6] = (nr >> 16) & 0xff;
+		req->cmd[7] = (nr >>  8) & 0xff;
+		req->cmd[8] = nr & 0xff;
+		req->cmd[9] = 0xf8;
+
+		req->cmd_len = 12;
 		rq->timeout = 60 * HZ;
 		bio = rq->bio;
 
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
-			struct request_sense *s = rq->sense;
+			struct request_sense *s = req->sense;
 			ret = -EIO;
 			cdi->last_sense = s->sense_key;
 		}
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index f90ea22..7c826ec 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -93,6 +93,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	int error;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = (char *)pc;
 
@@ -103,9 +104,9 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 			goto put_req;
 	}
 
-	memcpy(rq->cmd, pc->c, 12);
+	memcpy(scsi_req(rq)->cmd, pc->c, 12);
 	if (drive->media == ide_tape)
-		rq->cmd[13] = REQ_IDETAPE_PC1;
+		scsi_req(rq)->cmd[13] = REQ_IDETAPE_PC1;
 	error = blk_execute_rq(drive->queue, disk, rq, 0);
 put_req:
 	blk_put_request(rq);
@@ -171,7 +172,8 @@ EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
 void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 {
 	struct request_sense *sense = &drive->sense_data;
-	struct request *sense_rq = &drive->sense_rq;
+	struct request *sense_rq = drive->sense_rq;
+	struct scsi_request *req = scsi_req(sense_rq);
 	unsigned int cmd_len, sense_len;
 	int err;
 
@@ -197,6 +199,7 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	memset(sense, 0, sizeof(*sense));
 
 	blk_rq_init(rq->q, sense_rq);
+	scsi_req_init(sense_rq);
 
 	err = blk_rq_map_kern(drive->queue, sense_rq, sense, sense_len,
 			      GFP_NOIO);
@@ -208,13 +211,13 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	}
 
 	sense_rq->rq_disk = rq->rq_disk;
-	sense_rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	sense_rq->cmd[4] = cmd_len;
 	sense_rq->cmd_type = REQ_TYPE_ATA_SENSE;
 	sense_rq->rq_flags |= RQF_PREEMPT;
 
+	req->cmd[0] = GPCMD_REQUEST_SENSE;
+	req->cmd[4] = cmd_len;
 	if (drive->media == ide_tape)
-		sense_rq->cmd[13] = REQ_IDETAPE_PC1;
+		req->cmd[13] = REQ_IDETAPE_PC1;
 
 	drive->sense_rq_armed = true;
 }
@@ -229,12 +232,12 @@ int ide_queue_sense_rq(ide_drive_t *drive, void *special)
 		return -ENOMEM;
 	}
 
-	drive->sense_rq.special = special;
+	drive->sense_rq->special = special;
 	drive->sense_rq_armed = false;
 
 	drive->hwif->rq = NULL;
 
-	elv_add_request(drive->queue, &drive->sense_rq, ELEVATOR_INSERT_FRONT);
+	elv_add_request(drive->queue, drive->sense_rq, ELEVATOR_INSERT_FRONT);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
@@ -247,14 +250,14 @@ EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
 void ide_retry_pc(ide_drive_t *drive)
 {
 	struct request *failed_rq = drive->hwif->rq;
-	struct request *sense_rq = &drive->sense_rq;
+	struct request *sense_rq = drive->sense_rq;
 	struct ide_atapi_pc *pc = &drive->request_sense_pc;
 
 	(void)ide_read_error(drive);
 
 	/* init pc from sense_rq */
 	ide_init_pc(pc);
-	memcpy(pc->c, sense_rq->cmd, 12);
+	memcpy(pc->c, scsi_req(sense_rq)->cmd, 12);
 
 	if (drive->media == ide_tape)
 		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
@@ -286,7 +289,7 @@ int ide_cd_expiry(ide_drive_t *drive)
 	 * commands/drives support that. Let ide_timer_expiry keep polling us
 	 * for these.
 	 */
-	switch (rq->cmd[0]) {
+	switch (scsi_req(rq)->cmd[0]) {
 	case GPCMD_BLANK:
 	case GPCMD_FORMAT_UNIT:
 	case GPCMD_RESERVE_RZONE_TRACK:
@@ -297,7 +300,7 @@ int ide_cd_expiry(ide_drive_t *drive)
 	default:
 		if (!(rq->rq_flags & RQF_QUIET))
 			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
-					 rq->cmd[0]);
+					 scsi_req(rq)->cmd[0]);
 		wait = 0;
 		break;
 	}
@@ -420,7 +423,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 						     ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		} else
-			rq->resid_len = 0;
+			scsi_req(rq)->resid_len = 0;
 		debug_log("%s: DMA finished\n", drive->name);
 	}
 
@@ -436,7 +439,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		local_irq_enable_in_hardirq();
 
 		if (drive->media == ide_tape &&
-		    (stat & ATA_ERR) && rq->cmd[0] == REQUEST_SENSE)
+		    (stat & ATA_ERR) && scsi_req(rq)->cmd[0] == REQUEST_SENSE)
 			stat &= ~ATA_ERR;
 
 		if ((stat & ATA_ERR) || (pc->flags & PC_FLAG_DMA_ERROR)) {
@@ -446,7 +449,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			if (drive->media != ide_tape)
 				pc->rq->errors++;
 
-			if (rq->cmd[0] == REQUEST_SENSE) {
+			if (scsi_req(rq)->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR PFX "%s: I/O error in request "
 						"sense command\n", drive->name);
 				return ide_do_reset(drive);
@@ -512,7 +515,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	ide_pio_bytes(drive, cmd, write, done);
 
 	/* Update transferred byte count */
-	rq->resid_len -= done;
+	scsi_req(rq)->resid_len -= done;
 
 	bcount -= done;
 
@@ -520,7 +523,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		ide_pad_transfer(drive, write, bcount);
 
 	debug_log("[cmd %x] transferred %d bytes, padded %d bytes, resid: %u\n",
-		  rq->cmd[0], done, bcount, rq->resid_len);
+		  rq->cmd[0], done, bcount, scsi_req(rq)->resid_len);
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, ide_pc_intr, timeout);
@@ -603,7 +606,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 	if (dev_is_idecd(drive)) {
 		/* ATAPI commands get padded out to 12 bytes minimum */
-		cmd_len = COMMAND_SIZE(rq->cmd[0]);
+		cmd_len = COMMAND_SIZE(scsi_req(rq)->cmd[0]);
 		if (cmd_len < ATAPI_MIN_CDB_BYTES)
 			cmd_len = ATAPI_MIN_CDB_BYTES;
 
@@ -650,7 +653,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 	/* Send the actual packet */
 	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
-		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
+		hwif->tp_ops->output_data(drive, NULL, scsi_req(rq)->cmd, cmd_len);
 
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
@@ -695,7 +698,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 							     bytes, 63 * 1024));
 
 		/* We haven't transferred any data yet */
-		rq->resid_len = bcount;
+		scsi_req(rq)->resid_len = bcount;
 
 		if (pc->flags & PC_FLAG_DMA_ERROR) {
 			pc->flags &= ~PC_FLAG_DMA_ERROR;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9cbd217..6eb9872 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -121,7 +121,7 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq)
 		 * don't log START_STOP unit with LoEj set, since we cannot
 		 * reliably check if drive can auto-close
 		 */
-		if (rq->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
+		if (scsi_req(rq)->cmd[0] == GPCMD_START_STOP_UNIT && sense->asc == 0x24)
 			break;
 		log = 1;
 		break;
@@ -163,7 +163,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	 * toc has not been recorded yet, it will fail with 05/24/00 (which is a
 	 * confusing error)
 	 */
-	if (failed_command && failed_command->cmd[0] == GPCMD_READ_TOC_PMA_ATIP)
+	if (failed_command && scsi_req(failed_command)->cmd[0] == GPCMD_READ_TOC_PMA_ATIP)
 		if (sense->sense_key == 0x05 && sense->asc == 0x24)
 			return;
 
@@ -219,15 +219,12 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 	void *sense = bio_data(rq->bio);
 
 	if (failed) {
-		if (failed->sense) {
-			/*
-			 * Sense is always read into drive->sense_data.
-			 * Copy back if the failed request has its
-			 * sense pointer set.
-			 */
-			memcpy(failed->sense, sense, 18);
-			failed->sense_len = rq->sense_len;
-		}
+		/*
+		 * Sense is always read into drive->sense_data, copy back to the
+		 * original request.
+		 */
+		memcpy(scsi_req(failed)->sense, sense, 18);
+		scsi_req(failed)->sense_len = scsi_req(rq)->sense_len;
 		cdrom_analyze_sense_data(drive, failed);
 
 		if (ide_end_rq(drive, failed, -EIO, blk_rq_bytes(failed)))
@@ -338,7 +335,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		 *
 		 * cdrom_log_sense() knows this!
 		 */
-		if (rq->cmd[0] == GPCMD_START_STOP_UNIT)
+		if (scsi_req(rq)->cmd[0] == GPCMD_START_STOP_UNIT)
 			break;
 		/* fall-through */
 	case DATA_PROTECT:
@@ -414,7 +411,7 @@ static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 	 * Some of the trailing request sense fields are optional,
 	 * and some drives don't send them.  Sigh.
 	 */
-	if (rq->cmd[0] == GPCMD_REQUEST_SENSE &&
+	if (scsi_req(rq)->cmd[0] == GPCMD_REQUEST_SENSE &&
 	    cmd->nleft > 0 && cmd->nleft <= 5)
 		cmd->nleft = 0;
 }
@@ -425,12 +422,8 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		    req_flags_t rq_flags)
 {
 	struct cdrom_info *info = drive->driver_data;
-	struct request_sense local_sense;
 	int retries = 10;
-	req_flags_t flags = 0;
-
-	if (!sense)
-		sense = &local_sense;
+	bool failed;
 
 	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x, timeout: %d, "
 				  "rq_flags: 0x%x",
@@ -440,12 +433,12 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 	do {
 		struct request *rq;
 		int error;
+		bool delay = false;
 
 		rq = blk_get_request(drive->queue, write, __GFP_RECLAIM);
-
-		memcpy(rq->cmd, cmd, BLK_MAX_CDB);
+		scsi_req_init(rq);
+		memcpy(scsi_req(rq)->cmd, cmd, BLK_MAX_CDB);
 		rq->cmd_type = REQ_TYPE_ATA_PC;
-		rq->sense = sense;
 		rq->rq_flags |= rq_flags;
 		rq->timeout = timeout;
 		if (buffer) {
@@ -460,21 +453,21 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		error = blk_execute_rq(drive->queue, info->disk, rq, 0);
 
 		if (buffer)
-			*bufflen = rq->resid_len;
-
-		flags = rq->rq_flags;
-		blk_put_request(rq);
+			*bufflen = scsi_req(rq)->resid_len;
+		if (sense)
+			memcpy(sense, scsi_req(rq)->sense, sizeof(*sense));
 
 		/*
 		 * FIXME: we should probably abort/retry or something in case of
 		 * failure.
 		 */
-		if (flags & RQF_FAILED) {
+		failed = (rq->rq_flags & RQF_FAILED) != 0;
+		if (failed) {
 			/*
 			 * The request failed.  Retry if it was due to a unit
 			 * attention status (usually means media was changed).
 			 */
-			struct request_sense *reqbuf = sense;
+			struct request_sense *reqbuf = scsi_req(rq)->sense;
 
 			if (reqbuf->sense_key == UNIT_ATTENTION)
 				cdrom_saw_media_change(drive);
@@ -485,19 +478,20 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 				 * a disk.  Retry, but wait a little to give
 				 * the drive time to complete the load.
 				 */
-				ssleep(2);
+				delay = true;
 			} else {
 				/* otherwise, don't retry */
 				retries = 0;
 			}
 			--retries;
 		}
-
-		/* end of retry loop */
-	} while ((flags & RQF_FAILED) && retries >= 0);
+		blk_put_request(rq);
+		if (delay)
+			ssleep(2);
+	} while (failed && retries >= 0);
 
 	/* return an error if the command failed */
-	return (flags & RQF_FAILED) ? -EIO : 0;
+	return failed ? -EIO : 0;
 }
 
 /*
@@ -636,7 +630,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		len -= blen;
 
 		if (sense && write == 0)
-			rq->sense_len += blen;
+			scsi_req(rq)->sense_len += blen;
 	}
 
 	/* pad, if necessary */
@@ -664,7 +658,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 out_end:
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && rc == 0) {
-		rq->resid_len = 0;
+		scsi_req(rq)->resid_len = 0;
 		blk_end_request_all(rq, 0);
 		hwif->rq = NULL;
 	} else {
@@ -685,9 +679,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 		/* make sure it's fully ended */
 		if (rq->cmd_type != REQ_TYPE_FS) {
-			rq->resid_len -= cmd->nbytes - cmd->nleft;
+			scsi_req(rq)->resid_len -= cmd->nbytes - cmd->nleft;
 			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
-				rq->resid_len += cmd->last_xfer_len;
+				scsi_req(rq)->resid_len += cmd->last_xfer_len;
 		}
 
 		ide_complete_rq(drive, uptodate ? 0 : -EIO, blk_rq_bytes(rq));
@@ -1312,28 +1306,29 @@ static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 	int hard_sect = queue_logical_block_size(q);
 	long block = (long)blk_rq_pos(rq) / (hard_sect >> 9);
 	unsigned long blocks = blk_rq_sectors(rq) / (hard_sect >> 9);
+	struct scsi_request *req = scsi_req(rq);
 
-	memset(rq->cmd, 0, BLK_MAX_CDB);
+	memset(req->cmd, 0, BLK_MAX_CDB);
 
 	if (rq_data_dir(rq) == READ)
-		rq->cmd[0] = GPCMD_READ_10;
+		req->cmd[0] = GPCMD_READ_10;
 	else
-		rq->cmd[0] = GPCMD_WRITE_10;
+		req->cmd[0] = GPCMD_WRITE_10;
 
 	/*
 	 * fill in lba
 	 */
-	rq->cmd[2] = (block >> 24) & 0xff;
-	rq->cmd[3] = (block >> 16) & 0xff;
-	rq->cmd[4] = (block >>  8) & 0xff;
-	rq->cmd[5] = block & 0xff;
+	req->cmd[2] = (block >> 24) & 0xff;
+	req->cmd[3] = (block >> 16) & 0xff;
+	req->cmd[4] = (block >>  8) & 0xff;
+	req->cmd[5] = block & 0xff;
 
 	/*
 	 * and transfer length
 	 */
-	rq->cmd[7] = (blocks >> 8) & 0xff;
-	rq->cmd[8] = blocks & 0xff;
-	rq->cmd_len = 10;
+	req->cmd[7] = (blocks >> 8) & 0xff;
+	req->cmd[8] = blocks & 0xff;
+	req->cmd_len = 10;
 	return BLKPREP_OK;
 }
 
@@ -1343,7 +1338,7 @@ static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
  */
 static int ide_cdrom_prep_pc(struct request *rq)
 {
-	u8 *c = rq->cmd;
+	u8 *c = scsi_req(rq)->cmd;
 
 	/* transform 6-byte read/write commands to the 10-byte version */
 	if (c[0] == READ_6 || c[0] == WRITE_6) {
@@ -1354,7 +1349,7 @@ static int ide_cdrom_prep_pc(struct request *rq)
 		c[2] = 0;
 		c[1] &= 0xe0;
 		c[0] += (READ_10 - READ_6);
-		rq->cmd_len = 10;
+		scsi_req(rq)->cmd_len = 10;
 		return BLKPREP_OK;
 	}
 
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index f085e3a..da0aa01 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -304,6 +304,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	int ret;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->rq_flags = RQF_QUIET;
 	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
diff --git a/drivers/ide/ide-cd_verbose.c b/drivers/ide/ide-cd_verbose.c
index f079ca2..58a6feb 100644
--- a/drivers/ide/ide-cd_verbose.c
+++ b/drivers/ide/ide-cd_verbose.c
@@ -315,12 +315,12 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 		while (hi > lo) {
 			mid = (lo + hi) / 2;
 			if (packet_command_texts[mid].packet_command ==
-			    failed_command->cmd[0]) {
+			    scsi_req(failed_command)->cmd[0]) {
 				s = packet_command_texts[mid].text;
 				break;
 			}
 			if (packet_command_texts[mid].packet_command >
-			    failed_command->cmd[0])
+			    scsi_req(failed_command)->cmd[0])
 				hi = mid;
 			else
 				lo = mid + 1;
@@ -329,7 +329,7 @@ void ide_cd_log_error(const char *name, struct request *failed_command,
 		printk(KERN_ERR "  The failed \"%s\" packet command "
 				"was: \n  \"", s);
 		for (i = 0; i < BLK_MAX_CDB; i++)
-			printk(KERN_CONT "%02x ", failed_command->cmd[i]);
+			printk(KERN_CONT "%02x ", scsi_req(failed_command)->cmd[i]);
 		printk(KERN_CONT "\"\n");
 	}
 
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index 0dd43b4..fd56c9d 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -166,10 +166,11 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 		return setting->set(drive, arg);
 
 	rq = blk_get_request(q, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
-	rq->cmd_len = 5;
-	rq->cmd[0] = REQ_DEVSET_EXEC;
-	*(int *)&rq->cmd[1] = arg;
+	scsi_req(rq)->cmd_len = 5;
+	scsi_req(rq)->cmd[0] = REQ_DEVSET_EXEC;
+	*(int *)&scsi_req(rq)->cmd[1] = arg;
 	rq->special = setting->set;
 
 	if (blk_execute_rq(q, NULL, rq, 0))
@@ -183,7 +184,7 @@ ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
 {
 	int err, (*setfunc)(ide_drive_t *, int) = rq->special;
 
-	err = setfunc(drive, *(int *)&rq->cmd[1]);
+	err = setfunc(drive, *(int *)&scsi_req(rq)->cmd[1]);
 	if (err)
 		rq->errors = err;
 	ide_complete_rq(drive, err, blk_rq_bytes(rq));
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 5ceace5..3437c5b 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -478,6 +478,7 @@ static int set_multcount(ide_drive_t *drive, int arg)
 		return -EBUSY;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index d6da011..35e5b89 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -148,7 +148,7 @@ static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 	struct request *rq = drive->hwif->rq;
 
 	if (rq && rq->cmd_type == REQ_TYPE_DRV_PRIV &&
-	    rq->cmd[0] == REQ_DRIVE_RESET) {
+	    scsi_req(rq)->cmd[0] == REQ_DRIVE_RESET) {
 		if (err <= 0 && rq->errors == 0)
 			rq->errors = -EIO;
 		ide_complete_rq(drive, err ? err : 0, blk_rq_bytes(rq));
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index f079d8d..3bd678a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -203,7 +203,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
-	memcpy(rq->cmd, pc->c, 12);
+	memcpy(scsi_req(rq)->cmd, pc->c, 12);
 
 	pc->rq = rq;
 	if (cmd == WRITE)
@@ -216,7 +216,7 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 		struct ide_atapi_pc *pc, struct request *rq)
 {
 	ide_init_pc(pc);
-	memcpy(pc->c, rq->cmd, sizeof(pc->c));
+	memcpy(pc->c, scsi_req(rq)->cmd, sizeof(pc->c));
 	pc->rq = rq;
 	if (blk_rq_bytes(rq)) {
 		pc->flags |= PC_FLAG_DMA_OK;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 201e43f..3378503 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -279,7 +279,7 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
-	u8 cmd = rq->cmd[0];
+	u8 cmd = scsi_req(rq)->cmd[0];
 
 	switch (cmd) {
 	case REQ_PARK_HEADS:
@@ -545,6 +545,7 @@ void do_ide_request(struct request_queue *q)
 			goto plug_device;
 		}
 
+		scsi_req(rq)->resid_len = blk_rq_bytes(rq);
 		hwif->rq = rq;
 
 		spin_unlock_irq(&hwif->lock);
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index d05db24..a5d22c6 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -126,6 +126,7 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 		struct request *rq;
 
 		rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+		scsi_req_init(rq);
 		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 		err = blk_execute_rq(drive->queue, NULL, rq, 0);
 		blk_put_request(rq);
@@ -222,9 +223,10 @@ static int generic_drive_reset(ide_drive_t *drive)
 	int ret = 0;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
-	rq->cmd_len = 1;
-	rq->cmd[0] = REQ_DRIVE_RESET;
+	scsi_req(rq)->cmd_len = 1;
+	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
 	if (blk_execute_rq(drive->queue, NULL, rq, 1))
 		ret = rq->errors;
 	blk_put_request(rq);
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 2d7dca5..c37604a 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -32,8 +32,9 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	spin_unlock_irq(&hwif->lock);
 
 	rq = blk_get_request(q, READ, __GFP_RECLAIM);
-	rq->cmd[0] = REQ_PARK_HEADS;
-	rq->cmd_len = 1;
+	scsi_req_init(rq);
+	scsi_req(rq)->cmd[0] = REQ_PARK_HEADS;
+	scsi_req(rq)->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = &timeout;
 	rc = blk_execute_rq(q, NULL, rq, 1);
@@ -46,11 +47,12 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	 * timeout has expired, so power management will be reenabled.
 	 */
 	rq = blk_get_request(q, READ, GFP_NOWAIT);
+	scsi_req_init(rq);
 	if (IS_ERR(rq))
 		goto out;
 
-	rq->cmd[0] = REQ_UNPARK_HEADS;
-	rq->cmd_len = 1;
+	scsi_req(rq)->cmd[0] = REQ_UNPARK_HEADS;
+	scsi_req(rq)->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
 
@@ -64,7 +66,7 @@ ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
 	struct ide_taskfile *tf = &cmd.tf;
 
 	memset(&cmd, 0, sizeof(cmd));
-	if (rq->cmd[0] == REQ_PARK_HEADS) {
+	if (scsi_req(rq)->cmd[0] == REQ_PARK_HEADS) {
 		drive->sleep = *(unsigned long *)rq->special;
 		drive->dev_flags |= IDE_DFLAG_SLEEPING;
 		tf->command = ATA_CMD_IDLEIMMEDIATE;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index a015acd..f6767ab 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -19,6 +19,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_ATA_PM_SUSPEND;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
@@ -89,6 +90,7 @@ int generic_ide_resume(struct device *dev)
 
 	memset(&rqpm, 0, sizeof(rqpm));
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_ATA_PM_RESUME;
 	rq->rq_flags |= RQF_PREEMPT;
 	rq->special = &rqpm;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 330e319..a74ae8df 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -741,6 +741,14 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 	}
 }
 
+static int ide_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
+{
+	struct ide_request *req = blk_mq_rq_to_pdu(rq);
+
+	req->sreq.sense = req->sense;
+	return 0;
+}
+
 /*
  * init request queue
  */
@@ -758,11 +766,18 @@ static int ide_init_queue(ide_drive_t *drive)
 	 *	limits and LBA48 we could raise it but as yet
 	 *	do not.
 	 */
-
-	q = blk_init_queue_node(do_ide_request, NULL, hwif_to_node(hwif));
+	q = blk_alloc_queue_node(GFP_KERNEL, hwif_to_node(hwif));
 	if (!q)
 		return 1;
 
+	q->request_fn = do_ide_request;
+	q->init_rq_fn = ide_init_rq;
+	q->cmd_size = sizeof(struct ide_request);
+	if (blk_init_allocated_queue(q) < 0) {
+		blk_cleanup_queue(q);
+		return 1;
+	}
+
 	q->queuedata = drive;
 	blk_queue_segment_boundary(q, 0xffff);
 
@@ -1131,10 +1146,12 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 	ide_port_for_each_dev(i, drive, hwif) {
 		u8 j = (hwif->index * MAX_DRIVES) + i;
 		u16 *saved_id = drive->id;
+		struct request *saved_sense_rq = drive->sense_rq;
 
 		memset(drive, 0, sizeof(*drive));
 		memset(saved_id, 0, SECTOR_SIZE);
 		drive->id = saved_id;
+		drive->sense_rq = saved_sense_rq;
 
 		drive->media			= ide_disk;
 		drive->select			= (i << 4) | ATA_DEVICE_OBS;
@@ -1241,6 +1258,7 @@ static void ide_port_free_devices(ide_hwif_t *hwif)
 	int i;
 
 	ide_port_for_each_dev(i, drive, hwif) {
+		kfree(drive->sense_rq);
 		kfree(drive->id);
 		kfree(drive);
 	}
@@ -1248,11 +1266,10 @@ static void ide_port_free_devices(ide_hwif_t *hwif)
 
 static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
 {
+	ide_drive_t *drive;
 	int i;
 
 	for (i = 0; i < MAX_DRIVES; i++) {
-		ide_drive_t *drive;
-
 		drive = kzalloc_node(sizeof(*drive), GFP_KERNEL, node);
 		if (drive == NULL)
 			goto out_nomem;
@@ -1267,12 +1284,21 @@ static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
 		 */
 		drive->id = kzalloc_node(SECTOR_SIZE, GFP_KERNEL, node);
 		if (drive->id == NULL)
-			goto out_nomem;
+			goto out_free_drive;
+
+		drive->sense_rq = kmalloc(sizeof(struct request) +
+				sizeof(struct ide_request), GFP_KERNEL);
+		if (!drive->sense_rq)
+			goto out_free_id;
 
 		hwif->devices[i] = drive;
 	}
 	return 0;
 
+out_free_id:
+	kfree(drive->id);
+out_free_drive:
+	kfree(drive);
 out_nomem:
 	ide_port_free_devices(hwif);
 	return -ENOMEM;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 9ecf4e3..f6bc1e2 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -282,7 +282,7 @@ static void idetape_analyze_error(ide_drive_t *drive)
 
 	/* correct remaining bytes to transfer */
 	if (pc->flags & PC_FLAG_DMA_ERROR)
-		rq->resid_len = tape->blk_size * get_unaligned_be32(&sense[3]);
+		scsi_req(rq)->resid_len = tape->blk_size * get_unaligned_be32(&sense[3]);
 
 	/*
 	 * If error was the result of a zero-length read or write command,
@@ -316,7 +316,7 @@ static void idetape_analyze_error(ide_drive_t *drive)
 			pc->flags |= PC_FLAG_ABORT;
 		}
 		if (!(pc->flags & PC_FLAG_ABORT) &&
-		    (blk_rq_bytes(rq) - rq->resid_len))
+		    (blk_rq_bytes(rq) - scsi_req(rq)->resid_len))
 			pc->retries = IDETAPE_MAX_PC_RETRIES + 1;
 	}
 }
@@ -348,7 +348,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
 		unsigned int blocks =
-			(blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
+			(blk_rq_bytes(rq) - scsi_req(rq)->resid_len) / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
 
@@ -560,7 +560,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
 		pc->flags |= PC_FLAG_WRITING;
 	}
 
-	memcpy(rq->cmd, pc->c, 12);
+	memcpy(scsi_req(rq)->cmd, pc->c, 12);
 }
 
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
@@ -570,10 +570,11 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = NULL;
 	struct ide_cmd cmd;
+	struct scsi_request *req = scsi_req(rq);
 	u8 stat;
 
 	ide_debug_log(IDE_DBG_RQ, "cmd: 0x%x, sector: %llu, nr_sectors: %u",
-		      rq->cmd[0], (unsigned long long)blk_rq_pos(rq),
+		      req->cmd[0], (unsigned long long)blk_rq_pos(rq),
 		      blk_rq_sectors(rq));
 
 	BUG_ON(!(rq->cmd_type == REQ_TYPE_DRV_PRIV ||
@@ -592,7 +593,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	stat = hwif->tp_ops->read_status(hwif);
 
 	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
-	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
+	    (req->cmd[13] & REQ_IDETAPE_PC2) == 0)
 		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 
 	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
@@ -609,7 +610,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		} else if (time_after(jiffies, tape->dsc_timeout)) {
 			printk(KERN_ERR "ide-tape: %s: DSC timeout\n",
 				tape->name);
-			if (rq->cmd[13] & REQ_IDETAPE_PC2) {
+			if (req->cmd[13] & REQ_IDETAPE_PC2) {
 				idetape_media_access_finished(drive);
 				return ide_stopped;
 			} else {
@@ -626,23 +627,23 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		tape->postponed_rq = false;
 	}
 
-	if (rq->cmd[13] & REQ_IDETAPE_READ) {
+	if (req->cmd[13] & REQ_IDETAPE_READ) {
 		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
 		goto out;
 	}
-	if (rq->cmd[13] & REQ_IDETAPE_WRITE) {
+	if (req->cmd[13] & REQ_IDETAPE_WRITE) {
 		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, WRITE_6);
 		goto out;
 	}
-	if (rq->cmd[13] & REQ_IDETAPE_PC1) {
+	if (req->cmd[13] & REQ_IDETAPE_PC1) {
 		pc = (struct ide_atapi_pc *)rq->special;
-		rq->cmd[13] &= ~(REQ_IDETAPE_PC1);
-		rq->cmd[13] |= REQ_IDETAPE_PC2;
+		req->cmd[13] &= ~(REQ_IDETAPE_PC1);
+		req->cmd[13] |= REQ_IDETAPE_PC2;
 		goto out;
 	}
-	if (rq->cmd[13] & REQ_IDETAPE_PC2) {
+	if (req->cmd[13] & REQ_IDETAPE_PC2) {
 		idetape_media_access_finished(drive);
 		return ide_stopped;
 	}
@@ -853,8 +854,9 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	BUG_ON(size < 0 || size % tape->blk_size);
 
 	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_DRV_PRIV;
-	rq->cmd[13] = cmd;
+	scsi_req(rq)->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
 	rq->__sector = tape->first_frame;
 
@@ -868,7 +870,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	blk_execute_rq(drive->queue, tape->disk, rq, 0);
 
 	/* calculate the number of transferred bytes and update buffer state */
-	size -= rq->resid_len;
+	size -= scsi_req(rq)->resid_len;
 	tape->cur = tape->buf;
 	if (cmd == REQ_IDETAPE_READ)
 		tape->valid = size;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a716693..a393e13 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -431,6 +431,7 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	int rw = !(cmd->tf_flags & IDE_TFLAG_WRITE) ? READ : WRITE;
 
 	rq = blk_get_request(drive->queue, rw, __GFP_RECLAIM);
+	scsi_req_init(rq);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	/*
diff --git a/drivers/ide/sis5513.c b/drivers/ide/sis5513.c
index 247853e..c3062b5 100644
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -54,7 +54,7 @@
 #define DRV_NAME "sis5513"
 
 /* registers layout and init values are chipset family dependent */
-
+#undef ATA_16
 #define ATA_16		0x01
 #define ATA_33		0x02
 #define ATA_66		0x03
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7ee1667..b8c4b2b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2320,10 +2320,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		SmpPassthroughReply_t *smprep;
 
 		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
-		memcpy(req->sense, smprep, sizeof(*smprep));
-		req->sense_len = sizeof(*smprep);
-		req->resid_len = 0;
-		rsp->resid_len -= smprep->ResponseDataLength;
+		memcpy(scsi_req(req)->sense, smprep, sizeof(*smprep));
+		scsi_req(req)->sense_len = sizeof(*smprep);
+		scsi_req(req)->resid_len = 0;
+		scsi_req(rsp)->resid_len -= smprep->ResponseDataLength;
 	} else {
 		printk(MYIOC_s_ERR_FMT
 		    "%s: smp passthru reply failed to be returned\n",
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 919736a..aa76f36 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2095,7 +2095,7 @@ int fc_lport_bsg_request(struct bsg_job *job)
 
 	bsg_reply->reply_payload_rcv_len = 0;
 	if (rsp)
-		rsp->resid_len = job->reply_payload.payload_len;
+		scsi_req(rsp)->resid_len = job->reply_payload.payload_len;
 
 	mutex_lock(&lport->lp_mutex);
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 022bb6e..570b2cb 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2174,12 +2174,12 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			       bio_data(rsp->bio), blk_rq_bytes(rsp));
 	if (ret > 0) {
 		/* positive number is the untransferred residual */
-		rsp->resid_len = ret;
-		req->resid_len = 0;
+		scsi_req(rsp)->resid_len = ret;
+		scsi_req(req)->resid_len = 0;
 		ret = 0;
 	} else if (ret == 0) {
-		rsp->resid_len = 0;
-		req->resid_len = 0;
+		scsi_req(rsp)->resid_len = 0;
+		scsi_req(req)->resid_len = 0;
 	}
 
 	return ret;
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index d247925..45cbbc4 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -274,15 +274,15 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 
 	switch (req_data[1]) {
 	case SMP_REPORT_GENERAL:
-		req->resid_len -= 8;
-		rsp->resid_len -= 32;
+		scsi_req(req)->resid_len -= 8;
+		scsi_req(rsp)->resid_len -= 32;
 		resp_data[2] = SMP_RESP_FUNC_ACC;
 		resp_data[9] = sas_ha->num_phys;
 		break;
 
 	case SMP_REPORT_MANUF_INFO:
-		req->resid_len -= 8;
-		rsp->resid_len -= 64;
+		scsi_req(req)->resid_len -= 8;
+		scsi_req(rsp)->resid_len -= 64;
 		resp_data[2] = SMP_RESP_FUNC_ACC;
 		memcpy(resp_data + 12, shost->hostt->name,
 		       SAS_EXPANDER_VENDOR_ID_LEN);
@@ -295,13 +295,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_DISCOVER:
-		req->resid_len -= 16;
-		if ((int)req->resid_len < 0) {
-			req->resid_len = 0;
+		scsi_req(req)->resid_len -= 16;
+		if ((int)scsi_req(req)->resid_len < 0) {
+			scsi_req(req)->resid_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
-		rsp->resid_len -= 56;
+		scsi_req(rsp)->resid_len -= 56;
 		sas_host_smp_discover(sas_ha, resp_data, req_data[9]);
 		break;
 
@@ -311,13 +311,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_REPORT_PHY_SATA:
-		req->resid_len -= 16;
-		if ((int)req->resid_len < 0) {
-			req->resid_len = 0;
+		scsi_req(req)->resid_len -= 16;
+		if ((int)scsi_req(req)->resid_len < 0) {
+			scsi_req(req)->resid_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
-		rsp->resid_len -= 60;
+		scsi_req(rsp)->resid_len -= 60;
 		sas_report_phy_sata(sas_ha, resp_data, req_data[9]);
 		break;
 
@@ -331,15 +331,15 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		int to_write = req_data[4];
 
 		if (blk_rq_bytes(req) < base_frame_size + to_write * 4 ||
-		    req->resid_len < base_frame_size + to_write * 4) {
+		    scsi_req(req)->resid_len < base_frame_size + to_write * 4) {
 			resp_data[2] = SMP_RESP_INV_FRM_LEN;
 			break;
 		}
 
 		to_write = sas_host_smp_write_gpio(sas_ha, resp_data, req_data[2],
 						   req_data[3], to_write, &req_data[8]);
-		req->resid_len -= base_frame_size + to_write * 4;
-		rsp->resid_len -= 8;
+		scsi_req(req)->resid_len -= base_frame_size + to_write * 4;
+		scsi_req(rsp)->resid_len -= 8;
 		break;
 	}
 
@@ -348,13 +348,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		break;
 
 	case SMP_PHY_CONTROL:
-		req->resid_len -= 44;
-		if ((int)req->resid_len < 0) {
-			req->resid_len = 0;
+		scsi_req(req)->resid_len -= 44;
+		if ((int)scsi_req(req)->resid_len < 0) {
+			scsi_req(req)->resid_len = 0;
 			error = -EINVAL;
 			goto out;
 		}
-		rsp->resid_len -= 8;
+		scsi_req(rsp)->resid_len -= 8;
 		sas_phy_control(sas_ha, req_data[9], req_data[10],
 				req_data[32] >> 4, req_data[33] >> 4,
 				resp_data);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 7f1d578..e7a7a70 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -2057,10 +2057,10 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    ioc->name, __func__,
 		    le16_to_cpu(mpi_reply->ResponseDataLength)));
 
-		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
-		req->sense_len = sizeof(*mpi_reply);
-		req->resid_len = 0;
-		rsp->resid_len -=
+		memcpy(scsi_req(req)->sense, mpi_reply, sizeof(*mpi_reply));
+		scsi_req(req)->sense_len = sizeof(*mpi_reply);
+		scsi_req(req)->resid_len = 0;
+		scsi_req(rsp)->resid_len -=
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
 
 		/* check if the resp needs to be copied from the allocated
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index ef99f62..fcb040e 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -48,6 +48,7 @@
 #include <scsi/osd_sense.h>
 
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_request.h>
 
 #include "osd_debug.h"
 
@@ -477,11 +478,13 @@ static void _set_error_resid(struct osd_request *or, struct request *req,
 {
 	or->async_error = error;
 	or->req_errors = req->errors ? : error;
-	or->sense_len = req->sense_len;
+	or->sense_len = scsi_req(req)->sense_len;
+	if (or->sense_len)
+		memcpy(or->sense, scsi_req(req)->sense, or->sense_len);
 	if (or->out.req)
-		or->out.residual = or->out.req->resid_len;
+		or->out.residual = scsi_req(or->out.req)->resid_len;
 	if (or->in.req)
-		or->in.residual = or->in.req->resid_len;
+		or->in.residual = scsi_req(or->in.req)->resid_len;
 }
 
 int osd_execute_request(struct osd_request *or)
@@ -1565,7 +1568,7 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
 	req = blk_get_request(q, has_write ? WRITE : READ, flags);
 	if (IS_ERR(req))
 		return req;
-	blk_rq_set_block_pc(req);
+	scsi_req_init(req);
 
 	for_each_bio(bio) {
 		struct bio *bounce_bio = bio;
@@ -1599,8 +1602,6 @@ static int _init_blk_request(struct osd_request *or,
 
 	req->timeout = or->timeout;
 	req->retries = or->retries;
-	req->sense = or->sense;
-	req->sense_len = 0;
 
 	if (has_out) {
 		or->out.req = req;
@@ -1612,7 +1613,7 @@ static int _init_blk_request(struct osd_request *or,
 				ret = PTR_ERR(req);
 				goto out;
 			}
-			blk_rq_set_block_pc(req);
+			scsi_req_init(req);
 			or->in.req = or->request->next_rq = req;
 		}
 	} else if (has_in)
@@ -1699,8 +1700,8 @@ int osd_finalize_request(struct osd_request *or,
 
 	osd_sec_sign_cdb(&or->cdb, cap_key);
 
-	or->request->cmd = or->cdb.buff;
-	or->request->cmd_len = _osd_req_cdb_len(or);
+	scsi_req(or->request)->cmd = or->cdb.buff;
+	scsi_req(or->request)->cmd_len = _osd_req_cdb_len(or);
 
 	return 0;
 }
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index e8196c5..d314aa5 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -322,6 +322,7 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 /* Wakeup from interrupt */
 static void osst_end_async(struct request *req, int update)
 {
+	struct scsi_request *rq = scsi_req(req);
 	struct osst_request *SRpnt = req->end_io_data;
 	struct osst_tape *STp = SRpnt->stp;
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
@@ -330,6 +331,8 @@ static void osst_end_async(struct request *req, int update)
 #if DEBUG
 	STp->write_pending = 0;
 #endif
+	if (rq->sense_len)
+		memcpy(SRpnt->sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
 
@@ -357,6 +360,7 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 			int use_sg, int timeout, int retries)
 {
 	struct request *req;
+	struct scsi_request *rq;
 	struct page **pages = NULL;
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 
@@ -367,7 +371,8 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
-	blk_rq_set_block_pc(req);
+	rq = scsi_req(req);
+	scsi_req_init(req);
 	req->rq_flags |= RQF_QUIET;
 
 	SRpnt->bio = NULL;
@@ -404,11 +409,9 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 			goto free_req;
 	}
 
-	req->cmd_len = cmd_len;
-	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = SRpnt->sense;
-	req->sense_len = 0;
+	rq->cmd_len = cmd_len;
+	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
+	memcpy(rq->cmd, cmd, rq->cmd_len);
 	req->timeout = timeout;
 	req->retries = retries;
 	req->end_io_data = SRpnt;
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 1bf8061..40ca75b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -921,7 +921,7 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 	    sizeof(response) + sizeof(uint8_t);
-	fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+	fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
 	    sizeof(struct fc_bsg_reply);
 	memcpy(fw_sts_ptr, response, sizeof(response));
 	fw_sts_ptr += sizeof(response);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5093ca9..759f281 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1472,7 +1472,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				pkt)->total_byte_count));
-			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
+				sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		else {
@@ -1486,7 +1487,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
 			bsg_reply->reply_payload_rcv_len = 0;
-			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
+			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
+					sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 02f1de1..96c33e29 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2244,7 +2244,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		memcpy(fstatus.reserved_3,
 		    pkt->reserved_2, 20 * sizeof(uint8_t));
 
-		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
+		fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
 		    sizeof(struct fc_bsg_reply);
 
 		memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7c08460..4b40f74 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1968,6 +1968,7 @@ static void eh_lock_door_done(struct request *req, int uptodate)
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	struct request *req;
+	struct scsi_request *rq;
 
 	/*
 	 * blk_get_request with GFP_KERNEL (__GFP_RECLAIM) sleeps until a
@@ -1976,17 +1977,16 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
 	if (IS_ERR(req))
 		return;
+	rq = scsi_req(req);
+	scsi_req_init(req);
 
-	blk_rq_set_block_pc(req);
-
-	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
-	req->cmd[1] = 0;
-	req->cmd[2] = 0;
-	req->cmd[3] = 0;
-	req->cmd[4] = SCSI_REMOVAL_PREVENT;
-	req->cmd[5] = 0;
-
-	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
+	rq->cmd[0] = ALLOW_MEDIUM_REMOVAL;
+	rq->cmd[1] = 0;
+	rq->cmd[2] = 0;
+	rq->cmd[3] = 0;
+	rq->cmd[4] = SCSI_REMOVAL_PREVENT;
+	rq->cmd[5] = 0;
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
 	req->rq_flags |= RQF_QUIET;
 	req->timeout = 10 * HZ;
@@ -2355,7 +2355,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	scmd = (struct scsi_cmnd *)(rq + 1);
 	scsi_init_command(dev, scmd);
 	scmd->request = rq;
-	scmd->cmnd = rq->cmd;
+	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 81ff5ad..607e1f9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -220,21 +220,21 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 {
 	struct request *req;
 	int write = (data_direction == DMA_TO_DEVICE);
+	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
 	if (IS_ERR(req))
 		return ret;
-	blk_rq_set_block_pc(req);
+	rq = scsi_req(req);
+	scsi_req_init(req);
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
 					buffer, bufflen, __GFP_RECLAIM))
 		goto out;
 
-	req->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = sense;
-	req->sense_len = 0;
+	rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(rq->cmd, cmd, rq->cmd_len);
 	req->retries = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
@@ -251,11 +251,13 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 * is invalid.  Prevent the garbage from being misinterpreted
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
-	if (unlikely(req->resid_len > 0 && req->resid_len <= bufflen))
-		memset(buffer + (bufflen - req->resid_len), 0, req->resid_len);
+	if (unlikely(rq->resid_len > 0 && rq->resid_len <= bufflen))
+		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
 
 	if (resid)
-		*resid = req->resid_len;
+		*resid = rq->resid_len;
+	if (rq->sense_len)
+		memcpy(sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	ret = req->errors;
  out:
 	blk_put_request(req);
@@ -806,16 +808,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
 		if (result) {
-			if (sense_valid && req->sense) {
+			if (sense_valid) {
 				/*
 				 * SG_IO wants current and deferred errors
 				 */
-				int len = 8 + cmd->sense_buffer[7];
-
-				if (len > SCSI_SENSE_BUFFERSIZE)
-					len = SCSI_SENSE_BUFFERSIZE;
-				memcpy(req->sense, cmd->sense_buffer,  len);
-				req->sense_len = len;
+				scsi_req(req)->sense_len =
+					min(8 + cmd->sense_buffer[7],
+					    SCSI_SENSE_BUFFERSIZE);
 			}
 			if (!sense_deferred)
 				error = __scsi_error_from_host_byte(cmd, result);
@@ -825,14 +824,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 */
 		req->errors = cmd->result;
 
-		req->resid_len = scsi_get_resid(cmd);
+		scsi_req(req)->resid_len = scsi_get_resid(cmd);
 
 		if (scsi_bidi_cmnd(cmd)) {
 			/*
 			 * Bidi commands Must be complete as a whole,
 			 * both sides at once.
 			 */
-			req->next_rq->resid_len = scsi_in(cmd)->resid;
+			scsi_req(req->next_rq)->resid_len = scsi_in(cmd)->resid;
 			if (scsi_end_request(req, 0, blk_rq_bytes(req),
 					blk_rq_bytes(req->next_rq)))
 				BUG();
@@ -1165,7 +1164,8 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	void *prot = cmd->prot_sdb;
 	unsigned long flags;
 
-	memset(cmd, 0, sizeof(*cmd));
+	memset((char *)cmd + sizeof(cmd->req), 0,
+		sizeof(*cmd) - sizeof(cmd->req));
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
@@ -1197,7 +1197,8 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 	}
 
-	cmd->cmd_len = req->cmd_len;
+	cmd->cmd_len = scsi_req(req)->cmd_len;
+	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = req->retries;
 	return BLKPREP_OK;
@@ -1217,6 +1218,7 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 			return ret;
 	}
 
+	cmd->cmnd = scsi_req(req)->cmd = scsi_req(req)->__cmd;
 	memset(cmd->cmnd, 0, BLK_MAX_CDB);
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
@@ -1355,7 +1357,6 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 
 	cmd->tag = req->tag;
 	cmd->request = req;
-	cmd->cmnd = req->cmd;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	ret = scsi_setup_cmnd(sdev, req);
@@ -1874,7 +1875,8 @@ static int scsi_mq_prep_fn(struct request *req)
 	unsigned char *sense_buf = cmd->sense_buffer;
 	struct scatterlist *sg;
 
-	memset(cmd, 0, sizeof(struct scsi_cmnd));
+	memset((char *)cmd + sizeof(cmd->req), 0,
+		sizeof(*cmd) - sizeof(cmd->req));
 
 	req->special = cmd;
 
@@ -1884,7 +1886,6 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	cmd->tag = req->tag;
 
-	cmd->cmnd = req->cmd;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	INIT_LIST_HEAD(&cmd->list);
@@ -1959,7 +1960,6 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (!scsi_host_queue_ready(q, shost, sdev))
 		goto out_dec_target_busy;
 
-
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		ret = prep_to_mq(scsi_mq_prep_fn(req));
 		if (ret != BLK_MQ_RQ_QUEUE_OK)
@@ -2036,6 +2036,7 @@ static int scsi_init_request(void *data, struct request *rq,
 		scsi_alloc_sense_buffer(shost, GFP_KERNEL, numa_node);
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
+	cmd->req.sense = cmd->sense_buffer;
 	return 0;
 }
 
@@ -2125,6 +2126,7 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
 	if (!cmd->sense_buffer)
 		goto fail;
+	cmd->req.sense = cmd->sense_buffer;
 
 	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
 		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 60b651b..126a5ee 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -33,6 +33,7 @@
 #include <linux/bsg.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_request.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -177,6 +178,10 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 	while ((req = blk_fetch_request(q)) != NULL) {
 		spin_unlock_irq(q->queue_lock);
 
+		scsi_req(req)->resid_len = blk_rq_bytes(req);
+		if (req->next_rq)
+			scsi_req(req->next_rq)->resid_len =
+				blk_rq_bytes(req->next_rq);
 		handler = to_sas_internal(shost->transportt)->f->smp_handler;
 		ret = handler(shost, rphy, req);
 		req->errors = ret;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1fbb1ec..bc8ce6b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -781,7 +781,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	rq->special_vec.bv_len = len;
 
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
-	rq->resid_len = len;
+	scsi_req(rq)->resid_len = len;
 
 	ret = scsi_init_io(cmd);
 out:
@@ -1164,7 +1164,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		__free_page(rq->special_vec.bv_page);
 
-	if (SCpnt->cmnd != rq->cmd) {
+	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
 		mempool_free(SCpnt->cmnd, sd_cdb_pool);
 		SCpnt->cmnd = NULL;
 		SCpnt->cmd_len = 0;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dbe5b4b..226a8de 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -781,9 +781,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	}
 	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
-			if (srp->rq->cmd != srp->rq->__cmd)
-				kfree(srp->rq->cmd);
-
+			scsi_req_free_cmd(scsi_req(srp->rq));
 			blk_end_request_all(srp->rq, -EIO);
 			srp->rq = NULL;
 		}
@@ -1279,6 +1277,7 @@ static void
 sg_rq_end_io(struct request *rq, int uptodate)
 {
 	struct sg_request *srp = rq->end_io_data;
+	struct scsi_request *req = scsi_req(rq);
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	unsigned long iflags;
@@ -1297,9 +1296,9 @@ sg_rq_end_io(struct request *rq, int uptodate)
 	if (unlikely(atomic_read(&sdp->detaching)))
 		pr_info("%s: device detaching\n", __func__);
 
-	sense = rq->sense;
+	sense = req->sense;
 	result = rq->errors;
-	resid = rq->resid_len;
+	resid = req->resid_len;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
 				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
@@ -1333,6 +1332,10 @@ sg_rq_end_io(struct request *rq, int uptodate)
 			sdp->device->changed = 1;
 		}
 	}
+
+	if (req->sense_len)
+		memcpy(srp->sense_b, req->sense, SCSI_SENSE_BUFFERSIZE);
+
 	/* Rely on write phase to clean out srp status values, so no "else" */
 
 	/*
@@ -1342,8 +1345,7 @@ sg_rq_end_io(struct request *rq, int uptodate)
 	 * blk_rq_unmap_user() can be called from user context.
 	 */
 	srp->rq = NULL;
-	if (rq->cmd != rq->__cmd)
-		kfree(rq->cmd);
+	scsi_req_free_cmd(scsi_req(rq));
 	__blk_put_request(rq->q, rq);
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
@@ -1658,6 +1660,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
 	int res;
 	struct request *rq;
+	struct scsi_request *req;
 	Sg_fd *sfp = srp->parentfp;
 	sg_io_hdr_t *hp = &srp->header;
 	int dxfer_len = (int) hp->dxfer_len;
@@ -1700,17 +1703,17 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 		kfree(long_cmdp);
 		return PTR_ERR(rq);
 	}
+	req = scsi_req(rq);
 
-	blk_rq_set_block_pc(rq);
+	scsi_req_init(rq);
 
 	if (hp->cmd_len > BLK_MAX_CDB)
-		rq->cmd = long_cmdp;
-	memcpy(rq->cmd, cmd, hp->cmd_len);
-	rq->cmd_len = hp->cmd_len;
+		req->cmd = long_cmdp;
+	memcpy(req->cmd, cmd, hp->cmd_len);
+	req->cmd_len = hp->cmd_len;
 
 	srp->rq = rq;
 	rq->end_io_data = srp;
-	rq->sense = srp->sense_b;
 	rq->retries = SG_DEFAULT_RETRIES;
 
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
@@ -1786,8 +1789,7 @@ sg_finish_rem_req(Sg_request *srp)
 		ret = blk_rq_unmap_user(srp->bio);
 
 	if (srp->rq) {
-		if (srp->rq->cmd != srp->rq->__cmd)
-			kfree(srp->rq->cmd);
+		scsi_req_free_cmd(scsi_req(srp->rq));
 		blk_put_request(srp->rq);
 	}
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 5f35b86..4af9001 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -475,7 +475,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 	ktime_t now;
 
 	now = ktime_get();
-	if (req->cmd[0] == WRITE_6) {
+	if (scsi_req(req)->cmd[0] == WRITE_6) {
 		now = ktime_sub(now, STp->stats->write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
@@ -489,7 +489,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		} else
 			atomic64_add(atomic_read(&STp->stats->last_write_size),
 				&STp->stats->write_byte_cnt);
-	} else if (req->cmd[0] == READ_6) {
+	} else if (scsi_req(req)->cmd[0] == READ_6) {
 		now = ktime_sub(now, STp->stats->read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
@@ -514,15 +514,18 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 static void st_scsi_execute_end(struct request *req, int uptodate)
 {
 	struct st_request *SRpnt = req->end_io_data;
+	struct scsi_request *rq = scsi_req(req);
 	struct scsi_tape *STp = SRpnt->stp;
 	struct bio *tmp;
 
 	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
-	STp->buffer->cmdstat.residual = req->resid_len;
+	STp->buffer->cmdstat.residual = rq->resid_len;
 
 	st_do_stats(STp, req);
 
 	tmp = SRpnt->bio;
+	if (rq->sense_len)
+		memcpy(SRpnt->sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
 
@@ -535,6 +538,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 			   int timeout, int retries)
 {
 	struct request *req;
+	struct scsi_request *rq;
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
@@ -544,8 +548,8 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 			      GFP_KERNEL);
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
-
-	blk_rq_set_block_pc(req);
+	rq = scsi_req(req);
+	scsi_req_init(req);
 	req->rq_flags |= RQF_QUIET;
 
 	mdata->null_mapped = 1;
@@ -571,11 +575,9 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	}
 
 	SRpnt->bio = req->bio;
-	req->cmd_len = COMMAND_SIZE(cmd[0]);
-	memset(req->cmd, 0, BLK_MAX_CDB);
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = SRpnt->sense;
-	req->sense_len = 0;
+	rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memset(rq->cmd, 0, BLK_MAX_CDB);
+	memcpy(rq->cmd, cmd, rq->cmd_len);
 	req->timeout = timeout;
 	req->retries = retries;
 	req->end_io_data = SRpnt;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 04d7aa7..e52f4e1 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1013,7 +1013,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		goto fail;
 	}
 
-	blk_rq_set_block_pc(req);
+	scsi_req_init(req);
 
 	if (sgl) {
 		ret = pscsi_map_sg(cmd, sgl, sgl_nents, req);
@@ -1023,10 +1023,8 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 
 	req->end_io = pscsi_req_done;
 	req->end_io_data = cmd;
-	req->cmd_len = scsi_command_size(pt->pscsi_cdb);
-	req->cmd = &pt->pscsi_cdb[0];
-	req->sense = &pt->pscsi_sense[0];
-	req->sense_len = 0;
+	scsi_req(req)->cmd_len = scsi_command_size(pt->pscsi_cdb);
+	scsi_req(req)->cmd = &pt->pscsi_cdb[0];
 	if (pdv->pdv_sd->type == TYPE_DISK)
 		req->timeout = PS_TIMEOUT_DISK;
 	else
@@ -1075,7 +1073,7 @@ static void pscsi_req_done(struct request *req, int uptodate)
 	struct pscsi_plugin_task *pt = cmd->priv;
 
 	pt->pscsi_result = req->errors;
-	pt->pscsi_resid = req->resid_len;
+	pt->pscsi_resid = scsi_req(req)->resid_len;
 
 	cmd->scsi_status = status_byte(pt->pscsi_result) << 1;
 	if (cmd->scsi_status) {
@@ -1096,6 +1094,7 @@ static void pscsi_req_done(struct request *req, int uptodate)
 		break;
 	}
 
+	memcpy(pt->pscsi_sense, scsi_req(req)->sense, TRANSPORT_SENSE_BUFFER);
 	__blk_put_request(req->q, req);
 	kfree(pt);
 }
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 0780ff8..930d98c 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -10,6 +10,7 @@
 #include <linux/nfsd/debug.h>
 #include <scsi/scsi_proto.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_request.h>
 
 #include "blocklayoutxdr.h"
 #include "pnfs.h"
@@ -213,6 +214,7 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 {
 	struct request_queue *q = bdev->bd_disk->queue;
 	struct request *rq;
+	struct scsi_request *req;
 	size_t bufflen = 252, len, id_len;
 	u8 *buf, *d, type, assoc;
 	int error;
@@ -226,18 +228,19 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 		error = -ENOMEM;
 		goto out_free_buf;
 	}
-	blk_rq_set_block_pc(rq);
+	req = scsi_req(rq);
+	scsi_req_init(rq);
 
 	error = blk_rq_map_kern(q, rq, buf, bufflen, GFP_KERNEL);
 	if (error)
 		goto out_put_request;
 
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 1;
-	rq->cmd[2] = 0x83;
-	rq->cmd[3] = bufflen >> 8;
-	rq->cmd[4] = bufflen & 0xff;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+	req->cmd[0] = INQUIRY;
+	req->cmd[1] = 1;
+	req->cmd[2] = 0x83;
+	req->cmd[3] = bufflen >> 8;
+	req->cmd[4] = bufflen & 0xff;
+	req->cmd_len = COMMAND_SIZE(INQUIRY);
 
 	error = blk_execute_rq(rq->q, NULL, rq, 1);
 	if (error) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 648ecf5..d7f117f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -227,17 +227,7 @@ struct request {
 
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
-	unsigned int resid_len;	/* residual count */
-	void *sense;
 
 	unsigned long deadline;
 	struct list_head timeout_list;
@@ -919,7 +909,6 @@ extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
-extern void blk_rq_set_block_pc(struct request *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index e417f08..36767ec 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -112,9 +112,10 @@ struct compat_blk_user_trace_setup {
 
 #if defined(CONFIG_EVENT_TRACING) && defined(CONFIG_BLOCK)
 
+int scsi_cmd_buf_len(struct request *rq);
 static inline int blk_cmd_buf_len(struct request *rq)
 {
-	return (rq->cmd_type == REQ_TYPE_BLOCK_PC) ? rq->cmd_len * 3 : 1;
+	return (rq->cmd_type == REQ_TYPE_BLOCK_PC) ? scsi_cmd_buf_len(rq) : 1;
 }
 
 extern void blk_dump_cmd(char *buf, struct request *rq);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a633898..086fbe1 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 /* for request_sense */
 #include <linux/cdrom.h>
+#include <scsi/scsi_cmnd.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
 
@@ -52,6 +53,11 @@ enum ata_cmd_type_bits {
 	((rq)->cmd_type == REQ_TYPE_ATA_PM_SUSPEND || \
 	 (rq)->cmd_type == REQ_TYPE_ATA_PM_RESUME)
 
+struct ide_request {
+	struct scsi_request sreq;
+	u8 sense[SCSI_SENSE_BUFFERSIZE];
+};
+
 /* Error codes returned in rq->errors to the higher part of the driver. */
 enum {
 	IDE_DRV_ERROR_GENERAL	= 101,
@@ -579,7 +585,7 @@ struct ide_drive_s {
 
 	/* current sense rq and buffer */
 	bool sense_rq_armed;
-	struct request sense_rq;
+	struct request *sense_rq;
 	struct request_sense sense_data;
 };
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9fc1aec..f708f1a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -8,6 +8,7 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_request.h>
 
 struct Scsi_Host;
 struct scsi_driver;
@@ -57,6 +58,7 @@ struct scsi_pointer {
 #define SCMD_TAGGED		(1 << 0)
 
 struct scsi_cmnd {
+	struct scsi_request req;
 	struct scsi_device *device;
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
new file mode 100644
index 0000000..c4d86c6
--- /dev/null
+++ b/include/scsi/scsi_request.h
@@ -0,0 +1,28 @@
+#ifndef _SCSI_SCSI_REQUEST_H
+#define _SCSI_SCSI_REQUEST_H
+
+#include <linux/blk-mq.h>
+
+struct scsi_request {
+	unsigned char	__cmd[BLK_MAX_CDB];
+	unsigned char	*cmd;
+	unsigned short	cmd_len;
+	unsigned int	sense_len;
+	unsigned int	resid_len;	/* residual count */
+	void		*sense;
+};
+
+static inline struct scsi_request *scsi_req(struct request *rq)
+{
+	return blk_mq_rq_to_pdu(rq);
+}
+
+void scsi_req_init(struct request *);
+
+static inline void scsi_req_free_cmd(struct scsi_request *req)
+{
+	if (req->cmd != req->__cmd)
+		kfree(req->cmd);
+}
+
+#endif /* _SCSI_SCSI_REQUEST_H */
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 95cecbf..69c36e6a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -27,6 +27,7 @@
 #include <linux/time.h>
 #include <linux/uaccess.h>
 #include <linux/list.h>
+#include <scsi/scsi_request.h>
 
 #include <trace/events/block.h>
 
@@ -715,7 +716,8 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		what |= BLK_TC_ACT(BLK_TC_PC);
 		__blk_add_trace(bt, 0, nr_bytes, req_op(rq), rq->cmd_flags,
-				what, rq->errors, rq->cmd_len, rq->cmd);
+				what, rq->errors,
+				scsi_req(rq)->cmd_len, scsi_req(rq)->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
 		__blk_add_trace(bt, blk_rq_pos(rq), nr_bytes, req_op(rq),
@@ -1751,32 +1753,32 @@ void blk_trace_remove_sysfs(struct device *dev)
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
 #ifdef CONFIG_EVENT_TRACING
-
-void blk_dump_cmd(char *buf, struct request *rq)
+static void blk_dump_scsi_cmd(char *buf, struct scsi_request *req)
 {
 	int i, end;
-	int len = rq->cmd_len;
-	unsigned char *cmd = rq->cmd;
 
-	if (rq->cmd_type != REQ_TYPE_BLOCK_PC) {
-		buf[0] = '\0';
-		return;
-	}
-
-	for (end = len - 1; end >= 0; end--)
-		if (cmd[end])
+	for (end = req->cmd_len - 1; end >= 0; end--)
+		if (req->cmd[end])
 			break;
 	end++;
 
-	for (i = 0; i < len; i++) {
-		buf += sprintf(buf, "%s%02x", i == 0 ? "" : " ", cmd[i]);
-		if (i == end && end != len - 1) {
+	for (i = 0; i < req->cmd_len; i++) {
+		buf += sprintf(buf, "%s%02x", i == 0 ? "" : " ", req->cmd[i]);
+		if (i == end && end != req->cmd_len - 1) {
 			sprintf(buf, " ..");
 			break;
 		}
 	}
 }
 
+void blk_dump_cmd(char *buf, struct request *rq)
+{
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
+		blk_dump_scsi_cmd(buf, scsi_req(rq));
+	else
+		buf[0] = '\0';
+}
+
 void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes)
 {
 	int i = 0;
-- 
2.1.4

