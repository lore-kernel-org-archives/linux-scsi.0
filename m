Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928F7C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B6064ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhBBIcP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:32:15 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42154 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhBBIb4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:31:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612254716; x=1643790716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yE3IQNRIGv8P4YTxhrXqX1tuYBTk6wmw7N/UF17+BA4=;
  b=Eagx8Sm0nhs6F6vQsmCb4K9gSsyKHauoLfP3x8QtRK/d3utbOd+rnVqF
   bNqBOgMR/kHd2YXIeIXGkDqkrsO2J8IaHsVP9L6xJKspKmMF79ELy1tO5
   pGnPAOBEc/BweMW6V65Wz6a0o21CxlfGGi53N4tzrstFCo9l2H7qsahQr
   EBDDFDXyLL1CvMtJhaBSn0odsbk8g3wldWK3P1jamvvfsXNUDJA60YhuZ
   So5RKvIlKWDgQOpGQCjqkiHauvsm8hFa7qbkt7H1ERsfzBAOq5Ex4fGce
   UdiE7oagkWfFcO6QzMDQdwg30g+51GKm5dXtLOXPNKagdyMNfhqlOb07S
   Q==;
IronPort-SDR: EGJN8jlNPayLzVEfKMI6/7xaB16acbBZnL7WrXrtVqs3FaQ3GpctbmoM2TDBDftwDE7jKyUMf9
 rdtXrcfpYo4yiN53XzlZFW9ZwwuPL9bzOwrL10dAV7b40PTO+DgxJkBMJ2dsV/6ouO2Zk6kgh7
 SHdr5lVnXTq4rH5+OyqiwhSzCwFVqDPVp2KH/7dviTlIp5DNH1hRI53l1O2hDkAwBeJmHToGM/
 3qzr5Blyg+/fMhSy5ttpr7Ol15XfiNtkNEshhB9r1J4PZzkMVxbzEgKm4gN/v8rKbFgBopDD0J
 jAg=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="160083504"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:30:50 +0800
IronPort-SDR: kXYUnD1HoWLAM6Q5zgSvPJ3THm0qWM3tZxhLoytMsrfrcOjCR6P+NNmp9D37VxZbpu6hz4Ri1U
 3gka42BC9rFQeoP5ChqT07WwlF2Nc4iU90q0SsJZHdAtGDjBmbp5IesRGkEOK8M1s1Xa6tvGau
 KrLHyoFvM9jaOEfEiZYfEZ4URW5Rz+Mgk4PZxofrmgw++Ob1dxVy3m9yDV/16w+b+0dCH0+IZ9
 oEOjbFu5tXNI2CmNsr+XfGIR2rGxoZjbSLrFAzSbDMViHd3+LC3cyFzcOutwqbRP+St28AquZq
 yzxr8Ra37IkYOgSjWWXT7P0o
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:12:59 -0800
IronPort-SDR: MI32eZ2EuH5vgypqpY3QF2brIIp6t4EGJ+ZBVQlSYCFs7IqFXCV27UGTfKT/SFYeqx0LH3qd2i
 vnOsd4vXHJWg7oQqHx3oSPhqwyBmXjjgte/PA08dy37CpIA5k8wSO242jp14EO3RG4/fCkNhT8
 LJYUhRxPeo3Z63PzuTuXUfsslu0yQ2bCS/PG+iOhM77ja70CmsbwkdGcScjEqG9RBRva0geR4B
 sYQndWA5SDkW/d1sszLzR0Fe8vDCnv+1KGt5jitdH2I8/kcvcynKXxtaV/bzU+zdLKvDRYlyDQ
 49E=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:30:47 -0800
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
Subject: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Date:   Tue,  2 Feb 2021 10:30:01 +0200
Message-Id: <20210202083007.104050-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 109 ++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |   6 +++
 2 files changed, 100 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 61de80a778a7..de4866d42df0 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -16,6 +16,9 @@
 #include "ufshpb.h"
 #include "../sd.h"
 
+#define WORK_PENDING 0
+#define ACTIVATION_THRSHLD 4 /* 4 IOs */
+
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
 static mempool_t *ufshpb_mctx_pool;
@@ -261,6 +264,21 @@ ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
 	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
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
  * In HPB v1.0, maximum size of HPB read command is 4KB.
@@ -306,12 +324,45 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
 		return;
 	}
 
 	if (!ufshpb_is_support_chunk(transfer_len))
 		return;
 
+	if (hpb->is_hcm) {
+		bool activate = false;
+		/*
+		 * in host control mode, reads are the main source for
+		 * activation trials.
+		 */
+		spin_lock_irqsave(&rgn->rgn_lock, flags);
+		rgn->reads++;
+		if (rgn->reads == ACTIVATION_THRSHLD)
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
@@ -396,21 +447,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
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
@@ -646,6 +682,14 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
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
@@ -1044,6 +1088,36 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
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
@@ -1313,6 +1387,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -1399,6 +1476,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 5ec4023db74d..381b5fed61a5 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -115,6 +115,10 @@ struct ufshpb_region {
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
+
+	/* region reads - for host mode */
+	spinlock_t rgn_lock;
+	unsigned int reads;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -175,6 +179,8 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
+	unsigned long work_data_bits;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

