Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0ECDC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A795F23A7B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgLHUQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:16:05 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62626 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbgLHUPw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:15:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607458552; x=1638994552;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tuKWuOjiQtap3poLg4OIHYJq0fmTTfS/hQjweRYMREY=;
  b=FkrRGBeyAnZx2OUj+xGED4OP4XjzGtKlBiq3pTPX7VB5NN6/qr1P1R/l
   dvngNkpzmDEWFE5xxCTkEULc2D8ro8hFt9ta6nAPWUqXLv4IS29W8XjB8
   qT4GZBKE+Kn1bX8h3LPwtYGGMIBVeoCzOo6V2TL6idpGA7Iz9rdfGwhLH
   KvHyKkUXUfkavMm0D4UEpGdEC1xlc3CJZhbr8CG3Lz8BpWoGpC7u1bt7X
   D/JKQ6+ajVxYKX5a71PnX9PycbHhViLp39FFQAMd4NYMXidAtK3GJiusp
   387GaG5qH//MeyoBZxa1wJDHoCUWprqRMwdfiCYCsNmwvyXqfd6Te/hWb
   Q==;
IronPort-SDR: wo5ebu17VhkmrVY1A5HgHnHOmYLTc2/IExs1O8wJ+aIysGJ3NVE0pfMx2oEkVC8kjk/h/j8ZMs
 OZ8g26d5DcSu8hy+GFzNqx7RWJashZausJT5nu3rLUn732fpl4Xet3RIQoFvg+Tsb9mphlXRDh
 Ei24+uUVdBMga6OBQEmXr4UbwJitNMARkTWJvfS+E0LEsc0/fqKAwXIvGeV+PaF4ys4LiSZxVq
 7iH/hnc4uglYsmyzO91ABhozbWpD7emzxWdewEO1cm+1hr+YW1PKux98AquVLukaxIXLsrWDox
 WlY=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="106782286"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:38:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:38:08 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:38:08 -0700
Subject: [PATCH V2 16/25] smartpqi: convert snprintf to scnprintf
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:38:08 -0600
Message-ID: <160745628827.13450.14822580930036569973.stgit@brunhilda>
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
index b9c50411a4e2..cdeaeb162504 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1750,7 +1750,7 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 	ssize_t count;
 	char buffer[PQI_DEV_INFO_BUFFER_LENGTH];
 
-	count = snprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
+	count = scnprintf(buffer, PQI_DEV_INFO_BUFFER_LENGTH,
 		"%d:%d:", ctrl_info->scsi_host->host_no, device->bus);
 
 	if (device->target_lun_valid)
@@ -6399,14 +6399,13 @@ static ssize_t pqi_firmware_version_show(struct device *dev,
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
@@ -6418,7 +6417,7 @@ static ssize_t pqi_serial_number_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->serial_number);
 }
 
 static ssize_t pqi_model_show(struct device *dev,
@@ -6430,7 +6429,7 @@ static ssize_t pqi_model_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->model);
 }
 
 static ssize_t pqi_vendor_show(struct device *dev,
@@ -6442,7 +6441,7 @@ static ssize_t pqi_vendor_show(struct device *dev,
 	shost = class_to_shost(dev);
 	ctrl_info = shost_to_hba(shost);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", ctrl_info->vendor);
 }
 
 static ssize_t pqi_host_rescan_store(struct device *dev,
@@ -6636,7 +6635,7 @@ static ssize_t pqi_unique_id_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE,
+	return scnprintf(buffer, PAGE_SIZE,
 		"%02X%02X%02X%02X%02X%02X%02X%02X"
 		"%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		unique_id[0], unique_id[1], unique_id[2], unique_id[3],
@@ -6669,7 +6668,7 @@ static ssize_t pqi_lunid_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
+	return scnprintf(buffer, PAGE_SIZE, "0x%8phN\n", lunid);
 }
 
 #define MAX_PATHS	8
@@ -6781,7 +6780,7 @@ static ssize_t pqi_sas_address_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
+	return scnprintf(buffer, PAGE_SIZE, "0x%016llx\n", sas_address);
 }
 
 static ssize_t pqi_ssd_smart_path_enabled_show(struct device *dev,
@@ -6839,7 +6838,7 @@ static ssize_t pqi_raid_level_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
+	return scnprintf(buffer, PAGE_SIZE, "%s\n", raid_level);
 }
 
 static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
@@ -6866,7 +6865,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-	return snprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
+	return scnprintf(buffer, PAGE_SIZE, "0x%x\n", raid_bypass_cnt);
 }
 
 static DEVICE_ATTR(lunid, 0444, pqi_lunid_show, NULL);

