From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [hch: [PATCH] avoid obsolete "scsi.h" APIs in st]
Date: Tue, 14 Sep 2004 23:16:40 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409142311140.1979@kai.makisara.local>
References: <20040914181838.GB16028@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:39767 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S269770AbUINUQo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 16:16:44 -0400
In-Reply-To: <20040914181838.GB16028@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 14 Sep 2004, Christoph Hellwig wrote:

> Sorry, forgot to Cc linux-scsi.  please send eventual replies to Kai
> aswell.
> 
> ----- Forwarded message from Christoph Hellwig <hch> -----
> 
> Date: Tue, 14 Sep 2004 20:18:00 +0200
> From: Christoph Hellwig <hch>
> Subject: [PATCH] avoid obsolete "scsi.h" APIs in st
> To: Kai.Makisara@kolumbus.fi
> 
> no actual behaviour changes, just update to the less obsfucated 2.6+
> APIs.
> 
Looks good to me but did not link when DEBUG was set to 1: one 
print_req_sense() conversion was missed. This is corrected in the patch at 
the end of this message.

Thanks for doing the cleanup.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

-- 
Kai

------------------------------8<-------------------------------------------
--- linux-2.6.9-rc2-bk1/drivers/scsi/st.c	2004-08-14 12:58:24.000000000 +0300
+++ linux-2.6.9-rc2-bk1-k1/drivers/scsi/st.c	2004-09-14 22:30:18.000000000 +0300
@@ -40,6 +40,16 @@
 #include <asm/dma.h>
 #include <asm/system.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
+
+
 /* The driver prints some debugging information on the console if DEBUG
    is defined and non-zero. */
 #define DEBUG 0
@@ -56,13 +66,6 @@
 #define DEBC(a)
 #endif
 
-
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-
-#include <scsi/scsi_driver.h>
-#include <scsi/scsi_ioctl.h>
-
 #define ST_KILOBYTE 1024
 
 #include "st_options.h"
@@ -71,8 +74,8 @@
 static int buffer_kbs;
 static int max_sg_segs;
 static int try_direct_io = TRY_DIRECT_IO;
-static int try_rdio = TRUE;
-static int try_wdio = TRUE;
+static int try_rdio = 1;
+static int try_wdio = 1;
 
 static int st_dev_max;
 static int st_nr_dev;
@@ -237,7 +240,7 @@
 
 /* If the device signature is on the list of incompatible drives, the
    function returns a pointer to the name of the correct driver (if known) */
-static char * st_incompatible(Scsi_Device* SDp)
+static char * st_incompatible(struct scsi_device* SDp)
 {
 	struct st_reject_data *rp;
 
@@ -260,7 +263,7 @@
 }
 
 /* Convert the result to success code */
-static int st_chk_result(Scsi_Tape *STp, Scsi_Request * SRpnt)
+static int st_chk_result(Scsi_Tape *STp, struct scsi_request * SRpnt)
 {
 	int result = SRpnt->sr_result;
 	unsigned char *sense = SRpnt->sr_sense_buffer, scode;
@@ -287,7 +290,7 @@
 		       SRpnt->sr_cmnd[3], SRpnt->sr_cmnd[4], SRpnt->sr_cmnd[5],
 		       SRpnt->sr_bufflen);
 		if (driver_byte(result) & DRIVER_SENSE)
