Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2660FC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05E0364F84
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 08:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhCLIHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 03:07:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55371 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhCLIHa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 03:07:30 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210312080729epoutp03989d4988eadeedfef503d9c1707adad5~riddSER_i2507325073epoutp03A
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 08:07:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210312080729epoutp03989d4988eadeedfef503d9c1707adad5~riddSER_i2507325073epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615536449;
        bh=86Bf6XIO4fsNd7LDhlkgx4wanBgmxWiGffBA07gCvlg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=NKy5dZXMoEVuRPjlO1mi8eMlU7/pE+LaGA411IvgV26xdzD58aWwJiKeS+ffHERl0
         94KeJzZYkgoXtzRZLSbtrNdCJy7RdjgoX8tlv6VQ71PmalGQnCzezsrvSsaAMr1P8H
         taTKj7M+otNFane7NY8ScBdt7zCvwPTDtXm/lg98=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210312080728epcas2p475003f4b56182a0cd515f39be304c74f~ridctig5n0693206932epcas2p4r;
        Fri, 12 Mar 2021 08:07:28 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DxdhY5Gfbz4x9QL; Fri, 12 Mar
        2021 08:07:25 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-6d-604b213de96c
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.3D.05262.D312B406; Fri, 12 Mar 2021 17:07:25 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v27 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce@epcms2p3>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210312080724epcms2p59859f069e24aee73d4530e12f8f6f08d@epcms2p5>
Date:   Fri, 12 Mar 2021 17:07:24 +0900
X-CMS-MailID: 20210312080724epcms2p59859f069e24aee73d4530e12f8f6f08d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Ta0xbVRzAPfdeeguz5vKYO1Qn7JIxmdLX1nq2UKJsGVdwrirJFD6UG7iB
        utJ2va3PqRidxTEYJNM1HWML6Ig8M0J5RiAUcDAJm7DNwYBOYYYg47H46AhoS4tb/PY7v/N/
        nP859wrxsEmBWKgzWDizgdXTghCi2RWnildvS82UTfeJkbu8WYC+/+IyiWY91wXINX6PRF8v
        enC03HAxCM32xKFq92H0WWWDAJUN5WOo6JRTgH69fZ9EFT83Y+jUmo1AI+1lAlR4s1WAqn5Y
        w9B4Uwj61nkLoC/P1BIvRjAjo6nMSHERxrQ5JkimpKIbMF3naknm84EuglmaGSOY4qZqwNxv
        fIaxdRdimpB0fUIux2Zz5mjOkGXM1hly1HTqG9p9WqVKJo+X70Ev0NEGNo9T0/tf0cQf0Om9
        w9HR77B6q1dpWJ6npYkJZqPVwkXnGnmLmuZM2XqTXG6S8GwebzXkSLKMeXvlMplC6Y3M1OfW
        FdeQpmLNe8OuCZAP7C+dAMFCSO2GbTXfED4Oo1oB7Fr2slAookLhamu4T4dTKbCltCIQQsOG
        aw7S7yVw7E4t8LGAeh6euTzl9SHCCOo4ASuGqjDfAqdWMFg58I/A30wE7bYZws9PwZYq53p2
        MPUqHG2px/z+Wfj3xSLcz5vhrZp5coMX+s8DP0fA45NDgZhQ6PZ0BHwk7O9YDNT5BDpvPwC+
        Q0DqJICutrEg/4YU3ii4tH4IEXUQlk/Z1j1BbYf517sDyfvhUlvfelGcioIt82W471ZwKg42
        tEt9CKkY2DtGbIyVf2mF/D/j1BOwwLX6n28tnw5Uj4X1ngasBMQ4Hl6145Fejoe9LgC8GjzJ
        mfi8HI5XmHY9+riNYP1D35ncCuzzi5IegAlBD4BCnI4QXZ1NyQwTZbPvf8CZjVqzVc/xPUDp
        nbIUF2/OMnr/FINFK1cqVCrZHiVSqhSI3iLiZW5tGJXDWrgjHGfizBt5mDBYnI/ZB8vxm1tf
        Pr2tULg8OPCdqWDHofRxl6Zy01dSdnVXcJUiWtEblXUn0m0tvZIUO/xuv1iUfVoThzzn8KGk
        sv6SuvAY56dNA4NDZWOkvOjtoysgwXGlMbTIrvvLsdDTd0HTfv5ARkyQI33VLImq/vC10c50
        tQyYpL9HmSKy0oOunpWkqBN/ydW5ktr6sU038LkOR/JSmlRs/zEtccfs6wcV+L1j0791flyy
        vaXxaF/GXSccfmDd4lI3Wybdb53MOPzc9JvapCOyY4fqFnpP/EQZqmv/7GQiixe7yYm9a6qp
        syJjeI0tzWj7Y2brnHzubvLjMdceW3i6OTaKGd0db/2onib4XFa+Ezfz7L/KpHe5cQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce
