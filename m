From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sd descriptor sense support 2.6.11-rc2
Date: Sun, 23 Jan 2005 20:17:05 +1000
Message-ID: <41F379A1.8080700@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080300030300030003050507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:19619 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261284AbVAWKRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2005 05:17:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------080300030300030003050507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch builds on the 2 patches in the
"streamline block SG_IO error processing" thread.

It allows the sd driver to handle either fixed or
descriptor format sense data. A side effect of this
is that 64 bit medium/hardware error lbas can now be
conveyed back to the block layer.

Several sd patches are "in flight" at the moment so
two diffs are attached. The first patch is incremental
on the previous sd patch that I published (in the
"streamline block SG_IO" thread) and the second is against
lk 2.6.11-rc2. Both patches take into account the
small change to sd between lk 2.6.11-rc1 and -rc2.
[Only one of these patches should be applied.]

Changelog:
   - make all sd driver sense data handling able to use
     both fixed and descriptor format
   - permit 64 bit lbas associated with medium (or
     hardware) errors to be conveyed back to the block
     layer

Doug Gilbert

--------------080300030300030003050507
Content-Type: text/x-patch;
 name="sd2611rc1bk1med.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd2611rc1bk1med.diff"

--- linux/drivers/scsi/sd.c	2005-01-14 19:50:15.000000000 +1000
+++ linux/drivers/scsi/sd.c2611rc2med2	2005-01-23 10:44:44.000000000 +1000
@@ -106,7 +106,7 @@
 };
 
 static DEFINE_IDR(sd_index_idr);
-static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sd_index_lock);
 
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
@@ -761,15 +761,26 @@
 	int this_count = SCpnt->bufflen;
 	int good_bytes = (result == 0 ? this_count : 0);
 	sector_t block_sectors = 1;
+	u64 first_err_block;
 	sector_t error_sector;
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
+	int sense_deferred = 0;
+	int info_valid;
+
+	if (result) {
+		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
+		if (sense_valid)
+			sense_deferred = scsi_sense_is_deferred(&sshdr);
+	}
+
 #ifdef CONFIG_SCSI_LOGGING
 	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
 				SCpnt->request->rq_disk->disk_name, result));
