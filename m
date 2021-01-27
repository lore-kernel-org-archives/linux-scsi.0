Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D4EC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F61E207E8
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbhA0PT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:19:26 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46031 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhA0POo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 10:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611760483; x=1643296483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pdp00ko/BXv1nquiuxIwLaZHqLcdvOgRkvfcz0tbUgY=;
  b=Oz2ZaqBf39evtQt0en59730/oYAMFCDBL0zRDQYVAhPhPA3LxDVvNdTA
   3OSq6XvM3Gbm74gwzuwrFm2+/Tm6PQOcb7RFRaGKRQZ8VgGqLiAqNWcXQ
   Qragj7jekBwmNTO5DGmWgcrbxOmQC4IV9jompsYKPAjcG+vM8Ckv0BzEq
   zXs7jG1EgHzcb+pKtuOaGngx5oJlSgmsIOIjNsFiEVrzEsvaDhMltoDFO
   Qn2QnPb2a341FKNVg2WBwTXAAGXlt9q6owIMpulbPNNmGXYP4tnSetu8E
   JfCXP+qPFDutEV3pvOwNMk8iVCZb1rCB+Yl9baYpiDLMGFlTXUyMnbKOa
   w==;
IronPort-SDR: fWk0L/jqTVvGlQCP4Q+NI6KdFzpkTHsgwP7nhQUIaSpRmWtVevD4mLb6pSOJPWGqlaY4Pp1kdI
 36+3lRA2rLDPVRkyvCM7wI29e60iS8hZaAmyIQ/qcv8Zz4uVIF7pWoLUpeH6c2ntnwM6NehKhf
 6VyZBp1vIPmsLnVQkPxeD/YlqcFEt4+2m8hv4hWi4ldqvJp4Njr+DLkLMHskfycM5pvUhRM0UQ
 hVGFwsaxx9fenU/mhQIWd3FRVs7ROKPjB+PeRiwna9w5aBcTVh6Mzs9gv+tfZv2N6Hw8o7Ftis
 LFY=
X-IronPort-AV: E=Sophos;i="5.79,379,1602518400"; 
   d="scan'208";a="162900980"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 23:13:24 +0800
IronPort-SDR: 6elZPfMKOwleYU3U8IMoN7Y499P3YfgodhKrtm2FpuMGwRc719XDFuyw08RJWinUwRwGFTbQWD
 db7DK7vdOIfV3PJPCXSm+rfrVXLIVMPnXcU0Kj3kpKFB4mSkz9nYOYqGhPmXu+l3k+/22L6hN8
 r3n7ewd9Ut1ciQaMV4NvaMOVjj6T1X9TYLmaN3xnKaykVUMT2vJtnaxrL7KhBWGQznmSBQvG99
 g4+1chtk+A7yIglzYGKEzEvk/Jn/IB5NgKGZI+80L8rpLBTgE1i94Y6tokSWHiaZY9UJj+NzzN
 cK/Hw0vFf4HOY/Gwf0aitEel
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 06:55:43 -0800
IronPort-SDR: v5NbBKQE6kS+PQEC262KkZesCe0NZ2CTQetXbSsZIB9pQMmYfZYl0tL3bBhSJrPjzeY3GmA1EK
 X+fgBmQVCfqySuZmI5W1UlfjFLQzOLwYGJwZQasBCqPDn9XFwT95py8KmE9eHDq381rXdzYeco
 GhcfS5jDZW5Zj7pyvUd+Vsa8hj9VCoJThYNFH/EIspUmtP5lRleAh5B2ZNhc9GXusd2jtQulDI
 gu6RhtTb8LT6LU+51nLXXUFJTNJRqJ47mg9Y4Z1dT4ntjhPYMH5hzzrA0biMzOFzg2arSg90QN
 XYI=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 07:13:21 -0800
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
Subject: [PATCH 5/8] scsi: ufshpb: Region inactivation in host mode
Date:   Wed, 27 Jan 2021 17:12:14 +0200
Message-Id: <20210127151217.24760-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127151217.24760-1-avri.altman@wdc.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 120 +++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshpb.h |   4 ++
 2 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index a16c0f2d5fac..c09c8dce0745 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -386,49 +386,66 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	hpb->stats.hit_cnt++;
 }
 
+static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
+					 int rgn_idx, enum req_opf dir)
+{
+	struct ufshpb_req *rq;
+	struct request *req;
+
+	rq = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
+	if (!rq)
+		return NULL;
+
+	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
+			      dir, 0);
+	if (IS_ERR(req))
+		goto free_rq;
+
+	rq->hpb = hpb;
+	rq->req = req;
+	rq->rgn_idx = rgn_idx;
+
+	return rq;
+
+free_rq:
+	kmem_cache_free(hpb->map_req_cache, rq);
+	return NULL;
+}
+
+static void ufshpb_put_req(struct ufshpb_lu *hpb, struct ufshpb_req *rq)
+{
+	blk_put_request(rq->req);
+	kmem_cache_free(hpb->map_req_cache, rq);
+}
+
 static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 					     struct ufshpb_subregion *srgn)
 {
 	struct ufshpb_req *map_req;
-	struct request *req;
 	struct bio *bio;
 
-	map_req = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
 	if (!map_req)
 		return NULL;
 
-	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
-			      REQ_OP_SCSI_IN, 0);
-	if (IS_ERR(req))
-		goto free_map_req;
-
 	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
 	if (!bio) {
-		blk_put_request(req);
-		goto free_map_req;
+		ufshpb_put_req(hpb, map_req);
+		return NULL;
 	}
 
