From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug against lk 2.5.69+mikea
Date: Wed, 07 May 2003 23:26:17 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB90979.90600@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090704000002050602050700"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:12559 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263179AbTEGNLA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 09:11:00 -0400
Received: from torque.net (d-241-195.stlucia.uq.net.au [203.101.241.195])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h47DNUHO005742
	for <linux-scsi@vger.kernel.org>; Wed, 7 May 2003 23:23:31 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090704000002050602050700
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Found a small problem with scsi_debug while
playing with rescan-scsi-bus.sh . This patch
is against Mike Anderson's scsi hosts sysfs
patchset (since that version has my most
recent scsi_debug changes).

Doug Gilbert

--------------090704000002050602050700
Content-Type: text/plain;
 name="sdebug_2569ma_d1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_2569ma_d1.diff"

--- linux/drivers/scsi/scsi_debug.c	2003-05-05 20:49:16.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c2569ma_d1	2003-05-07 12:04:21.000000000 +1000
@@ -54,7 +54,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.70 (20030416)";
+static const char * scsi_debug_version_str = "Version: 1.70 (20030507)";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -271,9 +271,10 @@
 	}
 
         if(target == sdebug_driver_template.this_id) {
-                printk(KERN_WARNING 
-		       "scsi_debug: initiator's id used as target!\n");
-		return schedule_resp(SCpnt, NULL, done, 0, 0);
+                printk(KERN_INFO "scsi_debug: initiator's id used as "
+		       "target!\n");
+		return schedule_resp(SCpnt, NULL, done, 
+				     DID_NO_CONNECT << 16, 0);
         }
 
 	if (SCpnt->device->lun >= scsi_debug_max_luns)
@@ -866,7 +867,7 @@
 static void timer_intr_handler(unsigned long indx)
 {
 	struct sdebug_queued_cmd * sqcp;
-	unsigned int iflags;
+	unsigned long iflags;
 
 	if (indx >= SCSI_DEBUG_CANQUEUE) {
 		printk(KERN_ERR "scsi_debug:timer_intr_handler: indx too "

--------------090704000002050602050700--

