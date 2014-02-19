From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Wed, 19 Feb 2014 10:04:41 +0100
Message-ID: <1392800681-5290-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaBSJFA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 04:05:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org, hare@suse.de, jbottomley@parallels.com, kay@vrfy.org

This patch converts the st driver to use dev_printk() instead of printk(),
every st device has a reference to the underlying scsi device.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/st.c | 613 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 349 insertions(+), 264 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a1d6986..b2138cb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -171,6 +171,9 @@ static int debugging = DEBUG;
    24 bits) */
 #define SET_DENS_AND_BLK 0x10001
 
+#define stdev_printk(prefix, stdev, fmt, a...) \
+	sdev_printk(prefix, (stdev)->device, fmt, ##a)
+
 static int st_fixed_buffer_size = ST_FIXED_BUFFER_SIZE;
 static int st_max_sg_segs = ST_MAX_SG;
 
@@ -179,8 +182,8 @@ static int modes_defined;
 static int enlarge_buffer(struct st_buffer *, int, int);
 static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
-static int append_to_buffer(const char __user *, struct st_buffer *, int);
-static int from_buffer(struct st_buffer *, char __user *, int);
+static int append_to_buffer(const char __user *, struct st_buffer *, int, char **errmsg);
+static int from_buffer(struct st_buffer *, char __user *, int, char **errmsg);
 static void move_buffer_data(struct st_buffer *, int);
 
 static int sgl_map_user_pages(struct st_buffer *, const unsigned int,
@@ -360,19 +363,20 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 
         DEB(
         if (debugging) {
-                printk(ST_DEB_MSG "%s: Error: %x, cmd: %x %x %x %x %x %x\n",
-		       name, result,
-		       SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
-		       SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
+                stdev_printk(ST_DEB_MSG, STp,
+			     "%s: Error: %x, cmd: %x %x %x %x %x %x\n",
+			     name, result,
+			     SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
+			     SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
 			 __scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
-			printk(KERN_WARNING
-			       "%s: Error %x (driver bt 0x%x, host bt 0x%x).\n",
-			       name, result, driver_byte(result),
-			       host_byte(result));
+			stdev_printk(KERN_WARNING, STp,
+				     "%s: Error %x (driver bt 0x%x, host bt 0x%x).\n",
+				     name, result, driver_byte(result),
+				     host_byte(result));
 		else if (cmdstatp->have_sense &&
 			 scode != NO_SENSE &&
 			 scode != RECOVERED_ERROR &&
@@ -419,8 +423,9 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 				stp = "write";
 			else
 				stp = "ioctl";
-			printk(ST_DEB_MSG "%s: Recovered %s error (%d).\n", name, stp,
-			       STp->recover_count);
+			stdev_printk(ST_DEB_MSG, STp,
+				     "%s: Recovered %s error (%d).\n", name, stp,
+				     STp->recover_count);
 		} ) /* end DEB */
 
 		if (cmdstatp->flags == 0)
@@ -437,8 +442,9 @@ static struct st_request *st_allocate_request(struct scsi_tape *stp)
 	if (streq)
 		streq->stp = stp;
 	else {
-		DEBC(printk(KERN_ERR "%s: Can't get SCSI request.\n",
-			    tape_name(stp)););
+		DEBC(stdev_printk(KERN_ERR, stp,
+				  "%s: Can't get SCSI request.\n",
+				  tape_name(stp)););
 		if (signal_pending(current))
 			stp->buffer->syscall_result = -EINTR;
 		else
@@ -525,8 +531,9 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 
 	/* if async, make sure there's no command outstanding */
 	if (!do_wait && ((STp->buffer)->last_SRpnt)) {
-		printk(KERN_ERR "%s: Async command already active.\n",
-		       tape_name(STp));
+		stdev_printk(KERN_ERR, STp,
+			     "%s: Async command already active.\n",
+			     tape_name(STp));
 		if (signal_pending(current))
 			(STp->buffer)->syscall_result = (-EINTR);
 		else
@@ -639,8 +646,9 @@ static int write_behind_check(struct scsi_tape * STp)
 	STbuffer->writing = 0;
 
 	DEB(if (debugging && retval)
-	    printk(ST_DEB_MSG "%s: Async write error %x, return value %d.\n",
-		   tape_name(STp), STbuffer->cmdstat.midlevel_result, retval);) /* end DEB */
+	    stdev_printk(ST_DEB_MSG, STp,
+			 "%s: Async write error %x, return value %d.\n",
+			 tape_name(STp), STbuffer->cmdstat.midlevel_result, retval);) /* end DEB */
 
 	return retval;
 }
@@ -662,8 +670,9 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 		cmd[2] = cmd[3] = cmd[4] = 0xff;	/* -1 filemarks */
 	cmd[5] = 0;
 
-        DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
-		   tape_name(STp), forward ? "forward" : "backward"));
+        DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: Stepping over filemark %s.\n",
+			  tape_name(STp), forward ? "forward" : "backward"));
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
 			   STp->device->request_queue->rq_timeout,
@@ -675,8 +684,9 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 	SRpnt = NULL;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
-		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
-		   tape_name(STp), forward ? "forward" : "backward");
+		stdev_printk(KERN_ERR, STp,
+			     "%s: Stepping over filemark %s failed.\n",
+			     tape_name(STp), forward ? "forward" : "backward");
 
 	return (STp->buffer)->syscall_result;
 }
@@ -699,8 +709,8 @@ static int st_flush_write_buffer(struct scsi_tape * STp)
 	if (STp->dirty == 1) {
 
 		transfer = STp->buffer->buffer_bytes;
-                DEBC(printk(ST_DEB_MSG "%s: Flushing %d bytes.\n",
-                               tape_name(STp), transfer));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: Flushing %d bytes.\n",
+				  tape_name(STp), transfer));
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_6;
@@ -732,8 +742,9 @@ static int st_flush_write_buffer(struct scsi_tape * STp)
 					STps->drv_block += blks;
 				result = (-ENOSPC);
 			} else {
-				printk(KERN_ERR "%s: Error on flush.\n",
-                                       tape_name(STp));
+				stdev_printk(KERN_ERR, STp,
+					     "%s: Error on flush.\n",
+					     tape_name(STp));
 				STps->drv_block = (-1);
 				result = (-EIO);
 			}
@@ -830,9 +841,9 @@ static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
 		arg |= STp->block_size;
 	if (set_it &&
 	    st_int_ioctl(STp, SET_DENS_AND_BLK, arg)) {
-		printk(KERN_WARNING
-		       "%s: Can't set default block size to %d bytes and density %x.\n",
-		       name, STm->default_blksize, STm->default_density);
+		stdev_printk(KERN_WARNING, STp,
+			     "%s: Can't set default block size to %d bytes and density %x.\n",
+			     name, STm->default_blksize, STm->default_density);
 		if (modes_defined)
 			return (-EINVAL);
 	}
@@ -848,8 +859,9 @@ static int do_door_lock(struct scsi_tape * STp, int do_lock)
 
 
 	cmd = do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
