From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert sd to scsi_execute_req (and update the
	scsi_execute_req API)
Date: Sat, 11 Jun 2005 18:36:22 -0500
Message-ID: <1118532982.4924.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:6346 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261645AbVFKXgf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 19:36:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This one removes struct scsi_request entirely from sd.  In the process,
I noticed we have no callers of scsi_wait_req who don't immediately
normalise the sense, so I updated the API to make it take a struct
scsi_sense_hdr instead of simply a big sense buffer.

James

--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1155,6 +1155,31 @@ scsi_show_extd_sense(unsigned char asc, 
 	}
 }
 
+void
+scsi_print_sense_hdr(const char *name, struct scsi_sense_hdr *sshdr)
+{
+	const char *sense_txt;
+	/* An example of deferred is when an earlier write to disk cache
+	 * succeeded, but now the disk discovers that it cannot write the
+	 * data to the magnetic media.
+	 */
+	const char *error = scsi_sense_is_deferred(sshdr) ? 
+		"<<DEFERRED>>" : "Current";
+	printk(KERN_INFO "%s: %s", name, error);
+	if (sshdr->response_code >= 0x72)
+		printk(" [descriptor]");
+
+	sense_txt = scsi_sense_key_string(sshdr->sense_key);
+	if (sense_txt)
+		printk(": sense key: %s\n", sense_txt);
+	else
+		printk(": sense key=0x%x\n", sshdr->sense_key);
+	printk(KERN_INFO "    ");
+	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	printk("\n");
+}
+EXPORT_SYMBOL(scsi_print_sense_hdr);
+
 /* Print sense information */
 void
 __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
