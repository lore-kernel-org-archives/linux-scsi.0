Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE7C432BE
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848F761050
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhHGETh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:37 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14410 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhHGETb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309953; x=1659845953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FeD81iqhRNdggxCMSF8P8CRy5kyAnolAxVz51kW9A6A=;
  b=REKA0avth1nKg54Jf4nfJoCQImXPwIArbCQ1juVJwo3qInvcP3owhBy1
   7q+ei3wsfMrFjCUiOGX4G+HPQ0yE762rEsPvP/JPkzOAmNYHxni+ugb5L
   kUs8+DLd7EEOIllG10rATy0bEVAE7gdguWkDzepHOhxKtYF83kLJcFHbR
   frBvzCI7jlnp+4IFjfWrxYrJu+NO/VIz+HVWitCU2n6hpMasHdIgnD2Ar
   8xA58nZsWAQznOy3MqP943KoRerF6T5/MNpH4vP8v5oRBoXpibQup+6RY
   jTcMsWaeWPXrXSGYA2kIt+Go7Z5WuYowRUTHd3DOMiQS2a13XzWJqwHEB
   A==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363686"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:13 +0800
IronPort-SDR: G9NUw5wwXoN0QACKkWdxfVi6RWouFU4QJJxnl5G5ZMXSaQTMpeGZWdJrh6p8PbLICP8ZIHX44G
 rGbhXwH8JJ4f4EZO2XBq4u1Y0e1LwKyar5jh0d0WctJw3YsN714TLtBPd7jSFvrGHt4YIn5sBX
 mu8N0d78zryWNZguQvgT0fEf9RBkeqzARKUxjRW6CUxkLbvoq+tQXrBoCb/YbGkUhypJieTyWe
 cCtrfRAvYDMLWb0FgSCqpapCRqqpcu0rwMOzDNdP+u0cpiVyRaGJzDp1OBbE1fUKOql+hBaazj
 oWeaW3xDcdIfVT5IECultRMy
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:41 -0700
IronPort-SDR: fg9SwwOnw2yr9s8/bujKhQHtTgmfy5eRffdQSG4P/D+zbMP28q4KLx0bYvigqpeyrBCJTkNryd
 8aMtk8RB1tK8EwH3g0k6NWcR361F4fN6xvUpD9TSI69BLP/hlqf3DJA4nccNRsg1LoJ1HHn/Rs
 l8aKgP5qa27uN+XqbFze3x6ffIlbt06Bkq9fUcu9a1+wzepgQGxaqI3AW3qGwt9NiDlRsYcJQV
 oJ2Auea9rrUitF0V4ty7IZ36J4NY9TZUZWhNTLpONi6S8x/ZHALgrzssIT/taLkiwnXoCSfD1A
 FG0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:13 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 08/10] libata: print feature list on device scan
Date:   Sat,  7 Aug 2021 13:18:57 +0900
Message-Id: <20210807041859.579409-9-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 17 +++++++++++++++++
 include/linux/libata.h    |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a148ce94b3f1..5281864467b7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2433,6 +2433,20 @@ static void ata_dev_config_devslp(struct ata_device *dev)
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
@@ -2595,6 +2609,9 @@ int ata_dev_configure(struct ata_device *dev)
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