-	DEBC(printk(ST_DEB_MSG "%s: %socking drive door.\n", name,
-		    do_lock ? "L" : "Unl"));
+	DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: %socking drive door.\n", name,
+			  do_lock ? "L" : "Unl"));
 	retval = scsi_ioctl(STp->device, cmd, NULL);
 	if (!retval) {
 		STp->door_locked = do_lock ? ST_LOCKED_EXPLICIT : ST_UNLOCKED;
@@ -983,8 +995,9 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	STp->ready = ST_READY;
 
 	if (mode != STp->current_mode) {
-                DEBC(printk(ST_DEB_MSG "%s: Mode change from %d to %d.\n",
-			       name, STp->current_mode, mode));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Mode change from %d to %d.\n",
+				  name, STp->current_mode, mode));
 		new_session = 1;
 		STp->current_mode = mode;
 	}
@@ -1055,13 +1068,13 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 			STp->min_block = ((STp->buffer)->b_data[4] << 8) |
 			    (STp->buffer)->b_data[5];
 			if ( DEB( debugging || ) !STp->inited)
-				printk(KERN_INFO
-                                       "%s: Block limits %d - %d bytes.\n", name,
-                                       STp->min_block, STp->max_block);
+				stdev_printk(KERN_INFO, STp,
+					     "%s: Block limits %d - %d bytes.\n", name,
+					     STp->min_block, STp->max_block);
 		} else {
 			STp->min_block = STp->max_block = (-1);
-                        DEBC(printk(ST_DEB_MSG "%s: Can't read block limits.\n",
-                                       name));
+                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+					  "%s: Can't read block limits.\n", name));
 		}
 	}
 
@@ -1078,33 +1091,33 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	}
 
 	if ((STp->buffer)->syscall_result != 0) {
-                DEBC(printk(ST_DEB_MSG "%s: No Mode Sense.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: No Mode Sense.\n", name));
 		STp->block_size = ST_DEFAULT_BLOCK;	/* Educated guess (?) */
 		(STp->buffer)->syscall_result = 0;	/* Prevent error propagation */
 		STp->drv_write_prot = 0;
 	} else {
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Mode sense. Length %d, medium %x, WBS %x, BLL %d\n",
-                            name,
-                            (STp->buffer)->b_data[0], (STp->buffer)->b_data[1],
-                            (STp->buffer)->b_data[2], (STp->buffer)->b_data[3]));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Mode sense. Length %d, medium %x, WBS %x, BLL %d\n",
+				  name,
+				  (STp->buffer)->b_data[0], (STp->buffer)->b_data[1],
+				  (STp->buffer)->b_data[2], (STp->buffer)->b_data[3]));
 
 		if ((STp->buffer)->b_data[3] >= 8) {
 			STp->drv_buffer = ((STp->buffer)->b_data[2] >> 4) & 7;
 			STp->density = (STp->buffer)->b_data[4];
 			STp->block_size = (STp->buffer)->b_data[9] * 65536 +
 			    (STp->buffer)->b_data[10] * 256 + (STp->buffer)->b_data[11];
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Density %x, tape length: %x, drv buffer: %d\n",
-                                    name, STp->density, (STp->buffer)->b_data[5] * 65536 +
-                                    (STp->buffer)->b_data[6] * 256 + (STp->buffer)->b_data[7],
-                                    STp->drv_buffer));
+                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+					  "%s: Density %x, tape length: %x, drv buffer: %d\n",
+					  name, STp->density, (STp->buffer)->b_data[5] * 65536 +
+					  (STp->buffer)->b_data[6] * 256 + (STp->buffer)->b_data[7],
+					  STp->drv_buffer));
 		}
 		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
 		if (!STp->drv_buffer && STp->immediate_filemark) {
-			printk(KERN_WARNING
-			    "%s: non-buffered tape: disabling writing immediate filemarks\n",
-			    name);
+			stdev_printk(KERN_WARNING, STp,
+				     "%s: non-buffered tape: disabling writing immediate filemarks\n",
+				     name);
 			STp->immediate_filemark = 0;
 		}
 	}
@@ -1119,15 +1132,15 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		(STp->buffer)->buffer_blocks = 1;
 	(STp->buffer)->buffer_bytes = (STp->buffer)->read_pointer = 0;
 
-        DEBC(printk(ST_DEB_MSG
-                       "%s: Block size: %d, buffer size: %d (%d blocks).\n", name,
-		       STp->block_size, (STp->buffer)->buffer_size,
-		       (STp->buffer)->buffer_blocks));
+        DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: Block size: %d, buffer size: %d (%d blocks).\n", name,
+			  STp->block_size, (STp->buffer)->buffer_size,
+			  (STp->buffer)->buffer_blocks));
 
 	if (STp->drv_write_prot) {
 		STp->write_prot = 1;
 
-                DEBC(printk(ST_DEB_MSG "%s: Write protected\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: Write protected\n", name));
 
 		if (do_wait &&
 		    ((st_flags & O_ACCMODE) == O_WRONLY ||
@@ -1141,8 +1154,8 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		/* This code is reached when the device is opened for the first time
 		   after the driver has been initialized with tape in the drive and the
 		   partition support has been enabled. */
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Updating partition number in status.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Updating partition number in status.\n", name));
 		if ((STp->partition = find_partition(STp)) < 0) {
 			retval = STp->partition;
 			goto err_out;
@@ -1160,9 +1173,9 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 
 		if (STp->default_drvbuffer != 0xff) {
 			if (st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer))
-				printk(KERN_WARNING
-                                       "%s: Can't set default drive buffering to %d.\n",
-				       name, STp->default_drvbuffer);
+				stdev_printk(KERN_WARNING, STp,
+					     "%s: Can't set default drive buffering to %d.\n",
+					     name, STp->default_drvbuffer);
 		}
 	}
 
@@ -1202,7 +1215,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	if (STp->in_use) {
 		spin_unlock(&st_use_lock);
 		scsi_tape_put(STp);
-		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
+		DEB(stdev_printk(ST_DEB_MSG, STp, "%s: Device already in use.\n", name); )
 		return (-EBUSY);
 	}
 
@@ -1222,8 +1235,8 @@ static int st_open(struct inode *inode, struct file *filp)
 
 	/* See that we have at least a one page buffer available */
 	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
-		printk(KERN_WARNING "%s: Can't allocate one page tape buffer.\n",
-		       name);
+		stdev_printk(KERN_WARNING, STp, "%s: Can't allocate one page tape buffer.\n",
+			     name);
 		retval = (-EOVERFLOW);
 		goto err_out;
 	}
@@ -1292,23 +1305,24 @@ static int st_flush(struct file *filp, fl_owner_t id)
 
 	if (STp->can_partitions &&
 	    (result2 = switch_partition(STp)) < 0) {
-                DEBC(printk(ST_DEB_MSG
-                               "%s: switch_partition at close failed.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: switch_partition at close failed.\n", name));
 		if (result == 0)
 			result = result2;
 		goto out;
 	}
 
 	DEBC( if (STp->nbr_requests)
-		printk(KERN_DEBUG "%s: Number of r/w requests %d, dio used in %d, pages %d.\n",
-		       name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages));
+		stdev_printk(KERN_DEBUG, STp,
+			     "%s: Number of r/w requests %d, dio used in %d, pages %d.\n",
+			     name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages));
 
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
 		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-                DEBC(printk(ST_DEB_MSG "%s: Async write waits %d, finished %d.\n",
-                            name, STp->nbr_waits, STp->nbr_finished);
-		)
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Async write waits %d, finished %d.\n",
+				  name, STp->nbr_waits, STp->nbr_finished);)
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_FILEMARKS;
@@ -1343,13 +1357,16 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		else { /* Write error */
 			st_release_request(SRpnt);
 			SRpnt = NULL;
-			printk(KERN_ERR "%s: Error on write filemark.\n", name);
+			stdev_printk(KERN_ERR, STp,
+				     "%s: Error on write filemark.\n", name);
 			if (result == 0)
 				result = (-EIO);
 		}
 
