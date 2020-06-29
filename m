Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D725C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9BC206F1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TLs+JYZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbgF2TPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:15:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17472 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730956AbgF2TPp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:15:45 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200629072805epoutp01a1525d86bc11444267b08952652f31c5~c8x_QZUf02162021620epoutp01d
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 07:28:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200629072805epoutp01a1525d86bc11444267b08952652f31c5~c8x_QZUf02162021620epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593415685;
        bh=ESlZxTBpYnuxbWREyyzFErCZRW8W01qjywCWrMSeMVA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=TLs+JYZLK6nLfN7Oj/nkJc3CiJD/cAjqazS0UO+MTc7IBFPd96zlQTNjldcKoH+fA
         g3qnHfvu3Uyry9hW+QIwN1mNiLtWSt7K5+3bfWWSKwYP5H5pwX0HyxwenyUlC0HZ0y
         sI9f0BH5sDDH0Ya0t5FMqO2n/M/CR+CgrsagtB6k=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200629072804epcas1p39ce2728e5e8678a5a14dfa1afbf4c2f3~c8x9x1xhx2639826398epcas1p3Y;
        Mon, 29 Jun 2020 07:28:04 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v4 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21593415684555.JavaMail.epsvc@epcpadp2>
Date:   Mon, 29 Jun 2020 15:58:59 +0900
X-CMS-MailID: 20200629065859epcms2p25eef8ead17c9cd1e469a4393a510e2a6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200629064323epcms2p787baba58a416fef7fdd3927f8da701da
References: <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
        <963815509.21593413582881.JavaMail.epsvc@epcpadp2>
        <1239183618.61593413402991.JavaMail.epsvc@epcpadp1>
        <231786897.01593413281727.JavaMail.epsvc@epcpadp2>
        <CGME20200629064323epcms2p787baba58a416fef7fdd3927f8da701da@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for managing L2P map in HPB module.

The HPB divides logical addresses into several regions. A region consists
of several sub-regions. The sub-region is a basic unit where L2P mapping is
managed. The driver loads L2P mapping data of each sub-region. The loaded
sub-region is called active-state. The HPB driver unloads L2P mapping data
as region unit. The unloaded region is called inactive-state.

Sub-region/region candidates to be loaded and unloaded are delivered from
the UFS device. The UFS device delivers the recommended active sub-region
and inactivate region to the driver using sensedata.
The HPB module performs L2P mapping management on the host through the
delivered information.

A pinned region is a pre-set regions on the UFS device that is always
activate-state.

The data structure for map data request and L2P map uses mempool API,
minimizing allocation overhead while avoiding static allocation.

The map_work manages active/inactive by 2 "to-do" lists.
Each hpb lun maintains 2 "to-do" lists:
  hpb->lh_inact_rgn - regions to be inactivated, and
  hpb->lh_act_srgn - subregions to be activated
Those lists are maintained on IO completion.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 990 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  72 +++
 2 files changed, 1059 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index c63955a457b1..45510c207a98 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -26,6 +26,63 @@ static inline int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
 		srgn->srgn_state == HPB_SRGN_VALID;
 }
 
