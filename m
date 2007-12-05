From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Read errors on Flash Drive Transcend TS1GJF2A
Date: Wed, 5 Dec 2007 12:36:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0712051231020.6597-100000@iolanthe.rowland.org>
References: <47566991.6080200@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48506 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751502AbXLERgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 12:36:55 -0500
In-Reply-To: <47566991.6080200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 5 Dec 2007, Boaz Harrosh wrote:

> Hi Alen
> 
> Yes, I have not inspected sr.c very carefully, you are absolutely right.
> Could you submit a unified patch for sd, sr and scsi.c I have hit this 
> bug 2 in my error injection tests. I was doing sg_chaining tests and now
> with the possibly very large requests the problem gets worse. At the time,
> I could not identify the exact problem, thanks

I'd like to keep the sd and sr patches separate.  The sd patch has 
already been tested and is known to fix an existing problem.

The sr patch below is new and it has not been tested.  All I know is 
that it compiles.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi.c
+++ usb-2.6/drivers/scsi/scsi.c
@@ -700,6 +700,8 @@ void scsi_finish_command(struct scsi_cmn
 
 	good_bytes = cmd->request_bufflen;
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		if (cmd->resid > 0 && cmd->resid < good_bytes)
+			good_bytes -= cmd->resid;
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
 			good_bytes = drv->done(cmd);
Index: usb-2.6/drivers/scsi/sr.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sr.c
+++ usb-2.6/drivers/scsi/sr.c
@@ -218,15 +218,29 @@ static int sr_media_change(struct cdrom_
 static int sr_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->request_bufflen;
-	int good_bytes = (result == 0 ? this_count : 0);
-	int block_sectors = 0;
-	long error_sector;
+	unsigned int xfer_size = SCpnt->request_bufflen;
+	unsigned int good_bytes = (result == 0 ? xfer_size : 0);
+	unsigned long start_lba = SCpnt->request->sector;
+	u64 bad_lba;
+	unsigned long num_blocks;
+	unsigned long bad_sector;
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct scsi_sense_hdr sshdr;
+	int sense_valid = 0;
+	int sense_deferred = 0;
+	int info_valid;
 
 #ifdef DEBUG
 	printk("sr.c done: %x\n", result);
 #endif
+	if (result) {
+		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
+		if (sense_valid)
+			sense_deferred = scsi_sense_is_deferred(&sshdr);
+	}
+	if (driver_byte(result) != DRIVER_SENSE &&
+	    (!sense_valid || sense_deferred))
+		goto out;
 
 	/*
 	 * Handle MEDIUM ERRORs or VOLUME OVERFLOWs that indicate partial
@@ -234,60 +248,83 @@ static int sr_done(struct scsi_cmnd *SCp
 	 * care is taken to avoid unnecessary additional work such as
 	 * memcpy's that could be avoided.
 	 */
-	if (driver_byte(result) != 0 &&		/* An error occurred */
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
-		switch (SCpnt->sense_buffer[2]) {
-		case MEDIUM_ERROR:
-		case VOLUME_OVERFLOW:
-		case ILLEGAL_REQUEST:
-			if (!(SCpnt->sense_buffer[0] & 0x90))
-				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-				(SCpnt->sense_buffer[4] << 16) |
-				(SCpnt->sense_buffer[5] << 8) |
-				SCpnt->sense_buffer[6];
-			if (SCpnt->request->bio != NULL)
-				block_sectors =
-					bio_sectors(SCpnt->request->bio);
-			if (block_sectors < 4)
-				block_sectors = 4;
-			if (cd->device->sector_size == 2048)
-				error_sector <<= 2;
-			error_sector &= ~(block_sectors - 1);
-			good_bytes = (error_sector - SCpnt->request->sector) << 9;
-			if (good_bytes < 0 || good_bytes >= this_count)
-				good_bytes = 0;
-			/*
-			 * The SCSI specification allows for the value
-			 * returned by READ CAPACITY to be up to 75 2K
-			 * sectors past the last readable block.
-			 * Therefore, if we hit a medium error within the
-			 * last 75 2K sectors, we decrease the saved size
-			 * value.
-			 */
-			if (error_sector < get_capacity(cd->disk) &&
-			    cd->capacity - error_sector < 4 * 75)
-				set_capacity(cd->disk, error_sector);
+	switch (sshdr.sense_key) {
+	case HARDWARE_ERROR:
+	case MEDIUM_ERROR:
+	case VOLUME_OVERFLOW:
+	case ILLEGAL_REQUEST:
+		if (!blk_fs_request(SCpnt->request))
+			goto out;
+		info_valid = scsi_get_sense_info_fld(SCpnt->sense_buffer,
+						     SCSI_SENSE_BUFFERSIZE,
+						     &bad_lba);
+		if (!info_valid)
+			goto out;
+		if (xfer_size <= SCpnt->device->sector_size)
+			goto out;
+		switch (SCpnt->device->sector_size) {
+		case 512:
 			break;
-
-		case RECOVERED_ERROR:
-
-			/*
-			 * An error occured, but it recovered.  Inform the
-			 * user, but make sure that it's not treated as a
-			 * hard error.
-			 */
-			scsi_print_sense("sr", SCpnt);
-			SCpnt->result = 0;
-			SCpnt->sense_buffer[0] = 0x0;
-			good_bytes = this_count;
+		case 1024:
+			start_lba >>= 1;
+			break;
+		case 2048:
+			start_lba >>= 2;
 			break;
-
 		default:
+			/* Print something here with limiting frequency. */
+			goto out;
 			break;
 		}
-	}
+		/* This computation should always be done in terms of
+		 * the resolution of the device's medium.  Note that
+		 * overflow may occur if the device has more than
+		 * 2**32 512-byte sectors.
+		 */
+
+		num_blocks = bad_lba - start_lba;
+		if (num_blocks < xfer_size / SCpnt->device->sector_size)
+			;	/* We're good */
+
+		/* If the bad_lba value is no good, maybe the residue value
+		 * is better.
+		 */
+		else if (SCpnt->resid > 0 && SCpnt->resid < xfer_size)
+			num_blocks = (xfer_size - SCpnt->resid) /
+					SCpnt->device->sector_size;
+		else
+			num_blocks = 0;
+		good_bytes = SCpnt->device->sector_size * num_blocks;
 
+		/*
+		 * The SCSI specification allows for the value
+		 * returned by READ CAPACITY to be up to 75 2K
+		 * sectors past the last readable block.
+		 * Therefore, if we hit a medium error within the
+		 * last 75 2K sectors, we decrease the saved size
+		 * value.
+		 */
+		bad_sector = (start_lba + num_blocks) *
+				(SCpnt->device->sector_size / 512);
+		if (bad_sector < get_capacity(cd->disk) &&
+		    cd->capacity - bad_sector < 4 * 75)
+			set_capacity(cd->disk, bad_sector);
+		break;
+
+	case RECOVERED_ERROR:
+	case NO_SENSE:
+		/* Inform the user, but make sure that it's not treated
+		 * as a hard error.
+		 */
+		scsi_print_sense("sd", SCpnt);
+		SCpnt->result = 0;
+		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		good_bytes = xfer_size;
+		break;
+	default:
+		break;
+	}
+ out:
 	return good_bytes;
 }
 

