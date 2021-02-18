Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CD6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 17:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A304864EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 17:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhBRQ6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:58:38 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2868 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbhBRN13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:27:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654849; x=1645190849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yom8YghvRy3JpvoVcsokM4ePBjNz+gLkJ3acr37Efdk=;
  b=PpiGFAWAcXRnH+vBXRD+o/tCDRR19LFYpcWIa/MxiaIsdx0v4J5Fl3mK
   YO+yRrmNRI7w2MSviACoxpeQlWXrVnG/GZnKpCyogzLAVGGYOWD9V2mpt
   MaAOsTjN1BQUTq2inQYotoHsiChjGMwWoG30Y2CdvmEy8X3xWNY/n4H2S
   IBXR3AfKeK2iqFFJKpmqnAdS3xq1urONGNmUdlp1Hl7Ks5JhJj+rPo6Ex
   67XgU3BYwZejjS46J/N8LXA6QJpam+tNcV0fekEtJr4wC/Hb2AHnFNFe7
   /w9DBQBDJX9/YYN4Fv6tPjEEWLsD2nDFS3qIYQVDamyc4PmL89mFj18LS
   g==;
IronPort-SDR: 2byqv33m54iO/TB8GpPY3PuSL38Xj6/fee5L9X6yKjCUDnLILE7KLV77HI4KiWqEGYEnWgtECs
 WRCH2pBluEcGP7g+5vYP3tMFUerA+8geRAkHUGJGoQECuvWm03MuXbIU6AJgOkzppRp6sec95k
 Ryr2IkVHILAAxP+Nb4/rmtjiXlcr6T7awKebvXawpVyafC6TdbB/fWsahzL4lg45oD3D2Xfo32
 rLAQWo+b5UqX0D/NiglGBnFczfNql4a2xTZhUYZj22CCYz8IEjt++sXGwcJOXfXVL+vpewRKAe
 61Y=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="161433332"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:20:26 +0800
IronPort-SDR: f8hu879gzibLoSfp/qQY1mxxnbptR8Z3UNDEYKDq1OPbkrj44NrJiLV3D6rmlTHw56FzD+tRyn
 7K0Dx91vCrMiMOGvKM+yjXBJg6qY9epZxRJ/pgGWkcaZFd6PwdXaFejSfasP4gnQvfn6x4ckW4
 y+zy2Jw4/oUMBjdgYR2AwIqN4tajSNmINEpDjP0qtj+25a6qEAIFqQY8OxYAVMt7repIRNfJZK
 qns+CS49pOz3RIxTMAhJT3uwGHRgQs0FwysZENxHEMoxU2xxdLvyKul0BiJsmUcBB4OQZZkRWj
 9KsqpUPjK3WTwZvFG8ijcB8M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:03:51 -0800
IronPort-SDR: QcR3SqhsaGKhpkT+YOmErbYkbZ347LMzRkyEjeH1X+LWLF4j8y57iM8KGBOZLuxHs8zwgqlyzb
 9ZzOEtzz/u45AQAdI7O/zyRDn3ws7yipFsHZ8JfcT09MUWlBd4qz6GJyIJ/k+u+aQKF7A9V8qg
 rsAUp2AzzwaJ6IB/Ci/Ifdi+422RzTvtS9WK1/TM5+X3ScxDOsVFoSUoFd+Xxfyxa4cA5QRqdA
 emiQi5IjWvlgeyE9hchpplRjwhsWc9vaa6IP8nE8+lWVy4EiB9ZW2S30JeDrwDBBWztTysAhR3
 8Uw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:20:21 -0800
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
Subject: [PATCH v3 2/9] scsi: ufshpb: Add host control mode support to rsp_upiu
Date:   Thu, 18 Feb 2021 15:19:25 +0200
Message-Id: <20210218131932.106997-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
index f9140f3a4eed..e052260868ad 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -156,6 +156,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
+	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
@@ -222,6 +224,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	return false;
 }
 
+static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
+{
+	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+}
+
 static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
 			  struct ufshpb_map_ctx *mctx, int pos, int len,
 			  u64 *ppn_buf)
@@ -715,6 +722,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 				     struct ufshpb_subregion *srgn)
 {
+	struct ufshpb_region *rgn;
 	u32 num_entries = hpb->entries_per_srgn;
 
 	WARN_ON(!srgn->mctx);
@@ -723,6 +731,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
 		num_entries = hpb->last_srgn_entries;
 
 	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+
 	return 0;
 }
 
@@ -1171,6 +1183,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
 
@@ -1178,7 +1202,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
 		spin_unlock(&hpb->rsp_list_lock);
 
-		rgn = hpb->rgn_tbl + rgn_i;
 		srgn = rgn->srgn_tbl + srgn_i;
 
 		/* blocking HPB_READ */
@@ -1189,6 +1212,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1213,6 +1244,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		hpb->stats.rb_inactive_cnt++;
 	}
 
+out:
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
 		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index f55a71b250eb..8e6c2a5b80a0 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -115,6 +115,8 @@ struct ufshpb_region {
 
 	/* below information is used by lru */
 	struct list_head list_lru_rgn;
+	unsigned long rgn_flags;
+#define RGN_FLAG_DIRTY 0
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
-- 
2.25.1

