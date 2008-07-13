From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [RFC, PATCH v2] SCSI tape: MTIOCSENSE ioctl to return the sense data
 from errors
Date: Sun, 13 Jul 2008 17:24:59 +0300 (EEST)
Message-ID: <alpine.LNX.1.10.0807131723510.16437@kai.makisara.local>
References: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:59459 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYGMOZG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2008 10:25:06 -0400
In-Reply-To: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arne Wiebalck <arne.wiebalck@cern.ch>

Here is the second version of the proposed MTIOCSENSE patch. The changes from
the first version are:

1. The command descriptor block (up to 16 bytes) is included in the
result. The cost is small but the exact command can be useful in
interpretation of the sense data.

2. The residual from the HBA is included in the returned data.

3. Randy's documentation fix.

4. Computation of the length field uses also the additional length field in
the sense data.

The stsense utility at URL http://www.kolumbus.fi/kai.makisara/st.html has 
been updated to use the new ioctl definition.

The patch below this text applies to 2.6.26-rc9 plus the two bug fixes I have
sent to linux-scsi (applies with offsets without these fixes).

Kai

-----------------------8<-----------------------------------------------
diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
index 4075260..1f6ff53 100644
--- a/Documentation/scsi/st.txt
+++ b/Documentation/scsi/st.txt
@@ -291,6 +291,8 @@ The supported ioctls are:
 
 The following use the structure mtop:
 
+MTIOCTOP implements the following operations
+
 MTFSF   Space forward over count filemarks. Tape positioned after filemark.
 MTFSFM  As above but tape positioned before filemark.
 MTBSF	Space backward over count filemarks. Tape positioned before
@@ -457,6 +459,22 @@ MTIOCGET Returns some status information.
 	is set if there is no tape in the drive. GMT_EOD means either
 	end of recorded data or end of tape. GMT_EOT means end of tape.
 
+The following ioctl uses the structure mtsense to return error information:
+MTIOCSENSE returns the sense data from the previous "interesting" SCSI command
+	resulting in CHECK CONDITION. Sense data is not saved from a command
+	if it is used only for supporting the implementation of the tape
+	semantics and the sense data from that command would overwrite the
+	sense data from the error interesting to the user. For instance, error
+	from backspacing over a block by st after a read error does not
+	overwrite the sense data from the read. The field 'latest' tells if
+	the sense data is from the previous SCSI command sent to the device
+	(all SCSI commands are counted). The cdb array contains the command
+	block from the command resulting in the sense data. The field length
+	tells the length of the sense data returned by this ioctl (it may be
+	smaller than the length of the sense data the device provides if the
+	it is limited by the HBA driver or SCSI midlevel). The field residual
+	tells the residual byte count returned by the HBA driver. Note
+	that all HBA drivers may not return correct residual.
 
 MISCELLANEOUS COMPILE OPTIONS
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1986ebc..2726205 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20080504";
+static const char *verstr = "20080713";
 
 #include <linux/module.h>
 
@@ -352,14 +352,22 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	char *name = tape_name(STp);
 	struct st_cmdstatus *cmdstatp;
 
+	STp->saved_sense_latest = 0;
 	if (!result)
 		return 0;
 
 	cmdstatp = &STp->buffer->cmdstat;
 	st_analyze_sense(SRpnt, cmdstatp);
 
-	if (cmdstatp->have_sense)
+	if (cmdstatp->have_sense) {
 		scode = STp->buffer->cmdstat.sense_hdr.sense_key;
+		if (SRpnt->save_sense) {
+			memcpy(STp->saved_sense_cmd, SRpnt->cmd, MAX_COMMAND_SIZE);
+			memcpy(STp->saved_sense, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			STp->saved_sense_latest = 1;
+			STp->saved_residual = STp->buffer->cmdstat.residual;
+		}
+	}
 	else
 		scode = 0;
 
@@ -465,7 +473,7 @@ static void st_release_request(struct st_request *streq)
    has finished. */
 static struct st_request *
 st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd,
-	   int bytes, int direction, int timeout, int retries, int do_wait)
+	   int bytes, int direction, int timeout, int retries, int do_wait, int save_sense)
 {
 	struct completion *waiting;
 
@@ -491,6 +499,7 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 				(STp->buffer)->syscall_result = (-EBUSY);
 			return NULL;
 		}
