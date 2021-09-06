Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8AAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D6F60F43
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243794AbhIFQKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:10:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:28175 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbhIFQKG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 12:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1630944541; x=1662480541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NABKVHcyZbEZOsbrj1qIfaJNuMd97f9HWTcZaW3P3fo=;
  b=he59UP47I8MN64W7DYhOj242SK9TxJFbAPTss47bTeW3fhWt/8r9hxjH
   lSTFRFS9zZ7dik3tq6PPoruGiihsgjGc6bMEtmAw2thFJMtNco1iBtSgI
   96kJJ0Am9vwxsz9HsQdF3ZNNLkX4GxcVR9Miv3nDOzJPNcTl/Cicm1M6h
   7REfiryIzOE8/gZUS6vujX3HRCSRJtOAo1p8DA8oU/W0WSyrU9eO9AIO+
   om1RKrYVHcBjQfV8DQeqdtw9Dyit0wKL3nASpGkCTXddCrU0wNBL04S7a
   JB9nUcjIcZPArfO1mAuoZVd2HbSTS7BMRd2sAq8Rssv8WdnUx+OOfteJU
   Q==;
IronPort-SDR: v1sDC/6uqOqLUcb23Gar4gvhuoAcSj0D7/3AdkP3/Z9eyttSS+X+2AZ89OMxNLD82rHhoYYJQm
 ORTvL8NTnT/W/z+AxhcotPN40/a1IEhl7CsX1ScdGz4RTvD1UOdZn4Xawg7mYvN6U7taOu22D5
 bFXbnnojH1quunZCUtCrhQVLshTKKuAxUqOWcaM8LfIOuxjj5QeHLDB0iL5YqJvWEuU2iBj2/8
 TOE5CsgekJq6i8ymirUY/H9hSPYOO5OU1mRRnycopwo00fjVjndOSS/pz6gXUp1xBqYi4XSOSE
 1htRox+TJqKyDiFqbichvWcA
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="130876411"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2021 09:09:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 6 Sep 2021 09:09:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 6 Sep 2021 09:09:00 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 1/4] scsi: pm80xx: fix incorrect port value when registering a device
Date:   Mon, 6 Sep 2021 22:34:01 +0530
Message-ID: <20210906170404.5682-2-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
References: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During phyup event, firmware gives the phy_id and port_id
and driver is supposed to use the same during device handle
registration. Earlier, driver was using port id value from
libsas during device handle registration and at times, it is
different from firmware assigned port id. This will lead to
wrong device registration and eventually we would not see
those drives.

Fix is to use firmware assigned portid during device
registration.

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  |  7 ++++++-
 drivers/scsi/pm8001/pm8001_init.c |  1 +
 drivers/scsi/pm8001/pm8001_sas.c  | 15 +++++++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c  |  7 ++++++-
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 63690508313b..c9ecddd0d719 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3358,6 +3358,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
+	phy->port = port;
+	port->port_id = port_id;
 	port->port_state =  portstate;
 	phy->phy_state = PHY_STATE_LINK_UP_SPC;
 	pm8001_dbg(pm8001_ha, MSG,
@@ -3434,6 +3436,8 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	unsigned long flags;
 	pm8001_dbg(pm8001_ha, DEVIO, "HW_EVENT_SATA_PHY_UP port id = %d, phy id = %d\n",
 		   port_id, phy_id);
+	phy->port = port;
+	port->port_id = port_id;
 	port->port_state =  portstate;
 	phy->phy_state = PHY_STATE_LINK_UP_SPC;
 	port->port_attached = 1;
@@ -4460,6 +4464,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
 	struct domain_device *parent_dev = dev->parent;
+	struct pm8001_port *port = dev->port->lldd_port;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
 	memset(&payload, 0, sizeof(payload));
@@ -4488,7 +4493,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	linkrate = (pm8001_dev->sas_device->linkrate < dev->port->linkrate) ?
 			pm8001_dev->sas_device->linkrate : dev->port->linkrate;
 	payload.phyid_portid =
-		cpu_to_le32(((pm8001_dev->sas_device->port->id) & 0x0F) |
+		cpu_to_le32(((port->port_id) & 0x0F) |
 		((phy_id & 0x0F) << 4));
 	payload.dtype_dlr_retry = cpu_to_le32((retryFlag & 0x01) |
 		((linkrate & 0x0F) * 0x1000000) |
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 47db7e0beae6..613455a3e686 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -128,6 +128,7 @@ static struct sas_domain_function_template pm8001_transport_ops = {
 	.lldd_I_T_nexus_reset   = pm8001_I_T_nexus_reset,
 	.lldd_lu_reset		= pm8001_lu_reset,
 	.lldd_query_task	= pm8001_query_task,
+	.lldd_port_formed	= pm8001_port_formed,
 };
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 32e60f0c3b14..83e73009db5c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1355,3 +1355,18 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
 	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
+
+void pm8001_port_formed(struct asd_sas_phy *sas_phy)
+{
+	struct sas_ha_struct *sas_ha = sas_phy->ha;
+	struct pm8001_hba_info *pm8001_ha = sas_ha->lldd_ha;
+	struct pm8001_phy *phy = sas_phy->lldd_phy;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct pm8001_port *port = phy->port;
+
+	if (!sas_port) {
+		pm8001_dbg(pm8001_ha, FAIL, "Received null port\n");
+		return;
+	}
+	sas_port->lldd_port = port;
+}
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 62d08b535a4b..1a016a421280 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -230,6 +230,7 @@ struct pm8001_port {
 	u8			port_attached;
 	u16			wide_port_phymap;
 	u8			port_state;
+	u8			port_id;
 	struct list_head	list;
 };
 
@@ -651,6 +652,7 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun);
 int pm8001_I_T_nexus_reset(struct domain_device *dev);
 int pm8001_I_T_nexus_event_handler(struct domain_device *dev);
 int pm8001_query_task(struct sas_task *task);
+void pm8001_port_formed(struct asd_sas_phy *sas_phy);
 void pm8001_open_reject_retry(
 	struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task_to_close,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6ffe17b849ae..cec932f830b8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3299,6 +3299,8 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	struct pm8001_phy *phy = &pm8001_ha->phy[phy_id];
 	unsigned long flags;
 	u8 deviceType = pPayload->sas_identify.dev_type;
+	phy->port = port;
+	port->port_id = port_id;
 	port->port_state = portstate;
 	port->wide_port_phymap |= (1U << phy_id);
 	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
@@ -3380,6 +3382,8 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		   "port id %d, phy id %d link_rate %d portstate 0x%x\n",
 		   port_id, phy_id, link_rate, portstate);
 
+	phy->port = port;
+	port->port_id = port_id;
 	port->port_state = portstate;
 	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
 	port->port_attached = 1;
@@ -4808,6 +4812,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
 	struct domain_device *parent_dev = dev->parent;
+	struct pm8001_port *port = dev->port->lldd_port;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
 	memset(&payload, 0, sizeof(payload));
@@ -4840,7 +4845,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			pm8001_dev->sas_device->linkrate : dev->port->linkrate;
 
 	payload.phyid_portid =
-		cpu_to_le32(((pm8001_dev->sas_device->port->id) & 0xFF) |
+		cpu_to_le32(((port->port_id) & 0xFF) |
 		((phy_id & 0xFF) << 8));
 
 	payload.dtype_dlr_mcn_ir_retry = cpu_to_le32((retryFlag & 0x01) |
-- 
2.27.0

