From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] recovered error forward port
Date: Fri, 1 Aug 2003 13:15:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801201514.GD3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:12940 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S270677AbTHAULZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2003 16:11:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: garloff@suse.de

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Forward port of Kurt Garloff's recovered error fix.
http://marc.theaimsgroup.com/?l=linux-scsi&m=104470522312140&w=2

Also corrected some typos related to setting local scope variable by mistake.

Signature without fix:
Current sdc: sense key Recovered Error
Additional sense: Failure prediction threshold exceeded
end_request: I/O error, dev sdc, sector 1808
Buffer I/O error on device sdc, logical block 226

Signature with fix:
scsi_debug: cmd 28 00 00 00 3f 10 00 00 f0 00
scsi_debug: ... <1 0 0 0> non-zero result=0x8000002
Current sdsdc: sense key Recovered Error
Additional sense: Failure prediction threshold exceeded

EDESC


 drivers/scsi/sd.c |    6 ++--
 drivers/scsi/sr.c |   79 +++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 56 insertions(+), 29 deletions(-)

diff -puN drivers/scsi/sd.c~recovered_error drivers/scsi/sd.c
--- patched-scsi-misc-2.5/drivers/scsi/sd.c~recovered_error	Fri Aug  1 07:38:08 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/sd.c	Fri Aug  1 07:38:08 2003
@@ -651,9 +651,11 @@ static void sd_rw_intr(struct scsi_cmnd 
 
 	/* An error occurred */
 	if (driver_byte(result) != 0 && 	/* An error occurred */
-	    SCpnt->sense_buffer[0] == 0xF0) {	/* Sense data is valid */
+	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
+			if (!(SCpnt->sense_buffer[0] & 0x80))
+				break;
 			error_sector = (SCpnt->sense_buffer[3] << 24) |
 			(SCpnt->sense_buffer[4] << 16) |
 			(SCpnt->sense_buffer[5] << 8) |
@@ -696,7 +698,7 @@ static void sd_rw_intr(struct scsi_cmnd 
 			 * hard error.
 			 */
 			print_sense("sd", SCpnt);
-			result = 0;
+			SCpnt->result = 0;
 			SCpnt->sense_buffer[0] = 0x0;
 			good_sectors = this_count;
 			break;
diff -puN drivers/scsi/sr.c~recovered_error drivers/scsi/sr.c
--- patched-scsi-misc-2.5/drivers/scsi/sr.c~recovered_error	Fri Aug  1 07:38:08 2003
+++ patched-scsi-misc-2.5-andmike/drivers/scsi/sr.c	Fri Aug  1 07:38:08 2003
@@ -181,6 +181,7 @@ static void rw_intr(struct scsi_cmnd * S
 	int this_count = SCpnt->bufflen >> 9;
 	int good_sectors = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
+	long error_sector;
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 #ifdef DEBUG
@@ -194,33 +195,57 @@ static void rw_intr(struct scsi_cmnd * S
 	 * memcpy's that could be avoided.
 	 */
 	if (driver_byte(result) != 0 &&		/* An error occurred */
-	    SCpnt->sense_buffer[0] == 0xF0 &&	/* Sense data is valid */
-	    (SCpnt->sense_buffer[2] == MEDIUM_ERROR ||
-	     SCpnt->sense_buffer[2] == VOLUME_OVERFLOW ||
-	     SCpnt->sense_buffer[2] == ILLEGAL_REQUEST)) {
-		long error_sector = (SCpnt->sense_buffer[3] << 24) |
-		(SCpnt->sense_buffer[4] << 16) |
-		(SCpnt->sense_buffer[5] << 8) |
-		SCpnt->sense_buffer[6];
-		if (SCpnt->request->bio != NULL)
-			block_sectors = bio_sectors(SCpnt->request->bio);
-		if (block_sectors < 4)
-			block_sectors = 4;
-		if (cd->device->sector_size == 2048)
-			error_sector <<= 2;
-		error_sector &= ~(block_sectors - 1);
-		good_sectors = error_sector - SCpnt->request->sector;
-		if (good_sectors < 0 || good_sectors >= this_count)
-			good_sectors = 0;
-		/*
-		 * The SCSI specification allows for the value returned by READ
-		 * CAPACITY to be up to 75 2K sectors past the last readable
-		 * block.  Therefore, if we hit a medium error within the last
-		 * 75 2K sectors, we decrease the saved size value.
-		 */
-		if (error_sector < get_capacity(cd->disk) &&
-		    cd->capacity - error_sector < 4 * 75)
-			set_capacity(cd->disk, error_sector);
+	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
+		switch (SCpnt->sense_buffer[2]) {
+		case MEDIUM_ERROR:
+		case VOLUME_OVERFLOW:
+		case ILLEGAL_REQUEST:
+			if (!(SCpnt->sense_buffer[0] & 0x90))
+				break;
+			error_sector = (SCpnt->sense_buffer[3] << 24) |
+				(SCpnt->sense_buffer[4] << 16) |
+				(SCpnt->sense_buffer[5] << 8) |
+				SCpnt->sense_buffer[6];
+			if (SCpnt->request->bio != NULL)
+				block_sectors =
+					bio_sectors(SCpnt->request->bio);
+			if (block_sectors < 4)
+				block_sectors = 4;
+			if (cd->device->sector_size == 2048)
+				error_sector <<= 2;
+			error_sector &= ~(block_sectors - 1);
+			good_sectors = error_sector - SCpnt->request->sector;
+			if (good_sectors < 0 || good_sectors >= this_count)
+				good_sectors = 0;
+			/*
+			 * The SCSI specification allows for the value
+			 * returned by READ CAPACITY to be up to 75 2K
+			 * sectors past the last readable block.
+			 * Therefore, if we hit a medium error within the
+			 * last 75 2K sectors, we decrease the saved size
+			 * value.
+			 */
+			if (error_sector < get_capacity(cd->disk) &&
+			    cd->capacity - error_sector < 4 * 75)
+				set_capacity(cd->disk, error_sector);
+			break;
+
+		case RECOVERED_ERROR:
+
+			/*
+			 * An error occured, but it recovered.  Inform the
+			 * user, but make sure that it's not treated as a
+			 * hard error.
+			 */
+			print_sense("sr", SCpnt);
+			SCpnt->result = 0;
+			SCpnt->sense_buffer[0] = 0x0;
+			good_sectors = this_count;
+			break;
+
+		default:
+			break;
+		}
 	}
 
 	/*

_

