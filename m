From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] block: change blk_rq_unmap_user to take a request instead of a bio
Date: Thu,  3 Apr 2008 01:53:00 +0900
Message-ID: <1207155180-8069-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48322 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbYDBQzJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2008 12:55:09 -0400
In-Reply-To: <1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

The map APIs takes a request (blk_rq_map_user and
blk_rq_map_user_iov), the unmap API, blk_rq_unmap_user takes a bio.

Due to the asymmetry of the APIs, callers have to track a mapped bio
even if they aren't interested in a bio, the details of I/O
representation. The asymmetry leads to trouble easily. The symmetrical
APIs are nicer and easier to use.

This is based on an earlier patch by Mike Christie.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c            |    4 ++--
 block/blk-map.c             |   16 +++++-----------
 block/bsg.c                 |   32 ++++++++++----------------------
 block/scsi_ioctl.c          |   10 +++-------
 drivers/cdrom/cdrom.c       |    4 +---
 drivers/scsi/scsi_tgt_lib.c |    5 +----
 include/linux/blkdev.h      |    5 ++++-
 7 files changed, 26 insertions(+), 50 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..284863f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -119,7 +119,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->sector = rq->hard_sector = (sector_t) -1;
 	rq->nr_sectors = rq->hard_nr_sectors = 0;
 	rq->current_nr_sectors = rq->hard_cur_sectors = 0;
-	rq->bio = rq->biotail = NULL;
+	rq->bio = rq->biotail = rq->biohead = NULL;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->rq_disk = NULL;
@@ -2018,7 +2018,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->buffer = bio_data(bio);
 	rq->data_len = bio->bi_size;
 
-	rq->bio = rq->biotail = bio;
+	rq->bio = rq->biotail = rq->biohead = bio;
 
 	if (bio->bi_bdev)
 		rq->rq_disk = bio->bi_bdev->bd_disk;
diff --git a/block/blk-map.c b/block/blk-map.c
index e949969..be02969 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -107,7 +107,6 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		    void __user *ubuf, unsigned long len)
 {
 	unsigned long bytes_read = 0;
-	struct bio *bio = NULL;
 	int ret;
 
 	if (len > (q->max_hw_sectors << 9))
@@ -134,8 +133,6 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
 		if (ret < 0)
 			goto unmap_rq;
-		if (!bio)
-			bio = rq->bio;
 		bytes_read += ret;
 		ubuf += ret;
 	}
@@ -143,8 +140,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	rq->buffer = rq->data = NULL;
 	return 0;
 unmap_rq:
-	blk_rq_unmap_user(bio);
-	rq->bio = NULL;
+	blk_rq_unmap_user(rq);
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_user);
@@ -200,16 +196,14 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 
 /**
  * blk_rq_unmap_user - unmap a request with user data
- * @bio:	       start of bio list
+ * @req:	       a request previously mapped
  *
  * Description:
- *    Unmap a rq previously mapped by blk_rq_map_user(). The caller must
- *    supply the original rq->bio from the blk_rq_map_user() return, since
- *    the io completion may have changed rq->bio.
+ *    Unmap a rq previously mapped by blk_rq_map_user().
  */
-int blk_rq_unmap_user(struct bio *bio)
+int blk_rq_unmap_user(struct request *rq)
 {
-	struct bio *mapped_bio;
+	struct bio *mapped_bio, *bio = rq->biohead;
 	int ret = 0, ret2;
 
 	while (bio) {
diff --git a/block/bsg.c b/block/bsg.c
index 8917c51..e62d226 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -81,8 +81,6 @@ struct bsg_command {
 	struct bsg_device *bd;
 	struct list_head list;
 	struct request *rq;
-	struct bio *bio;
-	struct bio *bidi_bio;
 	int err;
 	struct sg_io_v4 hdr;
 	char sense[SCSI_SENSE_BUFFERSIZE];
@@ -305,7 +303,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 out:
 	blk_put_request(rq);
 	if (next_rq) {
-		blk_rq_unmap_user(next_rq->bio);
+		blk_rq_unmap_user(next_rq);
 		blk_put_request(next_rq);
 	}
 	return ERR_PTR(ret);
@@ -321,8 +319,8 @@ static void bsg_rq_end_io(struct request *rq, int uptodate)
 	struct bsg_device *bd = bc->bd;
 	unsigned long flags;
 
-	dprintk("%s: finished rq %p bc %p, bio %p stat %d\n",
-		bd->name, rq, bc, bc->bio, uptodate);
+	dprintk("%s: finished rq %p bc %p, stat %d\n",
+		bd->name, rq, bc, uptodate);
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
@@ -348,9 +346,6 @@ static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 	 * add bc command to busy queue and submit rq for io
 	 */
 	bc->rq = rq;
-	bc->bio = rq->bio;
-	if (rq->next_rq)
-		bc->bidi_bio = rq->next_rq->bio;
 	bc->hdr.duration = jiffies;
 	spin_lock_irq(&bd->lock);
 	list_add_tail(&bc->list, &bd->busy_list);
@@ -407,12 +402,11 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 	return bc;
 }
 
-static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio, struct bio *bidi_bio)
+static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr)
 {
 	int ret = 0;
 
-	dprintk("rq %p bio %p %u\n", rq, bio, rq->errors);
+	dprintk("rq %p %u\n", rq, rq->errors);
 	/*
 	 * fill in all the output members
 	 */
@@ -439,7 +433,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	if (rq->next_rq) {
 		hdr->dout_resid = rq->data_len;
 		hdr->din_resid = rq->next_rq->data_len;
-		blk_rq_unmap_user(bidi_bio);
+		blk_rq_unmap_user(rq->next_rq);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
 		hdr->din_resid = rq->data_len;
@@ -455,7 +449,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	if (!ret && rq->errors < 0)
 		ret = rq->errors;
 
-	blk_rq_unmap_user(bio);
+	blk_rq_unmap_user(rq);
 	blk_put_request(rq);
 
 	return ret;
@@ -501,8 +495,7 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
 		if (IS_ERR(bc))
 			break;
 
-		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-						bc->bidi_bio);
+		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr);
 		if (!ret)
 			ret = tret;
 