-                DEBC(printk(ST_DEB_MSG "%s: Buffer flushed, %d EOF(s) written\n",
-                            name, cmd[4]));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Buffer flushed, %d EOF(s) written\n",
+				  name, cmd[4]));
+
 	} else if (!STp->rew_at_close) {
 		STps = &(STp->ps[STp->partition]);
 		if (!STm->sysv || STps->rw != ST_READING) {
@@ -1449,7 +1466,7 @@ static ssize_t rw_checks(struct scsi_tape *STp, struct file *filp, size_t count)
 
         DEB(
 	if (!STp->in_use) {
-		printk(ST_DEB_MSG "%s: Incorrect device.\n", tape_name(STp));
+		stdev_printk(ST_DEB_MSG, STp, "%s: Incorrect device.\n", tape_name(STp));
 		retval = (-EIO);
 		goto out;
 	} ) /* end DEB */
@@ -1519,8 +1536,9 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 
 		if (bufsize > STbp->buffer_size &&
 		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
-			printk(KERN_WARNING "%s: Can't allocate %d byte tape buffer.\n",
-			       tape_name(STp), bufsize);
+			stdev_printk(KERN_WARNING, STp,
+				     "%s: Can't allocate %d byte tape buffer.\n",
+				     tape_name(STp), bufsize);
 			retval = (-EOVERFLOW);
 			goto out;
 		}
@@ -1563,6 +1581,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *STbp;
+	char *errmsg;
 	char *name = tape_name(STp);
 
 	if (mutex_lock_interruptible(&STp->lock))
@@ -1574,8 +1593,9 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 
 	/* Write must be integral number of blocks */
 	if (STp->block_size != 0 && (count % STp->block_size) != 0) {
-		printk(KERN_WARNING "%s: Write not multiple of tape block size.\n",
-		       name);
+		stdev_printk(KERN_WARNING, STp,
+			     "%s: Write not multiple of tape block size.\n",
+			     name);
 		retval = (-EINVAL);
 		goto out;
 	}
@@ -1601,8 +1621,9 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		if (STm->default_compression != ST_DONT_TOUCH &&
 		    !(STp->compression_changed)) {
 			if (st_compression(STp, (STm->default_compression == ST_YES))) {
-				printk(KERN_WARNING "%s: Can't set default compression.\n",
-				       name);
+				stdev_printk(KERN_WARNING, STp,
+					     "%s: Can't set default compression.\n",
+					     name);
 				if (modes_defined) {
 					retval = (-EINVAL);
 					goto out;
@@ -1668,8 +1689,10 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 					do_count = count;
 			}
 
-			i = append_to_buffer(b_point, STbp, do_count);
+			i = append_to_buffer(b_point, STbp, do_count, &errmsg);
 			if (i) {
+				stdev_printk(KERN_WARNING, STp, "%s\n",
+					     errmsg);
 				retval = i;
 				goto out;
 			}
@@ -1723,7 +1746,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		if (STbp->syscall_result != 0) {
 			struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-                        DEBC(printk(ST_DEB_MSG "%s: Error on write:\n", name));
+                        DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: Error on write:\n", name));
 			if (cmdstatp->have_sense && (cmdstatp->flags & SENSE_EOM)) {
 				scode = cmdstatp->sense_hdr.sense_key;
 				if (cmdstatp->remainder_valid)
@@ -1750,9 +1773,9 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 					if (STp->block_size == 0 ||
 					    undone > 0 || count == 0)
 						retval = (-ENOSPC); /* EOM within current request */
-                                        DEBC(printk(ST_DEB_MSG
-                                                       "%s: EOM with %d bytes unwritten.\n",
-						       name, (int)count));
+                                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+							  "%s: EOM with %d bytes unwritten.\n",
+							  name, (int)count));
 				} else {
 					/* EOT within data buffered earlier (possible only
 					   in fixed block mode without direct i/o) */
@@ -1765,9 +1788,9 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 								STp->block_size;
 						}
 						STps->eof = ST_EOM_OK;
-						DEBC(printk(ST_DEB_MSG
-							    "%s: Retry write of %d bytes at EOM.\n",
-							    name, STp->buffer->buffer_bytes));
+						DEBC(stdev_printk(ST_DEB_MSG, STp,
+								  "%s: Retry write of %d bytes at EOM.\n",
+								  name, STp->buffer->buffer_bytes));
 						goto retry_write;
 					}
 					else {
@@ -1778,9 +1801,9 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 						STps->eof = ST_EOM_ERROR;
 						STps->drv_block = (-1); /* Too cautious? */
 						retval = (-EIO);	/* EOM for old data */
-						DEBC(printk(ST_DEB_MSG
-							    "%s: EOM with lost data.\n",
-							    name));
+						DEBC(stdev_printk(ST_DEB_MSG, STp,
+								  "%s: EOM with lost data.\n",
+								  name));
 					}
 				}
 			} else {
@@ -1891,12 +1914,13 @@ static long read_tape(struct scsi_tape *STp, long count,
 		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
 		retval = 1;
-		DEBC(printk(ST_DEB_MSG "%s: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
-                            name,
-                            SRpnt->sense[0], SRpnt->sense[1],
-                            SRpnt->sense[2], SRpnt->sense[3],
-                            SRpnt->sense[4], SRpnt->sense[5],
-                            SRpnt->sense[6], SRpnt->sense[7]));
+		DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
+				  name,
+				  SRpnt->sense[0], SRpnt->sense[1],
+				  SRpnt->sense[2], SRpnt->sense[3],
+				  SRpnt->sense[4], SRpnt->sense[5],
+				  SRpnt->sense[6], SRpnt->sense[7]));
 		if (cmdstatp->have_sense) {
 
 			if (cmdstatp->sense_hdr.sense_key == BLANK_CHECK)
@@ -1916,9 +1940,10 @@ static long read_tape(struct scsi_tape *STp, long count,
 					if (STp->block_size == 0) {
 						if (transfer <= 0) {
 							if (transfer < 0)
-								printk(KERN_NOTICE
-								       "%s: Failed to read %d byte block with %d byte transfer.\n",
-								       name, bytes - transfer, bytes);
+								stdev_printk(KERN_NOTICE, STp,
+									     "%s: Failed to read %d byte block with "
+									     "%d byte transfer.\n",
+									     name, bytes - transfer, bytes);
 							if (STps->drv_block >= 0)
 								STps->drv_block += 1;
 							STbp->buffer_bytes = 0;
@@ -1929,7 +1954,8 @@ static long read_tape(struct scsi_tape *STp, long count,
 						st_release_request(SRpnt);
 						SRpnt = *aSRpnt = NULL;
 						if (transfer == blks) {	/* We did not get anything, error */
-							printk(KERN_NOTICE "%s: Incorrect block size.\n", name);
+							stdev_printk(KERN_NOTICE, STp,
+								     "%s: Incorrect block size.\n", name);
 							if (STps->drv_block >= 0)
 								STps->drv_block += blks - transfer + 1;
 							st_int_ioctl(STp, MTBSR, 1);
@@ -1938,9 +1964,9 @@ static long read_tape(struct scsi_tape *STp, long count,
 						/* We have some data, deliver it */
 						STbp->buffer_bytes = (blks - transfer) *
 						    STp->block_size;
-                                                DEBC(printk(ST_DEB_MSG
-                                                            "%s: ILI but enough data received %ld %d.\n",
-                                                            name, count, STbp->buffer_bytes));
+                                                DEBC(stdev_printk(ST_DEB_MSG, STp,
+							    "%s: ILI but enough data received %ld %d.\n",
+							    name, count, STbp->buffer_bytes));
 						if (STps->drv_block >= 0)
 							STps->drv_block += 1;
 						if (st_int_ioctl(STp, MTBSR, 1))
@@ -1956,9 +1982,9 @@ static long read_tape(struct scsi_tape *STp, long count,
 					else
 						STbp->buffer_bytes =
 						    bytes - transfer * STp->block_size;
-                                        DEBC(printk(ST_DEB_MSG
-                                                    "%s: EOF detected (%d bytes read).\n",
-                                                    name, STbp->buffer_bytes));
+                                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+							  "%s: EOF detected (%d bytes read).\n",
+							  name, STbp->buffer_bytes));
 				} else if (cmdstatp->flags & SENSE_EOM) {
 					if (STps->eof == ST_FM)
 						STps->eof = ST_EOD_1;
@@ -1970,20 +1996,21 @@ static long read_tape(struct scsi_tape *STp, long count,
 						STbp->buffer_bytes =
 						    bytes - transfer * STp->block_size;
 
-                                        DEBC(printk(ST_DEB_MSG "%s: EOM detected (%d bytes read).\n",
-                                                    name, STbp->buffer_bytes));
+                                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+							  "%s: EOM detected (%d bytes read).\n",
+							  name, STbp->buffer_bytes));
 				}
 			}
 			/* end of EOF, EOM, ILI test */ 
 			else {	/* nonzero sense key */
-                                DEBC(printk(ST_DEB_MSG
-                                            "%s: Tape error while reading.\n", name));
+                                DEBC(stdev_printk(ST_DEB_MSG, STp,
+						  "%s: Tape error while reading.\n", name));
 				STps->drv_block = (-1);
 				if (STps->eof == ST_FM &&
 				    cmdstatp->sense_hdr.sense_key == BLANK_CHECK) {
-                                        DEBC(printk(ST_DEB_MSG
-                                                    "%s: Zero returned for first BLANK CHECK after EOF.\n",
-                                                    name));
+                                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+							  "%s: Zero returned for first BLANK CHECK after EOF.\n",
+							  name));
 					STps->eof = ST_EOD_2;	/* First BLANK_CHECK after FM */
 				} else	/* Some other extended sense code */
 					retval = (-EIO);
@@ -2028,6 +2055,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *STbp = STp->buffer;
+	char *errmsg;
 	DEB( char *name = tape_name(STp); )
 
 	if (mutex_lock_interruptible(&STp->lock))
@@ -2055,8 +2083,9 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	}
         DEB(
 	if (debugging && STps->eof != ST_NOEOF)
-		printk(ST_DEB_MSG "%s: EOF/EOM flag up (%d). Bytes %d\n", name,
-		       STps->eof, STbp->buffer_bytes);
+		stdev_printk(ST_DEB_MSG, STp,
+			     "%s: EOF/EOM flag up (%d). Bytes %d\n", name,
+			     STps->eof, STbp->buffer_bytes);
         ) /* end DEB */
 
 	retval = setup_buffering(STp, buf, count, 1);
@@ -2106,16 +2135,18 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		if (STbp->buffer_bytes > 0) {
                         DEB(
 			if (debugging && STps->eof != ST_NOEOF)
-				printk(ST_DEB_MSG
-                                       "%s: EOF up (%d). Left %d, needed %d.\n", name,
-				       STps->eof, STbp->buffer_bytes,
-                                       (int)(count - total));
+				stdev_printk(ST_DEB_MSG, STp,
+					     "%s: EOF up (%d). Left %d, needed %d.\n", name,
+					     STps->eof, STbp->buffer_bytes,
+					     (int)(count - total));
                         ) /* end DEB */
 			transfer = STbp->buffer_bytes < count - total ?
 			    STbp->buffer_bytes : count - total;
 			if (!do_dio) {
-				i = from_buffer(STbp, buf, transfer);
+				i = from_buffer(STbp, buf, transfer, &errmsg);
 				if (i) {
+					stdev_printk(KERN_WARNING, STp, "%s\n",
+						     errmsg);
 					retval = i;
 					goto out;
 				}
@@ -2169,23 +2200,22 @@ DEB(
 static void st_log_options(struct scsi_tape * STp, struct st_modedef * STm, char *name)
 {
 	if (debugging) {
-		printk(KERN_INFO
-		       "%s: Mode %d options: buffer writes: %d, async writes: %d, read ahead: %d\n",
-		       name, STp->current_mode, STm->do_buffer_writes, STm->do_async_writes,
-		       STm->do_read_ahead);
-		printk(KERN_INFO
-		       "%s:    can bsr: %d, two FMs: %d, fast mteom: %d, auto lock: %d,\n",
-		       name, STp->can_bsr, STp->two_fm, STp->fast_mteom, STp->do_auto_lock);
-		printk(KERN_INFO
-		       "%s:    defs for wr: %d, no block limits: %d, partitions: %d, s2 log: %d\n",
-		       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_partitions,
-		       STp->scsi2_logical);
-		printk(KERN_INFO
-		       "%s:    sysv: %d nowait: %d sili: %d nowait_filemark: %d\n",
-		       name, STm->sysv, STp->immediate, STp->sili,
-		       STp->immediate_filemark);
-		printk(KERN_INFO "%s:    debugging: %d\n",
-		       name, debugging);
+		stdev_printk(KERN_INFO, STp,
+			     "%s: Mode %d options: buffer writes: %d, async writes: %d, read ahead: %d\n",
+			     name, STp->current_mode, STm->do_buffer_writes, STm->do_async_writes,
+			     STm->do_read_ahead);
+		stdev_printk(KERN_INFO, STp,
+			     "%s:    can bsr: %d, two FMs: %d, fast mteom: %d, auto lock: %d,\n",
+			     name, STp->can_bsr, STp->two_fm, STp->fast_mteom, STp->do_auto_lock);
+		stdev_printk(KERN_INFO, STp,
+			     "%s:    defs for wr: %d, no block limits: %d, partitions: %d, s2 log: %d\n",
+			     name, STm->defaults_for_writes, STp->omit_blklims, STp->can_partitions,
+			     STp->scsi2_logical);
+		stdev_printk(KERN_INFO, STp,
+			     "%s:    sysv: %d nowait: %d sili: %d nowait_filemark: %d\n",
+			     name, STm->sysv, STp->immediate, STp->sili,
+			     STp->immediate_filemark);
+		stdev_printk(KERN_INFO, STp, "%s:    debugging: %d\n", name, debugging);
 	}
 }
 	)
@@ -2205,9 +2235,9 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		memcpy(STm, &(STp->modes[0]), sizeof(struct st_modedef));
 		STm->cdevs[0] = cd0; STm->cdevs[1] = cd1;
 		modes_defined = 1;
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Initialized mode %d definition from mode 0\n",
-                            name, STp->current_mode));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Initialized mode %d definition from mode 0\n",
+				  name, STp->current_mode));
 	}
 
 	code = options & MT_ST_OPTIONS;