-			print_req_sense("st", SRpnt);
+			scsi_print_req_sense("st", SRpnt);
 	} else ) /* end DEB */
 		if (!(driver_byte(result) & DRIVER_SENSE) ||
 		    ((sense[0] & 0x70) == 0x70 &&
@@ -300,7 +303,7 @@
 		     SRpnt->sr_cmnd[0] != TEST_UNIT_READY)) {	/* Abnormal conditions for tape */
 		if (driver_byte(result) & DRIVER_SENSE) {
 			printk(KERN_WARNING "%s: Error with sense data: ", name);
-			print_req_sense("st", SRpnt);
+			scsi_print_req_sense("st", SRpnt);
 		} else
 			printk(KERN_WARNING
 			       "%s: Error %x (sugg. bt 0x%x, driver bt 0x%x, host bt 0x%x).\n",
@@ -351,7 +354,7 @@
 
 
 /* Wakeup from interrupt */
-static void st_sleep_done(Scsi_Cmnd * SCpnt)
+static void st_sleep_done(struct scsi_cmnd * SCpnt)
 {
 	int remainder;
 	Scsi_Tape *STp = container_of(SCpnt->request->rq_disk->private_data,
@@ -385,9 +388,9 @@
 /* Do the scsi command. Waits until command performed if do_wait is true.
    Otherwise write_behind_check() is used to check that the command
    has finished. */
-static Scsi_Request *
- st_do_scsi(Scsi_Request * SRpnt, Scsi_Tape * STp, unsigned char *cmd, int bytes,
-	    int direction, int timeout, int retries, int do_wait)
+static struct scsi_request *
+st_do_scsi(struct scsi_request * SRpnt, Scsi_Tape * STp, unsigned char *cmd,
+	   int bytes, int direction, int timeout, int retries, int do_wait)
 {
 	unsigned char *bp;
 
@@ -470,7 +473,7 @@
    it messes up the block number). */
 static int cross_eof(Scsi_Tape * STp, int forward)
 {
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 
 	cmd[0] = SPACE;
@@ -485,8 +488,8 @@
         DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
 		   tape_name(STp), forward ? "forward" : "backward"));
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, 0, SCSI_DATA_NONE,
-			   STp->device->timeout, MAX_RETRIES, TRUE);
+	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			   STp->device->timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -507,7 +510,7 @@
 	int offset, transfer, blks;
 	int result;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	ST_partstat *STps;
 
 	if ((STp->buffer)->writing) {
@@ -543,8 +546,8 @@
 		cmd[3] = blks >> 8;
 		cmd[4] = blks;
 
-		SRpnt = st_do_scsi(NULL, STp, cmd, transfer, SCSI_DATA_WRITE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, TRUE);
+		SRpnt = st_do_scsi(NULL, STp, cmd, transfer, DMA_TO_DEVICE,
+				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
 		if (!SRpnt)
 			return (STp->buffer)->syscall_result;
 
@@ -610,7 +613,7 @@
 	result = 0;
 	if (!seek_next) {
 		if (STps->eof == ST_FM_HIT) {
-			result = cross_eof(STp, FALSE);	/* Back over the EOF hit */
+			result = cross_eof(STp, 0);	/* Back over the EOF hit */
 			if (!result)
 				STps->eof = ST_NOEOF;
 			else {
@@ -634,7 +637,7 @@
 /* Set the mode parameters */
 static int set_mode_densblk(Scsi_Tape * STp, ST_mode * STm)
 {
-	int set_it = FALSE;
+	int set_it = 0;
 	unsigned long arg;
 	char *name = tape_name(STp);
 
@@ -642,7 +645,7 @@
 	    STm->default_density >= 0 &&
 	    STm->default_density != STp->density) {
 		arg = STm->default_density;
-		set_it = TRUE;
+		set_it = 1;
 	} else
 		arg = STp->density;
 	arg <<= MT_ST_DENSITY_SHIFT;
@@ -650,7 +653,7 @@
 	    STm->default_blksize >= 0 &&
 	    STm->default_blksize != STp->block_size) {
 		arg |= STm->default_blksize;
-		set_it = TRUE;
+		set_it = 1;
 	} else
 		arg |= STp->block_size;
 	if (set_it &&
@@ -665,7 +668,7 @@
 }
 
 
-/* Lock or unlock the drive door. Don't use when Scsi_Request allocated. */
+/* Lock or unlock the drive door. Don't use when scsi_request allocated. */
 static int do_door_lock(Scsi_Tape * STp, int do_lock)
 {
 	int retval, cmd;
@@ -698,7 +701,7 @@
 		STps->rw = ST_IDLE;
 		STps->eof = ST_NOEOF;
 		STps->at_sm = 0;
-		STps->last_block_valid = FALSE;
+		STps->last_block_valid = 0;
 		STps->drv_block = -1;
 		STps->drv_file = -1;
 	}
@@ -722,17 +725,17 @@
 static int test_ready(Scsi_Tape *STp, int do_wait)
 {
 	int attentions, waits, max_wait, scode;
-	int retval = CHKRES_READY, new_session = FALSE;
+	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
 
 	for (attentions=waits=0; ; ) {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE,
-				   STp->long_timeout, MAX_READY_RETRIES, TRUE);
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
+				   STp->long_timeout, MAX_READY_RETRIES, 1);
 
 		if (!SRpnt) {
 			retval = (STp->buffer)->syscall_result;
@@ -744,7 +747,7 @@
 			scode = (SRpnt->sr_sense_buffer[2] & 0x0f);
 
 			if (scode == UNIT_ATTENTION) { /* New media? */
-				new_session = TRUE;
+				new_session = 1;
 				if (attentions < MAX_ATTENTIONS) {
 					attentions++;
 					continue;
@@ -796,10 +799,10 @@
 */
 static int check_tape(Scsi_Tape *STp, struct file *filp)
 {
-	int i, retval, new_session = FALSE, do_wait;
+	int i, retval, new_session = 0, do_wait;
 	unsigned char cmd[MAX_COMMAND_SIZE], saved_cleaning;
 	unsigned short st_flags = filp->f_flags;
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 	ST_mode *STm;
 	ST_partstat *STps;
 	char *name = tape_name(STp);
@@ -811,7 +814,7 @@
 	if (mode != STp->current_mode) {
                 DEBC(printk(ST_DEB_MSG "%s: Mode change from %d to %d.\n",
 			       name, STp->current_mode, mode));
-		new_session = TRUE;
+		new_session = 1;
 		STp->current_mode = mode;
 	}
 	STm = &(STp->modes[STp->current_mode]);
@@ -836,11 +839,11 @@
 			STps->rw = ST_IDLE;
 			STps->eof = ST_NOEOF;
 			STps->at_sm = 0;
-			STps->last_block_valid = FALSE;
+			STps->last_block_valid = 0;
 			STps->drv_block = 0;
 			STps->drv_file = 0;
 		}
-		new_session = TRUE;
+		new_session = 1;
 	}
 	else {
 		STp->cleaning_req |= saved_cleaning;
@@ -867,8 +870,8 @@
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = READ_BLOCK_LIMITS;
 
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, SCSI_DATA_READ, STp->device->timeout,
-				   MAX_READY_RETRIES, TRUE);
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
+				   STp->device->timeout, MAX_READY_RETRIES, 1);
 		if (!SRpnt) {
 			retval = (STp->buffer)->syscall_result;
 			goto err_out;
@@ -894,8 +897,8 @@
 	cmd[0] = MODE_SENSE;
 	cmd[4] = 12;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, SCSI_DATA_READ, STp->device->timeout,
-			   MAX_READY_RETRIES, TRUE);
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
+			STp->device->timeout, MAX_READY_RETRIES, 1);
 	if (!SRpnt) {
 		retval = (STp->buffer)->syscall_result;
 		goto err_out;
@@ -928,7 +931,7 @@
 	}
 	scsi_release_request(SRpnt);
 	SRpnt = NULL;
-        STp->inited = TRUE;
+        STp->inited = 1;
 
 	if (STp->block_size > 0)
 		(STp->buffer)->buffer_blocks =
@@ -970,8 +973,8 @@
 	}
 
 	if (new_session) {	/* Change the drive parameters for the new mode */
-		STp->density_changed = STp->blksize_changed = FALSE;
-		STp->compression_changed = FALSE;
+		STp->density_changed = STp->blksize_changed = 0;
+		STp->compression_changed = 0;
 		if (!(STm->defaults_for_writes) &&
 		    (retval = set_mode_densblk(STp, STm)) < 0)
 		    goto err_out;
@@ -1076,7 +1079,7 @@
 {
 	int result = 0, result2;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	Scsi_Tape *STp = filp->private_data;
 	ST_mode *STm = &(STp->modes[STp->current_mode]);
 	ST_partstat *STps = &(STp->ps[STp->partition]);
@@ -1116,8 +1119,8 @@
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[4] = 1 + STp->two_fm;
 
-		SRpnt = st_do_scsi(NULL, STp, cmd, 0, SCSI_DATA_NONE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, TRUE);
+		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
 		if (!SRpnt) {
 			result = (STp->buffer)->syscall_result;
 			goto out;
@@ -1143,7 +1146,7 @@
 				STps->drv_file++;
 			STps->drv_block = 0;
 			if (STp->two_fm)
-				cross_eof(STp, FALSE);
+				cross_eof(STp, 0);
 			STps->eof = ST_FM;
 		}
 
@@ -1155,7 +1158,7 @@
 			if (STp->can_bsr)
 				result = flush_buffer(STp, 0);
 			else if (STps->eof == ST_FM_HIT) {
-				result = cross_eof(STp, FALSE);
+				result = cross_eof(STp, 0);
 				if (result) {
 					if (STps->drv_file >= 0)
 						STps->drv_file++;
@@ -1165,7 +1168,7 @@
 					STps->eof = ST_NOEOF;
 			}
 		} else if ((STps->eof == ST_NOEOF &&
-			    !(result = cross_eof(STp, TRUE))) ||
+			    !(result = cross_eof(STp, 1))) ||
 			   STps->eof == ST_FM_HIT) {
 			if (STps->drv_file >= 0)
 				STps->drv_file++;
@@ -1290,7 +1293,7 @@
 			STbp->buffer_bytes = 0;   /* can be used as transfer counter */
 		}
 		else
-			STbp->do_dio = FALSE;  /* fall back to buffering with any error */
+			STbp->do_dio = 0;  /* fall back to buffering with any error */
 		STbp->sg_segs = STbp->do_dio;
 		STbp->frp_sg_current = 0;
 		DEB(
@@ -1303,7 +1306,7 @@
 		     }
 		)
 	} else
-		STbp->do_dio = FALSE;
+		STbp->do_dio = 0;
 	DEB( STp->nbr_requests++; )
 
 	if (!STbp->do_dio) {
@@ -1335,7 +1338,7 @@
 
 	STbp = STp->buffer;
 	if (STbp->do_dio) {
-		sgl_unmap_user_pages(&(STbp->sg[0]), STbp->do_dio, FALSE);
+		sgl_unmap_user_pages(&(STbp->sg[0]), STbp->do_dio, 0);
 		STbp->do_dio = 0;
 	}
 }
@@ -1352,7 +1355,7 @@
 	int async_write;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	const char __user *b_point;
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 	Scsi_Tape *STp = filp->private_data;
 	ST_mode *STm;
 	ST_partstat *STps;
@@ -1438,7 +1441,7 @@
 		goto out;
 	}
 
-	retval = setup_buffering(STp, buf, count, FALSE);
+	retval = setup_buffering(STp, buf, count, 0);
 	if (retval)
 		goto out;
 
@@ -1482,7 +1485,7 @@
 		if (STp->block_size != 0 && STm->do_buffer_writes &&
 		    !(STp->try_dio && try_wdio) && STps->eof < ST_EOM_OK &&
 		    STbp->buffer_bytes < STbp->buffer_size) {
-			STp->dirty = TRUE;
+			STp->dirty = 1;
 			/* Don't write a buffer that is not full enough. */
 			if (!async_write && count == 0)
 				break;
@@ -1503,7 +1506,7 @@
 		cmd[3] = blks >> 8;
 		cmd[4] = blks;
 
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, transfer, SCSI_DATA_WRITE,
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
 				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write);
 		if (!SRpnt) {
 			retval = STbp->syscall_result;
@@ -1559,7 +1562,7 @@
 					if (!retry_eot && (SRpnt->sr_sense_buffer[0] & 1) == 0 &&
 					    (scode == NO_SENSE || scode == RECOVERED_ERROR)) {
 						move_buffer_data(STp->buffer, transfer - undone);
-						retry_eot = TRUE;
+						retry_eot = 1;
 						if (STps->drv_block >= 0) {
 							STps->drv_block += (transfer - undone) /
 								STp->block_size;
@@ -1630,11 +1633,11 @@
 
    Does release user buffer mapping if it is set.
 */
-static long read_tape(Scsi_Tape *STp, long count, Scsi_Request ** aSRpnt)
+static long read_tape(Scsi_Tape *STp, long count, struct scsi_request ** aSRpnt)
 {
 	int transfer, blks, bytes;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	ST_mode *STm;
 	ST_partstat *STps;
 	ST_buffer *STbp;
@@ -1673,8 +1676,8 @@
 	cmd[4] = blks;
 
 	SRpnt = *aSRpnt;
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, SCSI_DATA_READ,
-			   STp->device->timeout, MAX_RETRIES, TRUE);
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
+			   STp->device->timeout, MAX_RETRIES, 1);
 	release_buffering(STp);
 	*aSRpnt = SRpnt;
 	if (!SRpnt)
@@ -1818,7 +1821,7 @@
 	ssize_t retval = 0;
 	ssize_t i, transfer;
 	int special, do_dio = 0;
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 	Scsi_Tape *STp = filp->private_data;
 	ST_mode *STm;
 	ST_partstat *STps;
@@ -1852,7 +1855,7 @@
 		       STps->eof, STbp->buffer_bytes);
         ) /* end DEB */
 
-	retval = setup_buffering(STp, buf, count, TRUE);
+	retval = setup_buffering(STp, buf, count, 1);
 	if (retval)
 		goto out;
 	do_dio = STbp->do_dio;
@@ -1996,7 +1999,7 @@
 		cd0 = STm->cdevs[0]; cd1 = STm->cdevs[1];
 		memcpy(STm, &(STp->modes[0]), sizeof(ST_mode));
 		STm->cdevs[0] = cd0; STm->cdevs[1] = cd1;
-		modes_defined = TRUE;
+		modes_defined = 1;
                 DEBC(printk(ST_DEB_MSG
                             "%s: Initialized mode %d definition from mode 0\n",
                             name, STp->current_mode));
@@ -2065,7 +2068,7 @@
 			DEBC( printk(KERN_INFO "%s: Default block size set to %d bytes.\n",
 			       name, STm->default_blksize));
 			if (STp->ready == ST_READY) {
-				STp->blksize_changed = FALSE;
+				STp->blksize_changed = 0;
 				set_mode_densblk(STp, STm);
 			}
 		}
@@ -2104,7 +2107,7 @@
 				DEBC( printk(KERN_INFO "%s: Density default set to %x\n",
 				       name, STm->default_density));
 				if (STp->ready == ST_READY) {
-					STp->density_changed = FALSE;
+					STp->density_changed = 0;
 					set_mode_densblk(STp, STm);
 				}
 			}
@@ -2137,7 +2140,7 @@
 					DEBC( printk(KERN_INFO "%s: Compression default set to %x\n",
 					       name, (value & 1)));
 					if (STp->ready == ST_READY) {
-						STp->compression_changed = FALSE;
+						STp->compression_changed = 0;
 						st_compression(STp, (STm->default_compression == ST_YES));
 					}
 				}
