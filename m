Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66256C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398E260F92
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbhHWH3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 03:29:22 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:50368 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhHWH3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 03:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629703716; x=1661239716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=660fb0MKI5g+2HTrKghY4hOt6Os3nhuzgpfpVnOPgLg=;
  b=mQXHAoKf5QYEQN5+YjCWxI95597NfAEbZX+D6AHnmpXDAtrld4DAT68I
   Dt8l3W5rhpzpfVvMcmmO2t31jzuD/BL41M8i6Iwi9E14U4a5VZMzKN5Lp
   Fp/1XYTi3zvXPwkfI3+WN9hKF1x0sIkYS3OD83O7f8Xfcq01Z3ubfWUMC
   XI1yEqb/5wIBOaG863IjHk2xzlW541VVTuhp8sd0+pEUdvKNQWLO7Vfid
   ac7lNF1GG3GiWsdHiU+avIkU6KSIGdN3mh7fw9aoOiTNqyKeDc4kUY+us
   yYQjeq4+Th/9rmuvMvhQ7YELlnh71eYkhUeREPeHqem4Jz2AjCxC27WaW
   Q==;
IronPort-SDR: gkZOfknEQwmOh273O91Xj30/WbiOApSaiWi7enZbHbJhPOKsc3+q1KRQf1qzQTXPN2ru7W5EkH
 MIGLd1FEJpkxJn5i3R/Ec9B4TJYO/v27ZdZtNexGPQkYPqHjwBenhN22jND649s9L0MYHB3bSG
 rTDyAbcSiODdSk6MxuI0SJAK0/8wiHr4/kUUobJZB+ziWnGUelX3MOV4q0y9edhPtf1l7tbZ7Z
 40aRlEiZdve8TIcWVUyqFFuQ6tV6AwvT1gazkAuDXlp5iErqXRAizxMO2IhD7cMVbWaBi9LAqC
 5XMAtq+FfsE4xiOHgPCP1wCH
X-IronPort-AV: E=Sophos;i="5.84,343,1620716400"; 
   d="scan'208";a="129208644"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2021 00:28:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 23 Aug 2021 00:28:35 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 23 Aug 2021 00:28:35 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/4] scsi: pm80xx: fix incorrect port value when registering a device
Date:   Mon, 23 Aug 2021 13:53:35 +0530
Message-ID: <20210823082338.67309-2-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
References: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometime we observe there is mismatch between portid & phyid
received during phyup event and device registration. Later this
will cause drive missing issue.

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

