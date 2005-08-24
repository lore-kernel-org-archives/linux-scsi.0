From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RFC PATCH 1/4] convert block layer drivers to blkerr
	error values
Date: Wed, 24 Aug 2005 04:03:58 -0500
Message-ID: <1124874238.10888.18.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The current -Exyz errors are not descriptive enough to
allow upper layers like DM and MD to decide how to
handle IO errors. In many cases all we get is a -EIO.
The following path introduces BLK* error values for
use with the bio_endio and end_that_request* functions
(end_request keeps uptodate). I converted all the
users in this patch except scsi and dm. Those will
be in the next patches.

This patch will break all out of tree drivers.
I was not sure if it was better to start clean
or keep support for 1, 0, Exyz and whatever
else some drivers were sending sometimes. If
you want I can just redefine the BLKERR values to
fit into the existing tests then have driver
like dm-multipath check for both BLKERR and -Exyz
errors.

This is just a RFC and it has actually been sent to lkml
in the past so since I really want to make sure it will
work for SCSI amd dm-multipath I am just sending it here.
I will break this patch up and send it to lkml and
the maintainers of these drivers in the future.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -3471,9 +3471,9 @@ static inline boolean DAC960_ProcessComp
 	struct request *Request = Command->Request;
 	int UpToDate;
 
-	UpToDate = 0;
+	UpToDate = BLKERR_IO;
 	if (SuccessfulIO)
-		UpToDate = 1;
+		UpToDate = BLK_SUCCESS;
 
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -133,7 +133,7 @@ aoeblk_make_request(request_queue_t *q, 
 	if (buf == NULL) {
 		printk(KERN_INFO "aoe: aoeblk_make_request: buf allocation "
 			"failure\n");
-		bio_endio(bio, bio->bi_size, -ENOMEM);
+		bio_endio(bio, bio->bi_size, BLKERR_RETRY_DRV);
 		return 0;
 	}
 	memset(buf, 0, sizeof(*buf));
@@ -153,7 +153,7 @@ aoeblk_make_request(request_queue_t *q, 
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, bio->bi_size, -ENXIO);
+		bio_endio(bio, bio->bi_size, BLKERR_FATAL_DEV);
 		return 0;
 	}
 
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -478,7 +478,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 				disk_stat_add(disk, read_sectors, n_sect);
 			}
 			disk_stat_add(disk, io_ticks, duration);
-			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
+			n = (buf->flags & BUFFL_FAIL) ? BLKERR_IO : BLK_SUCCESS;
 			bio_endio(buf->bio, buf->bio->bi_size, n);
 			mempool_free(buf, d->bufpool);
 		}
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -79,7 +79,7 @@ aoedev_downdev(struct aoedev *d)
 		bio = buf->bio;
 		if (--buf->nframesout == 0) {
 			mempool_free(buf, d->bufpool);
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, bio->bi_size, BLKERR_IO);
 		}
 	}
 	d->inprocess = NULL;
@@ -89,7 +89,7 @@ aoedev_downdev(struct aoedev *d)
 		list_del(d->bufq.next);
 		bio = buf->bio;
 		mempool_free(buf, d->bufpool);
-		bio_endio(bio, bio->bi_size, -EIO);
+		bio_endio(bio, bio->bi_size, BLKERR_IO);
 	}
 
 	if (d->nopen)
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1913,7 +1913,8 @@ static inline void complete_buffers(stru
 
 		bio->bi_next = NULL; 
 		blk_finished_io(len);
-		bio_endio(bio, nr_sectors << 9, status ? 0 : -EIO);
+		bio_endio(bio, nr_sectors << 9,
+			  status ? BLK_SUCCESS : BLKERR_IO);
 		bio = xbh;
 	}
 
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -992,7 +992,7 @@ static inline void complete_buffers(stru
 		bio->bi_next = NULL;
 		
 		blk_finished_io(nr_sectors);
-		bio_endio(bio, nr_sectors << 9, ok ? 0 : -EIO);
+		bio_endio(bio, nr_sectors << 9, ok ? BLK_SUCCESS : BLKERR_IO);
 
 		bio = xbh;
 	}
