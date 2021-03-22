Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B50C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0FD61969
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhCVIMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:37 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24342 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCVIMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400739; x=1647936739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l5Wlbz+Tqk+TXj/VrKYpXsakvrZWXVLA1q7rGMTFdvU=;
  b=btMJNwGKvitX+5XeljxeNR2lCZEob5RCzfXYMymtJNRdK+2AL2ZvJIWD
   R63aHB2+rCEWYUNVOnyCLfO+M7lOAJX9r0S5pXdZy1QvHREhwhF7mOXSm
   xb0VHm5GTLANwLLGGG47kgU2vS+XvGw+RYjqh849myKdkeucv2V/034OA
   6J1fQt10K2PT26A9YizhLCj+QeTIN5EMwsVcEidjbgbPGU6k7nMtZSc7s
   KqHaVxLdRBSbSsuRjcIwkCQgApBl7gU7sSxP29YCR7MpP6NLpAtMfxTNN
   aYhhEBvNkY7be1noMaGtc2o50xG7ekaDKa8+Kal73dUPC0LcwYGqf27T5
   Q==;
IronPort-SDR: sW7FMfSb/K0UgdC6oPPdDcg1XXYqCsZqgX1qkDk+xewdcWniis6rxPBOlubQYv3AyECm/ZdT3A
 dqT0HPdTuw/xdQGvEHL903w3xjhX9v8OcKNN8i4TH7qrVG9hYOZHO3YpTSUgwbayYX2zFd9Vo6
 Z6Ho9ywD9iz9+tLuz53276O8Pbn+hysfEhDJ2A9fi2jSgCuJGbOESxVfWUUJvKxhw+Ep1L5ZK6
 A66WJNXcRjOsWfKB0+HPH9ry6bsEnRhvbreWvX2hfzaSctd57T9Mp84/8Vtu7kORhqaBU8y7E0
 /WM=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="167165990"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:12:19 +0800
IronPort-SDR: uJMPFF1j8x+n3OEAAkEUJthgBIPFvR7LYXruP1CXzSU0zwX3bUWetBRwvGRAhp6lv0r6rMTL88
 07Nlga7ayv1FGoawgxRsG7SqJ1KYl9AVgzWijEmUPixTCx515XAcj+bqMENMgEb0ktFV59GIMP
 cnDqIBv3a6gWBZrReWoVa6QpZegNBI1FJ7TEpfWgmXdzuJ6Y9jNc7MXntS11Xk2b74sBchJ7+G
 hGu6twtz1lIKCaMlfI5JW0T7rHr5WrhFNXdAjv2CXowD3X5pxKkAAfDQmoX9Rv8WJiYqzHVjKF
 Dy3DNgkQPA2l89FFDGjcw1vg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:52:48 -0700
IronPort-SDR: JCnJpv3Sxa1W/lhpLCkNxkAQOxQJi0rSgg6vtwlZL00wBPZk8gd7fe8XCbTMYTo5ZV7zGB8kvY
 vJGqMfxhtEcqEFHR7Q8urJY8Rnm8JTIq0GlwDyjljKw5SbKnkLS+lsDeBeHOJknB4FP7j5uK6q
 6U3sJF0w9+ynAh3A6s11ld82Eovjgd7XPzozYsK2ZtT8BXzf7NUb3PSERZcg/Kr+OJSPv/hw//
 REiQZE7u9ENGfCregekWqGtqeWu2pNgVze7WDW7GMF8abuXYhrp5cb9tJkh+PyFds9xQsFoufX
 vS0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:12:15 -0700
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
Subject: [PATCH v6 09/10] scsi: ufshpb: Add support for host control mode
Date:   Mon, 22 Mar 2021 10:10:43 +0200
Message-Id: <20210322081044.62003-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
index f755f5a7775c..51c527c6f8c2 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2565,12 +2565,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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

