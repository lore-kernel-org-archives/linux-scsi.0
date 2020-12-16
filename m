Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794E1C2BB48
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 02:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC912311D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 02:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLPCr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:47:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20912 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPCr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 21:47:56 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201216024713epoutp04d1baac20978f3e1fa04d9b49d9652097~REnSFZGhK0494904949epoutp04S
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2020 02:47:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201216024713epoutp04d1baac20978f3e1fa04d9b49d9652097~REnSFZGhK0494904949epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608086833;
        bh=xW1fDXdLv9OL+MOFF5dqmWIXt0AdcYVnw9P6gxrE1kY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=VCTSZYzwygc68DWbnb6E3Hr8/cHGkoN6Qiye67j/cmrWIB4rF8p+W2AkyFcZefAb+
         ZU1mH529Qrqw2ib8N/W4XbMKs92i7vJ2aMKprHyuRROdsmBTpVEaPgIOPyBHGoMKjM
         35G5YyTZGdqFGhxcWeBBgCmMVwwr1NSeKssHrt/8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201216024712epcas2p49c80f76431a463c5723ac8e95496c8c4~REnRYChYu0622206222epcas2p4C;
        Wed, 16 Dec 2020 02:47:12 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Cwffk4pfDzMqYkh; Wed, 16 Dec
        2020 02:47:10 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-31-5fd9752eca90
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.16.05262.E2579DF5; Wed, 16 Dec 2020 11:47:10 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v14 3/3] scsi: ufs: Prepare HPB read for cached sub-region
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20201216024627epcms2p7f5b3e63164704bd6897a1d44038aed30@epcms2p7>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201216024710epcms2p66c53656f17e300aff81d53354ac571db@epcms2p6>
Date:   Wed, 16 Dec 2020 11:47:10 +0900
X-CMS-MailID: 20201216024710epcms2p66c53656f17e300aff81d53354ac571db
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52TbUxbVRzGPfeWtpDUXF49g2zUu2wBlNIX2p1OIHyYeOfcoonMsCn1rlwp
        Ai3etpOhCXVTwTFgxESwMoaAdAJbBwNWSgikbJOpGAiiwN7YLEbAbswXXCsvUlrc4ke//c5z
        nv95/ueNj4fYeZH8HK2BYbV0HskN4nQPxiriRcZJlbjh52jUfmMuAE3XdXNR34dDPDTrHuei
        wWt3eeiTBTeOfrM2B6BZRyxqmX4FHWu0clHtsAlD5ZVdXNQw0Y2hMXstF5X9aOMiy1crGLrW
        GYS+6JoE6KPqNg5q+LyXkxpGjX2/hxqrKMeoHvMNHnWyYQBQ/afaeNT7V/s51P2ZKQ5V0dkC
        qN87tlAlA2XYi0EHTCCJZtWanMOMkNGqdVk52uxkMv3ltHhECjU6vSGZPChBUpFEKRclKkXS
        Ha/tlIjFUjkp1NL5TDJZGO+vJoWsumDNbWD0BpZRM2sSm6o30NmMSE/n643abJFal08KD9N5
        xrU6MiElScPQWQwrfN0JNAtf12IFd9IKmy8PYCbwh/I4CORDIhF+euwv/DgI4ocQNgDnnZPY
        ccDnC4hguGwL9XpCiedhu9uDezmEIKF11Mzz6SI4dbsNeJlLPA2rh27xvOuEEbdwaL56lOMd
        4MQpHF4eXsJ9aQJYUzLD8XEUvGjpWq8OJPbBoUulfk8MfNBc7udwONnq4m3wvSungY/D4Ac3
        h/2eYDjt7vXrm+CV3gXMx8Ww67oHeJuAxAkAB3umAnwTCfCH0vb1JgTEXtj5XtN6AIfYBk1H
        7/sX2gVrh8+ve3AiGl501eLeU8GJWGi1J3gRElvhpSnOxrZM7X/z/ss48TgsHVz+V7fVOf2t
        bYfn3FbsJNhqfnjU5keyzA+z6gHeAiKYAn1+NqOXFsgevekOsP7+456zgRrXgsgBMD5wAMjH
        yTDBkmtCFSLIoo8UMaxOxRrzGL0DFK3tsgqPDFfr1j6Q1qCSKMRShVyWKJPJE+X/W5ZLFQqx
        Uo7kCikinxCkf1mhCiGyaQOTyzAFDLsRjvEDI03Yjoge2VsVu/vycl0ZxKGRlqYSRV/8TqVn
        /5xlj8xl/872pmJmU1iSUzVgexCdMrld2fcY27S4+ebpM/XBlXeKuPfaMojNxsyokeCq5ZTG
        DqZ11Bh3olLXJ9bYXwi4/Vnr/g6Y8+Que0wV5am5vnjkm6cKo8hMPKOeGav+ZVUwmm7+07xY
        1zGe5rQMqdv7g63zsvILoYmjQ4ek5yWZbITLM/HqClodt36c2rxamdvgvKB5Y7ytsf6nsbNN
        pWf3qrm8EVVx44RntWemuOXc3boSLDzGsm3LPi7meOmZBBQwe8aSsSR4e+XA8u53n/01/yCa
        w8eTHfNlloqyd7LwNPe3JEevoSVxOKun/wFcEfj9zQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306
References: <20201216024627epcms2p7f5b3e63164704bd6897a1d44038aed30@epcms2p7>
        <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
        <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
        <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p6>
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
index d78d882c5b33..a2a3b88d32bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2582,6 +2582,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
+	ufshpb_prep(hba, lrbp);
+
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 65b7760c0b07..725bcff3a5c7 100644
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
+		spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
+				 transfer_len);
+		spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+		return;
+	}
+
+	if (!ufshpb_is_support_chunk(transfer_len))
+		return;
+
+	spin_lock_irqsave(&hpb->hpb_state_lock, flags);
+	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
+				   transfer_len)) {
+		hpb->stats.miss_cnt++;
+		spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
+		return;
+	}
+
+	ppn = ufshpb_get_ppn(hpb, srgn->mctx, srgn_offset, &err);
+	spin_unlock_irqrestore(&hpb->hpb_state_lock, flags);
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
index 17374893e3da..43838eba3234 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -197,6 +197,7 @@ struct ufs_hba;
 struct ufshcd_lrb;
 
 #ifndef CONFIG_SCSI_UFS_HPB
+static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
 static void ufshpb_resume(struct ufs_hba *hba) {}
 static void ufshpb_suspend(struct ufs_hba *hba) {}
@@ -210,6 +211,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba) { return false; }
 static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
 static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
 #else
+void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 void ufshpb_resume(struct ufs_hba *hba);
 void ufshpb_suspend(struct ufs_hba *hba);
-- 
2.25.1

