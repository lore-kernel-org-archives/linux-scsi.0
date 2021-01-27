Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C84EC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B437A20780
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhA0PQW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:16:22 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25658 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbhA0PP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760528; x=1643296528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C2n2qbZr6K8K8MlNh1JdDi0Gp2waOLViiNEO8MOhZ0s=;
  b=Uonukni7nqGl1uJYZqoYwV6v9MoOr07sS90UPToepsxOxi38oN2Y87nK
   TPKAvlM4iihAUVVwx/2OQsqs4wzLkpBGVxqLwzojoFVdZCh+t535TN+M2
   LGk/erislm+CdOD7FfAVp6aG68z8HaIBmuD2dFl//LTj5qm9CCwTkfT6K
   Yhy0f7b7AnSYkSPQmUEQzjvkD2rQ5EuA8OVckHL8m3JPMuba7Q2MWSfE7
   8lHNbNmdL3vp9TtA55GAyZTmi57BmhjU0fNJVAWMbswjEeb+jvF4IzJ+6
   +AF/0yUWkztzWsHCqHD9TiL2Gb7dUmHfnk1ald1AlTWX5efs6Qn1dLGBH
   g==;
IronPort-SDR: hwLWqOL9bWDVA/StNymDDFvmFEw64d47dpOrn1os+1A+p1SZeFX4NT7KBFTvbiOsSS9E690yE0
 J22QsvhYueHZVB4+NRZuC6POFFKgaQrZuJhaPIBz9HABhObDmrlQbfds+PvxGKzMkbG4iNjwcD
 wLYYG85nARvAz78bp2URatH+v/OsVO7j2JzM0atrbTRqOiMzB/dMaeWQ/nEC0G9/8jCqNcvNcC
 G4OJRY/7iLNsW2kbAPErqqWR0GLGf5kegno7loI+elgZ2dGi5GMbzRgOeEGRORBEUmbemTc6OR
 Mzk=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="159631247"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:13:45 +0800
IronPort-SDR: OGeUd8Ln1ZDER3s9Lv/aGn+y+1jPuceKcrY2Pi5U43bWaMSnYGO9XwoiVP9Vcp51VeaZ4NvU/J
 9iWkUafBYpJDCAKMAbX7nN6IfTQAkUGtsm0G87rEbxSiUS1CjYlNden3NPUEq2UGdCG7DK9y1z
 5c48ET/IP8pJiot/ricZ743l61l3rZlXv50eydYUbFkjRfPZdQrpW/B7Un78aMigckByUTHTpM
 ljfiRsDrM7hFSbuQOlOWbgQW+tFnMeaaq1qvhbV6lFtW7EgcUIuVBNyLsVqglpN7vyYaE7QkuN
 prl29T63d1W9PBt9+Do+rxvO
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:56:04 -0800
IronPort-SDR: o489SMbUEnyxQWr0H2UZf+VKLk5mCIyRERRszbtbajz3gCxfZiZ4cH/cCjfwtFRNsbcP6Mcbiu
 Kpk42Onft1VInu73GYHn42xhGdusAF0n5+6cCXDjHsZJCuoezJsoVmTvM/1GuIvTSumtCLMDTa
 a9YUvyKXXmmRn4v7OtqHn2OVbaJnYtpM4ppARefBzXv66x8AtME/IiaxQm7TEp6i1DsOxBBXlC
 eVjsDH5uBnOAu2EwxQ/SQvzR1ry4G1jBe8G04W2FbrGl2OMLBDb5WWxuSIsAdOeytLoWcQkn3p
 Tf4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:13:41 -0800
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
Subject: [PATCH 8/8] scsi: ufshpb: Add support for host control mode
Date:   Wed, 27 Jan 2021 17:12:17 +0200
Message-Id: <20210127151217.24760-9-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
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
index 482f01c3b3ee..3ea9f7079189 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2035,12 +2035,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	int version;
 
 	ufshpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (ufshpb_mode == HPB_HOST_CONTROL) {
-		dev_err(hba->dev, "%s: host control mode is not supported.\n",
-			__func__);
-		hpb_dev_info->hpb_disabled = true;
-		return;
-	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
 	if (version != HPB_SUPPORT_VERSION) {
-- 
2.25.1

