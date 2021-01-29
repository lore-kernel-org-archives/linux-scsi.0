Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01194C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D5064E05
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhA2Fbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:31:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10349 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbhA2Fbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 00:31:34 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210129053047epoutp01e16f79a6a0036eba0e14843748d762b7~enOpi5aMg2197021970epoutp01V
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2021 05:30:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210129053047epoutp01e16f79a6a0036eba0e14843748d762b7~enOpi5aMg2197021970epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611898247;
        bh=U4qi+HNYck972kgaSHpqflf1bebUTdQQhlwWvJMhbGE=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=PzGyHXMP/dT4BuHLkcvdy5tQ87oNWxGIWspf0DwZlj7l/ZKfnQDqCJu9ShvbF7JPw
         vjHPGrfAlDcfNV6WuUpaVczHDZjkE+M2BQ+AYdNMfo+kCLHzngjNUO7freEHIpJtCD
         4RniiUeai/ifEjCShJCKZ4yrXBskv8cqc/HUtCEU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210129053045epcas2p20f86c7df3d71cca67e5e4bb86faf463c~enOoM8hdr1273512735epcas2p2h;
        Fri, 29 Jan 2021 05:30:45 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DRmC737XLz4x9QH; Fri, 29 Jan
        2021 05:30:43 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-ce-60139d8309ed
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.4D.05262.38D93106; Fri, 29 Jan 2021 14:30:43 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached sub-region
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
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
Date:   Fri, 29 Jan 2021 14:30:42 +0900
X-CMS-MailID: 20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmuW7zXOEEg419ghYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWSy6sY3J4vKu
        OWwW3dd3sFksP/6PyeL2Fi6LpVtvMlp0Tl/DYrFo4W4WB2GPy1e8PS739TJ57Jx1l91jwqID
        jB77565h92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAKyrHJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoLyWFssScUqBQQGJxsZK+nU1RfmlJqkJG
        fnGJrVJqQUpOgaFhgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7G5N2NrAWN7hXX38xia2CcYNXF
        yMkhIWAiMaftLHsXIxeHkMAORomzi48DORwcvAKCEn93CIPUCAt4SZy88IsRxBYSUJJYf3EW
        O0RcT+LWwzVgcTYBHYnpJ+6DzRERaGWR6Hn3BSzBLHCJSeLvfEeIZbwSM9qfskDY0hLbl28F
        q+EU8JNoPTaXFSKuIfFjWS8zhC0qcXP1W3YY+/2x+YwQtohE672zUDWCEg9+7oaKS0oc2/2B
        CcKul9h6B+RoLiC7h1Hi8M5bUAv0Ja51bAQ7glfAV+LNnY9gDSwCqhIHdy2HanaR2Ng7hQXi
        AXmJ7W/nMIMChVlAU2L9Ln0QU0JAWeLILRaYtxo2/mZHZzML8El0HP4LF98x7wnUdDWJdT/X
        M01gVJ6FCOlZSHbNQti1gJF5FaNYakFxbnpqsVGBMXLkbmIEp3Et9x2MM95+0DvEyMTBeIhR
        goNZSYT37RyhBCHelMTKqtSi/Pii0pzU4kOMpkBfTmSWEk3OB2aSvJJ4Q1MjMzMDS1MLUzMj
        CyVx3mKDB/FCAumJJanZqakFqUUwfUwcnFINTAePr7Q6pbZp+bocT83F1YkyAf7x61rP/60L
        WGtqIFjGvPp4DNv1HzcZdZay/Q2apdV69dJbrksLnNR9joapHs+8evx54PYfy9cx5BfeUXml
        8Y7h3dIaHs615/zXljdfl7+5JLU0SmK1m6jf3nV+1tlnu54+lUm7fOkSq5ZE0FatOx0MT7YW
        5XFFznF1m/7nk8uOVt7EL3I8jH0rZkUZTX4br/ztXkGWkEz9+TBD3q+z/ktI9sz21U6sLlh2
        c26bstIytS57ry63zTe7rY+nPXl2J08p4TvfT+2aQ6tWFmwv6hD9srvh843pAtNebyk45Pcq
        4pV9ZKypkImHTepbzvpTq2rrNRTXT12X8jjUQ4mlOCPRUIu5qDgRAHsHgmxsBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
        <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
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
 drivers/scsi/ufs/ufshpb.c | 234 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |   2 +
 3 files changed, 238 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52e48de8d27c..37cb343e9ec1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2653,6 +2653,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
