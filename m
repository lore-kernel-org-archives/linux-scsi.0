From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH 2/2] pm80xx : Fixed return value issue.
Date: Wed, 27 Nov 2013 11:12:33 +0530
Message-ID: <1385530953-4267-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:56537 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab3K0Frl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Nov 2013 00:47:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

pm80xx_get_gsm_dump() was returning "1" in error case instead of
negative error value.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c |    4 ++--
 drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 1e055ae..ce91852 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -460,7 +460,7 @@ static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
 static ssize_t pm8001_ctl_fatal_log_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
-	u32 count;
+	ssize_t count;
 
 	count = pm80xx_get_fatal_dump(cdev, attr, buf);
 	return count;
@@ -478,7 +478,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
 static ssize_t pm8001_ctl_gsm_log_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
-	u32 count;
+	ssize_t count;
 
 	count = pm8001_get_gsm_dump(cdev, SYSFS_OFFSET, buf);
 	return count;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2aa0681..46ace52 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -5020,7 +5020,7 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char *buf)
 	/* check max is 1 Mbytes */
 	if ((length > 0x100000) || (gsm_dump_offset & 3) ||
 		((gsm_dump_offset + length) > 0x1000000))
-			return 1;
+			return -EINVAL;
 
 	if (pm8001_ha->chip_id == chip_8001)
 		bar = 2;
@@ -5048,12 +5048,12 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char *buf)
 				gsm_base = GSM_BASE;
 				if (-1 == pm8001_bar4_shift(pm8001_ha,
 						(gsm_base + shift_value)))
-					return 1;
+					return -EIO;
 			} else {
 				gsm_base = 0;
 				if (-1 == pm80xx_bar4_shift(pm8001_ha,
 						(gsm_base + shift_value)))
-					return 1;
+					return -EIO;
 			}
 			gsm_dump_offset = (gsm_dump_offset + offset) &
 						0xFFFF0000;
@@ -5073,7 +5073,7 @@ pm8001_get_gsm_dump(struct device *cdev, u32 length, char *buf)
 	}
 	/* Shift back to BAR4 original address */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, 0))
-			return 1;
+			return -EIO;
 	pm8001_ha->fatal_forensic_shift_offset += 1024;
 
 	if (pm8001_ha->fatal_forensic_shift_offset >= 0x100000)
-- 
1.7.1

