From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V3 6/9] pm80xx : modified port reset timer value for PM8006 card
Date: Tue, 19 Sep 2017 22:40:01 +0530
Message-ID: <20170919171004.10331-7-Viswas.G@microsemi.com>
References: <20170919171004.10331-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0061.outbound.protection.outlook.com ([104.47.41.61]:32425
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751396AbdISRKi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 13:10:38 -0400
In-Reply-To: <20170919171004.10331-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

Added port reset timer value as 2000ms for PM8006 sata controller.

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>

Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
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
