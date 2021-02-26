Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F45FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0847B64E20
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBZIhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:37:10 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11508 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhBZIgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:36:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328571; x=1645864571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5o1Joy+YObhraRwBiKgOJuCuzFTW6xDSF5NHVSdNyk0=;
  b=RFB424/GPzPGGoesrVnyB6Zp7NSJQbLdvCwTJ5jjb7qZjMKnQtzu70Ga
   RAL/uHfMUxJeyjAZ/VNnQL6WFF6boqu5jbjZ8aCfdcIhjrbp7iFGuSgFZ
   4IAWSTDiq2g0RhQC6fl7Y6iSs7b2iEvRqaa1+J/ztIOC7r58o8tJsh2jX
   4fGaRBpNW3w3/RXH/vH3tGmPccO9punFjnlJqyBhDpRoxcaDPGlc7eUa3
   Lj9GeF4RUCqUBKDlELTzoaxGLdzwSLhPqpGIVlr0Mqoe57ajS8YCxb/TU
   lP7SLTTkHNAN6ZPvyb96LMdtCL9CE/ADaSRtnb2szAvgurWmnVXgCUhWn
   A==;
IronPort-SDR: jGZvRZVlh8jTkihstFnH/R7WUN+odmMdhyfub6qmSlMf25PUCdS57I8NCy0d2UvjOOBHnvBK+I
 njN8dRNi9Al9IE1uJPI1Ih0q0AzwEAQG2Qkcj4GZQxCu6Uf6ZyhPuIGn5Vv0lJfTSJV5d6UweE
 Ls7JyhpzhdtyU/0s4KYWoYAT6ADMUaRn9S5LfR+M05y05F4ycX8J4IvKqA0I8EKX4+sYlgU1mk
 k1BEc6hFvZJFLdMtFsF1Mjud7BVmpVKRrzjmypUIXGsTD7TyqvsoXCVmRTnxt1hYq+pqyFZBdY
 1kU=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="271435340"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:35:02 +0800
IronPort-SDR: 2ddLZ/0RoRyDjxoNmwSsVJB/jzq/qkJGk+L+u6Bkgt7pVLZXuoC8mnH0znps0zjPLiPuNTtKOU
 mpjJqYTbnLjMxPBPlaRUTNlPom+4aXl30eGuBJmUsuhIeWBj2cWmcWSt+5I8kitQ5nNoheszPb
 /mB3hOkUR/dhqt2A0Li46ZhGKWly1GvsrkigHCuKTxA2kDv48rwqNR9SU7fFnEfNq0go9uEkRy
 cMSLwNwrlRi2IpJD0iecwx30efP3KYv/wZ560ngTMYpWyHCM6DHT+LF0Fy+92fi6k48pJ9rend
 2gSrVc1hIP2rohMcRRa6NDUG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:18:16 -0800
IronPort-SDR: H/OmzIMgJ2nT9kd5lxl+YH0xaxPmxpOI7e82RGj5U9U6AG7AiUuKPkrx/Qj0HjP/VQdmU7bkev
 sLRPH+KOKGHCJDf9kMicQFMwn/RORu64T4kuO5CEqLOrTt84GG4fnr22t4BRTE4ISDG688ndmb
 EXB08adlZRu0PkrpwIEPJMANgj2Fbpxw4R0ta+ciJLeem+kdIVfAzg+vxfl9umclzhtkdy/VWD
 pL5+C/kj2UJUfhmdAVlpkxU8PIlXAdq97oTCKG2d/GxZ3sYFLq9EtuXBL2vQcL/+JPlrh6EN5K
 ZGk=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:58 -0800
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
Subject: [PATCH v4 8/9] scsi: ufshpb: Add support for host control mode
Date:   Fri, 26 Feb 2021 10:32:59 +0200
Message-Id: <20210226083300.30934-9-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
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
index 5b76341fd558..86f4720f4f0d 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2573,12 +2573,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	u32 max_hpb_sigle_cmd = 0;
 
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

