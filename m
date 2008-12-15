From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Tue, 16 Dec 2008 00:24:27 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812152138090.6315@kai.makisara.local>
References: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:51215 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYLOWYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 17:24:36 -0500
In-Reply-To: <1229004470-25718-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Thu, 11 Dec 2008, FUJITA Tomonori wrote:

> This patchset is the second half of the patchset to remove
> scsi_execute_async in st driver. IOW, this converts st driver to use
> the block layer functions.
> 
> st driver uses scsi_execute_async for two purposes, performing sort
> management SCSI commands internally and data transfer between user and
> kernel space (st_read and st_write). The former was converted and this
> converts the latter.
> 
I have looked at this patch set and run some tests. The patches make 
st_do_scsi() do everything it used to do before your patch sets. So, I 
could not resist making a patch that obsoletes st_scsi_kern_execute() from 
your first patch set :-) The patch is at the end of this message.

The simple tests pass without problems. Unfortunately, the same does not 
apply to tests with bigger blocks. I wrote some data to tape and read it 
with dd. Whenever the block size exceeded 1 MB, I got data corruption just 
after the 1 MB limit.

This reminds me of something from the "old days". IIRC, one bio can map 
256 pages. With 4 kB page this makes 1 MB. st had to use chained bios to 
go beyond 1 MB block size. Does the new method do this?

Thanks,
Kai
-------------------------------8<---------------------------------------
This patch removes st_scsi_kern_execute() and substitutes calls to it with 
calls to st_do_scsi(). st_scsi_execute() is changed not to call 
blk_rq_map_user() if no data transfer is required.

--- linux-t4/drivers/scsi/st.c.org	2008-12-15 19:25:14.000000000 +0200
+++ linux-t4/drivers/scsi/st.c	2008-12-15 21:24:55.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20080504";
+static const char *verstr = "20081215";
 
 #include <linux/module.h>
 
@@ -491,10 +491,12 @@ static int st_scsi_execute(struct st_req
 
 	mdata->null_mapped = 1;
 
-	err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen, GFP_KERNEL);
-	if (err) {
-		blk_put_request(req);
-		return DRIVER_ERROR << 24;
+	if (bufflen) {
+		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen, GFP_KERNEL);
+		if (err) {
+			blk_put_request(req);
+			return DRIVER_ERROR << 24;
+		}
 	}
 
 	SRpnt->bio = req->bio;
@@ -576,28 +578,6 @@ st_do_scsi(struct st_request * SRpnt, st
 	return SRpnt;
 }
 
-static int st_scsi_kern_execute(struct st_request *streq,
-				const unsigned char *cmd, int data_direction,
-				void *buffer, unsigned bufflen, int timeout,
-				int retries)
-{
-	struct scsi_tape *stp = streq->stp;
-	int ret, resid;
-
-	stp->buffer->cmdstat.have_sense = 0;
-	memcpy(streq->cmd, cmd, sizeof(streq->cmd));
-
-	ret = scsi_execute(stp->device, cmd, data_direction, buffer, bufflen,
-			   streq->sense, timeout, retries, 0, &resid);
-	if (driver_byte(ret) & DRIVER_ERROR)
-		return -EBUSY;
-
-	stp->buffer->cmdstat.midlevel_result = streq->result = ret;
-	stp->buffer->cmdstat.residual = resid;
-	stp->buffer->syscall_result = st_chk_result(stp, streq);
-
-	return 0;
-}
 
 /* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
    write has been correct but EOM early warning reached, -EIO if write ended in
@@ -670,7 +650,6 @@ static int cross_eof(struct scsi_tape *
 {
 	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	int ret;
 
 	cmd[0] = SPACE;
 	cmd[1] = 0x01;		/* Space FileMarks */