+static inline bool ufshpb_is_general_lun(int lun)
+{
+	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
+}
+
+static inline bool
+ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
+{
+	if (hpb->lu_pinned_end != PINNED_NOT_SET &&
+	    rgn_idx >= hpb->lu_pinned_start &&
+	    rgn_idx <= hpb->lu_pinned_end)
+		return true;
+
+	return false;
+}
+
+static bool ufshpb_is_empty_rsp_lists(struct ufshpb_lu *hpb)
+{
+	bool ret = true;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	if (!list_empty(&hpb->lh_inact_rgn) || !list_empty(&hpb->lh_act_srgn))
+		ret = false;
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+
+	return ret;
+}
+
+static inline int ufshpb_may_field_valid(struct ufs_hba *hba,
+					 struct ufshcd_lrb *lrbp,
+					 struct ufshpb_rsp_field *rsp_field)
+{
+	if (be16_to_cpu(rsp_field->sense_data_len) != DEV_SENSE_SEG_LEN ||
+	    rsp_field->desc_type != DEV_DES_TYPE ||
+	    rsp_field->additional_len != DEV_ADDITIONAL_LEN ||
+	    rsp_field->hpb_type == HPB_RSP_NONE ||
+	    rsp_field->active_rgn_cnt > MAX_ACTIVE_NUM ||
+	    rsp_field->inactive_rgn_cnt > MAX_INACTIVE_NUM ||
+	    (!rsp_field->active_rgn_cnt && !rsp_field->inactive_rgn_cnt))
+		return -EINVAL;
+
+	if (!ufshpb_is_general_lun(lrbp->lun)) {
+		dev_warn(hba->dev, "ufshpb: lun(%d) not supported\n",
+			 lrbp->lun);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+
+static inline struct ufshpb_lu *ufshpb_get_hpb_data(struct scsi_cmnd *cmd)
+{
+	return cmd->device->hostdata;
+}
+
 static inline int ufshpb_get_state(struct ufshpb_lu *hpb)
 {
 	return atomic_read(&hpb->hpb_state);
@@ -60,6 +117,765 @@ static inline void ufshpb_lu_put(struct ufshpb_lu *hpb)
 	put_device(&hpb->hpb_lu_dev);
 }
 
+static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
+					     struct ufshpb_subregion *srgn)
+{
+	struct ufshpb_req *map_req;
+	struct request *req;
+	struct bio *bio;
+
+	map_req = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
+	if (!map_req)
+		return NULL;
+
+	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
+			      REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
+	if (IS_ERR(req))
+		goto free_map_req;
+
+	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
+	if (!bio) {
+		blk_put_request(req);
+		goto free_map_req;
+	}
+
+	map_req->hpb = hpb;
+	map_req->req = req;
+	map_req->bio = bio;
+
+	map_req->rgn_idx = srgn->rgn_idx;
+	map_req->srgn_idx = srgn->srgn_idx;
+	map_req->mctx = srgn->mctx;
+	map_req->lun = hpb->lun;
+
+	return map_req;
+
+free_map_req:
+	kmem_cache_free(hpb->map_req_cache, map_req);
+	return NULL;
+}
+
+static inline void ufshpb_put_map_req(struct ufshpb_lu *hpb,
+				      struct ufshpb_req *map_req)
+{
+	bio_put(map_req->bio);
+	blk_put_request(map_req->req);
+	kmem_cache_free(hpb->map_req_cache, map_req);
+}
+
+
+static inline int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *srgn)
+{
+	WARN_ON(!srgn->mctx);
+	bitmap_zero(srgn->mctx->ppn_dirty, hpb->entries_per_srgn);
+	return 0;
+}
+
+static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
+				      int srgn_idx)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	list_del_init(&rgn->list_inact_rgn);
+
+	if (list_empty(&srgn->list_act_srgn))
+		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+}
+
+static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	int srgn_idx;
+
+	rgn = hpb->rgn_tbl + rgn_idx;
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		srgn = rgn->srgn_tbl + srgn_idx;
+
+		list_del_init(&srgn->list_act_srgn);
+	}
+
+	if (list_empty(&rgn->list_inact_rgn))
+		list_add_tail(&rgn->list_inact_rgn, &hpb->lh_inact_rgn);
+}
+
+static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
+					  struct ufshpb_subregion *srgn)
+{
+	struct ufshpb_region *rgn;
+
+	/*
+	 * If there is no mctx in subregion
+	 * after I/O progress for HPB_READ_BUFFER, the region to which the
+	 * subregion belongs was evicted.
+	 * Mask sure the the region must not evict in I/O progress
+	 */
+	WARN_ON(!srgn->mctx);
+
+	rgn = hpb->rgn_tbl + srgn->rgn_idx;
+
+	if (unlikely(rgn->rgn_state == HPB_RGN_INACTIVE)) {
+		dev_err(&hpb->hpb_lu_dev,
+			"region %d subregion %d evicted\n",
+			srgn->rgn_idx, srgn->srgn_idx);
+		return;
+	}
+	srgn->srgn_state = HPB_SRGN_VALID;
+}
+
+static void ufshpb_map_req_compl_fn(struct request *req, blk_status_t error)
+{
+	struct ufshpb_req *map_req = (struct ufshpb_req *) req->end_io_data;
+	struct ufshpb_lu *hpb = map_req->hpb;
+	struct ufshpb_subregion *srgn;
+	unsigned long flags;
+
+	srgn = hpb->rgn_tbl[map_req->rgn_idx].srgn_tbl +
+		map_req->srgn_idx;
+
+	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+	ufshpb_activate_subregion(hpb, srgn);
+	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+
+	ufshpb_put_map_req(map_req->hpb, map_req);
+	ufshpb_lu_put(hpb);
+}
+
+static inline void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
+					   int srgn_idx, int srgn_mem_size)
+{
+	cdb[0] = UFSHPB_READ_BUFFER;
+	cdb[1] = UFSHPB_READ_BUFFER_ID;
+
+	put_unaligned_be16(rgn_idx, &cdb[2]);
+	put_unaligned_be16(srgn_idx, &cdb[4]);
+	put_unaligned_be24(srgn_mem_size, &cdb[6]);
+
+	cdb[9] = 0x00;
+}
+
+static int ufshpb_map_req_add_bio_page(struct ufshpb_lu *hpb,
+				       struct request_queue *q, struct bio *bio,
+				       struct ufshpb_map_ctx *mctx)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < hpb->pages_per_srgn; i++) {
+		ret = bio_add_pc_page(q, bio, mctx->m_page[i], PAGE_SIZE, 0);
+		if (ret != PAGE_SIZE) {
+			dev_notice(&hpb->hpb_lu_dev,
+				   "bio_add_pc_page fail %d\n", ret);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
+				  struct ufshpb_req *map_req)
+{
+	struct request_queue *q;
+	struct request *req;
+	struct scsi_request *rq;
+	int ret = 0;
+
+	q = hpb->sdev_ufs_lu->request_queue;
+	ret = ufshpb_map_req_add_bio_page(hpb, q, map_req->bio,
+					  map_req->mctx);
+	if (ret) {
+		dev_notice(&hpb->hpb_lu_dev,
+			   "map_req_add_bio_page fail %d - %d\n",
+			   map_req->rgn_idx, map_req->srgn_idx);
+		return ret;
+	}
+
+	req = map_req->req;
+
+	blk_rq_append_bio(req, &map_req->bio);
+
+	req->timeout = 0;
+	req->end_io_data = (void *)map_req;
+
+	rq = scsi_req(req);
+	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
+				map_req->srgn_idx, hpb->srgn_mem_size);
+	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
+
+	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_map_req_compl_fn);
+
+	atomic_inc(&hpb->stats.map_req_cnt);
+	return 0;
+}
+
+static struct ufshpb_map_ctx *ufshpb_get_map_ctx(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_map_ctx *mctx;
+	int i, j;
+
+	mctx = mempool_alloc(ufshpb_drv.ufshpb_mctx_pool, GFP_KERNEL);
+	if (!mctx)
+		return NULL;
+
+	mctx->m_page = kmem_cache_alloc(hpb->m_page_cache, GFP_KERNEL);
+	if (!mctx->m_page)
+		goto release_mctx;
+
+	mctx->ppn_dirty = bitmap_zalloc(hpb->entries_per_srgn, GFP_KERNEL);
+	if (!mctx->ppn_dirty)
+		goto release_m_page;
+
+	for (i = 0; i < hpb->pages_per_srgn; i++) {
+		mctx->m_page[i] = mempool_alloc(ufshpb_drv.ufshpb_page_pool,
+						GFP_KERNEL);
+		if (!mctx->m_page[i]) {
+			for (j = 0; j < i; j++)
+				mempool_free(mctx->m_page[j],
+					     ufshpb_drv.ufshpb_page_pool);
+			goto release_ppn_dirty;
+		}
+		clear_page(page_address(mctx->m_page[i]));
+	}
+
+	return mctx;
+release_ppn_dirty:
+	bitmap_free(mctx->ppn_dirty);
+release_m_page:
+	kmem_cache_free(hpb->m_page_cache, mctx->m_page);
+release_mctx:
+	mempool_free(mctx, ufshpb_drv.ufshpb_mctx_pool);
+	return NULL;
+}
+
+static inline void ufshpb_put_map_ctx(struct ufshpb_lu *hpb,
+				      struct ufshpb_map_ctx *mctx)
+{
+	int i;
+
+	for (i = 0; i < hpb->pages_per_srgn; i++)
+		mempool_free(mctx->m_page[i],
+			     ufshpb_drv.ufshpb_page_pool);
+
+	bitmap_free(mctx->ppn_dirty);
+	kmem_cache_free(hpb->m_page_cache, mctx->m_page);
+	mempool_free(mctx, ufshpb_drv.ufshpb_mctx_pool);
+}
+
+static int ufshpb_check_issue_state_srgns(struct ufshpb_lu *hpb,
+					  struct ufshpb_region *rgn)
+{
+	struct ufshpb_subregion *srgn;
+	int srgn_idx;
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		srgn  = rgn->srgn_tbl + srgn_idx;
+
+		if (srgn->srgn_state == HPB_SRGN_ISSUED)
+			return -EPERM;
+	}
+	return 0;
+}
+
+static inline void ufshpb_add_lru_info(struct victim_select_info *lru_info,
+				       struct ufshpb_region *rgn)
+{
+	rgn->rgn_state = HPB_RGN_ACTIVE;
+	list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
+	atomic_inc(&lru_info->active_cnt);
+}
+
+static inline void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
+				       struct ufshpb_region *rgn)
+{
+	list_move_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
+}
+
+static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
+{
+	struct victim_select_info *lru_info = &hpb->lru_info;
+	struct ufshpb_region *rgn, *victim_rgn = NULL;
+
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
+		WARN_ON(!rgn);
+		if (ufshpb_check_issue_state_srgns(hpb, rgn))
+			continue;
+
+		victim_rgn = rgn;
+		break;
+	}
+
+	return victim_rgn;
+}
+
+static inline void ufshpb_cleanup_lru_info(struct victim_select_info *lru_info,
+					   struct ufshpb_region *rgn)
+{
+	list_del_init(&rgn->list_lru_rgn);
+	rgn->rgn_state = HPB_RGN_INACTIVE;
+	atomic_dec(&lru_info->active_cnt);
+}
+
+static inline void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
+						 struct ufshpb_subregion *srgn)
+{
+	if (srgn->srgn_state != HPB_SRGN_UNUSED) {
+		ufshpb_put_map_ctx(hpb, srgn->mctx);
+		srgn->srgn_state = HPB_SRGN_UNUSED;
+		srgn->mctx = NULL;
+	}
+}
+
+static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
+				  struct ufshpb_region *rgn)
+{
+	struct victim_select_info *lru_info;
+	struct ufshpb_subregion *srgn;
+	int srgn_idx;
+
+	lru_info = &hpb->lru_info;
+
+	dev_dbg(&hpb->hpb_lu_dev, "evict region %d\n", rgn->rgn_idx);
+
+	ufshpb_cleanup_lru_info(lru_info, rgn);
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		srgn = rgn->srgn_tbl + srgn_idx;
+
+		ufshpb_purge_active_subregion(hpb, srgn);
+	}
+}
+
+static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+	if (rgn->rgn_state == HPB_RGN_PINNED) {
+		dev_warn(&hpb->hpb_lu_dev,
+			 "pinned region cannot drop-out. region %d\n",
+			 rgn->rgn_idx);
+		goto out;
+	}
+	if (!list_empty(&rgn->list_lru_rgn)) {
+		if (ufshpb_check_issue_state_srgns(hpb, rgn)) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		__ufshpb_evict_region(hpb, rgn);
+	}
+out:
+	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+	return ret;
+}
+
+static inline struct
+ufshpb_rsp_field *ufshpb_get_hpb_rsp(struct ufshcd_lrb *lrbp)
+{
+	return (struct ufshpb_rsp_field *)&lrbp->ucd_rsp_ptr->sr.sense_data_len;
+}
+
+static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
+				struct ufshpb_region *rgn,
+				struct ufshpb_subregion *srgn)
+{
+	struct ufshpb_req *map_req;
+	unsigned long flags;
+	int ret;
+	int err = -EAGAIN;
+	bool alloc_required = false;
+	enum HPB_RGN_STATE state = HPB_SRGN_INVALID;
+
+	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+	/*
+	 * Since the region state change occurs only in the map_work,
+	 * the state of the region cannot HPB_RGN_INACTIVE at this point.
+	 * The region state must be changed in the map_work
+	 */
+	WARN_ON(rgn->rgn_state == HPB_RGN_INACTIVE);
+
+	if (srgn->srgn_state == HPB_SRGN_UNUSED)
+		alloc_required = true;
+
+	/*
+	 * If the subregion is already ISSUED state,
+	 * a specific event (e.g., GC or wear-leveling, etc.) occurs in
+	 * the device and HPB response for map loading is received.
+	 * In this case, after finishing the HPB_READ_BUFFER,
+	 * the next HPB_READ_BUFFER is performed again to obtain the latest
+	 * map data.
+	 */
+	if (srgn->srgn_state == HPB_SRGN_ISSUED)
+		goto unlock_out;
+
+	srgn->srgn_state = HPB_SRGN_ISSUED;
+	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+
+	if (alloc_required) {
+		WARN_ON(srgn->mctx);
+		srgn->mctx = ufshpb_get_map_ctx(hpb);
+		if (!srgn->mctx) {
+			dev_notice(&hpb->hpb_lu_dev,
+			    "get map_ctx failed. region %d - %d\n",
+			    rgn->rgn_idx, srgn->srgn_idx);
+			state = HPB_SRGN_UNUSED;
+			goto change_srgn_state;
+		}
+	}
+
+	ufshpb_clear_dirty_bitmap(hpb, srgn);
+	map_req = ufshpb_get_map_req(hpb, srgn);
+	if (!map_req)
+		goto change_srgn_state;
+
+	ret = ufshpb_lu_get(hpb);
+	if (unlikely(ret)) {
+		dev_notice(&hpb->hpb_lu_dev,
+			   "%s: ufshpb_lu_get failed: %d", __func__, ret);
+		goto free_map_req;
+	}
+
+	ret = ufshpb_execute_map_req(hpb, map_req);
+	if (ret) {
+		dev_notice(&hpb->hpb_lu_dev,
+			   "%s: issue map_req failed: %d, region %d - %d\n",
+			   __func__, ret, srgn->rgn_idx, srgn->srgn_idx);
+		ufshpb_lu_put(hpb);
+		goto free_map_req;
+	}
+	return 0;
+
+free_map_req:
+	ufshpb_put_map_req(hpb, map_req);
+change_srgn_state:
+	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+	srgn->srgn_state = state;
+unlock_out:
+	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+	return err;
+}
+
+static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
+{
+	struct ufshpb_region *victim_rgn;
+	struct victim_select_info *lru_info = &hpb->lru_info;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+	/*
+	 * If region belongs to lru_list, just move the region
+	 * to the front of lru list. because the state of the region
+	 * is already active-state
+	 */
+	if (!list_empty(&rgn->list_lru_rgn)) {
+		ufshpb_hit_lru_info(lru_info, rgn);
+		goto out;
+	}
+
+	if (rgn->rgn_state == HPB_RGN_INACTIVE) {
+		if (atomic_read(&lru_info->active_cnt)
+		    == lru_info->max_lru_active_cnt) {
+			/*
+			 * If the maximum number of active regions
+			 * is exceeded, evict the least recently used region.
+			 * This case may occur when the device responds
+			 * to the eviction information late.
+			 * It is okay to evict the least recently used region,
+			 * because the device could detect this region
+			 * by not issuing HPB_READ
+			 */
+			victim_rgn = ufshpb_victim_lru_info(hpb);
+			if (!victim_rgn) {
+				dev_warn(&hpb->hpb_lu_dev,
+				    "cannot get victim region error\n");
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			dev_dbg(&hpb->hpb_lu_dev,
+				"LRU full (%d), choost victim %d\n",
+				atomic_read(&lru_info->active_cnt),
+				victim_rgn->rgn_idx);
+			__ufshpb_evict_region(hpb, victim_rgn);
+		}
+
+		/*
+		 * When a region is added to lru_info list_head,
+		 * it is guaranteed that the subregion has been
+		 * assigned all mctx. If failed, try to receive mctx again
+		 * without being added to lru_info list_head
+		 */
+		ufshpb_add_lru_info(lru_info, rgn);
+	}
+out:
+	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+	return ret;
+}
+
+static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
+					 struct ufshpb_rsp_field *rsp_field)
+{
+	int i, rgn_idx, srgn_idx;
+
+	/*
+	 * If the active region and the inactive region are the same,
+	 * we will inactivate this region.
+	 * The device could check this (region inactivated) and
+	 * will response the proper active region information
+	 */
+	spin_lock(&hpb->rsp_list_lock);
+	for (i = 0; i < rsp_field->active_rgn_cnt; i++) {
+		rgn_idx =
+			be16_to_cpu(rsp_field->hpb_active_field[i].active_rgn);
+		srgn_idx =
+			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
+
+		dev_dbg(&hpb->hpb_lu_dev, "activate(%d) region %d - %d\n",
+			i, rgn_idx, srgn_idx);
+		ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
+		atomic_inc(&hpb->stats.rb_active_cnt);
+	}
+
+	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
+		rgn_idx = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
+		dev_dbg(&hpb->hpb_lu_dev, "inactivate(%d) region %d\n",
+			i, rgn_idx);
+		ufshpb_update_inactive_info(hpb, rgn_idx);
+		atomic_inc(&hpb->stats.rb_inactive_cnt);
+	}
+	spin_unlock(&hpb->rsp_list_lock);
+
+	dev_dbg(&hpb->hpb_lu_dev, "Noti: #ACT %u #INACT %u\n",
+		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
+
+	queue_work(ufshpb_drv.ufshpb_wq, &hpb->map_work);
+}
+
+/* routine : isr (ufs) */
+static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufshpb_lu *hpb;
+	struct ufshpb_rsp_field *rsp_field;
+	int data_seg_len, ret;
+
+	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
+		& MASK_RSP_UPIU_DATA_SEG_LEN;
+
+	/* To flush remained rsp_list, we queue the map_work task */
+	if (!data_seg_len) {
+		if (!ufshpb_is_general_lun(lrbp->lun))
+			return;
+
+		hpb = ufshpb_get_hpb_data(lrbp->cmd);
+		ret = ufshpb_lu_get(hpb);
+		if (ret)
+			return;
+
+		if (!ufshpb_is_empty_rsp_lists(hpb))
+			queue_work(ufshpb_drv.ufshpb_wq, &hpb->map_work);
+
+		goto put_hpb;
+	}
+
+	/* Check HPB_UPDATE_ALERT */
+	if (!(lrbp->ucd_rsp_ptr->header.dword_2 &
+	      UPIU_HEADER_DWORD(0, 2, 0, 0)))
+		return;
+
+	rsp_field = ufshpb_get_hpb_rsp(lrbp);
+	if (ufshpb_may_field_valid(hba, lrbp, rsp_field))
+		return;
+
+	hpb = ufshpb_get_hpb_data(lrbp->cmd);
+	ret = ufshpb_lu_get(hpb);
+	if (ret)
+		return;
+
+	atomic_inc(&hpb->stats.rb_noti_cnt);
+
+	switch (rsp_field->hpb_type) {
+	case HPB_RSP_REQ_REGION_UPDATE:
+		WARN_ON(data_seg_len != DEV_DATA_SEG_LEN);
+		ufshpb_rsp_req_region_update(hpb, rsp_field);
+		break;
+	case HPB_RSP_DEV_RESET:
+		dev_warn(&hpb->hpb_lu_dev,
+			 "UFS device lost HPB information during PM.\n");
+		break;
+	default:
+		dev_notice(&hpb->hpb_lu_dev, "hpb_type is not available: %d\n",
+			   rsp_field->hpb_type);
+		break;
+	}
+put_hpb:
+	ufshpb_lu_put(hpb);
+}
+
+static void ufshpb_add_active_list(struct ufshpb_lu *hpb,
+				   struct ufshpb_region *rgn,
+				   struct ufshpb_subregion *srgn)
+{
+	if (!list_empty(&rgn->list_inact_rgn))
+		return;
+
+	if (!list_empty(&srgn->list_act_srgn)) {
+		list_move(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+		return;
+	}
+
+	list_add(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+}
+
+static void ufshpb_add_pending_evict_list(struct ufshpb_lu *hpb,
+				    struct ufshpb_region *rgn,
+				    struct list_head *pending_list)
+{
+	struct ufshpb_subregion *srgn;
+	int srgn_idx;
+
+	if (!list_empty(&rgn->list_inact_rgn))
+		return;
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		srgn = rgn->srgn_tbl + srgn_idx;
+
+		if (!list_empty(&srgn->list_act_srgn))
+			return;
+	}
+
+	list_add_tail(&rgn->list_inact_rgn, pending_list);
+}
+
+static void ufshpb_run_active_subregion_list(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	while ((srgn = list_first_entry_or_null(&hpb->lh_act_srgn,
+						struct ufshpb_subregion,
+						list_act_srgn))) {
+		list_del_init(&srgn->list_act_srgn);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+
+		rgn = hpb->rgn_tbl + srgn->rgn_idx;
+		ret = ufshpb_add_region(hpb, rgn);
+		if (ret)
+			break;
+
+		ret = ufshpb_issue_map_req(hpb, rgn, srgn);
+		if (ret) {
+			dev_notice(&hpb->hpb_lu_dev,
+			    "issue map_req failed. ret %d, region %d - %d\n",
+			    ret, rgn->rgn_idx, srgn->srgn_idx);
+			break;
+		}
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	}
+
+	if (ret) {
+		dev_notice(&hpb->hpb_lu_dev, "region %d - %d, will retry\n",
+			   rgn->rgn_idx, srgn->srgn_idx);
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		ufshpb_add_active_list(hpb, rgn, srgn);
+	}
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+}
+
+static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_region *rgn;
+	unsigned long flags;
+	int ret;
+	LIST_HEAD(pending_list);
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	while ((rgn = list_first_entry_or_null(&hpb->lh_inact_rgn,
+					       struct ufshpb_region,
+					       list_inact_rgn))) {
+		list_del_init(&rgn->list_inact_rgn);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+
+		ret = ufshpb_evict_region(hpb, rgn);
+		if (ret) {
+			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+			ufshpb_add_pending_evict_list(hpb, rgn, &pending_list);
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+		}
+
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	}
+
+	list_splice(&pending_list, &hpb->lh_inact_rgn);
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+}
+
+static void ufshpb_map_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	int ret;
+
+	hpb = container_of(work, struct ufshpb_lu, map_work);
+	ret = ufshpb_lu_get(hpb);
+	if (ret) {
+		dev_info(&hpb->hpb_lu_dev, "%s: exit, state %d\n",
+			 __func__, ufshpb_get_state(hpb));
+		return;
+	}
+
+	ufshpb_run_inactive_region_list(hpb);
+	ufshpb_run_active_subregion_list(hpb);
+
+	ufshpb_lu_put(hpb);
+}
+
+/*
+ * this function doesn't need to hold lock due to be called in init.
+ * (hpb_state_lock, rsp_list_lock, etc..)
+ */
+static int ufshpb_init_pinned_active_region(struct ufs_hba *hba,
+					    struct ufshpb_lu *hpb,
+					    struct ufshpb_region *rgn)
+{
+	struct ufshpb_subregion *srgn;
+	int srgn_idx, i;
+	int err = 0;
+
+	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
+		srgn = rgn->srgn_tbl + srgn_idx;
+
+		srgn->mctx = ufshpb_get_map_ctx(hpb);
+		srgn->srgn_state = HPB_SRGN_INVALID;
+		if (!srgn->mctx) {
+			dev_err(hba->dev,
+				"alloc mctx for pinned region failed\n");
+			goto release;
+		}
+
+		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
+	}
+
+	rgn->rgn_state = HPB_RGN_PINNED;
+	return 0;
+
+release:
+	for (i = 0; i < srgn_idx; i++) {
+		srgn = rgn->srgn_tbl + i;
+		ufshpb_put_map_ctx(hpb, srgn->mctx);
+	}
+	return err;
+}
+
 static void ufshpb_init_subregion_tbl(struct ufshpb_lu *hpb,
 				      struct ufshpb_region *rgn)
 {
@@ -68,6 +884,8 @@ static void ufshpb_init_subregion_tbl(struct ufshpb_lu *hpb,
 	for (srgn_idx = 0; srgn_idx < rgn->srgn_cnt; srgn_idx++) {
 		struct ufshpb_subregion *srgn = rgn->srgn_tbl + srgn_idx;
 
+		INIT_LIST_HEAD(&srgn->list_act_srgn);
+
 		srgn->rgn_idx = rgn->rgn_idx;
 		srgn->srgn_idx = srgn_idx;
 		srgn->srgn_state = HPB_SRGN_UNUSED;
@@ -100,6 +918,8 @@ static void ufshpb_init_lu_parameter(struct ufs_hba *hba,
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
 		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
 		: PINNED_NOT_SET;
+	hpb->lru_info.max_lru_active_cnt =
+		hpb_lu_info->max_active_rgns - hpb_lu_info->num_pinned;
 
 	rgn_mem_size = (1ULL << hpb_dev_info->rgn_size) * HPB_RGN_SIZE_UNIT
 		/ HPB_ENTRY_BLOCK_SIZE * HPB_ENTRY_SIZE;
@@ -153,6 +973,9 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		rgn = rgn_table + rgn_idx;
 		rgn->rgn_idx = rgn_idx;
 
+		INIT_LIST_HEAD(&rgn->list_inact_rgn);
+		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+
 		if (rgn_idx == hpb->rgns_per_lu - 1)
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
 				    hpb->srgns_per_rgn) + 1;
@@ -162,7 +985,13 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 			goto release_srgn_table;
 		ufshpb_init_subregion_tbl(hpb, rgn);
 
-		rgn->rgn_state = HPB_RGN_INACTIVE;
+		if (ufshpb_is_pinned_region(hpb, rgn_idx)) {
+			ret = ufshpb_init_pinned_active_region(hba, hpb, rgn);
+			if (ret)
+				goto release_srgn_table;
+		} else {
+			rgn->rgn_state = HPB_RGN_INACTIVE;
+		}
 	}
 
 	return 0;
@@ -186,7 +1015,10 @@ static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
 		struct ufshpb_subregion *srgn;
 
 		srgn = rgn->srgn_tbl + srgn_idx;
-		srgn->srgn_state = HPB_SRGN_UNUSED;
+		if (srgn->srgn_state != HPB_SRGN_UNUSED) {
+			srgn->srgn_state = HPB_SRGN_UNUSED;
+			ufshpb_put_map_ctx(hpb, srgn->mctx);
+		}
 	}
 }
 
