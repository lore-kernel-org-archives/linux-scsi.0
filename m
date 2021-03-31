Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1591DC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA358619D7
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhCaHk4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:40:56 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8986 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbhCaHku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176450; x=1648712450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hjAeagR9YTnezWZbY3MD3Zaa3a4X2VoOGgm7iCNox3o=;
  b=QSlu05itHP6Tt9h3CfWMmPFiZ/Mrzaog0SEX2HZVxCz9hapVAH16K1LX
   v3r6IJkgNDQHsYIbeHbOFF6dwAvmQssLxgp8OR1JR2m/dB7gRNj5+h5Ql
   EDdlrY1FzK7jIrWF9xqoc7m0ISyhkrLDi5y86T/S6GJEGc8s9TqSks853
   mrtZnsBeKSt+IuvLLr54zm4eoFu28uy8T5bePT0Htwt1wHvQC9UK/mMGg
   DFj2wc/2AzyUqsCVTgw7EHAfJYf5aj2wKofJbSz1Hy1euB3RpZ/td7nY5
   rdmpj5a8BicbnakvSuTFTFBuYQWBQHRG0tYtSvQn27eU14rpB7Hks4+ao
   w==;
IronPort-SDR: FdfnRWg8d2sXP0wygZVGNnfxAxFuew1kRBeZthmsgS0Omo4mEjVddtVg/AWtnMtmUsuiW/WENr
 9DriNwwSb28p/6TIsxs7m51eOEcW/ML3/LiJx4HUNyJMdZ+CFAvckLWplkxwtZHkD+U7Qy91qp
 Whx6jBvnYpPhASJQO23wdZ5Uf1YFLh61g0WU7HibWCu3uSBF+5z247wHrsRWO4Rlj39giRBexd
 C3eyN4D8W13iZFYTZL8dNTkkv2dRlw9A0v+fl8NvsYTg0JsfYJ2Jcmcs2nvNJqyF61szH9wCy9
 nRw=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="274239181"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:40:50 +0800
IronPort-SDR: m0hys45+51AvJS/1bWE1f8iw8XQrzuj2St6pcE6thb/bRc7ALHUlbba3nX4fvLep3soM+TDsiE
 1433JQRrm36uG8VewC65d4rm4A/GTQ6UtsktlUPnvcAfP1q3Mta3qOgfkQecnHHX4noAFkczpf
 Pjalg0FO7myDQ5GlcerJUmYF0xeSEhRSPxqWFJuWrEgcVf0bm7Jwd2HfqIbTuPGFqoLrqwreE5
 PAc4CgkgffXM46bg0I5FwCbe2JsHjL9p8FTXsfkxnset4PUOv8bkUhukQ9nqxh9T21yrkN9xis
 WGnnA1wuop0WmowMu7Qyid74
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:21:02 -0700
IronPort-SDR: zVzjlyk3zx9/ed4ecnZl54Im2Ul0zLrz0er/iZ3DlsqN7RToaOPZjHV/Y7W1WdD9OLuc5KuvA2
 MdiMj7T/TzjSbtYrNCQEWehdH9cJ4ufZifybZOLHWpu1aEzM+PwyJUU5LVVnCk0PzhGvr5h3cJ
 71cuDw42gIlqAYQNl5aIK+dhzzSdSzORQfKcYb5ZwJ3nHdUKgvQ+4wZ4mm+3BWAQxH+Km9b+zW
 WZjvLHhUKF165D+4NIctzHc7s8qzA3n9Q+JIzf/G6O/MfS81AXOcGz7jWWqXLwzgsgjaXbfe/b
 whw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:40:46 -0700
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
Subject: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Date:   Wed, 31 Mar 2021 10:39:47 +0300
Message-Id: <20210331073952.102162-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
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
---
 drivers/scsi/ufs/ufshpb.c | 35 +++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index aefb6dc160ee..fcc954f51bcf 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -914,6 +914,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1110,18 +1111,37 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
 	return -EAGAIN;
 }
 
+static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
+					struct ufshpb_region *rgn)
+{
+	return ufshpb_issue_umap_req(hpb, rgn);
+}
+
 static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
 {
 	return ufshpb_issue_umap_req(hpb, NULL);
 }
 
-static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
-				  struct ufshpb_region *rgn)
+static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
+				 struct ufshpb_region *rgn)
 {
 	struct victim_select_info *lru_info;
 	struct ufshpb_subregion *srgn;
 	int srgn_idx;
 
+	lockdep_assert_held(&hpb->rgn_state_lock);
+
+	if (hpb->is_hcm) {
+		unsigned long flags;
+		int ret;
+
+		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+		ret = ufshpb_issue_umap_single_req(hpb, rgn);
+		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+		if (ret)
+			return ret;
+	}
+
 	lru_info = &hpb->lru_info;
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", rgn->rgn_idx);
@@ -1130,6 +1150,8 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
 	for_each_sub_region(rgn, srgn_idx, srgn)
 		ufshpb_purge_active_subregion(hpb, srgn);
+
+	return 0;
 }
 
 static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
@@ -1151,7 +1173,7 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			goto out;
 		}
 
-		__ufshpb_evict_region(hpb, rgn);
+		ret = __ufshpb_evict_region(hpb, rgn);
 	}
 out:
 	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
@@ -1285,7 +1307,9 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 				"LRU full (%d), choose victim %d\n",
 				atomic_read(&lru_info->active_cnt),
 				victim_rgn->rgn_idx);
-			__ufshpb_evict_region(hpb, victim_rgn);
+			ret = __ufshpb_evict_region(hpb, victim_rgn);
+			if (ret)
+				goto out;
 		}
 
 		/*
@@ -1856,6 +1880,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1864,6 +1889,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1988,6 +2014,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
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

