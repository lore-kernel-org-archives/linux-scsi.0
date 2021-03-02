Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45709C43332
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFFD60232
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380698AbhCBSzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:55:14 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19117 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446201AbhCBN2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691734; x=1646227734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A8takycfQOXdn/3l4X9q25+hFq533U9bSyqrV2sSN/I=;
  b=r8XdGjfLmfRoxYuPLVIpkXY3KUCUqVdJzAf8ops7h2n2OGulo/2RPJFi
   Sum+PYe0iVIuwsX+FmMJypS94Rn0l2tPZVkk+qGkIunriAr063TgO3vYn
   vcEEWSN/zZ6uuN9UuuW/IlWyuBnW3QXi2a7vkuoR47NZVP1Fs/s810DOE
   Mvf4bR41wqrKLPjCUIaa9kP54aSxJ/pl5I6UhQb67dplcJsHUYn2gqXRW
   2FQ/Ttg50aKvbGz6LaPknuD/yn98GhF3HAe4gXvrROIjFGrHmiVwOeezd
   rVeZTgtw6zQNA0xfavcbWmz973ZkzT2+4edhi0sxtA8nJGhpwsQQOTw0B
   w==;
IronPort-SDR: lyHtkNbQxH1RhFTHkDO8qDmAPzIi8jfuUH+z/8cdv6923q89gmizjiDC4ANlxJjaGD3x2hqeTe
 77e7LIJiLfaOciGRsKFecX0b6TjEnb8NYJ5f1kDt5VPIexbhvuKqh9L56MjiU0AWkJXlQAXCzR
 kgOfU58IZj0skaaTGxFQ/7hqPJopo13HR7Os91xLKGCx+LwHd9ZNPj5DLd3lPll3FmYpYvt+BA
 s8oF9Za4AYGry+SNA0CAaXN/3FTKDdWdTK4GyE1M3d4qrW4CcYFuNJiEbeH6w4H/7M5sJS/j3s
 XOc=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="165637157"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:27:03 +0800
IronPort-SDR: rOy6vLtNSQMOq5HE831lyN0Yib17vy0VmUSa4w4zQxFVcQ6kvzX+luUq9Y5DvEL22UwpPjcoex
 9LdBmXXZwye++FZe8zMwa6NSDsABUcYDBBB10W2Io+n/7resP2KfJH4Gbcn7eJAb4Qt9nrzNs1
 ORgIkVj0TAbl9IYicY5z6UWcFV7z5tUtfcQ2LuYxrRCDJnDscUvxDnadir4enVmDAzwtflPRsW
 BMCupOiz9exMXwq9i7CQuTIMu8TpnGpEOnKrRVI1gdrfomRCMevcfbpJzFEgkGNJNtAsUvvOgz
 ofUDOfaROM79xcK30Wj1yNzX
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:10:09 -0800
IronPort-SDR: ispMW874JpmwJq6ZYQdLsdH027t/odzvH0KsqXd1QPfnGNAFqUo6lWvlYMve9Pn+TdtLAvNpbx
 FHhVEd10Qn+oi01nCVpkEI+MjgtVV2OIWxCJ2jTLLzM4cRCWtTykk6HWcP64YkCHo1/Yc/tz39
 9RlXgc1PAyHgvmN/osao3IIVTneX6aETm0di81PdhwJNIyI/5AzFwU14n98h2m4Lv0h7DaCBEz
 ALPz0f0jL8eN4EwNBwXwtC6xOCekNT7L5xxz9QW7Q/UgelNSUyjP+jXzkMs+10M/MLNtNWp8jC
 k3k=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:59 -0800
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
Subject: [PATCH v5 09/10] scsi: ufshpb: Add support for host control mode
Date:   Tue,  2 Mar 2021 15:25:02 +0200
Message-Id: <20210302132503.224670-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
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
index 74da69727340..7b749b95accb 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2567,12 +2567,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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

