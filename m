From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] scsi-misc-2.5 fix repeat_inquiry bflags setting
Date: Wed, 23 Apr 2003 11:16:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030423111640.A14690@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:23293 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S264210AbTDWSIS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 14:08:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

James -

The new printk for BLIST_INQUIRY_36 is getting a warning, and the
repeat_inquiry code is not quite right, since we reset *bflags after
getting the first INQUIRY.

Get rid of the warning, change the or-ing of the bflags settings, and get
rid of an extraneous BUG_ON.

===== drivers/scsi/scsi_scan.c 1.78 vs edited =====
--- 1.78/drivers/scsi/scsi_scan.c	Mon Apr 21 12:20:25 2003
+++ edited/drivers/scsi/scsi_scan.c	Wed Apr 23 10:22:53 2003
@@ -1001,6 +1001,7 @@
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int possible_inq_resp_len;
 
+	*bflags = 0;
  repeat_inquiry:
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: INQUIRY to host %d"
 			" channel %d id %d lun %d\n", sdev->host->host_no,
@@ -1041,8 +1042,7 @@
 	 * bit fields in Scsi_Device, so bflags need not be passed as an
 	 * argument.
 	 */
-	BUG_ON(bflags == NULL);
-	*bflags = scsi_get_device_flags(&inq_result[8], &inq_result[16]);
+	*bflags |= scsi_get_device_flags(&inq_result[8], &inq_result[16]);
 
 	possible_inq_resp_len = (unsigned char) inq_result[4] + 5;
 	if (BLIST_INQUIRY_36 & *bflags)
@@ -1072,8 +1072,11 @@
 			/* if the longer inquiry has failed, flag the device
 			 * as only accepting 36 byte inquiries and retry the
 			 * 36 byte inquiry */
-			printk(KERN_INFO "scsi scan: %d byte inquiry failed with code %d.  Consider BLIST_INQUIRY_36 for this device\n", sreq->sr_result);
-			*bflags |= BLIST_INQUIRY_36;
+			printk(KERN_INFO "scsi scan: %d byte inquiry failed"
+			       " with code %d.  Consider BLIST_INQUIRY_36 for"
+			       " this device\n", possible_inq_resp_len,
+			       sreq->sr_result);
+			*bflags = BLIST_INQUIRY_36;
 			goto repeat_inquiry;
 		}
 