@@ -2273,11 +2303,13 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		value = (options & ~MT_ST_OPTIONS);
 		if (value == ~MT_ST_OPTIONS) {
 			STm->default_blksize = (-1);
-			DEBC( printk(KERN_INFO "%s: Default block size disabled.\n", name));
+			DEBC(stdev_printk(KERN_INFO, STp,
+					  "%s: Default block size disabled.\n", name));
 		} else {
 			STm->default_blksize = value;
-			DEBC( printk(KERN_INFO "%s: Default block size set to %d bytes.\n",
-			       name, STm->default_blksize));
+			DEBC(stdev_printk(KERN_INFO, STp,
+					  "%s: Default block size set to %d bytes.\n",
+					  name, STm->default_blksize));
 			if (STp->ready == ST_READY) {
 				STp->blksize_changed = 0;
 				set_mode_densblk(STp, STm);
@@ -2287,13 +2319,15 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		value = (options & ~MT_ST_OPTIONS);
 		if ((value & MT_ST_SET_LONG_TIMEOUT) != 0) {
 			STp->long_timeout = (value & ~MT_ST_SET_LONG_TIMEOUT) * HZ;
-			DEBC( printk(KERN_INFO "%s: Long timeout set to %d seconds.\n", name,
-			       (value & ~MT_ST_SET_LONG_TIMEOUT)));
+			DEBC(stdev_printk(KERN_INFO, STp,
+					  "%s: Long timeout set to %d seconds.\n", name,
+					  (value & ~MT_ST_SET_LONG_TIMEOUT)));
 		} else {
 			blk_queue_rq_timeout(STp->device->request_queue,
 					     value * HZ);
-			DEBC( printk(KERN_INFO "%s: Normal timeout set to %d seconds.\n",
-				name, value) );
+			DEBC(stdev_printk(KERN_INFO, STp,
+					  "%s: Normal timeout set to %d seconds.\n",
+					  name, value) );
 		}
 	} else if (code == MT_ST_SET_CLN) {
 		value = (options & ~MT_ST_OPTIONS) & 0xff;
@@ -2304,21 +2338,23 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		STp->cln_mode = value;
 		STp->cln_sense_mask = (options >> 8) & 0xff;
 		STp->cln_sense_value = (options >> 16) & 0xff;
-		printk(KERN_INFO
-		       "%s: Cleaning request mode %d, mask %02x, value %02x\n",
-		       name, value, STp->cln_sense_mask, STp->cln_sense_value);
+		stdev_printk(KERN_INFO, STp,
+			     "%s: Cleaning request mode %d, mask %02x, value %02x\n",
+			     name, value, STp->cln_sense_mask, STp->cln_sense_value);
 	} else if (code == MT_ST_DEF_OPTIONS) {
 		code = (options & ~MT_ST_CLEAR_DEFAULT);
 		value = (options & MT_ST_CLEAR_DEFAULT);
 		if (code == MT_ST_DEF_DENSITY) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
 				STm->default_density = (-1);
-				DEBC( printk(KERN_INFO "%s: Density default disabled.\n",
-                                       name));
+				DEBC(stdev_printk(KERN_INFO, STp,
+						  "%s: Density default disabled.\n",
+						  name));
 			} else {
 				STm->default_density = value & 0xff;
-				DEBC( printk(KERN_INFO "%s: Density default set to %x\n",
-				       name, STm->default_density));
+				DEBC(stdev_printk(KERN_INFO, STp,
+						  "%s: Density default set to %x\n",
+						  name, STm->default_density));
 				if (STp->ready == ST_READY) {
 					STp->density_changed = 0;
 					set_mode_densblk(STp, STm);
@@ -2327,31 +2363,35 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		} else if (code == MT_ST_DEF_DRVBUFFER) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
 				STp->default_drvbuffer = 0xff;
-				DEBC( printk(KERN_INFO
-                                       "%s: Drive buffer default disabled.\n", name));
+				DEBC(stdev_printk(KERN_INFO, STp,
+						  "%s: Drive buffer default disabled.\n",
+						  name));
 			} else {
 				STp->default_drvbuffer = value & 7;
-				DEBC( printk(KERN_INFO
-                                       "%s: Drive buffer default set to %x\n",
-				       name, STp->default_drvbuffer));
+				DEBC(stdev_printk(KERN_INFO, STp,
+						  "%s: Drive buffer default set to %x\n",
+						  name, STp->default_drvbuffer));
 				if (STp->ready == ST_READY)
 					st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer);
 			}
 		} else if (code == MT_ST_DEF_COMPRESSION) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
 				STm->default_compression = ST_DONT_TOUCH;
