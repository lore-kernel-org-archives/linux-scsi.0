From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert SPI transport class to scsi_execute
Date: Sat, 11 Jun 2005 11:39:57 -0500
Message-ID: <1118507997.4924.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:43201 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261731AbVFKQkJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 12:40:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This one's slightly more difficult.  The transport class uses
REQ_FAILFAST, so another interface (scsi_execute) had to be invented to
take the extra flag.  Also, the sense functions are shifted around to
allow spi_execute to place data directly into a struct scsi_sense_hdr.
With this change, there's probably a lot of unnecessary sense buffer
allocation going on which we can fix later.

James

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1909,12 +1909,16 @@ EXPORT_SYMBOL(scsi_reset_provider);
 int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
                          struct scsi_sense_hdr *sshdr)
 {
-	if (!sense_buffer || !sb_len || (sense_buffer[0] & 0x70) != 0x70)
+	if (!sense_buffer || !sb_len)
 		return 0;
 
 	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
 
 	sshdr->response_code = (sense_buffer[0] & 0x7f);
+
+	if (!scsi_sense_valid(sshdr))
+		return 0;
+
 	if (sshdr->response_code >= 0x72) {
 		/*
 		 * descriptor format
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -285,7 +285,7 @@ void scsi_wait_req(struct scsi_request *
 EXPORT_SYMBOL(scsi_wait_req);
 
 /**
- * scsi_execute_req - insert request and wait for the result
+ * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @data_direction: data direction
@@ -294,13 +294,14 @@ EXPORT_SYMBOL(scsi_wait_req);
  * @sense:	optional sense buffer
  * @timeout:	request timeout in seconds
  * @retries:	number of times to retry request
+ * @flags:	or into request flags;
  *
  * scsi_execute_req returns the req->errors value which is the
  * the scsi_cmnd result field.
  **/
-int scsi_execute_req(struct scsi_device *sdev, unsigned char *cmd,
-		     int data_direction, void *buffer, unsigned bufflen,
-		     unsigned char *sense, int timeout, int retries)
+int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+		 int data_direction, void *buffer, unsigned bufflen,
+		 unsigned char *sense, int timeout, int retries, int flags)
 {
 	struct request *req;
 	int ret;
@@ -326,7 +327,7 @@ int scsi_execute_req(struct scsi_device 
 	req->sense = sense;
 	req->sense_len = 0;
 	req->timeout = timeout;
-	req->flags |= REQ_BLOCK_PC | REQ_SPECIAL;
+	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -339,7 +340,7 @@ int scsi_execute_req(struct scsi_device 
 	return ret;
 }
 
-EXPORT_SYMBOL(scsi_execute_req);
+EXPORT_SYMBOL(scsi_execute);
 
 /*
  * Function:    scsi_init_cmd_errh()
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -28,7 +28,7 @@
 #include "scsi_priv.h"
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_request.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
@@ -108,25 +108,33 @@ static int sprint_frac(char *dest, int v
 
 /* Modification of scsi_wait_req that will clear UNIT ATTENTION conditions
  * resulting from (likely) bus and device resets */
-static void spi_wait_req(struct scsi_request *sreq, const void *cmd,
-			 void *buffer, unsigned bufflen)
+static int spi_execute(struct scsi_device *sdev, const void *cmd,
+		       enum dma_data_direction dir,
+		       void *buffer, unsigned bufflen,
+		       struct scsi_sense_hdr *sshdr)
 {
-	int i;
+	int i, result;
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 
 	for(i = 0; i < DV_RETRIES; i++) {
-		sreq->sr_request->flags |= REQ_FAILFAST;
-
-		scsi_wait_req(sreq, cmd, buffer, bufflen,
-			      DV_TIMEOUT, /* retries */ 1);
-		if (sreq->sr_result & DRIVER_SENSE) {
-			struct scsi_sense_hdr sshdr;
 
-			if (scsi_request_normalize_sense(sreq, &sshdr)
-			    && sshdr.sense_key == UNIT_ATTENTION)
+		/* FIXME: need to set REQ_FAILFAST */
+		result = scsi_execute(sdev, cmd, dir, buffer, bufflen,
+				      sense, DV_TIMEOUT, /* retries */ 1,
+				      REQ_FAILFAST);
+		if (result & DRIVER_SENSE) {
+			struct scsi_sense_hdr sshdr_tmp;
+			if (!sshdr)
+				sshdr = &sshdr_tmp;
+
+			if (scsi_normalize_sense(sense, sizeof(*sense),
+						 sshdr)
+			    && sshdr->sense_key == UNIT_ATTENTION)
 				continue;
 		}
 		break;
 	}
+	return result;
 }
 
 static struct {
@@ -535,13 +543,13 @@ enum spi_compare_returns {
 /* This is for read/write Domain Validation:  If the device supports
  * an echo buffer, we do read/write tests to it */
 static enum spi_compare_returns
-spi_dv_device_echo_buffer(struct scsi_request *sreq, u8 *buffer,
+spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 			  u8 *ptr, const int retries)
 {
-	struct scsi_device *sdev = sreq->sr_device;
 	int len = ptr - buffer;
-	int j, k, r;
+	int j, k, r, result;
 	unsigned int pattern = 0x0000ffff;
+	struct scsi_sense_hdr sshdr;
 
 	const char spi_write_buffer[] = {
 		WRITE_BUFFER, 0x0a, 0, 0, 0, 0, 0, len >> 8, len & 0xff, 0
@@ -586,14 +594,12 @@ spi_dv_device_echo_buffer(struct scsi_re
 	}
 
 	for (r = 0; r < retries; r++) {
-		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
-		sreq->sr_data_direction = DMA_TO_DEVICE;
-		spi_wait_req(sreq, spi_write_buffer, buffer, len);
-		if(sreq->sr_result || !scsi_device_online(sdev)) {
-			struct scsi_sense_hdr sshdr;
+		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
+				     buffer, len, &sshdr);
+		if(result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_request_normalize_sense(sreq, &sshdr)
+			if (scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
@@ -605,14 +611,13 @@ spi_dv_device_echo_buffer(struct scsi_re
 				return SPI_COMPARE_SKIP_TEST;
 
 
-			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Write Buffer failure %x\n", sreq->sr_result);
+			SPI_PRINTK(sdev->sdev_target, KERN_ERR, "Write Buffer failure %x\n", result);
 			return SPI_COMPARE_FAILURE;
 		}
 
 		memset(ptr, 0, len);
-		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
-		sreq->sr_data_direction = DMA_FROM_DEVICE;
-		spi_wait_req(sreq, spi_read_buffer, ptr, len);
+		spi_execute(sdev, spi_read_buffer, DMA_FROM_DEVICE,
+			    ptr, len, NULL);
 		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
 		if (memcmp(buffer, ptr, len) != 0)
@@ -624,25 +629,22 @@ spi_dv_device_echo_buffer(struct scsi_re
 /* This is for the simplest form of Domain Validation: a read test
  * on the inquiry data from the device */
 static enum spi_compare_returns
-spi_dv_device_compare_inquiry(struct scsi_request *sreq, u8 *buffer,
+spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 			      u8 *ptr, const int retries)
 {
-	int r;
-	const int len = sreq->sr_device->inquiry_len;
-	struct scsi_device *sdev = sreq->sr_device;
+	int r, result;
+	const int len = sdev->inquiry_len;
 	const char spi_inquiry[] = {
 		INQUIRY, 0, 0, 0, len, 0
 	};
 
 	for (r = 0; r < retries; r++) {
-		sreq->sr_cmd_len = 0;	/* wait_req to fill in */
-		sreq->sr_data_direction = DMA_FROM_DEVICE;
-
 		memset(ptr, 0, len);
 
-		spi_wait_req(sreq, spi_inquiry, ptr, len);
+		result = spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
+				     ptr, len, NULL);
 		
-		if(sreq->sr_result || !scsi_device_online(sdev)) {
+		if(result || !scsi_device_online(sdev)) {
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
 			return SPI_COMPARE_FAILURE;
 		}
@@ -663,12 +665,11 @@ spi_dv_device_compare_inquiry(struct scs
 }
 
 static enum spi_compare_returns
-spi_dv_retrain(struct scsi_request *sreq, u8 *buffer, u8 *ptr,
+spi_dv_retrain(struct scsi_device *sdev, u8 *buffer, u8 *ptr,
 	       enum spi_compare_returns 
-	       (*compare_fn)(struct scsi_request *, u8 *, u8 *, int))
+	       (*compare_fn)(struct scsi_device *, u8 *, u8 *, int))
 {
-	struct spi_internal *i = to_spi_internal(sreq->sr_host->transportt);
-	struct scsi_device *sdev = sreq->sr_device;
+	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 	struct scsi_target *starget = sdev->sdev_target;
 	int period = 0, prevperiod = 0; 
 	enum spi_compare_returns retval;
@@ -676,7 +677,7 @@ spi_dv_retrain(struct scsi_request *sreq
 
 	for (;;) {
 		int newperiod;
-		retval = compare_fn(sreq, buffer, ptr, DV_LOOPS);
+		retval = compare_fn(sdev, buffer, ptr, DV_LOOPS);
 
 		if (retval == SPI_COMPARE_SUCCESS
 		    || retval == SPI_COMPARE_SKIP_TEST)
@@ -722,9 +723,9 @@ spi_dv_retrain(struct scsi_request *sreq
 }
 
 static int
-spi_dv_device_get_echo_buffer(struct scsi_request *sreq, u8 *buffer)
+spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 {
-	int l;
+	int l, result;
 
 	/* first off do a test unit ready.  This can error out 
 	 * because of reservations or some other reason.  If it
@@ -740,18 +741,16 @@ spi_dv_device_get_echo_buffer(struct scs
 	};
 
 	
-	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = DMA_NONE;
-
 	/* We send a set of three TURs to clear any outstanding 
 	 * unit attention conditions if they exist (Otherwise the
 	 * buffer tests won't be happy).  If the TUR still fails
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		spi_wait_req(sreq, spi_test_unit_ready, NULL, 0);
+		result = spi_execute(sdev, spi_test_unit_ready, DMA_NONE, 
+				     NULL, 0, NULL);
 
-		if(sreq->sr_result) {
+		if(result) {
 			if(l >= 3)
 				return 0;
 		} else {
@@ -760,12 +759,10 @@ spi_dv_device_get_echo_buffer(struct scs
 		}
 	}
 
-	sreq->sr_cmd_len = 0;
-	sreq->sr_data_direction = DMA_FROM_DEVICE;
+	result = spi_execute(sdev, spi_read_buffer_descriptor, 
+			     DMA_FROM_DEVICE, buffer, 4, NULL);
 
-	spi_wait_req(sreq, spi_read_buffer_descriptor, buffer, 4);
-
-	if (sreq->sr_result)
+	if (result)
 		/* Device has no echo buffer */
 		return 0;
 
@@ -773,17 +770,16 @@ spi_dv_device_get_echo_buffer(struct scs
 }
 
 static void
-spi_dv_device_internal(struct scsi_request *sreq, u8 *buffer)
+spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 {
-	struct spi_internal *i = to_spi_internal(sreq->sr_host->transportt);
-	struct scsi_device *sdev = sreq->sr_device;
+	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 	struct scsi_target *starget = sdev->sdev_target;
 	int len = sdev->inquiry_len;
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
 	DV_SET(width, 0);
 	
-	if (spi_dv_device_compare_inquiry(sreq, buffer, buffer, DV_LOOPS)
+	if (spi_dv_device_compare_inquiry(sdev, buffer, buffer, DV_LOOPS)
 	    != SPI_COMPARE_SUCCESS) {
 		SPI_PRINTK(starget, KERN_ERR, "Domain Validation Initial Inquiry Failed\n");
 		/* FIXME: should probably offline the device here? */
@@ -794,7 +790,7 @@ spi_dv_device_internal(struct scsi_reque
 	if (i->f->set_width && spi_max_width(starget) && sdev->wdtr) {
 		i->f->set_width(starget, 1);
 
-		if (spi_dv_device_compare_inquiry(sreq, buffer,
+		if (spi_dv_device_compare_inquiry(sdev, buffer,
 						   buffer + len,
 						   DV_LOOPS)
 		    != SPI_COMPARE_SUCCESS) {
@@ -815,7 +811,7 @@ spi_dv_device_internal(struct scsi_reque
 
 	len = 0;
 	if (sdev->ppr)
-		len = spi_dv_device_get_echo_buffer(sreq, buffer);
+		len = spi_dv_device_get_echo_buffer(sdev, buffer);
 
  retry:
 
@@ -839,7 +835,7 @@ spi_dv_device_internal(struct scsi_reque
 
 	if (len == 0) {
 		SPI_PRINTK(starget, KERN_INFO, "Domain Validation skipping write tests\n");
-		spi_dv_retrain(sreq, buffer, buffer + len,
+		spi_dv_retrain(sdev, buffer, buffer + len,
 			       spi_dv_device_compare_inquiry);
 		return;
 	}
@@ -849,7 +845,7 @@ spi_dv_device_internal(struct scsi_reque
 		len = SPI_MAX_ECHO_BUFFER_SIZE;
 	}
 
-	if (spi_dv_retrain(sreq, buffer, buffer + len,
+	if (spi_dv_retrain(sdev, buffer, buffer + len,
 			   spi_dv_device_echo_buffer)
 	    == SPI_COMPARE_SKIP_TEST) {
 		/* OK, the stupid drive can't do a write echo buffer
@@ -872,16 +868,12 @@ spi_dv_device_internal(struct scsi_reque
 void
 spi_dv_device(struct scsi_device *sdev)
 {
-	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
 	struct scsi_target *starget = sdev->sdev_target;
 	u8 *buffer;
 	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
 
-	if (unlikely(!sreq))
-		return;
-
 	if (unlikely(scsi_device_get(sdev)))
-		goto out_free_req;
+		return;
 
 	buffer = kmalloc(len, GFP_KERNEL);
 
@@ -902,7 +894,7 @@ spi_dv_device(struct scsi_device *sdev)
 
 	SPI_PRINTK(starget, KERN_INFO, "Beginning Domain Validation\n");
 
-	spi_dv_device_internal(sreq, buffer);
+	spi_dv_device_internal(sdev, buffer);
 
 	SPI_PRINTK(starget, KERN_INFO, "Ending Domain Validation\n");
 
@@ -917,8 +909,6 @@ spi_dv_device(struct scsi_device *sdev)
 	kfree(buffer);
  out_put:
 	scsi_device_put(sdev);
- out_free_req:
-	scsi_release_request(sreq);
 }
 EXPORT_SYMBOL(spi_dv_device);
 
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -254,6 +254,19 @@ extern void scsi_remove_target(struct de
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
+extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+			int data_direction, void *buffer, unsigned bufflen,
+			unsigned char *sense, int timeout, int retries,
+			int flag);
+
+static inline int
+scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
+		 int data_direction, void *buffer, unsigned bufflen,
+		 unsigned char *sense, int timeout, int retries)
+{
+	return scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,
+			    timeout, retries, 0);
+}
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -26,6 +26,14 @@ struct scsi_sense_hdr {		/* See SPC-3 se
 	u8 additional_length;	/* always 0 for fixed sense format */
 };
 
+static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
+{
+	if (!sshdr)
+		return 0;
+
+	return (sshdr->response_code & 0x70) == 0x70;
+}
+
 
 extern void scsi_add_timer(struct scsi_cmnd *, int,
 		void (*)(struct scsi_cmnd *));
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -54,8 +54,4 @@ extern void scsi_do_req(struct scsi_requ
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
-extern int scsi_execute_req(struct scsi_device *sdev, unsigned char *cmd,
-			    int data_direction, void *buffer, unsigned bufflen,
-			    unsigned char *sense, int timeout, int retries);
-
 #endif /* _SCSI_SCSI_REQUEST_H */


