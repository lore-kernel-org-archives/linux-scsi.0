From: Brian King <brking@us.ibm.com>
Subject: Re: Transport affected timeouts...
Date: Mon, 03 May 2004 10:49:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40966A27.3020506@us.ibm.com>
References: <3356669BBE90C448AD4645C843E2BF2802C016E3@xbl.ma.emulex.com> <40883CF6.8050808@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010200050702030308020207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:35714 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263750AbUECPuE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2004 11:50:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: "Smart, James" <James.Smart@Emulex.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>

This is a multi-part message in MIME format.
--------------010200050702030308020207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The following patch makes st use the timeout field in the scsi_device struct.
It requires the scsi_timeout_mod patch I just submitted.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------010200050702030308020207
Content-Type: text/plain;
 name="st_timeout_mod.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="st_timeout_mod.patch"


This patch changes st to use the timeout field in the scsi_device struct
for the short timeout. This patch depends on scsi_timeout_mod patch.


---


diff -puN drivers/scsi/st.h~st_timeout_mod drivers/scsi/st.h
--- linux-2.6.6-rc3/drivers/scsi/st.h~st_timeout_mod	Fri Apr 30 09:56:04 2004
+++ linux-2.6.6-rc3-bjking1/drivers/scsi/st.h	Fri Apr 30 09:56:15 2004
@@ -100,7 +100,6 @@ typedef struct {
 	unsigned char c_algo;			/* compression algorithm */
 	unsigned char pos_unknown;			/* after reset position unknown */
 	int tape_type;
-	int timeout;		/* timeout for normal commands */
 	int long_timeout;	/* timeout for commands known to take long time */
 
 	unsigned long max_pfn;	/* the maximum page number reachable by the HBA */
diff -puN drivers/scsi/st.c~st_timeout_mod drivers/scsi/st.c
--- linux-2.6.6-rc3/drivers/scsi/st.c~st_timeout_mod	Fri Apr 30 09:56:19 2004
+++ linux-2.6.6-rc3-bjking1/drivers/scsi/st.c	Fri Apr 30 10:15:03 2004
@@ -486,7 +486,7 @@ static int cross_eof(Scsi_Tape * STp, in
 		   tape_name(STp), forward ? "forward" : "backward"));
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, 0, SCSI_DATA_NONE,
-			   STp->timeout, MAX_RETRIES, TRUE);
+			   STp->device->timeout, MAX_RETRIES, TRUE);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -544,7 +544,7 @@ static int flush_write_buffer(Scsi_Tape 
 		cmd[4] = blks;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, transfer, SCSI_DATA_WRITE,
-				   STp->timeout, MAX_WRITE_RETRIES, TRUE);
+				   STp->device->timeout, MAX_WRITE_RETRIES, TRUE);
 		if (!SRpnt)
 			return (STp->buffer)->syscall_result;
 
@@ -867,7 +867,7 @@ static int check_tape(Scsi_Tape *STp, st
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = READ_BLOCK_LIMITS;
 
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, SCSI_DATA_READ, STp->timeout,
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, SCSI_DATA_READ, STp->device->timeout,
 				   MAX_READY_RETRIES, TRUE);
 		if (!SRpnt) {
 			retval = (STp->buffer)->syscall_result;
@@ -894,7 +894,7 @@ static int check_tape(Scsi_Tape *STp, st
 	cmd[0] = MODE_SENSE;
 	cmd[4] = 12;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, SCSI_DATA_READ, STp->timeout,
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, SCSI_DATA_READ, STp->device->timeout,
 			   MAX_READY_RETRIES, TRUE);
 	if (!SRpnt) {
 		retval = (STp->buffer)->syscall_result;
@@ -1115,7 +1115,7 @@ static int st_flush(struct file *filp)
 		cmd[4] = 1 + STp->two_fm;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, 0, SCSI_DATA_NONE,
-				   STp->timeout, MAX_WRITE_RETRIES, TRUE);
+				   STp->device->timeout, MAX_WRITE_RETRIES, TRUE);
 		if (!SRpnt) {
 			result = (STp->buffer)->syscall_result;
 			goto out;
@@ -1506,7 +1506,7 @@ static ssize_t
 		cmd[4] = blks;
 
 		SRpnt = st_do_scsi(SRpnt, STp, cmd, transfer, SCSI_DATA_WRITE,
-				   STp->timeout, MAX_WRITE_RETRIES, !async_write);
+				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write);
 		if (!SRpnt) {
 			retval = STbp->syscall_result;
 			goto out;
@@ -1676,7 +1676,7 @@ static long read_tape(Scsi_Tape *STp, lo
 
 	SRpnt = *aSRpnt;
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, SCSI_DATA_READ,
-			   STp->timeout, MAX_RETRIES, TRUE);
+			   STp->device->timeout, MAX_RETRIES, TRUE);
 	release_buffering(STp);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
