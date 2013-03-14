From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 01/12] pm80xx: fix for memory region free
Date: Thu, 14 Mar 2013 04:01:07 -0700
Message-ID: <5141ADF3.6040003@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000407050709050106000800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:46596 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757053Ab3CNK75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 06:59:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Harry.Yang@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, sakthivel.sk@hcl.com, Vishwanath.Maram@pmcs.com, Rich.Bono@pmcs.com

This is a multi-part message in MIME format.
--------------000407050709050106000800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 700bfe79294e9f9e1a5def178af52b13928902a9 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 12:10:02 +0530
Subject: [PATCH V2 01/12] pm80xx: fix for memory region free

All memory regions are allocated based on variables total_len
and alignment but free was based on element_size.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
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


--------------000407050709050106000800
Content-Type: text/plain; charset=windows-1252;
 name="0001-pm80xx-fix-for-memory-region-free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-pm80xx-fix-for-memory-region-free.patch"

>From 700bfe79294e9f9e1a5def178af52b13928902a9 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 12:10:02 +0530
Subject: [PATCH V2 01/12] pm80xx: fix for memory region free

All memory regions are allocated based on variables total_len
and alignment but free was based on element_size.

Signed-off-by: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Ack-by: Jack Wang <jack_wang@usish.com>
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


--------------000407050709050106000800--
