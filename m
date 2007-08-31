From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/7] blk_end_request: changing "normal" drivers
Date: Fri, 31 Aug 2007 18:42:19 -0400 (EDT)
Message-ID: <20070831.184219.95065632.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts "normal" drivers, which complete request
in a standard way shown below, to use blk_end_request().

 a) end_that_request_{chunk/first}
    spin_lock_irqsave()
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => blk_end_request()

 b) spin_lock_irqsave()
    end_that_request_{chunk/first}
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => spin_lock_irqsave()
       __blk_end_request()
       spin_unlock_irqsave()

 c) end_that_request_last()
    => __blk_end_request()

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 arch/arm/plat-omap/mailbox.c    |    9 ++++++---
 arch/um/drivers/ubd_kern.c      |   10 +---------
 block/elevator.c                |    4 ++--
 block/ll_rw_blk.c               |   15 +++++----------
 drivers/block/DAC960.c          |    6 ++----
 drivers/block/floppy.c          |    8 +++-----
 drivers/block/lguest_blk.c      |    5 +----
 drivers/block/nbd.c             |    4 +---
 drivers/block/ps3disk.c         |    6 +-----
 drivers/block/sunvdc.c          |    5 +----
 drivers/block/sx8.c             |    4 +---
 drivers/block/ub.c              |    4 ++--
 drivers/block/viodasd.c         |    5 +----
 drivers/block/xen-blkfront.c    |    5 ++---
 drivers/cdrom/viocd.c           |    5 +----
 drivers/ide/ide-cd.c            |    6 +++---
 drivers/ide/ide-io.c            |   22 +++++++---------------
 drivers/message/i2o/i2o_block.c |    8 ++------
 drivers/mmc/card/block.c        |   24 +++++-------------------
 drivers/mmc/card/queue.c        |    4 ++--
 drivers/s390/block/dasd.c       |    4 +---
 drivers/s390/char/tape_block.c  |    3 +--
 drivers/scsi/ide-scsi.c         |    8 ++++----
 drivers/scsi/scsi_lib.c         |   13 ++-----------
 24 files changed, 57 insertions(+), 130 deletions(-)

diff -rupN 02-sect2byte-macro/arch/arm/plat-omap/mailbox.c 03-normal-caller-change/arch/arm/plat-omap/mailbox.c
--- 02-sect2byte-macro/arch/arm/plat-omap/mailbox.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/arch/arm/plat-omap/mailbox.c	2007-08-23 17:51:33.000000000 -0400
@@ -117,7 +117,8 @@ static void mbox_tx_work(struct work_str
 
 		spin_lock(q->queue_lock);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock(q->queue_lock);
 	}
 }
