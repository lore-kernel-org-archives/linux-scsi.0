From: Mike Anderson <andmike@us.ibm.com>
Subject: status_byte() and SAM TASK_ABORTED
Date: Thu, 16 Dec 2004 10:32:33 -0800
Message-ID: <20041216183233.GB2722@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:19882 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261974AbULPSdD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 13:33:03 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBGIX2DP533188
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 13:33:02 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBGIX2Vt222352
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 11:33:02 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBGIX1A0011670
	for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2004 11:33:01 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: garloff@suse.de, dledford@redhat.com

Recently the old issue of the status_byte() macro masking off a
TASK_ABORTED status was brought to my attention by Martin Peschke and
Maxim Shchetynin.

For context here are some old discussions on this issue.
http://marc.theaimsgroup.com/?t=105601234500006&r=1&w=2
http://marc.theaimsgroup.com/?t=105609933000005&r=1&w=2
http://marc.theaimsgroup.com/?t=105304284100002&r=1&w=2
http://marc.theaimsgroup.com/?t=102225346500001&r=1&w=2

Kurt refreshed a patch for 2.6 that increases the mask value for the
status_byte macro (provided below). While this stops TASK_ABORTED falling
into the GOOD case statement in scsi_decide_disposition without adding
TASK_ABORTED to the case statement we will start up the error handler on
this command which is probably not what we want.

It was mentioned that masking off the TASK_ABORTED as we do now could lead
to a DI issue, but in experimentation with a hacked scsi_debug to return
TASK_ABORTED I did not see good status for blk IO through sd. In code
review it would appear there possibly could be an issue sg_io passing
good_status back to a user.

Example out with hacked scsi_debug fo blk IO through sd:
scsi_debug: cmd 28 00 00 00 12 00 00 02 00 00
scsi_debug: ... <5 0 0 0> non-zero result=0x40
SCSI error : <5 0 0 0> return code = 0x40
end_request: I/O error, dev sdd, sector 4608
Buffer I/O error on device sdd, logical block 576

If not this patch it would seem that we should adopt some solution to not
ignore TASK_ABORTED.

-andmike
--
Michael Anderson
andmike@us.ibm.com


--- linux-2.6.8/include/scsi/scsi.h.orig	2004-11-29 13:32:39.000000000 +0100
+++ linux-2.6.8/include/scsi/scsi.h	2004-12-15 23:33:35.563661314 +0100
@@ -169,8 +169,10 @@
 #define RESERVATION_CONFLICT 0x0c
 #define COMMAND_TERMINATED   0x11
 #define QUEUE_FULL           0x14
+#define ACA_ACTIVE           0x18
+#define TASK_ABORTED         0x20
 
-#define STATUS_MASK          0x3e
+#define STATUS_MASK          0xfe
 
 /*
  *  SENSE KEYS
@@ -348,7 +350,7 @@
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
  */
-#define status_byte(result) (((result) >> 1) & 0x1f)
+#define status_byte(result) (((result) >> 1) & 0x7f)
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)
