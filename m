Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B253C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E22DC61969
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCVIMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42789 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhCVILv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400712; x=1647936712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fCxw34cMsIYMmemsyAok+SNjOklldfJqd7WsyeleVS8=;
  b=A/K0gW6ep5B0MuUUpbr8SwTSrI2FEJERVzYoFmAgVnL7kW2Dm0WFTI11
   2BVeI4TSWKjjfwzrqRM23ejfPI2IC3qjW3FR0FSXFxCm51jGwKcLAW3nt
   zlhaGGVPMRtEyWE9eGNYUgqqLfORl/qMA65rR4dQs+9y+wTg5qgiu0rBu
   ZZ8itWGSxaj5DqCS6gE7RUTeUopKm3YOaHkNrxK17m/qHa9gwGTFUowq8
   mmSuZjn7kwK2+7eUnJRdiG5pBnHTFpSxS/JUxh2OC+WQuIUlAJRdw//lU
   X+ez4MfHtXmdDP2LuHlB3c3R97fZDpjTvpsKXnbG/Mm3GiAMcfrhrt2I3
   w==;
IronPort-SDR: GaKNX7HiiR24tBWBR+E5Vlox5lj3vtLhoG3ANvCnV5GUj6mW1XbKTffu+G9Sy4MLJzVduZHGah
 5YinputEzFzJc5VeN9nOJaqFNxEyh+GCxz4mr0WTTL6WdQNE41Ct9LPpq6nJFh10HkUVueJ0T9
 jVgI38aGx/dTvqCyLQyTNzgu3tzlXFadRsVfyjQqNvgfyCEbpyHiOGP81VGITlhFs0Jp4fYBfl
 Tu9fjzSwR0n47MVX/2oIQaeGn2mj+XcUOVzKrXXoe7RVqQKGdbkbRepZN7+/MTGPmxnlJMJ8r3
 tX0=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="163812193"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:11:51 +0800
IronPort-SDR: SdC/y/YDFK/q39fEKEKX/h+u17xGYFtKf9+agx0Nou0Hqyo5ixKEoMLBTVkjclRmTr4V6NYRJs
 oSTgl1WLgQ28kzhcRolSkmYbZamCmh9KST7ek5FGgNbyjEIXJ123KPZA4p/ZHZ+peaY5T+v7Eo
 ToZ6+XdNWRgJXfujTcaPg+eH6OvVSHFbzoOVGo0zpTeOptlpYAxms/QRiNwYTYurUqFj9rX5Yh
 c7C8JKmxc1f7rW5GZxVWFtfJtkgWMZMEU0B3Dpo53pD8suq2wNZaOyrZMbhcqps22HDI0gcg84
 sTVn3jznqHG1lCftKyTcPqfg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:52:20 -0700
IronPort-SDR: yvpiEVtlsKHwjq504ZMTrr+w+IGaWU5egGkxPvZk6WYlCrOm9IFWft1kGaLXL8i+juB5pjkF9R
 1NrDczEXNa+PRvLyw9W5F21sGg06dgJUjC9zy3j7lbL8gf51KSAAanIu32kVqowseVUF0zxssE
 UheGxY8U5ahq4mcXDtGxpiKnio/TxhGRqMCOf2cQfDlvkScPyDjDqMdUYxtWSxNlQJM+j9oBpe
 2iBirLn4Rx4hPim2aEGYK3gjd6qH+3lVa6gsd+w6p1hRweTs2XcBMQRaozjdGSHiIJPTuwwkY0
 WNQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:11:46 -0700
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
Subject: [PATCH v6 05/10] scsi: ufshpb: Region inactivation in host mode
Date:   Mon, 22 Mar 2021 10:10:39 +0200
Message-Id: <20210322081044.62003-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
index 5e757220d66a..1f0344eaa546 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -904,6 +904,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1100,18 +1101,37 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
 	return -EAGAIN;
 }
 
+static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
+					struct ufshpb_region *rgn)
+{
+	return ufshpb_issue_umap_req(hpb, rgn, false);
+}
+
 static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
 {
 	return ufshpb_issue_umap_req(hpb, NULL, false);
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
@@ -1120,6 +1140,8 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 
 	for_each_sub_region(rgn, srgn_idx, srgn)
 		ufshpb_purge_active_subregion(hpb, srgn);
+
+	return 0;
 }
 
 static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
@@ -1141,7 +1163,7 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			goto out;
 		}
 
-		__ufshpb_evict_region(hpb, rgn);
+		ret = __ufshpb_evict_region(hpb, rgn);
 	}
 out:
 	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
@@ -1275,7 +1297,9 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 				"LRU full (%d), choose victim %d\n",
 				atomic_read(&lru_info->active_cnt),
 				victim_rgn->rgn_idx);
-			__ufshpb_evict_region(hpb, victim_rgn);
+			ret = __ufshpb_evict_region(hpb, victim_rgn);
+			if (ret)
+				goto out;
 		}
 
 		/*
@@ -1839,6 +1863,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1847,6 +1872,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1971,6 +1997,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 32d72c46c57a..7afc98e61c0a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -187,6 +187,7 @@ struct ufshpb_stats {
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
 	u64 pre_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

