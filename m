Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBFAC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B106D6108B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhGLJyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:54:41 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:11512 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbhGLJyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083509; x=1657619509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+jnu3rPm16B/c8+fawe4fAuduxrSSeqJoz2Pler85XM=;
  b=MGw2PwnqSpOJ4+4/d8jtjRHhlORx8enz5sKJb61a9Cfh2HD3L4EgpKGX
   PMxTN3OYYGu3yAgb+r6qsBzVWWcIOn/d2yx+crBOLFgpn9YG3xNbUZV98
   M2ghmqwAiYj4T4ImBLkuTS7eXsH3Xm9TDjRFcD23pZ2zaDd7Kjq4GcraA
   Le4JD7KViOYST4qE469XjOGJVW2XhLtNBMnnuUailq1tVraOt6Woe5f0Y
   BwSM0b6me1vO459/z6BoQ5qKNlj3Zf/VcwLIbF/idYzjc7VZwehdWNHdb
   iEkPMayG6fYM2AReOAdyrvtEDN/pxbZXjVf4Xn3bHOAI+NYVJwFvmrAl5
   A==;
IronPort-SDR: TqkdiG/y+4lQM+JrKQN2eC60gKsw0KWSEEe1DRGj5Led+SYKIkd+/pa8kP0n45rJYqCdepITgi
 CyTKD0rMFr757digjlqiEozYt4xOayuVb/McHBH3rqoBcyfkUCNkF8ezS/Zx+6jZSPThs05iqV
 CFG5RN9zD++XI8TT4TfmuudU6GL2y01vPqwzq+U1o+nylpstHVDxrzEWFpNLSIzSRO16sFyzoC
 STT9qhdttFty3HFykIjAg3QhmYBrSVQ02a2mMS5OeUAA3gbWPNCLK9MqnU7uBl4/Sg+3cl0SrP
 MN0=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="174347121"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:51:49 +0800
IronPort-SDR: 3nBGYT7niz3YGn6oyDnaNzz//Pqv85nNa5hOjtsphHkjsJWLbzMBVVVb3LOilpEPQLpB9WRUpd
 D5Pm5hD0ySfcJWzz4AtEEXqFO52W2d46Y7fUpx8B/dzDt+TjW/fCU7CNd6yiYuLOYsYjxzpGCZ
 WJ8pzMzLE28ZPbybKg5hGoTdxRQUmSNdRog8Ys4MCgPQ/oV8YzVDRJVnD4ZYamAP5kYODGR+Qk
 MNUdotiRQDnL/IpI52T8/Yi0ISANZb42iwMaJDiZIAi8WLlD3qgCM/Q992+sYeMnwZps+t304V
 OijKIbgi9NbTfeAL0SqQuV4R
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:29:56 -0700
IronPort-SDR: tAgKDsFpocX6bue0/yacPL5zed/3JyNfxse9ghYi9Wag7/IFoFyzgB1d5vHDtw4KfZFHbk5J+M
 jYlfJD40Q3Gq9Fsl44kCL2B4CXKPW6zxMdsznMrZpj1nkAPltU4xgd+UbM8T638L0HbKot+xk5
 HTsQQuA35YF6/6btgwav+VyfUNwV7ZpIA2oUCX9SJmqbjz2CF0XDyeYsWkInjkaJhXxOwjVwqJ
 nylgL3bLQ7D5Er1RvaaEimBoeq8tGK73DjVMj7loHVPGnbZ+olAraETznw+6HOuWyyso8PxtD5
 j7I=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:51:45 -0700
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
Subject: [PATCH v12 05/12] scsi: ufshpb: Make eviction depends on region's reads
Date:   Mon, 12 Jul 2021 12:50:32 +0300
Message-Id: <20210712095039.8093-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
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
index d46235527fba..1eadfc12b6a7 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1056,6 +1057,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
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
@@ -1223,7 +1231,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1250,7 +1258,15 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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

