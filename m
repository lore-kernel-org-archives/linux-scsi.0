From: David Jeffery <david_jeffery@adaptec.com>
Subject: [PATCH 2.6] ips 2/2: minor fixes
Date: Thu, 15 Jan 2004 12:41:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074188494.607.20.camel@blackmagic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tLX9qXGYg0aGfIYjluUa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:26784 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265205AbUAORiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 12:38:16 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i0FHcGJ06577
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2004 09:38:16 -0800
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i0FHcE825805
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2004 09:38:14 -0800
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-tLX9qXGYg0aGfIYjluUa
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch fixes two minor bugs.  It allows zero length write commands
through to devices.  It also prevents the writing of any  '\0'
characters at the end of version numbers to ips's /proc/scsi files.

David Jeffery

--=-tLX9qXGYg0aGfIYjluUa
Content-Disposition: attachment; filename=ips.patch2
Content-Type: text/x-patch; name=ips.patch2; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 7bit

diff -ur linux-2.6.1_p1/drivers/scsi/ips.c linux-2.6.1_p2/drivers/scsi/ips.c
--- linux-2.6.1_p1/drivers/scsi/ips.c	2004-01-13 14:10:51.000000000 -0500
+++ linux-2.6.1_p2/drivers/scsi/ips.c	2004-01-13 14:10:57.000000000 -0500
@@ -2160,27 +2160,60 @@
 
 	copy_info(&info, "\tIRQ number                        : %d\n", ha->irq);
 
-	if (le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG)
-		copy_info(&info,
-			  "\tBIOS Version                      : %c%c%c%c%c%c%c%c\n",
-			  ha->nvram->bios_high[0], ha->nvram->bios_high[1],
-			  ha->nvram->bios_high[2], ha->nvram->bios_high[3],
-			  ha->nvram->bios_low[0], ha->nvram->bios_low[1],
-			  ha->nvram->bios_low[2], ha->nvram->bios_low[3]);
-
-	copy_info(&info,
-		  "\tFirmware Version                  : %c%c%c%c%c%c%c%c\n",
-		  ha->enq->CodeBlkVersion[0], ha->enq->CodeBlkVersion[1],
-		  ha->enq->CodeBlkVersion[2], ha->enq->CodeBlkVersion[3],
-		  ha->enq->CodeBlkVersion[4], ha->enq->CodeBlkVersion[5],
-		  ha->enq->CodeBlkVersion[6], ha->enq->CodeBlkVersion[7]);
-
-	copy_info(&info,
-		  "\tBoot Block Version                : %c%c%c%c%c%c%c%c\n",
-		  ha->enq->BootBlkVersion[0], ha->enq->BootBlkVersion[1],
-		  ha->enq->BootBlkVersion[2], ha->enq->BootBlkVersion[3],
-		  ha->enq->BootBlkVersion[4], ha->enq->BootBlkVersion[5],
-		  ha->enq->BootBlkVersion[6], ha->enq->BootBlkVersion[7]);
+    /* For the Next 3 lines Check for Binary 0 at the end and don't include it if it's there. */
+    /* That keeps everything happy for "text" operations on the proc file.                    */
+
+	if (le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) {
+        if (ha->nvram->bios_low[3] == 0) { 
+            copy_info(&info,
+			          "\tBIOS Version                      : %c%c%c%c%c%c%c\n",
+			          ha->nvram->bios_high[0], ha->nvram->bios_high[1],
+			          ha->nvram->bios_high[2], ha->nvram->bios_high[3],
+			          ha->nvram->bios_low[0], ha->nvram->bios_low[1],
+			          ha->nvram->bios_low[2]);
+
+        } else {
+		    copy_info(&info,
+			          "\tBIOS Version                      : %c%c%c%c%c%c%c%c\n",
+			          ha->nvram->bios_high[0], ha->nvram->bios_high[1],
+			          ha->nvram->bios_high[2], ha->nvram->bios_high[3],
+			          ha->nvram->bios_low[0], ha->nvram->bios_low[1],
+			          ha->nvram->bios_low[2], ha->nvram->bios_low[3]);
+        }
+
+    }
+
+    if (ha->enq->CodeBlkVersion[7] == 0) {
+        copy_info(&info,
+		          "\tFirmware Version                  : %c%c%c%c%c%c%c\n",
+		          ha->enq->CodeBlkVersion[0], ha->enq->CodeBlkVersion[1],
+		          ha->enq->CodeBlkVersion[2], ha->enq->CodeBlkVersion[3],
+		          ha->enq->CodeBlkVersion[4], ha->enq->CodeBlkVersion[5],
+		          ha->enq->CodeBlkVersion[6]);
+    } else {
+        copy_info(&info,
+		          "\tFirmware Version                  : %c%c%c%c%c%c%c%c\n",
+		          ha->enq->CodeBlkVersion[0], ha->enq->CodeBlkVersion[1],
+		          ha->enq->CodeBlkVersion[2], ha->enq->CodeBlkVersion[3],
+		          ha->enq->CodeBlkVersion[4], ha->enq->CodeBlkVersion[5],
+		          ha->enq->CodeBlkVersion[6], ha->enq->CodeBlkVersion[7]);
+    }
+
+    if (ha->enq->BootBlkVersion[7] == 0) {
+        copy_info(&info,
+		          "\tBoot Block Version                : %c%c%c%c%c%c%c\n",
+		          ha->enq->BootBlkVersion[0], ha->enq->BootBlkVersion[1],
+		          ha->enq->BootBlkVersion[2], ha->enq->BootBlkVersion[3],
+		          ha->enq->BootBlkVersion[4], ha->enq->BootBlkVersion[5],
+		          ha->enq->BootBlkVersion[6]);
+    } else {
+        copy_info(&info,
+		          "\tBoot Block Version                : %c%c%c%c%c%c%c%c\n",
+		          ha->enq->BootBlkVersion[0], ha->enq->BootBlkVersion[1],
+		          ha->enq->BootBlkVersion[2], ha->enq->BootBlkVersion[3],
+		          ha->enq->BootBlkVersion[4], ha->enq->BootBlkVersion[5],
+		          ha->enq->BootBlkVersion[6], ha->enq->BootBlkVersion[7]);
+    }
 
 	copy_info(&info, "\tDriver Version                    : %s%s\n",
 		  IPS_VERSION_HIGH, IPS_VERSION_LOW);
@@ -2842,6 +2875,11 @@
 		scb->dcdb.cmd_attribute =
 		    ips_command_direction[scb->scsi_cmd->cmnd[0]];
 
+        /* Allow a WRITE BUFFER Command to Have no Data */
+        /* This is Used by Tape Flash Utilites          */
+        if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0)) 
+            scb->dcdb.cmd_attribute = 0;                  
+
 		if (!(scb->dcdb.cmd_attribute & 0x3))
 			scb->dcdb.transfer_length = 0;
 

--=-tLX9qXGYg0aGfIYjluUa--

