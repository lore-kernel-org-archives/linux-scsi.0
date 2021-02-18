Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26053C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D41C364EB7
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhBRQ41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:56:27 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6374 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbhBRNYP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:24:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654654; x=1645190654;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jQxGAGS6CiCS/3erGLa+UPWM+FLQsPmPWWd5FPecgfw=;
  b=ZA45jntjAF/x1QDW8z/sM0zSTT3iDP6AN5YBlHEAq94FQgWp8dTn6Dxn
   oD1nh2cgFJKn5GV5pBlCZjQjtoDIFzGWv5iSutFjf4tkYnJXt0BC9OKnK
   n6iTuE7KsFOgA3EDiXgGV5Bn2+txKPMWqzTfe+2MyXghLUHkF9ZD2UvA1
   dvioxji6AxRt/e5JKGV34RkXetopfBNxELG0Lj+jE5MC5SxYOr2pF60Vo
   iMToNKVrRy5JgC3hTe99a0L0yrp8CazSQwwP3i3xJbB3UP8E52NNIwEfz
   dcs3cDL1LOSLa7HlTPLA8D1FHiynwm7Gm3Nw0YkVJWSrEQ0tbURcZao8R
   g==;
IronPort-SDR: ANy9W339HNTNs96y0TtfbQ+ufpYfsmIM67vSFzhomS/A6ND8B4yA9fraVudtLS33ogNIbhyxOx
 HlJEgOmMI/vr1xWDr2pFabNydBGvG7G0xIL74dBA6RdAeSOaC1kPVifeOTODJFdSWvof5M5H7B
 12nbMOmgj1rx3YZJjOXIxYXcwvqaj1+CT2udDXF+dsydO3KaeJfSg2vD5S0SU78YouQS+GaxxF
 Dfa9rpRSpyqPQM6AokoXd3/uHg3L9GJKSSB1NjUZmJ3WhgS/0QSUz2m86o1+vJV9NXcB7efiu+
 Qnc=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="160251031"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:21:36 +0800
IronPort-SDR: qkWw6kjvelhE8xRvRA3qux7RZnO/dOdL9pysK1jfKOOMqzwWvGHwRdpr/8R6p6NV1ybUZIbZmw
 5X58/KCUDhquTFV+Jzs+sjo9YHDS+b2CIJOtwZr0Lhv5R8Gxib5mN0whi/2QPkKN3Qh1lVKJ7V
 b/7kuxoYmyf+itGlOob+RnCwd1gYuYGPxd9EQSen5IXIPycV7HQFU71BZDnizCw/wX+jl69Tb3
 glslUc0jEr9GZBVYde9BtQSjz4jspAugUPUbOsrDAInDlqvSlLnvJDadSjzSdyYVXRkJgRI78m
 SOUTs+MmBqXB7ewGPQOzJH8U
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:03:16 -0800
IronPort-SDR: 9gk3oNBwxrwC1aTxMkidnL19PYe8Nvyqxlvt0goVERQH+fKSSNLuryORUqZRw+FHz0OqqWHhFL
 Vtb2C5V9BgqVUdro8cDexcUhbJDB/w2GCeuTTmPGbAQ4x0Z4Q2lDHM+y9ZM3sS1BrbpGAw4+Qe
 f1HkIQ0348RxlfsjsoA2COSu3LWyqaYpjNOtxBsUD1Bw7BKAiKRzm5vDiGyD/yDLT7OB+iBcq6
 XYtgRpnaRmgAmRj5oW6PruiPEoC5eY7OEijOHoKpa0ImMZrFzT3mudf+kg2goahUeWtPztLm63
 LJ0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:21:32 -0800
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
Subject: [PATCH v3 8/9] scsi: ufshpb: Add support for host control mode
Date:   Thu, 18 Feb 2021 15:19:31 +0200
Message-Id: <20210218131932.106997-9-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
index 9a1c525204f7..2c0f63a828ca 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2523,12 +2523,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	u32 max_hpb_sigle_cmd = 0;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
-		dev_err(hba->dev, "%s: host control mode is not supported.\n",
-			__func__);
-		hpb_dev_info->hpb_disabled = true;
-		return;
-	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
 	if (version != HPB_SUPPORT_VERSION) {
-- 
2.25.1

