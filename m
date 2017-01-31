From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] block: fold cmd_type into the REQ_OP_ space
Date: Tue, 31 Jan 2017 16:57:31 +0100
Message-ID: <1485878251-6107-11-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Instead of keeping two levels of indirection for requests types, fold it
all into the operations.  The little caveat here is that previously
cmd_type only applied to struct request, while the request and bio op
fields were set to plain REQ_OP_READ/WRITE even for passthrough
operations.

Instead this patch adds new REQ_OP_* for SCSI passthrough and driver
private requests, althought it has to add two for each so that we
can communicate the data in/out nature of the request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                        | 10 -----
 block/blk-core.c                   |  6 +--
 block/blk-flush.c                  |  1 -
 block/blk-map.c                    | 13 ++++---
 block/blk-mq-debugfs.c             |  4 +-
 block/bsg.c                        | 17 ++++-----
 block/scsi_ioctl.c                 |  9 +++--
 drivers/block/cciss.c              | 13 +++++--
 drivers/block/floppy.c             |  4 +-
 drivers/block/hd.c                 | 45 +++++++++++-----------
 drivers/block/mg_disk.c            | 31 +++++++++-------
 drivers/block/nbd.c                | 19 ++++++----
 drivers/block/null_blk.c           |  4 +-
 drivers/block/osdblk.c             |  6 ---
 drivers/block/paride/pd.c          | 15 +++-----
 drivers/block/pktcdvd.c            |  2 +-
 drivers/block/ps3disk.c            | 15 +++++---
 drivers/block/rbd.c                | 22 ++++++-----
 drivers/block/sx8.c                |  4 +-
 drivers/block/virtio_blk.c         | 61 +++++++++++++++---------------
 drivers/block/xen-blkfront.c       |  2 +-
 drivers/block/xsysace.c            |  2 +-
 drivers/cdrom/cdrom.c              |  2 +-
 drivers/cdrom/gdrom.c              | 29 ++++++++-------
 drivers/ide/ide-atapi.c            | 21 ++++++-----
 drivers/ide/ide-cd.c               | 76 ++++++++++++++++++++++----------------
 drivers/ide/ide-cd_ioctl.c         |  3 +-
 drivers/ide/ide-devsets.c          |  3 +-
 drivers/ide/ide-disk.c             |  9 ++---
 drivers/ide/ide-eh.c               |  2 +-
 drivers/ide/ide-floppy.c           | 19 +++++-----
 drivers/ide/ide-io.c               |  2 +-
 drivers/ide/ide-ioctls.c           |  6 +--
 drivers/ide/ide-park.c             |  6 +--
 drivers/ide/ide-pm.c               | 10 ++---
 drivers/ide/ide-tape.c             |  5 +--
 drivers/ide/ide-taskfile.c         |  6 +--
 drivers/mtd/mtd_blkdevs.c          | 13 +++----
 drivers/mtd/ubi/block.c            | 15 ++++----
 drivers/nvme/host/core.c           | 26 +++++++++----
 drivers/nvme/host/rdma.c           |  2 +-
 drivers/scsi/osd/osd_initiator.c   |  3 +-
 drivers/scsi/osst.c                |  3 +-
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_lib.c            | 30 +++++++--------
 drivers/scsi/sg.c                  |  3 +-
 drivers/scsi/sr.c                  |  9 +++--
 drivers/scsi/st.c                  |  6 +--
 drivers/target/target_core_pscsi.c |  3 +-
 fs/nfsd/blocklayout.c              |  2 +-
 include/linux/blk_types.h          |  7 ++++
 include/linux/blkdev.h             | 22 +++++------
 include/linux/ide.h                | 14 +++----
 53 files changed, 338 insertions(+), 326 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2b37502..9a2dd71 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1227,9 +1227,6 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	if (!bio)
 		goto out_bmd;
 
-	if (iter->type & WRITE)
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
-
 	ret = 0;
 
 	if (map_data) {
@@ -1394,12 +1391,6 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 
 	kfree(pages);
 
-	/*
-	 * set data direction, and check if mapped pages need bouncing
-	 */
-	if (iter->type & WRITE)
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
-
 	bio_set_flag(bio, BIO_USER_MAPPED);
 
 	/*
@@ -1590,7 +1581,6 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		bio->bi_private = data;
 	} else {
 		bio->bi_end_io = bio_copy_kern_endio;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	}
 
 	return bio;
diff --git a/block/blk-core.c b/block/blk-core.c
index f5c9f40..e1fc4f7f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -158,8 +158,8 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
 {
-	printk(KERN_INFO "%s: dev %s: type=%x, flags=%llx\n", msg,
-		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
+	printk(KERN_INFO "%s: dev %s: flags=%llx\n", msg,
+		rq->rq_disk ? rq->rq_disk->disk_name : "?",
 		(unsigned long long) rq->cmd_flags);
 
 	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
@@ -1593,7 +1593,6 @@ unsigned int blk_plug_queued_count(struct request_queue *q)
 
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
-	req->cmd_type = REQ_TYPE_FS;
 	if (bio->bi_opf & REQ_RAHEAD)
 		req->cmd_flags |= REQ_FAILFAST_MASK;
 
@@ -2983,7 +2982,6 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
-	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
 	dst->nr_phys_segments = src->nr_phys_segments;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 0a0358e..9681625 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -327,7 +327,6 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 		blk_mq_tag_set_rq(hctx, first_rq->tag, flush_rq);
 	}
 
-	flush_rq->cmd_type = REQ_TYPE_FS;
 	flush_rq->cmd_flags = REQ_OP_FLUSH | REQ_PREFLUSH;
 	flush_rq->rq_flags |= RQF_FLUSH_SEQ;
 	flush_rq->rq_disk = first_rq->rq_disk;
diff --git a/block/blk-map.c b/block/blk-map.c
index 0acb664..2f18c2a 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -16,8 +16,6 @@
 int blk_rq_append_bio(struct request *rq, struct bio *bio)
 {
 	if (!rq->bio) {
-		rq->cmd_flags &= REQ_OP_MASK;
-		rq->cmd_flags |= (bio->bi_opf & REQ_OP_MASK);
 		blk_rq_bio_prep(rq->q, rq, bio);
 	} else {
 		if (!ll_back_merge_fn(rq->q, rq, bio))
@@ -62,6 +60,9 @@ static int __blk_rq_map_user_iov(struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
+	bio->bi_opf &= ~REQ_OP_MASK;
+	bio->bi_opf |= req_op(rq);
+
 	if (map_data && map_data->null_mapped)
 		bio_set_flag(bio, BIO_NULL_MAPPED);
 
@@ -90,7 +91,7 @@ static int __blk_rq_map_user_iov(struct request *rq,
 }
 
 /**
- * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
+ * blk_rq_map_user_iov - map user data to a request, for passthrough requests
  * @q:		request queue where request should be inserted
  * @rq:		request to map data to
  * @map_data:   pointer to the rq_map_data holding pages (if necessary)
@@ -199,7 +200,7 @@ int blk_rq_unmap_user(struct bio *bio)
 EXPORT_SYMBOL(blk_rq_unmap_user);
 
 /**
- * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
+ * blk_rq_map_kern - map kernel data to a request, for passthrough requests
  * @q:		request queue where request should be inserted
  * @rq:		request to fill
  * @kbuf:	the kernel buffer
@@ -234,8 +235,8 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (!reading)
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+	bio->bi_opf &= ~REQ_OP_MASK;
+	bio->bi_opf |= req_op(rq);
 
 	if (do_copy)
 		rq->rq_flags |= RQF_COPY_USER;
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 5cd2b43..1e2a4a2 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -88,8 +88,8 @@ static int blk_mq_debugfs_rq_show(struct seq_file *m, void *v)
 {
 	struct request *rq = list_entry_rq(v);
 
-	seq_printf(m, "%p {.cmd_type=%u, .cmd_flags=0x%x, .rq_flags=0x%x, .tag=%d, .internal_tag=%d}\n",
-		   rq, rq->cmd_type, rq->cmd_flags, (unsigned int)rq->rq_flags,
+	seq_printf(m, "%p {.cmd_flags=0x%x, .rq_flags=0x%x, .tag=%d, .internal_tag=%d}\n",
+		   rq, rq->cmd_flags, (unsigned int)rq->rq_flags,
 		   rq->tag, rq->internal_tag);
 	return 0;
 }
diff --git a/block/bsg.c b/block/bsg.c
index e34c332..a9a8b8e 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -177,7 +177,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
  * Check if sg_io_v4 from user is allowed and valid
  */
 static int
-bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *rw)
+bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *op)
 {
 	int ret = 0;
 
@@ -198,7 +198,7 @@ bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *rw)
 		ret = -EINVAL;
 	}
 
