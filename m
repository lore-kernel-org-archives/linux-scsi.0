From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [RESEND] [PATCH 1/3] scsi_dh: add the interface scsi_dh_set_params()
Date: Mon, 03 Aug 2009 12:42:33 -0700
Message-ID: <20090803194233.5738.682.sendpatchset@chandra-ubuntu>
References: <20090803194226.5738.82973.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:45463 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZHCTiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 15:38:46 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n73JbvA0003230
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 13:37:57 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n73Jck6l233682
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 13:38:47 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n73JckHD005261
	for <linux-scsi@vger.kernel.org>; Mon, 3 Aug 2009 13:38:46 -0600
In-Reply-To: <20090803194226.5738.82973.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, berthiaume_wayne@emc.com, Eddie.Williams@steeleye.com, Chandra Seetharaman <sekharan@us.ibm.com>

When we moved the device handler functionality from dm layer to SCSI layer
we dropped the parameter functionality.

This path adds an interface to scsi dh layer to set device handler 
parameters.

Basically, multipath layer need to create a string with all the parameters
and call scsi_dh_set_params() after it called scsi_dh_attach() on a
device.

If a device handler provides such an interface it will handle the parameters
as it expects them.

Reported-by: Eddie Williams <Eddie.Williams@steeleye.com>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Tested-by: Eddie Williams <Eddie.Williams@steeleye.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h            |    1 +
 include/scsi/scsi_dh.h                |    5 +++++
 3 files changed, 39 insertions(+)

Index: linux-2.6.31-rc1/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.31-rc1.orig/include/scsi/scsi_device.h
+++ linux-2.6.31-rc1/include/scsi/scsi_device.h
@@ -187,6 +187,7 @@ struct scsi_device_handler {
 	void (*detach)(struct scsi_device *);
 	int (*activate)(struct scsi_device *);
 	int (*prep_fn)(struct scsi_device *, struct request *);
+	int (*set_params)(struct scsi_device *, const char *);
 };
 
 struct scsi_dh_data {
Index: linux-2.6.31-rc1/include/scsi/scsi_dh.h
===================================================================
--- linux-2.6.31-rc1.orig/include/scsi/scsi_dh.h
+++ linux-2.6.31-rc1/include/scsi/scsi_dh.h
@@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct reque
 extern int scsi_dh_handler_exist(const char *);
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
+extern int scsi_dh_set_params(struct request_queue *, const char *);
 #else
 static inline int scsi_dh_activate(struct request_queue *req)
 {
@@ -77,4 +78,8 @@ static inline void scsi_dh_detach(struct
 {
 	return;
 }
+static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
+{
+	return -SCSI_DH_NOSYS;
+}
 #endif
Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
@@ -449,6 +449,39 @@ int scsi_dh_activate(struct request_queu
 EXPORT_SYMBOL_GPL(scsi_dh_activate);
 
 /*
+ * scsi_dh_set_params - set the parameters for the device as per the
+ *      string specified in params.
+ * @q - Request queue that is associated with the scsi_device for
+ *      which the parameters to be set.
+ * @params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ *      for example, string for 2 parameters with value 10 and 21
+ *      is specified as "2\010\021\0".
+ */
+int scsi_dh_set_params(struct request_queue *q, const char *params)
+{
+	int err = -SCSI_DH_NOSYS;
+	unsigned long flags;
+	struct scsi_device *sdev;
+	struct scsi_device_handler *scsi_dh = NULL;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	sdev = q->queuedata;
+	if (sdev && sdev->scsi_dh_data)
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+	if (scsi_dh && scsi_dh->set_params && get_device(&sdev->sdev_gendev))
+		err = 0;
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	if (err)
+		return err;
+	err = scsi_dh->set_params(sdev, params);
+	put_device(&sdev->sdev_gendev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_set_params);
+
+/*
  * scsi_dh_handler_exist - Return TRUE(1) if a device handler exists for
  *	the given name. FALSE(0) otherwise.
  * @name - name of the device handler.
