Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD8FC433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DA8F64EAD
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhBRQ5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:57:25 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5492 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhBRN0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654923; x=1645190923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Z5gobiy/8FkE/TYphPMCbzPJlRPUDrnk+T3bO1VJgs=;
  b=YI7BvkHVjF32+WKpHi8KkSM9crKY71B006eWSfCuR+oWl38pW47+I9dD
   /Vf5HxSX39s5gDhSFJVwOQNR1tIGjtMQjGaLq9H7dJ8mIBFfIL/bkWNwY
   hMbiMZ3r01jV36YTFPyip/id5lEXBpZm9/t+6yTIv1AiwqlDDWk0vwFJM
   ylxRbM4UTaRfpszSvTODhqSO4Ka/49pfXsQX9RL5R0Lb2Z4oO8oU08x9l
   34Wto74afGl+cZVY7PbMQpUnjfoYjq30wppUyucboCyQMb0E0Vgnp5b2o
   YCKOUy+eGLdZdYFngkADJDrUHVdnF7dmXf3mpgTK0AK2JTrM/ku+WDZ8R
   A==;
IronPort-SDR: VPiZQ2urwXMOxw1xhwe9Q+1Ii7Q/NVQP2TgNZcrvVrsmu4l82tRjFkSC3ZJBl1f2zsv7cplfOL
 e9Gu+i78UEJD5OxpPvUaP9KTRgJS0brfKH8m3veM7B2I+VNV5oevcwy+9uWUflH71Z3Z4vNb5I
 /rdxKtuwym3K1SG4fZwGHLsdunTGivOI/lwsZMC9Y5JM1kmGQdhnJ8BZVamrmQYcMwdW4dTU7o
 qPebyZIOgNAlMugmqtg+2dwLgH/4xxYY0Za26R8N/Wt74bKuLlzZcdMa7tKf/QRTNMW7beFK8b
 NZc=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="264440596"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:40:45 +0800
IronPort-SDR: J92JhHaq4y8c2VzWPsnaT5il+c99rUTE0yJw4xso0e0mc5Pw3wphkEQgc2fIPpB4niDcziCtD4
 ZbhZPronLCvTVWktI/fM3tFeN60qqj2EomTNNlP5ZTrgCLqZc0Gxe2mlNtCOssDDyfQ0r6RpqD
 /RzaOQ7c46UWhPbbZ+Yuei8o2Z2Qc+JcjeDjtIb5aflqPwGtp943o4Dj5kXMQlrdQd9xCxPg9Q
 BQ9eLX+Bg1PA+av6RDW48O+mNqTHJdONBtUrvWq2PkemPsxNFby5xzdZp0Js3yQ3lNTUgBZ5b7
 TG3Qoz8Oou92FhAq0/AwcXuZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:02:18 -0800
IronPort-SDR: SuMQNxoMJZmionB4ubMvOKoud5sKbJoDcoDMqEtkGcOC9fvtLG/jYDzy3onjSMWfV+g0wFtGj5
 d6I1CRNX+GughXuENc36PNhXVLrjqb/rrtX6Sn8+iJ5VYpBOlmgIt2Vz0TQOvYKzVePaRC6sxa
 cnHIBFjT19XlGgDT2nKj8U2FhbYjZPYyDh2b3VzXz5Eples7zMv0gFSK+LsDQEsOA9SylQ0QLN
 OMMWWEhvmX0tQcfLfn8vh84AqYH1lhtQ5EUdvyHlMTxTIL+xyyPFDi0IeBTy3RPSTiE1HX3OAe
 b8Y=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:20:34 -0800
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
Subject: [PATCH v3 3/9] scsi: ufshpb: Add region's reads counter
Date:   Thu, 18 Feb 2021 15:19:26 +0200
Message-Id: <20210218131932.106997-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 108 ++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |   7 +++
 2 files changed, 100 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index e052260868ad..348185964c32 100644
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
@@ -570,6 +572,21 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
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
@@ -616,12 +633,45 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
+		if (rgn->reads > hpb->entries_per_srgn &&
+		    !test_and_set_bit(WORK_PENDING, &hpb->work_data_bits))
+			schedule_work(&hpb->ufshpb_normalization_work);
+	}
+
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len)) {
@@ -738,21 +788,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
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
@@ -998,6 +1033,14 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
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
@@ -1420,6 +1463,36 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 }
 
+static void ufshpb_normalization_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	int rgn_idx;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
+
+	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
+		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
+
+		if (rgn->reads) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&rgn->rgn_lock, flags);
+			rgn->reads = (rgn->reads >> 1);
+			spin_unlock_irqrestore(&rgn->rgn_lock, flags);
+		}
+
+		if (rgn->rgn_state != HPB_RGN_ACTIVE || rgn->reads)
+			continue;
+
+		/* if region is active but has no reads - inactivate it */
+		spin_lock(&hpb->rsp_list_lock);
+		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
+		spin_unlock(&hpb->rsp_list_lock);
+	}
+
+	clear_bit(WORK_PENDING, &hpb->work_data_bits);
+}
+
 static void ufshpb_map_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu, map_work);
@@ -1810,6 +1883,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -1909,6 +1985,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 8e6c2a5b80a0..0a41df919f06 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -117,6 +117,10 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+
+	/* region reads - for host mode */
+	spinlock_t rgn_lock;
+	unsigned int reads;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -207,6 +211,9 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
+	unsigned long work_data_bits;
+#define WORK_PENDING 0
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

