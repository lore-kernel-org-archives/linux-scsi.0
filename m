From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/3] scsi_dh: Workaround a race condition in module insertion
Date: Tue, 17 Mar 2009 18:36:33 -0700
Message-ID: <20090318013633.26548.94042.sendpatchset@chandra-ubuntu>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54474 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbZCRBdh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2009 21:33:37 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2I1Uj3o003607
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2009 19:30:45 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2I1XZbU199944
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2009 19:33:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2I1XYmu027653
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2009 19:33:35 -0600
In-Reply-To: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

From: Chandra Seetharaman <sekharan@us.ibm.com>

scsi_dh odule is getting inserted as soon as the first device is seen.
But, the first device is not seen by the module as we were past the 
ADD_DEVICE handling in the module.

Catch the first device by handling BUS_NOTIFY_BOUND_DRIVER event,
and not handle that event for any of the future devices (as they would
have been handled by ADD_DEVICE event).

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Peter Jones <pjones@redhat.com>

---
 drivers/scsi/device_handler/scsi_dh.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.28/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.28.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.28/drivers/scsi/device_handler/scsi_dh.c
@@ -294,7 +294,16 @@ static int scsi_dh_notifier(struct notif
 
 	sdev = to_scsi_device(dev);
 
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
+	if ((action == BUS_NOTIFY_ADD_DEVICE) ||
+			(action == BUS_NOTIFY_BOUND_DRIVER)) {
+		/*
+		 * This can happen if device was configured already
+		 * with BUS_NOTIFY_ADD_DEVICE and we are called
+		 * now with BUS_NOTIFY_BOUND_DRIVER
+		 */
+		if (sdev->scsi_dh_data)
+			goto out;
+
 		devinfo = device_handler_match(NULL, sdev);
 		if (!devinfo)
 			goto out;
