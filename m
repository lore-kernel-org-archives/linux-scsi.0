Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2815BC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073E461132
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhEXLZ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:25:57 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25937 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhEXLZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855441; x=1653391441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qWReMlBu2pEz10hW6XZxbX0QXg7/bMn3wao9J0zFBXg=;
  b=q76xaTlpJuj8CFagYJYkSLzuqrk39QPiAPrXwq9Lffk13Eq9x6aJj6gw
   tdtjyxyw1u4kso2hr276pwvJSYSVNf9D3c6okJ8hloVuunKjaz2QLnCZk
   1W10RJe2hAo679yRZEs7Iq8sb4tkiHZt4p9dUVWV54uOaam1cglm3wqzH
   4gGZjPuDOJeJqu9R3RL5GGNAJvfBsiQster+7XtZsv6HTzrOwagGxxavF
   IYz0olI7/OBlX0kYouBC1x8hfaBWZz1G45YatoddgXyntbRsnDT8De9pO
   71q7Om0hCU7Ctb8FEUcOKrELBfFV3M1M2k1i2t6sRfiggdSE4YX8YtD1A
   g==;
IronPort-SDR: ZzLmolHE0y5zV8eMYZ25UTlJESVkLZuWi+SEW186avRKd0nq1nSWSUeHnPBRzXaot+GvPUrf9N
 Ogv1ipR6u6ZGe6j2NjmM+qEkvyqUDC2WvIVRgTHMXREwSTzK9v7Q0U2FFcbHd+YtoESKI6eHyb
 QsgI1z44UfPWsoI+8u8od6ZNn33qSVzH+h1yKrDV5Ci1V0EzIbuqjuy2DKKlNljB16UVjmwCEd
 M3meAY+k/Lf+Nxd2U8yfOVxnwHnpk2m5zNtLRpzo0H4/CZnc+jeH4DF82VNST/1PfNkSs868Ui
 GzM=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="280526068"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:24:01 +0800
IronPort-SDR: YdjGZdPdgSf7cFguNJvbFo80HILysLB+ATbaM3M9iOOwD19DG3LKpZu7DcbfgjQt61Lpl5YKkd
 IVldb1CKYM0UJ5RLN2YNiYg0HH1Y3lceFYKtUCh6zjrQA5Pru1Uc52WbJ7JUgTz5Gzw8jXZJoA
 +3wa8E0eU3ukLqesrX4PYe7gqGbb9IgXqeN+2l+6G5Jk9Zwenb4ty15Fp1a+gsoq0PasPx38V4
 Gtyaz5u+Ljf9XJsxe/7/ghxUCOWs++NTlwYaOI3k6oqcJchvq8mHY1p8rSZMVuIiElOlGqJZml
 pfhWev87no4XMzkwmP5viqbx
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:03:31 -0700
IronPort-SDR: 5EoQycSBlssjux3NqiqqvxE4o6WRLgYUCzH3z5m+/oUpfYXoZzW2IfIU269MxytWUX1vwlsttc
 9Sko7/og+oMP4Wgzg1ECw/phQstiMMGQIdq/eN3LilizG1wpXXr5LqwmLBivEeR4zfoDFhOatX
 kobqI0Adi8SenFc+93+It08zsWntc6weX/CBJfxN5sSvNPgTNCGsmWNFoFr9ku++ZC1q8G/ulq
 PmOK0kFAWFNlLkfiSw/SIjd1AvOrUT6WilWX8WkHHpcbTjIZ8olyMByTtH+WixN5QDbHNFJ2q1
 hsU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:23:57 -0700
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
Subject: [PATCH v9 11/12] scsi: ufshpb: Add support for host control mode
Date:   Mon, 24 May 2021 14:19:12 +0300
Message-Id: <20210524111913.61303-12-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support devices that report they are using host control mode.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 585515c560a4..f52942cbf3b3 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2583,12 +2583,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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

