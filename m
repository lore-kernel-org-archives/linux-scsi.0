Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2CDC3524A
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D730206D3
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="r8g9gdBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgBBHmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 02:42:13 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6569 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgBBHmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 02:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580629331; x=1612165331;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=b5vpGURk2FU4BR4h+azmFWcVTABZu/RmGJq2GqpVcf4=;
  b=r8g9gdBvqE7r4j7eYNTANagzW1dEir/u7YP4Um/7R8Vmn7631LHSFgWn
   5G9bFpnIUXBOPOVLjsMJvTU1K7CHomCbhfa/zTajf4Sh/swpoAMZPn+pq
   /xBKpxTv6OnVM9MYc07PwTIXoyYqmL1eu1bNpE4jjXmWTMlEqjGrBResM
   yvME+5VC10pS45Rqkjj9D/q7gfHAQCGVEpwTNa3zfvISZnsxrPeOr2ics
   or04BuHX6U5hyRuLR84ee9wegvR8cF8aJeKLPYE6djEbFN2iXuQF/GNCo
   QC1veYDT0gRgZsiy/DUm4HFX8kQqDp0chwDdujZYrTyl1N+xAoMH1h8dH
   A==;
IronPort-SDR: juxvMsncY6TzjujqmMW+0VcMoTmcRF4SvAky9m7jdd/TqzOhMYQaPC/tZh014/Bp8bW4n5SawE
 bZv8QPaBnnFBocogkBMqWeUh0nBARAMvsvjrcU7DbvVYheIcySvIfkBUHUXk54FEMDaAEtEynb
 aMY4RlHjXk0M6NLVK6H6ESRfRItyUXcZm4mo0nOd/XEYmpLy/BhgH7a3mxyJ3/pnocbLddgOry
 W7ShC1Nfmad0PgoiUpM65qgTziNZayLEhkcls8UDr8xnO6kMC26XptBGvNkNqho1ki8Oyt/1eu
 n9A=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="130383381"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 15:42:11 +0800
IronPort-SDR: 0qq/XOef7hjvsm2woabK44tycI2xn12x77Mq7d4RNFuehOkgL/Pm5rph9Jx/jAyOnrW6+qrAv+
 54Waj+c+8JeZz+SG+yamVN3yCKkRDRCRjmH9GslZZwAKQOYbhonblPomSKjBuO9r/Gxm+S/Stg
 Y33L7Kp/e4ByHId85rVFvFjjxbxEbk+7b31k7MmeUFKmxHrc2kfDMDn2HKuZ47MRuvC0JHYkJU
 0zZN7cTRpdvkBh9c1Q6yvPcrxQWjUuKYB5HA6shuacw/4CAuNOJHu+VJTM9OFQrSpLdNnGRCIw
 ezpPpkBazwu6a7PMLpUHznH1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 23:35:17 -0800
IronPort-SDR: nGpJs+ohfdqfADBNn7KA2aNQ+dVJm9zrDnay7hG//l9vc+6hVQwxLSUA7Wj5BLEJqh31QZoUXJ
 eFr50Ih+uCDCIvR6Ih4Z783HeMwDB67sTqPv3Qji67KnnuAAQj6yD7QXa1o5yWQIFg1rSzKzsM
 ujLFV4jkw4OdJXR3tSLt37kjVWDQwvkY19fKmCPTRnSAAnZKEDKv3D0/59PnmiAaYDoIY76psM
 4HBpywpQdFE++vmWB3MA9hWAz7v6yNeYE44DrDs2ljmqylwEjWT53T7U7He9dpGWTFR+zxdcl9
 skc=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Feb 2020 23:42:09 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Avi Shchislowski <avi.shchislowski@sandisk.com>,
        Uri Yanai <uri.yanai@wdc.com>
Subject: [PATCH 5/5] scsi: ufs: temperature atrributes add to ufs_sysfs
Date:   Sun,  2 Feb 2020 09:41:53 +0200
Message-Id: <1580629313-20078-6-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
References: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Avi Shchislowski <avi.shchislowski@sandisk.com>

Signed-off-by: Uri Yanai <uri.yanai@wdc.com>
Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index dbdf8b0..180f4db 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -667,6 +667,9 @@ static DEVICE_ATTR_RO(_name)
 UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
 UFS_ATTRIBUTE(psa_state, _PSA_STATE);
 UFS_ATTRIBUTE(psa_data_size, _PSA_DATA_SIZE);
+UFS_ATTRIBUTE(rough_temp, _ROUGH_TEMP);
+UFS_ATTRIBUTE(too_high_temp, _TOO_HIGH_TEMP);
+UFS_ATTRIBUTE(too_low_temp, _TOO_LOW_TEMP);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
@@ -685,6 +688,9 @@ static DEVICE_ATTR_RO(_name)
 	&dev_attr_ffu_status.attr,
 	&dev_attr_psa_state.attr,
 	&dev_attr_psa_data_size.attr,
+	&dev_attr_rough_temp.attr,
+	&dev_attr_too_high_temp.attr,
+	&dev_attr_too_low_temp.attr,
 	NULL,
 };
 
-- 
1.9.1

