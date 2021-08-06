Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A277C43216
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E00E601FD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245353AbhHFLML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47128 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245322AbhHFLMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248315; x=1659784315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vHcGZ73V/R4Q8ziXdS6jpoinqApQHXcoTZdx3/d+YEs=;
  b=HjRpYG1p8F2Wn/42Udz2+/ElOvUpn0xcZ61KqpWa6JBAubq9NyMMlVEj
   LUl9hwC0BOEarNbegjDYhHjD/CUT617bMnDEWHCO2OoJwhaYlEfxReVIK
   9V6KGY00txCNDOLooXVoXOSTJrRvyaMO/5C9mPOY9QtwmmqK+QDUhc5iI
   X/j9GEaTJcznjhhI/xT2vFUHLE6QuEqB6YIPXj22QX1iPcMQxmiZFYcEK
   eAy/S9BtOGMe/Y8/2GIuCc9MJ2g6wwSN3ONsInASBe2Hky8Oz3GfZtjZs
   G14T+M461W5/KOJepsl1rT6EvGIgmvyoRlUf/pVNZPvCAngwf/IazVfhQ
   w==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055551"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:11:54 +0800
IronPort-SDR: KpfjRcOrqq43grPMDFiIP2KwiqLRn8EZ3vS/QrTbOSUrMFm/nE0RGm1/p14YuUd2mvKRETYBQc
 3jLX7uULlnkRH+Xv42bDOHe/J+iD3I4eTgq6CtEwG3mkJWW5B3BXyIY0y4PTlqQxDn5vedxTNP
 f6RTQGOtGe6gdSCyZ6kpmvWPgqsS9jfZh9nqxT6W8akGuByFI7wgJ24NUgnxv5BbN9kBcpxtPw
 yoc4Q/NMUe+FdaSmyLQpl2AX58SPdvU02gc2FTVD9bmBhQaCLTlCw8m5UAcV/boHdDl6xX50oG
 hyqitb9pMQvFThNxW/3sHfi7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:29 -0700
IronPort-SDR: lgmijqd75EPJrzm/UMNTW4gdk/zPTfLNGCp5AOXSpXwIpKZq0wlhhWQQ7aw+LYA4MQvqNvmFJX
 UpSJZn40ENJ1uj2OkMr9gjz0MSL5fA3UTiRuzEygbBfvWrXNLpsHBH+a5TcsirRf0InAp0q2HA
 eEz+jl0j0uOBfBPbFjBjIZv3HuPb3eyoAReDkmS2oyOd7/I7GBBwRVfC4rek+LR0Ywnt/2GDNm
 RaZAmcvaYov93UXSuqDa1vK7430YjNYzbzm/QmsICQ/gGwKbd3/nOvMD5+XIFXyQW8zQLOqBMB
 xT8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:53 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 3/9] libata: cleanup device sleep capability detection
Date:   Fri,  6 Aug 2021 20:11:39 +0900
Message-Id: <20210806111145.445697-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
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

