From: vignesh babu <vignesh.babu@wipro.com>
Subject: [PATCH]is_power_of_2-scsi/NCR53C9x.c
Date: Tue, 12 Jun 2007 10:54:36 +0530
Message-ID: <1181625877.11780.24.camel@merlin.linuxcoe.com>
Reply-To: vignesh.babu@wipro.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:40060 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbXFLF3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2007 01:29:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, Kernel Janitors List <kernel-janitors@lists.osdl.org>


Replacing (n & (n-1)) in the context of power of 2 checks
with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
--- 
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 8b5334c..2868b1a 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -33,6 +33,7 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/log2.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
@@ -1651,7 +1652,7 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
 	if(!(it & me))
 		return -1;
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