+		SRpnt->save_sense = save_sense;
 		SRpnt->stp = STp;
 	}
 
@@ -612,7 +621,7 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 		   tape_name(STp), forward ? "forward" : "backward"));
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->timeout, MAX_RETRIES, 1, 0);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -656,7 +665,7 @@ static int st_flush_write_buffer(struct scsi_tape * STp)
 		cmd[4] = blks;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, transfer, DMA_TO_DEVICE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+				   STp->device->timeout, MAX_WRITE_RETRIES, 1, 1);
 		if (!SRpnt)
 			return (STp->buffer)->syscall_result;
 
@@ -852,7 +861,7 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
 		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-				   STp->long_timeout, MAX_READY_RETRIES, 1);
+				   STp->long_timeout, MAX_READY_RETRIES, 1, 1);
 
 		if (!SRpnt) {
 			retval = (STp->buffer)->syscall_result;
@@ -986,7 +995,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		cmd[0] = READ_BLOCK_LIMITS;
 
 		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
-				   STp->device->timeout, MAX_READY_RETRIES, 1);
+				   STp->device->timeout, MAX_READY_RETRIES, 1, 0);
 		if (!SRpnt) {
 			retval = (STp->buffer)->syscall_result;
 			goto err_out;
@@ -1013,7 +1022,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	cmd[4] = 12;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+			   STp->device->timeout, MAX_READY_RETRIES, 1, 0);
 	if (!SRpnt) {
 		retval = (STp->buffer)->syscall_result;
 		goto err_out;
@@ -1240,7 +1249,7 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		cmd[4] = 1 + STp->two_fm;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+				   STp->device->timeout, MAX_WRITE_RETRIES, 1, 1);
 		if (!SRpnt) {
 			result = (STp->buffer)->syscall_result;
 			goto out;
@@ -1627,7 +1636,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		cmd[4] = blks;
 
 		SRpnt = st_do_scsi(SRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write);
+				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write, 1);
 		if (!SRpnt) {
 			retval = STbp->syscall_result;
 			goto out;
@@ -1797,7 +1806,7 @@ static long read_tape(struct scsi_tape *STp, long count,
 
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->timeout, MAX_RETRIES, 1, 1);
 	release_buffering(STp, 1);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
@@ -2314,7 +2323,7 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 	cmd[4] = 255;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
+			   STp->device->timeout, 0, 1, 0);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2345,7 +2354,7 @@ static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
-			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1);
+			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1, 0);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2470,7 +2479,7 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		);
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   timeout, MAX_RETRIES, 1);
+			   timeout, MAX_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2770,7 +2779,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 	}
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
+			   timeout, MAX_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2937,7 +2946,7 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
 			scmd[1] = 1;
 	}
 	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+			   STp->device->timeout, MAX_READY_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -3042,7 +3051,7 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 	}
 
 	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
-			   timeout, MAX_READY_RETRIES, 1);
+			   timeout, MAX_READY_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -3223,6 +3232,41 @@ static int partition_tape(struct scsi_tape *STp, int size)
 	return result;
 }
 

