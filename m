Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CBDC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F097B64EED
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhBZIhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:37:40 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:28206 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhBZIg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328588; x=1645864588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=528zCyfU9oRPSnjH+yjXj95fhfbazOZYxSMSfzyagJM=;
  b=QYDgxrcRcXSZlciBI0uxT6ePXswWm4R/LLWAz2GkN+AaebbuyMrgdVP9
   esf5VDNgjToVeWgCzJmGnRwft2xLdwJlwMk9m09HNco7iYN22YyB7SrCd
   XfSuqZXynZGgIU0LRR0PX0OAYLwlb3nR2lEw1T9wsSB1jQNhp2JCZuAX6
   f0s6SkfGM0zddJ+48oQn+FE7VcmPtDToChchBMDK0UZNJW1nHFJA7F4eb
   5JRRYh5G1I5tAm96h7akLOeT2vcqPoeodbvM/Kk6az853Vun1cobopqe2
   0B6f8f7Oi3okaRI0z/Bx/ZwO82XJuK9s8gZYJt4+kgCLHraSgIiPo2opI
   A==;
IronPort-SDR: U4mRRF9C/iPTqqN28B3Byj2QKOnyoXoyktEU94alJcMTh5y5ryT/XfJ5FIlZortvpwbXan6Jym
 LUipzZ1ulHonbQtl/enJlQDf2MBLupL2JfpNL/c4GV3tppKw9PuprQ9t//U+RvONfYBDYvSNbg
 oSymjZz82Bojeh30S+IZ+poKRNGbneTvVrgoG3U0d6kCwY7ZoGmCttoqQ6/FNi6BxSOe6fcc6Q
 A8ZJFhu2KKjeDzxULgGxi3NK0cCe3/hqqVvBGPDOD4IT0FFobYTIzrfuF3x2adF3M7y7tvE0TE
 x/I=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="165357049"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:34:44 +0800
IronPort-SDR: 9myq7Io2sF3Oxw528DvjqJjKm/vpTNwpM5WSodeCc/9qu8+zKFWjhjxXWkjwe3S/z6YTZM9W78
 5MbX5/Q+7ZiiG0G/bEEuclNg+BzPTnatfTzj5p6IVEjgP54YzJp74JvLNy+xBW/cTU1S0NYW5U
 /Koi+ecqjmTKH1PQZPTVDf/H8HAaDYkUj5ALxVRZCbDA0/C6/ePPU/ZlSQWkoYiNvngKLrNFuE
 QU237Ti4bT8NssXLuvpxlqnStpt14Cich/bJumeKYQ/FIIh0/kcWTeNFRiYRE86c4oyQ4BbOtr
 aWQ1hD9BGtF2SoyPn5aO5qhI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:17:57 -0800
IronPort-SDR: cx0HsvrWQx+PtOKbVrqIuq1SGMjJEsQYWBiDQAhjsZB0/kZjYOjVJttJX/iuh+qxKN+xI23ko7
 RnfZcs7tSPyqeshZOgM7DoPu3rwyJh0oICDWvMcfj2vGKM+0DSkNYAmfYXHjdyE7fA+OSl0iV3
 Lisrof+LTLwG3b9Q/y1GuZdPoDJBaGdaIA7ZqJqIACXSQta2dlWipKUs/BuNs6OmGd/DP/Yp6s
 mzr3NfMI4B6+z2ptjbkzxWwwmBYcFkbTMOiiuzeNMlzW8wqHNEP7xGrpyEch8W48swbdVTaDXN
 tR0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:40 -0800
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
Subject: [PATCH v4 6/9] scsi: ufshpb: Add hpb dev reset response
Date:   Fri, 26 Feb 2021 10:32:57 +0200
Message-Id: <20210226083300.30934-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The spec does not define what is the host's recommended response when
the device send hpb dev reset response (oper 0x2).

We will update all active hpb regions: mark them and do that on the next
read.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 53 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  3 +++
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index cf704b82e72a..f33aa28e0a0a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -642,7 +642,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		if (rgn->reads == ACTIVATION_THRESHOLD)
 			activate = true;
 		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
-		if (activate) {
+		if (activate ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			hpb->stats.rb_active_cnt++;
@@ -1481,6 +1482,24 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case HPB_RSP_DEV_RESET:
 		dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
 			 "UFS device lost HPB information during PM.\n");
+
+		if (hpb->is_hcm) {
+			struct scsi_device *sdev;
+
+			__shost_for_each_device(sdev, hba->host) {
+				struct ufshpb_lu *h = sdev->hostdata;
+
+				if (!h)
+					continue;
+
+				if (test_and_set_bit(RESET_PENDING,
+						     &hpb->work_data_bits))
+					continue;
+
+				schedule_work(&hpb->ufshpb_lun_reset_work);
+			}
+		}
+
 		break;
 	default:
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1595,6 +1614,27 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 }
 
+static void ufshpb_reset_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct victim_select_info *lru_info;
+	struct ufshpb_region *rgn;
+	unsigned long flags;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_lun_reset_work);
+
+	lru_info = &hpb->lru_info;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
+		set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+	clear_bit(RESET_PENDING, &hpb->work_data_bits);
+}
+
 static void ufshpb_normalization_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb;
@@ -1804,6 +1844,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2018,9 +2060,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
 		INIT_WORK(&hpb->ufshpb_normalization_work,
 			  ufshpb_normalization_work_handler);
+		INIT_WORK(&hpb->ufshpb_lun_reset_work,
+			  ufshpb_reset_work_handler);
+	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -2120,8 +2165,10 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
+		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+	}
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index b78ccb67b765..60bf5564397b 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -121,6 +121,7 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+#define RGN_FLAG_UPDATE 1
 
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
@@ -217,8 +218,10 @@ struct ufshpb_lu {
 	/* for selecting victim */
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
+	struct work_struct ufshpb_lun_reset_work;
 	unsigned long work_data_bits;
 #define WORK_PENDING 0
+#define RESET_PENDING 1
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

