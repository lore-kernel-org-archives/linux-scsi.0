Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D63DCA0ECE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 03:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241432AbjILDQc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242472AbjILDQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 23:16:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B487018B8A1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E05C116B8;
        Mon, 11 Sep 2023 23:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474872;
        bh=Z0yOyGyoYmQ2eQcz1Dx4wu6/vjDINYDTQx+tvjz0Tc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXXIMOiyfV/8FIs8zYsR3AyrWbiUM2iIiIgksr1wX55ZZKCAiNczujSQfF3PNuqzJ
         IQYxZfT3yI9Nv0VdckPJBITuuXbb2SDKmNF1VIC14r/MC85mcvTXR2CImN6ij8jVdo
         V/1/Wcg5AIOQAwmTVrhrz6EOszgaItmGSIkwz2pdmTcl9qgPQ1ijdxHDW3QbXqMshL
         OY/Qht7HHvwlatuQos5MuUY57eyDXf4GIYXo2HPA2U7GkPLN+QyrgyYu0PdDFuD8YT
         tXtb78gnfe/V2X4LgvDv3Kt6e1GF39Sb3epJcbbHb5sV4rQh9+hdezhcpILYuCgk37
         L9q84RxpxVbiQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 06/10] scsi: pm8001: Simplify pm8001_chip_interrupt_enable/disable()
Date:   Tue, 12 Sep 2023 08:27:41 +0900
Message-ID: <20230911232745.325149-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pm8001_chip_msix_interrupt_enable() and
pm8001_chip_msix_interrupt_disable() are always cold with the vector
argument equal to 0. This allows simplifying the code for these
functions. With this change, the functions are simple enough and can be
removed by open coding them directly in pm8001_chip_interrupt_enable()
and pm8001_chip_interrupt_disable(). Also do the same for the functions
pm8001_chip_intx_interrupt_enable() and
pm8001_chip_intx_interrupt_disable() and remove these functions.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 69 +++-----------------------------
 1 file changed, 6 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 33053db5a713..ef62afc425fc 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1180,65 +1180,6 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
 	}
 }
 
-#ifndef PM8001_USE_MSIX
-/**
- * pm8001_chip_intx_interrupt_enable - enable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- */
-static void
-pm8001_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
-{
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
-}
-
-/**
- * pm8001_chip_intx_interrupt_disable - disable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- */
-static void
-pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
-{
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
-}
-
-#else
-
-/**
- * pm8001_chip_msix_interrupt_enable - enable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- * @int_vec_idx: interrupt number to enable
- */
-static void
-pm8001_chip_msix_interrupt_enable(struct pm8001_hba_info *pm8001_ha,
-	u32 int_vec_idx)
-{
-	u32 msi_index;
-	u32 value;
-	msi_index = int_vec_idx * MSIX_TABLE_ELEMENT_SIZE;
-	msi_index += MSIX_TABLE_BASE;
-	pm8001_cw32(pm8001_ha, 0, msi_index, MSIX_INTERRUPT_ENABLE);
-	value = (1 << int_vec_idx);
-	pm8001_cw32(pm8001_ha, 0,  MSGU_ODCR, value);
-
-}
-
-/**
- * pm8001_chip_msix_interrupt_disable - disable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- * @int_vec_idx: interrupt number to disable
- */
-static void
-pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,
-	u32 int_vec_idx)
-{
-	u32 msi_index;
-	msi_index = int_vec_idx * MSIX_TABLE_ELEMENT_SIZE;
-	msi_index += MSIX_TABLE_BASE;
-	pm8001_cw32(pm8001_ha, 0,  msi_index, MSIX_INTERRUPT_DISABLE);
-}
-#endif
-
 /**
  * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
@@ -1248,9 +1189,11 @@ static void
 pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	pm8001_chip_msix_interrupt_enable(pm8001_ha, 0);
+	pm8001_cw32(pm8001_ha, 0, MSIX_TABLE_BASE, MSIX_INTERRUPT_ENABLE);
+	pm8001_cw32(pm8001_ha, 0,  MSGU_ODCR, 1);
 #else
-	pm8001_chip_intx_interrupt_enable(pm8001_ha);
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
 #endif
 }
 
@@ -1263,9 +1206,9 @@ static void
 pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	pm8001_chip_msix_interrupt_disable(pm8001_ha, 0);
+	pm8001_cw32(pm8001_ha, 0, MSIX_TABLE_BASE, MSIX_INTERRUPT_DISABLE);
 #else
-	pm8001_chip_intx_interrupt_disable(pm8001_ha);
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
 #endif
 }
 
-- 
2.41.0

