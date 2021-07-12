Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C2AC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD68B610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbhGLJyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:54:49 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32809 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241285AbhGLJyp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083518; x=1657619518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OYn10sGIjvUeP/VOinw0S9ZPw0l5lGzPAWp1xmE7ti8=;
  b=HEfH1AzX0Km0sQ33hjK7/iHF/vUZlWi1e0I1dxBR1ZBdsuDp1cnJjNex
   bZyJ1YWF45cX8ZrLEWiAGyqUbIGFTRjySxM/uD0l9rs0RqlrOPtCK/wDq
   B8UMxcsN8yLQ+JyHYBUDdTfHQwopHcLEUPs8bdO3wWPmtvjlFQhM3qiz+
   2ocY90f9xSPVPdS2F6BfR9323JsT/2jT2ofEJcgKbZt61KUJjrdnlnPPn
   8iGScA1+unzhlE1GtI/3QnujiHMSIKEuNKYiPbEooc47g0/Un4i5PlzJZ
   tndeElpArjwVyxVPeecxHR5+mjM6HJTo7elrZYVLIA1Burl7o4adPN4CQ
   w==;
IronPort-SDR: 2ycqrcX/3xRFGHoxv2znYDoV8Tant6ecJCNmripqiEAyBmU5mvVsNZlP2+uME45x4cHW9EBFoQ
 7y03CgpzwfwqIAIRMo9wltVL+3mrITVeTcxo9DaDFQRvlk4GdutjLkEi7W+UTrSPvFe0T3rgIS
 SHroSkDN7uetYj2N2QIjkHroclI1k0GgNKk5vfpzRGZLUx4XxS716mxDMcmcifUeWBs8JxMBaQ
 keAKeQ7ZwUY8PgCYVnfT93bHWvOTaTKu6WwG5qgZrB+5xTHjUgNg3ErFj5JWqvDgMSq+AHX7nk
 11s=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="174920201"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:51:57 +0800
IronPort-SDR: Y/oe6eMbhBEb55P/NpCns6E6b3Sx+7jnGmo4irqmD/2XFrbzAYxSrTqK+xcO054nSDeefHr83j
 p3TD2V5kWQrgmgWlW9k6zlYDhpQYw8pPTEC7MWZBJLzR9PnPBRd8ZTIXTORjAUVxmnrql5esZ5
 KaPzs8Wgbo1KjMelfr9OgoBObMXzuZfNCy93ykGF7nNqxpgU9xtsZ71vIl/fNjE3Lo5G+ze7sx
 YGgSzuhy05j/ywH0S5vq4EvEdxc8OAgUphZk1hmTsUtne0O4ZlSog6lXeFk/N4tjsrttIIdx22
 HhGcObmw1wJOq6dMjSqjfbgh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:30:04 -0700
IronPort-SDR: pIaf8R13+lBggPE2a4HPzjhM8UYXPkzazqjiNQtktrCm215Es6guBCTiqrNAMOj+alQnhmD9EL
 dMaNobQARn7STaa+9kUzs3OcDcP2+RK8/ehLO3uZHfIkm4IoirAP7J/yIirg5ImVmKwY2RZq7a
 lxCpp26tka1v2Blnbu2bW5I6oTsj0MnaYjvp7XS8jyt8hO11TL/uanuoC90D6cOlywU4ErBHn6
 dXFUbOoUx8wH0ZhDINrub8fVqSrEOVxmtQEeDCyWlNXnnypnPNas3zpwyb4wv1CDZNJj/lPuDn
 jYs=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:51:53 -0700
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
Subject: [PATCH v12 06/12] scsi: ufshpb: Region inactivation in host mode
Date:   Mon, 12 Jul 2021 12:50:33 +0300
Message-Id: <20210712095039.8093-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
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
index 1eadfc12b6a7..7b48a9ab1534 100644
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

