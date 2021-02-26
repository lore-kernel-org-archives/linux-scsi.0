Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CC9C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 444DE64EE7
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhBZIg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:36:58 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9469 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhBZIgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:36:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614329755; x=1645865755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DFeqoYX2xt6ByGOqkI5U/t4VJINkAp74Ejd4zvQt/Ko=;
  b=C1UeYIubhcGwPpklMNfNwrtG7JLuB6lP7/EuF8XVHDTYXJNSzt1PyBRa
   erQq5maCgRVUX++2d6UNBkyriRTuUDLbtNlupE3rwat9etde52lTkKbA6
   i6JcwW2mBzbb9lNrUzEpTISgt3I1oSZmBmGmKcrrWMrBf5GTQzYoYfYSn
   GhZwKBdUcNhsKrG7J8qWyC5Nr+FOO/PUFIpAKeqSPkqNkXeBabmUso/2S
   7MyflACiWkLYFCRRgIBPJEvoC3DXt6i/x+G0L2L2I1Td9skkowxRhFB1m
   /XdHNlKWYtkMUuj8xAzvn9b51Kf2zfxR1ZU7DZup4h3ZxNsdcYzvynr3P
   w==;
IronPort-SDR: izDlD/KSlIRgniD71iDNFySPKlxnv2u/kLE//ZZxQ44LhXI8U1SyFy8LyMlEXDP+0YHUVBi1uM
 KnLA8GnsDYYrYKYdUnxtcxNPGwCCDHrel1VaVLLkam33JoBoM7l1kn6GwPnxdZ1fj5MouNlgCZ
 oyufDLPBT0TAUqo7VvrALt8LvW2eVaNvSEno7WIHuEU7Xg+qUaKNhn8Kp5Kd8PxRluluATtpgV
 F9XqtptpC+MLxYKH71YJQkyvcy1FjV3RcP65SFk6QxOJe7glplVdfb3ATY3vAKBE8+HVbtCARk
 osM=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="265100199"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:54:05 +0800
IronPort-SDR: vqc74GftROtuoxmzdfVfXaOTnasraDe4Fv+dyrZ9MgIurAWXM+9CS0PR83i25R3pcbDr5yoEvK
 JEdkybaqqvw5EgS3ijgRyKLFu5qUO7ElpGoGv6/Xc9hpcY/hWBVibyb55ykri4ejxRM8NGpovd
 N7NxlRSmwTmwCbvUWHuRCXxmQ6H5TlL1sY8zq4dF9MPad8Mqek2btzfg0bhtgED4Ah3yznZ7qZ
 YOYkAJFoQOLNsE04t48Z69zmJOSVuA1AfdIeMZxijSLJH85WtiVES7WOMAyFhopbONMvqemiys
 JXugZfBsNRTrmKgPiLjqBvsM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:18:07 -0800
IronPort-SDR: WWi7moUmICodnrZ02il9Ummf0fmzRk6q+CwUGGV7SHQW1vorWVF0FIL3z5cs205bwhfGU5givQ
 XIs2j2860KAzcWceztuNeGLVVJZd7icBJi67Xf+4R2/Bglo51UwXWMEUhi4DI4fLYgwqFpA5My
 7LAk88wAKQl29tB6cF4O0IBHsrSLcJ2rQs6bSSYFNrVZhY/u321PvHO/ob6sQDUu4cJlb0vE06
 6aIm7w5ZLPHVmMgCdBZAsKvOJ7x3rU4mH+mTvZA4fFL4hWpVmgj0gfEugFvDDFu+Jh6AR+t/I6
 wx4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:49 -0800
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
Subject: [PATCH v4 7/9] scsi: ufshpb: Add "Cold" regions timer
Date:   Fri, 26 Feb 2021 10:32:58 +0200
Message-Id: <20210226083300.30934-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 70 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  7 ++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index f33aa28e0a0a..5b76341fd558 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -18,6 +18,9 @@
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
 #define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
+#define READ_TO_MS 1000
+#define READ_TO_EXPIRIES 100
+#define POLLING_INTERVAL_MS 200
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1025,12 +1028,66 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
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
+
+		if (timedout) {
+			rgn->read_timeout_expiries--;
+			if (is_rgn_dirty(rgn) ||
+			    rgn->read_timeout_expiries == 0)
+				list_add(&rgn->list_expired_rgn, &expired_list);
+			else
+				rgn->read_timeout = ktime_add_ms(ktime_get(),
+							 READ_TO_MS);
+		}
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
+	ufshpb_kick_map_work(hpb);
+
+	clear_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits);
+
+	schedule_delayed_work(&hpb->ufshpb_read_to_work,
+			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+}
+
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
 				struct ufshpb_region *rgn)
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
@@ -1825,6 +1882,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+		INIT_LIST_HEAD(&rgn->list_expired_rgn);
 
 		if (rgn_idx == hpb->rgns_per_lu - 1) {
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
@@ -1846,6 +1904,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		}
 
 		rgn->rgn_flags = 0;
+		rgn->hpb = hpb;
 	}
 
 	return 0;
@@ -2065,6 +2124,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 			  ufshpb_normalization_work_handler);
 		INIT_WORK(&hpb->ufshpb_lun_reset_work,
 			  ufshpb_reset_work_handler);
+		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
+				  ufshpb_read_to_handler);
 	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
@@ -2099,6 +2160,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	ufshpb_stat_init(hpb);
 	ufshpb_param_init(hpb);
 
+	if (hpb->is_hcm)
+		schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	return 0;
 
 release_pre_req_mempool:
@@ -2166,6 +2231,7 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm) {
+		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
 		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	}
@@ -2276,6 +2342,10 @@ void ufshpb_resume(struct ufs_hba *hba)
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
index 60bf5564397b..8d14f01b0e7b 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -109,6 +109,7 @@ struct ufshpb_subregion {
 };
 
 struct ufshpb_region {
+	struct ufshpb_lu *hpb;
 	struct ufshpb_subregion *srgn_tbl;
 	enum HPB_RGN_STATE rgn_state;
 	int rgn_idx;
@@ -126,6 +127,10 @@ struct ufshpb_region {
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
 	unsigned int reads;
+	/* region "cold" timer - for host mode */
+	ktime_t read_timeout;
+	unsigned int read_timeout_expiries;
+	struct list_head list_expired_rgn;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -219,9 +224,11 @@ struct ufshpb_lu {
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
 	struct work_struct ufshpb_lun_reset_work;
+	struct delayed_work ufshpb_read_to_work;
 	unsigned long work_data_bits;
 #define WORK_PENDING 0
 #define RESET_PENDING 1
+#define TIMEOUT_WORK_PENDING 2
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

