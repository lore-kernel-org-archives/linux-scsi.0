From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH v2 1/2] pm80xx : Removing redundant code snippets
Date: Tue, 10 Dec 2013 10:31:28 +0530
Message-ID: <1386651688-4303-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:59295 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab3LJFHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 00:07:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

Removed redundant code snippets in pm8001_hwi.c and
pm8001_ctl.c

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c |   34 ++++++++++------------------------
 drivers/scsi/pm8001/pm8001_hwi.c |    7 +------
 2 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index a04b4ff..1738965 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -323,24 +323,17 @@ static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
 	int offset;
 	char *str = buf;
 	int start = 0;
-#define IB_MEMMAP(c)		\
-		(*(u32 *)((u8 *)pm8001_ha->		\
-		memoryMap.region[IB].virt_ptr +		\
+#define IB_MEMMAP(c)	\
+		(*(u32 *)((u8 *)pm8001_ha->	\
+		memoryMap.region[IB].virt_ptr +	\
 		pm8001_ha->evtlog_ib_offset + (c)))
 
 	for (offset = 0; offset < IB_OB_READ_TIMES; offset++) {
-		if (pm8001_ha->chip_id != chip_8001)
-			str += sprintf(str, "0x%08x\n", IB_MEMMAP(start));
-		else
-			str += sprintf(str, "0x%08x\n", IB_MEMMAP(start));
+		str += sprintf(str, "0x%08x\n", IB_MEMMAP(start));
 		start = start + 4;
 	}
 	pm8001_ha->evtlog_ib_offset += SYSFS_OFFSET;
-	if ((((pm8001_ha->evtlog_ib_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
-		&& (pm8001_ha->chip_id != chip_8001))
-		pm8001_ha->evtlog_ib_offset = 0;
-	if ((((pm8001_ha->evtlog_ib_offset) % (PM8001_IB_OB_QUEUE_SIZE)) == 0)
-		&& (pm8001_ha->chip_id == chip_8001))
+	if (((pm8001_ha->evtlog_ib_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
 		pm8001_ha->evtlog_ib_offset = 0;
 
 	return str - buf;
@@ -363,24 +356,17 @@ static ssize_t pm8001_ctl_ob_queue_log_show(struct device *cdev,
 	int offset;
 	char *str = buf;
 	int start = 0;
-#define OB_MEMMAP(c)		\
-		(*(u32 *)((u8 *)pm8001_ha->		\
-		memoryMap.region[OB].virt_ptr +		\
+#define OB_MEMMAP(c)	\
+		(*(u32 *)((u8 *)pm8001_ha->	\
+		memoryMap.region[OB].virt_ptr +	\
 		pm8001_ha->evtlog_ob_offset + (c)))
 
 	for (offset = 0; offset < IB_OB_READ_TIMES; offset++) {
-		if (pm8001_ha->chip_id != chip_8001)
-			str += sprintf(str, "0x%08x\n", OB_MEMMAP(start));
-		else
-			str += sprintf(str, "0x%08x\n", OB_MEMMAP(start));
+		str += sprintf(str, "0x%08x\n", OB_MEMMAP(start));
 		start = start + 4;
 	}
 	pm8001_ha->evtlog_ob_offset += SYSFS_OFFSET;
-	if ((((pm8001_ha->evtlog_ob_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
-			&& (pm8001_ha->chip_id != chip_8001))
-		pm8001_ha->evtlog_ob_offset = 0;
-	if ((((pm8001_ha->evtlog_ob_offset) % (PM8001_IB_OB_QUEUE_SIZE)) == 0)
-			&& (pm8001_ha->chip_id == chip_8001))
+	if (((pm8001_ha->evtlog_ob_offset) % (PM80XX_IB_OB_QUEUE_SIZE)) == 0)
 		pm8001_ha->evtlog_ob_offset = 0;
 
 	return str - buf;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 0a1296a..2aa0681 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -5072,13 +5072,8 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char *buf)
 		direct_data += sprintf(direct_data, "%08x ", value);
 	}
 	/* Shift back to BAR4 original address */
-	if (pm8001_ha->chip_id == chip_8001) {
-		if (-1 == pm8001_bar4_shift(pm8001_ha, 0))
+	if (-1 == pm8001_bar4_shift(pm8001_ha, 0))
 			return 1;
-	} else {
-		if (-1 == pm80xx_bar4_shift(pm8001_ha, 0))
-			return 1;
-	}
 	pm8001_ha->fatal_forensic_shift_offset += 1024;
 
 	if (pm8001_ha->fatal_forensic_shift_offset >= 0x100000)
-- 
1.7.1

