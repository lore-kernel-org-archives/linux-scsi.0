Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D17C71153
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjIKDCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjIKDCV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3EFB5
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F327C433C9;
        Mon, 11 Sep 2023 03:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401336;
        bh=rx9uhbxORyX5fhZGyzK7ltvtMR14YOYSvKLSzUOu688=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+dAPUoCnAl5brJkgk0QlA9viVTJpuZRzvtRLpDpj+H1cobyaoCm8Y2OybvY1Q3JJ
         tNO6nOofvbP59G77L9ilOALVvtnfW6fp+K5/LcE9XmSIQ83wzh64muVh/5FWPktQsG
         th/LDigzIvwCXDoqpO40zIkAssKuge45PL1BcQTw5+LmKoaHm0XyJJ+8/9xtpdPD3L
         lHW/Ad6CLHuOrzypgkao2L82lYBc6f9lBajcmfgn4ubBTmZDlkku0xdpoTists0gPV
         ThrfS2k2McnbMi+gAGbpVJWT21lYtCgtt+2lqMjlSPsahJ3uClNav7kbFKdzbGwySu
         SA+D4UN/YE9oA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 08/10] scsi: pm8001: Remove PM8001_USE_MSIX
Date:   Mon, 11 Sep 2023 12:02:05 +0900
Message-ID: <20230911030207.242917-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pm8001 driver does not compile if PM8001_USE_MSIX is not defined in
pm8001_sas.h because various fields and functions conditionally defined
are used unconditionally without a "#ifdef PM8001_USE_MSIX" protection.
This macro is rather useless anyway and not convenient as diabling MSIX
use requires recompiling the driver.

Remove this macro and replace it with the bool module parameter
"use_msix" which defaults to true. The use of MSIX interrupts for an
adapter is gated by this module parameter for adapters that actually
support MSIX. The "use_msix" boolean field is added to struct
pm8001_hba_info and all code defined depending on PM8001_USE_MSIX is
modified to rely on pm8001_hba_info->use_msix instead.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 32 +++++++++++-----------
 drivers/scsi/pm8001/pm8001_init.c | 45 +++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h  |  7 ++---
 drivers/scsi/pm8001/pm80xx_hwi.c  | 38 +++++++++++++-------------
 4 files changed, 67 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index ef62afc425fc..6c9e7df0b349 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1188,13 +1188,14 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
 static void
 pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
-#ifdef PM8001_USE_MSIX
-	pm8001_cw32(pm8001_ha, 0, MSIX_TABLE_BASE, MSIX_INTERRUPT_ENABLE);
-	pm8001_cw32(pm8001_ha, 0,  MSGU_ODCR, 1);
-#else
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
-#endif
+	if (pm8001_ha->use_msix) {
+		pm8001_cw32(pm8001_ha, 0, MSIX_TABLE_BASE,
+			    MSIX_INTERRUPT_ENABLE);
+		pm8001_cw32(pm8001_ha, 0,  MSGU_ODCR, 1);
+	} else {
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
+	}
 }
 
 /**
@@ -1205,11 +1206,11 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 static void
 pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
-#ifdef PM8001_USE_MSIX
-	pm8001_cw32(pm8001_ha, 0, MSIX_TABLE_BASE, MSIX_INTERRUPT_DISABLE);
-#else
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
-#endif
+	if (pm8001_ha->use_msix)
+		pm8001_cw32(pm8001_ha, 0, MSIX_TABLE_BASE,
+			    MSIX_INTERRUPT_DISABLE);
+	else
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
 }
 
 /**
@@ -4252,16 +4253,15 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 
 static u32 pm8001_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 {
-#ifdef PM8001_USE_MSIX
-	return 1;
-#else
 	u32 value;
 
+	if (pm8001_ha->use_msix)
+		return 1;
+
 	value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
 	if (value)
 		return 1;
 	return 0;
-#endif
 }
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 0ec43e155511..8e59d0d46cd3 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -56,6 +56,10 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
 		" 4: Link rate 6.0G\n"
 		" 8: Link rate 12.0G\n");
 
+bool pm8001_use_msix = true;
+module_param_named(use_msix, pm8001_use_msix, bool, 0444);
+MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+
 static struct scsi_transport_template *pm8001_stt;
 static int pm8001_init_ccb_tag(struct pm8001_hba_info *);
 
@@ -961,7 +965,6 @@ static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
 	}
 }
 
-#ifdef PM8001_USE_MSIX
 /**
  * pm8001_setup_msix - enable MSI-X interrupt
  * @pm8001_ha: our ha struct.
@@ -1043,7 +1046,6 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 
 	return rc;
 }
-#endif
 
 /**
  * pm8001_request_irq - register interrupt
@@ -1052,10 +1054,9 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 {
 	struct pci_dev *pdev = pm8001_ha->pdev;
-#ifdef PM8001_USE_MSIX
 	int rc;
 
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+	if (pm8001_use_msix && pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
 		rc = pm8001_setup_msix(pm8001_ha);
 		if (rc) {
 			pm8001_dbg(pm8001_ha, FAIL,
@@ -1063,14 +1064,22 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 			return rc;
 		}
 
-		if (pdev->msix_cap && pci_msi_enabled())
-			return pm8001_request_msix(pm8001_ha);
+		if (!pdev->msix_cap || !pci_msi_enabled())
+			goto use_intx;
+
+		rc = pm8001_request_msix(pm8001_ha);
+		if (rc)
+			return rc;
+
+		pm8001_ha->use_msix = true;
+
+		return 0;
 	}
 
+use_intx:
+	/* Initialize the INT-X interrupt */
 	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
