Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B753AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700B364EE3
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhBZIgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:36:54 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9535 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhBZIgB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:36:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614329746; x=1645865746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uTq6wIUb+TSt9CNKgvD5aCPIirS1X26O3rqisHDbZ78=;
  b=lVx95mHbQRrle46Mz7gZ+OtkcyYtOYEkyqP5YA782oMWxulMu5TbTL0F
   iw3EGu33mnbmZM18MZf5GxxwV6jDgH+oDwVReExtKAl7V8F5giGJFb27F
   mK0isGWNWA2P07ee7lxE1kNJu5JRkW/+5tl3rywbzpf6MZHveNQGcIqV6
   46/W1qSXcao7fPl3gzJv0Sopiw3LvrkQw103QvanP9x7TEqcMUjwqv2tn
   s+eL2CdKsUZb8z7gxrgUZAve8MCoyklmhVee88NQ7gaI2g1wiTl8VUuJR
   KsMzwwu07+3Zyl3DAJyRW4dHnH1j6VoEO7QicUO4WWgaXaJWKgWIqqEEa
   A==;
IronPort-SDR: x3Pfa2K7nVMj4RWiXERlwVJv0zud9LeaqYdY9THI61/fM+RFOBls5xH0J5JQN7PpRuxNAO8Xg0
 edEXoHg/DzT785R1woDGu8ggNTvkBbR8KRbjhMgpq9GoM+GgDYN85MAfkRWT8Q5eDnWZa6QHVB
 1C4rbb71vsoPBIaebVUjDlOk54U8q+Ostb2DSsE3aOjGNc9WHQhv+bK/BmhhYEif4/K1upHUXz
 WAXSpHGY9wJ7AROWFw1S3uvaUnNUu9MyYfUCGXSlR/wCDY2PYuh/7q7OQQtXc+XgMoj11dYRsU
 HDA=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="265100156"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:53:10 +0800
IronPort-SDR: RI/Y9JIJSw00UzHbAODUXIf7qlb0u9u+e663FuSG5G30YYePuNkl3aqnKizhOSM4Z38RHzWr2A
 kJdibRYNzAGtgZBSwtq8zU1VpjYSalZxeK5Do9BzeaC1nzjjQVtiZx885GtNYCbH04So6HQ49B
 9Q+4SzTHeIkQqFSL82Ee487mMWk6Pgw6hXoqcGIlelneLRuQBj3wrZGGWRtEWQpVpZJmvB7bnh
 /SVzsaTU81hWsggECfB/iRUNEXeGkmS0fXoKoP3L+Vf/QGh4kNEmp97CA5dVe/6jSRmz+9SP80
 T5Pcco4pbnK3Dso9+L6ndcon
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:17:30 -0800
IronPort-SDR: YJ4cSZnaQoSNhQWB+qcNDsofbro6ikRca2IVDnuSMev05rxwvQURvivrJ5/xE6sQ1nLaN3T8+u
 7FQauBA7O8ffp97ahByQQEge95orb56th0GX9Md/SJT4FbNQG6WKAL2qVGw/noT82TGfPe11sb
 zU9z9AwJZgq6R5nei7mxiGPOKpmTDBIE0NQP1x4OXEM/m96sq7OT0QK/mE8VKV2BN8HJi2Hlfq
 vpJpLXDfDC7biGGCpwqqjAfucBgE3wayEn0/TlZAI2o0c1cLa4cbub+h4i2NjUMClWUMvpbX6Q
 JBM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:13 -0800
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
Subject: [PATCH v4 3/9] scsi: ufshpb: Add region's reads counter
Date:   Fri, 26 Feb 2021 10:32:54 +0200
Message-Id: <20210226083300.30934-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
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
index 044fec9854a0..717ccb66b33e 100644
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
@@ -600,12 +617,45 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -745,21 +795,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
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
@@ -1079,6 +1114,14 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
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
@@ -1523,6 +1566,36 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
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
@@ -1913,6 +1986,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (hpb->is_hcm)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2012,6 +2088,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (hpb->is_hcm)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 8119b1a3d1e5..2fbe928ae7fd 100644
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
@@ -211,6 +215,9 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
+	unsigned long work_data_bits;
+#define WORK_PENDING 0
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

