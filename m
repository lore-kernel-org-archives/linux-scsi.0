From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] descriptor sense format, mid-level
Date: Mon, 08 Nov 2004 23:00:39 +1000
Message-ID: <418F6DF7.6090205@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050700040100030605070500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:61575 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261833AbUKHNAp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 08:00:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 1AEC039404C
	for <linux-scsi@vger.kernel.org>; Mon,  8 Nov 2004 23:00:44 +1000 (EST)
Received: from [192.168.48.80] (dsl-16.130.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.130.16])
	by borg.st.net.au (Postfix) with ESMTP id 9DFD239402E
	for <linux-scsi@vger.kernel.org>; Mon,  8 Nov 2004 23:00:40 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050700040100030605070500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The 4 attachments replace sense_buffer handling that assumes
only fixed format from the scsi mid-level in lk 2.6.10-rc1.
There are many occurrences in the ULDs to be fixed.

Changelog:
   - generalize sense data logic to cope with both fixed and
     descriptor format
   - use KERN_INFO on most printk()s to limit console noise
   - retire mid-level usage of sense_class(), sense_error() and
     sense_valid() macros which are SCSI-1 remnants. Now only
     cpqfcTSinit.c seems to use them

Doug Gilbert

--------------050700040100030605070500
Content-Type: text/x-patch;
 name="scsi_error2610rc1ds.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error2610rc1ds.diff"

--- linux/drivers/scsi/scsi_error.c	2004-10-23 14:10:13.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2610rc1ds	2004-11-08 16:43:52.000000000 +1000
@@ -268,16 +268,42 @@
  *
  * Return value:
  * 	SUCCESS or FAILED or NEEDS_RETRY
+ *
+ * Notes:
+ *	When a deferred error is detected the current command has
+ *	not been executed and needs retrying.
  **/
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
-	if (!SCSI_SENSE_VALID(scmd))
-		return FAILED;
+	struct scsi_sense_hdr sshdr;
 
-	if (scmd->sense_buffer[2] & 0xe0)
-		return SUCCESS;
+	if (! scsi_command_normalize_sense(scmd, &sshdr))
+		return FAILED;	/* no valid sense data */
 
