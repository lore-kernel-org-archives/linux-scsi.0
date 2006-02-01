From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/3] aacraid: reduce device probe warnings
Date: Wed, 01 Feb 2006 09:30:31 -0800
Message-ID: <1138815031.27662.13.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:16527 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1422654AbWBARae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 12:30:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

This patch sets up some device quirks surrounding arrays to inform the
scsi layer that various mode pages are not supported. This reduces the
severity of the complaints that show up in the logs as the array devices
are enumerated.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-01-31 09:35:32.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-01-31 09:35:42.000000000 -0800
@@ -386,6 +386,10 @@
 static int aac_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *host = sdev->host;
+	if (sdev_channel(sdev) == CONTAINER_CHANNEL) {
+		sdev->skip_ms_page_8 = 1;
+		sdev->skip_ms_page_3f = 1;
+	}
 
 	if (sdev->tagged_supported)
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, 128);

-- 
Mark Haverkamp <markh@osdl.org>

