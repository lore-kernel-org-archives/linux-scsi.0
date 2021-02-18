Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE9BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670B664EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhBRQ6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:58:07 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30076 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbhBRN0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:26:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654800; x=1645190800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1LJBjYU69njB65xIZ3s0koQEhLEywwRydvSxE8Dq5TY=;
  b=grck9ATkjstu8IvNtZ3q0vZDe5cgNbBd9p06RDram/UeqxNij4+ldI5U
   O3VOKEwJyD5bEJHKeDSeNanYDQ/A6RLwR9qeSACEy8Twzi++eZ53vUm3L
   eDrAe4S689uACHVy96JXj0WNrpNuehhTQJDxbuzNt7R7f4T9OxjO5TKRM
   RDIWt4RyAB8/nqPY7+2d5kZYHJZrZrQN9Kk+WTvVkUbTD8FvoRNK+FYB+
   P/okWHAJWaJl6pwXlpcH6RUpldUSd5PJYr6FwGTBzKpBMYY+RybkT1arV
   uk7FT04Yn/wt30EvEPU7lDdyz2ZT2boCkRm1FcLSgmSJLb1j5329NzhWt
   g==;
IronPort-SDR: bu4wAJL+C1W/ZBQmrbXUvppPWxXU96xqITadjDdYRIGmsYwrAkAoJ54UgOC4q0aTX2dluKvx1b
 Uq8HYOWD+C6z+LwkN0TTD1YR0w0hJwcdkRH1sHykIr6I14qauX5yeQyqJ6L82Q90ANJ9Xs9zih
 /xUyWcufPHwlyIJotsXOhjgyLs74u5QRfLODYoc/FsJsyEMLk50s8SVpINC+Nw+3xGk6WhJ6T7
 ruGzw5PMiHwpopC5qvsM5c3dZTbYO9rIlEYV/CAMbm7sVKjKT70GXDtkXiDD5EcQ+uNzLjRGGg
 o70=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="160277218"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:20:48 +0800
IronPort-SDR: 36/tyPWbgdWIH/fiYJJx45b/cQBZgQczIHP3JEBtV1JMrEIJiUnBjyMpVcU6BBuSrp3JhUTkSS
 RSdFLhOYAB6mkZjfYyul7SCDqZndOvH96UrtCoYPtUpadQs5fchanxBTr7bMVDUWw1y/1PMM66
 oBVHhvKrRE2MYD9WtkRoL+JADpcD3/Xzn5jCabTE8zd9u1mdqj0wOAstm1a2qj2vIPWmqjPOus
 Zslju5l/7icHO3nvMBLuELyGA4QEsE+7BxibU9D4Hr0qP5X8qY6206N8ytIAPX6+nRo3XsPInW
 bqks2kSH2/wS3PM6I245tCAD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:04:14 -0800
IronPort-SDR: 6CM1oLgCbxZF9hau8fAPMMnyHg/vcrf7CtpVj7B+45WR+T8vgoJkAOCIKC/KFy1a2b0ECax2Cl
 KI45lmjwSjal6obqSe6Qp1E/h8jGTJDtGj6qffGte/Xd6Au007NJ8HFrMrZ+I1mwIR6K/LuiE+
 IYPara+PDuRnT0GF7th6vNA/U5vAowe0LsXI6yJcF1NoBsFIeozNLXAlSrAlSF2QBHSJopIL7f
 U6AbezCo9nZZT+ca92HisUboJuXy1TN2A/3ponFJf2yGs64LrL30X3FDL6tMt5z25A3LbZQgEH
 UkA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:20:44 -0800
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
Subject: [PATCH v3 4/9] scsi: ufshpb: Make eviction depends on region's reads
Date:   Thu, 18 Feb 2021 15:19:27 +0200
Message-Id: <20210218131932.106997-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
index 348185964c32..9cb17c97cf93 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -995,6 +996,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
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
@@ -1150,7 +1158,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1178,6 +1186,16 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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

