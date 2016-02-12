From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 05/23] scsi_dh_alua: switch to scsi_execute_req_flags()
Date: Fri, 12 Feb 2016 09:25:28 +0100
Message-ID: <1455265546-44470-6-git-send-email-hare@suse.de>
References: <1455265546-44470-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbcBLIZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 03:25:50 -0500
In-Reply-To: <1455265546-44470-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

All commands are issued synchronously, so no need to open-code
scsi_execute_req_flags() anymore. And we can get rid of the
static sense code structure element. scsi_execute_req_flags()
will be setting REQ_QUIET and REQ_PREEMPT, but that is
perfectly fine as we're evaluating and logging any errors
ourselves and we really need to send the command even if
the device is quiesced.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ewan Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 125 +++++++++--------------------
 1 file changed, 36 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 77e23a4..2101518 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -75,7 +75,6 @@ struct alua_dh_data {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
-	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
@@ -101,71 +100,30 @@ static int realloc_buffer(struct alua_dh_data *h, unsigned len)
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
+	u8 cdb[COMMAND_SIZE(MAINTENANCE_IN)];
+	int req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+		REQ_FAILFAST_DRIVER;
 
 	/* Prepare the command. */
-	rq->cmd[0] = MAINTENANCE_IN;
+	memset(cdb, 0x0, COMMAND_SIZE(MAINTENANCE_IN));
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
-
-	blk_execute_rq(rq->q, NULL, rq, 1);
-	if (rq->errors)
-		err = rq->errors;
-	blk_put_request(rq);
-done:
-	return err;
+		cdb[1] = MI_REPORT_TARGET_PGS;
+	put_unaligned_be32(bufflen, &cdb[6]);
+
+	return scsi_execute_req_flags(sdev, cdb, DMA_FROM_DEVICE,
+				      buff, bufflen, sshdr,
+				      ALUA_FAILOVER_TIMEOUT * HZ,
+				      ALUA_FAILOVER_RETRIES, NULL, req_flags);
 }
 
 /*
@@ -175,40 +133,30 @@ done:
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
@@ -398,14 +346,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	retval = submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->flags);
+	retval = submit_rtpg(sdev, h->buff, h->bufflen, &sense_hdr, h->flags);
+
 	if (retval) {
-		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					  &sense_hdr)) {
+		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
 				    ALUA_DH_NAME, retval);
-			if (driver_byte(retval) == DRIVER_BUSY)
+			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
 		}
@@ -570,15 +518,14 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		return SCSI_DH_NOSYS;
 		break;
 	}
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

