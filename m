From: Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 1/1] [BlOCK-BSG] Small stack and .o space clean up - removed local variable devname
Date: Tue, 13 Mar 2012 19:28:08 +0530
Message-ID: <1331647088-7858-1-git-send-email-sasikanth.v19@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57886 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2CMN41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 09:56:27 -0400
Received: by dadp12 with SMTP id p12so1025031dad.11
        for <linux-scsi@vger.kernel.org>; Tue, 13 Mar 2012 06:56:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org
Cc: Sasikantha babu <sasikanth.v19@gmail.com>

---
 block/bsg.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ff64ae3..4eaa9e9 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -999,12 +999,6 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	dev_t dev;
 	int ret, minor;
 	struct device *class_dev = NULL;
-	const char *devname;
-
-	if (name)
-		devname = name;
-	else
-		devname = dev_name(parent);
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
@@ -1039,7 +1033,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	bcd->release = release;
 	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
+	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", name ? name : dev_name(parent));
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
 		goto put_dev;
-- 
1.7.3.4

