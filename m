From: Stuart_Hayes@Dell.com
Subject: [PATCH] ide-scsi.c:  Fix tape drive block limits problem
Date: Wed, 10 Sep 2003 14:21:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <CE41BFEF2481C246A8DE0D2B4DBACF4F128A13@ausx2kmpc106.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausadmmsrr503.aus.amer.dell.com ([143.166.83.90]:64527 "HELO
	AUSADMMSRR503.aus.amer.dell.com") by vger.kernel.org with SMTP
	id S265661AbTIJTVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 15:21:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


IDE tape drives return "st0: Error with sense data: Current st09:00: sense
key illegal request ... Additional sense indicates Invalid command operation
code" error message when using drive.  This occurs because st.c tries to
issue a "read block limits" SCSI command when opening the device.  IDE tape
drives are not required to support this command (SCSI tapes are), but IDE
tapes do have to report the block sizes they support (512 and/or 1024 bytes
only) in mode page 0x2A.

This patch looks for "read block limits" commands being sent to tape drives,
and changes them into "mode sense" commands to read mode page 0x2A.  The
data that's returned is reformatted to look like the results of a "read
block limits" command (it will return block limits of minimum 512 (or 1024,
if 512 isn't supported), maximum of 1024 (or 512, if 1024 isn't supported),
with a granularity of 9 (512 bytes).

This patch is for kernel 2.4.22 (for ide-scsi.c ver 0.93).

Thanks
Stuart
---------------



diff -uNr linux-2.4.21-1.1931.2.421.ent/drivers/scsi/ide-scsi.c
linux-2.4.21-1.1931.2.421.ent.idescsifix/drivers/scsi/ide-scsi.c
--- linux-2.4.21-1.1931.2.421.ent/drivers/scsi/ide-scsi.c	2003-09-02
16:52:26.000000000 -0500
+++ linux-2.4.21-1.1931.2.421.ent.idescsifix/drivers/scsi/ide-scsi.c
2003-09-09 11:16:51.000000000 -0500
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/scsi/ide-scsi.c	Version 0.93    June 10, 2002
+ * linux/drivers/scsi/ide-scsi.c	Version 0.94    Sept 09, 2003
  *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2001 - 2002 Andre Hedrick <andre@linux-ide.org>
@@ -35,9 +35,12 @@
  * Ver 0.92  Mar 21 02   Include DevFs support
  *                        Borsenkow Andrej
<Andrej.Borsenkow@mow.siemens.ru>
  * Ver 0.93  Jun 10 02   Fix "off by one" error in transforms
+ * Ver 0.94  Sep 09 03   Added transform for reading ATAPI tape drive block
+ *                        limits (ATAPI tapes report block limits in mode
+ *                        page 0x2A, not by "read block limits" command)
  */
 
-#define IDESCSI_VERSION "0.93"
+#define IDESCSI_VERSION "0.94"
 
 #include <linux/module.h>
 #include <linux/config.h>
@@ -234,6 +237,25 @@
 			pc->buffer_size += 4;
 		}
 	}
+	if (drive->media == ide_tape) {
+		if (sc[0] == READ_BLOCK_LIMITS) {	/* IDE tapes have
blk lmts in mode page 0x2a */
+			if (!scsi_buf)
+				return;
+			/* buffer size should be 6 for READ_BLOCK_LIMITS
*/
+			/* we need 12 bytes (4 for header + 8 for mode page
*/
+			if ((atapi_buf = kmalloc(12, GFP_ATOMIC)) == NULL)
+				return;
+			memset(atapi_buf, 0, 12);
+			memset (c, 0, 12);
+			c[0] = MODE_SENSE;
+			c[1] = 8;  	/* no block descriptors     */
+			c[2] = 0x2A;	/* mode page 0x2A           */
+			c[4] = 12;	/* buffer length 12 decimal */
+			pc->buffer = atapi_buf;
+			pc->request_transfer = 12;
+			pc->buffer_size = 12;
+		}
+	}
 }
 
 static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t
*pc)
@@ -262,7 +284,19 @@
 			/* response data format */
 			scsi_buf[3] = (scsi_buf[3] & 0xf0) | 2;
 		}
+	}	
+	if (drive->media == ide_tape) {
+		if (sc[0] == READ_BLOCK_LIMITS) {
+			memset(scsi_buf, 0, pc->scsi_cmd->request_bufflen);
+			/* granularity of 9 (always 9 for ide tapes) */
+			scsi_buf[0] = 9;
+			/* block length of 1024 bytes supported? */
+			scsi_buf[2] = (atapi_buf[11] & 0x04) ? 4 : 2;
+			/* block length of 512 bytes supported?  */
+			scsi_buf[4] = (atapi_buf[11] & 0x02) ? 2 : 4;
+		}
 	}
+
 	if (atapi_buf && atapi_buf != scsi_buf)
 		kfree(atapi_buf);
 }



