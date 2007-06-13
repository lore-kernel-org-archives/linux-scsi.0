From: vignesh babu <vignesh.babu@wipro.com>
Subject: [PATCH][RESEND]is_power_of_2-scsi/NCR53C9x.c
Date: Wed, 13 Jun 2007 10:49:19 +0530
Message-ID: <1181711960.13391.47.camel@merlin.linuxcoe.com>
Reply-To: vignesh.babu@wipro.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:50314 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXFMFST (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 01:18:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, Kernel Janitors List <kernel-janitors@lists.osdl.org>

David S. Miller (davem@caip.rutgers.edu)
LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
P:	Matthew Wilcox
M:	matthew@wil.cx
L:	linux-scsi@vger.kernel.org
S:	Maintained


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Thanks Mathew for pointing out the double check that was going on for 0.I have fixed that.

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 8b5334c..60692dc 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -33,6 +33,7 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/log2.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -1648,10 +1649,8 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
 	if(2 != fcount(esp, eregs))
 		return -1;
 	it = esp_read(eregs->esp_fdata);
-	if(!(it & me))
-		return -1;
 	it &= ~me;
-	if(it & (it - 1))
+	if(!is_power_of_2(it))
 		return -1;
 	while(!(it & 1))
 		targ++, it >>= 1;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

