Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376C8C3526A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 168E823A79
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgLHU1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:27:46 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25043 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgLHU1n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459263; x=1638995263;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d8NMbrg/61Fg/4mwQe+bCWIAvfCT5cykS6CGZRr1YKs=;
  b=UsHRotRfYar1IYzAs+xWphCNN5yU5m+MMFT1HRkUz8M+QW+S0NnOFoXR
   4yI1hVa3EbfvC6hc7RqEqpBkGgCEVO/GOHOKgYF90GQLcC1PqodKNYGCd
   727ZKiXAl3nfK/Jo9b0BfOoraVXfvxNi36V81MD8H2i/JqFY2BHVe3Z03
   EeCu7D+jfEYKeLajqNn5dIQspDQkGQypq3zn80QcNUwuzUFhMPjZxwEY1
   pHyEfpVHn2bP+YGa1ESxeB1E/+5QLkGLWD945URQmsEJEymHgAqAng0CA
   eJ5/rXygM3UHUsV6eoWzVl0CCvZNSwXzzAIc3cTXlEWpmqAWfhuPUFlD6
   A==;
IronPort-SDR: WYMdJoESc7e9XE0thU2ajYKTkCIhCdXOaok0LenBecThj8rtIF4j+oV1My9cP/Gjz3ADfb7RSl
 tYmGzTfTdq9T/X0yeP4iKzh5C1N7rTgK4iXKuEE6yoxdGB1yxX1j2jBUU9k9a/fHPlyA3hL7A0
 V/3bYol+5heAdB2XnF9bK2AxahJGopUjulahCrGkhp6oZHaT0XNnHM5AAVBrGWWjFMvcFesMTX
 ZqQVG931Qp1PB/2ioMFtE7qnhPQoPJRzDyehv93pflI5OLW1ewLfoCzRJ2lzHhdn5QPOCxEsMp
 GXw=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102012134"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:37:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:37:45 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:37:45 -0700
Subject: [PATCH V2 12/25] smartpqi: enable support for NVMe encryption
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:37:44 -0600
Message-ID: <160745626493.13450.14690046675780433121.stgit@brunhilda>
In-Reply-To: <160745609917.13450.11882890596851148601.stgit@brunhilda>
References: <160745609917.13450.11882890596851148601.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Support new FW feature bit that enables
  NVMe encryption.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    3 ++-
 drivers/scsi/smartpqi/smartpqi_init.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 343f06e44220..976bfd8c5192 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -849,7 +849,8 @@ struct pqi_config_table_firmware_features {
 #define PQI_FIRMWARE_FEATURE_UNIQUE_SATA_WWN			12
 #define PQI_FIRMWARE_FEATURE_RAID_IU_TIMEOUT			13
 #define PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT			14
-#define PQI_FIRMWARE_FEATURE_MAXIMUM				14
+#define PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME	15
+#define PQI_FIRMWARE_FEATURE_MAXIMUM				15
 
 struct pqi_config_table_debug {
 	struct pqi_config_table_section_header header;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c5ee93a60695..3b30067e79ce 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7567,6 +7567,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
 		.feature_bit = PQI_FIRMWARE_FEATURE_TMF_IU_TIMEOUT,
 		.feature_status = pqi_ctrl_update_feature_flags,
 	},
+	{
+		.feature_name = "RAID Bypass on encrypted logical volumes on NVMe",
+		.feature_bit = PQI_FIRMWARE_FEATURE_RAID_BYPASS_ON_ENCRYPTED_NVME,
+		.feature_status = pqi_firmware_feature_status,
+	},
 };
 
 static void pqi_process_firmware_features(

