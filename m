From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH v2 2/2] pm80xx : Fixed return value issue
Date: Tue, 10 Dec 2013 10:31:38 +0530
Message-ID: <1386651698-4331-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:59310 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab3LJFHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 00:07:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

pm80xx_get_gsm_dump() was returning "1" in error case
instead of negative error value.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
Acked-by: TomasHenzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c |    4 ++--
 drivers/scsi/pm8001/pm8001_hwi.c |    8 ++++----
 drivers/scsi/pm8001/pm80xx_hwi.c |   15 ++++-----------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 1738965..28b4e81 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -452,7 +452,7 @@ static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
 static ssize_t pm8001_ctl_fatal_log_show(struct device *cdev,
 	struct device_attribute *attr, char *buf)
 {
-	u32 count;
+	ssize_t count;
 
 	count = pm80xx_get_fatal_dump(cdev, attr, buf);
 	return count;
@@ -470,7 +470,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
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
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c950dc5..65de79c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -91,7 +91,6 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	void __iomem *fatal_table_address = pm8001_ha->fatal_tbl_addr;
-	u32 status = 1;
 	u32 accum_len , reg_val, index, *temp;
 	unsigned long start;
 	u8 *direct_data;
@@ -111,13 +110,10 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 		direct_data = (u8 *)fatal_error_data;
 		pm8001_ha->forensic_info.data_type = TYPE_NON_FATAL;
 		pm8001_ha->forensic_info.data_buf.direct_len = SYSFS_OFFSET;
-		pm8001_ha->forensic_info.data_buf.direct_offset = 0;
 		pm8001_ha->forensic_info.data_buf.read_len = 0;
 
 		pm8001_ha->forensic_info.data_buf.direct_data = direct_data;
-	}
-
-	if (pm8001_ha->forensic_info.data_buf.direct_offset == 0) {
+
 		/* start to get data */
 		/* Program the MEMBASE II Shifting Register with 0x00.*/
 		pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
@@ -126,6 +122,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 		pm8001_ha->forensic_fatal_step = 0;
 		pm8001_ha->fatal_bar_loc = 0;
 	}
+
 	/* Read until accum_len is retrived */
 	accum_len = pm8001_mr32(fatal_table_address,
 				MPI_FATAL_EDUMP_TABLE_ACCUM_LEN);
@@ -135,7 +132,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("Possible PCI issue 0x%x not expected\n",
 				accum_len));
-		return status;
+		return -EIO;
 	}
 	if (accum_len == 0 || accum_len >= 0x100000) {
 		pm8001_ha->forensic_info.data_buf.direct_data +=
@@ -178,7 +175,6 @@ moreData:
 			pm8001_ha->forensic_fatal_step = 1;
 			pm8001_ha->fatal_forensic_shift_offset = 0;
 			pm8001_ha->forensic_last_offset	= 0;
-			status = 0;
 			return (char *)pm8001_ha->
 				forensic_info.data_buf.direct_data -
 				(char *)buf;
@@ -194,7 +190,6 @@ moreData:
 					forensic_info.data_buf.direct_data,
 					"%08x ", *(temp + index));
 			}
-			status = 0;
 			return (char *)pm8001_ha->
 				forensic_info.data_buf.direct_data -
 				(char *)buf;
@@ -214,7 +209,6 @@ moreData:
 		pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
 			pm8001_ha->fatal_forensic_shift_offset);
 		pm8001_ha->fatal_bar_loc = 0;
-		status = 0;
 		return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
 			(char *)buf;
 	}
@@ -239,7 +233,7 @@ moreData:
 			PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("TIMEOUT:MEMBASE_II_SHIFT_REGISTER"
 			" = 0x%x\n", reg_val));
-			return -1;
+			return -EIO;
 		}
 
 		/* Read the next 64K of the debug data. */
@@ -259,7 +253,6 @@ moreData:
 			pm8001_ha->forensic_info.data_buf.direct_len =  0;
 			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
 			pm8001_ha->forensic_info.data_buf.read_len = 0;
-			status = 0;
 		}
 	}
 
-- 
1.7.1

