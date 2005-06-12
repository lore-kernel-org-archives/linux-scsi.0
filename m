From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] convert sr to scsi_execute_req
Date: Sun, 12 Jun 2005 12:21:29 -0500
Message-ID: <1118596889.4967.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:7899 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262658AbVFLRVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jun 2005 13:21:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This follows almost the identical model to sd, except that there's one
ioctl which returns raw sense data, so it had to use scsi_execute()
instead.

James

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -50,10 +50,10 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
-#include <scsi/scsi_request.h>
 
 #include "scsi_logging.h"
 #include "sr.h"
@@ -658,39 +658,27 @@ static void get_sectorsize(struct scsi_c
 	unsigned char *buffer;
 	int the_result, retries = 3;
 	int sector_size;
-	struct scsi_request *SRpnt = NULL;
 	request_queue_t *queue;
 
 	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		goto Enomem;
-	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
-	if (!SRpnt)
-		goto Enomem;
 
 	do {
 		cmd[0] = READ_CAPACITY;
 		memset((void *) &cmd[1], 0, 9);
-		/* Mark as really busy */
-		SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
-		SRpnt->sr_cmd_len = 0;
-
 		memset(buffer, 0, 8);
 
 		/* Do the command and wait.. */
-		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
-		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
-			      8, SR_TIMEOUT, MAX_RETRIES);
+		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
+					      buffer, 8, NULL, SR_TIMEOUT,
+					      MAX_RETRIES);
 
-		the_result = SRpnt->sr_result;
 		retries--;
 
 	} while (the_result && retries);
 
 
-	scsi_release_request(SRpnt);
-	SRpnt = NULL;
-
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
@@ -750,8 +738,6 @@ Enomem:
 	cd->capacity = 0x1fffff;
 	sector_size = 2048;	/* A guess, just in case */
 	cd->needs_sector_size = 1;
-	if (SRpnt)
-		scsi_release_request(SRpnt);
 	goto out;
 }
 
@@ -759,8 +745,8 @@ static void get_capabilities(struct scsi
 {
 	unsigned char *buffer;
 	struct scsi_mode_data data;
-	struct scsi_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
+	struct scsi_sense_hdr sshdr;
 	unsigned int the_result;
 	int retries, rc, n;
 
@@ -776,19 +762,11 @@ static void get_capabilities(struct scsi
 		""
 	};
 
-	/* allocate a request for the TEST_UNIT_READY */
-	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
-	if (!SRpnt) {
-		printk(KERN_WARNING "(get_capabilities:) Request allocation "
-		       "failure.\n");
-		return;
-	}
 
 	/* allocate transfer buffer */
 	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
 		printk(KERN_ERR "sr: out of memory.\n");
-		scsi_release_request(SRpnt);
 		return;
 	}
 
@@ -800,20 +778,15 @@ static void get_capabilities(struct scsi
 		memset((void *)cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
 
-		SRpnt->sr_cmd_len = 0;
-		SRpnt->sr_sense_buffer[0] = 0;
-		SRpnt->sr_sense_buffer[2] = 0;
-		SRpnt->sr_data_direction = DMA_NONE;
-
-		scsi_wait_req (SRpnt, (void *) cmd, buffer,
-			       0, SR_TIMEOUT, MAX_RETRIES);
+		the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
+					       0, &sshdr, SR_TIMEOUT,
+					       MAX_RETRIES);
 
-		the_result = SRpnt->sr_result;
 		retries++;
 	} while (retries < 5 && 
 		 (!scsi_status_is_good(the_result) ||
-		  ((driver_byte(the_result) & DRIVER_SENSE) &&
-		   SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION)));
+		  (scsi_sense_valid(&sshdr) &&
+		   sshdr.sense_key == UNIT_ATTENTION)));
 
 	/* ask for mode page 0x2a */
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
@@ -825,7 +798,6 @@ static void get_capabilities(struct scsi
 		cd->cdi.mask |= (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
 					 CDC_DVD | CDC_DVD_RAM |
 					 CDC_SELECT_DISC | CDC_SELECT_SPEED);
-		scsi_release_request(SRpnt);
 		kfree(buffer);
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
 		return;
@@ -885,7 +857,6 @@ static void get_capabilities(struct scsi
 		cd->device->writeable = 1;
 	}
 
-	scsi_release_request(SRpnt);
 	kfree(buffer);
 }
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -17,7 +17,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi_request.h>
+#include <scsi/scsi_cmnd.h>
 
 #include "sr.h"
 
