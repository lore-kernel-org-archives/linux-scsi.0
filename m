From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/10] convert st to use scsi_execute_async
Date: Tue, 08 Nov 2005 04:06:44 -0600
Message-ID: <1131444404.23111.66.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:8863 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932502AbVKHKHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:07:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

convert st to always send scatterlists and kill scsi_request
usage.

This is the same as last time as it was posted, but with Kai's patches
merged and we now pass the bytes value to scsi_execute_async.

TODO:

- move DIO code to common place or make block layers usable for ULDs.
- move buffer allocation code to common place for all ULDs to use. And
make buffer allocation code handle all queue limits so we can find
out about problems before calling scsi_execute_async.
- move indirect (copy_to/from_user) paths commone place or make block
layers usable for ULDs.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6b85f84..9c5ef70 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -50,7 +50,6 @@ static char *verstr = "20050830";
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
 #include <scsi/sg.h>
 
 
@@ -188,8 +187,6 @@ static int from_buffer(struct st_buffer 
 static void move_buffer_data(struct st_buffer *, int);
 static void buf_to_sg(struct st_buffer *, unsigned int);
 
-static int st_map_user_pages(struct scatterlist *, const unsigned int, 
-			     unsigned long, size_t, int, unsigned long);
 static int sgl_map_user_pages(struct scatterlist *, const unsigned int, 
 			      unsigned long, size_t, int);
 static int sgl_unmap_user_pages(struct scatterlist *, const unsigned int, int);
@@ -313,12 +310,13 @@ static inline char *tape_name(struct scs
 }
 
 
-static void st_analyze_sense(struct scsi_request *SRpnt, struct st_cmdstatus *s)
+static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
 {
 	const u8 *ucp;
-	const u8 *sense = SRpnt->sr_sense_buffer;
+	const u8 *sense = SRpnt->sense;
 
-	s->have_sense = scsi_request_normalize_sense(SRpnt, &s->sense_hdr);
+	s->have_sense = scsi_normalize_sense(SRpnt->sense,
+				SCSI_SENSE_BUFFERSIZE, &s->sense_hdr);
 	s->flags = 0;
 
 	if (s->have_sense) {
@@ -345,9 +343,9 @@ static void st_analyze_sense(struct scsi
 
 
 /* Convert the result to success code */
-static int st_chk_result(struct scsi_tape *STp, struct scsi_request * SRpnt)
+static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 {
-	int result = SRpnt->sr_result;
+	int result = SRpnt->result;
 	u8 scode;
 	DEB(const char *stp;)
 	char *name = tape_name(STp);
@@ -366,13 +364,12 @@ static int st_chk_result(struct scsi_tap
 
         DEB(
         if (debugging) {
-                printk(ST_DEB_MSG "%s: Error: %x, cmd: %x %x %x %x %x %x Len: %d\n",
+                printk(ST_DEB_MSG "%s: Error: %x, cmd: %x %x %x %x %x %x\n",
 		       name, result,
-		       SRpnt->sr_cmnd[0], SRpnt->sr_cmnd[1], SRpnt->sr_cmnd[2],
-		       SRpnt->sr_cmnd[3], SRpnt->sr_cmnd[4], SRpnt->sr_cmnd[5],
-		       SRpnt->sr_bufflen);
+		       SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
+		       SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
-			scsi_print_req_sense("st", SRpnt);
+			 __scsi_print_sense("st", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
@@ -386,20 +383,21 @@ static int st_chk_result(struct scsi_tap
 			 /* scode != UNIT_ATTENTION && */
 			 scode != BLANK_CHECK &&
 			 scode != VOLUME_OVERFLOW &&
-			 SRpnt->sr_cmnd[0] != MODE_SENSE &&
-			 SRpnt->sr_cmnd[0] != TEST_UNIT_READY) {
+			 SRpnt->cmd[0] != MODE_SENSE &&
+			 SRpnt->cmd[0] != TEST_UNIT_READY) {
 				printk(KERN_WARNING "%s: Error with sense data: ", name);
-				scsi_print_req_sense("st", SRpnt);
+				__scsi_print_sense("st", SRpnt->sense,
+						   SCSI_SENSE_BUFFERSIZE);
 		}
 	}
 
 	if (cmdstatp->fixed_format &&
 	    STp->cln_mode >= EXTENDED_SENSE_START) {  /* Only fixed format sense */
 		if (STp->cln_sense_value)
-			STp->cleaning_req |= ((SRpnt->sr_sense_buffer[STp->cln_mode] &
+			STp->cleaning_req |= ((SRpnt->sense[STp->cln_mode] &
 					       STp->cln_sense_mask) == STp->cln_sense_value);
 		else
-			STp->cleaning_req |= ((SRpnt->sr_sense_buffer[STp->cln_mode] &
+			STp->cleaning_req |= ((SRpnt->sense[STp->cln_mode] &
 					       STp->cln_sense_mask) != 0);
 	}
 	if (cmdstatp->have_sense &&
@@ -411,8 +409,8 @@ static int st_chk_result(struct scsi_tap
 	if (cmdstatp->have_sense &&
 	    scode == RECOVERED_ERROR
 #if ST_RECOVERED_WRITE_FATAL
-	    && SRpnt->sr_cmnd[0] != WRITE_6
-	    && SRpnt->sr_cmnd[0] != WRITE_FILEMARKS
+	    && SRpnt->cmd[0] != WRITE_6
+	    && SRpnt->cmd[0] != WRITE_FILEMARKS
 #endif
 	    ) {
 		STp->recover_count++;
@@ -420,9 +418,9 @@ static int st_chk_result(struct scsi_tap
 
                 DEB(
 		if (debugging) {
-			if (SRpnt->sr_cmnd[0] == READ_6)
+			if (SRpnt->cmd[0] == READ_6)
 				stp = "read";
-			else if (SRpnt->sr_cmnd[0] == WRITE_6)
+			else if (SRpnt->cmd[0] == WRITE_6)
 				stp = "write";
 			else
 				stp = "ioctl";
@@ -438,28 +436,37 @@ static int st_chk_result(struct scsi_tap
 
 
 /* Wakeup from interrupt */
-static void st_sleep_done(struct scsi_cmnd * SCpnt)
+static void st_sleep_done(void *data, char *sense, int result, int resid)
 {
-	struct scsi_tape *STp = container_of(SCpnt->request->rq_disk->private_data,
-					     struct scsi_tape, driver);
+	struct st_request *SRpnt = data;
+	struct scsi_tape *STp = SRpnt->stp;
 
-	(STp->buffer)->cmdstat.midlevel_result = SCpnt->result;
-	SCpnt->request->rq_status = RQ_SCSI_DONE;
+	memcpy(SRpnt->sense, sense, SCSI_SENSE_BUFFERSIZE);
+	(STp->buffer)->cmdstat.midlevel_result = SRpnt->result = result;
 	DEB( STp->write_pending = 0; )
 
-	if (SCpnt->request->waiting)
-		complete(SCpnt->request->waiting);
+	if (SRpnt->waiting)
+		complete(SRpnt->waiting);
+}
+
+static struct st_request *st_allocate_request(void)
+{
+	return kzalloc(sizeof(struct st_request), GFP_KERNEL);
+}
+
+static void st_release_request(struct st_request *streq)
+{
+	kfree(streq);
 }
 
 /* Do the scsi command. Waits until command performed if do_wait is true.
    Otherwise write_behind_check() is used to check that the command
    has finished. */
-static struct scsi_request *
-st_do_scsi(struct scsi_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd,
+static struct st_request *
+st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd,
 	   int bytes, int direction, int timeout, int retries, int do_wait)
 {
 	struct completion *waiting;
-	unsigned char *bp;
 
 	/* if async, make sure there's no command outstanding */
 	if (!do_wait && ((STp->buffer)->last_SRpnt)) {
@@ -473,7 +480,7 @@ st_do_scsi(struct scsi_request * SRpnt, 
 	}
 
 	if (SRpnt == NULL) {
-		SRpnt = scsi_allocate_request(STp->device, GFP_ATOMIC);
+		SRpnt = st_allocate_request();
 		if (SRpnt == NULL) {
 			DEBC( printk(KERN_ERR "%s: Can't get SCSI request.\n",
 				     tape_name(STp)); );
@@ -483,6 +490,7 @@ st_do_scsi(struct scsi_request * SRpnt, 
 				(STp->buffer)->syscall_result = (-EBUSY);
 			return NULL;
 		}
+		SRpnt->stp = STp;
 	}
 
 	/* If async IO, set last_SRpnt. This ptr tells write_behind_check
@@ -492,32 +500,26 @@ st_do_scsi(struct scsi_request * SRpnt, 
 
 	waiting = &STp->wait;
 	init_completion(waiting);
-	SRpnt->sr_use_sg = STp->buffer->do_dio || (bytes > (STp->buffer)->frp[0].length);
-	if (SRpnt->sr_use_sg) {
-		if (!STp->buffer->do_dio)
-			buf_to_sg(STp->buffer, bytes);
-		SRpnt->sr_use_sg = (STp->buffer)->sg_segs;
-		bp = (char *) &((STp->buffer)->sg[0]);
-	} else
-		bp = (STp->buffer)->b_data;
-	SRpnt->sr_data_direction = direction;
-	SRpnt->sr_cmd_len = 0;
-	SRpnt->sr_request->waiting = waiting;
-	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
-	SRpnt->sr_request->rq_disk = STp->disk;
-	SRpnt->sr_request->end_io = blk_end_sync_rq;
-	STp->buffer->cmdstat.have_sense = 0;
+	SRpnt->waiting = waiting;
 
-	scsi_do_req(SRpnt, (void *) cmd, bp, bytes,
-		    st_sleep_done, timeout, retries);
+	if (!STp->buffer->do_dio)
+		buf_to_sg(STp->buffer, bytes);
+
+	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
+	STp->buffer->cmdstat.have_sense = 0;
+	STp->buffer->syscall_result = 0;
 
-	if (do_wait) {
+	if (scsi_execute_async(STp->device, cmd, direction,
+			&((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
+			timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL))
+		/* could not allocate the buffer or request was too large */
+		(STp->buffer)->syscall_result = (-EBUSY);
+	else if (do_wait) {
 		wait_for_completion(waiting);
-		SRpnt->sr_request->waiting = NULL;
-		if (SRpnt->sr_request->rq_status != RQ_SCSI_DONE)
-			SRpnt->sr_result |= (DRIVER_ERROR << 24);
+		SRpnt->waiting = NULL;
 		(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
 	}
+
 	return SRpnt;
 }
 
@@ -532,7 +534,7 @@ static int write_behind_check(struct scs
 	struct st_buffer *STbuffer;
 	struct st_partstat *STps;
 	struct st_cmdstatus *cmdstatp;
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 
 	STbuffer = STp->buffer;
 	if (!STbuffer->writing)
@@ -548,12 +550,10 @@ static int write_behind_check(struct scs
 	wait_for_completion(&(STp->wait));
 	SRpnt = STbuffer->last_SRpnt;
 	STbuffer->last_SRpnt = NULL;
-	SRpnt->sr_request->waiting = NULL;
-	if (SRpnt->sr_request->rq_status != RQ_SCSI_DONE)
-		SRpnt->sr_result |= (DRIVER_ERROR << 24);
+	SRpnt->waiting = NULL;
 
 	(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	STbuffer->buffer_bytes -= STbuffer->writing;
 	STps = &(STp->ps[STp->partition]);
@@ -593,7 +593,7 @@ static int write_behind_check(struct scs
    it messes up the block number). */
 static int cross_eof(struct scsi_tape * STp, int forward)
 {
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 
 	cmd[0] = SPACE;
@@ -613,7 +613,7 @@ static int cross_eof(struct scsi_tape * 
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
@@ -630,7 +630,7 @@ static int flush_write_buffer(struct scs
 	int offset, transfer, blks;
 	int result;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct st_partstat *STps;
 
 	result = write_behind_check(STp);
@@ -688,7 +688,7 @@ static int flush_write_buffer(struct scs
 			STp->dirty = 0;
 			(STp->buffer)->buffer_bytes = 0;
 		}
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 	}
 	return result;
@@ -785,7 +785,7 @@ static int set_mode_densblk(struct scsi_
 }
 
 
-/* Lock or unlock the drive door. Don't use when scsi_request allocated. */
+/* Lock or unlock the drive door. Don't use when st_request allocated. */
 static int do_door_lock(struct scsi_tape * STp, int do_lock)
 {
 	int retval, cmd;
@@ -844,7 +844,7 @@ static int test_ready(struct scsi_tape *
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
@@ -903,7 +903,7 @@ static int test_ready(struct scsi_tape *
 	}
 
 	if (SRpnt != NULL)
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 	return retval;
 }
 
@@ -918,7 +918,7 @@ static int check_tape(struct scsi_tape *
 	int i, retval, new_session = 0, do_wait;
 	unsigned char cmd[MAX_COMMAND_SIZE], saved_cleaning;
 	unsigned short st_flags = filp->f_flags;
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	char *name = tape_name(STp);
@@ -993,7 +993,7 @@ static int check_tape(struct scsi_tape *
 			goto err_out;
 		}
 
-		if (!SRpnt->sr_result && !STp->buffer->cmdstat.have_sense) {
+		if (!SRpnt->result && !STp->buffer->cmdstat.have_sense) {
 			STp->max_block = ((STp->buffer)->b_data[1] << 16) |
 			    ((STp->buffer)->b_data[2] << 8) | (STp->buffer)->b_data[3];
 			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
@@ -1045,7 +1045,7 @@ static int check_tape(struct scsi_tape *
 		}
 		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
 	}
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
         STp->inited = 1;
 
@@ -1196,7 +1196,7 @@ static int st_flush(struct file *filp)
 {
 	int result = 0, result2;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm = &(STp->modes[STp->current_mode]);
 	struct st_partstat *STps = &(STp->ps[STp->partition]);
@@ -1249,7 +1249,7 @@ static int st_flush(struct file *filp)
 		      cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
 		     (!cmdstatp->remainder_valid || cmdstatp->uremainder64 == 0))) {
 			/* Write successful at EOM */
-			scsi_release_request(SRpnt);
+			st_release_request(SRpnt);
 			SRpnt = NULL;
 			if (STps->drv_file >= 0)
 				STps->drv_file++;
@@ -1259,7 +1259,7 @@ static int st_flush(struct file *filp)
 			STps->eof = ST_FM;
 		}
 		else { /* Write error */
-			scsi_release_request(SRpnt);
+			st_release_request(SRpnt);
 			SRpnt = NULL;
 			printk(KERN_ERR "%s: Error on write filemark.\n", name);
 			if (result == 0)
@@ -1400,11 +1400,11 @@ static int setup_buffering(struct scsi_t
 		i = STp->try_dio && try_rdio;
 	else
 		i = STp->try_dio && try_wdio;
+
 	if (i && ((unsigned long)buf & queue_dma_alignment(
 					STp->device->request_queue)) == 0) {
-		i = st_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
-				      (unsigned long)buf, count, (is_read ? READ : WRITE),
-				      STp->max_pfn);
+		i = sgl_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
+				      (unsigned long)buf, count, (is_read ? READ : WRITE));
 		if (i > 0) {
 			STbp->do_dio = i;
 			STbp->buffer_bytes = 0;   /* can be used as transfer counter */
@@ -1472,7 +1472,7 @@ st_write(struct file *filp, const char _
 	int async_write;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	const char __user *b_point;
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -1624,7 +1624,7 @@ st_write(struct file *filp, const char _
 			retval = STbp->syscall_result;
 			goto out;
 		}
-		if (async_write) {
+		if (async_write && !STbp->syscall_result) {
 			STbp->writing = transfer;
 			STp->dirty = !(STbp->writing ==
 				       STbp->buffer_bytes);
@@ -1698,7 +1698,7 @@ st_write(struct file *filp, const char _
 			} else {
 				count += do_count;
 				STps->drv_block = (-1);		/* Too cautious? */
-				retval = (-EIO);
+				retval = STbp->syscall_result;
 			}
 
 		}
@@ -1728,7 +1728,7 @@ st_write(struct file *filp, const char _
 
  out:
 	if (SRpnt != NULL)
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 	release_buffering(STp);
 	up(&STp->lock);
 
@@ -1742,11 +1742,11 @@ st_write(struct file *filp, const char _
    Does release user buffer mapping if it is set.
 */
 static long read_tape(struct scsi_tape *STp, long count,
-		      struct scsi_request ** aSRpnt)
+		      struct st_request ** aSRpnt)
 {
 	int transfer, blks, bytes;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *STbp;
@@ -1802,10 +1802,10 @@ static long read_tape(struct scsi_tape *
 		retval = 1;
 		DEBC(printk(ST_DEB_MSG "%s: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
                             name,
-                            SRpnt->sr_sense_buffer[0], SRpnt->sr_sense_buffer[1],
-                            SRpnt->sr_sense_buffer[2], SRpnt->sr_sense_buffer[3],
-                            SRpnt->sr_sense_buffer[4], SRpnt->sr_sense_buffer[5],
-                            SRpnt->sr_sense_buffer[6], SRpnt->sr_sense_buffer[7]));
+                            SRpnt->sense[0], SRpnt->sense[1],
+                            SRpnt->sense[2], SRpnt->sense[3],
+                            SRpnt->sense[4], SRpnt->sense[5],
+                            SRpnt->sense[6], SRpnt->sense[7]));
 		if (cmdstatp->have_sense) {
 
 			if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
@@ -1835,7 +1835,7 @@ static long read_tape(struct scsi_tape *
 						}
 						STbp->buffer_bytes = bytes - transfer;
 					} else {
-						scsi_release_request(SRpnt);
+						st_release_request(SRpnt);
 						SRpnt = *aSRpnt = NULL;
 						if (transfer == blks) {	/* We did not get anything, error */
 							printk(KERN_NOTICE "%s: Incorrect block size.\n", name);
@@ -1929,7 +1929,7 @@ st_read(struct file *filp, char __user *
 	ssize_t retval = 0;
 	ssize_t i, transfer;
 	int special, do_dio = 0;
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -2054,7 +2054,7 @@ st_read(struct file *filp, char __user *
 
  out:
 	if (SRpnt != NULL) {
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 	}
 	if (do_dio) {
@@ -2284,7 +2284,7 @@ static int st_set_options(struct scsi_ta
 static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2298,7 +2298,7 @@ static int read_mode_page(struct scsi_ta
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	return (STp->buffer)->syscall_result;
 }
@@ -2310,7 +2310,7 @@ static int write_mode_page(struct scsi_t
 {
 	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
@@ -2329,7 +2329,7 @@ static int write_mode_page(struct scsi_t
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	return (STp->buffer)->syscall_result;
 }
@@ -2412,7 +2412,7 @@ static int do_load_unload(struct scsi_ta
 	DEB( char *name = tape_name(STp); )
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_partstat *STps;
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 
 	if (STp->ready != ST_READY && !load_code) {
 		if (STp->ready == ST_NO_TAPE)
@@ -2455,7 +2455,7 @@ static int do_load_unload(struct scsi_ta
 		return (STp->buffer)->syscall_result;
 
 	retval = (STp->buffer)->syscall_result;
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	if (!retval) {	/* SCSI command successful */
 
@@ -2503,7 +2503,7 @@ static int st_int_ioctl(struct scsi_tape
 	int ioctl_result;
 	int chg_eof = 1;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct st_partstat *STps;
 	int fileno, blkno, at_sm, undone;
 	int datalen = 0, direction = DMA_NONE;
@@ -2757,7 +2757,7 @@ static int st_int_ioctl(struct scsi_tape
 	ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 		STps->drv_block = blkno;
 		STps->drv_file = fileno;
@@ -2872,7 +2872,7 @@ static int st_int_ioctl(struct scsi_tape
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = !STp->use_pf | PF_TESTED;
-				scsi_release_request(SRpnt);
+				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
 			}
@@ -2882,7 +2882,7 @@ static int st_int_ioctl(struct scsi_tape
 		if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
 			STps->eof = ST_EOD;
 
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 	}
 
@@ -2898,7 +2898,7 @@ static int get_location(struct scsi_tape
 {
 	int result;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -2944,7 +2944,7 @@ static int get_location(struct scsi_tape
                 DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
                             *block, *partition));
 	}
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
 
 	return result;
@@ -2961,7 +2961,7 @@ static int set_location(struct scsi_tape
 	unsigned int blk;
 	int timeout;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -3047,7 +3047,7 @@ static int set_location(struct scsi_tape
 		result = 0;
 	}
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
 
 	return result;
@@ -3577,7 +3577,7 @@ static long st_compat_ioctl(struct file 
 static struct st_buffer *
  new_tape_buffer(int from_initialization, int need_dma, int max_sg)
 {
-	int i, got = 0, segs = 0;
+	int i, got = 0;
 	gfp_t priority;
 	struct st_buffer *tb;
 
@@ -3594,10 +3594,8 @@ static struct st_buffer *
 		return NULL;
 	}
 	memset(tb, 0, i);
-	tb->frp_segs = tb->orig_frp_segs = segs;
+	tb->frp_segs = tb->orig_frp_segs = 0;
 	tb->use_sg = max_sg;
-	if (segs > 0)
-		tb->b_data = page_address(tb->sg[0].page);
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
 	tb->in_use = 1;
@@ -3628,7 +3626,7 @@ static int enlarge_buffer(struct st_buff
 	priority = GFP_KERNEL | __GFP_NOWARN;
 	if (need_dma)
 		priority |= GFP_DMA;
-	for (b_size = PAGE_SIZE, order=0;
+	for (b_size = PAGE_SIZE, order=0; order <= 6 &&
 	     b_size < new_size - STbuffer->buffer_size;
 	     order++, b_size *= 2)
 		;  /* empty */
@@ -3882,7 +3880,6 @@ static int st_probe(struct device *dev)
 	struct st_buffer *buffer;
 	int i, j, mode, dev_num, error;
 	char *stp;
-	u64 bounce_limit;
 
 	if (SDp->type != TYPE_TAPE)
 		return -ENODEV;
@@ -3994,11 +3991,6 @@ static int st_probe(struct device *dev)
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
 
-	bounce_limit = scsi_calculate_bounce_limit(SDp->host) >> PAGE_SHIFT;
-	if (bounce_limit > ULONG_MAX)
-		bounce_limit = ULONG_MAX;
-	tpnt->max_pfn = bounce_limit;
-
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
 		STm->defined = 0;
@@ -4077,9 +4069,9 @@ static int st_probe(struct device *dev)
 
 	sdev_printk(KERN_WARNING, SDp,
 		    "Attached scsi tape %s", tape_name(tpnt));
-	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max page reachable by HBA %lu\n",
+	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B)\n",
 	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
-	       queue_dma_alignment(SDp->request_queue) + 1, tpnt->max_pfn);
+	       queue_dma_alignment(SDp->request_queue) + 1);
 
 	return 0;
 
@@ -4408,34 +4400,6 @@ static void do_create_class_files(struct
 	return;
 }
 
-
-/* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
-   - mapping of all pages not successful
-   - any page is above max_pfn
-   (i.e., either completely successful or fails)
-*/
-static int st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
-			     unsigned long uaddr, size_t count, int rw,
-			     unsigned long max_pfn)
-{
-	int i, nr_pages;
-
-	nr_pages = sgl_map_user_pages(sgl, max_pages, uaddr, count, rw);
-	if (nr_pages <= 0)
-		return nr_pages;
-
-	for (i=0; i < nr_pages; i++) {
-		if (page_to_pfn(sgl[i].page) > max_pfn)
-			goto out_unmap;
-	}
-	return nr_pages;
-
- out_unmap:
-	sgl_unmap_user_pages(sgl, nr_pages, 0);
-	return 0;
-}
-
-
 /* The following functions may be useful for a larger audience. */
 static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
 			      unsigned long uaddr, size_t count, int rw)
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 790acac..4112090 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -4,6 +4,7 @@
 
 #include <linux/completion.h>
 #include <linux/kref.h>
+#include <scsi/scsi_cmnd.h>
 
 /* Descriptor for analyzed sense data */
 struct st_cmdstatus {
@@ -17,6 +18,17 @@ struct st_cmdstatus {
 	u8 deferred;
 };
 
+struct scsi_tape;
+
+/* scsi tape command */
+struct st_request {
+	unsigned char cmd[MAX_COMMAND_SIZE];
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	int result;
+	struct scsi_tape *stp;
+	struct completion *waiting;
+};
+
 /* The tape buffer descriptor. */
 struct st_buffer {
 	unsigned char in_use;
@@ -28,7 +40,7 @@ struct st_buffer {
 	int read_pointer;
 	int writing;
 	int syscall_result;
-	struct scsi_request *last_SRpnt;
+	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */


