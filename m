From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [RFC] sd: make error handling more robust
Date: Thu, 31 Jan 2008 16:31:11 -0500
Message-ID: <47A23E1F.8060906@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:2757 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYAaVbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 16:31:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Luben Tuikov <ltuikov@yahoo.com>, linux-scsi@vger.kernel.org

I have a RAID that returns a medium error on a read command.  The
"information bytes valid" bit is set in the sense data, but the
information bytes are zero:

CDB: 28 00 02 B0 62 00 00 00 02 00
Status:	02 (CHECK CONDITION)
Sense data:
F0 00 03 00 | 00 00 00 0A | 00 00 00 00 | 00 00 00 00
00 00

For HARDWARE_ERROR/MEDIUM_ERROR, sd_done assumes that the sense
information bytes contain the sector in error without sanity-checking
the value, so it ends up returning a completely bogus good_bytes value
greater than xfer_size.  This in turn causes the medium error to be
ignored and corrupt data to be returned to the user application.  This
problem was introduced by the patch "[SCSI] sd/scsi_lib simplify
sd_rw_intr and scsi_io_completion" in 2.6.18-rc1; with kernels 2.6.17
and before, the application correctly gets an I/O error instead.  This
patch fixes this particular problem by checking that bad_lba falls
within a sensible range before using it.

For a read command that returns HARDWARE_ERROR/MEDIUM_ERROR, I also
added the ability to calculate the amount of good data returned using
the data transfer residual if set by the LLDD.  If the both the sense
information bytes and the data transfer residual are valid, then they
are used to sanity-check each other.

The following code in sd_done doesn't seem right to me:

       if (driver_byte(result) != DRIVER_SENSE &&
           (!sense_valid || sense_deferred))
                goto out;

It would make more sense to use || rather than && for this test.  Even
better, this patch moves the check up higher so that the sense buffer
isn't even accessed unless driver_byte(result) & DRIVER_SENSE.

Finally, for the case of RECOVERED_ERROR/NO_SENSE, this patch adds a
check of the data transfer residual before assuming that the command
completed successfully.

I would like comments on the following:

sd_done doesn't check the data transfer residual for commands that
complete successfully.  In the unlikely case that the drive returns good
status without transferring all the data (due to a SCSI bus problem or
disk firmware bug), the error won't be detected.  I figured that it was
more likely for a LLDD to set resid incorrectly than for this unlikely
problem to happen, so I didn't add a check for it.  Agreed?

Is the new is_sd_cmnd_read_or_write() function necessary?  The original
code appears to use blk_fs_request(SCpnt->request) to determine if a
command is read or write.  Should I drop is_sd_cmnd_read_or_write() and
use blk_fs_request() instead, or it it OK like this?

Does anyone object to the new data transfer residual checks for
non-read/write commands that return RECOVERED_ERROR/NO_SENSE?  Should I
just drop this part of the patch for simplicity?

--- linux-2.6.24-git9/drivers/scsi/sd.c.orig	2008-01-31 16:24:04.000000000 -0500
+++ linux-2.6.24-git9/drivers/scsi/sd.c	2008-01-31 16:24:51.000000000 -0500
@@ -916,6 +916,29 @@ static struct block_device_operations sd
 	.revalidate_disk	= sd_revalidate_disk,
 };
 
