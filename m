Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8408CC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D195610CD
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhGLJyX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:54:23 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11544 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbhGLJyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083494; x=1657619494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QdKOfzlJ2W+4aSAxJPGoEKB3+6FSSH1LQMJ40hFEuwE=;
  b=PwBgV/lyCbNme7uy/oI05+PwnXfHfqVAKtzi4865AXQ3/r+5B8nxH0uD
   l/VcolnRXUi8s3TrcBS7qqgBp/84rKGdhBRnkV/AaXiw+V+XGpF1o5Atg
   IpJYfjdC3hxP+yzHW2/zEqTfPvQcnCZ+x6XnLWomPlvRXuQ+rHkpQ8F1o
   vAvNkPXe0C6VGX8PkziyBj7r94L8p7Y/tMmb3kqqnwCYCzntFppZdmpJ6
   PZ9mKnKVwDIbq4Av6SjY2Y6IstZEUR/Jvwn/ri/OjwKPMyEPN1AN6juFO
   H5B2P+SPwEKZ5q14mbtljMv28Oep1+Lncku2rd8gll/Aui5qDJABPMYbu
   Q==;
IronPort-SDR: 3dxaf0HVewoNEuq4c9INg9bOjyM1WtFBf0icH9CBP88++2zdewOftAx9TimSv81MTfiNFEEDDk
 e+YkuqFcGN4Y76ES+rBap6u+726sTCVqt+5TuKZdauQTdaytUaFMc3/9wXR3ZNMhdXmsHF+IwZ
 MjxhHhKfZ/dOkkG7qF3dTJewGlzRk4Sn7ECLVcjKCbiaFxe1JmCerAYv+Fgmt+//hyFWfc346y
 jvGbgcOcIyCGCzMQ95ErBOvVJvrmknjR/YOqzxNaorDSjduDybDtVrtARgZi6atbRRfuPtpbw3
 j4Q=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="285877067"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:51:32 +0800
IronPort-SDR: EFThIQr+qE5KnFHuXIy8rO8hzgl8U0MMPVyTvl2s34oCuK2wL3HeOy1XJ+muJFy0XqqH5sMxhL
 hi5Nmp0UnGHNmafB3nWLKaVUX4pk6GD76XQUXqq4urdVUhDm+ZsCuamrWD221racx2hndptw1j
 KTmRGmDU5RFEH7TCPuY7P4Bf9d1tip+U4h+xbK+V+/fvPY/p1yXntbBmbOSbvlXervv9+hdwT6
 FHc56ZzCiiYKVnu2s6j+2bzayam4ueusuqnjfSrBislNyanIuWbxkdQICty+wPxeNIPVN6Pn6f
 eQQWPacXXzHzRfAtoZP+RTjf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:29:39 -0700
IronPort-SDR: sgU4EJtUw9ur+afh7mn1YtkqtEPEfDuSrvM80Vv6HiuhliOyyXJJRyRht14Jory3mI5N1vL+Sb
 Tis7eWp/H1DMs4zNXYsGV1KPTrR8UArc1pFzedLm19B6E4CpUKq3Aigifepi7f97xoatLrgsvz
 G0BSAtITK8CVExaObFw0i4+g/G868BV7dY2vZaUCIGEEZigoZMiqEz3QX1Vv1rQpj+vVvZ8N+G
 UB0QIjk5SsVmoENWqBXONQaTNYDOYRTpQzk21NhJEgvrUg3Crk9IfJN0Kr4NyDS3ZnC+IDefU1
 CRA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:51:28 -0700
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
Subject: [PATCH v12 03/12] scsi: ufshpb: Transform set_dirty to iterate_rgn
Date:   Mon, 12 Jul 2021 12:50:30 +0300
Message-Id: <20210712095039.8093-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
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
index 0ac0a4ec1e1f..3663f427dff6 100644
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