@@ -2174,7 +2177,7 @@
 static int read_mode_page(Scsi_Tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2183,8 +2186,8 @@
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_READ,
-			   STp->device->timeout, 0, TRUE);
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
+			   STp->device->timeout, 0, 1);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2200,7 +2203,7 @@
 {
 	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
@@ -2214,8 +2217,8 @@
 	(STp->buffer)->b_data[MH_OFF_DEV_SPECIFIC] &= ~MH_BIT_WP;
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_WRITE,
-			   (slow ? STp->long_timeout : STp->device->timeout), 0, TRUE);
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
+			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1);
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
@@ -2253,7 +2256,7 @@
 		return (-EIO);
 
 	/* Read the current page contents */
-	retval = read_mode_page(STp, COMPRESSION_PAGE, FALSE);
+	retval = read_mode_page(STp, COMPRESSION_PAGE, 0);
 	if (retval) {
                 DEBC(printk(ST_DEB_MSG "%s: Compression mode page not supported.\n",
                             name));
@@ -2282,7 +2285,7 @@
 			b_data[mpoffs + CP_OFF_C_ALGO] = 0; /* no compression */
 	}
 
-	retval = write_mode_page(STp, COMPRESSION_PAGE, FALSE);
+	retval = write_mode_page(STp, COMPRESSION_PAGE, 0);
 	if (retval) {
                 DEBC(printk(ST_DEB_MSG "%s: Compression change failed.\n", name));
 		return (-EIO);
@@ -2290,7 +2293,7 @@
         DEBC(printk(ST_DEB_MSG "%s: Compression state changed to %d.\n",
 		       name, state));
 
-	STp->compression_changed = TRUE;
+	STp->compression_changed = 1;
 	return 0;
 }
 