@@ -216,8 +1048,36 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
 	int ret;
 
 	spin_lock_init(&hpb->hpb_state_lock);
+	spin_lock_init(&hpb->rsp_list_lock);
+
+	INIT_LIST_HEAD(&hpb->lru_info.lh_lru_rgn);
+	INIT_LIST_HEAD(&hpb->lh_act_srgn);
+	INIT_LIST_HEAD(&hpb->lh_inact_rgn);
+	INIT_LIST_HEAD(&hpb->list_hpb_lu);
+
+	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
+
+	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
+			  sizeof(struct ufshpb_req), 0, 0, NULL);
+	if (!hpb->map_req_cache) {
+		dev_err(hba->dev, "ufshpb(%d) ufshpb_req_cache create fail",
+			hpb->lun);
+		return -ENOMEM;
+	}
+
+	hpb->m_page_cache = kmem_cache_create("ufshpb_m_page_cache",
+			  sizeof(struct page *) * hpb->pages_per_srgn,
+			  0, 0, NULL);
+	if (!hpb->m_page_cache) {
+		dev_err(hba->dev, "ufshpb(%d) ufshpb_m_page_cache create fail",
+			hpb->lun);
+		ret = -ENOMEM;
+		goto release_req_cache;
+	}
 
 	ret = ufshpb_alloc_region_tbl(hba, hpb);
