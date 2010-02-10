From: michaelc@cs.wisc.edu
Subject: [PATCH 6/6] qla4xxx: fix compile warning due to invalid extHwConfig
Date: Wed, 10 Feb 2010 16:51:48 -0600
Message-ID: <1265842308-2051-7-git-send-email-michaelc@cs.wisc.edu>
References: <1265842308-2051-1-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-2-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-3-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-4-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-5-git-send-email-michaelc@cs.wisc.edu>
 <1265842308-2051-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab0BJWuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:50:16 -0500
In-Reply-To: <1265842308-2051-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the nvram is invalid qla4xxx tries to set Asuint32_t
based on the card type. If the card type is not listed
then Asuint32_t is going to be gargabe. This just fixes
that if/elseif by adding a else to catch the case for
new hardware that might not be listed yet.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_init.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index af8c323..92329a4 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -844,10 +844,10 @@ static int qla4xxx_config_nvram(struct scsi_qla_host *ha)
 	DEBUG2(printk("scsi%ld: %s: Get EEProm parameters \n", ha->host_no,
 		      __func__));
 	if (ql4xxx_lock_flash(ha) != QLA_SUCCESS)
-		return (QLA_ERROR);
+		return QLA_ERROR;
 	if (ql4xxx_lock_nvram(ha) != QLA_SUCCESS) {
 		ql4xxx_unlock_flash(ha);
-		return (QLA_ERROR);
+		return QLA_ERROR;
 	}
 
 	/* Get EEPRom Parameters from NVRAM and validate */
@@ -858,20 +858,18 @@ static int qla4xxx_config_nvram(struct scsi_qla_host *ha)
 			rd_nvram_word(ha, eeprom_ext_hw_conf_offset(ha));
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	} else {
-		/*
-		 * QLogic adapters should always have a valid NVRAM.
-		 * If not valid, do not load.
-		 */
 		dev_warn(&ha->pdev->dev,
 			   "scsi%ld: %s: EEProm checksum invalid.  "
 			   "Please update your EEPROM\n", ha->host_no,
 			   __func__);
 
-		/* set defaults */
+		/* Attempt to set defaults */
 		if (is_qla4010(ha))
 			extHwConfig.Asuint32_t = 0x1912;
 		else if (is_qla4022(ha) | is_qla4032(ha))
 			extHwConfig.Asuint32_t = 0x0023;
+		else
+			return QLA_ERROR;
 	}
 	DEBUG(printk("scsi%ld: %s: Setting extHwConfig to 0xFFFF%04x\n",
 		     ha->host_no, __func__, extHwConfig.Asuint32_t));
@@ -884,7 +882,7 @@ static int qla4xxx_config_nvram(struct scsi_qla_host *ha)
 	ql4xxx_unlock_nvram(ha);
 	ql4xxx_unlock_flash(ha);
 
-	return (QLA_SUCCESS);
+	return QLA_SUCCESS;
 }
 
 static void qla4x00_pci_config(struct scsi_qla_host *ha)
-- 
1.6.6