@@ -2302,7 +2305,7 @@
 	DEB( char *name = tape_name(STp); )
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	ST_partstat *STps;
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 
 	if (STp->ready != ST_READY && !load_code) {
 		if (STp->ready == ST_NO_TAPE)
@@ -2339,8 +2342,8 @@
 		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
 		);
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, 0, SCSI_DATA_NONE,
-			   timeout, MAX_RETRIES, TRUE);
+	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			   timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2375,12 +2378,12 @@
 	int timeout;
 	long ltmp;
 	int ioctl_result;
-	int chg_eof = TRUE;
+	int chg_eof = 1;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	ST_partstat *STps;
 	int fileno, blkno, at_sm, undone;
-	int datalen = 0, direction = SCSI_DATA_NONE;
+	int datalen = 0, direction = DMA_NONE;
 	char *name = tape_name(STp);
 
 	WARN_ON(STp->buffer->do_dio != 0);
@@ -2399,7 +2402,7 @@
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	switch (cmd_in) {
 	case MTFSFM:
-		chg_eof = FALSE;	/* Changed from the FSF after this */
+		chg_eof = 0;	/* Changed from the FSF after this */
 	case MTFSF:
 		cmd[0] = SPACE;
 		cmd[1] = 0x01;	/* Space FileMarks */
@@ -2414,7 +2417,7 @@
 		at_sm &= (arg == 0);
 		break;
 	case MTBSFM:
-		chg_eof = FALSE;	/* Changed from the FSF after this */
+		chg_eof = 0;	/* Changed from the FSF after this */
 	case MTBSF:
 		cmd[0] = SPACE;
 		cmd[1] = 0x01;	/* Space FileMarks */
@@ -2583,7 +2586,7 @@
 	case MTSETDENSITY:	/* Set tape density */
 	case MTSETDRVBUFFER:	/* Set drive buffering */
 	case SET_DENS_AND_BLK:	/* Set density and block size */
-		chg_eof = FALSE;
+		chg_eof = 0;
 		if (STp->dirty || (STp->buffer)->buffer_bytes != 0)
 			return (-EIO);	/* Not allowed if data in buffer */
 		if ((cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) &&
@@ -2598,7 +2601,7 @@
 		if ((STp->use_pf & USE_PF))
 			cmd[1] = MODE_SELECT_PAGE_FORMAT;
 		cmd[4] = datalen = 12;
-		direction = SCSI_DATA_WRITE;
+		direction = DMA_TO_DEVICE;
 
 		memset((STp->buffer)->b_data, 0, 12);
 		if (cmd_in == MTSETDRVBUFFER)
@@ -2609,7 +2612,7 @@
 		(STp->buffer)->b_data[3] = 8;	/* block descriptor length */
 		if (cmd_in == MTSETDENSITY) {
 			(STp->buffer)->b_data[4] = arg;
-			STp->density_changed = TRUE;	/* At least we tried ;-) */
+			STp->density_changed = 1;	/* At least we tried ;-) */
 		} else if (cmd_in == SET_DENS_AND_BLK)
 			(STp->buffer)->b_data[4] = arg >> 24;
 		else
@@ -2617,7 +2620,7 @@
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
 			ltmp = arg & MT_ST_BLKSIZE_MASK;
 			if (cmd_in == MTSETBLK)
-				STp->blksize_changed = TRUE; /* At least we tried ;-) */
+				STp->blksize_changed = 1; /* At least we tried ;-) */
 		} else
 			ltmp = STp->block_size;
 		(STp->buffer)->b_data[9] = (ltmp >> 16);
@@ -2646,7 +2649,7 @@
 	}
 
 	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, TRUE);
