Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD30C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4479B6128B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhFPLa5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:30:57 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17157 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhFPLay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842928; x=1655378928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MH8AyvkrMMYDA/b/Jmo9KImTIqSvsagyK53VFCQe/uI=;
  b=CmqH+eacMqxA8SNA6nIR02Z5vBQJNTUTSH0CCqz8SwqTe+rwtFWXnGlo
   EmNMijMtSE0Z6JPSAgPupuFbjhvXpGtDzg4Wbe4mMOPkNeFleHoBrhMRc
   9dXg4LXQ9N0oho+E1TPi+tGr9fDoFdrLU0H8/l2BXOyW3CLOfc5Vo4pzq
   xiT60ikDpyKTD+5E021Sxtb2ss1nJH9FooOzl0l+qLuJx/hTzrYXVTwVH
   LGoLdDwuBoLdok1uGrLeb9q7PypcD7BtX/Ij4ksjhrDnb3Y/BPPBgmZzt
   jAPPobwNXHSpLRfHePa6YrTJdhjJGQ/ZVSICYDsvNGCPxTKkvTpsoPNo5
   Q==;
IronPort-SDR: +wzz6ZVvDou8thN3weo5ur/eZ1wGk/naaZ1gBiLOMapY4T5XDM+EO+gBiJuvDqOBBLH/nVq/vd
 NwfLcsY0VNZ1Pwso2SWhbiNDYRoPUsmG0m1PnvOAx0qXSUZNnGZ/3rEwSXVJwM6QdF/6chGR0V
 XvKBt1BoPg/4Uw+fCiWWjnLk0PDcvwScJcIR70s7Cgx+qZ/iD4pIgfx3Vlq4oOAmtZXATB+Evu
 ID4GOyMMdE5rIHW3QdAyNwbkSX+QWvKjXNpWnkqu6un4QIouRieZ5rCfPRcSnWoNLlOmEDSSkw
 dd8=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="283553844"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:28:48 +0800
IronPort-SDR: 46ZIyqb8133FHtEab3cE+4WyR/OELYjnErJnhqowlUN9MkPXlC4Z1FOq0zwKh4xC+VDwcshqFp
 DV6G1IlydFD1pFg1GTMugEiLgK1GoGu701YqDxsnju0Zv7qiSbgRet0YRroSbOuYHIDA3Gd/kz
 YccAYnmpot6uQxl7xg0ErwFWe0Jr71NIj6aRyeRX5ppSSR6GDcWWNeQKa2H4W82dUmmyN/SNmS
 NVCmGil4GHgXPf70qfNmD+Pq9nnZKAMG2y5dixTpTeLozLmPBKCcpu8nmBGr78kGAMDqOk5B++
 WY/6ZHR30EbXj4+PJ9e3ELLp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:07:38 -0700
IronPort-SDR: Xnb9Po5cWAdjHIYASxUfjTkirtDwSQuaSmAcpY/cVbSBm8UeX4tVnnMrHZWgKMWYqm6lYTaKgS
 GCDfchruXUQu5a5NYSfPSQxq1X1LPXYXKINQdORcg0U+85gJXTiQR1Q4vd2o+0/C6ZPnd/Zrh9
 5WNmxDLnK/PK/0z+i6oKQsXafJF0aVD7/E5qer4GzNtfMTQSTquk4KoeDzQqA19lvbsvKpOQpk
 6Of0tUYfd6SldsX/als1f2OutF/8nv4sVjHAECM4KDd4IwXXkhmNCXzpBpmJ7NNuuZ0LJ8trSw
 1yo=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:44 -0700
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
Subject: [PATCH v11 04/12] scsi: ufshpb: Add reads counter
Date:   Wed, 16 Jun 2021 14:27:52 +0300
Message-Id: <20210616112800.52963-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host control mode, reads are the major source of activation trials.
Keep track of those reads counters, for both active as well inactive
regions.

We reset the read counter upon write - we are only interested in "clean"
reads.

Keep those counters normalized, as we are using those reads as a
comparative score, to make various decisions.
If during consecutive normalizations an active region has exhaust its
reads - inactivate it.

while at it, protect the {active,inactive}_count stats by adding them
into the applicable handler.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 94 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  9 ++++
 2 files changed, 97 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 7db553769717..9e5e585e1a43 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -16,6 +16,8 @@
 #include "ufshpb.h"
 #include "../sd.h"
 
+#define ACTIVATION_THRESHOLD 8 /* 8 IOs */
+
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
 static mempool_t *ufshpb_mctx_pool;
@@ -26,6 +28,9 @@ static int tot_active_srgn_pages;
 
 static struct workqueue_struct *ufshpb_wq;
 