@@ -1162,8 +1187,6 @@ __scsi_print_sense(const char *name, con
 {
 	int k, num, res;
 	unsigned int info;
-	const char *error;
-	const char *sense_txt;
 	struct scsi_sense_hdr ssh;
     
 	res = scsi_normalize_sense(sense_buffer, sense_len, &ssh);
@@ -1181,26 +1204,7 @@ __scsi_print_sense(const char *name, con
 		printk("\n");
 		return;
 	}
-
-	/* An example of deferred is when an earlier write to disk cache
-	 * succeeded, but now the disk discovers that it cannot write the
-	 * data to the magnetic media.
-	 */
-	error = scsi_sense_is_deferred(&ssh) ? 
-			"<<DEFERRED>>" : "Current";
-	printk(KERN_INFO "%s: %s", name, error);
-	if (ssh.response_code >= 0x72)
-		printk(" [descriptor]");
-
-	sense_txt = scsi_sense_key_string(ssh.sense_key);
-	if (sense_txt)
-		printk(": sense key: %s\n", sense_txt);
-	else
-		printk(": sense key=0x%x\n", ssh.sense_key);
-	printk(KERN_INFO "    ");
-	scsi_show_extd_sense(ssh.asc, ssh.ascq);
-	printk("\n");
-
+	scsi_print_sense_hdr(name, &ssh);
 	if (ssh.response_code < 0x72) {
 		/* only decode extras for "fixed" format now */
 		char buff[80];
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -90,19 +90,16 @@ static int ioctl_internal_command(struct
 {
 	int result;
 	struct scsi_sense_hdr sshdr;
-	char sense[SCSI_SENSE_BUFFERSIZE];
 
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
-
-	memset(sense, 0, sizeof(*sense));
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  sense, timeout, retries);
+				  &sshdr, timeout, retries);
 
 	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", result));
 
 	if ((driver_byte(result) & DRIVER_SENSE) &&
-	    (scsi_normalize_sense(sense, sizeof(*sense), &sshdr))) {
+	    (scsi_sense_valid(&sshdr))) {
 		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
 			if (cmd[0] == ALLOW_MEDIUM_REMOVAL)
@@ -132,7 +129,7 @@ static int ioctl_internal_command(struct
 			       sdev->id,
 			       sdev->lun,
 			       result);
-			__scsi_print_sense("   ", sense, sizeof(*sense));
+			scsi_print_sense_hdr("   ", &sshdr);
 			break;
 		}
 	}
@@ -315,9 +312,9 @@ int scsi_ioctl_send_command(struct scsi_
 		break;
 	}
 
-	result = scsi_execute_req(sdev, cmd, data_direction, buf, needed,
-				  sense, timeout, retries);
-				  
+	result = scsi_execute(sdev, cmd, data_direction, buf, needed,
+			      sense, timeout, retries, 0);
+
 	/* 
 	 * If there was an error condition, pass the info back to the user. 
 	 */
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -296,8 +296,8 @@ EXPORT_SYMBOL(scsi_wait_req);
  * @retries:	number of times to retry request
  * @flags:	or into request flags;
  *
- * scsi_execute_req returns the req->errors value which is the
- * the scsi_cmnd result field.
+ * returns the req->errors value which is the the scsi_cmnd result
+ * field.
  **/
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
@@ -339,9 +339,31 @@ int scsi_execute(struct scsi_device *sde
 
 	return ret;
 }
-
 EXPORT_SYMBOL(scsi_execute);
 
+
+int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
+		     int data_direction, void *buffer, unsigned bufflen,
+		     struct scsi_sense_hdr *sshdr, int timeout, int retries)
+{
+	char *sense = NULL;
+		
+	if (sshdr) {
+		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!sense)
+			return DRIVER_ERROR << 24;
+		memset(sense, 0, sizeof(*sense));
+	}
+	int result = scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
+				  sense, timeout, retries, 0);
+	if (sshdr)
+		scsi_normalize_sense(sense, sizeof(*sense), sshdr);
+
+	kfree(sense);
+	return result;
+}
+EXPORT_SYMBOL(scsi_execute_req);
+
 /*
  * Function:    scsi_init_cmd_errh()
  *
@@ -1626,7 +1648,7 @@ void scsi_exit_queue(void)
 	}
 }
 /**
- *	__scsi_mode_sense - issue a mode sense, falling back from 10 to 
+ *	scsi_mode_sense - issue a mode sense, falling back from 10 to 
  *		six bytes if necessary.
  *	@sdev:	SCSI device to be queried
  *	@dbd:	set if mode sense will allow block descriptors to be returned
@@ -1646,26 +1668,22 @@ void scsi_exit_queue(void)
 int
 scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		  unsigned char *buffer, int len, int timeout, int retries,
-		  struct scsi_mode_data *data, char *sense) {
+		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr) {
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
 	int result;
-	char *sense_buffer = NULL;
+	struct scsi_sense_hdr my_sshdr;
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
 
-	if (!sense) {
-		sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-		if (!sense_buffer) {
-			dev_printk(KERN_ERR, &sdev->sdev_gendev, "failed to allocate sense buffer\n");
-			return 0;
-		}
-		sense = sense_buffer;
-	}
+	/* caller might not be interested in sense, but we need it */
+	if (!sshdr)
+		sshdr = &my_sshdr;
+
  retry:
 	use_10_for_ms = sdev->use_10_for_ms;
 
@@ -1685,12 +1703,10 @@ scsi_mode_sense(struct scsi_device *sdev
 		header_length = 4;
 	}
 
