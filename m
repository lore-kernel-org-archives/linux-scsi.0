Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BC9C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C9864E20
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhBZIfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:35:53 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:28206 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhBZIfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328543; x=1645864543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3uOjSmOzjY24VNbjOX25A85YrvCh/iOBT1jHqLJB7pU=;
  b=NQL/+uT0S3lgza/G7mq9MwoAfWVXIoQRcaNuhokxs1u7+TzEf5bcFhlw
   MZaV0y23ew2e2y8ytELTHPmZpogz6//OGahSkF+a7j/OnIoPVuPZnMzlr
   Cnyvo26SmYhR5EL0eLWET0KdyDcRORHjswXp2OjHjoQmAVa2c4Zm8rIqw
   xYE4Bhi80dAiamr6vNJGYxYDtk0YUupnPGcuwI92UBtvw1xfgw2pHa5YX
   pDKaPeXoQC77EvySUKp+hovha0zRMRz/MNifMFyMBMPCxP/d82C5CfnNt
   GBjc/pvxEQx+ioYRStSqxQMgto5MSgDh6lKmcCAsuKqUK3xcRu+6aHXdG
   A==;
IronPort-SDR: uQh6wbbH6kmOIukTx91PoRmSnnqdeBNsvImasfTkkGY+132t1xJ6ZuaH/ZMj5DgaPLXdhKP3Hv
 hR3IwsAHDGSK6jR37ZIHZW4nvThZlY9aXiUnsTNeCuAZhRsoK4Msr6MA36/pEHyGcAI6BMOiUm
 MBfK+9XD2z0UtlAw6U1OJ7kmWy6dF2TK12awO8etWOcVIvyjqfRIO9QSUwsXfC2HhywAYAOXC/
 a+BXESwqMFwMEDeId66lHFNOor2eCDi1ngb/ru/XRLXVmVgG3mZII9RTBwhkWl4FtmRUZxldNB
 Y2Q=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="165357041"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:34:27 +0800
IronPort-SDR: HrDXkslQFKxFHzHEIVJmKLXAG8sAc5hoUxODX+ptRZEvZ9HE2fIBxS2mDLMB+zAKXLNy25iWiL
 Hx+TJAn911ottkK/3GLastTI79kgKYQXMb/bUmxLDpuUESeubpQvnMkXI/BlPWdVXqVCphUV1j
 t6lg+ZfISrfC6Rsq7DhGJauAABAbZMxh0T8E8NOrQKo3/NGJ+jw5KB3e/+RvqiSaP2D7ANqYma
 806njrIDysnvzEGterleMp4j8ikqKVxeaqy2BNJPOB8kx4divhGjwBLXWwjrRTqifQ5pUvmHkV
 2nPjEbbB46+0p7c7MPh0mn6z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:15:47 -0800
IronPort-SDR: eubKs3W8xT23Z8jNrEmRNgAYGnsiD7dWenQgNHEndpVCRMRP4+5t5gRQrJ3vz6+9FSjv9ZPEqH
 b0Km3e/0DGhauYMPjlV3eG6LohKbDUI7nVQm2o42cwcF7BSPK9BVS6/X5KlPzyvT6kfiVGmrsG
 p9CMchWI25dIvzkyp0XNx+yGBDdrqnswkOKILyGP16vWtlDCCziR1EKY4fzBuilsUXueCWlhVr
 quq6HXWP2MB3KRrF97b62RMcVWfrp7mgvBQ50Qs3aN4YA+sqNzNki/cZEszsdv2qz0wBvRuf2b
 l1A=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:34:22 -0800
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
Subject: [PATCH v4 4/9] scsi: ufshpb: Make eviction depends on region's reads
Date:   Fri, 26 Feb 2021 10:32:55 +0200
Message-Id: <20210226083300.30934-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 717ccb66b33e..44e56a6d7102 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1051,6 +1052,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
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
@@ -1236,7 +1244,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1264,6 +1272,16 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * because the device could detect this region
 			 * by not issuing HPB_READ
 			 */
+
+			/*
+			 * in host control mode, verify that the entering
+			 * region has enough reads
+			 */
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

