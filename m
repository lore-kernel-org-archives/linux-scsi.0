From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 4/8] scsi_dh: Update hp_sw hardware handler
Date: Thu, 17 Jul 2008 09:38:26 +0200
Message-ID: <20080717073827.155C018C6FD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:37832 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416AbYGQHi2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 03:38:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


This patch updates the hp_sw device handler to properly
check the return codes etc.
And adds the 'correct' machine definitions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  272 +++++++++++++++++++++++----
 1 files changed, 234 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 78259bc..9c7a1f8 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2006 Red Hat, Inc.  All rights reserved.
  * Copyright (C) 2006 Mike Christie
+ * Copyright (C) 2008 Hannes Reinecke <hare@suse.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -25,13 +26,18 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 
-#define HP_SW_NAME	"hp_sw"
+#define HP_SW_NAME			"hp_sw"
 
-#define HP_SW_TIMEOUT (60 * HZ)
-#define HP_SW_RETRIES 3
+#define HP_SW_TIMEOUT			(60 * HZ)
+#define HP_SW_RETRIES			3
+
+#define HP_SW_PATH_UNINITIALIZED	-1
+#define HP_SW_PATH_ACTIVE		0
+#define HP_SW_PATH_PASSIVE		1
 
 struct hp_sw_dh_data {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	int path_state;
 	int retries;
 };
 
@@ -42,51 +48,161 @@ static inline struct hp_sw_dh_data *get_hp_sw_data(struct scsi_device *sdev)
 	return ((struct hp_sw_dh_data *) scsi_dh_data->buf);
 }
 
-static int hp_sw_done(struct scsi_device *sdev)
+/*
+ * tur_done - Handle TEST UNIT READY return status
+ * @sdev: sdev the command has been sent to
+ * @errors: blk error code
+ *
+ * Returns SCSI_DH_DEV_OFFLINED if the sdev is on the passive path
+ */
+static int tur_done(struct scsi_device *sdev, unsigned char *sense)
 {
-	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
 	struct scsi_sense_hdr sshdr;
-	int rc;
-
-	sdev_printk(KERN_INFO, sdev, "hp_sw_done\n");
+	int ret;
 
-	rc = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE, &sshdr);
-	if (!rc)
+	ret = scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr);
+	if (!ret) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending tur failed, no sense available\n",
+			    HP_SW_NAME);
+		ret = SCSI_DH_IO;
 		goto done;
+	}
 	switch (sshdr.sense_key) {
+	case UNIT_ATTENTION:
+		ret = SCSI_DH_IMM_RETRY;
+		break;
 	case NOT_READY:
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
-			rc = SCSI_DH_RETRY;
-			h->retries++;
+		if ((sshdr.asc == 0x04) && (sshdr.ascq == 2)) {
+			/*
+			 * LUN not ready - Initialization command required
+			 *
+			 * This is the passive path
+			 */
+			ret = SCSI_DH_DEV_OFFLINED;
 			break;
 		}
-		/* fall through */
+		/* Fallthrough */
 	default:
-		h->retries++;
-		rc = SCSI_DH_IMM_RETRY;
+		sdev_printk(KERN_WARNING, sdev,
+			   "%s: sending tur failed, sense %x/%x/%x\n",
+			   HP_SW_NAME, sshdr.sense_key, sshdr.asc,
+			   sshdr.ascq);
+		break;
 	}
 
 done:
