From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] dec_esp: Use physical addresses
Date: Sat, 15 Oct 2005 02:26:31 +0100
Message-ID: <20051015012630.GA20981@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:63261 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S932251AbVJQKLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:11:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>

FYI.  This is part of a larger MIPS patch which I'd like to submit
to akpm as a single patch.

Use physical addresses at the interface level, letting drivers remap
them as appropriate.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>


Index: manual.git/drivers/scsi/dec_esp.c
===================================================================
--- manual.git.orig/drivers/scsi/dec_esp.c
+++ manual.git/drivers/scsi/dec_esp.c
@@ -18,7 +18,7 @@
  * 20001005	- Initialization fixes for 2.4.0-test9
  * 			  Florian Lohoff <flo@rfc822.org>
  *
- *	Copyright (C) 2002, 2003  Maciej W. Rozycki
+ *	Copyright (C) 2002, 2003, 2005  Maciej W. Rozycki
  */
 
 #include <linux/kernel.h>
@@ -41,6 +41,7 @@
 #include <asm/dec/ioasic_addrs.h>
 #include <asm/dec/ioasic_ints.h>
 #include <asm/dec/machtype.h>
+#include <asm/dec/system.h>
 #include <asm/dec/tc.h>
 
 #define DEC_SCSI_SREG 0
@@ -183,7 +184,8 @@ static int dec_esp_detect(Scsi_Host_Temp
 		esp->dregs = 0;
 
 		/* ESP register base */
-		esp->eregs = (struct ESP_regs *) (system_base + IOASIC_SCSI);
+		esp->eregs = (void *)CKSEG1ADDR(dec_kn_slot_base +
+						IOASIC_SCSI);
 
 		/* Set the command buffer */
 		esp->esp_command = (volatile unsigned char *) cmd_buffer;
@@ -228,10 +230,11 @@ static int dec_esp_detect(Scsi_Host_Temp
 			mem_start = get_tc_base_addr(slot);
 
 			/* Store base addr into esp struct */
-			esp->slot = CPHYSADDR(mem_start);
+			esp->slot = mem_start;
 
 			esp->dregs = 0;
-			esp->eregs = (struct ESP_regs *) (mem_start + DEC_SCSI_SREG);
+			esp->eregs = (void *)CKSEG1ADDR(mem_start +
+							DEC_SCSI_SREG);
 			esp->do_pio_cmds = 1;
 
 			/* Set the command buffer */
