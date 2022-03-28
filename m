Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33E2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 08:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbiC1IoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 04:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiC1IoQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 04:44:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808B753A6D
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 01:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648456955; x=1679992955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FVMIVguURWEz5RRvmj/8yJub7zMMK5S2+nQN3Qn5BzU=;
  b=l9frkwp/IPHJpV6LLdvVsP2mRi29P0FhHPp3g9IjRGvd00uq5s+v5wau
   DQQFtfbnkmcjS+4pgX8C1fq53ly2HhG1wcaQJBkrW/LuUe3qEz50Y9e5Y
   da2KZzzmvuTD1WeRD+am8RP3JGcc7ELMHPkIxydhz5oTR1j77DRXAtfro
   sC8R/7ShNMzLYdEfGzRhHT2FkomfSpD21/40atlfdt/BAjr4X9MUtqWso
   xyJ8Led6YPPJS+0Zon1l316y1xYmX9oIClh7trqlUfaeiOwLRKhe6rsyo
   uJ2lcgT7BuTARkTIKHD/8pNH4t916b+RZcHwFbFfCfFBnHnoZymrybvZi
   w==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643698800"; 
   d="scan'208";a="158348642"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2022 01:42:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Mar 2022 01:42:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 28 Mar 2022 01:42:34 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
Date:   Mon, 28 Mar 2022 04:42:42 -0400
Message-ID: <20220328084243.301493-2-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
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
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 35 +++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9bb31f66db85..b92e82a576e3 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1728,9 +1728,20 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	u32 mask;
-	mask = (u32)(1 << vec);
+	u32 vec_u;
 
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
+	if (vec < 32) {
+		mask = (u32)(1 << vec);
+		/*vectors 0 - 31*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR,
+			    (u32)(mask & 0xFFFFFFFF));
+	} else {
+		vec_u = vec - 32;
+		mask = (u32)(1 << vec_u);
+		/*vectors 32 - 63*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U,
+			    (u32)(mask & 0xFFFFFFFF));
+	}
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
@@ -1747,11 +1758,25 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	u32 mask;
-	if (vec == 0xFF)
+	u32 vec_u;
+
+	if (vec == 0xFF) {
 		mask = 0xFFFFFFFF;
-	else
+		/* disable all vectors 0-31, 32-63*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);
+	} else if (vec < 32) {
 		mask = (u32)(1 << vec);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
+		/*vectors 0 - 31*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR,
+			    (u32)(mask & 0xFFFFFFFF));
+	} else {
+		vec_u = vec - 32;
+		mask = (u32)(1 << vec_u);
+		/*vectors 32 - 63*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U,
+			    (u32)(mask & 0xFFFFFFFF));
+	}
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
-- 
2.31.1

