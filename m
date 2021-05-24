Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910D0C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8DD61132
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhEXLY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:24:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:55116 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhEXLY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855380; x=1653391380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/iSUc3xRkBe0Jmn+hxK86Y4EAfWDCXgC+AP6lA0Bkxo=;
  b=gQVv1W3wT5Osj92X4kPPzSfUrTn6ZrTkSXYQLM4a4D5l/yhtxcZy4fPe
   tfGqV7d0D73j4QsCwnJo9+WAMGQbels9fy6Ki64e9eTGpWI86QqxQ/8pv
   3sFj5z8VE4/aWbM+d567mQwqJCVc/Uj51QM2295VcoF+qk9X14xKE3Cvj
   vy0GjkUSq+DwllgLighQrhAAUysr9+HnxoPcyecOJHnnQ8fPDpcHXJ1Qm
   HJpOSZyEQ3wAYj7qgJyrHlj8aINKgiMXTXu/A5VnWdXTmTGjnp7BrGtkP
   Ecp7bkm1aTLOoxiCWK4sI/xUt7gJuG0qIXUHhkk1N9CX2HQsukkIOI4ZT
   g==;
IronPort-SDR: vpCMy7W0wOvV7p8Njjp507hIBo8U97XgV+g1ihWD5TW7WZz1gSyi7BxUyP3b4urhrQ9/Hbt67t
 AEIrugF7RYMFEqjFAogrwpod5QAeO6vX4+z6dySpOsDqJ1rWIQjck1eA5Vf+jJj9iBqu8K5ji/
 tpO7+OsNU+K9TGAX9gU5vT3uIXYbyubDqaW2JjYg6AZWNBrs87XcqUyPaSGHV2kKmtkkwAGJmY
 fJXhI9bUNxFBv4ZBHhP5LLfNykv314JppVrRTrrlxoGBDuLRdlhuCmV9zVrs2AF8sJrO0CGSVT
 tbk=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="169770928"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:22:59 +0800
IronPort-SDR: 17k0bIXx5WmDYuScAISqOloeS5gTycy6UGeXHjxE19QPhH7MyaE3uEIDrakwvbMMNuyUoLfpvv
 tllMWHB8JCH2Ms7tnazctbzeiD9IxO5Bo4GB4I8CDx7ydXvZEfCzHPleW6X/qGzQGQMbcCnhjc
 r6ZKb27k16YaczUGkHVTXwmV5ox1y3qk2ZBroVQOMdbwKB+ucP6I2rvlda7OgiMTSRISjoXJv5
 3a+NP0VBwXy9LcqGGtZZJ529D9SO9OLG89BkCWM4Cb9a4J0gXCpa5T5gFPE6iUplEUq9utywCm
 i+W4yTL3BLlXjYl4UuvSrQvA
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:02:28 -0700
IronPort-SDR: IgT9egXin3bQgG4i4CItxSbVv+/LHxVe/XhF64LJ9J3b/DnBtofe+f/XbpsfHaHgeoS9J5sx0z
 2fZ1CPYcjiTPo3n/Gmnn62qRR35uB6aqr11aY9fC/voIocJ5G+pWjYhtLaQVxmltZx10qXnFsc
 I+5a0J07vTvH9qb+18Kgsbf7KkWaP6xX5ZHaDlTCLAZg5e+lmr0GVyXukIYlLboEaj1yjaGtP2
 ClMv++REEbg0cbwAQ5pDC1f2rTRN9EjNCk6A5BnfYr2cl/fHYFS2Ds8QHnK5q7Uu31Utw5FEHI
 Ajk=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:22:55 -0700
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
Subject: [PATCH v9 03/12] scsi: ufshpb: Transform set_dirty to iterate_rgn
Date:   Mon, 24 May 2021 14:19:04 +0300
Message-Id: <20210524111913.61303-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
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
index a19732b5f8d3..0a50eae35549 100644
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
@@ -590,10 +594,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
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

