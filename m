From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 22/24][RFC] scsi upper layer use of sense accessors
Date: Mon,  4 Feb 2008 19:55:50 +0200
Message-ID: <1202147750-5429-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:34668 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYBDSAo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:00:44 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  code that inspects the return sense can use the new scsi_sense()
  accessor.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/constants.c |    4 ++--
 drivers/scsi/sd.c        |    4 ++--
 drivers/scsi/sr.c        |   15 +++++++--------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 9785d73..0c6ad0e 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1349,10 +1349,10 @@ void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 	struct scsi_sense_hdr sshdr;
 
 	scmd_printk(KERN_INFO, cmd, "");
-	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+	scsi_decode_sense_buffer(scsi_sense(cmd), SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
 	scsi_show_sense_hdr(&sshdr);
-	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+	scsi_decode_sense_extras(scsi_sense(cmd), SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
 	scmd_printk(KERN_INFO, cmd, "");
 	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 51a5557..be3cee8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -960,7 +960,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	case MEDIUM_ERROR:
 		if (!blk_fs_request(SCpnt->request))
 			goto out;
-		info_valid = scsi_get_sense_info_fld(SCpnt->sense_buffer,
+		info_valid = scsi_get_sense_info_fld(scsi_sense(SCpnt),
 						     SCSI_SENSE_BUFFERSIZE,
 						     &bad_lba);
 		if (!info_valid)
@@ -999,7 +999,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		 */
 		scsi_print_sense("sd", SCpnt);
 		SCpnt->result = 0;
-		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+		scsi_eh_reset_sense(SCpnt);
 		good_bytes = xfer_size;
 		break;
 	case ILLEGAL_REQUEST:
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 50ba492..6dcb933 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -230,6 +230,7 @@ out:
  */
 static int sr_done(struct scsi_cmnd *SCpnt)
 {
+	const u8 *sense = scsi_sense(SCpnt);
 	int result = SCpnt->result;
 	int this_count = scsi_bufflen(SCpnt);
 	int good_bytes = (result == 0 ? this_count : 0);
@@ -248,17 +249,15 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	 * memcpy's that could be avoided.
 	 */
 	if (driver_byte(result) != 0 &&		/* An error occurred */
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
-		switch (SCpnt->sense_buffer[2]) {
+	    (sense[0] & 0x7f) == 0x70) { /* Sense current */
+		switch (sense[2]) {
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 		case ILLEGAL_REQUEST:
-			if (!(SCpnt->sense_buffer[0] & 0x90))
+			if (!(sense[0] & 0x90))
 				break;
-			error_sector = (SCpnt->sense_buffer[3] << 24) |
-				(SCpnt->sense_buffer[4] << 16) |
-				(SCpnt->sense_buffer[5] << 8) |
-				SCpnt->sense_buffer[6];
+			error_sector = (sense[3] << 24) | (sense[4] << 16) |
+					(sense[5] << 8) | sense[6];
 			if (SCpnt->request->bio != NULL)
 				block_sectors =
 					bio_sectors(SCpnt->request->bio);
@@ -292,7 +291,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 			 */
 			scsi_print_sense("sr", SCpnt);
 			SCpnt->result = 0;
-			SCpnt->sense_buffer[0] = 0x0;
+			scsi_eh_reset_sense(SCpnt);
 			good_bytes = this_count;
 			break;
 
-- 
1.5.3.3

