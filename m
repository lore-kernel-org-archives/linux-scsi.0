From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert the remaining mid-layer pieces to scsi_execute_req
Date: Sat, 11 Jun 2005 10:02:02 -0500
Message-ID: <1118502122.4924.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39097 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261723AbVFKPCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 11:02:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

After this, we just have some drivers, all the ULDs and the SPI
transport class using scsi_wait_req().

James

--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -88,25 +88,21 @@ static int ioctl_probe(struct Scsi_Host 
 static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 				  int timeout, int retries)
 {
-	struct scsi_request *sreq;
 	int result;
 	struct scsi_sense_hdr sshdr;
+	char sense[SCSI_SENSE_BUFFERSIZE];
 
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
-	sreq = scsi_allocate_request(sdev, GFP_KERNEL);
-	if (!sreq) {
-		printk(KERN_WARNING "SCSI internal ioctl failed, no memory\n");
-		return -ENOMEM;
-	}
 
-	sreq->sr_data_direction = DMA_NONE;
-        scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
+	memset(sense, 0, sizeof(*sense));
+	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
+				  sense, timeout, retries);
 
-	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", sreq->sr_result));
+	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", result));
 
-	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-	    (scsi_request_normalize_sense(sreq, &sshdr))) {
+	if ((driver_byte(result) & DRIVER_SENSE) &&
+	    (scsi_normalize_sense(sense, sizeof(*sense), &sshdr))) {
 		switch (sshdr.sense_key) {
 		case ILLEGAL_REQUEST:
 			if (cmd[0] == ALLOW_MEDIUM_REMOVAL)
@@ -125,7 +121,7 @@ static int ioctl_internal_command(struct
 		case UNIT_ATTENTION:
 			if (sdev->removable) {
 				sdev->changed = 1;
-				sreq->sr_result = 0;	/* This is no longer considered an error */
+				result = 0;	/* This is no longer considered an error */
 				break;
 			}
 		default:	/* Fall through for non-removable media */
@@ -135,15 +131,13 @@ static int ioctl_internal_command(struct
 			       sdev->channel,
 			       sdev->id,
 			       sdev->lun,
-			       sreq->sr_result);
-			scsi_print_req_sense("   ", sreq);
+			       result);
+			__scsi_print_sense("   ", sense, sizeof(*sense));
 			break;
 		}
 	}
 
-	result = sreq->sr_result;
 	SCSI_LOG_IOCTL(2, printk("IOCTL Releasing command\n"));
-	scsi_release_request(sreq);
 	return result;
 }
 
