From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC/RFT 4/4]  convert st
Date: Wed, 14 Sep 2005 17:19:52 -0500
Message-ID: <1126736393.16778.28.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2244 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030222AbVINWUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 18:20:21 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8EMKJoP021637
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2005 17:20:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert st to always use scatterlists.

Patch is completely untested. I do not have tape.

Note that this should work like before except that
HighMem is no longer supported for DIO (we drop down
to indirect). However we support bounce buffers
for the non-DIO case now. So we could kill restr_dma too becuase
the block layer will bounce the buffers that are beyond queue limits.

This was meant to be a safer patch that maybe Kai or someone
could test and adjust, but then we could move scsi-ml forward.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -50,7 +50,6 @@ static char *verstr = "20050830";
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
 #include <scsi/sg.h>
 
 
@@ -188,11 +187,11 @@ static int from_buffer(struct st_buffer 
 static void move_buffer_data(struct st_buffer *, int);
 static void buf_to_sg(struct st_buffer *, unsigned int);
 
-static int st_map_user_pages(struct scatterlist *, const unsigned int, 
-			     unsigned long, size_t, int, unsigned long);
-static int sgl_map_user_pages(struct scatterlist *, const unsigned int, 
+static int st_map_user_pages(struct kvec *, const unsigned int, 
+			     unsigned long, size_t, int);
+static int sgl_map_user_pages(struct kvec *, const unsigned int, 
 			      unsigned long, size_t, int);
-static int sgl_unmap_user_pages(struct scatterlist *, const unsigned int, int);
+static int sgl_unmap_user_pages(struct kvec *, const unsigned int, int);
 
 static int st_probe(struct device *);
 static int st_remove(struct device *);
@@ -313,12 +312,13 @@ static inline char *tape_name(struct scs
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
@@ -345,9 +345,9 @@ static void st_analyze_sense(struct scsi
 
 
 /* Convert the result to success code */
-static int st_chk_result(struct scsi_tape *STp, struct scsi_request * SRpnt)
+static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 {
-	int result = SRpnt->sr_result;
+	int result = SRpnt->result;
 	u8 scode;
 	DEB(const char *stp;)
 	char *name = tape_name(STp);
@@ -366,11 +366,10 @@ static int st_chk_result(struct scsi_tap
 
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
 			scsi_print_req_sense("st", SRpnt);
 	} ) /* end DEB */
@@ -386,20 +385,21 @@ static int st_chk_result(struct scsi_tap
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
@@ -411,8 +411,8 @@ static int st_chk_result(struct scsi_tap
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
@@ -420,9 +420,9 @@ static int st_chk_result(struct scsi_tap
 
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
@@ -438,28 +438,40 @@ static int st_chk_result(struct scsi_tap
 
 
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
+/*
+ * we can change this to use a mempool if Kai wants
+ */
+static struct st_request *st_allocate_request(void)
+{
+	return kzalloc(sizeof(struct st_request), GFP_ATOMIC);
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
@@ -473,7 +485,7 @@ st_do_scsi(struct scsi_request * SRpnt, 
 	}
 
 	if (SRpnt == NULL) {
-		SRpnt = scsi_allocate_request(STp->device, GFP_ATOMIC);
+		SRpnt = st_allocate_request();
 		if (SRpnt == NULL) {
 			DEBC( printk(KERN_ERR "%s: Can't get SCSI request.\n",
 				     tape_name(STp)); );
@@ -492,32 +504,25 @@ st_do_scsi(struct scsi_request * SRpnt, 
 
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
 
-	if (do_wait) {
+	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
+	STp->buffer->cmdstat.have_sense = 0;
+
+	if (scsi_execute_async_iov_req(STp->device, cmd, direction,
+			&((STp->buffer)->iov_req[0]), (STp->buffer)->sg_segs,
+			timeout, retries, SRpnt, st_sleep_done))
+		/* could not allocate the buffer probably */
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
 
@@ -532,7 +537,7 @@ static int write_behind_check(struct scs
 	struct st_buffer *STbuffer;
 	struct st_partstat *STps;
 	struct st_cmdstatus *cmdstatp;
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 
 	STbuffer = STp->buffer;
 	if (!STbuffer->writing)
@@ -548,12 +553,10 @@ static int write_behind_check(struct scs
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
@@ -593,7 +596,7 @@ static int write_behind_check(struct scs
    it messes up the block number). */
 static int cross_eof(struct scsi_tape * STp, int forward)
 {
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 
 	cmd[0] = SPACE;
@@ -613,7 +616,7 @@ static int cross_eof(struct scsi_tape * 
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
@@ -630,7 +633,7 @@ static int flush_write_buffer(struct scs
 	int offset, transfer, blks;
 	int result;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct st_partstat *STps;
 
 	result = write_behind_check(STp);
@@ -688,7 +691,7 @@ static int flush_write_buffer(struct scs
 			STp->dirty = 0;
 			(STp->buffer)->buffer_bytes = 0;
 		}
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 	}
 	return result;
@@ -785,7 +788,7 @@ static int set_mode_densblk(struct scsi_
 }
 
 
-/* Lock or unlock the drive door. Don't use when scsi_request allocated. */
+/* Lock or unlock the drive door. Don't use when st_request allocated. */
 static int do_door_lock(struct scsi_tape * STp, int do_lock)
 {
 	int retval, cmd;
@@ -844,7 +847,7 @@ static int test_ready(struct scsi_tape *
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
@@ -903,7 +906,7 @@ static int test_ready(struct scsi_tape *
 	}
 
 	if (SRpnt != NULL)
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 	return retval;
 }
 
@@ -918,7 +921,7 @@ static int check_tape(struct scsi_tape *
 	int i, retval, new_session = 0, do_wait;
 	unsigned char cmd[MAX_COMMAND_SIZE], saved_cleaning;
 	unsigned short st_flags = filp->f_flags;
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	char *name = tape_name(STp);
@@ -993,7 +996,7 @@ static int check_tape(struct scsi_tape *
 			goto err_out;
 		}
 
-		if (!SRpnt->sr_result && !STp->buffer->cmdstat.have_sense) {
+		if (!SRpnt->result && !STp->buffer->cmdstat.have_sense) {
 			STp->max_block = ((STp->buffer)->b_data[1] << 16) |
 			    ((STp->buffer)->b_data[2] << 8) | (STp->buffer)->b_data[3];
 			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
@@ -1045,7 +1048,7 @@ static int check_tape(struct scsi_tape *
 		}
 		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
 	}
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
         STp->inited = 1;
 
@@ -1196,7 +1199,7 @@ static int st_flush(struct file *filp)
 {
 	int result = 0, result2;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm = &(STp->modes[STp->current_mode]);
 	struct st_partstat *STps = &(STp->ps[STp->partition]);
@@ -1249,7 +1252,7 @@ static int st_flush(struct file *filp)
 		      cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
 		     (!cmdstatp->remainder_valid || cmdstatp->uremainder64 == 0))) {
 			/* Write successful at EOM */
-			scsi_release_request(SRpnt);
+			st_release_request(SRpnt);
 			SRpnt = NULL;
 			if (STps->drv_file >= 0)
 				STps->drv_file++;
@@ -1259,7 +1262,7 @@ static int st_flush(struct file *filp)
 			STps->eof = ST_FM;
 		}
 		else { /* Write error */
-			scsi_release_request(SRpnt);
+			st_release_request(SRpnt);
 			SRpnt = NULL;
 			printk(KERN_ERR "%s: Error on write filemark.\n", name);
 			if (result == 0)
@@ -1402,9 +1405,8 @@ static int setup_buffering(struct scsi_t
 		i = STp->try_dio && try_wdio;
 	if (i && ((unsigned long)buf & queue_dma_alignment(
 					STp->device->request_queue)) == 0) {
-		i = st_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
-				      (unsigned long)buf, count, (is_read ? READ : WRITE),
-				      STp->max_pfn);
+		i = st_map_user_pages(&(STbp->iov_req[0]), STbp->use_sg,
+				      (unsigned long)buf, count, (is_read ? READ : WRITE));
 		if (i > 0) {
 			STbp->do_dio = i;
 			STbp->buffer_bytes = 0;   /* can be used as transfer counter */
@@ -1455,7 +1457,7 @@ static void release_buffering(struct scs
 
 	STbp = STp->buffer;
 	if (STbp->do_dio) {
-		sgl_unmap_user_pages(&(STbp->sg[0]), STbp->do_dio, 0);
+		sgl_unmap_user_pages(&(STbp->iov_req[0]), STbp->do_dio, 0);
 		STbp->do_dio = 0;
 	}
 }
@@ -1472,7 +1474,7 @@ st_write(struct file *filp, const char _
 	int async_write;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	const char __user *b_point;
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -1728,7 +1730,7 @@ st_write(struct file *filp, const char _
 
  out:
 	if (SRpnt != NULL)
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 	release_buffering(STp);
 	up(&STp->lock);
 
@@ -1742,11 +1744,11 @@ st_write(struct file *filp, const char _
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
@@ -1835,7 +1837,7 @@ static long read_tape(struct scsi_tape *
 						}
 						STbp->buffer_bytes = bytes - transfer;
 					} else {
-						scsi_release_request(SRpnt);
+						st_release_request(SRpnt);
 						SRpnt = *aSRpnt = NULL;
 						if (transfer == blks) {	/* We did not get anything, error */
 							printk(KERN_NOTICE "%s: Incorrect block size.\n", name);
@@ -1929,7 +1931,7 @@ st_read(struct file *filp, char __user *
 	ssize_t retval = 0;
 	ssize_t i, transfer;
 	int special, do_dio = 0;
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 	struct scsi_tape *STp = filp->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -2054,7 +2056,7 @@ st_read(struct file *filp, char __user *
 
  out:
 	if (SRpnt != NULL) {
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 	}
 	if (do_dio) {
@@ -2284,7 +2286,7 @@ static int st_set_options(struct scsi_ta
 static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2298,7 +2300,7 @@ static int read_mode_page(struct scsi_ta
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	return (STp->buffer)->syscall_result;
 }
@@ -2310,7 +2312,7 @@ static int write_mode_page(struct scsi_t
 {
 	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt = NULL;
+	struct st_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
@@ -2329,7 +2331,7 @@ static int write_mode_page(struct scsi_t
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	return (STp->buffer)->syscall_result;
 }
@@ -2412,7 +2414,7 @@ static int do_load_unload(struct scsi_ta
 	DEB( char *name = tape_name(STp); )
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_partstat *STps;
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 
 	if (STp->ready != ST_READY && !load_code) {
 		if (STp->ready == ST_NO_TAPE)
@@ -2455,7 +2457,7 @@ static int do_load_unload(struct scsi_ta
 		return (STp->buffer)->syscall_result;
 
 	retval = (STp->buffer)->syscall_result;
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 
 	if (!retval) {	/* SCSI command successful */
 
@@ -2503,7 +2505,7 @@ static int st_int_ioctl(struct scsi_tape
 	int ioctl_result;
 	int chg_eof = 1;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	struct st_partstat *STps;
 	int fileno, blkno, at_sm, undone;
 	int datalen = 0, direction = DMA_NONE;
@@ -2757,7 +2759,7 @@ static int st_int_ioctl(struct scsi_tape
 	ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 		STps->drv_block = blkno;
 		STps->drv_file = fileno;
@@ -2872,7 +2874,7 @@ static int st_int_ioctl(struct scsi_tape
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = !STp->use_pf | PF_TESTED;
-				scsi_release_request(SRpnt);
+				st_release_request(SRpnt);
 				SRpnt = NULL;
 				return st_int_ioctl(STp, cmd_in, arg);
 			}
@@ -2882,7 +2884,7 @@ static int st_int_ioctl(struct scsi_tape
 		if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
 			STps->eof = ST_EOD;
 
-		scsi_release_request(SRpnt);
+		st_release_request(SRpnt);
 		SRpnt = NULL;
 	}
 
@@ -2898,7 +2900,7 @@ static int get_location(struct scsi_tape
 {
 	int result;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -2944,7 +2946,7 @@ static int get_location(struct scsi_tape
                 DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
                             *block, *partition));
 	}
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
 
 	return result;
@@ -2961,7 +2963,7 @@ static int set_location(struct scsi_tape
 	unsigned int blk;
 	int timeout;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	struct scsi_request *SRpnt;
+	struct st_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -3047,7 +3049,7 @@ static int set_location(struct scsi_tape
 		result = 0;
 	}
 
-	scsi_release_request(SRpnt);
+	st_release_request(SRpnt);
 	SRpnt = NULL;
 
 	return result;
@@ -3577,7 +3579,7 @@ static long st_compat_ioctl(struct file 
 static struct st_buffer *
  new_tape_buffer(int from_initialization, int need_dma, int max_sg)
 {
-	int i, priority, got = 0, segs = 0;
+	int i, priority, got = 0;
 	struct st_buffer *tb;
 
 	if (from_initialization)
@@ -3585,20 +3587,18 @@ static struct st_buffer *
 	else
 		priority = GFP_KERNEL;
 
-	i = sizeof(struct st_buffer) + (max_sg - 1) * sizeof(struct scatterlist) +
-		max_sg * sizeof(struct st_buf_fragment);
+	i = sizeof(struct st_buffer) + (max_sg - 1) * sizeof(struct kvec) +
+		max_sg * sizeof(struct kvec);
 	tb = kmalloc(i, priority);
 	if (!tb) {
 		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
 		return NULL;
 	}
 	memset(tb, 0, i);
-	tb->frp_segs = tb->orig_frp_segs = segs;
+	tb->frp_segs = tb->orig_frp_segs = 0;
 	tb->use_sg = max_sg;
-	if (segs > 0)
-		tb->b_data = page_address(tb->sg[0].page);
-	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
+	tb->iov = (struct kvec *)(&(tb->iov_req[0]) + max_sg);
 	tb->in_use = 1;
 	tb->dma = need_dma;
 	tb->buffer_size = got;
@@ -3633,8 +3633,8 @@ static int enlarge_buffer(struct st_buff
 
 	for (segs = STbuffer->frp_segs, got = STbuffer->buffer_size;
 	     segs < max_segs && got < new_size;) {
-		STbuffer->frp[segs].page = alloc_pages(priority, order);
-		if (STbuffer->frp[segs].page == NULL) {
+		STbuffer->iov[segs].iov_base = (void *)__get_free_pages(priority, order);
+		if (STbuffer->iov[segs].iov_base == NULL) {
 			if (new_size - got <= (max_segs - segs) * b_size / 2) {
 				b_size /= 2; /* Large enough for the rest of the buffers */
 				order--;
@@ -3644,13 +3644,13 @@ static int enlarge_buffer(struct st_buff
 			normalize_buffer(STbuffer);
 			return 0;
 		}
-		STbuffer->frp[segs].length = b_size;
+		STbuffer->iov[segs].iov_len = b_size;
 		STbuffer->frp_segs += 1;
 		got += b_size;
 		STbuffer->buffer_size = got;
 		segs++;
 	}
-	STbuffer->b_data = page_address(STbuffer->frp[0].page);
+	STbuffer->b_data = STbuffer->iov[0].iov_base;
 
 	return 1;
 }
@@ -3662,9 +3662,9 @@ static void normalize_buffer(struct st_b
 	int i, order;
 
 	for (i = STbuffer->orig_frp_segs; i < STbuffer->frp_segs; i++) {
-		order = get_order(STbuffer->frp[i].length);
-		__free_pages(STbuffer->frp[i].page, order);
-		STbuffer->buffer_size -= STbuffer->frp[i].length;
+		order = get_order(STbuffer->iov[i].iov_len);
+		free_pages((unsigned long)STbuffer->iov[i].iov_base, order);
+		STbuffer->buffer_size -= STbuffer->iov[i].iov_len;
 	}
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
@@ -3678,16 +3678,16 @@ static int append_to_buffer(const char _
 	int i, cnt, res, offset;
 
 	for (i = 0, offset = st_bp->buffer_bytes;
-	     i < st_bp->frp_segs && offset >= st_bp->frp[i].length; i++)
-		offset -= st_bp->frp[i].length;
+	     i < st_bp->frp_segs && offset >= st_bp->iov[i].iov_len; i++)
+		offset -= st_bp->iov[i].iov_len;
 	if (i == st_bp->frp_segs) {	/* Should never happen */
 		printk(KERN_WARNING "st: append_to_buffer offset overflow.\n");
 		return (-EIO);
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
-		cnt = st_bp->frp[i].length - offset < do_count ?
-		    st_bp->frp[i].length - offset : do_count;
-		res = copy_from_user(page_address(st_bp->frp[i].page) + offset, ubp, cnt);
+		cnt = st_bp->iov[i].iov_len - offset < do_count ?
+		    st_bp->iov[i].iov_len - offset : do_count;
+		res = copy_from_user(st_bp->iov[i].iov_base + offset, ubp, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -3709,16 +3709,16 @@ static int from_buffer(struct st_buffer 
 	int i, cnt, res, offset;
 
 	for (i = 0, offset = st_bp->read_pointer;
-	     i < st_bp->frp_segs && offset >= st_bp->frp[i].length; i++)
-		offset -= st_bp->frp[i].length;
+	     i < st_bp->frp_segs && offset >= st_bp->iov[i].iov_len; i++)
+		offset -= st_bp->iov[i].iov_len;
 	if (i == st_bp->frp_segs) {	/* Should never happen */
 		printk(KERN_WARNING "st: from_buffer offset overflow.\n");
 		return (-EIO);
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
-		cnt = st_bp->frp[i].length - offset < do_count ?
-		    st_bp->frp[i].length - offset : do_count;
-		res = copy_to_user(ubp, page_address(st_bp->frp[i].page) + offset, cnt);
+		cnt = st_bp->iov[i].iov_len - offset < do_count ?
+		    st_bp->iov[i].iov_len - offset : do_count;
+		res = copy_to_user(ubp, st_bp->iov[i].iov_base + offset, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -3746,24 +3746,24 @@ static void move_buffer_data(struct st_b
 	total=st_bp->buffer_bytes - offset;
 	for (src_seg=0; src_seg < st_bp->frp_segs; src_seg++) {
 		src_offset = offset;
-		if (src_offset < st_bp->frp[src_seg].length)
+		if (src_offset < st_bp->iov[src_seg].iov_len)
 			break;
-		offset -= st_bp->frp[src_seg].length;
+		offset -= st_bp->iov[src_seg].iov_len;
 	}
 
 	st_bp->buffer_bytes = st_bp->read_pointer = total;
 	for (dst_seg=dst_offset=0; total > 0; ) {
-		count = min(st_bp->frp[dst_seg].length - dst_offset,
-			    st_bp->frp[src_seg].length - src_offset);
-		memmove(page_address(st_bp->frp[dst_seg].page) + dst_offset,
-			page_address(st_bp->frp[src_seg].page) + src_offset, count);
+		count = min(st_bp->iov[dst_seg].iov_len - dst_offset,
+			    st_bp->iov[src_seg].iov_len - src_offset);
+		memmove(st_bp->iov[dst_seg].iov_base + dst_offset,
+			st_bp->iov[src_seg].iov_base + src_offset, count);
 		src_offset += count;
-		if (src_offset >= st_bp->frp[src_seg].length) {
+		if (src_offset >= st_bp->iov[src_seg].iov_len) {
 			src_seg++;
 			src_offset = 0;
 		}
 		dst_offset += count;
-		if (dst_offset >= st_bp->frp[dst_seg].length) {
+		if (dst_offset >= st_bp->iov[dst_seg].iov_len) {
 			dst_seg++;
 			dst_offset = 0;
 		}
@@ -3772,27 +3772,26 @@ static void move_buffer_data(struct st_b
 }
 
 
-/* Fill the s/g list up to the length required for this transfer */
+/* Set our segment counts */
 static void buf_to_sg(struct st_buffer *STbp, unsigned int length)
 {
 	int i;
 	unsigned int count;
-	struct scatterlist *sg;
-	struct st_buf_fragment *frp;
+	struct kvec *iov, *iov_req;
 
 	if (length == STbp->frp_sg_current)
 		return;   /* work already done */
 
-	sg = &(STbp->sg[0]);
-	frp = STbp->frp;
+	iov_req = &(STbp->iov_req[0]);
+	iov = STbp->iov;
 	for (i=count=0; count < length; i++) {
-		sg[i].page = frp[i].page;
-		if (length - count > frp[i].length)
-			sg[i].length = frp[i].length;
+		iov_req[i].iov_base = iov[i].iov_base;
+		if (length - count > iov[i].iov_len)
+			iov_req->iov_len = iov->iov_len;
 		else
-			sg[i].length = length - count;
-		count += sg[i].length;
-		sg[i].offset = 0;
+			iov_req->iov_len = length - count;
+
+		count += iov_req[i].iov_len;
 	}
 	STbp->sg_segs = i;
 	STbp->frp_sg_current = length;
@@ -3880,7 +3879,6 @@ static int st_probe(struct device *dev)
 	struct st_buffer *buffer;
 	int i, j, mode, dev_num, error;
 	char *stp;
-	u64 bounce_limit;
 
 	if (SDp->type != TYPE_TAPE)
 		return -ENODEV;
@@ -3994,11 +3992,6 @@ static int st_probe(struct device *dev)
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
@@ -4078,9 +4071,9 @@ static int st_probe(struct device *dev)
 	printk(KERN_WARNING
 	"Attached scsi tape %s at scsi%d, channel %d, id %d, lun %d\n",
 	       tape_name(tpnt), SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
-	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max page reachable by HBA %lu\n",
+	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B)\n",
 	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
-	       queue_dma_alignment(SDp->request_queue) + 1, tpnt->max_pfn);
+	       queue_dma_alignment(SDp->request_queue) + 1);
 
 	return 0;
 
@@ -4411,33 +4404,18 @@ static void do_create_class_files(struct
 
 /* Pin down user pages and put them into a scatter gather list. Returns <= 0 if
    - mapping of all pages not successful
-   - any page is above max_pfn
+   - A HighMem page is returned
    (i.e., either completely successful or fails)
 */
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
+static int st_map_user_pages(struct kvec *iov, const unsigned int max_pages, 
+			     unsigned long uaddr, size_t count, int rw)
+{
+	return sgl_map_user_pages(iov, max_pages, uaddr, count, rw);
 }
 
 
 /* The following functions may be useful for a larger audience. */
-static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
+static int sgl_map_user_pages(struct kvec *iov, const unsigned int max_pages, 
 			      unsigned long uaddr, size_t count, int rw)
 {
 	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -4486,21 +4464,30 @@ static int sgl_map_user_pages(struct sca
 		flush_dcache_page(pages[i]);
         }
 
-	/* Populate the scatter/gather list */
-	sgl[0].page = pages[0]; 
-	sgl[0].offset = uaddr & ~PAGE_MASK;
+	/*
+	 * setup kvec - if we have a high mem page drop back to
+	 * !dio mode. For all other pages the block layer could
+	 * bounce for us so we do not need the dma flags.
+	 *
+	 * In the future we will use the block layer's DIO code
+	 * so none of this will be problem.
+	 */
+	if (PageHighMem(pages[0]))
+		goto out_unmap;
+	iov[0].iov_base = page_address(pages[0]) + (uaddr & ~PAGE_MASK);
 	if (nr_pages > 1) {
-		sgl[0].length = PAGE_SIZE - sgl[0].offset;
-		count -= sgl[0].length;
+		iov[0].iov_len = PAGE_SIZE - (uaddr & ~PAGE_MASK);
+		count -= iov[0].iov_len;
 		for (i=1; i < nr_pages ; i++) {
-			sgl[i].offset = 0;
-			sgl[i].page = pages[i]; 
-			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
+			if (PageHighMem(pages[i]))
+				goto out_unmap;
+			iov[i].iov_base = page_address(pages[i]); 
+			iov[i].iov_len = count < PAGE_SIZE ? count : PAGE_SIZE;
 			count -= PAGE_SIZE;
 		}
 	}
 	else {
-		sgl[0].length = count;
+		iov[0].iov_len = count;
 	}
 
 	kfree(pages);
@@ -4512,23 +4499,25 @@ static int sgl_map_user_pages(struct sca
 			page_cache_release(pages[j]);
 	}
 	kfree(pages);
-	return res;
+	return -ENOMEM;
 }
 
 
 /* And unmap them... */
-static int sgl_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
+static int sgl_unmap_user_pages(struct kvec *iov, const unsigned int nr_pages,
 				int dirtied)
 {
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		if (dirtied && !PageReserved(sgl[i].page))
-			SetPageDirty(sgl[i].page);
+		struct page *p = virt_to_page(iov[i].iov_base);
+
+		if (dirtied && !PageReserved(p))
+			SetPageDirty(p);
 		/* FIXME: cache flush missing for rw==READ
 		 * FIXME: call the correct reference counting function
 		 */
-		page_cache_release(sgl[i].page);
+		page_cache_release(p);
 	}
 
 	return 0;
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -4,6 +4,8 @@
 
 #include <linux/completion.h>
 #include <linux/kref.h>
+#include <linux/uio.h>
+#include <scsi/scsi_cmnd.h>
 
 /* Descriptor for analyzed sense data */
 struct st_cmdstatus {
@@ -17,6 +19,17 @@ struct st_cmdstatus {
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
@@ -28,22 +41,17 @@ struct st_buffer {
 	int read_pointer;
 	int writing;
 	int syscall_result;
-	struct scsi_request *last_SRpnt;
+	struct st_request *last_SRpnt;
 	struct st_cmdstatus cmdstat;
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
 	unsigned short orig_frp_segs;	/* number of segments allocated at first try */
 	unsigned short frp_segs;	/* number of buffer segments */
-	unsigned int frp_sg_current;	/* driver buffer length currently in s/g list */
-	struct st_buf_fragment *frp;	/* the allocated buffer fragment list */
-	struct scatterlist sg[1];	/* MUST BE last item */
-};
-
-/* The tape buffer fragment descriptor */
-struct st_buf_fragment {
-	struct page *page;
-	unsigned int length;
+	unsigned int frp_sg_current;	/* driver buffer length currently in s/g
+ list */
+	struct kvec *iov;		/* allocated iov */
+	struct kvec iov_req[1];		/* iov sent to scsi (must be last) */
 };
 
 /* The tape mode definition */