-	if (0 != result) {
-		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[0,2,asc,ascq]"
-				"=%x,%x,%x,%x\n", SCpnt->sense_buffer[0],
-			SCpnt->sense_buffer[2], SCpnt->sense_buffer[12],
-			SCpnt->sense_buffer[13]));
+	if (sense_valid) {
+		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[respc,sk,asc,"
+				"ascq]=%x,%x,%x,%x\n", sshdr.response_code,
+				sshdr.sense_key, sshdr.asc, sshdr.ascq));
 	}
 #endif
 	/*
@@ -786,17 +797,19 @@
 	if (blk_pc_request(SCpnt->request))
 		good_bytes = this_count;
 	else if (driver_byte(result) != 0 &&
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) {
-		switch (SCpnt->sense_buffer[2]) {
+		 sense_valid && !sense_deferred) {
+		switch (sshdr.sense_key) {
 		case MEDIUM_ERROR:
-			if (!(SCpnt->sense_buffer[0] & 0x80))
-				break;
 			if (!blk_fs_request(SCpnt->request))
 				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-			(SCpnt->sense_buffer[4] << 16) |
-			(SCpnt->sense_buffer[5] << 8) |
-			SCpnt->sense_buffer[6];
+			info_valid = scsi_get_sense_info_fld(
+				SCpnt->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				&first_err_block);
+			/*
+			 * May want to warn and skip if following cast results
+			 * in actual truncation (if sector_t < 64 bits)
+			 */
+			error_sector = (sector_t)first_err_block;
 			if (SCpnt->request->bio != NULL)
 				block_sectors = bio_sectors(SCpnt->request->bio);
 			switch (SCpnt->device->sector_size) {
@@ -836,7 +849,7 @@
 			 */
 			scsi_print_sense("sd", SCpnt);
 			SCpnt->result = 0;
-			SCpnt->sense_buffer[0] = 0x0;
+			memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 			good_bytes = this_count;
 			break;
 
@@ -865,16 +878,20 @@
 
 static int media_not_present(struct scsi_disk *sdkp, struct scsi_request *srp)
 {
+	struct scsi_sense_hdr sshdr;
+
 	if (!srp->sr_result)
 		return 0;
 	if (!(driver_byte(srp->sr_result) & DRIVER_SENSE))
 		return 0;
-	if (srp->sr_sense_buffer[2] != NOT_READY &&
-	    srp->sr_sense_buffer[2] != UNIT_ATTENTION)
-	    	return 0;
-	if (srp->sr_sense_buffer[12] != 0x3A) /* medium not present */
-		return 0;
-
+	/* not invoked for commands that could return deferred errors */
+	if (scsi_request_normalize_sense(srp, &sshdr)) {
+		if (sshdr.sense_key != NOT_READY &&
+		    sshdr.sense_key != UNIT_ATTENTION)
+			return 0;
+		if (sshdr.asc != 0x3A) /* medium not present */
+			return 0;
+	}
 	set_media_not_present(sdkp);
 	return 1;
 }
@@ -889,6 +906,8 @@
 	unsigned long spintime_value = 0;
 	int retries, spintime;
 	unsigned int the_result;
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
 
 	spintime = 0;
 
@@ -902,19 +921,22 @@
 			memset((void *) &cmd[1], 0, 9);
 
 			SRpnt->sr_cmd_len = 0;
-			SRpnt->sr_sense_buffer[0] = 0;
-			SRpnt->sr_sense_buffer[2] = 0;
+			memset(SRpnt->sr_sense_buffer, 0,
+			       SCSI_SENSE_BUFFERSIZE);
 			SRpnt->sr_data_direction = DMA_NONE;
 
 			scsi_wait_req (SRpnt, (void *) cmd, (void *) buffer,
 				       0/*512*/, SD_TIMEOUT, SD_MAX_RETRIES);
 
 			the_result = SRpnt->sr_result;
+			if (the_result)
+				sense_valid = scsi_request_normalize_sense(
+							SRpnt, &sshdr);
 			retries++;
 		} while (retries < 3 && 
 			 (!scsi_status_is_good(the_result) ||
 			  ((driver_byte(the_result) & DRIVER_SENSE) &&
-			   SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION)));
+			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
 		/*
 		 * If the drive has indicated to us that it doesn't have
@@ -928,7 +950,8 @@
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result))
-				printk(KERN_NOTICE "%s: Unit Not Ready, error = 0x%x\n", diskname, the_result);
+				printk(KERN_NOTICE "%s: Unit Not Ready, "
+				       "error = 0x%x\n", diskname, the_result);
 			break;
 		}
 					
@@ -943,15 +966,15 @@
 		 * If manual intervention is required, or this is an
 		 * absent USB storage device, a spinup is meaningless.
 		 */
