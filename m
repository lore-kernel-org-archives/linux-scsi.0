Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A078BC07E9B
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8762161C6D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhGFSTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:19:00 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6083 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595379; x=1657131379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V2chWj2/gMJdpAGu1YDTieYmQTYA83+VsJXUuMEEYoE=;
  b=uLQo8pTfl0dhiLuKaxKWa2Ia8w+kEqHhSefOfCulrUEEVFtQRpxCKWfN
   kH6SflnS5J3IA8gomauYh+uV1NUUULEbFYXnTkCkQmsM1qeOA2RDubNgT
   6X8ngvAAUY6GrvGBY7Drbp8Zu/w9iFzk5M9my4a709ktUMrzu4FT1giYT
   sqlFD5vbDUs18FY0+WaTcgivk6T9Z3RlyqUuyLz0ku7iK+Ol+/cR7jy7B
   wfAVGsd052b+KKEs+eNPD7d1YS9/kV3MIKbZ8ek6FRae/MVa0LPanWua9
   tRvPWk+Rp5W3gV8rdfDtcZgC+seHjLTzljmnFIw+uBrwC8ewu0gMik8s9
   w==;
IronPort-SDR: wijzAQ+iywefoz7tELKjLhc3B/DXFVWOdcAMkMmy/r/PeXvMQElq26N2tw1GF7iFhm2KgXla4F
 SAPhWq46KJ37dhcmnRyyR8DspufcgFpwFnWmLpETYuM/dimEknis/IOWCLqfauvKqz8jpdkqYG
 JSNG8A1BMJ27/1h7iBVDccQNeLwTrfu1OIaMUaSm7uBYE49gxteWjKv+dUzwChfUOklolJz5f0
 yGVMsyQr/LanfbXHCJ45xRQwDyBn021JitQhiXRGxbYdxptW8L0766R/nl1MAHy05B6oG0J4NP
 e44=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="127846827"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:19 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 6414C702572; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
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
Subject: [smartpqi updates  PATCH 3/9] smartpqi: update copyright notices
Date:   Tue, 6 Jul 2021 13:16:12 -0500
Message-ID: <20210706181618.27960-4-don.brace@microchip.com>
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

Updated copyright notices and company name strings to reflect
Microchip ownership.

Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h               |  6 +++---
 drivers/scsi/smartpqi/smartpqi_init.c          | 12 ++++++------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  4 ++--
 drivers/scsi/smartpqi/smartpqi_sis.c           |  4 ++--
 drivers/scsi/smartpqi/smartpqi_sis.h           |  4 ++--
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index d7dac5572274..f340afc011b5 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
+ *    driver for Microchip PQI-based storage controllers
+ *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
@@ -59,7 +59,7 @@ struct pqi_device_registers {
 /*
  * controller registers
  *
- * These are defined by the Microsemi implementation.
+ * These are defined by the Microchip implementation.
  *
  * Some registers (those named sis_*) are only used when in
  * legacy SIS mode before we transition the controller into
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7958316841a4..5ce1c41a758d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
+ *    driver for Microchip PQI-based storage controllers
+ *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
@@ -39,7 +39,7 @@
 #define DRIVER_RELEASE		8
 #define DRIVER_REVISION		45
 
-#define DRIVER_NAME		"Microsemi PQI Driver (v" \
+#define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
 #define DRIVER_NAME_SHORT	"smartpqi"
 
@@ -48,8 +48,8 @@
 #define PQI_POST_RESET_DELAY_SECS			5
 #define PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS	10
 
-MODULE_AUTHOR("Microsemi");
-MODULE_DESCRIPTION("Driver for Microsemi Smart Family Controller version "
+MODULE_AUTHOR("Microchip");
+MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 	DRIVER_VERSION);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
@@ -8448,7 +8448,7 @@ static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
 	if (id->driver_data)
 		ctrl_description = (char *)id->driver_data;
 	else
-		ctrl_description = "Microsemi Smart Family Controller";
+		ctrl_description = "Microchip Smart Family Controller";
 
 	dev_info(&pci_dev->dev, "%s found\n", ctrl_description);
 }
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index dd628cc87f78..afd9bafebd1d 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
+ *    driver for Microchip PQI-based storage controllers
+ *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index c954620628e0..d63c46a8e38b 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
+ *    driver for Microchip PQI-based storage controllers
+ *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 12cd2ab1aead..d29c1352a826 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
+ *    driver for Microchip PQI-based storage controllers
+ *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
-- 
2.28.0.rc1.9.ge7ae437ac1

