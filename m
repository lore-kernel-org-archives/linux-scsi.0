Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D16FC433E9
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BCC1235FC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbhAIMaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8242 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195417; x=1641731417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=86KVVGkjsxV3CuXgmxLUP4ISNLUjibp0P90ZoI6alJc=;
  b=V7gHdpMgWlaXifHMMFNzAoqD5o2H/0ecTrgluCWWAoSE04DD1Sy80iHe
   QoJtlPOe2aN1NA0vP3yMkA3WCtVM+scp5izfEkjVFCcYyCFYAG1uUWJ39
   /76KK1CG+adCg67xDPm3HGc1DwNIzN9uCD89ZQJ64R6YfEQc8XW0EZr6D
   J3aYm0e6kZ7/Ls5woxNsQSNCFcOdLx/GV3KmsJhb1Civp7XIpZzJmIiuM
   kDWQAf2jf7f8LUfu/cZhlHzh8mTDaJ/ZN/kR+FCXCTqIkSq3BHgiPB2EX
   i4T14Qr/bwFrRb2acss5d4ayztckPDL+f5GHTn+ug+ZE9cNXgreO3V9+i
   A==;
IronPort-SDR: Pf8rSgAMX/1PCew9I1q9esdzlb6fnF03n/k1iZ68dU6Ra4Dl+KJN4BdJjQIgdElNekEtdFc1DM
 o/IxfFeIuecIb45MJD6VqfTUz6kM/YD5pvQFwrBayALyqrreY5wBV82HBblsEcYjCmuv/eKuAI
 wyavYwyd5SZ68Ve1jR365JGbyP4Rn3BrxmUVORgA/uVrwEoXYpZZR0Wna2NttQxFoiGMcPTR3I
 0oD9PbGNFf8sddGEYlHmEsMZsi6lzYU5Xhdok2nWE2ZAiWyC5gxnL4EHyEjmkFqMhYm/xyyt4U
 utw=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="99533222"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:29:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:29:01 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:29:00 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 4/8] pm80xx: fix missing tag_free in NVMD DATA req
Date:   Sat, 9 Jan 2021 18:08:45 +0530
Message-ID: <20210109123849.17098-5-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: akshatzen <akshatzen@google.com>

Tag is not free'd in NVMD get/set data request failure scenario,
which would have caused tag leak each time the request fails.

Signed-off-by: akshatzen <akshatzen@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index f147193d67bd..9cd6a654f8b2 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3038,8 +3038,8 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	complete(pm8001_ha->nvmd_completion);
 	pm8001_dbg(pm8001_ha, MSG, "Set nvm data complete!\n");
 	if ((dlen_status & NVMD_STAT) != 0) {
-		pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error!\n");
-		return;
+		pm8001_dbg(pm8001_ha, FAIL, "Set nvm data error %x\n",
+				dlen_status);
 	}
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
@@ -3062,11 +3062,17 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	pm8001_dbg(pm8001_ha, MSG, "Get nvm data complete!\n");
 	if ((dlen_status & NVMD_STAT) != 0) {
-		pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error!\n");
+		pm8001_dbg(pm8001_ha, FAIL, "Get nvm data error %x\n",
+				dlen_status);
 		complete(pm8001_ha->nvmd_completion);
+		/* We should free tag during failure also, the tag is not being
+		 * free'd by requesting path anywhere.
+		 */
+		ccb->task = NULL;
+		ccb->ccb_tag = 0xFFFFFFFF;
+		pm8001_tag_free(pm8001_ha, tag);
 		return;
 	}
-
 	if (ir_tds_bn_dps_das_nvm & IPMode) {
 		/* indirect mode - IR bit set */
 		pm8001_dbg(pm8001_ha, MSG, "Get NVMD success, IR=1\n");
-- 
2.16.3