-		if (SRpnt->sr_sense_buffer[2] == NOT_READY &&
-		    SRpnt->sr_sense_buffer[12] == 4 /* not ready */ &&
-		    SRpnt->sr_sense_buffer[13] == 3) {
+		if (sense_valid &&
+		    sshdr.sense_key == NOT_READY &&
+		    sshdr.asc == 4 && sshdr.ascq == 3) {
 			break;		/* manual intervention required */
 
 		/*
 		 * Issue command to spin up drive when not ready
 		 */
-		} else if (SRpnt->sr_sense_buffer[2] == NOT_READY) {
+		} else if (sense_valid && sshdr.sense_key == NOT_READY) {
 			if (!spintime) {
 				printk(KERN_NOTICE "%s: Spinning up disk...",
 				       diskname);
@@ -960,8 +983,8 @@
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
 				SRpnt->sr_cmd_len = 0;
-				SRpnt->sr_sense_buffer[0] = 0;
-				SRpnt->sr_sense_buffer[2] = 0;
+				memset(SRpnt->sr_sense_buffer, 0,
+					SCSI_SENSE_BUFFERSIZE);
 
 				SRpnt->sr_data_direction = DMA_NONE;
 				scsi_wait_req(SRpnt, (void *)cmd, 
@@ -977,7 +1000,8 @@
 			/* we don't understand the sense code, so it's
 			 * probably pointless to loop */
 			if(!spintime) {
-				printk(KERN_NOTICE "%s: Unit Not Ready, sense:\n", diskname);
+				printk(KERN_NOTICE "%s: Unit Not Ready, "
+					"sense:\n", diskname);
 				scsi_print_req_sense("", SRpnt);
 			}
 			break;
@@ -1005,6 +1029,8 @@
 	int the_result, retries;
 	int sector_size = 0;
 	int longrc = 0;
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
 
 repeat:
 	retries = 3;
@@ -1022,8 +1048,7 @@
 		}
 		
 		SRpnt->sr_cmd_len = 0;
-		SRpnt->sr_sense_buffer[0] = 0;
-		SRpnt->sr_sense_buffer[2] = 0;
+		memset(SRpnt->sr_sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
 
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
@@ -1033,6 +1058,9 @@
 			return;
 
 		the_result = SRpnt->sr_result;
+		if (the_result)
+			sense_valid = scsi_request_normalize_sense(SRpnt,
+								   &sshdr);
 		retries--;
 
 	} while (the_result && retries);
@@ -1054,7 +1082,7 @@
 		/* Set dirty bit for removable devices if not ready -
 		 * sometimes drives will not report this properly. */
 		if (sdp->removable &&
-		    SRpnt->sr_sense_buffer[2] == NOT_READY)
+		    sense_valid && sshdr.sense_key == NOT_READY)
 			sdp->changed = 1;
 
 		/* Either no media are present but the drive didn't tell us,
@@ -1262,6 +1290,7 @@
 	const int dbd = 0;	   /* DBD */
 	const int modepage = 0x08; /* current values, cache page */
 	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
 
 	if (sdkp->device->skip_ms_page_8)
 		goto defaults;
@@ -1311,17 +1340,14 @@
 	}
 
 bad_sense:
-	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
-	     && (SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST
-	     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
-	     && SRpnt->sr_sense_buffer[12] == 0x24
-	     && SRpnt->sr_sense_buffer[13] == 0x00) {
+	if (scsi_request_normalize_sense(SRpnt, &sshdr) &&
+	    sshdr.sense_key == ILLEGAL_REQUEST &&
+	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		printk(KERN_NOTICE "%s: cache data unavailable\n",
-		       diskname);
-	} else {
+		       diskname);	/* Invalid field in CDB */
+	else
 		printk(KERN_ERR "%s: asking for cache data failed\n",
 		       diskname);
-	}
 
 defaults:
 	printk(KERN_ERR "%s: assuming drive cache: write through\n",

--------------080300030300030003050507
Content-Type: text/x-patch;
 name="sd2611rc2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd2611rc2.diff"

--- linux/drivers/scsi/sd.c	2005-01-23 10:01:07.000000000 +1000
+++ linux/drivers/scsi/sd.c2611rc2med2	2005-01-23 10:44:44.000000000 +1000
@@ -87,6 +87,7 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
+#define SD_PASSTHROUGH_RETRIES	1
 
 static void scsi_disk_release(struct kref *kref);
 
@@ -217,15 +218,14 @@
 	struct gendisk *disk;
 	sector_t block;
 	struct scsi_device *sdp = SCpnt->device;
+	struct request *rq = SCpnt->request;
 
 	timeout = sdp->timeout;
 
 	/*
-	 * these are already setup, just copy cdb basically
+	 * SG_IO from block layer already setup, just copy cdb basically
 	 */
-	if (SCpnt->request->flags & REQ_BLOCK_PC) {
-		struct request *rq = SCpnt->request;
-
+	if (blk_pc_request(rq)) {
 		if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
 			return 0;
 
@@ -242,26 +242,28 @@
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
+		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
 		goto queue;
 	}
 
 	/*
 	 * we only do REQ_CMD and REQ_BLOCK_PC
 	 */
-	if (!(SCpnt->request->flags & REQ_CMD))
+	if (! blk_fs_request(rq))
 		return 0;
 
-	disk = SCpnt->request->rq_disk;
-	block = SCpnt->request->sector;
+	disk = rq->rq_disk;
+	block = rq->sector;
 	this_count = SCpnt->request_bufflen >> 9;
 
 	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
-			    "count=%d\n", disk->disk_name, (unsigned long long)block, this_count));
+			    "count=%d\n", disk->disk_name,
+			 (unsigned long long)block, this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
- 	    block + SCpnt->request->nr_sectors > get_capacity(disk)) {
+ 	    block + rq->nr_sectors > get_capacity(disk)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
-				 SCpnt->request->nr_sectors));
+				 rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
@@ -289,7 +291,7 @@
 	 * for this.
 	 */
 	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (SCpnt->request->nr_sectors & 1)) {
+		if ((block & 1) || (rq->nr_sectors & 1)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -298,7 +300,7 @@
 		}
 	}
 	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (SCpnt->request->nr_sectors & 3)) {
+		if ((block & 3) || (rq->nr_sectors & 3)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -307,7 +309,7 @@
 		}
 	}
 	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (SCpnt->request->nr_sectors & 7)) {
+		if ((block & 7) || (rq->nr_sectors & 7)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -315,25 +317,24 @@
 			this_count = this_count >> 3;
 		}
 	}
