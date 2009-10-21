From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 4/4] scsi_dh: Make alua hardware handler's activate() async
Date: Wed, 21 Oct 2009 09:23:04 -0700
Message-ID: <20091021162304.8473.66039.sendpatchset@chandra-ubuntu>
References: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54193 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbZJUQXC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 12:23:02 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9LGLcJp025867
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 12:21:38 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LGN52P154998
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 12:23:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9LGN5Vj031491
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 12:23:05 -0400
In-Reply-To: <20091021162240.8473.99556.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com, berthiaume_wayne@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Make the activate function asynchronous by using blk_execute_rq_nowait()

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |  132 ++++++++++++++++-------------
 1 file changed, 73 insertions(+), 59 deletions(-)

Index: linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux-2.6.32-rc5.orig/drivers/scsi/device_handler/scsi_dh_alua.c	2009-10-20 18:26:14.000000000 -0700
+++ linux-2.6.32-rc5/drivers/scsi/device_handler/scsi_dh_alua.c	2009-10-20 18:27:12.000000000 -0700
@@ -60,11 +60,17 @@
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
@@ -231,18 +237,71 @@
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
+			    print_alua_state(h->state));
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
@@ -252,7 +311,7 @@
 
 	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
 	if (!rq)
-		goto done;
+		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_OUT;
@@ -266,17 +325,9 @@
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
 
@@ -477,50 +528,6 @@
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
@@ -664,8 +671,14 @@
 			goto out;
 	}
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED)
-		err = alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
+	if (h->tpgs & TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED) {
+		h->callback_fn = fn;
+		h->callback_data = data;
+		err = submit_stpg(h);
+		if (err == SCSI_DH_OK)
+			return 0;
+		h->callback_fn = h->callback_data = NULL;
+	}
 
 out:
 	if (fn)
@@ -748,6 +761,7 @@
 	h->rel_port = -1;
 	h->buff = h->inq;
 	h->bufflen = ALUA_INQUIRY_SIZE;
+	h->sdev = sdev;
 
 	err = alua_initialize(sdev, h);
 	if (err != SCSI_DH_OK)