@@ -151,7 +152,8 @@ static void mbox_rx_work(struct work_str
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		mbox->rxq->callback((void *)msg);
@@ -265,7 +267,8 @@ omap_mbox_read(struct device *dev, struc
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		if (unlikely(mbox_seq_test(mbox, *p))) {
diff -rupN 02-sect2byte-macro/arch/um/drivers/ubd_kern.c 03-normal-caller-change/arch/um/drivers/ubd_kern.c
--- 02-sect2byte-macro/arch/um/drivers/ubd_kern.c	2007-08-22 18:54:03.000000000 -0400
+++ 03-normal-caller-change/arch/um/drivers/ubd_kern.c	2007-08-23 17:51:33.000000000 -0400
@@ -476,15 +476,7 @@ int thread_fd = -1;
 
 static void ubd_end_request(struct request *req, int bytes, int uptodate)
 {
-	if (!end_that_request_first(req, uptodate, bytes >> 9)) {
-		struct ubd *dev = req->rq_disk->private_data;
-		unsigned long flags;
-
-		add_disk_randomness(req->rq_disk);
-		spin_lock_irqsave(&dev->lock, flags);
-		end_that_request_last(req, uptodate);
-		spin_unlock_irqrestore(&dev->lock, flags);
-	}
+	blk_end_request(req, uptodate, bytes);
 }
 
 /* Callable only from interrupt context - otherwise you need to do
diff -rupN 02-sect2byte-macro/block/elevator.c 03-normal-caller-change/block/elevator.c
--- 02-sect2byte-macro/block/elevator.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/block/elevator.c	2007-08-23 17:51:33.000000000 -0400
@@ -758,8 +758,8 @@ struct request *elv_next_request(struct 
 
 			blkdev_dequeue_request(rq);
 			rq->cmd_flags |= REQ_QUIET;
-			end_that_request_chunk(rq, 0, nr_bytes);
-			end_that_request_last(rq, 0);
+			if (__blk_end_request(rq, 0, nr_bytes))
+				BUG();
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
 								ret);
diff -rupN 02-sect2byte-macro/block/ll_rw_blk.c 03-normal-caller-change/block/ll_rw_blk.c
--- 02-sect2byte-macro/block/ll_rw_blk.c	2007-08-23 17:19:20.000000000 -0400
+++ 03-normal-caller-change/block/ll_rw_blk.c	2007-08-23 17:51:33.000000000 -0400
@@ -379,8 +379,8 @@ void blk_ordered_complete_seq(struct req
 
 	q->ordseq = 0;
 
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_size(rq)))
+		BUG();
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -494,9 +494,8 @@ int blk_do_ordered(struct request_queue 
 			 * ORDERED_NONE while this request is on it.
 			 */
 			blkdev_dequeue_request(rq);
-			end_that_request_first(rq, -EOPNOTSUPP,
-					       rq->hard_nr_sectors);
-			end_that_request_last(rq, -EOPNOTSUPP);
+			if (__blk_end_request(rq, -EOPNOTSUPP, blk_rq_size(rq)))
+				BUG();
 			*rqp = NULL;
 			return 0;
 		}
@@ -3660,11 +3659,7 @@ EXPORT_SYMBOL(end_that_request_last);
 
 void end_request(struct request *req, int uptodate)
 {
-	if (!end_that_request_first(req, uptodate, req->hard_cur_sectors)) {
-		add_disk_randomness(req->rq_disk);
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, sect2byte(req->hard_cur_sectors));
 }
 
 EXPORT_SYMBOL(end_request);
diff -rupN 02-sect2byte-macro/drivers/block/DAC960.c 03-normal-caller-change/drivers/block/DAC960.c
--- 02-sect2byte-macro/drivers/block/DAC960.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/DAC960.c	2007-08-23 17:51:33.000000000 -0400
@@ -3457,10 +3457,8 @@ static inline bool DAC960_ProcessComplet
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
 
-	 if (!end_that_request_first(Request, UpToDate, Command->BlockCount)) {
-		add_disk_randomness(Request->rq_disk);
- 	 	end_that_request_last(Request, UpToDate);
-
+	 if (!__blk_end_request(Request, UpToDate,
+				sect2byte(Command->BlockCount))) {
 		if (Command->Completion) {
 			complete(Command->Completion);
 			Command->Completion = NULL;
diff -rupN 02-sect2byte-macro/drivers/block/floppy.c 03-normal-caller-change/drivers/block/floppy.c
--- 02-sect2byte-macro/drivers/block/floppy.c	2007-08-22 18:54:04.000000000 -0400
+++ 03-normal-caller-change/drivers/block/floppy.c	2007-08-23 17:51:33.000000000 -0400
@@ -2290,18 +2290,16 @@ static int do_format(int drive, struct f
 static void floppy_end_request(struct request *req, int uptodate)
 {
 	unsigned int nr_sectors = current_count_sectors;
+	unsigned int drive = (unsigned int)req->rq_disk->private_data;
 
 	/* current_count_sectors can be zero if transfer failed */
 	if (!uptodate)
 		nr_sectors = req->current_nr_sectors;
-	if (end_that_request_first(req, uptodate, nr_sectors))
+	if (__blk_end_request(req, uptodate, sect2byte(nr_sectors)))
 		return;
-	add_disk_randomness(req->rq_disk);
-	floppy_off((long)req->rq_disk->private_data);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 
 	/* We're done with the request */
+	floppy_off(drive);
 	current_req = NULL;
 }
 
diff -rupN 02-sect2byte-macro/drivers/block/lguest_blk.c 03-normal-caller-change/drivers/block/lguest_blk.c
--- 02-sect2byte-macro/drivers/block/lguest_blk.c	2007-08-22 18:54:04.000000000 -0400
+++ 03-normal-caller-change/drivers/block/lguest_blk.c	2007-08-23 17:51:33.000000000 -0400
@@ -77,11 +77,8 @@ struct blockdev
  * request.  This improved disk speed by 130%. */
 static void end_entire_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_size(req)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 /* I'm told there are only two stories in the world worth telling: love and
diff -rupN 02-sect2byte-macro/drivers/block/nbd.c 03-normal-caller-change/drivers/block/nbd.c
--- 02-sect2byte-macro/drivers/block/nbd.c	2007-08-22 18:54:04.000000000 -0400
+++ 03-normal-caller-change/drivers/block/nbd.c	2007-08-23 17:51:33.000000000 -0400
@@ -107,9 +107,7 @@ static void nbd_end_request(struct reque
 			req, uptodate? "done": "failed");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, sect2byte(req->nr_sectors));
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
diff -rupN 02-sect2byte-macro/drivers/block/ps3disk.c 03-normal-caller-change/drivers/block/ps3disk.c
--- 02-sect2byte-macro/drivers/block/ps3disk.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/ps3disk.c	2007-08-23 17:51:33.000000000 -0400
@@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
 	}
 
 	spin_lock(&priv->lock);
-	if (!end_that_request_first(req, uptodate, num_sectors)) {
-		add_disk_randomness(req->rq_disk);
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, sect2byte(num_sectors));
 	priv->req = NULL;
 	ps3disk_do_request(dev, priv->queue);
 	spin_unlock(&priv->lock);
diff -rupN 02-sect2byte-macro/drivers/block/sunvdc.c 03-normal-caller-change/drivers/block/sunvdc.c
--- 02-sect2byte-macro/drivers/block/sunvdc.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/sunvdc.c	2007-08-23 17:51:33.000000000 -0400
@@ -213,10 +213,7 @@ static void vdc_end_special(struct vdc_p
 
 static void vdc_end_request(struct request *req, int uptodate, int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, uptodate, sect2byte(num_sectors));
 }
 
 static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
diff -rupN 02-sect2byte-macro/drivers/block/sx8.c 03-normal-caller-change/drivers/block/sx8.c
--- 02-sect2byte-macro/drivers/block/sx8.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/sx8.c	2007-08-23 17:51:33.000000000 -0400
@@ -747,11 +747,9 @@ static inline void carm_end_request_queu
 	struct request *req = crq->rq;
 	int rc;
 
-	rc = end_that_request_first(req, uptodate, req->hard_nr_sectors);
+	rc = __blk_end_request(req, uptodate, blk_rq_size(req));
 	assert(rc == 0);
 
-	end_that_request_last(req, uptodate);
-
 	rc = carm_put_request(host, crq);
 	assert(rc == 0);
 }
diff -rupN 02-sect2byte-macro/drivers/block/ub.c 03-normal-caller-change/drivers/block/ub.c
--- 02-sect2byte-macro/drivers/block/ub.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/ub.c	2007-08-23 17:51:33.000000000 -0400
@@ -814,8 +814,8 @@ static void ub_end_rq(struct request *rq
 		uptodate = 0;
 		rq->errors = scsi_status;
 	}
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_size(rq)))
+		BUG();
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
diff -rupN 02-sect2byte-macro/drivers/block/viodasd.c 03-normal-caller-change/drivers/block/viodasd.c
--- 02-sect2byte-macro/drivers/block/viodasd.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/viodasd.c	2007-08-23 17:51:33.000000000 -0400
@@ -275,10 +275,7 @@ static struct block_device_operations vi
 static void viodasd_end_request(struct request *req, int uptodate,
 		int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, uptodate, sect2byte(num_sectors));
 }
 
 /*
diff -rupN 02-sect2byte-macro/drivers/block/xen-blkfront.c 03-normal-caller-change/drivers/block/xen-blkfront.c
--- 02-sect2byte-macro/drivers/block/xen-blkfront.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/block/xen-blkfront.c	2007-08-23 17:51:33.000000000 -0400
@@ -498,10 +498,9 @@ static irqreturn_t blkif_interrupt(int i
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = end_that_request_first(req, uptodate,
-				req->hard_nr_sectors);
+			ret = __blk_end_request(req, uptodate,
+						blk_rq_size(req));
 			BUG_ON(ret);
-			end_that_request_last(req, uptodate);
 			break;
 		default:
 			BUG();
diff -rupN 02-sect2byte-macro/drivers/cdrom/viocd.c 03-normal-caller-change/drivers/cdrom/viocd.c
--- 02-sect2byte-macro/drivers/cdrom/viocd.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/cdrom/viocd.c	2007-08-23 17:51:33.000000000 -0400
@@ -389,11 +389,8 @@ static void viocd_end_request(struct req
 	if (!nsectors)
 		nsectors = 1;
 
-	if (end_that_request_first(req, uptodate, nsectors))
+	if (__blk_end_request(req, uptodate, sect2byte(nsectors)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 static int rwreq;
diff -rupN 02-sect2byte-macro/drivers/ide/ide-cd.c 03-normal-caller-change/drivers/ide/ide-cd.c
--- 02-sect2byte-macro/drivers/ide/ide-cd.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/ide/ide-cd.c	2007-08-23 17:51:33.000000000 -0400
@@ -655,9 +655,9 @@ static void cdrom_end_request (ide_drive
 					BUG();
 			} else {
 				spin_lock_irqsave(&ide_lock, flags);
-				end_that_request_chunk(failed, 0,
-							failed->data_len);
-				end_that_request_last(failed, 0);
+				if (__blk_end_request(failed, 0,
+						      failed->data_len))
+					BUG();
 				spin_unlock_irqrestore(&ide_lock, flags);
 			}
 		} else
diff -rupN 02-sect2byte-macro/drivers/ide/ide-io.c 03-normal-caller-change/drivers/ide/ide-io.c
--- 02-sect2byte-macro/drivers/ide/ide-io.c	2007-08-22 18:54:04.000000000 -0400
+++ 03-normal-caller-change/drivers/ide/ide-io.c	2007-08-23 17:51:33.000000000 -0400
@@ -78,12 +78,8 @@ static int __ide_end_request(ide_drive_t
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		add_disk_randomness(rq->rq_disk);
-		if (!list_empty(&rq->queuelist))
-			blkdev_dequeue_request(rq);
+	if (!__blk_end_request(rq, uptodate, nr_bytes)) {
 		HWGROUP(drive)->rq = NULL;
-		end_that_request_last(rq, uptodate);
 		ret = 0;
 	}
 
@@ -280,13 +276,9 @@ int ide_end_dequeued_request(ide_drive_t
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_first(rq, uptodate, nr_sectors)) {
-		add_disk_randomness(rq->rq_disk);
-		if (blk_rq_tagged(rq))
-			blk_queue_end_tag(drive->queue, rq);
-		end_that_request_last(rq, uptodate);
+	if (!__blk_end_request(rq, uptodate, sect2byte(nr_sectors)))
 		ret = 0;
-	}
+
 	spin_unlock_irqrestore(&ide_lock, flags);
 	return ret;
 }
@@ -316,9 +308,9 @@ static void ide_complete_pm_request (ide
 		drive->blocked = 0;
 		blk_start_queue(drive->queue);
 	}
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
-	end_that_request_last(rq, 1);
+	if (__blk_end_request(rq, 1, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
@@ -448,10 +440,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	}
 
 	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
-	end_that_request_last(rq, !rq->errors);
+	if (__blk_end_request(rq, !rq->errors, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
diff -rupN 02-sect2byte-macro/drivers/message/i2o/i2o_block.c 03-normal-caller-change/drivers/message/i2o/i2o_block.c
--- 02-sect2byte-macro/drivers/message/i2o/i2o_block.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/message/i2o/i2o_block.c	2007-08-23 17:51:33.000000000 -0400
@@ -448,22 +448,18 @@ static void i2o_block_end_request(struct
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
-	if (end_that_request_chunk(req, uptodate, nr_bytes)) {
+	if (blk_end_request(req, uptodate, nr_bytes)) {
 		int leftover = (req->hard_nr_sectors << KERNEL_SECTOR_SHIFT);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
 		if (end_io_error(uptodate))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 	}
 
-	add_disk_randomness(req->rq_disk);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 
-	end_that_request_last(req, uptodate);
-
 	if (likely(dev)) {
 		dev->open_queue_depth--;
 		list_del(&ireq->queue);
diff -rupN 02-sect2byte-macro/drivers/mmc/card/block.c 03-normal-caller-change/drivers/mmc/card/block.c
--- 02-sect2byte-macro/drivers/mmc/card/block.c	2007-08-22 18:54:04.000000000 -0400
+++ 03-normal-caller-change/drivers/mmc/card/block.c	2007-08-23 17:51:33.000000000 -0400
@@ -336,15 +336,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
-		ret = end_that_request_chunk(req, 1, brq.data.bytes_xfered);
-		if (!ret) {
-			/*
-			 * The whole request completed successfully.
-			 */
-			add_disk_randomness(req->rq_disk);
-			blkdev_dequeue_request(req);
-			end_that_request_last(req, 1);
-		}
+		ret = __blk_end_request(req, 1, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
@@ -374,27 +366,21 @@ static int mmc_blk_issue_rq(struct mmc_q
 			else
 				bytes = blocks << 9;
 			spin_lock_irq(&md->lock);
-			ret = end_that_request_chunk(req, 1, bytes);
+			ret = __blk_end_request(req, 1, bytes);
 			spin_unlock_irq(&md->lock);
 		}
 	} else if (rq_data_dir(req) != READ &&
 		   (card->host->caps & MMC_CAP_MULTIWRITE)) {
 		spin_lock_irq(&md->lock);
-		ret = end_that_request_chunk(req, 1, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, 1, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
 	mmc_release_host(card->host);
 
 	spin_lock_irq(&md->lock);
-	while (ret) {
-		ret = end_that_request_chunk(req, 0,
-				req->current_nr_sectors << 9);
-	}
-
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	while (ret)
+		ret = __blk_end_request(req, 0, blk_rq_cur_size(req));
 	spin_unlock_irq(&md->lock);
 
 	return 0;
diff -rupN 02-sect2byte-macro/drivers/mmc/card/queue.c 03-normal-caller-change/drivers/mmc/card/queue.c
--- 02-sect2byte-macro/drivers/mmc/card/queue.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/mmc/card/queue.c	2007-08-23 17:51:33.000000000 -0400
@@ -93,8 +93,8 @@ static void mmc_request(struct request_q
 		printk(KERN_ERR "MMC: killing requests for dead queue\n");
 		while ((req = elv_next_request(q)) != NULL) {
 			do {
-				ret = end_that_request_chunk(req, 0,
-					req->current_nr_sectors << 9);
+				ret = __blk_end_request(req, 0,
+							blk_rq_cur_size(req));
 			} while (ret);
 		}
 		return;
diff -rupN 02-sect2byte-macro/drivers/s390/block/dasd.c 03-normal-caller-change/drivers/s390/block/dasd.c
--- 02-sect2byte-macro/drivers/s390/block/dasd.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/s390/block/dasd.c	2007-08-23 17:51:33.000000000 -0400
@@ -1080,10 +1080,8 @@ dasd_int_handler(struct ccw_device *cdev
 static inline void
 dasd_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_size(req)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
 }
 
 /*
diff -rupN 02-sect2byte-macro/drivers/s390/char/tape_block.c 03-normal-caller-change/drivers/s390/char/tape_block.c
--- 02-sect2byte-macro/drivers/s390/char/tape_block.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/s390/char/tape_block.c	2007-08-23 17:51:33.000000000 -0400
@@ -76,9 +76,8 @@ tapeblock_trigger_requeue(struct tape_de
 static void
 tapeblock_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_size(req)))
 		BUG();
-	end_that_request_last(req, uptodate);
 }
 
 static void
diff -rupN 02-sect2byte-macro/drivers/scsi/ide-scsi.c 03-normal-caller-change/drivers/scsi/ide-scsi.c
--- 02-sect2byte-macro/drivers/scsi/ide-scsi.c	2007-08-13 00:25:24.000000000 -0400
+++ 03-normal-caller-change/drivers/scsi/ide-scsi.c	2007-08-23 17:51:33.000000000 -0400
@@ -1035,8 +1035,8 @@ static int idescsi_eh_reset (struct scsi
 	}
 
 	/* kill current request */
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	if (__blk_end_request(req, 0, 0))
+		BUG();
 	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
@@ -1045,8 +1045,8 @@ static int idescsi_eh_reset (struct scsi
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, 0);
+		if (__blk_end_request(req, 0, 0))
+			BUG();
 	}
 
 	HWGROUP(drive)->rq = NULL;
diff -rupN 02-sect2byte-macro/drivers/scsi/scsi_lib.c 03-normal-caller-change/drivers/scsi/scsi_lib.c
--- 02-sect2byte-macro/drivers/scsi/scsi_lib.c	2007-08-22 18:54:06.000000000 -0400
+++ 03-normal-caller-change/drivers/scsi/scsi_lib.c	2007-08-23 17:51:33.000000000 -0400
@@ -667,13 +667,12 @@ static struct scsi_cmnd *scsi_end_reques
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
-	unsigned long flags;
 
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_chunk(req, uptodate, bytes)) {
+	if (blk_end_request(req, uptodate, bytes)) {
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
@@ -681,7 +680,7 @@ static struct scsi_cmnd *scsi_end_reques
 
 		/* kill remainder if no retrys */
 		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 		else {
 			if (requeue) {
 				/*
@@ -696,14 +695,6 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
-	add_disk_randomness(req->rq_disk);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-	end_that_request_last(req, uptodate);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