-				DEBC( printk(KERN_INFO
-                                       "%s: Compression default disabled.\n", name));
+				DEBC(stdev_printk(KERN_INFO, STp,
+						  "%s: Compression default disabled.\n",
+						  name));
 			} else {
 				if ((value & 0xff00) != 0) {
 					STp->c_algo = (value & 0xff00) >> 8;
-					DEBC( printk(KERN_INFO "%s: Compression algorithm set to 0x%x.\n",
-					       name, STp->c_algo));
+					DEBC(stdev_printk(KERN_INFO, STp,
+							  "%s: Compression algorithm set to 0x%x.\n",
+							  name, STp->c_algo));
 				}
 				if ((value & 0xff) != 0xff) {
 					STm->default_compression = (value & 1 ? ST_YES : ST_NO);
-					DEBC( printk(KERN_INFO "%s: Compression default set to %x\n",
-					       name, (value & 1)));
+					DEBC(stdev_printk(KERN_INFO, STp,
+							  "%s: Compression default set to %x\n",
+							  name, (value & 1)));
 					if (STp->ready == ST_READY) {
 						STp->compression_changed = 0;
 						st_compression(STp, (STm->default_compression == ST_YES));
@@ -2474,18 +2514,21 @@ static int st_compression(struct scsi_tape * STp, int state)
 	/* Read the current page contents */
 	retval = read_mode_page(STp, COMPRESSION_PAGE, 0);
 	if (retval) {
-                DEBC(printk(ST_DEB_MSG "%s: Compression mode page not supported.\n",
-                            name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Compression mode page not supported.\n",
+				  name));
 		return (-EIO);
 	}
 
 	mpoffs = MODE_HEADER_LENGTH + b_data[MH_OFF_BDESCS_LENGTH];
-        DEBC(printk(ST_DEB_MSG "%s: Compression state is %d.\n", name,
-                    (b_data[mpoffs + CP_OFF_DCE_DCC] & DCE_MASK ? 1 : 0)));
+        DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: Compression state is %d.\n", name,
+			  (b_data[mpoffs + CP_OFF_DCE_DCC] & DCE_MASK ? 1 : 0)));
 
 	/* Check if compression can be changed */
 	if ((b_data[mpoffs + CP_OFF_DCE_DCC] & DCC_MASK) == 0) {
-                DEBC(printk(ST_DEB_MSG "%s: Compression not supported.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Compression not supported.\n", name));
 		return (-EIO);
 	}
 
@@ -2503,11 +2546,13 @@ static int st_compression(struct scsi_tape * STp, int state)
 
 	retval = write_mode_page(STp, COMPRESSION_PAGE, 0);
 	if (retval) {
-                DEBC(printk(ST_DEB_MSG "%s: Compression change failed.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Compression change failed.\n", name));
 		return (-EIO);
 	}
-        DEBC(printk(ST_DEB_MSG "%s: Compression state changed to %d.\n",
-		       name, state));
+        DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: Compression state changed to %d.\n",
+			  name, state));
 
 	STp->compression_changed = 1;
 	return 0;
