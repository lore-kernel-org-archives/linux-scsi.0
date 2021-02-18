Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C79C43219
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2043A64EAD
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhBRQ6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:58:24 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29743 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbhBRN05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:26:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654816; x=1645190816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x18Znh/eyS+r6PchW22MgvwY6wKosNieDBsoZ+mEnvA=;
  b=HDX9DHTgeTJQsN+0QdmskZ9hkLPVF45QRHlFbE4PVb3qpFzAUSglLQXA
   ejC9dv2ISi+M9bXLbi0R7TnwfLGiPspyqI0Tel5twYMX7SORIGjnOuT9W
   z2lYmQvpUwH12IDGaf5Dx2zs02Gn+sSO147d6/1bXfzoIdHKJ0vnWsAbu
   rGI3AmMmNU8tH6nVtKWjdILLy0LyQ5ZUBxb8WSEq6bTzqMgbopwcnbJIa
   zIlpVkRBv16320y2jN3+gO4HZoeNz/4BABvZ5dn5Jia0aKfzj1V1jSbn0
   P42BWL21Ekzif2Q3VAIB3fZFJuFRhojPGWqcerZnAVcRJmlzYIH1rPyG5
   Q==;
IronPort-SDR: NeTuhu519lS22iRcqC0bjRg9csyabwQenq8Dt7F8Ca4tqIHF6+VXA52jwP3fcTCWG709epD2E0
 nSBGau2TWRo0HqRDPiJE+GXfauLxo+RskGnuiUTiPDjwsJBkBFeBB4zlFeAK1hdiAjOzLwPKzs
 7IVWxQnHZmBnAuKoEo+RfSvNOLpgyeBH0iqGmroTfUMXspzKCc4SSmnyQgmQ9YnKHoNNh7z7Kx
 PKk+q8sGjAt+ku9C2j3oXR7qFKd6UHOUHc3mhHRgLVmkBF9mXz1yElx3MCKequTot+cMdmIRkl
 17U=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="160277233"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:21:28 +0800
IronPort-SDR: oEDoTX5Fry1I8kZZiRf9Cl2SpnL7MDWm0Tk6EGft/1d12iUiYY/PJnJqRAHQLbCOw8HEwWxYrT
 H5a4Ic93/wT9ZBDgEAiaYBW+dvkNgJc+UBTxG+iVUap6Hqlg76j5mAA0q2/tQfEzV5Kd4e99Vr
 pmoMoa2SkFDCXLJwRqVKfm/2GJK9fv0QiGPBVMwGENRWo9rjEDLOZ/VaLDnLRDggUpwKzskdYK
 tlh+mlJPlwJTYQxKEp2gm8KbIGBPZURqCSLxnxCg5rx8J9PdL328kNRoZxBd3B8s50tzPG28nX
 u3XmtZhAA9fKZxh8TAOdIgT4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:04:54 -0800
IronPort-SDR: Zx0QSQ/A8K9zgRhd1SXrrWcVe9csB48I/+oAF1LzTO7INkTaaioD37VBXB/fWs76j5C8VE/Vr1
 PL4a4TJ5imT0xKGDfyWUqaKtIsuYbu4bZT8LBuT/GfOj71FOEHLc4g9QCX+TmyMdyRKSOWDtpY
 Ri6r1wwbjNUxjz/p0KwGqLUkagDsG93wvBI1S1EykoQ+Rl9OX1u9ed6Yh2CFLx6t+YUbPCtkUI
 iPIvEYnCGV6zZhjW6Y053mUZw6xXF5+2KqQpCC4acdcELUOcheXk/pVwFm8euWQt7XWAenVlDE
 s+k=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:21:23 -0800
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
Subject: [PATCH v3 7/9] scsi: ufshpb: Add "Cold" regions timer
Date:   Thu, 18 Feb 2021 15:19:30 +0200
Message-Id: <20210218131932.106997-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 70 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  7 ++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 15755f677097..9a1c525204f7 100644
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
@@ -1029,12 +1032,64 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
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
@@ -1778,6 +1833,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+		INIT_LIST_HEAD(&rgn->list_expired_rgn);
 
 		if (rgn_idx == hpb->rgns_per_lu - 1) {
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
@@ -1799,6 +1855,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		}
 
 		rgn->rgn_flags = 0;
+		rgn->hpb = hpb;
 	}
 
 	return 0;
@@ -2017,6 +2074,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 			  ufshpb_normalization_work_handler);
 		INIT_WORK(&hpb->ufshpb_lun_reset_work,
 			  ufshpb_reset_work_handler);
+		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
+				  ufshpb_read_to_handler);
 	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
@@ -2051,6 +2110,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	ufshpb_stat_init(hpb);
 	ufshpb_param_init(hpb);
 
+	if (hpb->is_hcm)
+		schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	return 0;
 
 release_pre_req_mempool:
@@ -2118,6 +2181,7 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm) {
+		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
 		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	}
@@ -2228,6 +2292,10 @@ void ufshpb_resume(struct ufs_hba *hba)
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
index a3b85d2df224..75093271d12b 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -107,6 +107,7 @@ struct ufshpb_subregion {
 };
 
 struct ufshpb_region {
+	struct ufshpb_lu *hpb;
 	struct ufshpb_subregion *srgn_tbl;
 	enum HPB_RGN_STATE rgn_state;
 	int rgn_idx;
@@ -124,6 +125,10 @@ struct ufshpb_region {
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
 	unsigned int reads;
+	/* region "cold" timer - for host mode */
+	ktime_t read_timeout;
+	unsigned int read_timeout_expiries;
+	struct list_head list_expired_rgn;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -217,9 +222,11 @@ struct ufshpb_lu {
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

