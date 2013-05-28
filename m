From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: scsi_dh_emc: set_params callback should consistently return errno
Date: Tue, 28 May 2013 17:26:05 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1305281723330.25762@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub4.stratus.com ([134.111.1.17]:51298 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab3E1VaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 17:30:20 -0400
In-Reply-To: <alpine.DEB.2.02.1305281713410.25762@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Joe Lawrence <Joe.Lawrence@stratus.com>

>From db6c2d4406732585fd7a658fc89b14fa26e7d1d4 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Tue, 28 May 2013 15:47:20 -0400
Subject: [PATCH 2/2] scsi_dh_emc: set_params callback should consistently
 return errno

A SCSI scsi_device_handler set_params routine should return a negative
errno value on failure. The scsi_dh_emc driver may return not only
-EINVAL but also also positive SCSI_DH enum values. Fix the
clariion_set_params implementation to return a negative value in all
error scenarios. To that end, make sure send_trespass_cmd consistently
returns a SCSI_DH enum.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 0438ed6..6ca9e84 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -389,6 +389,7 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 		if (rq->sense_len) {
 			err = trespass_endio(sdev, csdev->sense);
 		} else {
+			err = SCSI_DH_IO;
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: failed to send MODE SELECT: %x\n",
 				    CLARIION_NAME, rq->errors);
@@ -626,7 +627,10 @@ static int clariion_set_params(struct scsi_device *sdev, const char *params)
 	result = clariion_send_inquiry(sdev, csdev);
 
 done:
-	return result;
+	if (result != SCSI_DH_OK)
+		return -EIO;
+
+	return 0;
 }
 
 static const struct scsi_dh_devlist clariion_dev_list[] = {
-- 
1.7.10.4

