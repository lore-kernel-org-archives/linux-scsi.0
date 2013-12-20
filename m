From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/16] scsi_dh_alua: Improve error handling
Date: Fri, 20 Dec 2013 13:13:26 +0100
Message-ID: <1387541621-54967-2-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab3LTMNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:43 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

Improve error handling and use standard logging functions
instead of hand-crafted ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 150 +++++++++++++++++++----------
 1 file changed, 98 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5248c88..e4e5497 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 
@@ -144,11 +145,13 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
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
 	rq->cmd[0] = INQUIRY;
@@ -162,12 +165,12 @@ static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	rq->sense_len = h->senselen = 0;
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: evpd inquiry failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+	if (err < 0) {
+		if (!rq->errors)
+			err = DID_ERROR << 16;
+		else
+			err = rq->errors;
 		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
 	}
 	blk_put_request(rq);
 done:
@@ -182,11 +185,13 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
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
@@ -205,12 +210,12 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 	rq->sense_len = h->senselen = 0;
 
 	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
+	if (err < 0) {
+		if (!rq->errors)
+			err = DID_ERROR << 16;
+		else
+			err = rq->errors;
 		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
 	}
 	blk_put_request(rq);
 done:
@@ -218,13 +223,11 @@ done:
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
@@ -239,9 +242,8 @@ static void stpg_endio(struct request *req, int error)
 	}
 
 	if (req->sense_len > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
-		if (!err) {
+		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr)) {
 			err = SCSI_DH_IO;
 			goto done;
 		}
@@ -250,10 +252,12 @@ static void stpg_endio(struct request *req, int error)
 			err = SCSI_DH_RETRY;
 			goto done;
 		}
-		sdev_printk(KERN_INFO, h->sdev,
-			    "%s: stpg sense code: %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
+		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
+			    ALUA_DH_NAME);
+		scsi_show_sense_hdr(&sense_hdr);
+		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed, ",
+			    ALUA_DH_NAME);
+		scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
 		err = SCSI_DH_IO;
 	} else if (error)
 		err = SCSI_DH_IO;
@@ -362,15 +366,43 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
  */
 static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int len;
-	unsigned err;
+	int len, timeout = ALUA_FAILOVER_TIMEOUT;
+	struct scsi_sense_hdr sense_hdr;
+	unsigned retval;
 	unsigned char *d;
+	unsigned long expiry;
 
+	expiry = round_jiffies_up(jiffies + timeout);
  retry:
-	err = submit_vpd_inquiry(sdev, h);
-
-	if (err != SCSI_DH_OK)
-		return err;
+	retval = submit_vpd_inquiry(sdev, h);
+	if (retval) {
+		unsigned err;
+
+		if (h->senselen == 0 ||
+		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: evpd inquiry failed, ", ALUA_DH_NAME);
+			scsi_show_result(retval);
+			if (driver_byte(retval) == DRIVER_BUSY)
+				err = SCSI_DH_DEV_TEMP_BUSY;
+			else
+				err = SCSI_DH_IO;
+			return err;
+		}
+		err = alua_check_sense(sdev, &sense_hdr);
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
+			goto retry;
+		if (err != SUCCESS) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: evpd inquiry failed, ", ALUA_DH_NAME);
+			scsi_show_sense_hdr(&sense_hdr);
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: evpd inquiry failed, ", ALUA_DH_NAME);
+			scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
+			return SCSI_DH_IO;
+		}
+	}
 
 	/* Check if vpd page exceeds initial buffer */
 	len = (h->buff[2] << 8) + h->buff[3] + 4;
@@ -417,14 +449,13 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
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
+	return SCSI_DH_OK;
 }
 
 static char print_alua_state(int state)
@@ -533,7 +564,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
-	unsigned err;
+	unsigned err, retval;
 	bool rtpg_ext_hdr_req = 1;
 	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
@@ -545,13 +576,21 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		expiry = round_jiffies_up(jiffies + h->transition_tmo * HZ);
 
  retry:
-	err = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
+	retval = submit_rtpg(sdev, h, rtpg_ext_hdr_req);
 
-	if (err == SCSI_DH_IO && h->senselen > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
-		if (!err)
-			return SCSI_DH_IO;
+	if (retval) {
+		if (h->senselen == 0 ||
+		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					  &sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
+				    ALUA_DH_NAME);
+			scsi_show_result(retval);
+			if (driver_byte(retval) == DRIVER_BUSY)
+				err = SCSI_DH_DEV_TEMP_BUSY;
+			else
+				err = SCSI_DH_IO;
+			return err;
+		}
 
 		/*
 		 * submit_rtpg() has failed on existing arrays
@@ -569,16 +608,23 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 		}
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry, ",
+				    ALUA_DH_NAME);
+			scsi_show_sense_hdr(&sense_hdr);
+			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry, ",
+				    ALUA_DH_NAME);
+			scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
 			goto retry;
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: rtpg sense code %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
-		err = SCSI_DH_IO;
+		}
+		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
+			    ALUA_DH_NAME);
+		scsi_show_sense_hdr(&sense_hdr);
+		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
+			    ALUA_DH_NAME);
+		scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
+		return SCSI_DH_IO;
 	}
-	if (err != SCSI_DH_OK)
-		return err;
 
 	len = (h->buff[0] << 24) + (h->buff[1] << 16) +
 		(h->buff[2] << 8) + h->buff[3] + 4;
-- 
1.7.12.4