+	if (ret)
+		goto release_m_page_cache;
 
 	ret = ufshpb_create_sysfs(hba, hpb);
 	if (ret)
@@ -227,6 +1087,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
 
 release_rgn_table:
 	ufshpb_destroy_region_tbl(hpb);
+release_m_page_cache:
+	kmem_cache_destroy(hpb->m_page_cache);
+release_req_cache:
+	kmem_cache_destroy(hpb->map_req_cache);
 	return ret;
 }
 
@@ -258,10 +1122,42 @@ static struct ufshpb_lu *ufshpb_alloc_hpb_lu(struct ufs_hba *hba, int lun,
 	return NULL;
 }
 
+static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_region *rgn, *next_rgn;
+	struct ufshpb_subregion *srgn, *next_srgn;
+	unsigned long flags;
+
+	/*
+	 * If the device reset occurred, the remained HPB region information
+	 * may be stale. Therefore, by dicarding the lists of HPB response
+	 * that remained after reset, it prevents unnecessary work.
+	 */
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	list_for_each_entry_safe(rgn, next_rgn, &hpb->lh_inact_rgn,
+				 list_inact_rgn)
+		list_del_init(&rgn->list_inact_rgn);
+
+	list_for_each_entry_safe(srgn, next_srgn, &hpb->lh_act_srgn,
+				 list_act_srgn)
+		list_del_init(&srgn->list_act_srgn);
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+}
+
+static inline void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
+{
+	cancel_work_sync(&hpb->map_work);
+}
+
 static void ufshpb_lu_release(struct ufshpb_lu *hpb)
 {
+	ufshpb_cancel_jobs(hpb);
+
 	ufshpb_destroy_region_tbl(hpb);
 
+	kmem_cache_destroy(hpb->map_req_cache);
+	kmem_cache_destroy(hpb->m_page_cache);
+
 	list_del_init(&hpb->list_hpb_lu);
 }
 
