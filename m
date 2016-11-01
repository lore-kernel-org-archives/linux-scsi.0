From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi_dh_hp_sw: switch to scsi_execute_req_flags()
Date: Tue,  1 Nov 2016 22:49:38 +0100
Message-ID: <1478036978-30583-4-git-send-email-hare@suse.de>
References: <1478036978-30583-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754648AbcKAVtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 17:49:50 -0400
In-Reply-To: <1478036978-30583-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Switch to scsi_execute_req_flags() instead of
using the block interface directly. This will set
REQ_QUIET and REQ_PREEMPT, but this is okay as
we're evaluating the errors anyway and should be
able to send the command even if the device is
quiesced.
Switch to scsi_execute_req_flags() instead of
using the block interface directly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 218 ++++++++--------------------
 1 file changed, 61 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9406d5f..84afe2f 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -38,13 +38,10 @@
 #define HP_SW_PATH_PASSIVE		1
 
 struct hp_sw_dh_data {
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int path_state;
 	int retries;
 	int retry_cnt;
 	struct scsi_device *sdev;
-	activate_complete	callback_fn;
-	void			*callback_data;
 };
 
 static int hp_sw_start_stop(struct hp_sw_dh_data *);
@@ -56,43 +53,34 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *);
  *
  * Returns SCSI_DH_DEV_OFFLINED if the sdev is on the passive path
  */
-static int tur_done(struct scsi_device *sdev, unsigned char *sense)
+static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
+		    struct scsi_sense_hdr *sshdr)
 {
-	struct scsi_sense_hdr sshdr;
-	int ret;
+	int ret = SCSI_DH_IO;
 
-	ret = scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr);
-	if (!ret) {
-		sdev_printk(KERN_WARNING, sdev,
-			    "%s: sending tur failed, no sense available\n",
-			    HP_SW_NAME);
-		ret = SCSI_DH_IO;
-		goto done;
-	}
-	switch (sshdr.sense_key) {
+	switch (sshdr->sense_key) {
 	case UNIT_ATTENTION:
 		ret = SCSI_DH_IMM_RETRY;
 		break;
 	case NOT_READY:
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 2)) {
+		if ((sshdr->asc == 0x04) && (sshdr->ascq == 2)) {
 			/*
 			 * LUN not ready - Initialization command required
 			 *
 			 * This is the passive path
 			 */
-			ret = SCSI_DH_DEV_OFFLINED;
+			h->path_state = HP_SW_PATH_PASSIVE;
+			ret = SCSI_DH_OK;
 			break;
 		}
 		/* Fallthrough */
 	default:
 		sdev_printk(KERN_WARNING, sdev,
 			   "%s: sending tur failed, sense %x/%x/%x\n",
-			   HP_SW_NAME, sshdr.sense_key, sshdr.asc,
-			   sshdr.ascq);
+			   HP_SW_NAME, sshdr->sense_key, sshdr->asc,
+			   sshdr->ascq);
 		break;
 	}
-
-done:
 	return ret;
 }
 
