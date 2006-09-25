From: akpm@osdl.org
Subject: [patch 28/28] scsi: device_reprobe() can fail
Date: Mon, 25 Sep 2006 16:59:15 -0700
Message-ID: <200609252359.k8PNxF6r003550@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51131 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751775AbWIYX7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

From: Andrew Morton <akpm@osdl.org>

device_reprobe() should return an error code.  When it does so,
scsi_device_reprobe() should propagate it back.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/scsi/scsi_device.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/scsi/scsi_device.h~scsi-device_reprobe-can-fail include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h~scsi-device_reprobe-can-fail
+++ a/include/scsi/scsi_device.h
@@ -298,9 +298,9 @@ extern int scsi_execute_async(struct scs
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
 
-static inline void scsi_device_reprobe(struct scsi_device *sdev)
+static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {
-	device_reprobe(&sdev->sdev_gendev);
+	return device_reprobe(&sdev->sdev_gendev);
 }
 
 static inline unsigned int sdev_channel(struct scsi_device *sdev)
_
