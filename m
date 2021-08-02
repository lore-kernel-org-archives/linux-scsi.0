Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01500C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8CC860F9F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhHBJDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:03:09 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6558 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhHBJCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894957; x=1659430957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1lJCZKzFplMb5NB2wZ+Qms6TSDfs/rcPRomXSgSO30Q=;
  b=BG4NuLSYZeodZBLs7wo/fmWwPz+BT3CeiJB0M4j30SfYMK7af0an91Bm
   l3zqBpgkNNOB32TkY/ikHON8DIzlYdoRrJdCq/mwBydL0knYZkB+3cudD
   x6+BCD5RCD4+ProeUtKqKKtmUJQXWq/T6eAFFHsfzFjcYqxrKfuuhJ39R
   v2jBF+CdYe0d8zJpWPOcJ2iPTBhb+prsstZjtkfBvOMRIcU6wmvVENZjB
   ezGqHiKgCtnjvj1+kd0tfGQoF4KZuUcTQvbakguhf8G+acfkUZ85c384c
   uaKZ0HJnN+zZWD4uFTkBhi1beq6WZVoNdAWO9mYbi1X29W5PUz1iAi/OH
   w==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887616"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:33 +0800
IronPort-SDR: LH3u78C9lsxkMuTlgbrnHoskOFTFCNSlcizlSVEIWjR8TRaJ97xHxpnU6jxSdxU3pPYlkyB8/3
 Uficg01+ILFW9en/vPgVaiOquWVl90d+7GIwHnJdzMngrjt64T2VKHH1ON34udiRJ7NT2tyTTz
 oX2nE+ju3wMpQxYeFPQcgfSpX1bk/Xc5AxXegaU6hpcMp0ZyT+fRKtiam2MILRjm347dNlihnT
 7Ia4YptOYEwFAlq1WIAtrIomV6B5YX9u0gT67IQjzmRHz8mymxmqbKyI2ixVpZzv4aQWrW+wWO
 i/uqjJ8tec8lFe9QNylhL+e3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:10 -0700
IronPort-SDR: cB91D50I+Uae0uto9At4gJmXxhv3HcX3NqPwi/nNr7PTsbErYOqqYqIumdguW3nSPMEdwgeEfl
 AH0HS/QRnOwl9dTZsME/T3Ozk+sMA3VHMTyCv1HIixgnWgFEIyt7x7ac+V+z2jdOJgDJ7SIZYJ
 p5KCGPlnHaTr79VcPAZ9MJLClJyQv/E89hKX6JAS1TNFtepBQldB2Ap9lhLQHLku1j73heVU/9
 8Iftpvx3I2iEIrNA2JNYMkpJp/WuIYPix6SL4U1e37ELHQh5I9XqTEzxzaOZ64KO8YDiX856Vl
 Ez0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:35 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 1/7] libata: cleanup device sleep capability detection
Date:   Mon,  2 Aug 2021 18:02:26 +0900
Message-Id: <20210802090232.1166195-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802090232.1166195-1-damien.lemoal@wdc.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
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
index 61c762961ca8..9b39a4e2e567 100644
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

