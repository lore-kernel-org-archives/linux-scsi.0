From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/2] pm80xx : Fixed return value issue.
Date: Mon, 02 Dec 2013 14:41:38 +0100
Message-ID: <529C8E12.2000409@redhat.com>
References: <1385530953-4267-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3LBNlo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Dec 2013 08:41:44 -0500
In-Reply-To: <1385530953-4267-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>, linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com

On 11/27/2013 06:42 AM, Viswas G wrote:
> pm80xx_get_gsm_dump() was returning "1" in error case instead of
> negative error value.

Thanks for fixing this.
Acked-by: Tomas Henzl <thenzl@redhat.com>

-------------------
It think that the return value in pm80xx_get_fatal_dump should also be fixed,
please consider it.
(not even compile tested)

Tomas
--- 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8987b17..4cf1cd3 100644
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
@@ -135,7 +134,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("Possible PCI issue 0x%x not expected\n",
 				accum_len));
-		return status;
+		return -EIO;
 	}
 	if (accum_len == 0 || accum_len >= 0x100000) {
 		pm8001_ha->forensic_info.data_buf.direct_data +=
@@ -178,7 +177,6 @@ moreData:
 			pm8001_ha->forensic_fatal_step = 1;
 			pm8001_ha->fatal_forensic_shift_offset = 0;
 			pm8001_ha->forensic_last_offset	= 0;
-			status = 0;
 			return (char *)pm8001_ha->
 				forensic_info.data_buf.direct_data -
 				(char *)buf;
@@ -194,7 +192,6 @@ moreData:
 					forensic_info.data_buf.direct_data,
 					"%08x ", *(temp + index));
 			}
-			status = 0;
 			return (char *)pm8001_ha->
 				forensic_info.data_buf.direct_data -
 				(char *)buf;
@@ -214,7 +211,6 @@ moreData:
 		pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
 			pm8001_ha->fatal_forensic_shift_offset);
 		pm8001_ha->fatal_bar_loc = 0;
-		status = 0;
 		return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
 			(char *)buf;
 	}
@@ -259,7 +255,6 @@ moreData:
 			pm8001_ha->forensic_info.data_buf.direct_len =  0;
 			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
 			pm8001_ha->forensic_info.data_buf.read_len = 0;
-			status = 0;
 		}
 	}
 