-	if (rq_data_dir(SCpnt->request) == WRITE) {
+	if (rq_data_dir(rq) == WRITE) {
 		if (!sdp->writeable) {
 			return 0;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	} else if (rq_data_dir(SCpnt->request) == READ) {
+	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		printk(KERN_ERR "sd: Unknown command %lx\n", 
-		       SCpnt->request->flags);
-/* overkill 	panic("Unknown sd command %lx\n", SCpnt->request->flags); */
+		printk(KERN_ERR "sd: Unknown command %lx\n", rq->flags);
+/* overkill 	panic("Unknown sd command %lx\n", rq->flags); */
 		return 0;
 	}
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
-		disk->disk_name, (rq_data_dir(SCpnt->request) == WRITE) ? 
-		"writing" : "reading", this_count, SCpnt->request->nr_sectors));
+		disk->disk_name, (rq_data_dir(rq) == WRITE) ? 
+		"writing" : "reading", this_count, rq->nr_sectors));
 
 	SCpnt->cmnd[1] = 0;
 	
@@ -385,9 +386,9 @@
 	 */
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
+	SCpnt->allowed = SD_MAX_RETRIES;
 
 queue:
-	SCpnt->allowed = SD_MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
 
 	/*
@@ -760,15 +761,26 @@
 	int this_count = SCpnt->bufflen;
 	int good_bytes = (result == 0 ? this_count : 0);
 	sector_t block_sectors = 1;
+	u64 first_err_block;
 	sector_t error_sector;
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
+	int sense_deferred = 0;
+	int info_valid;
+
+	if (result) {
+		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
+		if (sense_valid)
+			sense_deferred = scsi_sense_is_deferred(&sshdr);
+	}
+
 #ifdef CONFIG_SCSI_LOGGING
 	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
 				SCpnt->request->rq_disk->disk_name, result));
-	if (0 != result) {
-		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[0,2,asc,ascq]"
-				"=%x,%x,%x,%x\n", SCpnt->sense_buffer[0],
-			SCpnt->sense_buffer[2], SCpnt->sense_buffer[12],
-			SCpnt->sense_buffer[13]));
+	if (sense_valid) {
+		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[respc,sk,asc,"
+				"ascq]=%x,%x,%x,%x\n", sshdr.response_code,
+				sshdr.sense_key, sshdr.asc, sshdr.ascq));
 	}
 #endif
 	/*
@@ -777,19 +789,27 @@
 	   unnecessary additional work such as memcpy's that could be avoided.
 	 */
 
