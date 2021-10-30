Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E7FC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 06:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFEB610FD
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 06:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhJ3GZy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 02:25:54 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37183 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhJ3GZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Oct 2021 02:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635575003; x=1667111003;
  h=from:to:cc:subject:date:message-id;
  bh=V37s13lxUJJisY2so3TtAysT8tIqFS7FbndO4agm79w=;
  b=B4NP0e+e8JuanZJxHlg/1gvVQo4ing7brVMi68cZt/yJLxJsCAD7JsJ5
   gapQqJyK0n62OdKUpJjRWV/m3LXKn10Rg8HyHXCMWQEclsNinj4BaMX79
   CHT5zB3J2lAWKOPQ9Uhfgblu864VNE/HdJf8tiJPqamEGLrPM2+UObV4R
   t1tfKZPPaybFc/r+2Sjd8w3WHmsFlm3WuKM2Hqwu5HSw9RPi0d2JPh7Vo
   Kws1jXk1Nju1q8G20G3ibeurtl9c6Lk8KayXMRzXMOMFHGH81mrJlMP45
   WwDrLva9zY64nk3pwoRhVGlNPnGXfd8KsUXdA/QtLHhFcFKwr3NxdHGUH
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,194,1631548800"; 
   d="scan'208";a="184227662"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2021 14:23:22 +0800
IronPort-SDR: mrWbhElz+WhGRCUgBvhz7FUFlWJ7SjdmLgWtTLFi5uqWbjZ6i7qe9qieM5rZ5mYDi8ml5xtfYi
 w4Q3mtZ6CPvBu4gprTitd8zrZYguhwb2ezizBBbTJA2IMyoo6guQf5rPQwFe/ff4Cmj77f/w/O
 BBZrtItxGR31vRUz+MJQp074A6MdrFGzerb6mYl3IrQnMaZc4tXaL7r2wS7mcKCchsjHo1YgJC
 i0Lk/CauDRswDSVY3Yq9A6GrCHuc1wh9gvIL2FEHLb6LmMJ1BwQThmwPeQijIauVtwbC06MFi/
 vEUcWeVU1zvF+83HCiZIO28j
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 22:57:15 -0700
IronPort-SDR: Zkmqy3bms/Uf65WLtdXEvl5jA7q+xd4TvBRV8cvw34UFE3U+/i4FH9eh5Sq/hTcoegHHvsPmaK
 Tz43U7MQACS+/c61A1eU5sjLGtBmSrs+yvbb8WiYSe/S2UkIVC5cLhfbcFd+U8xZNhEHVm0pSz
 Qw2TO6OeZPBpmANNyhYkk4p4WxGZB0XmzV+4ISwpdS/sgexcOdS8tdpCtkNpWP9XYxYujLc6AH
 zmuX1beapxweEpzBk5VuHOVcT1cvjegCyD7nXCAER4XlhKqdR14Cp172+x8XcVRiZNhJKCHDD9
 dAo=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.225.32.157])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Oct 2021 23:23:19 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Date:   Sat, 30 Oct 2021 09:23:01 +0300
Message-Id: <20211030062301.248-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2:
 - forgot to remove ufshpb_set_write_buf_cmd

v2 -> v3:
 - restore bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD
 - remove read_id - it is now always 0
 - Ignore ufshpb_prep returned error - does not return -EAGAIN no more

HPB allows its read commands to carry the physical addresses along with
the LBAs, thus allowing less internal L2P-table switches in the device.
HPB1.0 allowed a single LBA, while HPB2.0 increases this capacity up to
255 blocks.

Carrying more than a single record, the read operation is no longer
of type "read" per-se, but some sort of a "hybrid" command - writing the
physical address to the device and reading the required payload.

The HPB JEDEC spec came-up with a dual-command for that operation:
HPB-WRITE-BUFFER (0x2) to write the physical addresses to device, and
HPB-READ to read the payload.

Alas, the current HPB driver design - a single-scsi-LLD-module, has no
other alternative but to spawn the READ10 command into 2 commands:
HPB-WRITE-BUFFER and HPB-READ.
This causes a grat deal of aggrevation to the block layer guys, up to a
point, in which that they were willing to revert the entire HPB driver,
regardless of the huge amount of corporate effort already inversted in
it.

Therefore, remove the pre-req API for now, as a matter of urgency to get
it done before the closing of the merge window.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c |   7 +-
 drivers/scsi/ufs/ufshpb.c | 283 +-------------------------------------
 drivers/scsi/ufs/ufshpb.h |   2 -
 3 files changed, 4 insertions(+), 288 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f5ba8f953b87..470affdec426 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2767,12 +2767,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
-	err = ufshpb_prep(hba, lrbp);
-	if (err == -EAGAIN) {
-		lrbp->cmd = NULL;
-		ufshcd_release(hba);
-		goto out;
-	}
+	ufshpb_prep(hba, lrbp);
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 66b19500844e..3b1a90b1d82a 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -84,16 +84,6 @@ static bool ufshpb_is_supported_chunk(struct ufshpb_lu *hpb, int transfer_len)
 	return transfer_len <= hpb->pre_req_max_tr_len;
 }
 
