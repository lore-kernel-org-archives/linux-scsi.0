Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BC1C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE6A207D2
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343710AbhA0PQJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:16:09 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:45981 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhA0PPN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760513; x=1643296513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8LCpJhOcp6mb2OjMnRI5NHCjmwJ1AWYbDF0CdKK+aq8=;
  b=qXLLcHdJkr1sznvYHXMY8MBChp6laimt1HyhY/LO3pihNy6sPsdccNoN
   KsDBrxOX7YrywsOmJknfYEtH9kluhbDVZxjv4qxU0SRSM9yYo6RphYdMv
   gZiuL1kdNYkPjhiM4GsoAaK1V/Tn7EpXcgPCm0UQ9zdKZK3sHxfErfQdW
   ZJyjN7yaDEa8tjz5CjmRubaONifDaHV2kKnXxmMs4rf54Rry4ETqVxcMR
   4lKn74zT+2yactvp4WFsZwTzoqW63EnOM/+iGcE+LFnEO9xhXx0495F9o
   2LZ6WTNRLHd7h57JhM1mUScjQLyG+GnUl7zZLaS4uehyeDw4hlz/Mwpqz
   A==;
IronPort-SDR: D9JrpSxhohPzAEGLCe51v3qoz29zcZQQhXcioiZUlvH2XCZgKyS5FHYdrhBP0CJqGlHGGEu5Z9
 TzYvKMK1EGnBM54VTdU7tFkexM3pjtRgh8wfVj7KwfbunM22WAgQRpeOAALNZhvUBoXagPzs5d
 zYfgQSA0EV6GK6HhHOorORB3P/hLY0U4qkhOKmwowoJc8PMJNwNKeFUSgic8M5Izrh+v00KeB5
 Ep4dvXtqF5QL8F+3VLfvq17D1h7cVO5iiRCCyDTKu1b8hiRGmK6OJu+kE9TF37reLF4Ux6aAkJ
 7+Q=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="162900991"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:13:38 +0800
IronPort-SDR: gnGTMDbW/3ZOzsn62wT2ZEMJFem3283GDkjey82ey82nQAW0uGhtiWweT+sUGJ4n/KT2vatJjY
 DzRBufzq/DMgyeOckLvJNO4XokZG44WueeFY1sI/f0Qg6nCxGyNfIbGMDzBkBMJ37gcUbFQUAN
 Vfvt1QAijeoHHrAs+Cl6mdIaKR3VG7auxWsrHQnGt2VM0pnvE+cBdEByDPbyTptu7BRnfGERlq
 twVyV+PO3EfLq1k7lBfKLZ+w7YW0Fdu+ar2+s775j0FkBjcUVYIN/KJ4aEJchYRcni/YJIg5KI
 JOKxt4sHF4MrAWwD0wYh17LB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:55:57 -0800
IronPort-SDR: wgInEWAFnI5lo4O6WB2WBc5aGele/BMuVCCir7VxgbKoIv2ojG5kJzAgz3GezpOHb929oHGJ5l
 dbcfoCzCkheOp0PCFAkit9wo3tCMFIyQEb1liYG7X26uuVyO0QTWjaamJrAuNyBiOOsVIAcEIe
 s0rJWZ7bJ+YoQNTkbDmFsL/1HZOCwQR64Bo+L3ehV+67GT0nI7008+k88DYFthpokbcGUWHMte
 Yb7wSw7bUM/FbB2PeO0aHNzjZ47xQx9v4eWX/0BF5Ifbvqxb1SZ73lZnxB1WAcPUhpmolej/O3
 CgA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:13:34 -0800
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
Subject: [PATCH 7/8] scsi: ufshpb: Add "Cold" regions timer
Date:   Wed, 27 Jan 2021 17:12:16 +0200
Message-Id: <20210127151217.24760-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order not to hang on to “cold” regions, we shall inactivate a
region that has no READ access for a predefined amount of time -
READ_TO_MS. For that purpose we shall monitor the active regions list,
polling it on every POLLING_INTERVAL_MS. On timeout expiry we shall add
the region to the "to-be-inactivated" list, unless it is clean and did
not exahust its READ_TO_EXPIRIES - another parameter.