@@ -348,6 +1244,9 @@ static void ufshpb_reset_host(struct ufs_hba *hba)
 		dev_info(&hpb->hpb_lu_dev, "ufshpb run reset_host");
 
 		ufshpb_set_state(hpb, HPB_RESET);
+		ufshpb_cancel_jobs(hpb);
+		ufshpb_discard_rsp_lists(hpb);
+
 		ufshpb_lu_put(hpb);
 	}
 }
@@ -362,6 +1261,7 @@ static void ufshpb_suspend(struct ufs_hba *hba)
 
 		dev_info(&hpb->hpb_lu_dev, "ufshpb goto suspend");
 		ufshpb_set_state(hpb, HPB_SUSPEND);
+		ufshpb_cancel_jobs(hpb);
 
 		ufshpb_lu_put(hpb);
 	}
@@ -377,6 +1277,9 @@ static void ufshpb_resume(struct ufs_hba *hba)
 
 		dev_info(&hpb->hpb_lu_dev, "ufshpb resume");
 		ufshpb_set_state(hpb, HPB_PRESENT);
+		if (!ufshpb_is_empty_rsp_lists(hpb))
+			queue_work(ufshpb_drv.ufshpb_wq, &hpb->map_work);
+
 		ufshpb_lu_put(hpb);
 	}
 }