-	*rw = hdr->dout_xfer_len ? WRITE : READ;
+	*op = hdr->dout_xfer_len ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
 	return ret;
 }
 
@@ -210,8 +210,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
-	int ret, rw;
-	unsigned int dxfer_len;
+	int ret;
+	unsigned int op, dxfer_len;
 	void __user *dxferp = NULL;
 	struct bsg_class_device *bcd = &q->bsg_dev;
 
@@ -226,14 +226,14 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
 		hdr->din_xfer_len);
 
-	ret = bsg_validate_sgv4_hdr(hdr, &rw);
+	ret = bsg_validate_sgv4_hdr(hdr, &op);
 	if (ret)
 		return ERR_PTR(ret);
 
 	/*
 	 * map scatter-gather elements separately and string them to request
 	 */
-	rq = blk_get_request(q, rw, GFP_KERNEL);
+	rq = blk_get_request(q, op, GFP_KERNEL);
 	if (IS_ERR(rq))
 		return rq;
 	scsi_req_init(rq);
@@ -242,20 +242,19 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 	if (ret)
 		goto out;
 
-	if (rw == WRITE && hdr->din_xfer_len) {
+	if (op == REQ_OP_SCSI_OUT && hdr->din_xfer_len) {
 		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
 			ret = -EOPNOTSUPP;
 			goto out;
 		}
 
-		next_rq = blk_get_request(q, READ, GFP_KERNEL);
+		next_rq = blk_get_request(q, REQ_OP_SCSI_IN, GFP_KERNEL);
 		if (IS_ERR(next_rq)) {
 			ret = PTR_ERR(next_rq);
 			next_rq = NULL;
 			goto out;
 		}
 		rq->next_rq = next_rq;
-		next_rq->cmd_type = rq->cmd_type;
 
 		dxferp = (void __user *)(unsigned long)hdr->din_xferp;
 		ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 7edf44f..2a2fc76 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -321,7 +321,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		at_head = 1;
 
 	ret = -ENOMEM;
-	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
+	rq = blk_get_request(q, writing ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			GFP_KERNEL);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = scsi_req(rq);
@@ -448,7 +449,8 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	}
 
-	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_RECLAIM);
+	rq = blk_get_request(q, in_len ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			__GFP_RECLAIM);
 	if (IS_ERR(rq)) {
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
@@ -537,7 +539,7 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	struct request *rq;
 	int err;
 
-	rq = blk_get_request(q, WRITE, __GFP_RECLAIM);
+	rq = blk_get_request(q, REQ_OP_SCSI_OUT, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scsi_req_init(rq);
@@ -745,7 +747,6 @@ void scsi_req_init(struct request *rq)
 {
 	struct scsi_request *req = scsi_req(rq);
 
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	memset(req->__cmd, 0, sizeof(req->__cmd));
 	req->cmd = req->__cmd;
 	req->cmd_len = BLK_MAX_CDB;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 53dc297..f21c2f0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3394,7 +3394,9 @@ static void do_cciss_request(struct request_queue *q)
 		c->Header.SGList = h->max_cmd_sgentries;
 	set_performant_mode(h, c);
 
-	if (likely(creq->cmd_type == REQ_TYPE_FS)) {
+	switch (req_op(creq)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
 		if(h->cciss_read == CCISS_READ_10) {
 			c->Request.CDB[1] = 0;
 			c->Request.CDB[2] = (start_blk >> 24) & 0xff; /* MSB */
@@ -3424,13 +3426,16 @@ static void do_cciss_request(struct request_queue *q)
 			c->Request.CDB[13]= blk_rq_sectors(creq) & 0xff;
 			c->Request.CDB[14] = c->Request.CDB[15] = 0;
 		}
-	} else if (creq->cmd_type == REQ_TYPE_BLOCK_PC) {
+		break;
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
 		c->Request.CDBLen = scsi_req(creq)->cmd_len;
 		memcpy(c->Request.CDB, scsi_req(creq)->cmd, BLK_MAX_CDB);
 		scsi_req(creq)->sense = c->err_info->SenseInfo;
-	} else {
+		break;
+	default:
 		dev_warn(&h->pdev->dev, "bad request type %d\n",
-			creq->cmd_type);
+			creq->cmd_flags);
 		BUG();
 	}
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 184887a..45b4384 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2900,8 +2900,8 @@ static void do_fd_request(struct request_queue *q)
 		return;
 
 	if (WARN(atomic_read(&usage_count) == 0,
-		 "warning: usage count=0, current_req=%p sect=%ld type=%x flags=%llx\n",
-		 current_req, (long)blk_rq_pos(current_req), current_req->cmd_type,
+		 "warning: usage count=0, current_req=%p sect=%ld flags=%llx\n",
+		 current_req, (long)blk_rq_pos(current_req),
 		 (unsigned long long) current_req->cmd_flags))
 		return;
 
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index a9b48ed..6043648 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -626,30 +626,29 @@ static void hd_request(void)
 		req_data_dir(req) == READ ? "read" : "writ",
 		cyl, head, sec, nsect, bio_data(req->bio));
 #endif
-	if (req->cmd_type == REQ_TYPE_FS) {
-		switch (rq_data_dir(req)) {
-		case READ:
-			hd_out(disk, nsect, sec, head, cyl, ATA_CMD_PIO_READ,
-				&read_intr);
-			if (reset)
-				goto repeat;
-			break;
-		case WRITE:
-			hd_out(disk, nsect, sec, head, cyl, ATA_CMD_PIO_WRITE,
-				&write_intr);
-			if (reset)
-				goto repeat;
-			if (wait_DRQ()) {
-				bad_rw_intr();
-				goto repeat;
-			}
-			outsw(HD_DATA, bio_data(req->bio), 256);
-			break;
-		default:
-			printk("unknown hd-command\n");
-			hd_end_request_cur(-EIO);
-			break;
+
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		hd_out(disk, nsect, sec, head, cyl, ATA_CMD_PIO_READ,
+			&read_intr);
+		if (reset)
+			goto repeat;
+		break;
+	case REQ_OP_WRITE:
+		hd_out(disk, nsect, sec, head, cyl, ATA_CMD_PIO_WRITE,
+			&write_intr);
+		if (reset)
+			goto repeat;
+		if (wait_DRQ()) {
+			bad_rw_intr();
+			goto repeat;
 		}
+		outsw(HD_DATA, bio_data(req->bio), 256);
+		break;
+	default:
+		printk("unknown hd-command\n");
+		hd_end_request_cur(-EIO);
+		break;
 	}
 }
 
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index e937fcf7..286f276 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -670,15 +670,17 @@ static void mg_request_poll(struct request_queue *q)
 				break;
 		}
 
-		if (unlikely(host->req->cmd_type != REQ_TYPE_FS)) {
-			mg_end_request_cur(host, -EIO);
-			continue;
-		}
-
-		if (rq_data_dir(host->req) == READ)
+		switch (req_op(host->req)) {
+		case REQ_OP_READ:
 			mg_read(host->req);
-		else
+			break;
+		case REQ_OP_WRITE:
 			mg_write(host->req);
+			break;
+		default:
+			mg_end_request_cur(host, -EIO);
+			break;
+		}
 	}
 }
 
