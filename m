Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9E8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 04:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CEA22482
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 04:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbhAKELc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 23:11:32 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:35170 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbhAKELc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 23:11:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610338266; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=P/Qd1Z4a9IOlq1zKN8Qst0cHV/XpFTdCgDvO/qhm5e0=;
 b=ddUPulHCsWb8UCGOoNguiasDZfWS/1IrK058vD1+z9j8IavA7VWeXPEtrLVVZJfCIjmZvT20
 BfSRXQX1s/B5rqQEupYdJywiBWLfpe22KWoylPPHuxAlgCXWERzjMvuOqsIQ0rxTeyTBe4cP
 yASS1mscVW78QmVQlrx11NyQRO4=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5ffbcfb7415a6293c5b8465c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 04:10:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3BB91C43466; Mon, 11 Jan 2021 04:10:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 065F5C43461;
        Mon, 11 Jan 2021 04:10:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 11 Jan 2021 12:10:28 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, huobean@gmail.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v18 3/3] scsi: ufs: Prepare HPB read for cached sub-region
In-Reply-To: <20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49@epcms2p1>
References: <20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p6>
 <CGME20201222015704epcms2p643f0c5011064a7ce56b08331811a8509@epcms2p1>
 <20201222015854epcms2p1bdc30b8fab8ef01502451b75e7fbaf49@epcms2p1>
