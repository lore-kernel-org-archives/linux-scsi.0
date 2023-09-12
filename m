Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86708CA0EC8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbjILCIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbjILCCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:02:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167A31A39AE;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811E4C36AE6;
        Tue, 12 Sep 2023 00:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480248;
        bh=SUQ1ONHLZRQICe+mf6elU/cxoVog56qhZUq3IY+ouMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy/gMpafUy7Nf++ggk6vRr0IYGbu3oJNKGY13g/vA1IEog2hVwr3FQriSP8TrGuUs
         VoUYZs7J++5RLZirz9nY/UBGr1p1zWypBaTf4K8XOQFn+/6gmfjxj1bGMKrDeH9SqI
         WdSm1k4wLPe7onJb8jebgiwvNu74qL8E26hGlc5Xhnt3pEyNIzYPgAEhADSmpvSayV
         j/pjrY0ExEwqZl/LILBlRB8SL0PSJXV9kWf347RmAJ1gsSRSnUcwDV3kExratUqheT
         lIR4meqExNVh7OHEf/AcFNZxxx7xjYGSdaMSAKgWLLykQu8a2bJ+ULThdSUntWoPf+
         hN7cTk+hgXTgw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 21/21] ata: libata: Cleanup inline DMA helper functions
Date:   Tue, 12 Sep 2023 09:56:55 +0900
Message-ID: <20230912005655.368075-22-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
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

