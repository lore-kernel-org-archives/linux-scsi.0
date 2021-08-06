Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BC6C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE1D60F38
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbhHFHnY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:24 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24090 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238682AbhHFHnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235785; x=1659771785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ULciBzNUpJiXKFe0vahoPorjWXdHAnS2iZV514wtpz4=;
  b=ZNpH8CtcQlfhEQJdB7U9pAbbze0NgqoIYYa0ucFPnusECFaa04XwsD5b
   XBg0oIbQsDR7TIpMvOS3NbN7NIdR4XOh9NkVLoQw2D3FZDV+UFyeXV50+
   f9YKTI2DutGSc/WpaEPpUGy6f0p/xoW5wwBgoouln58iyrM0QWLG8CiBq
   3EN28u1BPiqyyiv2rWN9SCrhLolyeM+RHzrzVYN11WukB9uznLzZebNUH
   9N6dEttgkNVv8BLUfMqN7Hcx0Rq4b8riTHwra+SFYYC1seUk8ckxehin0
   fVwsVIgXw1IMtHISQe6HLiwj9JVuKudSr6LpyNQDk7uGciU8PqA38WQWw
   A==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296859"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:43:05 +0800
IronPort-SDR: 5U5RSpC37v6GG4jBnW3jzm8W+Z8xTDK1z/dEfxr2dTWNGLcEm6XnSWcp+mAToRsbV4GmRPg2Tl
 B5zxCCl+aL+rpux4QgyBGbxGA2Ny0wO8FXANPORp9TWSwnDTsUvPcTcI133ObxqtVww0qd3C32
 Bc4XG19yTOJ46EVlYmbkbR0rm1f1QjNgxSNDhaCSsXnQiJTvgvYPw3YMuvM2WNPeSKGLtJ5cXf
 r60ml+WZ0WIPI4aGLth21A1hK4s6ZjuTOUM0tmKHXD9UZzDyWnMMEnQaItSbOJwE+xeqO6AeXi
 ejuDAYJ6sOdiPg1dgnBA73Y0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:33 -0700
IronPort-SDR: fvXXs3hdmWAYGyA46+5rxnvGSrN76aiG0t8zQuh3+HcNcOcbJ7cwlEodw5dz0MApduQQEPVLpa
 CjRTqY70bRrv0p+08djAKCIsaZ/aShZ3e+A/N+QBc9dZdqNlkk7rU04EI9bzzbdFVVUqSsm4LA
 aJHgmS0SFC8+WalAavIAmagvZTMlm5NRd5ECILaOA/L6gaVPmWVwte6IxrnV+CxtYJYHfLtu7Q
 pqsM/1v/txHVmaF7qxs8XufhnKv2gIL5SMLdSuv7D/aMT9AJvdc/uhm85/pfE9t7mLYgKkTx6D
 OhA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:43:04 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 7/9] libata: print feature list on device scan
Date:   Fri,  6 Aug 2021 16:42:50 +0900
Message-Id: <20210806074252.398482-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806074252.398482-1-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
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
index 3c213d125e95..cef6d516b4d8 100644
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

