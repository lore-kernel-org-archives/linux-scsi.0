Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBFEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73843619CD
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhCaHky (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:40:54 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8958 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbhCaHkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176424; x=1648712424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7iRmZ6lDmT0DuAwbtSSQFG2JaK3coj1MKyRKx0MmGM4=;
  b=LkMjBJeIbyWjhs/M5GT/Qeq068QsJSnaGXkw3+7kSsp3KgzyTVp9QZwp
   lI9pPy3MWO0ACyvajM7eEGvDKzZUQQJJpyZKVH69tqqcexO+4bC5vxYEr
   wdyaZj5wpjPNWVWFDwDRHbIMGCwi23ja/XzX9qJdlLk8h4mZsiRwa/+fv
   bFBie8Q+cKMCHbEEba8hTMo5FYQ4JE2jyMaBnsMjN3oL3OwpuPFkurkDP
   UDkuSJgbqcHGI2ILr0oo5/xRCTY6rfsDlhew4Y0kILelZaaVuM8IvMr84
   dmoZYjnDH8KpplCO040eQyh89INfe0eoVtIkqG6nQomlVqjwxcDR3KzRo
   Q==;
IronPort-SDR: 8D4FkL9hLlY/uEAP/SGVTH/27rtW/dIL2Zy659Dr3XT+i9FSwtGVdwMLvkqhc9vWh0uV7e7OnB
 vgrrQea4o8YOPpnezXeY4zLapwLcgG/mnPp2tMImKJhzR/Lcu1KsYZnBGtE1gSTvy/NwaDt/ZW
 YaCS33mfxMQIMzwr5/OSrTYmVqGR3SlqMFsA2hqqBu9lAs31/RqpASniEOiqvsYjyCBihmMID2
 rBn64AtP7/g19X1tqNJNxQFx80B20U1W1AGfWMmgnqqVSpfNhXk1yn7Y5XLLzMVDAY+n42r5t5
 skc=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="274239158"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:40:24 +0800
IronPort-SDR: 1BjP+mZm+WQ6X3k/csSx1rA3AE3I/If3BirxVp2dPPMKGpbWrpabw/BA9wTOsUvw4HOz/8X46l
 RedVCd+f9HsxTezuv1kpOwk5fcBjHcm051cv1C0MXMLl+WFzzVhd3r+Ko4rz4uHQ4RP8AIS0NJ
 L3CUa0TxyMF1m6MSxBPaf2nVGj+17qiuZB8ti9Y8LhNfm8YU+1N+A0v5DXkcEk9V3SvCtf6/z6
 TYfnVHIsaGlNpK1jdHMd8uwEn5/PQzdFKbZY76Gn/iMllF1zq+1+ap3sCLx58fH1F46DNuOI8e
 59Y+ZETly5GUDuPM5rEFosA2
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:22:08 -0700
IronPort-SDR: HE+xdy8UuGKKBF3d+vUEpztOtVJyKdvR0AvHtHHuksoWttmy6AfJ2c2fyukHjtuX4P11O8VFs8
 pfGDDLOwidiRKFYtTFAFD1shI7GJ/87Y6NRGBccNb0xHsLtM6Z6tB1ok+PxGTQ6YJjRuGiFMqi
 MMA+Ll/sfhCl0jxwcg18nWsoroLUO/TSY+69FJslNHpm9TT9XqP8/ZHVrNUny9Ld6DYnslbafu
 jXSrYublOdwIVnlxLwOPTCk6Gj84kximwJO40zRsGpcXFym5L7vEkxJxCpkRHOCCZHUyVw/3RC
 Hdg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:40:20 -0700
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
Subject: [PATCH v7 03/11] scsi: ufshpb: Transform set_dirty to iterate_rgn
Date:   Wed, 31 Mar 2021 10:39:44 +0300
Message-Id: <20210331073952.102162-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Given a transfer length, set_dirty meticulously runs over all the
entries, across subregions and regions if needed. Currently its only use
is to mark dirty blocks, but soon HCM may profit from it as well, when
managing its read counters.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 6111019ca31a..252fcfb48862 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -144,13 +144,14 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
 	return true;
 }
 
-static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
-				 int srgn_idx, int srgn_offset, int cnt)
+static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
+			       int srgn_offset, int cnt, bool set_dirty)
 {
 	struct ufshpb_region *rgn;
 	struct ufshpb_subregion *srgn;
 	int set_bit_len;
 	int bitmap_len;
+	unsigned long flags;
 
 next_srgn:
 	rgn = hpb->rgn_tbl + rgn_idx;
@@ -166,11 +167,14 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
-	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+	if (set_dirty)
+		set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
 
-	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	if (set_dirty && rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
 
 	srgn_offset = 0;
 	if (++srgn_idx == hpb->srgns_per_rgn) {
@@ -592,10 +596,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	/* If command type is WRITE or DISCARD, set bitmap as drity */
 	if (ufshpb_is_write_or_discard_cmd(cmd)) {
-		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
-				 transfer_len);
-		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+		ufshpb_iterate_rgn(hpb, rgn_idx, srgn_idx, srgn_offset,
+				   transfer_len, true);
 		return 0;
 	}
 
-- 
2.25.1

