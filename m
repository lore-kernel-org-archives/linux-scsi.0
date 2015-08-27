From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/23] scsi_dh_alua: return standard SCSI return codes in submit_rtpg
Date: Thu, 27 Aug 2015 14:41:03 +0200
Message-ID: <1440679281-13234-6-git-send-email-hare@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbbH0MlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:25 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Fixup submit_rtpg() to always return a standard SCSI return code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 38 +++++++++++++++++-------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7b43ee3..c41d662 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -139,11 +139,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 			    bool rtpg_ext_hdr_req)
 {
 	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err = 0;
 
 	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
+	if (!rq) {
+		err = DRIVER_BUSY << 24;
 		goto done;
+	}
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
@@ -161,13 +163,10 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = h->senselen = 0;
 
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+	blk_execute_rq(rq->q, NULL, rq, 1);
+	if (rq->errors) {
+		err = rq->errors;
 		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
 	}
 	blk_put_request(rq);
 done:
@@ -489,7 +488,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
-	unsigned err;
+	unsigned err, retval;
 	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -501,13 +500,20 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
-
-	if (err == SCSI_DH_IO && h->senselen > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
-		if (!err)
-			return SCSI_DH_IO;
+	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
+
+	if (retval) {
+		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: rtpg failed, result %d\n",
+				    ALUA_DH_NAME, retval);
+			if (driver_byte(retval) == DRIVER_BUSY)
+				err = SCSI_DH_DEV_TEMP_BUSY;
+			else
+				err = SCSI_DH_IO;
+			return err;
+		}
 
 		/*
 		 * submit_rtpg() has failed on existing arrays
-- 
1.8.5.6

