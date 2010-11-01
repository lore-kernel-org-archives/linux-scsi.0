From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix queue full in scsi error handling
Date: Mon, 1 Nov 2010 21:13:59 +0800
Message-ID: <AANLkTi=Z9JDe_+DU5a3JDXAKU2kVQ35Z0E_JT6qwVXTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55913 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab0KANUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 09:20:15 -0400
Received: by wyf28 with SMTP id 28so5491847wyf.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 06:20:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Upon event that queue is full there seems the relevant time mark
should be updated.

Tedious check for sane depth of queue is also added before issuing the
callback of LLDD.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-11-01 20:48:26.000000000 +0800
@@ -405,6 +405,7 @@ static void scsi_handle_queue_full(struc

 	if (!sht->change_queue_depth)
 		return;
+	sdev->last_queue_full_time = jiffies;

 	shost_for_each_device(tmp_sdev, sdev->host) {
 		if (tmp_sdev->channel != sdev->channel ||
@@ -415,8 +416,10 @@ static void scsi_handle_queue_full(struc
 		 * the device when we got the queue full so we start
 		 * from the highest possible value and work our way down.
 		 */
-		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
-					SCSI_QDEPTH_QFULL);
+		if (tmp_sdev->queue_depth > 1)
+			sht->change_queue_depth(tmp_sdev,
+						tmp_sdev->queue_depth - 1,
+						SCSI_QDEPTH_QFULL);
 	}
 }
