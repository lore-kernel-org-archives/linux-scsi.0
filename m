Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAD7C71153
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjIKDCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjIKDCT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B60FC
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEF3C433C7;
        Mon, 11 Sep 2023 03:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401334;
        bh=ORXElVAofcyzBs8Ywt/fry+lu4D+3NaCnG14Ru3yip8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnNx2mDtU48MSazq0XktaJuhTYf/oGUnNhWQpnukB57wbj4QtF9VmlAvLtjOiOnRE
         mTRVfyVxjxvLELIoUU+JOZ7cbqtfZ59s6MbmPuPa6U2S0Av93bHtEwlQM1C62QWiie
         i4N9hUC/iqK8MYXoZVC6zfIzDMAvb1/zBSqv4pHgip5QauT0TMruM5FdIJnpZ5Bm4n
         Oz35iCXGdk6OJIQU08yGVPG5H3beUzPShRIKwv2huGosWbWVa+em8CKN1s7c8BUK4N
         PM7QEe7/P6BCXBtuL9oUUgV983H1nq0qUDEUZs774XSWCQlcjqnozTMAlnQDkYkoiF
         Hq8kqQ9qTRX6w==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 06/10] scsi: pm8001: Simplify pm8001_chip_interrupt_enable/disable()
Date:   Mon, 11 Sep 2023 12:02:03 +0900
Message-ID: <20230911030207.242917-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
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

