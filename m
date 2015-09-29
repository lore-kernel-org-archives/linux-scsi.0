From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/36] scsi_dh_alua: return standard SCSI return codes in submit_rtpg
Date: Tue, 29 Sep 2015 12:47:10 +0200
Message-ID: <1443523658-87622-9-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934644AbbI2Krw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:52 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Fixup submit_rtpg() to always return a standard SCSI return code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 33 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 018faf0..d4e5691 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -138,11 +138,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
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
@@ -160,13 +162,9 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
-		err = SCSI_DH_IO;
-	}
+	blk_execute_rq(rq->q, NULL, rq, 1);
+	if (rq->errors)
+		err = rq->errors;
 	blk_put_request(rq);
 done:
 	return err;
@@ -487,7 +485,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
-	unsigned err;
+	unsigned err, retval;
 	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -499,12 +497,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
-
-	if (err == SCSI_DH_IO) {
+	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
+	if (retval) {
 		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					  &sense_hdr))
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: rtpg failed, result %d\n",
+				    ALUA_DH_NAME, retval);
+			if (driver_byte(retval) == DRIVER_BUSY)
+				return SCSI_DH_DEV_TEMP_BUSY;
 			return SCSI_DH_IO;
+		}
 
 		/*
 		 * submit_rtpg() has failed on existing arrays
@@ -533,8 +536,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 		return SCSI_DH_IO;
 	}
-	if (err != SCSI_DH_OK)
-		return err;
 
 	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
 		(h->buff[2] << 8) + h->buff[3] + 4;
-- 
1.8.5.6

