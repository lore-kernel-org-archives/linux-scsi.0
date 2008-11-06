From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Retry mode select in rdac device handler
Date: Wed, 05 Nov 2008 20:06:37 -0800
Message-ID: <1225944397.14830.1111.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36982 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYKFEHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 23:07:40 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mA646rNQ010253
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 21:06:53 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA647deq125860
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 21:07:39 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA647AHv012598
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 21:07:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: dm-devel <dm-devel@redhat.com>

When the mode select sent to the controller fails with the retryable
error, it is better to retry the mode_select from the hardware handler
itself, instead of propagating the failure to dm-multipath.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.28-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
===================================================================
--- linux-2.6.28-rc3.orig/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.28-rc3/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -24,6 +24,7 @@
 #include <scsi/scsi_dh.h>
 
 #define RDAC_NAME "rdac"
+#define RDAC_RETRY_COUNT 5
 
 /*
  * LSI mode page stuff
@@ -477,21 +478,27 @@ static int send_mode_select(struct scsi_
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err, retry_cnt = RDAC_RETRY_COUNT;
 
+retry:
+	err = SCSI_DH_RES_TEMP_UNAVAIL;
 	rq = rdac_failover_get(sdev, h);
 	if (!rq)
 		goto done;
 
-	sdev_printk(KERN_INFO, sdev, "queueing MODE_SELECT command.\n");
+	sdev_printk(KERN_INFO, sdev, "%s MODE_SELECT command.\n",
+		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
 	err = blk_execute_rq(q, NULL, rq, 1);
-	if (err != SCSI_DH_OK)
+	blk_put_request(rq);
+	if (err != SCSI_DH_OK) {
 		err = mode_select_handle_sense(sdev, h->sense);
+		if (err == SCSI_DH_RETRY && retry_cnt--)
+			goto retry;
+	}
 	if (err == SCSI_DH_OK)
 		h->state = RDAC_STATE_ACTIVE;
 
-	blk_put_request(rq);
 done:
 	return err;
 }


