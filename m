Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF328E7D0AA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 21:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjIUVAP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjIUU7p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 16:59:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72273B05B1;
        Thu, 21 Sep 2023 11:08:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAC3C433C7;
        Thu, 21 Sep 2023 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695319723;
        bh=NzckH9m2rphuFI2v2F3MbPasIB1cMwXqdnfzrb7mEPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n630gAVYT5YfcZPDULc/OinMltsEN2ZQEhHUl/jf3AAwik26e/Jfo+LWSSN3aBgTS
         cYK5FxbPJ3qPEVGr9sPPLizdYUEoMTqPu9QGnHniBC0Zdj/ojynJEXrZwWHkZgSLqq
         0Ax5RSoCfbKZ8AzuyjK+uqfp1r/adZP0CLlOaJOyDbvmUBoWk3E10E3a3oL1C7oBfM
         8D+97fU73oRA4aCMAn8IMV2cExzzBzmkXJCX09S7prFgOXdyPe50ilbADg1IcGeQ6o
         SnSAqwrBPEmHYh7k3wD7/Gdmr3tafGfv0/VDgYN1H69tPbOJ65F8ba5Coc44BwwGvi
         PfIa3LuBEnB1Q==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v5 23/23] ata: libata: Cleanup inline DMA helper functions
Date:   Fri, 22 Sep 2023 03:07:58 +0900
Message-ID: <20230921180758.955317-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230921180758.955317-1-dlemoal@kernel.org>
References: <20230921180758.955317-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the inline DMA helper functions ata_using_mwdma(),
ata_using_udma() and ata_dma_enabled() to directly return as a boolean
the result of their test condition.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 include/linux/libata.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 00b4a2b7819a..3c0fd04b0035 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1881,23 +1881,21 @@ static inline unsigned long ata_deadline(unsigned long from_jiffies,
    change in future hardware and specs, secondly 0xFF means 'no DMA' but is
    > UDMA_0. Dyma ddreigiau */
 
-static inline int ata_using_mwdma(struct ata_device *adev)
+static inline bool ata_using_mwdma(struct ata_device *adev)
 {
-	if (adev->dma_mode >= XFER_MW_DMA_0 && adev->dma_mode <= XFER_MW_DMA_4)
-		return 1;
-	return 0;
+	return adev->dma_mode >= XFER_MW_DMA_0 &&
+		adev->dma_mode <= XFER_MW_DMA_4;
 }
 
-static inline int ata_using_udma(struct ata_device *adev)
+static inline bool ata_using_udma(struct ata_device *adev)
 {
-	if (adev->dma_mode >= XFER_UDMA_0 && adev->dma_mode <= XFER_UDMA_7)
-		return 1;
-	return 0;
+	return adev->dma_mode >= XFER_UDMA_0 &&
+		adev->dma_mode <= XFER_UDMA_7;
 }
 
-static inline int ata_dma_enabled(struct ata_device *adev)
+static inline bool ata_dma_enabled(struct ata_device *adev)
 {
-	return (adev->dma_mode == 0xFF ? 0 : 1);
+	return adev->dma_mode != 0xFF;
 }
 
 /**************************************************************************
-- 
2.41.0