-	if (rc == SCSI_DH_OK || rc == SCSI_DH_IO)
-		h->retries = 0;
-	else if (h->retries > HP_SW_RETRIES) {
-		h->retries = 0;
+	return ret;
+}
+
+/*
+ * hp_sw_tur - Send TEST UNIT READY
+ * @sdev: sdev command should be sent to
+ *
+ * Use the TEST UNIT READY command to determine
+ * the path state.
+ */
+static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
+{
+	struct request *req;
+	int ret;
+
+	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
+	if (!req)
+		return SCSI_DH_RES_TEMP_UNAVAIL;
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_FAILFAST;
+	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
+	memset(req->cmd, 0, MAX_COMMAND_SIZE);
+	req->cmd[0] = TEST_UNIT_READY;
+	req->timeout = HP_SW_TIMEOUT;
+	req->sense = h->sense;
+	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	req->sense_len = 0;
+
+retry:
+	ret = blk_execute_rq(req->q, NULL, req, 1);
+	if (ret == -EIO) {
+		if (req->sense_len > 0) {
+			ret = tur_done(sdev, h->sense);
+		} else {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: sending tur failed with %x\n",
+				    HP_SW_NAME, req->errors);
+			ret = SCSI_DH_IO;
+		}
+	} else {
+		h->path_state = HP_SW_PATH_ACTIVE;
+		ret = SCSI_DH_OK;
+	}
+	if (ret == SCSI_DH_IMM_RETRY)
+		goto retry;
+	if (ret == SCSI_DH_DEV_OFFLINED) {
+		h->path_state = HP_SW_PATH_PASSIVE;
+		ret = SCSI_DH_OK;
+	}
+
+	blk_put_request(req);
+
+	return ret;
+}
+
+/*
+ * start_done - Handle START STOP UNIT return status
+ * @sdev: sdev the command has been sent to
+ * @errors: blk error code
+ */
+static int start_done(struct scsi_device *sdev, unsigned char *sense)
+{
+	struct scsi_sense_hdr sshdr;
+	int rc;
+
+	rc = scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr);
+	if (!rc) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "%s: sending start_stop_unit failed, "
+			    "no sense available\n",
+			    HP_SW_NAME);
+		return SCSI_DH_IO;
+	}
+	switch (sshdr.sense_key) {
+	case NOT_READY:
+		if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			rc = SCSI_DH_RETRY;
+			break;
+		}
+		/* fall through */
+	default:
+		sdev_printk(KERN_WARNING, sdev,
+			   "%s: sending start_stop_unit failed, sense %x/%x/%x\n",
+			   HP_SW_NAME, sshdr.sense_key, sshdr.asc,
+			   sshdr.ascq);
 		rc = SCSI_DH_IO;
 	}
+
 	return rc;
 }
 
-static int hp_sw_activate(struct scsi_device *sdev)
+/*
+ * hp_sw_start_stop - Send START STOP UNIT command
+ * @sdev: sdev command should be sent to
+ *
+ * Sending START STOP UNIT activates the SP.
+ */
+static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 {
-	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
 	struct request *req;
-	int ret = SCSI_DH_RES_TEMP_UNAVAIL;
+	int ret, retry;
 
-	req = blk_get_request(sdev->request_queue, WRITE, GFP_ATOMIC);
+	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
 	if (!req)
-		goto done;
-
-	sdev_printk(KERN_INFO, sdev, "sending START_STOP.");
+		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
@@ -98,19 +214,78 @@ static int hp_sw_activate(struct scsi_device *sdev)
 	req->sense = h->sense;
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	req->sense_len = 0;
+	retry = h->retries;
 
+retry:
 	ret = blk_execute_rq(req->q, NULL, req, 1);
-	if (!ret) /* SUCCESS */
-		ret = hp_sw_done(sdev);
-	else
+	if (ret == -EIO) {
+		if (req->sense_len > 0) {
+			ret = start_done(sdev, h->sense);
+		} else {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: sending start_stop_unit failed with %x\n",
+				    HP_SW_NAME, req->errors);
+			ret = SCSI_DH_IO;
+		}
+	} else
+		ret = SCSI_DH_OK;
+
+	if (ret == SCSI_DH_RETRY) {
+		if (--retry)
+			goto retry;
 		ret = SCSI_DH_IO;
-done:
+	}
+
+	blk_put_request(req);
+
+	return ret;
+}
+
+static int hp_sw_prep_fn(struct scsi_device *sdev, struct request *req)
+{
+	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
+	int ret = BLKPREP_OK;
+
+	if (h->path_state != HP_SW_PATH_ACTIVE) {
+		ret = BLKPREP_KILL;
+		req->cmd_flags |= REQ_QUIET;
+	}
+	return ret;
+
+}
+
+/*
+ * hp_sw_activate - Activate a path
+ * @sdev: sdev on the path to be activated
+ *
+ * The HP Active/Passive firmware is pretty simple;
+ * the passive path reports NOT READY with sense codes
+ * 0x04/0x02; a START STOP UNIT command will then
+ * activate the passive path (and deactivate the
+ * previously active one).
+ */
+static int hp_sw_activate(struct scsi_device *sdev)
+{
+	int ret = SCSI_DH_OK;
+	struct hp_sw_dh_data *h = get_hp_sw_data(sdev);
+
+	ret = hp_sw_tur(sdev, h);
+
+	if (ret == SCSI_DH_OK && h->path_state == HP_SW_PATH_PASSIVE) {
+		ret = hp_sw_start_stop(sdev, h);
+		if (ret == SCSI_DH_OK)
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: activated path\n",
+				    HP_SW_NAME);
+	}
+
 	return ret;
 }
 
 const struct scsi_dh_devlist hp_sw_dh_data_list[] = {
-	{"COMPAQ", "MSA"},
-	{"HP", "HSV"},
+	{"COMPAQ", "MSA1000 VOLUME"},
+	{"COMPAQ", "HSV110"},
+	{"HP", "HSV100"},
 	{"DEC", "HSG80"},
 	{NULL, NULL},
 };
