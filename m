From: Jeff Leung <jleung@v10networks.ca>
Subject: [PATCH] scsi: storvsc: Force SPC-3 for Win8 Hosts or Later
Date: Tue, 21 Oct 2014 05:39:24 +0000
Message-ID: <1413869964-38940-1-git-send-email-jleung@v10networks.ca>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45989 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaJUFjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 01:39:31 -0400
Received: by mail-pa0-f50.google.com with SMTP id kx10so639187pab.9
        for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2014 22:39:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Cc: kys@microsoft.com, James.Bottomley@HansenPartnership.com, Jeff Leung <jleung@v10networks.ca>

This patch forces SPC-3 for Hyper-V disks on the VMBus. As Windows 10's
virtual SAS bus is SPC-3 compliant and there are no negative side effects
on forcing SPC-3 compliance for Win8 hosts, this patch enables SPC-3
compliance by forcing it on for hosts with versions later than Win8.

Forcing SPC-3 compliance for hosts earlier than Win10 also enables
TRIM support.

Suggested by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Jeff Leung <jleung@v10networks.ca>
---
 drivers/scsi/storvsc_drv.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ed0f899..afcc68e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1449,6 +1449,15 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	/*
+	 * If the host is Win2k12 or later, we pretend to be SPC-3 compliant
+	 * and send RC16 which activates TRIM. We will only enable this on a
+	 * host with levels greater than VERSION_WIN8
+	 */
+	if (vmbus_proto_version >= VERSION_WIN8) {
+		sdevice->scsi_level = SCSI_SPC_3;
+	}
+
 	return 0;
 }
 
-- 
1.7.2.5

