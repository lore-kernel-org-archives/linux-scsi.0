Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47756C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E094B20771
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhA0POc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:14:32 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50687 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbhA0POF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760444; x=1643296444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a+gWe1zrtM/8RLwHT911hun5GdaHlKNsD1TIXe6zByI=;
  b=buwOj/236dNnjVyNfZd2+PkIcnI/OWh8EnplpA+czUPhiHt1lVFbKclI
   mwEHHfnnjnqXmb4k5qZYKWgSFcwtFHV+Ry53iuijEWRd0mj8FcuQtTc+9
   Zx9NODqTO2GgEvYG9e98fkLw/0kwZqlD5zMaVCo7/82AEtBy7UeiIQiO+
   niontr9qni/GY7vI/7MbnmNBJSl8UAhy4wGDc+0K0V9sXoZfW7vxF50Wv
   9ztl7FBGowAYLA6iy8NRLBIEmrUWG1/0gZnA/+RjAjqM8e7S3vf68Ox53
   s9fyUftJFJ+GwjmjPoVw1TBxxPW+9+a151YPqQgXMUPz62Wqbu1GSrDyB
   w==;
IronPort-SDR: qDfAqTVYjZTmh8CrmAHISAenGC47nLLXsxjTZotaOmLfqUdSTEZ8zFTh+BZOGqXL1OCHszfDJ1
 saal5r2xWEg/4WBn/msOjIW+ZUeVBHALWeWZBx/s5DQMOpDeY7uTPDtuIT48Hd7NnXeqhSQmuL
 nsXsd9QRp44WDdfiCyOUybHgV+4f2ybLPIk9TE6hTsMEAKorTTDOLs+pObxOzgd9SzSDj2MPvI
 CZ9HMHs1z37QO8VegNP8ODjNFaBgMQJhNMMfdUK2Lu8htlwTn6hWalBP4c/mwM1wnBipMONzNV
 Eao=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="158455365"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:12:57 +0800
IronPort-SDR: ISRKgmjQpZsI2bGuDLVpQmJKAE49ZVr5m8139S81nAZW71RtzPtF+SLem6KMThTWEPMU+DZg4W
 qtzYJ3uTo4oxx9r42XkyrqCpZ/Z6rajKsVfKKGuVbB9sDouz5Q8xYlqKJeFoei2KaFba39Ahs2
 y14uwTLU8VjtpJDFZf3qazEEIiobBoCQlvSABDwpDMLI6i7emIqKbbNbGr1EFREzQji3AKatSM
 DuUkF+Aawe2rUdx/sHG27aUbyWOBmBwCbpcf9/eOrj3ssi6BVYtkZxoeTsGVzUwknoTyGyqr6E
 64SNskYmKl+WKMrnFe0kGsQ9
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:55:16 -0800
IronPort-SDR: pdTIneKST+RSvixuV5IMDyjTAi3rhAkexGajfSaUmIh1iN1yXX6RTQiilhzkAgp1V8vOrhCvf2
 lbWOXMX3C5XScqt697SLgwjz7FOMAuasp5KuAQxXxo8stPveTXimKJPHPUQS8W4Vb6nOrabjOp
 eYNHElX4TGRdSgDKg0+KNMpC4Edm2TURtkpf93Wiplw0X9Q9JjUBmebHKWVtsrXzQ/PjO0HY46
 YkwWHVu/4vYGb2c0FHMowTiEQx+CswIxzg/1jTKyvOOOxs2bKilrj4dwcLj1YH/dkKcxNCB2+C
 tXs=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:12:54 -0800
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
Subject: [PATCH 2/8] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Wed, 27 Jan 2021 17:12:11 +0200
Message-Id: <20210127151217.24760-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are some limitations to activations / inactivations in host
control mode - Add those.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  6 ++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 183bdf35f2d0..5fa1f5bc08e6 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -140,6 +140,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
+	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
@@ -201,6 +203,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
+{
+	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+}
+
 static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
 			  struct ufshpb_map_ctx *mctx, int pos, int *error)
 {
@@ -380,8 +387,12 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
+
 	WARN_ON(!srgn->mctx);
 	bitmap_zero(srgn->mctx->ppn_dirty, hpb->entries_per_srgn);
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
 	return 0;
 }
 
@@ -814,17 +825,39 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 	 */
 	spin_lock(&hpb->rsp_list_lock);
 	for (i = 0; i < rsp_field->active_rgn_cnt; i++) {
+		struct ufshpb_region *rgn;
+
 		rgn_idx =
 			be16_to_cpu(rsp_field->hpb_active_field[i].active_rgn);
 		srgn_idx =
 			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
 
+		rgn = hpb->rgn_tbl + rgn_idx;
+		if (ufshpb_mode == HPB_HOST_CONTROL &&
+		    (rgn->rgn_state != HPB_RGN_ACTIVE || is_rgn_dirty(rgn))) {
+			/*
+			 * in host control mode, subregion activation
+			 * recommendations are only allowed to active regions.
+			 * Also, ignore recommendations for dirty regions - the
+			 * host will make decisions concerning those by himself
+			 */
+			continue;
+		}
+
 		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
 			"activate(%d) region %d - %d\n", i, rgn_idx, srgn_idx);
 		ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 		hpb->stats.rb_active_cnt++;
 	}
 
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
+		/*
+		 * in host control mode the device is not allowed to inactivate
+		 * regions
+		 */
+		goto out_unlock;
+	}
+
 	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
 		rgn_idx = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
 		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
@@ -832,6 +865,8 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_inactive_info(hpb, rgn_idx);
 		hpb->stats.rb_inactive_cnt++;
 	}
+
+out_unlock:
 	spin_unlock(&hpb->rsp_list_lock);
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 2c43a03b66b6..8a34b0f42754 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -48,6 +48,11 @@ enum UFSHPB_MODE {
 	HPB_DEVICE_CONTROL,
 };
 
+enum HPB_RGN_FLAGS {
+	RGN_FLAG_UPDATE = 0,
+	RGN_FLAG_DIRTY,
+};
+
 enum UFSHPB_STATE {
 	HPB_PRESENT = 1,
 	HPB_SUSPEND,
@@ -109,6 +114,7 @@ struct ufshpb_region {
 
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
+	unsigned long rgn_flags;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
-- 
2.25.1

