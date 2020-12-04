Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB69C4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53CD322D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgLDXDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:49 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5079 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgLDXDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607123027; x=1638659027;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y7+pBmuEvnH+XQCjqvFzRGxI3wOQmc/1Cb5tqqhd0lY=;
  b=OWyG9hiiAnJdJqMZj9ilc/zbg/AcVpwCU44Eh3uMayHNkbtwYl1g1kh0
   THHAqBZLx6i7iiCZWHGjybYLFDfSTzPchiA1Y78GDIT+5EgzdxOirH+HJ
   H20CmTz8p4s3bA6sYVvorHa9ok1NavhzVNgDALPawtakOya9b8JQRbuSO
   wII5JVdypiJjqzum3SmtuNzGOnE/jLrYIh38tYcAZM8/byePwW09IGzby
   E3aCI2hlT9CYaaDbQP8z3WISCEDrHwCIu5/E89MMrqAXwMAhY/1vPP7ZH
   cQfDwsEGbp3cZWZ3bcrD/xcZkBi4KLtl91Rh8bKzNSl2yqmdEOTP6+dGG
   g==;
IronPort-SDR: /S6UVkD0WgrKcRzMaDssF6dmgPx6zGDBoF+nBsPG7VMS3/dnPeWGtFE3X5uEDB45DuoPQtJdHC
 +9fLFpafDVsaD5bNsN7MehvLR5lzvGye6bE7dUeCPnhZUO3po+i9izURVDjIZNpj6fRmMNKiWK
 2vV21TLrayyMN3qFxdptXyA+5O6xrONAs9Vy5XvYF48aKGHycaGtTipJM5QqtQf8iJcgZQKL96
 BFoWHIFxx8Z96MbltBdWs0FP5vGi+lY0JvbG6wSIgVQWNyj0q8cSR3S4E7ijydUfy86HGAMxiL
 y0Y=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="106273262"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:47 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:46 -0700
Subject: [PATCH 20/25] smartpqi: update sas initiator_port_protocols and
 target_port_protocols
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:46 -0600
Message-ID: <160712296680.21372.13023212315335549812.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
  * lsscsi now shows correct values.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
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

