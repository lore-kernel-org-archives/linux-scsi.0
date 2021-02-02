Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06310C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7758D64ED4
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhBBIbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:31:52 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:61803 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhBBIbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:31:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612255213; x=1643791213;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gyCwZHq1v+lKDMIZojckDSZqvBp22l96r/2T9aYBWGo=;
  b=Oxrnam8wNhyo4jApt7M3ah71kjtQu9WOBPOt2bUQ2GZ/sH5En8gfGEat
   lRPC16vnBAG5VZQqV7w4P5qZ+YEso6r1jlhBDTDFeQeqquinPUVCp1ZSh
   q8DrKvNrasNBNImc2taRfFRwSTEo4aEbBu1KleGNHUPHJ1zZUwVrHIKEw
   nVXC+fFddndHdF6GWVxkHf4XUzeTb9u4gcUdzxnvvXbiwCKgWjaDHSxQB
   syWU0jwKfaZLHTrIGmkT2Tx/gv7asRacbdUkOFvjYVSEewq60Vprhqbrk
   ja++FUfkEcpm7EsTkIapY19OTmhwhE9oS0Sjk5ZBJ0Qyaal6yCeCBH1e3
   A==;
IronPort-SDR: XOIYKLC5FigogSIMGcYwj9PeIM4NnOCCYN43ogFscwKYqA2TkhseKM+9utSAXKzy6VzD/oQ2ME
 z35qIQG2FCR7SaE4AF4EsqlL29fPV+3BMrXGTv1PoYOJpbMX2b90mWdrVfahJ/dK63CN5sHrAh
 90zJ6Dtcnclq+7r6gAVThk3KRn6+cmtjjJruH7c2ZrMJNwcxDNz2jo3t209dYvNKXhzbkWuYr0
 kqrZrO5G9DVH+d+1VVRO2lHBwnjVhbbmlUm731YbUvxCfewpte9ZbdEGQFbW5njh3ZiAffkAm/
 pC0=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="262976952"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:38:33 +0800
IronPort-SDR: hxiRJicvem0Hj3JMPJ1HoEbNROdYWcYmYw8kbzCldHMpayS6dr/bEvSInM8v1HsaYD+OrG55YS
 j5za5Jti6DRgBPWjS/VNf5riLGt9ta8k8TYJ7V09XTQsT7gmcK2oomp9b2bo8HLD5GcuFSKrfn
 OLV4B4E8sJjWyOghdJoIQb3TLt2AcXUC6QSttMsM8a7sGahea70dWDNomF7Wghq0CW79RsyX2M
 koU+UujbmiXqLXZP6qWESY8EdtYNhW+EZuUKKPtpGdhIpXjA1OtTHXpgGf4nmFRlSDeOlrwjra
 mLXnVAhAlUM+tuMymUihrJpV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:14:51 -0800
IronPort-SDR: NCcdU79cT8jUEwguT5PeUMP30wdlC/0cms/LNNm4R1TAlRM1+0Rv+gKIgQGtIvaaDItMrFIxam
 Vx5YlhCvFruRmBX5sMPB55vTVDvzG4DfsdDK82ql01MINUJkRSl+Z3LwFbuTypKAC9MUJar+5w
 +BW2lsJLKUoH5gdx2AJWIz2jvBjnDlAB6Vn/zVuL/zmSkJmpDJ+StyL6d5OaBTBNn+IgPgJtZa
 jgUqo7/vPkZwfkgHXYYC/dAehnzGHRhsV+yV+gLkdeiooXEnm9KpLHbf4DzlzVp/Rv09jE5YCF
 UUg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:30:39 -0800
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
Subject: [PATCH v2 2/9] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Tue,  2 Feb 2021 10:30:00 +0200
Message-Id: <20210202083007.104050-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In device control mode, the device may recommend the host to either
activate or inactivate a region, and the host should follow. Meaning
those are not actually recommendations, but more of instructions.

On the contrary, in host control mode, the recommendation protocol is
slightly changed:
a) The device may only recommend the host to update a subregion of an
   already-active region. And,
b) The device may *not* recommend to inactivate a region.

Furthermore, in host control mode, the host may choose not to follow any
of the device's recommendations. However, in case of a recommendation to
update an active and clean subregion, it is better to follow those
recommendation because otherwise the host has no other way to know that
some internal relocation took place.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 46f6a7104e7e..61de80a778a7 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -138,6 +138,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
+	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
@@ -199,6 +201,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
+{
+	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+}
+
 static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
 			  struct ufshpb_map_ctx *mctx, int pos, int *error)
 {
@@ -380,8 +387,12 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
+
 	WARN_ON(!srgn->mctx);
 	bitmap_zero(srgn->mctx->ppn_dirty, hpb->entries_per_srgn);
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
 	return 0;
 }
 
@@ -814,17 +825,39 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 	 */
 	spin_lock(&hpb->rsp_list_lock);
 	for (i = 0; i < rsp_field->active_rgn_cnt; i++) {
+		struct ufshpb_region *rgn;
+
 		rgn_idx =
 			be16_to_cpu(rsp_field->hpb_active_field[i].active_rgn);
 		srgn_idx =
 			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
 
+		rgn = hpb->rgn_tbl + rgn_idx;
+		if (hpb->is_hcm &&
+		    (rgn->rgn_state != HPB_RGN_ACTIVE || is_rgn_dirty(rgn))) {
+			/*
+			 * in host control mode, subregion activation
+			 * recommendations are only allowed to active regions.
+			 * Also, ignore recommendations for dirty regions - the
+			 * host will make decisions concerning those by himself
+			 */
+			continue;
+		}
+
 		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
 			"activate(%d) region %d - %d\n", i, rgn_idx, srgn_idx);
 		ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 		hpb->stats.rb_active_cnt++;
 	}
 
+	if (hpb->is_hcm) {
+		/*
+		 * in host control mode the device is not allowed to inactivate
+		 * regions
+		 */
+		goto out_unlock;
+	}
+
 	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
 		rgn_idx = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
 		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
@@ -832,6 +865,8 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_inactive_info(hpb, rgn_idx);
 		hpb->stats.rb_inactive_cnt++;
 	}
+
+out_unlock:
 	spin_unlock(&hpb->rsp_list_lock);
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index afeb6365daf8..5ec4023db74d 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -48,6 +48,11 @@ enum UFSHPB_MODE {
 	HPB_DEVICE_CONTROL,
 };
 
+enum HPB_RGN_FLAGS {
+	RGN_FLAG_UPDATE = 0,
+	RGN_FLAG_DIRTY,
+};
+
 enum UFSHPB_STATE {
 	HPB_PRESENT = 1,
 	HPB_SUSPEND,
@@ -109,6 +114,7 @@ struct ufshpb_region {
 
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
+	unsigned long rgn_flags;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
-- 
2.25.1

