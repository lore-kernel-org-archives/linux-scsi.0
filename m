From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_ioctl.c for SEND_DIAGNOSTIC
Date: Wed, 26 Mar 2003 20:02:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E817A9F.7090502@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040005060505040609010902"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-241-56.stlucia.uq.net.au [203.101.241.56])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h2QA3H54011984
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2003 20:03:26 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040005060505040609010902
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

While doing foreground extended self tests with
smartmontools I found that the timeout was much to
short for SCSI_IOCTL_SEND_COMMAND. On my 18 GB
disk that test takes about 12 minutes.

Attachment extends timeout to the same as FORMAT
(i.e. 2 hours). The patch is against lk 2.5.66 .

BTW Foreground extended self tests (and FORMATs :-))
should not be done on disks with mounted partitions.

Doug Gilbert

--------------040005060505040609010902
Content-Type: text/plain;
 name="scsi_ioctl_2566.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_ioctl_2566.diff"

--- linux/drivers/scsi/scsi_ioctl.c	2003-03-05 21:01:15.000000000 +1000
+++ linux/drivers/scsi/scsi_ioctl.c2566dpg	2003-03-26 19:47:18.000000000 +1000
@@ -298,6 +298,7 @@
 		goto error;
 
 	switch (opcode) {
+	case SEND_DIAGNOSTIC:
 	case FORMAT_UNIT:
 		timeout = FORMAT_UNIT_TIMEOUT;
 		retries = 1;

--------------040005060505040609010902--