@@ -125,30 +300,51 @@ static struct scsi_device_handler hp_sw_dh = {
 	.attach		= hp_sw_bus_attach,
 	.detach		= hp_sw_bus_detach,
 	.activate	= hp_sw_activate,
+	.prep_fn	= hp_sw_prep_fn,
 };
 
 static int hp_sw_bus_attach(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data;
+	struct hp_sw_dh_data *h;
 	unsigned long flags;
+	int ret;
 
 	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
 			       + sizeof(struct hp_sw_dh_data) , GFP_KERNEL);
 	if (!scsi_dh_data) {
-		sdev_printk(KERN_ERR, sdev, "Attach Failed %s.\n",
+		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
 		return 0;
 	}
 
 	scsi_dh_data->scsi_dh = &hp_sw_dh;
+	h = (struct hp_sw_dh_data *) scsi_dh_data->buf;
+	h->path_state = HP_SW_PATH_UNINITIALIZED;
+	h->retries = HP_SW_RETRIES;
+
+	ret = hp_sw_tur(sdev, h);
+	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)
+		goto failed;
+
+	if (!try_module_get(THIS_MODULE))
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-	try_module_get(THIS_MODULE);
 
-	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", HP_SW_NAME);
+	sdev_printk(KERN_INFO, sdev, "%s: attached to %s path\n",
+		    HP_SW_NAME, h->path_state == HP_SW_PATH_ACTIVE?
+		    "active":"passive");
 
 	return 0;
+
+failed:
+	kfree(scsi_dh_data);
+	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
+		    HP_SW_NAME);
+	return -EINVAL;
 }
 
 static void hp_sw_bus_detach( struct scsi_device *sdev )
@@ -162,7 +358,7 @@ static void hp_sw_bus_detach( struct scsi_device *sdev )
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 	module_put(THIS_MODULE);
 
-	sdev_printk(KERN_NOTICE, sdev, "Detached %s\n", HP_SW_NAME);
+	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", HP_SW_NAME);
 
 	kfree(scsi_dh_data);
 }
@@ -180,6 +376,6 @@ static void __exit hp_sw_exit(void)
 module_init(hp_sw_init);
 module_exit(hp_sw_exit);
 
-MODULE_DESCRIPTION("HP MSA 1000");
+MODULE_DESCRIPTION("HP Active/Passive driver");
 MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu");
 MODULE_LICENSE("GPL");
-- 
1.5.2.4

