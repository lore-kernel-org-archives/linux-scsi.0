Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60717C43141
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE6B2073B
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfKPDrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 22:47:42 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:35268 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfKPDrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 22:47:40 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 99A542A721; Fri, 15 Nov 2019 22:47:39 -0500 (EST)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        "Kars de Jong" <jongk@linux-m68k.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <2bbb6359d542f5882be67c415ecc25ad2d9eeb5e.1573875417.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] esp_scsi: Clear Transfer Count registers before PIO transfers
Date:   Sat, 16 Nov 2019 14:36:57 +1100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The zorro_esp driver uses both PIO and DMA transfers. If a failed DMA
transfer happened to be followed by a PIO transfer, the TCLOW and TCMED
registers would not get cleared. It is theoretically possible that the
stale value from the transfer counter or the TCLOW/TCMED registers
could then be used by the controller and the driver. Avoid that by
clearing these registers before each PIO transfer.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Kars de Jong <jongk@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/esp_scsi.c | 3 +++
 drivers/scsi/mac_esp.c  | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bb88995a12c7..afbef83f5dd9 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2835,6 +2835,9 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 	cmd &= ~ESP_CMD_DMA;
 	esp->send_cmd_error = 0;
 
+	esp_write8(0, ESP_TCLOW);
+	esp_write8(0, ESP_TCMED);
+
 	if (write) {
 		u8 *dst = (u8 *)addr;
 		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 1c78bc10c790..797579247e47 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -361,8 +361,6 @@ static int esp_mac_probe(struct platform_device *dev)
 	esp->flags = ESP_FLAG_NO_DMA_MAP;
 	if (mep->pdma_io == NULL) {
 		printk(KERN_INFO PFX "using PIO for controller %d\n", dev->id);
-		esp_write8(0, ESP_TCLOW);
-		esp_write8(0, ESP_TCMED);
 		esp->flags |= ESP_FLAG_DISABLE_SYNC;
 		mac_esp_ops.send_dma_cmd = esp_send_pio_cmd;
 	} else {
-- 
2.23.0

