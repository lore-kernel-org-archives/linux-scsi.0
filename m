Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4CAC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A5222D01
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgLDXDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:03:08 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:48973 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgLDXDH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122987; x=1638658987;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sXUcvXC/ZItNl9JW38wnQSR4IGVQomuEtqjH5+B5Iog=;
  b=m+BJvASZqzdAAq3f3JcYsL+dMTh/sd004ArftWdwgc84zmG/AYqMQkiz
   FArKEz9qBzV60YvuLmxCMAX6npuAq2+fpAfweyHvvzpxks8Ope5xFwCeW
   Fjfyf/KsNfmppD/z06bDbk2m3rtosy+B0nS4A3bgGV02G4UEeDfcIWSFU
   ZTDZUJsaZpbTil67PEZEzioLvikLY4xIG37adcgSXRUOZId/fMGXLEkUv
   g4a8700D5pIOB5FYywFdpVOaXprMkTsUQHcv2O+QXP7kdeEFAgW0tZb18
   m5IR9TBVGRMxKwoE6jI7DNRRBGare+jnO9lYUQva5gLKKjC9bXHHobz1h
   g==;
IronPort-SDR: o59hvk7e7adDJf2581LcyBwZKgnaXCpInG/jEMeYTG0XohSnVLnCMQg93lios/C9B7Mbx8dk+X
 vK6XR2CED9pW4DfiwOQXYW/LBqIma1JjVPAI3abBYLlKcI1aJCjhz9IAOEWIvf4jZXnyii5Wz/
 ffC3FTFnK/cehXljsOPw85ySCAtPziUARbvXmYBXtxmGyvwpxC8C8b/Am+7/w4qWPSKowxfDoL
 DMvte66Lq2iPkpp8LAoxf3LsH7FkAW5QU4oPZRvBiaJBzSnrJnaadPvFQNJxJv7WuayNMcccmq
 AJc=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="95934650"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:02:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:02:24 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:02:23 -0700
Subject: [PATCH 16/25] smartpqi: convert snprintf to scnprintf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:02:23 -0600
Message-ID: <160712294365.21372.18410124969166927118.stgit@brunhilda>
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

The entire Linux kernel has been slowly migrating from snprintf
to scnprintf, so we are doing our part. This article explains
the rationale for this change:
    https: //lwn.net/Articles/69419/

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a9856cc9a951..f96b8ce2edba 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1750,7 +1750,7 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 	ssize_t count;
 	char buffer[PQI_DEV_INFO_BUFFER_LENGTH];
 
-	count = snprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
+	count = scnprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
 		"%d:%d:", ctrl_info->scsi_host->host_no, device->bus);
 
 	if (device->target_lun_valid)
@@ -6336,14 +6336,13 @@ static ssize_t pqi_firmware_version_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->firmware_version);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->firmware_version);
 }
 
 static ssize_t pqi_driver_version_show(struct device *dev,
 	struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n",
-			DRIVER_VERSION BUILD_TIMESTAMP);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", DRIVER_VERSION BUILD_TIMESTAMP);
 }
 
 static ssize_t pqi_serial_number_show(struct device *dev,
@@ -6355,7 +6354,7 @@ static ssize_t pqi_serial_number_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
 }
 
 static ssize_t pqi_model_show(struct device *dev,
@@ -6367,7 +6366,7 @@ static ssize_t pqi_model_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
 }
 
 static ssize_t pqi_vendor_show(struct device *dev,
@@ -6379,7 +6378,7 @@ static ssize_t pqi_vendor_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
 }
 
 static ssize_t pqi_host_rescan_store(struct device *dev,
@@ -6573,7 +6572,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE,
+	return scnprintf(buffer, PAGE_SIZE,
 		"%02X%02X%02X%02X%02X%02X%02X%02X"
 		"%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
@@ -6606,7 +6605,7 @@ static ssize_t pqi_lunid_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
+	return scnprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
 }
 
 #define MAX_PATHS	8
@@ -6718,7 +6717,7 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
+	return scnprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
 }
 
 static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
@@ -6776,7 +6775,7 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
 }
 
 static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
@@ -6803,7 +6802,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
+	return scnprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
 }
 
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);

