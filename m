Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A10C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2BA920874
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgJEOk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:40:29 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21840 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJEOk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 10:40:28 -0400
IronPort-SDR: r/OEoZkUBu3nNV47axRAd+xzzgD9y3w27BKLx/KZye/eftCeB0FxnSjbjADqmWxa5h4dq+2jBj
 pTntchiyLeY7CEC+AzP59uqD8QrJEWQdq1LGolJmWI02hkaWvvvZhUXXxFpU4BV9eiPgNk3HUK
 WDi5bYaFAWug5cbql3Y0Eh4x2zFuJLkgiT6+NfU0kTrngFQfMpxbmN0kYFF9SN0dEGiWZN6xnd
 /kxLGxAtzIBj5yj+jEqhU/zEyHoPJN39w9c0+TyNJ3lHcO8/W2ULxT5ztvMk70ITWB4eqiycQq
 Ehk=
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="89133523"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Oct 2020 07:40:27 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 5 Oct 2020
 07:40:26 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.98) by
 avmbx3.microsemi.net (10.100.34.33) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Mon, 5 Oct 2020 07:40:26 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id F2563A09C6;
        Mon,  5 Oct 2020 07:40:25 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V2 2/4] pm80xx: Remove DMA memory allocation for ccb and device structures.
Date:   Mon, 5 Oct 2020 20:20:09 +0530
Message-ID: <20201005145011.23674-3-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201005145011.23674-1-Viswas.G@microchip.com.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Removed DMA memory allocation for Devices and CCB
structure, instead allocated memory outside DMA memory.
DMA memory is limited system resource and better to
allocate memory outside DMA memory when possible.

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_defs.h |  8 +++----
 drivers/scsi/pm8001/pm8001_init.c | 48 ++++++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index a4f52a5a449e..1bf1bcfaf010 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -91,17 +91,15 @@ enum port_type {
 #define	PM8001_MAX_DEVICES	 2048	/* max supported device */
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
 
-#define USI_MAX_MEMCNT_BASE	5
 #define	CONFIG_SCSI_PM8001_MAX_DMA_SG	528
 #define PM8001_MAX_DMA_SG	CONFIG_SCSI_PM8001_MAX_DMA_SG
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
 	IOP,	    /* IO processor */
 	NVMD,	    /* NVM device */
-	DEV_MEM,    /* memory for devices */
-	CCB_MEM,    /* memory for command control block */
 	FW_FLASH,    /* memory for fw flash update */
-	FORENSIC_MEM  /* memory for fw forensic data */
+	FORENSIC_MEM,  /* memory for fw forensic data */
+	USI_MAX_MEMCNT_BASE
 };
 #define	PM8001_EVENT_LOG_SIZE	 (128 * 1024)
 
