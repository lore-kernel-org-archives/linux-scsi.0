Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F8EC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C487E61246
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFPLbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:31:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4785 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbhFPLbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842943; x=1655378943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ZxgchlyaAoOW0pfw6dDegeGqzfsqGa2k1NmSNnm0Sk=;
  b=QknK9mSWWXhRWGwl2zOKetiEdE87y70RYowWk2fiz6BA1YbXGLef0qH8
   qeZTXRJDa4O9fkw7n2/AoO1RI7DMuZLhhjEXTH4JwBW9sO31PyUkIUYpF
   vEcJJ8dXBkHi4P40AQ8t1vyrsozhIbF8C96XjxN+sMjIx0ID+L1/F9Qpl
   sJpvpJOx1qnQ5re3MyB8v6Nve479uz0TQdL8IO2zm+oUgpBxI3GzgbiV7
   fRrZZZyJFx4p2eBhT04pfEPcbXF2o6WPXokje9FvHH1mSVUOirSu0BSgJ
   C92pzETCnJRiMyV+0UVnoaYHfhxlaYS0JLHy7YoyMOOea2QgZKfVbyuTz
   g==;
IronPort-SDR: C/lc5FANPULPgFMRBByW2abHYhMHlwI8fCJ8iB0wT6LEu8qC9/2xVNUbju7lYs6VyDnUvm3lde
 aIE+lDP+lDXpQSzEUyPoT8GOcS38mGpUybMQWiDJB5wc0aDD0e9o/HTWI5AHwtjYpcXKciQ+z1
 8+SWj4jUx/LVU8tmEO3mvrnp/CxTeGxlrrKNGylApqFMtJ8rW7QXboo+kngWEOvxHhHLWQhT0S
 BQG81VuwXcCoA1AQlOmORXHyXQw0+w+hE0dOhT5FT+6OXS/cmPfNFES6FyeITklZeUJyM21+5/
 Lpo=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="172653698"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:29:02 +0800
IronPort-SDR: XounaXtUFI1LtuUvh8JWHMjuKLDMaW7/uIpUzi68uKWNxIywZ2dlT4W3I/TC67TiB92QOvV3Lr
 RWXLLoaGTZbQPe17Tiv17xJrijv4ijSK/XKOsix2wm5IU/QWAL/EX3MHRynaPWomZhjmz0PKm1
 9uKM2P+H1xf/TnezJ2nifTMqBIXHPKQMKiBPKy4cAW6U4TbFGgICtmVehxGGKBKLZ1yDFa+BQN
 e2aU6W3b4tFWLH9HvPWvjhMTtqPRUnu11BeP+xn1opCk9YMG0I/3QWZJEQQuF8DHQxZ0y1nugh
 vibVoTQuyP8PBjC0fNfAgoxV
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:06:30 -0700
IronPort-SDR: /Xcpq+KZvZuCu1PdByFDwDYEVdk0r6jafqjuLb/cehUV1Kh3slH8JoMV2StvfNDM6zB0yzscGj
 Ww45fR0O2pZo8N+J2Z1AG0N8Y276vMw4dgCiunKhV6yItwei622hd/mbgxv9WgUC2gGxDrADb/
 mopi4+Pjcxh//S1Vci908/M/5T5eqLB9PKm62WWCmL2/7p8IoY/jZrPJ9WKBp1siNc6S+HekpM
 Aa5SfGhDOEVeWhHFCnI/hrcdS34HCg7MtCOPYOXSMPpKa6k/1BLIdN80w+le68jXCTr5nT5umF
 ICw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:28:58 -0700
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
Subject: [PATCH v11 06/12] scsi: ufshpb: Region inactivation in host mode
Date:   Wed, 16 Jun 2021 14:27:54 +0300
Message-Id: <20210616112800.52963-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 47 +++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index b61558196290..d6a4b816814c 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -692,7 +692,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
-					 int rgn_idx, enum req_opf dir)
+					 int rgn_idx, enum req_opf dir,
+					 bool atomic)
 {
 	struct ufshpb_req *rq;
 	struct request *req;
@@ -706,7 +707,7 @@ static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
 	req = blk_get_request(hpb->sdev_ufs_lu->request_queue, dir,
 			      BLK_MQ_REQ_NOWAIT);
 
-	if ((PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
+	if (!atomic && (PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
 		usleep_range(3000, 3100);
 		goto retry;
 	}
@@ -737,7 +738,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	struct ufshpb_req *map_req;
 	struct bio *bio;
 
-	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN, false);
 	if (!map_req)
 		return NULL;
 
@@ -914,6 +915,8 @@ static void ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
+
+	hpb->stats.umap_req_cnt++;
 }
 
 static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
@@ -1090,12 +1093,13 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
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
 
@@ -1104,13 +1108,19 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
 	return 0;
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
@@ -1145,6 +1155,14 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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
@@ -1279,6 +1297,18 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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
 
@@ -1848,6 +1878,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1856,6 +1887,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1981,6 +2013,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 33d163e76d41..0204e4fec6bc 100644
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

