Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BBCC77B60
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346388AbjD1PiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346135AbjD1PiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16F41984
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696265; x=1714232265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UsZqljxeabf4R9q6N3sdhM30ZyWjLB7cW7LX8LOQvro=;
  b=rMPIiGDz+IjKAvrdPobOnn6Ppt1DnS32JdCSPlLVgCO9iP6KIKYJVkdn
   Ot1U/aFXaKjhCOGoKdOTtwBxaQmhPzaWNrO+huGUl0RdcwH9tBvLW/Iqc
   ObqIOUjktM0kfFX9/BGPpi5GcLgt1pEC0oiGNDQi6ZbB8gFKdQ6Gk1Zdh
   KYW2Lp5OLGqk1Cd/dfeWludgp/iFzef8dFvnMZ/rWrC3vQ7DNFUvbMFwm
   PVY9BWMHULolboSIvLlBYaWP1f6yEcw+ScRTeivN71eigE21PmZj1+lqy
   lfDSXgrF6IiQNL7BbdcKDAAM17Oy9vSZHkosfdPXMRB7YdacOmCn9rqV0
   A==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="211156470"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:36:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:36:58 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:36:57 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 03/12] smartpqi: remove null pointer check
Date:   Fri, 28 Apr 2023 10:37:03 -0500
Message-ID: <20230428153712.297638-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Remove an unnecessary check for a null pointer.
This unnecessary check was flagged by Coverity.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 .../scsi/smartpqi/smartpqi_sas_transport.c    | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 13e8c539010e..52dbe37364bf 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -92,25 +92,23 @@ static int pqi_sas_port_add_rphy(struct pqi_sas_port *pqi_sas_port,
 
 	identify = &rphy->identify;
 	identify->sas_address = pqi_sas_port->sas_address;
+	identify->phy_identifier = pqi_sas_port->device->phy_id;
 
 	identify->initiator_port_protocols = SAS_PROTOCOL_ALL;
 	identify->target_port_protocols = SAS_PROTOCOL_STP;
 
-	if (pqi_sas_port->device) {
-		identify->phy_identifier = pqi_sas_port->device->phy_id;
-		switch (pqi_sas_port->device->device_type) {
-		case SA_DEVICE_TYPE_SAS:
-		case SA_DEVICE_TYPE_SES:
-		case SA_DEVICE_TYPE_NVME:
-			identify->target_port_protocols = SAS_PROTOCOL_SSP;
-			break;
-		case SA_DEVICE_TYPE_EXPANDER_SMP:
-			identify->target_port_protocols = SAS_PROTOCOL_SMP;
-			break;
-		case SA_DEVICE_TYPE_SATA:
-		default:
-			break;
-		}
+	switch (pqi_sas_port->device->device_type) {
+	case SA_DEVICE_TYPE_SAS:
+	case SA_DEVICE_TYPE_SES:
+	case SA_DEVICE_TYPE_NVME:
+		identify->target_port_protocols = SAS_PROTOCOL_SSP;
+		break;
+	case SA_DEVICE_TYPE_EXPANDER_SMP:
+		identify->target_port_protocols = SAS_PROTOCOL_SMP;
+		break;
+	case SA_DEVICE_TYPE_SATA:
+	default:
+		break;
 	}
 
 	return sas_rphy_add(rphy);
-- 
2.40.1.375.g9ce9dea4e1

