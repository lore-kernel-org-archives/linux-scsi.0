Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C709C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52458611C2
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhDKG23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:29 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61184 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbhDKG23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122493; x=1649658493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rL8WCMpfxX9Dd32VH5TCQxuY4q7r9qOQGHdD3tJcJ7E=;
  b=GfzmTOhKuwchbzvaT77tunnvCDwjWIxd+na4uEIkfH76dIzCupA+DY6H
   +5g3FSBfaprra57ta2VyiS/9BNqzhud+TTUMIScPpbUQzatfaviQ9PtoV
   zp8mUSpgrtKlg2EtXLdLF5Z2v/xEv2bA4TDsM7v61B6dZ4qFIu1c6oT7K
   5QWSG34dsW+tVJu5XLgw3s66ZIbAnpanoFStCOaCEeHU+oLcHQmVFIW3Z
   tcQygsz0bF+Raau50tx1r9a9ri5qxa1cbTp2DzAOqCJdinf694CCHKcJd
   q+rce8lFbc3P40R0/5ahjgf6w1uZossTUcI9+gdghyyOQgfPZcZL13sJw
   w==;
IronPort-SDR: wdJnJb7G7+ZmMdxS3kxAIYgNAO2c4kW0kw6JQM4HFxLXj7/HqRzmJSCf2nik5NytRzMn+Mx40M
 5/wfl4/QvocfG+cNxzK1wFJsK5JLEbIzHwpZeD8seqcoh9J9rQxyEFfhDFT4PMCwSc3y5Yu/hT
 khELmw1USZA1gygRBoxZHKlsqYCTsiDpScZB4O1NzKv+tYsxy8FGUVnnHkcQVsIbgs7LhtxhFF
 7qrGCqCokZVq/aHBHkdKdXgpAjluHD+eSSywSZannqlnLzCoMOoZwX5i9P5qXus8SUqWBrxBNe
 3EY=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="275295976"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:13 +0800
IronPort-SDR: JPZxlPkiE8bzIIzie/PnX0tZrWHaP6iM3Jgx+twr4KSCYJak8Pz5Pm7h+XgWomz2FKiLAkf+ih
 FlUiAR6IrSeQqJ4iJYyO5/T8ButJUMiQQ1lundTtwVTlcmeJvjZHJusju7SYvQMZb9Qz2x/ewd
 w0PESxIcjWK9ov+K8Jy0ZJPWfrBqsfr3ieepaf/pXoBmNCmEjjqJ+5uJ3cvqRFRaHkvcW1raWT
 pEDUUNTU0aqCakZ6DXEWOkQ/MUi2Epl/pseywa+FmqlBNFRJgi73j8k2M2zQ7UWg7ImhqdsE/S
 F8QVpBHeHZDfucON1aFKfS3m
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:07:46 -0700
IronPort-SDR: xed44BdbYBi1XXCHm4TyctZ3QqjFs/gmP4OovjgWyMo9sGvQcMECbEwGVWoin4dD69iIe+LKHG
 MoXgWFRa7e9UWRQiW3fLxKYMPyTsIi/IPFE8w+a9nBDsb7ryyf1s48UvZMuf5DrgXoIYpj+TpM
 Wy3nVGOGQMbgU3MNuNqvjx38NNC+FXvFI+7FWBtwqimbSkAQMVLiglge2SWikOHwf3YEhWCI8C
 QgjycqnApqLpLZTVXn0w84miFlkQmCjXUhE+ov5HKRCAHaPi97/dfLwF3DLw3I+h/ibW5iIijb
 wnY=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:28:09 -0700
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
Subject: [PATCH v8 05/11] scsi: ufshpb: Make eviction depends on region's reads
Date:   Sun, 11 Apr 2021 09:27:15 +0300
Message-Id: <20210411062721.10099-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
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

