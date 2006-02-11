From: Willem Riede <osst@riede.org>
Subject: Re: osst changes required to move forward to block request
Date: Sat, 11 Feb 2006 14:46:56 -0500
Message-ID: <1139687216l.24984l.0l@athena.riede.org>
References: <20060206131944.GA1769@lst.de>
	<1139274141l.7464l.1l@athena.riede.org>
	<20060207091254.GA11691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:7579 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S964781AbWBKTrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Feb 2006 14:47:06 -0500
In-Reply-To: <20060207091254.GA11691@infradead.org> (from hch@infradead.org
	on Tue Feb  7 04:12:55 2006)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 02/07/2006 04:12:55 AM, Christoph Hellwig wrote:
> On Mon, Feb 06, 2006 at 08:02:21PM -0500, Willem Riede wrote:
> 
> > But I will certainly help retire scsi_request. And anything else that is  
> > needed to keep up with proper kernel style. Let me know what those are, if 
> > you  would? I'll start looking at how st has changed, and will be back with 
> > any  questions I may have.
> 
> right now the above is the most urgent bit.  What would be nice but not
> required is a conversion to the sense handling helpers, similar to what
> st got (aka using the *normalize_sense functions and then dealing with the
> parsed sense buffer instead of the raw sense data)

Ok, so here is my first take at satisfying this request.
Be warned, that beyond compiling, and checking that the new module
doesn't immediately blow up, there hasn't yet been a lot of testing.

But this should allow you to comment on the changes, and move forward
with dropping scsi_request from the kernel code.

Signed-off-by: Willem Riede <osst@riede.org>

--- linux-2.6.15.3/drivers/scsi/osst.h	2006-02-06 18:36:47.000000000 -0500
+++ osst/drivers/scsi/osst.h	2006-02-11 13:30:27.000000000 -0500
@@ -518,7 +518,8 @@
   int writing;
   int midlevel_result;
   int syscall_result;
-  struct scsi_request *last_SRpnt;
+  struct osst_request *last_SRpnt;
+  struct st_cmdstatus cmdstat;
   unsigned char *b_data;
   os_aux_t *aux;               /* onstream AUX structure at end of each block     */
   unsigned short use_sg;       /* zero or number of s/g segments for this adapter */
@@ -626,6 +627,15 @@
   struct gendisk *drive;
 } ;
 
+/* scsi tape command */
+struct osst_request {
+	unsigned char cmd[MAX_COMMAND_SIZE];
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	int result;
+	struct osst_tape *stp;
+	struct completion *waiting;
+};
+
 /* Values of write_type */
 #define OS_WRITE_DATA      0
 #define OS_WRITE_EOD       1
--- linux-2.6.15.3/drivers/scsi/osst.c	2006-02-06 18:36:47.000000000 -0500
+++ osst/drivers/scsi/osst.c	2006-02-11 13:57:57.000000000 -0500
@@ -13,7 +13,7 @@
   order) Klaus Ehrenfried, Wolfgang Denk, Steve Hirsch, Andreas Koppenh"ofer,
   Michael Leodolter, Eyal Lebedinsky, J"org Weule, and Eric Youngdale.
 
-  Copyright 1992 - 2002 Kai Makisara / 2000 - 2004 Willem Riede
+  Copyright 1992 - 2002 Kai Makisara / 2000 - 2006 Willem Riede
 	 email osst@riede.org
 
   $Header: /cvsroot/osst/Driver/osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
@@ -24,7 +24,7 @@
 */
 
 static const char * cvsid = "$Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $";
-static const char * osst_version = "0.99.3";
+static const char * osst_version = "0.99.4";
 
 /* The "failure to reconnect" firmware bug */
 #define OSST_FW_NEED_POLL_MIN 10601 /*(107A)*/
@@ -70,7 +70,6 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
 
 #define ST_KILOBYTE 1024
 
@@ -179,16 +178,16 @@
 	}
 };
 