-	memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
-
 	memset(buffer, 0, len);
 
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sense, timeout, retries);
+				  sshdr, timeout, retries);
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
@@ -1699,11 +1715,9 @@ scsi_mode_sense(struct scsi_device *sdev
 
 	if (use_10_for_ms && !scsi_status_is_good(result) &&
 	    (driver_byte(result) & DRIVER_SENSE)) {
-		struct scsi_sense_hdr sshdr;
-
-		if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
-			if ((sshdr.sense_key == ILLEGAL_REQUEST) &&
-			    (sshdr.asc == 0x20) && (sshdr.ascq == 0)) {
+		if (scsi_sense_valid(sshdr)) {
+			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
+			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
 				/* 
 				 * Invalid command operation code
 				 */
@@ -1730,7 +1744,6 @@ scsi_mode_sense(struct scsi_device *sdev
 		}
 	}
 
-	kfree(sense_buffer);
 	return result;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
@@ -1741,17 +1754,15 @@ scsi_test_unit_ready(struct scsi_device 
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
-	char sense[SCSI_SENSE_BUFFERSIZE];
+	struct scsi_sense_hdr sshdr;
 	int result;
 	
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sense,
+	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
 				  timeout, retries);
 
 	if ((driver_byte(result) & DRIVER_SENSE) && sdev->removable) {
-		struct scsi_sense_hdr sshdr;
 
-		if ((scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
-					  &sshdr)) &&
+		if ((scsi_sense_valid(&sshdr)) &&
 		    ((sshdr.sense_key == UNIT_ATTENTION) ||
 		     (sshdr.sense_key == NOT_READY))) {
 			sdev->changed = 1;
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -432,7 +432,6 @@ void scsi_target_reap(struct scsi_target
 static int scsi_probe_lun(struct scsi_device *sdev, char *inq_result,
 			  int result_len, int *bflags)
 {
-	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
@@ -460,11 +459,10 @@ static int scsi_probe_lun(struct scsi_de
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) try_inquiry_len;
 
-		memset(sense, 0, sizeof(sense));
 		memset(inq_result, 0, try_inquiry_len);
 
 		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, sense,
+					  inq_result, try_inquiry_len, &sshdr,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3);
 
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY %s "
@@ -479,8 +477,7 @@ static int scsi_probe_lun(struct scsi_de
 			 * but many buggy devices do so anyway. 
 			 */
 			if ((driver_byte(result) & DRIVER_SENSE) &&
-			    scsi_normalize_sense(sense, sizeof(sense),
-						 &sshdr)) {
+			    scsi_sense_valid(&sshdr)) {
 				if ((sshdr.sense_key == UNIT_ATTENTION) &&
 				    ((sshdr.asc == 0x28) ||
 				     (sshdr.asc == 0x29)) &&
@@ -1010,7 +1007,6 @@ static int scsi_report_lun_scan(struct s
 				int rescan)
 {
 	char devname[64];
-	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	unsigned int lun;
@@ -1087,9 +1083,8 @@ static int scsi_report_lun_scan(struct s
 				" REPORT LUNS to %s (try %d)\n", devname,
 				retries));
 
-		memset(sense, 0, sizeof(sense));
 		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, sense,
+					  lun_data, length, &sshdr,
 					  SCSI_TIMEOUT + 4 * HZ, 3);
 
 		SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LUNS"
@@ -1097,7 +1092,7 @@ static int scsi_report_lun_scan(struct s
 				?  "failed" : "successful", retries, result));
 		if (result == 0)
 			break;
-		else if (scsi_normalize_sense(sense, sizeof(sense), &sshdr)) {
+		else if (scsi_sense_valid(&sshdr)) {
 			if (sshdr.sense_key != UNIT_ATTENTION)
 				break;
 		}
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -59,7 +59,6 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
 #include <scsi/scsicam.h>
 
 #include "scsi_logging.h"
@@ -125,7 +124,7 @@ static int sd_issue_flush(struct device 
 static void sd_end_flush(request_queue_t *, struct request *);
 static int sd_prepare_flush(request_queue_t *, struct request *);
 static void sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
-		 struct scsi_request *SRpnt, unsigned char *buffer);
+			     unsigned char *buffer);
 
 static struct scsi_driver sd_template = {
 	.owner			= THIS_MODULE,
@@ -685,19 +684,13 @@ not_present:
 
 static int sd_sync_cache(struct scsi_device *sdp)
 {
-	struct scsi_request *sreq;
 	int retries, res;
+	struct scsi_sense_hdr sshdr;
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
-	if (!sreq) {
-		printk("FAILED\n  No memory for request\n");
-		return -ENOMEM;
-	}
 
-	sreq->sr_data_direction = DMA_NONE;
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[10] = { 0 };
 
@@ -706,22 +699,20 @@ static int sd_sync_cache(struct scsi_dev
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		scsi_wait_req(sreq, cmd, NULL, 0, SD_TIMEOUT, SD_MAX_RETRIES);
-		if (sreq->sr_result == 0)
+		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+				       SD_TIMEOUT, SD_MAX_RETRIES);
+		if (res == 0)
 			break;
 	}
 
-	res = sreq->sr_result;
-	if (res) {
-		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
+	if (res) {		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
 				    "host = %d, driver = %02x\n  ",
 				    status_byte(res), msg_byte(res),
 				    host_byte(res), driver_byte(res));
 			if (driver_byte(res) & DRIVER_SENSE)
-				scsi_print_req_sense("sd", sreq);
+				scsi_print_sense_hdr("sd", &sshdr);
 	}
 
-	scsi_release_request(sreq);
 	return res;
 }
 
@@ -960,22 +951,19 @@ static void sd_rw_intr(struct scsi_cmnd 
 	scsi_io_completion(SCpnt, good_bytes, block_sectors << 9);
 }
 
-static int media_not_present(struct scsi_disk *sdkp, struct scsi_request *srp)
+static int media_not_present(struct scsi_disk *sdkp,
+			     struct scsi_sense_hdr *sshdr)
 {
-	struct scsi_sense_hdr sshdr;
 
-	if (!srp->sr_result)
-		return 0;
-	if (!(driver_byte(srp->sr_result) & DRIVER_SENSE))
+	if (!scsi_sense_valid(sshdr))
 		return 0;
 	/* not invoked for commands that could return deferred errors */
-	if (scsi_request_normalize_sense(srp, &sshdr)) {
-		if (sshdr.sense_key != NOT_READY &&
-		    sshdr.sense_key != UNIT_ATTENTION)
-			return 0;
-		if (sshdr.asc != 0x3A) /* medium not present */
-			return 0;
-	}
+	if (sshdr->sense_key != NOT_READY &&
+	    sshdr->sense_key != UNIT_ATTENTION)
+		return 0;
+	if (sshdr->asc != 0x3A) /* medium not present */
+		return 0;
+
 	set_media_not_present(sdkp);
 	return 1;
 }
@@ -984,8 +972,8 @@ static int media_not_present(struct scsi
  * spinup disk - called only in sd_revalidate_disk()
  */
 static void
-sd_spinup_disk(struct scsi_disk *sdkp, char *diskname,
-	       struct scsi_request *SRpnt, unsigned char *buffer) {
+sd_spinup_disk(struct scsi_disk *sdkp, char *diskname)
+{
 	unsigned char cmd[10];
 	unsigned long spintime_value = 0;
 	int retries, spintime;
@@ -1004,18 +992,13 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			SRpnt->sr_cmd_len = 0;
-			memset(SRpnt->sr_sense_buffer, 0,
-			       SCSI_SENSE_BUFFERSIZE);
-			SRpnt->sr_data_direction = DMA_NONE;
-
-			scsi_wait_req (SRpnt, (void *) cmd, (void *) buffer,
-				       0/*512*/, SD_TIMEOUT, SD_MAX_RETRIES);
+			the_result = scsi_execute_req(sdkp->device, cmd,
+						      DMA_NONE, NULL, 0,
+						      &sshdr, SD_TIMEOUT,
+						      SD_MAX_RETRIES);
 
-			the_result = SRpnt->sr_result;
 			if (the_result)
-				sense_valid = scsi_request_normalize_sense(
-							SRpnt, &sshdr);
+				sense_valid = scsi_sense_valid(&sshdr);
 			retries++;
 		} while (retries < 3 && 
 			 (!scsi_status_is_good(the_result) ||
@@ -1027,7 +1010,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 		 * any media in it, don't bother with any of the rest of
 		 * this crap.
 		 */
-		if (media_not_present(sdkp, SRpnt))
+		if (media_not_present(sdkp, &sshdr))
 			return;
 
 		if ((driver_byte(the_result) & DRIVER_SENSE) == 0) {
@@ -1066,14 +1049,9 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 				cmd[1] = 1;	/* Return immediately */
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
-				SRpnt->sr_cmd_len = 0;
-				memset(SRpnt->sr_sense_buffer, 0,
-					SCSI_SENSE_BUFFERSIZE);
-
-				SRpnt->sr_data_direction = DMA_NONE;
-				scsi_wait_req(SRpnt, (void *)cmd, 
-					      (void *) buffer, 0/*512*/, 
-					      SD_TIMEOUT, SD_MAX_RETRIES);
+				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
+						 NULL, 0, &sshdr,
+						 SD_TIMEOUT, SD_MAX_RETRIES);
 				spintime_value = jiffies;
 			}
 			spintime = 1;
@@ -1086,7 +1064,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			if(!spintime) {
 				printk(KERN_NOTICE "%s: Unit Not Ready, "
 					"sense:\n", diskname);
-				scsi_print_req_sense("", SRpnt);
+				scsi_print_sense_hdr("", &sshdr);
 			}
 			break;
 		}
@@ -1107,14 +1085,15 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
  */
 static void
 sd_read_capacity(struct scsi_disk *sdkp, char *diskname,
-		 struct scsi_request *SRpnt, unsigned char *buffer) {
+		 unsigned char *buffer)
+{
 	unsigned char cmd[16];
-	struct scsi_device *sdp = sdkp->device;
 	int the_result, retries;
 	int sector_size = 0;
 	int longrc = 0;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
+	struct scsi_device *sdp = sdkp->device;
 
 repeat:
 	retries = 3;
@@ -1131,20 +1110,15 @@ repeat:
 			memset((void *) buffer, 0, 8);
 		}
 		
-		SRpnt->sr_cmd_len = 0;
-		memset(SRpnt->sr_sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
-
-		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
-			      longrc ? 12 : 8, SD_TIMEOUT, SD_MAX_RETRIES);
+		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+					      buffer, longrc ? 12 : 8, &sshdr,
+					      SD_TIMEOUT, SD_MAX_RETRIES);
 
-		if (media_not_present(sdkp, SRpnt))
+		if (media_not_present(sdkp, &sshdr))
 			return;
 
-		the_result = SRpnt->sr_result;
 		if (the_result)
-			sense_valid = scsi_request_normalize_sense(SRpnt,
-								   &sshdr);
+			sense_valid = scsi_sense_valid(&sshdr);
 		retries--;
 
 	} while (the_result && retries);
@@ -1159,7 +1133,7 @@ repeat:
 		       driver_byte(the_result));
 
 		if (driver_byte(the_result) & DRIVER_SENSE)
-			scsi_print_req_sense("sd", SRpnt);
+			scsi_print_sense_hdr("sd", &sshdr);
 		else
 			printk("%s : sense not available. \n", diskname);
 
@@ -1299,12 +1273,13 @@ got_data:
 
 /* called with buffer of length 512 */
 static inline int
-sd_do_mode_sense(struct scsi_request *SRpnt, int dbd, int modepage,
-		 unsigned char *buffer, int len, struct scsi_mode_data *data)
+sd_do_mode_sense(struct scsi_device *sdp, int dbd, int modepage,
+		 unsigned char *buffer, int len, struct scsi_mode_data *data,
+		 struct scsi_sense_hdr *sshdr)
 {
-	return scsi_mode_sense(SRpnt->sr_device, dbd, modepage, buffer, len,
+	return scsi_mode_sense(sdp, dbd, modepage, buffer, len,
 			       SD_TIMEOUT, SD_MAX_RETRIES, data,
-			       SRpnt->sr_sense_buffer);
+			       sshdr);
 }
 
 /*
@@ -1313,25 +1288,27 @@ sd_do_mode_sense(struct scsi_request *SR
  */
 static void
 sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
-		   struct scsi_request *SRpnt, unsigned char *buffer) {
+			   unsigned char *buffer)
+{
 	int res;
+	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
 
 	set_disk_ro(sdkp->disk, 0);
-	if (sdkp->device->skip_ms_page_3f) {
+	if (sdp->skip_ms_page_3f) {
 		printk(KERN_NOTICE "%s: assuming Write Enabled\n", diskname);
 		return;
 	}
 
-	if (sdkp->device->use_192_bytes_for_3f) {
-		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 192, &data);
+	if (sdp->use_192_bytes_for_3f) {
+		res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 192, &data, NULL);
 	} else {
 		/*
 		 * First attempt: ask for all pages (0x3F), but only 4 bytes.
 		 * We have to start carefully: some devices hang if we ask
 		 * for more than is available.
 		 */
-		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
+		res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 4, &data, NULL);
 
 		/*
 		 * Second attempt: ask for page 0 When only page 0 is
@@ -1340,14 +1317,14 @@ sd_read_write_protect_flag(struct scsi_d
 		 * CDB.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
+			res = sd_do_mode_sense(sdp, 0, 0, buffer, 4, &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255,
-					       &data);
+			res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 255,
+					       &data, NULL);
 	}
 
 	if (!scsi_status_is_good(res)) {
@@ -1369,19 +1346,20 @@ sd_read_write_protect_flag(struct scsi_d
  */
 static void
 sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
-		   struct scsi_request *SRpnt, unsigned char *buffer)
+		   unsigned char *buffer)
 {
 	int len = 0, res;
+	struct scsi_device *sdp = sdkp->device;
 
 	int dbd;
 	int modepage;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdkp->device->skip_ms_page_8)
+	if (sdp->skip_ms_page_8)
 		goto defaults;
 
-	if (sdkp->device->type == TYPE_RBC) {
+	if (sdp->type == TYPE_RBC) {
 		modepage = 6;
 		dbd = 8;
 	} else {
@@ -1390,7 +1368,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 	}
 
 	/* cautiously ask */
-	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
+	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, 4, &data, &sshdr);
 
 	if (!scsi_status_is_good(res))
 		goto bad_sense;
@@ -1411,7 +1389,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 	len += data.header_length + data.block_descriptor_length;
 
 	/* Get the data */
-	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);
+	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
 		const char *types[] = {
@@ -1443,7 +1421,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 	}
 
 bad_sense:
-	if (scsi_request_normalize_sense(SRpnt, &sshdr) &&
+	if (scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		printk(KERN_NOTICE "%s: cache data unavailable\n",
@@ -1468,7 +1446,6 @@ static int sd_revalidate_disk(struct gen
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
-	struct scsi_request *sreq;
 	unsigned char *buffer;
 
 	SCSI_LOG_HLQUEUE(3, printk("sd_revalidate_disk: disk=%s\n", disk->disk_name));
@@ -1480,18 +1457,11 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
-	if (!sreq) {
-		printk(KERN_WARNING "(sd_revalidate_disk:) Request allocation "
-		       "failure.\n");
-		goto out;
-	}
-
 	buffer = kmalloc(512, GFP_KERNEL | __GFP_DMA);
 	if (!buffer) {
 		printk(KERN_WARNING "(sd_revalidate_disk:) Memory allocation "
 		       "failure.\n");
-		goto out_release_request;
+		goto out;
 	}
 
 	/* defaults, until the device tells us otherwise */
@@ -1502,25 +1472,23 @@ static int sd_revalidate_disk(struct gen
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 
-	sd_spinup_disk(sdkp, disk->disk_name, sreq, buffer);
+	sd_spinup_disk(sdkp, disk->disk_name);
 
 	/*
 	 * Without media there is no reason to ask; moreover, some devices
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, disk->disk_name, sreq, buffer);
+		sd_read_capacity(sdkp, disk->disk_name, buffer);
 		if (sdp->removable)
 			sd_read_write_protect_flag(sdkp, disk->disk_name,
-					sreq, buffer);
-		sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
+						   buffer);
+		sd_read_cache_type(sdkp, disk->disk_name, buffer);
 	}
 		
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
 
- out_release_request: 
-	scsi_release_request(sreq);
  out:
 	return 0;
 }
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -3,8 +3,10 @@
 
 struct scsi_cmnd;
 struct scsi_request;
+struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
+extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
 extern void __scsi_print_command(unsigned char *);
 extern void scsi_print_sense(const char *, struct scsi_cmnd *);
 extern void scsi_print_req_sense(const char *, struct scsi_request *);
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,6 +8,7 @@
 
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_sense_hdr;
 
 struct scsi_mode_data {
 	__u32	length;
@@ -236,7 +237,7 @@ extern int scsi_set_medium_removal(struc
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			   unsigned char *buffer, int len, int timeout,
 			   int retries, struct scsi_mode_data *data,
-			   char *sense);
+			   struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
@@ -258,15 +259,10 @@ extern int scsi_execute(struct scsi_devi
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
 			int flag);
+extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
+			    int data_direction, void *buffer, unsigned bufflen,
+			    struct scsi_sense_hdr *, int timeout, int retries);
 
-static inline int
-scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries)
-{
-	return scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,
-			    timeout, retries, 0);
-}
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;


