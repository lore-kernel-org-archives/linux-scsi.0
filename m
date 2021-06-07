Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731BFC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FFFA611AD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFGGSB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:18:01 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2423 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhFGGSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046571; x=1654582571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uCM6ztR68ONhBFMAqxH6M4v+IG6pYst0Aq+gii77JqU=;
  b=MwqlLs6HneA/h/MgKUSzZ044NaLiWievVitT+QXAruk4ll9B065c/qca
   Ac99tk2ScUwNAfm1N43yDtm0Ykdjt9L2GmNXf9kUlgNBMVhyqx1+FFQUW
   hxgjdtrBmVgO3UReFPlznnk1u1/zSuaJ5iz82u84uEPWlPa2Cy965h5Q2
   f9peNX8jOgYBlRZMD3/M4nv383DBm4Q61urHNnOFJ61IekjqYdK4pYWzT
   RJ7VnO0hq9YGqIhDVVfo7WqHivQuM5sQfOQJgp57zsqJ/flFO57khO3fo
   bpBGwnCXS92o1BtbxElSJWnGeQHEk0+WEfHWffCvhkLGL7CiERsdOhvlN
   w==;
IronPort-SDR: ZFRykyaBeIPK4myNKAc8ypIgH06q5FnLDc086AWZyPhfw1y82csm0YYuU86RaEWxijYQ2iWVaZ
 EWAVKhoHuxkpkGm6De4rs8EKSN0E/Qw6jmeTgVnG8bkqIfouDzuISugRFNZy4trGqbWgVa+aCD
 ifDJfXFaz0qiQaV9yOhzceYjynboHF6RGs/NXofjVVZ8gvVPwdgf6ncENCfFIVfH3d4jqMhLl7
 TmEiDX84HSoyr7llG+G4m7AZyEQkNI78jK+sDWrdnmN7wgE3Gt0aykFtKZII9HLMD+12cEQ4+F
 Y00=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="171530375"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:16:10 +0800
IronPort-SDR: g8WINktT4FtABmVnZ6u4ECdgYQvcSSSYmoa+6s6nGGTsxInAOqR8Ecjv+GgRcO15Ceg+B6dCqO
 G7KLZGm48JJNjGpRlqacsKuQgSL6GgJv+zUgx8T7eBh3mlSxTqYN7UZAblNhnjroHLp7QSiIwq
 YeFwDj8DOkEMC70lF9JBUbsxcGVHOjDeFLQsjaL9XA/tIU8fBRkiXbAqoEQlRRuzc28PVsZ+GL
 xM8EofcUwtpAmylA30ogVjDnLbUcyTE8YTRnZau/TBjS5pWr2W9JuaIEDPkVtihiGzwl7x+Szs
 jSXJ6yEUYcRhPcXFgAHpO+Ns
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:53:52 -0700
IronPort-SDR: OYmOalzL6EWpSLMfhD/iKqrre6Oy9nq2CAxrIAiqjNTvKqB8qger+s6maFJ8+sW74NpIGjPE2f
 pHx1p0WDAbtQigvj2ivXaeU73zRtlfnzorh3iIbzy+NpFSAUfmJnS3Y36QtnCWzIzW0zq78xPA
 gf3XBPJMjlJH7A5Go7c+aDhRwP90loJ2WKtMReNrCzZ3/JcCtjNrLm9F4N7xitas+TJs7jYzAc
 8nqhzB8RZZ1hoCAcaNPAS8OFadOuVfkj4X1d+7HhbQuCU/BKe5KS2xk+Qy4U0mlq2JFanWgAm3
 MGQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:16:06 -0700
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
Subject: [PATCH v10 11/12] scsi: ufshpb: Add support for host control mode
Date:   Mon,  7 Jun 2021 09:14:00 +0300
Message-Id: <20210607061401.58884-12-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index 98c107ca4a4e..53f94ad5e7a3 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2585,12 +2585,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
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

