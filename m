From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape descriptor based sense data support
Date: Sun, 13 Feb 2005 22:46:35 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0502132244290.6828@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:63434 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261305AbVBMUps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Feb 2005 15:45:48 -0500
Received: from kai.makisara.local ([193.229.228.239])
          by fep02-app.kolumbus.fi with ESMTP
          id <20050213204546.OCOD8756.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2005 22:45:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch at the end of this message converts the SCSI tape driver to support
also descriptor based sense data. Test for deferred sense data have been added
in a couple of places and the EOM tests have been unified. Some tests have been
simplified but the patch is not meant to change the current behavior. The
patch is against 2.6.11-rc4 and has been tested to some extent.

The patch also includes the msleep_interruptible change from from kernel
janitors.

Thanks to Doug Gilbert for doing a first version of this sense data
conversion.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-rc4/drivers/scsi/st.c	2005-02-13 10:37:49.000000000 +0200
+++ linux-2.6.11-rc4-k1/drivers/scsi/st.c	2005-02-13 22:42:48.000000000 +0200
@@ -9,7 +9,7 @@
    Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedinsky,
    Michael Schaefer, J"org Weule, and Eric Youngdale.
 
-   Copyright 1992 - 2004 Kai Makisara
+   Copyright 1992 - 2005 Kai Makisara
    email Kai.Makisara@kolumbus.fi
 
    Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20041025";
+static char *verstr = "20050213";
 
 #include <linux/module.h>
 
@@ -144,7 +144,7 @@ static char *st_formats[] = {
 #error "Buffer size should not exceed (2 << 24 - 1) bytes!"
 #endif
 
-DEB( static int debugging = DEBUG; )
+static int debugging = DEBUG;
 
 #define MAX_RETRIES 0
 #define MAX_WRITE_RETRIES 0
@@ -262,25 +262,57 @@ static inline char *tape_name(struct scs
 	return tape->disk->disk_name;
 }
 
+
+static void st_analyze_sense(struct scsi_request *SRpnt, struct st_cmdstatus *s)
+{
+	const u8 *ucp;
+	const u8 *sense = SRpnt->sr_sense_buffer;
+
+	s->have_sense = scsi_request_normalize_sense(SRpnt, &s->sense_hdr);
+
+	if (s->have_sense) {
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
+		default:
+			s->flags = 0;
+		}
+	}
+}
+
+
 /* Convert the result to success code */
 static int st_chk_result(struct scsi_tape *STp, struct scsi_request * SRpnt)
 {
 	int result = SRpnt->sr_result;
-	unsigned char *sense = SRpnt->sr_sense_buffer, scode;
+	u8 scode;
 	DEB(const char *stp;)
 	char *name = tape_name(STp);
+	struct st_cmdstatus *cmdstatp;
 
-	if (!result) {
-		sense[0] = 0;	/* We don't have sense data if this byte is zero */
+	if (!result)
 		return 0;
-	}
 
-	if ((driver_byte(result) & DRIVER_MASK) == DRIVER_SENSE)
-		scode = sense[2] & 0x0f;
-	else {
-		sense[0] = 0;
+		cmdstatp = &STp->buffer->cmdstat;
+	st_analyze_sense(STp->buffer->last_SRpnt, cmdstatp);
+
+	if (cmdstatp->have_sense)
+		scode = STp->buffer->cmdstat.sense_hdr.sense_key;
+	else
 		scode = 0;
-	}
 
         DEB(
         if (debugging) {
@@ -289,29 +321,30 @@ static int st_chk_result(struct scsi_tap
 		       SRpnt->sr_cmnd[0], SRpnt->sr_cmnd[1], SRpnt->sr_cmnd[2],
 		       SRpnt->sr_cmnd[3], SRpnt->sr_cmnd[4], SRpnt->sr_cmnd[5],
 		       SRpnt->sr_bufflen);
-		if (driver_byte(result) & DRIVER_SENSE)
-			scsi_print_req_sense("st", SRpnt);
-	} else ) /* end DEB */
-		if (!(driver_byte(result) & DRIVER_SENSE) ||
-		    ((sense[0] & 0x70) == 0x70 &&
-		     scode != NO_SENSE &&
-		     scode != RECOVERED_ERROR &&
-                     /* scode != UNIT_ATTENTION && */
-		     scode != BLANK_CHECK &&
-		     scode != VOLUME_OVERFLOW &&
-		     SRpnt->sr_cmnd[0] != MODE_SENSE &&
-		     SRpnt->sr_cmnd[0] != TEST_UNIT_READY)) {	/* Abnormal conditions for tape */
-		if (driver_byte(result) & DRIVER_SENSE) {
-			printk(KERN_WARNING "%s: Error with sense data: ", name);
+		if (cmdstatp->have_sense)
 			scsi_print_req_sense("st", SRpnt);
-		} else
+	} ) /* end DEB */
+	if (!debugging) { /* Abnormal conditions for tape */
+		if (!cmdstatp->have_sense)
 			printk(KERN_WARNING
 			       "%s: Error %x (sugg. bt 0x%x, driver bt 0x%x, host bt 0x%x).\n",
 			       name, result, suggestion(result),
-                               driver_byte(result) & DRIVER_MASK, host_byte(result));
+			       driver_byte(result) & DRIVER_MASK, host_byte(result));
+		else if (cmdstatp->have_sense &&
+			 scode != NO_SENSE &&
+			 scode != RECOVERED_ERROR &&
+			 /* scode != UNIT_ATTENTION && */
+			 scode != BLANK_CHECK &&
+			 scode != VOLUME_OVERFLOW &&
+			 SRpnt->sr_cmnd[0] != MODE_SENSE &&
+			 SRpnt->sr_cmnd[0] != TEST_UNIT_READY) {
+				printk(KERN_WARNING "%s: Error with sense data: ", name);
+				scsi_print_req_sense("st", SRpnt);
+		}
 	}
 
