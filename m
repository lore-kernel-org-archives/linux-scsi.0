From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 01/15] pm80xx: fix for memory region free
Date: Tue, 12 Feb 2013 04:25:53 -0800
Message-ID: <511A34D1.4070207@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:52944 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933230Ab3BLMZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:25:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From 56ee53f01663fa479c0624b81e36545ea5b1ab94 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 12:10:02 +0530
Subject: [PATCH 01/15] pm80xx: fix for memory region free

All memory regions are allocated based on variables total_len
and alignment but free was based on element_size.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 4c9fe73..3d5e522 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -140,7 +140,8 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 	for (i = 0; i < USI_MAX_MEMCNT; i++) {
 		if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
 			pci_free_consistent(pm8001_ha->pdev,
-				pm8001_ha->memoryMap.region[i].element_size,
+				(pm8001_ha->memoryMap.region[i].total_len +
+				pm8001_ha->memoryMap.region[i].alignment),
 				pm8001_ha->memoryMap.region[i].virt_ptr,
 				pm8001_ha->memoryMap.region[i].phys_addr);
 			}
-- 
1.7.1