+/* Assemble the MTIOCSENSE return and transfer it to user */
+static int do_mtiocsense(struct scsi_tape *STp, void __user *p)
+{
+	int i, retval = 0;
+	struct mtsense *mt_sensep;
+
+	mt_sensep = kzalloc(sizeof(struct mtsense), GFP_KERNEL);
+	if (!mt_sensep) {
+		retval = -ENOMEM;
+		goto out;
+	}
+
+	if (STp->saved_sense) {
+		mt_sensep->length = MTIOCSENSE_SENSE_LENGTH;
+		if (mt_sensep->length > SCSI_SENSE_BUFFERSIZE)
+			mt_sensep->length = SCSI_SENSE_BUFFERSIZE;
+		if ((STp->saved_sense[0] & 0x70) == 0x70) {
+			i = STp->saved_sense[7] + 8;
+			if (i < mt_sensep->length)
+				mt_sensep->length = i;
+		}
+		mt_sensep->latest = STp->saved_sense_latest;
+		memcpy(mt_sensep->cdb, STp->saved_sense_cmd, MTIOCSENSE_CDB_LENGTH < MAX_COMMAND_SIZE ?
+		       MTIOCSENSE_CDB_LENGTH : MAX_COMMAND_SIZE);
+		mt_sensep->residual = STp->saved_residual;
+		memcpy(mt_sensep->data, STp->saved_sense, SCSI_SENSE_BUFFERSIZE);
+	}
+
+	i = copy_to_user(p, mt_sensep, sizeof(struct mtsense));
+	if (i)
+		retval = (-EFAULT);
+	kfree(mt_sensep);
+out:
+	return retval;
+}
 
 
 /* The ioctl command */
@@ -3548,6 +3592,12 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			retval = (-EFAULT);
 		goto out;
 	}
+
+	if (cmd_type == _IOC_TYPE(MTIOCSENSE) && cmd_nr == _IOC_NR(MTIOCSENSE)) {
+		retval = do_mtiocsense(STp, p);
+		goto out;
+	}
+
 	mutex_unlock(&STp->lock);
 	switch (cmd_in) {
 		case SCSI_IOCTL_GET_IDLUN:
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index b92712f..f72ab60 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -27,6 +27,7 @@ struct st_request {
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int result;
+	int save_sense;
 	struct scsi_tape *stp;
 	struct completion *waiting;
 };
@@ -160,6 +161,14 @@ struct scsi_tape {
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
 
+	/* The latest sense data to be returned to the user. If the first byte is zero,
+	   there is no sense data to return. */
+	unsigned char saved_sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned char saved_sense_cmd[MAX_COMMAND_SIZE];/* the command resulting in request sense */
+	unsigned char saved_sense_latest;		/* is the sense data from the latest command
+							   submitted to the device */
+	int saved_residual;	/* the HBA residual associated with this sense data */
+
 #if DEBUG
 	unsigned char write_pending;
 	int nbr_finished;
diff --git a/include/linux/mtio.h b/include/linux/mtio.h
index ef01d6a..2685bd2 100644
--- a/include/linux/mtio.h
+++ b/include/linux/mtio.h
@@ -122,11 +122,23 @@ struct	mtpos {
 	long 	mt_blkno;	/* current block number */
 };
 
+/* structure for MTIOCSENSE - mag tape get sense data */
+#define MTIOCSENSE_SENSE_LENGTH 252
+#define MTIOCSENSE_CDB_LENGTH   16
+struct mtsense {
+	__u16 length;		/* the length of the returned sense data */
+	__u8 cdb[MTIOCSENSE_CDB_LENGTH];/* the command that returned the sense data */
+	__u8 latest;		/* is this sense data from the latest SCSI command to device? */
+	__s32 residual;		/* the residual returned from HBA */
+	__u8 data[MTIOCSENSE_SENSE_LENGTH];/* space for all data in REQUEST SENSE response */
+};
+
 
 /* mag tape io control commands */
 #define	MTIOCTOP	_IOW('m', 1, struct mtop)	/* do a mag tape op */
 #define	MTIOCGET	_IOR('m', 2, struct mtget)	/* get tape status */
 #define	MTIOCPOS	_IOR('m', 3, struct mtpos)	/* get tape position */
+#define MTIOCSENSE      _IOR('m', 4, struct mtsense)    /* get latest sense data */
 
 
 /* Generic Mag Tape (device independent) status macros for examining
