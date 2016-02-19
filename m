From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 03/23] scsi_dh_alua: Make stpg synchronous
Date: Fri, 19 Feb 2016 09:17:00 +0100
Message-ID: <1455869840-122786-4-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427009AbcBSIRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:44 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The 'activate_complete' function needs to be executed after
stpg has finished, so we can as well execute stpg synchronously
and call the function directly.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 158 ++++++++++-------------------
 1 file changed, 54 insertions(+), 104 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 136bc76..467c2cf 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -169,81 +169,28 @@ done:
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
-		if (sense_hdr.sense_key == NOT_READY &&
-		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
-			/* ALUA state transition already in progress */
-			err = SCSI_DH_OK;
-			goto done;
-		}
-		if (sense_hdr.sense_key == UNIT_ATTENTION) {
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
- * submit_stpg - Issue a SET TARGET GROUP STATES command
+ * submit_stpg - Issue a SET TARGET PORT GROUP command
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
-	put_unaligned_be16(h->group_id, &h->buff[6]);
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
@@ -251,13 +198,17 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	put_unaligned_be32(stpg_len, &rq->cmd[6]);
 	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
 
-	rq->sense = h->sense;
+	rq->sense = sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
-	rq->end_io_data = h;
 
-	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
-	return SCSI_DH_OK;
+	blk_execute_rq(rq->q, NULL, rq, 1);
+	if (rq->errors)
+		err = rq->errors;
+
+	blk_put_request(rq);
+
+	return err;
 }
 
 /*
@@ -582,59 +533,59 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
  * alua_stpg - Issue a SET TARGET PORT GROUP command
  *
  * Issue a SET TARGET PORT GROUP command and evaluate the
- * response. Returns SCSI_DH_RETRY if the target port group
- * state is found to be in 'transitioning'.
- * If SCSI_DH_OK is returned the passed-in 'fn' function
- * this function will take care of executing 'fn'.
- * Otherwise 'fn' should be executed by the caller with the
- * returned error code.
+ * response. Returns SCSI_DH_RETRY per default to trigger
+ * a re-evaluation of the target group state or SCSI_DH_OK
+ * if no further action needs to be taken.
  */
-static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h,
-			  activate_complete fn, void *data)
+static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err = SCSI_DH_OK;
-	int stpg = 0;
-
-	if (!(h->tpgs & TPGS_MODE_EXPLICIT))
-		/* Only implicit ALUA supported */
-		goto out;
+	int retval;
+	struct scsi_sense_hdr sense_hdr;
 
+	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
+		/* Only implicit ALUA supported, retry */
+		return SCSI_DH_RETRY;
+	}
 	switch (h->state) {
+	case TPGS_STATE_OPTIMIZED:
+		return SCSI_DH_OK;
 	case TPGS_STATE_NONOPTIMIZED:
-		stpg = 1;
 		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
 		    !h->pref &&
 		    (h->tpgs & TPGS_MODE_IMPLICIT))
-			stpg = 0;
+			return SCSI_DH_OK;
 		break;
 	case TPGS_STATE_STANDBY:
 	case TPGS_STATE_UNAVAILABLE:
-		stpg = 1;
 		break;
 	case TPGS_STATE_OFFLINE:
-		err = SCSI_DH_IO;
-		break;
+		return SCSI_DH_IO;
 	case TPGS_STATE_TRANSITIONING:
-		err = SCSI_DH_RETRY;
 		break;
 	default:
-		break;
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: stpg failed, unhandled TPGS state %d",
+			    ALUA_DH_NAME, h->state);
+		return SCSI_DH_NOSYS;
 	}
+	retval = submit_stpg(sdev, h->group_id, h->sense);
 
-	if (stpg) {
-		h->callback_fn = fn;
-		h->callback_data = data;
-		err = submit_stpg(h);
-		if (err != SCSI_DH_OK)
-			h->callback_fn = h->callback_data = NULL;
-		else
-			fn = NULL;
+	if (retval) {
+		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
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
 	}
-out:
-	if (fn)
-		fn(data, err);
-
-	return err;
+	/* Retry RTPG */
+	return SCSI_DH_RETRY;
 }
 
 /*
@@ -722,10 +673,9 @@ static int alua_activate(struct scsi_device *sdev,
 	if (optimize_stpg)
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
-	err = alua_stpg(sdev, h, fn, data);
-
+	err = alua_stpg(sdev, h);
 out:
-	if (err != SCSI_DH_OK && fn)
+	if (fn)
 		fn(data, err);
 	return 0;
 }
-- 
1.8.5.6