@@ -84,41 +84,37 @@ static int sr_fake_playtrkind(struct cdr
 
 int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 {
-	struct scsi_request *SRpnt;
 	struct scsi_device *SDev;
-        struct request *req;
+	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
+	struct request_sense *sense = cgc->sense;
 
 	SDev = cd->device;
-	SRpnt = scsi_allocate_request(SDev, GFP_KERNEL);
-        if (!SRpnt) {
-                printk(KERN_ERR "Unable to allocate SCSI request in sr_do_ioctl");
-		err = -ENOMEM;
-		goto out;
-        }
-	SRpnt->sr_data_direction = cgc->data_direction;
+
+	if (!sense) {
+		sense = kmalloc(sizeof(*sense), GFP_KERNEL);
+		if (!sense) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
 
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
 		err = -ENODEV;
-		goto out_free;
+		goto out;
 	}
 
-	scsi_wait_req(SRpnt, cgc->cmd, cgc->buffer, cgc->buflen,
-		      cgc->timeout, IOCTL_RETRIES);
-
-	req = SRpnt->sr_request;
-	if (SRpnt->sr_buffer && req->buffer && SRpnt->sr_buffer != req->buffer) {
-		memcpy(req->buffer, SRpnt->sr_buffer, SRpnt->sr_bufflen);
-		kfree(SRpnt->sr_buffer);
-		SRpnt->sr_buffer = req->buffer;
-        }
+	memset(sense, 0, sizeof(*sense));
+	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
+			      cgc->buffer, cgc->buflen, (char *)sense,
+			      cgc->timeout, IOCTL_RETRIES, 0);
 
-	result = SRpnt->sr_result;
+	scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
 
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (driver_byte(result) != 0) {
-		switch (SRpnt->sr_sense_buffer[2] & 0xf) {
+		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
 			SDev->changed = 1;
 			if (!cgc->quiet)
@@ -128,8 +124,8 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 			err = -ENOMEDIUM;
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
-			if (SRpnt->sr_sense_buffer[12] == 0x04 &&
-			    SRpnt->sr_sense_buffer[13] == 0x01) {
+			if (sshdr.asc == 0x04 &&
+			    sshdr.ascq == 0x01) {
 				/* sense: Logical unit is in process of becoming ready */
 				if (!cgc->quiet)
 					printk(KERN_INFO "%s: CDROM not ready yet.\n", cd->cdi.name);
@@ -146,37 +142,33 @@ int sr_do_ioctl(Scsi_CD *cd, struct pack
 			if (!cgc->quiet)
 				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
 #ifdef DEBUG
-			scsi_print_req_sense("sr", SRpnt);
+			scsi_print_sense_hdr("sr", &sshdr);
 #endif
 			err = -ENOMEDIUM;
 			break;
 		case ILLEGAL_REQUEST:
 			err = -EIO;
-			if (SRpnt->sr_sense_buffer[12] == 0x20 &&
-			    SRpnt->sr_sense_buffer[13] == 0x00)
+			if (sshdr.asc == 0x20 &&
+			    sshdr.ascq == 0x00)
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
 			__scsi_print_command(cgc->cmd);
-			scsi_print_req_sense("sr", SRpnt);
+			scsi_print_sense_hdr("sr", &sshdr);
 #endif
 			break;
 		default:
 			printk(KERN_ERR "%s: CDROM (ioctl) error, command: ", cd->cdi.name);
 			__scsi_print_command(cgc->cmd);
-			scsi_print_req_sense("sr", SRpnt);
+			scsi_print_sense_hdr("sr", &sshdr);
 			err = -EIO;
 		}
 	}
 
-	if (cgc->sense)
-		memcpy(cgc->sense, SRpnt->sr_sense_buffer, sizeof(*cgc->sense));
-
 	/* Wake up a process waiting for device */
-      out_free:
-	scsi_release_request(SRpnt);
-	SRpnt = NULL;
       out:
+	if (!cgc->sense)
+		kfree(sense);
 	cgc->stat = err;
 	return err;
 }


