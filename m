From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 4/4] scsi_dh: rdac handler: Make alua hardware handler async
Date: Tue, 29 Sep 2009 19:08:35 -0700
Message-ID: <20090930020835.11455.79360.sendpatchset@chandra-ubuntu>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:38500 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZI3CIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 22:08:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8U27GU8009052
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 20:07:16 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8U28FiS263576
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 20:08:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8U28FDP021733
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 20:08:15 -0600
In-Reply-To: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com, berthiaume_wayne@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Make the activate function asynchronous by using blk_execute_rq_nowait()

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |  132 ++++++++++++++++-------------
 1 file changed, 73 insertions(+), 59 deletions(-)

Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh_alua.c
+++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -60,11 +60,17 @@ struct alua_dh_data {
 	int			bufflen;
 	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
 	int			senselen;
+	struct scsi_device	*sdev;
+	activate_complete	callback_fn;
+	void			*callback_data;
 };
 
 #define ALUA_POLICY_SWITCH_CURRENT	0
 #define ALUA_POLICY_SWITCH_ALL		1
 
+static char print_alua_state(int);
+static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
+
 static inline struct alua_dh_data *get_alua_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
@@ -231,18 +237,71 @@ done:
 }
 
 /*
+ * alua_stpg - Evaluate SET TARGET GROUP STATES
+ * @sdev: the device to be evaluated
+ * @state: the new target group state
+ *
+ * Send a SET TARGET GROUP STATES command to the device.
+ * We only have to test here if we should resubmit the command;
+ * any other error is assumed as a failure.
+ */
+static void stpg_endio(struct request *req, int error)
+{
+	struct alua_dh_data *h = req->end_io_data;
+	struct scsi_sense_hdr sense_hdr;
+	unsigned err = SCSI_DH_IO;
+
+	if (error || host_byte(req->errors) != DID_OK ||
+			msg_byte(req->errors) != COMMAND_COMPLETE)
+		goto done;
+
+	if (err == SCSI_DH_IO && h->senselen > 0) {
+		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
+					   &sense_hdr);
+		if (!err) {
+			err = SCSI_DH_IO;
+			goto done;
+		}
+		err = alua_check_sense(h->sdev, &sense_hdr);
+		if (err == ADD_TO_MLQUEUE) {
+			err = SCSI_DH_RETRY;
+			goto done;
+		}
+		sdev_printk(KERN_INFO, h->sdev,
+			    "%s: stpg sense code: %02x/%02x/%02x\n",
+			    ALUA_DH_NAME, sense_hdr.sense_key,
+			    sense_hdr.asc, sense_hdr.ascq);
+		err = SCSI_DH_IO;
+	}
+	if (err == SCSI_DH_OK) {
+		h->state = TPGS_STATE_OPTIMIZED;
+		sdev_printk(KERN_INFO, h->sdev,
+			    "%s: port group %02x switched to state %c\n",
+			    ALUA_DH_NAME, h->group_id,
+			    print_alua_state(h->state) );
+	}
+done:
+	blk_put_request(req);
+	if (h->callback_fn) {
+		h->callback_fn(h->callback_data, err);
+		h->callback_fn = h->callback_data = NULL;
+	}
+	return;
+}
+
+/*
  * submit_stpg - Issue a SET TARGET GROUP STATES command
- * @sdev: sdev the command should be sent to
  *
  * Currently we're only setting the current target port group state
  * to 'active/optimized' and let the array firmware figure out
  * the states of the remaining groups.
  */
-static unsigned submit_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
+static unsigned submit_stpg(struct alua_dh_data *h)
 {
 	struct request *rq;
 	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 	int stpg_len = 8;
+	struct scsi_device *sdev = h->sdev;
 
 	/* Prepare the data buffer */
 	memset(h->buff, 0, stpg_len);
@@ -252,7 +311,7 @@ static unsigned submit_stpg(struct scsi_
 
 	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
 	if (!rq)
-		goto done;
+		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_OUT;
@@ -266,17 +325,9 @@ static unsigned submit_stpg(struct scsi_
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = h->senselen = 0;
+	rq->end_io_data = h;
 
-	err = blk_execute_rq(rq->q, NULL, rq, 1);
-	if (err == -EIO) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: stpg failed with %x\n",
-			    ALUA_DH_NAME, rq->errors);
-		h->senselen = rq->sense_len;
-		err = SCSI_DH_IO;
-	}
-	blk_put_request(rq);
-done:
+	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
 	return err;
 }
 
@@ -477,50 +528,6 @@ static int alua_check_sense(struct scsi_
 }
 
 /*
- * alua_stpg - Evaluate SET TARGET GROUP STATES
- * @sdev: the device to be evaluated
- * @state: the new target group state
- *
- * Send a SET TARGET GROUP STATES command to the device.
- * We only have to test here if we should resubmit the command;
- * any other error is assumed as a failure.
- */
-static int alua_stpg(struct scsi_device *sdev, int state,
-		     struct alua_dh_data *h)
-{
-	struct scsi_sense_hdr sense_hdr;
-	unsigned err;
-	int retry = ALUA_FAILOVER_RETRIES;
-
- retry:
-	err = submit_stpg(sdev, h);
-	if (err == SCSI_DH_IO && h->senselen > 0) {
-		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
-					   &sense_hdr);
-		if (!err)
-			return SCSI_DH_IO;
-		err = alua_check_sense(sdev, &sense_hdr);
-		if (retry > 0 && err == ADD_TO_MLQUEUE) {
-			retry--;
-			goto retry;
-		}
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: stpg sense code: %02x/%02x/%02x\n",
-			    ALUA_DH_NAME, sense_hdr.sense_key,
-			    sense_hdr.asc, sense_hdr.ascq);
-		err = SCSI_DH_IO;
-	}
-	if (err == SCSI_DH_OK) {
-		h->state = state;
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: port group %02x switched to state %c\n",
-			    ALUA_DH_NAME, h->group_id,
-			    print_alua_state(h->state) );
-	}
-	return err;
-}
-
-/*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
  *
@@ -663,8 +670,14 @@ static int alua_activate(struct scsi_dev
 			goto out;
 	}
 
-	if (h->tpgs == TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED)
-		err = alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
+	if (h->tpgs == TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED) {
+		h->callback_fn = fn;
+		h->callback_data = data;
+		err = submit_stpg(h);
+		if (err == SCSI_DH_OK)
+			return 0;
+		h->callback_fn = h->callback_data = NULL;
+	}
 
 out:
 	if (fn)
@@ -747,6 +760,7 @@ static int alua_bus_attach(struct scsi_d
 	h->rel_port = -1;
 	h->buff = h->inq;
 	h->bufflen = ALUA_INQUIRY_SIZE;
+	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
 	if (err != SCSI_DH_OK)