-	if (STp->cln_mode >= EXTENDED_SENSE_START) {
+	if (cmdstatp->fixed_format &&
+	    STp->cln_mode >= EXTENDED_SENSE_START) {  /* Only fixed format sense */
 		if (STp->cln_sense_value)
 			STp->cleaning_req |= ((SRpnt->sr_sense_buffer[STp->cln_mode] &
 					       STp->cln_sense_mask) == STp->cln_sense_value);
@@ -319,12 +352,13 @@ static int st_chk_result(struct scsi_tap
 			STp->cleaning_req |= ((SRpnt->sr_sense_buffer[STp->cln_mode] &
 					       STp->cln_sense_mask) != 0);
 	}
-	if (sense[12] == 0 && sense[13] == 0x17) /* ASC and ASCQ => cleaning requested */
-		STp->cleaning_req = 1;
+	if (cmdstatp->have_sense &&
+	    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
+		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
 
 	STp->pos_unknown |= STp->device->was_reset;
 
-	if ((sense[0] & 0x70) == 0x70 &&
+	if (cmdstatp->have_sense &&
 	    scode == RECOVERED_ERROR
 #if ST_RECOVERED_WRITE_FATAL
 	    && SRpnt->sr_cmnd[0] != WRITE_6
@@ -346,7 +380,7 @@ static int st_chk_result(struct scsi_tap
 			       STp->recover_count);
 		} ) /* end DEB */
 
-		if ((sense[2] & 0xe0) == 0)
+		if (cmdstatp->flags == 0)
 			return 0;
 	}
 	return (-EIO);
@@ -356,28 +390,10 @@ static int st_chk_result(struct scsi_tap
 /* Wakeup from interrupt */
 static void st_sleep_done(struct scsi_cmnd * SCpnt)
 {
-	int remainder;
 	struct scsi_tape *STp = container_of(SCpnt->request->rq_disk->private_data,
 					     struct scsi_tape, driver);
 
-	if ((STp->buffer)->writing &&
-	    (SCpnt->sense_buffer[0] & 0x70) == 0x70 &&
-	    (SCpnt->sense_buffer[2] & 0x40)) {
-		/* EOM at write-behind, has all been written? */
-		if ((SCpnt->sense_buffer[0] & 0x80) != 0)
-			remainder = (SCpnt->sense_buffer[3] << 24) |
-				(SCpnt->sense_buffer[4] << 16) |
-				(SCpnt->sense_buffer[5] << 8) |
-				SCpnt->sense_buffer[6];
-		else
-			remainder = 0;
-		if ((SCpnt->sense_buffer[2] & 0x0f) == VOLUME_OVERFLOW ||
-		    remainder > 0)
-			(STp->buffer)->midlevel_result = SCpnt->result; /* Error */
-		else
-			(STp->buffer)->midlevel_result = INT_MAX;	/* OK */
-	} else
-		(STp->buffer)->midlevel_result = SCpnt->result;
+	(STp->buffer)->cmdstat.midlevel_result = SCpnt->result;
 	SCpnt->request->rq_status = RQ_SCSI_DONE;
 	(STp->buffer)->last_SRpnt = SCpnt->sc_request;
 	DEB( STp->write_pending = 0; )
@@ -421,6 +437,7 @@ st_do_scsi(struct scsi_request * SRpnt, 
 	SRpnt->sr_request->waiting = &(STp->wait);
 	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
 	SRpnt->sr_request->rq_disk = STp->disk;
+	STp->buffer->cmdstat.have_sense = 0;
 
 	scsi_do_req(SRpnt, (void *) cmd, bp, bytes,
 		    st_sleep_done, timeout, retries);
@@ -434,13 +451,20 @@ st_do_scsi(struct scsi_request * SRpnt, 
 }
 
 
-/* Handle the write-behind checking (downs the semaphore) */
-static void write_behind_check(struct scsi_tape * STp)
+/* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
+   write has been correct but EOM early warning reached, -EIO if write ended in
+   error or zero if write successful. Asynchronous writes are used only in
+   variable block mode. */
+static int write_behind_check(struct scsi_tape * STp)
 {
+	int retval = 0;
 	struct st_buffer *STbuffer;
 	struct st_partstat *STps;
+	struct st_cmdstatus *cmdstatp;
 
 	STbuffer = STp->buffer;
+	if (!STbuffer->writing)
+		return 0;
 
         DEB(
 	if (STp->write_pending)
@@ -463,9 +487,29 @@ static void write_behind_check(struct sc
 		else
 			STps->drv_block += STbuffer->writing / STp->block_size;
 	}
+
+	cmdstatp = &STbuffer->cmdstat;
+	if (STbuffer->syscall_result) {
+		retval = -EIO;
+		if (cmdstatp->have_sense && !cmdstatp->deferred &&
+		    (cmdstatp->flags & SENSE_EOM) &&
+		    (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+		     cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR)) {
+			/* EOM at write-behind, has all data been written? */
+			if (!cmdstatp->remainder_valid ||
+			    cmdstatp->uremainder64 == 0)
+				retval = -ENOSPC;
+		}
+		if (retval == -EIO)
+			STps->drv_block = -1;
+	}
 	STbuffer->writing = 0;
 
-	return;
+	DEB(if (debugging && retval)
+	    printk(ST_DEB_MSG "%s: Async write error %x, return value %d.\n",
+		   tape_name(STp), STbuffer->cmdstat.midlevel_result, retval);) /* end DEB */
+
+	return retval;
 }
 
 
@@ -496,7 +540,7 @@ static int cross_eof(struct scsi_tape * 
 	scsi_release_request(SRpnt);
 	SRpnt = NULL;
 
-	if ((STp->buffer)->midlevel_result != 0)
+	if ((STp->buffer)->cmdstat.midlevel_result != 0)
 		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
 		   tape_name(STp), forward ? "forward" : "backward");
 
@@ -513,19 +557,9 @@ static int flush_write_buffer(struct scs
 	struct scsi_request *SRpnt;
 	struct st_partstat *STps;
 
-	if ((STp->buffer)->writing) {
-		write_behind_check(STp);
-		if ((STp->buffer)->syscall_result) {
-                        DEBC(printk(ST_DEB_MSG
-                                       "%s: Async write error (flush) %x.\n",
-				       tape_name(STp), (STp->buffer)->midlevel_result))
-			if ((STp->buffer)->midlevel_result == INT_MAX)
-				return (-ENOSPC);
-			return (-EIO);
-		}
-	}
-	if (STp->block_size == 0)
-		return 0;
+	result = write_behind_check(STp);
+	if (result)
+		return result;
 
 	result = 0;
 	if (STp->dirty == 1) {
@@ -553,18 +587,25 @@ static int flush_write_buffer(struct scs
 
 		STps = &(STp->ps[STp->partition]);
 		if ((STp->buffer)->syscall_result != 0) {
-			if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-			    (SRpnt->sr_sense_buffer[2] & 0x40) &&
-			    (SRpnt->sr_sense_buffer[2] & 0x0f) == NO_SENSE) {
+			struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
+
+			if (cmdstatp->have_sense && !cmdstatp->deferred &&
+			    (cmdstatp->flags & SENSE_EOM) &&
+			    (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+			     cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
+			    (!cmdstatp->remainder_valid ||
+			     cmdstatp->uremainder64 == 0)) { /* All written at EOM early warning */
 				STp->dirty = 0;
 				(STp->buffer)->buffer_bytes = 0;
+				if (STps->drv_block >= 0)
+					STps->drv_block += blks;
 				result = (-ENOSPC);
 			} else {
 				printk(KERN_ERR "%s: Error on flush.\n",
                                        tape_name(STp));
+				STps->drv_block = (-1);
 				result = (-EIO);
 			}
-			STps->drv_block = (-1);
 		} else {
 			if (STps->drv_block >= 0)
 				STps->drv_block += blks;
@@ -728,6 +769,7 @@ static int test_ready(struct scsi_tape *
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_request *SRpnt = NULL;
+	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
 
@@ -742,9 +784,9 @@ static int test_ready(struct scsi_tape *
 			break;
 		}
 
-		if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70) {
+		if (cmdstatp->have_sense) {
 
-			scode = (SRpnt->sr_sense_buffer[2] & 0x0f);
+			scode = cmdstatp->sense_hdr.sense_key;
 
 			if (scode == UNIT_ATTENTION) { /* New media? */
 				new_session = 1;
@@ -760,9 +802,7 @@ static int test_ready(struct scsi_tape *
 
 			if (scode == NOT_READY) {
 				if (waits < max_wait) {
-					set_current_state(TASK_INTERRUPTIBLE);
-					schedule_timeout(HZ);
-					if (signal_pending(current)) {
+					if (msleep_interruptible(1000)) {
 						retval = (-EINTR);
 						break;
 					}
@@ -771,7 +811,7 @@ static int test_ready(struct scsi_tape *
 				}
 				else {
 					if ((STp->device)->scsi_level >= SCSI_2 &&
-					    SRpnt->sr_sense_buffer[12] == 0x3a)	/* Check ASC */
+					    cmdstatp->sense_hdr.asc == 0x3a)	/* Check ASC */
 						retval = CHKRES_NO_TAPE;
 					else
 						retval = CHKRES_NOT_READY;
@@ -877,7 +917,7 @@ static int check_tape(struct scsi_tape *
 			goto err_out;
 		}
 
-		if (!SRpnt->sr_result && !SRpnt->sr_sense_buffer[0]) {
+		if (!SRpnt->sr_result && !STp->buffer->cmdstat.have_sense) {
 			STp->max_block = ((STp->buffer)->b_data[1] << 16) |
 			    ((STp->buffer)->b_data[2] << 8) | (STp->buffer)->b_data[3];
 			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
@@ -1108,6 +1148,7 @@ static int st_flush(struct file *filp)
 		       name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages, STp->nbr_combinable));
 
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
+		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
                 DEBC(printk(ST_DEB_MSG "%s: File length %lld bytes.\n",
                             name, (long long)filp->f_pos);
@@ -1126,20 +1167,13 @@ static int st_flush(struct file *filp)
 			goto out;
 		}
 
-		if ((STp->buffer)->syscall_result != 0 &&
-		    ((SRpnt->sr_sense_buffer[0] & 0x70) != 0x70 ||
-		     (SRpnt->sr_sense_buffer[2] & 0x4f) != 0x40 ||
-		     ((SRpnt->sr_sense_buffer[0] & 0x80) != 0 &&
-		      (SRpnt->sr_sense_buffer[3] | SRpnt->sr_sense_buffer[4] |
-		       SRpnt->sr_sense_buffer[5] |
-		       SRpnt->sr_sense_buffer[6]) != 0))) {
-			/* Filter out successful write at EOM */
-			scsi_release_request(SRpnt);
-			SRpnt = NULL;
-			printk(KERN_ERR "%s: Error on write filemark.\n", name);
-			if (result == 0)
-				result = (-EIO);
-		} else {
+		if (STp->buffer->syscall_result == 0 ||
+		    (cmdstatp->have_sense && !cmdstatp->deferred &&
+		     (cmdstatp->flags & SENSE_EOM) &&
+		     (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+		      cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
+		     (!cmdstatp->remainder_valid || cmdstatp->uremainder64 == 0))) {
+			/* Write successful at EOM */
 			scsi_release_request(SRpnt);
 			SRpnt = NULL;
 			if (STps->drv_file >= 0)
@@ -1149,6 +1183,13 @@ static int st_flush(struct file *filp)
 				cross_eof(STp, 0);
 			STps->eof = ST_FM;
 		}
+		else { /* Write error */
+			scsi_release_request(SRpnt);
+			SRpnt = NULL;
+			printk(KERN_ERR "%s: Error on write filemark.\n", name);
+			if (result == 0)
+				result = (-EIO);
+		}
 
                 DEBC(printk(ST_DEB_MSG "%s: Buffer flushed, %d EOF(s) written\n",
                             name, cmd[4]));
@@ -1410,16 +1451,12 @@ st_write(struct file *filp, const char _
 	}
 
 	STbp = STp->buffer;
-	if (STbp->writing) {
-		write_behind_check(STp);
-		if (STbp->syscall_result) {
-                        DEBC(printk(ST_DEB_MSG "%s: Async write error (write) %x.\n",
-                                    name, STbp->midlevel_result));
-			if (STbp->midlevel_result == INT_MAX)
-				STps->eof = ST_EOM_OK;
-			else
-				STps->eof = ST_EOM_ERROR;
-		}
+	i = write_behind_check(STp);
+	if (i) {
+		if (i == -ENOSPC)
+			STps->eof = ST_EOM_OK;
+		else
+			STps->eof = ST_EOM_ERROR;
 	}
 
 	if (STps->eof == ST_EOM_OK) {
@@ -1523,15 +1560,13 @@ st_write(struct file *filp, const char _
 		}
 
 		if (STbp->syscall_result != 0) {
+			struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
+
                         DEBC(printk(ST_DEB_MSG "%s: Error on write:\n", name));
-			if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-			    (SRpnt->sr_sense_buffer[2] & 0x40)) {
-				scode = SRpnt->sr_sense_buffer[2] & 0x0f;
-				if ((SRpnt->sr_sense_buffer[0] & 0x80) != 0)
-					undone = (SRpnt->sr_sense_buffer[3] << 24) |
-					    (SRpnt->sr_sense_buffer[4] << 16) |
-					    (SRpnt->sr_sense_buffer[5] << 8) |
-                                                SRpnt->sr_sense_buffer[6];
+			if (cmdstatp->have_sense && (cmdstatp->flags & SENSE_EOM)) {
+				scode = cmdstatp->sense_hdr.sense_key;
+				if (cmdstatp->remainder_valid)
+					undone = (int)cmdstatp->uremainder64;
 				else if (STp->block_size == 0 &&
 					 scode == VOLUME_OVERFLOW)
 					undone = transfer;
@@ -1556,11 +1591,11 @@ st_write(struct file *filp, const char _
 						retval = (-ENOSPC); /* EOM within current request */
                                         DEBC(printk(ST_DEB_MSG
                                                        "%s: EOM with %d bytes unwritten.\n",
-						       name, count));
+						       name, (int)count));
 				} else {
 					/* EOT within data buffered earlier (possible only
 					   in fixed block mode without direct i/o) */
-					if (!retry_eot && (SRpnt->sr_sense_buffer[0] & 1) == 0 &&
+					if (!retry_eot && !cmdstatp->deferred &&
 					    (scode == NO_SENSE || scode == RECOVERED_ERROR)) {
 						move_buffer_data(STp->buffer, transfer - undone);
 						retry_eot = 1;
@@ -1690,6 +1725,8 @@ static long read_tape(struct scsi_tape *
 
 	/* Something to check */
 	if (STbp->syscall_result) {
+		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
+
 		retval = 1;
 		DEBC(printk(ST_DEB_MSG "%s: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
                             name,
@@ -1697,25 +1734,22 @@ static long read_tape(struct scsi_tape *
                             SRpnt->sr_sense_buffer[2], SRpnt->sr_sense_buffer[3],
                             SRpnt->sr_sense_buffer[4], SRpnt->sr_sense_buffer[5],
                             SRpnt->sr_sense_buffer[6], SRpnt->sr_sense_buffer[7]));
-		if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70) {	/* extended sense */
+		if (cmdstatp->have_sense) {
 
-			if ((SRpnt->sr_sense_buffer[2] & 0x0f) == BLANK_CHECK)
-				SRpnt->sr_sense_buffer[2] &= 0xcf;	/* No need for EOM in this case */
+			if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
+				cmdstatp->flags &= 0xcf;	/* No need for EOM in this case */
 
-			if ((SRpnt->sr_sense_buffer[2] & 0xe0) != 0) { /* EOF, EOM, or ILI */
+			if (cmdstatp->flags != 0) { /* EOF, EOM, or ILI */
 				/* Compute the residual count */
-				if ((SRpnt->sr_sense_buffer[0] & 0x80) != 0)
-					transfer = (SRpnt->sr_sense_buffer[3] << 24) |
-					    (SRpnt->sr_sense_buffer[4] << 16) |
-					    (SRpnt->sr_sense_buffer[5] << 8) |
-					    SRpnt->sr_sense_buffer[6];
+				if (cmdstatp->remainder_valid)
+					transfer = (int)cmdstatp->uremainder64;
 				else
 					transfer = 0;
 				if (STp->block_size == 0 &&
-				    (SRpnt->sr_sense_buffer[2] & 0x0f) == MEDIUM_ERROR)
+				    cmdstatp->sense_hdr.sense_key == MEDIUM_ERROR)
 					transfer = bytes;
 
-				if (SRpnt->sr_sense_buffer[2] & 0x20) {	/* ILI */
+				if (cmdstatp->flags & SENSE_ILI) {	/* ILI */
 					if (STp->block_size == 0) {
 						if (transfer <= 0) {
 							if (transfer < 0)
@@ -1749,7 +1783,7 @@ static long read_tape(struct scsi_tape *
 						if (st_int_ioctl(STp, MTBSR, 1))
 							return (-EIO);
 					}
-				} else if (SRpnt->sr_sense_buffer[2] & 0x80) {	/* FM overrides EOM */
+				} else if (cmdstatp->flags & SENSE_FMK) {	/* FM overrides EOM */
 					if (STps->eof != ST_FM_HIT)
 						STps->eof = ST_FM_HIT;
 					else
@@ -1762,7 +1796,7 @@ static long read_tape(struct scsi_tape *
                                         DEBC(printk(ST_DEB_MSG
                                                     "%s: EOF detected (%d bytes read).\n",
                                                     name, STbp->buffer_bytes));
-				} else if (SRpnt->sr_sense_buffer[2] & 0x40) {
+				} else if (cmdstatp->flags & SENSE_EOM) {
 					if (STps->eof == ST_FM)
 						STps->eof = ST_EOD_1;
 					else
@@ -1783,7 +1817,7 @@ static long read_tape(struct scsi_tape *
                                             "%s: Tape error while reading.\n", name));
 				STps->drv_block = (-1);
 				if (STps->eof == ST_FM &&
-				    (SRpnt->sr_sense_buffer[2] & 0x0f) == BLANK_CHECK) {
+				    cmdstatp->sense_hdr.sense_key == BLANK_CHECK) {
                                         DEBC(printk(ST_DEB_MSG
                                                     "%s: Zero returned for first BLANK CHECK after EOF.\n",
                                                     name));
@@ -1907,7 +1941,7 @@ st_read(struct file *filp, char __user *
 				printk(ST_DEB_MSG
                                        "%s: EOF up (%d). Left %d, needed %d.\n", name,
 				       STps->eof, STbp->buffer_bytes,
-                                       count - total);
+                                       (int)(count - total));
                         ) /* end DEB */
 			transfer = STbp->buffer_bytes < count - total ?
 			    STbp->buffer_bytes : count - total;
@@ -2695,23 +2729,26 @@ static int st_int_ioctl(struct scsi_tape
 
 	} else { /* SCSI command was not completely successful. Don't return
                     from this block without releasing the SCSI command block! */
+		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-		if (SRpnt->sr_sense_buffer[2] & 0x40) {
+		if (cmdstatp->flags & SENSE_EOM) {
 			if (cmd_in != MTBSF && cmd_in != MTBSFM &&
 			    cmd_in != MTBSR && cmd_in != MTBSS)
 				STps->eof = ST_EOM_OK;
 			STps->drv_block = 0;
 		}
 
-		undone = ((SRpnt->sr_sense_buffer[3] << 24) +
-			  (SRpnt->sr_sense_buffer[4] << 16) +
-			  (SRpnt->sr_sense_buffer[5] << 8) +
-			  SRpnt->sr_sense_buffer[6]);
+		if (cmdstatp->remainder_valid)
+			undone = (int)cmdstatp->uremainder64;
+		else
+			undone = 0;
 
 		if (cmd_in == MTWEOF &&
-		    (SRpnt->sr_sense_buffer[0] & 0x70) == 0x70 &&
-		    (SRpnt->sr_sense_buffer[2] & 0x4f) == 0x40 &&
-		 ((SRpnt->sr_sense_buffer[0] & 0x80) == 0 || undone == 0)) {
+		    cmdstatp->have_sense &&
+		    (cmdstatp->flags & SENSE_EOM) &&
+		    (cmdstatp->sense_hdr.sense_key == NO_SENSE ||
+		     cmdstatp->sense_hdr.sense_key == RECOVERED_ERROR) &&
+		    undone == 0) {
 			ioctl_result = 0;	/* EOF written succesfully at EOM */
 			if (fileno >= 0)
 				fileno++;
@@ -2732,7 +2769,7 @@ static int st_int_ioctl(struct scsi_tape
 			STps->drv_block = 0;
 			STps->eof = ST_NOEOF;
 		} else if (cmd_in == MTFSR) {
-			if (SRpnt->sr_sense_buffer[2] & 0x80) {	/* Hit filemark */
+			if (cmdstatp->flags & SENSE_FMK) {	/* Hit filemark */
 				if (STps->drv_file >= 0)
 					STps->drv_file++;
 				STps->drv_block = 0;
@@ -2745,7 +2782,7 @@ static int st_int_ioctl(struct scsi_tape
 				STps->eof = ST_NOEOF;
 			}
 		} else if (cmd_in == MTBSR) {
-			if (SRpnt->sr_sense_buffer[2] & 0x80) {	/* Hit filemark */
+			if (cmdstatp->flags & SENSE_FMK) {	/* Hit filemark */
 				STps->drv_file--;
 				STps->drv_block = (-1);
 			} else {
@@ -2763,7 +2800,7 @@ static int st_int_ioctl(struct scsi_tape
 			   cmd_in == MTSETDENSITY ||
 			   cmd_in == MTSETDRVBUFFER ||
 			   cmd_in == SET_DENS_AND_BLK) {
-			if ((SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST &&
+			if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
 			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
@@ -2775,7 +2812,7 @@ static int st_int_ioctl(struct scsi_tape
 		} else if (chg_eof)
 			STps->eof = ST_NOEOF;
 
-		if ((SRpnt->sr_sense_buffer[2] & 0x0f) == BLANK_CHECK)
+		if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
 			STps->eof = ST_EOD;
 
 		scsi_release_request(SRpnt);
--- linux-2.6.11-rc4/drivers/scsi/st.h	2004-12-25 10:16:53.000000000 +0200
+++ linux-2.6.11-rc4-k1/drivers/scsi/st.h	2005-02-13 10:40:21.000000000 +0200
@@ -5,6 +5,18 @@
 #include <linux/completion.h>
 
 
+/* Descriptor for analyzed sense data */
+struct st_cmdstatus {
+	int midlevel_result;
+	struct scsi_sense_hdr sense_hdr;
+	int have_sense;
+	u64 uremainder64;
+	u8 flags;
+	u8 remainder_valid;
+	u8 fixed_format;
+	u8 deferred;
+};
+
 /* The tape buffer descriptor. */
 struct st_buffer {
 	unsigned char in_use;
@@ -15,9 +27,9 @@ struct st_buffer {
 	int buffer_bytes;
 	int read_pointer;
 	int writing;
-	int midlevel_result;
 	int syscall_result;
 	struct scsi_request *last_SRpnt;
+	struct st_cmdstatus cmdstat;
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
@@ -192,4 +204,9 @@ struct scsi_tape {
 
 #define EXTENDED_SENSE_START  18
 
+/* Masks for some conditions in the sense data */
+#define SENSE_FMK   0x80
+#define SENSE_EOM   0x40
+#define SENSE_ILI   0x20
+
 #endif
