Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28ECC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C6A619D6
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhCaHl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:41:28 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22925 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhCaHlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176490; x=1648712490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KFIzO+f8G2d7pNPpUOssuRMbLwQuLI0+hCQ7d1u7nDA=;
  b=To5QqJMZ5N16RDzEBvDKCCMdwzK7R+nnxpj1IWjYWvmHpURFkj6LRn4/
   PWuFziJK5fHyKULQn5b08fWdGcvH2N8SIJurrPUzr6HCCQJPvhg9F1TYc
   h5D8WimcX4ptfc/9xyyqwQj9wFeC52cEVJHkDks9lTUB6hSaP8lGW86og
   ouVfM9qtx2D8KpbDUUFEX+YLwP8xYV+C9yrkBieIKGfP9t0MfzYGeqNjt
   31/BpL7csbviTpA9J8rzDAy19uwOGYdAxUBVSZ3rjV36kIUHfJndyGt/7
   7sLHxfA3QldFqPTWQ0MdDCmmhgviXOYoTLVbGi4TeWnOeHgMG6rPnR0eU
   Q==;
IronPort-SDR: GopJlAZPpiXRndsZX4us5CKMdUIsGFYGpQRzEF25T1/LIamb2ZcfhXpg+Ak1ObFHBEN2Z8eAwI
 R27d7SWn3OnoCiJMx3sf3mVZN6plSfykqGyPMMiNyHBV3PvJs+zdt4X/+xPLpGIt9BSVOuIlt5
 AkhFtwuiAA9Lzx/4X70YoZYI0CSFW//YfIx8yk2jCgSFUVKAbc5rqoo2Owo6UUnTLoFU3x7SQy
 QXvqbhQ28LoXOFnQq6jbwqnvGGVbG8/B9LluxtrOSsus2aIQwazVrPw+G35bR9fPIYSvIZXGtd
 0gg=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="267851328"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:41:05 +0800
IronPort-SDR: L1NfyXW0ylGyGsi454b7FxDPhlUpVWZkm+qXydBnq0hj7v+Ce1OkcKCLfoEo/c0pR/7tNzKNld
 OSUFur80cP+xfME+5bq+PwfIizh+Saa9xqghkqqy5ptgQpZgdleTN4yfXLUU5bbi0tjcw3ymKJ
 ZM+YPGjAOwm4I6yveQ3Pvpqqu6BWRFwaLBEHVdTSJI4pjNYHVRjvRo1QftIwBFVaW5obOY9TKp
 A4rVa9c8Igpq5qnPVZ/RY5TTcLTYxpWlyJN0k67DeVOVjhWHwJPND4loAwwUolXGJR2HmYafBS
 1KvSkqTNHZMMYWlA9pQ9NHZn
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:20:54 -0700
IronPort-SDR: +PspDZ1oVg43ApFFOTzQxICU2vVitrl+4tkX8AsE1qBD86w59fiXwX7X216rN6aKf+7QNeZkEo
 Y7v3sdhWGaDgETgnDngH0LVgm9b+AQL5Zg6XnBgMW+YmMnz8qFL8+2ROTAB8vERlOBnBoryOLW
 LKsCe+DPBRHo4a6yxaPAiO2/EyFn+NTUdsMQcCr2vScxzVdE+xavhjSdBFO8GPJSkaqNynLIK0
 u+Vr78v2VPHseA9J3PAu82jF2OCUQ99g19S6n5QVMNAGYntbSD8ZGjV/Y/M9oEZOxHu1utOvCW
 cj8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:40:39 -0700
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
Subject: [PATCH v7 05/11] scsi: ufshpb: Make eviction depends on region's reads
Date:   Wed, 31 Mar 2021 10:39:46 +0300
Message-Id: <20210331073952.102162-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
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
index 3ab66421dc00..aefb6dc160ee 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1057,6 +1058,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
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
@@ -1229,7 +1237,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1256,7 +1264,15 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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

