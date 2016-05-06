From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] cciss: replace custom function to hexdump
Date: Fri,  6 May 2016 21:55:51 +0300
Message-ID: <1462560951-103680-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37506 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119AbcEFSz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 14:55:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Christoph Hellwig <hch@lst.de>

For small buffers we may use %*ph[N] specifier, for the bigger blocks
print_hex_dump() call.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/block/cciss_scsi.c | 72 +++++++---------------------------------------
 1 file changed, 10 insertions(+), 62 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 1537302..8988131 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -260,43 +260,6 @@ scsi_cmd_stack_free(ctlr_info_t *h)
 }
 
 #if 0
-static int xmargin=8;
-static int amargin=60;
-
-static void
-print_bytes (unsigned char *c, int len, int hex, int ascii)
-{
-
-	int i;
-	unsigned char *x;
-
-	if (hex)
-	{
-		x = c;
-		for (i=0;i<len;i++)
-		{
-			if ((i % xmargin) == 0 && i>0) printk("\n");
-			if ((i % xmargin) == 0) printk("0x%04x:", i);
-			printk(" %02x", *x);
-			x++;
-		}
-		printk("\n");
-	}
-	if (ascii)
-	{
-		x = c;
-		for (i=0;i<len;i++)
-		{
-			if ((i % amargin) == 0 && i>0) printk("\n");
-			if ((i % amargin) == 0) printk("0x%04x:", i);
-			if (*x > 26 && *x < 128) printk("%c", *x);
-			else printk(".");
-			x++;
-		}
-		printk("\n");
-	}
-}
-
 static void
 print_cmd(CommandList_struct *cp)
 {
@@ -305,30 +268,13 @@ print_cmd(CommandList_struct *cp)
 	printk("sgtot:%d\n", cp->Header.SGTotal);
 	printk("Tag:0x%08x/0x%08x\n", cp->Header.Tag.upper, 
 			cp->Header.Tag.lower);
-	printk("LUN:0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-		cp->Header.LUN.LunAddrBytes[0],
-		cp->Header.LUN.LunAddrBytes[1],
-		cp->Header.LUN.LunAddrBytes[2],
-		cp->Header.LUN.LunAddrBytes[3],
-		cp->Header.LUN.LunAddrBytes[4],
-		cp->Header.LUN.LunAddrBytes[5],
-		cp->Header.LUN.LunAddrBytes[6],
-		cp->Header.LUN.LunAddrBytes[7]);
+	printk("LUN:0x%8phN\n", cp->Header.LUN.LunAddrBytes);
 	printk("CDBLen:%d\n", cp->Request.CDBLen);
 	printk("Type:%d\n",cp->Request.Type.Type);
 	printk("Attr:%d\n",cp->Request.Type.Attribute);
 	printk(" Dir:%d\n",cp->Request.Type.Direction);
 	printk("Timeout:%d\n",cp->Request.Timeout);
-	printk( "CDB: %02x %02x %02x %02x %02x %02x %02x %02x"
-		" %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		cp->Request.CDB[0], cp->Request.CDB[1],
-		cp->Request.CDB[2], cp->Request.CDB[3],
-		cp->Request.CDB[4], cp->Request.CDB[5],
-		cp->Request.CDB[6], cp->Request.CDB[7],
-		cp->Request.CDB[8], cp->Request.CDB[9],
-		cp->Request.CDB[10], cp->Request.CDB[11],
-		cp->Request.CDB[12], cp->Request.CDB[13],
-		cp->Request.CDB[14], cp->Request.CDB[15]),
+	printk( "CDB: %16ph\n", cp->Request.CDB);
 	printk("edesc.Addr: 0x%08x/0%08x, Len  = %d\n", 
 		cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower, 
 			cp->ErrDesc.Len);
@@ -340,9 +286,7 @@ print_cmd(CommandList_struct *cp)
 	printk("offense size:%d\n", cp->err_info->MoreErrInfo.Invalid_Cmd.offense_size);
 	printk("offense byte:%d\n", cp->err_info->MoreErrInfo.Invalid_Cmd.offense_num);
 	printk("offense value:%d\n", cp->err_info->MoreErrInfo.Invalid_Cmd.offense_value);
-			
 }
-
 #endif
 
 static int 
@@ -782,8 +726,10 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 					"reported\n", c);
 			break;
 			case CMD_INVALID: {
-				/* print_bytes(c, sizeof(*c), 1, 0);
-				print_cmd(c); */
+				/*
+				print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1, c, sizeof(*c), false);
+				print_cmd(c);
+				 */
      /* We get CMD_INVALID if you address a non-existent tape drive instead
 	of a selection timeout (no response).  You will see this if you yank 
 	out a tape drive, then try to access it. This is kind of a shame
@@ -985,8 +931,10 @@ cciss_scsi_interpret_error(ctlr_info_t *h, CommandList_struct *c)
 			dev_warn(&h->pdev->dev,
 				"%p is reported invalid (probably means "
 				"target device no longer present)\n", c);
-			/* print_bytes((unsigned char *) c, sizeof(*c), 1, 0);
-			print_cmd(c);  */
+			/*
+			print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1, c, sizeof(*c), false);
+			print_cmd(c);
+			 */
 			}
 		break;
 		case CMD_PROTOCOL_ERR:
-- 
2.8.1