@@ -2539,9 +2584,10 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 	 */
 	if (load_code >= 1 + MT_ST_HPLOADER_OFFSET
 	    && load_code <= 6 + MT_ST_HPLOADER_OFFSET) {
-		DEBC(printk(ST_DEB_MSG "%s: Enhanced %sload slot %2d.\n",
-			    name, (cmd[4]) ? "" : "un",
-			    load_code - MT_ST_HPLOADER_OFFSET));
+		DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Enhanced %sload slot %2d.\n",
+				  name, (cmd[4]) ? "" : "un",
+				  load_code - MT_ST_HPLOADER_OFFSET));
 		cmd[3] = load_code - MT_ST_HPLOADER_OFFSET; /* MediaID field of C1553A */
 	}
 	if (STp->immediate) {
@@ -2553,10 +2599,12 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 
 	DEBC(
 		if (!load_code)
-		printk(ST_DEB_MSG "%s: Unloading tape.\n", name);
+			stdev_printk(ST_DEB_MSG, STp,
+				     "%s: Unloading tape.\n", name);
 		else
-		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
-		);
+			stdev_printk(ST_DEB_MSG, STp,
+				     "%s: Loading tape.\n", name);
+	    );
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
 			   timeout, MAX_RETRIES, 1);
@@ -2590,16 +2638,18 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 #if DEBUG
 #define ST_DEB_FORWARD  0
 #define ST_DEB_BACKWARD 1
-static void deb_space_print(char *name, int direction, char *units, unsigned char *cmd)
+static void deb_space_print(struct scsi_tape *STp, int direction,
+				char *units, unsigned char *cmd)
 {
 	s32 sc;
+	char *name = tape_name(STp);
 
 	sc = cmd[2] & 0x80 ? 0xff000000 : 0;
 	sc |= (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
 	if (direction)
 		sc = -sc;
-	printk(ST_DEB_MSG "%s: Spacing tape %s over %d %s.\n", name,
-	       direction ? "backward" : "forward", sc, units);
+	stdev_printk(ST_DEB_MSG, STp, "%s: Spacing tape %s over %d %s.\n", name,
+		     direction ? "backward" : "forward", sc, units);
 }
 #endif
 
@@ -2641,7 +2691,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-                DEBC(deb_space_print(name, ST_DEB_FORWARD, "filemarks", cmd);)
+                DEBC(deb_space_print(STp, ST_DEB_FORWARD, "filemarks", cmd);)
 		if (fileno >= 0)
 			fileno += arg;
 		blkno = 0;
@@ -2656,7 +2706,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (ltmp >> 16);
 		cmd[3] = (ltmp >> 8);
 		cmd[4] = ltmp;
-                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "filemarks", cmd);)
+                DEBC(deb_space_print(STp, ST_DEB_BACKWARD, "filemarks", cmd);)
 		if (fileno >= 0)
 			fileno -= arg;
 		blkno = (-1);	/* We can't know the block number */
@@ -2668,7 +2718,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-                DEBC(deb_space_print(name, ST_DEB_FORWARD, "blocks", cmd);)
+                DEBC(deb_space_print(STp, ST_DEB_FORWARD, "blocks", cmd);)
 		if (blkno >= 0)
 			blkno += arg;
 		at_sm &= (arg == 0);
@@ -2680,7 +2730,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (ltmp >> 16);
 		cmd[3] = (ltmp >> 8);
 		cmd[4] = ltmp;
-                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "blocks", cmd);)
+                DEBC(deb_space_print(STp, ST_DEB_BACKWARD, "blocks", cmd);)
 		if (blkno >= 0)
 			blkno -= arg;
 		at_sm &= (arg == 0);
@@ -2691,7 +2741,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-                DEBC(deb_space_print(name, ST_DEB_FORWARD, "setmarks", cmd);)
+                DEBC(deb_space_print(STp, ST_DEB_FORWARD, "setmarks", cmd);)
 		if (arg != 0) {
 			blkno = fileno = (-1);
 			at_sm = 1;
@@ -2704,7 +2754,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[2] = (ltmp >> 16);
 		cmd[3] = (ltmp >> 8);
 		cmd[4] = ltmp;
-                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "setmarks", cmd);)
+                DEBC(deb_space_print(STp, ST_DEB_BACKWARD, "setmarks", cmd);)
 		if (arg != 0) {
 			blkno = fileno = (-1);
 			at_sm = 1;
@@ -2727,11 +2777,13 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		timeout = STp->device->request_queue->rq_timeout;
                 DEBC(
 		     if (cmd_in != MTWSM)
-                               printk(ST_DEB_MSG "%s: Writing %d filemarks.\n", name,
-				 cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
+				stdev_printk(ST_DEB_MSG, STp,
+					     "%s: Writing %d filemarks.\n", name,
+					     cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
                      else
-				printk(ST_DEB_MSG "%s: Writing %d setmarks.\n", name,
-				 cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
+				stdev_printk(ST_DEB_MSG, STp,
+					     "%s: Writing %d setmarks.\n", name,
+					     cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
 		)
 		if (fileno >= 0)
 			fileno += arg;
@@ -2744,11 +2796,11 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			cmd[1] = 1;	/* Don't wait for completion */
 			timeout = STp->device->request_queue->rq_timeout;
 		}
-                DEBC(printk(ST_DEB_MSG "%s: Rewinding tape.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: Rewinding tape.\n", name));
 		fileno = blkno = at_sm = 0;
 		break;
 	case MTNOP:
-                DEBC(printk(ST_DEB_MSG "%s: No op on tape.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: No op on tape.\n", name));
 		return 0;	/* Should do something ? */
 		break;
 	case MTRETEN:
@@ -2758,7 +2810,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->device->request_queue->rq_timeout;
 		}
 		cmd[4] = 3;
-                DEBC(printk(ST_DEB_MSG "%s: Retensioning tape.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: Retensioning tape.\n", name));
 		fileno = blkno = at_sm = 0;
 		break;
 	case MTEOM:
@@ -2776,8 +2828,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			fileno = (-1);
 		cmd[0] = SPACE;
 		cmd[1] = 3;
-                DEBC(printk(ST_DEB_MSG "%s: Spacing to end of recorded medium.\n",
-                            name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Spacing to end of recorded medium.\n",
+				  name));
 		blkno = -1;
 		at_sm = 0;
 		break;
@@ -2793,7 +2846,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		else
 			timeout = STp->long_timeout * 8;
 
-                DEBC(printk(ST_DEB_MSG "%s: Erasing tape.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp, "%s: Erasing tape.\n", name));
 		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
@@ -2808,7 +2861,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		    STp->max_block > 0 &&
 		    ((arg & MT_ST_BLKSIZE_MASK) < STp->min_block ||
 		     (arg & MT_ST_BLKSIZE_MASK) > STp->max_block)) {
-			printk(KERN_WARNING "%s: Illegal block size.\n", name);
+			stdev_printk(KERN_WARNING, STp, "%s: Illegal block size.\n", name);
 			return (-EINVAL);
 		}
 		cmd[0] = MODE_SELECT;
@@ -2843,19 +2896,19 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		timeout = STp->device->request_queue->rq_timeout;
                 DEBC(
 			if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK)
-				printk(ST_DEB_MSG
-                                       "%s: Setting block size to %d bytes.\n", name,
-				       (STp->buffer)->b_data[9] * 65536 +
-				       (STp->buffer)->b_data[10] * 256 +
-				       (STp->buffer)->b_data[11]);
+				stdev_printk(ST_DEB_MSG, STp,
+					     "%s: Setting block size to %d bytes.\n", name,
+					     (STp->buffer)->b_data[9] * 65536 +
+					     (STp->buffer)->b_data[10] * 256 +
+					     (STp->buffer)->b_data[11]);
 			if (cmd_in == MTSETDENSITY || cmd_in == SET_DENS_AND_BLK)
-				printk(ST_DEB_MSG
-                                       "%s: Setting density code to %x.\n", name,
-				       (STp->buffer)->b_data[4]);
+				stdev_printk(ST_DEB_MSG, STp,
+					     "%s: Setting density code to %x.\n", name,
+					     (STp->buffer)->b_data[4]);
 			if (cmd_in == MTSETDRVBUFFER)
-				printk(ST_DEB_MSG
-                                       "%s: Setting drive buffer code to %d.\n", name,
-				    ((STp->buffer)->b_data[2] >> 4) & 7);
+				stdev_printk(ST_DEB_MSG, STp,
+					     "%s: Setting drive buffer code to %d.\n", name,
+					     ((STp->buffer)->b_data[2] >> 4) & 7);
 		)
 		break;
 	default:
@@ -3036,7 +3089,8 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
 	    (STp->device->scsi_level >= SCSI_2 &&
 	     ((STp->buffer)->b_data[0] & 4) != 0)) {
 		*block = *partition = 0;
-                DEBC(printk(ST_DEB_MSG "%s: Can't read tape position.\n", name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Can't read tape position.\n", name));
 		result = (-EIO);
 	} else {
 		result = 0;
@@ -3055,8 +3109,9 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
 			    (STp->buffer)->b_data[1] == 0)	/* BOP of partition 0 */
 				STp->ps[0].drv_block = STp->ps[0].drv_file = 0;
 		}
-                DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
-                            *block, *partition));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Got tape pos. blk %d part %d.\n", name,
+				  *block, *partition));
 	}
 	st_release_request(SRpnt);
 	SRpnt = NULL;