@@ -105,131 +93,34 @@ static int tur_done(struct scsi_device *sdev, unsigned char *sense)
  */
 static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 {
-	struct request *req;
-	int ret;
+	unsigned char cmd[6] = { TEST_UNIT_READY };
+	struct scsi_sense_hdr sshdr;
+	int ret = SCSI_DH_OK, res;
 
 retry:
-	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
-	if (IS_ERR(req))
-		return SCSI_DH_RES_TEMP_UNAVAIL;
-
-	blk_rq_set_block_pc(req);
-	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			  REQ_FAILFAST_DRIVER;
-	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
-	req->cmd[0] = TEST_UNIT_READY;
-	req->timeout = HP_SW_TIMEOUT;
-	req->sense = h->sense;
-	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	req->sense_len = 0;
-
-	ret = blk_execute_rq(req->q, NULL, req, 1);
-	if (ret == -EIO) {
-		if (req->sense_len > 0) {
-			ret = tur_done(sdev, h->sense);
-		} else {
+	res = scsi_execute_req_flags(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
+				     HP_SW_TIMEOUT, HP_SW_RETRIES,
+				     NULL, REQ_FAILFAST_MASK);
+	if (res) {
+		if (scsi_sense_valid(&sshdr))
+			ret = tur_done(sdev, h, &sshdr);
+		else {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending tur failed with %x\n",
-				    HP_SW_NAME, req->errors);
+				    HP_SW_NAME, res);
 			ret = SCSI_DH_IO;
 		}
 	} else {
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY) {
-		blk_put_request(req);
+	if (ret == SCSI_DH_IMM_RETRY)
 		goto retry;
-	}
-	if (ret == SCSI_DH_DEV_OFFLINED) {
-		h->path_state = HP_SW_PATH_PASSIVE;
-		ret = SCSI_DH_OK;
-	}
-
-	blk_put_request(req);
 
 	return ret;
 }
 
 /*
- * start_done - Handle START STOP UNIT return status
- * @sdev: sdev the command has been sent to
- * @errors: blk error code
- */
-static int start_done(struct scsi_device *sdev, unsigned char *sense)
-{
-	struct scsi_sense_hdr sshdr;
-	int rc;
-
-	rc = scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr);
-	if (!rc) {
-		sdev_printk(KERN_WARNING, sdev,
-			    "%s: sending start_stop_unit failed, "
-			    "no sense available\n",
-			    HP_SW_NAME);
-		return SCSI_DH_IO;
-	}
-	switch (sshdr.sense_key) {
-	case NOT_READY:
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
-			/*
-			 * LUN not ready - manual intervention required
-			 *
-			 * Switch-over in progress, retry.
-			 */
-			rc = SCSI_DH_RETRY;
-			break;
-		}
-		/* fall through */
-	default:
-		sdev_printk(KERN_WARNING, sdev,
-			   "%s: sending start_stop_unit failed, sense %x/%x/%x\n",
-			   HP_SW_NAME, sshdr.sense_key, sshdr.asc,
-			   sshdr.ascq);
-		rc = SCSI_DH_IO;
-	}
-
-	return rc;
-}
-
-static void start_stop_endio(struct request *req, int error)
-{
-	struct hp_sw_dh_data *h = req->end_io_data;
-	unsigned err = SCSI_DH_OK;
-
-	if (error || host_byte(req->errors) != DID_OK ||
-			msg_byte(req->errors) != COMMAND_COMPLETE) {
-		sdev_printk(KERN_WARNING, h->sdev,
-			    "%s: sending start_stop_unit failed with %x\n",
-			    HP_SW_NAME, req->errors);
-		err = SCSI_DH_IO;
-		goto done;
-	}
-
-	if (req->sense_len > 0) {
-		err = start_done(h->sdev, h->sense);
-		if (err == SCSI_DH_RETRY) {
-			err = SCSI_DH_IO;
-			if (--h->retry_cnt) {
-				blk_put_request(req);
-				err = hp_sw_start_stop(h);
-				if (err == SCSI_DH_OK)
-					return;
-			}
-		}
-	}
-done:
-	req->end_io_data = NULL;
-	__blk_put_request(req->q, req);
-	if (h->callback_fn) {
-		h->callback_fn(h->callback_data, err);
-		h->callback_fn = h->callback_data = NULL;
-	}
-	return;
-
-}
-
-/*
  * hp_sw_start_stop - Send START STOP UNIT command
  * @sdev: sdev command should be sent to
  *
@@ -237,26 +128,46 @@ static void start_stop_endio(struct request *req, int error)
  */
 static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 {
-	struct request *req;
-
-	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
-	if (IS_ERR(req))
-		return SCSI_DH_RES_TEMP_UNAVAIL;
-
-	blk_rq_set_block_pc(req);
-	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			  REQ_FAILFAST_DRIVER;
-	req->cmd_len = COMMAND_SIZE(START_STOP);
-	req->cmd[0] = START_STOP;
-	req->cmd[4] = 1;	/* Start spin cycle */
-	req->timeout = HP_SW_TIMEOUT;
-	req->sense = h->sense;
-	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	req->sense_len = 0;
-	req->end_io_data = h;
+	unsigned char cmd[6] = { START_STOP, 0, 0, 0, 1, 0 };	/* START_VALID */
+	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdev = h->sdev;
+	int res, rc = SCSI_DH_OK;
+	int retry_cnt = HP_SW_RETRIES;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, start_stop_endio);
-	return SCSI_DH_OK;
+retry:
+	res = scsi_execute_req_flags(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
+				     HP_SW_TIMEOUT, HP_SW_RETRIES,
+				     NULL, REQ_FAILFAST_MASK);
+	if (res) {
+		if (!scsi_sense_valid(&sshdr)) {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: sending start_stop_unit failed, "
+				    "no sense available\n", HP_SW_NAME);
+			return SCSI_DH_IO;
+		}
+		switch (sshdr.sense_key) {
+		case NOT_READY:
+			if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
+				/*
+				 * LUN not ready - manual intervention required
+				 *
+				 * Switch-over in progress, retry.
+				 */
+				if (--retry_cnt)
+					goto retry;
+				rc = SCSI_DH_RETRY;
+				break;
+			}
+			/* fall through */
+		default:
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: sending start_stop_unit failed, "
+				    "sense %x/%x/%x\n", HP_SW_NAME,
+				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+			rc = SCSI_DH_IO;
+		}
+	}
+	return rc;
 }
 
 static int hp_sw_prep_fn(struct scsi_device *sdev, struct request *req)
@@ -290,15 +201,8 @@ static int hp_sw_activate(struct scsi_device *sdev,
 
 	ret = hp_sw_tur(sdev, h);
 
-	if (ret == SCSI_DH_OK && h->path_state == HP_SW_PATH_PASSIVE) {
-		h->retry_cnt = h->retries;
-		h->callback_fn = fn;
-		h->callback_data = data;
+	if (ret == SCSI_DH_OK && h->path_state == HP_SW_PATH_PASSIVE)
 		ret = hp_sw_start_stop(h);
-		if (ret == SCSI_DH_OK)
-			return 0;
-		h->callback_fn = h->callback_data = NULL;
-	}
 
 	if (fn)
 		fn(data, ret);
-- 
2.6.6

