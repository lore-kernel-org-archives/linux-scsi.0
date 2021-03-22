Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D17C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1EF960233
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCVIMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:34 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12293 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhCVIMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400726; x=1647936726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uJgEjQUYZcrxmYjYGP2c2q06TyiCWiSeHVSw4+z+q90=;
  b=TyrFZvOVbgfsOGae03hV+pbB0yrNtPCE921YsbwYRIMmDeUiWwVX/wk5
   aQVCTZbuji1xGgzHYBIQ1F5/2j6V9fisaK4jUtb89FGavIC1hOitUcHeE
   NckIP1ZDky4fscSPlAMEp6fgC6xwvkC2aSK++OiyG7+6uQkbtKYiLYUUe
   9hnxCy3g7NgXzeAz+LxocRu58hqUk8hcKuZWFK5EKxPcsMAnjBb0XOpiR
   KYK76plw/bGanCltj7zlxBgDyNciyGIb6Gaa0POf5haYsa3nBKB4k0hLy
   55UtKWJpx376IdhatTMioFh0H8/GlinCUgu2s4ogDgnv188yJzW6BPCYT
   w==;
IronPort-SDR: s8wJtpv0MACp2RSGprwXpXaMG07ADzcqxLD+mbdoUknailIWZ5nSQQc+LFhjBnU2FhS/yV/62k
 md4xJMPDSI/QSrI7WkO4FtR9p4GldyQIflWnzt3bIDhz7vtE/v5Sq0W5gFIKkFD+J4NcOKb6oG
 p/bJiUlI7beN+VX54m49R2NHp3nOcuSdER1OA9MdFZj1x5usY8Mm/glcAFHYJ8hURMUi1gHlp6
 Pu1X4VLl+jdEx8yxnBaaJuS2GFltsdStdNjoTQQuoCYObxpO7PdGl/J7BZ8AUiIm6iEbt+j5SL
 qTw=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="162683038"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:12:06 +0800
IronPort-SDR: R0gLUM4SUok1X0xZ5wZwAAujKetrppywXbV6kk8ohM4vGtjSvPdiAHK0IwMJPtpvzL8RhG1FJu
 J1qrvAoEvj9SXfRaz/1gP5hFSEcJkKcHCGoVOyJkcjjlYmC4FhzMKP4c2AEHnw2G5tmwPGrtTS
 xy2optgxtuvxva/6f7sWaTDIHaDxuzQy561GvKI/Tm2DowP0wG+WvOLrSzxxYxrtO6SPCuHWgk
 OHNhLA1oB+IaZd+AjwS2TnL9Hdam/BiN9cWqoPzq/qlw8P/r+SGnE3MBfwgXNv7QzotFX2/9gS
 nHOvEt5AawGom4asiOewQMC5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:52:35 -0700
IronPort-SDR: KYLY9AyOuu9gk2nVcI2uAdIX0bMK9lOjNXwFta+myw9MatHGuFhapjLWxDs8ya6f6vcAwbCp8j
 bbrTxr4WY8XPfDvYC3f0IdiDFhFLWa+wr/resL6yXn8jWD4OlbUhUOujzED5zRtjfhuAOjAbK1
 AUyfrJbJZo6Se+JovlnI61A3lFZK54daCHFfUJveLqKva0ePa9gqAXogOlo3iF/WSvHcIid78K
 gJv9q8vBPFLIGlAum99MOUmhJyi+6fG7iL4gtNmF3QXhmBQNXobOxIoRcnsxhrH2Nt+aYbocI9
 HgE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:12:02 -0700
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
Subject: [PATCH v6 07/10] scsi: ufshpb: Add "Cold" regions timer
Date:   Mon, 22 Mar 2021 10:10:41 +0200
Message-Id: <20210322081044.62003-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 74 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h |  8 +++++
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 6e580111293f..4639d3b5ddc0 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -18,6 +18,9 @@
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
 #define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
+#define READ_TO_MS 1000
+#define READ_TO_EXPIRIES 100
+#define POLLING_INTERVAL_MS 200
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1021,12 +1024,63 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
 	return 0;
 }
 
+static void ufshpb_read_to_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
+					     ufshpb_read_to_work.work);
+	struct victim_select_info *lru_info = &hpb->lru_info;
+	struct ufshpb_region *rgn, *next_rgn;
+	unsigned long flags;
+	LIST_HEAD(expired_list);
+
+	if (test_and_set_bit(TIMEOUT_WORK_RUNNING, &hpb->work_data_bits))
+		return;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
+				 list_lru_rgn) {
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
+	list_for_each_entry_safe(rgn, next_rgn, &expired_list,
+				 list_expired_rgn) {
+		list_del_init(&rgn->list_expired_rgn);
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	}
+
+	ufshpb_kick_map_work(hpb);
+
+	clear_bit(TIMEOUT_WORK_RUNNING, &hpb->work_data_bits);
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
@@ -1803,6 +1857,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+		INIT_LIST_HEAD(&rgn->list_expired_rgn);
 
 		if (rgn_idx == hpb->rgns_per_lu - 1) {
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
@@ -1824,6 +1879,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		}
 
 		rgn->rgn_flags = 0;
+		rgn->hpb = hpb;
 	}
 
 	return 0;
@@ -2047,9 +2103,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
 		INIT_WORK(&hpb->ufshpb_normalization_work,
 			  ufshpb_normalization_work_handler);
+		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
+				  ufshpb_read_to_handler);
+	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2083,6 +2142,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	ufshpb_stat_init(hpb);
 	ufshpb_param_init(hpb);
 
+	if (hpb->is_hcm)
+		schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	return 0;
 
 release_pre_req_mempool:
@@ -2149,9 +2212,10 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
+		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
-
+	}
 	cancel_work_sync(&hpb->map_work);
 }
 
@@ -2259,6 +2323,10 @@ void ufshpb_resume(struct ufs_hba *hba)
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
index 24aa116c42c6..c2821504a2d8 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -111,6 +111,7 @@ struct ufshpb_subregion {
 };
 
 struct ufshpb_region {
+	struct ufshpb_lu *hpb;
 	struct ufshpb_subregion *srgn_tbl;
 	enum HPB_RGN_STATE rgn_state;
 	int rgn_idx;
@@ -128,6 +129,10 @@ struct ufshpb_region {
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
 	unsigned int reads;
+	/* region "cold" timer - for host mode */
+	ktime_t read_timeout;
+	unsigned int read_timeout_expiries;
+	struct list_head list_expired_rgn;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -219,6 +224,9 @@ struct ufshpb_lu {
 	/* for selecting victim */
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
+	struct delayed_work ufshpb_read_to_work;
+	unsigned long work_data_bits;
+#define TIMEOUT_WORK_RUNNING 0
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

