Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769CAC4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DD8964F89
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhCKUSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:18:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45866 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbhCKURk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493861; x=1647029861;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pMjrmSznAIn7UuTlcSSQy5YtSf/FsaqMbeUl3RqPQLQ=;
  b=zybfNeCNSD8lGZWcGhAWgE5oeeVkNOgYy9+pUTBulzYxip8JuAx2IdLs
   Yukl4ndxf8zRuQNwoUOnaD3i/N9dm/Qdvea3sbwfFonBEXZxglADFsSxW
   E4d0ffY1EV27n57NyoX7M3xmboe3Stav/7zEsootMIhOfD+aHDvaXv93P
   0TSD5dOQN3N2ux64SmiSH0TS5x/rn3vWgn9sWDTK4WWFM+y4xvZRk7EBp
   62MqGO0Sn2ACMYs1dToeMP5AuKQx+VYrW9jkLsdAAIj8FPASbHuu1d2N5
   aeqGYAw52rlXkpqWj6Qm0i32kVcvvSm4jk9PFtYXbCpEIbTZYTvkVbm1h
   g==;
IronPort-SDR: K1kG8KxTZYDj1dXHGAhMYlz0b74EnPp8fcyB35SukCPahxbOcB5ZXsGmiqOlP5s8nuHEph+37B
 y2EhQVg1eP26A0oji/jOY1SWjHFbWr0qWbVT5M8W+CASIt8Z+BUDDCxJ/2mOGuQomIkf2PfMvS
 vrdcCybXqhTta4Zhv3qfK4BWlXpIxTU+BaSt9zyKnkoYHZecLMpt67P2SWFXqCS8rDmlSoYLuK
 aWKPMMU297swfdI9BMic37icGA5T2m7PE1IxqhcwDLt/lZbHs6qEO2wBd+GOOqSt82JpLlJoLL
 +LE=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112406150"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:33 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:25 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:25 -0700
Subject: [PATCH V5 26/31] smartpqi: update sas initiator_port_protocols and
 target_port_protocols
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:25 -0600
Message-ID: <161549384532.25025.1469409935400845385.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

* Export valid sas initiator_port_protocols and
  target_port_protocols to sysfs.
  * Needed for lsscsi to show correct values.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |   28 ++++++++++++++++--------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 71e83d5fdd02..dd9b784792ef 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -65,8 +65,8 @@ static int pqi_sas_port_add_phy(struct pqi_sas_phy *pqi_sas_phy)
 	memset(identify, 0, sizeof(*identify));
 	identify->sas_address = pqi_sas_port->sas_address;
 	identify->device_type = SAS_END_DEVICE;
-	identify->initiator_port_protocols = SAS_PROTOCOL_STP;
-	identify->target_port_protocols = SAS_PROTOCOL_STP;
+	identify->initiator_port_protocols = SAS_PROTOCOL_ALL;
+	identify->target_port_protocols = SAS_PROTOCOL_ALL;
 	phy->minimum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
 	phy->maximum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
 	phy->minimum_linkrate = SAS_LINK_RATE_UNKNOWN;
@@ -94,13 +94,23 @@ static int pqi_sas_port_add_rphy(struct pqi_sas_port *pqi_sas_port,
 	identify->sas_address = pqi_sas_port->sas_address;
 	identify->phy_identifier = pqi_sas_port->device->phy_id;
 
-	if (pqi_sas_port->device &&
-		pqi_sas_port->device->is_expander_smp_device) {
-		identify->initiator_port_protocols = SAS_PROTOCOL_SMP;
-		identify->target_port_protocols = SAS_PROTOCOL_SMP;
-	} else {
-		identify->initiator_port_protocols = SAS_PROTOCOL_STP;
-		identify->target_port_protocols = SAS_PROTOCOL_STP;
+	identify->initiator_port_protocols = SAS_PROTOCOL_ALL;
+	identify->target_port_protocols = SAS_PROTOCOL_STP;
+
+	if (pqi_sas_port->device) {
+		switch (pqi_sas_port->device->device_type) {
+		case SA_DEVICE_TYPE_SAS:
+		case SA_DEVICE_TYPE_SES:
+		case SA_DEVICE_TYPE_NVME:
+			identify->target_port_protocols = SAS_PROTOCOL_SSP;
+			break;
+		case SA_DEVICE_TYPE_EXPANDER_SMP:
+			identify->target_port_protocols = SAS_PROTOCOL_SMP;
+			break;
+		case SA_DEVICE_TYPE_SATA:
+		default:
+			break;
+		}
 	}
 
 	return sas_rphy_add(rphy);

