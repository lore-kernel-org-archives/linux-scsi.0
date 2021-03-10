Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D3DC43381
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA01664FBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhCJUDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:03:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26085 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbhCJUDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406586; x=1646942586;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S2Y8p5w1vXa9BM/27hL9JjdW+9BSv2mNP+3K+vms9Hk=;
  b=xkE9KUjnMD0HLYcbbGPT37nvdGcb5PMV/2jrSY7ix0e+6XMObAv3vjTH
   OlzdLPUW19KMEodE480QAGZwxWXwVlD2lW2b/VsZcsK2goKD7hQDZhhRu
   X52CHJxNTni5a7G418ON7cmpokhd/iJoksUBuKV+uUTMO+a96rxtVrWAG
   gDGeHypCHY3zCdC6xkjAL1CNu44BNG02l+Eb1ZbCNN6uZplS/iSQLC2cn
   3nUQRfJd1hS9/LdjyD+rDGIbyT5tAiuILc44QW0KnvZKd1Qypndss5cRK
   WZGdELfD3Y09KdDnoF4/07IVc62aWt1tHfu1OkLWAGrLY4UaipylGi7bc
   Q==;
IronPort-SDR: jAfyCy5/Sg3emuirmX4RMmfauNHiYYE5EZqYZeEIuXMFGZrfCtWWVZW9yY6ama6iuKzO4vwd0o
 GgAUjXqLD6Gq3Og64PChLoZr7rkWxMIWpTxRRe0WYdcTRDEmflz+MKBYJXHiT+Ig4bVf3yRT6t
 1KDzI5Rl9RdH8q+05wAYrxgL/wVJw77aklkJ0u+Bwg+UaS01c6oWEY6ExklcabIS42WMx7S7op
 FYjYc9poqibH5FTtxmYACROl2adCLjEFApZFl7w+uPc7d0+YaSHjboxNTGa6zJrma4GACd7Zn9
 28o=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="112731896"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:05 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:03:05 -0700
Subject: [PATCH V4 24/31] smartpqi: convert snprintf to scnprintf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:03:05 -0600
Message-ID: <161540658522.19430.10343074991023319331.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
index 94a70e26fae2..872b2b136e91 100644
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

