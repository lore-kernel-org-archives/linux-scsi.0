Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A503BC07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87EE061152
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhGMVFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5638 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMVFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210164; x=1657746164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KCeMB1351RaaFzihjYpmyZpKn1nIlXa9kenq/xuiRIQ=;
  b=AwvvS/mRU6H7NFPIjctMvhN11mRtJOJxfTOmIJiG2BMaziDf0Eifq75P
   Rm9Nt5tKYkyzVi2j05Bz8cXsAidiMCzp12QC/7k7qbWU2+plebcLoIv9z
   5hVyY6znBux3ORurti42Y83AWu48JTSWoLTEGy1biwfxNINO8qCEBBieZ
   8qP3nI5hIZK0u296ewfmsnbp8fOgZYIJH7xiGvvyYVbix8Wj7jM4RqHjZ
   R+1lzOK9V5OrSiR3IC96kH6MfQN/WPt2H+t/SPkjaMEeTMJzyDJlK0o9B
   D6/ihv9gMtfaIbwSL+Jp57k3MpehFFYN+RhklEyDlrnXWAPwzrJfHUe66
   A==;
IronPort-SDR: DaLvutn5ou+r6oygKF1SV7AIboNxfxvRruGq8n9Un5pV8dYlW1YwibfBqcUTvaJxRNs32U5yhW
 gt7dSsJbFBnWN8LosbilerJ/cylQP99gBTlBj3AynyVR0J3vX1GBxMNcZRC4VNKwZRQnSyseSy
 AR77pNaLJJoMjX/VnwNE/rkflzEzf3Cn0hyqLPRVYT9sikoVjsjX1kOAoUceezpeuepBmCOqhh
 kKnSGzdZqWXOlLE621lPkNQR4Gv2CADL2OCjLh1l0ZPYxqM2GFAKM16ep4W8pVQyneWn7pxnZ4
 LOU=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="62103594"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:43 -0700
Received: from AUSMBX2.microsemi.net (10.10.76.218) by AUSMBX2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 6BD5570347F; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
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
Subject: [smartpqi updates V2 PATCH 2/9] smartpqi: update copyright notices
Date:   Tue, 13 Jul 2021 16:02:36 -0500
Message-ID: <20210713210243.40594-3-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210713210243.40594-1-don.brace@microchip.com>
References: <20210713210243.40594-1-don.brace@microchip.com>
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

