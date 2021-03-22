Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB679C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C133761973
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCVIMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:00 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12236 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVILg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400696; x=1647936696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zn4Hr1n/aB/9YN+9nD0vGeVhInuIDC2ZbF8Fk/h2p/I=;
  b=Nzi0zBYjC3wj/ewLDneXUTnjQHKHt0JG+FZf5uWizvclL3lULzIukx/S
   ZCd7NIsVJkoF83w+D3Mn0D/0gEnuss94SwvchCTTHWO/H+aZg1HkQxtab
   3CV+91G4X9IxyJujnu+RM+6XCfrVdc9NN7TOytN2irLbzaCrxDY77WLd9
   pcAUANerm1hLg1qZIzvJZQQCHJHPcFmVQSHvxTMzViSKBPs3ZBNksTU4K
   IXesfhgWOPhOJeu4V6Luyse//YVoltzM9Oj4fAAIgqFRBz5QA9I3mVckj
   ZJ47gQE1fOV3Kv3BbVx8cTEYH+0kHxN6kLBf0MqGpXcSQOaenOW/H3aTE
   Q==;
IronPort-SDR: U4qrDx7al659gvg4DgwlQov0N5i3PnQnXF2YbB8Vn5LnisVbJlkoAFLs3xAXfW9hwatzMiSCgD
 4YzeOxy5Un/JmSK+HdlJ9BaJZMSqSJgO6VJZQi/aJvcikQjWSdkFlwQY5iw6Nbgh5bxQ6WmOci
 TNvuvP6Z36Uoqm+P8YN7PoiR0xagL/XG1eL9UnaxWhQSaJ9HGyzx5g6vphPjTuVLh4ltCo5QkM
 uoCkurACoqPu0t56dTRCD1l4uFFobwc8W5VL5C7INHpy0lMJaO/u3ykD8K0KhPp6yPrGBd1Mun
 kEc=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="162683002"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:11:36 +0800
IronPort-SDR: cdl0WzM1fjp0DQG9TgfzNBIOvlkJI3acEisJ8yh9bXsvDLLal55kVaKMIqxcoxDLz/tSy/QsuN
 ZMvAdZ+pspGYD1uPO3o+FhLhxGIa7P4AeW06BLOi/2ZpDa/RLLdd4dRHMSYR2jblRKAG7AgNFE
 XMONcZ7T3j3+yP/uuq5G5GqRCdDhU+7LI16jWXZuY/hXV+7VggxH5QTbetNVrBFfNbQ5ZU0/1N
 C/Qcpa4C239L5ADVV9JRKsuy+UzQXVZK33E55GOw+WGAePoTr3wX52giT3GECR9unJWE1uY9GS
 HVqzjF1LmoKH0iki1ceLDn38
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:52:05 -0700
IronPort-SDR: 4Q3XQXkSzNg+q+dwb7Yo/vJAex6svvYYCHhWmIXBDZz2OnAB8qhDYMZnry2Esk72bGNeGEPjQ+
 v6WI0ajn2VJUp3yJcNZJJlVh2rWpqZV9ME5GA2fbsZ++o4zBrLMx9bKnlvEtYN1vXjSlMGj8ru
 m+51YgMVjQmG59SCdEvtBGy6NA8L/somvy+Pp8jT1ftRdRCAaycJXaK0alzurg1bPYoh6lAS5v
 Mk3yLW3gMoK6CxztjQZFXgcHG0sd5jh4eh612DBMvx03IDwkVZyYLgFP3GFZuHhiY/5GY/SZyr
 yoc=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:11:32 -0700
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
Subject: [PATCH v6 03/10] scsi: ufshpb: Add region's reads counter
Date:   Mon, 22 Mar 2021 10:10:37 +0200
Message-Id: <20210322081044.62003-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
---
 drivers/scsi/ufs/ufshpb.c | 100 +++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshpb.h |   5 ++
 2 files changed, 88 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d4f0bb6d8fa1..a1519cbb4ce0 100644
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
@@ -546,6 +548,23 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 	return ret;
 }
 