+	ufshpb_prep(hba, lrbp);
+
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
 	err = ufshcd_map_sg(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 48edfdd0f606..73e7b3ed04a4 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -31,6 +31,29 @@ bool ufshpb_is_allowed(struct ufs_hba *hba)
 	return !(hba->ufshpb_dev.hpb_disabled);
 }
 
+static int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
+			     struct ufshpb_subregion *srgn)
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
@@ -98,6 +121,217 @@ static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
 	atomic_set(&hpb->hpb_state, state);
 }
 
+static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
+			     int srgn_idx, int srgn_offset, int cnt)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	int set_bit_len;
+	int bitmap_len = hpb->entries_per_srgn;
+
+next_srgn:
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
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
+
+	WARN_ON(cnt < 0);
+}
+
+static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
+				   int srgn_idx, int srgn_offset, int cnt)
+{
+	struct ufshpb_region *rgn;
+	struct ufshpb_subregion *srgn;
+	int bitmap_len = hpb->entries_per_srgn;
+	int bit_len;
+
+next_srgn:
+	rgn = hpb->rgn_tbl + rgn_idx;
+	srgn = rgn->srgn_tbl + srgn_idx;
+
+	if (!ufshpb_is_valid_srgn(rgn, srgn))
+		return true;
+
+	/*
+	 * If the region state is active, mctx must be allocated.
+	 * In this case, check whether the region is evicted or
+	 * mctx allcation fail.
+	 */
+	WARN_ON(!srgn->mctx);
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
+static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
+			  struct ufshpb_map_ctx *mctx, int pos, int *error)
+{
+	u64 *ppn_table;
+	struct page *page;
+	int index, offset;
+
+	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
+	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
+
+	page = mctx->m_page[index];
+	if (unlikely(!page)) {
+		*error = -ENOMEM;
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"error. cannot find page in mctx\n");
+		return 0;
+	}
+
+	ppn_table = page_address(page);
+	if (unlikely(!ppn_table)) {
+		*error = -ENOMEM;
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"error. cannot get ppn_table\n");
+		return 0;
+	}
+
+	return ppn_table[offset];
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
+				  u32 lpn, u64 ppn,  unsigned int transfer_len)
+{
+	unsigned char *cdb = lrbp->cmd->cmnd;
+
+	cdb[0] = UFSHPB_READ;
+
+	put_unaligned_be64(ppn, &cdb[6]);
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
+	transfer_len = sectors_to_logical(cmd->device, blk_rq_sectors(cmd->request));
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
+	ppn = ufshpb_get_ppn(hpb, srgn->mctx, srgn_offset, &err);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+	if (unlikely(err)) {
+		/*
+		 * In this case, the region state is active,
+		 * but the ppn table is not allocated.
+		 * Make sure that ppn table must be allocated on
+		 * active state.
+		 */
+		WARN_ON(true);
+		dev_err(hba->dev, "ufshpb_get_ppn failed. err %d\n", err);
+		return;
+	}
+
+	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
+
+	hpb->stats.hit_cnt++;
+}
+
 static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 					     struct ufshpb_subregion *srgn)
 {
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index e40b016971ac..2c43a03b66b6 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -198,6 +198,7 @@ struct ufs_hba;
 struct ufshcd_lrb;
 
 #ifndef CONFIG_SCSI_UFS_HPB
+static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_resume(struct ufs_hba *hba) {}
 static void ufshpb_suspend(struct ufs_hba *hba) {}
@@ -211,6 +212,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
 static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
 static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
 #else
+void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_resume(struct ufs_hba *hba);
 void ufshpb_suspend(struct ufs_hba *hba);
-- 
2.25.1

