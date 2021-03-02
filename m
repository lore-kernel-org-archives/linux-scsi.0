Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C8AC433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8735864F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581549AbhCBS6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:58:30 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19062 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351129AbhCBNb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691916; x=1646227916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m+6wspnTXV7QglngrZG4/3odIUM/+3SS06tigLAb6fY=;
  b=NNJXHkKNWNB6Rvn5FCxhLHw5dMv66byzfkJyBG97rlNgBZ/Qe53RG3q0
   9V3+CApiZIP0Ek70Y6y6hLVLCTbGZEREy4fFwVpIV9c2RCh5oiq3jM0OW
   Mtrcg6quQ4HiYeiiVjMuuq2KxLjJC+ysu6xb4GB2lR8syPPOdHxrtOnfc
   MbcOTIjIlvvXuQ5TIbj0ZPctqgt/9jlrPFwcabw8q+r+LNUTzSJYqQXHo
   KUIWpyXZls0D66Dl0o0noE3LKk67jHY412dgZbWF5qluyH5Rtppxx8rvh
   4kj5f4IP2DhJKYY+vDhB2UecainngDUtLK+u4ZU1NcYH/Kmz/FHplULza
   w==;
IronPort-SDR: se8vgd3ifR3hWY/tv3aQb0kq68YrZR8rw8a9LB+CjwijJHSC2Kt05Y9ymtqcM7pohJZfnj8lqE
 lTv9+AVU4eRv9WHd2vEwWIbGPN0c95yawUCiNLxmImRgbY3AlBluj5NfCBlAJMaIDxHuML8b0E
 fvBCj4csOuKFdgBHYor3VHNygCgxszERgcpIeag/kWInK9s2CjSYbQORBc1z4zW/FKUqzL8WVq
 OgqXOjslOFiYIM0D2Opp0BHUMLpdKT9EMPX5bq9I2xbuK4G+fsQTO5fCA+rE602Cf+mXvh+RzO
 lJE=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="165637121"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:23 +0800
IronPort-SDR: 1DeuyRWzIPPNfTz2HDIX4hKticQCTYarGlqmbQx9SRmcphxo1LfusKVOCZJh+EjE5KTQWypcYg
 Q5cP/2JFEd4AfrYsXwWOwhmusstb8dzKI1Nh8YgLqBZXaBMc9xnGdFPU9GF4kVKTTT+Xtz908V
 3bvS1dXn3v94kc0RRXiT7oIWkoc07nQAhkSL7u1MZQiRrHWL0xIPRJBZ+0fximoNHxtjzuC2kl
 NyVO/cPf1ZySFpb+fk5FTS6umSY60bs9fvTE84FYaUNe/XQ0lhYg44E41Gu4UJz6hUxws20LEi
 6k3N3po8/uvJISmdt6ZIfuAc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:07:39 -0800
IronPort-SDR: ktsiY3aG4gNm9Fzuw+r26RectOBYMVCRNNXDqKfWMuW8iT6Gcs6K26tvWuAmmXIbdcXhSqGBeI
 j11GUhE9A9TjT8mo4Wl7IEKRsWNma6M/lfRnbHp4bckPjxLk561ROC00rZ3My6ca9m+Yr/zpd7
 BBzoY69tCvF83K3D54r/hOeJ7xwgXrOrEdwSnJrnlOvJXWpmFCnc7X3inbTgnnrYiN9rn/fZ/7
 pf64Z9+p06/h6UHGO97XGT00APGqdGIcTu4APjIbeZ/HYdta4HCNEQOQyrRc8ubmJiIfnU3uLF
 p0A=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:20 -0800
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
Subject: [PATCH v5 04/10] scsi: ufshpb: Make eviction depends on region's reads
Date:   Tue,  2 Mar 2021 15:24:57 +0200
Message-Id: <20210302132503.224670-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
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
index a8f8d13af21a..6f4fd22eaf2f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1050,6 +1051,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
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
@@ -1235,7 +1243,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1263,6 +1271,16 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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

