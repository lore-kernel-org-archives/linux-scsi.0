Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D18BC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 305E660F9F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhHBJDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:03:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6558 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbhHBJCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894962; x=1659430962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f7WZKZcvvqTN7PtjxoPt6LREs35g8kRsrNmm7vSfhHM=;
  b=OyKp0A9AmUDrqLFwORoJhy6wWQDjAoHPeUTQ3rbYLFj/E+l5xboaL/ah
   RNty/1eh8BIsVMQLSNvFl5BM9GA8BbKSaKCH5BhxkLctBsYPx0codw97Q
   bhfKbx8cUuteVNGNUf0M95y1xvAo/WVW4FxBzOWp3PIR6giHxHU2HDHbd
   n4x6Uq52cCGqKrTS6+gt8NOfbsi8UWfua6So+Y1yuP8UpcApb5ArXXNtP
   UlnnRrugjhKtiiT+8X9fBRELledhGALYXVn0h/CJeCvDwh4c1bzKp9YGW
   lYXahgLaOBqF2d7OvBUpd5U4mE/ZrGJ9UA9PH7LX+by5Y2pHSFNfXQwHP
   w==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887623"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:39 +0800
IronPort-SDR: ukHWnnHN/VEWy1E6dP8Dy7/VUeJofaORJEI1sRJ3eRxNUU8ETtwNCbqPuJBytK9SN1/ts0kn8v
 0NXThDzxXGkhhBLGJV9FxLD00PwRTgWES76/BYkp/RuyNLBWG1Sdj/t2WC9FdqnDAo88GlABa3
 +YrgY72vd6rRELLXmR4yF7XntqPczfuwu/Wdww4zP3yIqazIyF7/c9DEYnmi6/9v0NlpKRSPE4
 Em/ZWMlY4m1i6T72EkjfoaE33cPLr9a6Nrv3Of6+90003b9o9iGIK0dx61fJXgb/Jnt+8iZJLt
 jlIYTB0XRxjdRgg8j/+78QFu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:16 -0700
IronPort-SDR: tGWIFYFfs5yhQm9H+hRYXPM5/PSjDZBZs1ZMuKtX+WsWTfq5wpXkOtCE1yB76ozyGDRHizleNi
 cPiiKmmWtULxQJa81lM02Hq2XB/RtMym2SYXWLJRR/OE0f7giYMnAYc/CfUF86pNWcwckYiir/
 kLeXKgTL6tVYlftpDD+Rp5VenjAUCW12vb/th3+eGiQizqxOuXDOF/lga6M7zCmAhjI8QqxU0d
 XkRCY99CeDTDtCl8H3Y0dwnEfKTEhEuwEqTT0sxksVoqeQmNz9tq/KILgQVHCpXr7vGsDqzEqA
 JHk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:41 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 5/7] libata: print feature list on device scan
Date:   Mon,  2 Aug 2021 18:02:30 +0900
Message-Id: <20210802090232.1166195-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802090232.1166195-1-damien.lemoal@wdc.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Print a list of features supported by a drive when it is configured in
ata_dev_configure() using the new function ata_dev_print_features().
The features printed are not already advertized and are: trusted
send-recev support, device attention support, device sleep support,
NCQ send-recv support and NCQ priority support.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 17 +++++++++++++++++
 include/linux/libata.h    |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 68ef43de0ed2..77118719e494 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2415,6 +2415,20 @@ static void ata_dev_config_devslp(struct ata_device *dev)
 	}
 }
 
+static void ata_dev_print_features(struct ata_device *dev)
+{
+	if (!(dev->flags & ATA_DFLAG_FEATURES_MASK))
+		return;
+
+	ata_dev_info(dev,
+		     "Features:%s%s%s%s%s\n",
+		     dev->flags & ATA_DFLAG_TRUSTED ? " Trust" : "",
+		     dev->flags & ATA_DFLAG_DA ? " Dev-Attention" : "",
+		     dev->flags & ATA_DFLAG_DEVSLP ? " Dev-Sleep" : "",
+		     dev->flags & ATA_DFLAG_NCQ_SEND_RECV ? " NCQ-sndrcv" : "",
+		     dev->flags & ATA_DFLAG_NCQ_PRIO ? " NCQ-prio" : "");
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2584,6 +2598,9 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_config_zac(dev);
 		ata_dev_config_trusted(dev);
 		dev->cdb_len = 32;
+
+		if (ata_msg_drv(ap) && print_info)
+			ata_dev_print_features(dev);
 	}
 
 	/* ATAPI-specific feature tests */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3fcd24236793..b23f28cfc8e0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -161,6 +161,10 @@ enum {
 	ATA_DFLAG_D_SENSE	= (1 << 29), /* Descriptor sense requested */
 	ATA_DFLAG_ZAC		= (1 << 30), /* ZAC device */
 
+	ATA_DFLAG_FEATURES_MASK	= ATA_DFLAG_TRUSTED | ATA_DFLAG_DA | \
+				  ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
+				  ATA_DFLAG_NCQ_PRIO,
+
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
 	ATA_DEV_ATA_UNSUP	= 2,	/* ATA device (unsupported) */
-- 
2.31.1

