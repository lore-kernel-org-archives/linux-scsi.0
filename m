Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E796AC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 07:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD71613FA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 07:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhD1H6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:58:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59916 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1H6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 03:58:33 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210428075747epoutp03aaf01f89444e384b4c7fd8bf0110369f~59paJ2G8x1134411344epoutp03L
        for <linux-scsi@vger.kernel.org>; Wed, 28 Apr 2021 07:57:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210428075747epoutp03aaf01f89444e384b4c7fd8bf0110369f~59paJ2G8x1134411344epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619596667;
        bh=Pe1KjPbNZnBRAUbdROdTIzYiaCrsq+xBMYRpfJkrKuk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=CMdhSB5gvW3MnF5e/L4TCvAoEryS5AmXT/+rQ/vcaSL1V75slmShCG+mebMk/WSOX
         Ie930MBzJPa+LdoH0ccoSGb59jLiMx7Q8yoIrpG5m4jS5bl3aoIIQi51f14MQrmaqJ
         xzUhQghpQ20yxSRoscM6HtgsEQh2XyRrrue8ghh0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210428075746epcas2p25b58ea334b6e4fa5d1a166342e920701~59pZhD6pP1359613596epcas2p2X;
        Wed, 28 Apr 2021 07:57:46 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FVWFh26H3z4x9QL; Wed, 28 Apr
        2021 07:57:44 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-13-60891578ca3a
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.08.09433.87519806; Wed, 28 Apr 2021 16:57:44 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v33 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman" <avri.altman@wdc.com>, jejb <jejb@linux.ibm.com>,
        "martin.petersen" <martin.petersen@oracle.com>,
        asutoshd <asutoshd@codeaurora.org>,
        "stanley.chu" <stanley.chu@mediatek.com>,
        cang <cang@codeaurora.org>, bvanassche <bvanassche@acm.org>,
        huobean <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20210428075614epcms2p40136d775b9c43190ae70095811c84741@epcms2p4>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210428075743epcms2p301200edbb99388c903b6f010f138628c@epcms2p3>
Date:   Wed, 28 Apr 2021 16:57:43 +0900
X-CMS-MailID: 20210428075743epcms2p301200edbb99388c903b6f010f138628c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0ybVRjGOd/38bUQKx+3ecRlY8UbuELL1u6wARIk0sHmcANN9sfaQr8B
        WW+0sKEmik5uHRSWKGsqg4k6HJCV+zXCKAsUDDEKDIbbgCggWyoU0FgFZi/gFv978jvPe973
        ORcm7rNABjAzFdm0WiGRsUlPon0g+BAn179YzH08wUSzVe0k+q7AzEBLtgkSVazYcLRqvO6O
        lkzBqLu/n0R1s++ii18ZSVQ5moeh0rI2ErX0N+Lol3trDFQz1Y6hsq1CArWveaOh4d8BGuuu
        JNGlyU4S1Q5tYeibtrsAFV9pIGJ2CcfGE4VjulJM2GW4zxCW19wCwr6rDQzhp8N9hNA6P00I
        da11QLjWvEdYeOsSluR5WhaZQUuktDqQVqQppZmK9Ch24inRGyK+gMvj8CLQIXagQiKno9hx
        x5I4b2bK7DHZgeclshw7SpJoNOyw6Ei1MiebDsxQarKj2LRKKlPxeKpQjUSuyVGkh6Yp5Yd5
        XG443+4UyzL0zUkq3du569ZZPA/kx2qBBxNSB6G1oQtogSfTh+oE8EF+IaEFTCaL8oabnb4O
        jy+VAOeLJkiH9qHY0PijgeHioXB6rgE4NEnth1fMM07uR32Bw0d1cseeOFWPw6bqFszVjAX1
        hfOES78AO2rbnMUe1Fv2Ta+RLv4q/Ot6Ke7S/vBuvYWxo5cHq4FL+8H8B6PbHm84a+vZ5s/D
        wZ6V7V4fwbZ7fzuDQaoEwIGuaXfXQhi8U9TkHIJFHYf1YxXOAoJ6CfYWfIw5wkMqDi7dCXFg
        nNoLOyyVuAPjVDA0doe5HEHw9jSxkyqv6R/G/zVOPQuLBjb/451Vv25P9jK8aTNi5SDI8OSg
        DU/1MjzpdQ3gdWAXrdLI02lNuOrA01fbDJwPPiS+E+gtK6EmgDGBCUAmzvZjkd35Yh+WVPLe
        +7RaKVLnyGiNCfDtIS/jAf5pSvuPUWSLePxwgYAbwUd8QThiP8ey0R+Kfah0STZ9jqZVtHqn
        DmN6BORhusFKj43z7l7WDYNl6Kzb6rEXS06mNqceEbiVLZ8xxU6dW++LjJ+zVHubPtC+/nhL
        IfJavArhl1kdFUfVj7TRLP2UYaZ8WGfOAlUtP2+WhEzpu7h/CASH9zZ/n3V5aH/KJwvFW3j/
        6Qnxa7XBS5aNHnf9iaCR9vlTy1JUkTyam37QPPOt+31OytiFObej67OtC4ZFzuf7xv0PVL/y
        2dln4s2TXuJ3VOUnj/guyBMIY9XID8nlNcfVrJiwqJqbvBsP/+z1l2fGcKyw1fNh8r7JoeXb
        IY0jw9Y1bcKN1fzoxD27F38ynkltPEHvlooqvuaYfyvodYutE1C8qQu28YtxKRFsQpMh4YXg
        ao3kX/tyCzZ5BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210428075614epcms2p40136d775b9c43190ae70095811c84741
References: <20210428075614epcms2p40136d775b9c43190ae70095811c84741@epcms2p4>
        <CGME20210428075614epcms2p40136d775b9c43190ae70095811c84741@epcms2p3>
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
Tested-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   2 +
 drivers/scsi/ufs/ufshpb.c | 257 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |   2 +
 3 files changed, 258 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3699b8603e9a..e070aec72924 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2647,6 +2647,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
+	ufshpb_prep(hba, lrbp);
+
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
 	err = ufshcd_map_sg(hba, lrbp);
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index c67acfc8c6bf..e23fc97fac6d 100644
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
+	memcpy(&cdb[6], &ppn, sizeof(__be64));
+	cdb[14] = (u8)transfer_len;
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
+	    (!ufshpb_is_write_or_discard(cmd) &&
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

