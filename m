Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53890C43381
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0C2560232
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581512AbhCBS5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:57:50 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:41811 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351058AbhCBNbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691880; x=1646227880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+mj9k8DOW2ynjWjt3zJCuC4pRcPAUXqtzLGwdtsx21E=;
  b=oPK+ijT3m2hFrO6owPzlttAXVeGB+lnIZHWwgf6q7B1Av5D/JSPAD1Jw
   WekaQf+DMnoiOwslNHXM1KB9O7s7lc90plqLc9IH3ATtGtLGWiX6F+hME
   /lD56k7y9ae7/zYpbv8VylDEdxJgJJ56BLo28qr3nDeDXvh1uLoOmc4TF
   0YEiNsWeQJ182beEYIXG2B8BwXsTMdzWrefv4CvPAZYOEdz9SNeOo98f4
   4jVmavCM0bl2UUDkBBeqJ1pe/kgbp9JPNixkKCDHdg3gBENu5UMzJ8tbr
   FeJUnx1brH0Hb4TO61YrTgrynGKCC3y7BdWiitxsCRVVeSBU7JnkWxXOn
   A==;
IronPort-SDR: DKOzjSMtwPI1Dto2ip4qxu23Wkln24mrzbU41ncmRtnoTik6ZdzFF+5bbT1+Cyn5otEkwi83hO
 NajPcttnknewao6iEp8p3uo0GhneTThKxWmq9LVaPzsfVL/3RTr8qUWaE7kLjjvR2mF+9xX2yl
 tuB3bLoPy9coJMUsSMmh4i0Dp1vxUEQbcmdIHchk+YVCMmpJd8ilLu2NWlpIzOdXGzlWie4455
 YAHc2j36+3xATtT8kCypjkyvjmbvAXHL1XCADw12CS5oqfk27IoUhfZGA24CENoTDvLh+G7TFi
 uVw=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="161172110"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:07 +0800
IronPort-SDR: 3wyH+ejIGcIfM/PwKSr5yvU+X6NVXJkSJDzgqSm8mZW6r2tL90Qhgk9GrRrWCIBf7YFzB/sI4E
 1fZV2QQPTh6IaTz4LGvcB0quIxu3lAG4hXWzGMx9IWxNTHtzyZeHiR8f7snbrppf5GxK8cgbGb
 gw0biq83KCdWGyDz3il+86DyW+VntSORa+rKZ9ljMaGhIC0nXxxisx+jhkgLv+pYB2XztWd/3F
 Kyhw65xUd25B/O0weWs04NlcDHmFKBJGY5jcuZ1oRydGgbgP3dUZayZJqfNnKGzwg479fg4wF/
 o7EGE0BroecHKsRMIvLpy51G
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:09:14 -0800
IronPort-SDR: fW4yyjzBc7vac75egBzXRpQDpYQFKLYcD6LaTA5oWjGpMkV0udqu4BxViynvuVqBwT3hdlKBq6
 lypHHUZ65LtFCu37zW5SE0ScAanxlAM6t5UkfbNLInG0v3oQ4H50Pyx59kpR2CYBqFVSoTwBi2
 ZZLeHINVhvAPTOcuxi+kbhnRQL8I33H0qd+vM8St4MxTINfAOMXZWSirr2o6+e3BZiOkSbQ+Wj
 qkJgLV/ppndb+l1pHRVaqqyfDPcyyZjHbIgvMAeLRkR4tlmKBt1B1Xe838xvjUUi2aLf3bFf+H
 wR4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:04 -0800
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
Subject: [PATCH v5 02/10] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Tue,  2 Mar 2021 15:24:55 +0200
Message-Id: <20210302132503.224670-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
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

