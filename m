From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 09:21:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400FEA73.80109@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080809010004000007040009"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:11954 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264855AbUAVPV0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 10:21:26 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0MFLPvM517302
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2004 10:21:25 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0MFLOIF109392
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2004 10:21:24 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080809010004000007040009
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here is a patch that adds a flag to struct scsi_device which prevents
upper layer drivers from binding to it. This flag can be set by LLDs
in their slave_configure routine. I plan to use this in the ipr driver
so I can have scsi disks that are in RAID arrays show up in sysfs and
have sg devices created for them, but prevent sd devices from being
created since these devices will fail reads and writes with data protect
errors. I tested this out with the ipr driver it worked as expected.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------080809010004000007040009
Content-Type: text/plain;
 name="patch-2.6.1-hidden_devs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.6.1-hidden_devs"

diff -Naur linux-2.6.1/drivers/scsi/scsi_sysfs.c linux-2.6.1-hidden/drivers/scsi/scsi_sysfs.c
--- linux-2.6.1/drivers/scsi/scsi_sysfs.c	Fri Jan  9 00:59:10 2004
+++ linux-2.6.1-hidden/drivers/scsi/scsi_sysfs.c	Thu Jan 22 08:54:39 2004
@@ -149,7 +149,13 @@
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-	return 1;
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+
+	if (sdev->hidden)
+		return 0;
+	else
+		return 1;
 }
 
 struct bus_type scsi_bus_type = {
diff -Naur linux-2.6.1/include/scsi/scsi_device.h linux-2.6.1-hidden/include/scsi/scsi_device.h
--- linux-2.6.1/include/scsi/scsi_device.h	Fri Jan  9 00:59:06 2004
+++ linux-2.6.1-hidden/include/scsi/scsi_device.h	Thu Jan 22 08:50:33 2004
@@ -94,6 +94,7 @@
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
+	unsigned hidden:1;	/* do not bind to upper level driver */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 

--------------080809010004000007040009--