+static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
+				      int srgn_idx);
+
 bool ufshpb_is_allowed(struct ufs_hba *hba)
 {
 	return !(hba->ufshpb_dev.hpb_disabled);
@@ -149,7 +154,7 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 			       int srgn_offset, int cnt, bool set_dirty)
 {
 	struct ufshpb_region *rgn;
-	struct ufshpb_subregion *srgn;
+	struct ufshpb_subregion *srgn, *prev_srgn = NULL;
 	int set_bit_len;
 	int bitmap_len;
 	unsigned long flags;
@@ -168,15 +173,39 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 	else
 		set_bit_len = cnt;
 
-	if (set_dirty)
-		set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
-
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (set_dirty && rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
 	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
 
+	if (hpb->is_hcm && prev_srgn != srgn) {
+		bool activate = false;
+
+		spin_lock(&rgn->rgn_lock);
+		if (set_dirty) {
+			rgn->reads -= srgn->reads;
+			srgn->reads = 0;
+			set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+		} else {
+			srgn->reads++;
+			rgn->reads++;
+			if (srgn->reads == ACTIVATION_THRESHOLD)
+				activate = true;
+		}
+		spin_unlock(&rgn->rgn_lock);
+
+		if (activate) {
+			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
+				"activate region %d-%d\n", rgn_idx, srgn_idx);
+		}
+
+		prev_srgn = srgn;
+	}
+
 	srgn_offset = 0;
 	if (++srgn_idx == hpb->srgns_per_rgn) {
 		srgn_idx = 0;
@@ -605,6 +634,19 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	WARN_ON_ONCE(transfer_len > HPB_MULTI_CHUNK_HIGH);
 
+	if (hpb->is_hcm) {
+		/*
+		 * in host control mode, reads are the main source for
+		 * activation trials.
+		 */
+		ufshpb_iterate_rgn(hpb, rgn_idx, srgn_idx, srgn_offset,
+				   transfer_len, false);
+
+		/* keep those counters normalized */
+		if (rgn->reads > hpb->entries_per_srgn)
+			schedule_work(&hpb->ufshpb_normalization_work);
+	}
+
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len)) {
@@ -756,6 +798,8 @@ static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
 
 	if (list_empty(&srgn->list_act_srgn))
 		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+
+	hpb->stats.rb_active_cnt++;
 }
 
 static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
@@ -771,6 +815,8 @@ static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
 
 	if (list_empty(&rgn->list_inact_rgn))
 		list_add_tail(&rgn->list_inact_rgn, &hpb->lh_inact_rgn);
+
+	hpb->stats.rb_inactive_cnt++;
 }
 
 static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
@@ -1084,6 +1130,7 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 rgn->rgn_idx);
 		goto out;
 	}
+
 	if (!list_empty(&rgn->list_lru_rgn)) {
 		if (ufshpb_check_srgns_issue_state(hpb, rgn)) {
 			ret = -EBUSY;
@@ -1278,7 +1325,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		if (srgn->srgn_state == HPB_SRGN_VALID)
 			srgn->srgn_state = HPB_SRGN_INVALID;
 		spin_unlock(&hpb->rgn_state_lock);
-		hpb->stats.rb_active_cnt++;
 	}
 
 	if (hpb->is_hcm) {
@@ -1310,7 +1356,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		}
 		spin_unlock(&hpb->rgn_state_lock);
 
-		hpb->stats.rb_inactive_cnt++;
 	}
 
 out:
@@ -1509,6 +1554,36 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 }
 
+static void ufshpb_normalization_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
+					     ufshpb_normalization_work);
+	int rgn_idx;
+
+	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
+		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
+		int srgn_idx;
+
+		spin_lock(&rgn->rgn_lock);
+		rgn->reads = 0;
+		for (srgn_idx = 0; srgn_idx < hpb->srgns_per_rgn; srgn_idx++) {
+			struct ufshpb_subregion *srgn = rgn->srgn_tbl + srgn_idx;
+
+			srgn->reads >>= 1;
+			rgn->reads += srgn->reads;
+		}
+		spin_unlock(&rgn->rgn_lock);
+
+		if (rgn->rgn_state != HPB_RGN_ACTIVE || rgn->reads)
+			continue;
+
+		/* if region is active but has no reads - inactivate it */
+		spin_lock(&hpb->rsp_list_lock);
+		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
+		spin_unlock(&hpb->rsp_list_lock);
+	}
+}
+
 static void ufshpb_map_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu, map_work);
@@ -1667,6 +1742,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		rgn = rgn_table + rgn_idx;
 		rgn->rgn_idx = rgn_idx;
 
+		spin_lock_init(&rgn->rgn_lock);
+
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
 
@@ -1908,6 +1985,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2007,6 +2087,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 9ab502f82835..33d163e76d41 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -106,6 +106,10 @@ struct ufshpb_subregion {
 	int rgn_idx;
 	int srgn_idx;
 	bool is_last;
+
+	/* subregion reads - for host mode */
+	unsigned int reads;
+
 	/* below information is used by rsp_list */
 	struct list_head list_act_srgn;
 };
@@ -123,6 +127,10 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+
+	/* region reads - for host mode */
+	spinlock_t rgn_lock;
+	unsigned int reads;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -212,6 +220,7 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

