From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH, RFC] st: start using scsi_execute
Date: Sat, 4 Feb 2006 12:41:17 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0602041231410.11033@kai.makisara.local>
References: <20060130182324.GA6253@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:59825 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751241AbWBDKi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 05:38:58 -0500
In-Reply-To: <20060130182324.GA6253@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 30 Jan 2006, Christoph Hellwig wrote:

> This patch updates st to use scsi_execute instead of scsi_execute_async
> for all scsi commands except the main I/O path.  The advantage is that
> these helpers do all the request tracking for these synchronous I/Os so
> that there is no need for st_request structures.  It also decouples
> these helper scsi commands from the main tape buffer, allowing for an
> easier switchover to the generic block request mapping routines for the
> main I/O path later on.
> 
> Note that I don't have a scsi tape, so this is totally untested and
> probably needs some tweaking before it's ready..
> 
I did some small changes. The patch at the end passes my light standard 
tests but it has not been completely tested.

> 
> Index: scsi-misc-2.6/drivers/scsi/st.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/st.c	2006-01-30 19:14:34.000000000 +0100
> +++ scsi-misc-2.6/drivers/scsi/st.c	2006-01-30 19:14:39.000000000 +0100
...
> +static int
> +st_scsi_execute(struct scsi_tape *st, u8 *cmd, int direction, void *buffer,
> +		unsigned int buflen, int timeout, int retries)
> +{
> +	char *sense;
> +
> +	sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
> +	if (!sense) {
> +		/*
> +		 * Slightly odd errno values for memory allocation failure.
> +		 * But for now we follow the scheme introduced by st_do_scsi
> +		 * long ago.
> +		 */
> +		st->buffer->syscall_result =
> +			signal_pending(current) ? -EINTR : -EBUSY;
> +		return 0;
> +	}
> +
> +	st->buffer->cmdstat.have_sense = 0;
> +	st->buffer->cmdstat.midlevel_result =
> +		scsi_execute(st->device, cmd, direction, NULL, 0,
                                                         ^^^^^^^^
The new st_scsi_execute did not pass any buffer to scsi_execute. This 
caused some problems ;-)

I also removed the call to enlarge_buffer() from st_open(). It is not 
needed when everything except read and write use separate buffers.

I don't advocate inclusion of this patch before seeing real code switching 
st to use the generic block mapping routines. This is nice cleanup but it 
does not solve any problem now. On the contrary, it switches st to use two 
different methods to handle SCSI requests instead of only one.

Kai

--- linux-2.6.16-rc1-git4-k1/drivers/scsi/st.c	2006-02-01 19:40:52.000000000 +0200
+++ linux-2.6.16-rc1-git4-k2/drivers/scsi/st.c	2006-02-04 12:23:41.000000000 +0200
@@ -308,12 +308,11 @@ static inline char *tape_name(struct scs
 }
 
 
-static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
+static void st_analyze_sense(const u8 *sense, struct st_cmdstatus *s)
 {
 	const u8 *ucp;
-	const u8 *sense = SRpnt->sense;
 
-	s->have_sense = scsi_normalize_sense(SRpnt->sense,
+	s->have_sense = scsi_normalize_sense(sense,
 				SCSI_SENSE_BUFFERSIZE, &s->sense_hdr);
 	s->flags = 0;
 
@@ -341,9 +340,8 @@ static void st_analyze_sense(struct st_r
 
 
 /* Convert the result to success code */
-static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
+static int st_chk_result(struct scsi_tape *STp, u8 *cmd, u8 *sense, int result)
 {
-	int result = SRpnt->result;
 	u8 scode;
 	DEB(const char *stp;)
 	char *name = tape_name(STp);
@@ -353,7 +351,7 @@ static int st_chk_result(struct scsi_tap
 		return 0;
 
 	cmdstatp = &STp->buffer->cmdstat;
-	st_analyze_sense(SRpnt, cmdstatp);
+	st_analyze_sense(sense, cmdstatp);
 
 	if (cmdstatp->have_sense)
 		scode = STp->buffer->cmdstat.sense_hdr.sense_key;
@@ -364,10 +362,9 @@ static int st_chk_result(struct scsi_tap
         if (debugging) {
                 printk(ST_DEB_MSG "%s: Error: %x, cmd: %x %x %x %x %x %x\n",
 		       name, result,
-		       SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
-		       SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
+		       cmd[0], cmd[1], cmd[2], cmd[3], cmd[4], cmd[5]);
 		if (cmdstatp->have_sense)
-			 __scsi_print_sense("st", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			 __scsi_print_sense("st", sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
@@ -381,10 +378,10 @@ static int st_chk_result(struct scsi_tap
 			 /* scode != UNIT_ATTENTION && */
 			 scode != BLANK_CHECK &&
 			 scode != VOLUME_OVERFLOW &&
-			 SRpnt->cmd[0] != MODE_SENSE &&
-			 SRpnt->cmd[0] != TEST_UNIT_READY) {
+			 cmd[0] != MODE_SENSE &&
+			 cmd[0] != TEST_UNIT_READY) {
 				printk(KERN_WARNING "%s: Error with sense data: ", name);
-				__scsi_print_sense("st", SRpnt->sense,
+				__scsi_print_sense("st", sense,
 						   SCSI_SENSE_BUFFERSIZE);
 		}
 	}
@@ -392,10 +389,10 @@ static int st_chk_result(struct scsi_tap
 	if (cmdstatp->fixed_format &&
 	    STp->cln_mode >= EXTENDED_SENSE_START) {  /* Only fixed format sense */
 		if (STp->cln_sense_value)
-			STp->cleaning_req |= ((SRpnt->sense[STp->cln_mode] &
+			STp->cleaning_req |= ((sense[STp->cln_mode] &
 					       STp->cln_sense_mask) == STp->cln_sense_value);
 		else
-			STp->cleaning_req |= ((SRpnt->sense[STp->cln_mode] &
+			STp->cleaning_req |= ((sense[STp->cln_mode] &
 					       STp->cln_sense_mask) != 0);
 	}
 	if (cmdstatp->have_sense &&
@@ -407,8 +404,8 @@ static int st_chk_result(struct scsi_tap
 	if (cmdstatp->have_sense &&
 	    scode == RECOVERED_ERROR
 #if ST_RECOVERED_WRITE_FATAL
-	    && SRpnt->cmd[0] != WRITE_6
-	    && SRpnt->cmd[0] != WRITE_FILEMARKS
+	    && cmd[0] != WRITE_6
+	    && cmd[0] != WRITE_FILEMARKS
 #endif
 	    ) {
 		STp->recover_count++;
@@ -416,9 +413,9 @@ static int st_chk_result(struct scsi_tap
 
                 DEB(
 		if (debugging) {
-			if (SRpnt->cmd[0] == READ_6)
+			if (cmd[0] == READ_6)
 				stp = "read";
-			else if (SRpnt->cmd[0] == WRITE_6)
+			else if (cmd[0] == WRITE_6)
 				stp = "write";
 			else
 				stp = "ioctl";
@@ -457,6 +454,7 @@ static void st_release_request(struct st
 	kfree(streq);
 }
 
+
 /* Do the scsi command. Waits until command performed if do_wait is true.
    Otherwise write_behind_check() is used to check that the command
    has finished. */
@@ -508,7 +506,7 @@ st_do_scsi(struct st_request * SRpnt, st
 	STp->buffer->syscall_result = 0;
 
 	if (scsi_execute_async(STp->device, cmd, direction,
-			&((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
+			       &((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
 			       timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL)) {
 		/* could not allocate the buffer or request was too large */
 		(STp->buffer)->syscall_result = (-EBUSY);
@@ -517,13 +515,51 @@ st_do_scsi(struct st_request * SRpnt, st
 	else if (do_wait) {
 		wait_for_completion(waiting);
 		SRpnt->waiting = NULL;
-		(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
+		(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt->cmd,
+							      SRpnt->sense,
+							      SRpnt->result);
 	}
 
 	return SRpnt;
 }
 
 
+static int
+st_scsi_execute(struct scsi_tape *st, u8 *cmd, int direction, void *buffer,
+		unsigned int buflen, int timeout, int retries)
+{
+	char *sense;
+
+	sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+	if (!sense) {
+		/*
+		 * Slightly odd errno values for memory allocation failure.
+		 * But for now we follow the scheme introduced by st_do_scsi
+		 * long ago.
+		 */
+		st->buffer->syscall_result =
+			signal_pending(current) ? -EINTR : -EBUSY;
+		return 0;
+	}
+
+	st->buffer->cmdstat.have_sense = 0;
+	st->buffer->cmdstat.midlevel_result =
+		scsi_execute(st->device, cmd, direction, buffer, buflen,
+				sense, timeout, retries, 0);
+
+	DEB(st->write_pending = 0;)
+
+	if (st->buffer->cmdstat.midlevel_result != (DRIVER_ERROR << 24)) {
+		st->buffer->syscall_result =
+			st_chk_result(st, cmd, sense, st->buffer->cmdstat.midlevel_result);
+	} else
+		st->buffer->syscall_result = -EBUSY;
+
+	kfree(sense);
+	return 1;
+}
+
+
 /* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
    write has been correct but EOM early warning reached, -EIO if write ended in
    error or zero if write successful. Asynchronous writes are used only in
@@ -552,7 +588,9 @@ static int write_behind_check(struct scs
 	STbuffer->last_SRpnt = NULL;
 	SRpnt->waiting = NULL;
 
-	(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
+	(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt->cmd,
+						      SRpnt->sense,
+						      SRpnt->result);
 	st_release_request(SRpnt);
 
 	STbuffer->buffer_bytes -= STbuffer->writing;
@@ -593,7 +631,6 @@ static int write_behind_check(struct scs
    it messes up the block number). */
 static int cross_eof(struct scsi_tape * STp, int forward)
 {
-	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 
 	cmd[0] = SPACE;
@@ -608,13 +645,10 @@ static int cross_eof(struct scsi_tape * 
         DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
 		   tape_name(STp), forward ? "forward" : "backward"));
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   STp->device->timeout, MAX_RETRIES, 1);
-	if (!SRpnt)
+	if (!st_scsi_execute(STp, cmd, DMA_NONE, NULL, 0,
+			   STp->device->timeout, MAX_RETRIES))
 		return (STp->buffer)->syscall_result;
 
-	st_release_request(SRpnt);
-	SRpnt = NULL;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
 		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
@@ -646,7 +680,8 @@ static int flush_write_buffer(struct scs
                 DEBC(printk(ST_DEB_MSG "%s: Flushing %d bytes.\n",
                                tape_name(STp), transfer));
 
-		memset((STp->buffer)->b_data + offset, 0, transfer - offset);
+		memset(page_address(STp->buffer->frp[0].page) + offset,
+				0, transfer - offset);
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_6;
@@ -723,8 +758,8 @@ static int flush_buffer(struct scsi_tape
 
 	backspace = ((STp->buffer)->buffer_bytes +
 		     (STp->buffer)->read_pointer) / STp->block_size -
-	    ((STp->buffer)->read_pointer + STp->block_size - 1) /
-	    STp->block_size;
+		((STp->buffer)->read_pointer + STp->block_size - 1) /
+		STp->block_size;
 	(STp->buffer)->buffer_bytes = 0;
 	(STp->buffer)->read_pointer = 0;
 	result = 0;
@@ -844,7 +879,6 @@ static int test_ready(struct scsi_tape *
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
@@ -852,10 +886,8 @@ static int test_ready(struct scsi_tape *
 	for (attentions=waits=0; ; ) {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-				   STp->long_timeout, MAX_READY_RETRIES, 1);
-
-		if (!SRpnt) {
+		if (!st_scsi_execute(STp, cmd, DMA_NONE, NULL, 0,
+				   STp->long_timeout, MAX_READY_RETRIES)) {
 			retval = (STp->buffer)->syscall_result;
 			break;
 		}
@@ -902,12 +934,104 @@ static int test_ready(struct scsi_tape *
 		break;
 	}
 
-	if (SRpnt != NULL)
-		st_release_request(SRpnt);
 	return retval;
 }
 
 
+static int
+st_get_block_limits(struct scsi_tape *st)
+{
+	u8 cmd[MAX_COMMAND_SIZE];
+	u8 *buf;
+
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = READ_BLOCK_LIMITS;
+
+	buf = kmalloc(6, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (!st_scsi_execute(st, cmd, DMA_FROM_DEVICE, buf, 6,
+			     st->device->timeout, MAX_READY_RETRIES))
+		goto fail;
+
+	if (!st->buffer->cmdstat.midlevel_result &&
+	    !st->buffer->cmdstat.have_sense) {
+		st->max_block = (buf[1] << 16) | (buf[2] << 8) | buf[3];
+		st->min_block = (buf[4] << 8) | buf[5];
+		if (DEB(debugging ||) !st->inited) {
+			printk(KERN_WARNING "%s: Block limits %d - %d bytes.\n",
+			       tape_name(st), st->min_block, st->max_block);
+		}
+	} else {
+		st->min_block = st->max_block = -1;
+		DEBC(printk(ST_DEB_MSG "%s: Can't read block limits.\n",
+			    tape_name(st)));
+	}
+
+	kfree(buf);
+	return 0;
+ fail:
+	kfree(buf);
+	return st->buffer->syscall_result;
+}
+
+
+static int
+st_get_mode_sense(struct scsi_tape *st)
+{
+	u8 cmd[MAX_COMMAND_SIZE];
+	u8 *buf;
+
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = MODE_SENSE;
+	cmd[4] = 12;
+
+	buf = kmalloc(12, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (!st_scsi_execute(st, cmd, DMA_FROM_DEVICE, buf, 12,
+			     st->device->timeout, MAX_READY_RETRIES))
+		goto fail;
+
+	if (st->buffer->syscall_result) {
+		DEBC(printk(ST_DEB_MSG "%s: No Mode Sense.\n", tape_name(st)));
+		st->block_size = ST_DEFAULT_BLOCK;	/* Educated guess (?) */
+		st->buffer->syscall_result = 0;	 /* Prevent error propagation */
+		st->drv_write_prot = 0;
+		goto out;
+	}
+
+	DEBC(printk(ST_DEB_MSG
+		    "%s: Mode sense. Length %d, medium %x, WBS %x, BLL %d\n",
+		    tape_name(st), buf[0], buf[1], buf[2], buf[3]));
+
+	if (buf[3] >= 8) {
+		st->drv_buffer = (buf[2] >> 4) & 7;
+		st->density = buf[4];
+		st->block_size = buf[9] * 65536 +
+				 buf[10] * 256 +
+				 buf[11];
+
+		DEBC(printk(ST_DEB_MSG
+			    "%s: Density %x, tape length: %x, drv buffer: %d\n",
+			    tape_name(st), st->density, buf[5] * 65536 +
+			    buf[6] * 256 + buf[7], st->drv_buffer));
+	}
+
+	st->drv_write_prot = (buf[2] & 0x80) != 0;
+
+ out:
+	kfree(buf);
+	return 0;
+
+ fail:
+	kfree(buf);
+	return st->buffer->syscall_result;
+}
+
+
 /* See if the drive is ready and gather information about the tape. Return values:
    < 0   negative error code from errno.h
    0     drive ready
@@ -916,9 +1040,8 @@ static int test_ready(struct scsi_tape *
 static int check_tape(struct scsi_tape *STp, struct file *filp)
 {
 	int i, retval, new_session = 0, do_wait;
-	unsigned char cmd[MAX_COMMAND_SIZE], saved_cleaning;
+	unsigned char saved_cleaning;
 	unsigned short st_flags = filp->f_flags;
-	struct st_request *SRpnt = NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	char *name = tape_name(STp);
@@ -980,73 +1103,17 @@ static int check_tape(struct scsi_tape *
 		}
 	}
 
-	if (STp->omit_blklims)
-		STp->min_block = STp->max_block = (-1);
-	else {
-		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
-		cmd[0] = READ_BLOCK_LIMITS;
-
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
-				   STp->device->timeout, MAX_READY_RETRIES, 1);
-		if (!SRpnt) {
-			retval = (STp->buffer)->syscall_result;
+	if (!STp->omit_blklims) {
+		retval = st_get_block_limits(STp);
+		if (retval)
 			goto err_out;
-		}
-
-		if (!SRpnt->result && !STp->buffer->cmdstat.have_sense) {
-			STp->max_block = ((STp->buffer)->b_data[1] << 16) |
-			    ((STp->buffer)->b_data[2] << 8) | (STp->buffer)->b_data[3];
-			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
-			    (STp->buffer)->b_data[5];
-			if ( DEB( debugging || ) !STp->inited)
-				printk(KERN_WARNING
-                                       "%s: Block limits %d - %d bytes.\n", name,
-                                       STp->min_block, STp->max_block);
-		} else {
-			STp->min_block = STp->max_block = (-1);
-                        DEBC(printk(ST_DEB_MSG "%s: Can't read block limits.\n",
-                                       name));
-		}
-	}
-
-	memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
-	cmd[0] = MODE_SENSE;
-	cmd[4] = 12;
+	} else
+		STp->min_block = STp->max_block = -1;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
-	if (!SRpnt) {
-		retval = (STp->buffer)->syscall_result;
+	retval = st_get_mode_sense(STp);
+	if (retval)
 		goto err_out;
-	}
 
-	if ((STp->buffer)->syscall_result != 0) {
-                DEBC(printk(ST_DEB_MSG "%s: No Mode Sense.\n", name));
-		STp->block_size = ST_DEFAULT_BLOCK;	/* Educated guess (?) */
-		(STp->buffer)->syscall_result = 0;	/* Prevent error propagation */
-		STp->drv_write_prot = 0;
-	} else {
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Mode sense. Length %d, medium %x, WBS %x, BLL %d\n",
-                            name,
-                            (STp->buffer)->b_data[0], (STp->buffer)->b_data[1],
-                            (STp->buffer)->b_data[2], (STp->buffer)->b_data[3]));
-
-		if ((STp->buffer)->b_data[3] >= 8) {
-			STp->drv_buffer = ((STp->buffer)->b_data[2] >> 4) & 7;
-			STp->density = (STp->buffer)->b_data[4];
-			STp->block_size = (STp->buffer)->b_data[9] * 65536 +
-			    (STp->buffer)->b_data[10] * 256 + (STp->buffer)->b_data[11];
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Density %x, tape length: %x, drv buffer: %d\n",
-                                    name, STp->density, (STp->buffer)->b_data[5] * 65536 +
-                                    (STp->buffer)->b_data[6] * 256 + (STp->buffer)->b_data[7],
-                                    STp->drv_buffer));
-		}
-		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
-	}
-	st_release_request(SRpnt);
-	SRpnt = NULL;
         STp->inited = 1;
 
 	if (STp->block_size > 0)
@@ -1150,14 +1217,6 @@ static int st_open(struct inode *inode, 
 		goto err_out;
 	}
 
-	/* See that we have at least a one page buffer available */
-	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
-		printk(KERN_WARNING "%s: Can't allocate one page tape buffer.\n",
-		       name);
-		retval = (-EOVERFLOW);
-		goto err_out;
-	}
-
 	(STp->buffer)->writing = 0;
 	(STp->buffer)->syscall_result = 0;
 
@@ -1196,7 +1255,6 @@ static int st_flush(struct file *filp)
 {
 	int result = 0, result2;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm = &(STp->modes[STp->current_mode]);
 	struct st_partstat *STps = &(STp->ps[STp->partition]);
@@ -1235,9 +1293,8 @@ static int st_flush(struct file *filp)
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[4] = 1 + STp->two_fm;
 
-		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
-		if (!SRpnt) {
+		if (!st_scsi_execute(STp, cmd, DMA_NONE, NULL, 0,
+				   STp->device->timeout, MAX_WRITE_RETRIES)) {
 			result = (STp->buffer)->syscall_result;
 			goto out;
 		}
@@ -1249,8 +1306,6 @@ static int st_flush(struct file *filp)
 		      cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
 		     (!cmdstatp->remainder_valid || cmdstatp->uremainder64 == 0))) {
 			/* Write successful at EOM */
-			st_release_request(SRpnt);
-			SRpnt = NULL;
 			if (STps->drv_file >= 0)
 				STps->drv_file++;
 			STps->drv_block = 0;
@@ -1259,8 +1314,6 @@ static int st_flush(struct file *filp)
 			STps->eof = ST_FM;
 		}
 		else { /* Write error */
-			st_release_request(SRpnt);
-			SRpnt = NULL;
 			printk(KERN_ERR "%s: Error on write filemark.\n", name);
 			if (result == 0)
 				result = (-EIO);
@@ -2282,10 +2335,10 @@ static int st_set_options(struct scsi_ta
 /* Read a mode page into the tape buffer. The block descriptors are included
    if incl_block_descs is true. The page control is ored to the page number
    parameter, if necessary. */
-static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
+static int read_mode_page(struct scsi_tape *STp, u8 *buf, int page,
+		int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2294,44 +2347,33 @@ static int read_mode_page(struct scsi_ta
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
-	if (SRpnt == NULL)
-		return (STp->buffer)->syscall_result;
-
-	st_release_request(SRpnt);
-
+	st_scsi_execute(STp, cmd, DMA_FROM_DEVICE, buf, cmd[4],
+				STp->device->timeout, 0);
 	return (STp->buffer)->syscall_result;
 }
 
 
 /* Send the mode page in the tape buffer to the drive. Assumes that the mode data
    in the buffer is correctly formatted. The long timeout is used if slow is non-zero. */
-static int write_mode_page(struct scsi_tape *STp, int page, int slow)
+static int write_mode_page(struct scsi_tape *STp, u8 *buf, int page, int slow)
 {
 	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
+	int timeout = (slow ? STp->long_timeout : STp->device->timeout);
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
 	cmd[1] = MODE_SELECT_PAGE_FORMAT;
-	pgo = MODE_HEADER_LENGTH + (STp->buffer)->b_data[MH_OFF_BDESCS_LENGTH];
-	cmd[4] = pgo + (STp->buffer)->b_data[pgo + MP_OFF_PAGE_LENGTH] + 2;
+	pgo = MODE_HEADER_LENGTH + buf[MH_OFF_BDESCS_LENGTH];
+	cmd[4] = pgo + buf[pgo + MP_OFF_PAGE_LENGTH] + 2;
 
 	/* Clear reserved fields */
-	(STp->buffer)->b_data[MH_OFF_DATA_LENGTH] = 0;
-	(STp->buffer)->b_data[MH_OFF_MEDIUM_TYPE] = 0;
-	(STp->buffer)->b_data[MH_OFF_DEV_SPECIFIC] &= ~MH_BIT_WP;
-	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
-
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
-			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1);
-	if (SRpnt == NULL)
-		return (STp->buffer)->syscall_result;
-
-	st_release_request(SRpnt);
+	buf[MH_OFF_DATA_LENGTH] = 0;
+	buf[MH_OFF_MEDIUM_TYPE] = 0;
+	buf[MH_OFF_DEV_SPECIFIC] &= ~MH_BIT_WP;
+	buf[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
+	st_scsi_execute(STp, cmd, DMA_TO_DEVICE, buf, cmd[4], timeout, 0);
 	return (STp->buffer)->syscall_result;
 }
 
@@ -2357,14 +2399,19 @@ static int st_compression(struct scsi_ta
 {
 	int retval;
 	int mpoffs;  /* Offset to mode page start */
-	unsigned char *b_data = (STp->buffer)->b_data;
+	unsigned char *b_data;
+	int rval = EIO;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
 		return (-EIO);
 
+	b_data = (u8 *)get_zeroed_page(GFP_KERNEL);
+	if (!b_data)
+		return -ENOMEM;
+
 	/* Read the current page contents */
-	retval = read_mode_page(STp, COMPRESSION_PAGE, 0);
+	retval = read_mode_page(STp, b_data, COMPRESSION_PAGE, 0);
 	if (retval) {
                 DEBC(printk(ST_DEB_MSG "%s: Compression mode page not supported.\n",
                             name));
@@ -2378,7 +2425,7 @@ static int st_compression(struct scsi_ta
 	/* Check if compression can be changed */
 	if ((b_data[mpoffs + CP_OFF_DCE_DCC] & DCC_MASK) == 0) {
                 DEBC(printk(ST_DEB_MSG "%s: Compression not supported.\n", name));
-		return (-EIO);
+		goto out;
 	}
 
 	/* Do the change */
@@ -2393,16 +2440,20 @@ static int st_compression(struct scsi_ta
 			b_data[mpoffs + CP_OFF_C_ALGO] = 0; /* no compression */
 	}
 
-	retval = write_mode_page(STp, COMPRESSION_PAGE, 0);
+	retval = write_mode_page(STp, b_data, COMPRESSION_PAGE, 0);
 	if (retval) {
                 DEBC(printk(ST_DEB_MSG "%s: Compression change failed.\n", name));
-		return (-EIO);
+		goto out;
 	}
         DEBC(printk(ST_DEB_MSG "%s: Compression state changed to %d.\n",
 		       name, state));
 
 	STp->compression_changed = 1;
-	return 0;
+
+	rval = 0;
+ out:
+	free_page((unsigned long)b_data);
+	return rval;
 }
 
 
@@ -2413,7 +2464,6 @@ static int do_load_unload(struct scsi_ta
 	DEB( char *name = tape_name(STp); )
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_partstat *STps;
-	struct st_request *SRpnt;
 
 	if (STp->ready != ST_READY && !load_code) {
 		if (STp->ready == ST_NO_TAPE)
@@ -2450,13 +2500,10 @@ static int do_load_unload(struct scsi_ta
 		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
 		);
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   timeout, MAX_RETRIES, 1);
-	if (!SRpnt)
+	if (!st_scsi_execute(STp, cmd, DMA_NONE, NULL, 0, timeout, MAX_RETRIES))
 		return (STp->buffer)->syscall_result;
 
 	retval = (STp->buffer)->syscall_result;
-	st_release_request(SRpnt);
 
 	if (!retval) {	/* SCSI command successful */
 
@@ -2504,11 +2551,11 @@ static int st_int_ioctl(struct scsi_tape
 	int ioctl_result;
 	int chg_eof = 1;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt;
 	struct st_partstat *STps;
 	int fileno, blkno, at_sm, undone;
 	int datalen = 0, direction = DMA_NONE;
 	char *name = tape_name(STp);
+	u8 *buf = NULL;
 
 	WARN_ON(STp->buffer->do_dio != 0);
 	if (STp->ready != ST_READY) {
@@ -2705,61 +2752,64 @@ static int st_int_ioctl(struct scsi_tape
 		cmd[4] = datalen = 12;
 		direction = DMA_TO_DEVICE;
 
-		memset((STp->buffer)->b_data, 0, 12);
+		buf = kzalloc(datalen, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
 		if (cmd_in == MTSETDRVBUFFER)
-			(STp->buffer)->b_data[2] = (arg & 7) << 4;
+			buf[2] = (arg & 7) << 4;
 		else
-			(STp->buffer)->b_data[2] =
-			    STp->drv_buffer << 4;
-		(STp->buffer)->b_data[3] = 8;	/* block descriptor length */
+			buf[2] = STp->drv_buffer << 4;
+		buf[3] = 8;	/* block descriptor length */
 		if (cmd_in == MTSETDENSITY) {
-			(STp->buffer)->b_data[4] = arg;
+			buf[4] = arg;
 			STp->density_changed = 1;	/* At least we tried ;-) */
-		} else if (cmd_in == SET_DENS_AND_BLK)
-			(STp->buffer)->b_data[4] = arg >> 24;
-		else
-			(STp->buffer)->b_data[4] = STp->density;
+		} else if (cmd_in == SET_DENS_AND_BLK) {
+			buf[4] = arg >> 24;
+		} else {
+			buf[4] = STp->density;
+		}
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
 			ltmp = arg & MT_ST_BLKSIZE_MASK;
 			if (cmd_in == MTSETBLK)
 				STp->blksize_changed = 1; /* At least we tried ;-) */
 		} else
 			ltmp = STp->block_size;
-		(STp->buffer)->b_data[9] = (ltmp >> 16);
-		(STp->buffer)->b_data[10] = (ltmp >> 8);
-		(STp->buffer)->b_data[11] = ltmp;
+		buf[9] = (ltmp >> 16);
+		buf[10] = (ltmp >> 8);
+		buf[11] = ltmp;
 		timeout = STp->device->timeout;
                 DEBC(
 			if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK)
 				printk(ST_DEB_MSG
                                        "%s: Setting block size to %d bytes.\n", name,
-				       (STp->buffer)->b_data[9] * 65536 +
-				       (STp->buffer)->b_data[10] * 256 +
-				       (STp->buffer)->b_data[11]);
+				       buf[9] * 65536 +
+				       buf[10] * 256 +
+				       buf[11]);
 			if (cmd_in == MTSETDENSITY || cmd_in == SET_DENS_AND_BLK)
 				printk(ST_DEB_MSG
                                        "%s: Setting density code to %x.\n", name,
-				       (STp->buffer)->b_data[4]);
+				       buf[4]);
 			if (cmd_in == MTSETDRVBUFFER)
 				printk(ST_DEB_MSG
                                        "%s: Setting drive buffer code to %d.\n", name,
-				    ((STp->buffer)->b_data[2] >> 4) & 7);
+				    (buf[2] >> 4) & 7);
 		)
 		break;
 	default:
 		return (-ENOSYS);
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
-	if (!SRpnt)
+	if (!st_scsi_execute(STp, cmd, direction, buf, datalen,
+				timeout, MAX_RETRIES)) {
+		kfree(buf);
 		return (STp->buffer)->syscall_result;
+	}
 
-	ioctl_result = (STp->buffer)->syscall_result;
+	kfree(buf);
 
+	ioctl_result = (STp->buffer)->syscall_result;
 	if (!ioctl_result) {	/* SCSI command successful */
-		st_release_request(SRpnt);
-		SRpnt = NULL;
 		STps->drv_block = blkno;
 		STps->drv_file = fileno;
 		STps->at_sm = at_sm;
@@ -2873,8 +2923,6 @@ static int st_int_ioctl(struct scsi_tape
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = !STp->use_pf | PF_TESTED;
-				st_release_request(SRpnt);
-				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
 			}
 		} else if (chg_eof)
@@ -2882,9 +2930,6 @@ static int st_int_ioctl(struct scsi_tape
 
 		if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
 			STps->eof = ST_EOD;
-
-		st_release_request(SRpnt);
-		SRpnt = NULL;
 	}
 
 	return ioctl_result;
@@ -2897,9 +2942,8 @@ static int st_int_ioctl(struct scsi_tape
 static int get_location(struct scsi_tape *STp, unsigned int *block, int *partition,
 			int logical)
 {
-	int result;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt;
+	u8 *buf;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -2914,41 +2958,45 @@ static int get_location(struct scsi_tape
 		if (!logical && !STp->scsi2_logical)
 			scmd[1] = 1;
 	}
-	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
-	if (!SRpnt)
-		return (STp->buffer)->syscall_result;
 
-	if ((STp->buffer)->syscall_result != 0 ||
-	    (STp->device->scsi_level >= SCSI_2 &&
-	     ((STp->buffer)->b_data[0] & 4) != 0)) {
+	buf = kmalloc(20, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (!st_scsi_execute(STp, scmd, DMA_FROM_DEVICE, buf, 20,
+				STp->device->timeout, MAX_READY_RETRIES)) {
+		kfree(buf);
+		return STp->buffer->syscall_result;
+	}
+
+	if (STp->buffer->syscall_result != 0 ||
+	    (STp->device->scsi_level >= SCSI_2 && (buf[0] & 4) != 0)) {
 		*block = *partition = 0;
-                DEBC(printk(ST_DEB_MSG "%s: Can't read tape position.\n", name));
-		result = (-EIO);
+                DEBC(printk(ST_DEB_MSG "%s: Can't read tape position.\n",
+			    name));
+		kfree(buf);
+		return -EIO;
+	}
+
+	if (STp->device->scsi_level < SCSI_2) {
+		*block = (buf[0] << 16) +
+			 (buf[1] << 8) +
+			  buf[2];
+		*partition = 0;
 	} else {
-		result = 0;
-		if ((STp->device)->scsi_level < SCSI_2) {
-			*block = ((STp->buffer)->b_data[0] << 16)
-			    + ((STp->buffer)->b_data[1] << 8)
-			    + (STp->buffer)->b_data[2];
-			*partition = 0;
-		} else {
-			*block = ((STp->buffer)->b_data[4] << 24)
-			    + ((STp->buffer)->b_data[5] << 16)
-			    + ((STp->buffer)->b_data[6] << 8)
-			    + (STp->buffer)->b_data[7];
-			*partition = (STp->buffer)->b_data[1];
-			if (((STp->buffer)->b_data[0] & 0x80) &&
-			    (STp->buffer)->b_data[1] == 0)	/* BOP of partition 0 */
-				STp->ps[0].drv_block = STp->ps[0].drv_file = 0;
-		}
-                DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
-                            *block, *partition));
+		*block = (buf[4] << 24) +
+			 (buf[5] << 16) +
+			 (buf[6] << 8) +
+			  buf[7];
+		*partition = buf[1];
+		if ((buf[0] & 0x80) && buf[1] == 0)	/* BOP of partition 0 */
+			STp->ps[0].drv_block = STp->ps[0].drv_file = 0;
 	}
-	st_release_request(SRpnt);
-	SRpnt = NULL;
 
-	return result;
+	DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n",
+		    name, *block, *partition));
+	kfree(buf);
+	return 0;
 }
 
 
@@ -2962,7 +3010,6 @@ static int set_location(struct scsi_tape
 	unsigned int blk;
 	int timeout;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -3019,9 +3066,8 @@ static int set_location(struct scsi_tape
 		timeout = STp->device->timeout;
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
-			   timeout, MAX_READY_RETRIES, 1);
-	if (!SRpnt)
+	if (!st_scsi_execute(STp, scmd, DMA_NONE, NULL, 0,
+			   timeout, MAX_READY_RETRIES))
 		return (STp->buffer)->syscall_result;
 
 	STps->drv_block = STps->drv_file = (-1);
@@ -3048,9 +3094,6 @@ static int set_location(struct scsi_tape
 		result = 0;
 	}
 
-	st_release_request(SRpnt);
-	SRpnt = NULL;
-
 	return result;
 }
 
@@ -3102,23 +3145,28 @@ static int switch_partition(struct scsi_
 static int nbr_partitions(struct scsi_tape *STp)
 {
 	int result;
+	u8 *buf;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
 		return (-EIO);
 
-	result = read_mode_page(STp, PART_PAGE, 1);
+	buf = (u8 *)get_zeroed_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	result = read_mode_page(STp, buf, PART_PAGE, 1);
 
 	if (result) {
                 DEBC(printk(ST_DEB_MSG "%s: Can't read medium partition page.\n",
                             name));
 		result = (-EIO);
 	} else {
-		result = (STp->buffer)->b_data[MODE_HEADER_LENGTH +
-					      PP_OFF_NBR_ADD_PARTS] + 1;
+		result = buf[MODE_HEADER_LENGTH + PP_OFF_NBR_ADD_PARTS] + 1;
                 DEBC(printk(ST_DEB_MSG "%s: Number of partitions %d.\n", name, result));
 	}
 
+	free_page((unsigned long)buf);
 	return result;
 }
 
@@ -3149,13 +3197,17 @@ static int partition_tape(struct scsi_ta
 	int pgo, psd_cnt, psdo;
 	unsigned char *bp;
 
-	result = read_mode_page(STp, PART_PAGE, 0);
+	bp = (u8 *)get_zeroed_page(GFP_KERNEL);
+	if (!bp)
+		return -ENOMEM;
+
+	result = read_mode_page(STp, bp, PART_PAGE, 0);
 	if (result) {
 		DEBC(printk(ST_DEB_MSG "%s: Can't read partition mode page.\n", name));
-		return result;
+		goto out;
 	}
 	/* The mode page is in the buffer. Let's modify it and write it. */
-	bp = (STp->buffer)->b_data;
+
 	pgo = MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
 	DEBC(printk(ST_DEB_MSG "%s: Partition page length is %d bytes.\n",
 		    name, bp[pgo + MP_OFF_PAGE_LENGTH] + 2));
@@ -3192,12 +3244,14 @@ static int partition_tape(struct scsi_ta
 	bp[pgo + PP_OFF_RESERVED] = 0;
 	bp[pgo + PP_OFF_FLAGS] = PP_BIT_IDP | PP_MSK_PSUM_MB;
 
-	result = write_mode_page(STp, PART_PAGE, 1);
+	result = write_mode_page(STp, bp, PART_PAGE, 1);
 	if (result) {
 		printk(KERN_INFO "%s: Partitioning of tape failed.\n", name);
 		result = (-EIO);
 	}
 
+ out:
+	free_page((unsigned long)bp);
 	return result;
 }
 

@@ -3643,7 +3697,6 @@ static int enlarge_buffer(struct st_buff
 		STbuffer->buffer_size = got;
 		segs++;
 	}
-	STbuffer->b_data = page_address(STbuffer->frp[0].page);
 
 	return 1;
 }
--- linux-2.6.16-rc1-git4-k1/drivers/scsi/st.h	2006-01-18 21:22:07.000000000 +0200
+++ linux-2.6.16-rc1-git4-k2/drivers/scsi/st.h	2006-02-01 19:41:38.000000000 +0200
@@ -42,7 +42,6 @@ struct st_buffer {
 	int syscall_result;
 	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
-	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
 	unsigned short orig_frp_segs;	/* number of segments allocated at first try */