-/*
- * In this driver, WRITE_BUFFER CMD support 36KB (len=9) ~ 1MB (len=256) as
- * default. It is possible to change range of transfer_len through sysfs.
- */
-static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int len)
-{
-	return len > hpb->pre_req_min_tr_len &&
-	       len <= hpb->pre_req_max_tr_len;
-}
-
 static bool ufshpb_is_general_lun(int lun)
 {
 	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
@@ -334,7 +324,7 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 
 static void
 ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
-			    __be64 ppn, u8 transfer_len, int read_id)
+			    __be64 ppn, u8 transfer_len)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 	__be64 ppn_tmp = ppn;
@@ -346,256 +336,11 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	/* ppn value is stored as big-endian in the host memory */
 	memcpy(&cdb[6], &ppn_tmp, sizeof(__be64));
 	cdb[14] = transfer_len;
-	cdb[15] = read_id;
+	cdb[15] = 0;
 
 	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
 }
 
-static inline void ufshpb_set_write_buf_cmd(unsigned char *cdb,
-					    unsigned long lpn, unsigned int len,
-					    int read_id)
-{
-	cdb[0] = UFSHPB_WRITE_BUFFER;
-	cdb[1] = UFSHPB_WRITE_BUFFER_PREFETCH_ID;
-
-	put_unaligned_be32(lpn, &cdb[2]);
-	cdb[6] = read_id;
-	put_unaligned_be16(len * HPB_ENTRY_SIZE, &cdb[7]);
-
-	cdb[9] = 0x00;	/* Control = 0x00 */
-}
-
-static struct ufshpb_req *ufshpb_get_pre_req(struct ufshpb_lu *hpb)
-{
-	struct ufshpb_req *pre_req;
-
-	if (hpb->num_inflight_pre_req >= hpb->throttle_pre_req) {
-		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
-			 "pre_req throttle. inflight %d throttle %d",
-			 hpb->num_inflight_pre_req, hpb->throttle_pre_req);
-		return NULL;
-	}
-
-	pre_req = list_first_entry_or_null(&hpb->lh_pre_req_free,
-					   struct ufshpb_req, list_req);
-	if (!pre_req) {
-		dev_info(&hpb->sdev_ufs_lu->sdev_dev, "There is no pre_req");
-		return NULL;
-	}
-
-	list_del_init(&pre_req->list_req);
-	hpb->num_inflight_pre_req++;
-
-	return pre_req;
-}
-
-static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
-				      struct ufshpb_req *pre_req)
-{
-	pre_req->req = NULL;
-	bio_reset(pre_req->bio);
-	list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
-	hpb->num_inflight_pre_req--;
-}
-
-static void ufshpb_pre_req_compl_fn(struct request *req, blk_status_t error)
-{
-	struct ufshpb_req *pre_req = (struct ufshpb_req *)req->end_io_data;
-	struct ufshpb_lu *hpb = pre_req->hpb;
-	unsigned long flags;
-
-	if (error) {
-		struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
-		struct scsi_sense_hdr sshdr;
-
-		dev_err(&hpb->sdev_ufs_lu->sdev_dev, "block status %d", error);
-		scsi_command_normalize_sense(cmd, &sshdr);
-		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-			"code %x sense_key %x asc %x ascq %x",
-			sshdr.response_code,
-			sshdr.sense_key, sshdr.asc, sshdr.ascq);
-		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-			"byte4 %x byte5 %x byte6 %x additional_len %x",
-			sshdr.byte4, sshdr.byte5,
-			sshdr.byte6, sshdr.additional_length);
-	}
-
-	blk_mq_free_request(req);
-	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-	ufshpb_put_pre_req(pre_req->hpb, pre_req);
-	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-}
-
-static int ufshpb_prep_entry(struct ufshpb_req *pre_req, struct page *page)
-{
-	struct ufshpb_lu *hpb = pre_req->hpb;
-	struct ufshpb_region *rgn;
-	struct ufshpb_subregion *srgn;
-	__be64 *addr;
-	int offset = 0;
-	int copied;
-	unsigned long lpn = pre_req->wb.lpn;
-	int rgn_idx, srgn_idx, srgn_offset;
-	unsigned long flags;
-
-	addr = page_address(page);
-	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
-
-	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-
-next_offset:
-	rgn = hpb->rgn_tbl + rgn_idx;
-	srgn = rgn->srgn_tbl + srgn_idx;
-
-	if (!ufshpb_is_valid_srgn(rgn, srgn))
-		goto mctx_error;
-
-	if (!srgn->mctx)
-		goto mctx_error;
-
-	copied = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset,
-					   pre_req->wb.len - offset,
-					   &addr[offset]);
-
-	if (copied < 0)
-		goto mctx_error;
-
-	offset += copied;
-	srgn_offset += copied;
-
-	if (srgn_offset == hpb->entries_per_srgn) {
-		srgn_offset = 0;
-
-		if (++srgn_idx == hpb->srgns_per_rgn) {
-			srgn_idx = 0;
-			rgn_idx++;
-		}
-	}
-
-	if (offset < pre_req->wb.len)
-		goto next_offset;
-
-	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-	return 0;
-mctx_error:
-	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-	return -ENOMEM;
-}
-
-static int ufshpb_pre_req_add_bio_page(struct ufshpb_lu *hpb,
-				       struct request_queue *q,
-				       struct ufshpb_req *pre_req)
-{
-	struct page *page = pre_req->wb.m_page;
-	struct bio *bio = pre_req->bio;
-	int entries_bytes, ret;
-
-	if (!page)
-		return -ENOMEM;
-
-	if (ufshpb_prep_entry(pre_req, page))
-		return -ENOMEM;
-
-	entries_bytes = pre_req->wb.len * sizeof(__be64);
-
-	ret = bio_add_pc_page(q, bio, page, entries_bytes, 0);
-	if (ret != entries_bytes) {
-		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-			"bio_add_pc_page fail: %d", ret);
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
-{
-	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
-		hpb->cur_read_id = 1;
-	return hpb->cur_read_id;
-}
-
-static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
-				  struct ufshpb_req *pre_req, int read_id)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct request_queue *q = sdev->request_queue;
-	struct request *req;
-	struct scsi_request *rq;
-	struct bio *bio = pre_req->bio;
-
-	pre_req->hpb = hpb;
-	pre_req->wb.lpn = sectors_to_logical(cmd->device,
-					     blk_rq_pos(scsi_cmd_to_rq(cmd)));
-	pre_req->wb.len = sectors_to_logical(cmd->device,
-					     blk_rq_sectors(scsi_cmd_to_rq(cmd)));
-	if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
-		return -ENOMEM;
-
-	req = pre_req->req;
-
-	/* 1. request setup */
-	blk_rq_append_bio(req, bio);
-	req->rq_disk = NULL;
-	req->end_io_data = (void *)pre_req;
-	req->end_io = ufshpb_pre_req_compl_fn;
-
-	/* 2. scsi_request setup */
-	rq = scsi_req(req);
-	rq->retries = 1;
-
-	ufshpb_set_write_buf_cmd(rq->cmd, pre_req->wb.lpn, pre_req->wb.len,
-				 read_id);
-	rq->cmd_len = scsi_command_size(rq->cmd);
-
-	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
-		return -EAGAIN;
-
-	hpb->stats.pre_req_cnt++;
-
-	return 0;
-}
-
-static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
-				int *read_id)
-{
-	struct ufshpb_req *pre_req;
-	struct request *req = NULL;
-	unsigned long flags;
-	int _read_id;
-	int ret = 0;
-
-	req = blk_get_request(cmd->device->request_queue,
-			      REQ_OP_DRV_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
-	if (IS_ERR(req))
-		return -EAGAIN;
-
-	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-	pre_req = ufshpb_get_pre_req(hpb);
-	if (!pre_req) {
-		ret = -EAGAIN;
-		goto unlock_out;
-	}
-	_read_id = ufshpb_get_read_id(hpb);
-	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-
-	pre_req->req = req;
-
-	ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
-	if (ret)
-		goto free_pre_req;
-
-	*read_id = _read_id;
-
-	return ret;
-free_pre_req:
-	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-	ufshpb_put_pre_req(hpb, pre_req);
-unlock_out:
-	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-	blk_put_request(req);
-	return ret;
-}
-
 /*
  * This function will set up HPB read command using host-side L2P map data.
  */
@@ -609,7 +354,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	__be64 ppn;
 	unsigned long flags;
 	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
-	int read_id = 0;
 	int err = 0;
 
 	hpb = ufshpb_get_hpb_data(cmd->device);
@@ -685,24 +429,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		dev_err(hba->dev, "get ppn failed. err %d\n", err);
 		return err;
 	}
