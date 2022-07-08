Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AC0C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbiGHSqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbiGHSqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:46:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A844D4DC
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305983; x=1688841983;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SWlYYEdMbNC6dAJB0+WlXz8wtwHqRzyxIQA0S2veKRg=;
  b=gdKiABCVk73Iva7S/rKVSoE1CdTWkMtGyjagcUKE6LrjeUS0NLKxCPxl
   ZiHc+Qc9SDKnngWL4biT9ZIjhUsDjMGariME77qx4wUtoVYB+erSRKZLl
   2+rqjzTrt4seJ51MvZlLmSDjnRxAiFa0WodTxPLutP6S90vodcQXBofmQ
   tTMVg8LkQf9Qist+JUYpD89vOo3iBZj3ocGXSb5EVoCmFwDDK/rSwOgak
   RRgwYbQmdTBv6aF6x8pOXzM/qKP5eZeX1LWQKscmIbP7lTLPQtAtBf/4i
   JbmDkhjhdoFK498TK/cfVhJWHL/B3f9Dm+xBtUM6aA3Jn79MOcBbA2jKB
   g==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="103695540"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:46:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:45:53 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:45:53 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268Il08T177310;
        Fri, 8 Jul 2022 13:47:00 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Il0AA177309;
        Fri, 8 Jul 2022 13:47:00 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 03/16] smartpqi: add PCI-IDs for ramaxel controllers
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:47:00 -0500
Message-ID: <165730602045.177165.3720208650043407285.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Murthy Bhat <Murthy.Bhat@microchip.com>

Add the following controllers (values in hex):

                               VID  / DID  / SVID / SDID
                               ---- / ---- / ---- / ----
Ramaxel FBGF-RAD PM8204        9005 / 028F / 1CC4 / 0101
Ramaxel FBGF-RAD PM8222        9005 / 028F / 1CC4 / 0201

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 394583672b0d..b13233dbe46c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9746,6 +9746,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x0b45)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cc4, 0x0101)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cc4, 0x0201)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)

