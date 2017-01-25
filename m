From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/18] scsi_dh_emc: switch to scsi_execute_req_flags()
Date: Wed, 25 Jan 2017 18:25:17 +0100
Message-ID: <1485365126-23210-10-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Switch to scsi_execute_req_flags() and scsi_get_vpd_page() instead of
open-coding it.  Using scsi_execute_req_flags() will set REQ_QUIET and
REQ_PREEMPT, but this is okay as we're evaluating the errors anyway and
should be able to send the command even if the device is quiesced.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c | 247 +++++++-----------------------
 1 file changed, 56 insertions(+), 191 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 5b80746..4a7679f 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -88,12 +88,6 @@ struct clariion_dh_data {
 	 */
 	unsigned char buffer[CLARIION_BUFFER_SIZE];
 	/*
-	 * SCSI sense buffer for commands -- assumes serial issuance
-	 * and completion sequence of all commands for same multipath.
-	 */
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
-	unsigned int senselen;
-	/*
 	 * LUN state
 	 */
 	int lun_state;
@@ -116,44 +110,38 @@ struct clariion_dh_data {
 /*
  * Parse MODE_SELECT cmd reply.
  */
-static int trespass_endio(struct scsi_device *sdev, char *sense)
+static int trespass_endio(struct scsi_device *sdev,
+			  struct scsi_sense_hdr *sshdr)
 {
 	int err = SCSI_DH_IO;
-	struct scsi_sense_hdr sshdr;
-
-	if (!scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
-		sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
-			    "0x%2x, 0x%2x while sending CLARiiON trespass "
-			    "command.\n", CLARIION_NAME, sshdr.sense_key,
-			    sshdr.asc, sshdr.ascq);
 
-		if ((sshdr.sense_key == 0x05) && (sshdr.asc == 0x04) &&
-		     (sshdr.ascq == 0x00)) {
-			/*
-			 * Array based copy in progress -- do not send
-			 * mode_select or copy will be aborted mid-stream.
-			 */
-			sdev_printk(KERN_INFO, sdev, "%s: Array Based Copy in "
-				    "progress while sending CLARiiON trespass "
-				    "command.\n", CLARIION_NAME);
-			err = SCSI_DH_DEV_TEMP_BUSY;
-		} else if ((sshdr.sense_key == 0x02) && (sshdr.asc == 0x04) &&
-			    (sshdr.ascq == 0x03)) {
-			/*
-			 * LUN Not Ready - Manual Intervention Required
-			 * indicates in-progress ucode upgrade (NDU).
-			 */
-			sdev_printk(KERN_INFO, sdev, "%s: Detected in-progress "
-				    "ucode upgrade NDU operation while sending "
-				    "CLARiiON trespass command.\n", CLARIION_NAME);
-			err = SCSI_DH_DEV_TEMP_BUSY;
-		} else
-			err = SCSI_DH_DEV_FAILED;
-	} else {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: failed to send MODE SELECT, no sense available\n",
-			    CLARIION_NAME);
-	}
+	sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
+		    "0x%2x, 0x%2x while sending CLARiiON trespass "
+		    "command.\n", CLARIION_NAME, sshdr->sense_key,
+		    sshdr->asc, sshdr->ascq);
+
+	if (sshdr->sense_key == 0x05 && sshdr->asc == 0x04 &&
+	    sshdr->ascq == 0x00) {
+		/*
+		 * Array based copy in progress -- do not send
+		 * mode_select or copy will be aborted mid-stream.
+		 */
+		sdev_printk(KERN_INFO, sdev, "%s: Array Based Copy in "
+			    "progress while sending CLARiiON trespass "
+			    "command.\n", CLARIION_NAME);
+		err = SCSI_DH_DEV_TEMP_BUSY;
+	} else if (sshdr->sense_key == 0x02 && sshdr->asc == 0x04 &&
+		   sshdr->ascq == 0x03) {
+		/*
+		 * LUN Not Ready - Manual Intervention Required
+		 * indicates in-progress ucode upgrade (NDU).
+		 */
+		sdev_printk(KERN_INFO, sdev, "%s: Detected in-progress "
+			    "ucode upgrade NDU operation while sending "
+			    "CLARiiON trespass command.\n", CLARIION_NAME);
+		err = SCSI_DH_DEV_TEMP_BUSY;
+	} else
+		err = SCSI_DH_DEV_FAILED;
 	return err;
 }
 
@@ -257,103 +245,15 @@ static char * parse_sp_model(struct scsi_device *sdev, unsigned char *buffer)
 	return sp_model;
 }
 
