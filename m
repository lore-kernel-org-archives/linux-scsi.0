Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F03BC19F31
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348B961050
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbhHFHnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:19 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24071 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbhHFHnO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235778; x=1659771778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fl178F5dJP4MrjAB3i84z1UPjR8a6z38mtu0l91vz0c=;
  b=jq24dfZkOtgmCZOgMQKMa0Dx6WuyDuvuofwutpJjkWIx4Iqg4W2WRvK7
   NSWBaAgvANfJ7+yiOGyMB7f70nK3Wgb/9yIbWrysawK90Hwgo/JV7kFnI
   /uc+8V5HKr5BAiZ7Ln66S61BisG7ljRw0ILrH3D+4RKt0A44zrujVMRXf
   nW9C74oVAAJUhZ4aPW9aedDT7nl1F4rNDTS+BZSWkDYTF5J5P73ftyt6J
   4nxIbag6KZVVP3VWuP7YVTftQLUGq5G65J9ykRF6nS+7jS27RCO11aIKI
   Me6mhhQ+GVZIbBDJspMzpsZEhxH4LUBsPZ8bmzof2OIcPa2OVrZH1CktC
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296848"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:42:58 +0800
IronPort-SDR: Z0Utv644KZAARpXSPue5ziqrUh8p3y9VNUhtagJ8vQLunRa/RIt6J95ioKq26K1MXPTotcRing
 sWHt1gtkfQ9XT5kp6RKXYPRp4jGJPZQEUCKTkMO19+E7o5sYHI9nJb/opNNGZscNoTfDBu4r1u
 k+cWkL1bjkYqbmD0sqj2LKwywXzFGPP/qbrvSeru4eB3Hqv2knDNf0L++izCkXKRDSqCEh65g3
 psfCZxctSMMZh1c4p28oTs4birIdTnaC3xsRdYakcYSAGexqBKy7ixKxlS5SxPvMcIPcoNRhqH
 MuWAIcTwHR8Dls9rYZMP8I8U
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:27 -0700
IronPort-SDR: hxnQVcRG+RVxt5TNy2+i3atUir5L2heCClnd1puHSz63USDGYrCK4vWjAm2wZ5EvHMe/aQo/H0
 /ooqtwOfmek9Qx5KQv6NqMP5CbrYKYzco3yqRsSihlpE/ogioSaPaXUgsYeWIDLA4Gfh/dBt+D
 fAPKbhimRLvAeGC7G8e2BWcNGkWz32/bqe5qEXCU8L7n02FU5zhgX+kIsAtWn6dMpS9ROOEwtq
 bOJ5HQvpyy8RZmw6TYv/aTntEo1gqfZ6knFJrXisIQSTqrDMz57MNcNO6Jm6bR9doY7KDg5QXn
 jog=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:42:57 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 3/9] libata: cleanup device sleep capability detection
Date:   Fri,  6 Aug 2021 16:42:46 +0900
Message-Id: <20210806074252.398482-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806074252.398482-1-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
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
---
 drivers/ata/libata-core.c | 55 +++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fe49197caf99..b13194432e5a 100644
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

