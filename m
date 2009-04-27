From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/3] scsi_dh: Workaround a race condition in module insertion
Date: Mon, 27 Apr 2009 11:06:27 -0700
Message-ID: <20090427180627.22758.59210.sendpatchset@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:55583 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbZD0SFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 14:05:49 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3RI3IRH025142
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:03:18 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3RI5dR8062824
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3RI5ccc012746
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 12:05:38 -0600
In-Reply-To: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, hare@suse.de, Chandra Seetharaman <sekharan@us.ibm.com>

From: Chandra Seetharaman <sekharan@us.ibm.com>

scsi_dh module is getting inserted as soon as the first device is seen.
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

Index: linux-2.6.29/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.29.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.29/drivers/scsi/device_handler/scsi_dh.c
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
