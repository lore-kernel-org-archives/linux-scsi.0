Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2624C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 806F6610FA
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhEXLYS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:24:18 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43226 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbhEXLYR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855390; x=1653391390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8oJiGZWvCOYhNCjPFkvi+zKs+g6YfPSJL7ChfduYeOo=;
  b=GQF5jnyw3v0MW3o2M4/Jo0Qru3Gh7yNh7OF9qhi6JfRteuHwWDp1F0uo
   B+78/mqDVPm1zM7O9uOeQ51oS6o/v/KQTvWb2spRP25iLtQhEaVuEAIEo
   7KvPJCUfgXzQrd4OeBB04oEjZVUtRY3/dIjBHjBho5YFNxKwFPjmQsmGx
   EcQcweu+m+ISYvRYUhZsIwwk0cKkkg1NTOeq3IyP2kLjSTRdNtrisrUk2
   mRkYhs49f68fa8CtoO26y2fhXA8NB2ENwuEVQLkCYjA7CKZUbMedh17ij
   rNcVIPHJ2tmLFgImASmw9JiJGyF2zkpIpMx3+T16oZBE35QsW3J/rAVxb
   w==;
IronPort-SDR: CaetfJEPR7QLof4f2h/VTHDLzR7joemhp3fC+evSWVynNQOS8OjCY3zMww6OC4QmagSSuuBhlA
 VxMB/Fid4Y7rLpoFM8uNNowylEwyOiqRAoCJMeRjzc9G38kYqyEPWQiyDY7UqENeroW9B+Nn89
 Fugi1D28ES7vk5jq3y+VNtjpckhP5zn8wf1B5NTqOyT1yxiJn/7IOk/bOiEdvygTVCK72y7g0E
 pdwG2yCz+1Cwr/FJ+OfL1faVWLtCGW9B78uG2p/U6rrRRMRWRaE+nNet0Pmn/di1dC/JFfz4oS
 kUE=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="273140516"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:23:09 +0800
IronPort-SDR: jkSb/5AuwkTx2qB3TEPCPa1qQivwXW/znoaiYCNoa75KZiwGpn5IFSpPS4pNyAoNSidCZ34nMI
 OKpD5b2vL2A4W8BYynYvIqvZRiXybDguCBlt8eN6CZBr/eIre6RWnjQzWIRn6O/jvS4Po2lwX7
 BcgJq3TRDiREiC6ivxphI2uZuZQAZ/d5VGJlm6W55yH4IviGB/5Ho3Wqvr8Lp1daZty7/96F9F
 eWxJtmfs+ocVAf2IVbn+Ho6KesanXpTOZhwEKbTgUOlGaMMFBAxd/af6cmdM65KXgquwOsbtYt
 Ggvienth2C1EImEreEVjxQWe
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:02:18 -0700
IronPort-SDR: nKpxCPl8dHM7ZQGhwKMbHgehgpmAb2Pw8Qmt1sJK+siWrQ8J0qPgm+FSvdhZ+d5rSMQs4uZPEj
 reV0HieKJjYYkbDn1T8ijAObdlEqZgy8U2nQflp2qe3bf0Q9781gUF3R6ZpNQZHjtw1ND5X8pO
 ciC85xnNeCllu8v2AplemAbmPyiJovVPdB0IdttJjieFWUvMncbA/zHjtNKGgLZddCFDWBIwgp
 OnRO4HtZIZDZHYcW6TxswkAEIJAGqjcdclcvziCbAO3joGc+oU+qejHPeiWsh8/gDWLIzKVvW/
 DcM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:22:45 -0700
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
Subject: [PATCH v9 02/12] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Mon, 24 May 2021 14:19:03 +0300
Message-Id: <20210524111913.61303-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
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
index 08290ab34f58..a19732b5f8d3 100644
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
@@ -710,6 +717,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
 	u32 num_entries = hpb->entries_per_srgn;
 
 	if (!srgn->mctx) {
@@ -723,6 +731,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 		num_entries = hpb->last_srgn_entries;
 
 	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	return 0;
 }
 
@@ -1242,6 +1254,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
 
@@ -1249,7 +1273,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
 		spin_unlock(&hpb->rsp_list_lock);
 
-		rgn = hpb->rgn_tbl + rgn_i;
 		srgn = rgn->srgn_tbl + srgn_i;
 
 		/* blocking HPB_READ */
@@ -1260,6 +1283,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1284,6 +1315,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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