@@ -2075,7 +2075,7 @@ static int st_set_options(Scsi_Tape *STp
 			printk(KERN_INFO "%s: Long timeout set to %d seconds.\n", name,
 			       (value & ~MT_ST_SET_LONG_TIMEOUT));
 		} else {
-			STp->timeout = value * HZ;
+			STp->device->timeout = value * HZ;
 			printk(KERN_INFO "%s: Normal timeout set to %d seconds.\n",
                                name, value);
 		}
@@ -2183,7 +2183,7 @@ static int read_mode_page(Scsi_Tape *STp
 	cmd[4] = 255;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_READ,
-			   STp->timeout, 0, TRUE);
+			   STp->device->timeout, 0, TRUE);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2214,7 +2214,7 @@ static int write_mode_page(Scsi_Tape *ST
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
 	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_WRITE,
-			   (slow ? STp->long_timeout : STp->timeout), 0, TRUE);
+			   (slow ? STp->long_timeout : STp->device->timeout), 0, TRUE);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2326,7 +2326,7 @@ static int do_load_unload(Scsi_Tape *STp
 	}
 	if (STp->immediate) {
 		cmd[1] = 1;	/* Don't wait for completion */
-		timeout = STp->timeout;
+		timeout = STp->device->timeout;
 	}
 	else
 		timeout = STp->long_timeout;
@@ -2506,7 +2506,7 @@ static int st_int_ioctl(Scsi_Tape *STp, 
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
 		cmd[4] = arg;
-		timeout = STp->timeout;
+		timeout = STp->device->timeout;
                 DEBC(
                      if (cmd_in == MTWEOF)
                                printk(ST_DEB_MSG "%s: Writing %d filemarks.\n", name,
@@ -2524,7 +2524,7 @@ static int st_int_ioctl(Scsi_Tape *STp, 
 		cmd[0] = REZERO_UNIT;
 		if (STp->immediate) {
 			cmd[1] = 1;	/* Don't wait for completion */
-			timeout = STp->timeout;
+			timeout = STp->device->timeout;
 		}
                 DEBC(printk(ST_DEB_MSG "%s: Rewinding tape.\n", name));
 		fileno = blkno = at_sm = 0;
@@ -2537,7 +2537,7 @@ static int st_int_ioctl(Scsi_Tape *STp, 
 		cmd[0] = START_STOP;
 		if (STp->immediate) {
 			cmd[1] = 1;	/* Don't wait for completion */
-			timeout = STp->timeout;
+			timeout = STp->device->timeout;
 		}
 		cmd[4] = 3;
                 DEBC(printk(ST_DEB_MSG "%s: Retensioning tape.\n", name));
@@ -2570,7 +2570,7 @@ static int st_int_ioctl(Scsi_Tape *STp, 
 		cmd[1] = (arg ? 1 : 0);	/* Long erase with non-zero argument */
 		if (STp->immediate) {
 			cmd[1] |= 2;	/* Don't wait for completion */
-			timeout = STp->timeout;
+			timeout = STp->device->timeout;
 		}
 		else
 			timeout = STp->long_timeout * 8;
@@ -2622,7 +2622,7 @@ static int st_int_ioctl(Scsi_Tape *STp, 
 		(STp->buffer)->b_data[9] = (ltmp >> 16);
 		(STp->buffer)->b_data[10] = (ltmp >> 8);
 		(STp->buffer)->b_data[11] = ltmp;
-		timeout = STp->timeout;
+		timeout = STp->device->timeout;
                 DEBC(
 			if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK)
 				printk(ST_DEB_MSG
@@ -2803,7 +2803,7 @@ static int get_location(Scsi_Tape *STp, 
 		if (!logical && !STp->scsi2_logical)
 			scmd[1] = 1;
 	}
-	SRpnt = st_do_scsi(NULL, STp, scmd, 20, SCSI_DATA_READ, STp->timeout,
+	SRpnt = st_do_scsi(NULL, STp, scmd, 20, SCSI_DATA_READ, STp->device->timeout,
 			   MAX_READY_RETRIES, TRUE);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
@@ -2905,7 +2905,7 @@ static int set_location(Scsi_Tape *STp, 
 	}
 	if (STp->immediate) {
 		scmd[1] |= 1;		/* Don't wait for completion */
-		timeout = STp->timeout;
+		timeout = STp->device->timeout;
 	}
 
 	SRpnt = st_do_scsi(NULL, STp, scmd, 0, SCSI_DATA_NONE,
@@ -3844,7 +3844,7 @@ static int st_probe(struct device *dev)
 	tpnt->partition = 0;
 	tpnt->new_partition = 0;
 	tpnt->nbr_partitions = 0;
-	tpnt->timeout = ST_TIMEOUT;
+	tpnt->device->timeout = ST_TIMEOUT;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
 

_

--------------010200050702030308020207--

