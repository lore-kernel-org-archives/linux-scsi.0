Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B617C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F70C61351
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhFPLat (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:30:49 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17148 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhFPLar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842921; x=1655378921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N+UorW/M+tQ9BKtSt2SvsYx6FPcT/Bjw5KUFrbTxwXI=;
  b=TSwNXEzNfBmU/5lmYcWBB3y0gXbL0y359z8cZQMZPPymDgsynS0eetUd
   q5y2WdJ9+jnux9XeD2D4B6fblfZMYXucR0sxqJGjAjTYikqRPmGgZqaBL
   Z4SU91Um45anq62IllHBJMX7a8Bh+PeBuQqCtamhOV2gSSaVwQDefDi02
   SnuhmfKTnOX9AfesZdazhr2XuomT7ebgMBTROS33dphpo0uFcn36IwPDy
   Irdbf31Ok7bVFk88xlyQ3wVu8HCgoC+f4xcwQQ2MHY6GkXTF/KtBlF6aD
   Vev7ku2ea/1sLxo/QiLBSsvmER7RENd5WEhPMkrjeeH1GOt36BqHRSSFg
   g==;
IronPort-SDR: bB/4xpovxTZtcriVjBLOB3tenFBqQdLNmWeLzH9L+7dKpKLBXXz1H2lA+5pg5MQoo9ejLrw5T6
 S1stMr1/0Km4FMmdvV3z4uKHCuDJts1MduaT7nKof7v2gBczyR7iBDdWWWqhW4x0Yg5dd0zaQF
 olKDPXWXJ7Sg70bvyu0y2buVg6S5MZ1O8RMnQIEkjA/Tgto7RN4htVoYjnVzdk0vAiynel5EIW
 ybNi4/u84CJyJVOUKT8zm3t3Ic92z2R3JgIhwDgmwRrczXxNkjzyeU6jwVAZx0dNB13Ymiwp19
 49s=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="283553826"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:28:41 +0800
IronPort-SDR: gCtU1Xv82jyhqld4htIyMfHMuOGyYkmvp8Yl9lUdXj/nF+6/NIgPxwN6Kq2U1jPbHnBfWn1RmM
 DZpK6QbyFkgflKeLH3ZviR1qo6+4kRhKboW/hCr35MUeLdCUCo1BwZRphaxmxYC8DLTBhDJUmA
 Tzuq5IQiM+iVIssZpmqzlP2DJEY7RdbkGkYyWMJIaVRTrziY9R/fd2U4F7FTTAt9dxT4PcXXv8
 BiWkBPg9pJT9ew9/BmFe/ePJCmPSX2GuMk3+KFQdBLCwEBbun0PIX7w/1/zpOiOz0SpF7HZ+E7
 Ghp/jj/Z90fmE2CScQHyiS0r
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:06:09 -0700
IronPort-SDR: aRUZk5rD3fNbDYiSuvFlErv8VaNlAzujCEMzNrb/I8RfYRckLLEfLSlG++CCgYMrHKxIwCIGjH
 4bnutSSV/SNa50G5+TiwAcmwxXRXOELdgaESIjj7sWeYvGd8yOta1kfCAoye2vXqR33mnoK22c
 D3QpNI0pIAYl+27TkveT9+AgXI/8ApxISAod3Rgr/p0EQWjNXMwez8W/syA6r88Pm0XdencZg8
 Z43I4nbMTHfOGDIg7RMhuWB3io6f3KO+t0iiYTRAAaC2MLYEp3IjQemjOeKYIe9mfH4W+eP1pT
 OE4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:37 -0700
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
Subject: [PATCH v11 03/12] scsi: ufshpb: Transform set_dirty to iterate_rgn
Date:   Wed, 16 Jun 2021 14:27:51 +0300
Message-Id: <20210616112800.52963-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 3fd9fd5cb43e..7db553769717 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -145,13 +145,14 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
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
@@ -167,11 +168,14 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
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
@@ -591,10 +595,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	/* If command type is WRITE or DISCARD, set bitmap as drity */
 	if (ufshpb_is_write_or_discard(cmd)) {
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

