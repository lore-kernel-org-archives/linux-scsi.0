Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02D7C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 21:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF94760720
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 21:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhJ3VsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 17:48:17 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:52170 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhJ3VsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Oct 2021 17:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635630346;
        bh=zKB1pZmHpOgoFoyme2O36VT2hQR1Y3A6cTVVfvpqYmI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=gEcvy7On+yG6qfzBTLhQJN3VRshhmJRDAyKZND5vk/uy2LSPPpyDmIr/zVLblG649
         XPTAoyRyy37VCrE+kHKjKSlTj3yMvtLn1l7e4mmdwtIytno2+NgKx44va4EAxmcR77
         wwouYdbQLARfiuyMKSPry6j2pvuoVKN6/EIwg4jQ=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5C7A4128043D;
        Sat, 30 Oct 2021 17:45:46 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eoURyQrgnMhj; Sat, 30 Oct 2021 17:45:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635630346;
        bh=zKB1pZmHpOgoFoyme2O36VT2hQR1Y3A6cTVVfvpqYmI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=gEcvy7On+yG6qfzBTLhQJN3VRshhmJRDAyKZND5vk/uy2LSPPpyDmIr/zVLblG649
         XPTAoyRyy37VCrE+kHKjKSlTj3yMvtLn1l7e4mmdwtIytno2+NgKx44va4EAxmcR77
         wwouYdbQLARfiuyMKSPry6j2pvuoVKN6/EIwg4jQ=
Received: from [172.20.7.191] (65-126-61-114.dia.static.qwest.net [65.126.61.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id AD987128012A;
        Sat, 30 Oct 2021 17:45:45 -0400 (EDT)
Message-ID: <fd550fa6f72861294271fdbaf98c09b34a1a8c95.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.15-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 30 Oct 2021 14:45:43 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three small fixes, all in drivers, and one sizeable update to the UFS
driver to remove the HPB 2.0 feature that has been objected to by Jens
and Christoph.  Although the UFS patch is large and last minute, it's
essentially the least intrusive way of resolving the objections in time
for the 5.15 release.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Avri Altman (1):
      scsi: ufs: ufshpb: Remove HPB2.0 flows

Brian King (1):
      scsi: ibmvfc: Fix up duplicate response detection

Chanho Park (1):
      scsi: ufs: ufs-exynos: Correct timeout value setting registers

Martin K. Petersen (1):
      scsi: mpt3sas: Fix reference tag handling for WRITE_INSERT

And the diffstat:

 drivers/scsi/ibmvscsi/ibmvfc.c       |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   9 +-
 drivers/scsi/ufs/ufs-exynos.c        |   6 +-
 drivers/scsi/ufs/ufshcd.c            |   7 +-
 drivers/scsi/ufs/ufshpb.c            | 283 +----------------------------------
 drivers/scsi/ufs/ufshpb.h            |   2 -
 6 files changed, 15 insertions(+), 295 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..01f79991bf4a 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1696,6 +1696,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 	spin_lock_irqsave(&evt->queue->l_lock, flags);
 	list_add_tail(&evt->queue_list, &evt->queue->sent);
+	atomic_set(&evt->active, 1);
 
 	mb();
 
@@ -1710,6 +1711,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 				     be64_to_cpu(crq_as_u64[1]));
 
 	if (rc) {
+		atomic_set(&evt->active, 0);
 		list_del(&evt->queue_list);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		del_timer(&evt->timer);
@@ -1737,7 +1739,6 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 		evt->done(evt);
 	} else {
-		atomic_set(&evt->active, 1);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d383d4a03436..ad1b6c2b37a7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5065,9 +5065,12 @@ _scsih_setup_eedp(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	if (scmd->prot_flags & SCSI_PROT_GUARD_CHECK)
 		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
 
-	if (scmd->prot_flags & SCSI_PROT_REF_CHECK) {
-		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
-			MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
+	if (scmd->prot_flags & SCSI_PROT_REF_CHECK)
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG;
+
+	if (scmd->prot_flags & SCSI_PROT_REF_INCREMENT) {
+		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG;
+
 		mpi_request->CDB.EEDP32.PrimaryReferenceTag =
 			cpu_to_be32(scsi_prot_ref_tag(scmd));
 	}
diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a14dd8ce56d4..bb2dd79a1bcd 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -642,9 +642,9 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
 	}
 
 	/* setting for three timeout values for traffic class #0 */
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 8064);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 28224);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 20160);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), 8064);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL), 28224);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), 20160);
 
 	return 0;
 out:
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 95be7ecdfe10..41f2ff35f82b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2737,12 +2737,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
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
index 589af5f6b940..026a133149dc 100644
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

