Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700C0C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31F3F619B1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhCaHkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:40:24 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28172 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhCaHkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176417; x=1648712417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DDdf1YZpbbGS2MS0NGmUe99mGJKNugwHoSd4Gb7gXRk=;
  b=eBu6IEoFnOcDq408s0SSswuymG1xifaBUPgRhPsoyKYVmGq6B6lqs6Ol
   hq1TlmUlwXC6sC9EDl9gc0ENdAqmRPt+Ra/zLjy52qDi9hVzqKeXEoOPj
   gEANztL/tXI7AiUBRKo2sDMqF3Z/Yz8kChSgMdYH1YJmpk7EM9XCBDW84
   fZYrh8u1p6Mi3DXsW3F2dqxQ5B2StFxTvTlLFBU0lqHmyNpDDl46oBj9m
   bGM6Q17GQykBob956+1r2ZFa2IWqNcd8IxEQzFDIBF5OZ6HmtdNIKKAZY
   KJBNChy9QXcDOtEzijeV3yMp/h/PCsJsduZiiNLIM+9Xge9Qzs/404CWn
   Q==;
IronPort-SDR: kveB/wvGATWRG6wqtAEr6htDBFbyMY35A9XGT94qMiyn781t2c5dRKnq/B+BHXebqx4Ub0R90x
 o7tgHjjbXRHHRKOt2hvVsyO7JKT8n+iHzD93EwkrqM42EvwdWed1ZAx8vZaCXfItLSJAOiFw3o
 V0IO969iIbfqO5JLIvwu65hdPtkF7zgpY2dhNrgPCzYsK0ZDUCrA1kKyKWQCmNZgJMdvJ77BsU
 rXVQsDAqCmveJB6LjK3jCTo1LuVtUyMhVfPEufBS71JEFKXFzxgN6zXNvvsZFChByv7T1LJ4I3
 vpY=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="163338559"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:40:17 +0800
IronPort-SDR: 0BYfjCapl1yWo/O4m6mF4OC5kDWztEdJuR3iuWz9tyiQw/UjBW+YmfoukxpIWAL5LjsFRi2Fe3
 p2K6cuvoJiVv5OXuDUf6VVEi3wAlV2DWxVt98ni2TzlJ8M36yad9FphJ3nAtWMs25C9bhs0cI9
 m7vrwv6/oRmkX2n8IB+C0fHb7+09KWtC+VGgOW2tGDMgTEpkok5VV44IBS0voCscbp8xvFPLQW
 MzoFNvII8g6aQxKX8DWwILhRpxCsrMb8vO8VG0dTys2p0RSQ5P7ooqJVWT0qH5ynGb6YjqMmug
 Gu4r8qV5+tCLYm9ge6wW/1+i
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:22:01 -0700
IronPort-SDR: ETgRQ7kUBK9sqVziU2ODqHQaN1oXB+4HiLga0+NK3lTYWo4RPt+ybYvWjE1w6OMYLJgT9804Jy
 8PGKPTqGFyLVA4rz6UjzDNJieePr+NW3/T9cWffdCeNBwSf4QMwqqXuBEjS8m2O2BCyhK1ZlFU
 jLn428QOoT2ABTM6en+X77K0VZlyDUW7sCHbdTeMBzz2RfcM5GDcFdpRZPXaJOYjjLoGrvQmVp
 fzYVhcemfUGveKV93BlSbUowCZCMRMImQPg3l9ob7PVpTdN/1ynDpO4n7vI+gWyd7pgW9lFCt2
 uD0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:40:13 -0700
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
Subject: [PATCH v7 02/11] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Wed, 31 Mar 2021 10:39:43 +0300
Message-Id: <20210331073952.102162-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
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
index 5285a50b05dd..6111019ca31a 100644
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
@@ -712,6 +719,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
 	u32 num_entries = hpb->entries_per_srgn;
 
 	if (!srgn->mctx) {
@@ -725,6 +733,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 		num_entries = hpb->last_srgn_entries;
 
 	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	return 0;
 }
 
@@ -1244,6 +1256,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
 
@@ -1251,7 +1275,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
 		spin_unlock(&hpb->rsp_list_lock);
 
-		rgn = hpb->rgn_tbl + rgn_i;
 		srgn = rgn->srgn_tbl + srgn_i;
 
 		/* blocking HPB_READ */
@@ -1262,6 +1285,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1286,6 +1317,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_inactive_cnt++;
 	}
 
+out:
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
 		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 7df30340386a..032672114881 100644
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

