Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78997EE6440
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 08:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjIOIYD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 04:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjIOIYA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 04:24:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9414499;
        Fri, 15 Sep 2023 01:22:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5484C433BD;
        Fri, 15 Sep 2023 08:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694765752;
        bh=Ny5m9BSnjoocQpihQVcwfWavMkW7NZYngxvodx+Ozj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0HleOmVsHL0jDai/dBS98DJr9mI6+qZZ686NrsePnipY0EflQnXqcwrqSlh9FrMC
         S55tB7KxeT1M6za8JlJeABwUpSfm3Y2gdIYMBfvyajKfZR0N9aCXgzdHv6uzUayncD
         7PDAHxW7YmECVdZDzc7sG2uRuW1YExcxJ90X28gfMLnFa9BYSytSlgrgAjjdaLxM2S
         xBorVCzuyrrqV1C7W+TG6ljBIn4IiS/Az/NxWLzN1k7Nx8C6taZbnxmxDitRnZmALx
         bymlJWFBJH1EBbhZnTKHzfdyQ1AxxTF+kQIpUtJejriyvsTDApmXvU756sm3L5NwAS
         qq54DOWgiJ1Jw==
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
Subject: [PATCH v3 23/23] ata: libata: Cleanup inline DMA helper functions
Date:   Fri, 15 Sep 2023 17:15:07 +0900
Message-ID: <20230915081507.761711-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230915081507.761711-1-dlemoal@kernel.org>
References: <20230915081507.761711-1-dlemoal@kernel.org>
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
---
 include/linux/libata.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 6593c79b7290..f48fe27dae94 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1878,23 +1878,21 @@ static inline unsigned long ata_deadline(unsigned long from_jiffies,
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

