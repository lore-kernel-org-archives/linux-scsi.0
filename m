From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/7] scsi_dh_alua: Evaluate TPGS setting from inquiry data
Date: Wed, 24 Aug 2011 10:51:13 +0200
Message-ID: <1314175879-16565-2-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab1HXIvj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:39 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Instead of issuing a standard inquiry from within the
alua device handler we can evaluate the TPGS setting from
the existing inquiry data of the sdev and save us the I/O.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   55 +++-------------------------
 include/scsi/scsi_device.h                 |    5 +++
 2 files changed, 11 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6fec9fe..4326778 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -128,43 +128,6 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 }
 
 /*
- * submit_std_inquiry - Issue a standard INQUIRY command
- * @sdev: sdev the command should be send to
- */
-static int submit_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
-{
-	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq = get_alua_req(sdev, h->inq, ALUA_INQUIRY_SIZE, READ);
-	if (!rq)
-		goto done;
-
-	/* Prepare the command. */
-	rq->cmd[0] = INQUIRY;
-	rq->cmd[1] = 0;
-	rq->cmd[2] = 0;
-	rq->cmd[4] = ALUA_INQUIRY_SIZE;
-	rq->cmd_len = COMMAND_SIZE(INQUIRY);
-
-	rq->sense = h->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = h->senselen = 0;
-
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: std inquiry failed with %x\n",
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
  * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
  * @sdev: sdev the command should be sent to
  */
@@ -338,23 +301,17 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 }
 
 /*
- * alua_std_inquiry - Evaluate standard INQUIRY command
+ * alua_check_tpgs - Evaluate TPGS setting
  * @sdev: device to be checked
  *
- * Just extract the TPGS setting to find out if ALUA
+ * Examine the TPGS setting of the sdev to find out if ALUA
  * is supported.
  */
-static int alua_std_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err;
-
-	err = submit_std_inquiry(sdev, h);
-
-	if (err != SCSI_DH_OK)
-		return err;
+	int err = SCSI_DH_OK;
 
-	/* Check TPGS setting */
-	h->tpgs = (h->inq[5] >> 4) & 0x3;
+	h->tpgs = scsi_device_tpgs(sdev);
 	switch (h->tpgs) {
 	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
 		sdev_printk(KERN_INFO, sdev,
@@ -642,7 +599,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err;
 
-	err = alua_std_inquiry(sdev, h);
+	err = alua_check_tpgs(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto out;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6712446..4733635 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -472,6 +472,11 @@ static inline int scsi_device_protection(struct scsi_device *sdev)
 	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
+static inline int scsi_device_tpgs(struct scsi_device *sdev)
+{
+	return sdev->inquiry ? (sdev->inquiry[5] >> 4) & 0x3 : 0;
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
-- 
1.6.0.2

