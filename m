Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89ACBC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6362661246
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhFPLbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:31:04 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:65265 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhFPLbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842937; x=1655378937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KOE+iOlrS9XEWOKhdbmkFiw56P3ix4vKgtUj2RN0skk=;
  b=kD5AFggroqcOl7ZCTf4NrRaJfpI6IqQePhW2rk0QEaxIl9E8p6ev8am9
   aeuyyUo8+cZmZ48PTw62Te+dez1lu5BN7sCj2yaz176r1bVnyYoR4SKlz
   gTN4tL/gounzTXveDAM/Y5DKgeVxeFO0QyPEzIM6lmsdfmC14dZPypsgH
   OjiqS6VDFEf7ZdEGhn6DShQa+Gd8sbE5dt3bBAmMrQniyQowM8TOlKECL
   7NMQf0f+mrAMHv5miNI2byFnn6bKiw1lRQsHpQQGH/7L16gE5v6ZgTogv
   VkeYqHV+htB4y5y92l2uIFV8l2V6ZWNZvCyX8ib+OLpbBYgsbLciQ5N8S
   Q==;
IronPort-SDR: 1TL6MbaIeKuLWpz2wfJTKFm3et/euhDuLCE4MXdtUepVaT+muB/GOzcIDLq4Nf2JOM3YFuRDsB
 G6HzueSr06x0D3uo8xki4X0YpGxvxdkryi+WPAqMCDc6aHPwDz5KDEBFikduBIQd0f0AM9xbka
 nIJ4cqAAMaWb4TVodpDAjd/npXwnrQjOJhUWK1g0gdBN65QSDbAkK67k0Tbzrf9Ab+fvUXd/lN
 uc6vJoeGBYpEhTftTFr1HIlO0wzbfKWFmmmHmLMdjLhqVRk+O5srymvexjVEpdwpLxrGsVqi+6
 zMw=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="275871304"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:28:58 +0800
IronPort-SDR: XVF9Z+kEvbWwgzX6zZG9BLQv257RzhNkx5qkEOZUOZ9zjiNsrQszMMfApL+d1YTRFETS2hD8kN
 3W9L55wEtWNlJsOV++s1KeyFtOOz9hkJs/o6uIqgPuKsbpr6UWc6/Q0nV8yoHe/H0OAzf99EsN
 D37Cmlj13KsKYkoFU45JSpCkF7t6ahApjXtxLVaXpLnDapxbBVLu5f5Z8l6+2oVv1zXhf9SuKn
 DurtKEYgGPHgrgE6vlcT8fLegPtUjnpGvAXCF5taqy/nwyWClasF8L5URF+D1uzh9A+CcPsYem
 r5lkyT9mA2PTH8PFnKA9nMhx
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:06:22 -0700
IronPort-SDR: JG0vsmxmw+4ICbxk14ZD5ixEGdx3PxeKImRAu+ZJXBjwXRrxxdFhVVHadY1L3NyEAq2r8TVoTB
 PBa4mdxE7B9OFSnU/LG4tMrZY74i0/0ckd/0u2Jsd7GbNBBaBkszy9T5ORCXJG5GTS4lOXFWaj
 fDPsYGExPx3UqCtOdEM0RuG/HxGw4Q5mV2GodGzOyg+8K9pJMnUi1BR2wUa6l87C614VwbpZaG
 xZQwI4fZ5sNo+L6OerzRVW2jK4e/EJEq7FFiiR0hz01d/i4yoG+SedRrCfwkCiF1irwIFWmFCK
 zzU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:50 -0700
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
Subject: [PATCH v11 05/12] scsi: ufshpb: Make eviction depends on region's reads
Date:   Wed, 16 Jun 2021 14:27:53 +0300
Message-Id: <20210616112800.52963-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
index 9e5e585e1a43..b61558196290 100644
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