-static int osst_int_ioctl(struct osst_tape *STp, struct scsi_request ** aSRpnt,
+static int osst_int_ioctl(struct osst_tape *STp, struct osst_request ** aSRpnt,
 			    unsigned int cmd_in, unsigned long arg);
 
-static int osst_set_frame_position(struct osst_tape *STp, struct scsi_request ** aSRpnt, int frame, int skip);
+static int osst_set_frame_position(struct osst_tape *STp, struct osst_request ** aSRpnt, int frame, int skip);
 
-static int osst_get_frame_position(struct osst_tape *STp, struct scsi_request ** aSRpnt);
+static int osst_get_frame_position(struct osst_tape *STp, struct osst_request ** aSRpnt);
 
-static int osst_flush_write_buffer(struct osst_tape *STp, struct scsi_request ** aSRpnt);
+static int osst_flush_write_buffer(struct osst_tape *STp, struct osst_request ** aSRpnt);
 
-static int osst_write_error_recovery(struct osst_tape * STp, struct scsi_request ** aSRpnt, int pending);
+static int osst_write_error_recovery(struct osst_tape * STp, struct osst_request ** aSRpnt, int pending);
 
 static inline char *tape_name(struct osst_tape *tape)
 {
@@ -197,52 +196,84 @@
 

 /* Routines that handle the interaction with mid-layer SCSI routines */
 
+
+/* Normalize Sense */
+static void osst_analyze_sense(struct osst_request *SRpnt, struct st_cmdstatus *s)
+{
+	const u8 *ucp;
+	const u8 *sense = SRpnt->sense;
+
+	s->have_sense = scsi_normalize_sense(SRpnt->sense,
+				SCSI_SENSE_BUFFERSIZE, &s->sense_hdr);
+	s->flags = 0;
+
+	if (s->have_sense) {
+		s->deferred = 0;
+		s->remainder_valid =
+			scsi_get_sense_info_fld(sense, SCSI_SENSE_BUFFERSIZE, &s->uremainder64);
+		switch (sense[0] & 0x7f) {
+		case 0x71:
+			s->deferred = 1;
+		case 0x70:
+			s->fixed_format = 1;
+			s->flags = sense[2] & 0xe0;
+			break;
+		case 0x73:
+			s->deferred = 1;
+		case 0x72:
+			s->fixed_format = 0;
+			ucp = scsi_sense_desc_find(sense, SCSI_SENSE_BUFFERSIZE, 4);
+			s->flags = ucp ? (ucp[3] & 0xe0) : 0;
+			break;
+		}
+	}
+}
+
 /* Convert the result to success code */
-static int osst_chk_result(struct osst_tape * STp, struct scsi_request * SRpnt)
+static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 {
 	char *name = tape_name(STp);
-	int result = SRpnt->sr_result;
-	unsigned char * sense = SRpnt->sr_sense_buffer, scode;
+	int result = SRpnt->result;
+	u8 * sense = SRpnt->sense, scode;
 #if DEBUG
 	const char *stp;
 #endif
+	struct st_cmdstatus *cmdstatp;
 
-	if (!result) {
-		sense[0] = 0;    /* We don't have sense data if this byte is zero */
+	if (!result)
 		return 0;
-	}
-	if ((driver_byte(result) & DRIVER_MASK) == DRIVER_SENSE)
-		scode = sense[2] & 0x0f;
-	else {
-		sense[0] = 0;    /* We don't have sense data if this byte is zero */
+
+	cmdstatp = &STp->buffer->cmdstat;
+	osst_analyze_sense(SRpnt, cmdstatp);
+
+	if (cmdstatp->have_sense)
+		scode = STp->buffer->cmdstat.sense_hdr.sense_key;
+	else
 		scode = 0;
-	}
 #if DEBUG
 	if (debugging) {
-		printk(OSST_DEB_MSG "%s:D: Error: %x, cmd: %x %x %x %x %x %x Len: %d\n",
+		printk(OSST_DEB_MSG "%s:D: Error: %x, cmd: %x %x %x %x %x %x\n",
 		   name, result,
-		   SRpnt->sr_cmnd[0], SRpnt->sr_cmnd[1], SRpnt->sr_cmnd[2],
-		   SRpnt->sr_cmnd[3], SRpnt->sr_cmnd[4], SRpnt->sr_cmnd[5],
-		   SRpnt->sr_bufflen);
+		   SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
+		   SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (scode) printk(OSST_DEB_MSG "%s:D: Sense: %02x, ASC: %02x, ASCQ: %02x\n",
 			       	name, scode, sense[12], sense[13]);
-		if (driver_byte(result) & DRIVER_SENSE)
-			scsi_print_req_sense("osst ", SRpnt);
+		if (cmdstatp->have_sense)
+			__scsi_print_sense("osst ", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	}
 	else
 #endif
-	if (!(driver_byte(result) & DRIVER_SENSE) ||
-		((sense[0] & 0x70) == 0x70 &&
+	if (cmdstatp->have_sense && (
 		 scode != NO_SENSE &&
 		 scode != RECOVERED_ERROR &&
 /*      	 scode != UNIT_ATTENTION && */
 		 scode != BLANK_CHECK &&
 		 scode != VOLUME_OVERFLOW &&
-		 SRpnt->sr_cmnd[0] != MODE_SENSE &&
-		 SRpnt->sr_cmnd[0] != TEST_UNIT_READY)) { /* Abnormal conditions for tape */
-		if (driver_byte(result) & DRIVER_SENSE) {
+		 SRpnt->cmd[0] != MODE_SENSE &&
+		 SRpnt->cmd[0] != TEST_UNIT_READY)) { /* Abnormal conditions for tape */
+		if (cmdstatp->have_sense) {
 			printk(KERN_WARNING "%s:W: Command with sense data:\n", name);
-			scsi_print_req_sense("osst:", SRpnt);
+			__scsi_print_sense("osst ", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 		}
 		else {
 			static	int	notyetprinted = 1;
@@ -262,15 +293,14 @@
 	}
 	STp->pos_unknown |= STp->device->was_reset;
 
-	if ((sense[0] & 0x70) == 0x70 &&
-	     scode == RECOVERED_ERROR) {
+	if (cmdstatp->have_sense && scode == RECOVERED_ERROR) {
 		STp->recover_count++;
 		STp->recover_erreg++;
 #if DEBUG
 		if (debugging) {
-			if (SRpnt->sr_cmnd[0] == READ_6)
+			if (SRpnt->cmd[0] == READ_6)
 				stp = "read";
-			else if (SRpnt->sr_cmnd[0] == WRITE_6)
+			else if (SRpnt->cmd[0] == WRITE_6)
 				stp = "write";
 			else
 				stp = "ioctl";
@@ -286,74 +316,99 @@
 
 
 /* Wakeup from interrupt */
-static void osst_sleep_done (struct scsi_cmnd * SCpnt)
+static void osst_sleep_done(void *data, char *sense, int result, int resid)
 {
-	struct osst_tape * STp = container_of(SCpnt->request->rq_disk->private_data, struct osst_tape, driver);
-
-	if ((STp->buffer)->writing &&
-	    (SCpnt->sense_buffer[0] & 0x70) == 0x70 &&
-	    (SCpnt->sense_buffer[2] & 0x40)) {
-		/* EOM at write-behind, has all been written? */
-		if ((SCpnt->sense_buffer[2] & 0x0f) == VOLUME_OVERFLOW)
-			STp->buffer->midlevel_result = SCpnt->result; /* Error */
-		else
-			STp->buffer->midlevel_result = INT_MAX;       /* OK */
-	}
-	else
-		STp->buffer->midlevel_result = SCpnt->result;
-	SCpnt->request->rq_status = RQ_SCSI_DONE;
-	STp->buffer->last_SRpnt = SCpnt->sc_request;
+	struct osst_request *SRpnt = data;
+	struct osst_tape *STp = SRpnt->stp;
 
+	memcpy(SRpnt->sense, sense, SCSI_SENSE_BUFFERSIZE);
+	STp->buffer->cmdstat.midlevel_result = SRpnt->result = result;
 #if DEBUG
 	STp->write_pending = 0;
 #endif
-	complete(SCpnt->request->waiting);
+	if (SRpnt->waiting)
+		complete(SRpnt->waiting);
 }
 
+/* osst_request memory management */
+static struct osst_request *osst_allocate_request(void)
+{
+	return kzalloc(sizeof(struct osst_request), GFP_KERNEL);
+}
+
+static void osst_release_request(struct osst_request *streq)
+{
+	kfree(streq);
+}
 
 /* Do the scsi command. Waits until command performed if do_wait is true.
    Otherwise osst_write_behind_check() is used to check that the command
    has finished. */
-static	struct scsi_request * osst_do_scsi(struct scsi_request *SRpnt, struct osst_tape *STp, 
+static	struct osst_request * osst_do_scsi(struct osst_request *SRpnt, struct osst_tape *STp, 
 	unsigned char *cmd, int bytes, int direction, int timeout, int retries, int do_wait)
 {
 	unsigned char *bp;
+	unsigned short use_sg;
 #ifdef OSST_INJECT_ERRORS
 	static   int   inject = 0;
 	static   int   repeat = 0;
 #endif
+	struct completion *waiting;
+
+	/* if async, make sure there's no command outstanding */
+	if (!do_wait && ((STp->buffer)->last_SRpnt)) {
+		printk(KERN_ERR "%s: Async command already active.\n",
+		       tape_name(STp));
+		if (signal_pending(current))
+			(STp->buffer)->syscall_result = (-EINTR);
+		else
+			(STp->buffer)->syscall_result = (-EBUSY);
+		return NULL;
+	}
+
 	if (SRpnt == NULL) {
-		if ((SRpnt = scsi_allocate_request(STp->device, GFP_ATOMIC)) == NULL) {
-			printk(KERN_ERR "%s:E: Can't get SCSI request.\n", tape_name(STp));
+		SRpnt = osst_allocate_request();
+		if (SRpnt == NULL) {
+			printk(KERN_ERR "%s: Can't allocate SCSI request.\n",
+				     tape_name(STp));
 			if (signal_pending(current))
 				(STp->buffer)->syscall_result = (-EINTR);
 			else
 				(STp->buffer)->syscall_result = (-EBUSY);
 			return NULL;
 		}
+		SRpnt->stp = STp;
 	}
 
-        init_completion(&STp->wait);
-	SRpnt->sr_use_sg = (bytes > (STp->buffer)->sg[0].length) ?
-				    (STp->buffer)->use_sg : 0;
-	if (SRpnt->sr_use_sg) {
+	/* If async IO, set last_SRpnt. This ptr tells write_behind_check
+	   which IO is outstanding. It's nulled out when the IO completes. */
+	if (!do_wait)
+		(STp->buffer)->last_SRpnt = SRpnt;
+
+	waiting = &STp->wait;
+	init_completion(waiting);
+	SRpnt->waiting = waiting;
+
+	use_sg = (bytes > STp->buffer->sg[0].length) ? STp->buffer->use_sg : 0;
+	if (use_sg) {
 		bp = (char *)&(STp->buffer->sg[0]);
-		if (STp->buffer->sg_segs < SRpnt->sr_use_sg)
-			SRpnt->sr_use_sg = STp->buffer->sg_segs;
+		if (STp->buffer->sg_segs < use_sg)
+			use_sg = STp->buffer->sg_segs;
 	}
 	else
 		bp = (STp->buffer)->b_data;
-	SRpnt->sr_data_direction = direction;
-	SRpnt->sr_cmd_len = 0;
-	SRpnt->sr_request->waiting = &(STp->wait);
-	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
-	SRpnt->sr_request->rq_disk = STp->drive;
-
-	scsi_do_req(SRpnt, (void *)cmd, bp, bytes, osst_sleep_done, timeout, retries);
-
-	if (do_wait) {
-		wait_for_completion(SRpnt->sr_request->waiting);
-		SRpnt->sr_request->waiting = NULL;
+
+	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
+	STp->buffer->cmdstat.have_sense = 0;
+	STp->buffer->syscall_result = 0;
+
+	if (scsi_execute_async(STp->device, cmd, COMMAND_SIZE(cmd[0]), direction, bp, bytes,
+			use_sg, timeout, retries, SRpnt, osst_sleep_done, GFP_KERNEL))
+		/* could not allocate the buffer or request was too large */
+		(STp->buffer)->syscall_result = (-EBUSY);
+	else if (do_wait) {
+		wait_for_completion(waiting);
+		SRpnt->waiting = NULL;
 		STp->buffer->syscall_result = osst_chk_result(STp, SRpnt);
 #ifdef OSST_INJECT_ERRORS
 		if (STp->buffer->syscall_result == 0 &&
@@ -386,21 +441,22 @@
 		STp->nbr_finished++;
 #endif
 	wait_for_completion(&(STp->wait));
-	(STp->buffer)->last_SRpnt->sr_request->waiting = NULL;
+	STp->buffer->last_SRpnt->waiting = NULL;
 
 	STp->buffer->syscall_result = osst_chk_result(STp, STp->buffer->last_SRpnt);
 
-	if ((STp->buffer)->syscall_result)
-		(STp->buffer)->syscall_result =
-			osst_write_error_recovery(STp, &((STp->buffer)->last_SRpnt), 1);
+	if (STp->buffer->syscall_result)
+		STp->buffer->syscall_result =
+			osst_write_error_recovery(STp, &(STp->buffer->last_SRpnt), 1);
 	else
 		STp->first_frame_position++;
 
-	scsi_release_request((STp->buffer)->last_SRpnt);
+	osst_release_request(STp->buffer->last_SRpnt);
 
 	if (STbuffer->writing < STbuffer->buffer_bytes)
 		printk(KERN_WARNING "osst :A: write_behind_check: something left in buffer!\n");
 
+	STbuffer->last_SRpnt = NULL;
 	STbuffer->buffer_bytes -= STbuffer->writing;
 	STbuffer->writing = 0;
 
@@ -609,11 +665,11 @@
 /*
  * Wait for the unit to become Ready
  */
-static int osst_wait_ready(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_wait_ready(struct osst_tape * STp, struct osst_request ** aSRpnt,
 				 unsigned timeout, int initial_delay)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	unsigned long		startwait = jiffies;
 #if DEBUG
 	int			dbg  = debugging;
@@ -633,10 +689,10 @@
 	if (!SRpnt) return (-EBUSY);
 
 	while ( STp->buffer->syscall_result && time_before(jiffies, startwait + timeout*HZ) &&
-	       (( SRpnt->sr_sense_buffer[2]  == 2 && SRpnt->sr_sense_buffer[12] == 4    &&
-		 (SRpnt->sr_sense_buffer[13] == 1 || SRpnt->sr_sense_buffer[13] == 8)    ) ||
-		( SRpnt->sr_sense_buffer[2]  == 6 && SRpnt->sr_sense_buffer[12] == 0x28 &&
-		  SRpnt->sr_sense_buffer[13] == 0                                        )  )) {
+	       (( SRpnt->sense[2]  == 2 && SRpnt->sense[12] == 4    &&
+		 (SRpnt->sense[13] == 1 || SRpnt->sense[13] == 8)    ) ||
+		( SRpnt->sense[2]  == 6 && SRpnt->sense[12] == 0x28 &&
+		  SRpnt->sense[13] == 0                                        )  )) {
 #if DEBUG
 	    if (debugging) {
 		printk(OSST_DEB_MSG "%s:D: Sleeping in onstream wait ready\n", name);
@@ -660,8 +716,8 @@
 #if DEBUG
 	    printk(OSST_DEB_MSG "%s:D: Abnormal exit from onstream wait ready\n", name);
 	    printk(OSST_DEB_MSG "%s:D: Result = %d, Sense: 0=%02x, 2=%02x, 12=%02x, 13=%02x\n", name,
-			STp->buffer->syscall_result, SRpnt->sr_sense_buffer[0], SRpnt->sr_sense_buffer[2],
-			SRpnt->sr_sense_buffer[12], SRpnt->sr_sense_buffer[13]);
+			STp->buffer->syscall_result, SRpnt->sense[0], SRpnt->sense[2],
+			SRpnt->sense[12], SRpnt->sense[13]);
 #endif
 	    return (-EIO);
 	}
@@ -674,10 +730,10 @@
 /*
  * Wait for a tape to be inserted in the unit
  */
-static int osst_wait_for_medium(struct osst_tape * STp, struct scsi_request ** aSRpnt, unsigned timeout)
+static int osst_wait_for_medium(struct osst_tape * STp, struct osst_request ** aSRpnt, unsigned timeout)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	unsigned long		startwait = jiffies;
 #if DEBUG
 	int			dbg = debugging;
@@ -694,8 +750,7 @@
 	if (!SRpnt) return (-EBUSY);
 
 	while ( STp->buffer->syscall_result && time_before(jiffies, startwait + timeout*HZ) &&
-		SRpnt->sr_sense_buffer[2]  == 2 && SRpnt->sr_sense_buffer[12] == 0x3a       &&
-	        SRpnt->sr_sense_buffer[13] == 0                                             ) {
+		SRpnt->sense[2] == 2 && SRpnt->sense[12] == 0x3a && SRpnt->sense[13] == 0  ) {
 #if DEBUG
 	    if (debugging) {
 		printk(OSST_DEB_MSG "%s:D: Sleeping in onstream wait medium\n", name);
@@ -714,13 +769,13 @@
 #if DEBUG
 	debugging = dbg;
 #endif
-	if ( STp->buffer->syscall_result     && SRpnt->sr_sense_buffer[2]  != 2 &&
-	     SRpnt->sr_sense_buffer[12] != 4 && SRpnt->sr_sense_buffer[13] == 1) {
+	if ( STp->buffer->syscall_result     && SRpnt->sense[2]  != 2 &&
+	     SRpnt->sense[12] != 4 && SRpnt->sense[13] == 1) {
 #if DEBUG
 	    printk(OSST_DEB_MSG "%s:D: Abnormal exit from onstream wait medium\n", name);
 	    printk(OSST_DEB_MSG "%s:D: Result = %d, Sense: 0=%02x, 2=%02x, 12=%02x, 13=%02x\n", name,
-			STp->buffer->syscall_result, SRpnt->sr_sense_buffer[0], SRpnt->sr_sense_buffer[2],
-			SRpnt->sr_sense_buffer[12], SRpnt->sr_sense_buffer[13]);
+			STp->buffer->syscall_result, SRpnt->sense[0], SRpnt->sense[2],
+			SRpnt->sense[12], SRpnt->sense[13]);
 #endif
 	    return 0;
 	}
@@ -730,7 +785,7 @@
 	return 1;
 }
 
-static int osst_position_tape_and_confirm(struct osst_tape * STp, struct scsi_request ** aSRpnt, int frame)
+static int osst_position_tape_and_confirm(struct osst_tape * STp, struct osst_request ** aSRpnt, int frame)
 {
 	int	retval;
 
@@ -744,10 +799,10 @@
 /*
  * Wait for write(s) to complete
  */
-static int osst_flush_drive_buffer(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_flush_drive_buffer(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	int			result = 0;
 	int			delay  = OSST_WAIT_WRITE_COMPLETE;
 #if DEBUG
@@ -764,8 +819,8 @@
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
 	if (STp->buffer->syscall_result) {
-		if ((SRpnt->sr_sense_buffer[2] & 0x0f) == 2 && SRpnt->sr_sense_buffer[12] == 4) {
-			if (SRpnt->sr_sense_buffer[13] == 8) {
+		if ((SRpnt->sense[2] & 0x0f) == 2 && SRpnt->sense[12] == 4) {
+			if (SRpnt->sense[13] == 8) {
 				delay = OSST_WAIT_LONG_WRITE_COMPLETE;
 			}
 		} else
@@ -778,7 +833,7 @@
 }
 
 #define OSST_POLL_PER_SEC 10
-static int osst_wait_frame(struct osst_tape * STp, struct scsi_request ** aSRpnt, int curr, int minlast, int to)
+static int osst_wait_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int curr, int minlast, int to)
 {
 	unsigned long	startwait = jiffies;
 	char	      * name      = tape_name(STp);
@@ -833,9 +888,9 @@
 	return -EBUSY;
 }
 
-static int osst_recover_wait_frame(struct osst_tape * STp, struct scsi_request ** aSRpnt, int writing)
+static int osst_recover_wait_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int writing)
 {
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	unsigned long   	startwait = jiffies;
 	int			retval    = 1;
@@ -856,7 +911,7 @@
 
 		while (retval && time_before (jiffies, startwait + 5*60*HZ)) {
 
-			if (STp->buffer->syscall_result && (SRpnt->sr_sense_buffer[2] & 0x0f) != 2) {
+			if (STp->buffer->syscall_result && (SRpnt->sense[2] & 0x0f) != 2) {
 
 				/* some failure - not just not-ready */
 				retval = osst_write_error_recovery(STp, aSRpnt, 0);
@@ -881,9 +936,9 @@
 		if (STp->buffer->syscall_result)
 			printk(KERN_WARNING
 				"%s:W: Recover_wait_frame(read) cannot handle %02x:%02x:%02x\n", name,
-					(*aSRpnt)->sr_sense_buffer[ 2] & 0x0f,
-					(*aSRpnt)->sr_sense_buffer[12],
-					(*aSRpnt)->sr_sense_buffer[13]);
+					(*aSRpnt)->sense[ 2] & 0x0f,
+					(*aSRpnt)->sense[12],
+					(*aSRpnt)->sense[13]);
 
 	return retval;
 }
@@ -891,10 +946,10 @@
 /*
  * Read the next OnStream tape frame at the current location
  */
-static int osst_read_frame(struct osst_tape * STp, struct scsi_request ** aSRpnt, int timeout)
+static int osst_read_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int timeout)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	int			retval = 0;
 #if DEBUG
 	os_aux_t	      * aux    = STp->buffer->aux;
@@ -932,10 +987,10 @@
 	    if (debugging)
 		printk(OSST_DEB_MSG "%s:D: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
 		   name,
-		   SRpnt->sr_sense_buffer[0], SRpnt->sr_sense_buffer[1],
-		   SRpnt->sr_sense_buffer[2], SRpnt->sr_sense_buffer[3],
-		   SRpnt->sr_sense_buffer[4], SRpnt->sr_sense_buffer[5],
-		   SRpnt->sr_sense_buffer[6], SRpnt->sr_sense_buffer[7]);
+		   SRpnt->sense[0], SRpnt->sense[1],
+		   SRpnt->sense[2], SRpnt->sense[3],
+		   SRpnt->sense[4], SRpnt->sense[5],
+		   SRpnt->sense[6], SRpnt->sense[7]);
 #endif
 	}
 	else
@@ -962,10 +1017,10 @@
 	return (retval);
 }
 
-static int osst_initiate_read(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_initiate_read(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	struct st_partstat    * STps   = &(STp->ps[STp->partition]);
-	struct scsi_request   * SRpnt  ;
+	struct osst_request   * SRpnt  ;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	int			retval = 0;
 	char		      * name   = tape_name(STp);
@@ -999,7 +1054,7 @@
 	return retval;
 }
 
-static int osst_get_logical_frame(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_get_logical_frame(struct osst_tape * STp, struct osst_request ** aSRpnt,
 						int frame_seq_number, int quiet)
 {
 	struct st_partstat * STps  = &(STp->ps[STp->partition]);
@@ -1128,7 +1183,7 @@
 	return (STps->eof);
 }
 
-static int osst_seek_logical_blk(struct osst_tape * STp, struct scsi_request ** aSRpnt, int logical_blk_num)
+static int osst_seek_logical_blk(struct osst_tape * STp, struct osst_request ** aSRpnt, int logical_blk_num)
 {
         struct st_partstat * STps = &(STp->ps[STp->partition]);
 	char		   * name = tape_name(STp);
@@ -1237,7 +1292,7 @@
 #define OSST_SECTOR_SHIFT 9
 #define OSST_SECTOR_MASK  0x03F
 
-static int osst_get_sector(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_get_sector(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	int	sector;
 #if DEBUG
@@ -1267,7 +1322,7 @@
 	return sector;
 }
 
-static int osst_seek_sector(struct osst_tape * STp, struct scsi_request ** aSRpnt, int sector)
+static int osst_seek_sector(struct osst_tape * STp, struct osst_request ** aSRpnt, int sector)
 {
         struct st_partstat * STps   = &(STp->ps[STp->partition]);
 	int		     frame  = sector >> OSST_FRAME_SHIFT,
@@ -1330,10 +1385,10 @@
  * Precondition for this function to work: all frames in the
  * drive's buffer must be of one type (DATA, MARK or EOD)!
  */
-static int osst_read_back_buffer_and_rewrite(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_read_back_buffer_and_rewrite(struct osst_tape * STp, struct osst_request ** aSRpnt,
 						unsigned int frame, unsigned int skip, int pending)
 {
-	struct scsi_request   * SRpnt = * aSRpnt;
+	struct osst_request   * SRpnt = * aSRpnt;
 	unsigned char	      * buffer, * p;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
 	int			flag, new_frame, i;
@@ -1477,8 +1532,8 @@
 					SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout,
 												MAX_RETRIES, 1);
 
-					if (SRpnt->sr_sense_buffer[2] == 2 && SRpnt->sr_sense_buffer[12] == 4 &&
-					    (SRpnt->sr_sense_buffer[13] == 1 || SRpnt->sr_sense_buffer[13] == 8)) {
+					if (SRpnt->sense[2] == 2 && SRpnt->sense[12] == 4 &&
+					    (SRpnt->sense[13] == 1 || SRpnt->sense[13] == 8)) {
 						/* in the process of becoming ready */
 						msleep(100);
 						continue;
@@ -1495,17 +1550,17 @@
 		}
 		*aSRpnt = SRpnt;
 		if (flag) {
-			if ((SRpnt->sr_sense_buffer[ 2] & 0x0f) == 13 &&
-			     SRpnt->sr_sense_buffer[12]         ==  0 &&
-			     SRpnt->sr_sense_buffer[13]         ==  2) {
+			if ((SRpnt->sense[ 2] & 0x0f) == 13 &&
+			     SRpnt->sense[12]         ==  0 &&
+			     SRpnt->sense[13]         ==  2) {
 				printk(KERN_ERR "%s:E: Volume overflow in write error recovery\n", name);
 				vfree(buffer);
 				return (-EIO);			/* hit end of tape = fail */
 			}
-			i = ((SRpnt->sr_sense_buffer[3] << 24) |
-			     (SRpnt->sr_sense_buffer[4] << 16) |
-			     (SRpnt->sr_sense_buffer[5] <<  8) |
-			      SRpnt->sr_sense_buffer[6]        ) - new_frame;
+			i = ((SRpnt->sense[3] << 24) |
+			     (SRpnt->sense[4] << 16) |
+			     (SRpnt->sense[5] <<  8) |
+			      SRpnt->sense[6]        ) - new_frame;
 			p = &buffer[i * OS_DATA_SIZE];
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Additional write error at %d\n", name, new_frame+i);
@@ -1528,11 +1583,11 @@
 	return 0;
 }
 
-static int osst_reposition_and_retry(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_reposition_and_retry(struct osst_tape * STp, struct osst_request ** aSRpnt,
 					unsigned int frame, unsigned int skip, int pending)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	char		      * name      = tape_name(STp);
 	int			expected  = 0;
 	int			attempts  = 1000 / skip;
@@ -1584,9 +1639,9 @@
 			*aSRpnt = SRpnt;
 
 			if (STp->buffer->syscall_result) {		/* additional write error */
-				if ((SRpnt->sr_sense_buffer[ 2] & 0x0f) == 13 &&
-				     SRpnt->sr_sense_buffer[12]         ==  0 &&
-				     SRpnt->sr_sense_buffer[13]         ==  2) {
+				if ((SRpnt->sense[ 2] & 0x0f) == 13 &&
+				     SRpnt->sense[12]         ==  0 &&
+				     SRpnt->sense[13]         ==  2) {
 					printk(KERN_ERR
 					       "%s:E: Volume overflow in write error recovery\n",
 					       name);
@@ -1631,9 +1686,9 @@
  * Error recovery algorithm for the OnStream tape.
  */
 
-static int osst_write_error_recovery(struct osst_tape * STp, struct scsi_request ** aSRpnt, int pending)
+static int osst_write_error_recovery(struct osst_tape * STp, struct osst_request ** aSRpnt, int pending)
 {
-	struct scsi_request * SRpnt  = * aSRpnt;
+	struct osst_request * SRpnt  = * aSRpnt;
 	struct st_partstat  * STps   = & STp->ps[STp->partition];
 	char		    * name   = tape_name(STp);
 	int		      retval = 0;
@@ -1642,20 +1697,20 @@
 
 	rw_state = STps->rw;
 
-	if ((SRpnt->sr_sense_buffer[ 2] & 0x0f) != 3
-	  || SRpnt->sr_sense_buffer[12]         != 12
-	  || SRpnt->sr_sense_buffer[13]         != 0) {
+	if ((SRpnt->sense[ 2] & 0x0f) != 3
+	  || SRpnt->sense[12]         != 12
+	  || SRpnt->sense[13]         != 0) {
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Write error recovery cannot handle %02x:%02x:%02x\n", name,
-			SRpnt->sr_sense_buffer[2], SRpnt->sr_sense_buffer[12], SRpnt->sr_sense_buffer[13]);
+			SRpnt->sense[2], SRpnt->sense[12], SRpnt->sense[13]);
 #endif
 		return (-EIO);
 	}
-	frame =	(SRpnt->sr_sense_buffer[3] << 24) |
-		(SRpnt->sr_sense_buffer[4] << 16) |
-		(SRpnt->sr_sense_buffer[5] <<  8) |
-		 SRpnt->sr_sense_buffer[6];
-	skip  =  SRpnt->sr_sense_buffer[9];
+	frame =	(SRpnt->sense[3] << 24) |
+		(SRpnt->sense[4] << 16) |
+		(SRpnt->sense[5] <<  8) |
+		 SRpnt->sense[6];
+	skip  =  SRpnt->sense[9];
  
 #if DEBUG
 	printk(OSST_DEB_MSG "%s:D: Detected physical bad frame at %u, advised to skip %d\n", name, frame, skip);
@@ -1710,7 +1765,7 @@
 	return retval;
 }
 
-static int osst_space_over_filemarks_backward(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_space_over_filemarks_backward(struct osst_tape * STp, struct osst_request ** aSRpnt,
 								 int mt_op, int mt_count)
 {
 	char  * name = tape_name(STp);
@@ -1809,7 +1864,7 @@
  *
  * Just scans for the filemark sequentially.
  */
-static int osst_space_over_filemarks_forward_slow(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_space_over_filemarks_forward_slow(struct osst_tape * STp, struct osst_request ** aSRpnt,
 								     int mt_op, int mt_count)
 {
 	int	cnt = 0;
@@ -1863,7 +1918,7 @@
 /*
  * Fast linux specific version of OnStream FSF
  */
-static int osst_space_over_filemarks_forward_fast(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_space_over_filemarks_forward_fast(struct osst_tape * STp, struct osst_request ** aSRpnt,
 								     int mt_op, int mt_count)
 {
 	char  * name = tape_name(STp);
@@ -2014,10 +2069,10 @@
  * to test the error recovery mechanism.
  */
 #if DEBUG
-static void osst_set_retries(struct osst_tape * STp, struct scsi_request ** aSRpnt, int retries)
+static void osst_set_retries(struct osst_tape * STp, struct osst_request ** aSRpnt, int retries)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt  = * aSRpnt;
+	struct osst_request   * SRpnt  = * aSRpnt;
 	char		      * name   = tape_name(STp);
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
@@ -2046,7 +2101,7 @@
 #endif
 
 
-static int osst_write_filemark(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_write_filemark(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	int	result;
 	int	this_mark_ppos = STp->first_frame_position;
@@ -2074,7 +2129,7 @@
 	return result;
 }
 
-static int osst_write_eod(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_write_eod(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	int	result;
 #if DEBUG
@@ -2097,7 +2152,7 @@
 	return result;
 }
 
-static int osst_write_filler(struct osst_tape * STp, struct scsi_request ** aSRpnt, int where, int count)
+static int osst_write_filler(struct osst_tape * STp, struct osst_request ** aSRpnt, int where, int count)
 {
 	char * name = tape_name(STp);
 
@@ -2122,7 +2177,7 @@
 	return osst_flush_drive_buffer(STp, aSRpnt);
 }
 
-static int __osst_write_header(struct osst_tape * STp, struct scsi_request ** aSRpnt, int where, int count)
+static int __osst_write_header(struct osst_tape * STp, struct osst_request ** aSRpnt, int where, int count)
 {
 	char * name = tape_name(STp);
 	int     result;
@@ -2149,7 +2204,7 @@
 	return result;
 }
 
-static int osst_write_header(struct osst_tape * STp, struct scsi_request ** aSRpnt, int locate_eod)
+static int osst_write_header(struct osst_tape * STp, struct osst_request ** aSRpnt, int locate_eod)
 {
 	os_header_t * header;
 	int	      result;
@@ -2223,7 +2278,7 @@
 	return result;
 }
 
-static int osst_reset_header(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_reset_header(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	if (STp->header_cache != NULL)
 		memset(STp->header_cache, 0, sizeof(os_header_t));
@@ -2236,7 +2291,7 @@
 	return osst_write_header(STp, aSRpnt, 1);
 }
 
-static int __osst_analyze_headers(struct osst_tape * STp, struct scsi_request ** aSRpnt, int ppos)
+static int __osst_analyze_headers(struct osst_tape * STp, struct osst_request ** aSRpnt, int ppos)
 {
 	char        * name = tape_name(STp);
 	os_header_t * header;
@@ -2413,7 +2468,7 @@
 	return 1;
 }
 
-static int osst_analyze_headers(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_analyze_headers(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	int	position, ppos;
 	int	first, last;
@@ -2468,7 +2523,7 @@
 	return 1;
 }
 
-static int osst_verify_position(struct osst_tape * STp, struct scsi_request ** aSRpnt)
+static int osst_verify_position(struct osst_tape * STp, struct osst_request ** aSRpnt)
 {
 	int	frame_position  = STp->first_frame_position;
 	int	frame_seq_numbr = STp->frame_seq_number;
@@ -2544,11 +2599,11 @@
 /*
  * Configure the OnStream SCII tape drive for default operation
  */
-static int osst_configure_onstream(struct osst_tape *STp, struct scsi_request ** aSRpnt)
+static int osst_configure_onstream(struct osst_tape *STp, struct osst_request ** aSRpnt)
 {
 	unsigned char                  cmd[MAX_COMMAND_SIZE];
 	char                         * name = tape_name(STp);
-	struct scsi_request                 * SRpnt = * aSRpnt;
+	struct osst_request          * SRpnt = * aSRpnt;
 	osst_mode_parameter_header_t * header;
 	osst_block_size_page_t       * bs;
 	osst_capabilities_page_t     * cp;
@@ -2715,7 +2770,7 @@
 
 /* Step over EOF if it has been inadvertently crossed (ioctl not used because
    it messes up the block number). */
-static int cross_eof(struct osst_tape *STp, struct scsi_request ** aSRpnt, int forward)
+static int cross_eof(struct osst_tape *STp, struct osst_request ** aSRpnt, int forward)
 {
 	int	result;
 	char  * name = tape_name(STp);
@@ -2744,10 +2799,10 @@
 
 /* Get the tape position. */
 
-static int osst_get_frame_position(struct osst_tape *STp, struct scsi_request ** aSRpnt)
+static int osst_get_frame_position(struct osst_tape *STp, struct osst_request ** aSRpnt)
 {
 	unsigned char		scmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	int			result = 0;
 	char    	      * name   = tape_name(STp);
 
@@ -2772,14 +2827,14 @@
 	*aSRpnt = SRpnt;
 
 	if (STp->buffer->syscall_result)
-		result = ((SRpnt->sr_sense_buffer[2] & 0x0f) == 3) ? -EIO : -EINVAL;	/* 3: Write Error */
+		result = ((SRpnt->sense[2] & 0x0f) == 3) ? -EIO : -EINVAL;	/* 3: Write Error */
 
 	if (result == -EINVAL)
 		printk(KERN_ERR "%s:E: Can't read tape position.\n", name);
 	else {
 		if (result == -EIO) {	/* re-read position - this needs to preserve media errors */
 			unsigned char mysense[16];
-			memcpy (mysense, SRpnt->sr_sense_buffer, 16);
+			memcpy (mysense, SRpnt->sense, 16);
 			memset (scmd, 0, MAX_COMMAND_SIZE);
 			scmd[0] = READ_POSITION;
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
@@ -2788,10 +2843,10 @@
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Reread position, reason=[%02x:%02x:%02x], result=[%s%02x:%02x:%02x]\n",
 					name, mysense[2], mysense[12], mysense[13], STp->buffer->syscall_result?"":"ok:",
-					SRpnt->sr_sense_buffer[2],SRpnt->sr_sense_buffer[12],SRpnt->sr_sense_buffer[13]);
+					SRpnt->sense[2],SRpnt->sense[12],SRpnt->sense[13]);
 #endif
 			if (!STp->buffer->syscall_result)
-				memcpy (SRpnt->sr_sense_buffer, mysense, 16);
+				memcpy (SRpnt->sense, mysense, 16);
 			else
 				printk(KERN_WARNING "%s:W: Double error in get position\n", name);
 		}
@@ -2828,10 +2883,10 @@
 
 
 /* Set the tape block */
-static int osst_set_frame_position(struct osst_tape *STp, struct scsi_request ** aSRpnt, int ppos, int skip)
+static int osst_set_frame_position(struct osst_tape *STp, struct osst_request ** aSRpnt, int ppos, int skip)
 {
 	unsigned char		scmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	struct st_partstat    * STps;
 	int			result = 0;
 	int			pp     = (ppos == 3000 && !skip)? 0 : ppos;
@@ -2886,7 +2941,7 @@
 	return result;
 }
 
-static int osst_write_trailer(struct osst_tape *STp, struct scsi_request ** aSRpnt, int leave_at_EOT)
+static int osst_write_trailer(struct osst_tape *STp, struct osst_request ** aSRpnt, int leave_at_EOT)
 {
 	struct st_partstat * STps = &(STp->ps[STp->partition]);
 	int result = 0;
@@ -2913,12 +2968,12 @@
 /* osst versions of st functions - augmented and stripped to suit OnStream only */
 
 /* Flush the write buffer (never need to write if variable blocksize). */
-static int osst_flush_write_buffer(struct osst_tape *STp, struct scsi_request ** aSRpnt)
+static int osst_flush_write_buffer(struct osst_tape *STp, struct osst_request ** aSRpnt)
 {
 	int			offset, transfer, blks = 0;
 	int			result = 0;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt = *aSRpnt;
+	struct osst_request   * SRpnt = *aSRpnt;
 	struct st_partstat    * STps;
 	char		      * name = tape_name(STp);
 
@@ -2926,13 +2981,13 @@
 		if (SRpnt == (STp->buffer)->last_SRpnt)
 #if DEBUG
 			{ printk(OSST_DEB_MSG
-	 "%s:D: aSRpnt points to scsi_request that write_behind_check will release -- cleared\n", name);
+	 "%s:D: aSRpnt points to osst_request that write_behind_check will release -- cleared\n", name);
 #endif
 			*aSRpnt = SRpnt = NULL;
 #if DEBUG
 			} else if (SRpnt)
 				printk(OSST_DEB_MSG
-	 "%s:D: aSRpnt does not point to scsi_request that write_behind_check will release -- strange\n", name);
+	 "%s:D: aSRpnt does not point to osst_request that write_behind_check will release -- strange\n", name);
 #endif	
 		osst_write_behind_check(STp);
 		if ((STp->buffer)->syscall_result) {
@@ -3010,12 +3065,12 @@
 #if DEBUG
 			printk(OSST_DEB_MSG
 				"%s:D: write sense [0]=0x%02x [2]=%02x [12]=%02x [13]=%02x\n",
-				name, SRpnt->sr_sense_buffer[0], SRpnt->sr_sense_buffer[2],
-				SRpnt->sr_sense_buffer[12], SRpnt->sr_sense_buffer[13]);
+				name, SRpnt->sense[0], SRpnt->sense[2],
+				SRpnt->sense[12], SRpnt->sense[13]);
 #endif
-			if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-			    (SRpnt->sr_sense_buffer[2] & 0x40) && /* FIXME - SC-30 drive doesn't assert EOM bit */
-			    (SRpnt->sr_sense_buffer[2] & 0x0f) == NO_SENSE) {
+			if ((SRpnt->sense[0] & 0x70) == 0x70 &&
+			    (SRpnt->sense[2] & 0x40) && /* FIXME - SC-30 drive doesn't assert EOM bit */
+			    (SRpnt->sense[2] & 0x0f) == NO_SENSE) {
 				STp->dirty = 0;
 				(STp->buffer)->buffer_bytes = 0;
 				result = (-ENOSPC);
@@ -3043,7 +3098,7 @@
 
 /* Flush the tape buffer. The tape will be positioned correctly unless
    seek_next is true. */
-static int osst_flush_buffer(struct osst_tape * STp, struct scsi_request ** aSRpnt, int seek_next)
+static int osst_flush_buffer(struct osst_tape * STp, struct osst_request ** aSRpnt, int seek_next)
 {
 	struct st_partstat * STps;
 	int    backspace = 0, result = 0;
@@ -3105,10 +3160,10 @@
 	return result;
 }
 
-static int osst_write_frame(struct osst_tape * STp, struct scsi_request ** aSRpnt, int synchronous)
+static int osst_write_frame(struct osst_tape * STp, struct osst_request ** aSRpnt, int synchronous)
 {
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt;
+	struct osst_request   * SRpnt;
 	int			blks;
 #if DEBUG
 	char		      * name = tape_name(STp);
@@ -3169,9 +3224,9 @@
 			if (debugging)
 				printk(OSST_DEB_MSG "%s:D: Error on write:\n", name);
 #endif
-			if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-			    (SRpnt->sr_sense_buffer[2] & 0x40)) {
-				if ((SRpnt->sr_sense_buffer[2] & 0x0f) == VOLUME_OVERFLOW)
+			if ((SRpnt->sense[0] & 0x70) == 0x70 &&
+			    (SRpnt->sense[2] & 0x40)) {
+				if ((SRpnt->sense[2] & 0x0f) == VOLUME_OVERFLOW)
 					return (-ENOSPC);
 			}
 			else {
@@ -3188,7 +3243,7 @@
 	return 0;
 }
 
-/* Lock or unlock the drive door. Don't use when struct scsi_request allocated. */
+/* Lock or unlock the drive door. Don't use when struct osst_request allocated. */
 static int do_door_lock(struct osst_tape * STp, int do_lock)
 {
 	int retval, cmd;
@@ -3236,7 +3291,7 @@
 	int		      write_threshold;
 	int		      doing_write = 0;
 	const char   __user * b_point;
-	struct scsi_request * SRpnt = NULL;
+	struct osst_request * SRpnt = NULL;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
 	struct osst_tape    * STp  = filp->private_data;
@@ -3427,7 +3482,7 @@
 #if DEBUG
 	if (debugging)
 		printk(OSST_DEB_MSG "%s:D: Writing %d bytes to file %d block %d lblk %d fseq %d fppos %d\n",
-				name, count, STps->drv_file, STps->drv_block,
+				name, (int) count, STps->drv_file, STps->drv_block,
 				STp->logical_blk_num, STp->frame_seq_number, STp->first_frame_position);
 #endif
 	b_point = buf;
@@ -3463,7 +3518,7 @@
 #if DEBUG
 				if (debugging)
 				      printk(OSST_DEB_MSG "%s:D: EOM with %d bytes unwritten.\n",
-							     name, transfer);
+							     name, (int) transfer);
 #endif
 			}
 			else {
@@ -3481,7 +3536,7 @@
 			
 		if (retval < 0) {
 			if (SRpnt != NULL) {
-				scsi_release_request(SRpnt);
+				osst_release_request(SRpnt);
 				SRpnt = NULL;
 			}
 			STp->buffer->buffer_bytes = 0;
@@ -3543,7 +3598,7 @@
 	retval = total;
 
 out:
-	if (SRpnt != NULL) scsi_release_request(SRpnt);
+	if (SRpnt != NULL) osst_release_request(SRpnt);
 
 	up(&STp->lock);
 
@@ -3559,7 +3614,7 @@
 	int		      special;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
-	struct scsi_request * SRpnt = NULL;
+	struct osst_request * SRpnt = NULL;
 	struct osst_tape    * STp   = filp->private_data;
 	char		    * name  = tape_name(STp);
 
@@ -3667,7 +3722,7 @@
 #if DEBUG
 			if (debugging && STps->eof != ST_NOEOF)
 			    printk(OSST_DEB_MSG "%s:D: EOF up (%d). Left %d, needed %d.\n", name,
-						 STps->eof, (STp->buffer)->buffer_bytes, count - total);
+						 STps->eof, (STp->buffer)->buffer_bytes, (int) (count - total));
 #endif
 		       	/* force multiple of block size, note block_size may have been adjusted */
 			transfer = (((STp->buffer)->buffer_bytes < count - total ?
@@ -3728,7 +3783,7 @@
 	retval = total;
 
 out:
-	if (SRpnt != NULL) scsi_release_request(SRpnt);
+	if (SRpnt != NULL) osst_release_request(SRpnt);
 
 	up(&STp->lock);
 
@@ -3916,7 +3971,7 @@
 
 
 /* Internal ioctl function */
-static int osst_int_ioctl(struct osst_tape * STp, struct scsi_request ** aSRpnt,
+static int osst_int_ioctl(struct osst_tape * STp, struct osst_request ** aSRpnt,
 			     unsigned int cmd_in, unsigned long arg)
 {
 	int			timeout;
@@ -3924,7 +3979,7 @@
 	int			i, ioctl_result;
 	int			chg_eof = 1;
 	unsigned char		cmd[MAX_COMMAND_SIZE];
-	struct scsi_request   * SRpnt = * aSRpnt;
+	struct osst_request   * SRpnt = * aSRpnt;
 	struct st_partstat    * STps;
 	int			fileno, blkno, at_sm, frame_seq_numbr, logical_blk_num;
 	int			datalen = 0, direction = DMA_NONE;
@@ -4282,14 +4337,14 @@
 	} else if (cmd_in == MTERASE) {
 		STp->header_ok = 0;
 	} else if (SRpnt) {  /* SCSI command was not completely successful. */
-		if (SRpnt->sr_sense_buffer[2] & 0x40) {
+		if (SRpnt->sense[2] & 0x40) {
 			STps->eof = ST_EOM_OK;
 			STps->drv_block = 0;
 		}
 		if (chg_eof)
 			STps->eof = ST_NOEOF;
 
-		if ((SRpnt->sr_sense_buffer[2] & 0x0f) == BLANK_CHECK)
+		if ((SRpnt->sense[2] & 0x0f) == BLANK_CHECK)
 			STps->eof = ST_EOD;
 
 		if (cmd_in == MTLOAD && osst_wait_for_medium(STp, &SRpnt, 60))
@@ -4307,7 +4362,7 @@
 	unsigned short	      flags;
 	int		      i, b_size, new_session = 0, retval = 0;
 	unsigned char	      cmd[MAX_COMMAND_SIZE];
-	struct scsi_request * SRpnt = NULL;
+	struct osst_request * SRpnt = NULL;
 	struct osst_tape    * STp;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
@@ -4415,17 +4470,17 @@
 		retval = (STp->buffer)->syscall_result;		/* FIXME - valid? */
 		goto err_out;
 	}
-	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70      &&
-	    (SRpnt->sr_sense_buffer[2] & 0x0f) == NOT_READY &&
-	     SRpnt->sr_sense_buffer[12]        == 4         ) {
+	if ((SRpnt->sense[0] & 0x70) == 0x70      &&
+	    (SRpnt->sense[2] & 0x0f) == NOT_READY &&
+	     SRpnt->sense[12]        == 4         ) {
 #if DEBUG
-		printk(OSST_DEB_MSG "%s:D: Unit not ready, cause %x\n", name, SRpnt->sr_sense_buffer[13]);
+		printk(OSST_DEB_MSG "%s:D: Unit not ready, cause %x\n", name, SRpnt->sense[13]);
 #endif
 		if (filp->f_flags & O_NONBLOCK) {
 			retval = -EAGAIN;
 			goto err_out;
 		}
-		if (SRpnt->sr_sense_buffer[13] == 2) {	/* initialize command required (LOAD) */
+		if (SRpnt->sense[13] == 2) {	/* initialize command required (LOAD) */
 			memset (cmd, 0, MAX_COMMAND_SIZE);
         		cmd[0] = START_STOP;
 			cmd[1] = 1;
@@ -4433,10 +4488,10 @@
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
 					     STp->timeout, MAX_RETRIES, 1);
 		}
-		osst_wait_ready(STp, &SRpnt, (SRpnt->sr_sense_buffer[13]==1?15:3) * 60, 0);
+		osst_wait_ready(STp, &SRpnt, (SRpnt->sense[13]==1?15:3) * 60, 0);
 	}
-	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-	    (SRpnt->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION) { /* New media? */
+	if ((SRpnt->sense[0] & 0x70) == 0x70 &&
+	    (SRpnt->sense[2] & 0x0f) == UNIT_ATTENTION) { /* New media? */
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Unit wants attention\n", name);
 #endif
@@ -4449,8 +4504,8 @@
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
 					     STp->timeout, MAX_RETRIES, 1);
-			if ((SRpnt->sr_sense_buffer[0] & 0x70) != 0x70 ||
-			    (SRpnt->sr_sense_buffer[2] & 0x0f) != UNIT_ATTENTION)
+			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
+			    (SRpnt->sense[2] & 0x0f) != UNIT_ATTENTION)
 				break;
 		}
 
@@ -4476,7 +4531,7 @@
 	 * open without reconfiguring and re-reading the headers
 	 */
 	if (!STp->buffer->syscall_result && STp->header_ok &&
-	    !SRpnt->sr_result && SRpnt->sr_sense_buffer[0] == 0) {
+	    !SRpnt->result && SRpnt->sense[0] == 0) {
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = MODE_SENSE;
@@ -4515,7 +4570,7 @@
 			}
 			STp->buffer->buffer_blocks = OS_DATA_SIZE / STp->block_size;
 			STp->fast_open = 1;
-			scsi_release_request(SRpnt);
+			osst_release_request(SRpnt);
 			return 0;
 		}
 #if DEBUG
@@ -4528,7 +4583,7 @@
 	STp->fast_open = 0;
 
 	if ((STp->buffer)->syscall_result != 0 &&   /* in all error conditions except no medium */ 
-	    (SRpnt->sr_sense_buffer[2] != 2 || SRpnt->sr_sense_buffer[12] != 0x3A) ) {
+	    (SRpnt->sense[2] != 2 || SRpnt->sense[12] != 0x3A) ) {
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = MODE_SELECT;
@@ -4558,11 +4613,11 @@
 
 			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
 						    STp->timeout, MAX_RETRIES, 1);
-			if ((SRpnt->sr_sense_buffer[0] & 0x70) != 0x70 ||
-			    (SRpnt->sr_sense_buffer[2] & 0x0f) == NOT_READY)
+			if ((SRpnt->sense[0] & 0x70) != 0x70 ||
+			    (SRpnt->sense[2] & 0x0f) == NOT_READY)
 			break;
 
-			if ((SRpnt->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION) {
+			if ((SRpnt->sense[2] & 0x0f) == UNIT_ATTENTION) {
 				STp->pos_unknown = 0;
 				STp->partition = STp->new_partition = 0;
 				if (STp->can_partitions)
@@ -4586,13 +4641,13 @@
 
 	if ((STp->buffer)->syscall_result != 0) {
 		if ((STp->device)->scsi_level >= SCSI_2 &&
-		    (SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-		    (SRpnt->sr_sense_buffer[2] & 0x0f) == NOT_READY &&
-		     SRpnt->sr_sense_buffer[12] == 0x3a) { /* Check ASC */
+		    (SRpnt->sense[0] & 0x70) == 0x70 &&
+		    (SRpnt->sense[2] & 0x0f) == NOT_READY &&
+		     SRpnt->sense[12] == 0x3a) { /* Check ASC */
 			STp->ready = ST_NO_TAPE;
 		} else
 			STp->ready = ST_NOT_READY;
-		scsi_release_request(SRpnt);
+		osst_release_request(SRpnt);
 		SRpnt = NULL;
 		STp->density = 0;   	/* Clear the erroneous "residue" */
 		STp->write_prot = 0;
@@ -4652,14 +4707,14 @@
 
 	osst_analyze_headers(STp, &SRpnt);
 
-	scsi_release_request(SRpnt);
+	osst_release_request(SRpnt);
 	SRpnt = NULL;
 
 	return 0;
 
 err_out:
 	if (SRpnt != NULL)
-		scsi_release_request(SRpnt);
+		osst_release_request(SRpnt);
 	normalize_buffer(STp->buffer);
 	STp->header_ok = 0;
 	STp->in_use = 0;
@@ -4676,7 +4731,7 @@
 	struct osst_tape    * STp    = filp->private_data;
 	struct st_modedef   * STm    = &(STp->modes[STp->current_mode]);
 	struct st_partstat  * STps   = &(STp->ps[STp->partition]);
-	struct scsi_request * SRpnt  = NULL;
+	struct osst_request * SRpnt  = NULL;
 	char		    * name   = tape_name(STp);
 
 	if (file_count(filp) > 1)
@@ -4739,7 +4794,7 @@
 		if (result == 0 && result2 < 0)
 			result = result2;
 	}
-	if (SRpnt) scsi_release_request(SRpnt);
+	if (SRpnt) osst_release_request(SRpnt);
 
 	if (STp->abort_count || STp->recover_count) {
 		printk(KERN_INFO "%s:I:", name);
@@ -4793,7 +4848,7 @@
 	unsigned int	      blk;
 	struct st_modedef   * STm;
 	struct st_partstat  * STps;
-	struct scsi_request * SRpnt = NULL;
+	struct osst_request * SRpnt = NULL;
 	struct osst_tape    * STp   = file->private_data;
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
@@ -5107,14 +5162,14 @@
 			retval = -EFAULT;
 		goto out;
 	}
-	if (SRpnt) scsi_release_request(SRpnt);
+	if (SRpnt) osst_release_request(SRpnt);
 
 	up(&STp->lock);
 
 	return scsi_ioctl(STp->device, cmd_in, p);
 
 out:
-	if (SRpnt) scsi_release_request(SRpnt);
+	if (SRpnt) osst_release_request(SRpnt);
 
 	up(&STp->lock);
 

