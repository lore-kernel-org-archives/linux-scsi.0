Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5A9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 08:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiDHIHu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 04:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiDHIHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 04:07:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D127B05
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 01:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649405130; x=1680941130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5wLMG1uiQ1XDvNAz0iBOvothgFggYIKD1XnbZ3GqpHY=;
  b=xeGM8yAqwK31L/KHBxl5VAFH7qnqDvdKHzYAgBOWtJHQg6pcLRt5d4jx
   vzHmf23zDXxFtHFpmy4cNsQJB2rFZvrrWSvEbI2RE6ZNUIXjknyeFqHYt
   KKcT5dJAbJEYo+mch/ToP8LUNk9nsvO869VOasfuBesuoM0h+/1+1oQzI
   ExY+RzsOxLKtsyyIyGlOR2FhZ7yJASDGZaQQHNmtX3ZXYUVBVKoQO/xv5
   kScbKezfKB232bGRqDRjspwEPQRJMyUbeu7wK9FKlYUTP3yid255MwuqP
   t+vVAPXkllpX3thCyG9thZvMTwdci054MNrcLJMvNpQ/93BDUB7thETXM
   g==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="159833059"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 01:05:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 01:05:24 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Apr 2022 01:05:23 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v3 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
Date:   Fri, 8 Apr 2022 13:35:37 +0530
Message-ID: <20220408080538.278707-2-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220408080538.278707-1-Ajish.Koshy@microchip.com>
References: <20220408080538.278707-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When upper inbound and outbound queues 32-63 are enabled, we see upper
vectors 32-63 in interrupt service routine. We need corresponding
registers to handle masking and unmasking of these upper interrupts.

To achieve this, we use registers MSGU_ODMR_U(0x34) to mask and
MSGU_ODMR_CLR_U(0x3C) to unmask the interrupts. In these registers bit
0-31 represents interrupt vectors 32-63.

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9bb31f66db85..cdb31679f419 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1727,10 +1727,14 @@ static void
 pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	u32 mask;
-	mask = (u32)(1 << vec);
-
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
+	if (vec < 32) {
+		/* vectors 0 - 31 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, 1U << vec);
+	} else {
+		/* vectors 32 - 63 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
+			    1U << (vec - 32));
+	}
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
@@ -1746,12 +1750,18 @@ static void
 pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
-	u32 mask;
-	if (vec == 0xFF)
-		mask = 0xFFFFFFFF;
-	else
-		mask = (u32)(1 << vec);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
+	if (vec == 0xFF) {
+		/* disable all vectors 0-31, 32-63 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 0xFFFFFFFF);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, 0xFFFFFFFF);
+	} else if (vec < 32) {
+		/* vectors 0 - 31 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, 1U << vec);
+	} else {
+		/* vectors 32 - 63 */
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
+			    1U << (vec - 32));
+	}
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
-- 
2.31.1