-	switch (scmd->sense_buffer[2] & 0xf) {
+	if (scsi_sense_is_deferred(&sshdr))
+		return NEEDS_RETRY;
+
+	/*
+	 * Previous logic looked for FILEMARK, EOM or ILI which are
+	 * mainly associated with tapes and returned SUCCESS.
+	 */
+	if (sshdr.response_code == 0x70) {
+		/* fixed format */
+		if (scmd->sense_buffer[2] & 0xe0)
+			return SUCCESS;
+	} else {
+		/*
+		 * descriptor format: look for "stream commands sense data
+		 * descriptor" (see SSC-3). Assume single sense data
+		 * descriptor. Ignore ILI from SBC-2 READ LONG and WRITE LONG.
+		 */
+		if ((sshdr.additional_length > 3) &&
+		    (scmd->sense_buffer[8] == 0x4) &&
+		    (scmd->sense_buffer[11] & 0xe0))
+			return SUCCESS;
+	}
+
+	switch (sshdr.sense_key) {
 	case NO_SENSE:
 		return SUCCESS;
 	case RECOVERED_ERROR:
@@ -301,19 +327,15 @@
 		 * if the device is in the process of becoming ready, we 
 		 * should retry.
 		 */
-		if ((scmd->sense_buffer[12] == 0x04) &&
-			(scmd->sense_buffer[13] == 0x01)) {
+		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
 			return NEEDS_RETRY;
-		}
 		/*
 		 * if the device is not started, we need to wake
 		 * the error handler to start the motor
 		 */
 		if (scmd->device->allow_restart &&
-		    (scmd->sense_buffer[12] == 0x04) &&
-		    (scmd->sense_buffer[13] == 0x02)) {
+		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
-		}
 		return SUCCESS;
 
 		/* these three are not supported */
@@ -1358,7 +1380,8 @@
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk("scsi%d (%d,%d,%d) : reservation conflict\n",
+		printk(KERN_INFO "scsi: reservation conflict: host"
+                                " %d channel %d id %d lun %d\n",
 		       scmd->device->host->host_no, scmd->device->channel,
 		       scmd->device->id, scmd->device->lun);
 		return SUCCESS; /* causes immediate i/o error */

--------------050700040100030605070500
Content-Type: text/x-patch;
 name="scsi_lib2610rc1ds.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_lib2610rc1ds.diff"

--- linux/drivers/scsi/scsi_lib.c	2004-11-07 22:54:47.000000000 +1000
+++ linux/drivers/scsi/scsi_lib.c2610rc1ds	2004-11-08 17:14:41.000000000 +1000
@@ -717,7 +717,7 @@
 			clear_errors = 0;
 			if (scsi_command_normalize_sense(cmd, &sshdr)) {
 				/*
-				 * SG_IO wants to know about deferred errors
+				 * SG_IO wants current and deferred errors
 				 */
 				int len = 8 + cmd->sense_buffer[7];
 
@@ -843,9 +843,10 @@
 			cmd = scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
-			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
-			       cmd->device->host->host_no, (int) cmd->device->channel,
-			       (int) cmd->device->id, (int) cmd->device->lun);
+			printk(KERN_INFO "Volume overflow <%d %d %d %d> CDB: ",
+			       cmd->device->host->host_no,
+			       (int)cmd->device->channel,
+			       (int)cmd->device->id, (int)cmd->device->lun);
 			__scsi_print_command(cmd->data_cmnd);
 			scsi_print_sense("", cmd);
 			cmd = scsi_end_request(cmd, 0, block_bytes, 1);
@@ -864,8 +865,8 @@
 		return;
 	}
 	if (result) {
-		printk("SCSI error : <%d %d %d %d> return code = 0x%x\n",
-		       cmd->device->host->host_no,
+		printk(KERN_INFO "SCSI error : <%d %d %d %d> return code "
+		       "= 0x%x\n", cmd->device->host->host_no,
 		       cmd->device->channel,
 		       cmd->device->id,
 		       cmd->device->lun, result);
@@ -1600,12 +1601,15 @@
 	sreq->sr_data_direction = DMA_NONE;
 	scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
 
-	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-	    ((sreq->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION ||
-	     (sreq->sr_sense_buffer[2] & 0x0f) == NOT_READY) &&
-	    sdev->removable) {
-		sdev->changed = 1;
-		sreq->sr_result = 0;
+	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) && sdev->removable) {
+		struct scsi_sense_hdr sshdr;
+
+		if ((scsi_request_normalize_sense(sreq, &sshdr)) &&
+		    ((sshdr.sense_key == UNIT_ATTENTION) ||
+		     (sshdr.sense_key == NOT_READY))) {
+			sdev->changed = 1;
+			sreq->sr_result = 0;
+		}
 	}
 	result = sreq->sr_result;
 	scsi_release_request(sreq);

--------------050700040100030605070500
Content-Type: text/x-patch;
 name="scsi_scan2610rc1ds.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_scan2610rc1ds.diff"

--- linux/drivers/scsi/scsi_scan.c	2004-10-23 14:10:13.000000000 +1000
+++ linux/drivers/scsi/scsi_scan.c2610rc1ds	2004-11-08 18:33:25.000000000 +1000
@@ -39,6 +39,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_request.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_eh.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -323,6 +324,7 @@
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count;
+	struct scsi_sense_hdr sshdr;
 
 	*bflags = 0;
 
@@ -358,17 +360,20 @@
 				sreq->sr_result));
 
 		if (sreq->sr_result) {
-
-			/* not-ready to ready transition or power-on - good */
-			/* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
-			/* Supposedly, but many buggy devices do so anyway. */
+			/*
+			 * not-ready to ready transition [asc/ascq=0x28/0x0]
+			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
+			 * INQUIRY should not yield UNIT_ATTENTION
+			 * but many buggy devices do so anyway. 
+			 */
 			if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-					(sreq->sr_sense_buffer[2] & 0xf) ==
-						UNIT_ATTENTION &&
-					(sreq->sr_sense_buffer[12] == 0x28 ||
-					 sreq->sr_sense_buffer[12] == 0x29) &&
-					sreq->sr_sense_buffer[13] == 0)
-				continue;
+			    scsi_request_normalize_sense(sreq, &sshdr)) {
+				if ((sshdr.sense_key == UNIT_ATTENTION) &&
+				    ((sshdr.asc == 0x28) ||
+				     (sshdr.asc == 0x29)) &&
+				    (sshdr.ascq == 0))
+					continue;
+			}
 		}
 		break;
 	}
