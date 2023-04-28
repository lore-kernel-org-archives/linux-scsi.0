Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFBFC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjD1Ph5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjD1Phs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:37:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DF8559D
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696248; x=1714232248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MMuzKRWqImG+2wNI5yo9Prq+Ly1D5t+cWzO9bCOb0Kc=;
  b=pajZezbHX1Q8mNZqh23w3AOlCZI01xIgohV0k0dqUbhGDLsmzLN3LJAm
   RWOa5omfCh1YWDKcjuFk8f7gky614FMppfYn1FkLzUsNhYGXWoKjCznXN
   52FIVM5WgxkchLpHogRQv3genpzWkpH5HZW+aXxIAdCUHnqdpdsiDYJr/
   PUsiwOJXRwZMggiNIp+FCNfLAgvXCLTwfHmYoTCTveycKuZw8AtFR8Msy
   EnCHz8xPaU7L2+LsfW4Cs1L/bqyXzvnH0xDc7p1bt2V0WayTbar+7KXDh
   cObMYNsla9+5hqtqiO0aId57qJuVWpt47RGyR5I04AMCxe3chxxo79JdZ
   g==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="208806408"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:37:01 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:37:00 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 05/12] smartpqi: Remove contention for raid_bypass_cnt
Date:   Fri, 28 Apr 2023 10:37:05 -0500
Message-ID: <20230428153712.297638-6-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

Reduce CPU contention when incrementing variable raid_bypass_cnt.

Remove the atomic operations for this variable by changing
the atomic to an unsigned int and replace atomic operations with
standard operations. The value is only checked that it is increasing
and accuracy is not required.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 228838eb3686..659a087a0e52 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1147,7 +1147,7 @@ struct pqi_scsi_dev {
 
 	struct pqi_stream_data stream_data[NUM_STREAMS_PER_LUN];
 	atomic_t scsi_cmds_outstanding[PQI_MAX_LUNS_PER_DEVICE];
-	atomic_t raid_bypass_cnt;
+	unsigned int raid_bypass_cnt;
 };
 
 /* VPD inquiry pages */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3daad878bafa..7fe80bef1a15 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6052,7 +6052,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
-				atomic_inc(&device->raid_bypass_cnt);
+				device->raid_bypass_cnt++;
 			}
 		}
 		if (!raid_bypassed)
@@ -7288,7 +7288,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 	struct scsi_device *sdev;
 	struct pqi_scsi_dev *device;
 	unsigned long flags;
-	int raid_bypass_cnt;
+	unsigned int raid_bypass_cnt;
 
 	sdev = to_scsi_device(dev);
 	ctrl_info = shost_to_hba(sdev->host);
@@ -7304,7 +7304,7 @@ static ssize_t pqi_raid_bypass_cnt_show(struct device *dev,
 		return -ENODEV;
 	}
 
-	raid_bypass_cnt = atomic_read(&device->raid_bypass_cnt);
+	raid_bypass_cnt = device->raid_bypass_cnt;
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
-- 
2.40.1.375.g9ce9dea4e1

