Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FD3C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9408960F93
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ2Tcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:32:39 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47184 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhJ2Tcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635535811; x=1667071811;
  h=from:to:cc:subject:date:message-id;
  bh=DVMVMXnrdNRRNoHShLz1dN+a2K7WgB7Gn7+QjTLGB3s=;
  b=juf7Hx/1/gW0zTBUkfJMH0okI+ExQ5/Ob37ufu7JLTVw8jwissDiyQFm
   hyEtOP3avR2oIXB/TCIC66DLITlO/8ihvOd/FSW6MN4Z3eiLYUKhpOKBp
   GkO4tQL9lWKwyr1wUHvuPenhGWIt17rgjGeQrCZEQeq5cQdCD3Z9osZLz
   Y/JS8WY5ODLiBZ0v2BDYCrt1lsyr9BqL4wB4X+P8SmGo+VF5Uj46JhMu2
   jnppPpkX57ctug9ogxrE8my1vMfAl3ISCHSK8dYswRVsmLAvt3EWMcXP7
   MmlRyiX3ZDP/Mi+IOMOMgRDpCocutlZRhVIY9o0qseyWKuYHzdwUAEBkz
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,193,1631548800"; 
   d="scan'208";a="185146761"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2021 03:30:11 +0800
IronPort-SDR: qbwKot+YDvYMnCYQaqxeqb2+dbTfGAxiCZgbQZ1JsdRhWrB/fV32EyMQIb6i3R9OY8m5hV5Ins
 YL86xYskLOQIBjmW0CvnwUdNHD1Gb/CVgpiBUqA2Pd9rl3N08NFMEumGa5LFzleIMQX2V58LxQ
 HxGyKK9mPqkaoqsk8jIvdgnw9doeUx7jXw2zbEKKd6iRP6hBs0uDdYcRJ4Qv/JXQWrfzZgao3G
 upCswDAnR15mk2lOP2bB6+zOiFOfbSkRX9Hie36/tljKH1IoGmGMNJxUOHo132COd4I7Nlb0DX
 Bb6mseB3cu/i/3cs+a+13BWm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 12:04:03 -0700
IronPort-SDR: xsjXa8xqXr3KC8pcR9xn+VKrrhh79ri/qrv9fIdNKs4iHiffouZzz62Rz2CAGudbaudvQad35j
 hKta1ejhKG5aFDzRVwE/KQoU/4UJ1w3fNf9WVMFgUuyIj6N9WgXeOla7zSdf9q7T9qEIKTj6EQ
 Co5W5f646tN52GLRUH2kRi2Fofjqbmvukot+1ZgsWt3nofjFTrOHxcGl2gFhpiqlSUQ1dsvgfK
 yBbxiRzSfw1jEkZ/FZR3Aw3nIZOQhkl5A+eKZugqqs9EYMGGYeq+tLuWbdabNBAuzVmgxda0Qn
 G/w=
WDCIronportException: Internal
Received: from ind005806.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.157])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Oct 2021 12:30:06 -0700
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
Subject: [PATCH v2] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Date:   Fri, 29 Oct 2021 22:30:02 +0300
Message-Id: <20211029193002.4187-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2:
forgot to remove ufshpb_set_write_buf_cmd

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
 drivers/scsi/ufs/ufshpb.c | 284 +-------------------------------------
 drivers/scsi/ufs/ufshpb.h |   2 -
 2 files changed, 2 insertions(+), 284 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 66b19500844e..51d1571ec162 100644
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
@@ -351,162 +341,6 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
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
 static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
 {
 	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
@@ -514,88 +348,6 @@ static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
 	return hpb->cur_read_id;
 }
 
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
@@ -650,8 +402,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	if (!ufshpb_is_supported_chunk(hpb, transfer_len))
 		return 0;
 
-	WARN_ON_ONCE(transfer_len > HPB_MULTI_CHUNK_HIGH);
-
 	if (hpb->is_hcm) {
 		/*
 		 * in host control mode, reads are the main source for
@@ -685,22 +435,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
 
 	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len, read_id);
 
@@ -1841,13 +1575,7 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	u32 entries_per_rgn;
 	u64 rgn_mem_size, tmp;
 
-	/* for pre_req */
-	hpb->pre_req_min_tr_len = hpb_dev_info->max_hpb_single_cmd + 1;
-
-	if (ufshpb_is_legacy(hba))
-		hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
-	else
-		hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
+	hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
 
 	hpb->cur_read_id = 0;
 
@@ -2858,8 +2586,7 @@ void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf)
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
-	int version, ret;
-	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
+	int version;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
 
@@ -2875,13 +2602,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	if (version == HPB_SUPPORT_LEGACY_VERSION)
 		hpb_dev_info->is_legacy = true;
 
-	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
-	if (ret)
-		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
-			__func__);
-	hpb_dev_info->max_hpb_single_cmd = max_hpb_single_cmd;
-
 	/*
 	 * Get the number of user logical unit to check whether all
 	 * scsi_device finish initialization
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index a79e07398970..a4e7e33d451e 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -31,8 +31,6 @@
 
 /* hpb support chunk size */
 #define HPB_LEGACY_CHUNK_HIGH			1
-#define HPB_MULTI_CHUNK_LOW			7
-#define HPB_MULTI_CHUNK_HIGH			255
 
 /* hpb vender defined opcode */
 #define UFSHPB_READ				0xF8
-- 
2.17.1

