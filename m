From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: Tue, 7 Oct 2003 13:18:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200310071318.11847.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:48584 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262763AbTJGURR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 16:17:17 -0400
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e31.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id h97KHG67488968
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 16:17:16 -0400
Received: from DYN318271BLD.beaverton.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h97KHEir144946
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 14:17:15 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I originally posted this patch for comments:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106487047707538&w=2

The sdev_printk macro is meant to provide two things for the mid-layer and 
LLDs:

1) Add consistency to printing out scsi_device information.

2) Identifying printk with a specific scsi_device.

I've updated it to the latest scsi tree and I've split it into two parts. The 
first patch adds the macro to scsi_device.h and moves setting scsi_device's 
sdev_gendev's bus_id from scsi_sysfs.c to scsi_scan.c. The second patch, 
which I'll send after this message, adds using the macro to scsi mid-layer. 

I split them up in case there might be some discussion on how I applied the 
macro, whether I've missed places or put it in places where it shouldn't be.

Please apply, or let me know if you have any objections.

Thanks,

Dan

Patch #1 Follows:
-------------------


diff -urN --exclude=SCCS scsi-misc-2.5/include/scsi/scsi_device.h 
scsi-misc-2.5-sdev/include/scsi/scsi_device.h
--- scsi-misc-2.5/include/scsi/scsi_device.h	2003-10-06 16:13:57.000000000 
-0700
+++ scsi-misc-2.5-sdev/include/scsi/scsi_device.h	2003-10-06 
20:04:19.671217176 -0700
@@ -105,6 +105,9 @@
 #define	class_to_sdev(d)	\
 	container_of(d, struct scsi_device, sdev_classdev)
 
+#define sdev_printk(level, sdev, format, arg...) \
+	printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ## arg)
+
 extern struct scsi_device *scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint);
 extern void scsi_remove_device(struct scsi_device *);
diff -urN --exclude=SCCS scsi-misc-2.5/drivers/scsi/scsi_scan.c 
scsi-misc-2.5-sdev/drivers/scsi/scsi_scan.c
--- scsi-misc-2.5/drivers/scsi/scsi_scan.c	2003-10-06 16:13:29.000000000 -0700
+++ scsi-misc-2.5-sdev/drivers/scsi/scsi_scan.c	2003-10-06 20:08:42.428272032 
-0700
@@ -258,6 +258,9 @@
 	if (!sdev->scsi_level)
 		sdev->scsi_level = SCSI_2;
 
+	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
+		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+
 	/*
 	 * Add it to the end of the shost->my_devices list.
 	 */
diff -urN --exclude=SCCS scsi-misc-2.5/drivers/scsi/scsi_sysfs.c 
scsi-misc-2.5-sdev/drivers/scsi/scsi_sysfs.c
--- scsi-misc-2.5/drivers/scsi/scsi_sysfs.c	2003-10-06 16:13:29.000000000 
-0700
+++ scsi-misc-2.5-sdev/drivers/scsi/scsi_sysfs.c	2003-10-06 20:09:14.553388272 
-0700
@@ -340,8 +340,6 @@
 
 	set_bit(SDEV_ADD, &sdev->sdev_state);
 	device_initialize(&sdev->sdev_gendev);
-	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.release = scsi_device_dev_release;


