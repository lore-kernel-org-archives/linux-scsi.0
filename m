From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: 20 Aug 2004 21:56:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093053368.3318.569.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:23988 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268817AbUHUB4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 21:56:09 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i7L1u6X06332
	for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2004 21:56:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The idea here is to get a full range of device capabilites in the
scsi_device structure so there's absolutely no need at all for drivers
to snoop the inquiry data.

The missing parameters were:

dt_only - means the device only supports DT transfers (not ST)
ius - means the device supports information unit (IU) transfers
qas - means the device supports the Quick Arbitration and Selection
protocol

Our rather misnamed ones are:

ppr - means the device does DT (DT negotiation may only be done via PPR)
wdtr - means the device does wide
sdtr - means the device does sync

James

===== drivers/scsi/scsi_scan.c 1.127 vs edited =====
--- 1.127/drivers/scsi/scsi_scan.c	2004-06-25 06:56:28 -05:00
+++ edited/drivers/scsi/scsi_scan.c	2004-08-20 11:30:09 -05:00
@@ -576,9 +576,16 @@
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
 
-	if (sdev->scsi_level >= SCSI_3 || (sdev->inquiry_len > 56 &&
-		inq_result[56] & 0x04))
-		sdev->ppr = 1;
+	if (sdev->inquiry_len > 56) {
+		if (inq_result[56] & 0x04)
+			sdev->ppr = 1;
+		if ((inq_result[56] & 0x0c) == 0x04)
+			sdev->dt_only = 1;
+		if (inq_result[56] & 0x01)
+			sdev->ius = 1;
+		if (inq_result[56] & 0x02)
+			sdev->qas = 1;
+	}
 	if (inq_result[7] & 0x60)
 		sdev->wdtr = 1;
 	if (inq_result[7] & 0x10)
===== include/scsi/scsi_device.h 1.19 vs edited =====
--- 1.19/include/scsi/scsi_device.h	2004-07-07 11:24:13 -05:00
+++ edited/include/scsi/scsi_device.h	2004-08-20 11:31:05 -05:00
@@ -89,6 +92,10 @@
 	unsigned sdtr:1;	/* Device supports SDTR messages */
 	unsigned wdtr:1;	/* Device supports WDTR messages */
 	unsigned ppr:1;		/* Device supports PPR messages */
+	unsigned dt_only:1;	/* Device only supports DT */
+	unsigned ius:1;		/* Device Supports IUs */
+	unsigned qas:1;		/* Device Support Quick Arbitration
+				 * and Selection */
 	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
 	unsigned simple_tags:1;	/* simple queue tag messages are enabled */
 	unsigned ordered_tags:1;/* ordered queue tag messages are enabled */

