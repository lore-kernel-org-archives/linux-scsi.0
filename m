Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EDEC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 409BF611AD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFGGQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:16:34 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24848 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFGGQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046483; x=1654582483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kU7WBgg2cM0JHdF73dtNBxdvqY08/m7Ks0SLhflPAFY=;
  b=ogrUHWW/eXvSgI5JRR/TgK6TBJFB1dTnnW6u56T7+dzkzkuqSy/NOMcV
   LSO/wkvCQUGDQoTr+MUxastXhju42aLJAqrV0MOUJO9Bj2RJWgiYi68q8
   w2qZbz3n7j5T8ZjdBdCefZUtuguKeC/fD3NQCoBw9RIruKM4z80u9mCEu
   i31cZkCioLDF0zNIaVakrA0MFJkJtoz9NXL9rqBpkEs+pRcCfhyiGGfBB
   g7g2UF4eOV6vEadWnfrfhl2DPtvCNZY+BeiM6xHCQX1SBVMXLT3Sgyp4T
   HGdbqee00e1Jz63wNqmYWIco32E+9NkDeY/JAGTe7t7j99euVvnlo75rf
   Q==;
IronPort-SDR: 76/qI0u5ectsvMu715vcXUUMFeCAgcWSpvfG4mPz239GFe5IvIp75BEetScf76UOsA1s1Yuvos
 0y84ArPASMqVTT2NcymHGt2vKQIi/zs/YvpMPInCt3LXgIUMgmiye5wrwCTzN4ICCghXonyxmd
 Qy6v5eLfjrX1KUWVhnpZ3Uti7Js+5sRwkM7niawWtaEbNuyeDtioHTbBNJ32Wt8zGq1XzO+YU2
 4k06/GYxp/V+2fswMMRwMMyQ6snLhNPqlPFpgP/M5EFI66nubfluy9mhF+Scvz2PkaHPHGTzL+
 8XM=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="171530251"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:14:43 +0800
IronPort-SDR: KgO51tMf75kICpXxr7hU+I5K1aYvBWQlhf+bVJOaY5dkUsuhVP9pBvuI3bXVtPYzLiF+QYSRU/
 dwpm+D3JOTdQIehveOoxVJzUQ9iEzbh+syQy518DAgLrZqkXw/ifFnDK+hRsZ3R1boaHonFSge
 8E87j26RuVmd9OrQvI0P0gmrk6nn8It3zatn0xJyb5OPfal10UYyUY9+7xwlAinYywU/WpIoFg
 zVIcBIfZ3+vAQ4b5svGBM9nNZDRvt0OuVcAyQXTAnFXwvrehHwPwbz0StMasChB0ArrPOpQGup
 f5xxv/XVAyTImso4SbzHagMZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:53:50 -0700
IronPort-SDR: 8uxDMEJbslS2cLvcFTHZiZLM7lAug4VNwjcv9lMyqlzlzPfm7bpwgIDg4RmMxYtoXDx8CKzXgP
 118t8q6b46gIOzMnbiCpQ9CmMUWFrgTY8LfquIP45dDLrk9pkv/ejaQ0ANhsw85I8rQboawEox
 VoiMRDF3C6gxG+8pZtPokUTXXZFmvMFxcPyijE96R3HuQyhzI8KHftE82yu1QmanUQZTnKQa3/
 Lje4Qm0f3fdExezthuGGBcKC6kQX3YX2mc53CX7Nx7hOmvxCWKA9tnu5JNTbaa2ezOz7Q2ehwF
 5h8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:14:38 -0700
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
Subject: [PATCH v10 02/12] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Mon,  7 Jun 2021 09:13:51 +0300
Message-Id: <20210607061401.58884-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d45343a00e9f..6f2e3b3c9252 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -166,6 +166,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
+	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
@@ -235,6 +237,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
+{
+	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+}
+
 static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
 				     struct ufshpb_map_ctx *mctx, int pos,
 				     int len, __be64 *ppn_buf)
@@ -712,6 +719,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
 	u32 num_entries = hpb->entries_per_srgn;
 
 	if (!srgn->mctx) {
@@ -725,6 +733,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 		num_entries = hpb->last_srgn_entries;
 
 	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	return 0;
 }
 
@@ -1244,6 +1256,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		srgn_i =
 			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
 
+		rgn = hpb->rgn_tbl + rgn_i;
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
 			"activate(%d) region %d - %d\n", i, rgn_i, srgn_i);
 
@@ -1251,7 +1275,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
 		spin_unlock(&hpb->rsp_list_lock);
 
-		rgn = hpb->rgn_tbl + rgn_i;
 		srgn = rgn->srgn_tbl + srgn_i;
 
 		/* blocking HPB_READ */
@@ -1262,6 +1285,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_active_cnt++;
 	}
 
+	if (hpb->is_hcm) {
+		/*
+		 * in host control mode the device is not allowed to inactivate
+		 * regions
+		 */
+		goto out;
+	}
+
 	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
 		rgn_i = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
 		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1286,6 +1317,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_inactive_cnt++;
 	}
 
+out:
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
 		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 7df30340386a..032672114881 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -121,6 +121,8 @@ struct ufshpb_region {
 
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
+	unsigned long rgn_flags;
+#define RGN_FLAG_DIRTY 0
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
-- 
2.25.1

