Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAD7CA0ECD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbjILCci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbjILCcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:32:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6032C36
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18A4C116C8;
        Mon, 11 Sep 2023 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474873;
        bh=mvsERvQcfR1QvuRqnqjM+akGSnRTUuk4knhVacMeTGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPpCVRRsuFI/HQstkyysqijEA2N6dNcfvWBO8Ziz1tUcf/rfwilywV5wHL4mRgjNm
         zbFHn36s2bE5u3gokpFdwaoyrd/s4604l9yNVbn0WnGs9c9pS5ZGTniU6BtFpsiw+A
         LIWmt57k1oggChghHYb8d2NitP/FRbMTfQa4FROMez2hiM1oLA4YXxCXv3ZkUWEVT2
         wd1Tb3D41QlNimE/CZQ3n6luIaLvb3U68qH/nGSxQ5FsCbBhfDG9RhzqaIODJprSIS
         EKpNTnfr23qwbTfhjaefowqBPR7RbmjKaM0o0xRlMHK23zefIGG9S7ZgIEE3YjWuEw
         ahCKfih3+13Lw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 07/10] scsi: pm8001: Remove pm80xx_chip_intx_interrupt_enable/disable()
Date:   Tue, 12 Sep 2023 08:27:42 +0900
Message-ID: <20230911232745.325149-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the functions pm80xx_chip_intx_interrupt_enable() and
pm80xx_chip_intx_interrupt_disable() and open code them respectively in
pm80xx_chip_interrupt_enable() and pm80xx_chip_interrupt_disable().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 31 +++++--------------------------
 1 file changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index f6857632dc7c..b2749cfbbef1 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1714,27 +1714,6 @@ static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 	pm8001_dbg(pm8001_ha, INIT, "chip reset finished\n");
 }
 
-/**
- * pm80xx_chip_intx_interrupt_enable - enable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- */
-static void
-pm80xx_chip_intx_interrupt_enable(struct pm8001_hba_info *pm8001_ha)
-{
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
-}
-
-/**
- * pm80xx_chip_intx_interrupt_disable - disable PM8001 chip interrupt
- * @pm8001_ha: our hba card information
- */
-static void
-pm80xx_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
-{
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, ODMR_MASK_ALL);
-}
-
 /**
  * pm80xx_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
@@ -1749,10 +1728,10 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	else
 		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
 			    1U << (vec - 32));
-	return;
+#else
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_CLEAR_ALL);
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
 #endif
-	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
-
 }
 
 /**
@@ -1773,9 +1752,9 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	else
 		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
 			    1U << (vec - 32));
-	return;
+#else
+	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, ODMR_MASK_ALL);
 #endif
-	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
 }
 
 /**
-- 
2.41.0