Message-ID: <e9b2479d0371e3cbe8aeb6c90ffb5d72@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-22 09:58, Daejun Park wrote:
> This patch changes the read I/O to the HPB read I/O.
> 
> If the logical address of the read I/O belongs to active sub-region, 
> the
> HPB driver modifies the read I/O command to HPB read. It modifies the 
> UPIU
> command of UFS instead of modifying the existing SCSI command.
> 
> In the HPB version 1.0, the maximum read I/O size that can be converted 
> to
> HPB read is 4KB.
> 
> The dirty map of the active sub-region prevents an incorrect HPB read 
> that
> has stale physical page number which is updated by previous write I/O.
> 
> Reviewed-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Avri Altman <Avri.Altman@wdc.com>
> Tested-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |   2 +
>  drivers/scsi/ufs/ufshpb.c | 232 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h |   2 +
>  3 files changed, 236 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0ec0ed237140..41554afead63 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2600,6 +2600,8 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	ufshcd_comp_scsi_upiu(hba, lrbp);
> 
> +	ufshpb_prep(hba, lrbp);
> +
>  	err = ufshcd_map_sg(hba, lrbp);
>  	if (err) {
>  		lrbp->cmd = NULL;
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 37ae61fbf36a..d3e6c5b32328 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -31,6 +31,29 @@ bool ufshpb_is_allowed(struct ufs_hba *hba)
>  	return !(hba->ufshpb_dev.hpb_disabled);
>  }
> 
> +static int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
> +			     struct ufshpb_subregion *srgn)
> +{
> +	return rgn->rgn_state != HPB_RGN_INACTIVE &&
> +		srgn->srgn_state == HPB_SRGN_VALID;
> +}
> +
> +static bool ufshpb_is_read_cmd(struct scsi_cmnd *cmd)
> +{
> +	return req_op(cmd->request) == REQ_OP_READ;
> +}
> +
> +static bool ufshpb_is_write_or_discard_cmd(struct scsi_cmnd *cmd)
> +{
> +	return op_is_write(req_op(cmd->request)) ||
> +	       op_is_discard(req_op(cmd->request));
> +}
> +
> +static bool ufshpb_is_support_chunk(int transfer_len)
> +{
> +	return transfer_len <= HPB_MULTI_CHUNK_HIGH;
> +}
> +
>  static bool ufshpb_is_general_lun(int lun)
>  {
>  	return lun < UFS_UPIU_MAX_UNIT_NUM_ID;
> @@ -98,6 +121,215 @@ static void ufshpb_set_state(struct ufshpb_lu
> *hpb, int state)
>  	atomic_set(&hpb->hpb_state, state);
>  }
> 
> +static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> +			     int srgn_idx, int srgn_offset, int cnt)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	int set_bit_len;
> +	int bitmap_len = hpb->entries_per_srgn;
> +
> +next_srgn:
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	if ((srgn_offset + cnt) > bitmap_len)
> +		set_bit_len = bitmap_len - srgn_offset;
> +	else
> +		set_bit_len = cnt;
> +
> +	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
> +	    srgn->srgn_state == HPB_SRGN_VALID)
> +		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
> +
> +	srgn_offset = 0;
> +	if (++srgn_idx == hpb->srgns_per_rgn) {
> +		srgn_idx = 0;
> +		rgn_idx++;
> +	}
> +
> +	cnt -= set_bit_len;
> +	if (cnt > 0)
> +		goto next_srgn;
> +
> +	WARN_ON(cnt < 0);
> +}
> +
> +static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
> +				   int srgn_idx, int srgn_offset, int cnt)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	int bitmap_len = hpb->entries_per_srgn;
> +	int bit_len;
> +
> +next_srgn:
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	if (!ufshpb_is_valid_srgn(rgn, srgn))
> +		return true;
> +
> +	/*
> +	 * If the region state is active, mctx must be allocated.
> +	 * In this case, check whether the region is evicted or
> +	 * mctx allcation fail.
> +	 */
> +	WARN_ON(!srgn->mctx);
> +
> +	if ((srgn_offset + cnt) > bitmap_len)
> +		bit_len = bitmap_len - srgn_offset;
> +	else
> +		bit_len = cnt;
> +
> +	if (find_next_bit(srgn->mctx->ppn_dirty,
> +			  bit_len, srgn_offset) >= srgn_offset)
> +		return true;
> +
> +	srgn_offset = 0;
> +	if (++srgn_idx == hpb->srgns_per_rgn) {
> +		srgn_idx = 0;
> +		rgn_idx++;
> +	}
> +
> +	cnt -= bit_len;
> +	if (cnt > 0)
> +		goto next_srgn;
> +
> +	return false;
> +}
> +
> +static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
> +			  struct ufshpb_map_ctx *mctx, int pos, int *error)
> +{
> +	u64 *ppn_table;
> +	struct page *page;
> +	int index, offset;
> +
> +	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
> +	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
> +
> +	page = mctx->m_page[index];
> +	if (unlikely(!page)) {
> +		*error = -ENOMEM;
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot find page in mctx\n");
> +		return 0;
> +	}
> +
> +	ppn_table = page_address(page);
> +	if (unlikely(!ppn_table)) {
> +		*error = -ENOMEM;
> +		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> +			"error. cannot get ppn_table\n");
> +		return 0;
> +	}
> +
> +	return ppn_table[offset];
> +}
> +
> +static void
> +ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int 
> *rgn_idx,
> +			int *srgn_idx, int *offset)
> +{
> +	int rgn_offset;
> +
> +	*rgn_idx = lpn >> hpb->entries_per_rgn_shift;
> +	rgn_offset = lpn & hpb->entries_per_rgn_mask;
> +	*srgn_idx = rgn_offset >> hpb->entries_per_srgn_shift;
> +	*offset = rgn_offset & hpb->entries_per_srgn_mask;
> +}
> +
> +static void
> +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb 
> *lrbp,
> +				  u32 lpn, u64 ppn,  unsigned int transfer_len)
> +{
> +	unsigned char *cdb = lrbp->ucd_req_ptr->sc.cdb;
> +
> +	cdb[0] = UFSHPB_READ;

You are only replacing opcode in cdb[0], but ufshcd_add_command_trace() 
is
counting on lrbp->cmd->cmnd. This will lead to wrong opcode recorded by 
UFS ftrace.

Can Guo.

> +
> +	put_unaligned_be64(ppn, &cdb[6]);
> +	cdb[14] = transfer_len;
> +}
> +
> +/*
> + * This function will set up HPB read command using host-side L2P map 
> data.
> + * In HPB v1.0, maximum size of HPB read command is 4KB.
> + */
> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> +	struct ufshpb_lu *hpb;
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +	struct scsi_cmnd *cmd = lrbp->cmd;
> +	u32 lpn;
> +	u64 ppn;
> +	unsigned long flags;
> +	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
> +	int err = 0;
> +
> +	hpb = ufshpb_get_hpb_data(cmd->device);
> +	if (!hpb)
> +		return;
> +
> +	if (ufshpb_get_state(hpb) != HPB_PRESENT) {
> +		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> +			   "%s: ufshpb state is not PRESENT", __func__);
> +		return;
> +	}
> +
> +	if (!ufshpb_is_write_or_discard_cmd(cmd) &&
> +	    !ufshpb_is_read_cmd(cmd))
> +		return;
> +
> +	transfer_len = sectors_to_logical(cmd->device, 
> blk_rq_sectors(cmd->request));
> +	if (unlikely(!transfer_len))
> +		return;
> +
> +	lpn = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
> +	ufshpb_get_pos_from_lpn(hpb, lpn, &rgn_idx, &srgn_idx, &srgn_offset);
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	/* If command type is WRITE or DISCARD, set bitmap as drity */
> +	if (ufshpb_is_write_or_discard_cmd(cmd)) {
> +		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> +				 transfer_len);
> +		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +		return;
> +	}
> +
> +	if (!ufshpb_is_support_chunk(transfer_len))
> +		return;
> +
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
> +				   transfer_len)) {
> +		hpb->stats.miss_cnt++;
> +		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +		return;
> +	}
> +
> +	ppn = ufshpb_get_ppn(hpb, srgn->mctx, srgn_offset, &err);
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +	if (unlikely(err)) {
> +		/*
> +		 * In this case, the region state is active,
> +		 * but the ppn table is not allocated.
> +		 * Make sure that ppn table must be allocated on
> +		 * active state.
> +		 */
> +		WARN_ON(true);
> +		dev_err(hba->dev, "ufshpb_get_ppn failed. err %d\n", err);
> +		return;
> +	}
> +
> +	ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
> +
> +	hpb->stats.hit_cnt++;
> +}
> +
>  static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
>  					     struct ufshpb_subregion *srgn)
>  {
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index e40b016971ac..2c43a03b66b6 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -198,6 +198,7 @@ struct ufs_hba;
>  struct ufshcd_lrb;
> 
>  #ifndef CONFIG_SCSI_UFS_HPB
> +static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) 
> {}
>  static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb 
> *lrbp) {}
>  static void ufshpb_resume(struct ufs_hba *hba) {}
>  static void ufshpb_suspend(struct ufs_hba *hba) {}
> @@ -211,6 +212,7 @@ static bool ufshpb_is_allowed(struct ufs_hba *hba)
> { return false; }
>  static void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf) {}
>  static void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf) {}
>  #else
> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
>  void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
>  void ufshpb_resume(struct ufs_hba *hba);
>  void ufshpb_suspend(struct ufs_hba *hba);