@@ -3083,8 +3138,9 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 	timeout = STp->long_timeout;
 	STps = &(STp->ps[STp->partition]);
 
-        DEBC(printk(ST_DEB_MSG "%s: Setting block to %d and partition to %d.\n",
-                    name, block, partition));
+        DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: Setting block to %d and partition to %d.\n",
+			  name, block, partition));
 	DEB(if (partition < 0)
 		return (-EIO); )
 
@@ -3098,9 +3154,9 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 		else {
 			STps->last_block_valid = 1;
 			STps->last_block_visited = blk;
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Visited block %d for partition %d saved.\n",
-                                    name, blk, STp->partition));
+                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+					  "%s: Visited block %d for partition %d saved.\n",
+					  name, blk, STp->partition));
 		}
 	}
 
@@ -3122,9 +3178,9 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 		if (STp->partition != partition) {
 			scmd[1] |= 2;
 			scmd[8] = partition;
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Trying to change partition from %d to %d\n",
-                                    name, STp->partition, partition));
+                        DEBC(stdev_printk(ST_DEB_MSG, STp,
+					  "%s: Trying to change partition from %d to %d\n",
+					  name, STp->partition, partition));
 		}
 	}
 	if (STp->immediate) {
@@ -3223,13 +3279,16 @@ static int nbr_partitions(struct scsi_tape *STp)
 	result = read_mode_page(STp, PART_PAGE, 1);
 
 	if (result) {
-                DEBC(printk(ST_DEB_MSG "%s: Can't read medium partition page.\n",
-                            name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Can't read medium partition page.\n",
+				  name));
 		result = (-EIO);
 	} else {
 		result = (STp->buffer)->b_data[MODE_HEADER_LENGTH +
 					      PP_OFF_NBR_ADD_PARTS] + 1;
-                DEBC(printk(ST_DEB_MSG "%s: Number of partitions %d.\n", name, result));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Number of partitions %d.\n",
+				  name, result));
 	}
 
 	return result;
@@ -3264,14 +3323,16 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 	result = read_mode_page(STp, PART_PAGE, 0);
 	if (result) {
-		DEBC(printk(ST_DEB_MSG "%s: Can't read partition mode page.\n", name));
+		DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Can't read partition mode page.\n", name));
 		return result;
 	}
 	/* The mode page is in the buffer. Let's modify it and write it. */
 	bp = (STp->buffer)->b_data;
 	pgo = MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
-	DEBC(printk(ST_DEB_MSG "%s: Partition page length is %d bytes.\n",
-		    name, bp[pgo + MP_OFF_PAGE_LENGTH] + 2));
+	DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: Partition page length is %d bytes.\n",
+			  name, bp[pgo + MP_OFF_PAGE_LENGTH] + 2));
 
 	psd_cnt = (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGTH) / 2;
 	psdo = pgo + PART_PAGE_FIXED_LENGTH;
@@ -3281,25 +3342,27 @@ static int partition_tape(struct scsi_tape *STp, int size)
 	}
 	memset(bp + psdo, 0, bp[pgo + PP_OFF_NBR_ADD_PARTS] * 2);
 
-	DEBC(printk("%s: psd_cnt %d, max.parts %d, nbr_parts %d\n", name,
-		    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
-		    bp[pgo + PP_OFF_NBR_ADD_PARTS]));
+	DEBC(stdev_printk(ST_DEB_MSG, STp,
+			  "%s: psd_cnt %d, max.parts %d, nbr_parts %d\n",
+			  name, psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
+			  bp[pgo + PP_OFF_NBR_ADD_PARTS]));
 
 	if (size <= 0) {
 		bp[pgo + PP_OFF_NBR_ADD_PARTS] = 0;
 		if (psd_cnt <= bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] = 6;
-                DEBC(printk(ST_DEB_MSG "%s: Formatting tape with one partition.\n",
-                            name));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Formatting tape with one partition.\n",
+				  name));
 	} else {
 		bp[psdo] = (size >> 8) & 0xff;
 		bp[psdo + 1] = size & 0xff;
 		bp[pgo + 3] = 1;
 		if (bp[pgo + MP_OFF_PAGE_LENGTH] < 8)
 		    bp[pgo + MP_OFF_PAGE_LENGTH] = 8;
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Formatting tape with two partitions (1 = %d MB).\n",
-                            name, size));
+                DEBC(stdev_printk(ST_DEB_MSG, STp,
+				  "%s: Formatting tape with two partitions (1 = %d MB).\n",
+				  name, size));
 	}
 	bp[pgo + PP_OFF_PART_UNITS] = 0;
 	bp[pgo + PP_OFF_RESERVED] = 0;
@@ -3307,7 +3370,8 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 	result = write_mode_page(STp, PART_PAGE, 1);
 	if (result) {
-		printk(KERN_INFO "%s: Partitioning of tape failed.\n", name);
+		stdev_printk(KERN_INFO, STp,
+			     "%s: Partitioning of tape failed.\n", name);
 		result = (-EIO);
 	}
 
@@ -3333,7 +3397,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 
         DEB(
 	if (debugging && !STp->in_use) {
-		printk(ST_DEB_MSG "%s: Incorrect device.\n", name);
+		stdev_printk(ST_DEB_MSG, STp, "%s: Incorrect device.\n", name);
 		retval = (-EIO);
 		goto out;
 	} ) /* end DEB */
