Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B439C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9CD464EEF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhBBIe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:34:57 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48446 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbhBBIdC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:33:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612254781; x=1643790781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wJLgNlvZfXe0u3jCR9Ds9yEwJYxAb9hARdAQsEbFjuA=;
  b=EFZyUfUBXX6LuhT4D5boo1Gt/BRNfIFFMR/Z1anW9eDvdtX506uzw77B
   cP7pVVCJ9mkqqI3G8FRq1lmRI/KWQLDFE3DmvAn951krXvbewNzTHIuft
   DhUGgh3dA9a4wRXbFb/woHgMUUQUacIqc7LUDSlPV8D2nQGCYWy4rqf1r
   mjRkkA4Fc5uSQex1XS+C0RPr6ssBZkHLG7MlDjJUURPEiB1xptC5k76oD
   F2LkCspeKFrsTztH0uaSSaI57Xfx0bqXi2pRgaQPRcwEiLhCf8zbbQHKu
   sJnyEtW6TQpfUVFekPwmze1xHDkiV5pwqrvWLNJWtdkyEuJWUZfyuLnX8
   A==;
IronPort-SDR: CklQ9AetWWm5rBsuo61O8KiBOJXv5MLjHuxUcavuWb3ZAWZqVQO4lg6t6Vu3Z1JYOI96iIzAVi
 CUpk5M79rtlwmH655lKAsqFu/4V6eidYX6nq4XEYbn4It8Q4EJkqMcRcXJYBS/S5SEf5XiETFq
 VLfOEcV8jCdDtjec4Uvk8DX/a8f3u6iLftWCB99zSPo97VBGmqA7jRR21Rto0RvFn9T9UyzBBd
 4MvcabyjC0mxhnOgQ8WueMy7xpzQcBuE7F377eNbP4IuyhdKRwKwmQ2XpbxgvJ4EeWtG3RqCNT
 Q3o=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="163348407"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:31:48 +0800
IronPort-SDR: gk/RmlkrRFQJl+3CepBh90LAZRX9CYkjzHwCEi0w9MHTWwoPE9Ishv8dFZ1NdStH/Uo2o9lsli
 VS9j+Ia4xQp+xWyZIF3vv6Zb9+YUxXDq5VODVck5Zd75Xn1sg471pw2pS6qPCfHx+TxI5Jvl1C
 PFy/ErhHsD018nFHuHFA/RcqjTriBQvlfr69oLdHKVOfAqumH2HVrHrsNPXF4E1Oa+2m5//UnN
 dZHeNI77qhvtAnjKsZUcwLzkpsdZCi/aFpzGfx/cQ+Uxm8raC9u/u7WfR8zi0QaP1PzkR5eumg
 +OnxLnGwdCHKo6N7mNtLeYj7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:13:57 -0800
IronPort-SDR: T1F/TpBd996ndF1WfZyssGp7iGJaVrIup3w6zS8Vho+4UPTPTWav7nZnvuSSx4fj5ceWwMWzcB
 AHSB055crS865NloEIPHUEa4Z4t2TVFSrV9vvHX6yZkmom0VPCeRZIfbVIBMMXcOgy487eWxra
 Sr5Uoyu5zs6okzkkXlZyddZ23sVZduhqv32iI3iKlG/vPv/UWeMCZoNwjwj0a7rHtj0+XDZIOt
 ZGBr9iYd5gNjO0o/A9hCRj+a4Oys3YHALlK3vhebMGzLctUylL1WeEA1pehFLzcscKmTzoimFq
 sis=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:31:45 -0800
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
Subject: [PATCH v2 8/9] scsi: ufshpb: Add support for host control mode
Date:   Tue,  2 Feb 2021 10:30:06 +0200
Message-Id: <20210202083007.104050-9-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
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
index c61fda95e35a..cec6f641a103 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2050,12 +2050,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	int version;
 
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

