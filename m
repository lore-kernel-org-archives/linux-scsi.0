Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C689BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8DE2076B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbhA0Pc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:32:26 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:45981 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbhA0POP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760455; x=1643296455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7VFDSJqxHUSXRoc2A3ruFxeTNHKGX04nUEcpHMmE0PY=;
  b=miCvkYJk09bWrNt+OHE5tKfMVQ2w3OrbVybHkWcDUPqg1UeV2mzgBKV5
   eTGS3ED7oUJE4aWaANprBKgE7vxVGbrwt4cuWI/8hVDar+5EemKBL5jn4
   AI3mSZk1nTc/g+U8lWl0u2JQpYsB1Kt4u1WYHyPMZc6U5ZOqFDNugPBGp
   a9ZRwvVFcFPXFsiHvgJlygwzJscwNtXkK9WMe8kCdZN3X5ndWJZ/cyayu
   VTlSDY6j9QMkEZFcUFmpJRZzX1d5jUMAOh3mUAQFT6VDB+bQTsofE+EIS
   KPit2zK7JthMHiLNbu0ynzrYL5TbKclRuIbVotEO0JrTK7VjUvAXlFItq
   Q==;
IronPort-SDR: Mm3Ne0XmkAWLFA5Ka9AKewzNxmjBnw6vmFEIBmNglBjpU8vSfgl/KTNUvEuED+H7ZXBjGUTKPs
 fy+8J0pKZOnc7hKPoIaartn9CBW5DbcHpTN2QfwDd2QxHRE8QHTcPfriHiabuqdTEwtwdFHzB2
 4GB4JSO/j2OzEf2H+u/pxgdHMNq6ALSS9yOqIDAg8wzHKK4b6Qzvj/o2alg6BlQQ6AScQVaJQG
 3zuYk1kZTX+WD6QabBy4G7bTLBDlHuZmZMd4O6qr5i/rUJ9EwiJeM7oThIVMbNnfoAU/tLYYec
 c78=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="162900946"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:13:06 +0800
IronPort-SDR: fCb5pqjkWniYX7ucz0douTOVaapvB37x/ylliD2gvm3ePIhZuv10PVu/tVm4XZObBa57r24yoE
 9xbuuBdd53SzcAVV0ZKuokAUFwFH52cQckHfGrvjfjPUyXuZHHbrwpSOSPmPj+ruSI1UgO0Yj5
 9oSvMQIJt6sLKrINN59sCb1NfTC+z7fKO8AcPmD72AL1CakYtCi42s4Lz00JRBuE9fC7ihpYT+
 ACvm9FTUygFYiNx7xzU2Og9MqwJjFOa+1r/gU82qsUYCHxJ91zrDEQJC+udp9h7Ruqq5BHEP7d
 ZrSltkDBr4Awj9ETzYzyPR4I
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:55:25 -0800
IronPort-SDR: 16N/ihp9MyZPJSJZKsrL/vxP5zkj1nT5PGiUxR820l0ofyoqKRITGGN/4PfQt0OryMNUbw/96K
 HOdx6Ei1iyeNTaqH+VJrBwuqAvXMBOTiIZrXe4TbUub9FAd7X3YEdO5GCcPQ3Ndi8KUcsV65Mw
 cX5egc0WSWir9jEujXGJPfTCEslnWcX9L+zQhVYh6o5GpUCa18D0obVGwSaKeApYxS4Y9tvO65
 DTpA6dXoZKjfCm5i57uCettK9ze7dicpBLqNcSo7HXeJ1VF3T7CmFk06MlKKPNG56lbfL6HFVz
 VT4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:13:02 -0800
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
Subject: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Date:   Wed, 27 Jan 2021 17:12:12 +0200
Message-Id: <20210127151217.24760-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 96 +++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |  5 ++
 2 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 5fa1f5bc08e6..51c3607166bc 100644
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
 	cdb[14] = transfer_len;
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
@@ -276,6 +294,7 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	unsigned long flags;
 	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
 	int err = 0;
+	u64 reads;
 
 	hpb = ufshpb_get_hpb_data(cmd->device);
 	if (!hpb)
@@ -306,12 +325,39 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				 transfer_len);
 		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+		if (ufshpb_mode == HPB_HOST_CONTROL)
+			atomic64_set(&rgn->reads, 0);
+
 		return;
 	}
 
+	if (ufshpb_mode == HPB_HOST_CONTROL)
+		reads = atomic64_inc_return(&rgn->reads);
+
 	if (!ufshpb_is_support_chunk(transfer_len))
 		return;
 
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
+		/*
+		 * in host control mode, reads are the main source for
+		 * activation trials.
+		 */
+		if (reads == ACTIVATION_THRSHLD) {
+			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
+			hpb->stats.rb_active_cnt++;
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
+				"activate region %d-%d\n", rgn_idx, srgn_idx);
+		}
+
+		/* keep those counters normalized */
+		if (reads > hpb->entries_per_srgn &&
+		    !test_and_set_bit(WORK_PENDING, &hpb->work_data_bits))
+			schedule_work(&hpb->ufshpb_normalization_work);
+	}
+
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
 	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len)) {
@@ -396,21 +442,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
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
@@ -646,6 +677,9 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
 	ufshpb_cleanup_lru_info(lru_info, rgn);
 
+	if (ufshpb_mode == HPB_HOST_CONTROL)
+		atomic64_set(&rgn->reads, 0);
+
 	for_each_sub_region(rgn, srgn_idx, srgn)
 		ufshpb_purge_active_subregion(hpb, srgn);
 }
@@ -1044,6 +1078,33 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
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
+		u64 reads = atomic64_read(&rgn->reads);
+
+		if (reads)
+			atomic64_set(&rgn->reads, reads >> 1);
+
+		if (rgn->rgn_state != HPB_RGN_ACTIVE ||
+			atomic64_read(&rgn->reads))
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
@@ -1308,6 +1369,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+	if (ufshpb_mode == HPB_HOST_CONTROL)
+		INIT_WORK(&hpb->ufshpb_normalization_work,
+			  ufshpb_normalization_work_handler);
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -1394,6 +1458,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
+	if (ufshpb_mode == HPB_HOST_CONTROL)
+		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 8a34b0f42754..b0e78728af38 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -115,6 +115,9 @@ struct ufshpb_region {
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
+
+	/* region reads - for host mode */
+	atomic64_t reads;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -175,6 +178,8 @@ struct ufshpb_lu {
 
 	/* for selecting victim */
 	struct victim_select_info lru_info;
+	struct work_struct ufshpb_normalization_work;
+	unsigned long work_data_bits;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