@@ -619,6 +1522,8 @@ static void ufshpb_scan_hpb_lu(struct ufs_hba *hba,
 	struct scsi_device *sdev;
 	struct ufshpb_lu *hpb;
 	int find_hpb_lu = 0;
+	int tot_active_srgn_pages = 0;
+	int pool_size;
 	int ret;
 
 	INIT_LIST_HEAD(&ufshpb_drv.lh_hpb_lu);
@@ -639,6 +1544,9 @@ static void ufshpb_scan_hpb_lu(struct ufs_hba *hba,
 		if (!hpb)
 			continue;
 
+		tot_active_srgn_pages += hpb_lu_info.max_active_rgns *
+				hpb->srgns_per_rgn * hpb->pages_per_srgn;
+
 		hpb->sdev_ufs_lu = sdev;
 		sdev->hostdata = hpb;
 
@@ -650,11 +1558,31 @@ static void ufshpb_scan_hpb_lu(struct ufs_hba *hba,
 		return;
 
 	ufshpb_check_hpb_reset_query(hba);
+
+	pool_size = DIV_ROUND_UP(ufshpb_host_map_kbytes * 1024, PAGE_SIZE);
+	if (pool_size > tot_active_srgn_pages) {
+		dev_info(hba->dev,
+			"reset pool_size to %lu KB.\n",
+			tot_active_srgn_pages * PAGE_SIZE / 1024);
+		mempool_resize(ufshpb_drv.ufshpb_mctx_pool,
+			       tot_active_srgn_pages);
+		mempool_resize(ufshpb_drv.ufshpb_page_pool,
+			       tot_active_srgn_pages);
+	}
+
 	dev_set_drvdata(&hba->ufsf.hpb_dev, &ufshpb_drv);
 
 	list_for_each_entry(hpb, &ufshpb_drv.lh_hpb_lu, list_hpb_lu) {
 		dev_info(&hpb->hpb_lu_dev, "set state to present\n");
 		ufshpb_set_state(hpb, HPB_PRESENT);
+
+		if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0) {
+			dev_info(&hpb->hpb_lu_dev,
+			    "loading pinned regions %d - %d\n",
+			    hpb->lu_pinned_start, hpb->lu_pinned_end);
+			queue_work(ufshpb_drv.ufshpb_wq,
+				&hpb->map_work);
+		}
 	}
 }
 
@@ -721,6 +1649,8 @@ static int ufshpb_remove(struct device *dev)
 		sdev = hpb->sdev_ufs_lu;
 		sdev->hostdata = NULL;
 
+		ufshpb_cancel_jobs(hpb);
+
 		device_del(&hpb->hpb_lu_dev);
 
 		dev_info(&hpb->hpb_lu_dev, "hpb_lu_dev refcnt %d\n",
@@ -746,6 +1676,7 @@ static struct ufshpb_driver ufshpb_drv = {
 		.reset_host = ufshpb_reset_host,
 		.suspend = ufshpb_suspend,
 		.resume = ufshpb_resume,
+		.rsp_upiu = ufshpb_rsp_upiu,
 	},
 };
 
@@ -756,17 +1687,70 @@ MODULE_PARM_DESC(ufshpb_host_map_kbytes,
 static int __init ufshpb_init(void)
 {
 	int ret;
+	unsigned int pool_size;
+
+	ufshpb_drv.ufshpb_mctx_cache = kmem_cache_create("ufshpb_mctx_cache",
+					sizeof(struct ufshpb_map_ctx),
+					0, 0, NULL);
+	if (!ufshpb_drv.ufshpb_mctx_cache) {
+		pr_err("ufshpb: cannot init mctx cache\n");
+		return -ENOMEM;
+	}
+
+	pool_size = DIV_ROUND_UP(ufshpb_host_map_kbytes * 1024, PAGE_SIZE);
+	pr_info("%s:%d ufshpb_host_map_kbytes %u pool_size %u\n",
+	       __func__, __LINE__, ufshpb_host_map_kbytes, pool_size);
+
+	ufshpb_drv.ufshpb_mctx_pool = mempool_create_slab_pool(
+				     pool_size, ufshpb_drv.ufshpb_mctx_cache);
+	if (!ufshpb_drv.ufshpb_mctx_pool) {
+		pr_err("ufshpb: cannot init mctx pool\n");
+		ret = -ENOMEM;
+		goto release_mctx_cache;
+	}
+
+	ufshpb_drv.ufshpb_page_pool = mempool_create_page_pool(pool_size, 0);
+	if (!ufshpb_drv.ufshpb_page_pool) {
+		pr_err("ufshpb: cannot init page pool\n");
+		ret = -ENOMEM;
+		goto release_mctx_pool;
+	}
+
+	ufshpb_drv.ufshpb_wq = alloc_workqueue("ufshpb-wq",
+					WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!ufshpb_drv.ufshpb_wq) {
+		pr_err("ufshpb: alloc workqueue failed\n");
+		ret = -ENOMEM;
+		goto release_page_pool;
+	}
 
 	ret = driver_register(&ufshpb_drv.drv);
-	if (ret)
+	if (ret) {
 		pr_err("ufshpb: driver register failed\n");
+		goto release_wq;
+	}
 
+	return 0;
+release_wq:
+	destroy_workqueue(ufshpb_drv.ufshpb_wq);
+release_page_pool:
+	mempool_destroy(ufshpb_drv.ufshpb_page_pool);
+release_mctx_pool:
+	mempool_destroy(ufshpb_drv.ufshpb_mctx_pool);
+release_mctx_cache:
+	kmem_cache_destroy(ufshpb_drv.ufshpb_mctx_cache);
 	return ret;
 }
 
 static void __exit ufshpb_exit(void)
 {
 	driver_unregister(&ufshpb_drv.drv);
+
+	mempool_destroy(ufshpb_drv.ufshpb_page_pool);
+	mempool_destroy(ufshpb_drv.ufshpb_mctx_pool);
+	kmem_cache_destroy(ufshpb_drv.ufshpb_mctx_cache);
+
+	destroy_workqueue(ufshpb_drv.ufshpb_wq);
 }
 
 MODULE_AUTHOR("Yongmyong Lee <ymhungry.lee@samsung.com>");
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index eaa4a3e035b1..d9c27348d354 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -101,10 +101,36 @@ struct ufshpb_lu_info {
 	int max_active_rgns;
 };
 
+struct ufshpb_active_field {
+	__be16 active_rgn;
+	__be16 active_srgn;
+} __packed;
+
+struct ufshpb_rsp_field {
+	__be16 sense_data_len;
+	u8 desc_type;
+	u8 additional_len;
+	u8 hpb_type;
+	u8 reserved;
+	u8 active_rgn_cnt;
+	u8 inactive_rgn_cnt;
+	struct ufshpb_active_field hpb_active_field[2];
+	__be16 hpb_inactive_field[2];
+} __packed;
+
+struct ufshpb_map_ctx {
+	struct page **m_page;
+	unsigned long *ppn_dirty;
+};
+
 struct ufshpb_subregion {
+	struct ufshpb_map_ctx *mctx;
 	enum HPB_SRGN_STATE srgn_state;
 	int rgn_idx;
 	int srgn_idx;
+
+	/* below information is used by rsp_list */
+	struct list_head list_act_srgn;
 };
 
 struct ufshpb_region {
@@ -112,6 +138,39 @@ struct ufshpb_region {
 	enum HPB_RGN_STATE rgn_state;
 	int rgn_idx;
 	int srgn_cnt;
+
+	/* below information is used by rsp_list */
+	struct list_head list_inact_rgn;
+
+	/* below information is used by lru */
+	struct list_head list_lru_rgn;
+};
+
+/**
+ * struct ufshpb_req - UFSHPB READ BUFFER (for caching map) request structure
+ * @req: block layer request for READ BUFFER
+ * @bio: bio for holding map page
+ * @hpb: ufshpb_lu structure that related to the L2P map
+ * @mctx: L2P map information
+ * @rgn_idx: target region index
+ * @srgn_idx: target sub-region index
+ * @lun: target logical unit number
+ */
+struct ufshpb_req {
+	struct request *req;
+	struct bio *bio;
+	struct ufshpb_lu *hpb;
+	struct ufshpb_map_ctx *mctx;
+
+	unsigned int rgn_idx;
+	unsigned int srgn_idx;
+	unsigned int lun;
+};
+
+struct victim_select_info {
+	struct list_head lh_lru_rgn;
+	int max_lru_active_cnt; /* supported hpb #region - pinned #region */
+	atomic_t active_cnt;
 };
 
 struct ufshpb_stats {
@@ -134,6 +193,16 @@ struct ufshpb_lu {
 	spinlock_t hpb_state_lock;
 	atomic_t hpb_state; /* hpb_state_lock */
 
+	spinlock_t rsp_list_lock;
+	struct list_head lh_act_srgn; /* rsp_list_lock */
+	struct list_head lh_inact_rgn; /* rsp_list_lock */
+
+	/* cached L2P map management worker */
+	struct work_struct map_work;
+
+	/* for selecting victim */
+	struct victim_select_info lru_info;
+
 	/* pinned region information */
 	u32 lu_pinned_start;
 	u32 lu_pinned_end;
@@ -152,6 +221,9 @@ struct ufshpb_lu {
 
 	struct ufshpb_stats stats;
 
+	struct kmem_cache *map_req_cache;
+	struct kmem_cache *m_page_cache;
+
 	struct ufsf_feature_info *ufsf;
 	struct list_head list_hpb_lu;
 };
-- 
2.17.1