References: <20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce@epcms2p3>
        <CGME20210312080600epcms2p3f04061fbf25f2afb1588fa005541fbce@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch changes the read I/O to the HPB read I/O.

If the logical address of the read I/O belongs to active sub-region, the
HPB driver modifies the read I/O command to HPB read. It modifies the UPIU
command of UFS instead of modifying the existing SCSI command.

In the HPB version 1.0, the maximum read I/O size that can be converted to
HPB read is 4KB.

The dirty map of the active sub-region prevents an incorrect HPB read that
has stale physical page number which is updated by previous write I/O.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   2 +
 drivers/scsi/ufs/ufshpb.c | 256 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |   2 +
 3 files changed, 257 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e10984fd8d47..88dd0f34fa09 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2656,6 +2656,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
+	ufshpb_prep(hba, lrbp);
+
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
 	err = ufshcd_map_sg(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 489c8b1ac580..201dc24d55b3 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -46,6 +46,29 @@ static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
 	atomic_set(&hpb->hpb_state, state);
 }
 
+static int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
+				struct ufshpb_subregion *srgn)
+{
+	return rgn->rgn_state != HPB_RGN_INACTIVE &&
+		srgn->srgn_state == HPB_SRGN_VALID;
+}
+
+static bool ufshpb_is_read_cmd(struct scsi_cmnd *cmd)
+{
+	return req_op(cmd->request) == REQ_OP_READ;
+}
+
+static bool ufshpb_is_write_or_discard_cmd(struct scsi_cmnd *cmd)
+{
+	return op_is_write(req_op(cmd->request)) ||
+	       op_is_discard(req_op(cmd->request));
+}
+
+static bool ufshpb_is_support_chunk(int transfer_len)
+{
+	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
+}
+
 static bool ufshpb_is_general_lun(int lun)
 {
 	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
@@ -80,8 +103,8 @@ static void ufshpb_kick_map_work(struct ufshpb_lu *hpb)
 }
 
 static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
