From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/17] scsi_dh_alua: switch to scsi_execute()
Date: Mon,  4 May 2015 14:42:15 +0200
Message-ID: <1430743343-47174-10-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbbEDMmk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:40 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

All commands are issued synchronously, so no need to open-code
scsi_execute anymore.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 119 +++++++----------------------
 1 file changed, 26 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 0b8e111..0cc18e3 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -103,80 +103,29 @@ static int realloc_buffer(struct alua_dh_data *h, unsigned len)
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
+static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 			    int bufflen, unsigned char *sense, int flags)
 {
-	struct request *rq;
-	int err;
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
-	rq->cmd[6] = (bufflen >> 24) & 0xff;
-	rq->cmd[7] = (bufflen >> 16) & 0xff;
-	rq->cmd[8] = (bufflen >>  8) & 0xff;
-	rq->cmd[9] = bufflen & 0xff;
-	rq->cmd_len = COMMAND_SIZE(MAINTENANCE_IN);
-
-	rq->sense = sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = 0;
-
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err < 0) {
-		if (!rq->errors)
-			err = DID_ERROR << 16;
-		else
-			err = rq->errors;
-		if (rq->sense_len)
-			err |= (DRIVER_SENSE << 24);
-	}
-	blk_put_request(rq);
-done:
-	return err;
+		cdb[1] = MI_REPORT_TARGET_PGS;
+	put_unaligned_be32(bufflen, &cdb[6]);
+
+	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen,
+			    sense, ALUA_FAILOVER_TIMEOUT * HZ,
+			    ALUA_FAILOVER_RETRIES, req_flags, NULL);
 }
 
 /*
@@ -186,45 +135,29 @@ done:
  * to 'active/optimized' and let the array firmware figure out
  * the states of the remaining groups.
  */
-static unsigned submit_stpg(struct scsi_device *sdev, int group_id,
-			    unsigned char *sense)
+static int submit_stpg(struct scsi_device *sdev, int group_id,
+		       unsigned char *sense)
 {
-	struct request *rq;
+	u8 cdb[COMMAND_SIZE(MAINTENANCE_OUT)];
 	unsigned char stpg_data[8];
 	int stpg_len = 8;
-	int err;
+	int req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+		REQ_FAILFAST_DRIVER;
 
 	/* Prepare the data buffer */
 	memset(stpg_data, 0, stpg_len);
 	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
 	put_unaligned_be16(group_id, &stpg_data[6]);
 
-	rq = get_alua_req(sdev, stpg_data, stpg_len, WRITE);
-	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
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
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err < 0) {
-		if (!rq->errors)
-			err = DID_ERROR << 16;
-		else
-			err = rq->errors;
-		if (rq->sense_len)
-			err |= (DRIVER_SENSE << 24);
-	}
-	blk_put_request(rq);
-
-	return err;
+	memset(cdb, 0x0, COMMAND_SIZE(MAINTENANCE_OUT));
+	cdb[0] = MAINTENANCE_OUT;
+	cdb[1] = MO_SET_TARGET_PGS;
+	put_unaligned_be32(stpg_len, &cdb[6]);
+
+	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len,
+			    sense, ALUA_FAILOVER_TIMEOUT * HZ,
+			    ALUA_FAILOVER_RETRIES, req_flags, NULL);
 }
 
 /*
-- 
1.8.5.2

