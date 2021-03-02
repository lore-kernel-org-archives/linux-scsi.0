Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359D5C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D25660232
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581532AbhCBS6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:58:01 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11077 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351061AbhCBNbV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691880; x=1646227880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LMnp9+2/jvR23G64ulLSsuDDDVG9gP189H3fURWEBWA=;
  b=p+hdDJmq6jV/BLuWc/FbUFsP36bysiJ0ALkNgGBJ+2W0PgC16GfJIlZR
   LeiloI1pJR877dOWjHdrysAVmnxJjiZ8zVz4Yv/n010B34t5P0rymltsN
   mD3U1YA1F0OoXCcTR/nOYhM90G90GtvUVAZhIVWD8vI8lEfhr78Wrg2Em
   UaCDYa+E3xSvGWKXHXvaoc+qZDvf/Y0OLA2XsNl2FIXKWfryXmS4mXpCh
   q45+nG56kq705AVSJo6uPrTkxWrUdr142k6F65lrP9CNWHknf3Yk77rO8
   6bjGV156IC3DlTHE6Za6DW8StZk2lAPH2v099u+cw/4X58EINxvjWZ9Lg
   g==;
IronPort-SDR: vE5MwXPycqgySBPyRak7EZ0iHt4oNt4+t4f92ImO+dAV8iv0fjxjPQM2uqfKVzigS5g6Cz/LoC
 KPOUDh9l6ea1OqkfUvkt6weeYG38yjuNg4E8Uq2FckyGQoekVq5XJleA8OQQoxOaWDIhWgwbPB
 PFYv3bEj/XkN/+qugQSWA6M6Ke0RPairS7ehauLvSrv32Qkt+Ya+f8fZyRP0tW/+g2q42trpjq
 O1TW7tQs/n4VlV6YO3ERH7bH5o+o1NP9TYXmn/wJ9ZPS0GIzdgM/UoSpsmAtaTKiBMtb7bBOSu
 F+k=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="271767219"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:30 +0800
IronPort-SDR: 54uCqvwDI3Dt861m98yg3MNHuUcqNDmLE41FFPsnpK4QxHW7Nx7hZgIzaw1JYL4h4yTGGEZOko
 4ciGwZuC9ZcfMf6k3crwSVFswon+CVNnshc1zEl/QIv9iMuE8GAOpBwXy5Q0RnTBcl/U6PNdRm
 r9ltMu1q15MyRgAmULOwyvfujDBTYD1NDaYUEWr3bclrF+ko+0WtDApQsM29cV2R8FLwCHS7N+
 Ctt2x6F9ljxIRvDJ7CJMH+wPYLqMkMDQ80h10egQHDzNF3D62ehnDNtBngCZ8Fvlu9uGw+3BJG
 sDCOoExjvSbNATc+dY/SRaUs
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:07:46 -0800
IronPort-SDR: wlw30RL21bPYeOyNaYxbngMgSQUNwEbnhvETLY2RGLA5zbf3d1hfnKCT7Oy2MN+bLJgehdtQwM
 p7ErXiSpaOnUpCrLx12bKzRaanXIdXRQXnMBHtdz7exmV7UNymvFxkkmZuBCZ7+lDR0+pYe/1/
 7e0ecNYC0MDHVdhv59E5twbyoA6X98kzg2+HOlGTTdvuDJx96eNnFwcjGKrnfng5IstCB4TFf/
 gLDxX8biWmFRYOEiLylp2UFx+uZ8fD9gX3vh9zDvmgRMFOilpTDGMlhURB193dtZcjmI3D6jWM
 6mg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:27 -0800
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
Subject: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
Date:   Tue,  2 Mar 2021 15:24:58 +0200
Message-Id: <20210302132503.224670-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I host mode, the host is expected to send HPB-WRITE-BUFFER with
buffer-id = 0x1 when it inactivates a region.

Use the map-requests pool as there is no point in assigning a
designated cache for umap-requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 6f4fd22eaf2f..0744feb4d484 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -907,6 +907,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1103,6 +1104,12 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
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
@@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 	struct ufshpb_subregion *srgn;
 	int srgn_idx;
 
+
+	if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
+		return;
+
 	lru_info = &hpb->lru_info;
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", rgn->rgn_idx);
@@ -1855,6 +1866,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1863,6 +1875,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1978,6 +1991,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index bd4308010466..84598a317897 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -186,6 +186,7 @@ struct ufshpb_stats {
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
 	u64 pre_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

