From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] minor scsi_lib.c cleanup for 2.5.64
Date: Sun, 09 Mar 2003 23:31:11 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6B421F.8070005@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090304090404050601000200"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-242-8.stlucia.uq.net.au [203.101.242.8])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h29DV5Gf022161
	for <linux-scsi@vger.kernel.org>; Sun, 9 Mar 2003 23:31:05 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090304090404050601000200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The following patch made the trail in /var/log/messages
a little easier to follow (for me). Just a cosmetic change.

Doug Gilbert

--------------090304090404050601000200
Content-Type: text/plain;
 name="scsi_lib_2564dpg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_lib_2564dpg.diff"

--- linux/drivers/scsi/scsi_lib.c	2003-03-01 12:23:04.000000000 +1000
+++ linux/drivers/scsi/scsi_lib.c2564dpg	2003-03-09 21:05:27.000000000 +1000
@@ -812,7 +812,7 @@
 			       cmd->device->host->host_no, (int) cmd->device->channel,
 			       (int) cmd->device->id, (int) cmd->device->lun);
 			print_command(cmd->data_cmnd);
-			print_sense("sd", cmd);
+			print_sense("", cmd);
 			cmd = scsi_end_request(cmd, 0, block_sectors, 1);
 			return;
 		default:
@@ -832,7 +832,7 @@
 		struct Scsi_Device_Template *sdt;
 
 		sdt = scsi_get_request_dev(cmd->request);
-		printk("SCSI %s error : host %d channel %d id %d lun %d return code = %x\n",
+		printk("SCSI %s error : <%d %d %d %d> return code = 0x%x\n",
 		       (sdt ? sdt->name : "device"),
 		       cmd->device->host->host_no,
 		       cmd->device->channel,
@@ -840,7 +840,7 @@
 		       cmd->device->lun, result);
 
 		if (driver_byte(result) & DRIVER_SENSE)
-			print_sense("sd", cmd);
+			print_sense("", cmd);
 		/*
 		 * Mark a single buffer as not uptodate.  Queue the remainder.
 		 * We sometimes get this cruft in the event that a medium error

--------------090304090404050601000200--