diff --git a/drivers/block/elevator.c b/drivers/block/elevator.c
--- a/drivers/block/elevator.c
+++ b/drivers/block/elevator.c
@@ -404,7 +404,7 @@ struct request *elv_next_request(request
 
 			blkdev_dequeue_request(rq);
 			rq->flags |= REQ_QUIET;
-			end_that_request_chunk(rq, 0, nr_bytes);
+			end_that_request_chunk(rq, BLKERR_IO, nr_bytes);
 			end_that_request_last(rq);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2290,11 +2290,14 @@ static int do_format(int drive, struct f
 static void floppy_end_request(struct request *req, int uptodate)
 {
 	unsigned int nr_sectors = current_count_sectors;
+	int err = BLK_SUCCESS;
 
 	/* current_count_sectors can be zero if transfer failed */
-	if (!uptodate)
+	if (!uptodate) {
+		err = BLKERR_IO;
 		nr_sectors = req->current_nr_sectors;
-	if (end_that_request_first(req, uptodate, nr_sectors))
+	}
+	if (end_that_request_first(req, err, nr_sectors))
 		return;
 	add_disk_randomness(req->rq_disk);
 	floppy_off((long)req->rq_disk->private_data);
diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -2551,7 +2551,7 @@ static int __make_request(request_queue_
 
 	barrier = bio_barrier(bio);
 	if (unlikely(barrier) && (q->ordered == QUEUE_ORDERED_NONE)) {
-		err = -EOPNOTSUPP;
+		err = BLKERR_NOTSUPP;
 		goto end_io;
 	}
 
@@ -2860,7 +2860,7 @@ void generic_make_request(struct bio *bi
 				bdevname(bio->bi_bdev, b),
 				(long long) bio->bi_sector);
 end_io:
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, bio->bi_size, BLKERR_IO);
 			break;
 		}
 
@@ -2996,29 +2996,23 @@ static void blk_recalc_rq_sectors(struct
 	}
 }
 
-static int __end_that_request_first(struct request *req, int uptodate,
+static int __end_that_request_first(struct request *req, int error,
 				    int nr_bytes)
 {
-	int total_bytes, bio_nbytes, error, next_idx = 0;
+	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
 
 	/*
-	 * extend uptodate bool to allow < 0 value to be direct io error
-	 */
-	error = 0;
-	if (end_io_error(uptodate))
-		error = !uptodate ? -EIO : uptodate;
-
-	/*
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
 	 */
 	if (!blk_pc_request(req))
 		req->errors = 0;
 
-	if (!uptodate) {
+	if (error != BLK_SUCCESS) {
 		if (blk_fs_request(req) && !(req->flags & REQ_QUIET))
-			printk("end_request: I/O error, dev %s, sector %llu\n",
+			printk("end_request: I/O error %d, dev %s, sector "
+				"%llu\n", error,
 				req->rq_disk ? req->rq_disk->disk_name : "?",
 				(unsigned long long)req->sector);
 	}
@@ -3099,7 +3093,7 @@ static int __end_that_request_first(stru
 /**
  * end_that_request_first - end I/O on a request
  * @req:      the request being processed
- * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ * @uptodate: a block layer error value
  * @nr_sectors: number of sectors to end I/O on
  *
  * Description:
@@ -3120,7 +3114,7 @@ EXPORT_SYMBOL(end_that_request_first);
 /**
  * end_that_request_chunk - end I/O on a request
  * @req:      the request being processed
- * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ * @uptodate: a block layer error value
  * @nr_bytes: number of bytes to complete
  *
  * Description:
@@ -3174,7 +3168,9 @@ EXPORT_SYMBOL(end_that_request_last);
 
 void end_request(struct request *req, int uptodate)
 {
-	if (!end_that_request_first(req, uptodate, req->hard_cur_sectors)) {
+	int err = uptodate ? BLK_SUCCESS : BLKERR_IO;
+
+	if (!end_that_request_first(req, err, req->hard_cur_sectors)) {
 		add_disk_randomness(req->rq_disk);
 		blkdev_dequeue_request(req);
 		end_that_request_last(req);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -549,7 +549,7 @@ static inline void loop_handle_bio(struc
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
+		int ret = do_bio_filebacked(lo, bio) ? BLKERR_IO : BLK_SUCCESS;
 		bio_endio(bio, bio->bi_size, ret);
 	}
 }
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -127,15 +127,15 @@ static const char *nbdcmd_to_ascii(int c
 
 static void nbd_end_request(struct request *req)
 {
-	int uptodate = (req->errors == 0) ? 1 : 0;
+	int err = (req->errors == 0) ? BLK_SUCCESS : BLKERR_IO;
 	request_queue_t *q = req->q;
 	unsigned long flags;
 
 	dprintk(DBG_BLKDEV, "%s: request %p: %s\n", req->rq_disk->disk_name,
-			req, uptodate? "done": "failed");
+			req, err == BLK_SUCCESS ? "done": "failed");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
+	if (!end_that_request_first(req, err, req->nr_sectors)) {
 		end_that_request_last(req);
 	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -678,7 +678,7 @@ static int pkt_end_io_read(struct bio *b
 	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
 		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
 
-	if (err)
+	if (err != BLK_SUCCESS)
 		atomic_inc(&pkt->io_errors);
 	if (atomic_dec_and_test(&pkt->io_wait)) {
 		atomic_inc(&pkt->run_sm);
@@ -1049,7 +1049,6 @@ static void pkt_start_write(struct pktcd
 	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
 	pkt->w_bio->bi_sector = pkt->sector;
 	pkt->w_bio->bi_bdev = pd->bdev;
-	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
 	for (f = 0; f < pkt->frames; f++) {
 		if ((f + 1 < pkt->frames) && (pages[f + 1] == pages[f]) &&
@@ -1081,7 +1080,8 @@ static void pkt_finish_packet(struct pac
 	while (bio) {
 		next = bio->bi_next;
 		bio->bi_next = NULL;
-		bio_endio(bio, bio->bi_size, uptodate ? 0 : -EIO);
+		bio_endio(bio, bio->bi_size,
+			  uptodate ? BLK_SUCCESS : BLKERR_IO);
 		bio = next;
 	}
 	pkt->orig_bios = pkt->orig_bios_tail = NULL;
diff --git a/drivers/block/rd.c b/drivers/block/rd.c
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -288,7 +288,7 @@ static int rd_make_request(request_queue
 	if (ret)
 		goto fail;
 
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, bio->bi_size, BLK_SUCCESS);
 	return 0;
 fail:
 	bio_io_error(bio, bio->bi_size);
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -790,7 +790,7 @@ static inline void carm_round_robin(stru
 static inline void carm_end_rq(struct carm_host *host, struct carm_request *crq,
 			int is_ok)
 {
-	carm_end_request_queued(host, crq, is_ok);
+	carm_end_request_queued(host, crq, is_ok ? BLK_SUCCESS : BLKERR_IO);
 	if (CARM_MAX_Q == 1)
 		carm_round_robin(host);
 	else if ((host->n_msgs <= CARM_MSG_LOW_WATER) &&
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -765,7 +765,7 @@ static int ub_bd_rq_fn_1(struct ub_lun *
 
 	if (atomic_read(&sc->poison) || lun->changed) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, 0);
+		ub_end_rq(rq, BLKERR_IO);
 		return 0;
 	}
 
@@ -782,7 +782,7 @@ static int ub_bd_rq_fn_1(struct ub_lun *
 	}
 	if (rc != 0) {
 		ub_put_cmd(lun, cmd);
-		ub_end_rq(rq, 0);
+		ub_end_rq(rq, BLKERR_IO);
 		return 0;
 	}
 	cmd->state = UB_CMDST_INIT;
@@ -793,7 +793,7 @@ static int ub_bd_rq_fn_1(struct ub_lun *
 	cmd->tag = sc->tagcnt++;
 	if ((rc = ub_submit_scsi(sc, cmd)) != 0) {
 		ub_put_cmd(lun, cmd);
-		ub_end_rq(rq, 0);
+		ub_end_rq(rq, BLKERR_IO);
 		return 0;
 	}
 
@@ -823,7 +823,7 @@ static int ub_cmd_build_block(struct ub_
 	n_elem = blk_rq_map_sg(q, rq, sg);
 	if (n_elem <= 0) {
 		ub_put_cmd(lun, cmd);
-		ub_end_rq(rq, 0);
+		ub_end_rq(rq, BLKERR_IO);
 		blk_start_queue(q);
 		return 0;		/* request with no s/g entries? */
 	}
@@ -832,7 +832,7 @@ static int ub_cmd_build_block(struct ub_
 		printk(KERN_WARNING "%s: request with %d segments\n",
 		    sc->name, n_elem);
 		ub_put_cmd(lun, cmd);
-		ub_end_rq(rq, 0);
+		ub_end_rq(rq, BLKERR_IO);
 		blk_start_queue(q);
 		return 0;
 	}
@@ -930,9 +930,9 @@ static void ub_rw_cmd_done(struct ub_dev
 	}
 
 	if (cmd->error == 0)
-		uptodate = 1;
+		uptodate = BLK_SUCCESS;
 	else
-		uptodate = 0;
+		uptodate = BLKERR_IO;
 
 	ub_put_cmd(lun, cmd);
 	ub_end_rq(rq, uptodate);
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -543,7 +543,7 @@ static void process_page(unsigned long d
 
 		return_bio = bio->bi_next;
 		bio->bi_next = NULL;
-		bio_endio(bio, bio->bi_size, 0);
+		bio_endio(bio, bio->bi_size, BLK_SUCCESS);
 	}
 }
 
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -445,12 +445,14 @@ static void do_viodasd_request(request_q
 		blkdev_dequeue_request(req);
 		/* check that request contains a valid command */
 		if (!blk_fs_request(req)) {
-			viodasd_end_request(req, 0, req->hard_nr_sectors);
+			viodasd_end_request(req, BLKERR_IO,
+					    req->hard_nr_sectors);
 			continue;
 		}
 		/* Try sending the request */
 		if (send_request(req) != 0)
-			viodasd_end_request(req, 0, req->hard_nr_sectors);
+			viodasd_end_request(req, BLKERR_IO,
+					    req->hard_nr_sectors);
 	}
 }
 
@@ -656,7 +658,7 @@ static int viodasd_handle_read_write(str
 	}
 	qlock = req->q->queue_lock;
 	spin_lock_irqsave(qlock, irq_flags);
-	viodasd_end_request(req, !error, num_sect);
+	viodasd_end_request(req, error ? BLKERR_IO : BLK_SUCCESS, num_sect);
 	spin_unlock_irqrestore(qlock, irq_flags);
 
 	/* Finally, try to get more requests off of this device's queue */
diff --git a/drivers/cdrom/cdu31a.c b/drivers/cdrom/cdu31a.c
--- a/drivers/cdrom/cdu31a.c
+++ b/drivers/cdrom/cdu31a.c
@@ -1399,7 +1399,7 @@ static void do_cdu31a_request(request_qu
 		read_data_block(req->buffer, block, nblock, res_reg, &res_size);
 
 		if (res_reg[0] != 0x20) {
-			if (!end_that_request_first(req, 1, nblock)) {
+			if (!end_that_request_first(req, BLK_SUCCESS, nblock)) {
 				spin_lock_irq(q->queue_lock);
 				blkdev_dequeue_request(req);
 				end_that_request_last(req);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -613,7 +613,8 @@ static void cdrom_end_request (ide_drive
 			 * now end failed request
 			 */
 			spin_lock_irqsave(&ide_lock, flags);
-			end_that_request_chunk(failed, 0, failed->data_len);
+			end_that_request_chunk(failed, BLKERR_IO,
+					       failed->data_len);
 			end_that_request_last(failed);
 			spin_unlock_irqrestore(&ide_lock, flags);
 		}
@@ -1636,7 +1637,7 @@ static ide_startstop_t cdrom_newpc_intr(
 			return ide_error(drive, "dma error", stat);
 		}
 
-		end_that_request_chunk(rq, 1, rq->data_len);
+		end_that_request_chunk(rq, BLK_SUCCESS, rq->data_len);
 		rq->data_len = 0;
 		goto end_request;
 	}
@@ -1710,7 +1711,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		rq->data_len -= blen;
 
 		if (rq->bio)
-			end_that_request_chunk(rq, 1, blen);
+			end_that_request_chunk(rq, BLK_SUCCESS, blen);
 		else
 			rq->data += blen;
 	}
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -58,6 +58,7 @@
 int __ide_end_request(ide_drive_t *drive, struct request *rq, int uptodate,
 		      int nr_sectors)
 {
+	int err = uptodate ? BLK_SUCCESS : BLKERR_IO;
 	int ret = 1;
 
 	BUG_ON(!(rq->flags & REQ_STARTED));
@@ -66,10 +67,10 @@ int __ide_end_request(ide_drive_t *drive
 	 * if failfast is set on a request, override number of sectors and
 	 * complete the whole request right now
 	 */
-	if (blk_noretry_request(rq) && end_io_error(uptodate))
+	if (blk_noretry_request(rq) && err != BLK_SUCCESS)
 		nr_sectors = rq->hard_nr_sectors;
 
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
+	if (!blk_fs_request(rq) && (err != BLK_SUCCESS) && !rq->errors)
 		rq->errors = -EIO;
 
 	/*
@@ -81,7 +82,7 @@ int __ide_end_request(ide_drive_t *drive
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_first(rq, uptodate, nr_sectors)) {
+	if (!end_that_request_first(rq, err, nr_sectors)) {
 		add_disk_randomness(rq->rq_disk);
 
 		if (blk_rq_tagged(rq))
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -76,7 +76,7 @@ static int faulty_fail(struct bio *bio, 
 		bio_put(bio);
 
 	clear_bit(BIO_UPTODATE, &b->bi_flags);
-	return (b->bi_end_io)(b, bytes_done, -EIO);
+	return (b->bi_end_io)(b, bytes_done, BLKERR_IO);
 }
 
 typedef struct faulty_conf {
@@ -179,7 +179,7 @@ static int make_request(request_queue_t 
 			/* special case - don't decrement, don't generic_make_request,
 			 * just fail immediately
 			 */
-			bio_endio(bio, bio->bi_size, -EIO);
+			bio_endio(bio, bio->bi_size, BLKERR_IO);
 			return 0;
 		}
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -333,7 +333,7 @@ static int super_written(struct bio *bio
 	if (bio->bi_size)
 		return 1;
 
-	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (error != BLK_SUCCESS || !test_bit(BIO_UPTODATE, &bio->bi_flags))
 		md_error(rdev->mddev, rdev);
 
 	if (atomic_dec_and_test(&rdev->mddev->pending_writes))
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -115,7 +115,7 @@ static int multipath_end_request(struct 
 		return 1;
 
 	if (uptodate)
-		multipath_end_bh_io(mp_bh, 0);
+		multipath_end_bh_io(mp_bh, BLK_SUCCESS);
 	else if (!bio_rw_ahead(bio)) {
 		/*
 		 * oops, IO error:
@@ -184,7 +184,7 @@ static int multipath_make_request (reque
 
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
-		bio_endio(bio, bio->bi_size, -EIO);
+		bio_endio(bio, bio->bi_size, BLKERR_IO);
 		mempool_free(mp_bh, conf->pool);
 		return 0;
 	}
@@ -405,7 +405,7 @@ static void multipathd (mddev_t *mddev)
 				" error for block %llu\n",
 				bdevname(bio->bi_bdev,b),
 				(unsigned long long)bio->bi_sector);
-			multipath_end_bh_io(mp_bh, -EIO);
+			multipath_end_bh_io(mp_bh, BLKERR_IO);
 		} else {
 			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
 				" to another IO path\n",
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -223,7 +223,7 @@ static void raid_end_bio_io(r1bio_t *r1_
 	struct bio *bio = r1_bio->master_bio;
 
 	bio_endio(bio, bio->bi_size,
-		test_bit(R1BIO_Uptodate, &r1_bio->state) ? 0 : -EIO);
+		test_bit(R1BIO_Uptodate, &r1_bio->state) ? BLK_SUCCESS : BLKERR_IO);
 	free_r1bio(r1_bio);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -238,7 +238,7 @@ static void raid_end_bio_io(r10bio_t *r1
 	struct bio *bio = r10_bio->master_bio;
 
 	bio_endio(bio, bio->bi_size,
-		test_bit(R10BIO_Uptodate, &r10_bio->state) ? 0 : -EIO);
+		test_bit(R10BIO_Uptodate, &r10_bio->state) ? BLK_SUCCESS : BLKERR_IO);
 	free_r10bio(r10_bio);
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1249,7 +1249,7 @@ static void handle_stripe(struct stripe_
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes, BLK_SUCCESS);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -1469,7 +1469,7 @@ static int make_request (request_queue_t
 		if ( bio_data_dir(bi) == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes, BLK_SUCCESS);
 	}
 	spin_unlock_irq(&conf->device_lock);
 	return 0;
diff --git a/drivers/md/raid6main.c b/drivers/md/raid6main.c
--- a/drivers/md/raid6main.c
+++ b/drivers/md/raid6main.c
@@ -1408,7 +1408,7 @@ static void handle_stripe(struct stripe_
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes, BLK_SUCCESS);
 	}
 	for (i=disks; i-- ;) {
 		int rw;
@@ -1628,7 +1628,7 @@ static int make_request (request_queue_t
 		if ( bio_data_dir(bi) == WRITE )
 			md_write_end(mddev);
 		bi->bi_size = 0;
-		bi->bi_end_io(bi, bytes, 0);
+		bi->bi_end_io(bi, bytes, BLK_SUCCESS);
 	}
 	spin_unlock_irq(&conf->device_lock);
 	return 0;
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -438,7 +438,7 @@ static void i2o_block_delayed_request_fn
 /**
  *	i2o_block_end_request - Post-processing of completed commands
  *	@req: request which should be completed
- *	@uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ *	@uptodate: A BLKERR_* value or BLK_SUCCESS
  *	@nr_bytes: number of bytes to complete
  *
  *	Mark the request as complete. The lock must not be held when entering.
@@ -458,8 +458,8 @@ static void i2o_block_end_request(struct
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
-		if (end_io_error(uptodate))
-			end_that_request_chunk(req, 0, leftover);
+		if (uptodate != BLK_SUCCESS)
+			end_that_request_chunk(req, uptodate, leftover);
 	}
 
 	add_disk_randomness(req->rq_disk);
@@ -494,7 +494,7 @@ static int i2o_block_reply(struct i2o_co
 			   struct i2o_message *msg)
 {
 	struct request *req;
-	int uptodate = 1;
+	int uptodate = BLK_SUCCESS;
 
 	req = i2o_cntxt_list_get(c, le32_to_cpu(msg->u.s.tcntxt));
 	if (unlikely(!req)) {
@@ -527,7 +527,7 @@ static int i2o_block_reply(struct i2o_co
 
 		req->errors++;
 
-		uptodate = 0;
+		uptodate = BLKERR_IO;
 	}
 
 	i2o_block_end_request(req, uptodate, le32_to_cpu(msg->body[1]));
diff --git a/drivers/mmc/mmc_block.c b/drivers/mmc/mmc_block.c
--- a/drivers/mmc/mmc_block.c
+++ b/drivers/mmc/mmc_block.c
@@ -247,7 +247,8 @@ static int mmc_blk_issue_rq(struct mmc_q
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
-		ret = end_that_request_chunk(req, 1, brq.data.bytes_xfered);
+		ret = end_that_request_chunk(req, BLK_SUCCESS,
+					     brq.data.bytes_xfered);
 		if (!ret) {
 			/*
 			 * The whole request completed successfully.
@@ -274,7 +275,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 	 */
 	spin_lock_irq(&md->lock);
 	do {
-		ret = end_that_request_chunk(req, 0,
+		ret = end_that_request_chunk(req, BLKERR_IO,
 				req->current_nr_sectors << 9);
 	} while (ret);
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1036,7 +1036,9 @@ dasd_int_handler(struct ccw_device *cdev
 static inline void
 dasd_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	int err = !uptodate ? BLKERR_IO : BLK_SUCCESS;
+
+	if (end_that_request_first(req, err, req->hard_nr_sectors))
 		BUG();
 	add_disk_randomness(req->rq_disk);
 	end_that_request_last(req);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -675,7 +675,7 @@ dcssblk_make_request(request_queue_t *q,
 		}
 		bytes_done += bvec->bv_len;
 	}
-	bio_endio(bio, bytes_done, 0);
+	bio_endio(bio, bytes_done, BLK_SUCCESS);
 	return 0;
 fail:
 	bio_io_error(bio, bio->bi_size);
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -321,7 +321,7 @@ static int xpram_make_request(request_qu
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bytes = bio->bi_size;
 	bio->bi_size = 0;
-	bio->bi_end_io(bio, bytes, 0);
+	bio->bi_end_io(bio, bytes, BLK_SUCCESS);
 	return 0;
 fail:
 	bio_io_error(bio, bio->bi_size);
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -91,7 +91,7 @@ __tapeblock_end_request(struct tape_requ
 
 	device = ccw_req->device;
 	req = (struct request *) data;
-	tapeblock_end_request(req, ccw_req->rc == 0);
+	tapeblock_end_request(req, ccw_req->rc == 0 ? BLK_SUCCESS : BLKERR_IO);
 	if (ccw_req->rc == 0)
 		/* Update position. */
 		device->blk_data.block_position =
@@ -119,7 +119,7 @@ tapeblock_start_request(struct tape_devi
 	ccw_req = device->discipline->bread(device, req);
 	if (IS_ERR(ccw_req)) {
 		DBF_EVENT(1, "TBLOCK: bread failed\n");
-		tapeblock_end_request(req, 0);
+		tapeblock_end_request(req, BLKERR_IO);
 		return PTR_ERR(ccw_req);
 	}
 	ccw_req->callback = __tapeblock_end_request;
@@ -132,7 +132,7 @@ tapeblock_start_request(struct tape_devi
 		 * Start/enqueueing failed. No retries in
 		 * this case.
 		 */
-		tapeblock_end_request(req, 0);
+		tapeblock_end_request(req, BLKERR_IO);
 		device->discipline->free_bread(ccw_req);
 	}
 
@@ -175,7 +175,7 @@ tapeblock_requeue(void *data) {
 		if (rq_data_dir(req) == WRITE) {
 			DBF_EVENT(1, "TBLOCK: Rejecting write request\n");
 			blkdev_dequeue_request(req);
-			tapeblock_end_request(req, 0);
+			tapeblock_end_request(req, BLKERR_IO);
 			continue;
 		}
 		spin_unlock_irq(&device->blk_data.request_queue_lock);
diff --git a/fs/bio.c b/fs/bio.c
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -664,7 +664,7 @@ struct bio *bio_map_user(request_queue_t
 	/*
 	 * don't support partial mappings
 	 */
-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, bio->bi_size, BLK_SUCCESS);
 	bio_unmap_user(bio);
 	return ERR_PTR(-EINVAL);
 }
@@ -837,14 +837,13 @@ void bio_check_pages_dirty(struct bio *b
  *   bio_endio() will end I/O on @bytes_done number of bytes. This may be
  *   just a partial part of the bio, or it may be the whole bio. bio_endio()
  *   is the preferred way to end I/O on a bio, it takes care of decrementing
- *   bi_size and clearing BIO_UPTODATE on error. @error is 0 on success, and
- *   and one of the established -Exxxx (-EIO, for instance) error values in
- *   case something went wrong. Noone should call bi_end_io() directly on
+ *   bi_size and clearing BIO_UPTODATE on error. @error is a block layer error
+ *   value defined in blkdev.h. Noone should call bi_end_io() directly on
  *   a bio unless they own it and thus know that it has an end_io function.
  **/
 void bio_endio(struct bio *bio, unsigned int bytes_done, int error)
 {
-	if (error)
+	if (error != BLK_SUCCESS)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 
 	if (unlikely(bytes_done > bio->bi_size)) {
@@ -874,7 +873,7 @@ static int bio_pair_end_1(struct bio * b
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
 
-	if (err)
+	if (err != BLK_SUCCESS)
 		bp->error = err;
 
 	if (bi->bi_size)
@@ -888,7 +887,7 @@ static int bio_pair_end_2(struct bio * b
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
 
-	if (err)
+	if (err != BLK_SUCCESS)
 		bp->error = err;
 
 	if (bi->bi_size)
@@ -912,7 +911,7 @@ struct bio_pair *bio_split(struct bio *b
 	BUG_ON(bi->bi_vcnt != 1);
 	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
-	bp->error = 0;
+	bp->error = BLK_SUCCESS;
 	bp->bio1 = *bi;
 	bp->bio2 = *bi;
 	bp->bio2.bi_sector += first_sectors;
diff --git a/fs/buffer.c b/fs/buffer.c
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2733,7 +2733,7 @@ static int end_bio_bh_io_sync(struct bio
 	if (bio->bi_size)
 		return 1;
 
-	if (err == -EOPNOTSUPP) {
+	if (err == BLKERR_NOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		set_bit(BH_Eopnotsupp, &bh->b_state);
 	}
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2157,7 +2157,7 @@ static void lbmStartIO(struct lbuf * bp)
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_size = 0;
-		lbmIODone(bio, 0, 0);
+		lbmIODone(bio, 0, BLKERR_IO);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -222,7 +222,7 @@ struct bio {
 #define BIO_SEG_BOUNDARY(q, b1, b2) \
 	BIOVEC_SEG_BOUNDARY((q), __BVEC_END((b1)), __BVEC_START((b2)))
 
-#define bio_io_error(bio, bytes) bio_endio((bio), (bytes), -EIO)
+#define bio_io_error(bio, bytes) bio_endio((bio), (bytes), BLKERR_IO)
 
 /*
  * drivers should not use the __ version unless they _really_ want to
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -599,12 +599,21 @@ extern void end_that_request_last(struct
 extern void end_request(struct request *req, int uptodate);
 
 /*
- * end_that_request_first/chunk() takes an uptodate argument. we account
- * any value <= as an io error. 0 means -EIO for compatability reasons,
- * any other < 0 value is the direct error type. An uptodate value of
- * 1 indicates successful io completion
+ * Error values that users of end_that_request_first/chunk,
+ * bio_endio/bi_end_io should use to indicate I/O completion status.
  */
-#define end_io_error(uptodate)	(unlikely((uptodate) <= 0))
+enum {
+	BLK_SUCCESS = 0,	/* Must be zero for compat with old usage */
+	BLKERR_IO,		/* Generic I/O error */
+	BLKERR_NOTSUPP,		/* Operation is not supported */
+	BLKERR_WOULDBLOCK,	/* Operation would block */
+	BLKERR_FATAL_DRV,	/* Fatal driver error */
+	BLKERR_FATAL_DEV,	/* Fatal device error */
+	BLKERR_FATAL_XPT,	/* Fatal transport error */
+	BLKERR_RETRY_DRV,	/* Driver error, I/O may be retried */
+	BLKERR_RETRY_DEV,	/* Device error, I/O may be retried */
+	BLKERR_RETRY_XPT,	/* Transport error, I/O may retried */
+};
 
 static inline void blkdev_dequeue_request(struct request *req)
 {
