Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20665C11F69
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BDEE613C5
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240071AbhGNSbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:44 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36768 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287329; x=1657823329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KCeMB1351RaaFzihjYpmyZpKn1nIlXa9kenq/xuiRIQ=;
  b=RU3E/GaF7jouPSzsRG3qrUxIb9LwONZxZcQL+yHqJordnS0s0VwGVmfa
   25Y9pNAZ4/DvtIQmpaKBoy0Dimv8kmTv+d58SahSf87x36aGzmkH9nrq8
   qrfyiM76zLxVyvW4ZNR6DcfTIGaK/yQBXnt1hOJDNr0bjrciwEL+HUjmT
   scUEKKjHVR2kJTPjhLrX7Pj0im4PUIPT/UgQEobD8viIxysw45uBBUhrW
   pCzi2IwUm6u6Y+ke0H5k4xOZ5j9zS4p7+KWteEMRGuPj06o0EZb/eAarN
   n0tSHseTHJ0UsKHJf2QqjcCM/azUjUmmiaqALYRf5vOW2TFPpTYG4dl+y
   w==;
IronPort-SDR: R/UJecjkn+ryGiP98Qaz4qUHoSknoEIa2mP0pcc3S2CDIafx1DMsuvjZLvUbk9YZRnBP5Mg5y/
 j+EirzZNO/jlzIfdVAJ/gSyE/F66vE/qibhvw6U1UebyVJRNLcIVvfBIy/Kzr385ZKZHL6lD69
 siqS0cQJT6BnKBwO6rI80gHvmNThbrZs64S7jA1lkAvmnagUaBVH4/8B3uBzdRP3yknNtSBhix
 yVF6UwIdsZWHidXnQ52riIecE3KYWBUa0TLPyTL/LRhyTzG8Qu0KJGEGDC3whrFZVpRrySreyU
 TsY=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="124579308"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:48 -0700
Received: from AUSMBX2.microsemi.net (10.10.76.218) by AUSMBX1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 339DC70260E; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates V3 PATCH 2/9] smartpqi: update copyright notices
Date:   Wed, 14 Jul 2021 13:28:40 -0500
Message-ID: <20210714182847.50360-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
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
 drivers/scsi/smartpqi/Kconfig                  | 2 +-
 drivers/scsi/smartpqi/smartpqi.h               | 6 +++---
 drivers/scsi/smartpqi/smartpqi_init.c          | 4 ++--
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 4 ++--
 drivers/scsi/smartpqi/smartpqi_sis.c           | 4 ++--
 drivers/scsi/smartpqi/smartpqi_sis.h           | 4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index cb9e4e968b60..eac7baecf42f 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -1,7 +1,7 @@
 #
 # Kernel configuration file for the SMARTPQI
 #
-# Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
+# Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
 # Copyright (c) 2017-2018 Microsemi Corporation
 # Copyright (c) 2016 Microsemi Corporation
 # Copyright (c) 2016 PMC-Sierra, Inc.
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
index 64ea4650ca10..6ce17a191c0b 100644
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