@@ -894,6 +899,7 @@
 	struct scsi_lun *lunp, *lun_data;
 	struct scsi_request *sreq;
 	u8 *data;
+	struct scsi_sense_hdr sshdr;
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -971,9 +977,12 @@
 				" %s (try %d) result 0x%x\n", sreq->sr_result
 				?  "failed" : "successful", retries,
 				sreq->sr_result));
-		if (sreq->sr_result == 0 ||
-		    sreq->sr_sense_buffer[2] != UNIT_ATTENTION)
+		if (sreq->sr_result == 0)
 			break;
+		else if (scsi_request_normalize_sense(sreq, &sshdr)) {
+			if (sshdr.sense_key != UNIT_ATTENTION)
+				break;
+		}
 	}
 
 	if (sreq->sr_result) {

--------------050700040100030605070500
Content-Type: text/x-patch;
 name="scsi_ioctl2610rc1ds.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_ioctl2610rc1ds.diff"

--- linux/drivers/scsi/scsi_ioctl.c	2004-10-23 15:01:08.000000000 +1000
+++ linux/drivers/scsi/scsi_ioctl.c2610rc1ds	2004-11-08 20:56:44.000000000 +1000
@@ -21,6 +21,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_request.h>
 #include <scsi/sg.h>
+#include <scsi/scsi_dbg.h>
 
 #include "scsi_logging.h"
 
@@ -94,12 +95,13 @@
 {
 	struct scsi_request *sreq;
 	int result;
+	struct scsi_sense_hdr sshdr;
 
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
 	sreq = scsi_allocate_request(sdev, GFP_KERNEL);
 	if (!sreq) {
-		printk("SCSI internal ioctl failed, no memory\n");
+		printk(KERN_WARNING "SCSI internal ioctl failed, no memory\n");
 		return -ENOMEM;
 	}
 
@@ -108,17 +110,21 @@
 
 	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", sreq->sr_result));
 
-	if (driver_byte(sreq->sr_result)) {
-		switch (sreq->sr_sense_buffer[2] & 0xf) {
+	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
+	    (scsi_request_normalize_sense(sreq, &sshdr))) {
+		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
 			if (cmd[0] == ALLOW_MEDIUM_REMOVAL)
 				sdev->lockable = 0;
 			else
-				printk("SCSI device (ioctl) reports ILLEGAL REQUEST.\n");
+				printk(KERN_INFO "ioctl_internal_command: "
+				       "ILLEGAL REQUEST asc=0x%x ascq=0x%x\n",
+				       sshdr.asc, sshdr.ascq);
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
 			if (sdev->removable && (cmd[0] != TEST_UNIT_READY)) {
-				printk(KERN_INFO "Device not ready.  Make sure there is a disc in the drive.\n");
+				printk(KERN_INFO "Device not ready. Make sure"
+				       " there is a disc in the drive.\n");
 				break;
 			}
 		case UNIT_ATTENTION:
@@ -128,16 +134,15 @@
 				break;
 			}
 		default:	/* Fall through for non-removable media */
-			printk("SCSI error: host %d id %d lun %d return code = %x\n",
+			printk(KERN_INFO "ioctl_internal_command: <%d %d %d "
+			       "%d> return code = %x\n",
 			       sdev->host->host_no,
+			       sdev->channel,
 			       sdev->id,
 			       sdev->lun,
 			       sreq->sr_result);
-			printk("\tSense class %x, sense error %x, extended sense %x\n",
-			       sense_class(sreq->sr_sense_buffer[0]),
-			       sense_error(sreq->sr_sense_buffer[0]),
-			       sreq->sr_sense_buffer[2] & 0xf);
-
+			scsi_print_req_sense("   ", sreq);
+			break;
 		}
 	}
 
@@ -401,7 +406,8 @@
 	case SCSI_IOCTL_SYNC:
 	case SCSI_IOCTL_START_UNIT:
 	case SCSI_IOCTL_STOP_UNIT:
-		printk(KERN_WARNING "program %s is using a deprecated SCSI ioctl, please convert it to SG_IO\n", current->comm);
+		printk(KERN_WARNING "program %s is using a deprecated SCSI "
+		       "ioctl, please convert it to SG_IO\n", current->comm);
 		break;
 	default:
 		break;

--------------050700040100030605070500--
