Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0960EC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B7F64EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhBRQ6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:58:14 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2097 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbhBRN0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654800; x=1645190800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2SzdTpY078B1u2ZtuNLU5TzOEvdFKNJ83j2vTItjfjA=;
  b=dzEInwJmY5JCHIUz62C5VhK7g/DFfu7HbdMJr9fOHxU1pSyMNuU3FBKR
   RaGzTVG+QZAITlniv8ZfN1CkwawtSAv3ZDGGdjkOkHeD9lovj2CELSHmw
   UcdoGUI0WlQXT0+RTiVSmxGRYn3ClKPbcNn1Xl0uLMNAPgTPY8nJwJUpd
   y4U8NKkcJkMmVP2WZRdkSsNQH779pT+suYIMeQ6M35z3xBrj56c29cXVq
   tQPc06kAOnXYaYKjWQ4PH1HUsSgSkzibRHwpH96l4/JHU68ONVHHkQWKJ
   ZcLY6VsvF1zwD/ym7U/Cqc863nbeQ8wqLon+UEmBCP0CgT2FiHQWCHpSv
   Q==;
IronPort-SDR: qdfiHXqaZh4mqJ/Owqc9Wj5N/SOOp8ZfApNOqzoLg6t++Q79JJvVBUo44L0cxDqa4OKC6n9r5O
 nBpAm9EQEglkuA0/h2io4AXW7ctOKIMIyqK1FWm1Q+9IsIhwmXa/OC91Xs4VHdtl6kMqHCXB38
 7D/msdG83uyQzrF14RB0ekuOGY7ZIBSBNq7l8u30rN6ApgHv5HOlc7miquVB5BkQLRNkhgkQFO
 8cZle2d364zhtZ05rEBzDMUPys9BHtEQI0crMdQ7PYsDoOjFWeSdvIYtPH28sAehUuTRAHYBav
 2+w=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="164746437"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:20:59 +0800
IronPort-SDR: LpUXv1CzAh3Dmejfj1zL4mydo2elw6pcf29t1z037TSj4WLey7ASW/x18UVbMMDqb6uiJpQcwk
 iE400JyEfwCZNKLki7uJ3a5ijV8u1Al+BppG/irMMzDmuZx/O0egmjvm3TzSYXAJlSML32dEkW
 vqrHAYJeuiou9TC2AA5UizKW31J3Wbcg3gNnsj6CUT5UT5ss0vmRZpH7N2g5Yl2PbaBBaMe0AP
 zqdGdeEbIJu9OmIF1hr1vUaSMChWI6RBftOpcmieNLTPakDvALpiKaUrSlpgoh0zdA64rVby1z
 SFxWEy4WiMd/r0iBlbhy8loL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:02:39 -0800
IronPort-SDR: JUoKiuFrdzc4tXp6MCw7/MeVyMJ/dcAWbWXru3ZOdiFVB1k75+y7AgzQgZi+hHY4dLphPoBB+9
 w6/CRVfT6EFAGkFBFr/Z5MXDcsmPCgpdka1t/vLUpzqjwh1bEwxRZah2Htacji5RMEtXDr7SpI
 Q4wwSO815BLQe+EtbB+hOaiT2UqhwCP4MxiD7Khd76OZjsUjuSYD8r5C89qA0c6xecbbzIF/kJ
 AR8Q0FZa9F7IqQABNZWBvFuUkEpeVTGHv1XBTX8y6E5kOPUBTTdl/xmOKcb0CbA+57RkIKAyeR
 PIo=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:20:55 -0800
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
Subject: [PATCH v3 5/9] scsi: ufshpb: Region inactivation in host mode
Date:   Thu, 18 Feb 2021 15:19:28 +0200
Message-Id: <20210218131932.106997-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 120 ++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |   5 +-
 2 files changed, 105 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 9cb17c97cf93..3435a5507853 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -717,16 +717,15 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return 0;
 }
 
-static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
-					     struct ufshpb_subregion *srgn)
+static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
+					 int rgn_idx, enum req_opf dir)
 {
-	struct ufshpb_req *map_req;
+	struct ufshpb_req *rq;
 	struct request *req;
-	struct bio *bio;
 	int retries = HPB_MAP_REQ_RETRIES;
 
-	map_req = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
-	if (!map_req)
+	rq = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
+	if (!rq)
 		return NULL;
 
 retry:
@@ -738,36 +737,57 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 		goto retry;
 	}
 
+	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
+			      dir, 0);
 	if (IS_ERR(req))
-		goto free_map_req;
+		goto free_rq;
+
+	rq->hpb = hpb;
+	rq->req = req;
+	rq->rb.rgn_idx = rgn_idx;
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
+static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
+					     struct ufshpb_subregion *srgn)
+{
+	struct ufshpb_req *map_req;
+	struct bio *bio;
+
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
+	if (!map_req)
+		return NULL;
 
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
 
-	map_req->rb.rgn_idx = srgn->rgn_idx;
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
 
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
@@ -829,6 +849,13 @@ static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
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
@@ -847,6 +874,14 @@ static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
 	ufshpb_put_map_req(map_req->hpb, map_req);
 }
 
+static void ufshpb_set_unmap_cmd(unsigned char *cdb, int rgn_idx)
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
@@ -860,6 +895,27 @@ static void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
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
+	ufshpb_set_unmap_cmd(rq->cmd, umap_req->rb.rgn_idx);
+	rq->cmd_len = HPB_WRITE_BUFFER_CMD_LENGTH;
+
+	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
+
+	hpb->stats.umap_req_cnt++;
+	return 0;
+}
+
 static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
 				  struct ufshpb_req *map_req, bool last)
 {
@@ -1028,6 +1084,25 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
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
@@ -1035,6 +1110,10 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
 	struct ufshpb_subregion *srgn;
 	int srgn_idx;
 
+
+	if (hpb->is_hcm && ufshpb_issue_umap_req(hpb, rgn))
+		return;
+
 	lru_info = &hpb->lru_info;
 
 	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", rgn->rgn_idx);
@@ -1759,6 +1838,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1767,6 +1847,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1881,6 +1962,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 0a41df919f06..13ec49ba260d 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -36,11 +36,13 @@
 /* hpb vender defined opcode */
 #define UFSHPB_READ				0xF8
 #define UFSHPB_READ_BUFFER			0xF9
-#define UFSHPB_READ_BUFFER_ID			0x01
 #define UFSHPB_WRITE_BUFFER			0xFA
+#define UFSHPB_READ_BUFFER_ID			0x01
+#define UFSHPB_WRITE_BUFFER_ID			0x01
 #define UFSHPB_WRITE_BUFFER_PREFETCH_ID		0x02
 #define MAX_HPB_READ_ID				0x7F
 #define HPB_READ_BUFFER_CMD_LENGTH		10
+#define HPB_WRITE_BUFFER_CMD_LENGTH		10
 #define LU_ENABLED_HPB_FUNC			0x02
 
 #define HPB_RESET_REQ_RETRIES			10
@@ -182,6 +184,7 @@ struct ufshpb_stats {
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
 	u64 pre_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

