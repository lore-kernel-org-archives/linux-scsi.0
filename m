From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug delayed result, lk 2.4.27
Date: Tue, 31 Aug 2004 22:33:14 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4134700A.30701@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070308000101030304030502"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:45747 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268092AbUHaMdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 08:33:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: marcelo.tosatti@cyclades.com

This is a multi-part message in MIME format.
--------------070308000101030304030502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The error result code is not conveyed back to the mid-level
for delayed commands (i.e. when scsi_debug_delay!=0) in
lk 2.4.27 (and earlier). [This bug is not present in the
lk 2.6 version of scsi_debug.]

Change:
     - convey error result back to midlevel for delayed commands

Doug Gilbert

--------------070308000101030304030502
Content-Type: text/x-patch;
 name="scsi_debug2427.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug2427.diff"

--- linux/drivers/scsi/scsi_debug.c	2003-03-20 20:28:33.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c2427fix	2004-08-31 20:01:41.674371448 +1000
@@ -48,7 +48,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 0.62 (20030320)";
+static const char * scsi_debug_version_str = "Version: 0.63 (20040831)";
 
 
 #ifndef SCSI_CMD_READ_16
@@ -772,8 +772,10 @@
 		return;
 	}
 	sqcp->in_use = 0;
-	if (sqcp->done_funct)
+	if (sqcp->done_funct) {
+		sqcp->a_cmnd->result = sqcp->scsi_result;
 		sqcp->done_funct(sqcp->a_cmnd); /* callback to mid level */
+	}
 	sqcp->done_funct = NULL;
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }

--------------070308000101030304030502--
