From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] fix oops caused when writing to the rescan attribute
Date: Tue, 30 Sep 2003 15:27:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F7A0346.9090309@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040200090500010208080902"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:15861 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261763AbTI3W1U
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 18:27:20 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id h8UMRJxu162368
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2003 18:27:19 -0400
Received: from us.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h8UMRITa228492
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2003 16:27:19 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040200090500010208080902
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

If an upper layer driver is not loaded, and you write to a device's 
rescan attribute you will get an oops. The attached patch fixes this by 
testing if the device's driver variable is set before accessing it.


Mike Christie
mikenc@us.ibm.com

--------------040200090500010208080902
Content-Type: text/plain;
 name="sysfs_rescan.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysfs_rescan.patch"

--- linux-2.6.0-test6/drivers/scsi/scsi_scan.c	2003-09-27 17:50:40.000000000 -0700
+++ linux-2.6.0-test6-work/drivers/scsi/scsi_scan.c	2003-09-30 04:12:25.000000000 -0700
@@ -1080,8 +1080,12 @@
 
 void scsi_rescan_device(struct device *dev)
 {
-	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+	struct scsi_driver *drv;
+	
+	if (!dev->driver)
+		return;
 
+	drv = to_scsi_driver(dev->driver);
 	if (try_module_get(drv->owner)) {
 		if (drv->rescan)
 			drv->rescan(dev);

--------------040200090500010208080902--

