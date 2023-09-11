Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5909ACA0ECD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 03:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbjILDQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242470AbjILDQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 23:16:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6C6181789
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CABC116CA;
        Mon, 11 Sep 2023 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474876;
        bh=gKbOAeAnoyieGSBvizJ7kLdrnOFfUIGkIm/CyS3tPJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOYH+XY/8W3Gq8vyJwOl4C6jtLIfFS0+Vl4w46hAAZpF5Igq6t3Vjz9zenpPay1XC
         VaNtKOof7fHG/Ye7lqIDJy3EY43ibc5agq+3mLR4RI0SlSA1/cdDHy8Hz6AjXA/JZ6
         S+QuqaBBwqH8pyZkMv0y5esF2mDz2zTBBxsxuqignWNxQXMlfB0dCGulmXnxsZki9I
         Ray0Pzp8qLBNyOKZFo0d7kUL1safuyRMOLkKQdpOEsbK5YCiIWMUh0Hdt9RxOUMzSt
         /AA6IM9ihZMByFFzYVbhgaJ1BajzMUCbUYV4k+VHZtlJDKwF5zgd50MCH5szp0cfB9
         cY4I1+bAwL0GA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 10/10] scsi: pm8001: Remove PM8001_READ_VPD
Date:   Tue, 12 Sep 2023 08:27:45 +0900
Message-ID: <20230911232745.325149-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the macro PM8001_READ_VPD used to define if a controller WWN
should be retrieved from the device. Instead, define the better named
boolean module parameter "read_wwn" to control this.

The code to set a fixed address for a phy device address when read_wwn
is set to false is simplified and fixed to avoid sparse warnings.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 50 +++++++++++++++++--------------
 drivers/scsi/pm8001/pm8001_sas.h  |  3 --
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 78c22421d6fe..ed6b7d954dda 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -64,6 +64,10 @@ static bool pm8001_use_tasklet = true;
 module_param_named(use_tasklet, pm8001_use_tasklet, bool, 0444);
 MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
 
+static bool pm8001_read_wwn = true;
+module_param_named(read_wwn, pm8001_read_wwn, bool, 0444);
+MODULE_PARM_DESC(zoned, "Get WWN from the controller. Default: true");
+
 static struct scsi_transport_template *pm8001_stt;
 static int pm8001_init_ccb_tag(struct pm8001_hba_info *);
 
@@ -683,19 +687,30 @@ static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
  */
 static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 {
-	u8 i, j;
-	u8 sas_add[8];
-#ifdef PM8001_READ_VPD
-	/* For new SPC controllers WWN is stored in flash vpd
-	*  For SPC/SPCve controllers WWN is stored in EEPROM
-	*  For Older SPC WWN is stored in NVMD
-	*/
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
+	unsigned long time_remaining;
+	u8 sas_add[8];
 	u16 deviceid;
 	int rc;
-	unsigned long time_remaining;
+	u8 i, j;
+
+	if (!pm8001_read_wwn) {
+		__be64 dev_sas_addr = cpu_to_be64(0x50010c600047f9d0ULL);
+
+		for (i = 0; i < pm8001_ha->chip->n_phy; i++)
+			memcpy(&pm8001_ha->phy[i].dev_sas_addr, &dev_sas_addr,
+			       SAS_ADDR_SIZE);
+		memcpy(pm8001_ha->sas_addr, &pm8001_ha->phy[0].dev_sas_addr,
+		       SAS_ADDR_SIZE);
+		return 0;
+	}
 
+	/*
+	 * For new SPC controllers WWN is stored in flash vpd. For SPC/SPCve
+	 * controllers WWN is stored in EEPROM. And for Older SPC WWN is stored
+	 * in NVMD.
+	 */
 	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
 		pm8001_dbg(pm8001_ha, FAIL, "controller is in fatal error state\n");
 		return -EIO;
@@ -769,16 +784,7 @@ static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 			   pm8001_ha->phy[i].dev_sas_addr);
 	}
 	kfree(payload.func_specific);
-#else
-	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
-		pm8001_ha->phy[i].dev_sas_addr = 0x50010c600047f9d0ULL;
-		pm8001_ha->phy[i].dev_sas_addr =
-			cpu_to_be64((u64)
-				(*(u64 *)&pm8001_ha->phy[i].dev_sas_addr));
-	}
-	memcpy(pm8001_ha->sas_addr, &pm8001_ha->phy[0].dev_sas_addr,
-		SAS_ADDR_SIZE);
-#endif
+
 	return 0;
 }
 
@@ -788,13 +794,13 @@ static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
  */
 static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 {
-
-#ifdef PM8001_READ_VPD
-	/*OPTION ROM FLASH read for the SPC cards */
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
 	int rc;
 
+	if (!pm8001_read_wwn)
+		return 0;
+
 	pm8001_ha->nvmd_completion = &completion;
 	/* SAS ADDRESS read from flash / EEPROM */
 	payload.minor_function = 6;
@@ -813,7 +819,7 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 	wait_for_completion(&completion);
 	pm8001_set_phy_profile(pm8001_ha, sizeof(u8), payload.func_specific);
 	kfree(payload.func_specific);
-#endif
+
 	return 0;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index e14c6668b0d3..3ccb7371902f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -85,9 +85,6 @@ do {									\
 
 extern bool pm8001_use_msix;
 
-#define PM8001_READ_VPD
-
-
 #define IS_SPCV_12G(dev)	((dev->device == 0X8074)		\
 				|| (dev->device == 0X8076)		\
 				|| (dev->device == 0X8077)		\
-- 
2.41.0

