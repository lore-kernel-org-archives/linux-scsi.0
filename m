Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A03EC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B13C619D3
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhCaHmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:42:16 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22972 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhCaHlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176511; x=1648712511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kw0n9qy43sV6k7GArTQnIOeZqCNtAeuHTWn+7jmRqIE=;
  b=WvjxCUIwGxRI1K/5TnQam3MyM1lVHf2xtgaw1CzXjWixMc4/5iNI2Rr1
   LG5EbY18jQbWygI/BbQes4fgk6GsKLuwQSIddbv69SP/PeN60WhOkE7l9
   ZJuFMVTHx8SCQQj/3jbniiOpMc7aUGqR84T4fjDML/ztOobqqlZGmkpcM
   P49fVO91XmmXeqsJPX9GKA8cXviQbSiywV8IZYEi8mrzwITZhkGnPBZSQ
   EDWN5kbFjgSCWoXjE5UJkW4bZ2eRDdK5x0twcjqNT6j1pz/KNH77hrlei
   9OUPTpa1kpHtgMlHDz5MIzagJrDbkyaecZ2df3XY80ydjcqnTWhDAceZ6
   w==;
IronPort-SDR: N2kqZbMRZpOAo1b4bwUfjNs/cD5PKhsWY67LdTvH8t+YWKyXIrfsAvSBnEVIbMTuty3W5Mh9/r
 QtA/ZqNhu1mYN16KVa48BKRChvD6cSHB/KSnmWqzPBqtAK6JWrQf8wrkug9oLwzS4PIb7HBQ/S
 mkNVeYexzTb8PrKZlovs4S/Z2ONT793XKCGQdZ9Bnq+EZZQC6DITEkMeWZJEYB4JACBrkULnlZ
 UgkGoK2lHH+kbtASJgZvNA60S69/GK27yJ4ePpugD0//MZWzAI9LfWfDM2XdoNgNOTKAiX7ijy
 tZo=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="267851382"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:41:35 +0800
IronPort-SDR: DZ6nUOQgKTEWlHZIY16t8W70nnX3Li34PKGI151R1kcnSrfjiBuAGO1grnrdfSs6Ny5g2hl72W
 w5rULhbVr44Rw2BXaAlG+s92NgBAgywVUG53y/IUXwm/xwnmbCpgoKBh+wLp3i2lb8f9zKoWOH
 cMcatVwepwAcEWiTR3yFRs8sm6BWNckRxBlGfELEgLhGrf+zuhrES9Gu7dfXShlAlhgWsOqJba
 5+kJm24s+NGFhXQ/REJ5tTORVrYElSUnA92eg2WNhR6mpbDBLJ86vmhVeeCtiYcOA1tR47JPFT
 xTFZ2ajydtYf72Mp/6njoJva
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:21:33 -0700
IronPort-SDR: snXp5J+M9D0iDvEYXWMLakipiRRIVXJMl14DJ+9QHcTK39TMGSvcUDSCE4lJ5Mu3lStMrvlazN
 qJEU3XlxbNGFUNt5hT2X7bl5sArnGtAPcya1BRfTofDTtECaFnCib89Zov2gJWf7S0bwQ02VDt
 WqK6uMDwDE+8aqS+xtYHVsg9NyFaY63HA9EBeBxCfeR3H/9EomC5Q3QGX8v8Skg+bGPws6wVGk
 WWE8cChDVJ+KY65JJQjccqAORMUzWlMHyn6SdWJ7kLODRnorHqMKan6r9VNxpVqJJl1E3PND7Y
 8W0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:41:17 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 10/11] scsi: ufshpb: Add support for host control mode
Date:   Wed, 31 Mar 2021 10:39:51 +0300
Message-Id: <20210331073952.102162-11-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support devices that report they are using host control mode.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index c07da481ff4e..08066bb6da65 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2582,12 +2582,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
-		dev_err(hba->dev, "%s: host control mode is not supported.\n",
-			__func__);
-		hpb_dev_info->hpb_disabled = true;
-		return;
-	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
 	if ((version != HPB_SUPPORT_VERSION) &&
-- 
2.25.1

