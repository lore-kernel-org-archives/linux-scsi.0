Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A243EC4332E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61EE264F21
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581527AbhCBS57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:57:59 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23192 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347028AbhCBNbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691880; x=1646227880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tuMBzJcfZ8Nw6jlG9OQ1dI7Gar9QuErc0UbP0X6+pg0=;
  b=JPBNg3kAKgcUx4mncMjTRdts91ot5dfILJH5kTlU2G5k4Gz+eDm8prU+
   sgK8c8KYK1XcYDZQEqF8EExRYVTJEL3RC7/3YBiJdhKYyqYc/3sMp8m7E
   JdawtFiby3DN95WafyQ/pEUQhP9Ya0v+oYagFrJzvwt1+83tqVkpH+LVt
   YIj47v0tU+g8zKnuu7XKLoCF0ovU8vvy7epp8f3Kqsnign9T8t6fa8I4M
   Q1IwaJpyYbDs5Spcc9bLwRTSOIzznaft4eeHZV9ztnvi/mPm9sbf9JgUi
   rgFH0dZ/5zZAkBBF2H0d1iRYQYJp+/VVs6frLgulPvAiqgSOpLQX7avt3
   A==;
IronPort-SDR: IDhbzDHATuASBSn2FankBZGtkZ+MdPpx1eholt1oF6Xca6x66iOq2POfAEB0GbE8cuLkFb+9pd
 ZWnZbGqN3UfCu0IX6BHE/VkJ/yZDd3kCRcEHv1UJN0b1D22vSmYXQ7idI/tEOHrNTHT92/L/r9
 MxUQuQpEWf4riY4XCjBm8ROLjV1ez034g9KwiMMiy2j3+yoUuErFsn7OLBKo9gz3jBhN5h3jc+
 we7jBBpgq8fAmjhmSkHrARqBulXtlqiRUdPKmB3lLD8AXNBuCPpAzskDp9oxEoenAkSqSYjo+Y
 /jQ=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="162324688"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:17 +0800
IronPort-SDR: A2rvw3Bj03ZGBySr8jtUd/ZTzTWIPQTDImp0W+AUZ6MJZt+95MU+fnABDY5Q5oXIS3GJ+Lw1rQ
 HT5Y1udYsu0sUha1vSGbdqzCMTOTL3uxxddpTUakHrne59pJbzdADqPrR2cfqgdwEJNbOIl9G8
 LovBUauNdOoYOioY1F+lZK14/R7zsgy9ZpRQtoZ8O3bnDziDC9CJeZSkkHBoIxk7hyeplgQ3AB
 wmLVx4oyOn50oaki5KwxnqQlpM6xfHTVXmd+wL/XF2rCFTzKlG3DLWxeXa5ruW9+5FoSBpV3Ak
 ZiaegKQ4Z7bQIj/nI1aRaMvP
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:09:22 -0800
IronPort-SDR: wkeK+El7hBfZCpuT2sZtpIvc/rCylu33+FfCOjnGynaCEPQL8TX9GqmZmw934Ue4I7JrFFUHsl
 1uac14nJ9V3nbpiw3BF29G/17vXkHIHCShlQNEjAS2tAiHgYstJ8jakqYopvXsVui9TmP5rFul
 NPaXImlHKv2IQAwtaEi75jGrl6W5Z54xyoTSoWhrwRmIzlWtZ4tUqZ7DKFzsopscFXUUDNMzB2
 zLLyfL8vZ62hv9hf5jO0SrCtGZm+tfEuxxuR32om211yYWV/wGPJLgtUn5n9JFiImDXkP5jSll
 UNs=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:13 -0800
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
Subject: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
Date:   Tue,  2 Mar 2021 15:24:56 +0200
Message-Id: <20210302132503.224670-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host control mode, reads are the major source of activation trials.
Keep track of those reads counters, for both active as well inactive
regions.

We reset the read counter upon write - we are only interested in "clean"
reads.  less intuitive however, is that we also reset it upon region's
deactivation.  Region deactivation is often due to the fact that
eviction took place: a region become active on the expense of another.
This is happening when the max-active-regions limit has crossed. If we
don’t reset the counter, we will trigger a lot of trashing of the HPB
database, since few reads (or even one) to the region that was
deactivated, will trigger a re-activation trial.

Keep those counters normalized, as we are using those reads as a
comparative score, to make various decisions.
If during consecutive normalizations an active region has exhaust its
reads - inactivate it.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 102 ++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |   5 ++
 2 files changed, 92 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 044fec9854a0..a8f8d13af21a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -16,6 +16,8 @@
 #include "ufshpb.h"
 #include "../sd.h"
 
+#define ACTIVATION_THRESHOLD 4 /* 4 IOs */
+
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
 static mempool_t *ufshpb_mctx_pool;
@@ -554,6 +556,21 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
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
+}
+
 /*
  * This function will set up HPB read command using host-side L2P map data.
  */
@@ -600,12 +617,44 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				 transfer_len);
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+		if (hpb->is_hcm) {
+			spin_lock_irqsave(&rgn->rgn_lock, flags);
+			rgn->reads = 0;
+			spin_unlock_irqrestore(&rgn->rgn_lock, flags);
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
+		spin_lock_irqsave(&rgn->rgn_lock, flags);
+		rgn->reads++;
+		if (rgn->reads == ACTIVATION_THRESHOLD)
+			activate = true;
+		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
+		if (activate) {
+			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
+			hpb->stats.rb_active_cnt++;
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
@@ -745,21 +794,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
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
@@ -1079,6 +1113,14 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
 	ufshpb_cleanup_lru_info(lru_info, rgn);
 
+	if (hpb->is_hcm) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&rgn->rgn_lock, flags);
+		rgn->reads = 0;
+		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
+	}
+
 	for_each_sub_region(rgn, srgn_idx, srgn)
 		ufshpb_purge_active_subregion(hpb, srgn);
 }
@@ -1523,6 +1565,31 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 }
 
+static void ufshpb_normalization_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	int rgn_idx;
+	unsigned long flags;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
+
+	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
+		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
+
+		spin_lock_irqsave(&rgn->rgn_lock, flags);
+		rgn->reads = (rgn->reads >> 1);
+		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
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
@@ -1913,6 +1980,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2012,6 +2082,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 8119b1a3d1e5..bd4308010466 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -121,6 +121,10 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+
+	/* region reads - for host mode */
+	spinlock_t rgn_lock;
+	unsigned int reads;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -211,6 +215,7 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

