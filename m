Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585BEC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286D822D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgLDXDB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:01 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:45863 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDXDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122980; x=1638658980;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hU1czVExCD3fXvIWcdqtP2z0QNdElvuzaH8DBzttLxE=;
  b=YH2RoqUV4kP6z2WVWW4NF0wMroIpn5qRH+vMC9uYCy6q+0UIEkAq35LB
   KcumsaKq+Xkrl0TWB+6mq/KVhVpvKxfrr2gfUkGF2+nESFuEiLQsbg9aV
   RQISvkVr6iNf5Ijc/kLm0LSeBnuk6ht6g7vpK9vV8q6Z6BdZmvnl8vzP3
   R6WWdABqfRnb0io/LtF0yRmAPA66CIRbI4N0/7HQok7d0O8j1UtLRFgm6
   bUoMdixG8bAiHPeUNXMvzz2c4otCRpLWU2R/Gc2HTuU894Okf0zsD0b2D
   h7h917nqfEujXP5LGrrU+u31FfNIQLXmDMWxnc6xXVn0M9MMlqKxLtc5C
   w==;
IronPort-SDR: vWuuS95NkFvclOLdCodR7YpZJRKUUKe09SiJxU30wR9dF6mNxiOvKGbWdtiJazhVhg3FAOPBNZ
 l7DNsA17Zo6n5IhJOavcPKveuMh6Hz655q0UX8aeBGKWnCpU70Iulcloc58uReTyic8Scgo27l
 xNuG8R6/NMPSVM39TAzlzeVagfyrRIXbzy9u2aIQOXw14zFgblc8jBbmqhDN9dbCXBzhcZl3rq
 dv6XrBYkmOtkfIwqfcz9cfoa3XhgnVZRNtQP4zPjCtxQLs1lGuFhSrs+8tvWmBKsHhvW4HW9ZH
 27M=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="98684130"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:01 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:00 -0700
Subject: [PATCH 12/25] smartpqi: enable support for NVMe encryption
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:00 -0600
Message-ID: <160712292038.21372.12259646828427195105.stgit@brunhilda>
In-Reply-To: <160712276179.21372.51526310810782843.stgit@brunhilda>
References: <160712276179.21372.51526310810782843.stgit@brunhilda>
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
index 9604e08e58cb..be2f177b3a21 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7504,6 +7504,11 @@ static struct pqi_firmware_feature pqi_firmware_features[] = {
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

