From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] dec_esp: Fix mapping of ESP.
Date: Sat, 15 Oct 2005 02:41:36 +0100
Message-ID: <20051015014136.GA25316@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:24841 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S932250AbVJQKLp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:11:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>

FYI and reviewing pleassure.

Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Mon Jun 13 19:55:42 2005 +0000

These should really be addresses obtained with ioremap() or some
bus-specific backend, but for now...

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>


 drivers/scsi/dec_esp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: manual.git/drivers/scsi/dec_esp.c
===================================================================
--- manual.git.orig/drivers/scsi/dec_esp.c
+++ manual.git/drivers/scsi/dec_esp.c
@@ -228,7 +228,7 @@ static int dec_esp_detect(Scsi_Host_Temp
 			mem_start = get_tc_base_addr(slot);
 
 			/* Store base addr into esp struct */
-			esp->slot = PHYSADDR(mem_start);
+			esp->slot = CPHYSADDR(mem_start);
 
 			esp->dregs = 0;
 			esp->eregs = (struct ESP_regs *) (mem_start + DEC_SCSI_SREG);
