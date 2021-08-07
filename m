Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DECC4320A
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC53611CA
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhHGET2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:28 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhHGETZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309947; x=1659845947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+GiROEWUnztuRRKjkVPOCEL0TaSeYA6z70ChZ/n54KI=;
  b=YFShRcW6yYt6w3aa1tju3Bw5GdU6d7/GILAGFgF7DuJO52CXJELyIQRp
   rLZgTzS+JVpSJYus/nucb5XsIo4hxz3b7nBVfeMz4hveXx1o3uS2kssil
   dXxOqOKi9lngIiua+tlDOnsf5QA5DSBUsQWUEB9gZZSqITgRKKB0mWgI5
   +FvRtRbqPgR+V2AIeXiT0eFneE8nXHBj4NvZSb9guLQopD2By3qIVxgtu
   a5hjm6YDf3t7EZiJZdtJixgN+j7Fv9dXyp5aV6Q3MbnQsnpZW9kscmQlY
   Uy+WLuXxgPE0K0FJ3HdtXs++9PwAP4Z72tBCPehA+jZSk0oFnE86Rssn7
   w==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363654"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:07 +0800
IronPort-SDR: V7lngx/M6I5zfV1XiEOO+UKaeD5cW2WsznXVsbmQKWP5SUxEUGau4iWBZwgi2NvPFRfH4kuvJ/
 ZK22QpycBCk/GI/ceT7lpHFox2hvYhzd5gojnSs5Qa3LwAwQPmSSgufsy4APb8dXy4q3bXXQqA
 mamdxriaRQDi6h/d1ggeNxWg1fVvYEgRYzV5OKXmHwNCRxhjGWfzPtUcSslknQJOQotw1Z7s79
 MoAZpFHOq2xxi8RnK2G1ApPjvkEzmsqZEqHHiLrRU0zXDrBYPbrPLrHuUMv77TN4Oh6/n1z1dO
 74/yquvDPS+JlKbc3B2McU+6
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:35 -0700
IronPort-SDR: 0JgNqRQCl1+9W6vmsNvsAQWLCSoxtdOERHkyiTYZJsF7J3DyhP12xSKbTzH/F6pvMYmwaF2ls9
 54tdt7rvrrx+qly+PenwuWs1GBaslDEeyheaIo+F8wLW1hJqBuJbU9445T6sWNlvcyisrhqj2Y
 h536am0kcSFQlVicr80rEcKArVLGSzIIx3fD3luECVELx/vzSrscdyy4G4R7q65W1rZjh+dpvZ
 HeYz+vf7uzEfO4ZteqWVQ0fI5PfLEL+UcaoViAMqsCyGv1f10mDvkB7Czn6SY1PDA8C21YyHAM
 mqM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:07 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 04/10] libata: cleanup device sleep capability detection
Date:   Sat,  7 Aug 2021 13:18:53 +0900
Message-Id: <20210807041859.579409-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the code to retrieve the device sleep capability and timings out of
ata_dev_configure() into the helper function ata_dev_config_devslp().
While at it, mark the device as supporting the device sleep capability
only if the sata settings page was retrieved successfully to ensure that
the timing information is correctly initialized.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 55 +++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 01cbf45f9d02..febf46b87a42 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2363,6 +2363,37 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_TRUSTED;
 }
 
+static void ata_dev_config_devslp(struct ata_device *dev)
+{
+	u8 *sata_setting = dev->link->ap->sector_buf;
+	unsigned int err_mask;
+	int i, j;
+
+	/*
+	 * Check device sleep capability. Get DevSlp timing variables
+	 * from SATA Settings page of Identify Device Data Log.
+	 */
+	if (!ata_id_has_devslp(dev->id))
+		return;
+
+	err_mask = ata_read_log_page(dev,
+				     ATA_LOG_IDENTIFY_DEVICE,
+				     ATA_LOG_SATA_SETTINGS,
+				     sata_setting, 1);
+	if (err_mask) {
+		ata_dev_dbg(dev,
+			    "failed to get SATA Settings Log, Emask 0x%x\n",
+			    err_mask);
+		return;
+	}
+
+	dev->flags |= ATA_DFLAG_DEVSLP;
+	for (i = 0; i < ATA_LOG_DEVSLP_SIZE; i++) {
+		j = ATA_LOG_DEVSLP_OFFSET + i;
+		dev->devslp_timing[i] = sata_setting[j];
+	}
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2565,29 +2596,7 @@ int ata_dev_configure(struct ata_device *dev)
 			}
 		}
 
-		/* Check and mark DevSlp capability. Get DevSlp timing variables
-		 * from SATA Settings page of Identify Device Data Log.
-		 */
-		if (ata_id_has_devslp(dev->id)) {
-			u8 *sata_setting = ap->sector_buf;
-			int i, j;
-
-			dev->flags |= ATA_DFLAG_DEVSLP;
-			err_mask = ata_read_log_page(dev,
-						     ATA_LOG_IDENTIFY_DEVICE,
-						     ATA_LOG_SATA_SETTINGS,
-						     sata_setting,
-						     1);
-			if (err_mask)
-				ata_dev_dbg(dev,
-					    "failed to get Identify Device Data, Emask 0x%x\n",
-					    err_mask);
-			else
-				for (i = 0; i < ATA_LOG_DEVSLP_SIZE; i++) {
-					j = ATA_LOG_DEVSLP_OFFSET + i;
-					dev->devslp_timing[i] = sata_setting[j];
-				}
-		}
+		ata_dev_config_devslp(dev);
 		ata_dev_config_sense_reporting(dev);
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
-- 
2.31.1

