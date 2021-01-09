Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F63C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B81235DD
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAIMa5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:63795 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195456; x=1641731456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=sgRzZaYhzN7qaiiMH6XvnZw3BVhPp7ygvJ3c0xFsRy0=;
  b=vn97gPFMhXDB15eoXdFbALWiWfDzGGcku6V7Qip9YkVCU+DiIhZ1+07V
   RDdWeGI9o3mYRNwoMtpTu539yn3W4nkwKYVeSqG1pLv5JDry3rC3evwGI
   0W5FFA5QfxPaMbPrJwYgOY530pxeVUOTHb279aP5k6BcHtln0NTtVUVKW
   W2ipR6oZhOMQaYGJX3beymzaTvmrJOAf/LudSqMVKya62WePiKb+QUAZX
   65wAZgTx5wGikogSmM1sDux+U/VBfdBQGX/cJeqmRwgt78V2KgLBVLcfC
   /AEq940T1/QiUXZBQJigzHUC616Naa1T4R8e+D/N0BXxK8pSxUfHP30JR
   w==;
IronPort-SDR: eOXuuk69oQbh8DfC4Mi76s3UiCvrJnKfw6m/KVbO1/D70tLunPvU68vHm3WJDH/o3H2tgh4Khk
 s6ICSA9/qGbtTK6qktNNTFeCyFlsL9Z9fyDYld7/pL/KtLw6kFph7PGAhyRdOZ8xAt+7ssAvOS
 /o0Y5zcYFUHB8QzABDVDOjx1/UCkPWr5oq4Ydi+1Ns3Ajg/09qdLa0X7lrSSPabuvcQxPJPat6
 /b7dYKeMDbIZkdak5K0pwcRdGJ8qYjVDihdDT3EgMVE4XXFDZMGoQtT6BMHCcgklRX9ij/Dxge
 AC4=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="39871687"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:29:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:29:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:29:04 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 6/8] pm80xx: Simultaneous poll for all FW readiness.
Date:   Sat, 9 Jan 2021 18:08:47 +0530
Message-ID: <20210109123849.17098-7-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bhavesh Jashnani <bjashnani@google.com>

In check_fw_ready() we first wait for ILA to come up and then we
wait for RAAE to come up and IOPs and so on. This is a sequential check.
Because of this ILA image seems to be not ready in the allocated time
and so the driver marks it as "not ready" and then move on to other FW
images. But ILA does become ready eventually, but is not checked again.
In this way driver concludes that FW is not ready, when it actually is.

Fix: Instead of sequentially polling each image, we keep polling for all
images to be ready. The timeout for the polling has been set to the sum
of what was used for each individual image.

Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 80 ++++++++++++----------------------------
 1 file changed, 23 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 407c0cf6ab5f..df679e36954a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1043,6 +1043,7 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	u32 value;
 	u32 max_wait_count;
 	u32 max_wait_time;
+	u32 expected_mask;
 	int ret = 0;
 
 	/* reset / PCIe ready */
@@ -1052,70 +1053,35 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while ((value == 0xFFFFFFFF) && (--max_wait_count));
 
-	/* check ila status */
-	max_wait_time = max_wait_count = 50;	/* 1000 milli sec */
-	do {
-		msleep(FW_READY_INTERVAL);
-		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-	} while (((value & SCRATCH_PAD_ILA_READY) !=
-			SCRATCH_PAD_ILA_READY) && (--max_wait_count));
-	if (!max_wait_count)
-		ret = -1;
-	else {
-		pm8001_dbg(pm8001_ha, MSG,
-			   " ila ready status in %d millisec\n",
-			   (max_wait_time - max_wait_count));
-	}
-
-	/* check RAAE status */
-	max_wait_time = max_wait_count = 90;	/* 1800 milli sec */
-	do {
-		msleep(FW_READY_INTERVAL);
-		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-	} while (((value & SCRATCH_PAD_RAAE_READY) !=
-				SCRATCH_PAD_RAAE_READY) && (--max_wait_count));
-	if (!max_wait_count)
-		ret = -1;
-	else {
-		pm8001_dbg(pm8001_ha, MSG,
-			   " raae ready status in %d millisec\n",
-			   (max_wait_time - max_wait_count));
+	/* check ila, RAAE and iops status */
+	if ((pm8001_ha->chip_id != chip_8008) &&
+			(pm8001_ha->chip_id != chip_8009)) {
+		max_wait_time = max_wait_count = 180;   /* 3600 milli sec */
+		expected_mask = SCRATCH_PAD_ILA_READY |
+			SCRATCH_PAD_RAAE_READY |
+			SCRATCH_PAD_IOP0_READY |
+			SCRATCH_PAD_IOP1_READY;
+	} else {
+		max_wait_time = max_wait_count = 170;   /* 3400 milli sec */
+		expected_mask = SCRATCH_PAD_ILA_READY |
+			SCRATCH_PAD_RAAE_READY |
+			SCRATCH_PAD_IOP0_READY;
 	}
-
-	/* check iop0 status */
-	max_wait_time = max_wait_count = 30;	/* 600 milli sec */
 	do {
 		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-	} while (((value & SCRATCH_PAD_IOP0_READY) != SCRATCH_PAD_IOP0_READY) &&
-			(--max_wait_count));
-	if (!max_wait_count)
+	} while (((value & expected_mask) !=
+				 expected_mask) && (--max_wait_count));
+	if (!max_wait_count) {
+		pm8001_dbg(pm8001_ha, INIT,
+		"At least one FW component failed to load within %d millisec: Scratchpad1: 0x%x\n",
+			max_wait_time * FW_READY_INTERVAL, value);
 		ret = -1;
-	else {
+	} else {
 		pm8001_dbg(pm8001_ha, MSG,
-			   " iop0 ready status in %d millisec\n",
-			   (max_wait_time - max_wait_count));
+			"All FW components ready by %d ms\n",
+			(max_wait_time - max_wait_count) * FW_READY_INTERVAL);
 	}
-
-	/* check iop1 status only for 16 port controllers */
-	if ((pm8001_ha->chip_id != chip_8008) &&
-			(pm8001_ha->chip_id != chip_8009)) {
-		/* 200 milli sec */
-		max_wait_time = max_wait_count = 10;
-		do {
-			msleep(FW_READY_INTERVAL);
-			value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-		} while (((value & SCRATCH_PAD_IOP1_READY) !=
-				SCRATCH_PAD_IOP1_READY) && (--max_wait_count));
-		if (!max_wait_count)
-			ret = -1;
-		else {
-			pm8001_dbg(pm8001_ha, MSG,
-				   "iop1 ready status in %d millisec\n",
-				   (max_wait_time - max_wait_count));
-		}
-	}
-
 	return ret;
 }
 
-- 
2.16.3

