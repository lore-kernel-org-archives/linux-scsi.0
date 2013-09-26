From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 03/10] pm80xx: Indirect SMP request fix
Date: Wed, 25 Sep 2013 22:30:00 -0700
Message-ID: <5243C658.5000406@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:56870 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab3IZF12 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 01:27:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com, xjtuwjp@gmail.com

>From adf0140b2a05f51f6cb9ccefd0f82f3905b0692b Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Tue, 17 Sep 2013 14:37:14 +0530
Subject: [PATCH V2 03/10] pm80xx: Indirect SMP request fix.

Fix for indirect data transfer mode in case of SMP request.

Signed-off-by: Anandkumar.Santhanam@pmcs.com

---
 drivers/scsi/pm8001/pm80xx_hwi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 912dfec..99cec5f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3512,8 +3512,6 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 	else
 		pm8001_ha->smp_exp_mode = SMP_INDIRECT;
 
-	/* DIRECT MODE support only in spcv/ve */
-	pm8001_ha->smp_exp_mode = SMP_DIRECT;
 
 	tmp_addr = cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));
 	preq_dma_addr = (char *)phys_to_virt(tmp_addr);
@@ -3529,7 +3527,7 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 		/* exclude top 4 bytes for SMP req header */
 		smp_cmd.long_smp_req.long_req_addr =
 			cpu_to_le64((u64)sg_dma_address
-				(&task->smp_task.smp_req) - 4);
+				(&task->smp_task.smp_req) + 4);
 		/* exclude 4 bytes for SMP req header and CRC */
 		smp_cmd.long_smp_req.long_req_size =
 			cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_req)-8);
-- 
1.7.1

