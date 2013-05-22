From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 03/12] megaraid_sas : Update balance count in driver to be in sync of firmware
Date: Wed, 22 May 2013 12:30:22 +0530
Message-ID: <201305221230.r4MCUbgR011994@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:48462
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756094Ab3EVMaq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:30:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Update balance count in driver to be in sync of firmware.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index a11df82..b06a240 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -503,8 +503,9 @@ u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm, u64 block,
 	diff1 = ABS_DIFF(block, lbInfo->last_accessed_block[1]);
 	bestArm = (diff0 <= diff1 ? 0 : 1);
 
-	if ((bestArm == arm && pend0 > pend1 + 16)  ||
-	    (bestArm != arm && pend1 > pend0 + 16))
+	/*Make balance count from 16 to 4 to keep driver in sync with Firmware*/
+	if ((bestArm == arm && pend0 > pend1 + 4)  ||
+	    (bestArm != arm && pend1 > pend0 + 4))
 		bestArm ^= 1;
 
 	/* Update the last accessed block on the correct pd */

