Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74E6C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EEC207B0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhA0PPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:15:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30681 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbhA0POe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760474; x=1643296474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vas6vzHGrww2zViujLO89n+jvEzx6usSOUxeeboPCy0=;
  b=KsYpOtT+j2da7IBvHQfgQA57aBpTPmhWYnQfGSlR9/nXREN6lmNNf0Hs
   w72QBWC/vuKzSGlrR/kJg/MQcBHdtptmSy7EiZJvbDH70jQB8HbVQFzD2
   Nkmxwg7QRfCkGTGwTak3BgCMApZJ/ZPwmw/LXwAQTkMswK2TjuLGdbPHg
   k3DkjQSKLMgCB2eA7F3cPYh/weFZZXea3wd5yZGV8vHQsCO4BDlasJ2/y
   5PVKrkukHLj/al3jqq9sJRJMHuJU3vRI33o1gH3GoIo7ItiROkB33Yddf
   UUJejS/aPVkbEqJW8Th/1xTzghzL8kSKIy7VHv2c8tEe4pRicESUghZLG
   A==;
IronPort-SDR: CKpC2PQqpieDUCpgSwtHAqea8m9MiqatktAj2uVZGRScfrGH/SIOzuW2QxgDtg3/GujuD1s9Ln
 c5KuJCsOduUuJ26mns6OMbpKYsWJ271b8uENmnmL5OobKfCgTZTDkE6gSt4KchHRUhIqgqXKJz
 RLQxXkkI1wrGtKyBn4rruq7h0DUy76iDqAEqVT8Vut3esOuQ8hu7Qhp4SBfd6AsplHFfdINdZ/
 tcRKfXWcQNJkcgZrdTmUVH0KBANLCPjAL43cQN9rf3TWGGTRycMQJaj88h5IvDZ15PKCbhQH/2
 h0E=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="158454216"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:13:15 +0800
IronPort-SDR: Q1QhEK+BDVTxgKcbnvbh9gMlWPcj1ZQISaVximfggfQe0EjQ2N81UhcyxLiHuORwku/OlzT4sj
 58lC85miidCo5K+x12qJp7bZcW6g+LILUni2QEZnun4uWT/TPJQMEhGLmnS8+FSgkzXJPV6g8p
 S0BPto12LN0UedXbYtQIn0mKWxJ0tZ7sYHs3H8HtOLzfStenvMFkY9wt53OnAXYZoG0PiA6EG5
 0oV0VtadNRE5TnjLt9jfzYbHh36pPR+vrX78bwW5rg6+Vbm3kEvhR9zlHd29lxtxmAN/qeq92d
 al+kWeAyDGl0J7hffmjImxxp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:57:36 -0800
IronPort-SDR: w64i1XuSCkd1qWhfzqgpJYu/6un6gWY5MG5cMco/LTb0oWD2ot+QiV2kbuxzecbkMtSV4YRWPm
 lPGZvhbtkE52hm2QrE1N60R4E44rdvU5Xz3NHlY28Vbhz/ttPXF9PdDiTFCLsJD7pVOVB+E57t
 bsrqGbSG08jANbj7G4moWJIv6Yow31nlL8gOEw94LoQYGeKMgVlFvjuh6Qo++a4UVk/Dhf3mvT
 AHrYZdQ3uoElBZ0SvI8tNxqhey2ROcl3Ip8DtJQZRJW8Pl6yzu9qu5ZCpI7WavnuixWkmxzvvk
 5LU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:13:11 -0800
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
Subject: [PATCH 4/8] scsi: ufshpb: Make eviction depends on region's reads
Date:   Wed, 27 Jan 2021 17:12:13 +0200
Message-Id: <20210127151217.24760-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 44 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 51c3607166bc..a16c0f2d5fac 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -18,6 +18,7 @@
 
 #define WORK_PENDING 0
 #define ACTIVATION_THRSHLD 4 /* 4 IOs */
+#define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -639,6 +640,14 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		if (ufshpb_check_srgns_issue_state(hpb, rgn))
 			continue;
 
+		/*
+		 * in host control mode, verify that the exiting region
+		 * has less reads
+		 */
+		if (ufshpb_mode == HPB_HOST_CONTROL &&
+		    atomic64_read(&rgn->reads) > (EVICTION_THRSHLD >> 1))
+			continue;
+
 		victim_rgn = rgn;
 		break;
 	}
@@ -789,7 +798,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -817,6 +826,17 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * because the device could detect this region
 			 * by not issuing HPB_READ
 			 */
+
+			/*
+			 * in host control mode, verify that the entering
+			 * region has enough reads
+			 */
+			if (ufshpb_mode == HPB_HOST_CONTROL &&
+			    atomic64_read(&rgn->reads) < EVICTION_THRSHLD) {
+				ret = -EACCES;
+				goto out;
+			}
+
 			victim_rgn = ufshpb_victim_lru_info(hpb);
 			if (!victim_rgn) {
 				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1024,8 +1044,13 @@ static void ufshpb_run_active_subregion_list(struct ufshpb_lu *hpb)
 
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
@@ -1039,9 +1064,22 @@ static void ufshpb_run_active_subregion_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 	return;
 
+add_region_failed:
+	if (ufshpb_mode == HPB_HOST_CONTROL) {
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

