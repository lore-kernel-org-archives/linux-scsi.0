From: Joe Perches <joe@perches.com>
Subject: [PATCH] scsi: fas216: Add __printf validation, fix fallout
Date: Sun, 30 Apr 2017 14:50:11 -0700
Message-ID: <ea0f8cf0ba961817f13225a5444c76a86e2ea610.1493588987.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:59262 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1424701AbdD3VuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Apr 2017 17:50:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <linux@armlinux.org.uk>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

__printf makes the compiler check format and arguments.

Fix fallout.

Miscellanea:

o Convert formats to const char *
o Use vsprintf extension %pV instead of a static buffer.
o Add newline to logging and remove now unnecessary printk("\n")
o Use pr_cont where appropriate

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/arm/fas216.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 24388795ee9a..112bec886192 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -289,17 +289,20 @@ static char fas216_target(FAS216_Info *info)
 		return 'H';
 }
 
-static void
-fas216_do_log(FAS216_Info *info, char target, char *fmt, va_list ap)
+__printf(3, 0) static void
+fas216_do_log(FAS216_Info *info, char target, const char *fmt, va_list ap)
 {
-	static char buf[1024];
+	struct va_format vaf;
+
+	vaf.fmt = fmt;
+	vaf.va = &ap;
 
-	vsnprintf(buf, sizeof(buf), fmt, ap);
-	printk("scsi%d.%c: %s", info->host->host_no, target, buf);
+	printk("scsi%d.%c: %pV\n", info->host->host_no, target, &vaf);
 }
 
+__printf(4, 5)
 static void fas216_log_command(FAS216_Info *info, int level,
-			       struct scsi_cmnd *SCpnt, char *fmt, ...)
+			       struct scsi_cmnd *SCpnt, const char *fmt, ...)
 {
 	va_list args;
 
@@ -313,8 +316,9 @@ static void fas216_log_command(FAS216_Info *info, int level,
 	scsi_print_command(SCpnt);
 }
 
-static void
-fas216_log_target(FAS216_Info *info, int level, int target, char *fmt, ...)
+__printf(4, 5) static void
+fas216_log_target(FAS216_Info *info, int level, int target,
+		  const char *fmt, ...)
 {
 	va_list args;
 
@@ -329,11 +333,10 @@ fas216_log_target(FAS216_Info *info, int level, int target, char *fmt, ...)
 	va_start(args, fmt);
 	fas216_do_log(info, target, fmt, args);
 	va_end(args);
-
-	printk("\n");
 }
 
-static void fas216_log(FAS216_Info *info, int level, char *fmt, ...)
+__printf(3, 4)
+static void fas216_log(FAS216_Info *info, int level, const char *fmt, ...)
 {
 	va_list args;
 
@@ -343,8 +346,6 @@ static void fas216_log(FAS216_Info *info, int level, char *fmt, ...)
 	va_start(args, fmt);
 	fas216_do_log(info, fas216_target(info), fmt, args);
 	va_end(args);
-
-	printk("\n");
 }
 
 #define PH_SIZE	32
@@ -431,7 +432,7 @@ fas216_get_last_msg(FAS216_Info *info, int pos)
 	}
 
 	fas216_log(info, LOG_MESSAGES,
-		"Message: %04x found at position %02x\n", packed_msg, pos);
+		   "Message: %04x found at position %02x", packed_msg, pos);
 
 	return packed_msg;
 }
@@ -725,7 +726,7 @@ static void fas216_cleanuptransfer(FAS216_Info *info)
 	fifo = fas216_readb(info, REG_CFIS) & CFIS_CF;
 
 	fas216_log(info, LOG_BUFFER, "cleaning up from previous "
-		   "transfer: length 0x%06x, residual 0x%x, fifo %d",
+		   "transfer: length 0x%06lx, residual 0x%lx, fifo %ld",
 		   total, residual, fifo);
 
 	/*
@@ -1144,8 +1145,8 @@ static void fas216_parse_message(FAS216_Info *info, unsigned char *message, int
 	fas216_log(info, 0, "unrecognised message, rejecting");
 	printk("scsi%d.%c: message was", info->host->host_no, fas216_target(info));
 	for (i = 0; i < msglen; i++)
-		printk("%s%02X", i & 31 ? " " : "\n  ", message[i]);
-	printk("\n");
+		pr_cont("%s%02X", i & 31 ? " " : "\n  ", message[i]);
+	pr_cont("\n");
 
 	/*
 	 * Something strange seems to be happening here -
@@ -1582,7 +1583,7 @@ static void fas216_funcdone_intr(FAS216_Info *info, unsigned int stat, unsigned
 	default:
 		fas216_log(info, 0, "internal phase %s for function done?"
 			"  What do I do with this?",
-			fas216_target(info), fas216_drv_phase(info));
+			fas216_drv_phase(info));
 	}
 }
 
@@ -1642,7 +1643,7 @@ irqreturn_t fas216_intr(FAS216_Info *info)
 			fas216_bus_reset(info);
 			scsi_report_bus_reset(info->host, 0);
 		} else if (inst & INST_ILLEGALCMD) {
-			fas216_log(info, LOG_ERROR, "illegal command given\n");
+			fas216_log(info, LOG_ERROR, "illegal command given");
 			fas216_dumpstate(info);
 			print_debug_list();
 		} else if (inst & INST_DISCONNECT)
-- 
2.10.0.rc2.1.g053435c
