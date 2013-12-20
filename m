From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Fri, 20 Dec 2013 13:13:29 +0100
Message-ID: <1387541621-54967-5-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab3LTMNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:43 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

We should be issuing STPG synchronously as we need to
evaluate the return code on failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 192 +++++++++++++----------------
 1 file changed, 89 insertions(+), 103 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5358c2f..ef92008 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -227,82 +227,27 @@ done:
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
-	if (req->sense_len > 0) {
-		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					  &sense_hdr)) {
-			err = SCSI_DH_IO;
-			goto done;
-		}
-		err = alua_check_sense(h->sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE) {
-			err = SCSI_DH_RETRY;
-			goto done;
-		}
-		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
-			    ALUA_DH_NAME);
-		scsi_show_sense_hdr(&sense_hdr);
-		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
-			    ALUA_DH_NAME);
-		scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
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
+	int err;
 
 	/* Prepare the data buffer */
-	memset(h->buff, 0, stpg_len);
-	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
-	h->buff[6] = (h->group_id >> 8) & 0xff;
-	h->buff[7] = h->group_id & 0xff;
+	memset(stpg_data, 0, stpg_len);
+	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
+	stpg_data[6] = (group_id >> 8) & 0xff;
+	stpg_data[7] = group_id & 0xff;
 
-	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
+	rq = get_alua_req(sdev, stpg_data, stpg_len, WRITE);
 	if (!rq)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
@@ -315,13 +260,22 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	rq->cmd[9] = stpg_len & 0xff;
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
-	rq->end_io_data = h;
+	rq->sense_len = 0;
 
-	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
-	return SCSI_DH_OK;
+	err = blk_execute_rq(rq->q, NULL, rq, 1);
+	if (err < 0) {
+		if (!rq->errors)
+			err = DID_ERROR << 16;
+		else
+			err = rq->errors;
+		if (rq->sense_len)
+			err |= (DRIVER_SENSE << 24);
+	}
+	blk_put_request(rq);
+
+	return err;
 }
 
 /*
@@ -715,6 +669,69 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
+	int retval, err = SCSI_DH_RETRY;
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	struct scsi_sense_hdr sense_hdr;
+
+	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
+		/* Only implicit ALUA supported, retry */
+		return SCSI_DH_RETRY;
+	}
+	switch (h->state) {
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
+		return SCSI_DH_RETRY;
+		break;
+	default:
+		return SCSI_DH_NOSYS;
+		break;
+	}
+	/* Set state to transitioning */
+	h->state = TPGS_STATE_TRANSITIONING;
+	retval = submit_stpg(sdev, h->group_id, sense);
+
+	if (retval) {
+		if (!(driver_byte(retval) & DRIVER_SENSE) ||
+		    !scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev, "%s: stpg failed, ",
+				    ALUA_DH_NAME);
+			scsi_show_result(retval);
+			/* Retry RTPG */
+			return err;
+		}
+		err = alua_check_sense(h->sdev, &sense_hdr);
+		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
+			    ALUA_DH_NAME);
+		scsi_show_sense_hdr(&sense_hdr);
+		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
+			    ALUA_DH_NAME);
+		scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
+		err = SCSI_DH_RETRY;
+	}
+	return err;
+}
+
+/*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
  *
@@ -791,7 +808,6 @@ static int alua_activate(struct scsi_device *sdev,
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int err = SCSI_DH_OK;
-	int stpg = 0;
 
 	err = alua_rtpg(sdev, h, 1);
 	if (err != SCSI_DH_OK)
@@ -800,39 +816,9 @@ static int alua_activate(struct scsi_device *sdev,
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
+		err = alua_rtpg(sdev, h);
 out:
 	if (fn)
 		fn(data, err);
-- 
1.7.12.4