+static int is_sd_cmnd_read_or_write(struct scsi_cmnd *cmd)
+{
+	int is_rw;
+
+	switch (cmd->cmnd[0]) {
+	case READ_6 :
+	case WRITE_6 :
+	case READ_10 :
+	case WRITE_10 :
+	case READ_12 :
+	case WRITE_12 :
+	case READ_16 :
+	case WRITE_16 :
+		is_rw = 1;
+		break;
+
+	default :
+		is_rw = 0;
+	}
+
+	return is_rw;
+}
+
 /**
  *	sd_done - bottom half handler: called when the lower level
  *	driver has completed (successfully or otherwise) a scsi command.
@@ -928,14 +951,16 @@ static int sd_done(struct scsi_cmnd *SCp
 	int result = SCpnt->result;
 	unsigned int xfer_size = scsi_bufflen(SCpnt);
  	unsigned int good_bytes = result ? 0 : xfer_size;
- 	u64 start_lba = SCpnt->request->sector;
+	unsigned int sector_size;
+	u64 start_lba;
  	u64 bad_lba;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
 	int info_valid;
+	int resid;
 
-	if (result) {
+	if (driver_byte(result) & DRIVER_SENSE) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
@@ -951,23 +976,53 @@ static int sd_done(struct scsi_cmnd *SCp
 						   sshdr.ascq));
 	}
 #endif
-	if (driver_byte(result) != DRIVER_SENSE &&
-	    (!sense_valid || sense_deferred))
+	if (!sense_valid || sense_deferred)
 		goto out;
 
+	sector_size = SCpnt->device->sector_size;
+
+	resid = scsi_get_resid(SCpnt);
+	if (resid < 0)
+		resid = 0;
+	else if ((unsigned) resid > xfer_size)
+		resid = xfer_size;
+
 	switch (sshdr.sense_key) {
 	case HARDWARE_ERROR:
 	case MEDIUM_ERROR:
-		if (!blk_fs_request(SCpnt->request))
+		if (!is_sd_cmnd_read_or_write(SCpnt))
 			goto out;
+
+		/* For read commands, use the data transfer residual (if
+		 * supported by the LLDD) to calculate the amount of good data
+		 * actually returned.  This doesn't work for write commands,
+		 * since the drive may accept the data into its buffer, but
+		 * then not write it to the medium.  Assume that resid == 0
+		 * means that the LLDD didn't set it, since if the drive
+		 * really returned all the data, then it shouldn't have
+		 * returned an error also.
+		 */
+		if ((SCpnt->sc_data_direction == DMA_FROM_DEVICE) &&
+		    (resid != 0) &&
+		    (sector_size != 0)) {
+			good_bytes = xfer_size - resid;
+			good_bytes -= good_bytes % sector_size;
+			/* Check the sense data also.
+			 */
+		}
+
+		/* The drive may return the LBA of the sector with the error in
+		 * the sense information bytes.
+		 */
 		info_valid = scsi_get_sense_info_fld(SCpnt->sense_buffer,
 						     SCSI_SENSE_BUFFERSIZE,
 						     &bad_lba);
 		if (!info_valid)
 			goto out;
-		if (xfer_size <= SCpnt->device->sector_size)
+		if (xfer_size <= sector_size)
 			goto out;
-		switch (SCpnt->device->sector_size) {
+		start_lba = SCpnt->request->sector;
+		switch (sector_size) {
 		case 256:
 			start_lba <<= 1;
 			break;
@@ -987,13 +1042,72 @@ static int sd_done(struct scsi_cmnd *SCp
 			goto out;
 			break;
 		}
+
+		/* Make sure that bad_lba is one of the sectors that the
+		 * command was trying to access.
+		 */
+		if (bad_lba < start_lba ||
+		    bad_lba >= start_lba + xfer_size / sector_size)
+			goto out;
+
 		/* This computation should always be done in terms of
 		 * the resolution of the device's medium.
 		 */
-		good_bytes = (bad_lba - start_lba)*SCpnt->device->sector_size;
+		good_bytes = (bad_lba - start_lba) * sector_size;
+
+		/* Check the computed value against the amount of data the
+		 * command actually transferred.
+		 */
+		if (good_bytes > xfer_size - resid) {
+			good_bytes = xfer_size - resid;
+			good_bytes -= good_bytes % sector_size;
+		}
 		break;
 	case RECOVERED_ERROR:
 	case NO_SENSE:
+		if (is_sd_cmnd_read_or_write(SCpnt)) {
+			/* Read/write commands: if all data transferred, then
+			 * consider the command to have completed successfully.
+			 * Otherwise, calculate good_bytes based on the actual
+			 * data transfer length rounded down to the nearest
+			 * sector.
+			 */
+			if (resid != 0) {
+				good_bytes = xfer_size - resid;
+				if (sector_size != 0)
+					good_bytes -= good_bytes % sector_size;
+				goto out;
+			}
+		} else {
+			switch (SCpnt->sc_data_direction) {
+			case DMA_TO_DEVICE:
+				/* Data-out commands (e.g. mode select): if all
+				 * data transferred, then consider the command
+				 * to have completed successfully.  Otherwise,
+				 * consider it an error.
+				 */
+				if (resid != 0)
+					goto out;
+				break;
+			case DMA_FROM_DEVICE:
+				/* Data-in commands (e.g. mode sense): if some
+				 * data transferred, then consider the command
+				 * to have completed successfully.  If no data
+				 * transferred, then consider it an error.
+				 * Note that it is normal for data-in commands
+				 * to transfer less than requested.
+				 */
+				if ((resid != 0) && (resid == xfer_size))
+					goto out;
+				break;
+			default:
+				/* Non-data commands: consider the command to
+				 * have completed successfully.
+				 */
+				break;
+			}
+		}
+
 		/* Inform the user, but make sure that it's not treated
 		 * as a hard error.
 		 */


