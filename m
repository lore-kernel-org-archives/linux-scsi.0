Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CC0C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43BC764ED4
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhBBIcq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:32:46 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10223 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhBBIci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:32:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612254757; x=1643790757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FeLo9NCwnuPi6CmS9o6Drvw/zKEYJuBGxJNimeytX9E=;
  b=Tt+FevWW9N3jZ7YdtLNrWEw+DTDoz/xNTLQ3tfSdR9ZZygADRqjJpm/b
   RnmOpGjCdzUdWQX1VSWGb/pGM7JIYCzBzl3F71bP0jhCOxOANvd62/k7u
   FodhHBq6r7BkEg7Y9PwZPJL9StUZOusX/d/hfZ1D0N6ZiwSpgfSrjrdYm
   iLPEr0c8NJz853Bt+Fs5OgTqQQzbnoq8+kujbZdvSER+Wg7KyMh8CzX62
   RvyCuOaV1oT9IXIL3qGb8X2uaTpZf852GNU10zbnRbvWBvlsdDnLlvheS
   aH4yVKm6/grxD0NgmGwFR75xcbBaxiX9mpKmUogdDqcfcXUAFueJgziH2
   g==;
IronPort-SDR: 45YCI5j8s/V69febnd4j2hnKR6lITk/NoxFFcd5LYn96dToxsu1WlVhWF0kpN3+xqagGM/BY1P
 1qQIPsom6uZBSM8qHF15VxFDnfr8vC0/2aUk1flJSNOX09y+TNt2q7eG/w/we9W9+sEW1F34Yl
 K4vdw1WB62XjG91GS9lWVxtW69MlLS9pKkvMp812k73RJFSV6gz6gYVnfB6QCg0i92gJ3PXVaF
 CCrHVICtA/JOR6KMXZFc/Y6JaqPtX3WTid+w5ypuIB6PQIF8uR38krJ1C2mhtui6BfNRoJmUNO
 1+M=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="158900059"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:31:32 +0800
IronPort-SDR: 9894MdSSSX/ibm93CEGga+UEPSVig1m2SR6vRR8FK5/5Ai+siGnTG3hIvXcDUJk8j94OCaFG+4
 X3qc/XqLeCm7cyabtsrY+e3ayrqJdeRlY8GC0K6KINGlUUhibUIOzipCjgInBR4/OTiU9XDCN3
 NhUeBDPEAH33p55TniE+/hoL0wauAin8OVyv6iP0MFSkl4NtUEEZHmkB2cxQu54Ro2myo5IhKB
 4T+jzX4c6+tsXY4kOePZkTYMyaPyWB1mGUk9q6fo8wihrO2znx4KN2PKQ8J48hH0INJr/8aXdT
 0rKWd1Y4zcRYdXzPDOjR05Si
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:15:41 -0800
IronPort-SDR: oq4BV3UhBdGt31gfLZT5QVHbpBc/l4o9eoe3Ie2HkOYbOMKziKxd66B+HCcHuSzVwnW14i2hIk
 6mPT4nt+uoyBZEDhlAYtx4OQx0QNu1fvxbc64unHWgaUgar9cP6iCF1pbVrdCyDyUfbF5MJGKD
 npYjrALIiKpalsdARpm3/k8T5n2dwGkICEO29xB+M0C1fjwjGeSfVw5m2WQtJWpEXFxrL0LIB0
 BeaeM2QV3+/daxHs4hHDEX8NRsIT1zpaUaCCy2619OhvRMox43zZFZp4kBkR+VxE3DYZroVhWe
 lc0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:31:29 -0800
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
Subject: [PATCH v2 7/9] scsi: ufshpb: Add "Cold" regions timer
Date:   Tue,  2 Feb 2021 10:30:05 +0200
Message-Id: <20210202083007.104050-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
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
not exhaust its READ_TO_EXPIRIES - another parameter.

All this does not apply to pinned regions.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 76 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  6 ++++
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 28e0025507a1..c61fda95e35a 100644
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
@@ -676,12 +680,69 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
 	return 0;
 }
 
+static void ufshpb_read_to_handler(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufshpb_lu *hpb;
+	struct victim_select_info *lru_info;
+	struct ufshpb_region *rgn;
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
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
+		bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
+		bool dirty, expired = false;
+
+		if (!timedout)
+			continue;
+
+		dirty = is_rgn_dirty(rgn);
+		rgn->read_timeout_expiries--;
+		if (rgn->read_timeout_expiries == 0)
+			expired = true;
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
+	list_for_each_entry(rgn, &expired_list, list_expired_rgn) {
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
+	if (rgn->hpb->is_hcm) {
+		rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
+		rgn->read_timeout_expiries = READ_TO_EXPIRIES;
+	}
 }
 
 static void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
@@ -1416,6 +1477,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+		INIT_LIST_HEAD(&rgn->list_expired_rgn);
 
 		if (rgn_idx == hpb->rgns_per_lu - 1)
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
@@ -1435,6 +1497,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		}
 
 		rgn->rgn_flags = 0;
+		rgn->hpb = hpb;
 	}
 
 	return 0;
@@ -1550,6 +1613,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 			  ufshpb_normalization_work_handler);
 		INIT_WORK(&hpb->ufshpb_lun_reset_work,
 			  ufshpb_reset_work_handler);
+		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
+				  ufshpb_read_to_handler);
 	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
@@ -1576,6 +1641,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 	ufshpb_stat_init(hpb);
 
+	if (hpb->is_hcm)
+		schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	return 0;
 
 release_m_page_cache:
@@ -1638,6 +1707,7 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm) {
+		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
 		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	}
@@ -1748,6 +1818,10 @@ void ufshpb_resume(struct ufs_hba *hba)
 			continue;
 		ufshpb_set_state(hpb, HPB_PRESENT);
 		ufshpb_kick_map_work(hpb);
+		if (hpb->is_hcm)
+			schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index e55892ceb3fc..207925cf1f44 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -107,6 +107,7 @@ struct ufshpb_subregion {
 };
 
 struct ufshpb_region {
+	struct ufshpb_lu *hpb;
 	struct ufshpb_subregion *srgn_tbl;
 	enum HPB_RGN_STATE rgn_state;
 	int rgn_idx;
@@ -122,6 +123,10 @@ struct ufshpb_region {
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
 	unsigned int reads;
+	/* region "cold" timer - for host mode */
+	ktime_t read_timeout;
+	unsigned int read_timeout_expiries;
+	struct list_head list_expired_rgn;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -185,6 +190,7 @@ struct ufshpb_lu {
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
 	struct work_struct ufshpb_lun_reset_work;
+	struct delayed_work ufshpb_read_to_work;
 	unsigned long work_data_bits;
 
 	/* pinned region information */
-- 
2.25.1

