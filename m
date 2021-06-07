Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FD0C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 04:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC986121D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 04:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFGEUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 00:20:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63568 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhFGEUv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 00:20:51 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210607041859epoutp01377e9837c702d34bc2a67ea38c092fd0~GMdyvorwo2736027360epoutp01J
        for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2021 04:18:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210607041859epoutp01377e9837c702d34bc2a67ea38c092fd0~GMdyvorwo2736027360epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623039539;
        bh=xgWa+3JXaDgMJe7sUIotK8ZV1metpjIVB/vH+1oBMfg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=pIU9bEzDcMP0qwnOiUDiLgxZDdhSFkMVaIVehDM7s9u/8Ar4/2Ssx+Vj2hzEf7ue8
         S36tcD+rxZ3bTCWRPjuCFXilDI2JmUsniBMhLz/3++7YvBW4LqOQR5tYTkR7At7Gfv
         KQ3MzBmh+gPqt+PQKYqv50RfqKgyzkS/dc/sY0Fs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210607041858epcas2p1e5b7589fdc313e750829324bbca0420f~GMdyAGJG11963919639epcas2p17;
        Mon,  7 Jun 2021 04:18:58 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Fz0Vm2hk9z4x9Q9; Mon,  7 Jun
        2021 04:18:56 +0000 (GMT)
X-AuditID: b6c32a45-db3ff70000002584-91-60bd9e30a388
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.A3.09604.03E9DB06; Mon,  7 Jun 2021 13:18:56 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v36 3/4] scsi: ufs: Prepare HPB read for cached sub-region
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
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210607041855epcms2p5bf52ae178f7f22d863860d636d705111@epcms2p5>
Date:   Mon, 07 Jun 2021 13:18:55 +0900
X-CMS-MailID: 20210607041855epcms2p5bf52ae178f7f22d863860d636d705111
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xTVxzHd+69vS1sJZcW2BlOwYubA6W0zOJhgU0CW25gM4hR9wxc4AaY
        faUtKLgMcAgK8jAsShpArAxYZauClHeEVsUXYxtsAgMGcUbZhoMRkoFBRluYZv998j3f8/v+
        fuchwEXTpLcgTaXntCpWQZOuhMXmHxIore5OkOaOPY8mqy0k6s6/wUfTiz+R6PTsIo7+Ntfx
        0LTVH3X09pLINHkAfXHeTKLK/hwMFZe2kKi59yKO7o3N85Fx2IKh0icFBLLMu6O+m48AGuyo
        JFHR3TYS1fc9wdBXLSMAnTjTSOzyYgaHYpjBkmKMaTeM85kyYw9grlQ18pm8m1cIZu7+KMGU
        XDYBZr5pE1PQU4TFun6oCEvl2GRO68upktTJaaqUcDpmb3xkvDxEKguUhaKdtK+KVXLhdNS7
        sYHvpClWx6R9M1hF+qoUy+p0dNCbYVp1up7zTVXr9OE0p0lWaGQyjUTHKnXpqhRJklr5hkwq
        DZavOhMUqafKm3FNQ9zhvGvnyBxQFlkIXASQ2gE7TAasELgKRFQbgEsTU7xCIBAIKXe43Ca2
        e8RUNFxot5F2FlE0NP9g4Dt1CRydagR2Jqnt8MyNX/n2Oh7UMQIa++sdRXFqAIddwwXAmSaE
        FQX3CSdvgK31LQ7dhdoNW1cq1vTX4D91xbiTPeHIhRn+Ov91/exaHQ94bKJ/zeMOJxc71/SX
        4PXOWczJ2bBlbAnYm4DUSQBt7aM850IQ/Pn4JUeYkHoPWm5/7dAJ6hU40FlPOj1RcKF2zsE4
        5QNbZypx+6nglD80dwTZEVJ+8OoosT5WzqXH/P8zTrnB47bl//S26t/WWnsVfrtoxsqAn+Hp
        URueyTI8zaoBuAl4cRqdMoXTBWtkz95uE3C8+YC320D5zKzECjABsAIowGkPYfTLXQkiYTKb
        mcVp1fHadAWnswL56pSncG/PJPXqp1Hp42Xy4JAQaagcyUOCEf2icJH7PEFEpbB67iDHaTjt
        +j5M4OKdg70VPlgzXHTnLCG13fEv/+Xew0TbPuPYsJ/6z7jEppo0VXf4Y/74+LYLVRENZfqt
        zBFerjWOrVfEHuR5lPtPmH7US695Lz+WP6j7iBT1RbhJyOIeeO73ki0V2w3ZpfNG087vT2cG
        hR25ZX20ucC96jDpcyJGUrs0LQ64OD30+qcjyvijtgW2OXKH5eHGXfv3Xv1G7GldyNj9mSx6
        KPr9XH1tZte+/SD/8kDaXOFzG5qzMje5TWVtrp7q++T8HpR/F4ozRo7u+TKi79AfxBblBx8n
        lsRMZRaH9ga9cCC3Cm/Kvo2ZvzOv+GwVyX14c1Ht5eIHIktew6EVo6zoltfG3GrvbSKa0KWy
        sgBcq2P/BWpy0d18BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e
References: <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
        <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p5>
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
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Tested-by: Can Guo <cang@codeaurora.org>
Tested-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   2 +
 drivers/scsi/ufs/ufshpb.c | 259 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |   2 +
 3 files changed, 260 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 02490f8f15d4..da96b7c6b108 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2721,6 +2721,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
+	ufshpb_prep(hba, lrbp);
+
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
 	err = ufshcd_map_sg(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 5f01b0e56477..fdb89836707b 100644
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
+static bool ufshpb_is_write_or_discard(struct scsi_cmnd *cmd)
+{
+	return op_is_write(req_op(cmd->request)) ||
+	       op_is_discard(req_op(cmd->request));
+}
+
+static bool ufshpb_is_supported_chunk(int transfer_len)
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
@@ -107,6 +130,236 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
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
+				     int len, __be64 *ppn_buf)
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
+			    u32 lpn, __be64 ppn, u8 transfer_len)
+{
+	unsigned char *cdb = lrbp->cmd->cmnd;
+
+	cdb[0] = UFSHPB_READ;
+
+	/* ppn value is stored as big-endian in the host memory */
+	memcpy(&cdb[6], &ppn, sizeof(__be64));
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
+	__be64 ppn;
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
+	if (blk_rq_is_scsi(cmd->request) ||
+	    (!ufshpb_is_write_or_discard(cmd) &&
+	    !ufshpb_is_read_cmd(cmd)))
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
+	if (ufshpb_is_write_or_discard(cmd)) {
+		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
+				 transfer_len);
+		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+		return;
+	}
+
+	if (!ufshpb_is_supported_chunk(transfer_len))
+		return;
+
+	WARN_ON_ONCE(transfer_len > HPB_MULTI_CHUNK_HIGH);
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
@@ -153,7 +406,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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

