From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V2 6/9] pm80xx : modified port reset timer value for PM8006 card
Date: Wed, 18 Feb 2015 05:06:47 +0530
Message-ID: <20150217233650.9091-7-Viswas.G@microsemi.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03hn0209.outbound.protection.outlook.com ([104.47.42.209]:61904
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751905AbdIMKmQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 06:42:16 -0400
In-Reply-To: <20150217233650.9091-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

Added port reset timer value as 2000ms for PM8006 sata controller.

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index baab8a19c78e..8f1f5dc77d71 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -597,6 +597,12 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &= 0xffff0000;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
 							PORT_RECOVERY_TIMEOUT;
+	if (pm8001_ha->chip_id == chip_8006) {
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer &=
+					0x0000ffff;
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer |=
+					0x140000;
+	}
 	pm8001_mw32(address, MAIN_PORT_RECOVERY_TIMER,
 			pm8001_ha->main_cfg_tbl.pm80xx_tbl.port_recovery_timer);
 }
-- 
2.12.3
