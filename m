Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6529C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CEB6101D
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhDKG26 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37451 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhDKG2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122517; x=1649658517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MP/iaopsFhmHH+0iw/GzZpRoFHNh2uNshgBq4m5TKTY=;
  b=qfEH5EKtLDYOvuw4UBTZi9/vsfBTgGmLmF6490XF1LCgbWFxZTD4WYY+
   brMnam4kG1E2veTkf/ubPbWKXO9LNY9ukwE3BZ3wm2cy1Pz6BZDQFpLq5
   0XONYael0hP8+dgixtU7xQrmxXY4Tl/7x5Jqkc6easCP+eSE6bM4xMlNe
   VP+u1EXOnwS2uSpHtKb50tNBoZkK9wL7Z+F6WmOECJwC1nyxydg57seo2
   zhBqbFDcW+ZoLQr0JX85ccUmTCOIpNUL62Eltja1AhpsUASMzQfWm9pQ/
   lu994QHn3100Lz7TD9PRbM/ykvlkCI9krkzfZgLcevFuSxIOyqQBoFRfI
   w==;
IronPort-SDR: dwfa3blFGWRkB7Yq1ryQ71WbMzpiut7bLtyn3HH9uyH9A0GJcAcuTqzQM9Lhw9b+cAJEDLzf7I
 befR9noht3Co+hTA2g6INmpDXg86nTUuBiGurMt9W4Z2fbfIn4wmuIX/Wtmjd/AatvQlUVMJp4
 wxJilBG49zZKAjb1lpJxhHA1p2Y8I7S8s7AUUB0r7tycFcouyfdUr5fvq43rmIbvZ/dlmnyafj
 zG01vKS+XZPk9WeGJEEwd0Q2OuzA6abZUx371aPDHJjwLuXv7ZmOWzoki85JFObtDObSWFhKRT
 dKo=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="165243146"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:18 +0800
IronPort-SDR: PEnxur/yZ0R0Cim2kSZvE4MBSLRruGLNRCBXh9Htf4U3jwNrBtajo31dJD07sIbouS2cnkYQNT
 Wsk2i+9gRK9D4LH/3xkIEwJMmtqJvyol5rHzpAJTokzbx69ztobLoOTuS0ifrACXHWzHd2ClJY
 x7CjjMol5dtmBO93rBmVDQstl2GheR13l347yiaDaAA64da2mr2HL8mL3uGYLFXt/drwj4C/7R
 snBkP0TEWdfK22shmrP0eJDuH4b1tILsamwfm9jOtkYVe6txXKFmoa3kkwpxPYpCodZuTOQ/zv
 BlcSWzYpxjy1iwKN/47h3DGp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:07:40 -0700
IronPort-SDR: zzBVCb5VC6j4LqNS9i7OYo5GCX+jMwoXoX59bjQPR0seuKbOxH+x09e4YkTrwbR2kWhxZi9bjt
 C10DZR5Eqjgl9lEiabZvVbq9OWRPlpWbaNfzMVDrUOh5jnmmBRb8h234F1c9ruSEi17/ipy2rm
 G5jLPGb8b6LaPlahhd+vKNMdPTWjKMkFSv3UyNz9Xwp54kxBj1FySvB6Sp7fUDgsNsNgjTgey/
 40XHlsmmwqE3wsZamrHoQLnicS/d8wYB4SO8zahzAX/F7WpLY29QjvHhKyrObPB4FxCK3eEY1+
 c1U=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:28:03 -0700
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
Subject: [PATCH v8 04/11] scsi: ufshpb: Add reads counter
Date:   Sun, 11 Apr 2021 09:27:14 +0300
Message-Id: <20210411062721.10099-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
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
index 252fcfb48862..3ab66421dc00 100644
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
@@ -148,7 +153,7 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 			       int srgn_offset, int cnt, bool set_dirty)
 {
 	struct ufshpb_region *rgn;
-	struct ufshpb_subregion *srgn;
+	struct ufshpb_subregion *srgn, *prev_srgn = NULL;
 	int set_bit_len;
 	int bitmap_len;
 	unsigned long flags;
@@ -167,15 +172,39 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
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
@@ -604,6 +633,19 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	if (!ufshpb_is_support_chunk(hpb, transfer_len))
 		return 0;
 
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
@@ -755,6 +797,8 @@ static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
 
 	if (list_empty(&srgn->list_act_srgn))
 		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+
+	hpb->stats.rb_active_cnt++;
 }
 
 static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
@@ -770,6 +814,8 @@ static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
 
 	if (list_empty(&rgn->list_inact_rgn))
 		list_add_tail(&rgn->list_inact_rgn, &hpb->lh_inact_rgn);
+
+	hpb->stats.rb_inactive_cnt++;
 }
 
 static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
@@ -1090,6 +1136,7 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 rgn->rgn_idx);
 		goto out;
 	}
+
 	if (!list_empty(&rgn->list_lru_rgn)) {
 		if (ufshpb_check_srgns_issue_state(hpb, rgn)) {
 			ret = -EBUSY;
@@ -1284,7 +1331,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		if (srgn->srgn_state == HPB_SRGN_VALID)
 			srgn->srgn_state = HPB_SRGN_INVALID;
 		spin_unlock(&hpb->rgn_state_lock);
-		hpb->stats.rb_active_cnt++;
 	}
 
 	if (hpb->is_hcm) {
@@ -1316,7 +1362,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		}
 		spin_unlock(&hpb->rgn_state_lock);
 
-		hpb->stats.rb_inactive_cnt++;
 	}
 
 out:
@@ -1515,6 +1560,36 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
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
@@ -1674,6 +1749,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		rgn = rgn_table + rgn_idx;
 		rgn->rgn_idx = rgn_idx;
 
+		spin_lock_init(&rgn->rgn_lock);
+
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
 
@@ -1915,6 +1992,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2014,6 +2094,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 032672114881..87495e59fcf1 100644
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

