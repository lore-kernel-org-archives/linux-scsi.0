Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF9AEEB580
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjIKDCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjIKDCU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A69EB0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46556C433C8;
        Mon, 11 Sep 2023 03:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401335;
        bh=T9AS2buyFQ/vpkvo87QiayAPGcLD3wcxFDgbZa1puP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBq+3ZjgJLVF5kjwuXElpjeez5alOrUIY/d2pFlMUOKNbUK5nKxnUnKqRRbJP8RLY
         z1UgPEYRRMnL1m/bnGtrhkFNXDl/4X16IP8sBGzht8gzlXbQio5wcZsUr7/MK3FkDh
         pE1C+Tu+5F3ys8oLF/4U5XH/JN2Fe3/7LwLljbOmdiShAymTso87yXsY8w1QpZHK7R
         8Q10n/NdC0QwN8lQ3X4Mb61S9K9WUQfYP52hkowPBLw1enh7sxeqenIZnuFd+4BN4S
         BCPVD9rqkoQBNpwcN02KbooHkX9CAgDc+LH80E1xW+NHzS50t2g8rTa/5Lp/64MIbI
         7vyN5RTWKhZaQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 07/10] scsi: pm8001: Remove pm80xx_chip_intx_interrupt_enable/disable()
Date:   Mon, 11 Sep 2023 12:02:04 +0900
Message-ID: <20230911030207.242917-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the functions pm80xx_chip_intx_interrupt_enable() and
pm80xx_chip_intx_interrupt_disable() and open code them respectively in
pm80xx_chip_interrupt_enable() and pm80xx_chip_interrupt_disable().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
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

