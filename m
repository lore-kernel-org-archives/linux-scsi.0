Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C63C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F7464E20
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBZIf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:35:29 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9469 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhBZIfX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:35:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614329689; x=1645865689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+mj9k8DOW2ynjWjt3zJCuC4pRcPAUXqtzLGwdtsx21E=;
  b=QwNqoMw4zyG62bcIjjC/y8ZjNzpd6GpzUPopDu5YkXaZepoLADmk6U5c
   K8++FxJcX9fFXy5g316j0hGwfQUfH7wnLJHZdvFs2SK5TwQ3qsqZTGjNw
   spTSmHfEpojoejC1Nu29H4BcQ7dTxkB1XtJWdPdio+Q2bZrRMPX2bsr21
   PB7dXimttm0c5f8s4GSRkVnprKV4ek6sYQ7XIINL+NOL+vAMwNZLMHZ2m
   6G2CBjnWaafWfTMNgBEOGkooNeHjjKLdIPSot37yxCqFcWYgQy+0a82PH
   gPtZ5Lb5rNvVYZ6VwhpUs1MIReH9vKQrnHCCLoBQT1xUx8D6A9LatDpZO
   Q==;
IronPort-SDR: EdYKVSNaKKBP4XVEQ7mMQ1e92vAggWsg/LXDNRBljwO1CbdwXws2V5+Hp87BAletj7a7cBkCHY
 mvdDcyMXWOsUvcATLsCyfRGQITJRp1W6YQbBed+B65T1Qs8bInX+5bahG1ijcHNTYgMlilyEyE
 3i7e8/fvfwVpyUJtZqAEZBhdcCbzfTmwvYSg8FW55ZSBj6EQ5oY9LphALOfKeGQrvbNyJyCWLB
 vqBPmj5DRN3BOaG6NWaoKmeQDuIgr7KTbK09mEvx5MiRWvNqJqayWkoDIBsCq/nbL71Fw4ntHl
 2UM=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="265100132"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:52:54 +0800
IronPort-SDR: m6Gs0gfumMKMoMrDncaRMS7DR9sp5Nw94RwMojOFHskVbVsrJ0L/a4Y/LPzWvJFM4ZOhMijfqQ
 pJtYu1Nb6vugVVCstrp6aHQYYLL9KqI+kOMdenZzZGiYONVrYwGmPianABks6Rw+eqv8rS2RJJ
 VTR4PE2uv+bsce9pFjTqkXz87XVeG57ycs7Z+RIIAcJJOhWdssIGA4IvJ8tk3QH3YCVYhtbLZ1
 IS2X6YmLi/fYFL3amZQfXfv5HL+p5+oPXbgFj2+S7z8tUuhv0JI9syWJ7YKJU77Law+AROqFFr
 kCDh+LCtuGm0VLWpD8UrJp8e
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:17:20 -0800
IronPort-SDR: uJ3hqNSeyqH1HF3zIc0JwbmSGDbh6pvMtx1NEvgibR25EbjGnJRogn6BMU+Lu8R+6DVT4bViht
 pKsV47+aMIDco+SIPKrfQ59VNfR5/tq4kGvhyblVN6Co3RaurMo9JYog+4zCaVJ1xxJOPStyg+
 3RtO+TI5EtiYfclCdtqnPlVltPqrrGkGUIpHLBFyz6CiG3e9ee7QtGqgYSuqd64LaGVymw/4bA
 bvEybD/3PfWZSAfRKB69HibdkmB8iVgx+ZETHUS9pFcClsoikcN0idlcLtg+AjFzt7CfplgriI
 8og=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:02 -0800
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
Subject: [PATCH v4 2/9] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Fri, 26 Feb 2021 10:32:53 +0200
Message-Id: <20210226083300.30934-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In device control mode, the device may recommend the host to either
activate or inactivate a region, and the host should follow. Meaning
those are not actually recommendations, but more of instructions.

On the contrary, in host control mode, the recommendation protocol is
slightly changed:
a) The device may only recommend the host to update a subregion of an
   already-active region. And,
b) The device may *not* recommend to inactivate a region.

Furthermore, in host control mode, the host may choose not to follow any
of the device's recommendations. However, in case of a recommendation to
update an active and clean subregion, it is better to follow those
recommendation because otherwise the host has no other way to know that
some internal relocation took place.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d9ea0cddc3c4..044fec9854a0 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -166,6 +166,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
+	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
@@ -235,6 +237,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
+{
+	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+}
+
 static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
 				     struct ufshpb_map_ctx *mctx, int pos,
 				     int len, u64 *ppn_buf)
@@ -717,6 +724,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
 	u32 num_entries = hpb->entries_per_srgn;
 
 	if (!srgn->mctx) {
@@ -730,6 +738,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 		num_entries = hpb->last_srgn_entries;
 
 	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	return 0;
 }
 
@@ -1257,6 +1269,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		srgn_i =
 			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
 
+		rgn = hpb->rgn_tbl + rgn_i;
+		if (hpb->is_hcm &&
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
 			"activate(%d) region %d - %d\n", i, rgn_i, srgn_i);
 
@@ -1264,7 +1288,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
 		spin_unlock(&hpb->rsp_list_lock);
 
-		rgn = hpb->rgn_tbl + rgn_i;
 		srgn = rgn->srgn_tbl + srgn_i;
 
 		/* blocking HPB_READ */
@@ -1275,6 +1298,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_active_cnt++;
 	}
 
+	if (hpb->is_hcm) {
+		/*
+		 * in host control mode the device is not allowed to inactivate
+		 * regions
+		 */
+		goto out;
+	}
+
 	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
 		rgn_i = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
 		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1299,6 +1330,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_inactive_cnt++;
 	}
 
+out:
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
 		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 14b7ba9bda3a..8119b1a3d1e5 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -119,6 +119,8 @@ struct ufshpb_region {
 
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
+	unsigned long rgn_flags;
+#define RGN_FLAG_DIRTY 0
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
-- 
2.25.1

