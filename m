Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAEDC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D8F761132
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhEXLYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:24:43 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:17436 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbhEXLYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855395; x=1653391395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OnMBRzrruyNOJYDo4+Xotl7uoG9aAm+mR3kOeI0xjqI=;
  b=AUlC/HLTQ6bbWJsOuJZYJArqh2PZzjGGDZCBUYjpnuKJAcJoZKM52mgU
   HiotYQOXOJnWdLX94ai1L7MQTD9ijYP4sMg6+Wt108CUJXVxHade6tqET
   UetenRbiVoQ0FNAMQuZ+bJCuT+O/9fGNjtDsLry71IKrWduqdenEZCLGG
   EIdS2OcNJeM6WxuJAHeYMekX57RPpgEwr6JgXhQ0AliQjY30nXRFZEh+f
   sfRiAwoZ6Tb3uwvOXL3TqnfjQ0lEG5daac+pGDjNDMC9GopCnlsqn2fq5
   taKqEK3HxrvwiDeNVDvcAuMkxFXKi99oNnkKvnyEBQc7c3L6KDkX/cl7C
   w==;
IronPort-SDR: wiebSsQ4F6LwOh4Md1nqRxNMLWPa1tHOnaBZsNqSFw0AI2nppCvj5SRBv66dW4WtU0Nk2YSby8
 8JOfdbu20pJpQJEXMYjG1bFWaUzzC2A5bGbkdLWrdokW8xo13zYZmfWz0FK0QKozQLUEawg3xv
 rv+aR9JZcfkjF2lPEOe2Jo+zejpcJzPhiJY3NA+MrNKMxZlLZZk/LmS2aLNjCfAOecxrb+lCM4
 oMIGDCASDCymo5FJYJh9n/xLM1cMY0Z/w+zgpa+00NjfXH+bAYdFM2+NZ5KUW8hOZ1z4H5Xv+v
 NLc=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="168540286"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:23:15 +0800
IronPort-SDR: XJ2l4Vc3S6Fnfy3u1qaBc5LnK+DDTdsxVtSIbHFcVBFvpvevEqQos18eWkaghLhcUwB8OpK0oj
 ddG+gsP7zGxRTrGd5eYjAQ/2ZowmigGt5EnJVEAyac2FpaqERYW6+0ngt0usT3K242L8rAg3yb
 7cX+b5Qg7WBVMVxMvIZ+z6WbSJK8ZF6XhXWGaecD0tJm4ZTxkDWrxTkdlUCsWvSbjXK9BUf6qc
 31mkZBHZgUi0/wRvSC2GwrbLveIPtFX/pcpK2dtW8SZQegPIvseY6J5fvzGOrEf3oPdTA+fz4n
 Lf97WKvnCsmhwwIKIGLpvGCr
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:02:45 -0700
IronPort-SDR: 5osQcLZdIrzGaQrzHARDRVNZ59ns++CVTgxSwBqrNHPh8tzi3IsXzPxoO6mHf5aZ/4+P311Mjb
 LPNYmV+oh8KspY2wtf4Vdczmfnei/K+3QrT8kjf+JsiDuZWCqcPp7YYbrF6eLvg5BLtOPdtXPw
 nP8mQ1jowpiIIn8+4xb5IR62ZazhnDc9zwsu3T53LpQ1f+SxgylJZsiHPTxoWnXVO9HLoCuuoR
 HezkvbfVSTqij0s2Ya4QPFU0qpopEX05/zeAwiOY4iP45CjGXw3QymuGpktvbW5Mm6suvWlyyo
 tfs=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:23:11 -0700
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
Subject: [PATCH v9 05/12] scsi: ufshpb: Make eviction depends on region's reads
Date:   Mon, 24 May 2021 14:19:06 +0300
Message-Id: <20210524111913.61303-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host mode, eviction is considered an extreme measure.
verify that the entering region has enough reads, and the exiting
region has much less reads.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index e3b1eb857ce3..180e74675912 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1055,6 +1056,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
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
@@ -1227,7 +1235,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1254,7 +1262,15 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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

