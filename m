From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/20] scsi_dh_alua: Improve error handling
Date: Wed,  8 Jul 2015 11:06:02 +0200
Message-ID: <1436346378-96518-5-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbbGHJG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:26 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Improve error handling and use standard logging functions
instead of hand-crafted ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 78 +++++++++++++++---------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a20c8bf..0b92319 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 
@@ -138,11 +139,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 			    bool rtpg_ext_hdr_req)
 {
 	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err;
 
 	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
+	if (!rq) {
+		err = DRIVER_BUSY << 24;
 		goto done;
+	}
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_IN;
@@ -160,13 +163,10 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
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
@@ -174,13 +174,11 @@ done:
 }
 
 /*
- * alua_stpg - Evaluate SET TARGET GROUP STATES
+ * stpg_endio - Evaluate SET TARGET GROUP STATES
  * @sdev: the device to be evaluated
  * @state: the new target group state
  *
- * Send a SET TARGET GROUP STATES command to the device.
- * We only have to test here if we should resubmit the command;
- * any other error is assumed as a failure.
+ * Evaluate a SET TARGET GROUP STATES command response.
  */
 static void stpg_endio(struct request *req, int error)
 {
@@ -194,22 +192,16 @@ static void stpg_endio(struct request *req, int error)
 		goto done;
 	}
 
-	if (req->sense_len > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
-		if (!err) {
-			err = SCSI_DH_IO;
-			goto done;
-		}
+	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+				 &sense_hdr)) {
 		err = alua_check_sense(h->sdev, &sense_hdr);
 		if (err == ADD_TO_MLQUEUE) {
 			err = SCSI_DH_RETRY;
 			goto done;
 		}
-		sdev_printk(KERN_INFO, h->sdev,
-			    "%s: stpg sense code: %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
+		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
+			    ALUA_DH_NAME);
+		scsi_print_sense_hdr(h->sdev, ALUA_DH_NAME, &sense_hdr);
 		err = SCSI_DH_IO;
 	} else if (error)
 		err = SCSI_DH_IO;
@@ -494,7 +486,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
-	unsigned err;
+	unsigned err, retval;
 	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -506,13 +498,20 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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
@@ -530,16 +529,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		}
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
+				    ALUA_DH_NAME);
+			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 			goto retry;
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg sense code %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
-		err = SCSI_DH_IO;
+		}
+		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
+			    ALUA_DH_NAME);
+		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+		return SCSI_DH_IO;
 	}
-	if (err != SCSI_DH_OK)
-		return err;
 
 	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
 		(h->buff[2] << 8) + h->buff[3] + 4;
-- 
1.8.5.2

