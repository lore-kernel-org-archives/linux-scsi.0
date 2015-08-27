From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/23] scsi_dh_alua: switch to scsi_execute_req_flags()
Date: Thu, 27 Aug 2015 14:41:10 +0200
Message-ID: <1440679281-13234-13-git-send-email-hare@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbbH0Ml1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:27 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

All commands are issued synchronously, so no need to open-code
scsi_execute_req_flags() anymore. And we can get rid of the
static sense code structure element.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 124 ++++++++---------------------
 1 file changed, 34 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fd0385e..ef4363a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -75,8 +75,6 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
-	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
-	int			senselen;
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -103,72 +101,30 @@ static int realloc_buffer(struct alua_dh_data *h, unsigned len)
 	return 0;
 }
 
-static struct request *get_alua_req(struct scsi_device *sdev,
-				    void *buffer, unsigned buflen, int rw)
-{
-	struct request *rq;
-	struct request_queue *q = sdev->request_queue;
-
-	rq = blk_get_request(q, rw, GFP_NOIO);
-
-	if (IS_ERR(rq)) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: blk_get_request failed\n", __func__);
-		return NULL;
-	}
-	blk_rq_set_block_pc(rq);
-
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
-		blk_put_request(rq);
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: blk_rq_map_kern failed\n", __func__);
-		return NULL;
-	}
-
-	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER;
-	rq->retries = ALUA_FAILOVER_RETRIES;
-	rq->timeout = ALUA_FAILOVER_TIMEOUT * HZ;
-
-	return rq;
-}
-
 /*
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
-static unsigned submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-			    int bufflen, unsigned char *sense, int flags)
+static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
+		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
 {
-	struct request *rq;
-	int err = 0;
-
-	rq = get_alua_req(sdev, buff, bufflen, READ);
-	if (!rq) {
-		err = DRIVER_BUSY << 24;
-		goto done;
-	}
+	u8 cdb[16];
+	int req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+		REQ_FAILFAST_DRIVER;
 
 	/* Prepare the command. */
-	rq->cmd[0] = MAINTENANCE_IN;
+	memset(cdb, 0x0, 16);
+	cdb[0] = MAINTENANCE_IN;
 	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
-		rq->cmd[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
+		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	else
-		rq->cmd[1] = MI_REPORT_TARGET_PGS;
-	put_unaligned_be32(bufflen, &rq->cmd[6]);
-	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
-
-	rq->sense = sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
+		cdb[1] = MI_REPORT_TARGET_PGS;
+	put_unaligned_be32(bufflen, &cdb[6]);
 
-	blk_execute_rq(rq->q, NULL, rq, 1);
-	if (rq->errors)
-		err = rq->errors;
-
-	blk_put_request(rq);
-done:
-	return err;
+	return scsi_execute_req_flags(sdev, cdb, DMA_FROM_DEVICE,
+				      buff, bufflen, sshdr,
+				      ALUA_FAILOVER_TIMEOUT * HZ,
+				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
 }
 
 /*
@@ -178,40 +134,30 @@ done:
  * to 'active/optimized' and let the array firmware figure out
  * the states of the remaining groups.
  */
-static unsigned submit_stpg(struct scsi_device *sdev, int group_id,
-			    unsigned char *sense)
+static int submit_stpg(struct scsi_device *sdev, int group_id,
+		       struct scsi_sense_hdr *sshdr)
 {
-	struct request *rq;
+	u8 cdb[COMMAND_SIZE(MAINTENANCE_OUT)];
 	unsigned char stpg_data[8];
 	int stpg_len = 8;
-	int err = 0;
+	int req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+		REQ_FAILFAST_DRIVER;
 
 	/* Prepare the data buffer */
 	memset(stpg_data, 0, stpg_len);
 	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
 	put_unaligned_be16(group_id, &stpg_data[6]);
 
-	rq = get_alua_req(sdev, stpg_data, stpg_len, WRITE);
-	if (!rq)
-		return DRIVER_BUSY << 24;
-
 	/* Prepare the command. */
-	rq->cmd[0] = MAINTENANCE_OUT;
-	rq->cmd[1] = MO_SET_TARGET_PGS;
-	put_unaligned_be32(stpg_len, &rq->cmd[6]);
-	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_OUT);
-
-	rq->sense = sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
-
-	blk_execute_rq(rq->q, NULL, rq, 1);
-	if (rq->errors)
-		err = rq->errors;
-
-	blk_put_request(rq);
-
-	return err;
+	memset(cdb, 0x0, COMMAND_SIZE(MAINTENANCE_OUT));
+	cdb[0] = MAINTENANCE_OUT;
+	cdb[1] = MO_SET_TARGET_PGS;
+	put_unaligned_be32(stpg_len, &cdb[6]);
+
+	return scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
+				      stpg_data, stpg_len,
+				      sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
+				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
 }
 
 /*
@@ -447,15 +393,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, &sense_hdr, h->flags);
 
 	if (retval) {
-		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					  &sense_hdr)) {
+		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
-			if (driver_byte(retval) == DRIVER_BUSY)
+			if (driver_byte(retval) == DRIVER_ERROR)
 				err = SCSI_DH_DEV_TEMP_BUSY;
 			else
 				err = SCSI_DH_IO;
@@ -616,15 +561,14 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	}
 	/* Set state to transitioning */
 	h->state = TPGS_STATE_TRANSITIONING;
-	retval = submit_stpg(sdev, h->group_id, h->sense);
+	retval = submit_stpg(sdev, h->group_id, &sense_hdr);
 
 	if (retval) {
-		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					  &sense_hdr)) {
+		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: stpg failed, result %d",
 				    ALUA_DH_NAME, retval);
-			if (driver_byte(retval) == DRIVER_BUSY)
+			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
 		} else {
 			sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
-- 
1.8.5.6

