Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F592C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D80164F25
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581545AbhCBS6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:58:24 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31299 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351130AbhCBNb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691916; x=1646227916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j6DLWYgVXFPTG7STfqj4A3+JM3M57pgEcTH+5GaWOkI=;
  b=EXvlj6uoRWRO42s7y0SOTU8U2tdNyuySLJP9vXSXudwmAkYKp5cpKkyQ
   yxGC93EiFQLDsh2D/nuw0iB5B+IhfZ3klejs0kM1URBhQdY95BpZELyXl
   YoHbu2JIiM9FhOhGWKZQJ9WebqVOrA/wK227s5EDRvDQYANQz3a1Yrffi
   V1JBM2WRRrtyKIcp0knE60doQxjOOTtEBT1i/XQlzCtbOSCRwJDL+N/qM
   vD4qnah32n8Rs36fklwDrRRdymDcThEW7fJrHuo8erymTROercrCz6c2F
   E0C+Np3TNdbuvamADbHh1W3fL9LJlxMDciJddIoLA+nbyeDHBalC2P3bg
   Q==;
IronPort-SDR: rYQZpTTUZ/z9HhZx2tcbvW0iEjgGqBlze9Rm0QUAIxAskpD4vmpLUerg6KQi28/7X4/biq0JWA
 sMr/Un/dwXl5rpw53nXgXkuU1jAJAdeoUZPYeRoQUQqOd+QNu5GbwJVSR95mo3jCDEL+C25UWv
 5cyroLeXpFcpSR1pf/ILEgf8dt/ZZR4sYsSr1ZbohinwQSYWB8o7FeV3eqvJxcgFrNREx/t+ET
 /VVVmBCsRcwMIlsBujVIkAl6Zts0JjcT2DxFRwfFHzJPARVT+iN4FwvWmUzyiC8bodE4ntkTjB
 6PI=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="161146243"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:38 +0800
IronPort-SDR: FoVxyRPIcO8CLcYb3r2s2RAWvNBrCJCHuXGaaGb65GyVl70Z+xAIemjsNPmsrJOkL/fxlkC4LV
 o4HgHevhUygtZP74ArZgmWkUGKKTv8W21CQrtP7iSYCVf2oiibqMfxyg0usQiUL+YDIzoOXx3r
 o0kIDrkAZgQMezs0qionlwtDE5cHtfIW47qIW2WXWA/lZ6L4yGxqhS2PBlYQpnceM8xuYF26E9
 BQVXD7QZSa8tSYajjLmekc9jB99LAshZDfZXGGWPuymPoZoRPvDTYAm2XH26DDV3J65MwcPbp2
 Dveo9SVHmd/lL3+Y7vO6N88N
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:07:54 -0800
IronPort-SDR: QFFw73nbnDnCFuZd2Z5CgDkyl/PwrTYKqPR/bzezOf49rKPkHtGQXwZPK4vNs3jJm2aGOsbDuj
 eaTZ2OSjnx+QDOazkyJ4gJE5F0VdAMT2oNyqLJa+rOqC0yFVr9nsqOebnnpue/Y46UYmSIMPYw
 QTGT2r+nl8b1o6m9X/uB54jj1FUalj9C+3/gfRvwmO9EpAOC/CUSwSzdZ15sNd4V0epHcangCu
 MKWvaQEvyKkenvRdinZe4c0nUpGQZd1ol+dY4NQWrMwV+7N4tW3SXpSIpjascwmg8xTPx4USO5
 /34=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:35 -0800
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
Subject: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Date:   Tue,  2 Mar 2021 15:24:59 +0200
Message-Id: <20210302132503.224670-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 47 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  2 ++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 0744feb4d484..0034fa03fdc6 100644
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
@@ -1480,6 +1481,20 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
+				schedule_work(&hpb->ufshpb_lun_reset_work);
+			}
+		}
+
 		break;
 	default:
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1594,6 +1609,25 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
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
+}
+
 static void ufshpb_normalization_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb;
@@ -1798,6 +1832,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
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
@@ -2114,8 +2153,10 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
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
index 84598a317897..37c1b0ea0c0a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -121,6 +121,7 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+#define RGN_FLAG_UPDATE 1
 
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
@@ -217,6 +218,7 @@ struct ufshpb_lu {
 	/* for selecting victim */
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
+	struct work_struct ufshpb_lun_reset_work;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

