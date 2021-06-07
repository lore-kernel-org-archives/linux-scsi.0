Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9ADC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 719566121D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFGGQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:16:48 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:4757 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFGGQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046497; x=1654582497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/uVpI9cCRF77MVsFcmUIyS2US+7d5GjqQu2LbdJilI4=;
  b=rqU4QVRQdU8JoZOgR+vQqM4GYr7JcLuFwf3yGc4nhmrZmDKppBd/SCKD
   UT7cDqKvT4jwjhWjVIBL/Z3JHRtJpbIOKru9ZgQIxpNMsIa+c3XV1bTmQ
   lekkynvMCe0ykB2UFjR54FT8wp4gFVaNKYV+RPjbjZTraBSTC6aZRjlFh
   5vD1fz2+BPfsEHVXqzUPhicCkNALoUH4C1Gu53YoHiydFYUrqd0S0XkTx
   pvlTeyKPvqP7zjz8Y4YqlGy16NOJc6fxiXZHb3d7c6YFlozgNaOUPjkoA
   E8kRZFEyLwV5bJ1nmXvZ3/FZEthjJiHZbfMT+vBO6x/GLfrTTpCF9Cw3A
   Q==;
IronPort-SDR: Dyl2D4TfihI/MD1E14l7Oc4VDKKyHx7WWHzt/o/LIhD1lYiM4YOMo7mZy78tFkV1i62MF2ZteA
 u+AxeyVebEcb32uBtHtaDIquXX+cnKuBfYNTvNPJH4gIvbnmwU6yPhBt6suGrcHIlx7S1Nmjo9
 jgxWrL1Hf8hFMV+9nun0StCwSwBRNFZv9tcZrPyxU8CDczUk0DnatDmnOZB/noVO58uwWSj2Sg
 fMHbdzHzhlvxd0M61RuVoQTUh4pvA/FaTsBVduospareQp5X1ZFW38Wxych8Yr9iOCbCpRZCCd
 OJA=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="170991540"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:14:56 +0800
IronPort-SDR: SXar8ADT02dTlnHnqtuNHLWG47/foleNLwQsYfSNgPpKXBqi66MXV/9OiLXxB0taDvMU3D89sD
 XBhqRwNSFGSRdNGJVPYF7nVnaVnoTBNR6eZW94OLbEN4OrJd9yGxHo/YPr2xbz8lJMot3gWfCn
 kraUSOv1jDe+xBXjK8a8DM3wTpcis7WIb+9kPDolIU55hZLTAm53FXuiN/dR34H/H0ynFVCpjw
 dXXCL76kY3QHxexA+6gFeXyhSOmIveKPRust2Q5+514U3dZIx1iXiQp2iP0zPHZgtjPUH6JOJE
 3fzMQPPh2ygWFBjwmBt+B0wj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:54:04 -0700
IronPort-SDR: xqN+qbWCiUYQ6BZ9QjKbg9t7YRrKcfMvuYeypAZojGiRLzjdKNM/kBmfvoRdLptgxmrL2LgTUP
 XnRYz4WkF3RsvUVBX0MMvLLmZIiW73ZDbrBClTqqNHVWOsfCTAvMVcvFdWkpFEXkcEjJIKXGZz
 0nxFpSafjZ8Zw/InBDg+v/nbVTk1nbNjpF6B/Uco+GnNa3yyna5YIY4VkIVNO3iBwuGjIxAsIF
 uuaq3cAO7dOl3mLqxg2GbsOYrgYQFWOn3uHdJ+MTfXrl2MJ26JlmnxT16t3zYpMPfpfNCunfyd
 Dvw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:14:52 -0700
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
Subject: [PATCH v10 04/12] scsi: ufshpb: Add reads counter
Date:   Mon,  7 Jun 2021 09:13:53 +0300
Message-Id: <20210607061401.58884-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index 01a4efa37db8..b080bd9ca35a 100644
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
@@ -1673,6 +1748,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		rgn = rgn_table + rgn_idx;
 		rgn->rgn_idx = rgn_idx;
 
+		spin_lock_init(&rgn->rgn_lock);
+
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
 
@@ -1912,6 +1989,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2011,6 +2091,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
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