@@ -109,7 +107,7 @@ enum memory_region_num {
  * maximum DMA memory regions(number of IBQ + number of IBQ CI
  * + number of  OBQ + number of OBQ PI)
  */
-#define USI_MAX_MEMCNT	(USI_MAX_MEMCNT_BASE + 1 + ((2 * PM8001_MAX_INB_NUM) \
+#define USI_MAX_MEMCNT	(USI_MAX_MEMCNT_BASE + ((2 * PM8001_MAX_INB_NUM) \
 			+ (2 * PM8001_MAX_OUTB_NUM)))
 /*error code*/
 enum mpi_err {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c744f846e08d..d6789a261c1c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -288,7 +288,7 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 
 	count = pm8001_ha->max_q_num;
 	/* Queues are chosen based on the number of cores/msix availability */
-	ib_offset = pm8001_ha->ib_offset  = USI_MAX_MEMCNT_BASE + 1;
+	ib_offset = pm8001_ha->ib_offset  = USI_MAX_MEMCNT_BASE;
 	ci_offset = pm8001_ha->ci_offset  = ib_offset + count;
 	ob_offset = pm8001_ha->ob_offset  = ci_offset + count;
 	pi_offset = pm8001_ha->pi_offset  = ob_offset + count;
@@ -380,19 +380,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	pm8001_ha->memoryMap.region[NVMD].num_elements = 1;
 	pm8001_ha->memoryMap.region[NVMD].element_size = 4096;
 	pm8001_ha->memoryMap.region[NVMD].total_len = 4096;
-	/* Memory region for devices*/
-	pm8001_ha->memoryMap.region[DEV_MEM].num_elements = 1;
-	pm8001_ha->memoryMap.region[DEV_MEM].element_size = PM8001_MAX_DEVICES *
-		sizeof(struct pm8001_device);
-	pm8001_ha->memoryMap.region[DEV_MEM].total_len = PM8001_MAX_DEVICES *
-		sizeof(struct pm8001_device);
-
-	/* Memory region for ccb_info*/
-	pm8001_ha->memoryMap.region[CCB_MEM].num_elements = 1;
-	pm8001_ha->memoryMap.region[CCB_MEM].element_size = PM8001_MAX_CCB *
-		sizeof(struct pm8001_ccb_info);
-	pm8001_ha->memoryMap.region[CCB_MEM].total_len = PM8001_MAX_CCB *
-		sizeof(struct pm8001_ccb_info);
 
 	/* Memory region for fw flash */
 	pm8001_ha->memoryMap.region[FW_FLASH].total_len = 4096;
@@ -416,18 +403,30 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		}
 	}
 
-	pm8001_ha->devices = pm8001_ha->memoryMap.region[DEV_MEM].virt_ptr;
+	/* Memory region for devices*/
+	pm8001_ha->devices = kzalloc(PM8001_MAX_DEVICES
+				* sizeof(struct pm8001_device), GFP_KERNEL);
+	if (!pm8001_ha->devices) {
+		rc = -ENOMEM;
+		goto err_out_nodev;
+	}
 	for (i = 0; i < PM8001_MAX_DEVICES; i++) {
 		pm8001_ha->devices[i].dev_type = SAS_PHY_UNUSED;
 		pm8001_ha->devices[i].id = i;
 		pm8001_ha->devices[i].device_id = PM8001_MAX_DEVICES;
 		pm8001_ha->devices[i].running_req = 0;
 	}
-	pm8001_ha->ccb_info = pm8001_ha->memoryMap.region[CCB_MEM].virt_ptr;
+	/* Memory region for ccb_info*/
+	pm8001_ha->ccb_info = kzalloc(PM8001_MAX_CCB
+				* sizeof(struct pm8001_ccb_info), GFP_KERNEL);
+	if (!pm8001_ha->ccb_info) {
+		rc = -ENOMEM;
+		goto err_out_noccb;
+	}
 	for (i = 0; i < PM8001_MAX_CCB; i++) {
 		pm8001_ha->ccb_info[i].ccb_dma_handle =
-			pm8001_ha->memoryMap.region[CCB_MEM].phys_addr +
-			i * sizeof(struct pm8001_ccb_info);
+			virt_to_phys(pm8001_ha->ccb_info) +
+			(i * sizeof(struct pm8001_ccb_info));
 		pm8001_ha->ccb_info[i].task = NULL;
 		pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
 		pm8001_ha->ccb_info[i].device = NULL;
@@ -437,8 +436,21 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	/* Initialize tags */
 	pm8001_tag_init(pm8001_ha);
 	return 0;
+
+err_out_noccb:
+	kfree(pm8001_ha->devices);
 err_out_shost:
 	scsi_remove_host(pm8001_ha->shost);
+err_out_nodev:
+	for (i = 0; i < pm8001_ha->max_memcnt; i++) {
+		if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
+			pci_free_consistent(pm8001_ha->pdev,
+				(pm8001_ha->memoryMap.region[i].total_len +
+				pm8001_ha->memoryMap.region[i].alignment),
+				pm8001_ha->memoryMap.region[i].virt_ptr,
+				pm8001_ha->memoryMap.region[i].phys_addr);
+		}
+	}
 err_out:
 	return 1;
 }
-- 
2.16.3