+static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
+				      int srgn_idx)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	list_del_init(&rgn->list_inact_rgn);
+
+	if (list_empty(&srgn->list_act_srgn))
+		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+
+	hpb->stats.rb_active_cnt++;
+}
+
 /*
  * This function will set up HPB read command using host-side L2P map data.
  */
@@ -596,12 +615,43 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				 transfer_len);
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+		if (hpb->is_hcm) {
+			spin_lock(&rgn->rgn_lock);
+			rgn->reads = 0;
+			spin_unlock(&rgn->rgn_lock);
+		}
+
 		return 0;
 	}
 
 	if (!ufshpb_is_support_chunk(hpb, transfer_len))
 		return 0;
 
+	if (hpb->is_hcm) {
+		bool activate = false;
+		/*
+		 * in host control mode, reads are the main source for
+		 * activation trials.
+		 */
+		spin_lock(&rgn->rgn_lock);
+		rgn->reads++;
+		if (rgn->reads == ACTIVATION_THRESHOLD)
+			activate = true;
+		spin_unlock(&rgn->rgn_lock);
+		if (activate) {
+			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
+				"activate region %d-%d\n", rgn_idx, srgn_idx);
+		}
+
+		/* keep those counters normalized */
+		if (rgn->reads > hpb->entries_per_srgn)
+			schedule_work(&hpb->ufshpb_normalization_work);
+	}
+
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len)) {
@@ -741,21 +791,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 	return 0;
 }
 
-static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
-				      int srgn_idx)
-{
-	struct ufshpb_region *rgn;
-	struct ufshpb_subregion *srgn;
-
-	rgn = hpb->rgn_tbl + rgn_idx;
-	srgn = rgn->srgn_tbl + srgn_idx;
-
-	list_del_init(&rgn->list_inact_rgn);
-
-	if (list_empty(&srgn->list_act_srgn))
-		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
-}
-
 static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
 {
 	struct ufshpb_region *rgn;
@@ -769,6 +804,8 @@ static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
 
 	if (list_empty(&rgn->list_inact_rgn))
 		list_add_tail(&rgn->list_inact_rgn, &hpb->lh_inact_rgn);
+
+	hpb->stats.rb_inactive_cnt++;
 }
 
 static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
@@ -1089,6 +1126,7 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 rgn->rgn_idx);
 		goto out;
 	}
+
 	if (!list_empty(&rgn->list_lru_rgn)) {
 		if (ufshpb_check_srgns_issue_state(hpb, rgn)) {
 			ret = -EBUSY;
@@ -1283,7 +1321,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		if (srgn->srgn_state == HPB_SRGN_VALID)
 			srgn->srgn_state = HPB_SRGN_INVALID;
 		spin_unlock(&hpb->rgn_state_lock);
-		hpb->stats.rb_active_cnt++;
 	}
 
 	if (hpb->is_hcm) {
@@ -1315,7 +1352,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		}
 		spin_unlock(&hpb->rgn_state_lock);
 
-		hpb->stats.rb_inactive_cnt++;
 	}
 
 out:
@@ -1514,6 +1550,29 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
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
+
+		spin_lock(&rgn->rgn_lock);
+		rgn->reads = (rgn->reads >> 1);
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
@@ -1673,6 +1732,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		rgn = rgn_table + rgn_idx;
 		rgn->rgn_idx = rgn_idx;
 
+		spin_lock_init(&rgn->rgn_lock);
+
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
 
@@ -1914,6 +1975,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2013,6 +2077,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 032672114881..32d72c46c57a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -123,6 +123,10 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+
+	/* region reads - for host mode */
+	spinlock_t rgn_lock;
+	unsigned int reads;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -212,6 +216,7 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

