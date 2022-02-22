Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8DEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 09:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiBVJXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 04:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBVJXz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 04:23:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156D013D92A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 01:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645521810; x=1677057810;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FzlRxwjLHk24p5btVZn7u+P9AR4beLCz1OhirLTmN/I=;
  b=vfbCfQxI0tliogVT07iMVWsyoydyi3Wa1Lo8O/A7MO+WVDED1s2UY57e
   eFTAFZyLPUk3L3SPz3JOhN7tnqzxJYGVOuwdHK6rMekGDR/Vjx0jUhoFF
   vYqRemDx9TqRXjPBikFoMJ73F+Bmt63+zh+gRD5nCioTec3r0TusLmD5P
   m5H/YjoGcN0YBjPB9HZBUOBWalf+fiinMRX0VAAZiLN2CLgtMD0X+yg5a
   R51pYf/2Zr+g/quInDfGeleHu/yvHYRgw6G2LOe0R5DMznzC/G6zNbkKr
   itQavyC791dLjhgeZst7Pa8UomfLYgNg5Gb+lnWcP3JJFeQOkCXeRl/p3
   A==;
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="163127979"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Feb 2022 02:23:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Feb 2022 02:23:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 22 Feb 2022 02:23:29 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v2] scsi: pm80xx: handle non-fatal errors
Date:   Tue, 22 Feb 2022 14:56:18 +0530
Message-ID: <20220222092618.108198-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Firmware expects host driver to clear scratchpad rsvd 0 register after
non-fatal error is found.

This is done when firmware raises fatal error interrupt and indicates
non-fatal error. At this point firmware updates scratchpad rsvd 0
register with non-fatal error value. Here host has to clear the register
after reading it during non-fatal errors.

Renamed
MSGU_HOST_SCRATCH_PAD_6 to MSGU_SCRATCH_PAD_RSVD_0
MSGU_HOST_SCRATCH_PAD_7 to MSGU_SCRATCH_PAD_RSVD_1

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 28 ++++++++++++++++++++++------
 drivers/scsi/pm8001/pm80xx_hwi.h |  9 +++++++--
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index bbf538fe15b3..9fcc332d685b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1552,9 +1552,9 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
 {
 	int ret = 0;
 	u32 scratch_pad_rsvd0 = pm8001_cr32(pm8001_ha, 0,
-					MSGU_HOST_SCRATCH_PAD_6);
+					    MSGU_SCRATCH_PAD_RSVD_0);
 	u32 scratch_pad_rsvd1 = pm8001_cr32(pm8001_ha, 0,
-					MSGU_HOST_SCRATCH_PAD_7);
+					    MSGU_SCRATCH_PAD_RSVD_1);
 	u32 scratch_pad1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	u32 scratch_pad2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
 	u32 scratch_pad3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
@@ -1663,9 +1663,9 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 			PCI_VENDOR_ID_ATTO &&
 			pm8001_ha->pdev->subsystem_vendor != 0) {
 			ibutton0 = pm8001_cr32(pm8001_ha, 0,
-					MSGU_HOST_SCRATCH_PAD_6);
+					       MSGU_SCRATCH_PAD_RSVD_0);
 			ibutton1 = pm8001_cr32(pm8001_ha, 0,
-					MSGU_HOST_SCRATCH_PAD_7);
+					       MSGU_SCRATCH_PAD_RSVD_1);
 			if (!ibutton0 && !ibutton1) {
 				pm8001_dbg(pm8001_ha, FAIL,
 					   "iButton Feature is not Available!!!\n");
@@ -4138,9 +4138,9 @@ static void print_scratchpad_registers(struct pm8001_hba_info *pm8001_ha)
 	pm8001_dbg(pm8001_ha, FAIL, "MSGU_HOST_SCRATCH_PAD_5: 0x%x\n",
 		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_5));
 	pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_0: 0x%x\n",
-		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_6));
+		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_RSVD_0));
 	pm8001_dbg(pm8001_ha, FAIL, "MSGU_RSVD_SCRATCH_PAD_1: 0x%x\n",
-		   pm8001_cr32(pm8001_ha, 0, MSGU_HOST_SCRATCH_PAD_7));
+		   pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_RSVD_1));
 }
 
 static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
@@ -4162,6 +4162,22 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 			pm8001_handle_event(pm8001_ha, NULL, IO_FATAL_ERROR);
 			print_scratchpad_registers(pm8001_ha);
 			return ret;
+		} else {
+			/*read scratchpad rsvd 0 register*/
+			regval = pm8001_cr32(pm8001_ha, 0,
+					     MSGU_SCRATCH_PAD_RSVD_0);
+			switch (regval) {
+			case NON_FATAL_SPBC_LBUS_ECC_ERR:
+			case NON_FATAL_BDMA_ERR:
+			case NON_FATAL_THERM_OVERTEMP_ERR:
+				/*Clear the register*/
+				pm8001_cw32(pm8001_ha, 0,
+					    MSGU_SCRATCH_PAD_RSVD_0,
+					    0x00000000);
+				break;
+			default:
+				break;
+			}
 		}
 	}
 	circularQ = &pm8001_ha->outbnd_q_tbl[vec];
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index c7e5d93bea92..f0818540b2cd 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1366,8 +1366,8 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define MSGU_HOST_SCRATCH_PAD_3			0x60
 #define MSGU_HOST_SCRATCH_PAD_4			0x64
 #define MSGU_HOST_SCRATCH_PAD_5			0x68
-#define MSGU_HOST_SCRATCH_PAD_6			0x6C
-#define MSGU_HOST_SCRATCH_PAD_7			0x70
+#define MSGU_SCRATCH_PAD_RSVD_0			0x6C
+#define MSGU_SCRATCH_PAD_RSVD_1			0x70
 
 #define MSGU_SCRATCHPAD1_RAAE_STATE_ERR(x) ((x & 0x3) == 0x2)
 #define MSGU_SCRATCHPAD1_ILA_STATE_ERR(x) (((x >> 2) & 0x3) == 0x2)
@@ -1435,6 +1435,11 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define SCRATCH_PAD_ERROR_MASK		0xFFFFFC00 /* Error mask bits */
 #define SCRATCH_PAD_STATE_MASK		0x00000003 /* State Mask bits */
 
+/*state definition for Scratchpad Rsvd 0, Offset 0x6C, Non-fatal*/
+#define NON_FATAL_SPBC_LBUS_ECC_ERR	0x70000001
+#define NON_FATAL_BDMA_ERR		0xE0000001
+#define NON_FATAL_THERM_OVERTEMP_ERR	0x80000001
+
 /* main configuration offset - byte offset */
 #define MAIN_SIGNATURE_OFFSET		0x00 /* DWORD 0x00 */
 #define MAIN_INTERFACE_REVISION		0x04 /* DWORD 0x01 */
-- 
2.27.0

