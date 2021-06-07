Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD29C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 570A061164
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFGGRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:17:04 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52776 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhFGGRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046512; x=1654582512;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1XKwUM4VXln0o2FqHchK+4k1fpAauX0jY9w4mGCeyYw=;
  b=DkqPRYBnuxNQhcpJ2uG2M+HI3gcbPqev/80v6PcLTVKXyGScnLJjpGiJ
   GSk3KpaPwJseLCtQIS+UjPznFLj1IFne125qdHEELvcWUMazTS4JgNV1X
   nj+JgKeUM7M81ow9PGrNUsvyZvB4Fqn1ULnQa01XCDe/P9Atlv+7mxMwK
   9sKIhbf2uuXfsN3vMS8kSNZyccbYLyHZvcgLqqvpNWMll9BskTy7RJeh9
   gFD0a0AVLuPZtzDPcvwOaPi8GtohTE5zUwooSV59+YoIHZjBmcLKq2RKP
   bSBnhX9LEfns3r3ae6KJitvw+VVWsw6IWMLCYSJuu3UqJ8N2TUuX5i5HR
   Q==;
IronPort-SDR: eZh1ax7/sSm+UvAJLxXyzHMP2YUxgiMRGzN5c2+Df/fnmNQ1O9p6+uqm+arj7G2qDDjYVe2HAN
 u0pLYhRbBLyQeFAvNPhxRSCynaL3zi/8LvILMIciXqYYDOU7LvLuEGVG9PbzsQzCsIx3C0Vr4I
 RWJn1zWRNfxDwFguGzxBdAmtuGcE5IGvo9HmCXf9a9USo7wstIJJiHbvLwsafZAuQNc3cpdhT1
 6Yvo+Bm8q7IxonDtg1d2Y7dS/cHWSUBYAn4Pbs2BfYrPBkTT5m8JVU8ZxxD1n0kd6tkA/6AOTJ
 CUc=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="170277913"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:15:10 +0800
IronPort-SDR: jazZu2vO/RDZfRCvTix9g2y59aShKTl6Kq13mgbCwzxK/UpuQj/KR2HgUITCFqEMBScTcV/nxM
 8dkJ+XMSgAlrcg/DiIjaMbrUVoDthJoyPuvvcEBKYvfkRi21rMsk0QfYcrgtUv5MXntLEqH3c2
 kU+xUEEQY7VSOeq4g2IGqbNJn47vKaegF3r2Vf8qSQ+eAm7OIS3brbQNcky9M+FJiE8f7P+Cxy
 lIVcyOCiAVdeTOOVj086FotnDuAVSzaqo/0mJZIDOi4/6RwDLiH7eFhSLllrx9J3B+DpqnhSGc
 tGZC5fEjadzNJOZOOiwgpvKA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:54:19 -0700
IronPort-SDR: wmoWBl7FImJqVPoTa9p1//KgMMcZL8YnW+3XamLjw3SvZfuyZLKCI3WJ/6T7d6wSEorqp3XgAh
 ArKzQ53CaVL4mhvj+Vw7Sjzvpmlz+hBB+KUAiCgz4rD34sNOhDjLzLFfR7+aWOC8E/0qbud1TQ
 BMqaOFTx/Yt/lg53GUqQO4lorAoXdtiSXrNXbIrez9mAwQmSIi9RZH3+49r6OHb5ROZipJIS2K
 b1zGkdHThiqnXLf62dCXOi4ylNWU0Wm2g6LYr20k97iZjiUIxNEbA6/30dlRv0VB1qGFpRTg/Q
 9o0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:15:07 -0700
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
Subject: [PATCH v10 06/12] scsi: ufshpb: Region inactivation in host mode
Date:   Mon,  7 Jun 2021 09:13:55 +0300
Message-Id: <20210607061401.58884-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host mode, the host is expected to send HPB-WRITE-BUFFER with
buffer-id = 0x1 when it inactivates a region.

Use the map-requests pool as there is no point in assigning a
designated cache for umap-requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 46 +++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index f9efef35316e..0ef46aa71045 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -691,7 +691,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
-					 int rgn_idx, enum req_opf dir)
+					 int rgn_idx, enum req_opf dir,
+					 bool atomic)
 {
 	struct ufshpb_req *rq;
 	struct request *req;
@@ -705,7 +706,7 @@ static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
 	req = blk_get_request(hpb->sdev_ufs_lu->request_queue, dir,
 			      BLK_MQ_REQ_NOWAIT);
 
-	if ((PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
+	if (!atomic && (PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
 		usleep_range(3000, 3100);
 		goto retry;
 	}
@@ -736,7 +737,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	struct ufshpb_req *map_req;
 	struct bio *bio;
 
-	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN, false);
 	if (!map_req)
 		return NULL;
 
@@ -914,6 +915,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1091,12 +1093,13 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
 }
 
 static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
-				 struct ufshpb_region *rgn)
+				 struct ufshpb_region *rgn,
+				 bool atomic)
 {
 	struct ufshpb_req *umap_req;
 	int rgn_idx = rgn ? rgn->rgn_idx : 0;
 
-	umap_req = ufshpb_get_req(hpb, rgn_idx, REQ_OP_SCSI_OUT);
+	umap_req = ufshpb_get_req(hpb, rgn_idx, REQ_OP_SCSI_OUT, atomic);
 	if (!umap_req)
 		return -ENOMEM;
 
@@ -1110,13 +1113,19 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
 	return -EAGAIN;
 }
 
+static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
+					struct ufshpb_region *rgn)
+{
+	return ufshpb_issue_umap_req(hpb, rgn, true);
+}
+
 static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
 {
-	return ufshpb_issue_umap_req(hpb, NULL);
+	return ufshpb_issue_umap_req(hpb, NULL, false);
 }
 
 static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
-				  struct ufshpb_region *rgn)
+				 struct ufshpb_region *rgn)
 {
 	struct victim_select_info *lru_info;
 	struct ufshpb_subregion *srgn;
@@ -1151,6 +1160,14 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			goto out;
 		}
 
+		if (hpb->is_hcm) {
+			spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+			ret = ufshpb_issue_umap_single_req(hpb, rgn);
+			spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+			if (ret)
+				goto out;
+		}
+
 		__ufshpb_evict_region(hpb, rgn);
 	}
 out:
@@ -1285,6 +1302,18 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 				"LRU full (%d), choose victim %d\n",
 				atomic_read(&lru_info->active_cnt),
 				victim_rgn->rgn_idx);
+
+			if (hpb->is_hcm) {
+				spin_unlock_irqrestore(&hpb->rgn_state_lock,
+						       flags);
+				ret = ufshpb_issue_umap_single_req(hpb,
+								victim_rgn);
+				spin_lock_irqsave(&hpb->rgn_state_lock,
+						  flags);
+				if (ret)
+					goto out;
+			}
+
 			__ufshpb_evict_region(hpb, victim_rgn);
 		}
 
@@ -1853,6 +1882,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1861,6 +1891,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1985,6 +2016,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 87495e59fcf1..1ea58c17a4de 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -191,6 +191,7 @@ struct ufshpb_stats {
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
 	u64 pre_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

