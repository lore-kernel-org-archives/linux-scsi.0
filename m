Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998E0C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648F264F88
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKUR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:17:58 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49199 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhCKURY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493844; x=1647029844;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sItFnv8InDTCK+FrYZVZp96L4CvRZ3UGQD8p49XbwPA=;
  b=FHCpDhKUYmzAteIKDHX9wHVDNURVG4PeGWpKIDgLfiJP3EUIneEzXhab
   HTkZvioioT1Pqq5j8ykZjHRUVppYDO8O72Ah61jYUFuN4UR0Bcxh1avnW
   Cx4STG145MXgI0SV9BmN2qx0nYJSYbHtIAaVmsFQoVRM+U+YrHyIa6jTV
   NhU3OiJRvIm/tJ5Kh1sC10lNJ1pfi5fBcqZtI+E78FkizgmS6j4CCsgOZ
   K9/lXJyMhivuKpB1ATorrM7Fd/kn2ACaZqmrixOiNhh7+5U6ohHAXoHqM
   mIJCTx5v/cIeJAPopImzWBqA/iJg9DPJR2QRQqY/SKlGPs1NUbTnLgo/d
   A==;
IronPort-SDR: NJpg8DmUWMCzjaL79ZWxFnk5BvIDXp+KODj1Mrkgh1hCTwSU0GqmVVyAiOTKDY8QvaBMqhWpg4
 qitPxt/HzAg0efvxNGSo+iEk+5iHVsJE/kQVWvRNVX5dRPbAB9w8oBb+60yEGGy8wN9MUiViAu
 ET+zEpmFZ47KN95kP7kwr/8mfgYATZhKuR4CpPFm5NP+t14l6kRdontjdAa4KezgdrnSIe6f0b
 CtBgp/XQHoz19AajVk5wCi8wvARtFIq7eQhu9yN/pVYz+mkcAl+PD+IuzqiD6s2IGOqleFZuC1
 0KM=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="118559157"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:14 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:13 -0700
Subject: [PATCH V5 24/31] smartpqi: convert snprintf to scnprintf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:13 -0600
Message-ID: <161549383357.25025.12363435617789964291.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8b512f39f9d9..761d7ec6d2b2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1749,7 +1749,7 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 	ssize_t count;
 	char buffer[PQI_DEV_INFO_BUFFER_LENGTH];
 
-	count = snprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
+	count = scnprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
 		"%d:%d:", ctrl_info->scsi_host->host_no, device->bus);
 
 	if (device->target_lun_valid)
@@ -6382,14 +6382,13 @@ static ssize_t pqi_firmware_version_show(struct device *dev,
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
@@ -6401,7 +6400,7 @@ static ssize_t pqi_serial_number_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
 }
 
 static ssize_t pqi_model_show(struct device *dev,
@@ -6413,7 +6412,7 @@ static ssize_t pqi_model_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
 }
 
 static ssize_t pqi_vendor_show(struct device *dev,
@@ -6425,7 +6424,7 @@ static ssize_t pqi_vendor_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
 }
 
 static ssize_t pqi_host_rescan_store(struct device *dev,
@@ -6619,7 +6618,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE,
+	return scnprintf(buffer, PAGE_SIZE,
 		"%02X%02X%02X%02X%02X%02X%02X%02X"
 		"%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
@@ -6652,7 +6651,7 @@ static ssize_t pqi_lunid_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
+	return scnprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
 }
 
 #define MAX_PATHS	8
@@ -6764,7 +6763,7 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
+	return scnprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
 }
 
 static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
@@ -6822,7 +6821,7 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
 }
 
 static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
@@ -6849,7 +6848,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
+	return scnprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
 }
 
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);

