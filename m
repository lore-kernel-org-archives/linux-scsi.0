Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A797C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 609F664EC3
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhBBIcM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:32:12 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:61831 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhBBIcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612255236; x=1643791236;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uc6S6JLc9fPtNQ4x1i1Afa72HYjOgH8MRSDYSHHVYws=;
  b=YR/1PubuPmk9TD00K2a2wGw9lcjuGE5qFdpMs8Cb3CVoQfCo4wHjK15L
   cJ/zRdEyqZ1XOH4CN7GhlQy2gALTQvdKJwsJyLhiPWt9BwTOoJmopHKQi
   TPTtBNoYeFSTUa4nDNAalt2LAVVgYKCrG5XlWBshoJ2aTOQm9N8So31y5
   tJ6TwH10C9m7JJowOQqWQIdYPG3469uyK5qg/AfJlWMezR+j4sY2ONVtv
   xa3XD0J3IgmcQqIwDukduU6ZVe0n2umja4DwOCb4EWI05xQvGIO4B0+Of
   bxQ8j/nMoKjettcqQc/o8wD55+Ph3n1GJTGvz56rdMO9N4Akbzl4P9447
   Q==;
IronPort-SDR: RSyhR/xZ9s+xochbjeod4FBsP8cwS+9fHzZMY4e7/bZ5VfzavdF0FzG/0hMCI98RQ7VADAwt8E
 lFeLnBX/QRufpUuAXVzo3Nemw+NbRLQ9E3s7kwX5Of8s2ME2L6oIBPlVYBzA5KG22i1xa3EJR3
 fJTzq3wyJFv6sBxuilW5bkg4NKI83GovqOqhZdjWRPmv3A/xlJ3Aeow3l0tuYBYIIHckYdZJkN
 +e3ezXsbh7PxZ+1MBe9zytZiMdCILaNcHLwhu3iBSOGhxIe0xyVkm93xxY6KpXV1V9un+wacfJ
 SMg=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="262976972"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:38:57 +0800
IronPort-SDR: M8eCInVLMSb8vP6NrF/mSJyNq31JYwAUQNrmTqVJ4+p9enmHNfY6ovK0z3lvPuluOgEii1qO5d
 ccc+lkOVe+8bxqyMM53LrzuBaHcS7erYEL1sv7aBhetIrsY3oKb9SmtGIqblvM3IeNzyRKEuIV
 ahLiKlQi5yYz3gk3mSHM8fLraNe2OVwpWzguzic0wOx/mCRMbS38HIuaIR7FuOGzm23VM5C0cJ
 Nn1CdYNaQq65+ZW7MLesE79kk7ccXUV7W6jxdlniCnzmv1DJSWnso7sn+0O4fLrgXk9ETWyUQj
 G1LTMovYuHA27XhpNv9EDEiS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:15:07 -0800
IronPort-SDR: ahMIH6VADxBtNa9HQR4ouPqnrzLNVR5sfgIEPlCIwgA5y0A900GRbCSNSEluB9XypR9dcLcucz
 rFlrZF2nEhAFyv48aWszEOudkBE8rAA+Cz+OM7fmKTQlcpCDOwMHSP2YYoHQ84vwF35UbsUJzO
 9sXSnB3+l2xLEhT/on0n2VP1K6b60U8iCXO1bpe36Sn9nPDFnITPBr6FzBCPbd8zbpU7XNYs50
 P7Vr0gHTCF6zx+v6keMxBPRsR2On8ySPIekPfyXqANLy3yc3FiyXX5lUatgr2MWqiNMzELbhPc
 TuM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:30:55 -0800
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
Subject: [PATCH v2 4/9] scsi: ufshpb: Make eviction depends on region's reads
Date:   Tue,  2 Feb 2021 10:30:02 +0200
Message-Id: <20210202083007.104050-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 42 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index de4866d42df0..bae7dca105da 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -18,6 +18,7 @@
 
 #define WORK_PENDING 0
 #define ACTIVATION_THRSHLD 4 /* 4 IOs */
+#define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -644,6 +645,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		if (ufshpb_check_srgns_issue_state(hpb, rgn))
 			continue;
 
+		/*
+		 * in host control mode, verify that the exiting region
+		 * has less reads
+		 */
+		if (hpb->is_hcm && rgn->reads > (EVICTION_THRSHLD >> 1))
+			continue;
+
 		victim_rgn = rgn;
 		break;
 	}
@@ -799,7 +807,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -827,6 +835,16 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * because the device could detect this region
 			 * by not issuing HPB_READ
 			 */
+
+			/*
+			 * in host control mode, verify that the entering
+			 * region has enough reads
+			 */
+			if (hpb->is_hcm && rgn->reads < EVICTION_THRSHLD) {
+				ret = -EACCES;
+				goto out;
+			}
+
 			victim_rgn = ufshpb_victim_lru_info(hpb);
 			if (!victim_rgn) {
 				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1034,8 +1052,13 @@ static void ufshpb_run_active_subregion_list(struct ufshpb_lu *hpb)
 
 		rgn = hpb->rgn_tbl + srgn->rgn_idx;
 		ret = ufshpb_add_region(hpb, rgn);
-		if (ret)
-			goto active_failed;
+		if (ret) {
+			if (ret == -EACCES) {
+				spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+				continue;
+			}
+			goto add_region_failed;
+		}
 
 		ret = ufshpb_issue_map_req(hpb, rgn, srgn);
 		if (ret) {
@@ -1049,9 +1072,22 @@ static void ufshpb_run_active_subregion_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 	return;
 
+add_region_failed:
+	if (hpb->is_hcm) {
+		/*
+		 * In host control mode, it is common that eviction trials
+		 * fail, either because the entering region didn't have enough
+		 * reads, or a poor-performing exiting region wasn't found.
+		 * No need to re-insert those regions to the "to-be-activated"
+		 * list.
+		 */
+		return;
+	}
+
 active_failed:
 	dev_err(&hpb->sdev_ufs_lu->sdev_dev, "failed to activate region %d - %d, will retry\n",
 		   rgn->rgn_idx, srgn->srgn_idx);
+
 	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 	ufshpb_add_active_list(hpb, rgn, srgn);
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
-- 
2.25.1

