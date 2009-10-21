From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/4] scsi_dh: Make hp hardware handler's activate() async
Date: Wed, 21 Oct 2009 09:22:58 -0700
Message-ID: <20091021162258.8473.32042.sendpatchset@chandra-ubuntu>
References: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47555 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbZJUQW4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 12:22:56 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9LGFFh4016158
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 12:15:15 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LGN0OT201596
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 12:23:00 -0400
Received: from d01av01.pok.ibm.com (d03av01 [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9LGMxOA032761
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 12:23:00 -0400
In-Reply-To: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com, berthiaume_wayne@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Make the activate function asynchronous by using blk_execute_rq_nowait()

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |   87 +++++++++++++++++-----------
 1 file changed, 54 insertions(+), 33 deletions(-)

Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_hp_sw.c
===================================================================
--- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2009-10-20 18:26:14.000000000 -0700
+++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2009-10-20 18:26:44.000000000 -0700
@@ -39,8 +39,14 @@
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int path_state;
 	int retries;
+	int retry_cnt;
+	struct scsi_device *sdev;
+	activate_complete	callback_fn;
+	void			*callback_data;
 };
 
+static int hp_sw_start_stop(struct hp_sw_dh_data *);
+
 static inline struct hp_sw_dh_data *get_hp_sw_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
@@ -191,19 +197,53 @@
 	return rc;
 }
 
+static void start_stop_endio(struct request *req, int error)
+{
+	struct hp_sw_dh_data *h = req->end_io_data;
+	unsigned err = SCSI_DH_OK;
+
+	if (error || host_byte(req->errors) != DID_OK ||
+			msg_byte(req->errors) != COMMAND_COMPLETE) {
+		sdev_printk(KERN_WARNING, h->sdev,
+			    "%s: sending start_stop_unit failed with %x\n",
+			    HP_SW_NAME, req->errors);
+		err = SCSI_DH_IO;
+		goto done;
+	}
+
+	if (req->sense_len > 0) {
+		err = start_done(h->sdev, h->sense);
+		if (err == SCSI_DH_RETRY) {
+			err = SCSI_DH_IO;
+			if (--h->retry_cnt) {
+				blk_put_request(req);
+				err = hp_sw_start_stop(h);
+				if (err == SCSI_DH_OK)
+					return;
+			}
+		}
+	}
+done:
+	blk_put_request(req);
+	if (h->callback_fn) {
+		h->callback_fn(h->callback_data, err);
+		h->callback_fn = h->callback_data = NULL;
+	}
+	return;
+
+}
+
 /*
  * hp_sw_start_stop - Send START STOP UNIT command
  * @sdev: sdev command should be sent to
  *
  * Sending START STOP UNIT activates the SP.
  */
-static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
+static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 {
 	struct request *req;
-	int ret, retry;
 
-retry:
-	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
+	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
 	if (!req)
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
@@ -217,32 +257,10 @@
 	req->sense = h->sense;
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	req->sense_len = 0;
-	retry = h->retries;
+	req->end_io_data = h;
 
-	ret = blk_execute_rq(req->q, NULL, req, 1);
-	if (ret == -EIO) {
-		if (req->sense_len > 0) {
-			ret = start_done(sdev, h->sense);
-		} else {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: sending start_stop_unit failed with %x\n",
-				    HP_SW_NAME, req->errors);
-			ret = SCSI_DH_IO;
-		}
-	} else
-		ret = SCSI_DH_OK;
-
-	if (ret == SCSI_DH_RETRY) {
-		if (--retry) {
-			blk_put_request(req);
-			goto retry;
-		}
-		ret = SCSI_DH_IO;
-	}
-
-	blk_put_request(req);
-
-	return ret;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, start_stop_endio);
+	return SCSI_DH_OK;
 }
 
 static int hp_sw_prep_fn(struct scsi_device *sdev, struct request *req)
@@ -277,11 +295,13 @@
 	ret = hp_sw_tur(sdev, h);
 
 	if (ret == SCSI_DH_OK && h->path_state == HP_SW_PATH_PASSIVE) {
-		ret = hp_sw_start_stop(sdev, h);
+		h->retry_cnt = h->retries;
+		h->callback_fn = fn;
+		h->callback_data = data;
+		ret = hp_sw_start_stop(h);
 		if (ret == SCSI_DH_OK)
-			sdev_printk(KERN_INFO, sdev,
-				    "%s: activated path\n",
-				    HP_SW_NAME);
+			return 0;
+		h->callback_fn = h->callback_data = NULL;
 	}
 
 	if (fn)
@@ -329,6 +349,7 @@
 	h = (struct hp_sw_dh_data *) scsi_dh_data->buf;
 	h->path_state = HP_SW_PATH_UNINITIALIZED;
 	h->retries = HP_SW_RETRIES;
+	h->sdev = sdev;
 
 	ret = hp_sw_tur(sdev, h);
 	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)
