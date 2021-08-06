Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBEDC19F31
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C33F601FD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbhHFLMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:24 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47136 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbhHFLMP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248321; x=1659784321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pk+lhm8JBHwvIjXHR2WChMXDt5SKOnHmtBL2xd0eUh0=;
  b=P2DoOAXVWQ3FsqsDODX66Ho8kxaR5GqheDYbSvWrGB19auv0JB/dAOGc
   Xd7T4yHft+/N9ENKXILb62PlJ6O8OT2h/tDEniQYeTyVc1tJ4irT9vsUe
   YpYCWK4mCn25i786Wp1QvQSER0EKs+DyqpnGb6tonuka4KPxhETyGyIVJ
   tlgqDKQEPLql0w89ZgIsj2GyXCdIcD4yTNu/VXSgVsejYjmt2sgI6PBn5
   KHwMglYUSPRV1qSOGgAJZwu06VGQvvasgPXk6R72/U74dMa27+UZFr+Do
   vHwYAN2lOJZvNcWv+5W8oCRPctLoNAzhrOj4NnSc2zvTH8UR7kWLPpyHa
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055562"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:12:01 +0800
IronPort-SDR: aSvM1abw8ufBwtaElj6qhfJMxbjEJ3VkEtnkHvI8Bx8gD4TTw3jfjapd6V9CW8/LonMnPV3f/E
 ghJxbuyVa0WdHVMVT9Rsetm9O+/wNpeqrsV8lzuItaU7KdSGn1INDdmzZGse2iJMfC3a75emf2
 wrYVD4GFlDFbzgP8PwgOKMO/MKRUSWokT+iS2K6BjhpfjXTGPsnCc4RcpTSxcEva2SD/bQHlo6
 hKoW1ULIC9l6ov34UCCEDTg2f+OhnuUo2hDL906HkrCs6y0+vbcErwhRYL1+gSTl/isFRSHKK/
 FCBGrsRASZIding396bVV0cM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:36 -0700
IronPort-SDR: yhbEO0YFw9ohBBAnSkl3gZHdCyBirIv+Ci6aBCsN4SmFao1G5bIrrc3Jkg4ipRLihByQ/oVf8t
 0F0GKFp8Y6Izqm9I705o5APrqCjzl8Y11jSSz7vU9lmCEkllfDWE+l5/tPHeS+nzXHfukaOqsu
 C9OqWkNPVglW0ez9vnq99YQi5LL8LafiK/kagLvrMb6FXl8S1pQ34sd9acB3z6cusowM7e2hUs
 VnRXaZVWLO5XdbeUHGKRfHIPpsNfpF/rTNBHtYsTFpgSI4gkpwzGWUW3ILWEvQKqM8YAIlM97q
 3HY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:59 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 7/9] libata: print feature list on device scan
Date:   Fri,  6 Aug 2021 20:11:43 +0900
Message-Id: <20210806111145.445697-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
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
index e0ab03f59a8f..6d5d99ccbff3 100644
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