-	map_req->hpb = hpb;
-	map_req->req = req;
 	map_req->bio = bio;
-
-	map_req->rgn_idx = srgn->rgn_idx;
 	map_req->srgn_idx = srgn->srgn_idx;
 	map_req->mctx = srgn->mctx;
 
 	return map_req;
-
-free_map_req:
-	kmem_cache_free(hpb->map_req_cache, map_req);
-	return NULL;
 }
 
 static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
-				      struct ufshpb_req *map_req)
+			       struct ufshpb_req *map_req)
 {
 	bio_put(map_req->bio);
-	blk_put_request(map_req->req);
-	kmem_cache_free(hpb->map_req_cache, map_req);
+	ufshpb_put_req(hpb, map_req);
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
@@ -483,6 +500,13 @@ static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
 	srgn->srgn_state = HPB_SRGN_VALID;
 }
 
+static void ufshpb_umap_req_compl_fn(struct request *req, blk_status_t error)
+{
+	struct ufshpb_req *umap_req = (struct ufshpb_req *)req->end_io_data;
+
+	ufshpb_put_req(umap_req->hpb, umap_req);
+}
+
 static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 {
 	struct ufshpb_req *map_req = (struct ufshpb_req *) req->end_io_data;
@@ -501,6 +525,14 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	ufshpb_put_map_req(map_req->hpb, map_req);
 }
 
+static void ufshpb_set_write_buf_cmd(unsigned char *cdb, int rgn_idx)
+{
+	cdb[0] = UFSHPB_WRITE_BUFFER;
+	cdb[1] = UFSHPB_WRITE_BUFFER_ID;
+	put_unaligned_be16(rgn_idx, &cdb[2]);
+	cdb[9] = 0x00;
+}
+
 static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
 					   int srgn_idx, int srgn_mem_size)
 {
@@ -514,6 +546,27 @@ static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
 	cdb[9] = 0x00;
 }
 
+static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
+				   struct ufshpb_req *umap_req)
+{
+	struct request_queue *q;
+	struct request *req;
+	struct scsi_request *rq;
+
+	q = hpb->sdev_ufs_lu->request_queue;
+	req = umap_req->req;
+	req->timeout = 0;
+	req->end_io_data = (void *)umap_req;
+	rq = scsi_req(req);
+	ufshpb_set_write_buf_cmd(rq->cmd, umap_req->rgn_idx);
+	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
+
+	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
+
+	hpb->stats.umap_req_cnt++;
+	return 0;
+}
+
 static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 				  struct ufshpb_req *map_req)
 {
@@ -673,6 +726,25 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
 	}
 }
 
+static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
+				 struct ufshpb_region *rgn)
+{
+	struct ufshpb_req *umap_req;
+
+	umap_req = ufshpb_get_req(hpb, rgn->rgn_idx, REQ_OP_SCSI_OUT);
+	if (!umap_req)
+		return -ENOMEM;
+
+	if (ufshpb_execute_umap_req(hpb, umap_req))
+		goto free_umap_req;
+
+	return 0;
+
+free_umap_req:
+	ufshpb_put_req(hpb, umap_req);
+	return -EAGAIN;
+}
+
 static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 				  struct ufshpb_region *rgn)
 {
@@ -680,6 +752,11 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 	struct ufshpb_subregion *srgn;
 	int srgn_idx;
 
+
+	if (ufshpb_mode == HPB_HOST_CONTROL &&
+	    ufshpb_issue_umap_req(hpb, rgn))
+		return;
+
 	lru_info = &hpb->lru_info;
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", rgn->rgn_idx);
@@ -1368,6 +1445,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1376,6 +1454,7 @@ static struct attribute *hpb_dev_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1392,6 +1471,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index b0e78728af38..47a8877f9cdb 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -35,8 +35,11 @@
 /* hpb vender defined opcode */
 #define UFSHPB_READ				0xF8
 #define UFSHPB_READ_BUFFER			0xF9
+#define UFSHPB_WRITE_BUFFER			0xFA
 #define UFSHPB_READ_BUFFER_ID			0x01
+#define UFSHPB_WRITE_BUFFER_ID			0x01
 #define HPB_READ_BUFFER_CMD_LENGTH		10
+#define HPB_WRITE_BUFFER_CMD_LENGTH		10
 #define LU_ENABLED_HPB_FUNC			0x02
 
 #define HPB_RESET_REQ_RETRIES			10
@@ -158,6 +161,7 @@ struct ufshpb_stats {
 	u64 rb_active_cnt;
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