-/*
- * Get block request for REQ_BLOCK_PC command issued to path.  Currently
- * limited to MODE_SELECT (trespass) and INQUIRY (VPD page 0xC0) commands.
- *
- * Uses data and sense buffers in hardware handler context structure and
- * assumes serial servicing of commands, both issuance and completion.
- */
-static struct request *get_req(struct scsi_device *sdev, int cmd,
-				unsigned char *buffer)
-{
-	struct request *rq;
-	int len = 0;
-
-	rq = blk_get_request(sdev->request_queue,
-			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
-	if (IS_ERR(rq)) {
-		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
-		return NULL;
-	}
-
-	blk_rq_set_block_pc(rq);
-	rq->cmd_len = COMMAND_SIZE(cmd);
-	rq->cmd[0] = cmd;
-
-	switch (cmd) {
-	case MODE_SELECT:
-		len = sizeof(short_trespass);
-		rq->cmd[1] = 0x10;
-		rq->cmd[4] = len;
-		break;
-	case MODE_SELECT_10:
-		len = sizeof(long_trespass);
-		rq->cmd[1] = 0x10;
-		rq->cmd[8] = len;
-		break;
-	case INQUIRY:
-		len = CLARIION_BUFFER_SIZE;
-		rq->cmd[4] = len;
-		memset(buffer, 0, len);
-		break;
-	default:
-		BUG_ON(1);
-		break;
-	}
-
-	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER;
-	rq->timeout = CLARIION_TIMEOUT;
-	rq->retries = CLARIION_RETRIES;
-
-	if (blk_rq_map_kern(rq->q, rq, buffer, len, GFP_NOIO)) {
-		blk_put_request(rq);
-		return NULL;
-	}
-
-	return rq;
-}
-
-static int send_inquiry_cmd(struct scsi_device *sdev, int page,
-			    struct clariion_dh_data *csdev)
-{
-	struct request *rq = get_req(sdev, INQUIRY, csdev->buffer);
-	int err;
-
-	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq->sense = csdev->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = csdev->senselen = 0;
-
-	rq->cmd[0] = INQUIRY;
-	if (page != 0) {
-		rq->cmd[1] = 1;
-		rq->cmd[2] = page;
-	}
-	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: failed to send %s INQUIRY: %x\n",
-			    CLARIION_NAME, page?"EVPD":"standard",
-			    rq->errors);
-		csdev->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
-	}
-
-	blk_put_request(rq);
-
-	return err;
-}
-
 static int send_trespass_cmd(struct scsi_device *sdev,
 			    struct clariion_dh_data *csdev)
 {
-	struct request *rq;
 	unsigned char *page22;
-	int err, len, cmd;
+	unsigned char cdb[COMMAND_SIZE(MODE_SELECT)];
+	int err, res = SCSI_DH_OK, len;
+	struct scsi_sense_hdr sshdr;
+	u64 req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+		REQ_FAILFAST_DRIVER;
 
 	if (csdev->flags & CLARIION_SHORT_TRESPASS) {
 		page22 = short_trespass;
@@ -361,40 +261,37 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 			/* Set Honor Reservations bit */
 			page22[6] |= 0x80;
 		len = sizeof(short_trespass);
-		cmd = MODE_SELECT;
+		cdb[0] = MODE_SELECT;
+		cdb[1] = 0x10;
+		cdb[4] = len;
 	} else {
 		page22 = long_trespass;
 		if (!(csdev->flags & CLARIION_HONOR_RESERVATIONS))
 			/* Set Honor Reservations bit */
 			page22[10] |= 0x80;
 		len = sizeof(long_trespass);
-		cmd = MODE_SELECT_10;
+		cdb[0] = MODE_SELECT_10;
+		cdb[8] = len;
 	}
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	rq = get_req(sdev, cmd, csdev->buffer);
-	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq->sense = csdev->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = csdev->senselen = 0;
-
-	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
-	if (err == -EIO) {
-		if (rq->sense_len) {
-			err = trespass_endio(sdev, csdev->sense);
-		} else {
+	err = scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
+				     csdev->buffer, len, &sshdr,
+				     CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
+				     NULL, req_flags, 0);
+	if (err) {
+		if (scsi_sense_valid(&sshdr))
+			res = trespass_endio(sdev, &sshdr);
+		else {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: failed to send MODE SELECT: %x\n",
-				    CLARIION_NAME, rq->errors);
+				    CLARIION_NAME, err);
+			res = SCSI_DH_IO;
 		}
 	}
 
-	blk_put_request(rq);
-
-	return err;
+	return res;
 }
 
 static int clariion_check_sense(struct scsi_device *sdev,
@@ -464,21 +361,7 @@ static int clariion_std_inquiry(struct scsi_device *sdev,
 	int err;
 	char *sp_model;
 
-	err = send_inquiry_cmd(sdev, 0, csdev);
-	if (err != SCSI_DH_OK && csdev->senselen) {
-		struct scsi_sense_hdr sshdr;
-
-		if (scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
-					 &sshdr)) {
-			sdev_printk(KERN_ERR, sdev, "%s: INQUIRY sense code "
-				    "%02x/%02x/%02x\n", CLARIION_NAME,
-				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
-		}
-		err = SCSI_DH_IO;
-		goto out;
-	}
-
-	sp_model = parse_sp_model(sdev, csdev->buffer);
+	sp_model = parse_sp_model(sdev, sdev->inquiry);
 	if (!sp_model) {
 		err = SCSI_DH_DEV_UNSUPP;
 		goto out;
@@ -500,30 +383,12 @@ static int clariion_std_inquiry(struct scsi_device *sdev,
 static int clariion_send_inquiry(struct scsi_device *sdev,
 				 struct clariion_dh_data *csdev)
 {
-	int err, retry = CLARIION_RETRIES;
-
-retry:
-	err = send_inquiry_cmd(sdev, 0xC0, csdev);
-	if (err != SCSI_DH_OK && csdev->senselen) {
-		struct scsi_sense_hdr sshdr;
-
-		err = scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sshdr);
-		if (!err)
-			return SCSI_DH_IO;
-
-		err = clariion_check_sense(sdev, &sshdr);
-		if (retry > 0 && err == ADD_TO_MLQUEUE) {
-			retry--;
-			goto retry;
-		}
-		sdev_printk(KERN_ERR, sdev, "%s: INQUIRY sense code "
-			    "%02x/%02x/%02x\n", CLARIION_NAME,
-			      sshdr.sense_key, sshdr.asc, sshdr.ascq);
-		err = SCSI_DH_IO;
-	} else {
+	int err = SCSI_DH_IO;
+
+	if (!scsi_get_vpd_page(sdev, 0xC0, csdev->buffer,
+			       CLARIION_BUFFER_SIZE))
 		err = parse_sp_info_reply(sdev, csdev);
-	}
+
 	return err;
 }
 
-- 
2.1.4

