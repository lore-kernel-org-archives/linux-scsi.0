Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFB3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Dec 2021 11:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhL1LPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Dec 2021 06:15:46 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:51368 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhL1LPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2021 06:15:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640690146; x=1672226146;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KphdA5yEo36pTCplqJMTDKjpqIxC965bXcTJGY7CiB8=;
  b=Y6JLaITkvgsPdkwykEOe6qYJ+yd/BhiTjXXfyGqetnSDoKP8wBRia6dI
   yDLJyUE+la4suFgbsGFUOc4wR0SA5bt6veKB6JFvXyXJoajUl7uitFJmI
   c7eOf2Yit/Xun+cPp2dZeZ7wHjdRh9YTW6dXJ5kDJkaDFw/YBzdg5NH1V
   y2T05A3POwMNk+ACpv7jH/db2rLriSdklzTVxtrzDniNZ0l+k5dONXQ4d
   oxgbCaaNckZ9CNk5p26/7qIraKRF1fT8dTyn8YdOqij22AGl549nP4s6k
   jjSxKg9xFBtcLSXegqYBGAmjAHBIy5eQhUEIWE3NFVlFA61xJ4MlAtASD
   g==;
IronPort-SDR: E6NIKBBN47FyasxE8Gk3FQWStphQzOgdaapnrjR+V/UM41/KEYLj0hdmIerTttRpDNYP7diBKF
 T1KVMoqq6vpvvm/4sKhasUntquJAX3rZcsDrM4fcCD/Zck9DgqbpOXiOuCqFFJ2w2e8OcIUXtF
 tqmnOBhYzAgCyMj8hecWVZ/cgaKOnAGktMHvo8+sFjFe2iwHDSmmvT8lo5HhAOFH3BQdUmQ2fi
 /9LdcQ3KimCUK4Eyul0V+vM1FidJZqs8y927JxniS+w/xKLsISMgZM3F/CXy4+HG2LNtWcYR63
 62+glwZZTa9ts9R8fINuZPJR
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="156868901"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Dec 2021 04:15:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Dec 2021 04:15:43 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 28 Dec 2021 04:15:43 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, "Jinpu Wang" <jinpu.wang@cloud.ionos.com>
Subject: [PATCH] scsi: pm80xx: port reset timeout error handling correction.
Date:   Tue, 28 Dec 2021 16:47:53 +0530
Message-ID: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Error handling steps were not in sequence as per the programmers
manual. Expected sequence:
 -PHY_DOWN (PORT_IN_RESET)
 -PORT_RESET_TIMER_TMO
 -Host aborts pending I/Os
 -Host deregister the device
 -Host sends HW_EVENT_PHY_DOWN ack

Earlier, we were sending HW_EVENT_PHY_DOWN ack first and then
deregister the device.

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 7 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h | 3 +++
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index c9a16eef38c1..160ee8b228c9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1199,7 +1199,7 @@ int pm8001_abort_task(struct sas_task *task)
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_tmf_task tmf_task;
 	int rc = TMF_RESP_FUNC_FAILED, ret;
-	u32 phy_id;
+	u32 phy_id, port_id;
 	struct sas_task_slow slow_task;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
@@ -1246,6 +1246,7 @@ int pm8001_abort_task(struct sas_task *task)
 			DECLARE_COMPLETION_ONSTACK(completion_reset);
 			DECLARE_COMPLETION_ONSTACK(completion);
 			struct pm8001_phy *phy = pm8001_ha->phy + phy_id;
+			port_id = phy->port->port_id;
 
 			/* 1. Set Device state as Recovery */
 			pm8001_dev->setds_completion = &completion;
@@ -1297,6 +1298,10 @@ int pm8001_abort_task(struct sas_task *task)
 						PORT_RESET_TMO);
 				if (phy->port_reset_status == PORT_RESET_TMO) {
 					pm8001_dev_gone_notify(dev);
+					PM8001_CHIP_DISP->hw_event_ack_req(
+						pm8001_ha, 0,
+						0x07, /*HW_EVENT_PHY_DOWN ack*/
+						port_id, phy_id, 0, 0);
 					goto out;
 				}
 			}
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 83eec16d021d..a17da1cebce1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -216,6 +216,9 @@ struct pm8001_dispatch {
 		u32 state);
 	int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
 	int (*fatal_errors)(struct pm8001_hba_info *pm8001_ha);
+	void (*hw_event_ack_req)(struct pm8001_hba_info *pm8001_ha,
+		u32 Qnum, u32 SEA, u32 port_id, u32 phyId, u32 param0,
+		u32 param1);
 };
 
 struct pm8001_chip_info {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 0849ecc913c7..97750d0ebee9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3709,8 +3709,10 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
-		pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
-			port_id, phy_id, 0, 0);
+		if (!pm8001_ha->phy[phy_id].reset_completion) {
+			pm80xx_hw_event_ack_req(pm8001_ha, 0, HW_EVENT_PHY_DOWN,
+				port_id, phy_id, 0, 0);
+		}
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
 		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
@@ -5051,4 +5053,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
 	.fatal_errors		= pm80xx_fatal_errors,
+	.hw_event_ack_req	= pm80xx_hw_event_ack_req,
 };
-- 
2.27.0