-					 struct ufshcd_lrb *lrbp,
-					 struct utp_hpb_rsp *rsp_field)
+				    struct ufshcd_lrb *lrbp,
+				    struct utp_hpb_rsp *rsp_field)
 {
 	/* Check HPB_UPDATE_ALERT */
 	if (!(lrbp->ucd_rsp_ptr->header.dword_2 &
@@ -107,6 +130,233 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
 	return true;
 }
 
+static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
+				 int srgn_idx, int srgn_offset, int cnt)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	int set_bit_len;
+	int bitmap_len;
+
+next_srgn:
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	if (likely(!srgn->is_last))
+		bitmap_len = hpb->entries_per_srgn;
+	else
+		bitmap_len = hpb->last_srgn_entries;
+
+	if ((srgn_offset + cnt) > bitmap_len)
+		set_bit_len = bitmap_len - srgn_offset;
+	else
+		set_bit_len = cnt;
+
+	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
+	    srgn->srgn_state == HPB_SRGN_VALID)
+		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
+
+	srgn_offset = 0;
+	if (++srgn_idx == hpb->srgns_per_rgn) {
+		srgn_idx = 0;
+		rgn_idx++;
+	}
+
+	cnt -= set_bit_len;
+	if (cnt > 0)
+		goto next_srgn;
+}
+
+static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
+				  int srgn_idx, int srgn_offset, int cnt)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	int bitmap_len;
+	int bit_len;
+
+next_srgn:
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	if (likely(!srgn->is_last))
+		bitmap_len = hpb->entries_per_srgn;
+	else
+		bitmap_len = hpb->last_srgn_entries;
+
+	if (!ufshpb_is_valid_srgn(rgn, srgn))
+		return true;
+
+	/*
+	 * If the region state is active, mctx must be allocated.
+	 * In this case, check whether the region is evicted or
+	 * mctx allcation fail.
+	 */
+	if (unlikely(!srgn->mctx)) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"no mctx in region %d subregion %d.\n",
+			srgn->rgn_idx, srgn->srgn_idx);
+		return true;
+	}
+
+	if ((srgn_offset + cnt) > bitmap_len)
+		bit_len = bitmap_len - srgn_offset;
+	else
+		bit_len = cnt;
+
+	if (find_next_bit(srgn->mctx->ppn_dirty,
+			  bit_len, srgn_offset) >= srgn_offset)
+		return true;
+
+	srgn_offset = 0;
+	if (++srgn_idx == hpb->srgns_per_rgn) {
+		srgn_idx = 0;
+		rgn_idx++;
+	}
+
+	cnt -= bit_len;
+	if (cnt > 0)
+		goto next_srgn;
+
+	return false;
+}
+
+static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
+				     struct ufshpb_map_ctx *mctx, int pos,
+				     int len, u64 *ppn_buf)
+{
+	struct page *page;
+	int index, offset;
+	int copied;
+
+	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
+	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
+
+	if ((offset + len) <= (PAGE_SIZE / HPB_ENTRY_SIZE))
+		copied = len;
+	else
+		copied = (PAGE_SIZE / HPB_ENTRY_SIZE) - offset;
+
+	page = mctx->m_page[index];
+	if (unlikely(!page)) {
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"error. cannot find page in mctx\n");
+		return -ENOMEM;
+	}
+
+	memcpy(ppn_buf, page_address(page) + (offset * HPB_ENTRY_SIZE),
+	       copied * HPB_ENTRY_SIZE);
+
+	return copied;
+}
+
+static void
+ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
+			int *srgn_idx, int *offset)
+{
+	int rgn_offset;
+
+	*rgn_idx = lpn >> hpb->entries_per_rgn_shift;
+	rgn_offset = lpn & hpb->entries_per_rgn_mask;
+	*srgn_idx = rgn_offset >> hpb->entries_per_srgn_shift;
+	*offset = rgn_offset & hpb->entries_per_srgn_mask;
+}
+
+static void
+ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
+			    u32 lpn, u64 ppn, unsigned int transfer_len)
+{
+	unsigned char *cdb = lrbp->cmd->cmnd;
+
+	cdb[0] = UFSHPB_READ;
+
+	/* ppn value is stored as big-endian in the host memory */
+	memcpy(&cdb[6], &ppn, sizeof(u64));
+	cdb[14] = transfer_len;
+
+	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
+}
+
+/*
+ * This function will set up HPB read command using host-side L2P map data.
+ * In HPB v1.0, maximum size of HPB read command is 4KB.
+ */
+void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufshpb_lu *hpb;
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	struct scsi_cmnd *cmd = lrbp->cmd;
+	u32 lpn;
+	u64 ppn;
+	unsigned long flags;
+	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
+	int err = 0;
+
+	hpb = ufshpb_get_hpb_data(cmd->device);
+	if (!hpb)
+		return;
+
+	if (ufshpb_get_state(hpb) == HPB_INIT)
+		return;
+
+	if (ufshpb_get_state(hpb) != HPB_PRESENT) {
+		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
+			   "%s: ufshpb state is not PRESENT", __func__);
+		return;
+	}
+
+	if (!ufshpb_is_write_or_discard_cmd(cmd) &&
+	    !ufshpb_is_read_cmd(cmd))
+		return;
+
+	transfer_len = sectors_to_logical(cmd->device,
+					  blk_rq_sectors(cmd->request));
+	if (unlikely(!transfer_len))
+		return;
+
+	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
+	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	/* If command type is WRITE or DISCARD, set bitmap as drity */
+	if (ufshpb_is_write_or_discard_cmd(cmd)) {
+		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
+				 transfer_len);
+		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+		return;
+	}
+
+	if (!ufshpb_is_support_chunk(transfer_len))
+		return;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
+				   transfer_len)) {
+		hpb->stats.miss_cnt++;
+		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+		return;
+	}
+
+	err = ufshpb_fill_ppn_from_page(hpb, srgn->mctx, srgn_offset, 1, &ppn);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	if (unlikely(err < 0)) {
+		/*
+		 * In this case, the region state is active,
+		 * but the ppn table is not allocated.
+		 * Make sure that ppn table must be allocated on
+		 * active state.
+		 */
+		dev_err(hba->dev, "get ppn failed. err %d\n", err);
+		return;
+	}
+
+	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
+
+	hpb->stats.hit_cnt++;
+}
 static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 					     struct ufshpb_subregion *srgn)
 {
@@ -153,7 +403,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 }
 
 static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
-				      struct ufshpb_req *map_req)
+			       struct ufshpb_req *map_req)
 {
 	bio_put(map_req->bio);
 	blk_put_request(map_req->req);
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index dcc0ca3b8158..6e6a0252dc15 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -201,6 +201,7 @@ struct ufs_hba;
 struct ufshcd_lrb;
 
 #ifndef CONFIG_SCSI_UFS_HPB
+static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_resume(struct ufs_hba *hba) {}
 static void ufshpb_suspend(struct ufs_hba *hba) {}
@@ -214,6 +215,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
 static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
 static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
 #else
+void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_resume(struct ufs_hba *hba);
 void ufshpb_suspend(struct ufs_hba *hba);
-- 
2.25.1