@@ -3371,8 +3435,9 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		}
 
 		if (mtc.mt_op == MTSETDRVBUFFER && !capable(CAP_SYS_ADMIN)) {
-			printk(KERN_WARNING
-                               "%s: MTSETDRVBUFFER only allowed for root.\n", name);
+			stdev_printk(KERN_WARNING, STp,
+				     "%s: MTSETDRVBUFFER only allowed for root.\n",
+				     name);
 			retval = (-EPERM);
 			goto out;
 		}
@@ -3694,10 +3759,9 @@ static struct st_buffer *new_tape_buffer(int need_dma, int max_sg)
 	struct st_buffer *tb;
 
 	tb = kzalloc(sizeof(struct st_buffer), GFP_ATOMIC);
-	if (!tb) {
-		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
+	if (!tb)
 		return NULL;
-	}
+
 	tb->frp_segs = 0;
 	tb->use_sg = max_sg;
 	tb->dma = need_dma;
@@ -3808,31 +3872,37 @@ static void normalize_buffer(struct st_buffer * STbuffer)
 
 /* Move data from the user buffer to the tape buffer. Returns zero (success) or
    negative error code. */
-static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count)
+static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, int do_count, char **errmsg)
 {
 	int i, cnt, res, offset;
 	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
+	*errmsg = NULL;
+
 	for (i = 0, offset = st_bp->buffer_bytes;
 	     i < st_bp->frp_segs && offset >= length; i++)
 		offset -= length;
 	if (i == st_bp->frp_segs) {	/* Should never happen */
-		printk(KERN_WARNING "st: append_to_buffer offset overflow.\n");
+		*errmsg = "st: append_to_buffer: offset overflow.";
 		return (-EIO);
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
 		struct page *page = st_bp->reserved_pages[i];
 		cnt = length - offset < do_count ? length - offset : do_count;
 		res = copy_from_user(page_address(page) + offset, ubp, cnt);
-		if (res)
+		if (res) {
+			*errmsg = "st: append_to_buffer: copy_to_user() failed.";
 			return (-EFAULT);
+		}
 		do_count -= cnt;
 		st_bp->buffer_bytes += cnt;
 		ubp += cnt;
 		offset = 0;
 	}
-	if (do_count) /* Should never happen */
+	if (do_count) { /* Should never happen */
+		*errmsg = "st: append_to_buffer: do_count != 0.";
 		return (-EIO);
+	}
 
 	return 0;
 }
@@ -3840,32 +3910,38 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 
 /* Move data from the tape buffer to the user buffer. Returns zero (success) or
    negative error code. */
-static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
+static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count, char **errmsg)
 {
 	int i, cnt, res, offset;
 	int length = PAGE_SIZE << st_bp->reserved_page_order;
 
+	*errmsg = NULL;
+
 	for (i = 0, offset = st_bp->read_pointer;
 	     i < st_bp->frp_segs && offset >= length; i++)
 		offset -= length;
 	if (i == st_bp->frp_segs) {	/* Should never happen */
-		printk(KERN_WARNING "st: from_buffer offset overflow.\n");
+		*errmsg = "st: from_buffer: offset overflow.";
 		return (-EIO);
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
 		struct page *page = st_bp->reserved_pages[i];
 		cnt = length - offset < do_count ? length - offset : do_count;
 		res = copy_to_user(ubp, page_address(page) + offset, cnt);
-		if (res)
+		if (res) {
+			*errmsg = "st: from_buffer: copy_to_user() failed.";
 			return (-EFAULT);
+		}
 		do_count -= cnt;
 		st_bp->buffer_bytes -= cnt;
 		st_bp->read_pointer += cnt;
 		ubp += cnt;
 		offset = 0;
 	}
-	if (do_count) /* Should never happen */
+	if (do_count) { /* Should never happen */
+		*errmsg = "st: from_buffer: do_count != 0.";
 		return (-EIO);
+	}
 
 	return 0;
 }
@@ -3996,7 +4072,9 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 
 	cdev = cdev_alloc();
 	if (!cdev) {
-		pr_err("st%d: out of memory. Device not attached.\n", dev_num);
+		stdev_printk(KERN_ERR, tape,
+			     "st%d: out of memory. Device not attached.\n",
+			     dev_num);
 		error = -ENOMEM;
 		goto out;
 	}
@@ -4005,9 +4083,12 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 
 	error = cdev_add(cdev, cdev_devno, 1);
 	if (error) {
-		pr_err("st%d: Can't add %s-rewind mode %d\n", dev_num,
-		       rew ? "non" : "auto", mode);
-		pr_err("st%d: Device not attached.\n", dev_num);
+		stdev_printk(KERN_ERR, tape,
+			     "st%d: Can't add %s-rewind mode %d\n",
+			     dev_num, rew ? "non" : "auto", mode);
+		stdev_printk(KERN_ERR, tape,
+			     "st%d: Device not attached.\n",
+			     dev_num);
 		goto out_free;
 	}
 	STm->cdevs[rew] = cdev;
@@ -4019,7 +4100,8 @@ static int create_one_cdev(struct scsi_tape *tape, int mode, int rew)
 	dev = device_create(&st_sysfs_class, &tape->device->sdev_gendev,
 			    cdev_devno, &tape->modes[mode], "%s", name);
 	if (IS_ERR(dev)) {
-		pr_err("st%d: device_create failed\n", dev_num);
+		stdev_printk(KERN_ERR, tape, "st%d: device_create failed\n",
+			     dev_num);
 		error = PTR_ERR(dev);
 		goto out_free;
 	}
@@ -4080,7 +4162,7 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	if ((stp = st_incompatible(SDp))) {
 		sdev_printk(KERN_INFO, SDp, "Found incompatible tape\n");
-		printk(KERN_INFO "st: The suggested driver is %s.\n", stp);
+		sdev_printk(KERN_INFO, SDp, "st: The suggested driver is %s.\n", stp);
 		return -ENODEV;
 	}
 
@@ -4089,20 +4171,22 @@ static int st_probe(struct device *dev)
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer((SDp->host)->unchecked_isa_dma, i);
 	if (buffer == NULL) {
-		printk(KERN_ERR
-		       "st: Can't allocate new tape buffer. Device not attached.\n");
+		sdev_printk(KERN_ERR, SDp,
+			    "st: Can't allocate new tape buffer. Device not attached.\n");
 		goto out;
 	}
 
 	disk = alloc_disk(1);
 	if (!disk) {
-		printk(KERN_ERR "st: out of memory. Device not attached.\n");
+		sdev_printk(KERN_ERR, SDp,
+			    "st: out of memory. Device not attached.\n");
 		goto out_buffer_free;
 	}
 
 	tpnt = kzalloc(sizeof(struct scsi_tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
-		printk(KERN_ERR "st: Can't allocate device descriptor.\n");
+		sdev_printk(KERN_ERR, SDp,
+			    "st: Can't allocate device descriptor.\n");
 		goto out_put_disk;
 	}
 	kref_init(&tpnt->kref);
@@ -4185,7 +4269,8 @@ static int st_probe(struct device *dev)
 	spin_unlock(&st_index_lock);
 	idr_preload_end();
 	if (error < 0) {
-		pr_warn("st: idr allocation failed: %d\n", error);
+		sdev_printk(KERN_WARNING, SDp,
+			    "st: idr allocation failed: %d\n", error);
 		goto out_put_queue;
 	}
 	tpnt->index = error;
-- 
Maurizio Lombardi

