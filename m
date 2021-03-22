Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331BAC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01C5D6198F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCVIMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:01 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10119 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhCVILo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400704; x=1647936704;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZQlTIn3Cwx9+GuCI+PprQls3a+m7Dnv3nr+GnlS5/6U=;
  b=I7yzUfdSyJjV3OadSKgBOIg95P69xXzhW7HaG2FtWnPe3V9TavJ86BbQ
   R6BrDPvkrXXYmBWKkFohZt2z1wDaqbcnnF9fZB2xB/KvpRazLYOxLaWe0
   7+0QBVyAiPCUxpmD9H3QQkZHozxTZvWMkoCwSrtaLcLjfl7BjBm4qEdiy
   iCvHNlKFE9YoDx4X//IIbSKOYbtfBCEjga04H5/mQheeJKjF/IYDFE6hL
   V4seuJJe3MA/oOX9WPgGMCSSOwl7bUukTRRKoE3Y4/rUCASiEwy7qxO+S
   JnN2nzHw1/mdrQRprLNkHrapfoLVVekfBWnmShoLR0DL1pYYNa3vqEiy8
   A==;
IronPort-SDR: 18aSkkT5rfcfD8305pdp3XknekmY3xJJ9GJ5bG2Vpez5Il8QQu5y79xTz26UvvDatI+nQjndfd
 YEMEFHJtvoWuTj76gOg+6yIgQqbwC8DZlEtZZGHz0+y5SkWRt61AoAo3bCgVX9NkPhJUZLt/uM
 1PJxtlLvrcsjtbnDLKRhIvgBAaYfC2p6kwC8R/4xzVOPW+S9aLetkRvlsRLrCF/C4WPXTmuJx2
 0h1ZvDVM27lOa/tyKJKEkzJVS8GZM/9EU2A6hlXTB9O1EuQw78eDQb1anllzNnA2R4Q3VEtcYE
 +6Y=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="162644072"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:11:43 +0800
IronPort-SDR: 4FshHTJAoy15J8KcuJ4yOHqdsYgFBNe2J2651IGnzIbluVIfDLNFapHIKRCTEHH4+ecadcFC66
 dqGYo2y/qJhtvP2f0JWJAk5oobX5Mg5uEisjQ0y5s7ahOrt5dzetXyYxb5HA+r0Z5UsoxUTBPe
 E0adlv+w4E5g+ZGapyAdMyDGnnqvwN4jr1EOKqpQcz+72kDu8KeG71pZzUrDNZCpRvmd6Dny+f
 qa4Nbu23zJ/LHkvUBM5UYh45v2ZMJDoKp09THzO8LMIbLdCD4Yp2/u2FsnHt6RrLfLaO5TxLZG
 wlDt81BlEqW5CRjXGjQ/HAz+
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:53:52 -0700
IronPort-SDR: INJb7e++8Pt/MslVhbKiwWGY//dBS87L+VAkFdSPb2A6flLlNqF6qeT9/FCKrl/nMiNpRXo/j/
 /uWJEpO0TzeJRHBoIi/a7vLk8XaZTk+hLhlQ8tpY2cDsWgucx+f365CIOHb/TUypGpHTYSZ1ol
 4LDa1aQzoP6PgZBvEvgxGILSG8XHUNWUWbqMw9zYoKKs9KJaF/1RVFwDrI+oPXvdbF4mnOeFjU
 yf2sZ3LWkCjV55moEmD887xIhf1LyaghPbvg2KCiq/fnM3x5sUL1o2psN5HsbNr7W0AflIxMF2
 8Sw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:11:39 -0700
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
Subject: [PATCH v6 04/10] scsi: ufshpb: Make eviction depends on region's reads
Date:   Mon, 22 Mar 2021 10:10:38 +0200
Message-Id: <20210322081044.62003-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host mode, eviction is considered an extreme measure.
verify that the entering region has enough reads, and the exiting
region has much less reads.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index a1519cbb4ce0..5e757220d66a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1047,6 +1048,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		if (ufshpb_check_srgns_issue_state(hpb, rgn))
 			continue;
 
+		/*
+		 * in host control mode, verify that the exiting region
+		 * has less reads
+		 */
+		if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1))
+			continue;
+
 		victim_rgn = rgn;
 		break;
 	}
@@ -1219,7 +1227,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1246,7 +1254,15 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * It is okay to evict the least recently used region,
 			 * because the device could detect this region
 			 * by not issuing HPB_READ
+			 *
+			 * in host control mode, verify that the entering
+			 * region has enough reads
 			 */
+			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
+				ret = -EACCES;
+				goto out;
+			}
+
 			victim_rgn = ufshpb_victim_lru_info(hpb);
 			if (!victim_rgn) {
 				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
-- 
2.25.1