@@ -536,8 +529,7 @@ __bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
 		 * after completing the request. so do that here,
 		 * bsg_complete_work() cannot do that for us
 		 */
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-					       bc->bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr);
 
 		if (copy_to_user(buf, &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -886,7 +878,6 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 	case SG_IO: {
 		struct request *rq;
-		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
@@ -896,11 +887,8 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
-		bio = rq->bio;
-		if (rq->next_rq)
-			bidi_bio = rq->next_rq->bio;
 		blk_execute_rq(bd->queue, NULL, rq, 0);
-		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+		ret = blk_complete_sgv4_hdr_rq(rq, &hdr);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
 			return -EFAULT;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a2c3a93..f6cf8ba 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -245,13 +245,12 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
  */
 static int blk_unmap_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
-	blk_rq_unmap_user(rq->bio);
+	blk_rq_unmap_user(rq);
 	blk_put_request(rq);
 	return 0;
 }
 
-static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
-				 struct bio *bio)
+static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr)
 {
 	int r, ret = 0;
 
@@ -278,7 +277,6 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	rq->bio = bio;
 	r = blk_unmap_sghdr_rq(rq, hdr);
 	if (ret)
 		r = ret;
@@ -293,7 +291,6 @@ static int sg_io(struct file *file, struct request_queue *q,
 	int writing = 0, ret = 0, has_write_perm = 0;
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
-	struct bio *bio;
 
 	if (hdr->interface_id != 'S')
 		return -EINVAL;
@@ -352,7 +349,6 @@ static int sg_io(struct file *file, struct request_queue *q,
 	if (ret)
 		goto out;
 
-	bio = rq->bio;
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
 	rq->sense_len = 0;
@@ -368,7 +364,7 @@ static int sg_io(struct file *file, struct request_queue *q,
 
 	hdr->duration = jiffies_to_msecs(jiffies - start_time);
 
-	return blk_complete_sghdr_rq(rq, hdr, bio);
+	return blk_complete_sghdr_rq(rq, hdr);
 out:
 	blk_put_request(rq);
 	return ret;
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 12f5bae..3ccaa3d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2101,7 +2101,6 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 {
 	struct request_queue *q = cdi->disk->queue;
 	struct request *rq;
-	struct bio *bio;
 	unsigned int len;
 	int nr, ret = 0;
 
@@ -2142,7 +2141,6 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		rq->cmd_len = 12;
 		rq->cmd_type = REQ_TYPE_BLOCK_PC;
 		rq->timeout = 60 * HZ;
-		bio = rq->bio;
 
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
@@ -2150,7 +2148,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio))
+		if (blk_rq_unmap_user(rq))
 			ret = -EFAULT;
 
 		if (ret)
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a0f308b..2f7793a 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -43,7 +43,6 @@ struct scsi_tgt_cmd {
 	/* TODO replace work with James b's code */
 	struct work_struct work;
 	/* TODO fix limits of some drivers */
-	struct bio *bio;
 
 	struct list_head hash_list;
 	struct request *rq;
@@ -170,7 +169,7 @@ static void cmd_hashlist_del(struct scsi_cmnd *cmd)
 
 static void scsi_unmap_user_pages(struct scsi_tgt_cmd *tcmd)
 {
-	blk_rq_unmap_user(tcmd->bio);
+	blk_rq_unmap_user(tcmd->rq);
 }
 
 static void scsi_tgt_cmd_destroy(struct work_struct *work)
@@ -194,7 +193,6 @@ static void init_scsi_tgt_cmd(struct request *rq, struct scsi_tgt_cmd *tcmd,
 
 	tcmd->itn_id = itn_id;
 	tcmd->tag = tag;
-	tcmd->bio = NULL;
 	INIT_WORK(&tcmd->work, scsi_tgt_cmd_destroy);
 	spin_lock_irqsave(&qdata->cmd_hash_lock, flags);
 	head = &qdata->cmd_hash[cmd_hashfn(tag)];
@@ -375,7 +373,6 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 		return err;
 	}
 
-	tcmd->bio = rq->bio;
 	err = scsi_init_io(cmd, GFP_KERNEL);
 	if (err) {
 		scsi_release_buffers(cmd);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6f79d40..b7879ed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -233,6 +233,9 @@ struct request {
 
 	/* for bidi */
 	struct request *next_rq;
+
+	/* for blk_rq_unmap_user */
+	struct bio *biohead;
 };
 
 /*
@@ -622,7 +625,7 @@ extern void __blk_stop_queue(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_start_queueing(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *, void __user *, unsigned long);
-extern int blk_rq_unmap_user(struct bio *);
+extern int blk_rq_unmap_user(struct request *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct sg_iovec *, int, unsigned int);
-- 
1.5.3.7

