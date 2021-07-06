Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCB8C07E9C
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0344961C7B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGFSTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:19:01 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47117 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595379; x=1657131379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Va5Tn4D1ElEIsTt42mitEm2Zc+DYV4qL4YotBj8gr5Q=;
  b=vC6RxBN3py7PLNgRUMnmGG4gbDYtUO/QICeAQmyr+QBb2MO6wzFmOh/c
   q3qBmJQs9O0Jojs0I5zJhBlTzmlIWYX9UpuUnUIUzID33mwe5GDyCIzJ+
   1BozkWNDFXpnD4B2WEcgcPkUmHaU5m0RUyZe/Mehn28I2hKY8HX2xF8Aq
   vKO1Q4q3Z2NHnlhxev93tM+IS56PwQo1WDIzOgS+cvGrLYkGPh0VD2CaJ
   dOlaY5ZpgETVp8U2XgVdVeYJHop1BGM1CjPvNGDmHYnluJ6kwXz71nBVI
   pb4E5JoJKCFGody5rpdTnWlB/lWFN747WngANPkak7AK/+kqHK67104oL
   Q==;
IronPort-SDR: WIblwKlWmPODgDevCcx7j2OBYr0gaBHioLmRXgFPvzM3iU07m9iYSZY+mO2Q3R4aMcETDDzWg2
 1Qrkm/+VOpHrvbIVMIZ601kRQaMKVDY8o9ykfy98CEF0nZzqbwEsiHChBI4hZMpc7UM5sqRCSa
 Ivd5AgFHCUKb/gIyaagXTs13SnbiKQyHS0TEkj3N91VJRM+AYgb9Q5lUzrViq8QCBvItAxIwsA
 78f3QOIDjNo7F+DDNhqBMvM9pC5zwtN6HPcX9n7xNV1TrwYGxotIN1mrXHXRchTopozRUkyuy4
 1pY=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="134786019"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:18 -0700
Received: from AUSMBX2.microsemi.net (10.10.76.218) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 5DC9D7024C2; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates  PATCH 2/9] smartpqi: rm unsupported controller features msgs
Date:   Tue, 6 Jul 2021 13:16:11 -0500
Message-ID: <20210706181618.27960-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Remove "Feature XYZ not supported by controller" messages.

During driver initialization, the driver examines the PQI Table Feature bits.
These bits are used by the controller to advertise features supported by the
controller. For any features not supported by the controller, the driver would
display a message in the form:
        "Feature XYZ not supported by controller"
Some of these "negative" messages were causing customer confusion.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d977c7b30d5c..7958316841a4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7255,11 +7255,8 @@ struct pqi_firmware_feature {
 static void pqi_firmware_feature_status(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_firmware_feature *firmware_feature)
 {
-	if (!firmware_feature->supported) {
-		dev_info(&ctrl_info->pci_dev->dev, "%s not supported by controller\n",
-			firmware_feature->feature_name);
+	if (!firmware_feature->supported)
 		return;
-	}
 
 	if (firmware_feature->enabled) {
 		dev_info(&ctrl_info->pci_dev->dev,
-- 
2.28.0.rc1.9.ge7ae437ac1