@@ -687,13 +689,15 @@ static unsigned int mg_issue_req(struct request *req,
 		unsigned int sect_num,
 		unsigned int sect_cnt)
 {
-	if (rq_data_dir(req) == READ) {
+	switch (req_op(host->req)) {
+	case REQ_OP_READ:
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr)
 				!= MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
-	} else {
+		break;
+	case REQ_OP_WRITE:
 		/* TODO : handler */
 		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr)
@@ -712,6 +716,10 @@ static unsigned int mg_issue_req(struct request *req,
 		mod_timer(&host->timer, jiffies + 3 * HZ);
 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
 				MG_REG_COMMAND);
+		break;
+	default:
+		mg_end_request_cur(host, -EIO);
+		break;
 	}
 	return MG_ERR_NONE;
 }
@@ -753,11 +761,6 @@ static void mg_request(struct request_queue *q)
 			continue;
 		}
 
-		if (unlikely(req->cmd_type != REQ_TYPE_FS)) {
-			mg_end_request_cur(host, -EIO);
-			continue;
-		}
-
 		if (!mg_issue_req(req, host, sect_num, sect_cnt))
 			return;
 	}
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 8bce1c7c..58296e4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -271,17 +271,22 @@ static int nbd_send_cmd(struct nbd_device *nbd, struct nbd_cmd *cmd, int index)
 	u32 type;
 	u32 tag = blk_mq_unique_tag(req);
 
