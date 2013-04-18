From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V4 1/12] pm80xx: fix for memory region free
Date: Thu, 18 Apr 2013 11:23:58 -0700
Message-ID: <51703A3E.1080204@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37799 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077Ab3DRSWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Apr 2013 14:22:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, Vishwanath.Maram@pmcs.com, rich.Bono@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, sakthivel.sk@hcl.com

>From 8464bcd3b7789798a1f34826fe51eb833ae0578d Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 12:10:02 +0530
Subject: [PATCH V4 1/12] pm80xx: fix for memory region free

All memory regions are allocated based on variables total_len
and alignment but free was based on element_size.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
Ack-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/pm8001/pm8001_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 4c9fe73..3d5e522 100644
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

