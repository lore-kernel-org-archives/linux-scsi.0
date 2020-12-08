Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F32C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D89023B03
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgLHVQY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:16:24 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:52710 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgLHVQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:16:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607462184; x=1638998184;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y7+pBmuEvnH+XQCjqvFzRGxI3wOQmc/1Cb5tqqhd0lY=;
  b=hLkXxZdYEezLioN8bxNs6l54ZbWbgT9TV+l/8lDQZOUXISqHy7nm9/OQ
   +ZVtwge6rFxmWYyHrqMb2pfeHyHXo/+ej/vr9iv55uIjSLJb59Dp4RYgS
   fF5Q+QH66u0bw6CIlXmVe6NHt+dO4gZ5DO6IX+4CZZUETUUqWLTfQHW+L
   gs7bVJMjlAQOgtLnBIyowD1nQtCRNK87Gozs/02in4BGT5yySjTaWPpCO
   dDn/peLa904ZrwlRorrv3lzozPnIMCTEImphdZhFFWe71Ljz3h4xfbScv
   syaBCPvYkhKpm+2sAWoiQxQ1Px3u6SZeDqjnPZKIYXtmEGzUQoQz3NsqC
   Q==;
IronPort-SDR: Yz1cNK1nlh3SvFuTR0iTI3Qi3oVFNw8S6/6GaWdA5RFIFNpPxIKXLJVOpxrLA/ciXjKWMV5sF2
 wkpAmKk5RINZ332lKmxjUWxEy3hCHj5wI3QGu6Run7MnFE0Bsm0dVFxRFJgVLx8M/4DqUew0Xq
 wq53FsiQl11eahc7DyjSIwrNEUt+bapDK6+D+9CBmuV+7nQ3O8DnA1g59agLfNRKW/SsmmzJvD
 vc0MohYgWHCAzsnXlrwFr9O8rNZu8Tgmbz9J4I4Vw1qdhR9r/bahvPtLWgZLRyetv5pVIPWDVb
 byE=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="99080260"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:32 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:31 -0700
Subject: [PATCH V2 20/25] smartpqi: update sas initiator_port_protocols and
 target_port_protocols
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:31 -0600
Message-ID: <160745631149.13450.12706689258766997364.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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

