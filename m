From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_status() macro
Date: Fri, 16 May 2003 09:50:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC427D5.3060309@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070302020601070402030203"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:35337 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264294AbTEOXhP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 19:37:15 -0400
Received: from torque.net (d-241-253.stlucia.uq.net.au [203.101.241.253])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4FNo2hp011292
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2003 09:50:03 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070302020601070402030203
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here is a replacement macro for status_byte().
Leave the status_byte() macro and mark it as deprecated.

Doug Gilbert

--------------070302020601070402030203
Content-Type: text/plain;
 name="scsi_h2569bk8cc.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_h2569bk8cc.diff"

--- linux/drivers/scsi/scsi.h	2003-05-14 18:09:21.000000000 +1000
+++ linux/drivers/scsi/scsi.h2569bk8cc	2003-05-16 09:47:11.469708960 +1000
@@ -90,12 +90,19 @@
  *
  *  These are set by:
  *
- *      status byte = set from target device
+ *      status byte = set from target device (SCSI status value)
  *      msg_byte    = return status from host adapter itself.
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
+ *
+ *  Notes about following macros:
+ *	scsi_status() returns a standard SCSI status value that may
+ *	be compared with the SAM_STAT_... series of defines.
+ *	status_byte() returns a shifted SCSI status value that matches
+ *	CHECK_CONDITION and friends. status_byte() is deprecated.
  */
-#define status_byte(result) (((result) >> 1) & 0x1f)
+#define scsi_status(result) ((result) & 0x7e)
+#define status_byte(result) (((result) >> 1) & 0x1f)	/* deprecated */
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)

--------------070302020601070402030203--

