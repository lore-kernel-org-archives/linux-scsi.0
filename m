Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738AFC4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 11:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbiDEK4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 06:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345028AbiDEJmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 05:42:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ACFBF959
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 02:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649150901; x=1680686901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MiDBtTI5DxAu1kXNuWEhbMRyLeEHOB8yGCKvaEoMnnI=;
  b=zAgyuRTSklxAZfLfy+e33j0hfqwPMjAFNW0FmYXeJbYKGZWFiDZ753WD
   SIadQB2qh0DuuA54rBIvUJ3qINikUL/jjz19WVdhw9zU0pKsYo1VymH3f
   zFyBwwUYQeHfsbSaEw9SvB3iWnSFtC4CT5D1s3by4cXJ9bwFi0Kl7PWio
   yX3zI8xEUcrK8aPuhk/WZEsi4SyNtW1pBbkUvQvce2sCkdsgJsA0wSFmF
   fHEicCOG+mBV6sJKUhbfGViSr0ddRKakCgInAQTX5p1tjGBRQVpPbeE3e
   2/nBodoD8wi+mBDKK3CyvCgXPfHOE1lVIqhiwD8pcceUroKlY8iLCtyuB
   A==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="154410412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 02:28:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 02:28:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 02:28:20 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors 32-63
Date:   Tue, 5 Apr 2022 05:28:32 -0400
Message-ID: <20220405092833.83335-2-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
References: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
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
 drivers/scsi/pm8001/pm80xx_hwi.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9bb31f66db85..3e6413e21bfe 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1728,9 +1728,17 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	u32 mask;
-	mask = (u32)(1 << vec);
 
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, (u32)(mask & 0xFFFFFFFF));
+	if (vec < 32) {
+		mask = 1U << vec;
+		/*vectors 0 - 31*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR, mask);
+	} else {
+		vec = vec - 32;
+		mask = 1U << vec;
+		/*vectors 32 - 63*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_CLR_U, mask);
+	}
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_enable(pm8001_ha);
@@ -1747,11 +1755,22 @@ pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 {
 #ifdef PM8001_USE_MSIX
 	u32 mask;
-	if (vec == 0xFF)
+
+	if (vec == 0xFF) {
 		mask = 0xFFFFFFFF;
-	else
-		mask = (u32)(1 << vec);
-	pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, (u32)(mask & 0xFFFFFFFF));
+		/* disable all vectors 0-31, 32-63*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);
+	} else if (vec < 32) {
+		mask = 1U << vec;
+		/*vectors 0 - 31*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, mask);
+	} else {
+		vec = vec - 32;
+		mask = 1U << vec;
+		/*vectors 32 - 63*/
+		pm8001_cw32(pm8001_ha, 0, MSGU_ODMR_U, mask);
+	}
 	return;
 #endif
 	pm80xx_chip_intx_interrupt_disable(pm8001_ha);
-- 
2.31.1

