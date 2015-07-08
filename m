From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/20] scsi_dh_alua: Make stpg synchronous
Date: Wed,  8 Jul 2015 11:06:06 +0200
Message-ID: <1436346378-96518-9-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934479AbbGHJG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:26 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

We should be issuing STPG synchronously as we need to
evaluate the return code on failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 189 +++++++++++++----------------
 1 file changed, 87 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 28a3b99..76bc66d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -172,94 +172,46 @@ done:
 }
 
 /*
- * stpg_endio - Evaluate SET TARGET GROUP STATES
- * @sdev: the device to be evaluated
- * @state: the new target group state
- *
- * Evaluate a SET TARGET GROUP STATES command response.
- */
-static void stpg_endio(struct request *req, int error)
-{
-	struct alua_dh_data *h = req->end_io_data;
-	struct scsi_sense_hdr sense_hdr;
-	unsigned err = SCSI_DH_OK;
-
-	if (host_byte(req->errors) != DID_OK ||
-	    msg_byte(req->errors) != COMMAND_COMPLETE) {
-		err = SCSI_DH_IO;
-		goto done;
-	}
-
-	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-				 &sense_hdr)) {
-		err = alua_check_sense(h->sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE) {
-			err = SCSI_DH_RETRY;
-			goto done;
-		}
-		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
-			    ALUA_DH_NAME);
-		scsi_print_sense_hdr(h->sdev, ALUA_DH_NAME, &sense_hdr);
-		err = SCSI_DH_IO;
-	} else if (error)
-		err = SCSI_DH_IO;
-
-	if (err == SCSI_DH_OK) {
-		h->state = TPGS_STATE_OPTIMIZED;
-		sdev_printk(KERN_INFO, h->sdev,
-			    "%s: port group %02x switched to state %c\n",
-			    ALUA_DH_NAME, h->group_id,
-			    print_alua_state(h->state));
-	}
-done:
-	req->end_io_data = NULL;
-	__blk_put_request(req->q, req);
-	if (h->callback_fn) {
-		h->callback_fn(h->callback_data, err);
-		h->callback_fn = h->callback_data = NULL;
-	}
-	return;
-}
-
-/*
  * submit_stpg - Issue a SET TARGET GROUP STATES command
  *
  * Currently we're only setting the current target port group state
  * to 'active/optimized' and let the array firmware figure out
  * the states of the remaining groups.
  */
