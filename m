Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5BEC71153
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjIKDCb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjIKDCX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4E8FB
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2913C433CC;
        Mon, 11 Sep 2023 03:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401338;
        bh=I6h9oP2plr0NpSsjEvVSiepFCTw2Z4+5TfKQCrsu3T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUdmUgLa3dERnzc5pvPx2I/BMOL/M/kx7kmVICaM7tWvHLcTV+4j29uaBBzNVcnOV
         PvJRVPsugMRO0oN6b3bAr1jAtBg6fmt/lUTytMaEdruTB6m/nzFNhYGbgCnu/wN2Jm
         sb904RpedIjfTn5JjOZvKz/RQnSpuA4ZvMWztZfvxYJ15wzsuZ/6BLU1XhSNea7BBR
         QSqbQHGQ8Iz9AGEjQ9SSS4Ll+wKOGUZpK/6AaynPQ+PaDauCkoBFyZwKvctaVv/LBd
         NR1SU9OpwXrA9UOAITPrCRkDJgy/Hlu7hCMIEQXpU5t2pT1LaI6NFpou+QZk8wA+7y
         H6lYjHhQDP1bg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 10/10] scsi: pm8001: Remove PM8001_READ_VPD
Date:   Mon, 11 Sep 2023 12:02:07 +0900
Message-ID: <20230911030207.242917-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the macro PM8001_READ_VPD used to define if a controller WWN
should be retrieved from the device. Instead, define the better named
boolean module parameter "read_wwn" to control this.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 46 ++++++++++++++++++-------------
 drivers/scsi/pm8001/pm8001_sas.h  |  3 --
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 78c22421d6fe..52dcb95898fb 100644
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
 
@@ -685,11 +689,24 @@ static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 {
 	u8 i, j;
 	u8 sas_add[8];
-#ifdef PM8001_READ_VPD
-	/* For new SPC controllers WWN is stored in flash vpd
-	*  For SPC/SPCve controllers WWN is stored in EEPROM
-	*  For Older SPC WWN is stored in NVMD
-	*/
+
+	if (!pm8001_read_wwn) {
+		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
+			pm8001_ha->phy[i].dev_sas_addr = 0x50010c600047f9d0ULL;
+			pm8001_ha->phy[i].dev_sas_addr =
+				cpu_to_be64((u64)
+					(*(u64 *)&pm8001_ha->phy[i].dev_sas_addr));
+		}
+		memcpy(pm8001_ha->sas_addr, &pm8001_ha->phy[0].dev_sas_addr,
+		       SAS_ADDR_SIZE);
+		return 0;
+	}
+
+	/*
+	 * For new SPC controllers WWN is stored in flash vpd. For SPC/SPCve
+	 * controllers WWN is stored in EEPROM. And for Older SPC WWN is stored
+	 * in NVMD.
+	 */
 	DECLARE_COMPLETION_ONSTACK(completion);
 	struct pm8001_ioctl_payload payload;
 	u16 deviceid;
@@ -769,16 +786,7 @@ static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
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
 
@@ -788,13 +796,13 @@ static int pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
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
@@ -813,7 +821,7 @@ static int pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
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

