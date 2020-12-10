Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA55C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497CF23E26
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393828AbgLJUgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:36:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:60508 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393794AbgLJUgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:36:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632606; x=1639168606;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N9+QSnBJ2GPL4kcgRFEa8vIv5juD3AybqT7f5fNC1I8=;
  b=xNudHc/1iTEKys1J4qy0DmwtXzzMwogVCvsJRFPOowuZVT6tABtE1SCD
   vrDMaHCTn0q0ADFMSq6Gi1rS4Xqize3MAZH/kprmLZ1bdndHWNR9/vH18
   zqJoNZv4MTH+d7J8eszz4aWXyVRgCXSlAMJwN8tAkOBXDcWbtRPom25sQ
   UH8XHu6ytUg12SUYOh3hhuB4cr172lfVbZXGO5IJ3bEpmdBRQzhAkD7Oq
   Kru9n3VTgrR4gFdRs6B4l8ACzh9RL0Voj6J6S9yJAzvSsleCdE/ahpbE1
   SrR7+zTj5OQJRw8tpYJD4rVuJ+mblV6I5yalGLuRdD/wzhz1fgDqA8WpH
   Q==;
IronPort-SDR: ZctV5kBRcE0EVOexC79OarCMBP1imJXjTR7L5aWd1Cr6F6/60isfN0iFB8qfNGMMLqrUEzsBOO
 KFuc2m1mVy5yFvcmSnphdu6RK8ekOY+Ee45AnoQYbX8mk77fUDek7SWN4NhqqCIS0aX6xyAyni
 ztD1Z9ZuIM8Lb5Gjslmd/CLQuALGMz67S/wx7zWBHqviK3bjhiyDup8f3/w22ivqqbGmKL/8/9
 Bi8XyDQtkDv6YRjtk0FNaCqDqmA9T/7cS25oTev8aLcaaHIzh0CkmsC9eVVt13xR8OAO3fBo1s
 +sQ=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="96675011"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:35:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:30 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:30 -0700
Subject: [PATCH V3 12/25] smartpqi: enable support for NVMe encryption
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:30 -0600
Message-ID: <160763253019.26927.7831220182823562476.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
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
index 9a449bbc1898..19b8dc9ea6ad 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7573,6 +7573,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
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