@@ -684,26 +663,20 @@ static int cross_eof(struct scsi_tape *
         DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
 		   tape_name(STp), forward ? "forward" : "backward"));
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			   STp->device->request_queue->rq_timeout,
+			   MAX_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
-				   STp->device->request_queue->rq_timeout,
-				   MAX_RETRIES);
-	if (ret)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
-	ret = STp->buffer->syscall_result;
+	st_release_request(SRpnt);
+	SRpnt = NULL;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
 		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
 		   tape_name(STp), forward ? "forward" : "backward");
 
-out:
-	st_release_request(SRpnt);
-
-	return ret;
+	return (STp->buffer)->syscall_result;
 }
 
 
@@ -924,24 +897,21 @@ static int test_ready(struct scsi_tape *
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt;
+	struct st_request *SRpnt = NULL;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
 
 	for (attentions=waits=0; ; ) {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
+				   STp->long_timeout, MAX_READY_RETRIES, 1);
 
-		retval = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
-					      STp->long_timeout,
-					      MAX_READY_RETRIES);
-		if (retval)
+		if (!SRpnt) {
+			retval = (STp->buffer)->syscall_result;
 			break;
+		}
 
 		if (cmdstatp->have_sense) {
 
@@ -985,8 +955,8 @@ static int test_ready(struct scsi_tape *
 		break;
 	}
 
-	st_release_request(SRpnt);
-
+	if (SRpnt != NULL)
+		st_release_request(SRpnt);
 	return retval;
 }
 
@@ -1063,24 +1033,17 @@ static int check_tape(struct scsi_tape *
 		}
 	}
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt) {
-		retval = STp->buffer->syscall_result;
-		goto err_out;
-	}
-
 	if (STp->omit_blklims)
 		STp->min_block = STp->max_block = (-1);
 	else {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = READ_BLOCK_LIMITS;
 
-		retval = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
-					      STp->buffer->b_data, 6,
-					      STp->device->request_queue->rq_timeout,
-					      MAX_READY_RETRIES);
-		if (retval) {
-			st_release_request(SRpnt);
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
+				   STp->device->request_queue->rq_timeout,
+				   MAX_READY_RETRIES, 1);
+		if (!SRpnt) {
+			retval = (STp->buffer)->syscall_result;
 			goto err_out;
 		}
 
@@ -1104,12 +1067,11 @@ static int check_tape(struct scsi_tape *
 	cmd[0] = MODE_SENSE;
 	cmd[4] = 12;
 
-	retval = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
-				      STp->buffer->b_data, 12,
-				      STp->device->request_queue->rq_timeout,
-				      MAX_READY_RETRIES);
-	if (retval) {
-		st_release_request(SRpnt);
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
+			   STp->device->request_queue->rq_timeout,
+			   MAX_READY_RETRIES, 1);
+	if (!SRpnt) {
+		retval = (STp->buffer)->syscall_result;
 		goto err_out;
 	}
 
@@ -1339,17 +1301,11 @@ static int st_flush(struct file *filp, f
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[4] = 1 + STp->two_fm;
 
-		SRpnt = st_allocate_request(STp);
+		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+				   STp->device->request_queue->rq_timeout,
+				   MAX_WRITE_RETRIES, 1);
 		if (!SRpnt) {
-			result = STp->buffer->syscall_result;
-			goto out;
-		}
-
-		result = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
-					      STp->device->request_queue->rq_timeout,
-					      MAX_WRITE_RETRIES);
-		if (result) {
-			st_release_request(SRpnt);
+			result = (STp->buffer)->syscall_result;
 			goto out;
 		}
 
@@ -2414,7 +2370,6 @@ static int read_mode_page(struct scsi_ta
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
-	int ret;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2423,17 +2378,14 @@ static int read_mode_page(struct scsi_ta
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt)
-		return STp->buffer->syscall_result;
+	SRpnt = st_do_scsi(NULL, STp, cmd, cmd[4], DMA_FROM_DEVICE,
+			   STp->device->request_queue->rq_timeout, 0, 1);
+	if (SRpnt == NULL)
+		return (STp->buffer)->syscall_result;
 
-	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
-				   STp->buffer->b_data, cmd[4],
-				   STp->device->request_queue->rq_timeout,
-				   MAX_RETRIES);
 	st_release_request(SRpnt);
 
