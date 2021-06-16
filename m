Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026C1C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D81D06128C
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhFPLam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:30:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65350 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbhFPLal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842914; x=1655378914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VsFl0BSSzEpcepwJIpxcxa26x244/RmPQno1tOqHH1M=;
  b=N1jITnUffw4qJHAUH04svQd2W08kst0NjUGq84x5cGZ55jI1eLs5h4Q5
   9JesU4OobAPhTO2s20Cs48vwbdDLgvCk83DoALAsdL2P37hjzvjfpZOol
   n7xJyfkD9zCPEPuWTVTky7q8e/O/bk3IREe9upKHqOsHt1Pu4F/uDPPyV
   iUqwvbGaYXQAK2sUFNBrxc7VxxyEIYzqGZLJPe03iTcFd2gj5151+uoiI
   Ccf730j28d+bmU38tjX+UsCHbWj7a5gCRCMiSIldHlGPvv3n2/28IznFF
   vvlnKQzQRMcoZSKuXcvaoToGlR1OBwKMuLrncINW27EDc5t7I6+44hMUe
   g==;
IronPort-SDR: 9j/u5uDQx/IUerpD0KGbRXzVDUvWt7RBD2yWuWIE6M6E4M9hhsu7YPpPz2yd1Lw+w8Lx+rIDs9
 gTYUnP6daVfBncgOuDRTbV88u4C2x/XhZYnjpBTXi37WXCqxrdY2bmCG8tK6FNARZGGGvzAU6w
 jF8uw7FuF5EoFcn7rbuOR9BoI1mj5WWfkGmzfbgFzlnIjN+zGUIwhz4Xy6AygnKutxe/+63Fhu
 UKtS1eP2ifiaNZxGtGkxd10ca3U9K4ErcjZ/NkjuELGoOLVGCjEUcEyCkYmcdOX7VWdvkLhmWk
 3cs=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="176876289"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:28:32 +0800
IronPort-SDR: zFtki8XHoOUev0uWIQ1E1OZFp3jOxOZ53elaa1GArHnN6eRcZeNLBdA2QkQu2Tb06omQQP3nyN
 oHflVhzVTe/2tshkHTKUrMswtjXcdfm/MhqyvfqZBpVWafN/xd/iXHvsO12KP1DApYgko+Iuie
 8nh8KD98lHE8RFHxVv+UZtZVfiVZ2fYYMHK5ppATeo9t2kH9SJDLu9LcY6fQtVk9FlBiLqfBiv
 qV7lUvYpx7WBkzxYzDrbTmwKIAtHb7i5ECJJQyR46TBFag/4tCdEFMZtDY7sNblG5NwMrhf/9I
 xOLZtc+TxlYnVf0gfLgI8lhL
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:06:02 -0700
IronPort-SDR: 9N4pv0Ly2mnfra+xSt7geJxlxA/fDgq7bzN9zNKzAiMT4JUnpIeopCRAY4Y8y9yluakAPCiGpu
 eRnfPOC2ynaw6BUThAB2X98C02hXTM6WoGwOa7MwacNRvmIbyk+trAOjAZ4C3KbfG8DFVQIX7q
 oRhjnB7ZzB1ZFoOW2Lly33kDWgdmb/dM/Pv6880p48dNMnX9dkvO5lyrkc4dFkffAZBLIkMcth
 IqTV/OQJc2vANEe36sXgdFS1LAwpS9KBqmRgQDcwTsZ/PLo7kz1OIMScIsTVTST2ZmEgdycNY2
 42I=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:30 -0700
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
Subject: [PATCH v11 02/12] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Wed, 16 Jun 2021 14:27:50 +0300
Message-Id: <20210616112800.52963-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 61f4fcf6bc07..3fd9fd5cb43e 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -167,6 +167,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
+	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
@@ -236,6 +238,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
+{
+	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+}
+
 static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
 				     struct ufshpb_map_ctx *mctx, int pos,
 				     int len, __be64 *ppn_buf)
@@ -713,6 +720,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
 	u32 num_entries = hpb->entries_per_srgn;
 
 	if (!srgn->mctx) {
@@ -726,6 +734,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 		num_entries = hpb->last_srgn_entries;
 
 	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	return 0;
 }
 
@@ -1238,6 +1250,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
 
@@ -1245,7 +1269,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
 		spin_unlock(&hpb->rsp_list_lock);
 
-		rgn = hpb->rgn_tbl + rgn_i;
 		srgn = rgn->srgn_tbl + srgn_i;
 
 		/* blocking HPB_READ */
@@ -1256,6 +1279,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1280,6 +1311,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_inactive_cnt++;
 	}
 
+out:
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
 		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index dc168ba08a09..9ab502f82835 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -121,6 +121,8 @@ struct ufshpb_region {
 
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
+	unsigned long rgn_flags;
+#define RGN_FLAG_DIRTY 0
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
-- 
2.25.1