All this does not apply to pinned regions.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 75 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  7 ++++
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index cb99b57b4319..482f01c3b3ee 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -18,8 +18,12 @@
 
 #define WORK_PENDING 0
 #define RESET_PENDING 1
+#define TIMEOUT_WORK_PENDING 2
 #define ACTIVATION_THRSHLD 4 /* 4 IOs */
 #define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
+#define READ_TO_MS 1000
+#define READ_TO_EXPIRIES 100
+#define POLLING_INTERVAL_MS 200
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -671,12 +675,69 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
 	return 0;
 }
 
+static void ufshpb_read_to_handler(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufshpb_lu *hpb;
+	struct victim_select_info *lru_info;
+	struct ufshpb_region *rgn, *next_rgn;
+	unsigned long flags;
+	LIST_HEAD(expired_list);
+
+	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
+
+	if (test_and_set_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits))
+		return;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	lru_info = &hpb->lru_info;
+
+	list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
+				 list_lru_rgn) {
+		bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
+		bool dirty, expired;
+
+		if (!timedout)
+			continue;
+
+		dirty = is_rgn_dirty(rgn);
+		expired = atomic_dec_and_test(&rgn->read_timeout_expiries);
+
+		if (dirty || expired)
+			list_add(&rgn->list_expired_rgn, &expired_list);
+		else
+			rgn->read_timeout = ktime_add_ms(ktime_get(),
+							 READ_TO_MS);
+	}
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry_safe(rgn, next_rgn, &expired_list,
+				 list_expired_rgn) {
+		list_del_init(&rgn->list_expired_rgn);
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
+		hpb->stats.rb_inactive_cnt++;
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	}
+
+	clear_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits);
+
+	schedule_delayed_work(&hpb->ufshpb_read_to_work,
+			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+}
+
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
-				       struct ufshpb_region *rgn)
+				struct ufshpb_region *rgn)
 {
 	rgn->rgn_state = HPB_RGN_ACTIVE;
 	list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
 	atomic_inc(&lru_info->active_cnt);
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
+		rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
+		atomic_set(&rgn->read_timeout_expiries, READ_TO_EXPIRIES);
+	}
 }
 
 static void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
@@ -1404,6 +1465,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+		INIT_LIST_HEAD(&rgn->list_expired_rgn);
 
 		if (rgn_idx == hpb->rgns_per_lu - 1)
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
@@ -1536,6 +1598,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 			  ufshpb_normalization_work_handler);
 		INIT_WORK(&hpb->ufshpb_lun_reset_work,
 			  ufshpb_reset_work_handler);
+		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
+				  ufshpb_read_to_handler);
 	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
@@ -1562,6 +1626,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 	ufshpb_stat_init(hpb);
 
+	if (ufshpb_mode == HPB_HOST_CONTROL)
+		schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	return 0;
 
 release_m_page_cache:
@@ -1624,6 +1692,7 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (ufshpb_mode == HPB_HOST_CONTROL) {
+		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
 		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	}
@@ -1734,6 +1803,10 @@ void ufshpb_resume(struct ufs_hba *hba)
 			continue;
 		ufshpb_set_state(hpb, HPB_PRESENT);
 		ufshpb_kick_map_work(hpb);
+		if (ufshpb_mode == HPB_HOST_CONTROL)
+			schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 4bf77169af00..86c16a4127bd 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -121,6 +121,12 @@ struct ufshpb_region {
 
 	/* region reads - for host mode */
 	atomic64_t reads;
+
+	/* region "cold" timer - for host mode */
+	ktime_t read_timeout;
+	atomic_t read_timeout_expiries;
+	struct list_head list_expired_rgn;
+
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -184,6 +190,7 @@ struct ufshpb_lu {
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
 	struct work_struct ufshpb_lun_reset_work;
+	struct delayed_work ufshpb_read_to_work;
 	unsigned long work_data_bits;
 
 	/* pinned region information */
-- 
2.25.1