-	return ret ? : STp->buffer->syscall_result;
+	return STp->buffer->syscall_result;
 }
 
 
@@ -2441,7 +2393,7 @@ static int read_mode_page(struct scsi_ta
    in the buffer is correctly formatted. The long timeout is used if slow is non-zero. */
 static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 {
-	int pgo, timeout, ret = 0;
+	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
 
@@ -2457,21 +2409,15 @@ static int write_mode_page(struct scsi_t
 	(STp->buffer)->b_data[MH_OFF_DEV_SPECIFIC] &= ~MH_BIT_WP;
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt)
-		return ret;
-
-	timeout = slow ? STp->long_timeout :
-		STp->device->request_queue->rq_timeout;
-
-	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_TO_DEVICE,
-				   STp->buffer->b_data, cmd[4], timeout, 0);
-	if (!ret)
-		ret = STp->buffer->syscall_result;
+	SRpnt = st_do_scsi(NULL, STp, cmd, cmd[4], DMA_TO_DEVICE,
+			   (slow ? STp->long_timeout : STp->device->request_queue->rq_timeout),
+			   0, 1);
+	if (SRpnt == NULL)
+		return (STp->buffer)->syscall_result;
 
 	st_release_request(SRpnt);
 
-	return ret;
+	return STp->buffer->syscall_result;
 }
 
 
@@ -2589,16 +2535,13 @@ static int do_load_unload(struct scsi_ta
 		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
 		);
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			   timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	retval = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0, timeout,
-				      MAX_RETRIES);
-	if (retval)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
 	retval = (STp->buffer)->syscall_result;
+	st_release_request(SRpnt);
 
 	if (!retval) {	/* SCSI command successful */
 
@@ -2617,8 +2560,6 @@ static int do_load_unload(struct scsi_ta
 		STps = &(STp->ps[STp->partition]);
 		STps->drv_file = STps->drv_block = (-1);
 	}
-out:
-	st_release_request(SRpnt);
 
 	return retval;
 }
@@ -2894,15 +2835,12 @@ static int st_int_ioctl(struct scsi_tape
 		return (-ENOSYS);
 	}
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
+			   timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
-	ioctl_result = st_scsi_kern_execute(SRpnt, cmd, direction,
-					    STp->buffer->b_data, datalen,
-					    timeout, MAX_RETRIES);
-	if (!ioctl_result)
-		ioctl_result = (STp->buffer)->syscall_result;
+	ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
 		st_release_request(SRpnt);
@@ -3064,17 +3002,11 @@ static int get_location(struct scsi_tape
 		if (!logical && !STp->scsi2_logical)
 			scmd[1] = 1;
 	}
-
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
+			   STp->device->request_queue->rq_timeout,
+			   MAX_READY_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	result = st_scsi_kern_execute(SRpnt, scmd, DMA_FROM_DEVICE,
-				      STp->buffer->b_data, 20,
-				      STp->device->request_queue->rq_timeout,
-				      MAX_READY_RETRIES);
-	if (result)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
 	if ((STp->buffer)->syscall_result != 0 ||
 	    (STp->device->scsi_level >= SCSI_2 &&
@@ -3102,7 +3034,6 @@ static int get_location(struct scsi_tape
                 DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
                             *block, *partition));
 	}
-out:
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
@@ -3177,14 +3108,10 @@ static int set_location(struct scsi_tape
 		timeout = STp->device->request_queue->rq_timeout;
 	}
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
+			   timeout, MAX_READY_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	result = st_scsi_kern_execute(SRpnt, scmd, DMA_NONE, NULL, 0,
-				      timeout, MAX_READY_RETRIES);
-	if (result)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
 	STps->drv_block = STps->drv_file = (-1);
 	STps->eof = ST_NOEOF;
@@ -3209,7 +3136,7 @@ static int set_location(struct scsi_tape
 			STps->drv_block = STps->drv_file = 0;
 		result = 0;
 	}
-out:
+
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