@@ -208,8 +202,8 @@ int scsi_ioctl_send_command(struct scsi_
 {
 	char *buf;
 	unsigned char cmd[MAX_COMMAND_SIZE];
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	char __user *cmd_in;
-	struct scsi_request *sreq;
 	unsigned char opcode;
 	unsigned int inlen, outlen, cmdlen;
 	unsigned int needed, buf_needed;
@@ -321,31 +315,23 @@ int scsi_ioctl_send_command(struct scsi_
 		break;
 	}
 
-	sreq = scsi_allocate_request(sdev, GFP_KERNEL);
-        if (!sreq) {
-                result = -EINTR;
-                goto error;
-        }
-
-	sreq->sr_data_direction = data_direction;
-        scsi_wait_req(sreq, cmd, buf, needed, timeout, retries);
-
+	result = scsi_execute_req(sdev, cmd, data_direction, buf, needed,
+				  sense, timeout, retries);
+				  
 	/* 
 	 * If there was an error condition, pass the info back to the user. 
 	 */
-	result = sreq->sr_result;
 	if (result) {
-		int sb_len = sizeof(sreq->sr_sense_buffer);
+		int sb_len = sizeof(*sense);
 
 		sb_len = (sb_len > OMAX_SB_LEN) ? OMAX_SB_LEN : sb_len;
-		if (copy_to_user(cmd_in, sreq->sr_sense_buffer, sb_len))
+		if (copy_to_user(cmd_in, sense, sb_len))
 			result = -EFAULT;
 	} else {
 		if (copy_to_user(cmd_in, buf, outlen))
 			result = -EFAULT;
 	}	
 
-	scsi_release_request(sreq);
 error:
 	kfree(buf);
 	return result;
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1627,7 +1627,7 @@ void scsi_exit_queue(void)
 /**
  *	__scsi_mode_sense - issue a mode sense, falling back from 10 to 
  *		six bytes if necessary.
- *	@sreq:	SCSI request to fill in with the MODE_SENSE
+ *	@sdev:	SCSI device to be queried
  *	@dbd:	set if mode sense will allow block descriptors to be returned
  *	@modepage: mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
@@ -1635,26 +1635,38 @@ void scsi_exit_queue(void)
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
+ *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if unsuccessful, or the header offset (either 4
  *	or 8 depending on whether a six or ten byte command was
  *	issued) if successful.
  **/
 int
-__scsi_mode_sense(struct scsi_request *sreq, int dbd, int modepage,
+scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		  unsigned char *buffer, int len, int timeout, int retries,
-		  struct scsi_mode_data *data) {
+		  struct scsi_mode_data *data, char *sense) {
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
+	int result;
+	char *sense_buffer = NULL;
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
 
+	if (!sense) {
+		sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!sense_buffer) {
+			dev_printk(KERN_ERR, &sdev->sdev_gendev, "failed to allocate sense buffer\n");
+			return 0;
+		}
+		sense = sense_buffer;
+	}
  retry:
-	use_10_for_ms = sreq->sr_device->use_10_for_ms;
+	use_10_for_ms = sdev->use_10_for_ms;
 
 	if (use_10_for_ms) {
 		if (len < 8)
@@ -1672,36 +1684,35 @@ __scsi_mode_sense(struct scsi_request *s
 		header_length = 4;
 	}
 
-	sreq->sr_cmd_len = 0;
-	memset(sreq->sr_sense_buffer, 0, sizeof(sreq->sr_sense_buffer));
-	sreq->sr_data_direction = DMA_FROM_DEVICE;
+	memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
 
 	memset(buffer, 0, len);
 
-	scsi_wait_req(sreq, cmd, buffer, len, timeout, retries);
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
+				  sense, timeout, retries);
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
 	 * byte as the problem.  MODE_SENSE commands can return
 	 * ILLEGAL REQUEST if the code page isn't supported */
 
-	if (use_10_for_ms && !scsi_status_is_good(sreq->sr_result) &&
-	    (driver_byte(sreq->sr_result) & DRIVER_SENSE)) {
+	if (use_10_for_ms && !scsi_status_is_good(result) &&
+	    (driver_byte(result) & DRIVER_SENSE)) {
 		struct scsi_sense_hdr sshdr;
 
-		if (scsi_request_normalize_sense(sreq, &sshdr)) {
+		if (scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
 			if ((sshdr.sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr.asc == 0x20) && (sshdr.ascq == 0)) {
 				/* 
 				 * Invalid command operation code
 				 */
-				sreq->sr_device->use_10_for_ms = 0;
+				sdev->use_10_for_ms = 0;
 				goto retry;
 			}
 		}
 	}
 
-	if(scsi_status_is_good(sreq->sr_result)) {
+	if(scsi_status_is_good(result)) {
 		data->header_length = header_length;
 		if(use_10_for_ms) {
 			data->length = buffer[0]*256 + buffer[1] + 2;
@@ -1718,73 +1729,34 @@ __scsi_mode_sense(struct scsi_request *s
 		}
 	}
 
-	return sreq->sr_result;
-}
-EXPORT_SYMBOL(__scsi_mode_sense);
-
-/**
- *	scsi_mode_sense - issue a mode sense, falling back from 10 to 
- *		six bytes if necessary.
- *	@sdev:	scsi device to send command to.
- *	@dbd:	set if mode sense will disable block descriptors in the return
- *	@modepage: mode page being requested
- *	@buffer: request buffer (may not be smaller than eight bytes)
- *	@len:	length of request buffer.
- *	@timeout: command timeout
- *	@retries: number of retries before failing
- *
- *	Returns zero if unsuccessful, or the header offset (either 4
- *	or 8 depending on whether a six or ten byte command was
- *	issued) if successful.
- **/
-int
-scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-		unsigned char *buffer, int len, int timeout, int retries,
-		struct scsi_mode_data *data)
-{
-	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
-	int ret;
-
-	if (!sreq)
-		return -1;
-
-	ret = __scsi_mode_sense(sreq, dbd, modepage, buffer, len,
-				timeout, retries, data);
-
-	scsi_release_request(sreq);
-
-	return ret;
+	kfree(sense_buffer);
+	return result;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
 
 int
 scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries)
 {
-	struct scsi_request *sreq;
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
+	char sense[SCSI_SENSE_BUFFERSIZE];
 	int result;
 	
-	sreq = scsi_allocate_request(sdev, GFP_KERNEL);
-	if (!sreq)
-		return -ENOMEM;
-
-	sreq->sr_data_direction = DMA_NONE;
-	scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
+	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sense,
+				  timeout, retries);
 
-	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) && sdev->removable) {
+	if ((driver_byte(result) & DRIVER_SENSE) && sdev->removable) {
 		struct scsi_sense_hdr sshdr;
 
-		if ((scsi_request_normalize_sense(sreq, &sshdr)) &&
+		if ((scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
+					  &sshdr)) &&
 		    ((sshdr.sense_key == UNIT_ATTENTION) ||
 		     (sshdr.sense_key == NOT_READY))) {
 			sdev->changed = 1;
-			sreq->sr_result = 0;
+			result = 0;
 		}
 	}
-	result = sreq->sr_result;
-	scsi_release_request(sreq);
 	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1302,8 +1302,9 @@ static inline int
 sd_do_mode_sense(struct scsi_request *SRpnt, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data)
 {
-	return __scsi_mode_sense(SRpnt, dbd, modepage, buffer, len,
-				 SD_TIMEOUT, SD_MAX_RETRIES, data);
+	return scsi_mode_sense(SRpnt->sr_device, dbd, modepage, buffer, len,
+			       SD_TIMEOUT, SD_MAX_RETRIES, data,
+			       SRpnt->sr_sense_buffer);
 }
 
 /*
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -817,7 +817,7 @@ static void get_capabilities(struct scsi
 
 	/* ask for mode page 0x2a */
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
-			     SR_TIMEOUT, 3, &data);
+			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (!scsi_status_is_good(rc)) {
 		/* failed, drive doesn't have capabilities mode page */
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,8 +8,15 @@
 
 struct request_queue;
 struct scsi_cmnd;
-struct scsi_mode_data;
 
+struct scsi_mode_data {
+	__u32	length;
+	__u16	block_descriptor_length;
+	__u8	medium_type;
+	__u8	device_specific;
+	__u8	header_length;
+	__u8	longlba:1;
+};
 
 /*
  * sdev state: If you alter this, you also need to alter scsi_sysfs.c
@@ -228,7 +235,8 @@ extern int scsi_set_medium_removal(struc
 
 extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			   unsigned char *buffer, int len, int timeout,
-			   int retries, struct scsi_mode_data *data);
+			   int retries, struct scsi_mode_data *data,
+			   char *sense);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -58,19 +58,4 @@ extern int scsi_execute_req(struct scsi_
 			    int data_direction, void *buffer, unsigned bufflen,
 			    unsigned char *sense, int timeout, int retries);
 
-struct scsi_mode_data {
-	__u32	length;
-	__u16	block_descriptor_length;
-	__u8	medium_type;
-	__u8	device_specific;
-	__u8	header_length;
-	__u8	longlba:1;
-};
-
-extern int __scsi_mode_sense(struct scsi_request *SRpnt, int dbd,
-			     int modepage, unsigned char *buffer, int len,
-			     int timeout, int retries,
-			     struct scsi_mode_data *data);
-
-
 #endif /* _SCSI_SCSI_REQUEST_H */