-	/* An error occurred */
-	if (driver_byte(result) != 0 && 	/* An error occurred */
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
-		switch (SCpnt->sense_buffer[2]) {
+	/* 
+	 * If SG_IO from block layer then set good_bytes to stop retries;
+	 * else if errors, check them, and if necessary prepare for
+	 * (partial) retries.
+	 */
+	if (blk_pc_request(SCpnt->request))
+		good_bytes = this_count;
+	else if (driver_byte(result) != 0 &&
+		 sense_valid && !sense_deferred) {
+		switch (sshdr.sense_key) {
 		case MEDIUM_ERROR:
-			if (!(SCpnt->sense_buffer[0] & 0x80))
-				break;
 			if (!blk_fs_request(SCpnt->request))
 				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-			(SCpnt->sense_buffer[4] << 16) |
-			(SCpnt->sense_buffer[5] << 8) |
-			SCpnt->sense_buffer[6];
+			info_valid = scsi_get_sense_info_fld(
+				SCpnt->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+				&first_err_block);
+			/*
+			 * May want to warn and skip if following cast results
+			 * in actual truncation (if sector_t < 64 bits)
+			 */
+			error_sector = (sector_t)first_err_block;
 			if (SCpnt->request->bio != NULL)
 				block_sectors = bio_sectors(SCpnt->request->bio);
 			switch (SCpnt->device->sector_size) {
@@ -829,7 +849,7 @@
 			 */
 			scsi_print_sense("sd", SCpnt);
 			SCpnt->result = 0;
-			SCpnt->sense_buffer[0] = 0x0;
+			memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 			good_bytes = this_count;
 			break;
 
@@ -858,16 +878,20 @@
 
 static int media_not_present(struct scsi_disk *sdkp, struct scsi_request *srp)
 {
+	struct scsi_sense_hdr sshdr;
+
 	if (!srp->sr_result)
 		return 0;
 	if (!(driver_byte(srp->sr_result) & DRIVER_SENSE))
 		return 0;
-	if (srp->sr_sense_buffer[2] != NOT_READY &&
-	    srp->sr_sense_buffer[2] != UNIT_ATTENTION)
-	    	return 0;
-	if (srp->sr_sense_buffer[12] != 0x3A) /* medium not present */
-		return 0;
-
+	/* not invoked for commands that could return deferred errors */
+	if (scsi_request_normalize_sense(srp, &sshdr)) {
+		if (sshdr.sense_key != NOT_READY &&
+		    sshdr.sense_key != UNIT_ATTENTION)
+			return 0;
+		if (sshdr.asc != 0x3A) /* medium not present */
+			return 0;
+	}
 	set_media_not_present(sdkp);
 	return 1;
 }
@@ -882,6 +906,8 @@
 	unsigned long spintime_value = 0;
 	int retries, spintime;
 	unsigned int the_result;
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
 
 	spintime = 0;
 
@@ -895,19 +921,22 @@
 			memset((void *) &cmd[1], 0, 9);
 
 			SRpnt->sr_cmd_len = 0;
-			SRpnt->sr_sense_buffer[0] = 0;
-			SRpnt->sr_sense_buffer[2] = 0;
+			memset(SRpnt->sr_sense_buffer, 0,
+			       SCSI_SENSE_BUFFERSIZE);
 			SRpnt->sr_data_direction = DMA_NONE;
 
 			scsi_wait_req (SRpnt, (void *) cmd, (void *) buffer,
 				       0/*512*/, SD_TIMEOUT, SD_MAX_RETRIES);
 
 			the_result = SRpnt->sr_result;
+			if (the_result)
+				sense_valid = scsi_request_normalize_sense(
+							SRpnt, &sshdr);
 			retries++;
 		} while (retries < 3 && 
 			 (!scsi_status_is_good(the_result) ||
 			  ((driver_byte(the_result) & DRIVER_SENSE) &&
-			   SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION)));
+			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
 
 		/*
 		 * If the drive has indicated to us that it doesn't have
@@ -921,7 +950,8 @@
 			/* no sense, TUR either succeeded or failed
 			 * with a status error */
 			if(!spintime && !scsi_status_is_good(the_result))
-				printk(KERN_NOTICE "%s: Unit Not Ready, error = 0x%x\n", diskname, the_result);
+				printk(KERN_NOTICE "%s: Unit Not Ready, "
+				       "error = 0x%x\n", diskname, the_result);
 			break;
 		}
 					
@@ -936,15 +966,15 @@
 		 * If manual intervention is required, or this is an
 		 * absent USB storage device, a spinup is meaningless.
 		 */
-		if (SRpnt->sr_sense_buffer[2] == NOT_READY &&
-		    SRpnt->sr_sense_buffer[12] == 4 /* not ready */ &&
-		    SRpnt->sr_sense_buffer[13] == 3) {
+		if (sense_valid &&
+		    sshdr.sense_key == NOT_READY &&
+		    sshdr.asc == 4 && sshdr.ascq == 3) {
 			break;		/* manual intervention required */
 
 		/*
 		 * Issue command to spin up drive when not ready
 		 */
-		} else if (SRpnt->sr_sense_buffer[2] == NOT_READY) {
+		} else if (sense_valid && sshdr.sense_key == NOT_READY) {
 			if (!spintime) {
 				printk(KERN_NOTICE "%s: Spinning up disk...",
 				       diskname);
@@ -953,8 +983,8 @@
 				memset((void *) &cmd[2], 0, 8);
 				cmd[4] = 1;	/* Start spin cycle */
 				SRpnt->sr_cmd_len = 0;
-				SRpnt->sr_sense_buffer[0] = 0;
-				SRpnt->sr_sense_buffer[2] = 0;
+				memset(SRpnt->sr_sense_buffer, 0,
+					SCSI_SENSE_BUFFERSIZE);
 
 				SRpnt->sr_data_direction = DMA_NONE;
 				scsi_wait_req(SRpnt, (void *)cmd, 
@@ -970,7 +1000,8 @@
 			/* we don't understand the sense code, so it's
 			 * probably pointless to loop */
 			if(!spintime) {
-				printk(KERN_NOTICE "%s: Unit Not Ready, sense:\n", diskname);
+				printk(KERN_NOTICE "%s: Unit Not Ready, "
+					"sense:\n", diskname);
 				scsi_print_req_sense("", SRpnt);
 			}
 			break;
@@ -998,6 +1029,8 @@
 	int the_result, retries;
 	int sector_size = 0;
 	int longrc = 0;
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
 
 repeat:
 	retries = 3;
@@ -1015,8 +1048,7 @@
 		}
 		
 		SRpnt->sr_cmd_len = 0;
-		SRpnt->sr_sense_buffer[0] = 0;
-		SRpnt->sr_sense_buffer[2] = 0;
+		memset(SRpnt->sr_sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
 
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
@@ -1026,6 +1058,9 @@
 			return;
 
 		the_result = SRpnt->sr_result;
+		if (the_result)
+			sense_valid = scsi_request_normalize_sense(SRpnt,
+								   &sshdr);
 		retries--;
 
 	} while (the_result && retries);
@@ -1047,7 +1082,7 @@
 		/* Set dirty bit for removable devices if not ready -
 		 * sometimes drives will not report this properly. */
 		if (sdp->removable &&
-		    SRpnt->sr_sense_buffer[2] == NOT_READY)
+		    sense_valid && sshdr.sense_key == NOT_READY)
 			sdp->changed = 1;
 
 		/* Either no media are present but the drive didn't tell us,
@@ -1255,6 +1290,7 @@
 	const int dbd = 0;	   /* DBD */
 	const int modepage = 0x08; /* current values, cache page */
 	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
 
 	if (sdkp->device->skip_ms_page_8)
 		goto defaults;
@@ -1304,17 +1340,14 @@
 	}
 
 bad_sense:
-	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
-	     && (SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST
-	     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
-	     && SRpnt->sr_sense_buffer[12] == 0x24
-	     && SRpnt->sr_sense_buffer[13] == 0x00) {
+	if (scsi_request_normalize_sense(SRpnt, &sshdr) &&
+	    sshdr.sense_key == ILLEGAL_REQUEST &&
+	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		printk(KERN_NOTICE "%s: cache data unavailable\n",
-		       diskname);
-	} else {
+		       diskname);	/* Invalid field in CDB */
+	else
 		printk(KERN_ERR "%s: asking for cache data failed\n",
 		       diskname);
-	}
 
 defaults:
 	printk(KERN_ERR "%s: assuming drive cache: write through\n",

--------------080300030300030003050507--