-	if (!ufshpb_is_legacy(hba) &&
-	    ufshpb_is_required_wb(hpb, transfer_len)) {
-		err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
-		if (err) {
-			unsigned long timeout;
-
-			timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
-				  hpb->params.requeue_timeout_ms);
-
-			if (time_before(jiffies, timeout))
-				return -EAGAIN;
-
-			hpb->stats.miss_cnt++;
-			return 0;
-		}
-	}
 
-	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len, read_id);
+	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len);
 
 	hpb->stats.hit_cnt++;
 	return 0;
@@ -1841,16 +1569,11 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	u32 entries_per_rgn;
 	u64 rgn_mem_size, tmp;
 
-	/* for pre_req */
-	hpb->pre_req_min_tr_len = hpb_dev_info->max_hpb_single_cmd + 1;
-
 	if (ufshpb_is_legacy(hba))
 		hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
 	else
 		hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
 
-	hpb->cur_read_id = 0;
-
 	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
 		(hpb_lu_info->pinned_start + hpb_lu_info->num_pinned - 1)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index a79e07398970..f15d8fdbce2e 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -241,8 +241,6 @@ struct ufshpb_lu {
 	spinlock_t param_lock;
 
 	struct list_head lh_pre_req_free;
-	int cur_read_id;
-	int pre_req_min_tr_len;
 	int pre_req_max_tr_len;
 
 	/* cached L2P map management worker */
-- 
2.17.1

