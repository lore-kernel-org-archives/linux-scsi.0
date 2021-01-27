Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9876C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4B5207BC
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbhA0PO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:14:56 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25658 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhA0POm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760482; x=1643296482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FjmDrGo/SvhF+h3fNWWxJ6aaSFusGpBlATpzroPSKmo=;
  b=DRM5r0zABkBd8ClhyevDx3PIDVlIhlA2+xnMqj/yphmsn7XFB7FEqI8s
   M9XFeOpe7pnA0Xa39TikZCbqIextJqU0tXI/GQesp6kMTtcmDA9G85eKS
   kE2jKVWw6fBz0Vn/KgGHe8FkSDLE3RTRZCX2xT/a2jIBFiSXyf/UPqtA0
   MsQBKTkCl1VV5MyE2SZUTOh94RybmFX+NSoix2MHV7UsQdGi3lmSJJxY0
   356fojHpj9QzCnjZSbVz17hew/OnxNkTme17vt0c5lf9DqhgWA8o00iJG
   z7f8+13ooVfY/Vik4C3Pvt6RcO/bUxveuquf0yvZsldWWqM+6H+JAEirj
   w==;
IronPort-SDR: 3b2P9lR0BtvkgvOt+sjuadIg4djg/mdv+yn7B8NK/r1xRvjPPO5gGYtWptdFFdi6McOaNIB8fi
 Yfg30FlHpiRT8HnfDw5frC/aNHwhstet4LpjqkXbcddzt56YHML2EtUtoej7RW4n9k9x4oWfq4
 9bjDdETMp6NMUq0DYnLYvRcIJduDsCAU/tGN2HVtDOaBEpPXk46f6iV2LxLghFLcsDUraBs6Do
 vKuoV+zCmVpJwujXXbO1YkZ5HgPX23Cx5Y/jzjJjOjpILyWy/+vyMi6flxxGl4ugXXXvYsgiwJ
 oXE=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="159631226"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:13:31 +0800
IronPort-SDR: HoRmLC8W69ki6Y0cJnVu5SbJBv0q1aDgXtfejaAwYJys8YhCraYP76CJ/mfbmGz/PztZRzETtB
 TUR8mI2a2YzG17X5qTtq9hrVCHngStcM7QGKWoKpZwBftMmSp/jIXWhzKLUwD+i5OFBm/1gLSv
 UrGnsuqgAJliFWUSbre4tD3Q1iKJeOgz/dhJwygWSskMNmQRnQTvNzIfKvfwWOwG1fLkePT5sL
 U3mwiOPqbttVZi1iUxn9FyPZ0hCm/Ad5c8QAH+qrJSQZresTdq6WYR/F9/l+ipSQvZ0cKUuhD6
 laTfWgr5AdIXPoAtrAyL78R/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:55:50 -0800
IronPort-SDR: c30zxQEYMLgwpBwamwYeHZowFmVWOvSWWE9eASk7rPG3iaMTAolktzVZBN6YumzmFtTHW9jKcm
 JW+AW9Yg6SclhiRov4LREPL11BDuCWQYJHDT+OpIPnhHNkUfyizwyzbkKYmYw7Zt9hW/SPYUzV
 KJS+2yQRzaJOw60FyUUeHarEjNkOSD3Q00JB0aLZ4irQ/I+d0DkeMRrjHa9UXKYF4jyb5JI8yI
 boI7x/6CgvFbghDdmIlbcyT0Z076wWEUyRRMQSFdVxSBCmrwDaFRPQ1tlhSsk1Z/e4nqJZm6xF
 eYg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:13:28 -0800
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
Subject: [PATCH 6/8] scsi: ufshpb: Add hpb dev reset response
Date:   Wed, 27 Jan 2021 17:12:15 +0200
Message-Id: <20210127151217.24760-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 55 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index c09c8dce0745..cb99b57b4319 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define WORK_PENDING 0
+#define RESET_PENDING 1
 #define ACTIVATION_THRSHLD 4 /* 4 IOs */
 #define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
 
@@ -344,7 +345,8 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 * in host control mode, reads are the main source for
 		 * activation trials.
 		 */
-		if (reads == ACTIVATION_THRSHLD) {
+		if (reads == ACTIVATION_THRSHLD ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			hpb->stats.rb_active_cnt++;
@@ -1061,6 +1063,24 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case HPB_RSP_DEV_RESET:
 		dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
 			 "UFS device lost HPB information during PM.\n");
+
+		if (ufshpb_mode == HPB_HOST_CONTROL) {
+			struct ufshpb_lu *h;
+			struct scsi_device *sdev;
+
+			shost_for_each_device(sdev, hba->host) {
+				h = sdev->hostdata;
+				if (!h)
+					continue;
+
+				if (test_and_set_bit(RESET_PENDING,
+						     &h->work_data_bits))
+					continue;
+
+				schedule_work(&h->ufshpb_lun_reset_work);
+			}
+		}
+
 		break;
 	default:
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1193,6 +1213,28 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 }
 
+static void ufshpb_reset_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct victim_select_info *lru_info;
+	struct ufshpb_region *rgn, *next_rgn;
+	unsigned long flags;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_lun_reset_work);
+
+	lru_info = &hpb->lru_info;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
+				 list_lru_rgn)
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
@@ -1379,6 +1421,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -1487,9 +1531,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
-	if (ufshpb_mode == HPB_HOST_CONTROL)
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
 		INIT_WORK(&hpb->ufshpb_normalization_work,
 			  ufshpb_normalization_work_handler);
+		INIT_WORK(&hpb->ufshpb_lun_reset_work,
+			  ufshpb_reset_work_handler);
+	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -1576,8 +1623,10 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
-	if (ufshpb_mode == HPB_HOST_CONTROL)
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
+		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+	}
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 47a8877f9cdb..4bf77169af00 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -183,6 +183,7 @@ struct ufshpb_lu {
 	/* for selecting victim */
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
+	struct work_struct ufshpb_lun_reset_work;
 	unsigned long work_data_bits;
 
 	/* pinned region information */
-- 
2.25.1

