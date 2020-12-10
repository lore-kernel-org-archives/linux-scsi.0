Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AF7C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A28523E25
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404455AbgLJUhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:37:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:55295 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404660AbgLJUhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632654; x=1639168654;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bLnVp0QamLrqNtK3ruUOoBbZI6LE/aaXlXCfnzZPe3Y=;
  b=iNmO+0lgrzTIgcvxQW2Nm8BlH1HxkZFC28uON6qtYsSqrqec1xl1iycG
   Sj07RCjrFbAEpegXfvnlR341l0wqlxPvog3uOpzyoWAVSATxE08w/UKDr
   aVltpqApq3xCzf07BXqjDAJu5uVHOJIdomyDCZDZ9V0D69p+lfgol8g+N
   KCBEGQLhcHBT0ZhUR+/QcRjkQsh7sQxfL1fzUdov9/ZwZlyeF/Nxe0s3O
   lyxWiKgeqmw5WPYpSZH5kamXmZtb2I0tSPON6m4l1jqru9ckXF2uXVRYd
   Eiw1HhIH/g/0i8XViRH6XMUdF4LygGLuuHOSl9awmZ2zJ8fjA/HMkbC/L
   A==;
IronPort-SDR: BvePX5Y+5oBuFygQRo/Yjie1A+m1ycyI1WtRILhosT2IueTOzbFeEh8sGRL6EjfJU+xrXH6eJe
 JO36E7CwbfJMyRZtkuVfkkTnnEgw1gUy4jjnEV33YNheHSXrF8Kxo69sFCn7cSuosz/vcwIfTL
 jgDS8y46cDlZh51Sex7UIu6Uc5rKfr9v3/SOAZVOKfbbL0RPOOQGXHDF7IGuEmlplCZEsILnKf
 3jJVCsYRdNGzdp7H3e75NnRNYF7/lNIWfLFxMYWuq5Lr2ZlyObJhy9/lCxrtoG/1loRs9QoGyS
 b98=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="36986807"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:35:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:35:54 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:35:53 -0700
Subject: [PATCH V3 16/25] smartpqi: convert snprintf to scnprintf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:35:53 -0600
Message-ID: <160763255345.26927.17474892658811246984.stgit@brunhilda>
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
index 4e088f47d95f..456ea8732312 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1750,7 +1750,7 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 	ssize_t count;
 	char buffer[PQI_DEV_INFO_BUFFER_LENGTH];
 
-	count = snprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
+	count = scnprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
 		"%d:%d:", ctrl_info->scsi_host->host_no, device->bus);
 
 	if (device->target_lun_valid)
@@ -6405,14 +6405,13 @@ static ssize_t pqi_firmware_version_show(struct device *dev,
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
@@ -6424,7 +6423,7 @@ static ssize_t pqi_serial_number_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
 }
 
 static ssize_t pqi_model_show(struct device *dev,
@@ -6436,7 +6435,7 @@ static ssize_t pqi_model_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
 }
 
 static ssize_t pqi_vendor_show(struct device *dev,
@@ -6448,7 +6447,7 @@ static ssize_t pqi_vendor_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
 }
 
 static ssize_t pqi_host_rescan_store(struct device *dev,
@@ -6642,7 +6641,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE,
+	return scnprintf(buffer, PAGE_SIZE,
 		"%02X%02X%02X%02X%02X%02X%02X%02X"
 		"%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
@@ -6675,7 +6674,7 @@ static ssize_t pqi_lunid_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
+	return scnprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
 }
 
 #define MAX_PATHS	8
@@ -6787,7 +6786,7 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
+	return scnprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
 }
 
 static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
@@ -6845,7 +6844,7 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
 }
 
 static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
@@ -6872,7 +6871,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
+	return scnprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
 }
 
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);

