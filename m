From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 5/7] st: update to use block timeout
Date: Sun, 30 Nov 2008 10:36:26 -0600
Message-ID: <1228062986.4115.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40469 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYK3Qg0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:36:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <Jens.Axboe@oracle.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>

Since we're trying to eliminate struct scsi_device timeout, the tape
driver has to be updated to use the block queue timeout instead.  The
tape use of scsi_device timeout looks to be self consistent, so I don't
think this necessarily fixes any bug, but it has to be done to allow me
to remove the timeout parameter from struct scsi_device.

Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c959bdc..d60be83 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -613,7 +613,8 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 		   tape_name(STp), forward ? "forward" : "backward"));
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->request_queue->rq_timeout,
+			   MAX_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -657,7 +658,8 @@ static int st_flush_write_buffer(struct scsi_tape * STp)
 		cmd[4] = blks;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, transfer, DMA_TO_DEVICE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+				   STp->device->request_queue->rq_timeout,
+				   MAX_WRITE_RETRIES, 1);
 		if (!SRpnt)
 			return (STp->buffer)->syscall_result;
 
@@ -987,7 +989,8 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		cmd[0] = READ_BLOCK_LIMITS;
 
 		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
-				   STp->device->timeout, MAX_READY_RETRIES, 1);
+				   STp->device->request_queue->rq_timeout,
+				   MAX_READY_RETRIES, 1);
 		if (!SRpnt) {
 			retval = (STp->buffer)->syscall_result;
 			goto err_out;
@@ -1014,7 +1017,8 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	cmd[4] = 12;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+			   STp->device->request_queue->rq_timeout,
+			   MAX_READY_RETRIES, 1);
 	if (!SRpnt) {
 		retval = (STp->buffer)->syscall_result;
 		goto err_out;
@@ -1247,7 +1251,8 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		cmd[4] = 1 + STp->two_fm;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+				   STp->device->request_queue->rq_timeout,
+				   MAX_WRITE_RETRIES, 1);
 		if (!SRpnt) {
 			result = (STp->buffer)->syscall_result;
 			goto out;
@@ -1634,7 +1639,8 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		cmd[4] = blks;
 
 		SRpnt = st_do_scsi(SRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write);
+				   STp->device->request_queue->rq_timeout,
+				   MAX_WRITE_RETRIES, !async_write);
 		if (!SRpnt) {
 			retval = STbp->syscall_result;
 			goto out;
@@ -1804,7 +1810,8 @@ static long read_tape(struct scsi_tape *STp, long count,
 
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->request_queue->rq_timeout,
+			   MAX_RETRIES, 1);
 	release_buffering(STp, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
@@ -2213,7 +2220,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 			DEBC( printk(KERN_INFO "%s: Long timeout set to %d seconds.\n", name,
 			       (value & ~MT_ST_SET_LONG_TIMEOUT)));
 		} else {
-			STp->device->timeout = value * HZ;
+			blk_queue_rq_timeout(STp->device->request_queue,
+					     value * HZ);
 			DEBC( printk(KERN_INFO "%s: Normal timeout set to %d seconds.\n",
 				name, value) );
 		}
@@ -2321,7 +2329,7 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 	cmd[4] = 255;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
+			   STp->device->request_queue->rq_timeout, 0, 1);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2352,7 +2360,7 @@ static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
-			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1);
+			   (slow ? STp->long_timeout : STp->device->request_queue->rq_timeout), 0, 1);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2464,7 +2472,7 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 	}
 	if (STp->immediate) {
 		cmd[1] = 1;	/* Don't wait for completion */
-		timeout = STp->device->timeout;
+		timeout = STp->device->request_queue->rq_timeout;
 	}
 	else
 		timeout = STp->long_timeout;
@@ -2638,7 +2646,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-		timeout = STp->device->timeout;
+		timeout = STp->device->request_queue->rq_timeout;
                 DEBC(
                      if (cmd_in == MTWEOF)
                                printk(ST_DEB_MSG "%s: Writing %d filemarks.\n", name,
@@ -2656,7 +2664,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[0] = REZERO_UNIT;
 		if (STp->immediate) {
 			cmd[1] = 1;	/* Don't wait for completion */
-			timeout = STp->device->timeout;
+			timeout = STp->device->request_queue->rq_timeout;
 		}
                 DEBC(printk(ST_DEB_MSG "%s: Rewinding tape.\n", name));
 		fileno = blkno = at_sm = 0;
@@ -2669,7 +2677,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[0] = START_STOP;
 		if (STp->immediate) {
 			cmd[1] = 1;	/* Don't wait for completion */
-			timeout = STp->device->timeout;
+			timeout = STp->device->request_queue->rq_timeout;
 		}
 		cmd[4] = 3;
                 DEBC(printk(ST_DEB_MSG "%s: Retensioning tape.\n", name));
@@ -2702,7 +2710,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[1] = (arg ? 1 : 0);	/* Long erase with non-zero argument */
 		if (STp->immediate) {
 			cmd[1] |= 2;	/* Don't wait for completion */
-			timeout = STp->device->timeout;
+			timeout = STp->device->request_queue->rq_timeout;
 		}
 		else
 			timeout = STp->long_timeout * 8;
@@ -2754,7 +2762,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		(STp->buffer)->b_data[9] = (ltmp >> 16);
 		(STp->buffer)->b_data[10] = (ltmp >> 8);
 		(STp->buffer)->b_data[11] = ltmp;
-		timeout = STp->device->timeout;
+		timeout = STp->device->request_queue->rq_timeout;
                 DEBC(
 			if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK)
 				printk(ST_DEB_MSG
@@ -2944,7 +2952,8 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
 			scmd[1] = 1;
 	}
 	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+			   STp->device->request_queue->rq_timeout,
+			   MAX_READY_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -3045,7 +3054,7 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 	}
 	if (STp->immediate) {
 		scmd[1] |= 1;		/* Don't wait for completion */
-		timeout = STp->device->timeout;
+		timeout = STp->device->request_queue->rq_timeout;
 	}
 
 	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
@@ -4029,7 +4038,7 @@ static int st_probe(struct device *dev)
 	tpnt->partition = 0;
 	tpnt->new_partition = 0;
 	tpnt->nbr_partitions = 0;
-	tpnt->device->timeout = ST_TIMEOUT;
+	blk_queue_rq_timeout(tpnt->device->request_queue, ST_TIMEOUT);
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
 