+			   timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2789,7 +2792,7 @@
 {
 	int result;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -2804,8 +2807,8 @@
 		if (!logical && !STp->scsi2_logical)
 			scmd[1] = 1;
 	}
-	SRpnt = st_do_scsi(NULL, STp, scmd, 20, SCSI_DATA_READ, STp->device->timeout,
-			   MAX_READY_RETRIES, TRUE);
+	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
+			STp->device->timeout, MAX_READY_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2852,7 +2855,7 @@
 	unsigned int blk;
 	int timeout;
 	unsigned char scmd[MAX_COMMAND_SIZE];
-	Scsi_Request *SRpnt;
+	struct scsi_request *SRpnt;
 	DEB( char *name = tape_name(STp); )
 
 	if (STp->ready != ST_READY)
@@ -2871,9 +2874,9 @@
 		return (-EINVAL);
 	if (partition != STp->partition) {
 		if (get_location(STp, &blk, &p, 1))
-			STps->last_block_valid = FALSE;
+			STps->last_block_valid = 0;
 		else {
-			STps->last_block_valid = TRUE;
+			STps->last_block_valid = 1;
 			STps->last_block_visited = blk;
                         DEBC(printk(ST_DEB_MSG
                                     "%s: Visited block %d for partition %d saved.\n",
@@ -2909,8 +2912,8 @@
 		timeout = STp->device->timeout;
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, scmd, 0, SCSI_DATA_NONE,
-			   timeout, MAX_READY_RETRIES, TRUE);
+	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
+			   timeout, MAX_READY_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
@@ -2997,7 +3000,7 @@
 	if (STp->ready != ST_READY)
 		return (-EIO);
 
-	result = read_mode_page(STp, PART_PAGE, TRUE);
+	result = read_mode_page(STp, PART_PAGE, 1);
 
 	if (result) {
                 DEBC(printk(ST_DEB_MSG "%s: Can't read medium partition page.\n",
@@ -3039,7 +3042,7 @@
 	int pgo, psd_cnt, psdo;
 	unsigned char *bp;
 
-	result = read_mode_page(STp, PART_PAGE, FALSE);
+	result = read_mode_page(STp, PART_PAGE, 0);
 	if (result) {
 		DEBC(printk(ST_DEB_MSG "%s: Can't read partition mode page.\n", name));
 		return result;
@@ -3082,7 +3085,7 @@
 	bp[pgo + PP_OFF_RESERVED] = 0;
 	bp[pgo + PP_OFF_FLAGS] = PP_BIT_IDP | PP_MSK_PSUM_MB;
 
-	result = write_mode_page(STp, PART_PAGE, TRUE);
+	result = write_mode_page(STp, PART_PAGE, 1);
 	if (result) {
 		printk(KERN_INFO "%s: Partitioning of tape failed.\n", name);
 		result = (-EIO);
@@ -3259,7 +3262,7 @@
 			for (i = 0; i < ST_NBR_PARTITIONS; i++) {
 				STp->ps[i].rw = ST_IDLE;
 				STp->ps[i].at_sm = 0;
-				STp->ps[i].last_block_valid = FALSE;
+				STp->ps[i].last_block_valid = 0;
 			}
 			STp->partition = STp->new_partition = 0;
 			STp->nbr_partitions = 1;	/* Bad guess ?-) */
@@ -3308,7 +3311,7 @@
 		goto out;
 	}
 
-	if ((i = flush_buffer(STp, FALSE)) < 0) {
+	if ((i = flush_buffer(STp, 0)) < 0) {
 		retval = i;
 		goto out;
 	}
@@ -3448,7 +3451,7 @@
 		tb->b_data = page_address(tb->sg[0].page);
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
-	tb->in_use = TRUE;
+	tb->in_use = 1;
 	tb->dma = need_dma;
 	tb->buffer_size = got;
 
@@ -3462,7 +3465,7 @@
 	int segs, nbr, max_segs, b_size, priority, order, got;
 
 	if (new_size <= STbuffer->buffer_size)
-		return TRUE;
+		return 1;
 
 	if (STbuffer->buffer_size <= PAGE_SIZE)
 		normalize_buffer(STbuffer);  /* Avoid extra segment */
@@ -3470,7 +3473,7 @@
 	max_segs = STbuffer->use_sg;
 	nbr = max_segs - STbuffer->frp_segs;
 	if (nbr <= 0)
-		return FALSE;
+		return 0;
 
 	priority = GFP_KERNEL | __GFP_NOWARN;
 	if (need_dma)
@@ -3491,7 +3494,7 @@
 			}
 			DEB(STbuffer->buffer_size = got);
 			normalize_buffer(STbuffer);
-			return FALSE;
+			return 0;
 		}
 		STbuffer->frp[segs].length = b_size;
 		STbuffer->frp_segs += 1;
@@ -3501,7 +3504,7 @@
 	}
 	STbuffer->b_data = page_address(STbuffer->frp[0].page);
 
-	return TRUE;
+	return 1;
 }
 
 
@@ -3741,7 +3744,7 @@
 	i = SDp->host->sg_tablesize;
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
-	buffer = new_tape_buffer(TRUE, (SDp->host)->unchecked_isa_dma, i);
+	buffer = new_tape_buffer(1, (SDp->host)->unchecked_isa_dma, i);
 	if (buffer == NULL) {
 		printk(KERN_ERR "st: Can't allocate new tape buffer. Device not attached.\n");
 		goto out;
@@ -3844,7 +3847,7 @@
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
-		STm->defined = FALSE;
+		STm->defined = 0;
 		STm->sysv = ST_SYSV;
 		STm->defaults_for_writes = 0;
 		STm->do_async_writes = ST_ASYNC_WRITES;
@@ -3860,16 +3863,16 @@
 		STps->rw = ST_IDLE;
 		STps->eof = ST_NOEOF;
 		STps->at_sm = 0;
-		STps->last_block_valid = FALSE;
+		STps->last_block_valid = 0;
 		STps->drv_block = (-1);
 		STps->drv_file = (-1);
 	}
 
 	tpnt->current_mode = 0;
-	tpnt->modes[0].defined = TRUE;
+	tpnt->modes[0].defined = 1;
 
 	tpnt->density_changed = tpnt->compression_changed =
-	    tpnt->blksize_changed = FALSE;
+	    tpnt->blksize_changed = 0;
 	init_MUTEX(&tpnt->lock);
 
 	st_nr_dev++;
@@ -3961,7 +3964,7 @@
 
 static int st_remove(struct device *dev)
 {
-	Scsi_Device *SDp = to_scsi_device(dev);
+	struct scsi_device *SDp = to_scsi_device(dev);
 	Scsi_Tape *tpnt;
 	int i, j, mode;
 
@@ -4253,7 +4256,7 @@
 	return nr_pages;
 
  out_unmap:
-	sgl_unmap_user_pages(sgl, nr_pages, FALSE);
+	sgl_unmap_user_pages(sgl, nr_pages, 0);
 	return 0;
 }
 
--- linux-2.6.9-rc2-bk1/drivers/scsi/st.h	2004-06-16 20:52:54.000000000 +0300
+++ linux-2.6.9-rc2-bk1-k1/drivers/scsi/st.h	2004-09-14 22:22:23.000000000 +0300
@@ -2,11 +2,9 @@
 #ifndef _ST_H
 #define _ST_H
 
-#ifndef _SCSI_H
-#include "scsi.h"
-#endif
 #include <linux/completion.h>
 
+
 /* The tape buffer descriptor. */
 typedef struct {
 	unsigned char in_use;
@@ -19,7 +17,7 @@
 	int writing;
 	int midlevel_result;
 	int syscall_result;
-	Scsi_Request *last_SRpnt;
+	struct scsi_request *last_SRpnt;
 	unsigned char *b_data;
 	unsigned short use_sg;	/* zero or max number of s/g segments for this adapter */
 	unsigned short sg_segs;		/* number of segments in s/g list */
@@ -76,7 +74,7 @@
 /* The tape drive descriptor */
 typedef struct {
 	struct scsi_driver *driver;
-	Scsi_Device *device;
+	struct scsi_device *device;
 	struct semaphore lock;	/* For serialization */
 	struct completion wait;	/* For SCSI commands */
 	ST_buffer *buffer;