-	if (req->cmd_type != REQ_TYPE_FS)
-		return -EIO;
-
-	if (req_op(req) == REQ_OP_DISCARD)
+	switch (req_op(req)) {
+	case REQ_OP_DISCARD:
 		type = NBD_CMD_TRIM;
-	else if (req_op(req) == REQ_OP_FLUSH)
+		break;
+	case REQ_OP_FLUSH:
 		type = NBD_CMD_FLUSH;
-	else if (rq_data_dir(req) == WRITE)
+		break;
+	case REQ_OP_WRITE:
 		type = NBD_CMD_WRITE;
-	else
+		break;
+	case REQ_OP_READ:
 		type = NBD_CMD_READ;
+		break;
+	default:
+		return -EIO;
+	}
 
 	if (rq_data_dir(req) == WRITE &&
 	    (nbd->flags & NBD_FLAG_READ_ONLY)) {
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index c0e14e5..4335b84 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -431,11 +431,11 @@ static int null_lnvm_submit_io(struct nvm_dev *dev, struct nvm_rq *rqd)
 	struct request *rq;
 	struct bio *bio = rqd->bio;
 
-	rq = blk_mq_alloc_request(q, bio_data_dir(bio), 0);
+	rq = blk_mq_alloc_request(q,
+		op_is_write(bio_op(bio)) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
 		return -ENOMEM;
 
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->__sector = bio->bi_iter.bi_sector;
 	rq->ioprio = bio_prio(bio);
 
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index 92900f5..8127b82 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -308,12 +308,6 @@ static void osdblk_rq_fn(struct request_queue *q)
 		if (!rq)
 			break;
 
-		/* filter out block requests we don't understand */
-		if (rq->cmd_type != REQ_TYPE_FS) {
-			blk_end_request_all(rq, 0);
-			continue;
-		}
-
 		/* deduce our operation (read, write, flush) */
 		/* I wish the block layer simplified cmd_type/cmd_flags/cmd[]
 		 * into a clearly defined set of RPC commands:
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index c3ed2fc..644ba08 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -439,18 +439,16 @@ static int pd_retries = 0;	/* i/o error retry count */
 static int pd_block;		/* address of next requested block */
 static int pd_count;		/* number of blocks still to do */
 static int pd_run;		/* sectors in current cluster */
-static int pd_cmd;		/* current command READ/WRITE */
 static char *pd_buf;		/* buffer for request in progress */
 
 static enum action do_pd_io_start(void)
 {
-	if (pd_req->cmd_type == REQ_TYPE_DRV_PRIV) {
+	switch (req_op(pd_req)) {
+	case REQ_OP_DRV_IN:
 		phase = pd_special;
 		return pd_special();
-	}
-
-	pd_cmd = rq_data_dir(pd_req);
-	if (pd_cmd == READ || pd_cmd == WRITE) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
 		pd_block = blk_rq_pos(pd_req);
 		pd_count = blk_rq_cur_sectors(pd_req);
 		if (pd_block + pd_count > get_capacity(pd_req->rq_disk))
@@ -458,7 +456,7 @@ static enum action do_pd_io_start(void)
 		pd_run = blk_rq_sectors(pd_req);
 		pd_buf = bio_data(pd_req->bio);
 		pd_retries = 0;
-		if (pd_cmd == READ)
+		if (req_op(pd_req) == REQ_OP_READ)
 			return do_pd_read_start();
 		else
 			return do_pd_write_start();
@@ -723,11 +721,10 @@ static int pd_special_command(struct pd_unit *disk,
 	struct request *rq;
 	int err = 0;
 
-	rq = blk_get_request(disk->gd->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(disk->gd->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	rq->special = func;
 
 	err = blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 918a92c..f4bd959 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -704,7 +704,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	int ret = 0;
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
-			     WRITE : READ, __GFP_RECLAIM);
+			     REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scsi_req_init(rq);
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 76f33c8..a809e3e 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -196,16 +196,19 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
 	while ((req = blk_fetch_request(q))) {
-		if (req_op(req) == REQ_OP_FLUSH) {
+		switch (req_op(req)) {
+		case REQ_OP_FLUSH:
 			if (ps3disk_submit_flush_request(dev, req))
-				break;
-		} else if (req->cmd_type == REQ_TYPE_FS) {
+				return;
+			break;
+		case REQ_OP_READ:
+		case REQ_OP_WRITE:
 			if (ps3disk_submit_request_sg(dev, req))
-				break;
-		} else {
+				return;
+			break;
+		default:
 			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
 			__blk_end_request_all(req, -EIO);
-			continue;
 		}
 	}
 }
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 36d2b9f..4d78cf6 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4099,19 +4099,21 @@ static void rbd_queue_workfn(struct work_struct *work)
 	bool must_be_locked;
 	int result;
 
-	if (rq->cmd_type != REQ_TYPE_FS) {
-		dout("%s: non-fs request type %d\n", __func__,
-			(int) rq->cmd_type);
-		result = -EIO;
-		goto err;
-	}
-
-	if (req_op(rq) == REQ_OP_DISCARD)
+	switch (req_op(rq)) {
+	case REQ_OP_DISCARD:
 		op_type = OBJ_OP_DISCARD;
-	else if (req_op(rq) == REQ_OP_WRITE)
+		break;
+	case REQ_OP_WRITE:
 		op_type = OBJ_OP_WRITE;
-	else
+		break;
+	case REQ_OP_READ:
 		op_type = OBJ_OP_READ;
+		break;
+	default:
+		dout("%s: non-fs request type %d\n", __func__, req_op(rq));
+		result = -EIO;
+		goto err;
+	}
 
 	/* Ignore/skip any zero-length requests */
 
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 0e93ad7..c8e072c 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -567,7 +567,7 @@ static struct carm_request *carm_get_special(struct carm_host *host)
 	if (!crq)
 		return NULL;
 
-	rq = blk_get_request(host->oob_q, WRITE /* bogus */, GFP_KERNEL);
+	rq = blk_get_request(host->oob_q, REQ_OP_DRV_OUT, GFP_KERNEL);
 	if (IS_ERR(rq)) {
 		spin_lock_irqsave(&host->lock, flags);
 		carm_put_request(host, crq);
@@ -620,7 +620,6 @@ static int carm_array_info (struct carm_host *host, unsigned int array_idx)
 	spin_unlock_irq(&host->lock);
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", idx);
-	crq->rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	crq->rq->special = crq;
 	blk_execute_rq_nowait(host->oob_q, NULL, crq->rq, true, NULL);
 
@@ -661,7 +660,6 @@ static int carm_send_special (struct carm_host *host, carm_sspc_t func)
 	crq->msg_bucket = (u32) rc;
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", idx);
-	crq->rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	crq->rq->special = crq;
 	blk_execute_rq_nowait(host->oob_q, NULL, crq->rq, true, NULL);
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index d9491bd..a363170 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -175,11 +175,12 @@ static inline void virtblk_request_done(struct request *req)
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	int error = virtblk_result(vbr);
 
-	switch (req->cmd_type) {
-	case REQ_TYPE_BLOCK_PC:
+	switch (req_op(req)) {
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
 		virtblk_scsi_reques_done(req);
 		break;
-	case REQ_TYPE_DRV_PRIV:
+	case REQ_OP_DRV_IN:
 		req->errors = (error != 0);
 		break;
 	}
@@ -226,36 +227,35 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int qid = hctx->queue_num;
 	int err;
 	bool notify = false;
+	u32 type;
 
 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
-	if (req_op(req) == REQ_OP_FLUSH) {
-		vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_FLUSH);
-		vbr->out_hdr.sector = 0;
-		vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
-	} else {
-		switch (req->cmd_type) {
-		case REQ_TYPE_FS:
-			vbr->out_hdr.type = 0;
-			vbr->out_hdr.sector = cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
-			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
-			break;
-		case REQ_TYPE_BLOCK_PC:
-			vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_SCSI_CMD);
-			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
-			break;
-		case REQ_TYPE_DRV_PRIV:
-			vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
-			vbr->out_hdr.sector = 0;
-			vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
-			break;
-		default:
-			/* We don't put anything else in the queue. */
-			BUG();
-		}
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		type = 0;
+		break;
+	case REQ_OP_FLUSH:
+		type = VIRTIO_BLK_T_FLUSH;
+		break;
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
+		type = VIRTIO_BLK_T_SCSI_CMD;
+		break;
+	case REQ_OP_DRV_IN:
+		type = VIRTIO_BLK_T_GET_ID;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
 
+	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, type);
+	vbr->out_hdr.sector = type ?
+		0 : cpu_to_virtio64(vblk->vdev, blk_rq_pos(req));
+	vbr->out_hdr.ioprio = cpu_to_virtio32(vblk->vdev, req_get_ioprio(req));
+
 	blk_mq_start_request(req);
 
 	num = blk_rq_map_sg(hctx->queue, req, vbr->sg);
@@ -267,7 +267,7 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
-	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+	if (req_op(req) == REQ_OP_SCSI_IN || req_op(req) == REQ_OP_SCSI_OUT)
 		err = virtblk_add_req_scsi(vblk->vqs[qid].vq, vbr, vbr->sg, num);
 	else
 		err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
@@ -300,10 +300,9 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	struct request *req;
 	int err;
 
-	req = blk_get_request(q, READ, GFP_KERNEL);
+	req = blk_get_request(q, REQ_OP_DRV_IN, GFP_KERNEL);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-	req->cmd_type = REQ_TYPE_DRV_PRIV;
 
 	err = blk_rq_map_kern(q, req, id_str, VIRTIO_BLK_ID_BYTES, GFP_KERNEL);
 	if (err)
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b2bdfa8..9a8cb22 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -865,7 +865,7 @@ static inline void flush_requests(struct blkfront_ring_info *rinfo)
 static inline bool blkif_request_flush_invalid(struct request *req,
 					       struct blkfront_info *info)
 {
-	return ((req->cmd_type != REQ_TYPE_FS) ||
+	return (blk_rq_is_passthrough(req) ||
 		((req_op(req) == REQ_OP_FLUSH) &&
 		 !info->feature_flush) ||
 		((req->cmd_flags & REQ_FUA) &&
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index c4328d9..757dce2 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -468,7 +468,7 @@ static struct request *ace_get_next_request(struct request_queue *q)
 	struct request *req;
 
 	while ((req = blk_peek_request(q)) != NULL) {
-		if (req->cmd_type == REQ_TYPE_FS)
+		if (!blk_rq_is_passthrough(req))
 			break;
 		blk_start_request(req);
 		__blk_end_request_all(req, -EIO);
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 36f5237..8f496b4 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2191,7 +2191,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		rq = blk_get_request(q, READ, GFP_KERNEL);
+		rq = blk_get_request(q, REQ_OP_SCSI_IN, GFP_KERNEL);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			break;
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 584bc31..b6f1a5d 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -659,23 +659,24 @@ static void gdrom_request(struct request_queue *rq)
 	struct request *req;
 
 	while ((req = blk_fetch_request(rq)) != NULL) {
-		if (req->cmd_type != REQ_TYPE_FS) {
-			printk(KERN_DEBUG "gdrom: Non-fs request ignored\n");
-			__blk_end_request_all(req, -EIO);
-			continue;
-		}
-		if (rq_data_dir(req) != READ) {
+		switch (req_op(req)) {
+		case REQ_OP_READ:
+			/*
+			 * Add to list of deferred work and then schedule
+			 * workqueue.
+			 */
+			list_add_tail(&req->queuelist, &gdrom_deferred);
+			schedule_work(&work);
+			break;
+		case REQ_OP_WRITE:
 			pr_notice("Read only device - write request ignored\n");
 			__blk_end_request_all(req, -EIO);
-			continue;
+			break;
+		default:
+			printk(KERN_DEBUG "gdrom: Non-fs request ignored\n");
+			__blk_end_request_all(req, -EIO);
+			break;
 		}
-
-		/*
-		 * Add to list of deferred work and then schedule
-		 * workqueue.
-		 */
-		list_add_tail(&req->queuelist, &gdrom_deferred);
-		schedule_work(&work);
 	}
 }
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index a8c650e..feb3006 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -92,9 +92,8 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	struct request *rq;
 	int error;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->special = (char *)pc;
 
@@ -212,7 +211,7 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	}
 
 	sense_rq->rq_disk = rq->rq_disk;
-	sense_rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	sense_rq->cmd_flags = REQ_OP_DRV_IN;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
 	sense_rq->rq_flags |= RQF_PREEMPT;
 
@@ -312,19 +311,21 @@ EXPORT_SYMBOL_GPL(ide_cd_expiry);
 
 int ide_cd_get_xferlen(struct request *rq)
 {
-	switch (rq->cmd_type) {
-	case REQ_TYPE_FS:
+	switch (req_op(rq)) {
+	default:
 		return 32768;
-	case REQ_TYPE_BLOCK_PC:
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
 		return blk_rq_bytes(rq);
-	case REQ_TYPE_DRV_PRIV:
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
 		switch (ide_req(rq)->type) {
 		case ATA_PRIV_PC:
 		case ATA_PRIV_SENSE:
 			return blk_rq_bytes(rq);
+		default:
+			return 0;
 		}
-	default:
-		return 0;
 	}
 }
 EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
@@ -491,7 +492,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 			error = 0;
 		} else {
 
-			if (rq->cmd_type != REQ_TYPE_FS && uptodate <= 0) {
+			if (blk_rq_is_passthrough(rq) && uptodate <= 0) {
 				if (rq->errors == 0)
 					rq->errors = -EIO;
 			}
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 207af78..dc039d1 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -176,7 +176,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 			if (!sense->valid)
 				break;
 			if (failed_command == NULL ||
-			    failed_command->cmd_type != REQ_TYPE_FS)
+			    blk_rq_is_passthrough(failed_command))
 				break;
 			sector = (sense->information[0] << 24) |
 				 (sense->information[1] << 16) |
@@ -293,7 +293,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	}
 
 	/* if we have an error, pass CHECK_CONDITION as the SCSI status byte */
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && !rq->errors)
+	if (blk_rq_is_scsi(rq) && !rq->errors)
 		rq->errors = SAM_STAT_CHECK_CONDITION;
 
 	if (blk_noretry_request(rq))
@@ -301,13 +301,13 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 
 	switch (sense_key) {
 	case NOT_READY:
-		if (rq->cmd_type == REQ_TYPE_FS && rq_data_dir(rq) == WRITE) {
+		if (req_op(rq) == REQ_OP_WRITE) {
 			if (ide_cd_breathe(drive, rq))
 				return 1;
 		} else {
 			cdrom_saw_media_change(drive);
 
-			if (rq->cmd_type == REQ_TYPE_FS &&
+			if (!blk_rq_is_passthrough(rq) &&
 			    !(rq->rq_flags & RQF_QUIET))
 				printk(KERN_ERR PFX "%s: tray open\n",
 					drive->name);
@@ -317,7 +317,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 	case UNIT_ATTENTION:
 		cdrom_saw_media_change(drive);
 
-		if (rq->cmd_type != REQ_TYPE_FS)
+		if (blk_rq_is_passthrough(rq))
 			return 0;
 
 		/*
@@ -365,7 +365,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 		do_end_request = 1;
 		break;
 	default:
-		if (rq->cmd_type != REQ_TYPE_FS)
+		if (blk_rq_is_passthrough(rq))
 			break;
 		if (err & ~ATA_ABORTED) {
 			/* go to the default handler for other errors */
@@ -376,7 +376,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 			do_end_request = 1;
 	}
 
-	if (rq->cmd_type != REQ_TYPE_FS) {
+	if (blk_rq_is_passthrough(rq)) {
 		rq->rq_flags |= RQF_FAILED;
 		do_end_request = 1;
 	}
@@ -435,10 +435,10 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 		int error;
 		bool delay = false;
 
-		rq = blk_get_request(drive->queue, write, __GFP_RECLAIM);
+		rq = blk_get_request(drive->queue,
+			write ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,  __GFP_RECLAIM);
 		scsi_req_init(rq);
 		memcpy(scsi_req(rq)->cmd, cmd, BLK_MAX_CDB);
-		rq->cmd_type = REQ_TYPE_DRV_PRIV;
 		ide_req(rq)->type = ATA_PRIV_PC;
 		rq->rq_flags |= rq_flags;
 		rq->timeout = timeout;
@@ -564,7 +564,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	ide_read_bcount_and_ireason(drive, &len, &ireason);
 
-	thislen = (rq->cmd_type == REQ_TYPE_FS) ? len : cmd->nleft;
+	thislen = !blk_rq_is_passthrough(rq) ? len : cmd->nleft;
 	if (thislen > len)
 		thislen = len;
 
@@ -573,7 +573,8 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	/* If DRQ is clear, the command has completed. */
 	if ((stat & ATA_DRQ) == 0) {
-		if (rq->cmd_type == REQ_TYPE_FS) {
+		switch (req_op(rq)) {
+		default:
 			/*
 			 * If we're not done reading/writing, complain.
 			 * Otherwise, complete the command normally.
@@ -587,7 +588,9 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 					rq->rq_flags |= RQF_FAILED;
 				uptodate = 0;
 			}
-		} else if (rq->cmd_type != REQ_TYPE_BLOCK_PC) {
+			goto out_end;
+		case REQ_OP_DRV_IN:
+		case REQ_OP_DRV_OUT:
 			ide_cd_request_sense_fixup(drive, cmd);
 
 			uptodate = cmd->nleft ? 0 : 1;
@@ -603,8 +606,11 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 			if (!uptodate)
 				rq->rq_flags |= RQF_FAILED;
+			goto out_end;
+		case REQ_OP_SCSI_IN:
+		case REQ_OP_SCSI_OUT:
+			goto out_end;
 		}
-		goto out_end;
 	}
 
 	rc = ide_check_ireason(drive, rq, len, ireason, write);
@@ -636,7 +642,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 
 	/* pad, if necessary */
 	if (len > 0) {
-		if (rq->cmd_type != REQ_TYPE_FS || write == 0)
+		if (blk_rq_is_passthrough(rq) || write == 0)
 			ide_pad_transfer(drive, write, len);
 		else {
 			printk(KERN_ERR PFX "%s: confused, missing data\n",
@@ -645,12 +651,18 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		}
 	}
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
+	switch (req_op(rq)) {
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
 		timeout = rq->timeout;
-	} else {
+		break;
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
+		expiry = ide_cd_expiry;
+		/*FALLTHRU*/
+	default:
 		timeout = ATAPI_WAIT_PC;
-		if (rq->cmd_type != REQ_TYPE_FS)
-			expiry = ide_cd_expiry;
+		break;
 	}
 
 	hwif->expiry = expiry;
@@ -658,7 +670,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	return ide_started;
 
 out_end:
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC && rc == 0) {
+	if (blk_rq_is_scsi(rq) && rc == 0) {
 		scsi_req(rq)->resid_len = 0;
 		blk_end_request_all(rq, 0);
 		hwif->rq = NULL;
@@ -666,7 +678,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		if (sense && uptodate)
 			ide_cd_complete_failed_rq(drive, rq);
 
-		if (rq->cmd_type == REQ_TYPE_FS) {
+		if (!blk_rq_is_passthrough(rq)) {
 			if (cmd->nleft == 0)
 				uptodate = 1;
 		} else {
@@ -679,7 +691,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 				return ide_stopped;
 
 		/* make sure it's fully ended */
-		if (rq->cmd_type != REQ_TYPE_FS) {
+		if (blk_rq_is_passthrough(rq)) {
 			scsi_req(rq)->resid_len -= cmd->nbytes - cmd->nleft;
 			if (uptodate == 0 && (cmd->tf_flags & IDE_TFLAG_WRITE))
 				scsi_req(rq)->resid_len += cmd->last_xfer_len;
@@ -739,7 +751,7 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	ide_debug_log(IDE_DBG_PC, "rq->cmd[0]: 0x%x, rq->cmd_type: 0x%x",
 				  rq->cmd[0], rq->cmd_type);
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
+	if (blk_rq_is_scsi(rq))
 		rq->rq_flags |= RQF_QUIET;
 	else
 		rq->rq_flags &= ~RQF_FAILED;
@@ -781,18 +793,20 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	if (drive->debug_mask & IDE_DBG_RQ)
 		blk_dump_rq_flags(rq, "ide_cd_do_request");
 
-	switch (rq->cmd_type) {
-	case REQ_TYPE_FS:
+	switch (req_op(rq)) {
+	default:
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
 			goto out_end;
 		break;
-	case REQ_TYPE_BLOCK_PC:
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
 	handle_pc:
 		if (!rq->timeout)
 			rq->timeout = ATAPI_WAIT_PC;
 		cdrom_do_block_pc(drive, rq);
 		break;
-	case REQ_TYPE_DRV_PRIV:
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
 		switch (ide_req(rq)->type) {
 		case ATA_PRIV_MISC:
 			/* right now this can only be a reset... */
@@ -801,9 +815,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		case ATA_PRIV_SENSE:
 		case ATA_PRIV_PC:
 			goto handle_pc;
+		default:
+			BUG();
 		}
-	default:
-		BUG();
 	}
 
 	/* prepare sense request for this command */
@@ -816,7 +830,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	cmd.rq = rq;
 
-	if (rq->cmd_type == REQ_TYPE_FS || blk_rq_bytes(rq)) {
+	if (!blk_rq_is_passthrough(rq) || blk_rq_bytes(rq)) {
 		ide_init_sg_cmd(&cmd, blk_rq_bytes(rq));
 		ide_map_sg(drive, &cmd);
 	}
@@ -1373,9 +1387,9 @@ static int ide_cdrom_prep_pc(struct request *rq)
 
 static int ide_cdrom_prep_fn(struct request_queue *q, struct request *rq)
 {
-	if (rq->cmd_type == REQ_TYPE_FS)
+	if (!blk_rq_is_passthrough(rq))
 		return ide_cdrom_prep_fs(q, rq);
-	else if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
+	else if (blk_rq_is_scsi(rq))
 		return ide_cdrom_prep_pc(rq);
 
 	return 0;
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 3f03eed..9fcefbc 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -303,9 +303,8 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	struct request *rq;
 	int ret;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->rq_flags = RQF_QUIET;
 	ret = blk_execute_rq(drive->queue, cd->disk, rq, 0);
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index c040b9d..a45dda5 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -165,9 +165,8 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 	if (!(setting->flags & DS_SYNC))
 		return setting->set(drive, arg);
 
-	rq = blk_get_request(q, READ, __GFP_RECLAIM);
+	rq = blk_get_request(q, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd_len = 5;
 	scsi_req(rq)->cmd[0] = REQ_DEVSET_EXEC;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 69cf717..1861597 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -184,7 +184,7 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
-	BUG_ON(rq->cmd_type != REQ_TYPE_FS);
+	BUG_ON(blk_rq_is_passthrough(rq));
 
 	ledtrig_disk_activity();
 
@@ -452,8 +452,8 @@ static int idedisk_prep_fn(struct request_queue *q, struct request *rq)
 	cmd->valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
 	cmd->tf_flags = IDE_TFLAG_DYN;
 	cmd->protocol = ATA_PROT_NODATA;
-
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
+	rq->cmd_flags &= ~REQ_OP_MASK;
+	rq->cmd_flags |= REQ_OP_DRV_OUT;
 	ide_req(rq)->type = ATA_PRIV_TASKFILE;
 	rq->special = cmd;
 	cmd->rq = rq;
@@ -478,9 +478,8 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	if (drive->special_flags & IDE_SFLAG_SET_MULTMODE)
 		return -EBUSY;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_TASKFILE;
 
 	drive->mult_req = arg;
diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 1e4b147..cf3af68 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -123,7 +123,7 @@ ide_startstop_t ide_error(ide_drive_t *drive, const char *msg, u8 stat)
 		return ide_stopped;
 
 	/* retry only "normal" I/O: */
-	if (rq->cmd_type != REQ_TYPE_FS) {
+	if (blk_rq_is_passthrough(rq)) {
 		if (ata_taskfile_request(rq)) {
 			struct ide_cmd *cmd = rq->special;
 
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 24c6d36..a69e801 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -72,7 +72,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 		drive->failed_pc = NULL;
 
 	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
-	    rq->cmd_type == REQ_TYPE_BLOCK_PC)
+	    (req_op(rq) == REQ_OP_SCSI_IN || req_op(rq) == REQ_OP_SCSI_OUT))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 
@@ -254,8 +254,8 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 			goto out_end;
 	}
 
-	switch (rq->cmd_type) {
-	case REQ_TYPE_FS:
+	switch (req_op(rq)) {
+	default:
 		if (((long)blk_rq_pos(rq) % floppy->bs_factor) ||
 		    (blk_rq_sectors(rq) % floppy->bs_factor)) {
 			printk(KERN_ERR PFX "%s: unsupported r/w rq size\n",
@@ -265,11 +265,13 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		pc = &floppy->queued_pc;
 		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
 		break;
-	case REQ_TYPE_BLOCK_PC:
+	case REQ_OP_SCSI_IN:
+	case REQ_OP_SCSI_OUT:
 		pc = &floppy->queued_pc;
 		idefloppy_blockpc_cmd(floppy, pc, rq);
 		break;
-	case REQ_TYPE_DRV_PRIV:
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
 		switch (ide_req(rq)->type) {
 		case ATA_PRIV_MISC:
 		case ATA_PRIV_SENSE:
@@ -278,9 +280,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		default:
 			BUG();
 		}
-		break;
-	default:
-		BUG();
 	}
 
 	ide_prep_sense(drive, rq);
@@ -292,7 +291,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 
 	cmd.rq = rq;
 
-	if (rq->cmd_type == REQ_TYPE_FS || blk_rq_bytes(rq)) {
+	if (!blk_rq_is_passthrough(rq) || blk_rq_bytes(rq)) {
 		ide_init_sg_cmd(&cmd, blk_rq_bytes(rq));
 		ide_map_sg(drive, &cmd);
 	}
@@ -302,7 +301,7 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 	return ide_floppy_issue_pc(drive, &cmd, pc);
 out_end:
 	drive->failed_pc = NULL;
-	if (rq->cmd_type != REQ_TYPE_FS && rq->errors == 0)
+	if (blk_rq_is_passthrough(rq) && rq->errors == 0)
 		rq->errors = -EIO;
 	ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
 	return ide_stopped;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 6735c92..043b1fb 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -145,7 +145,7 @@ void ide_kill_rq(ide_drive_t *drive, struct request *rq)
 	} else {
 		if (media == ide_tape)
 			rq->errors = IDE_DRV_ERROR_GENERAL;
-		else if (rq->cmd_type != REQ_TYPE_FS && rq->errors == 0)
+		else if (blk_rq_is_passthrough(rq) && rq->errors == 0)
 			rq->errors = -EIO;
 	}
 
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index fc19e84..248a3e0 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -125,9 +125,8 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 	if (NULL == (void *) arg) {
 		struct request *rq;
 
-		rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+		rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 		scsi_req_init(rq);
-		rq->cmd_type = REQ_TYPE_DRV_PRIV;
 		ide_req(rq)->type = ATA_PRIV_TASKFILE;
 		err = blk_execute_rq(drive->queue, NULL, rq, 0);
 		blk_put_request(rq);
@@ -223,9 +222,8 @@ static int generic_drive_reset(ide_drive_t *drive)
 	struct request *rq;
 	int ret = 0;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd_len = 1;
 	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index fc3c944..101aed9 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -31,11 +31,10 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	}
 	spin_unlock_irq(&hwif->lock);
 
-	rq = blk_get_request(q, READ, __GFP_RECLAIM);
+	rq = blk_get_request(q, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
 	scsi_req(rq)->cmd[0] = REQ_PARK_HEADS;
 	scsi_req(rq)->cmd_len = 1;
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	rq->special = &timeout;
 	rc = blk_execute_rq(q, NULL, rq, 1);
@@ -47,14 +46,13 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	 * Make sure that *some* command is sent to the drive after the
 	 * timeout has expired, so power management will be reenabled.
 	 */
-	rq = blk_get_request(q, READ, GFP_NOWAIT);
+	rq = blk_get_request(q, REQ_OP_DRV_IN, GFP_NOWAIT);
 	scsi_req_init(rq);
 	if (IS_ERR(rq))
 		goto out;
 
 	scsi_req(rq)->cmd[0] = REQ_UNPARK_HEADS;
 	scsi_req(rq)->cmd_len = 1;
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
 
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 0c12968..ec951be 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -18,9 +18,8 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_PM_SUSPEND;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_SUSPEND;
@@ -90,9 +89,8 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	rq->rq_flags |= RQF_PREEMPT;
 	rq->special = &rqpm;
@@ -244,12 +242,12 @@ void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
 {
 	struct ide_pm_state *pm = rq->special;
 
-	if (rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+	if (blk_rq_is_private(rq) &&
 	    ide_req(rq)->type == ATA_PRIV_PM_SUSPEND &&
 	    pm->pm_step == IDE_PM_START_SUSPEND)
 		/* Mark drive blocked when starting the suspend sequence. */
 		drive->dev_flags |= IDE_DFLAG_BLOCKED;
-	else if (rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+	else if (blk_rq_is_private(rq) &&
 	         ide_req(rq)->type == ATA_PRIV_PM_RESUME &&
 		 pm->pm_step == IDE_PM_START_RESUME) {
 		/*
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 37c7bea..3c1b7974 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -577,7 +577,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		      req->cmd[0], (unsigned long long)blk_rq_pos(rq),
 		      blk_rq_sectors(rq));
 
-	BUG_ON(rq->cmd_type != REQ_TYPE_DRV_PRIV);
+	BUG_ON(!blk_rq_is_private(rq));
 	BUG_ON(ide_req(rq)->type != ATA_PRIV_MISC &&
 	       ide_req(rq)->type != ATA_PRIV_SENSE);
 
@@ -854,9 +854,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	BUG_ON(cmd != REQ_IDETAPE_READ && cmd != REQ_IDETAPE_WRITE);
 	BUG_ON(size < 0 || size % tape->blk_size);
 
-	rq = blk_get_request(drive->queue, READ, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_MISC;
 	scsi_req(rq)->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 9ccc1d5..247b9fac 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -428,11 +428,11 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 {
 	struct request *rq;
 	int error;
-	int rw = !(cmd->tf_flags & IDE_TFLAG_WRITE) ? READ : WRITE;
 
-	rq = blk_get_request(drive->queue, rw, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue,
+		(cmd->tf_flags & IDE_TFLAG_WRITE) ?
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, __GFP_RECLAIM);
 	scsi_req_init(rq);
-	rq->cmd_type = REQ_TYPE_DRV_PRIV;
 	ide_req(rq)->type = ATA_PRIV_TASKFILE;
 
 	/*
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index df8a5ef..6b8d5cd 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -84,9 +84,6 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	nsect = blk_rq_cur_bytes(req) >> tr->blkshift;
 	buf = bio_data(req->bio);
 
-	if (req->cmd_type != REQ_TYPE_FS)
-		return -EIO;
-
 	if (req_op(req) == REQ_OP_FLUSH)
 		return tr->flush(dev);
 
@@ -94,16 +91,16 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	    get_capacity(req->rq_disk))
 		return -EIO;
 
-	if (req_op(req) == REQ_OP_DISCARD)
+	switch (req_op(req)) {
+	case REQ_OP_DISCARD:
 		return tr->discard(dev, block, nsect);
-
-	if (rq_data_dir(req) == READ) {
+	case REQ_OP_READ:
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->readsect(dev, block, buf))
 				return -EIO;
 		rq_flush_dcache_pages(req);
 		return 0;
-	} else {
+	case REQ_OP_WRITE:
 		if (!tr->writesect)
 			return -EIO;
 
@@ -112,6 +109,8 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 			if (tr->writesect(dev, block, buf))
 				return -EIO;
 		return 0;
+	default:
+		return -EIO;
 	}
 }
 
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index d1e6931..c80869e 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -323,16 +323,15 @@ static int ubiblock_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct ubiblock *dev = hctx->queue->queuedata;
 	struct ubiblock_pdu *pdu = blk_mq_rq_to_pdu(req);
 
-	if (req->cmd_type != REQ_TYPE_FS)
+	switch (req_op(req)) {
+	case REQ_OP_READ:
+		ubi_sgl_init(&pdu->usgl);
+		queue_work(dev->wq, &pdu->work);
+		return BLK_MQ_RQ_QUEUE_OK;
+	default:
 		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
 
-	if (rq_data_dir(req) != READ)
-		return BLK_MQ_RQ_QUEUE_ERROR; /* Write not implemented */
-
-	ubi_sgl_init(&pdu->usgl);
-	queue_work(dev->wq, &pdu->work);
-
-	return BLK_MQ_RQ_QUEUE_OK;
 }
 
 static int ubiblock_init_request(void *data, struct request *req,
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8a3c3e3..1640a5c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -208,18 +208,18 @@ EXPORT_SYMBOL_GPL(nvme_requeue_req);
 struct request *nvme_alloc_request(struct request_queue *q,
 		struct nvme_command *cmd, unsigned int flags, int qid)
 {
+	unsigned op = nvme_is_write(cmd) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
 	struct request *req;
 
 	if (qid == NVME_QID_ANY) {
-		req = blk_mq_alloc_request(q, nvme_is_write(cmd), flags);
+		req = blk_mq_alloc_request(q, op, flags);
 	} else {
-		req = blk_mq_alloc_request_hctx(q, nvme_is_write(cmd), flags,
+		req = blk_mq_alloc_request_hctx(q, op, flags,
 				qid ? qid - 1 : 0);
 	}
 	if (IS_ERR(req))
 		return req;
 
-	req->cmd_type = REQ_TYPE_DRV_PRIV;
 	req->cmd_flags |= REQ_FAILFAST_DRIVER;
 	nvme_req(req)->cmd = cmd;
 
@@ -309,17 +309,27 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 {
 	int ret = BLK_MQ_RQ_QUEUE_OK;
 
-	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
+	switch (req_op(req)) {
+	case REQ_OP_DRV_IN:
+	case REQ_OP_DRV_OUT:
 		memcpy(cmd, nvme_req(req)->cmd, sizeof(*cmd));
-	else if (req_op(req) == REQ_OP_FLUSH)
+		break;
+	case REQ_OP_FLUSH:
 		nvme_setup_flush(ns, cmd);
-	else if (req_op(req) == REQ_OP_DISCARD)
+		break;
+	case REQ_OP_DISCARD:
 		ret = nvme_setup_discard(ns, req, cmd);
-	else
+		break;
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
 		nvme_setup_rw(ns, req, cmd);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
 
 	cmd->common.command_id = req->tag;
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_setup_cmd);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ecc79b2..a75e95d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1471,7 +1471,7 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	ib_dma_sync_single_for_device(dev, sqe->dma,
 			sizeof(struct nvme_command), DMA_TO_DEVICE);
 
-	if (rq->cmd_type == REQ_TYPE_FS && req_op(rq) == REQ_OP_FLUSH)
+	if (req_op(rq) == REQ_OP_FLUSH)
 		flush = true;
 	ret = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
 			req->mr->need_inval ? &req->reg_wr.wr : NULL, flush);
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index fcb040e..30b9050 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1565,7 +1565,8 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
 	struct bio *bio = oii->bio;
 	int ret;
 
-	req = blk_get_request(q, has_write ? WRITE : READ, flags);
+	req = blk_get_request(q, has_write ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			flags);
 	if (IS_ERR(req))
 		return req;
 	scsi_req_init(req);
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index d314aa5..451de6c 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -367,7 +367,8 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
 
-	req = blk_get_request(SRpnt->stp->device->request_queue, write, GFP_KERNEL);
+	req = blk_get_request(SRpnt->stp->device->request_queue,
+			write ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, GFP_KERNEL);
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b4ce7bb..9e82fa5 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1974,7 +1974,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * blk_get_request with GFP_KERNEL (__GFP_RECLAIM) sleeps until a
 	 * request becomes available
 	 */
-	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, GFP_KERNEL);
 	if (IS_ERR(req))
 		return;
 	rq = scsi_req(req);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 31629a7..90f65c8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -219,11 +219,12 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 req_flags_t rq_flags, int *resid)
 {
 	struct request *req;
-	int write = (data_direction == DMA_TO_DEVICE);
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
 
-	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
+	req = blk_get_request(sdev->request_queue,
+			data_direction == DMA_TO_DEVICE ?
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -839,8 +840,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		}
 	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
 		/*
-		 * Certain non BLOCK_PC requests are commands that don't
-		 * actually transfer anything (FLUSH), so cannot use
+		 * Flush commands do not transfers any data, and thus cannot use
 		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
 		 * This sets the error explicitly for the problem case.
 		 */
@@ -859,8 +859,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		blk_rq_sectors(req), good_bytes));
 
 	/*
-	 * Recovered errors need reporting, but they're always treated
-	 * as success, so fiddle the result code here.  For BLOCK_PC
+	 * Recovered errors need reporting, but they're always treated as
+	 * success, so fiddle the result code here.  For passthrough requests
 	 * we already took a copy of the original into rq->errors which
 	 * is what gets returned to the user
 	 */
@@ -874,7 +874,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		else if (!(req->rq_flags & RQF_QUIET))
 			scsi_print_sense(cmd);
 		result = 0;
-		/* BLOCK_PC may have set error */
+		/* for passthrough error may be set */
 		error = 0;
 	}
 
@@ -1179,12 +1179,12 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 	spin_unlock_irqrestore(&dev->list_lock, flags);
 }
 
-static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
+static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd = req->special;
 
 	/*
-	 * BLOCK_PC requests may transfer data, in which case they must
+	 * Passthrough requests may transfer data, in which case they must
 	 * a bio attached to them.  Or they might contain a SCSI command
 	 * that does not transfer data, in which case they may optionally
 	 * submit a request without an attached bio.
@@ -1207,7 +1207,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 }
 
 /*
- * Setup a REQ_TYPE_FS command.  These are simple request from filesystems
+ * Setup a normal block command.  These are simple request from filesystems
  * that still need to be translated to SCSI CDBs from the ULD.
  */
 static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1236,14 +1236,10 @@ static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
 	else
 		cmd->sc_data_direction = DMA_FROM_DEVICE;
 
-	switch (req->cmd_type) {
-	case REQ_TYPE_FS:
+	if (blk_rq_is_scsi(req))
+		return scsi_setup_scsi_cmnd(sdev, req);
+	else
 		return scsi_setup_fs_cmnd(sdev, req);
-	case REQ_TYPE_BLOCK_PC:
-		return scsi_setup_blk_pc_cmnd(sdev, req);
-	default:
-		return BLKPREP_KILL;
-	}
 }
 
 static int
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 226a8de..e0e308b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1698,7 +1698,8 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	 * With scsi-mq disabled, blk_get_request() with GFP_KERNEL usually
 	 * does not sleep except under memory pressure.
 	 */
-	rq = blk_get_request(q, rw, GFP_KERNEL);
+	rq = blk_get_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV ?
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, GFP_KERNEL);
 	if (IS_ERR(rq)) {
 		kfree(long_cmdp);
 		return PTR_ERR(rq);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94352e4..2e1d910 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -437,14 +437,17 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 		goto out;
 	}
 
-	if (rq_data_dir(rq) == WRITE) {
+	switch (req_op(rq)) {
+	case REQ_OP_WRITE:
 		if (!cd->writeable)
 			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
 		cd->cdi.media_written = 1;
-	} else if (rq_data_dir(rq) == READ) {
+		break;
+	case REQ_OP_READ:
 		SCpnt->cmnd[0] = READ_10;
-	} else {
+		break;
+	default:
 		blk_dump_rq_flags(rq, "Unknown sr command");
 		goto out;
 	}
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 4af9001..81212d4 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -541,11 +541,11 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	struct scsi_request *rq;
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
-	int write = (data_direction == DMA_TO_DEVICE);
 	struct scsi_tape *STp = SRpnt->stp;
 
-	req = blk_get_request(SRpnt->stp->device->request_queue, write,
-			      GFP_KERNEL);
+	req = blk_get_request(SRpnt->stp->device->request_queue,
+			data_direction == DMA_TO_DEVICE ?
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, GFP_KERNEL);
 	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 	rq = scsi_req(req);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e52f4e1..a8f8e53 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1005,7 +1005,8 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		scsi_command_size(cmd->t_task_cdb));
 
 	req = blk_get_request(pdv->pdv_sd->request_queue,
-			(cmd->data_direction == DMA_TO_DEVICE),
+			cmd->data_direction == DMA_TO_DEVICE ?
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
 			GFP_KERNEL);
 	if (IS_ERR(req)) {
 		pr_err("PSCSI: blk_get_request() failed\n");
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 930d98c..a06115e 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -223,7 +223,7 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	if (!buf)
 		return -ENOMEM;
 
-	rq = blk_get_request(q, READ, GFP_KERNEL);
+	rq = blk_get_request(q, REQ_OP_SCSI_IN, GFP_KERNEL);
 	if (IS_ERR(rq)) {
 		error = -ENOMEM;
 		goto out_free_buf;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 37c9a43..d703acb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -162,6 +162,13 @@ enum req_opf {
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= 8,
 
+	/* SCSI passthrough using struct scsi_request */
+	REQ_OP_SCSI_IN		= 32,
+	REQ_OP_SCSI_OUT		= 33,
+	/* Driver private requests */
+	REQ_OP_DRV_IN		= 34,
+	REQ_OP_DRV_OUT		= 35,
+
 	REQ_OP_LAST,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7121be0..1e947e7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -71,15 +71,6 @@ struct request_list {
 };
 
 /*
- * request command types
- */
-enum rq_cmd_type_bits {
-	REQ_TYPE_FS		= 1,	/* fs request */
-	REQ_TYPE_BLOCK_PC,		/* scsi command */
-	REQ_TYPE_DRV_PRIV,		/* driver defined types from here */
-};
-
-/*
  * request flags */
 typedef __u32 __bitwise req_flags_t;
 
@@ -145,7 +136,6 @@ struct request {
 	struct blk_mq_ctx *mq_ctx;
 
 	int cpu;
-	unsigned cmd_type;
 	unsigned int cmd_flags;		/* op and common flags */
 	req_flags_t rq_flags;
 	unsigned long atomic_flags;
@@ -242,9 +232,19 @@ struct request {
 	struct request *next_rq;
 };
 
+static inline bool blk_rq_is_scsi(struct request *rq)
+{
+	return req_op(rq) == REQ_OP_SCSI_IN || req_op(rq) == REQ_OP_SCSI_OUT;
+}
+
+static inline bool blk_rq_is_private(struct request *rq)
+{
+	return req_op(rq) == REQ_OP_DRV_IN || req_op(rq) == REQ_OP_DRV_OUT;
+}
+
 static inline bool blk_rq_is_passthrough(struct request *rq)
 {
-	return rq->cmd_type != REQ_TYPE_FS;
+	return blk_rq_is_scsi(rq) || blk_rq_is_private(rq);
 }
 
 static inline unsigned short req_get_ioprio(struct request *req)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 5cc6caa..2f51c17 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -63,31 +63,27 @@ static inline struct ide_request *ide_req(struct request *rq)
 
 static inline bool ata_misc_request(struct request *rq)
 {
-	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
-               ide_req(rq)->type == ATA_PRIV_MISC;
+	return blk_rq_is_private(rq) && ide_req(rq)->type == ATA_PRIV_MISC;
 }
 
 static inline bool ata_taskfile_request(struct request *rq)
 {
-	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
-               ide_req(rq)->type == ATA_PRIV_TASKFILE;
+	return blk_rq_is_private(rq) && ide_req(rq)->type == ATA_PRIV_TASKFILE;
 }
 
 static inline bool ata_pc_request(struct request *rq)
 {
-	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
-               ide_req(rq)->type == ATA_PRIV_PC;
+	return blk_rq_is_private(rq) && ide_req(rq)->type == ATA_PRIV_PC;
 }
 
 static inline bool ata_sense_request(struct request *rq)
 {
-	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
-               ide_req(rq)->type == ATA_PRIV_SENSE;
+	return blk_rq_is_private(rq) && ide_req(rq)->type == ATA_PRIV_SENSE;
 }
 
 static inline bool ata_pm_request(struct request *rq)
 {
-	return rq->cmd_type == REQ_TYPE_DRV_PRIV &&
+	return blk_rq_is_private(rq) &&
 		(ide_req(rq)->type == ATA_PRIV_PM_SUSPEND ||
 		 ide_req(rq)->type == ATA_PRIV_PM_RESUME);
 }
-- 
2.1.4

