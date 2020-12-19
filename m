Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D17C3526D
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3739223BCA
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgLSDc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:32:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19594 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLSDcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 22:32:23 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201219033139epoutp0208e9258e286a4d5e494e1766f566cd61~SAJ7uH6BR1266512665epoutp02H
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 03:31:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201219033139epoutp0208e9258e286a4d5e494e1766f566cd61~SAJ7uH6BR1266512665epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608348699;
        bh=+4yCnfwzKaSPpSNHQovytT4X1m0er/sJ2PUgnea4oBM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=S22FPXu1B/5/Mr42YaOHNaQ69jgWMvaYGWfpWxhX62Ie6ZO5ZGU5zI88pm1ZdwT3y
         dWUp6RiRWKhEEdH1fo7770ahm1/j9TNzNTypBpsjF+7l2Z09Q00r1SDERzwoK5YcaO
         I3KopsO1UpHgaJVpZnesJibQVi0RznOo8LDV7FXE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201219033138epcas2p2de077a40fbc8a286e4a3d39041d1c375~SAJ7F6_qQ0597005970epcas2p2-;
        Sat, 19 Dec 2020 03:31:38 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CyWVc32hgz4x9Pr; Sat, 19 Dec
        2020 03:31:36 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-74-5fdd741815d4
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.E3.05262.8147DDF5; Sat, 19 Dec 2020 12:31:36 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v15 3/3] scsi: ufs: Prepare HPB read for cached sub-region
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
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p6>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201219033135epcms2p3e7934deb21f46ead49dc7ad55e7bdcc4@epcms2p3>
Date:   Sat, 19 Dec 2020 12:31:35 +0900
X-CMS-MailID: 20201219033135epcms2p3e7934deb21f46ead49dc7ad55e7bdcc4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmua5Eyd14gwXTBCw23n3FavFg3jY2
        i71tJ9gtXv68ymZx+PY7dotpH34yW3xav4zV4uUhTYtVD8ItmhevZ7OYc7aByaK3fyubxaIb
        25gsLu+aw2bRfX0Hm8Xy4/+YLG5v4bJYuvUmo0Xn9DUsFosW7mZxEPG4fMXb43JfL5PHzll3
        2T0mLDrA6LF/7hp2j5aT+1k8Pj69xeLRt2UVo8fnTXIe7Qe6mQK4onJsMlITU1KLFFLzkvNT
        MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CeU1IoS8wpBQoFJBYXK+nb2RTl
        l5akKmTkF5fYKqUWpOQUGBoW6BUn5haX5qXrJefnWhkaGBiZAlUm5GSc/LWKteCRW8Xi2evZ
        Gxi/WHYxcnJICJhILO05ytjFyMUhJLCDUWLbvxnsXYwcHLwCghJ/dwiD1AgLeEns/3aHHcQW
        ElCSWH9xFjtEXE/i1sM1jCA2m4COxPQT99lB5ogItLJI9Lz7AjaUWeArk8Sn57OZILbxSsxo
        f8oCYUtLbF++lRFkGaeAn8T15TwQYQ2JH8t6mSFsUYmbq9+yw9jvj81nhLBFJFrvnYWqEZR4
        8HM3VFxS4tjuD1Cr6iW23vkFdoOEQA+jxOGdt1ghEvoS1zo2gt3AK+ArMeXofrAbWARUJc6u
        TIcocZFY/6SbDcRmFpCX2P52DjNICbOApsT6XfogpoSAssSRWywwTzVs/M2OzmYW4JPoOPwX
        Lr5j3hOoy9Qk1v1czzSBUXkWIqBnIdk1C2HXAkbmVYxiqQXFuempxUYFxshxu4kRnM613Hcw
        znj7Qe8QIxMH4yFGCQ5mJRHe0Ae344V4UxIrq1KL8uOLSnNSiw8xmgI9OZFZSjQ5H5hR8kri
        DU2NzMwMLE0tTM2MLJTEeUNX9sULCaQnlqRmp6YWpBbB9DFxcEo1MOnmOOn2ex/ae4En80Wm
        8OVp3w9EXfLLz1lS0ZslImQjPmObstTaiGMhr3oq5rjaqMSbPV9kE3VrUdIC7humpiXqCxfu
        3yLz/cwX6R0BDySens67/aAxp059xrcF+Wl/be8yr/hxk/G3rvX8ias/vfh0VLKouMRaZypb
        8sV8Dw+7e5az7B/V3F9/12G+d+JBPT21e6pSTmuda5g+hU1i3XZORmGPzPT6k9Oznlm1PT0y
        0TEq50T6KvYMzZzVJ7nOhyi/bnvBwZB4qDf7vnVjuM0j26yyE9u9ngjOLZbiZYjve3Y6hqmn
        OK1nTsTH6m+vtR0+a0f+/Tc3nuXh5obIu2F8HodXnvrTcVf4h4kvjxJLcUaioRZzUXEiAPsA
        G4pwBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d
References: <20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p6>
        <CGME20201219032952epcms2p668a76f6b5ab021f0e66c856c44d5be0d@epcms2p3>
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

