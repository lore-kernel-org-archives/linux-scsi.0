From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] Fix up scsi_test_unit_ready() to work correctly with CD-ROMs
Date: 09 Sep 2004 09:58:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094738299.1837.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:55730 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264443AbUIIN6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2004 09:58:21 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i89DwIJ26279
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2004 09:58:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Olaf Hering noticed that SG_IO was no-longer working correctly on some
CD-ROMS.  The reason is a change in behaviour induced by switching to
the new scsi_test_unit_ready() API.

Apparently the CD-ROM special case needs to ignore both UNIT_ATTENTION
and NOT_READY for removable media.

James

===== drivers/scsi/scsi_lib.c 1.133 vs edited =====
--- 1.133/drivers/scsi/scsi_lib.c	Tue Sep  7 16:48:51 2004
+++ edited/drivers/scsi/scsi_lib.c	Wed Sep  8 22:22:27 2004
@@ -1585,11 +1585,12 @@
 	if (!sreq)
 		return -ENOMEM;
 
-		sreq->sr_data_direction = DMA_NONE;
-        scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
+	sreq->sr_data_direction = DMA_NONE;
+	scsi_wait_req(sreq, cmd, NULL, 0, timeout, retries);
 
 	if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) &&
-	    (sreq->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION &&
+	    ((sreq->sr_sense_buffer[2] & 0x0f) == UNIT_ATTENTION ||
+	     (sreq->sr_sense_buffer[2] & 0x0f) == NOT_READY) &&
 	    sdev->removable) {
 		sdev->changed = 1;
 		sreq->sr_result = 0;



