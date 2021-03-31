Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A2CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 01:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9C1619D9
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 01:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhCaBR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:17:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26207 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhCaBRw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 21:17:52 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210331011750epoutp023d54e4bf75a732759ec1fea6eb1911de~xSIN8FIPn0515205152epoutp02M
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2021 01:17:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210331011750epoutp023d54e4bf75a732759ec1fea6eb1911de~xSIN8FIPn0515205152epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1617153470;
        bh=na/hfSLOjeznbzfb0JgM0jEtKnKgaPvDKSPrlOoY7Yk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=AVY0Ildp5WAG3iQ3g6XOdTJq9ltV3l8vajCvcScbPcuA8+ExwiBBcxEprAdYLWhfQ
         uDVntyu/ZuS1Ur4YzFRnGdSkGPCRnvZ3s+evZl4R6LPoOU/1PYIMNm14tAZYfTgI1t
         NV7Po9dSDC4Kw2yLH951vuZ6lgE4QPl/OY/Kz97o=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210331011750epcas2p3aba0d7116e716dee0e8ddc6962ac846f~xSINS8VuC2057220572epcas2p3O;
        Wed, 31 Mar 2021 01:17:50 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4F97j73qxdz4x9Pr; Wed, 31 Mar
        2021 01:17:47 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-a8-6063cdbb6100
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        96.FF.52511.BBDC3606; Wed, 31 Mar 2021 10:17:47 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v32 3/4] scsi: ufs: Prepare HPB read for cached sub-region
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
In-Reply-To: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210331011746epcms2p27df366c4d084572c811314428ade0ff4@epcms2p2>
Date:   Wed, 31 Mar 2021 10:17:46 +0900
X-CMS-MailID: 20210331011746epcms2p27df366c4d084572c811314428ade0ff4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJsWRmVeSWpSXmKPExsWy7bCmhe7us8kJBlOei1k8mLeNzWJv2wl2
        i5c/r7JZTPvwk9ni0/plrBYvD2la7Dp4kM1i1YNwi+bF69ks5pxtYLLo7d/KZrH54AZmi8d3
        PrNbLLqxjcmi/187i8W2z4IWx0++Y7S4vGsOm0X39R1sFsuP/2OyWLr1JqNF5/Q1LA5iHpev
        eHtc7utl8tg56y67x4RFBxg99s9dw+7RcnI/i8fHp7dYPPq2rGL0+LxJzqP9QDdTAFdUjk1G
        amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0JtKCmWJOaVA
        oYDE4mIlfTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjDvv
        1zMVPA2o2PjtP1sD40PHLkZODgkBE4mfp6cydjFycQgJ7GCUOHRvMlMXIwcHr4CgxN8dwiA1
        wgJeEls7PrCA2EICShLrL85ih4jrSdx6uIYRxGYT0JGYfuI+O8gcEYFWFolFZ5czgTjMAueZ
        JfbcaGeE2MYrMaP9KQuELS2xfflWsDingJ/E34croOIaEj+W9TJD2KISN1e/ZYex3x+bDzVH
        RKL13lmoGkGJBz93Q8UlJY7t/sAEYddLbL3zC+wzCYEeRonDO2+xQiT0Ja51bARbxivgK/Hv
        0Dc2EJtFQFXi1RmQxRxANS4SWw6DhZkF5CW2v50DFmYW0JRYv0sfokJZ4sgtFpivGjb+Zkdn
        MwvwSXQc/gsX3zHvCdRlahLrfq5nmsCoPAsR0rOQ7JqFsGsBI/MqRrHUguLc9NRiowIT5Mjd
        xAhO8loeOxhnv/2gd4iRiYPxEKMEB7OSCK/wgcQEId6UxMqq1KL8+KLSnNTiQ4ymQE9OZJYS
        Tc4H5pm8knhDUyMzMwNLUwtTMyMLJXHeIoMH8UIC6YklqdmpqQWpRTB9TBycUg1M2TF1LN6x
        517wm89weejxLqjyUZhUSaif1HPnXd9/HXw1z3//77jQ8oML+N+VvZXNiOKc6XDdfqHQ1r1P
        lJudd0+Ou3Fq+o8NPfxP9tSsU2feNUXydNkMZ+NLbnpbSy5u3sNwwuNSlb5n1OdyTqEFWf3/
        7zK2RMRsKJhl9/nOHpcDD4/u9c1zrTAufSuuFHyh7OzGHSFbpz9cxr9gJV9c1Tbz6m9CSgec
        qrIU/526lLHh7jHVn1xl9wTCp6jddmnpX7HsaIzVa2XzEOYapqDZPhNvvvvoa6YeYS656dzB
        PyLfXd14dgWG1em/Tw42PSbF9/737clvz/06uVnbo/7FyWqn0rUSbTLGDJal3BzrlFiKMxIN
        tZiLihMBe55VcXsEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217
References: <20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p3>
        <CGME20210331011526epcms2p37684869a9781d1eb45bfcbfe9babd217@epcms2p2>
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
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   2 +
 drivers/scsi/ufs/ufshpb.c | 257 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |   2 +
 3 files changed, 258 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f4443a7b252b..2145360d74da 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2645,6 +2645,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
+	ufshpb_prep(hba, lrbp);
+
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
 	err = ufshcd_map_sg(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index c67acfc8c6bf..f789339f68d9 100644
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
@@ -107,6 +130,234 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
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
+	if (blk_rq_is_scsi(cmd->request) ||
+	    (!ufshpb_is_write_or_discard_cmd(cmd) &&
+	    !ufshpb_is_read_cmd(cmd)))
+		return 0;
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
@@ -153,7 +404,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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

