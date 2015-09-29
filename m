From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/36] scsi_dh_alua: Use vpd_pg83 information
Date: Tue, 29 Sep 2015 12:47:06 +0200
Message-ID: <1443523658-87622-5-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041AbbI2Kru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:50 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

The SCSI device now has the VPD page 0x83 information attached,
so there is no need to query it again.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 83 +++++-------------------------
 1 file changed, 13 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7d01ef0..f15b977 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -131,43 +131,6 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 }
 
 /*
- * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
- * @sdev: sdev the command should be sent to
- */
-static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
-{
-	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
-		goto done;
-
-	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 1;
-	rq->cmd[2] = 0x83;
-	rq->cmd[4] = h->bufflen;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
-
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: evpd inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
-	}
-	blk_put_request(rq);
-done:
-	return err;
-}
-
-/*
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
@@ -359,43 +322,24 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 }
 
 /*
- * alua_vpd_inquiry - Evaluate INQUIRY vpd page 0x83
+ * alua_check_vpd - Evaluate INQUIRY vpd page 0x83
  * @sdev: device to be checked
  *
  * Extract the relative target port and the target port group
  * descriptor from the list of identificators.
  */
-static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int len;
-	unsigned err;
 	unsigned char *d;
 
- retry:
-	err = submit_vpd_inquiry(sdev, h);
-
-	if (err != SCSI_DH_OK)
-		return err;
-
-	/* Check if vpd page exceeds initial buffer */
-	len = (h->buff[2] << 8) + h->buff[3] + 4;
-	if (len > h->bufflen) {
-		/* Resubmit with the correct length */
-		if (realloc_buffer(h, len)) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: kmalloc buffer failed\n",
-				    ALUA_DH_NAME);
-			/* Temporary failure, bypass */
-			return SCSI_DH_DEV_TEMP_BUSY;
-		}
-		goto retry;
-	}
+	if (!sdev->vpd_pg83)
+		return SCSI_DH_DEV_UNSUPP;
 
 	/*
-	 * Now look for the correct descriptor.
+	 * Look for the correct descriptor.
 	 */
-	d = h->buff + 4;
-	while (d < h->buff + len) {
+	d = sdev->vpd_pg83 + 4;
+	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
@@ -422,14 +366,13 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME);
 		h->state = TPGS_STATE_OPTIMIZED;
 		h->tpgs = TPGS_MODE_NONE;
-		err = SCSI_DH_DEV_UNSUPP;
-	} else {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: port group %02x rel port %02x\n",
-			    ALUA_DH_NAME, h->group_id, h->rel_port);
+		return SCSI_DH_DEV_UNSUPP;
 	}
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x rel port %02x\n",
+		    ALUA_DH_NAME, h->group_id, h->rel_port);
 
-	return err;
+	return 0;
 }
 
 static char print_alua_state(int state)
@@ -692,7 +635,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	if (err != SCSI_DH_OK)
 		goto out;
 
-	err = alua_vpd_inquiry(sdev, h);
+	err = alua_check_vpd(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto out;
 
-- 
1.8.5.6

