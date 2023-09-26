Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C73E7D252
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbjIZIQ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbjIZIQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:16:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B756FC;
        Tue, 26 Sep 2023 01:15:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A019C433C7;
        Tue, 26 Sep 2023 08:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716155;
        bh=53d3ZPKvrChRMkkJyJG5wwgMC5g/WRn51TobyMswQos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/t4D4x4aQL3TGfsVxwobIbQ/KeArNbDiZozUqDhQVYOmNYOuoxr4CXyr91v9MijR
         Wr449OMWkfgUteChMdHZ/O+DCaj40SZ12loPtCdFk6J+1bt/LIsnWGlaJjAISqLvCS
         voRGNw3JpL/+5hHfwpzP91Ix6fYFOD+yN9RWiAZYI4cvpP5uoUSYB1DNsOx8X+XE44
         rHeOq2mqHp1EWZ5Scjb0FVZJtIO7VDpqN7qTVc0rZ1x4aE43pCJWnHfvrUEzyuTg62
         hGjuAC6F8FWw4yszs58kLvbwgynZz0ULa6ADx+2Zrikla4MVd+N6pTi0/+KIqXMPRd
         h6jG13I6aHYKw==
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
Subject: [PATCH v7 23/23] ata: libata: Cleanup inline DMA helper functions
Date:   Tue, 26 Sep 2023 17:15:07 +0900
Message-ID: <20230926081507.69346-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230926081507.69346-1-dlemoal@kernel.org>
References: <20230926081507.69346-1-dlemoal@kernel.org>
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
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

