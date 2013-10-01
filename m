From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V3 07/10] pm80xx: Print SAS address of IO failed device.
Date: Mon, 30 Sep 2013 23:41:06 -0700
Message-ID: <524A6E82.6010104@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:52619 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3JAGie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 02:38:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, xjtuwjp@gmail.com, Viswas.G@pmcs.com

>From 2c945961b52fabe4ea815b08bfa2eef814db8b97 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Tue, 17 Sep 2013 16:47:21 +0530
Subject: [PATCH V3 07/10] pm80xx: Print SAS address of IO failed device.

Signed-off-by: Anandkumar.Santhanam@pmcs.com
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |   53 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.c |   51 ++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 4c9c220..600e61e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1868,6 +1868,13 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
+	/* Print sas address of IO failed device */
+	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
+		(status != IO_UNDERFLOW))
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("SAS Address of IO Failure Drive:"
+			"%016llx", SAS_ADDR(t->dev->sas_addr)));
+
 	switch (status) {
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
@@ -2276,6 +2283,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 param;
 	u32 status;
 	u32 tag;
+	int i, j;
+	u8 sata_addr_low[4];
+	u32 temp_sata_addr_low;
+	u8 sata_addr_hi[4];
+	u32 temp_sata_addr_hi;
 	struct sata_completion_resp *psataPayload;
 	struct task_status_struct *ts;
 	struct ata_task_resp *resp ;
@@ -2325,7 +2337,46 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("ts null\n"));
 		return;
 	}
-
+	/* Print sas address of IO failed device */
+	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
+		(status != IO_UNDERFLOW)) {
+		if (!((t->dev->parent) &&
+			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
+			for (i = 0 , j = 4 ; j <= 7 && i <= 3 ; i++ , j++)
+				sata_addr_low[i] = pm8001_ha->sas_addr[j];
+			for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
+				sata_addr_hi[i] = pm8001_ha->sas_addr[j];
+			memcpy(&temp_sata_addr_low, sata_addr_low,
+				sizeof(sata_addr_low));
+			memcpy(&temp_sata_addr_hi, sata_addr_hi,
+				sizeof(sata_addr_hi));
+			temp_sata_addr_hi = (((temp_sata_addr_hi >> 24) & 0xff)
+						|((temp_sata_addr_hi << 8) &
+						0xff0000) |
+						((temp_sata_addr_hi >> 8)
+						& 0xff00) |
+						((temp_sata_addr_hi << 24) &
+						0xff000000));
+			temp_sata_addr_low = ((((temp_sata_addr_low >> 24)
+						& 0xff) |
+						((temp_sata_addr_low << 8)
+						& 0xff0000) |
+						((temp_sata_addr_low >> 8)
+						& 0xff00) |
+						((temp_sata_addr_low << 24)
+						& 0xff000000)) +
+						pm8001_dev->attached_phy +
+						0x10);
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("SAS Address of IO Failure Drive:"
+				"%08x%08x", temp_sata_addr_hi,
+					temp_sata_addr_low));
+		} else {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("SAS Address of IO Failure Drive:"
+				"%016llx", SAS_ADDR(t->dev->sas_addr)));
+		}
+	}
 	switch (status) {
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 37ddc5d..5a357d1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1276,6 +1276,13 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	if (unlikely(!t || !t->lldd_task || !t->dev))
 		return;
 	ts = &t->task_status;
+	/* Print sas address of IO failed device */
+	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
+		(status != IO_UNDERFLOW))
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("SAS Address of IO Failure Drive"
+			":%016llx", SAS_ADDR(t->dev->sas_addr)));
+
 	switch (status) {
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha,
@@ -1699,6 +1706,10 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 param;
 	u32 status;
 	u32 tag;
+	int i, j;
+	u8 sata_addr_low[4];
+	u32 temp_sata_addr_low, temp_sata_addr_hi;
+	u8 sata_addr_hi[4];
 	struct sata_completion_resp *psataPayload;
 	struct task_status_struct *ts;
 	struct ata_task_resp *resp ;
@@ -1748,7 +1759,47 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("ts null\n"));
 		return;
 	}
+	/* Print sas address of IO failed device */
+	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
+		(status != IO_UNDERFLOW)) {
+		if (!((t->dev->parent) &&
+			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
+			for (i = 0 , j = 4 ; i <= 3 && j <= 7 ; i++ , j++)
+				sata_addr_low[i] = pm8001_ha->sas_addr[j];
+			for (i = 0 , j = 0; i <= 3 && j <= 3; i++ , j++)
+				sata_addr_hi[i] = pm8001_ha->sas_addr[j];
+			memcpy(&temp_sata_addr_low, sata_addr_low,
+				sizeof(sata_addr_low));
+			memcpy(&temp_sata_addr_hi, sata_addr_hi,
+				sizeof(sata_addr_hi));
+			temp_sata_addr_hi = (((temp_sata_addr_hi >> 24) & 0xff)
+						|((temp_sata_addr_hi << 8) &
+						0xff0000) |
+						((temp_sata_addr_hi >> 8)
+						& 0xff00) |
+						((temp_sata_addr_hi << 24) &
+						0xff000000));
+			temp_sata_addr_low = ((((temp_sata_addr_low >> 24)
+						& 0xff) |
+						((temp_sata_addr_low << 8)
+						& 0xff0000) |
+						((temp_sata_addr_low >> 8)
+						& 0xff00) |
+						((temp_sata_addr_low << 24)
+						& 0xff000000)) +
+						pm8001_dev->attached_phy +
+						0x10);
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("SAS Address of IO Failure Drive:"
+				"%08x%08x", temp_sata_addr_hi,
+					temp_sata_addr_low));
 
+		} else {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("SAS Address of IO Failure Drive:"
+				"%016llx", SAS_ADDR(t->dev->sas_addr)));
+		}
+	}
 	switch (status) {
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
-- 
1.7.1