-static unsigned submit_stpg(struct alua_dh_data *h)
+static unsigned submit_stpg(struct scsi_device *sdev, int group_id,
+			    unsigned char *sense)
 {
 	struct request *rq;
+	unsigned char stpg_data[8];
 	int stpg_len = 8;
-	struct scsi_device *sdev = h->sdev;
+	int err = 0;
 
 	/* Prepare the data buffer */
-	memset(h->buff, 0, stpg_len);
-	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
-	h->buff[6] = (h->group_id >> 8) & 0xff;
-	h->buff[7] = h->group_id & 0xff;
+	memset(stpg_data, 0, stpg_len);
+	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
+	put_unaligned_be16(group_id, &stpg_data[6]);
 
-	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
+	rq = get_alua_req(sdev, stpg_data, stpg_len, WRITE);
 	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
+		return DRIVER_BUSY << 24;
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_OUT;
 	rq->cmd[1] = MO_SET_TARGET_PGS;
-	rq->cmd[6] = (stpg_len >> 24) & 0xff;
-	rq->cmd[7] = (stpg_len >> 16) & 0xff;
-	rq->cmd[8] = (stpg_len >>  8) & 0xff;
-	rq->cmd[9] = stpg_len & 0xff;
+	put_unaligned_be32(stpg_len, &rq->cmd[6]);
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
-	rq->end_io_data = h;
+	rq->sense_len = 0;
+
+	blk_execute_rq(rq->q, NULL, rq, 1);
+	if (rq->errors)
+		err = rq->errors;
+
+	blk_put_request(rq);
 
-	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
-	return SCSI_DH_OK;
+	return err;
 }
 
 /*
@@ -498,7 +450,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
 
 	if (retval) {
-		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+		if (!(driver_byte(retval) & DRIVER_SENSE) ||
+		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					  &sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
@@ -624,6 +577,69 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 }
 
 /*
+ * alua_stpg - Issue a SET TARGET GROUP STATES command
+ *
+ * Issue a SET TARGET GROUP STATES command and evaluate the
+ * response. Returns SCSI_DH_RETRY per default to trigger
+ * a re-evaluation of the target group state.
+ */
+static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
+{
+	int retval;
+	struct scsi_sense_hdr sense_hdr;
+
+	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
+		/* Only implicit ALUA supported, retry */
+		return SCSI_DH_RETRY;
+	}
+	switch (h->state) {
+	case TPGS_STATE_OPTIMIZED:
+		return SCSI_DH_OK;
+	case TPGS_STATE_NONOPTIMIZED:
+		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
+		    (!h->pref) &&
+		    (h->tpgs & TPGS_MODE_IMPLICIT))
+			return SCSI_DH_OK;
+		break;
+	case TPGS_STATE_STANDBY:
+	case TPGS_STATE_UNAVAILABLE:
+		break;
+	case TPGS_STATE_OFFLINE:
+		return SCSI_DH_IO;
+		break;
+	case TPGS_STATE_TRANSITIONING:
+		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: stpg failed, unhandled TPGS state %d",
+			    ALUA_DH_NAME, h->state);
+		return SCSI_DH_NOSYS;
+		break;
+	}
+	/* Set state to transitioning */
+	h->state = TPGS_STATE_TRANSITIONING;
+	retval = submit_stpg(sdev, h->group_id, h->sense);
+
+	if (retval) {
+		if (!(driver_byte(retval) & DRIVER_SENSE) ||
+		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: stpg failed, result %d",
+				    ALUA_DH_NAME, retval);
+			if (driver_byte(retval) == DRIVER_BUSY)
+				return SCSI_DH_DEV_TEMP_BUSY;
+		} else {
+			sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
+				    ALUA_DH_NAME);
+			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+		}
+	}
+	/* Retry RTPG */
+	return SCSI_DH_RETRY;
+}
+
+/*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
  *
@@ -700,7 +716,6 @@ static int alua_activate(struct scsi_device *sdev,
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
-	int stpg = 0;
 
 	err = alua_rtpg(sdev, h, 1);
 	if (err != SCSI_DH_OK)
@@ -709,39 +724,9 @@ static int alua_activate(struct scsi_device *sdev,
 	if (optimize_stpg)
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT) {
-		switch (h->state) {
-		case TPGS_STATE_NONOPTIMIZED:
-			stpg = 1;
-			if ((h->flags & ALUA_OPTIMIZE_STPG) &&
-			    (!h->pref) &&
-			    (h->tpgs & TPGS_MODE_IMPLICIT))
-				stpg = 0;
-			break;
-		case TPGS_STATE_STANDBY:
-		case TPGS_STATE_UNAVAILABLE:
-			stpg = 1;
-			break;
-		case TPGS_STATE_OFFLINE:
-			err = SCSI_DH_IO;
-			break;
-		case TPGS_STATE_TRANSITIONING:
-			err = SCSI_DH_RETRY;
-			break;
-		default:
-			break;
-		}
-	}
-
-	if (stpg) {
-		h->callback_fn = fn;
-		h->callback_data = data;
-		err = submit_stpg(h);
-		if (err == SCSI_DH_OK)
-			return 0;
-		h->callback_fn = h->callback_data = NULL;
-	}
-
+	err = alua_stpg(sdev, h);
+	if (err == SCSI_DH_RETRY)
+		err = alua_rtpg(sdev, h, 1);
 out:
 	if (fn)
 		fn(data, err);
-- 
1.8.5.2

