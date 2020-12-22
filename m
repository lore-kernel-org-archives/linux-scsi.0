Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332E6C433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 01:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF94122A83
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 01:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgLVB7l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 20:59:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25423 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLVB7k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 20:59:40 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201222015857epoutp0164df80803819e93dd5a68d5a8e61668a~S50274lXz0074300743epoutp01M
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 01:58:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201222015857epoutp0164df80803819e93dd5a68d5a8e61668a~S50274lXz0074300743epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608602338;
        bh=xTNZiA+MrtKkxAtqF0J6sBQK4BjN6wmRik+BDqHE+hg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=VpusDvTDh1mHgYO8Vb7sovRLpEEKcH4Adwf3JiAzZAquB8p3c9gUVNzap+VyJSnXX
         5Jj1iMJFdOb5RdGd0JSABwiyQPJUd5qPWP4wJQ+7xXY0J2CO09+8xusSRlIlrnge++
         uYAmuHFR5j6wrp3d+kjN9Tk7LDJGq5ggKeNkYxMU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201222015857epcas2p234fbd191413a7dfb19d0068570e2214a~S502SK0rm3231432314epcas2p2K;
        Tue, 22 Dec 2020 01:58:57 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D0KJH2rrKz4x9Q5; Tue, 22 Dec
        2020 01:58:55 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-15-5fe152dece09
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.96.05262.ED251EF5; Tue, 22 Dec 2020 10:58:54 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v18 3/3] scsi: ufs: Prepare HPB read for cached sub-region
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
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49@epcms2p1>
Date:   Tue, 22 Dec 2020 10:58:54 +0900
X-CMS-MailID: 20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmme69oIfxBpcX2lhsvPuK1eLBvG1s
        FnvbTrBbvPx5lc3i8O137BbTPvxktvi0fhmrxctDmharHoRbNC9ez2Yx52wDk0Vv/1Y2i0U3
        tjFZXN41h82i+/oONovlx/8xWdzewmWxdOtNRovO6WtYLBYt3M3iIOJx+Yq3x+W+XiaPnbPu
        sntMWHSA0WP/3DXsHi0n97N4fHx6i8Wjb8sqRo/Pm+Q82g90MwVwReXYZKQmpqQWKaTmJeen
        ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9p6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMl4MvkhU8Ejt4oFP6cw
        NTB+sexi5OSQEDCR2L/pLCuILSSwg1HizhSHLkYODl4BQYm/O4RBwsICXhKLpq9mgyhRklh/
        cRY7RFxP4tbDNYwgNpuAjsT0E/eB4lwcIgKtLBKLzi5nAnGYBb4ySXx6PpsJYhmvxIz2pywQ
        trTE9uVbwbo5Bfwk9h28wwwR15D4sawXyhaVuLn6LTuM/f7YfEYIW0Si9d5ZqBpBiQc/d0PF
        JSWO7f4AtateYuudX4wgR0gI9DBKHN55ixUioS9xrWMj2BG8Ar4SZ18+AbNZBFQlbrz/B7XM
        RWLhkT9g9cwC8hLb385hBoUKs4CmxPpd+iCmhICyxJFbLDBvNWz8zY7OZhbgk+g4/BcuvmPe
        E6jT1CTW/VzPNIFReRYiqGch2TULYdcCRuZVjGKpBcW56anFRgXGyJG7iRGc0LXcdzDOePtB
        7xAjEwfjIUYJDmYlEV4zqfvxQrwpiZVVqUX58UWlOanFhxhNgb6cyCwlmpwPzCl5JfGGpkZm
        ZgaWphamZkYWSuK8xQYP4oUE0hNLUrNTUwtSi2D6mDg4pRqYlKbc0pf/de1PzYtJtzT8b0cW
        9rDdr/39IEMuedJpoWv2FlfL8id7qxxk0GaSsDx+5Apjw6s34rOnWVSo87wXZZ52uuZVd3/i
        5KYrN/+HKhdN+OdwonS340NZjqA5tx1YNi8/6q3tud3jPOOrpW1u/a7bPeK+mFv9v+PJJ3Hk
        TdHPay7zWKqy499KejdkC85X2xVlV73bmv2SyqtPHfP63Wur5vLNfi2bsbPtbPDn1bVsWT8+
        fj/An7vv/9PHcTvMF80s4Fq18VNUWvDONVrrvrT6ZKVe7Ob/zp6+mvPf/EMvdy3pfNO5sVo2
        W9atZdG7To2QpkkFTwsPL2g7crG+JCQhLqE3xm39AjMrg9i9SizFGYmGWsxFxYkA+MIEBXEE
        AAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222015704epcms2p643f0c5011064a7ce56b08331811a8509
References: <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
        <CGME20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p1>
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
 drivers/scsi/ufs/ufshpb.c | 232 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |   2 +
 3 files changed, 236 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0ec0ed237140..41554afead63 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2600,6 +2600,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
+	ufshpb_prep(hba, lrbp);
+
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 37ae61fbf36a..d3e6c5b32328 100644
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
@@ -98,6 +121,215 @@ static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
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
+	unsigned char *cdb = lrbp->ucd_req_ptr->sc.cdb;
+
+	cdb[0] = UFSHPB_READ;
+
+	put_unaligned_be64(ppn, &cdb[6]);
+	cdb[14] = transfer_len;
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

