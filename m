From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi SEND DIAGNOSTIC timeout 2.4.21-pre6
Date: Fri, 04 Apr 2003 22:31:13 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8D7B11.1070708@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080206090309040908010206"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:11282 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263690AbTDDMTJ (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2003 07:19:09 -0500
List-Id: linux-scsi@vger.kernel.org
To: marcelo@hera.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080206090309040908010206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Marcelo,
While working with smartmontools I found that an
extended foreground self-test failed because the
SCSI command that sends it: SEND DIAGNOSTIC, has a
normal timeout value of 10 seconds. With my 18 GB
disk this test takes 12 minutes. Larger disks can
take up to an hour.

This patch makes the SCSI_IOCTL_SEND_COMMAND ioctl's
timeout for SEND DIAGNOSTIC the same as it is for
FORMAT (2 hours).

The scsi_ioctl.c file is the same in lk 2.4.20 and
lk 2.4.21-pre6 .

Doug Gilbert

--------------080206090309040908010206
Content-Type: text/plain;
 name="scsi_ioctl_2420sd.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_ioctl_2420sd.diff"

--- linux/drivers/scsi/scsi_ioctl.c	2002-08-09 01:31:46.000000000 +1000
+++ linux/drivers/scsi/scsi_ioctl.c2420sd	2003-04-04 21:58:44.000000000 +1000
@@ -282,6 +282,7 @@
 		cmd[1] = (cmd[1] & 0x1f) | (dev->lun << 5);
 
 	switch (opcode) {
+	case SEND_DIAGNOSTIC:
 	case FORMAT_UNIT:
 		timeout = FORMAT_UNIT_TIMEOUT;
 		retries = 1;

--------------080206090309040908010206--

