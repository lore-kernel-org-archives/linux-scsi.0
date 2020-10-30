Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E49C56202
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 05:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB556221F8
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 05:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgJ3F7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:59:23 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:19185 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3F7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 01:59:23 -0400
IronPort-SDR: ZMjaW/QA1ORILsFM+u6WjG3GHjsg+dIbV9kHoUM3K0aedMWIBXkNVvDNYQaUFlFuCusjGLc6QW
 52pGeOEHB1Zs9tWEF5HdSrz7ol7SEgEFQwKb3GrJIriSrttpSD6qk0Q6s4hHxH6qUpE8VlZn1d
 HH4jxrcW3YgqVhI7e1NQgRpPeAZjM02zwZ4GGfUbfmlR9hZWD1JOaEsghaViDTnwLE6wY9FKX8
 347u/6t92EYA8gDDL/3m/y1eYngmpl3PEY6wuI6XX1eXGAPJ8h7CTK+nNfKjfoZLSrmN1R93Mi
 GyY=
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="101540446"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Oct 2020 22:59:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 22:59:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 29 Oct 2020 22:59:21 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V2 3/4] pm80xx: Avoid busywait in FW ready check
Date:   Fri, 30 Oct 2020 11:39:12 +0530
Message-ID: <20201030060913.14886-4-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201030060913.14886-1-Viswas.G@microchip.com.com>
References: <20201030060913.14886-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: akshatzen <akshatzen@google.com>

Today in function check_fw_ready we do busy wait using udelay. Due to
which CPU is not released and we see CPU need_resched failures.

Here busy waiting is not necessary since we are in process context and
we should sleep instead. So to avoid busy waiting we are replacing
udelay with msleep of 20 ms intervals to check for FW to become ready.

It's verified that check_fw_ready today is not being used in interrupt
context anywhere, hence it is safe to make this change.

Tested:
Installed the kernel and looked at dmesg for failures pertaining to
need_resched and did not find them.

Signed-off-by: akshatzen <akshatzen@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 21 +++++++++++----------
 drivers/scsi/pm8001/pm80xx_hwi.h |  6 ++++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 1ba93fb76093..24a4f6b9e79d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1042,6 +1042,7 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 
 /**
  * check_fw_ready - The LLDD check if the FW is ready, if not, return error.
+ * This function sleeps hence it must not be used in atomic context.
  * @pm8001_ha: our hba card information
  */
 static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
@@ -1052,16 +1053,16 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	int ret = 0;
 
 	/* reset / PCIe ready */
-	max_wait_time = max_wait_count = 100 * 1000;	/* 100 milli sec */
+	max_wait_time = max_wait_count = 5;	/* 100 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while ((value == 0xFFFFFFFF) && (--max_wait_count));
 
 	/* check ila status */
-	max_wait_time = max_wait_count = 1000 * 1000;	/* 1000 milli sec */
+	max_wait_time = max_wait_count = 50;	/* 1000 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while (((value & SCRATCH_PAD_ILA_READY) !=
 			SCRATCH_PAD_ILA_READY) && (--max_wait_count));
@@ -1074,9 +1075,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	}
 
 	/* check RAAE status */
-	max_wait_time = max_wait_count = 1800 * 1000;	/* 1800 milli sec */
+	max_wait_time = max_wait_count = 90;	/* 1800 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while (((value & SCRATCH_PAD_RAAE_READY) !=
 				SCRATCH_PAD_RAAE_READY) && (--max_wait_count));
@@ -1089,9 +1090,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	}
 
 	/* check iop0 status */
-	max_wait_time = max_wait_count = 600 * 1000;	/* 600 milli sec */
+	max_wait_time = max_wait_count = 30;	/* 600 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while (((value & SCRATCH_PAD_IOP0_READY) != SCRATCH_PAD_IOP0_READY) &&
 			(--max_wait_count));
@@ -1107,9 +1108,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	if ((pm8001_ha->chip_id != chip_8008) &&
 			(pm8001_ha->chip_id != chip_8009)) {
 		/* 200 milli sec */
-		max_wait_time = max_wait_count = 200 * 1000;
+		max_wait_time = max_wait_count = 10;
 		do {
-			udelay(1);
+			msleep(FW_READY_INTERVAL);
 			value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 		} while (((value & SCRATCH_PAD_IOP1_READY) !=
 				SCRATCH_PAD_IOP1_READY) && (--max_wait_count));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 701951a0f715..ec48bc276de6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1639,3 +1639,9 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 
 #define MEMBASE_II_SHIFT_REGISTER       0x1010
 #endif
+
+/**
+ * As we know sleep (1~20) ms may result in sleep longer than ~20 ms, hence we
+ * choose 20 ms interval.
+ */
+#define FW_READY_INTERVAL	20
-- 
2.16.3

