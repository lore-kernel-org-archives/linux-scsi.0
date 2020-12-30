Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE378C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4AE207AF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgL3EtK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Dec 2020 23:49:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:39095 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgL3EtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2020 23:49:10 -0500
IronPort-SDR: qjFV5BDomDhfcvNdOPgAhKAI/z1T1x0AtniAYaJ/Y1XiomDUEX4x6JZ0DzATozBrc6xlTnuLuh
 vvuxRKlDs+XcUY7MNH+im4x6rE6aIpcDmGVpA9/4W7K7zMGuMIK11GqIgfrFvr1PBoqhqvJkUx
 5oCrF7+ES8MBU0OfYQyaIrk34czykUQ0YERqst68XwzT48fZnURePaBfRbpbakZGvH6VSQ/HAt
 UEATyOhuBI1XFbGhoR2SmhZpfTpL3rKnBmLIzuQcSM2DomjL6DK6B0GlOu9fuMZA0EKfOIMHr2
 CE0=
X-IronPort-AV: E=Sophos;i="5.78,460,1599548400"; 
   d="scan'208";a="101338721"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Dec 2020 21:47:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 21:47:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 29 Dec 2020 21:47:53 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4/8] pm80xx: fix missing tag_free in NVMD DATA req
Date:   Wed, 30 Dec 2020 10:27:39 +0530
Message-ID: <20201230045743.14694-5-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201230045743.14694-1-Viswas.G@microchip.com.com>
References: <20201230045743.14694-1-Viswas.G@microchip.com.com>
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