-#endif
-
-	/* initialize the INT-X interrupt */
+	pm8001_ha->use_msix = false;
 	pm8001_ha->irq_vector[0].irq_id = 0;
 	pm8001_ha->irq_vector[0].drv_inst = pm8001_ha;
 
@@ -1081,20 +1090,22 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 
 static void pm8001_free_irq(struct pm8001_hba_info *pm8001_ha)
 {
-#ifdef PM8001_USE_MSIX
 	struct pci_dev *pdev = pm8001_ha->pdev;
 	int i;
 
-	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		synchronize_irq(pci_irq_vector(pdev, i));
+	if (pm8001_ha->use_msix) {
+		for (i = 0; i < pm8001_ha->number_of_intr; i++)
+			synchronize_irq(pci_irq_vector(pdev, i));
 
-	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
+		for (i = 0; i < pm8001_ha->number_of_intr; i++)
+			free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
 
-	pci_free_irq_vectors(pdev);
-#else
+		pci_free_irq_vectors(pdev);
+		return;
+	}
+
+	/* INT-X */
 	free_irq(pm8001_ha->irq, pm8001_ha->sas);
-#endif
 }
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 2fadd353f1c1..612856b09187 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -83,8 +83,9 @@ do {									\
 		pm8001_info(HBA, fmt, ##__VA_ARGS__);			\
 } while (0)
 
+extern bool pm8001_use_msix;
+
 #define PM8001_USE_TASKLET
-#define PM8001_USE_MSIX
 #define PM8001_READ_VPD
 
 
@@ -520,11 +521,11 @@ struct pm8001_hba_info {
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
 	u32			ccb_count;
-#ifdef PM8001_USE_MSIX
+
+	bool			use_msix;
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]
 				[PM8001_NAME_LENGTH+1+3+1];
-#endif
 #ifdef PM8001_USE_TASKLET
 	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
 #endif
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index b2749cfbbef1..6041d3b88547 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1722,16 +1722,16 @@ static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 static void
 pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
-#ifdef PM8001_USE_MSIX
+	if (!pm8001_ha->use_msix) {
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
+		return;
+	}
+
 	if (vec < 32)
 		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);
 	else
-		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
-			    1U << (vec - 32));
-#else
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
-#endif
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U, 1U << (vec - 32));
 }
 
 /**
@@ -1742,19 +1742,20 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 static void
 pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
-#ifdef PM8001_USE_MSIX
+	if (!pm8001_ha->use_msix) {
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, ODMR_MASK_ALL);
+		return;
+	}
+
 	if (vec == 0xFF) {
 		/* disable all vectors 0-31, 32-63 */
 		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
 		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);
-	} else if (vec < 32)
+	} else if (vec < 32) {
 		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);
-	else
-		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
-			    1U << (vec - 32));
-#else
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, ODMR_MASK_ALL);
-#endif
+	} else {
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 1U << (vec - 32));
+	}
 }
 
 /**
@@ -4779,16 +4780,15 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 {
-#ifdef PM8001_USE_MSIX
-	return 1;
-#else
 	u32 value;
 
+	if (pm8001_ha->use_msix)
+		return 1;
+
 	value = pm8001_cr32(pm8001_ha, 0, MSGU_ODR);
 	if (value)
 		return 1;
 	return 0;
-#endif
 }
 
 /**
-- 
2.41.0

